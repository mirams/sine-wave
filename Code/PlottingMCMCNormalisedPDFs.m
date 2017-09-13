function PlottingMCMCNormalisedPDFs()
% Code to plot Figure C5 - compares MCMC chains from fitting to
% simulated and experimental data.
% chain_1 is MCMC chain from fitting to experimental data
% chain_2 is MCMC chain from fitting to simulated data
% We discard first 50,000 points in MCMC chain as burn

cd ../MCMCResults
chain_1 = importdata('MCMCChain_16713110_hh_sine_wave_30082148.mat');
likelihood_1=importdata('MCMCLikelihood_16713110_hh_sine_wave_30082148.mat');

[i,v]=max(likelihood_1);

max_likelihood = chain_1(v,:);
cd ..
cd MCMCResultsSimulated
chain_2 =importdata('MCMCChain_hh_sine_wave_12092104.mat');
cd ..
% Discard first 50000 points are burn in
chain_1=chain_1(50001:250000,:);
chain_2=chain_2(50001:250000,:);
for i =1:size(chain_1,2)
    
    subplot(3,3,i)
    % Plots MCMC chain for experimental data
    h=histogram(chain_1(:,i),'Normalization','pdf','NumBins',100)
    %h =  findobj(gca,'Type','patch');
    
    set(h,'FaceColor','r','LineStyle','none');
    
    hold on
    % Plots MCMC chain for simulated data
    h1=histogram(chain_2(:,i),'Normalization','pdf','NumBins',100)
    %h1 = findobj(gca,'Type','patch');
    
    set(h1,'LineStyle','none','FaceColor','b');
    
    axis('tight')
    % Plots parameters with maximum likelihood from experimental MCMC chain
    % (which corresponds to parameter set used to generate simulated data).
    plot(max_likelihood(i),0,'kx','MarkerSize',16,'LineWidth',4)
    % first chain is ref and second is blue
    set(gca, 'FontSize',20)
    xlabel(['Parameter ',num2str(i)],'FontSize',20)
    
    if i==9
        xlabel('Conductance','FontSize',20)
    end
    if i==1||i==4||i==7
        ylabel(['Probability Density'],'FontSize',20)
    end
    
end

legend('Distributions from Experimental Data','Distributions from Synthetic Data','Maximum Likelihood Parameters')


cd Code