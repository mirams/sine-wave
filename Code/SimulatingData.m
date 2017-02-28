function [I,O] = SimulatingData(model_type,protocol,params,V,temperature)
%--------------------------------------------------------------------------------------------------------------------------------------
% In this function the initial conditions are identified for the model type and appropriate MexFunction for model is called (with model parameters
% passed to MexFunction) to simulate current in response to specified protocol.

%Temperature Converted to Kelvins

T = 273.15+temperature;

%Initial conditions for each model (using model type defined in modeldata.m)

if model_type==2||model_type==27||model_type==16||model_type==6
    IC = [0.0,0.0,0.0,0.0];
end
if model_type==13||model_type==19||model_type==10||model_type==11||model_type==15||model_type==30||model_type==24||model_type==35
    IC = [0.0,0.0,0.0];
end
if model_type==5
    IC = [1.0,0.0,0.0,0.0,0.0];
end
if model_type==4
    IC = [1.0,0.0,0.0];
end
if model_type==3||model_type==91||model_type==7||model_type==22||model_type==8||model_type==18||model_type==21||model_type==23||model_type==25||model_type==28||model_type==29||model_type==9||model_type==1||model_type==2999
    
    IC = [0.0];
end
if model_type==12||model_type==20||model_type==26
    IC = [0.0,0.0];
end
%-----------------------------------------------------------------------------------------------------------------------------------------%
% Defines protocol number and protocol length (ms) for each protocol
%-----------------------------------------------------------------------------------------------------------------------------------------%
cd ..
% For non-sine wave protocol the protocol is also passed as additional parameters, avoiding detailed protocol description in Mex function
ProtocolLength = (length(V)/10);
if strcmp(protocol,'sine_wave')==1
    
    protocol_number=1;
end

