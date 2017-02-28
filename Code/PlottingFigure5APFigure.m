function PlottingFigure5APFigure()
% This script produces the data used to plot Figure 5
%Simulates response to action potential waveform protocol for literature models and new model (with best fitting parameters to sine wave for cell 5)
% and compares with experimental recording from cell 5

model = 'hh';
fitting_protocol={'sine_wave'};
exp_ref = '16713110';

cd ../ParameterSets
% Imports literature model parameters
W=importdata('WangModelSimulatedParameters.mat');
DV=importdata('DiVeroliRTModelSimulatedParameters.mat');
M=importdata('MazhariModelSimulatedParameters.mat');
TT=importdata('TenTusscherModelSimulatedParameters.mat');
Z=importdata('ZengTolModelSimulatedParameters.mat');

cd ..

% Identifies temperature for appropriate experiment

if strcmp(exp_ref,'16713110')==1
    
    temperature = 21.4;
    
end
cd Code
% Identifies best fitting parameters to sine wave
[chain,likelihood] = FindingBestFitsAfterMCMC(model,fitting_protocol,exp_ref);

[i,v]= max(likelihood);

MP= chain(v,:);

%Import action potential protocol
cd ../Protocols
V=importdata(['ap_protocol.mat']);
cd ..
cd Code
% Identify appropriate model for simulation
[simulated_parameters,model_type] =modeldata(model);
% Import experimental data
cd ../ExperimentalData
cd(exp_ref)
E=importdata(['ap_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
cd ..
cd ..
cd Code
% Simulate model with parameters identified as providing bet fit to sine wave
I = SimulatingData(model_type,{'ap'},MP,V,temperature);
% For each literature model simulation we scale the model conductance to minimise the square difference between each model simulation and the experimental
% recording in response to the action potential voltage protocol for cell 5.
% Wang model
IW = SimulatingData(27,{'ap'},W,V,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((E-a.*IW).^2)./length(IW);
    
end


[i,v]=min((Diff(1,:)));

sw = v*0.01+0.000001;

JW = sw.*IW;
IW=JW;
%DiVeroli model
ID = SimulatingData(5,{'ap'},DV,V,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((E-a.*ID).^2)./length(ID);
    
end


[i,v]=min((Diff(1,:)));

sd = v*0.01+0.000001;

JD = sd.*ID;
ID=JD;
%Mazhari model
IM = SimulatingData(16,{'ap'},M,V,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((E-a.*IM).^2)./length(IM);
    
end


[i,v]=min((Diff(1,:)));

sm = v*0.01+0.000001;

JM = sm.*IM;
IM=JM;
%TenTusscher Model
IT = SimulatingData(26,{'ap'},TT,V,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((E-a.*IT).^2)./length(IT);
    
end


[i,v]=min((Diff(1,:)));

st = v*0.01+0.000001;

JT = st.*IT;
IT=JT;
%Zeng model (note we have to use version with singularities removed to simulate action potential waveform protocol)
IZ = SimulatingData(2999,{'ap'},Z,V,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((E-a.*IZ).^2)./length(IZ);
    
end


[i,v]=min((Diff(1,:)));

sz = v*0.01+0.000001;

JZ = sz.*IZ;
IZ=JZ;

% Prepare and save data
cd ../Figures/figure_5
wang_data=[[0:0.0001:(length(V)/10000)-0.0001]',IW];
diveroli_data=[[0:0.0001:(length(V)/10000)-0.0001]',ID];
mazhari_data=[[0:0.0001:(length(V)/10000)-0.0001]',IM];
tentusscher_data=[[0:0.0001:(length(V)/10000)-0.0001]',IT];
zeng_data=[[0:0.0001:(length(V)/10000)-0.0001]',IZ];
new_model_data=[[0:0.0001:(length(V)/10000)-0.0001]',I];
experimental_data=[[0:0.0001:(length(V)/10000)-0.0001]',E];
protocol_data=[[0:0.0001:(length(V)/10000)-0.0001]',V];
save figure_5_ap_wang_prediction.txt wang_data -ascii
save figure_5_ap_diveroli_prediction.txt diveroli_data -ascii
save figure_5_ap_mazhari_prediction.txt mazhari_data -ascii
save figure_5_ap_tentusscher_prediction.txt tentusscher_data -ascii
save figure_5_ap_zeng_prediction.txt zeng_data -ascii
save figure_5_ap_new_model_prediction.txt new_model_data -ascii
save figure_5_ap_experimental_data.txt experimental_data -ascii
save figure_5_ap_protocol_data.txt protocol_data -ascii
cd ..
cd ..
cd Code