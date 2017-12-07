function PlottingFigure5TraditionalVoltageSteps()
close all
% This script produces the data to plot Figure 5, which is then used in Figures/figure_5/plot_figure_5_results.py to plot the figure
% Plots protocols, model simulations and experimental recordings for cell 5 for steady state activation, inactivation and deactivation protoocols
% and also plot the summary data curves in the form of current-voltage and time constant-voltage relationships for these protocols.

% Model simulations are performed with best fitting parameters to sine wave for cell 5
model='hh';
protocol={'sine_wave'};
exp_ref='16713110';
temperature=21.4; % temperature for cell 5 recordings

%Inactivation protocol
[simulated_parameters,model_type] =modeldata(model);
%Import experimental data
cd ../ExperimentalData
cd(exp_ref)
D=importdata(['inactivation_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
cd ..
cd ..
l=length(D)/16;
% Reformat experimental data to plot in traditional voltage steps
inactivation_experimental_data(:,1)=[0:0.0001:-0.0001+l/10000];
for i=1:16
    inactivation_experimental_data(:,i+1) = D(1+(i-1)*l:i*l);
    
end
cd Code
[chain,likelihood] = FindingBestFitsAfterMCMC(model,protocol,exp_ref);

[i,v]= max(likelihood);

P= chain(v,:);


% Import inactivation protocol
cd ../Protocols
V=importdata('inactivation_protocol.mat');
cd ..
cd Code
% Simulate inactivation protocol with the parameters identified as providing best fit to sine wave protocol
I=SimulatingData(model_type,'inactivation',P,V,temperature);
inactivation_protocol_data(:,1)=[0:0.0001:-0.0001+l/10000];
inactivation_prediction_data(:,1)=[0:0.0001:-0.0001+l/10000];
for i=1:16
    
    inactivation_protocol_data(:,i+1) = V(1+(i-1)*l:i*l);
    inactivation_prediction_data(:,i+1) = I(1+(i-1)*l:i*l);
    
end
cd ../Figures/figure_5/figure_5_inactivation/
save figure_5_inactivation_prediction.txt inactivation_prediction_data -ascii
save figure_5_inactivation_experiment.txt inactivation_experimental_data -ascii
save figure_5_inactivation_protocol.txt inactivation_protocol_data -ascii
cd ..
cd ..
cd ..
cd Code
D=[];
I=[];
%Deactivation Protocol
[simulated_parameters,model_type] =modeldata(model);
% Import experimental data
cd ../ExperimentalData
cd(exp_ref)
D=importdata(['deactivation_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
cd ..
cd ..

% Reformat experimental data to plot in traditional voltage steps
l=length(D)/9;
deactivation_experimental_data(:,1)=[0:0.0001:-0.0001+l/10000];
deactivation_protocol_data(:,1)=[0:0.0001:-0.0001+l/10000];
deactivation_prediction_data(:,1)=[0:0.0001:-0.0001+l/10000];
for i=1:9
    
    deactivation_experimental_data(:,i+1) = D(1+(i-1)*l:i*l);
    
end

%Import deactivation protocol
cd Protocols
V=importdata('deactivation_protocol.mat');
cd ..
cd Code
% Simulate deactivation protocol with parameters which provided best fit to sine wave
I=SimulatingData(model_type,'deactivation',P,V,temperature);

for i=1:9
    
    deactivation_protocol_data(:,i+1) = V(1+(i-1)*l:i*l);
    deactivation_prediction_data(:,i+1) = I(1+(i-1)*l:i*l);
    
end
% Save data
cd ../Figures/figure_5/figure_5_deactivation
save figure_5_deactivation_prediction.txt deactivation_prediction_data -ascii
save figure_5_deactivation_experiment.txt deactivation_experimental_data -ascii
save figure_5_deactivation_protocol.txt deactivation_protocol_data -ascii
cd ..
cd ..
cd ..
D=[];
I=[];

% Steady state activation protocol
% Import experimental data
cd ExperimentalData
cd(exp_ref)
D=importdata(['steady_activation_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);
cd ..
cd ..

% Reformat experimental data to plot in traditional voltage steps
l=length(D)/7;
steady_activation_experimental_data(:,1)=[0:0.0001:-0.0001+l/10000];
steady_activation_protocol_data(:,1)=[0:0.0001:-0.0001+l/10000];
steady_activation_prediction_data(:,1)=[0:0.0001:-0.0001+l/10000];
for i=1:7
    
    steady_activation_experimental_data(:,i+1) = D(1+(i-1)*l:i*l);
end

% Import protocol
cd Protocols
V=importdata('steady_activation_protocol.mat');
cd ..
cd Code
% Simulate steady state activation protocol with parameters which were identified as providing best fit to sine wave
I=SimulatingData(model_type,'steady_activation',P,V,temperature);

for i=1:7
    
    steady_activation_protocol_data(:,i+1) = V(1+(i-1)*l:i*l);
    steady_activation_prediction_data(:,i+1) = I(1+(i-1)*l:i*l);
end
%Save data
cd ../Figures/figure_5/figure_5_steady_activation
save figure_5_steady_activation_prediction.txt steady_activation_prediction_data -ascii
save figure_5_steady_activation_experiment.txt steady_activation_experimental_data -ascii
save figure_5_steady_activation_protocol.txt steady_activation_protocol_data -ascii
cd ..
cd ..
cd ..
cd Code
