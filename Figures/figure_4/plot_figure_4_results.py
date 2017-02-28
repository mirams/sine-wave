import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib.patches as patches
from matplotlib.ticker import FormatStrFormatter

from cycler import cycler
import numpy
from os.path import join, exists
import re
import sys
plt.switch_backend('pdf')
plt.tick_params(axis='both', which='minor', labelsize=16)

model_prediction_colour = [0,0.45,0.74]

fig = plt.figure(0, figsize=(8,12), dpi=900)
#fig.text(0.51, 0.9, r'{0}'.format('Title'), ha='center', va='center', fontsize=16)

gs = gridspec.GridSpec(5, 3, height_ratios=[3,3,3,3,3], width_ratios=[1,1,1] )

left_alignment_for_panel_label = -1.00
protocol_names = ['steady_activation','inactivation','deactivation']

for column in range(0,3):
    protocol = protocol_names[column]

    # Plot voltage protocols
    if column==0:
        ax1 = plt.subplot(gs[0,column])
        ax1_col0 = ax1
        ax1.set_title('Steady Activation (Pr3)')
    else:
        ax1 = plt.subplot(gs[0,column], sharey=ax1_col0)
        if column==1:
            ax1.set_title('Inactivation (Pr4)')
        elif column==2:
            ax1.set_title('Deactivation (Pr5)')

    # Load voltage data
    voltage_file = 'figure_4_' + protocol + '/' + 'figure_4_' + protocol + '_protocol.txt'
    data = numpy.loadtxt(voltage_file, skiprows=0)
    all_time = data[:, 0]
    voltages = data[:,1:]
    ax1.plot(all_time,voltages,'k-',lw=0.75)
    ax1.set_xlabel('Time (s)', fontsize=12)
    ax1.set_ylim([-130, 65])
    ax1.set_xlim([0, numpy.amax(all_time)])

    # Plot voltage protocols
    ax2 = plt.subplot(gs[1,column])

    # Experimental data
    data_file = 'figure_4_' + protocol + '/' + 'figure_4_' + protocol + '_experiment.txt'
    data = numpy.loadtxt(data_file, skiprows=0)
    all_time = data[:, 0]
    experimental_currents = data[:,1:]
    ax2.plot(all_time,experimental_currents,'r-',lw=0.5)
    ax2.set_xlabel('Time (s)', fontsize=12)

    # Simulation
    ax3 = plt.subplot(gs[2,column],sharex=ax2,sharey=ax2)
    data_file = 'figure_4_' + protocol + '/' + 'figure_4_' + protocol + '_prediction.txt'
    data = numpy.loadtxt(data_file, skiprows=0)
    all_time = data[:, 0]
    simulated_currents = data[:,1:]
    ax3.plot(all_time,simulated_currents,'-',color=model_prediction_colour,lw=0.8)
    ax3.set_xlabel('Time (s)', fontsize=12)

    if column==0:
        ax1.set_ylabel('Voltage\n(mV)', fontsize=14,rotation=0)
        ax2.set_ylabel('Experimental\nCurrent (nA)', fontsize=14,rotation=0)
        ax3.set_ylabel('Predicted\nCurrent (nA)', fontsize=14,rotation=0)
        start_of_zoom_time = 0.6
        length_of_zoom_time = 5.9
        ax2.set_ylim([-1,2])
    elif column==2:
        start_of_zoom_time = 2.4
        length_of_zoom_time = 5.6
        ax2.set_ylim([-3.5,2])
    elif column==1:
        start_of_zoom_time = 1.2
        length_of_zoom_time = 0.3
        ax2.set_ylim([-5,10])
        ax2.locator_params(axis='x', nbins=4)

    ax2.set_xlim([start_of_zoom_time,start_of_zoom_time+length_of_zoom_time])

    # Put a zoom section on
    lower_voltage, tmp = ax1.get_ylim()
    tmp, upper_v_time = ax1.get_xlim()
    voltage_at_next_axes = -208

    patch_vertices = numpy.array([[start_of_zoom_time,lower_voltage],
                                  [0,voltage_at_next_axes],
                                  [upper_v_time,voltage_at_next_axes],
                                  [start_of_zoom_time+length_of_zoom_time,lower_voltage]])

    ax1.add_artist(plt.Polygon(patch_vertices,
                           closed=True,
                           edgecolor="none",
                           facecolor="grey",
                           alpha=0.15,
                           clip_on=False
                           )
               )

    # Shift axis labels
    axes_list = [ax1, ax2, ax3]
    for ax in axes_list:
        if column==0:
            ax.get_yaxis().set_label_coords(-0.6,0.30)
        ax.get_xaxis().set_label_coords(+0.5,-0.19)

    if column == 0:
        # Add subfigure text labels, relative to axes top left
        ax1.text(left_alignment_for_panel_label, 1.05, 'A', verticalalignment='top', horizontalalignment='left', transform=ax1.transAxes, fontsize=20, fontweight='bold')
        ax2.text(left_alignment_for_panel_label, 1.05, 'B', verticalalignment='top', horizontalalignment='left', transform=ax2.transAxes, fontsize=20, fontweight='bold')
        ax3.text(left_alignment_for_panel_label, 1.05, 'C', verticalalignment='top', horizontalalignment='left', transform=ax3.transAxes, fontsize=20, fontweight='bold')


