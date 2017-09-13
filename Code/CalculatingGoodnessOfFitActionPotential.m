function CalculatingGoodnessOfFitActionPotential(exp_ref)
model = 'hh';
fitting_protocol={'sine_wave'};

% Compares predictions of current response to activation potential protocol for experiment exp_ref
% for simulated cell-specific and average models and leading literature models.
% Average model and literature models have their conductance scaled so that they minimise the
% square difference between the simulated model trace and the current in response to the action
% potential waveform for exp_ref.

% Import literature model parameters
cd ../ParameterSets

W=importdata('WangModelSimulatedParameters.mat');
DV=importdata('DiVeroliRTModelSimulatedParameters.mat');
M=importdata('MazhariModelSimulatedParameters.mat');
TT=importdata('TenTusscherModelSimulatedParameters.mat');
Z=importdata('ZengTolModelSimulatedParameters.mat');

cd ..

% Identify temperature for experiment
if strcmp(exp_ref,'16708016')==1
    
    temperature = 21.8;
    
end
if strcmp(exp_ref,'16708060')==1
    
    temperature = 21.7;
    
end

if strcmp(exp_ref,'16704047')==1
    temperature = 21.6;
    
end
if strcmp(exp_ref,'16704007')==1
    
    temperature = 21.2;
    
end

if strcmp(exp_ref,'16713003')==1
    
    temperature = 21.3;
    
end

if strcmp(exp_ref,'16713110')==1||strcmp(exp_ref,'16715049')==1
    
    temperature = 21.4;
    
end
if strcmp(exp_ref,'16707014')==1
    
    temperature = 21.4;
    
end
if strcmp(exp_ref,'16708118')==1
    
    temperature = 21.7;
    
end
cd Code
% Identifies maximum likelihood parameters for cell-specific and average model for fit to sine wave
[chain_av,likelihood_av] = FindingBestFitsAfterMCMC(model,fitting_protocol,'average');

[i,v]= max(likelihood_av);

AP= chain_av(v,:);

[chain,likelihood] = FindingBestFitsAfterMCMC(model,fitting_protocol,exp_ref);

[i,v]= max(likelihood);

MP= chain(v,:);


% Import sine wave and action potential protocols

cd ../Protocols
V=importdata(['ap_protocol.mat']);
V_sine = importdata(['sine_wave_protocol.mat']);
cd ..
cd Code
[simulated_parameters,model_type] =modeldata(model);
cd ..
% Import experimental data traces
cd ExperimentalData
cd(exp_ref)

E=importdata(['ap_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
cd ..
cd ..
cd Code
I = SimulatingData(model_type,{'ap'},MP,V,temperature);
%Scale average model to minimise square difference between average model simulation of sine wave and experimental data
I_av = SimulatingData(model_type,{'ap'},AP,V,temperature);
I_av_sine = SimulatingData(model_type,{'sine_wave'},AP,V_sine,temperature);
cd ../ExperimentalData
cd(exp_ref)

cell_specific_sine_wave=importdata(['sine_wave_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
cd ..
cd ..
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((cell_specific_sine_wave-a.*I_av_sine).^2)./length(I_av_sine);
    
end


[i,v]=min((Diff(1,:)));

s_av = v*0.01+0.000001;

J_av = s_av.*I_av;
I_av=J_av;
cd Code
%Scale literature models to minimise square difference between simulations of action potential protocol and experiment
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
% DiVeroli model
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
% Mazhari model
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
%TenTusscher model
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

% Zeng model
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

% Calculate differences between cell-specific, literature and average model and experiment
cell_specific_diff = sum((sqrt((E-I).^2)))/length(I)

average_diff = sum((sqrt((E-I_av).^2)))/length(I_av)

wang_diff =sum((sqrt((E-IW).^2)))/length(IW)
diveroli_diff  =sum((sqrt((E-ID).^2)))/length(ID)
mazhari_diff =sum((sqrt((E-IM).^2)))/length(IM)
tentusscher_diff =sum((sqrt((E-IT).^2)))/length(IT)
zeng_diff =sum((sqrt((E-IZ).^2)))/length(IZ)
cell_specific_part_diff=sum((sqrt((E(5702:73245)-I(5702:73245)).^2)))/length(I(5702:73245))
