import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib.patches as patches
from matplotlib.ticker import FormatStrFormatter, ScalarFormatter

import numpy
from os.path import join, exists
import re
import sys
plt.switch_backend('pdf')
plt.tick_params(axis='both', which='minor', labelsize=16)

voltage_file = 'figure_3_a/figure_3_model_fit_protocol.txt'
data = numpy.loadtxt(voltage_file, skiprows=0)
all_time = data[:, 0]
voltage = data[:,1]

fig = plt.figure(0, figsize=(10,7), dpi=900)
#fig.text(0.51, 0.9, r'{0}'.format('Title'), ha='center', va='center', fontsize=16)

start_of_zoom_time = 4.  # seconds
length_of_zoom_time = 2. # seconds
low_zoom_current = -1.1  # nA
high_zoom_current = 1.3  # nA

########################################################
## Full plot of sine wave voltage protocol and current
########################################################
gs1 = gridspec.GridSpec(2, 1, height_ratios=[1,2],top=1.0,bottom=0.55,left=0.0,right=0.6 )
ax1 = fig.add_subplot(gs1[0])
ax2 = fig.add_subplot(gs1[1], sharex=ax1)
plt.setp(ax1.get_xticklabels(), visible=False)

# Voltage trace
#ax1.set_title('Summat', fontsize=14)
ax1.set_ylabel('Voltage (mV)', fontsize=14)
#ax1.set_xlabel('Time (s)')
#plt.setp(ax.get_xticklabels(), visible=False)
ax1.set_xlim([0, 8])
ax1.set_ylim([-130, 65])

#ax1.set_yticklabels([r'$-10$', r'$-5$', r'$0$', r'$5$', r'$10$', r'$15$', r'$20$'])
#ax1.set_xticklabels([r'$10^{-3}$', r'$10^{-2}$', r'$10^{-1}$', r'$10^0$', r'$10^1$', r'$10^2$'])
ax1.plot(all_time, voltage, color='k', lw=2)
# Shade in the zoomed in region
ax1.add_patch(
              patches.Rectangle(
                                (start_of_zoom_time, -130),     # (x,y)
                                length_of_zoom_time,            # width
                                60-(-130),                      # height
                                edgecolor="none",
                                facecolor="grey",
                                alpha=0.2,
                                clip_on=False
                                )
              )

experiment_file = 'figure_3_a/figure_3_model_fit_experimental_data.txt'
#file = open(experiment_file, 'r')
data = numpy.loadtxt(experiment_file, skiprows=0)
experimental_current = data[:,1]

current_file ='figure_3_a/figure_3_model_fit_new_model_fit.txt'
data = numpy.loadtxt(current_file, skiprows=0)
fitted_simulated_current = data[:,1]

# Current trace
#ax2.set_title('Summat', fontsize=14)
ax2.set_xlim([0, 8])
lower_current = -3.2
ax2.set_ylim([lower_current, 1.5])
ax2.yaxis.set_major_formatter(FormatStrFormatter('%.1f'))

# Shade in the zoomed in region
ax2.add_patch(
             patches.Rectangle(
                               (start_of_zoom_time, low_zoom_current),   # (x,y)
                               length_of_zoom_time,                 # width
                               high_zoom_current-low_zoom_current,  # height
                               edgecolor="none",
                               facecolor="grey",
                               alpha=0.2,
                               clip_on=False
                               )
             )
[a] = ax2.plot(all_time, experimental_current,color='r',lw=1)
[b] = ax2.plot(all_time, fitted_simulated_current,color=[0,0.45,0.74], lw=1)
ax2.set_ylabel('Current (nA)', fontsize=14)
ax2.set_xlabel('Time (s)', fontsize=14)

ax2.legend([a,b], ["Experiment","Fitted model"], loc=8, handletextpad=0.1, columnspacing=1,
           ncol=2, borderaxespad=1)

# Add the little zoom patch between plots
patch_vertices = numpy.array([[start_of_zoom_time,lower_current],[0,-4.45],[8,-4.45],[start_of_zoom_time+length_of_zoom_time,lower_current]])

polygon1 = plt.Polygon(patch_vertices,
                       closed=True,
                       edgecolor="none",
                       facecolor="grey",
                       alpha=0.15,
                       clip_on=False
                       )
ax2.add_artist(polygon1)