# Probably easier just to plot all the summary graphs without looping!

def get_model_name(argument):
    switcher = {
        0: "tentusscher",
        1: "mazhari",
        2: "diveroli",
        3: "wang",
        4: "zeng",
        5: "experiment",
        6: "prediction",
    }
    return switcher.get(argument, "nothing")

color_cycle = [[1,0,1], [0.47,0.67,0.19], 'c', [0.49,0.18,0.56],'DarkOrange','r',model_prediction_colour]
line_width_cycle = [0.5,0.5,0.5,0.5,0.5,2,2]
line_style_cycle = ['-','-','-','-','-','--','-']

###########################
# S.S. activation IV curve
###########################
ax4 = plt.subplot(gs[3,0])

###########################
# S.S. activation tau curve - not plotting this as it isn't something usually seen!
###########################
#ax5 = plt.subplot(gs[4,0])

###########################
# deactivation - deactivation tau curve
###########################
ax6 = plt.subplot(gs[3,2])

###########################
# deactivation - recovery from inactivtion tau curve
###########################
ax7 = plt.subplot(gs[4,2])

###########################
# inactivtion- instantaneous inactivation tau curve
###########################
ax8 = plt.subplot(gs[3,1])

legend_entry = []

for model_idx in range(0,7):
    file_name = 'figure_4_steady_activation/figure_4_steady_activation_iv_curve/figure_4_steady_activation_iv_' + get_model_name(model_idx) +'.txt'
    data = numpy.loadtxt(file_name,skiprows=0)
    ax4.plot(data[:,0],data[:,1],'.'+line_style_cycle[model_idx],color=color_cycle[model_idx],lw=line_width_cycle[model_idx])
    
#    file_name = 'figure_4_steady_activation/figure_4_steady_activation_tau_v_curve/figure_4_steady_activation_tau_v_' + get_model_name(model_idx) +'.txt'
#    data = numpy.loadtxt(file_name,skiprows=0)
#    ax5.semilogy(data[:,0],data[:,1],'.'+line_style_cycle[model_idx],color=color_cycle[model_idx],lw=line_width_cycle[model_idx])

    file_name = 'figure_4_deactivation/figure_4_deactivation_tau_v/figure_4_deactivation_tau_v_' + get_model_name(model_idx) +'.txt'
    data = numpy.loadtxt(file_name,skiprows=0)
    [a] = ax6.semilogy(data[:,0],data[:,1],'.'+line_style_cycle[model_idx],color=color_cycle[model_idx],lw=line_width_cycle[model_idx])
    legend_entry.append(a)
    
    # Don't plot inactivation or instantaneous inactivation tau curves for TT or Zeng, simulated curves not comparable.
    if (get_model_name(model_idx) != "tentusscher") and (get_model_name(model_idx) != "zeng"):
        file_name = 'figure_4_inactivation/figure_4_instantaneous_inactivation_tau/figure_4_instantaneous_inactivation_tau_v_' + get_model_name(model_idx) +'.txt'
        data = numpy.loadtxt(file_name,skiprows=0)
        ax8.plot(data[:,0],data[:,1],'.'+line_style_cycle[model_idx],color=color_cycle[model_idx],lw=line_width_cycle[model_idx])

    if (get_model_name(model_idx) != "tentusscher") and (get_model_name(model_idx) != "zeng"):
        file_name = 'figure_4_deactivation/figure_4_inactivation_tau_v/figure_4_inactivation_tau_v_' + get_model_name(model_idx) +'.txt'
        data = numpy.loadtxt(file_name,skiprows=0)
        ax7.plot(data[:,0],data[:,1],'.'+line_style_cycle[model_idx],color=color_cycle[model_idx],lw=line_width_cycle[model_idx])


