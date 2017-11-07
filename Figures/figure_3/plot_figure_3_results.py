import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib.patches as patches
from matplotlib.ticker import FormatStrFormatter, ScalarFormatter

# Use matplot lib version 1 styles
import matplotlib as mpl
mpl.style.use('classic') # Use Matplotlib v1 defaults (plot was designed on this!)
mpl.rc('text', usetex=True)

import numpy
from os.path import join, exists
import re
import sys
plt.switch_backend('pdf')
plt.tick_params(axis='both', which='minor', labelsize=16)

voltage_file = 'figure_3_data/figure_3_sine_wave_protocol.txt'
data = numpy.loadtxt(voltage_file, skiprows=0)
all_time = data[:, 0]
voltage = data[:,1]

fig = plt.figure(0, figsize=(9,6), dpi=900)
#fig.text(0.51, 0.9, r'{0}'.format('Title'), ha='center', va='center', fontsize=16)

#start_of_zoom_time = 3.4  # seconds
#length_of_zoom_time = 1.6 # seconds

start_of_zoom_time = 4.0  # seconds
length_of_zoom_time = 1.0 # seconds

########################################################
## Full plot of sine wave voltage protocol and current
########################################################
gs1 = gridspec.GridSpec(3, 1, height_ratios=[1,1,1],top=1.0,bottom=0.55,left=0.0,right=1.0 )
ax1 = fig.add_subplot(gs1[0])
ax2 = fig.add_subplot(gs1[1], sharex=ax1)
ax6 = fig.add_subplot(gs1[2], sharex=ax1)
plt.setp(ax1.get_xticklabels(), visible=False)
plt.setp(ax2.get_xticklabels(), visible=False)

# Voltage trace
ax1.set_ylabel('Voltage\nClamp\n(mV)', fontsize=14, rotation=0)
ax1.set_xlim([0, 8])
ax1.set_ylim([-130, 65])
ax1.plot(all_time, voltage, color='k', lw=1)

experiment_file = 'figure_3_data/figure_3_sine_wave_experimental_data.txt'
#file = open(experiment_file, 'r')
data = numpy.loadtxt(experiment_file, skiprows=0)
experimental_currents = data[:,1:]

current_file ='figure_3_data/figure_3_sine_wave_model_data.txt'
data = numpy.loadtxt(current_file, skiprows=0)
simulated_currents = data[:,1:]

# Current trace
ax2.plot(all_time, simulated_currents, lw=0.5)
ax2.set_ylabel("Existing\nModels'\nCurrents\n(normalized)", fontsize=14, rotation=0)
ax2.set_ylim([-14.8, 9.])

ax6.axhline(0.0, linestyle='--', color='k',lw=0.5)
ax6.plot(all_time, experimental_currents, lw=0.5)
#ax6.set_xlabel('Time (s)', fontsize=14)
ax6.set_ylabel('Experimental\nCurrents\n(nA)', fontsize=14, rotation=0)
ax6.set_ylim([-3, 2])


#ax2.legend([a,b], ["Experiment","Fitted model"], loc=8, handletextpad=0.1, columnspacing=1,
#           ncol=2, borderaxespad=1)

# Add the little zoom patch between plots
lower_current, tmp = ax6.get_ylim()

patch_vertices = numpy.array([[start_of_zoom_time,lower_current],[0,-5.6],[8,-5.6],[start_of_zoom_time+length_of_zoom_time,lower_current]])

ax6.add_artist(plt.Polygon(patch_vertices,
                           closed=True,
                           edgecolor="none",
                           facecolor="grey",
                           alpha=0.15,
                           clip_on=False
                           )
               )

########################################################
## Plot zoomed in voltage protocol and current
########################################################
gs2 = gridspec.GridSpec(3, 1, height_ratios=[1,1,1],top=0.47, bottom=0.0,left=0.0,right=1.0)
ax3 = fig.add_subplot(gs2[0])
ax4 = fig.add_subplot(gs2[1], sharex=ax3)
ax5 = fig.add_subplot(gs2[2], sharex=ax3)
plt.setp(ax3.get_xticklabels(), visible=False)
plt.setp(ax4.get_xticklabels(), visible=False)

