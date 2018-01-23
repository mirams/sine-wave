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

fig = plt.figure(0, figsize=(8,7), dpi=900)

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

guinea_pigs = ['zeng','winslow','clancy','lindblad','matsuoka']
human_vent = ['lindblad','ohara','tentusscher','grandi','seeman','priebe']
rabbit_san = ['lindblad','zhang','kurata','oehmen','matsuoka']
expression_room = ['wang','diveroli_rt']
expression_37 = ['diveroli_pt','fink','nygren','mazhari','tentusscher','lu']

########################################################
## Full plot of sine wave voltage protocol and current
########################################################
gs1 = gridspec.GridSpec(5, 3)

gs1.update(hspace=0.1)
gs1.update(wspace=0.1)

ax1 = fig.add_subplot(gs1[0])
ax2 = fig.add_subplot(gs1[1], sharey=ax1)
ax3 = fig.add_subplot(gs1[2], sharey=ax1)
ax4 = fig.add_subplot(gs1[3], sharex=ax1)
ax5 = fig.add_subplot(gs1[4], sharex=ax2)
ax6 = fig.add_subplot(gs1[5], sharex=ax3)
ax7 = fig.add_subplot(gs1[6], sharex=ax1)
ax8 = fig.add_subplot(gs1[7], sharex=ax2)
ax9 = fig.add_subplot(gs1[8], sharex=ax3)
ax10 = fig.add_subplot(gs1[9], sharex=ax1)
ax11 = fig.add_subplot(gs1[10], sharex=ax2)
ax12 = fig.add_subplot(gs1[11], sharex=ax3)
ax13 = fig.add_subplot(gs1[12], sharex=ax1)
ax14 = fig.add_subplot(gs1[13], sharex=ax2)
ax15 = fig.add_subplot(gs1[14], sharex=ax3)
# Hide y axis labels for centre and right columns.
plt.setp(ax2.get_yticklabels(), visible=False)
plt.setp(ax3.get_yticklabels(), visible=False)
plt.setp(ax5.get_yticklabels(), visible=False)
plt.setp(ax6.get_yticklabels(), visible=False)
plt.setp(ax8.get_yticklabels(), visible=False)
plt.setp(ax9.get_yticklabels(), visible=False)
plt.setp(ax11.get_yticklabels(), visible=False)
plt.setp(ax12.get_yticklabels(), visible=False)
plt.setp(ax14.get_yticklabels(), visible=False)
plt.setp(ax15.get_yticklabels(), visible=False)
# Hide x axis labels for everything apart from bottom row.
for ax in [ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9, ax10, ax11, ax12]:
    plt.setp(ax.get_xticklabels(), visible=False)

end_of_clamp_to_use = 5001
alpha_level = 0.1

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
            if m in guinea_pigs:
                ax4.plot(times_seconds,data)
            else:
                ax4.plot(times_seconds,data,'k-',alpha=alpha_level)
            if m in human_vent:
                ax7.plot(times_seconds,data)
            else:
                ax7.plot(times_seconds,data,'k-',alpha=alpha_level)
            if m in rabbit_san:
                ax10.plot(times_seconds,data)
            else:
                ax10.plot(times_seconds,data,'k-',alpha=alpha_level)
            if m in expression_room:
	        ax13.plot(times_seconds,data,'b-')
            elif m in expression_37:
                ax13.plot(times_seconds,data,'r-')
            else:
                ax13.plot(times_seconds,data,'k-',alpha=alpha_level)

    elif experiment == 'b':
        time_range = times[(total_length-end_of_clamp_to_use):] - times[(total_length-end_of_clamp_to_use)]
        ax2.plot(time_range,data[(total_length-end_of_clamp_to_use):],'k-')
        for m in models:
            current_file = 'figure_1_' + experiment + '_data/figure_1_' +experiment+ '_' + m + '.txt'
            data = numpy.loadtxt(current_file, skiprows=0)
            if m in guinea_pigs:
                ax5.plot(time_range,data)
            else:
            	ax5.plot(time_range,data,'k-',alpha=alpha_level)
            if m in human_vent:
                ax8.plot(time_range,data)
            else:
                ax8.plot(time_range,data,'k-',alpha=alpha_level)
            if m in rabbit_san:
                ax11.plot(time_range,data)
            else:
                ax11.plot(time_range,data,'k-',alpha=alpha_level)
            if m in expression_room:
	        ax14.plot(time_range,data,'b-')
            elif m in expression_37:
                ax14.plot(time_range,data,'r-')
            else:
                ax14.plot(time_range,data,'k-',alpha=alpha_level)

    elif experiment == 'c':
        ax3.plot(time_range,data[(total_length-end_of_clamp_to_use):],'k-')
        for m in models:
            current_file = 'figure_1_' + experiment + '_data/figure_1_' +experiment+ '_' + m + '.txt'
            data = numpy.loadtxt(current_file, skiprows=0)
            if m in guinea_pigs:
                ax6.plot(time_range,data)
            else:
                ax6.plot(time_range,data,'k-',alpha=alpha_level)
            if m in human_vent:
                ax9.plot(time_range,data)
            else:
                ax9.plot(time_range,data,'k-',alpha=alpha_level)
            if m in rabbit_san:
                ax12.plot(time_range,data)
            else:
                ax12.plot(time_range,data,'k-',alpha=alpha_level)
            if m in expression_room:
	        ax15.plot(time_range,data,'b-')
            elif m in expression_37:
                ax15.plot(time_range,data,'r-')
            else:
                ax15.plot(time_range,data,'k-',alpha=alpha_level)

# Reduce number of ticks on single AP plot
ax5.set_xticks([0,100,200,300])
ax1.set_yticks([-80,-40,0,40])
ax4.set_yticks([0,10,20,30])
ax7.set_yticks([0,10,20,30])
ax10.set_yticks([0,10,20,30])
ax13.set_yticks([0,10,20,30])

ax1.set_xlim([0, 10.5])
ax2.set_xlim([0, 350])
#ax3.set_xlim([0, 500])

ax13.set_xlabel('Time (s)')
ax14.set_xlabel('Time (ms)')
ax15.set_xlabel('Time (ms)')
ax1.set_ylabel('Voltage (mV)')
ax4.set_ylabel('Current\n(normalized)')
ax7.set_ylabel('Current\n(normalized)')
ax10.set_ylabel('Current\n(normalized)')
ax13.set_ylabel('Current\n(normalized)')

column_titles = ['i)','ii)','iii)']
for ax, label_txt in zip([ax1,ax2,ax3],column_titles):
    ax.text(0, 1.22, label_txt, verticalalignment='top', horizontalalignment='left',
            transform=ax.transAxes,fontsize=16)

row_titles = ['A','B','C','D','E']
for ax, label_txt in zip([ax1,ax4,ax7,ax10,ax13],row_titles):
    ax.text(-0.4, 1.1, label_txt, verticalalignment='top', horizontalalignment='left',
            transform=ax.transAxes,fontsize=16)

########################################################
# FINAL PLOT OUTPUT
########################################################
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.savefig('figure_1_r1.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)
