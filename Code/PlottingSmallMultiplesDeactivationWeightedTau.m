function PlottingSmallMultiplesDeactivationWeighted()
cd ..
% This script generates data for plotting in figure F8 - in each case the time constants for the
% experimental and simulated traces have been obtained manually from fitting in pClamp software.

% Weighted deactivation time constant is identified as the weighted sum of the slowest two time
% constants from a triple exponential fit to the deactivation protocol (Pr5) data.

% Specifies voltage range
V=[-120,-110,-100,-90,-80,-70,-60]';

% average model has same parameters for each cell but we simulate the parameters at the temperature
% corresponding to the specific experiment, hence identifying slightly different time constants for
% the average model for different cells as below.

%average model data for cell 1
average_model_cell_1 = [44.5776
    72.5384
    118.082
    312.032
    506.539
    818.672
    ];

%average model data for cells 2, 5 and 9
average_model_cell_2_5_9=[44.5665
    72.5143
    117.981
    312.032
    506.539
    818.672
    ];

%average model data for cell 3

average_model_cell_3=[44.5665
    72.5143
    118.039
    312.032
    506.539
    818.672
    ];

%average model data for cell 4 and 6
average_model_cell_4_6=[44.5759
    72.5143
    117.981
    311.929
    506.366
    818.672
    ];

%average model data for cell 7
average_model_cell_7=[44.5758
    72.5143
    117.981
    312.032
    506.539
    818.672
    ];

%average model data for cell 8

average_model_cell_8=[44.5665
    72.5385
    117.981
    312.032
    506.483
    818.672
    ];
% to define a single average model to plot in experiment we take an average of the average models
average_model = (average_model_cell_1+3*average_model_cell_2_5_9+average_model_cell_3+2*average_model_cell_4_6+average_model_cell_7+average_model_cell_8)./9;

% Weighted deactivation time constants identified manually for experiment and simulation
exp_16713110 = [33.88406051
    54.41660379
    94.65675289
    206.9228347
    422.5121594
    1083.034372
    2410.843456
    ];

sim_16713110 = [41.3198
    71.3425
    123.178
    212.665
    367.109
    633.389
    1090.69
    ];
exp_16713003=[42.89152862
    62.07063962
    93.49290129
    163.7477269
    298.7188579
    659.6837213
    1492.059125
    ];

sim_16713003=[37.4564
    61.347
    100.47
    164.533
    269.393
    440.818
    720.053
    ];

exp_16715049 = [39.52322076
    54.81799862
    88.39078828
    179.4944329
    215.7434862
    619.4839456
    1553.291619
    ];

sim_16715049 = [32.8802
    54.0456
    88.8335
    146.005
    239.924
    394.011
    645.802
    ];

exp_16708060=[36.00060628
    58.37124617
    73.01644485
    12.57819593
    453.4139318
    884.96537
    2099.825146
    ];

sim_16708060=[34.73
    58.205
    97.5374
    163.399
    273.369
    456.56
    756.393
    ];


exp_16708016=[3.90E+01
    5.87E+01
    1.07E+02
    1.86E+02
    4.12E+02
    8.87E+02
    1.84E+03
    ];

sim_16708016=[36.3099
    61.29
    103.428
    174.51
    294.346
    495.914
    832.473
    ];


exp_16707014 = [5.30E+01
    7.26E+01
    1.10E+02
    1.75E+02
    3.75E+02
    7.09E+02
    1.43E+03
    ];

sim_16707014 = [39.141
    61.0173
    95.098
    148.131
    230.427
    357.279
    549.706
    ];


sim_16704047=[54.498
    89.0873
    145.556
    237.776
    388.045
    631.664
    1021.37
    ];

exp_16704047=[52.72966604
    82.33956509
    108.4462364
    1050.969743
    447.3083767
    820.9822424
    1547.361696
    ];


sim_16704007=[62.787
    99.1278
    156.46
    246.783
    388.633
    609.145
    944.506
    ];

