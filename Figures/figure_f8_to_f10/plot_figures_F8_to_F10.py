import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import numpy as np
import numpy.random as npr
import pandas as pd

plt.switch_backend('pdf')

plt.figure(1, figsize=(8,6), dpi=900)
plt.tick_params(axis='both', which='minor', labelsize=16)
plt.figure(2, figsize=(8,6), dpi=900)
plt.tick_params(axis='both', which='minor', labelsize=16)
plt.figure(3, figsize=(8,6), dpi=900)
plt.tick_params(axis='both', which='minor', labelsize=16)

gs1 = gridspec.GridSpec(3, 3)
gs2 = gridspec.GridSpec(3, 3)
gs3 = gridspec.GridSpec(3, 3)

gridspaces = [gs1, gs2, gs3]

folder_names = ['deactivation_weighted_tau',
                'recovery_inactivation_tau',
                'instantaneous_inactivation_tau']

cells_to_plot_each_experiment = [[0,1,2,3,4,6,7,8],
                                 [0,1,2,3,4,6,7,8],
                                 range(0,9)]

num_data_points_in_x = [6, 6, 11]

experiment_names = ['deactivation',
                    'recovery_inactivation',
                    'instantaneous_inactivation']

colours = ['fuchsia','red','blue','darkorange','green','gold','lawngreen','saddlebrown','darkturquoise','black'] # from brewer

for experiment_idx in range(0,3):
    print('Plotting: ' + experiment_names[experiment_idx])
    plt.figure(experiment_idx+1)
    current_gridspace = gridspaces[experiment_idx]
    cells_to_plot = cells_to_plot_each_experiment[experiment_idx]

    ax1 = plt.subplot(current_gridspace[0,0])
    ax2 = plt.subplot(current_gridspace[0,1],sharex=ax1,sharey=ax1)
    ax3 = plt.subplot(current_gridspace[0,2],sharex=ax1,sharey=ax1)
    ax4 = plt.subplot(current_gridspace[1,0],sharex=ax1,sharey=ax1)
    ax5 = plt.subplot(current_gridspace[1,1],sharex=ax1,sharey=ax1)
    ax6 = plt.subplot(current_gridspace[1,2],sharex=ax1,sharey=ax1)
    plt.setp(ax6.get_yticklabels(), visible=False)
    plt.setp(ax6.get_xticklabels(), visible=False)
    ax7 = plt.subplot(current_gridspace[2,0],sharex=ax1,sharey=ax1)
    ax8 = plt.subplot(current_gridspace[2,1],sharex=ax1,sharey=ax1)
    ax9 = plt.subplot(current_gridspace[2,2],sharex=ax1,sharey=ax1)

    axes = [ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9]

    exp_data = np.empty([9,num_data_points_in_x[experiment_idx],2])
    sim_data = np.empty([9,num_data_points_in_x[experiment_idx],2])
    average_data = np.empty([9,num_data_points_in_x[experiment_idx],2])

    # Load all the data
    for i in cells_to_plot:
	# Cell i's averaged result (temperature adjusted to Cell i - average data)
	average_file = folder_names[experiment_idx] + '/average_cell_'  + str(i+1) + '_' + experiment_names[experiment_idx] + '_sim.txt'
    	average_data[i,:,:] = np.loadtxt(average_file, skiprows=0)

        # Cell i's experimental data
        experiment_file = folder_names[experiment_idx] + '/cell_' + str(i+1) + '_' + experiment_names[experiment_idx] + '_exp.txt'
	exp_data[i,:,:] = np.loadtxt(experiment_file, skiprows=0)
        
        simulation_file = folder_names[experiment_idx] + '/cell_' + str(i+1) + '_' + experiment_names[experiment_idx] + '_sim.txt'
        sim_data[i,:,:] = np.loadtxt(simulation_file, skiprows=0)

    for i in cells_to_plot:
        ax = axes[i]
        
        ax.set_xlim([np.min(average_data[i,:,0]),np.max(average_data[i,:,0])])
        #ax.grid()
        if i>=6:
            ax.set_xlabel('Voltage (mV)',fontsize=14)
        elif i<6:
            plt.setp(ax.get_xticklabels(), visible=False)

        if i==3:
            ax.set_ylabel(r'Time Constant $\tau$ (ms)',fontsize=14)
            if experiment_idx==0:
                ax.set_yticks([1,1.477,2,2.477,3,3.477])
                ax.set_yticklabels(['10','30','100','300','1000','3000'])
                ax.set_ylim([1.477,3.477])
        elif (i%3 is not 0):
            plt.setp(ax.get_yticklabels(), visible=False)

        # Plot the small multiples faintly in the background.
        for j in cells_to_plot:
            ax.plot(exp_data[j,:,0],exp_data[j,:,1],'--',color='0.9')
            ax.plot(sim_data[j,:,0],sim_data[j,:,1],'-',color='0.9')
        
        # Plot average data
        ax.plot(average_data[i,:,0],average_data[i,:,1],'-',color='0.2')

    for i in cells_to_plot:
        ax = axes[i]
        ax.plot(exp_data[i,:,0],exp_data[i,:,1],'.--',color=colours[i],lw=2)
        ax.plot(sim_data[i,:,0],sim_data[i,:,1],'.-',color=colours[i],lw=2)
        
        # Add label saying which cell it is
        if experiment_idx<2:
            xpos = 0.04
            alignment = 'left'
        else:
            xpos = 0.96
            alignment = 'right'
        
        ax.text(xpos, 0.94, 'Cell ' + str(i+1),
                verticalalignment='top', horizontalalignment=alignment, # Where the co-ordinates point to in terms of the text
                transform=ax.transAxes,
                color='black', fontsize=14)

    for ax in axes:
        for label in ax.get_xticklabels():
            label.set_rotation(90)

gs1.update(hspace=0.15,wspace=0.1)
gs2.update(hspace=0.15,wspace=0.1)
gs3.update(hspace=0.15,wspace=0.1)

#ax0.legend_.remove()
#legend = ax0.legend(bbox_to_anchor=(1.0, 0.5), loc='center left', handletextpad=0, columnspacing=0.6, ncol=2, borderaxespad=0.,fontsize=13, title="Calibration Data")
#legend.get_title().set_fontsize('16')
#plt.show(block=True)

plt.figure(1)
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.subplots_adjust(top=0.75, wspace=0.25)
plt.savefig('figure_F8.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)

plt.figure(2)
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.subplots_adjust(top=0.75, wspace=0.25)
plt.savefig('figure_F9.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)

plt.figure(3)
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.subplots_adjust(top=0.75, wspace=0.25)
plt.savefig('figure_F10.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)
