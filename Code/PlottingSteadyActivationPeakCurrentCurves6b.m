function PlottingSteadyActivationPeakCurrentCurves6b(exp_ref)
% This function generates the data for the steady state activation iv curves in Figure 6b.
% It calculates IV curves for both simulated and experimental data for the cell specific models
% and well as the literature model predictions.

model = 'hh';
fitting_protocol={'sine_wave'};

% Identify parameters corresponding to best fit to sine wave after MCMC for average model
[chain_av,likelihood_av] = FindingBestFitsAfterMCMC(model,fitting_protocol,'average');
[i,v]= max(likelihood_av);
average_model= chain_av(v,:);
%Identify parameters corresponding to best fit to sine wave adter MCMC for cell-specific model
[chain,likelihood] = FindingBestFitsAfterMCMC(model,fitting_protocol,exp_ref);
[i,v]= max(likelihood);
P= chain(v,:);

% Identify temperature for particular experiment
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

% steady state activation protocol

% Import protocol
cd ../Protocols
V=importdata(['steady_activation_protocol.mat']);
cd ..
cd Code
% Identify model type for simulation
[simulated_parameters,model_type] =modeldata(model);

% Import experimental data
cd ../ExperimentalData
cd(exp_ref)
E=importdata(['steady_activation_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
cd ..
cd ..
cd Code
% Simulate cell-specific and literature models
I = SimulatingData(model_type,{'steady_activation'},P,V,temperature);

% For literature models we identify a scaling factor for the conductance to minimise the square difference
% between the literature model simulation and the steady state activation experiment, although in practice
% the scaling does not matter as we are plotting relative currents (it is just done for visualisation of
% the model comparisons if required).

% Average model
IA = SimulatingData(35,{'steady_activation'},average_model,V,temperature);
c=0;
for a = 0.000001:0.01:2
    c=c+1;
    
    Diff(1,c) = sum((E-a.*IA).^2)./length(IA);
    
end


[i,v]=min((Diff(1,:)));

sa = v*0.01+0.000001;

JA = sa.*IA;
IA=JA;



V=[-60,-40,-20,0,20,40,60];


for i=1:7
    
    D=I(56292+(82580*(i-1)):57292+82580*(i-1));
    
    DA=IA(56292+(82580*(i-1)):57292+82580*(i-1));
    S(i) = max(abs(D));
    
    SA(i) = max(abs(DA));
    if min(D) == -S(i);
        
        S(i) = -S(i);
    end
    
    
    
    if min(DA) == -SA(i);
        
        SA(i) = -SA(i);
    end
    D=[];
    
    DA=[];
end

% Experimental peak currents identified manually
if strcmp(exp_ref,'16713110')==1
    
    SExp = [0.0201,0.0357,0.2412,1.21,1.6253,1.6373,1.6473];
    
end
if strcmp(exp_ref,'16713003')==1
    
    SExp = [0.0286,0.0344,0.1205,0.6948,1.1962,1.3079,1.3802];
    
end
if strcmp(exp_ref,'16715049')==1
    
    SExp = [0.0363,0.0445,0.1645,0.5908,0.7596,0.7946,0.813];
    
end

if strcmp(exp_ref,'16704007')==1
    
    SExp = [0.0235,0.0764,0.6929,1.793,2.2334,2.2947,2.3034];
    
end
if strcmp(exp_ref,'16704047')==1
    
    SExp = [0.0792,0.1058,0.2722,0.7578,1.1566,1.382,1.4495];
    
end

if strcmp(exp_ref,'16708016')==1
    
    SExp = [0.05,0.0587,0.3118,0.6876,0.7373,0.7395,0.7423];
    
end

if strcmp(exp_ref,'16707014')==1
    
    SExp = [0.0539,0.0586,0.1294,0.3797,0.5509,0.5684,0.571];
    
end

if strcmp(exp_ref,'16708118')==1
    
    SExp = [0.0356,0.06,0.1799,0.3834,0.4283,0.4343,0.4459];
    
end

if strcmp(exp_ref,'16708060')==1
    
    SExp = [0.0387,0.0555,0.3067,0.6727,0.7875,0.7973,0.8142];
    
end

% Prepare and save data
steady_activation_iv_experimental_data(:,1)=V;
steady_activation_iv_experimental_data(:,2)=SExp./max(SExp);
steady_activation_iv_prediction_data(:,1)=V;
steady_activation_iv_prediction_data(:,2) =S./max(S);
steady_activation_iv_average_data(:,1) =V;
steady_activation_iv_average_data(:,2)=SA./max(SA);

cd ../Figures/figure_6/steady_act_predictions
save(['steady_act_peak_hh_',exp_ref,'.txt'],'steady_activation_iv_prediction_data','-ascii')
save(['steady_act_peak_hh_',exp_ref,'_average.txt'],'steady_activation_iv_average_data','-ascii')
cd ..
cd ..
cd ..
cd Code