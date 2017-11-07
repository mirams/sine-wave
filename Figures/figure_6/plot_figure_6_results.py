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
import math
plt.switch_backend('pdf')

voltage_file = 'figure_6_ap_protocol_data.txt'
file = open(voltage_file, 'r')
data = numpy.loadtxt(voltage_file, skiprows=0)
all_time = data[:, 0]
voltage = data[:,1]

fig = plt.figure(0, figsize=(11.3,11.3), dpi=900)
#fig.text(0.51, 0.9, r'{0}'.format('Title'), ha='center', va='center', fontsize=16)

#gs = gridspec.GridSpec(4, 1, height_ratios=[3,5,4,4] )
gs1 = gridspec.GridSpec(2, 1, height_ratios=[3,5],top=1.0,bottom=0.6,left=0.0,right=1.0 )
gs2 = gridspec.GridSpec(3, 1, height_ratios=[1,2,2],top=0.55,bottom=0,left=0.0,right=1.0 )

# Voltage trace
ax1 = fig.add_subplot(gs1[0])
plt.tick_params(axis='both', which='major', labelsize=16) # Seems to work on last created axes
ax5 = fig.add_subplot(gs2[0])
plt.tick_params(axis='both', which='major', labelsize=16)
for ax in [ax1, ax5]:
    #ax1.set_title('Summat', fontsize=14)
    ax.set_ylabel('Voltage (mV)', fontsize=18)
    #ax.set_xlabel('Time (s)', fontsize=14)
    #ax1.set_xlabel('Time (s)')
    plt.setp(ax.get_xticklabels(), visible=False)
    
    #ax1.set_yticklabels([r'$-10$', r'$-5$', r'$0$', r'$5$', r'$10$', r'$15$', r'$20$'])
    #ax1.set_xticklabels([r'$10^{-3}$', r'$10^{-2}$', r'$10^{-1}$', r'$10^0$', r'$10^1$', r'$10^2$'])
    ax.plot(all_time, voltage, color='k', lw=2)

ax1.set_xlim([0, 8])
ax1.set_ylim([-130, 80])

# To plot experimental data and then ours last, we re-order when we read in.
model_prediction_columns = [8, 9, 10, 11, 7, 6]
color_cycle = [[1,0,1], [0.47,0.67,0.19], 'c', [0.49,0.18,0.56],'DarkOrange','r',[0,0.45,0.74]]
line_width_cycle = [1.5,1.5,1.5,1.5,1.5,1.,1.5]

def get_filename(argument):
    switcher = {
        0: "figure_6_ap_tentusscher_prediction.txt",
        1: "figure_6_ap_mazhari_prediction.txt",
        2: "figure_6_ap_diveroli_prediction.txt",
        3: "figure_6_ap_wang_prediction.txt",
        4: "figure_6_ap_zeng_prediction.txt",
        5: "figure_6_ap_experimental_data.txt",
        6: "figure_6_ap_new_model_prediction.txt",
    }
    return switcher.get(argument, "nothing")

model_names = ['ten Tusscher','Mazhari','DiVeroli','Wang','Zeng','Experimental Data','New Model']

for i in range(0,7):
    file = open(get_filename(i), 'r')
    data = numpy.loadtxt(get_filename(i), skiprows=0)
    all_time = data[:,0]
    if i == 0: # Set up an empty currents array
        currents = numpy.zeros((len(all_time),7))
    currents[:,i] = data[:,1]

# Work out error measures
fig2 = plt.figure(1, figsize=(8,11.3), dpi=900)
gs3 = gridspec.GridSpec(6, 1)
mean_error = numpy.empty(7)
zeros = numpy.zeros(len(currents[:,0]))
for i in [0,1,2,3,4,6]:
    if i<6:
        ax = fig2.add_subplot(gs3[i])
    else:
        ax = fig2.add_subplot(gs3[-1])
        ax.set_xlabel('Time (s)')
    error_measure = currents[:,i]-currents[:,5]
    #ax.plot(all_time, error_measure, color='k', lw=1)
    ax.fill_between(all_time,error_measure,zeros,lw=0,color=color_cycle[i])
    ax.set_ylim([-0.6,0.6])
    ax.set_title(model_names[i])
    ax.set_ylabel('Error (nA)')
    error_measure = numpy.sqrt(pow(error_measure,2))
    mean_error[i] = numpy.mean(error_measure)

