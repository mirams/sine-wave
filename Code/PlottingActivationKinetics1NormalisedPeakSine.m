function PlottingActivationKinetics1PlotNormalisedPeakSine()
% This script generates data for subpanel A in Figure E6
exp_ref = '16713110';
%Identify temperature for experiment

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

% Import protocols
cd ../Protocols

V=importdata('sine_wave_protocol.mat');
V_AP=importdata('ap_protocol.mat');
cd ..

% Import parameter sets for literature models
cd ParameterSets
W=importdata('WangModelSimulatedParameters.mat');
DV=importdata('DiVeroliRTModelSimulatedParameters.mat');
M=importdata('MazhariModelSimulatedParameters.mat');
TT=importdata('TenTusscherModelSimulatedParameters.mat');
Z=importdata('ZengModelSimulatedParameters.mat');
Z_tol=importdata('ZengTolModelSimulatedParameters.mat');
cd ..

% Import experimental data for sine wave and action potential protocols
cd ExperimentalData
cd(exp_ref)

D=importdata(['sine_wave_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
D_AP=importdata(['ap_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
cd ..
cd ..
cd Code
% Identify parameter set with maximum likelihood fit to sine wave
[chain,likelihood] = FindingBestFitsAfterMCMC('hh',{'sine_wave'},exp_ref);

[i,v]= max(likelihood);

k= chain(v,:);


I=SimulatingData(35,{'sine_wave'},k,V,temperature);
% Calculate conductance scaling factor for literature models to minimise square difference between
% literature model simulation and action potential experiment for exp_ref

% Wang model
IW = SimulatingData(27,{'sine_wave'},W,V,temperature);
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

% DiVeroli model
ID = SimulatingData(5,{'sine_wave'},DV,V,temperature);
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

% Mazhari model
IM = SimulatingData(16,{'sine_wave'},M,V,temperature);
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
IT = SimulatingData(26,{'sine_wave'},TT,V,temperature);
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

% Zeng model (note that we use the version of the Zeng model with the singularities removed for simulating the action potential protocol)
IZ = SimulatingData(29,{'sine_wave'},Z,V,temperature);
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

% Calculate normalisation factor by identifying the maximum negative peak current during the
% voltage step to -120 mV around 1.5 seconds in the sine wave protocol. This current corresponds
% roughly to the current measured when the channel is maximally open during the sine wave protocol.
norm_I=max(abs(I(15002:15200)));
norm_IW=max(abs(IW(15002:15200)));
norm_IM=max(abs(IM(15002:15200)));
norm_ID=max(abs(ID(15002:15200)));
norm_IT=max(abs(IT(15002:15200)));
norm_IZ=max(abs(IZ(15002:15200)));
norm_exp=max(abs(D(15040:15200)));

% Peaks from experiments and simulations for activation kinetics protocol 1 identified manually
exp = [0
    0.0042411
    0.008519
    0.0177
    0.0619
    0.2267
    ]';

model = [0.0051949
    0.0089096
    0.0092176
    0.0169
    0.049
    0.1492
    ]';

wang = [0.00063753
    0.0037895
    0.0318
    0.1027
    0.1679
    0.2705
    ]';

diveroli = [0.0038698
    0.0099015
    0.0218
    0.0615
    0.1678
    0.4616
    ]';


mazhari = [0.00060942
    0.0032698
    0.027
    0.1008
    0.1899
    0.388
    ]';

tentusscher = [0.0319
    0.0239
    0.0422
    0.1176
    0.2251
    0.2783
    ]';


zeng = [0.0252
    0.0831
    0.204
    0.3648
    0.4019
    0.4022
    ]';

% Plot and save normalised traces
T= [3,10,30,100,300,1000];

figure(1)

plot(T,exp./abs(norm_exp),'color','r','Marker','o','LineWidth',2)
hold on
plot(T,model./abs(norm_I),'color','b','Marker','o','LineWidth',2)
plot(T,wang./abs(norm_IW),'color','k','Marker','o','LineWidth',2)
plot(T,diveroli./abs(norm_ID),'color','c','Marker','o','LineWidth',2)
plot(T,mazhari./abs(norm_IM),'color','g','Marker','o','LineWidth',2)
plot(T,tentusscher./abs(norm_IT),'color','m','Marker','o','LineWidth',2)
plot(T,zeng./abs(norm_IZ),'color','y','Marker','o','LineWidth',2)
xlabel('Time (ms)')
ylabel('Normalised Current')
set(gca,'FontSize',20)
experimental_data = [log10(T),exp./abs(norm_exp)];
model_data = [log10(T),model./abs(norm_I)];
wang_data = [log10(T),wang./abs(norm_IW)];
diveroli_data=[log10(T),diveroli./abs(norm_ID)];
mazhari_data = [log10(T),mazhari./abs(norm_IM)];
tentusscher_data = [log10(T),tentusscher./abs(norm_IT)];
zeng_data = [log10(T),zeng./abs(norm_IZ)];

cd ../Figures/figure_e_6/activation_kinetics_1
save activation_kinetics_1_iv_experiment.txt experimental_data -ascii
save activation_kinetics_1_iv_prediction.txt model_data -ascii
save activation_kinetics_1_iv_wang.txt wang_data -ascii
save activation_kinetics_1_iv_mazhari.txt mazhari_data -ascii
save activation_kinetics_1_iv_diveroli.txt diveroli_data -ascii
save activation_kinetics_1_iv_tentusscher.txt tentusscher_data -ascii
save activation_kinetics_1_iv_zeng.txt zeng_data -ascii
cd ..
cd ..
cd ..
cd Code