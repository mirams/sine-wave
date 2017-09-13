import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib.patches as patches
from matplotlib.ticker import FormatStrFormatter

import matplotlib as mpl
mpl.style.use('classic') # Use Matplotlib v1 defaults (plot was designed on this!)
mpl.rc('text', usetex=True)

from cycler import cycler
import numpy
from os.path import join, exists
import re
import sys
plt.switch_backend('pdf')
plt.tick_params(axis='both', which='minor', labelsize=16)

voltage_file = 'figure_5_ap_protocol_data.txt'
file = open(voltage_file, 'r')
data = numpy.loadtxt(voltage_file, skiprows=0)
all_time = data[:, 0]
voltage = data[:,1]

fig = plt.figure(0, figsize=(11.3,11.3), dpi=900)
#fig.text(0.51, 0.9, r'{0}'.format('Title'), ha='center', va='center', fontsize=16)

gs = gridspec.GridSpec(4, 1, height_ratios=[3,5,4,4] )

# Voltage trace
ax1 = plt.subplot(gs[0])
#ax1.set_title('Summat', fontsize=14)
ax1.set_ylabel('Voltage (mV)', fontsize=14)
ax1.set_xlabel('Time (s)', fontsize=14)
#ax1.set_xlabel('Time (s)')
#plt.setp(ax.get_xticklabels(), visible=False)
ax1.set_xlim([0, 8])
ax1.set_ylim([-130, 80])     
#ax1.set_yticklabels([r'$-10$', r'$-5$', r'$0$', r'$5$', r'$10$', r'$15$', r'$20$'])
#ax1.set_xticklabels([r'$10^{-3}$', r'$10^{-2}$', r'$10^{-1}$', r'$10^0$', r'$10^1$', r'$10^2$'])
ax1.plot(all_time, voltage, color='k', lw=2)

# To plot experimental data and then ours last, we re-order when we read in.
model_prediction_columns = [8, 9, 10, 11, 7, 6]
color_cycle = [[1,0,1], [0.47,0.67,0.19], 'c', [0.49,0.18,0.56],'DarkOrange','r',[0,0.45,0.74]]
line_width_cycle = [1.5,1.5,1.5,1.5,1.5,1.,1.5]

def get_filename(argument):
    switcher = {
        0: "figure_5_ap_tentusscher_prediction.txt",
        1: "figure_5_ap_mazhari_prediction.txt",
        2: "figure_5_ap_diveroli_prediction.txt",
        3: "figure_5_ap_wang_prediction.txt",
        4: "figure_5_ap_zeng_prediction.txt",
        5: "figure_5_ap_experimental_data.txt",
        6: "figure_5_ap_new_model_prediction.txt",
    }
    return switcher.get(argument, "nothing")


for i in range(0,7):
    file = open(get_filename(i), 'r')
    data = numpy.loadtxt(get_filename(i), skiprows=0)
    all_time = data[:,0]
    if i == 0: # Set up an empty currents array
        currents = numpy.zeros((len(all_time),7))
    currents[:,i] = data[:,1]

start_of_zoom_time = 3.
length_of_zoom_time = 4.3

# Current trace
ax2 = plt.subplot(gs[1])
#ax2.set_title('Summat', fontsize=14)
ax2.set_xlim([0, 8])
ax2.set_ylim([-2, 3])
ax2.yaxis.set_major_formatter(FormatStrFormatter('%.1f'))
ax2.add_patch(
             patches.Rectangle(
                               (start_of_zoom_time, 0.),   # (x,y)
                               length_of_zoom_time,          # width
                               1.,          # height
                               edgecolor="none",
                               facecolor="grey",
                               alpha=0.2,
                               clip_on=False
                               )
             )
ax2.plot(all_time, currents[:,5],color='r',lw=1)
ax2.plot(all_time, currents[:,6],color=[0,0.45,0.74], lw=1.5)
ax2.set_ylabel('Current (nA)', fontsize=14)
ax2.set_xlabel('Time (s)', fontsize=14)

patch_vertices = numpy.array([[start_of_zoom_time,-2.0],[0,-2.96],[8,-2.96],[start_of_zoom_time+length_of_zoom_time,-2.0]])

polygon1 = plt.Polygon(patch_vertices,
                       closed=True,
                       edgecolor="none",
                       facecolor="grey",
                       alpha=0.15,
                       clip_on=False
                       )
ax2.add_artist(polygon1)


# Current zoom trace
ax3 = plt.subplot(gs[2])
#ax.set_title('Summat', fontsize=14)
ax3.set_ylabel('Current (nA)', fontsize=14)
ax3.set_xlabel('Time (s)', fontsize=14)
ax3.set_xlim([start_of_zoom_time, start_of_zoom_time+length_of_zoom_time])
ax3.set_ylim([0, 1])
#ax3.set_prop_cycle(cycler('color',color_cycle[:,4:5]) + cycler('lw',line_width_cycle[:,4:5]))
ax3.plot(all_time, currents[:,5],color='r',lw=1)
[g] = ax3.plot(all_time, currents[:,6],color=[0,0.45,0.74], lw=1.5)

# Current zoom trace
ax4 = plt.subplot(gs[3])
#ax.set_title('Summat', fontsize=14)
ax4.set_ylabel('Current (nA)', fontsize=14)
ax4.set_xlabel('Time (s)', fontsize=14)
ax4.set_xlim([start_of_zoom_time, start_of_zoom_time+length_of_zoom_time])
ax4.set_ylim([0, 1])
ax4.set_prop_cycle(cycler('color',color_cycle) + cycler('lw',line_width_cycle))
[a,b,c,d,e,f] = ax4.plot(all_time, currents[:,[0,1,2,3,4,5]])

ax4.legend([a,b,c,d,e,f], ["ten Tusscher `04","Mazhari `01","Di Veroli `13","Wang `97","Zeng `95","Experiment"], bbox_to_anchor=(0., -0.42, 1., .102), loc=8, handletextpad=0.1,columnspacing=1.0,
           ncol=6, mode="expand", borderaxespad=0.)

ax2.legend([f,g], ["Experiment","New model prediction"], loc=8, handletextpad=0.1, columnspacing=1,
           ncol=2, borderaxespad=1.0)

# Add subfigure text labels, relative to axes top left
ax1.text(-0.06, 1.05, 'A', verticalalignment='top', horizontalalignment='left',
         transform=ax1.transAxes,fontsize=20, fontweight='bold')
ax2.text(-0.06, 1.05, 'B', verticalalignment='top', horizontalalignment='left',
         transform=ax2.transAxes,fontsize=20, fontweight='bold')
ax3.text(-0.06, 1.05, 'C', verticalalignment='top', horizontalalignment='left',
         transform=ax3.transAxes,fontsize=20, fontweight='bold')
ax4.text(-0.06, 1.05, 'D', verticalalignment='top', horizontalalignment='left',
         transform=ax4.transAxes,fontsize=20, fontweight='bold')

#fig.set_tight_layout(True)
gs.tight_layout(fig, renderer=None, pad=0, h_pad=None, w_pad=None, rect=None)
#plt.tight_layout()
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.subplots_adjust(top=0.75, wspace=0.25)
plt.savefig('figure_5.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)
