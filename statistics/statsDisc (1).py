#######################################################################################
# Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
# Engineering - Etchverry 2162
#
# Processing disc geometry measurement data and computing summary statistics across 
# control/kyphotic + regions of interest experimental groups.
#
#######################################################################################

import os
import spm1d

import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt

# path of the segmentation measurement data:
folderPath = "C:\\Users\\16233\\Desktop\\grad\\projects\\scoliosis\\subject measurements\\subject statistical modeling\\disc measurement summaries"
fileName = "summary_arrays.mat"

# looping summary array files:
filePath = os.path.join(folderPath, fileName)
dataMat = sio.loadmat(filePath)

# disc wedging data:
wedge_ca = dataMat['wedge_ca_summary']
wedge_ka = dataMat['wedge_ka_summary']
wedge_cb = dataMat['wedge_cb_summary']
wedge_kb = dataMat['wedge_kb_summary']

# disc volume data:
vol_ca = dataMat['vol_ca_summary']
vol_ka = dataMat['vol_ka_summary']
vol_cb = dataMat['vol_cb_summary']
vol_kb = dataMat['vol_kb_summary']

# disc total surface area data:
sa_ca = dataMat['sa_ca_summary']
sa_ka = dataMat['sa_ka_summary']
sa_cb = dataMat['sa_cb_summary']
sa_kb = dataMat['sa_kb_summary']

# disc inferior surface area data:
saI_ca = dataMat['saI_ca_summary']
saI_ka = dataMat['saI_ka_summary']
saI_cb = dataMat['saI_cb_summary']
saI_kb = dataMat['saI_kb_summary']

# disc superior surface area data:
saS_ca = dataMat['saS_ca_summary']
saS_ka = dataMat['saS_ka_summary']
saS_cb = dataMat['saS_cb_summary']
saS_kb = dataMat['saS_kb_summary']

