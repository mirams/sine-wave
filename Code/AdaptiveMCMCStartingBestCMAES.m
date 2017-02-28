function AdaptiveMCMCStartingBestCMAES(seed,exp_ref)
% Adaptive MCMC algorithm used to generate MCMC chains.
% The algorithm uses the maximum likelihood parameter set identified by the CMA-ES
% algorithm (which we ensure has consistently identified the maximum likelihood
% region of parameter space prior to running MCMC chain).
model = 'hh';
protocols = {'sine_wave'};
%Retrieves correct temperature for experiment exp_ref
if strcmp(exp_ref,'16708016')==1
    
    temperature = 21.8;
    
end
if strcmp(exp_ref,'16708060')==1
    
    temperature = 21.7;
    
end

if strcmp(exp_ref,'16704047')==1
    temperature = 21.6;
    
end
if strcmp(exp_ref,'16704007')==1
    
    temperature = 21.2;
    
end

if strcmp(exp_ref,'16713003')==1
    
    temperature = 21.3;
    
end

if strcmp(exp_ref,'16713110')==1||strcmp(exp_ref,'16715049')==1
    
    temperature = 21.4;
    
end
if strcmp(exp_ref,'16707014')==1
    
    temperature = 21.4;
    
end
if strcmp(exp_ref,'16708118')==1
    
    temperature = 21.7;
    
end

% Identifies appropriate model type to use during simulation
[simulated_parameters,model_type] =modeldata(model);

% Import protocol and experimental data

cd ../Protocols/
V = importdata([protocols{1},'_protocol.mat']);
cd ..
cd ExperimentalData
cd(exp_ref)

D= importdata([protocols{1},'_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);

cd ..
cd ..
cd Code
% Standard deviation calculated from initial section of protocol which is held -80mV (and the current would be expected to be 0)
noise = std(D(1:2000));
rand('seed',seed);

% retrieve upper and lower bounds for parameters according to priors
[zz,LB,UB]=sampling_prior(model,exp_ref);

% Identify maximum likelihood parameters (in practice minimising negative log-likelihood) from CMA-ES algorithm results
[P_asc,V_asc] = FindingBestFits(model,protocols,exp_ref);

k = P_asc(1,:);


X0=(k);

k=X0;

% Calculate initial log likelihood using each protocol
% As in parameter search using CMA-ES, in the objective function we exclude the capacitive spikes to ensure
% these don't adversely affect the fitting to the sine wave current
L_init = objective_without_capacitance_mcmc((X0)',D,V,noise,model,protocols{1},model_type,temperature)

L_can = (L_init);


% To keep track of acceptance rate
a=0;

% Initial covariance is identity matrix with diagonal entries proportional to the magnitude of each parameter.
cov_0=eye(length(k));
for i = 1:length(k)
    cov_0(i,i)=(abs(k(i)));
end

cov_m=cov_0;
mu= (X0);

% Scaling factor initialised to 1 so that when the adaption to the scaling factor begins the log(s) value in the expression is 0.
s=1;

d=log(s);

% Initialise cov_m_t and mu for recursive calculation of covariance
cov_m_t=cov_0;

% Start of MCMC chain which is run for 25000 iterations
Y0=(X0);

for j = 1:1:250000
    
    % Generate proposal parameter set from multivariate normal distribution
    
    
    k2= mvnrnd(Y0',(s.*cov_m));
    
    % Check the conditions of the prior are satisfied - if they are then Q=1 is returned and MCMC continues, if not then Q=0 is returned and the parameter set is immediately assigned a probability of 0 (without simulating) and the previous parameter set is recored in the MCMC chain and a new proposal generated.
    
    r = CheckingRanges(k2,model,V);
    
    
    if r>1000||r<1.67e-5||any(k2>UB)==1||any(k2<LB)==1
        Q=0;
    else
        Q=1;
    end
    
    if Q==0
        E=0;
    else
        
        
        % Current simulated using proposed parameter set and log likelihood calculated for each protocol
        
        
        L_can_21 = objective_without_capacitance_mcmc((k2)',D,V,noise,model,protocols{1},model_type,temperature);
        
        
        L_can_2=(L_can_21);
        
        
        % Acceptance probability E of the proposed parameter set calculated
        
        E=min(1,exp(L_can_2-L_can));
        
        % If the proposed parameter set is accepted, the new parameters are recorded in the MCMC chain. If the parameter set is rejected then the previous parameter set is repeated again in the MCMC chain.
        if E>rand
            
            
            L_can = L_can_2;
            
            Y0=k2;
            a=a+1;
            
            
        end
    end
    
    % Rate of acceptance over the whole chain monitored, as well as the entries in the MCMC chain and the log likelihood associated with each entry and the overall acceptance rate
    racc=(a)/(j);
    
    M(j,:) = Y0;
    MM(j,:) = Y0;
    U(j,1) = L_can;
    R(j,1)= racc;
    
    % Recursive calculation of covariance to be used when covariance adaptation begins
    
    cov_m_t = ((1-((j+1)^-0.7)).*cov_m_t) + ((j+1)^-0.7).*((Y0-mu)'*(Y0-mu));
    mu =   ((1-((j+1)^-0.7)).*mu) + ((j+1)^-0.7).*(Y0);
    
    % Adpative MCMC with the covariance matrix used to generate the proposal and the scaling factor of the covariance matrix updated on each iteration.
    cov_m = cov_m_t;
    
    d=d+(((j+1)^-0.7)*(E-0.234));
    
    s=exp(d);
    
    
    
    % The MCMC Chain, log-likelihoods and acceptance rates written to file
    if mod(j,1000)==0
        
        cd ../MCMCResults
        
        filename1=['MCMCChain_',exp_ref,'_',model,'_',protocols{1},'_',num2str(seed),'.mat'];
        filename2=['MCMCLikelihood_',exp_ref,'_',model,'_',protocols{1},'_',num2str(seed),'.mat'];
        filename3=['MCMCAcceptance_',exp_ref,'_',model,'_',protocols{1},'_',num2str(seed),'.mat'];
        save(filename1,'MM');
        save(filename2,'U');
        save(filename3,'R');
        cd ..
	cd Code
    end
end
