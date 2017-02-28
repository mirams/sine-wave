function PlottingSmallMultiplesRecoveryInactivation()
cd ..
% This script generates data for plotting in figure F9 - in each case the time constants for the
% experimental and simulated traces have been obtained manually from fitting in pClamp software.

% Recovery from inactivation time constant is identified as the fastest time constant from a triple
% exponential fit to the deactivation protocol (Pr5) data.

% Specifies voltage range

V=[-120,-110,-100,-90,-80,-70,-60]';

% average model has same parameters for each cell but we simulate the parameters at the temperature
% corresponding to the specific experiment, hence identifying slightly different time constants for
% the average model for different cells as below.

%average model data for cell 1
average_model_cell_1=[2.91175
    3.88953
    5.02716
    8.00634
    9.45578
    10.7142
    ];

%average model data for cells 2, 5 and 9
average_model_cell_2_5_9=[2.92092
    3.91284
    5.12332
    8.00626
    9.45577
    10.7142
    ];

%average model data for cell 3
average_model_cell_3=[2.92091
    3.91284
    5.06741
    8.00634
    9.45578
    10.7142
    ];

%average model data for cell 4 and 6
average_model_cell_4_6=[2.91177
    3.91284
    5.12332
    8.104
    9.61101
    10.7142
    ];

%average model data for cell 7
average_model_cell_7=[2.91189
    3.91287
    5.12321
    8.00634
    9.45577
    10.7142
    ];

%average model data for cell 8
average_model_cell_8=[2.92091
    3.88938
    5.12332
    8.00634
    9.50596
    10.7142
    ];

% to define a single average model to plot in experiment we take an average of the average models
average_model = (average_model_cell_1+3*average_model_cell_2_5_9+average_model_cell_3+2*average_model_cell_4_6+average_model_cell_7+average_model_cell_8)./9;


% Recovery from inactivation time constants identified manually for experiment and simulation
exp_16713110 = [3.41735
    4.56564
    5.62613
    8.78123
    10.5684
    11.3938
    12.639];

sim_16713110 = [3.54466
    4.69501
    6.05576
    7.56244
    9.09354
    10.4862
    11.5832
    ];
exp_16713003=[3.89766
    4.95054
    6.32857
    9.18933
    9.42535
    10.8773
    13.1544
    ];

sim_16713003=[3.00705
    4.18785
    5.69906
    7.49619
    9.42231
    11.1955
    12.4948
    ];

exp_16715049 = [3.85304
    4.856454372
    6.18789
    7.42267
    10.9389
    11.8752
    13.1192
    ];

sim_16715049 = [3.02184
    3.94041
    5.00446
    6.16852
    7.36197
    8.50109
    9.50879
    ];


sim_16708060=[2.77225
    3.67216
    4.74494
    5.95053
    7.32722
    8.41579
    9.45546
    ];


exp_16708060=[3.07914
    4.00953
    5.19637
    9.94873
    9.0001
    9.36188
    10.5154
    ];


sim_16708016 = [2.36122
    3.24784
    4.34144
    5.571
    6.79761
    7.84522
    8.56738
    ];

exp_16708016=[3.29164
    4.15076
    4.89831
    9.88065
    6.79313
    8.32588
    9.42034
    ];


sim_16707014 = [3.38248
    4.484
    5.79606
    7.26987
    8.81496
    10.3129
    11.6469
    ];


exp_16707014 = [3.76635
    5.34746
    7.67374
    10.0754
    11.8002
    12.704
    12.8252
    ];




sim_16704047=[2.79697
    3.74074
    4.90731
    6.27693
    7.78669
    9.32255
    10.7397
    ];


exp_16704047=[3.44604
    3.69198
    6.04403
    7.11555
    8.59105
    11.4734
    12.5071
    ];



sim_16704007=[3.5596
    4.73776
    6.19233
    7.90252
    9.78463
    11.6908
    13.4164
    ];

exp_16704007=[3.76505
    5.86939
    6.79693
    6.97898
    11.1949
    12.2334
    13.4633
    ];
% Collate simulation and experimental results
exp=[exp_16713003,exp_16715049,exp_16708016,exp_16708060,exp_16713110,exp_16704007,exp_16704047,exp_16707014];
sim=[sim_16713003,sim_16715049,sim_16708016,sim_16708060,sim_16713110,sim_16704007,sim_16704047,sim_16707014];

