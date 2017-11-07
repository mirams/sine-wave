import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import numpy as np
import numpy.random as npr
import pandas as pd

# These two lines let you use latex in text.
import matplotlib as mpl
mpl.style.use('classic') # Use Matplotlib v1 defaults (plot was designed on this!)
mpl.rcParams['text.usetex'] = True

# If you change the input data order or anything, then check line 113 (in which we ignore average cell conductance - as it is fitted
# to currents all scaled to one particular cell).

plt.switch_backend('pdf')
plt.tick_params(axis='both', which='minor', labelsize=16)
fig = plt.figure()

num_cells = 9

gs1 = gridspec.GridSpec(1, 3,top=1, bottom=0.7,left=0.0,right=1.0)
gs2 = gridspec.GridSpec(3, 3,top=0.60, bottom=0,left=0.0,right=1.0)

colours = ['fuchsia','red','blue','darkorange','green','gold','lawngreen','saddlebrown','darkturquoise','black'] # from brewer

ax1 = plt.subplot(gs2[0,0])
ax2 = plt.subplot(gs2[0,1],sharex=ax1,sharey=ax1)
ax3 = plt.subplot(gs2[0,2],sharex=ax1,sharey=ax1)
ax4 = plt.subplot(gs2[1,0],sharex=ax1,sharey=ax1)
ax5 = plt.subplot(gs2[1,1],sharex=ax1,sharey=ax1)
ax6 = plt.subplot(gs2[1,2],sharex=ax1,sharey=ax1)
ax7 = plt.subplot(gs2[2,0],sharex=ax1,sharey=ax1)
ax8 = plt.subplot(gs2[2,1],sharex=ax1,sharey=ax1)
ax9 = plt.subplot(gs2[2,2],sharex=ax1,sharey=ax1)

axes = [ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9]

# Load the average model IV curve
average_file = 'steady_activation_peak_current_figure_7_b/average_cell_steady_activation_peak_sim.txt'
average_data = np.loadtxt(average_file, skiprows=0)

exp_data = np.empty([num_cells,7,2])
sim_data = np.empty([num_cells,7,2])

# Load all the data
for i in range(0,num_cells):
    # Cell i's experimental data
    experiment_file = 'steady_activation_peak_current_figure_7_b/cell_' + str(i+1) + '_steady_activation_peak_exp.txt'
    exp_data[i,:,:] = np.loadtxt(experiment_file, skiprows=0)
    
    simulation_file = 'steady_activation_peak_current_figure_7_b/cell_' + str(i+1) + '_steady_activation_peak_sim.txt'
    sim_data[i,:,:] = np.loadtxt(simulation_file, skiprows=0)

for i in range(0,num_cells):
    ax = axes[i]
    #ax.grid()
    if i>=6:
        ax.set_xlabel('Voltage (mV)',fontsize=14)
    else:
        plt.setp(ax.get_xticklabels(), visible=False)
    if i==3:
        ax.set_ylabel('Normalised\nCurrent',fontsize=14)
    elif (i%3 is not 0):
        plt.setp(ax.get_yticklabels(), visible=False)

    
    # Plot the small multiples faintly in the background.
    for j in range(0,num_cells):
        ax.plot(exp_data[j,:,0],exp_data[j,:,1],'--',color='0.9')
        ax.plot(sim_data[j,:,0],sim_data[j,:,1],'-', color='0.9')
    
    # Plot average data
    ax.plot(average_data[:,0],average_data[:,1],'-',color='0.2')

for i in range(0,num_cells):
    ax = axes[i]
    ax.plot(exp_data[i,:,0],exp_data[i,:,1],'.--',color=colours[i],lw=2)
    ax.plot(sim_data[i,:,0],sim_data[i,:,1],'.-', color=colours[i],lw=2)
    
    # Add label saying which cell it is
    ax.text(0.05, 0.90, 'Cell ' + str(i+1),
            verticalalignment='top', horizontalalignment='left', # Where the co-ordinates point to in terms of the text
            transform=ax.transAxes,
            color='black', fontsize=14)

