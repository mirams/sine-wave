function std_scale = CalculatingScalingFactorAndNoise(protocol,model,P)
% In this script we compare the simulated data trace to the experimental data to identify
% appropriate level of noise to add to the simulated data trace for cell 5 used in Figure C5.

[sim,model_type] = modeldata(model);
% Import protocol
cd ../Protocols

V = importdata([protocol,'_protocol.mat']);

cd ..
% Import experimental data
cd ExperimentalData
cd 16713110

D=importdata([protocol,'_16713110_dofetilide_subtracted_leak_subtracted.mat']);

cd ..
cd ..
cd Code
I = SimulatingData(model_type,protocol,P,V,21.4);

% Normalises the current trace to the experimental trace by calculating a scaling factor which
% minimises the square difference between the traces

c=0;

for a = 0.000001:0.001:5
    c=c+1;
    
    Diff(1,c) = sum((D-a.*I).^2);
    
end

% Identifies scaling factor


[i,v]=min((Diff(1,:)));

s = v*0.001+0.000001;

J = s.*I;

% Experimental std calculated from first 200 ms of protocol where voltage is held at -80 mV and current
% is expected to be zero.
std_exp = std(D(1:2000,:))

s
% Simulated data trace std identified by scaling experimental std by scaling factor identified to minimize
% square difference between the two traces above.
std_scale = std_exp/s