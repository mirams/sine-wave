function PlottingFigure1AllModels()
% This script plots Figure 1A in the manuscript
temperature=21.5;
% All models included for comparison
Models = {'aslanidi','clancy','courtemanche','diveroli_pt','diveroli_rt','fink','fox','grandi','hund','inada','kurata','lindblad','liu','lu','matsuoka','mazhari','nygren','oehmen','ohara','priebe','ramirez','seemann','severi','shannon','tentusscher','wang','winslow','zeng','zhang'};
%Repeated activation step protocol
% Imports voltage protocol
cd ../Protocols/
V = importdata(['repeated_activation_step_protocol.mat']);
cd ..
subplot(2,3,1)
plot([0:0.1:(length(V)/10)-0.1],V,'k')

xlim([0,(length(V)/10)-0.1]);
set(gca,'FontSize',16)
xlabel('Time (ms)')
ylabel('Voltage (mV)')
cd Code
% Simulates current from each model in the Models vector
N=length(Models);
for i=1:N
    % Imports simulated parameters for each model and model type
    [simulated_parameters,model_type] =modeldata(Models{i});
    % We simulate each model with a conductance value of 1
    simulated_parameters(end)=1;
    k=simulated_parameters;
    
    I(:,i) = SimulatingData(model_type,{'repeated_activation_step'},k,V,temperature);
    
end

% Plots each current trace
cc=jet(length(Models));

subplot(2,3,4)

hold on;

for i=1:length(Models)
    
    plot([0:0.1:(length(V)/10)-0.1],I(:,i),'color',cc(i,:))
end

xlim([0,(length(V)/10)-0.1]);
set(gca,'FontSize',16)
xlabel('Time (ms)')
ylabel('Normalised Current')
I=[];

% Healthy action potential protocol (created by simulating the Grandi et al. 2010 model at 2hZ pacing frequency)
cd ../Protocols/
V = importdata(['grandi_2hz_protocol.mat']);
cd ..
subplot(2,3,2)
plot([0:0.1:(length(V)/10)-0.1],V,'k')
xlim([0,(length(V)/10)-0.1]);


xlim([9500,10000])
set(gca,'XTick',[9500:100:10000])
set(gca,'XTickLabel',['0  ';'100';'200';'300';'400';'500'])
set(gca,'FontSize',16)
xlabel('Time (ms)')
ylabel('Voltage (mV)')

xlim([9500,10000])
set(gca,'XTick',[9500:100:10000])
set(gca,'XTickLabel',['0  ';'100';'200';'300';'400';'500'])
cd Code
% Simulates current from each model in the Models vector
N=length(Models);
for i=1:N
    
    % Imports simulated parameters for each model and model type
    [simulated_parameters,model_type] =modeldata(Models{i});
    simulated_parameters(end)=1;
    k=simulated_parameters;
    
    I(:,i) = SimulatingData(model_type,{'grandi_2hz'},k,V,temperature);
    
end


% Plots each current trace
cc=jet(length(Models));
subplot(2,3,5)

hold on;

for i=1:length(Models)
    
    plot([0:0.1:(length(V)/10)-0.1],I(:,i),'color',cc(i,:))
end

xlim([9500,10000])
set(gca,'XTick',[9500:100:10000])
set(gca,'XTickLabel',['0  ';'100';'200';'300';'400';'500'])
set(gca,'FontSize',16)
xlabel('Time (ms)')
ylabel('Normalised Current')

% Arrhythmic action potential protocol (created by fast pacing of the Grandi et al. 2010 action potential protocol to produce arrhythmic behaviours)
cd ../Protocols/
V = importdata(['grandi_fast_protocol.mat']);
cd ..
I=[];
subplot(2,3,3)
plot([0:0.1:(length(V)/10)-0.1],V,'k')
xlim([9500,10000])
set(gca,'XTick',[9500:100:10000])
set(gca,'XTickLabel',['0  ';'100';'200';'300';'400';'500'])
set(gca,'FontSize',16)
xlabel('Time (ms)')
ylabel('Voltage (mV)')
cd Code
% Simulates current from each model in the Models vector
N=length(Models);
for i=1:N
    
    % Imports simulated parameters for each model and model type
    [simulated_parameters,model_type] =modeldata(Models{i});
    simulated_parameters(end)=1;
    k=simulated_parameters;
    
    I(:,i) = SimulatingData(model_type,{'grandi_fast'},k,V,temperature);
    
end


% Plots each current trace
cc=jet(length(Models));


subplot(2,3,6)

hold on;

for i=1:length(Models)
    
    plot([0:0.1:(length(V)/10)-0.1],I(:,i),'color',cc(i,:))
end
xlim([9500,10000])
set(gca,'XTick',[9500:100:10000])
set(gca,'XTickLabel',['0  ';'100';'200';'300';'400';'500'])
set(gca,'FontSize',16)
xlabel('Time (ms)')
ylabel('Normalised Current')
