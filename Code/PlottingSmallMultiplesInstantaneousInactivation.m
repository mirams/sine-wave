function PlottingSmallMultiplesInstantaneousInactivation()
cd ..
% This script generates data for plotting in figure F10 - in each case the time constants for the
% experimental and simulated traces have been obtained manually from fitting in pClamp software.

% Instantaneous inactivation time constant is identified from the inactivation protocol (Pr4) and
% we fit a single exponential to the current response during the 150 ms Vstep.

% Specifies voltage range
V=[-50
    -40
    -30
    -20
    -10
    0
    10
    20
    30
    40
    50]';

% average model has same parameters for each cell but we simulate the parameters at the temperature
% corresponding to the specific experiment, hence identifying slightly different time constants for
% the average model for different cells as below.

%average model data for cell 1
average_model_cell_1=[13.5885
    12.9471
    12.7215
    12.4671
    12.1
    11.6291
    11.0912
    10.5229
    9.95509
    9.41182
    8.91326
    ];

% average model data for cells 2, 5 and 9
average_model_cell_2_5_9=[13.612
    12.9489
    12.7202
    12.4674
    12.1
    11.6291
    11.0911
    10.5228
    9.95512
    9.41121
    8.91315
    ];

% average model data for cell 3
average_model_cell_3=[13.5972
    12.9494
    12.7196
    12.4678
    12.1
    11.6291
    11.0911
    10.523
    9.95509
    9.41168
    8.91317
    ];

% average model data for cells 4 and 6
average_model_cell_4_6=[13.592
    12.9483
    12.7194
    12.4671
    12.1001
    11.6291
    11.0913
    10.5229
    9.95448
    9.41168
    8.91241
    ];

% average model data for cell 7
average_model_cell_7=[13.5955
    12.95
    12.7217
    12.4678
    12.1
    11.6289
    11.0911
    10.523
    9.95509
    9.41175
    8.9132
    ];

% average model data for cell 8
average_model_cell_8=[13.5729
    12.95
    12.7194
    12.4673
    12.1001
    11.629
    11.0909
    10.5229
    9.95463
    9.41124
    8.91246
    ];

% to define a single average model to plot in experiment we take an average of the average models
average_model = (average_model_cell_1+3*average_model_cell_2_5_9+average_model_cell_3+2*average_model_cell_4_6+average_model_cell_7+average_model_cell_8)./9;

% Instantaneous inactivation time constants identified manually for experiment and simulation
exp_16713110 = [17.5899
    17.6702
    17.7078
    16.8357
    15.0998
    13.2722
    11.7947
    10.049
    8.04101
    6.60235
    5.19663];

sim_16713110 = [13.6113
    13.0192
    12.6175
    12.1226
    11.5069
    10.8081
    10.0722
    9.33586
    8.62702
    7.96556
    7.3685];

exp_16713003=[17.0815
    16.7005
    15.4975
    14.0525
    11.578
    8.65804
    6.40815
    4.5325
    3.25877
    2.49725
    1.78943    ];

sim_16713003=[14.9237
    13.6255
    12.6001
    11.4996
    10.3465
    9.2044
    8.1256
    7.1393
    6.25607
    5.47573
    4.79368    ];

exp_16715049 = [17.1882
    17.1095
    16.3614
    15.7536
    14.5681
    13.1349
    11.486
    9.26046
    7.68653
    6.13083
    5.04113    ];

sim_16715049 = [12.3807
    11.7477
    11.6781
    11.726
    11.7413
    11.6983
    11.6001
    11.4653
    11.3261
    11.218
    11.1941
    ];


sim_16708060=[12.0275
    11.3442
    11.1937
    11.0323
    10.7924
    10.4705
    10.0913
    9.68643
    9.28065
    8.90462
    8.57649
    ];


exp_16708060=[13.4239
    13.0998
    13.2401
    12.5267
    11.3075
    9.97451
    8.58166
    7.15483
    5.80648
    4.49743
    3.63191
    
    ];


sim_16708016 = [9.78344
    9.16979
    8.70866
    8.19448
    7.63854
    7.06669
    6.50426
    5.96952
    5.47376
    5.02455
    4.62748
    
    ];

exp_16708016=[11.3816
    10.7823
    9.73208
    8.44343
    6.78734
    5.15347
    3.76231
    2.76486
    2.07389
    1.57119
    1.2458
    
    ];


sim_16707014 = [15.4244
    14.5756
    14.4575
    14.4741
    14.4585
    14.3713
    14.2211
    14.0289
    13.8214
    13.619
    13.4482
    
    ];


exp_16707014 = [20.568
    21.1928
    17.1837
    14.8584
    12.2451
    12.2288
    11.3335
    9.07071
    5.66094
    4.96444
    2.95953
    
    ];




sim_16704047=[13.7114
    13.3923
    13.4135
    13.3586
    13.139
    12.7696
    12.293
    11.7529
    11.1871
    10.6228
    10.0796
    
    ];


exp_16704047=[15.0752
    15.2524
    14.9405
    14.5255
    13.4945
    12.0009
    10.3393
    8.92588
    7.35374
    5.4543
    4.8236
    
    ];



sim_16704007=[17.2119
    16.5512
    16.3043
    15.9525
    15.3891
    14.6513
    13.8044
    12.9121
    12.019
    11.1591
    10.353
    
    ];

exp_16704007=[20.1925
    21.2751
    20.5709
    19.921
    19.331
    17.9157
    15.9591
    13.8091
    11.54456
    9.5655
    7.82344
    ];

