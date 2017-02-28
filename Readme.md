# Sinusoidal voltage protocols for rapid characterization of ion channel kinetics: Supplementary Data

In this readme we detail both how all the scripts in this folder are used to generate the results in the paper, and which scripts
are used to collate and plot the data for each figure.

## Experimental Data
The experimental data used in this study is included in [ExperimentalData](ExperimentalData). 
There is a folder corresponding to the data used for each cell (correspondence between file names and cell numbers in paper is provided in [cell_index.txt](ExperimentalData/cell_index.txt)). 
There are additional folders containing the average model data for the sine wave ('average') and one containing the
repeats from the sine wave protocol for each cell ('sine_wave').
All the data traces correspond to leak and dofetilide subtracted data. The full set of raw data traces in both .abf and plain text format can be found at SOMEWHERE.

## CMAES and MCMC Results
To find the best fit to the sine wave experimental data we first run [FullGlobalSearch.m](Code/FullGlobalSearch.m) for each cell and then once we've verified that the CMA-ES algorithm repeatedly returns parameters in the same region of parameter space on multiple different iterations we then run [AdaptiveMCMCStartingBestCMAES.m](Code/AdaptiveMCMCStartingBestCMAES.m) to determine MCMC chains. 

[cmaes.m](Code/cmaes.m) defines the CMA-ES algorithm used for the initial search of the parameter space before running MCMC.

[FullGlobalSearch.m](Code/FullGlobalSearch.m) is run to search the parameter space and identify the best guess parameter set to be used to initialise the MCMC chain.

[AdaptiveMCMCStartingBestCMAES.m](Code/AdaptiveMCMCStartingBestCMAES.m) defines the covariance adaptive MCMC algorithm used.

