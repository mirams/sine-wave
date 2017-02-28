function D= ProducingSimulatedDataWithNoise()
% In this script we produce the simulated data used to generate the results of the synthetic data study shown in Figure C5

protocol={'sine_wave'};
model='hh';

[P,model_type] = modeldata(model);
[chain,likelihood] = FindingBestFitsAfterMCMC('hh',{'sine_wave'},'16713110');

[i,v]= max(likelihood);

P= chain(v,:);
%First identify appropriate level of noise to add to simulated data by comparison with experiment
std_scale = CalculatingScalingFactorAndNoise(protocol{1},model,P);

% Import protocol
cd ../Protocols
V=importdata([protocol{1},'_protocol.mat']);
cd ..
cd Code
% Simulated model
[I,O]=SimulatingData(model_type,protocol{1},P,V,21.4);

% Add normally distributed noise with mean 0 and std as identified
N=normrnd(0,std_scale,[length(I),1]);

D = I + N;
cd ..
% Commented out saving simulated data trace to avoid overwritting the simulated trace used in the manuscript
%cd  SimulatedData
%save([protocol{1},'_',model,'_simulated.mat'],'D')
%cd ..
cd Code