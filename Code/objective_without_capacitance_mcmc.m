function Idiff = objective_without_capacitance_avoiding_leak_mcmc(X0,D,V,noise,model,protocol,model_type,temperature)
% This function defines the objective function to be used in MCMC - this is the same as the objective function
% used during fitting using the CMA-ES algorithm except it does not introduce a penalty on the objective function
% if the proposed parameter set violates the prior - instead in the MCMC algorithm we just assign a zero probability
% of acceptance to such parameter sets and generate a new proposal. We consider the log likelihood throughout the MCMC
% algorithm.
X0=(X0);

sig = noise;
[I,O]=SimulatingData(model_type,protocol,X0',V,temperature);

% Calculates log likelihood removing capacitive spikes from experimental and simulation data
J = [I(1:2499);I(2549:2999);I(3049:4999);I(5049:14999);I(15049:19999);I(20049:29999);I(30049:64999);I(65049:69999);I(70049:end)];
F = [D(1:2499);D(2549:2999);D(3049:4999);D(5049:14999);D(15049:19999);D(20049:29999);D(30049:64999);D(65049:69999);D(70049:end)];


L_I =   -0.5.*length(J)*log((2.*pi).*(sig.^2))-0.5.*(1/((sig)^2))*(sum((F-J).^(2)));


% log likelihood used as output of objective function to be maximised

Idiff=(sum(L_I));