########################################################
## Plot zoomed in voltage protocol and current
########################################################
gs2 = gridspec.GridSpec(2, 1, height_ratios=[1,2],top=0.47, bottom=0.0,left=0.0,right=0.6)
ax3 = fig.add_subplot(gs2[0])
ax4 = fig.add_subplot(gs2[1], sharex=ax3)
plt.setp(ax3.get_xticklabels(), visible=False)
# Voltage zoom trace
#ax3.set_title('Summat', fontsize=14)
ax3.set_ylabel('Voltage (mV)', fontsize=14)

#ax3.set_xlabel('Time (s)')
#plt.setp(ax.get_xticklabels(), visible=False)
ax3.set_xlim([start_of_zoom_time, start_of_zoom_time+length_of_zoom_time])
ax3.set_ylim([-130, 65])
#ax3.set_yticklabels([r'$-10$', r'$-5$', r'$0$', r'$5$', r'$10$', r'$15$', r'$20$'])
#ax3.set_xticklabels([r'$10^{-3}$', r'$10^{-2}$', r'$10^{-1}$', r'$10^0$', r'$10^1$', r'$10^2$'])
ax3.plot(all_time, voltage, color='k', lw=2)


# Current zoom trace
ax4 = plt.subplot(gs2[1])
#ax4.set_title('Summat', fontsize=14)
ax4.set_ylabel('Current (nA)', fontsize=14)
ax4.set_xlabel('Time (s)', fontsize=14)
ax4.set_xlim([start_of_zoom_time, start_of_zoom_time+length_of_zoom_time])
ax4.set_ylim([low_zoom_current, high_zoom_current])
#ax4.set_prop_cycle(cycler('color',color_cycle[:,4:5]) + cycler('lw',line_width_cycle[:,4:5]))
ax4.plot(all_time, experimental_current,color='r',lw=1)
[f] = ax4.plot(all_time, fitted_simulated_current,color=[0,0.45,0.74], lw=1)


# Squeeze the voltage and current plots together
gs1.update(hspace=0.0)
gs2.update(hspace=0.0)

################################################################################
# PLOT THE SCHEMATIC - unfortunately it doesn't seem to import PDF, so use .png
################################################################################
gs4 = gridspec.GridSpec(1, 1, top=1, bottom=0.75, left=0.67, right=1.0)

ax5 = fig.add_subplot(gs4[0,0])
image = plt.imread('figure_3_b.png')
im = ax5.imshow(image)
ax5.axis('off')

gs3 = gridspec.GridSpec(3, 3, top=0.73, bottom=0.0,left=0.67,right=1.0)
gs3.update(hspace=0.65)
gs3.update(wspace=0.07)

########################################################
## Plot histograms
########################################################

data = numpy.loadtxt('figure_3_c/MCMC_likelihood_and_samples.txt', skiprows=0)
likelihoods = data[:,0]
max_likelihood_index = numpy.argmax(likelihoods)
print('Maximum likelihood at index',max_likelihood_index)

# Remove 'burn in'
data = data[50001:,:]

ax6 = fig.add_subplot(gs3[0,0])
weights = numpy.ones_like(data[:,1])/float(len(data[:,1]))
ax6.hist(data[:,1], 20, normed=0, weights=weights, facecolor='r', edgecolor = "none", alpha=0.75)
ax6.set_ylabel('Probability')
ax6.set_xlabel('$P_1$')
ax6.yaxis.set_major_formatter(FormatStrFormatter('%.2f'))

ax7 = fig.add_subplot(gs3[0,1],sharey=ax6)
weights = numpy.ones_like(data[:,2])/float(len(data[:,2]))
ax7.hist(data[:,2], 20, normed=0, weights=weights, facecolor='r', edgecolor = "none", alpha=0.75)
ax7.set_xlabel('$P_2$')

ax8 = fig.add_subplot(gs3[0,2],sharey=ax6)
weights = numpy.ones_like(data[:,3])/float(len(data[:,3]))
ax8.hist(data[:,3], 20, normed=0, weights=weights, facecolor='r', edgecolor = "none", alpha=0.75)
ax8.set_xlabel('$P_3$')
ax8.set_ylim([0., .2]) # This needs to be on the LAST of the shared axis plots (otherwise gets overridden)

ax9 = fig.add_subplot(gs3[1,0])
weights = numpy.ones_like(data[:,4])/float(len(data[:,4]))
ax9.hist(data[:,4], 20, normed=0, weights=weights, facecolor='r', edgecolor = "none", alpha=0.75)
ax9.set_ylabel('Probability')
ax9.set_xlabel('$P_4$')
ax9.yaxis.set_major_formatter(FormatStrFormatter('%.2f'))