The contents of [CMAESFullSearchResults](CMAESFullSearchResults) give an example output of CMAES search results to be used for running of the MCMC algorithm (for cell #5).

In [MCMCResults](MCMCResults) there are all the MCMC chains run from fitting each cell's sine wave data to the model as well
as the average model. We include a separate file for each cell for the parameter values in the MCMC chain, the likelihoods 
corresponding to these parameter values and the acceptance rate over the running of the MCMC chain.

[PlottingSamplesFromMCMC.m](Code/PlottingSamplesFromMCMC.m) is used to assess the 95% credible intervals for the fits to the sine wave protocol when taken 1000 samples from the results MCMC parameter distributions. 
This figure is quoted in the text in Model Calibration Section 2.2.

## Voltage Protocols
In [Protocols](Protocols) we include the voltage clamp waveform for each of the protocols. These files include a list 
of times and voltages that comprise the protocol (in mV), with each row corresponding to a 0.1 ms timestep (10kHz samples).

## Model Parameters and Equations
The parameter values for each model are included in [ParameterSets](ParameterSets). Note that in each parameter set the final parameter is the conductance parameter which has been set to 0.1 for all models. This value is irrelevant as we scale the literature model simulations to either a simulated or experimental reference trace when plotting these model simulations or using them for comparison.

For each model (or sets of models which share the same model structure and only vary in their parameterisations) there is
a Mex file detailing the set of equations which define that model. For example [MexWang.c](Code/MexWang.c) is used to simulate the Wang et al. 1997 model. The appropriate Mex file is called when SimulatedData.m is run.

If any changes to Mex files are made these must be recomplied using:

`mex -I/path_to_CVODE/include -L/path_to_CVODE/lib -lsundials_nvecserial -lsundials_cvode MexFilename.c`

[modeldata.m](Code/modeldata.m) defines the model_type for each model (to determine which Mex file should be used for each model simulation) and also identifies the appropriate parameter set in [ParameterSets](ParameterSets) to be used when simulating each model.

## Synthetic Data
In [SimulatedData](SimulatedData) we have the simulated data trace from the maximum likelihood parameters identified from fitting 
to experimental data for cell 5. This data trace was produced using [ProducingSimulatedDataWithNoise.m](Code/ProducingSimulatedDataWithNoise.m). We use this data 
to produce the simulated data trace MCMC distributions shown in Figure C5. 

In [MCMCResultsSimulated](MCMCResultsSimulated) there is the MCMC chain (and likelihood and acceptancerate files) for the synthetic data study results shown in Figure C5.

## Averaged Model
[CreatingAveragedModel.m](Code/CreatingAveragedModel.m) creates the 'averaged' sine wave data which was used to fit the average model for comparison of 
cell-specific vs. average model predictions.

### Scripts for Generating Data in and Plotting Figures
Code to generate and plot data in each figure:

- Figure 1 - run [PlottingFigure1AllModels.m](Code/PlottingFigure1AllModels.m)
- Figure 2 - to produce Figure 2 run [PlottingFigure2.m](Code/PlottingFigure2.m) to generate the data for the figure then [plot_figure_2_results.py](Figures/figure_2/plot_figure_2_results.py).
- Figure 3 - run [PlottingFigure3TrainingFigure.m](Code/PlottingFigure3TrainingFigure.m) to produce data for figure 3a, figure 3b is contained in [Figures/figure3](Figures/figure3) and data for figure 3c is in [Figures/figure_3_c](Figures/figure_3_c). Figure 3 is plotted as in the manuscript using [plot_figure_3_results.py](Figures/figure_3/plot_figure_3_results.py).
- Figure 4 - run [Figure4TraditionalVoltageSteps.m](Code/Figure4TraditionalVoltageSteps.m) and [PlottingSteadyActivationPeakCurrentCurves4.m](Code/PlottingSteadyActivationPeakCurrentCurves4.m) and to generate data for the figure. 
  The data for the time constant voltage relationships for deactivation, recovery from inactivation and instantaneous inactivation were fitted manually and so their data can be found in the respective folders in [Figures/figure_4](Figures/figure_4). Run [plot_figure_4_results.py](Figures/figure_4/plot_figure_4_results.py) to produce figure 4.
- Figure 5 - run [PlottingFigure5APFigure.m](Code/PlottingFigure5APFigure.m) to generate data for Figure 5 and plot results using [plot_figure_5_results.py](Figures/figure_5/plot_figure_5_results.py)
- Figure 6 - run [GettingAllParameters.m](Code/GettingAllParameters.m) to collate the best fitting parameters for each cell and average cell model for plotting Figure 6A. Data for Figure 6B is generated by [PlottingSteadyActivationPeakCurrentCurves6b.m](Code/PlottingSteadyActivationPeakCurrentCurves6b.m) and then [PlottingSmallMultiplesSteadyActivation.m](Code/PlottingSmallMultiplesSteadyActivation.m). Figure 6 is plotted by running [plot_figure_6_results.py](Figures/figure_6/plot_figure_6_results.py)
- Figure C5 - run [PlottingMCMCNormalisedPDFs.m](Code/PlottingMCMCNormalisedPDFs.m)
- Table D2-D10:
  - run [CalculatingGoodnessofFitSineWave.m](Code/CalculatingGoodnessofFitSineWave.m) to generate column 1 . 
  - run [CalculatingGoodnessofFitActionPotential.m](Code/CalculatingGoodnessofFitActionPotential.m) to generate column 2
  - run [CalculatingGoodnessofFitSteadyActivation.m](Code/CalculatingGoodnessofFitSteadyActivation.m) to generate column 3
  - run [CalculatingGoodnessofFitSteadyDeactivation.m](Code/CalculatingGoodnessofFitSteadyDeactivation.m) to generate column 4
  - run [CalculatingGoodnessofFitSteadyInactivation.m](Code/CalculatingGoodnessofFitSteadyInactivation.m) to generate column 5
  - heat map plot form of table is generated by running `results_to_latex_tables.m <file>` for each cell (found in [Figures/table_d_2_to_d_10](Figures/table_d_2_to_d_10))
- Figure E6 - 
  run [PlottingActivationKinetics1NormalisedPeakSine.m](Code/PlottingActivationKinetics1NormalisedPeakSine.m)
  run [PlottingActivationKinetics2NormalisedPeakSine.m](Code/PlottingActivationKinetics2NormalisedPeakSine.m)
- Table F11 - parameters corresponding to maximum likelihoods from MCMC chains in MCMCResults - these can be generated by running [GettingAllParameters.m](Code/GettingAllParameters.m).
  Note that we need to take the transpose of the output from this script to get the parameters in the format as in Table F11.
- Figure F7 - Plots of MCMC distributions from [MCMCResults](MCMCResults) (with first 50000 interations discarded as burn in). Figure plotted by running [plot_figure_all_cell_param_pdfs.py](Figures/figure_f_7/plot_figure_all_cell_param_pdfs.py) 
- Table F12:
  run CalculatingGoodnessofFitSineWave.m to generate column 3 and 4
  run CalculatingGoodnessofFitActionPotential.m to generate column 5 and 6
  run CalculatingGoodnessofFitSteadyActivation.m to generate column 7 and 8
  run CalculatingGoodnessofFitSteadyDeactivation.m to generate column 9 and 10
  run CalculatingGoodnessofFitSteadyInactivation.m to generate column 11 and 12
  Note that the exp_ref is required to run each of these functions, which corresponds to the experimental number of each cell (which can be found in ExperimentalData/cell_index.txt.
  To generate the leak resistance in column 2 we compared the resistance value identified when leak subtracting the vehicle repeat of the sine wave and the sine wave recording in the
  presence of dofetilide (as detailed in ManualLeakSubtraction.m) for each experiment. heat map form of table is generated by running results_to_latex_tables.m (found in Figures/table_f_12). 
- Figure F8 - Data is generated by [PlottingSmallMultiplesDeactivationWeightedTau.m](Code/PlottingSmallMultiplesDeactivationWeightedTau.m)
- Figure F9 - Data is generated by [PlottingSmallMultiplesRecoveryInactivation.m](Code/PlottingSmallMultiplesRecoveryInactivation.m)
- Figure F10 - Data is generated by [PlottingSmallMultiplesInstantaneousInactivation.m](Code/PlottingSmallMultiplesInstantaneousInactivation.m)
  To plot figures F8-F10 run [plot_figures_F8_to_F10.py](Figures/figure_f8_to_f10/plot_figures_F8_to_F10.py)

## Additional Notes

Any remaining `.m` files not described in this document are used within the individual scripts described above with a note within each script about their use.

Note that the Zeng model contained singularities and was unable to simulate our action potential protocol (Pr6) in its
original form, so whenever the action potential waveform is simulated we use a version of the Zeng et al. model where
the singularities have been removed (as in MexZengTol.c).

We also note that the leak subtracted dofetilide subtracted experimental traces for the activation kinetics protocols for cells 3, 4 and 7 (16708016, 16708060 and 16704007) appear to be over leak subtracted when we use the same leak resistance values identified for appropriately leak subtracting the sine wave trace for these cells. The activation kinetics protocols are performed at the very start of the protocol sequence so we may expect some change in leak resitance by the time the sine wave protocol is performed. As we do not use the activation kinetics data for these cells and the remaining protocols appear to be appropriately leak subtracted using the leak resistance values identified for each cell from the sine wave protocol, we do not adjust the leak resistance for activation kinetics data.

A final point to note is that when comparing our input voltage protocol with the command voltage recorded in the results file
output from the pClamp10 software, we observed a time shift of one sample period (0.1 ms) in the applied protocol to that
recorded in experiment. This shift was consistent in all recordings, and is likely due to a timing offset in the digitizer. To account for this observation, to ensure the use of recorded currents and correct corresponding applied voltage, we 
applied a time shift of 0.1 ms to the input protocol when performing simulations for comparison with experimental data.
