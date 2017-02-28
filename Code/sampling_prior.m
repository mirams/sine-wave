function [X0,LB,UB] =sampling_prior(model,exp_ref)
% In this function we generate initial guesses X0 for CMA-ES according to prior and define upper
% and lower bounds on parameters to be used during CMA-ES search.
%Lower and upper bounds on conductance parameter as estimated from experimental data
if strcmp(exp_ref,'16708118')==1
    lower_conductance = 0.0170;
end
if strcmp(exp_ref,'16704047')==1
    lower_conductance = 0.0434;
end
if strcmp(exp_ref,'16704007')==1
    lower_conductance = 0.0886;
end

if strcmp(exp_ref,'16707014')==1
    lower_conductance = 0.0203;
end
if strcmp(exp_ref,'16708060')==1
    lower_conductance = 0.0305;
end
if strcmp(exp_ref,'16708016')==1
    lower_conductance = 0.0417;
end
if strcmp(exp_ref,'16713110')==1
    lower_conductance = 0.0612;
end
if strcmp(exp_ref,'16713003')==1
    lower_conductance = 0.0478;
end
if strcmp(exp_ref,'16715049')==1
    lower_conductance = 0.0255;
end
if strcmp(exp_ref,'average')==1
    lower_conductance = 0.0410;
end
upper_conductance= 10.*lower_conductance;

%Parameter priors
upper_alpha = 1e3;
lower_alpha = 1e-7;

upper_beta = 0.4;
lower_beta = 1e-7;

%Inital guesses and upper and lower bounds

if strcmp(model,'hh')==1
    X0= rand(9,1);
    X0([2,4,6,8])=(upper_beta-lower_beta).*X0([2,4,6,8])+lower_beta;
    X0([1,3,5,7])=10.^((10).*X0([1,3,5,7])+-7.*ones(length(X0([1,3,5,7])),1));
    X0(9)=(upper_conductance-lower_conductance).*X0(9)+lower_conductance;
    
    UB=[upper_alpha,upper_beta,upper_alpha,upper_beta,upper_alpha,upper_beta,upper_alpha,upper_beta,upper_conductance];
    LB =[lower_alpha,lower_beta,lower_alpha,lower_beta,lower_alpha,lower_beta,lower_alpha,lower_beta,lower_conductance];
end