if strcmp(protocol,'ap')==1
    protocol_number=7;
    cd Protocols
    vv=importdata('ap_protocol.mat');
    cd ..
    temp_con = params(end);
    params = [params(1:end-1),vv',temp_con];
end

if strcmp(protocol,'activation_kinetics_1')==1
    protocol_number=9;
    cd Protocols
    vv=importdata('activation_kinetics_1_protocol.mat');
    cd ..
    temp_con = params(end);
    params = [params(1:end-1),vv',temp_con];
end

if strcmp(protocol,'activation_kinetics_2')==1
    protocol_number=11;
    cd Protocols
    vv=importdata('activation_kinetics_2_protocol.mat');
    cd ..
    temp_con = params(end);
    params = [params(1:end-1),vv',temp_con];
end
if strcmp(protocol,'inactivation')==1
    protocol_number=12;
    cd Protocols
    vv=importdata('inactivation_protocol.mat');
    cd ..
    temp_con = params(end);
    params = [params(1:end-1),vv',temp_con];
end
if strcmp(protocol,'deactivation')==1
    protocol_number=13;
    cd Protocols
    vv=importdata('deactivation_protocol.mat');
    cd ..
    temp_con = params(end);
    params = [params(1:end-1),vv',temp_con];
end
if strcmp(protocol,'steady_activation')==1
    protocol_number=14;
    cd Protocols
    vv=importdata('steady_activation_protocol.mat');
    cd ..
    temp_con = params(end);
    params = [params(1:end-1),vv',temp_con];
end

if strcmp(protocol,'grandi_2hz')==1
    
    protocol_number=18;
    cd Protocols
    vv=importdata('grandi_2hz_protocol.mat');
    cd ..
    temp_con = params(end);
    params = [params(1:end-1),vv',temp_con];
end
if strcmp(protocol,'grandi_fast')==1
    
    protocol_number=19;
    cd Protocols
    vv=importdata('grandi_fast_protocol.mat');
    cd ..
    temp_con = params(end);
    params = [params(1:end-1),vv',temp_con];
end
if strcmp(protocol,'repeated_activation_step')==1
    protocol_number=20;
    cd Protocols
    vv=importdata('repeated_activation_step_protocol.mat');
    cd ..
    temp_con = params(end);
    params = [params(1:end-1),vv',temp_con];
end
cd Code
%-----------------------------------------------------------------------------------------------------------------------------------------%
% Protocol number is added to start of parameter vector to be passed in mex function
%-----------------------------------------------------------------------------------------------------------------------------------------%
params = [protocol_number,params];

%-----------------------------------------------------------------------------------------------------------------------------------------%
% Using the approriate mex function as determined by the model type, the time vector, initial conditions and parameter vector (including the
% initial element being the protocol_number corresponding to the protocol being simulated) is passed to the mex function. The solution X
% is the probability of being in the open/activated state where there is just one vector, or the solutions of the probability of being in
% multiple different activated or the inactivated state where there are multiple solution outputs.
%-----------------------------------------------------------------------------------------------------------------------------------------%
if model_type==1
    X=MexAslanidi([0:0.1:ProtocolLength],IC,params);
    
end


if model_type==13||model_type==19
    X=MexLiu([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==5
    X=MexDiVeroliRT([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==3
    X=MexCourtemanche([0:0.1:ProtocolLength],IC,params);
    
end

if model_type==16
    X=MexMazhari([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==35
    X=MexHH([0:0.1:ProtocolLength],IC,params);
    
end

if model_type==26
    [X1,X2]=MexTenTusscher([0:0.1:ProtocolLength],IC,params);
    X=X1;
end
if model_type==2
    X=MexClancy([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==4
    X=MexDiVeroliPT([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==27||model_type==6
    X=MexWang([0:0.1:ProtocolLength],IC,params);
    
end

if model_type==29||model_type==25
    X=MexShannon([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==2999
    
    X=MexZengTol([0:0.1:ProtocolLength],IC,params);
end

if model_type==7
    X=MexFox([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==8
    X=MexGrandi([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==9
    X=MexHund([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==10
    [X1,X2,X3]=MexInada([0:0.1:ProtocolLength],IC,params);
    X=[X1,X2,X3];
end
if model_type==11
    [X1,X2,X3]=MexKurata([0:0.1:ProtocolLength],IC,params);
    X=[X1,X2,X3];
end
if model_type==12
    [X1,X2]=MexLindblad([0:0.1:ProtocolLength],IC,params);
    X=[X1,X2];
end

if model_type==15
    [X1,X2,X3]=MexMatsuoka([0:0.1:ProtocolLength],IC,params);
    X=[X1,X2,X3];
end
if model_type==18
    X=MexNygren([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==20
    [X1,X2]=MexOHara([0:0.1:ProtocolLength],IC,params);
    X=[X1,X2];
end
if model_type==21
    X=MexPriebe([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==22
    X=MexRamirez([0:0.1:ProtocolLength],IC,params);
end
if model_type==23||model_type==28
    X=MexSeemann([0:0.1:ProtocolLength],IC,params);
    
end
if model_type==24
    [X1,X2,X3]=MexSeveri([0:0.1:ProtocolLength],IC,params);
    X=[X1,X2,X3];
end
if model_type==30
    [X1,X2,X3]=MexZhang([0:0.1:ProtocolLength],IC,params);
    X=[X1,X2,X3];
end
if model_type==2999
    
    X=MexZengTol([0:0.1:ProtocolLength],IC,params);
end
%Calculates reversal potential using Nernst equation to be used in current calculation equation. Temperature, extracellular and intracellular potassium concentration correspond to those used in experiment.

F = 96485;

R = 8314;
K_i = 130;
k_o = 4;

erev = ((R*T)/F)*log(k_o/K_i);

O = ones(length(X),1);

Vr = O.*erev;

%-----------------------------------------------------------------------------------------------------------------------------------------%

% Current calculations.
% For Markov models, current is calculated according to
%                         I = g*O*(V-Vr)
% where the conductance g is the final parameter in the parameter set for each model and O is the probability of being in the open state,
% which corresponds to the solution X for these models.

% Similarly, the current formulation for Hodgkin-Huxley style models is typically of the form
%                         I =  g*Xr*Rr*(V-Vr)
% so for model for which the output of the Mex function X represents Xr*Rr,
% the current can be expressed in the same way as for the Markov model formulations.

if model_type==2||model_type==27||model_type==13||model_type==19||model_type==5||model_type==16||model_type==4||model_type==6||model_type==14||model_type==35
    
    I = params(length(params)).*X.*(V-Vr);
    O=X;
    
end
if model_type==12
    
    I = params(length(params)).*X1.*X2.*(V-Vr);
    
    O=X1.*X2;
end

if model_type==20
    
    Rkr = ones(length(X),1)./((ones(length(X),1)+params(16).*exp((V.*params(17)))).*(ones(length(X),1)+params(18).*exp((V.*params(19)))));
    
    A_fast = ones(length(X),1)./(ones(length(X),1)+params(2).*exp((V.*params(3))));
    
    A_slow = 1-A_fast;
    
    I = params(length(params)).*((A_fast.*X1)+(A_slow.*X2)).*Rkr.*(V-Vr);
    O=((A_fast.*X1)+(A_slow.*X2)).*Rkr;
    
end
if model_type==3||model_type==7
    
    Rkr = ones(length(X),1)./(ones(length(X),1)+params(9).*exp((V.*params(10))));
    
    I=params(length(params)).*(X.*Rkr.*(V-Vr));
    O=X.*Rkr;
end
if model_type==26
    
    I=params(length(params)).*(X1.*X2.*(V-Vr));
    O = X1.*X2;
end
if model_type==18||model_type==21
    
    Rkr = ones(length(X),1)./(ones(length(X),1)+params(8).*exp((V.*params(9))));
    
    I=params(length(params)).*(X.*Rkr.*(V-Vr));
    O=X.*Rkr;
end
if model_type==23||model_type==28
    
    Rkr = ones(length(X),1)./(ones(length(X),1)+params(6).*exp((V.*params(7))));
    
    I=params(length(params)).*(X.*Rkr.*(V-Vr));
    O=X.*Rkr;
end
if model_type==8
    
    Rkr = ones(length(X),1)./(ones(length(X),1)+params(11).*exp((V.*params(12))));
    
    I=params(length(params)).*(X.*Rkr.*(V-Vr));
    O=X.*Rkr;
end
if model_type==9||model_type==25||model_type==29||model_type==2999
    
    Rkr = ones(length(X),1)./(ones(length(X),1)+params(10).*exp((V.*params(11))));
    
    I=params(length(params)).*(X.*Rkr.*(V-Vr));
    O=X.*Rkr;
end
if model_type==1
    
    Rkr = ones(length(X),1)./(ones(length(X),1)+params(7).*exp((V.*params(8))));
    
    I=params(length(params)).*(X.*Rkr.*(V-Vr));
    O=X.*Rkr;
end


if model_type==10
    
    I=params(length(params)).*(params(20).*X1 + (1-params(20)).*X2).*X3.*(V-Vr);
    O=(params(20).*X1 + (1-params(20)).*X2).*X3;
end
if model_type==11
    
    I=params(length(params)).*(params(18).*X1 + (1-params(18)).*X2).*X3.*(V-Vr);
    O=(params(18).*X1 + (1-params(18)).*X2).*X3;
end
if model_type==24
    
    I=params(length(params)).*(params(17).*X1 + ((1-params(17)).*X2)).*X3.*(V-Vr);
    O=(params(17).*X1 + ((1-params(17)).*X2)).*X3;
end
if model_type==15
    
    I=params(length(params)).*(params(22).*X1 + (1-params(22)).*X2).*X3.*(V-Vr);
    O=(params(22).*X1 + (1-params(22)).*X2).*X3;
end
if model_type==22
    
    Rkr = params(10)+(params(11).*ones(length(X),1))./(ones(length(X),1)+params(12).*exp((V.*params(13))));
    
    I=params(length(params)).*(X.*Rkr.*(V-Vr));
    O=X.*Rkr;
end

if model_type==30
    
    I=params(length(params)).*(params(15).*X1 + (1-params(15)).*X2).*X3.*(V-Vr);
    O=(params(15).*X1 + (1-params(15)).*X2).*X3;
end