ax10 = fig.add_subplot(gs3[1,1],sharey=ax9)
weights = numpy.ones_like(data[:,5])/float(len(data[:,5]))
ax10.hist(data[:,5], 20, normed=0, weights=weights, facecolor='r', edgecolor = "none", alpha=0.75)
ax10.set_xlabel('$P_5$')

ax11 = fig.add_subplot(gs3[1,2],sharey=ax9)
weights = numpy.ones_like(data[:,6])/float(len(data[:,6]))
ax11.hist(data[:,6], 20, normed=0, weights=weights, facecolor='r', edgecolor = "none", alpha=0.75)
ax11.set_xlabel('$P_6$')
ax11.set_ylim([0., .2])

ax12 = fig.add_subplot(gs3[2,0])
weights = numpy.ones_like(data[:,7])/float(len(data[:,7]))
ax12.hist(data[:,7], 20, normed=0, weights=weights, facecolor='r', edgecolor = "none", alpha=0.75)
ax12.set_ylabel('Probability')
ax12.set_xlabel('$P_7$')
ax12.yaxis.set_major_formatter(FormatStrFormatter('%.2f'))

ax13 = fig.add_subplot(gs3[2,1],sharey=ax12)
weights = numpy.ones_like(data[:,8])/float(len(data[:,8]))
ax13.hist(data[:,8], 20, normed=0, weights=weights, facecolor='r', edgecolor = "none", alpha=0.75)
ax13.set_xlabel('$P_8$')

ax14 = fig.add_subplot(gs3[2,2],sharey=ax12)
weights = numpy.ones_like(data[:,9])/float(len(data[:,9]))
ax14.hist(data[:,9], 20, normed=0, weights=weights, facecolor='r', edgecolor = "none", alpha=0.75)
ax14.set_xlabel('Conductance')
ax14.set_ylim([0., .2])
#ax14.xaxis.set_major_formatter(FormatStrFormatter('%5.4g'))
#ax14.set_xticklabels(ax14.xaxis.get_majorticklabels(), rotation=90)

# Don't show y tick labels on most of the histograms
plt.setp(ax7.get_yticklabels(), visible=False)
plt.setp(ax8.get_yticklabels(), visible=False)
plt.setp(ax10.get_yticklabels(), visible=False)
plt.setp(ax11.get_yticklabels(), visible=False)
plt.setp(ax13.get_yticklabels(), visible=False)
plt.setp(ax14.get_yticklabels(), visible=False)

#xfmt = ScalarFormatter(useOffset=False)
#xfmt.set_powerlimits((-3,3))

axes_list = [ax6,ax7,ax8,ax9,ax10,ax11,ax12,ax13,ax14]
for i in range(0,9):
    ax = axes_list[i]
    ax.locator_params(tight=True, nbins=5)
    #ax.xaxis.set_major_formatter(xfmt)
    ax.get_xaxis().get_major_formatter().set_useOffset(False)
    ax.get_xaxis().get_major_formatter().set_scientific(True)
    ax.get_xaxis().get_major_formatter().set_powerlimits([-3,1])
    for label in ax.get_xticklabels():
        label.set_rotation(305)
        label.set_horizontalalignment("left")
    ax.plot(data[max_likelihood_index,i+1], 0, 'kx', markersize=10, markeredgewidth=3, clip_on=False)
    if i==8:
        ax.get_xaxis().set_label_coords(+0.5,0.93)
    else:
        ax.get_xaxis().set_label_coords(+0.1,0.93)

########################################################
# Add subfigure text labels, relative to axes top left
########################################################
left_shift_for_panel_labels = -0.15
ax1.text(left_shift_for_panel_labels, 1.05, 'A', verticalalignment='top', horizontalalignment='left',
         transform=ax1.transAxes,fontsize=20, fontweight='bold')
ax5.text(-0.175, 1.10, 'B', verticalalignment='top', horizontalalignment='left',
         transform=ax5.transAxes,fontsize=20, fontweight='bold')
ax3.text(left_shift_for_panel_labels, 1.05, 'D', verticalalignment='top', horizontalalignment='left',
         transform=ax3.transAxes,fontsize=20, fontweight='bold')
ax6.text(-0.6, 1.15, 'C', verticalalignment='top', horizontalalignment='left',
         transform=ax6.transAxes,fontsize=20, fontweight='bold')


########################################################
# FINAL PLOT OUTPUT
########################################################
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.savefig('figure_3.pdf', bbox_inches='tight', dpi=900, pad_inches=0.05)
