import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import numpy as np
import numpy.random as npr
import pandas as pd
import itertools

# To re-organise the legend into rows rather than columns.
def flip(items, ncol):
    return itertools.chain(*[items[i::ncol] for i in range(ncol)])

plt.switch_backend('pdf')
plt.tick_params(axis='both', which='minor', labelsize=16)
fig = plt.figure(0, figsize=(11.3,8), dpi=900)

gs1 = gridspec.GridSpec(3, 3)

colours = ['fuchsia','red','blue','darkorange','green','gold','lawngreen','saddlebrown','darkturquoise','black'] # from brewer
labels = ['Cell 1','Cell 2','Cell 3','Cell 4','Cell 5','Cell 6','Cell 7','Cell 8','Cell 9','Averaged']

datafiles = ['MCMCChain_16713003_hh_sine_wave_3110141', # Cell 1
             'MCMCChain_16715049_hh_sine_wave_3110139', # Cell 2
             'MCMCChain_16708016_hh_sine_wave_3110145', # Cell 3
             'MCMCChain_16708060_hh_sine_wave_3110143', # Cell 4
             'MCMCChain_16713110_hh_sine_wave_3110140', # Cell 5
             'MCMCChain_16708118_hh_sine_wave_3110142', # Cell 6
             'MCMCChain_16704007_hh_sine_wave_3110138', # Cell 7
             'MCMCChain_16704047_hh_sine_wave_3110136', # Cell 8 
             'MCMCChain_16707014_hh_sine_wave_3110151', # Cell 9
             'MCMCChain_average_hh_sine_wave_18010521'] # Averaged data fit

data = np.empty([10,250000,9]) # cell (+average), mcmc_sample, parameter
handles=np.empty([10,1])

i=0;
for file in datafiles:
    data[i,:,:] = np.loadtxt(file + '.txt', skiprows=0)
    i = i+1
    print(np.shape(data))


ax1 = plt.subplot(gs1[0,0])
ax2 = plt.subplot(gs1[0,1],sharey=ax1)
ax3 = plt.subplot(gs1[0,2],sharey=ax1)
ax4 = plt.subplot(gs1[1,0],sharey=ax1)
ax5 = plt.subplot(gs1[1,1],sharey=ax1)
ax6 = plt.subplot(gs1[1,2],sharey=ax1)
ax7 = plt.subplot(gs1[2,0],sharey=ax1)
ax8 = plt.subplot(gs1[2,1],sharey=ax1)
ax9 = plt.subplot(gs1[2,2],sharey=ax1)

axes = [ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9]

for param_idx in range(0,9):
    ax = axes[param_idx]
    if param_idx < 8:
        ax.set_xlabel('$P_{' + str(param_idx+1) + '}$')
    else:
        ax.set_xlabel('$G_{Kr}$')
    ax.xaxis.label.set_size(18)
    ax.get_xaxis().set_label_coords(+0.15,0.93)



    for cell_idx in range(0,10):
        if not (param_idx==8 and cell_idx==9): # Don't plot conductance for averaged model (arbitrary!)
            ax.hist(data[cell_idx,:,param_idx], 100, normed=0, facecolor=colours[cell_idx], edgecolor="none", alpha=0.75, label=labels[cell_idx])

    ax.set_ylim([0,12000])
            #if param_idx==0:
            ## Plot a little irrelevant square somewhere to use in legend!
            #handles[cell_idx], = ax.plot([0,-1], marker='s', color=colours[cell_idx], markersize=15)

    if param_idx==7:
        handles, labels = ax.get_legend_handles_labels()
        ax.legend(flip(handles, 5), flip(labels, 5),
                  bbox_to_anchor=(-1.25, -0.62, 3.5, .102),
                  loc=8,
                  handletextpad=0.3,
                  columnspacing=1.0,
                  ncol=5,
                  mode="expand",
                  borderaxespad=0.)

    if param_idx==2:
        ax.locator_params(axis='x',nbins=5)
    else:
        ax.locator_params(axis='x',nbins=6)

#gs1.update(hspace=0.1,wspace=0.1)

plt.setp(ax2.get_yticklabels(), visible=False)
plt.setp(ax3.get_yticklabels(), visible=False)
plt.setp(ax5.get_yticklabels(), visible=False)
plt.setp(ax6.get_yticklabels(), visible=False)
plt.setp(ax8.get_yticklabels(), visible=False)
plt.setp(ax9.get_yticklabels(), visible=False)


#ax0.legend_.remove()
#legend = axes[0].legend(bbox_to_anchor=(1.0, 0.5), loc='center left', handletextpad=0, columnspacing=0.6, ncol=2, borderaxespad=0.,fontsize=13, title="Calibration Data")
#legend.get_title().set_fontsize('16')
#plt.show(block=True)

plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.subplots_adjust(top=0.75, wspace=0.25)
plt.savefig('MCMC_parameter_distributions_all_cells.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)
