function PlottingFigure3TrainingDataFigure()
% This script produces the data to plot Figure 3, which is then used in Figures/figure_3/plot_figure_3_results.py to plot the figure
% Plots sine wave protocol along with experimental recording and model fit for cell 5

% Imports protocol
cd ../Protocols

V=importdata('sine_wave_protocol.mat');

cd ..


%Imports experimental data for cell 5
cd ExperimentalData/16713110


D=importdata('sine_wave_16713110_dofetilide_subtracted_leak_subtracted.mat');

cd ..
cd ..
cd Code
%Identify parameters with having maximum likelihood after MCMC

[chain,likelihood] = FindingBestFitsAfterMCMC('hh',{'sine_wave'},'16713110');

[i,v]= max(likelihood);

k= chain(v,:);
% Simulate the model with the maximum likelihood parameters
I=SimulatingData(35,{'sine_wave'},k,V,21.4);

% Save data
protocol_data=[[0:0.0001:(length(V)/10000)-0.0001]',V];
new_model_data=[[0:0.0001:(length(V)/10000)-0.0001]',I];
experimental_data=[[0:0.0001:(length(V)/10000)-0.0001]',D];
cd ../Figures/figure_3/figure_3_a
save figure_3_model_fit_protocol.txt protocol_data -ascii
save figure_3_model_fit_new_model_fit.txt new_model_data -ascii
save figure_3_model_fit_experimental_data.txt experimental_data -ascii

cd ..
cd ..
cd ..
cd Code