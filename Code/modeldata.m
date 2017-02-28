function [simulated_parameters,model_type]=modeldata(model)
cd ..
% For each model a model_type is assigned to determine which Mex function is
% used in SimulatingData.m. The corresponding parameter set (in ParameterSets)
% for each model is also accessed.

if strcmp(model,'aslanidi')==1
    cd ParameterSets/
    simulated_parameters=importdata('AslanidiModelSimulatedParameters.mat');
    model_type = 1;
    cd ..
end
if strcmp(model,'clancy')==1
    cd ParameterSets/
    simulated_parameters=importdata('ClancyModelSimulatedParameters.mat');
    model_type = 2;
    cd ..
end

if strcmp(model,'wang')==1
    cd ParameterSets/
    simulated_parameters=importdata('WangModelSimulatedParameters.mat');
    model_type = 27;
    cd ..
end

if strcmp(model,'fink')==1
    cd ParameterSets/
    simulated_parameters=importdata('FinkModelSimulatedParameters.mat');
    model_type = 6;
    cd ..
end
if strcmp(model,'liu')==1
    cd ParameterSets/
    simulated_parameters=importdata('LiuModelSimulatedParameters.mat');
    model_type = 13;
    cd ..
end

if strcmp(model,'oehmen')==1
    cd ParameterSets/
    simulated_parameters=importdata('OehmenModelSimulatedParameters.mat');
    model_type = 19;
    cd ..
end

if strcmp(model,'diveroli_rt')==1
    cd ParameterSets/
    simulated_parameters=importdata('DiVeroliRTModelSimulatedParameters.mat');
    model_type = 5;
    cd ..
end

if strcmp(model,'mazhari')==1
    cd ParameterSets/
    simulated_parameters=importdata('MazhariModelSimulatedParameters.mat');
    model_type = 16;
    cd ..
end

if strcmp(model,'courtemanche')==1
    cd ParameterSets/
    simulated_parameters=importdata('CourtemancheModelSimulatedParameters.mat');
    model_type = 3;
    cd ..
end

if strcmp(model,'fox')==1
    cd ParameterSets/
    simulated_parameters=importdata('FoxModelSimulatedParameters.mat');
    model_type = 7;
    cd ..
end
if strcmp(model,'diveroli_pt')==1
    cd ParameterSets/
    simulated_parameters=importdata('DiVeroliPTModelSimulatedParameters.mat');
    model_type = 4;
    cd ..
end

if strcmp(model,'ramirez')==1
    cd ParameterSets/
    simulated_parameters=importdata('RamirezModelSimulatedParameters.mat');
    model_type = 22;
    cd ..
end
if strcmp(model,'grandi')==1
    cd ParameterSets/
    simulated_parameters=importdata('GrandiModelSimulatedParameters.mat');
    model_type = 8;
    cd ..
end
if strcmp(model,'hund')==1
    cd ParameterSets/
    simulated_parameters=importdata('HundModelSimulatedParameters.mat');
    model_type = 9;
    cd ..
end

if strcmp(model,'inada')==1
    cd ParameterSets/
    simulated_parameters=importdata('InadaModelSimulatedParameters.mat');
    model_type = 10;
    cd ..
end
if strcmp(model,'kurata')==1
    cd ParameterSets/
    simulated_parameters=importdata('KurataModelSimulatedParameters.mat');
    model_type = 11;
    cd ..
end

if strcmp(model,'lindblad')==1
    cd ParameterSets/
    simulated_parameters=importdata('LindbladModelSimulatedParameters.mat');
    model_type = 12;
    cd ..
end

if strcmp(model,'lu')==1
    cd ParameterSets/
    simulated_parameters=importdata('LuModelSimulatedParameters.mat');
    model_type = 16;
    cd ..
end
if strcmp(model,'matsuoka')==1
    cd ParameterSets/
    simulated_parameters=importdata('MatsuokaModelSimulatedParameters.mat');
    model_type = 15;
    cd ..
end
if strcmp(model,'shannon')==1
    cd ParameterSets/
    simulated_parameters=importdata('ShannonModelSimulatedParameters.mat');
    model_type = 25;
    cd ..
end

if strcmp(model,'nygren')==1
    cd ParameterSets/
    simulated_parameters=importdata('NygrenModelSimulatedParameters.mat');
    model_type = 18;
    cd ..
end

if strcmp(model,'ohara')==1
    cd ParameterSets/
    simulated_parameters=importdata('OharaModelSimulatedParameters.mat');
    model_type = 20;
    cd ..
end

if strcmp(model,'priebe')==1
    cd ParameterSets/
    simulated_parameters=importdata('PriebeModelSimulatedParameters.mat');
    model_type = 21;
    cd ..
end

if strcmp(model,'seemann')==1
    cd ParameterSets/
    simulated_parameters=importdata('SeemannModelSimulatedParameters.mat');
    model_type = 23;
    cd ..
end

if strcmp(model,'severi')==1
    cd ParameterSets/
    simulated_parameters=importdata('SeveriModelSimulatedParameters.mat');
    model_type = 24;
    cd ..
end

if strcmp(model,'tentusscher')==1
    cd ParameterSets/
    simulated_parameters=importdata('TenTusscherModelSimulatedParameters.mat');
    model_type = 26;
    cd ..
end

if strcmp(model,'winslow')==1
    cd ParameterSets/
    simulated_parameters=importdata('WinslowModelSimulatedParameters.mat');
    model_type = 28;
    cd ..
end

if strcmp(model,'zeng')==1
    cd ParameterSets/
    simulated_parameters=importdata('ZengModelSimulatedParameters.mat');
    model_type = 29;
    cd ..
end
if strcmp(model,'zeng_tol')==1
    cd ParameterSets/
    simulated_parameters=importdata('ZengTolModelSimulatedParameters.mat');
    model_type = 2999;
    cd ..
end

if strcmp(model,'zhang')==1
    cd ParameterSets/
    simulated_parameters=importdata('ZhangModelSimulatedParameters.mat');
    model_type = 30;
    cd ..
end

if strcmp(model,'hh')==1
    cd ParameterSets/
    simulated_parameters=importdata('HHModelSimulatedParameters.mat');
    model_type = 35;
    cd ..
end

cd Code