# Voltage zoom trace
ax3.set_ylabel('Voltage\nClamp\n(mV)', fontsize=14, rotation=0)
ax3.set_xlim([start_of_zoom_time, start_of_zoom_time+length_of_zoom_time])
ax3.plot(all_time, voltage, color='k', lw=1.5)
ax3.set_ylim([-130, 65])

# Current zoom trace
ax4.plot(all_time, simulated_currents,lw=0.5)
ax4.set_ylim([-3.5, 8.2])
ax4.set_ylabel("Existing\nModels'\nCurrents\n(normalized)", fontsize=14, rotation=0)
ax4.set_yticks([-2.0,0,2,4,6])

ax5.axhline(0.0, linestyle='--', color='k',lw=0.5)
ax5.plot(all_time, experimental_currents,lw=0.5)
ax5.set_ylabel('Experimental\nCurrents\n(nA)', fontsize=14, rotation=0)
ax5.set_xlabel('Time (s)', fontsize=14)
ax5.set_ylim([-1.25,1.6])


# Use the automatic axis limits here to set the zoomed region on top plots
ymin_voltage, ymax_voltage = ax3.get_ylim()
ymin_sim, ymax_sim = ax4.get_ylim()
ymin_expt, ymax_expt = ax5.get_ylim()

# Now shade in this region on top plots
# Shade in the zoomed in region
ax2.add_patch(patches.Rectangle((start_of_zoom_time, ymin_sim),   # (x,y)
                                length_of_zoom_time,                 # width
                                ymax_sim-ymin_sim,  # height
                                edgecolor="none",
                                facecolor="grey",
                                alpha=0.2,
                                clip_on=False
                                )
              )
ax6.add_patch(patches.Rectangle((start_of_zoom_time, ymin_expt),   # (x,y)
                                length_of_zoom_time,                 # width
                                ymax_expt-ymin_expt,  # height
                                edgecolor="none",
                                facecolor="grey",
                                alpha=0.2,
                                clip_on=False
                                )
              )

ax1.add_patch(
              patches.Rectangle(
                                (start_of_zoom_time, ymin_voltage),   # (x,y)
                                length_of_zoom_time,                 # width
                                ymax_voltage-ymin_voltage,  # height
                                edgecolor="none",
                                facecolor="grey",
                                alpha=0.2,
                                clip_on=False
                                )
              )

# Squeeze the voltage and current plots together
gs1.update(hspace=0.0)
gs2.update(hspace=0.0)

########################################################
# Add subfigure text labels, relative to axes top left
########################################################

axes_list = [ax1,ax2,ax3,ax4,ax5,ax6]
for ax in axes_list:
    if ax==ax2 or ax==ax4:
        vertical_offset = 0.08
    else:
        vertical_offset = 0.16
    
    ax.get_yaxis().set_label_coords(-0.10,vertical_offset)
    ax.locator_params(axis='y', nbins=6)
    ax.get_yaxis().set_tick_params(direction='inout')
    ax.get_xaxis().set_tick_params(direction='inout')
#ax.yaxis.set_major_formatter(FormatStrFormatter('%.1f'))

left_shift_for_panel_labels = -0.18
ax1.text(left_shift_for_panel_labels, 1.05, 'A', verticalalignment='top', horizontalalignment='left',
         transform=ax1.transAxes,fontsize=20, fontweight='bold')#

ax3.text(left_shift_for_panel_labels, 1.05, 'B', verticalalignment='top', horizontalalignment='left',
         transform=ax3.transAxes,fontsize=20, fontweight='bold')

########################################################
# FINAL PLOT OUTPUT
########################################################
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.savefig('figure_3.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)
