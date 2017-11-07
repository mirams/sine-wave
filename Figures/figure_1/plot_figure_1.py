import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib.patches as patches
from matplotlib.ticker import FormatStrFormatter, ScalarFormatter
import matplotlib as mpl
mpl.style.use('classic') # Use Matplotlib v1 defaults (plot was designed on this!)
mpl.rc('text', usetex=True)

import numpy
from os.path import join, exists
import re
import sys
plt.switch_backend('pdf')
plt.tick_params(axis='both', which='minor', labelsize=16)
plt.tick_params(axis='both', which='major', labelsize=16)

fig = plt.figure(0, figsize=(8,3), dpi=900)

models = ['mazhari',
          'aslanidi',
          'nygren',
          'clancy',
          'oehmen',
          'courtemanche',
          'ohara',
          'diveroli_pt',
          'priebe',
          'diveroli_rt',
          'ramirez',
          'fink',
          'seemann',
          'fox',
          'severi',
          'grandi',
          'shannon',
          'hund',
          'tentusscher',
          'inada',
          'kurata',
          'wang',
          'lindblad',
          'winslow',
          'liu',
          'zeng',
          'lu',
          'zhang',
          'matsuoka']

########################################################
## Full plot of sine wave voltage protocol and current
########################################################
gs1 = gridspec.GridSpec(2, 3)

gs1.update(hspace=0.1)
gs1.update(wspace=0.1)

ax1 = fig.add_subplot(gs1[0])
ax2 = fig.add_subplot(gs1[1], sharey=ax1)
ax3 = fig.add_subplot(gs1[2], sharey=ax1)
ax4 = fig.add_subplot(gs1[3], sharex=ax1)
ax5 = fig.add_subplot(gs1[4], sharex=ax2)
ax6 = fig.add_subplot(gs1[5], sharex=ax3)
plt.setp(ax2.get_yticklabels(), visible=False)
plt.setp(ax3.get_yticklabels(), visible=False)
plt.setp(ax5.get_yticklabels(), visible=False)
plt.setp(ax6.get_yticklabels(), visible=False)
plt.setp(ax1.get_xticklabels(), visible=False)
plt.setp(ax2.get_xticklabels(), visible=False)
plt.setp(ax3.get_xticklabels(), visible=False)

end_of_clamp_to_use = 5001

for experiment in ['a','b','c']:
    voltage_file = 'figure_1_' + experiment + '_data/figure_1_'+experiment+'_voltage_protocol.txt'
    data = numpy.loadtxt(voltage_file, skiprows=0)
    total_length = len(data)
    times = numpy.array([x / 10.0 for x in range(0,total_length)]) # Hardcoded to 10 samples per ms. (10kHz)
    times_seconds = times / 1000.0
    if experiment == 'a':
        ax1.plot(times_seconds,data,'k-')
        for m in models:
            current_file = 'figure_1_' + experiment + '_data/figure_1_' +experiment+ '_' + m + '.txt'
            data = numpy.loadtxt(current_file, skiprows=0)
            ax4.plot(times_seconds,data)
    elif experiment == 'b':
        ax2.plot(times[(total_length-end_of_clamp_to_use):] - times[(total_length-end_of_clamp_to_use)],data[(total_length-end_of_clamp_to_use):],'k-')
        for m in models:
            current_file = 'figure_1_' + experiment + '_data/figure_1_' +experiment+ '_' + m + '.txt'
            data = numpy.loadtxt(current_file, skiprows=0)
            ax5.plot(times[(total_length-end_of_clamp_to_use):] - times[(total_length-end_of_clamp_to_use)],data)
    elif experiment == 'c':
        ax3.plot(times[(total_length-end_of_clamp_to_use):] - times[(total_length-end_of_clamp_to_use)],data[(total_length-end_of_clamp_to_use):],'k-')
        for m in models:
            current_file = 'figure_1_' + experiment + '_data/figure_1_' +experiment+ '_' + m + '.txt'
            data = numpy.loadtxt(current_file, skiprows=0)
            ax6.plot(times[(total_length-end_of_clamp_to_use):] - times[(total_length-end_of_clamp_to_use)],data)

# Reduce number of ticks on single AP plot
ax5.set_xticks([0,100,200,300])
ax1.set_yticks([-80,-40,0,40])
ax4.set_yticks([0,10,20,30,40])

ax1.set_xlim([0, 10.5])
ax2.set_xlim([0, 350])
#ax3.set_xlim([0, 500])

ax4.set_xlabel('Time (s)')
ax5.set_xlabel('Time (ms)')
ax6.set_xlabel('Time (ms)')
ax1.set_ylabel('Voltage (mV)')
ax4.set_ylabel('Current\n(normalized)')

column_titles = ['i)','ii)','iii)']
for ax, label_txt in zip([ax1,ax2,ax3],column_titles):
    ax.text(0, 1.22, label_txt, verticalalignment='top', horizontalalignment='left',
            transform=ax.transAxes,fontsize=16)

########################################################
# FINAL PLOT OUTPUT
########################################################
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.savefig('figure_1.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)
