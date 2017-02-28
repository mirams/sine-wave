function [P_asc,V_asc] = FindingBestFits(model,protocol,exp_ref)
% Function imports CMA-ES search results (negative log-likelihood values and corresponding parameters) and for relevant model/protocol/exp_ref combination
% sorts the results into ascending order (we aim to identify the most negative log-likelihood value which corresponds to the top parameter set in the sorted matrix)

%Import all CMA-ES results
cd  ../CMAESFullSearchResults
pathToFolder = '.';
files = dir(fullfile(pathToFolder,'*.mat'));


P=[];
V=[];
for i = 1:numel(files)
    
    
    k = regexp(files(i).name,['FullGlobalSearchVals_',exp_ref,'_',model,'_',protocol{1}]);
    if k>=1
        V=[V;importdata(files(i).name)];
        
        S=files(i).name;
        
        mS = strrep(S, 'Vals', 'Params');
        q=exist('P');
        if q==1
            P=[P;importdata(mS)];
            
        else
            P=importdata(mS);
            
        end
    end
end

cd ..

% Sorts CMA-ES results into ascending order
[V_asc,I_asc] = sort(V);

for i=1:length(I_asc)
    
    P_asc(i,:) = P(I_asc(i),:);
    
end

V_asc;
P_asc;
cd Code