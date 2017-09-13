function P= GettingAllParameters()
% This script identifies all maximum likelihood parameters for fit to sine wave for each cell
% and collates them to be used for producing figure 6a. It is also used to generate the parameter
% values in Table F3 but note that the transpose of this output matrix is used to visualise the
% parameters in the row by row format seen in Table F3.
cd ../MCMCResults

T=importdata('MCMCChain_16713003_hh_sine_wave_31082310.mat');
L=importdata('MCMCLikelihood_16713003_hh_sine_wave_31082310.mat');
[i,v]=max(L);
P(1,:)=T(v,:);
T=importdata('MCMCChain_16715049_hh_sine_wave_31082315.mat');
L=importdata('MCMCLikelihood_16715049_hh_sine_wave_31082315.mat');
[i,v]=max(L);
P(2,:)=T(v,:);
T=importdata('MCMCChain_16708016_hh_sine_wave_1092300.mat');
L=importdata('MCMCLikelihood_16708016_hh_sine_wave_1092300.mat');
[i,v]=max(L);
P(3,:)=T(v,:);
T=importdata('MCMCChain_16708060_hh_sine_wave_31082301.mat');
L=importdata('MCMCLikelihood_16708060_hh_sine_wave_31082301.mat');
[i,v]=max(L);
P(4,:)=T(v,:);
T=importdata('MCMCChain_16713110_hh_sine_wave_30082148.mat');
L=importdata('MCMCLikelihood_16713110_hh_sine_wave_30082148.mat');
[i,v]=max(L);
P(5,:)=T(v,:);
T=importdata('MCMCChain_16708118_hh_sine_wave_31082334.mat');
L=importdata('MCMCLikelihood_16708118_hh_sine_wave_31082334.mat');
[i,v]=max(L);
P(6,:)=T(v,:);
T=importdata('MCMCChain_16704007_hh_sine_wave_31082305.mat');
L=importdata('MCMCLikelihood_16704007_hh_sine_wave_31082305.mat');
[i,v]=max(L);
P(7,:)=T(v,:);
T=importdata('MCMCChain_16704047_hh_sine_wave_31082302.mat');
L=importdata('MCMCLikelihood_16704047_hh_sine_wave_31082302.mat');
[i,v]=max(L);
P(8,:)=T(v,:);
T=importdata('MCMCChain_16707014_hh_sine_wave_31082320.mat');
L=importdata('MCMCLikelihood_16707014_hh_sine_wave_31082320.mat');
[i,v]=max(L);
P(9,:)=T(v,:);
T=importdata('MCMCChain_average_hh_sine_wave_12092102.mat');
L=importdata('MCMCLikelihood_average_hh_sine_wave_12092102.mat');
[i,v]=max(L);
P(10,:)=T(v,:);
P=P';
cd ..
cd Figures/figure_6

save parameters_each_cell_and_average.txt P -ascii
cd ..
cd ..
cd Code