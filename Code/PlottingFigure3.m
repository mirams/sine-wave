function PlottingFigure3()
% This script produces the data to plot Figure 3, which is then used in Figures/figure_3/plot_figure_3_results.py to plot the figure
% Plots sine wave voltage protocol, simulations in response to sine wave protocol from each literature model and experimental recordings from sine wave protocol
protocol='sine_wave';
temperature = 21.5; % Temperature corresponds to mean of experiment temperatures
% All literature models
Models = {'aslanidi','clancy','courtemanche','diveroli_pt','diveroli_rt','fink','fox','grandi','hund','inada','kurata','lindblad','liu','lu','matsuoka','mazhari','nygren','oehmen','ohara','priebe','ramirez','seemann','severi','shannon','tentusscher','wang','winslow','zeng','zhang'};

% Imports voltage protocol

cd ../Protocols/
V = importdata([protocol,'_protocol.mat']);
cd ..
cd Code
% Simulates currents from each model in the Models vector
N=length(Models);
for i=1:N
    % Imports simulated parameters for each model and identifies model type to be used to simulate
    % appropriate mex file in SimulatingData.m
    [simulated_parameters,model_type] =modeldata(Models{i});
    k=simulated_parameters;
    
    I(:,i) = SimulatingData(model_type,protocol,simulated_parameters,V,temperature);
end

% Normalises the current trace from each literature model to the first trace in the
% current vector as a reference trace by calculating a scaling factor which minimises
% the absolute difference between each simulated trace and the reference trace.

c=0;
J(:,1) = I(:,1);
for a = 0.000001:0.01:10
    c=c+1;
    for j= 2:N
        Diff(j,c) = sum(abs(I(:,1)-a.*I(:,j)))./length(I);
    end
end

% Identifies scaling factor for each trace
for j = 2:N
    
    [i(j),v(j)]=min((Diff(j,:)));
    
    s(j) = v(j)*0.01+0.000001;
    
    J(:,j) = s(j).*I(:,j);
end


cd ../Figures/figure_3/figure_3_data
model_data=[[0:0.0001:(length(V)/10000)-0.0001]',J];
save figure_3_sine_wave_model_data.txt model_data -ascii
cd ..
cd ..
cd ..
J=[];

% Import all experimental data traces for the sine wave protocol
cd ExperimentalData
cd(protocol)
pathToFolder = '.';
files = dir(fullfile(pathToFolder,'*.mat'));

for i=1:numel(files)
    D(:,i)=importdata(files(i).name);
    E(:,i) = D(30100:65000,i);
end

% Normalises the current trace from each experiment to a reference trace (the trace
% with the peak current during the sine wave section) by calculating a scaling factor
% which minimises the absolute difference between each experimental trace and the reference
% trace.

% identify trace with peak current
[vv,ii] =max(max(E(:)));
col = ii;
J(:,1) = D(:,col);
col
% Identify scaling factor for each experimental trace (with experimental
% trace with peak current used as reference trace)
c=0;
for a=0.01:0.001:10
    c=c+1;
    for j = 1:numel(files)
        if j~=col
            Diff(j,c) = sum(abs(D(:,col)-a.*D(:,j)))./length(D);
        end
    end
end

for j = 1:numel(files)
    if j~=col
        [i(j),v(j)] = min(Diff(j,:));
        s(j) = v(j)*0.001+0.01;
        J(:,j) = s(j).*D(:,j);
    end
    if j==col
        
        J(:,j) = D(:,col);
    end
end
cd ..
cd ..
cd Figures/figure_3/figure_3_data
experimental_data=[[0:0.0001:(length(V)/10000)-0.0001]',J];
save figure_3_sine_wave_experimental_data.txt experimental_data -ascii
cd ..
cd ..
cd ..

cd Figures/figure_3/figure_3_data
protocol_data=[[0:0.0001:(length(V)/10000)-0.0001]',V];
save figure_3_sine_wave_protocol.txt protocol_data -ascii
cd ..
cd ..
cd ..
cd Code
