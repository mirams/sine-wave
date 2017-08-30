function Idiff = objective_without_capacitance(X0,D,V,noise,model,protocol,model_type,temperature)

% Checks the conditions for model parameters described in the prior are not violated - if they are the parameter set
% is not simulated and the likelihood is instead penalised.
S=1;

% Undo log transform parameters before simulation
X0=10.^(X0);

% Determine maximum transition rate and check conditions and either penalise likelihood (maximum transition out of required range) or simulate model
r = CheckingRanges(X0,model,V);

if r>1000||r<1.67e-5
    
    S=0;
end
L_I = -1e25;
penal = 1e25;

% If maximu transition within require range simulate model and calculate log-likelihood
if S==1
    sig = noise;
    [I,O]=SimulatingData(model_type,protocol{1},X0',V,temperature);
    
    % Calculate log likelihood first removing capactive spikes from experimental and simulation traces to ensure that these artefacts
    % do not adversely affect fitting to the current trace.
    J = [I(1:2499);I(2549:2999);I(3049:4999);I(5049:14999);I(15049:19999);I(20049:29999);I(30049:64999);I(65049:69999);I(70049:end)];
    F = [D(1:2499);D(2549:2999);D(3049:4999);D(5049:14999);D(15049:19999);D(20049:29999);D(30049:64999);D(65049:69999);D(70049:end)];
    
    L_I =   -0.5.*length(J)*log((2.*pi).*(sig.^2))-0.5.*(1/((sig)^2))*(sum((F-J).^(2)));
    
end
% Penalties are imposed so that points further away from the prior are more heavily weighted, to aid the search path back to satisfy the required conditions
if S==0
    
    for j= 1:size(protocol,2)
        
        
        L_I(j)=-10^25;
        
        if r>=1000
            
            L_I(j) = L_I(j)*penal*abs(r-1000);
            
            
        end
        
        
        
        if r<=1.67e-5
            
            L_I(j) = L_I(j)*penal*abs(1.67e-5-r);
            
        end
        
    end
end

% negative log likelihood used as output of objective function to be minimised

Idiff=-(sum(L_I));

