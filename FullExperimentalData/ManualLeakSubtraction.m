function[I_final,R] = ManualLeakSubtraction(data,protocol)
%In this function we estimate the leak resistance required to leak subtract
%the experimental data traces for each cell. 
%We do this manually by trial and error, checking that the leak subtraction
%to reduce the difference between the currents recorded during the leak
%step does not leak to over subtraction so that the first depolarisation
%step becomes negative - we selected the most appropriate resistance values
%so that these two factors were balanced.
%We identified the appropriate resistance value to use for each cell from
%the sine wave repeat during the vehicle and applied this same value to the
%other protocol recordings in vehicle for the same cell. We then calculated
%a resistance value for from the sine wave recorded after dofetilide
%application and applied this resistance value to all of the protocols
%recorded in the presence of dofetilide on the same cell.

%We use the voltage information directly from the experimental data files, 
%which has been corrected for liquid junction potential so here we
%subtract the liquid junction potential of 4.1 mV to use the actual voltage
%level.

% We repeat leak subtraction for both vehicle and dofetilide recorded
% traces and then subtract the two leak subtracted recordings to obtain a
% leak subtracted dofetilide subtracted trace for each protocol for each
% cell.
if strcmp(protocol,'sine_wave')==1||strcmp(protocol,'ap')==1
V=data(:,3)-4.1*ones(length(data(:,3)),1);
I=data(:,2);
end
data_temp=[];
v_temp=[];
t_temp=[];
% For the voltage step protocols we have to extract the data from each
% column
if strcmp(protocol,'steady_activation')==1||strcmp(protocol,'deactivation')==1||strcmp(protocol,'inactivation')==1||strcmp(protocol,'activation_kinetics_1')==1||strcmp(protocol,'activation_kinetics_2')==1
for j =1:(size(data,2)-1)/2

data_temp = [data_temp;data(:,2*j)];
v_temp = [v_temp;data(:,2*j+1)];

end
I=data_temp;
V=v_temp - 4.1*ones(length(v_temp),1);
end

% We implemented an automated method of performing leak subtraction to minimise
% change in current during leak step by testing a range of resistance
% values. This method gave us an idea of the expected range of leak
% resistance values, however we found that this often lead to over
% correction of the traces and sometimes negative currents during the
% activation steps so we later identified these resistance values manually.
a=1;
for R =-5000:1:5000
    % Equation for corrected current
    Ic = I -(V./(R*0.001));
    % For each resistance value for each protocol we calculated the
    % absolute difference between a period just before and just after the
    % leak step to minimise (we exclude the regions around the voltage-step
    % for this to eliminate the effect of capacative currents).
    if strcmp(protocol,'sine_wave')==1||strcmp(protocol,'ap')==1
    P(a) = abs(mean(Ic(400:2400)) -mean(Ic(2600:2900)));
    end
    
     if strcmp(protocol,'activation_kinetics_1')==1||strcmp(protocol,'activation_kinetics_2')
    P(a) = abs(mean(Ic(400:3200)) -mean(Ic(3400:3800)));
     end
    
  if strcmp(protocol,'inactivation')==1
    P(a) = abs((mean(Ic(400:2900)) -mean(Ic(3000:3400))));
    end
       if strcmp(protocol,'deactivation')==1
    P(a) = abs(mean(Ic(400:4100)) -mean(Ic(4200:4600)));
       end
           if strcmp(protocol,'steady_activation')==1
    P(a) = (abs(mean(Ic(400:3780))-(mean(Ic(3880:4280)))));
    end    
     
  a=a+1;
    
end

   figure(1)
  
    plot(P,'*')
   

[i,v]=min(P);

% Manually identifed resistance values for each cell for vehicle and
% dofetilide repeats on each cell.

% We later use these values to calculate percentage change in leak
% resistance between vehicle and dofetilide repeats which we use as a
% pseudo metric for data quality in Table F4 in supplementary material.
% We use the vehicle leak resistance for all the protocols recorded during
% vehicle conditions on each cell and then the dofetilide leak resistance for
% all the protocols recorded during dofetilide conditions on each cell.

% To calculate the change in leak resistance as detailed in column 2 of
% Table F4 we use
% 100*((max of R in control and dofetilide - min of R in control and dofetilide)/(max of R in control and dofetilide))

%R=3000; %16707014 control
%R=1250; %16707014 dofetilide

%R=420; %16708016 control
%R= 480; %16708016 dofetilide

%R=420;  %16708060 control
%R = 350; %16708060 dofetilide

%R=1400; %16708118 control
%R=1000;  %16708118 dofetilide

%R=7500; %16713003 control and dofetilide

%R=5600; % 16713110 control 
%R = 7000; % 16713110 dofetilide

%R=6000; % 16715049 control
%R=6500; % 16715049 dofetilide

%R=385; % 16704007 control
%R=260; % 16704007 dofetilide

%R=1225; % 16704047 control
%R=700; % 16704047 dofetilide

% Correct current using leak resistance
I_final = I -(V./(R*0.001));

% Now adjusting baseline

adjust = mean(I_final(1:1000));

% Fully leak subtracted trace
I_final= I_final -adjust.*(ones(length(I_final),1));