def plot_spatial_variable(ca: np.ndarray, ka: np.ndarray, cb: np.ndarray, kb: np.ndarray, xlab: str, ylab: str, roia_lab: str, roib_lab: str, name: str, alpha=0.05):
    """
    Plots the summary statistics and statistical tests of the given goemetric spatial variable
    which is partitioned into regions of interest (ROIa an ROIb) and experimentally seperated into
    control and kyphotic groups as such:
        ca ~ control, ROIa data
        ka ~ kyphotic, ROIa data
        cb ~ control, ROIb data
        kb ~ kyphotic, ROIb data

        * statistical test assumptions:
             --> unequal variance between control and kyphotic groups
             --> hypothesis is one-directional

    Args:
        ca (np.ndarray): control, ROIa array of spatial variable
        ka (np.ndarray): kyphotic, ROIa array of spatial variable
        cb (np.ndarray): control, ROIb array of spatial variable
        kb (np.ndarray): kyphotic, ROIb array of spatial variable
        xlab (string): name of xlabel associated with spatial variable
        ylab (string): name of ylabel associated with spatial variable
        roia_lab (string): name of ROIa label associated with spatial variable
        roib_lab (string): name of ROIb label associated with spatial variable
        name (string): name of spatial variable
    
    Returns:
        None
    """
    # contructing plotting objects:
    f = ca.shape[1] # sampling frequency of spatial variable
    normx = np.linspace(0.0, 1.0, num=f, endpoint=True)
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2)
    
    # plotting mean and standard deviation cloud distribution:
    spm1d.plot.plot_mean_sd(ca, x=normx, ax=ax1, linecolor='b', facecolor=(0.7,0.7,1), edgecolor='b', label='control')
    spm1d.plot.plot_mean_sd(ka, x=normx, ax=ax1, linecolor='r', facecolor=(1,0.7,0.7), edgecolor='r', label='kyphotic')
    spm1d.plot.plot_mean_sd(cb, x=normx, ax=ax2, linecolor='b', facecolor=(0.7,0.7,1), edgecolor='b', label='control')
    spm1d.plot.plot_mean_sd(kb, x=normx, ax=ax2, linecolor='r', facecolor=(1,0.7,0.7), edgecolor='r', label='kyphotic')

    # labeling the figure:
    fig.suptitle("Summary statistics and two-sample t-tests for %s distribution" % (name))
    ymina = np.min([np.min(ca), np.min(ka)])
    yminb = np.min([np.min(cb), np.min(kb)])
    ymaxa = np.max([np.max(ca), np.max(ka)])
    ymaxb = np.max([np.max(cb), np.max(kb)])
    ymin = np.min([ymina, yminb])
    ymax = np.max([ymaxa, ymaxb])
    ax1.set_ylim(ymin, ymax)
    ax2.set_ylim(ymin, ymax)
    ax1.set_ylabel(ylab, fontsize='large')
    ax2.set_ylabel(ylab, fontsize='large')
    ax3.set(xlabel="normalized position along %s " % (xlab))
    ax4.set(xlabel="normalized position along %s " % (xlab))
    ax1.set_title(roia_lab + ' section')
    ax2.set_title(roib_lab + ' section')
    ax1.legend(loc='lower right')
    ax2.legend(loc='lower right')

    # computing statistical test distributions:
    # statistical test assumptions,
    #       equal-variance --> False (different groups of observations can have different variances)
    #       two-tailed --> False (hypothesis is one-directional)
    #       interp --> True (interpolate to more accurately estimate the location and size of threshold crossings (clusters) between the discrete nodes of your data)
    try: # checks for zero variance at boundaries of data
        ta = spm1d.stats.ttest2(ca, ka, equal_var=False) # ROIa test
        tb = spm1d.stats.ttest2(cb, kb, equal_var=False) # ROIb test
    except spm1d.stats._datachecks.SPM1DError:
        ta = spm1d.stats.ttest2(ca[:, 1:-1], ka[:, 1:-1], equal_var=False) # ROIa test
        tb = spm1d.stats.ttest2(cb[:, 1:-1], kb[:, 1:-1], equal_var=False) # ROIb test
    tai = ta.inference(alpha=alpha, two_tailed=False, interp=True) # ROIa inference
    tbi = tb.inference(alpha=alpha, two_tailed=False, interp=True) # ROIb inference

    # plotting significance distribution:
    # figure characteristics,
    #       --> thick black line depicts the test statistic continuum
    #       --> p-value indicates the probability that smooth, random continua would produce a 
    #           supra-threshold cluster as broad as the observed cluster
    #       --> red hashed line depicts the critical threshold at alpha = 5% such that the null 
    #           hypothesis is rejected at alpha if the SPM{t} exceeds this threshold
    tai.plot(ax=ax3)
    tbi.plot(ax=ax4)
    tai.plot_p_values(ax=ax3)
    tbi.plot_p_values(ax=ax4)
    tai.plot_threshold_label(ax=ax3)
    tbi.plot_threshold_label(ax=ax4)

    # normalizing x-axis: relabeling from [0, f] to [0.0, 1.0]
    nn = 6
    xticks = np.linspace(0, f, nn)
    xticklabels = np.linspace(0, 1, nn)
    ax3.set_xticks(xticks)
    ax3.set_xticklabels([f'{x:.1f}' for x in xticklabels])
    ax4.set_xticks(xticks)
    ax4.set_xticklabels([f'{x:.1f}' for x in xticklabels])
        
    # showing the subplot figure:
    plt.show()

