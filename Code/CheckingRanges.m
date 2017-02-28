function r = CheckingRanges(parameters,model,V)
% In this function the maximum and minimum voltages in the protocol are identified and the maximum transition rate over the voltage range
% for the given parameter set is calculated. This maximum rate is then used to check whether the parameter set allows the maximum
% transition rate to fall within the required defined range.
U=[max(V);min(V)];
params=parameters;
a=1;

% Defines transition rates for model and maximum rate identified
if strcmp(model,'hh')==1
    for i=1:length(U)
        v=U(i);
        alpha_1(a) = params(1)*exp(params(2)*v);
        beta_1(a) = params(3)*exp(-params(4)*v);
        alpha_2(a) = params(5)*exp(params(6)*v);
        beta_2(a) = params(7)*exp(-params(8)*v);
        
        a=a+1;
        
    end
    r = max([alpha_1,alpha_2,beta_1,beta_2]);
    
end