sim_16708118=[18.2813
    16.499
    15.1025
    13.833
    12.4798
    11.0823
    9.71334
    8.43133
    7.27538
    6.26314
    5.39551
    ];

exp_16708118=[15.5854
    15.4958
    16.5264
    16.3297
    14.2905
    13.9821
    12.1822
    10.6405
    9.29917
    7.71733
    7.05256
    ];

% Collate simulation and experimental results
exp=[exp_16713003,exp_16715049,exp_16708016,exp_16708060,exp_16713110,exp_16708118,exp_16704007,exp_16704047,exp_16707014];
sim=[sim_16713003,sim_16715049,sim_16708016,sim_16708060,sim_16713110,sim_16708118,sim_16704007,sim_16704047,sim_16707014];


% Prepare and save results
cd Figures/figure_f8_to_f10/instantaneous_inactivation_tau
average_cell_sim_data = [V(:),average_model];
average_cell_1_sim_data = [V(:),average_model_cell_1];
average_cell_2_5_9_sim_data = [V(:),average_model_cell_2_5_9];
average_cell_3_sim_data = [V(:),average_model_cell_3];
average_cell_4_6_sim_data = [V(:),average_model_cell_4_6];
average_cell_7_sim_data = [V(:),average_model_cell_7];
average_cell_8_sim_data = [V(:),average_model_cell_8];
cell_1_16713003_exp_data = [V(:),(exp(:,1))];
cell_2_16715049_exp_data = [V(:),(exp(:,2))];
cell_3_16708016_exp_data = [V(:),(exp(:,3))];
cell_4_16708060_exp_data = [V(:),(exp(:,4))];
cell_5_16713110_exp_data = [V(:),(exp(:,5))];
cell_6_16708118_exp_data = [V(:),(exp(:,6))];
cell_7_16704007_exp_data = [V(:),(exp(:,7))];

cell_8_16704047_exp_data = [V(:),(exp(:,8))];
cell_9_16707014_exp_data = [V(:),(exp(:,9))];

cell_1_16713003_sim_data = [V(:),(sim(:,1))];
cell_2_16715049_sim_data = [V(:),(sim(:,2))];
cell_3_16708016_sim_data = [V(:),(sim(:,3))];
cell_4_16708060_sim_data = [V(:),(sim(:,4))];
cell_5_16713110_sim_data = [V(:),(sim(:,5))];
cell_6_16708118_sim_data = [V(:),(sim(:,6))];
cell_7_16704007_sim_data = [V(:),(sim(:,7))];

cell_8_16704047_sim_data = [V(:),(sim(:,8))];
cell_9_16707014_sim_data = [V(:),(sim(:,9))];

save cell_1_instantaneous_inactivation_exp.txt cell_1_16713003_exp_data -ascii
save cell_2_instantaneous_inactivation_exp.txt cell_2_16715049_exp_data -ascii
save cell_3_instantaneous_inactivation_exp.txt cell_3_16708016_exp_data -ascii
save cell_4_instantaneous_inactivation_exp.txt cell_4_16708060_exp_data -ascii
save cell_5_instantaneous_inactivation_exp.txt cell_5_16713110_exp_data -ascii
save cell_6_instantaneous_inactivation_exp.txt cell_6_16708118_exp_data -ascii
save cell_7_instantaneous_inactivation_exp.txt cell_7_16704007_exp_data -ascii

save cell_8_instantaneous_inactivation_exp.txt cell_8_16704047_exp_data -ascii
save cell_9_instantaneous_inactivation_exp.txt cell_9_16707014_exp_data -ascii

save cell_1_instantaneous_inactivation_sim.txt cell_1_16713003_sim_data -ascii
save cell_2_instantaneous_inactivation_sim.txt cell_2_16715049_sim_data -ascii
save cell_3_instantaneous_inactivation_sim.txt cell_3_16708016_sim_data -ascii
save cell_4_instantaneous_inactivation_sim.txt cell_4_16708060_sim_data -ascii
save cell_5_instantaneous_inactivation_sim.txt cell_5_16713110_sim_data -ascii
save cell_6_instantaneous_inactivation_sim.txt cell_6_16708118_sim_data -ascii
save cell_7_instantaneous_inactivation_sim.txt cell_7_16704007_sim_data -ascii

save cell_8_instantaneous_inactivation_sim.txt cell_8_16704047_sim_data -ascii
save cell_9_instantaneous_inactivation_sim.txt cell_9_16707014_sim_data -ascii

save average_cell_instantaneous_inactivation_sim.txt average_cell_sim_data -ascii
save average_cell_1_instantaneous_inactivation_sim.txt average_cell_1_sim_data -ascii
save average_cell_2_instantaneous_inactivation_sim.txt average_cell_2_5_9_sim_data -ascii
save average_cell_5_instantaneous_inactivation_sim.txt average_cell_2_5_9_sim_data -ascii
save average_cell_9_instantaneous_inactivation_sim.txt average_cell_2_5_9_sim_data -ascii
save average_cell_3_instantaneous_inactivation_sim.txt average_cell_3_sim_data -ascii
save average_cell_4_instantaneous_inactivation_sim.txt average_cell_4_6_sim_data -ascii
save average_cell_6_instantaneous_inactivation_sim.txt average_cell_4_6_sim_data -ascii
save average_cell_7_instantaneous_inactivation_sim.txt average_cell_7_sim_data -ascii
save average_cell_8_instantaneous_inactivation_sim.txt average_cell_8_sim_data -ascii
cd ..
cd ..
cd ..
cd Code