% We remove the data corresponding to -90 mV for fitting as this could not be reliably fitted. Note that we
% have also not included this data point in the average model data above.
exp_temp = [exp(1:3,:);exp(5:end,:)];
sim_temp = [sim(1:3,:);sim(5:end,:)];
v_temp = [V(1:3,:);V(5:end,:)];
exp=exp_temp;
sim=sim_temp;
V=v_temp;
% Prepare and save results

cd Figures/figure_f8_to_f10/recovery_inactivation_tau
average_cell_sim_data = [V(:),average_model];
average_cell_1_sim_data = [V(:),average_model_cell_1];
average_cell_2_5_9_sim_data = [V(:),average_model_cell_2_5_9];
average_cell_3_sim_data = [V(:),average_model_cell_3];
average_cell_4_6_sim_data = [V(:),average_model_cell_4_6];
average_cell_7_sim_data = [V(:),average_model_cell_7];
average_cell_8_sim_data = [V(:),average_model_cell_8];
cell_1_16713003_exp_data = [V,(exp(:,1))];
cell_2_16715049_exp_data = [V,(exp(:,2))];
cell_3_16708016_exp_data = [V,(exp(:,3))];
cell_4_16708060_exp_data = [V,(exp(:,4))];
cell_5_16713110_exp_data = [V,(exp(:,5))];
cell_7_16704007_exp_data = [V,(exp(:,6))];

cell_8_16704047_exp_data = [V,(exp(:,7))];
cell_9_16707014_exp_data = [V,(exp(:,8))];

cell_1_16713003_sim_data = [V,(sim(:,1))];
cell_2_16715049_sim_data = [V,(sim(:,2))];
cell_3_16708016_sim_data = [V,(sim(:,3))];
cell_4_16708060_sim_data = [V,(sim(:,4))];
cell_5_16713110_sim_data = [V,(sim(:,5))];
cell_7_16704007_sim_data = [V,(sim(:,6))];

cell_8_16704047_sim_data = [V,(sim(:,7))];
cell_9_16707014_sim_data = [V,(sim(:,8))];

save cell_1_recovery_inactivation_exp.txt cell_1_16713003_exp_data -ascii
save cell_2_recovery_inactivation_exp.txt cell_2_16715049_exp_data -ascii
save cell_3_recovery_inactivation_exp.txt cell_3_16708016_exp_data -ascii
save cell_4_recovery_inactivation_exp.txt cell_4_16708060_exp_data -ascii
save cell_5_recovery_inactivation_exp.txt cell_5_16713110_exp_data -ascii
save cell_7_recovery_inactivation_exp.txt cell_7_16704007_exp_data -ascii

save cell_8_recovery_inactivation_exp.txt cell_8_16704047_exp_data -ascii
save cell_9_recovery_inactivation_exp.txt cell_9_16707014_exp_data -ascii

save cell_1_recovery_inactivation_sim.txt cell_1_16713003_sim_data -ascii
save cell_2_recovery_inactivation_sim.txt cell_2_16715049_sim_data -ascii
save cell_3_recovery_inactivation_sim.txt cell_3_16708016_sim_data -ascii
save cell_4_recovery_inactivation_sim.txt cell_4_16708060_sim_data -ascii
save cell_5_recovery_inactivation_sim.txt cell_5_16713110_sim_data -ascii
save cell_7_recovery_inactivation_sim.txt cell_7_16704007_sim_data -ascii

save cell_8_recovery_inactivation_sim.txt cell_8_16704047_sim_data -ascii
save cell_9_recovery_inactivation_sim.txt cell_9_16707014_sim_data -ascii

save average_cell_recovery_inactivation_sim.txt average_cell_sim_data -ascii
save average_cell_1_recovery_inactivation_sim.txt average_cell_1_sim_data -ascii
save average_cell_2_recovery_inactivation_sim.txt average_cell_2_5_9_sim_data -ascii
save average_cell_5_recovery_inactivation_sim.txt average_cell_2_5_9_sim_data -ascii
save average_cell_9_recovery_inactivation_sim.txt average_cell_2_5_9_sim_data -ascii
save average_cell_3_recovery_inactivation_sim.txt average_cell_3_sim_data -ascii
save average_cell_4_recovery_inactivation_sim.txt average_cell_4_6_sim_data -ascii
save average_cell_6_recovery_inactivation_sim.txt average_cell_4_6_sim_data -ascii
save average_cell_7_recovery_inactivation_sim.txt average_cell_7_sim_data -ascii
save average_cell_8_recovery_inactivation_sim.txt average_cell_8_sim_data -ascii
cd ..
cd ..
cd ..
cd Code