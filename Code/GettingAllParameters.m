function P= GettingAllParameters()
% This script identifies all maximum likelihood parameters for fit to sine wave for each cell
% and collates them to be used for producing figure 6a. It is also used to generate the parameter
% values in Table F11 but note that the transpose of this output matrix is used to visualise the
% parameters in the row by row format seen in Table F11.
cd ../MCMCResults

T=importdata('MCMCChain_16713003_hh_sine_wave_3110141.mat');
L=importdata('MCMCLikelihood_16713003_hh_sine_wave_3110141.mat');
[i,v]=max(L);
P(1,:)=T(v,:);
T=importdata('MCMCChain_16715049_hh_sine_wave_3110139.mat');
L=importdata('MCMCLikelihood_16715049_hh_sine_wave_3110139.mat');
[i,v]=max(L);
P(2,:)=T(v,:);
T=importdata('MCMCChain_16708016_hh_sine_wave_3110145.mat');
L=importdata('MCMCLikelihood_16708016_hh_sine_wave_3110145.mat');
[i,v]=max(L);
P(3,:)=T(v,:);
T=importdata('MCMCChain_16708060_hh_sine_wave_3110143.mat');
L=importdata('MCMCLikelihood_16708060_hh_sine_wave_3110143.mat');
[i,v]=max(L);
P(4,:)=T(v,:);
T=importdata('MCMCChain_16713110_hh_sine_wave_3110140.mat');
L=importdata('MCMCLikelihood_16713110_hh_sine_wave_3110140.mat');
[i,v]=max(L);
P(5,:)=T(v,:);
T=importdata('MCMCChain_16708118_hh_sine_wave_3110142.mat');
L=importdata('MCMCLikelihood_16708118_hh_sine_wave_3110142.mat');
[i,v]=max(L);
P(6,:)=T(v,:);
T=importdata('MCMCChain_16704007_hh_sine_wave_3110138.mat');
L=importdata('MCMCLikelihood_16704007_hh_sine_wave_3110138.mat');
[i,v]=max(L);
P(7,:)=T(v,:);
T=importdata('MCMCChain_16704047_hh_sine_wave_3110136.mat');
L=importdata('MCMCLikelihood_16704047_hh_sine_wave_3110136.mat');
[i,v]=max(L);
P(8,:)=T(v,:);
T=importdata('MCMCChain_16707014_hh_sine_wave_3110151.mat');
L=importdata('MCMCLikelihood_16707014_hh_sine_wave_3110151.mat');
[i,v]=max(L);
P(9,:)=T(v,:);
T=importdata('MCMCChain_average_hh_sine_wave_18010521.mat');
L=importdata('MCMCLikelihood_average_hh_sine_wave_18010521.mat');
[i,v]=max(L);
P(10,:)=T(v,:);
P=P';
cd ..
cd Figures/figure_6

save parameters_each_cell_and_average.txt P -ascii
cd ..
cd ..
cd Code