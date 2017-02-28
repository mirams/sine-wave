function xvec=FullGlobalSearch(seed,exp_ref)
% Script which runs CMA-ES algorithm to determine best starting points for MCMC.
% Algorithm is repeated 25 times as indicated below so that different areas of
% parameter space are explored. We are satisfied that the best points of parameter
% space have been identified when same parameter sets are consistently recovered
% from different iterations of CMA-ES algorithm. The identity of the parameter sets
% identified by CMA-ES are later confirmed to be global optima after further exploring
% parameter space with MCMC.

model = 'hh';
protocol = {'sine_wave'};

% assigns temperature according to experiment
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

% Determines model type
[simulated_parameters,model_type] =modeldata(model);


% Imports protocol
cd ../Protocols/
V = importdata([protocol{1},'_protocol.mat']);

cd ..
% Imports experimental data
cd ExperimentalData/

cd(num2str(exp_ref))
D= importdata([protocol{1},'_',exp_ref,'_dofetilide_subtracted_leak_subtracted.mat']);

cd ..
cd ..
cd Code
% Estimates noise from first 200 ms of experimental data - in this section the holding potential is at -80 mV
% and so the channel would be expected to be closed with no current flowing.
noise = std(D(1:2000));

rand('seed',seed)

opts = cmaes;
opts.Seed = seed;

% Repeat CMA-ES search 25 times (or may interrupt when consistently retrieving parameters in same area of parameter space)
for m = 1:25
    
    % Retrieve upper (UB) and lower (LB) bounds for each parameter and generate intial guess X0 from priors
    [X0,LB,UB]=sampling_prior(model,exp_ref);
    
    % In addition to sampling according to the defined prior, in addition we start one initial guess off from
    % the parameter sets saved in ParameterSets as well as a few guesses where parameters are sampled uniformly
    % from [1e-7,0.1] (the range within which the majority of kinetic model parameters are found in literature models)
    % These extra points were used as additional starting points to try to ensure that the global optimum parameter set was identified.
    if m==1
        
        X0 = simulated_parameters;
        
    end
    if m>10&&m<=15
        
        X0=(0.1-1e-7).*rand(length(X0),1)+1e-7;
    end
    
    X0(end) = (UB(end)-LB(end)).*rand(1,1)+LB(end);
    
    % We log transform parameters for CMA-ES search
    X0=log10(X0);
    
    % Set CMA-ES variables. Don't need to define sigma0 in CMA-ES search because we have defined upper and lower bounds on parameters
    sigma0=[];
    
    opts.TolFun = 1e-4;
    opts.LBounds = log10(LB');
    opts.UBounds = log10(UB');
    opts.PopSize = (4 + floor(3*log(length(X0))));
    
    % Call to CMA-ES. Our objective function is defined in objective_without_capacitance.m and excludes the capacitive sections of the current traces during fitting
    % to ensure that these artefacts do not adversely effect the fitting to the current trace.
    [X1, val1, COUNTEVAL, STOPFLAG, OUT, BESTEVER] = cmaes('objective_without_capacitance', X0, sigma0, opts, D, V,noise,model, protocol, model_type, temperature);
    % Convert parameters back to non-log transformed
    X_best=10.^(BESTEVER.x);
    V_best = BESTEVER.f;
    xvec(m,:) = X_best;
    
    xval(m,1) = V_best;
    
    % Saves search results
    cd ..
    cd CMAESFullSearchResults
    
    filename1 = ['FullGlobalSearchParams_',exp_ref,'_',model,'_',protocol{1},'_protocol_',num2str(seed),'.mat'];
    filename2 = ['FullGlobalSearchVals_',exp_ref,'_',model,'_',protocol{1},'_protocol_',num2str(seed),'.mat'];
    
    save(filename1,'xvec');
    save(filename2,'xval');
    cd ..
cd Code
end

