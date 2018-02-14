function PlottingSmallMultiplesSteadyActivation()
% This script generates data for plotting in figure 6b. The peak currents in the tails
% of the steady state activation protocols (Pr 3) for the
% experimental traces have been obtained manually from fitting in pClamp software and
% those for the simulated traces have been obtained using the script PlottingSteadyActivationPeakCurrentCurves6b.m.
cd ..
% Specifies voltage range

V=[-60,-40,-20,0,20,40,60];

% Peak currents from experimental data for each cell identified manually
exp_16713110 = [0.0201,0.0357,0.2412,1.21,1.6253,1.6373,1.6473];

exp_16713003 = [0.0286,0.0344,0.1205,0.6948,1.1962,1.3079,1.3802];

exp_16715049 = [0.0363,0.0445,0.1645,0.5908,0.7596,0.7946,0.813];

exp_16704007 = [0.0235,0.0764,0.6929,1.793,2.2334,2.2947,2.3034];

exp_16704047 = [0.0792,0.1058,0.2722,0.7578,1.1566,1.382,1.4495];

exp_16708016 =  [0.05,0.0587,0.3118,0.6876,0.7373,0.7395,0.7423];

exp_16707014 =  [0.0539,0.0586,0.1294,0.3797,0.5509,0.5684,0.571];

exp_16708118= [0.0356,0.06,0.1799,0.3834,0.4283,0.4343,0.4459];

exp_16708060= [0.0387,0.0555,0.3067,0.6727,0.7875,0.7973,0.8142];

cd Figures/figure_7/steady_act_predictions

% Import peak current data for simulations as calculated from running the matlab script PlottingSteadyActivationPeakCurrentCurves6b.m.
sim_16713110 = importdata('steady_act_peak_hh_16713110.txt');
sim_16713003 = importdata('steady_act_peak_hh_16713003.txt');
sim_16715049 = importdata('steady_act_peak_hh_16715049.txt');
sim_16708118 = importdata('steady_act_peak_hh_16708118.txt');
sim_16708060 = importdata('steady_act_peak_hh_16708060.txt');
sim_16708016 = importdata('steady_act_peak_hh_16708016.txt');
sim_16707014 = importdata('steady_act_peak_hh_16707014.txt');
sim_16704047 = importdata('steady_act_peak_hh_16704047.txt');
sim_16704007 = importdata('steady_act_peak_hh_16704007.txt');
% While we calculate an average model for each cell (based on the temperature of the experiments for that
% particular cell) the peak currents from each of these average models were the same so we just have one
% average model data set to be used for all the cells.
sim_average = importdata('steady_act_peak_hh_average.txt');
sim_average=sim_average(:,2);
cd ..
% Collate simulation and experimental results
exp=[exp_16713003',exp_16715049',exp_16708016',exp_16708060',exp_16713110',exp_16708118',exp_16704007',exp_16704047',exp_16707014'];
sim=[sim_16713003(:,2),sim_16715049(:,2),sim_16708016(:,2),sim_16708060(:,2),sim_16713110(:,2),sim_16708118(:,2),sim_16704007(:,2),sim_16704047(:,2),sim_16707014(:,2)];

% Prepare and save data
cd steady_activation_peak_current_figure_7_b

cell_1_16713003_exp_data = [V(:),exp(:,1)./max(exp(:,1))];
cell_2_16715049_exp_data = [V(:),exp(:,2)./max(exp(:,2))];
cell_3_16708016_exp_data = [V(:),exp(:,3)./max(exp(:,3))];
cell_4_16708060_exp_data = [V(:),exp(:,4)./max(exp(:,4))];
cell_5_16713110_exp_data = [V(:),exp(:,5)./max(exp(:,5))];
cell_6_16708118_exp_data = [V(:),exp(:,6)./max(exp(:,6))];
cell_7_16704007_exp_data = [V(:),exp(:,7)./max(exp(:,7))];
cell_8_16704047_exp_data = [V(:),exp(:,8)./max(exp(:,8))];
cell_9_16707014_exp_data = [V(:),exp(:,9)./max(exp(:,9))];
average_cell_sim_data = [V(:),sim_average(:)./max(sim_average(:))];
cell_1_16713003_sim_data = [V(:),sim(:,1)./max(sim(:,1))];
cell_2_16715049_sim_data = [V(:),sim(:,2)./max(sim(:,2))];
cell_3_16708016_sim_data = [V(:),sim(:,3)./max(sim(:,3))];
cell_4_16708060_sim_data = [V(:),sim(:,4)./max(sim(:,4))];
cell_5_16713110_sim_data = [V(:),sim(:,5)./max(sim(:,5))];
cell_6_16708118_sim_data = [V(:),sim(:,6)./max(sim(:,6))];
cell_7_16704007_sim_data = [V(:),sim(:,7)./max(sim(:,7))];
cell_8_16704047_sim_data = [V(:),sim(:,8)./max(sim(:,8))];
cell_9_16707014_sim_data = [V(:),sim(:,9)./max(sim(:,9))];

save cell_1_steady_activation_peak_exp.txt cell_1_16713003_exp_data -ascii
save cell_2_steady_activation_peak_exp.txt cell_2_16715049_exp_data -ascii
save cell_3_steady_activation_peak_exp.txt cell_3_16708016_exp_data -ascii
save cell_4_steady_activation_peak_exp.txt cell_4_16708060_exp_data -ascii
save cell_5_steady_activation_peak_exp.txt cell_5_16713110_exp_data -ascii
save cell_6_steady_activation_peak_exp.txt cell_6_16708118_exp_data -ascii
save cell_7_steady_activation_peak_exp.txt cell_7_16704007_exp_data -ascii
save cell_8_steady_activation_peak_exp.txt cell_8_16704047_exp_data -ascii
save cell_9_steady_activation_peak_exp.txt cell_9_16707014_exp_data -ascii

save cell_1_steady_activation_peak_sim.txt cell_1_16713003_sim_data -ascii
save cell_2_steady_activation_peak_sim.txt cell_2_16715049_sim_data -ascii
save cell_3_steady_activation_peak_sim.txt cell_3_16708016_sim_data -ascii
save cell_4_steady_activation_peak_sim.txt cell_4_16708060_sim_data -ascii
save cell_5_steady_activation_peak_sim.txt cell_5_16713110_sim_data -ascii
save cell_6_steady_activation_peak_sim.txt cell_6_16708118_sim_data -ascii
save cell_7_steady_activation_peak_sim.txt cell_7_16704007_sim_data -ascii
save cell_8_steady_activation_peak_sim.txt cell_8_16704047_sim_data -ascii
save cell_9_steady_activation_peak_sim.txt cell_9_16707014_sim_data -ascii

save average_cell_steady_activation_peak_sim.txt average_cell_sim_data -ascii
cd ..
cd ..
cd ..
cd Code