gs1.update(hspace=0.1,wspace=0.1)
gs2.update(hspace=0.15,wspace=0.1)

#######
####### Swarmplot - importing seaborn messes up a=default formatting so do this last!
#######
import seaborn as sns

sns.set_style("whitegrid")


# big axis at top for swarm plot
ax0 = plt.subplot(gs1[0,0:2])

# Load up the parameter data
parameter_file = 'parameters_each_cell_and_average.txt'
parameter_values = np.loadtxt(parameter_file)
each_cell_log_parameters = np.log10(parameter_values)
average_log_parameters = np.log10(parameter_values[:,num_cells])

num_parameters = np.shape(average_log_parameters)[0]
each_cell_log_parameters = np.reshape(each_cell_log_parameters,((num_cells+1)*num_parameters,1), order='C')

df = pd.DataFrame(columns=["Cell","Value","Parameter"])
cell_numbers = ['Cell 1','Cell 2','Cell 3','Cell 4','Cell 5','Cell 6','Cell 7','Cell 8','Cell 9','All']
parameter_names = ['P$_1$','P$_2$','P$_3$','P$_4$','P$_5$','P$_6$','P$_7$','P$_8$',r'G$_\textrm{Kr}$']
df["Cell"] = cell_numbers*num_parameters
df["Value"] = each_cell_log_parameters

list_of_params = []
for name in parameter_names:
	list_of_params += [name]*(num_cells+1)
df["Parameter"] = list_of_params

# Find the index of the averaged cell in each ordering
all_data_ranking = [0] * 8
i=0
for param in parameter_names[:-1]:
	subframe = df[df.Parameter == param]
	ranking = subframe['Value'].rank(axis=0)
	all_data_ranking[i] = int(ranking.as_matrix()[9] - 1)
	i += 1

# Remove the last entry (corresponding to the GKr for Averaged cell, which doesn't mean much!)
# IF YOU CHANGE THE INPUT DATA MAKE SURE YOU CHECK THIS IS STILL SENSIBLE!!
df = df[:-1]

print(df)

#print(df)
ax0.set_ylim([-5,0])
result = sns.swarmplot(y=df["Value"],ax=ax0,hue=df["Cell"],palette=colours,x=df["Parameter"],size=4)

# Now start some fun to make the averaged cell data larger.
pathcollections  = result.collections
normal_sizes = [16,16,16,16,16,16,16,16,16]
i=0
for p in pathcollections[0:8]:
	these_sizes = normal_sizes[:]
	idx = all_data_ranking[i]
	these_sizes[idx] = 42
	p.set_sizes(these_sizes)
	i += 1

# Make the legend entry for the averaged cell model bigger too
pathcollections[18].set_sizes([121])

ax0.set_ylabel("")
ax0.set_xlabel("")
ax0.set_yticks([-5,-4,-3,-2,-1,0])
ax0.set_yticklabels([r'$10^{-5}$',r'$10^{-4}$',r'$10^{-3}$',r'$10^{-2}$',r'$10^{-1}$', r'$1$'],fontsize=14)
for tick in ax0.xaxis.get_major_ticks():
    tick.label.set_fontsize(14)
    tick.set_visible(True)

# Add panel labels
ax0.text(-0.15, 1.0, 'A',
        verticalalignment='center', horizontalalignment='left', # Where the co-ordinates point to in terms of the text
        transform=ax0.transAxes, color='black', fontsize=20, fontweight='bold')

ax1.text(-0.3, 1.0, 'B',
         verticalalignment='center', horizontalalignment='left', # Where the co-ordinates point to in terms of the text
         transform=ax1.transAxes, color='black', fontsize=20, fontweight='bold')

#ax0.legend_.remove()
legend = ax0.legend(bbox_to_anchor=(1.08, 0.5), loc='center left', handletextpad=0, columnspacing=0.6, ncol=2, borderaxespad=0.,fontsize=13, title="Calibration Data")
legend.get_title().set_fontsize('16')
#plt.show(block=True)

plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.subplots_adjust(top=0.75, wspace=0.25)
plt.savefig('figure_7.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)
