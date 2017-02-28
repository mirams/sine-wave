function PlottingActivationKinetics2PlotNormalisedPeakSine()
% This script generates data for subpanel B in Figure E6

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

%TenTusscher model
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

% Zeng model (note that we use to version of the Zeng model with the singularities removed for simulating the action potential protocol)
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

% Peaks from experiments and simulations for activation kinetics protocol 2 identified manually
exp = [0
    0.012
    0.0118
    0.0706
    0.169
    0.244
    ]';

model = [0.0892
    0.1278
    0.0501
    0.0699
    0.1514
    0.22]';

wang = [0.0021377
    0.0248
    0.1469
    0.2161
    0.2161
    0.2161
    ]';

diveroli = [0.0082182
    0.0229
    0.0297
    0.0955
    0.210096
    0.2667
    ]';


mazhari = [0.0021425
    0.0297
    0.2164
    0.4691
    0.4691
    0.4691
    ]';

tentusscher = [0.8699
    0.1597
    0.0796
    0.0802
    0.0802
    0.0802
    ]';


zeng = [0.0285
    0.0803
    0.1386
    0.1553
    0.1554
    0.1554
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

cd ../Figures/figure_e_6/activation_kinetics_2
save activation_kinetics_2_iv_experiment.txt experimental_data -ascii
save activation_kinetics_2_iv_prediction.txt model_data -ascii
save activation_kinetics_2_iv_wang.txt wang_data -ascii
save activation_kinetics_2_iv_mazhari.txt mazhari_data -ascii
save activation_kinetics_2_iv_diveroli.txt diveroli_data -ascii
save activation_kinetics_2_iv_tentusscher.txt tentusscher_data -ascii
save activation_kinetics_2_iv_zeng.txt zeng_data -ascii

cd ..
cd ..
cd ..
cd Code