for i in [0,1,2,3,4,6]:
    print(model_names[i],' mean error = ',mean_error[i],' nA')
    print(model_names[i],' percent increase over New Model Error = ',100*mean_error[i]/mean_error[6]-100,'%')
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.tight_layout()
plt.savefig('errors.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)

plt.figure(0)
start_of_zoom_time = 3.
length_of_zoom_time = 4.3
lower_zoom_voltage = -90
upper_zoom_voltage = 75
lower_zoom_current = -0.02
upper_zoom_current = 1.15
ax5.set_xlim([start_of_zoom_time, start_of_zoom_time+length_of_zoom_time])
ax5.set_ylim([lower_zoom_voltage, upper_zoom_voltage])
ax5.locator_params(nbins=8,axis='y')

ax1.add_patch(
              patches.Rectangle(
                                (start_of_zoom_time, lower_zoom_voltage),   # (x,y)
                                length_of_zoom_time,          # width
                                upper_zoom_voltage-lower_zoom_voltage, # height
                                edgecolor="none",
                                facecolor="grey",
                                alpha=0.2,
                                clip_on=False
                                )
              )

# Current trace
ax2 = fig.add_subplot(gs1[1])
#ax2.set_title('Summat', fontsize=14)
ax2.set_xlim([0, 8])
ax2.set_ylim([-2, 3])
ax2.yaxis.set_major_formatter(FormatStrFormatter('%.1f'))
ax2.add_patch(
              patches.Rectangle(
                                (start_of_zoom_time, lower_zoom_current),   # (x,y)
                                length_of_zoom_time,          # width
                                upper_zoom_current-lower_zoom_current,          # height
                                edgecolor="none",
                                facecolor="grey",
                                alpha=0.2,
                                clip_on=False
                                )
              )
ax2.plot(all_time, currents[:,5],color='r',lw=1)
ax2.plot(all_time, currents[:,6],color=[0,0.45,0.74], lw=1.5)
ax2.set_ylabel('Current (nA)', fontsize=18)
ax2.set_xlabel('Time (s)', fontsize=18)

# Add zoomy shading bit
patch_vertices = numpy.array([[start_of_zoom_time,-2.0],[0,-2.96],[8,-2.96],[start_of_zoom_time+length_of_zoom_time,-2.0]])

polygon_zooming = plt.Polygon(patch_vertices,
                              closed=True,
                              edgecolor="none",
                              facecolor="grey",
                              alpha=0.15,
                              clip_on=False
                              )
ax2.add_artist(polygon_zooming)
plt.tick_params(axis='both', which='major', labelsize=16)




# Current zoom trace
ax3 = fig.add_subplot(gs2[1])
#ax.set_title('Summat', fontsize=14)
ax3.set_ylabel('Current (nA)', fontsize=18)
#ax3.set_xlabel('Time (s)', fontsize=16)
ax3.set_xlim([start_of_zoom_time, start_of_zoom_time+length_of_zoom_time])
ax3.set_ylim([lower_zoom_current, upper_zoom_current])
#ax3.set_prop_cycle(cycler('color',color_cycle[:,4:5]) + cycler('lw',line_width_cycle[:,4:5]))
ax3.plot(all_time, currents[:,5],color='r',lw=1)
[g] = ax3.plot(all_time, currents[:,6],color=[0,0.45,0.74], lw=1.5)
plt.setp(ax3.get_xticklabels(), visible=False)
plt.tick_params(axis='both', which='major', labelsize=16)

# Current zoom trace
ax4 = fig.add_subplot(gs2[2])
#ax.set_title('Summat', fontsize=14)
ax4.set_ylabel('Current (nA)', fontsize=18)
ax4.set_xlabel('Time (s)', fontsize=18)
ax4.set_xlim([start_of_zoom_time, start_of_zoom_time+length_of_zoom_time])
ax4.set_ylim([lower_zoom_current, upper_zoom_current])
ax4.set_prop_cycle(cycler('color',color_cycle) + cycler('lw',line_width_cycle))
[a,b,c,d,e,f] = ax4.plot(all_time, currents[:,[0,1,2,3,4,5]])

# Squeeze the voltage and current plots together
gs1.update(hspace=0.0)
gs2.update(hspace=0.0)

ax4.legend([a,b,c,d,e,f], ["ten Tusscher `04","Mazhari `01","Di Veroli `13","Wang `97","Zeng `95","Experiment"], bbox_to_anchor=(0., -0.42, 1., .102), loc=8, handletextpad=0.05,columnspacing=1.0,
           ncol=6, mode="expand", borderaxespad=0.,prop={'size':17})

ax2.legend([f,g], ["Experiment","New model prediction"], loc=8, handletextpad=0.1, columnspacing=1,
           ncol=2, borderaxespad=1.0,prop={'size':18})

x_text = -0.1
y_text = 1.01

# Line up y labels
for ax in [ax1, ax2, ax3, ax4, ax5]:
    ax.yaxis.set_label_coords(-0.045, 0.5)

# Add subfigure text labels, relative to axes top left
ax1.text(x_text, y_text, 'A', verticalalignment='top', horizontalalignment='left',
         transform=ax1.transAxes,fontsize=23, fontweight='bold')
ax2.text(x_text, y_text, 'B', verticalalignment='top', horizontalalignment='left',
         transform=ax2.transAxes,fontsize=23, fontweight='bold')
ax5.text(x_text, y_text, 'C', verticalalignment='top', horizontalalignment='left',
         transform=ax5.transAxes,fontsize=23, fontweight='bold')
ax3.text(x_text, y_text, 'D', verticalalignment='top', horizontalalignment='left',
         transform=ax3.transAxes,fontsize=23, fontweight='bold')
ax4.text(x_text, y_text, 'E', verticalalignment='top', horizontalalignment='left',
         transform=ax4.transAxes,fontsize=23, fontweight='bold')

#fig.set_tight_layout(True)
#gs.tight_layout(fig, renderer=None, pad=0, h_pad=None, w_pad=None, rect=None)
#plt.tight_layout()
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.tick_params(axis='both', which='major', labelsize=16)
plt.savefig('figure_6.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)

