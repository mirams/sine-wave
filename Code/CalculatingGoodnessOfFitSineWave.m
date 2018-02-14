function CalculatingGoodnessOfFitSineWave(exp_ref)
% Calculates fit of experiment exp_ref and leading literature models to sine wave protocol.
% Literature models have their conductance scaled so that they minimise the squared difference
% between the simulated model trace and the current in response to the action potential
% waveform for exp_ref.

cd ../ParameterSets
% Import literature model parameters
W=importdata('WangModelSimulatedParameters.mat');
DV=importdata('DiVeroliRTModelSimulatedParameters.mat');
M=importdata('MazhariModelSimulatedParameters.mat');
TT=importdata('TenTusscherModelSimulatedParameters.mat');
Z=importdata('ZengModelSimulatedParameters.mat');
Z_tol=importdata('ZengTolModelSimulatedParameters.mat');
cd ..
% Identify temperature corresponding to each experiment
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

% Import sine wave and action potential protocols
cd Protocols

V=importdata('sine_wave_protocol.mat');
V_AP=importdata('ap_protocol.mat');
cd ..

% Import sine wave and action potential waveform experimental data for experiment
cd ExperimentalData
cd(exp_ref)

D=importdata(['sine_wave_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
AP=importdata(['ap_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
cd ..
cd average

% Import average model data (used for comparison in generating results for Table F4)
D_av = importdata(['sine_wave_average_dofetilide_subtracted_leak_subtracted.mat']);

cd ..
cd ..

cd Code

% Identifies maximum likelihood parameters for cell-specific and average model for fit to sine wave

[chain,likelihood] = FindingBestFitsAfterMCMC('hh',{'sine_wave'},exp_ref);

[i,v]= max(likelihood);

k= chain(v,:);


[chain_av,likelihood_av] = FindingBestFitsAfterMCMC('hh',{'sine_wave'},'average');

[i,v]= max(likelihood_av);

k_av= chain_av(v,:);

I=SimulatingData(35,{'sine_wave'},k,V,temperature);
I_av=SimulatingData(35,{'sine_wave'},k_av,V,temperature);

% Capacitive spikes removed from sine wave experimental and simulation traces
J = [I(1:2499);I(2549:2999);I(3049:4999);I(5049:14999);I(15049:19999);I(20049:29999);I(30049:64999);I(65049:69999);I(70049:end)];
F = [D(1:2499);D(2549:2999);D(3049:4999);D(5049:14999);D(15049:19999);D(20049:29999);D(30049:64999);D(65049:69999);D(70049:end)];

% Scale average model to minimise square difference between simulation and experiment exp_ref sine wave recording
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((D-a.*I_av).^2)./length(I_av);
    
end


[i,v]=min((Diff(1,:)));

s_av = v*0.01+0.000001;

J_av = s_av.*I_av;
I_av=J_av;
% Capacitive spikes removed from average sine wave scaled simulated trace
K_av = [I_av(1:2499);I_av(2549:2999);I_av(3049:4999);I_av(5049:14999);I_av(15049:19999);I_av(20049:29999);I_av(30049:64999);I_av(65049:69999);I_av(70049:end)];

% Scale literature models to minimise square difference between simulation and experiment exp_ref action potential recording
%Wang model
IW = SimulatingData(27,{'sine_wave'},W,V,temperature);
IW_AP=SimulatingData(27,{'ap'},W,V_AP,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((AP-a.*IW_AP).^2)./length(IW_AP);
    
end


[i,v]=min((Diff(1,:)));

sw = v*0.01+0.000001;

JW = sw.*IW;
IW=JW;
% DiVeroli model
ID = SimulatingData(5,{'sine_wave'},DV,V,temperature);
ID_AP = SimulatingData(5,{'ap'},DV,V_AP,temperature);

c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((AP-a.*ID_AP).^2)./length(ID_AP);
    
end


[i,v]=min((Diff(1,:)));

sd = v*0.01+0.000001;

JD = sd.*ID;
ID=JD;
%Mazhari model
IM = SimulatingData(16,{'sine_wave'},M,V,temperature);
IM_AP = SimulatingData(16,{'ap'},M,V_AP,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((AP-a.*IM_AP).^2)./length(IM_AP);
    
end


[i,v]=min((Diff(1,:)));

sm = v*0.01+0.000001;

JM = sm.*IM;
IM=JM;
%TenTusscher model
IT = SimulatingData(26,{'sine_wave'},TT,V,temperature);
IT_AP = SimulatingData(26,{'ap'},TT,V_AP,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((D-a.*IT).^2)./length(IT);
    
end


[i,v]=min((Diff(1,:)));

st = v*0.01+0.000001;

JT = st.*IT;
IT=JT;

%Zeng model
IZ = SimulatingData(29,{'sine_wave'},Z,V,temperature);
IZ_AP = SimulatingData(2999,{'ap'},Z_tol,V_AP,temperature);

c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((D-a.*IZ).^2)./length(IZ);
    
end


[i,v]=min((Diff(1,:)));

sz = v*0.01+0.000001;

JZ = sz.*IZ;
IZ=JZ;
% Capacitive spikes removed from literature models scaled simulated traces
JJZ = [IZ(1:2499);IZ(2549:2999);IZ(3049:4999);IZ(5049:14999);IZ(15049:19999);IZ(20049:29999);IZ(30049:64999);IZ(65049:69999);IZ(70049:end)];
JJT = [IT(1:2499);IT(2549:2999);IT(3049:4999);IT(5049:14999);IT(15049:19999);IT(20049:29999);IT(30049:64999);IT(65049:69999);IT(70049:end)];
JJW = [IW(1:2499);IW(2549:2999);IW(3049:4999);IW(5049:14999);IW(15049:19999);IW(20049:29999);IW(30049:64999);IW(65049:69999);IW(70049:end)];
JJM = [IM(1:2499);IM(2549:2999);IM(3049:4999);IM(5049:14999);IM(15049:19999);IM(20049:29999);IM(30049:64999);IM(65049:69999);IM(70049:end)];
JJD = [ID(1:2499);ID(2549:2999);ID(3049:4999);ID(5049:14999);ID(15049:19999);ID(20049:29999);ID(30049:64999);ID(65049:69999);ID(70049:end)];

% Square differences between scaled simulated and experimental traces calculated for cell-specific and average
% model fits as well as literature model predictions.
cell_specific_diff = sum((sqrt((F-J).^2)))/length(J)
average_diff  =  sum((sqrt((F-K_av).^2)))/length(K_av)
wang_diff = sum((sqrt((F-JJW).^2)))/length(JJW)
diveroli_diff = sum((sqrt((F-JJD).^2)))/length(JJD)
mazhari_diff = sum((sqrt((F-JJM).^2)))/length(JJM)
tentusscher_diff = sum((sqrt((F-JJT).^2)))/length(JJT)
zeng_diff = sum((sqrt((F-JJZ).^2)))/length(JJZ)