exp_16704007=[53.0019918
    71.80021096
    112.6418947
    184.4595108
    373.7751722
    711.7665113
    1424.215547
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

%Prepare and save data
cd Figures/figure_f8_to_f10/deactivation_weighted_tau
average_cell_sim_data = [V(:),log10(average_model)];
average_cell_1_sim_data = [V(:),log10(average_model_cell_1)];
average_cell_2_5_9_sim_data = [V(:),log10(average_model_cell_2_5_9)];
average_cell_3_sim_data = [V(:),log10(average_model_cell_3)];
average_cell_4_6_sim_data = [V(:),log10(average_model_cell_4_6)];
average_cell_7_sim_data = [V(:),log10(average_model_cell_7)];
average_cell_8_sim_data = [V(:),log10(average_model_cell_8)];
cell_1_16713003_exp_data = [V,log10(exp(:,1))];
cell_2_16715049_exp_data = [V,log10(exp(:,2))];
cell_3_16708016_exp_data = [V,log10(exp(:,3))];
cell_4_16708060_exp_data = [V,log10(exp(:,4))];
cell_5_16713110_exp_data = [V,log10(exp(:,5))];
cell_7_16704007_exp_data = [V,log10(exp(:,6))];
cell_8_16704047_exp_data = [V,log10(exp(:,7))];
cell_9_16707014_exp_data = [V,log10(exp(:,8))];

cell_1_16713003_sim_data = [V,log10(sim(:,1))];
cell_2_16715049_sim_data = [V,log10(sim(:,2))];
cell_3_16708016_sim_data = [V,log10(sim(:,3))];
cell_4_16708060_sim_data = [V,log10(sim(:,4))];
cell_5_16713110_sim_data = [V,log10(sim(:,5))];
cell_7_16704007_sim_data = [V,log10(sim(:,6))];
cell_8_16704047_sim_data = [V,log10(sim(:,7))];
cell_9_16707014_sim_data = [V,log10(sim(:,8))];

save cell_1_deactivation_exp.txt cell_1_16713003_exp_data -ascii
save cell_2_deactivation_exp.txt cell_2_16715049_exp_data -ascii
save cell_3_deactivation_exp.txt cell_3_16708016_exp_data -ascii
save cell_4_deactivation_exp.txt cell_4_16708060_exp_data -ascii
save cell_5_deactivation_exp.txt cell_5_16713110_exp_data -ascii
save cell_7_deactivation_exp.txt cell_7_16704007_exp_data -ascii
save cell_8_deactivation_exp.txt cell_8_16704047_exp_data -ascii
save cell_9_deactivation_exp.txt cell_9_16707014_exp_data -ascii

save cell_1_deactivation_sim.txt cell_1_16713003_sim_data -ascii
save cell_2_deactivation_sim.txt cell_2_16715049_sim_data -ascii
save cell_3_deactivation_sim.txt cell_3_16708016_sim_data -ascii
save cell_4_deactivation_sim.txt cell_4_16708060_sim_data -ascii
save cell_5_deactivation_sim.txt cell_5_16713110_sim_data -ascii
save cell_7_deactivation_sim.txt cell_7_16704007_sim_data -ascii
save cell_8_deactivation_sim.txt cell_8_16704047_sim_data -ascii
save cell_9_deactivation_sim.txt cell_9_16707014_sim_data -ascii

save average_cell_deactivation_sim.txt average_cell_sim_data -ascii
save average_cell_1_deactivation_sim.txt average_cell_1_sim_data -ascii
save average_cell_2_deactivation_sim.txt average_cell_2_5_9_sim_data -ascii
save average_cell_5_deactivation_sim.txt average_cell_2_5_9_sim_data -ascii
save average_cell_9_deactivation_sim.txt average_cell_2_5_9_sim_data -ascii
save average_cell_3_deactivation_sim.txt average_cell_3_sim_data -ascii
save average_cell_4_deactivation_sim.txt average_cell_4_6_sim_data -ascii
save average_cell_6_deactivation_sim.txt average_cell_4_6_sim_data -ascii
save average_cell_7_deactivation_sim.txt average_cell_7_sim_data -ascii
save average_cell_8_deactivation_sim.txt average_cell_8_sim_data -ascii
cd ..
cd ..
cd ..
cd Code