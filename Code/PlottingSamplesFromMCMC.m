function PlottingSamplesFromMCMC()
% Code used to 95% credible intervals for fits to sine wave protocol from
% 1000 samples from MCMC chain as quoted in Model Calibration Section 2.2
% in the manuscript

model = 'hh';
protocol = {'sine_wave'};
exp_ref = '16713110';
temperature = 21.4;
seed=1;
rand('seed',seed)

[simulated_parameters,model_type] =modeldata(model);
cd ../MCMCResults
pathToFolder = '.';
files = dir(fullfile(pathToFolder,'*'));

C=[];
L=[];

% Identifies MCMC chain and likelihood values for experiment
for i = 1:numel(files)
    
    k = regexp(files(i).name,['MCMCChain_',exp_ref,'_',model,'_',protocol{1}]);
    if k>=1
        C=importdata(files(i).name);
        
        S=files(i).name;
        
        mS = strrep(S, 'MCMCChain', 'MCMCLikelihood');
        
        L=importdata(mS);
    end
end
cd ..


cd Protocols
V=importdata([protocol{1},'_protocol.mat']);
cd ..
[i,v]=max(L);

best= C(v,:);
cd Code
B=SimulatingData(model_type,protocol,best,V,temperature);
for j =1:1000
    
    n=randi(length(C));
    I(:,j)=SimulatingData(model_type,protocol,C(n,:),V,temperature);
    LL(j) = L(n);
    
end

[tmp,ind]=sort(LL);
J=I(ind,:);

% Calculate 95% credible intervals

m=floor(0.025*length(LL));

J=I(:,m:end-m);

plot(max(J,[],2))
hold on
plot(min(J,[],2))
hold on
plot(B,'K')

plot(abs(max(J,[],2)-min(J,[],2)))

% 95% credible interval in absolute terms
max(abs(max(J,[],2)-min(J,[],2)))
% 95% credible interval as percentage of current
max(abs(max(J,[],2)-min(J,[],2))./B)