ax4.set_xlabel('Voltage (mV)', fontsize=12)
ax4.set_ylabel('Current\n(normalized)', fontsize=12)
ax4.get_yaxis().set_label_coords(-0.26,0.5)
ax4.get_xaxis().set_label_coords(0.5,-0.19)

#ax5.set_xlabel('Voltage (mV)', fontsize=12)
#ax5.set_ylabel(r'Time constant $\tau$ (ms)', fontsize=12)
#ax5.set_ylim([8,10000])
#ax5.get_yaxis().set_label_coords(-0.3,0.4)
#ax5.get_xaxis().set_label_coords(0.5,-0.19)

ax6.set_xlabel('Voltage (mV)', fontsize=12)
ax6.set_ylabel(r'Deactivation $\tau$ (ms)', fontsize=12)
ax6.get_yaxis().set_label_coords(-0.16,0.5)
ax6.set_ylim([1,4000])
ax6.get_xaxis().set_label_coords(0.5,-0.19)

ax7.set_xlabel('Voltage (mV)', fontsize=12)
ax7.set_ylabel(r'Recovery inact. $\tau$ (ms)', fontsize=12)
ax7.get_yaxis().set_label_coords(-0.16,0.4)
ax7.get_xaxis().set_label_coords(0.5,-0.19)

ax8.set_xlabel('Voltage (mV)', fontsize=12)
ax8.set_ylabel(r'Inactivation $\tau$ (ms)', fontsize=12)
ax8.get_yaxis().set_label_coords(-0.16,0.5)
ax8.get_xaxis().set_label_coords(0.5,-0.19)
ax8.set_xlim([-50, 50])

ax6.locator_params(axis='x', nbins=4)
ax7.locator_params(axis='x', nbins=4)
ax7.locator_params(axis='y', nbins=6)
#ax5.locator_params(axis='y', nbins=6)
ax8.locator_params(axis='y', nbins=6)


ax4.text(-130, -0.4, 'Summary\nPlots', ha='center', fontsize=14)


ax7.legend(legend_entry, ["ten Tusscher `04","Mazhari `01","Di Veroli `13","Wang `97","Zeng `95","Experiment", "New model"], title="Legend", bbox_to_anchor=(-2.7, 0, 2.35, 1.5), loc='lower left', handletextpad=0.5,borderpad=0.5,labelspacing=0.35,columnspacing=4.5, ncol=2, borderaxespad=0.,fontsize=12)


ax4.text(left_alignment_for_panel_label, 1.05, 'D', verticalalignment='top', horizontalalignment='left',
         transform=ax4.transAxes,fontsize=20, fontweight='bold')

#legend = ax4.legend(loc='center', shadow=False)
gs.update(wspace=0.35, hspace=0.4)
#fig.set_tight_layout(True)
#gs.tight_layout(fig, renderer=None, pad=0, h_pad=None, w_pad=None, rect=None)
#plt.tight_layout()
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.subplots_adjust(top=0.75, wspace=0.25)
plt.savefig('figure_4.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)