def plot_position_variable(ca: np.ndarray, ka: np.ndarray, cb: np.ndarray, kb: np.ndarray, xaticks: np.array, xbticks: np.array, ylab: str, roia_lab: str, roib_lab: str, name: str, alpha=0.05, two_tailed=False):
    """
    Plots the summary statistics and statistical tests of the given goemetric position variable
    which is partitioned into regions of interest (ROIa an ROIb) and experimentally seperated into
    control and kyphotic groups as such:
        ca ~ control, ROIa data
        ka ~ kyphotic, ROIa data
        cb ~ control, ROIb data
        kb ~ kyphotic, ROIb data

        * statistical test assumptions:
             --> unequal variance between control and kyphotic groups
             --> hypothesis is one-directional

    Args:
        ca (np.ndarray): control, ROIa array of position variable
        ka (np.ndarray): kyphotic, ROIa array of position variable
        cb (np.ndarray): control, ROIb array of position variable
        kb (np.ndarray): kyphotic, ROIb array of position variable
        xaticks (np.narray): x-axis tick labels associated with ROIa
        xbticks (np.narray): x-axis tick labels associated with ROIb
        ylab (string): name of ylabel associated with position variable
        roia_lab (string): name of ROIa label associated with position variable
        roib_lab (string): name of ROIb label associated with position variable
        name (string): name of position variable
    
    Returns:
        None
    """
    # contructing plotting objects:
    fa = ca.shape[1] # sampling frequency of position variable wrt ROIa section
    fb = cb.shape[1] # sampling frequency of position variable wrt ROIb section
    normxa = np.linspace(0.0, 1.0, num=fa, endpoint=True)
    normxb = np.linspace(0.0, 1.0, num=fb, endpoint=True)
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2)
    
    # plotting mean and standard deviation cloud distribution:
    spm1d.plot.plot_mean_sd(ca, x=normxa, ax=ax1, linecolor='b', facecolor=(0.7,0.7,1), edgecolor='b', label='control')
    spm1d.plot.plot_mean_sd(ka, x=normxa, ax=ax1, linecolor='r', facecolor=(1,0.7,0.7), edgecolor='r', label='kyphotic')
    spm1d.plot.plot_mean_sd(cb, x=normxb, ax=ax2, linecolor='b', facecolor=(0.7,0.7,1), edgecolor='b', label='control')
    spm1d.plot.plot_mean_sd(kb, x=normxb, ax=ax2, linecolor='r', facecolor=(1,0.7,0.7), edgecolor='r', label='kyphotic')

    # labeling the figure:
    fig.suptitle("Summary statistics and non-parametric two-sample t-tests for %s distribution" % (name))
    ymina = np.min([np.min(ca), np.min(ka)])
    yminb = np.min([np.min(cb), np.min(kb)])
    ymaxa = np.max([np.max(ca), np.max(ka)])
    ymaxb = np.max([np.max(cb), np.max(kb)])
    ymin = np.min([ymina, yminb])
    ymax = np.max([ymaxa, ymaxb])
    ax1.set_ylim(ymin, ymax)
    ax2.set_ylim(ymin, ymax)
    ax1.set_ylabel(ylab, fontsize='large')
    ax2.set_ylabel(ylab, fontsize='large')
    ax3.set(xlabel="position along spine")
    ax4.set(xlabel="position along spine")
    ax1.set_title(roia_lab + ' section')
    ax2.set_title(roib_lab + ' section')
    ax1.legend(loc='upper left')
    ax2.legend(loc='upper left')

    # normalizing x-axis: relabel from [0.0, 1.0] to [T1, L6]
    xaticks_range = np.linspace(0.0, 1.0, fa)
    xbticks_range = np.linspace(0.0, 1.0, fb)
    xaticksn_range = np.linspace(0.0, fa - 1, fa)
    xbticksn_range = np.linspace(0.0, fb - 1, fb)
    ax1.set_xticks(xaticks_range)
    ax1.set_xticklabels(xaticks)
    ax2.set_xticks(xbticks_range)
    ax2.set_xticklabels(xbticks)
    ax3.set_xticks(xaticksn_range)
    ax3.set_xticklabels(xaticks)
    ax4.set_xticks(xbticksn_range)
    ax4.set_xticklabels(xbticks)

    # computing statistical test distributions:
    # statistical test assumptions,
    #       nonparam --> data is not normally distributed
    #       two-tailed --> False (hypothesis is one-directional)
    #       interp --> True (interpolate to more accurately estimate the location and size of threshold crossings (clusters) between the discrete nodes of your data)
    try: # checks for zero variance at boundaries of data
        ta = spm1d.stats.nonparam.ttest2(ca, ka) # ROIa test
        tb = spm1d.stats.nonparam.ttest2(cb, kb) # ROIb test
    except spm1d.stats._datachecks.SPM1DError:
        ta = spm1d.stats.nonparam.ttest2(ca[:, 1:-1], ka[:, 1:-1]) # ROIa test
        tb = spm1d.stats.nonparam.ttest2(cb[:, 1:-1], kb[:, 1:-1]) # ROIb test
    tai = ta.inference(alpha=alpha, two_tailed=two_tailed, interp=True, iterations=-1) # ROIa inference
    tbi = tb.inference(alpha=alpha, two_tailed=two_tailed, interp=True, iterations=-1) # ROIb inference

    # plotting significance distribution:
    # figure characteristics,
    #       --> thick black line depicts the test statistic continuum
    #       --> p-value indicates the probability that smooth, random continua would produce a 
    #           supra-threshold cluster as broad as the observed cluster
    #       --> red hashed line depicts the critical threshold at alpha = 5% such that the null 
    #           hypothesis is rejected at alpha if the SPM{t} exceeds this threshold
    tai.plot(ax=ax3)
    tbi.plot(ax=ax4)
    tai.plot_p_values(ax=ax3)
    tbi.plot_p_values(ax=ax4)
    tai.plot_threshold_label(ax=ax3)
    tbi.plot_threshold_label(ax=ax4)
        
    # showing the subplot figure:
    plt.show()

