function A=CreatingAveragedModel()
% Creates average model data but scaling each experimental trace to a reference trace then finding mean value at each time point
cd ../ExperimentalData
cd sine_wave

% Reads in all sine wave traces
pathToFolder = '.';
files = dir(fullfile(pathToFolder,'*.mat'));

for i = 1:numel(files)
    
    
    D=importdata(files(i).name);
    
    
    DD(:,i)=D;
    % Scaling factor is calculated with removal of capacative spikes to minimise difference between each trace and the reference trace (last trace in the file)
    I(:,i)= [D(1:2499);D(2549:2999);D(3049:4999);D(5049:14999);D(15049:19999);D(20049:29999);D(30049:64999);D(65049:69999);D(700049:end)];
end
N=size(I,2);
c=0;

for a = 0.000001:0.01:15
    c=c+1;
    for j= 1:N
        if j~=9
            Diff(j,c) = sum((I(:,9)-a.*I(:,j)).^2)./length(I);
        end
    end
end

% Identifies scaling factor for each trace - final trace is used as reference trace
for j = 1:N
    if j~=9
        [i(j),v(j)]=min((Diff(j,:)));
        
        s(j) = v(j)*0.01+0.000001;
        
        J(:,j) = s(j).*DD(:,j);
    end
    J(:,9) = DD(:,9);
    
end
%Visualise all scaled traces and reference trace
%figure(1)
%plot(J)

A=sum(J,2)./size(J,2);

%figure(2)
%plot(A)

cd ..
cd ..

% Commented out to avoid overwritting trace used in manuscript (although script generates same trace)
%cd ExperimentalData/average
%save sine_wave_average_dofetilide_subtracted_leak_subtracted.mat A -ascii
%cd ..
%cd ..

cd Code