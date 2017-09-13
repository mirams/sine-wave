function CalculatingGoodnessOfFitDeactivation(exp_ref)

% Compares predictions of current response to deactivation protocol for experiment exp_ref
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
Z=importdata('ZengModelSimulatedParameters.mat');
Z_tol=importdata('ZengTolModelSimulatedParameters.mat');
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

% Imports deactivation, sine wave and action potential protocols
cd Protocols

V=importdata('deactivation_protocol.mat');
V_AP=importdata('ap_protocol.mat');
V_sine = importdata(['sine_wave_protocol.mat']);
cd ..

cd ExperimentalData
cd(exp_ref)

D=importdata(['deactivation_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
D_AP=importdata(['ap_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
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

% Simulate sine wave protocol for average model and scale averae model conductance to minimise square difference
% between average model and cell-specific experimental recording of sine wave.
I=SimulatingData(35,{'deactivation'},k,V,temperature);
I_av=SimulatingData(35,{'deactivation'},k_av,V,temperature);
I_av_sine = SimulatingData(35,{'sine_wave'},k_av,V_sine,temperature);
J=I;
F=D;
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

K_av = I_av;
cd Code
% Scale literature models conductance to minimise square difference between simulation of action potential
% and experimental recording for exp_ref of action potential.
% Wang model
IW = SimulatingData(27,{'deactivation'},W,V,temperature);
IW_AP = SimulatingData(27,{'ap'},W,V_AP,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((D_AP-a.*IW_AP).^2)./length(IW_AP);
    
end


[i,v]=min((Diff(1,:)));

sw = v*0.01+0.000001;

JW = sw.*IW;
IW=JW;

%DiVeroli Model
ID = SimulatingData(5,{'deactivation'},DV,V,temperature);
ID_AP = SimulatingData(5,{'ap'},DV,V_AP,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((D_AP-a.*ID_AP).^2)./length(ID_AP);
    
end


[i,v]=min((Diff(1,:)));

sd = v*0.01+0.000001;

JD = sd.*ID;
ID=JD;

%Mazhari model
IM = SimulatingData(16,{'deactivation'},M,V,temperature);
IM_AP = SimulatingData(16,{'ap'},M,V_AP,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((D_AP-a.*IM_AP).^2)./length(IM_AP);
    
end


[i,v]=min((Diff(1,:)));

sm = v*0.01+0.000001;

JM = sm.*IM;
IM=JM;

% TenTusscher model
IT = SimulatingData(26,{'deactivation'},TT,V,temperature);
IT_AP = SimulatingData(26,{'ap'},TT,V_AP,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((D_AP-a.*IT_AP).^2)./length(IT_AP);
    
end


[i,v]=min((Diff(1,:)));

st = v*0.01+0.000001;

JT = st.*IT;
IT=JT;

%Zeng model
IZ = SimulatingData(29,{'deactivation'},Z,V,temperature);
IZ_AP = SimulatingData(2999,{'ap'},Z_tol,V_AP,temperature);
c=0;
for a = 0.000001:0.01:5
    c=c+1;
    
    Diff(1,c) = sum((D_AP-a.*IZ_AP).^2)./length(IZ_AP);
    
end


[i,v]=min((Diff(1,:)));

sz = v*0.01+0.000001;

JZ = sz.*IZ;
IZ=JZ;

JJZ =IZ;
JJT = IT;
JJW = IW;
JJM = IM;
JJD = ID;

% Calculate differences between literature, cell specific and average models and deactivation experiment
cell_specific_diff = sum((sqrt((F-J).^2)))/length(J)
average_diff  =  sum((sqrt((F-K_av).^2)))/length(K_av)

wang_diff = sum((sqrt((F-JJW).^2)))/length(JJW)
diveroli_diff = sum((sqrt((F-JJD).^2)))/length(JJD)
mazhari_diff = sum((sqrt((F-JJM).^2)))/length(JJM)
tentusscher_diff = sum((sqrt((F-JJT).^2)))/length(JJT)
zeng_diff = sum((sqrt((F-JJZ).^2)))/length(JJZ)