# plotting disc-position variable summary statistic and statistical test distributions:
# disc-position variables include,
#       disc wedging VS position along spine
#       disc volume VS position along spine
#       disc total surface area VS position along spine
#       disc inferior surface area VS position along spine
#       disc superior surface area VS position along spine
ROIa_label = dataMat['DisplayNameIa'][0]
ROIb_label = dataMat['DisplayNameIb'][0]
xaticklabels = np.array([item[0] for item in dataMat['ROIa_levels'][0]], dtype='<U7')
xbticklabels = np.array([item[0] for item in dataMat['ROIb_levels'][0]], dtype='<U7')
plot_position_variable(wedge_ca, wedge_ka, wedge_cb, wedge_kb, xaticks=xaticklabels, xbticks=xbticklabels, ylab="wedging [deg]", roia_lab=ROIa_label, roib_lab = ROIb_label, name="disc wedging", two_tailed=True)
plot_position_variable(vol_ca, vol_ka, vol_cb, vol_kb, xaticks=xaticklabels, xbticks=xbticklabels, ylab="volume [mm^3]", roia_lab=ROIa_label, roib_lab = ROIb_label, name="disc volume", two_tailed=True)
plot_position_variable(sa_ca, sa_ka, sa_cb, sa_kb, xaticks=xaticklabels, xbticks=xbticklabels, ylab="surface area [mm^2]", roia_lab=ROIa_label, roib_lab = ROIb_label, name="disc total surface area", two_tailed=True)
plot_position_variable(saI_ca, saI_ka, saI_cb, saI_kb, xaticks=xaticklabels, xbticks=xbticklabels, ylab="surface area [mm^2]", roia_lab=ROIa_label, roib_lab = ROIb_label, name="disc inferior surface area", two_tailed=True)
plot_position_variable(saS_ca, saS_ka, saS_cb, saS_kb, xaticks=xaticklabels, xbticks=xbticklabels, ylab="surface area [mm^2]", roia_lab=ROIa_label, roib_lab = ROIb_label, name="disc superior surface area", two_tailed=True)
