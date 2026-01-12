# Import statements
import spm1d
import numpy as np
import matplotlib.pyplot as plt

def runSPM1D(Yc, Yk, lvlRange, *,xMode="norm",alpha=0.05,equal_var=False,two_tailed=False,plotRaw=False,overlaySPM=False,title="",ylabel="Measurement"):
    """
    Runs two-sample 1D SPM t-test and plots results.

    Parameters
    ----------
    Yc, Yk : (N x Q) arrays
        Control and kyphotic summary arrays
    lvlRange : (M,) array
        Levels associated with measurement
    plotRaw : bool
        If True, plot individual subject curves
    overlaySPM : bool
        If True, plot SPM statistics and mean and STD clouds on the same axes
    """

    plt.rcParams["font.family"] = "serif"
    plt.rcParams["font.serif"] = ["Times New Roman"]

    Q = Yc.shape[1]

    ## DATA PROCESSING ##
    mask = validNodes(Yc, Yk)
    Yc = Yc[:, mask]
    Yk = Yk[:, mask]

    if not np.any(mask):
        raise RuntimeError("No valid nodes remain after masking.")
    if Yc.shape[0] < 2 or Yk.shape[0] < 2:
        raise RuntimeError("Insufficient subjects after cleaning.")

    ## SPM TEST ##
    ttest = spm1d.stats.ttest2(Yc, Yk, equal_var=equal_var)
    inference = ttest.inference(
        alpha=alpha,
        two_tailed=two_tailed,
        interp=True
    )

    ## PLOTTING ##
    target_size_inches = 6.4
    fig = plt.figure(figsize=(target_size_inches, target_size_inches))

    # ==========================
    # OVERLAY MODE
    # ==========================
    if overlaySPM:

        ax = fig.add_subplot(111)

        x = np.arange(Yc.shape[1])

        # --- Raw curves ---
        if plotRaw:
            for i in range(Yc.shape[0]):
                ax0.plot(x, Yc[i, :], color='r', alpha=0.25, linewidth=0.8)
            for i in range(Yk.shape[0]):
                ax0.plot(x, Yk[i, :], color='b', alpha=0.25, linewidth=0.8)

        ax.set_ylabel(ylabel)

        # --- SPM axis ---
        ax_spm = ax.twinx()
        inference.plot(ax=ax_spm, color='k', lw=1.25)
        inference.plot_threshold_label(ax=ax_spm)
        inference.plot_p_values(ax=ax_spm)

        ax_spm.set_ylabel("SPM{t}")

        # --------------------------
        # Plot means
        # --------------------------
        mc = np.nanmean(Yc, axis=0)
        mk = np.nanmean(Yk, axis=0)

        ax.plot(
            x, mc,
            color='r',
            linewidth=2.5,
            label='Control',
            zorder=10
        )
        ax.plot(
            x, mk,
            color='b',
            linewidth=2.5,
            label='Kyphotic',
            zorder=10
        )

        # --- Title ---
        ax.set_title(
            title + ' (Levels: ' + lvlRange[0] + ' → ' + lvlRange[-1] + ')'
        )

        # --- Legend (measurement only) ---
        ax.legend(loc='upper left')

        # --- X-axis handling ---
        if xMode == "norm":
            nn = 6
            xticks = np.linspace(0, Yc.shape[1] - 1, nn)
            xticklabels = np.linspace(0, 100, nn)
            ax.set_xticks(xticks)
            ax.set_xticklabels([f"{x:.0f}" for x in xticklabels])
            ax.set_xlabel("Measurement domain (%)")

        elif xMode == "levels":
            xticks = np.arange(len(lvlRange))
            ax.set_xticks(xticks)
            ax.set_xticklabels(lvlRange)
            ax.set_xlabel("Spinal position")

        else:
            raise ValueError("xMode must be 'norm' or 'levels'.")

    # ==========================
    # CLASSIC 2-PANEL MODE
    # ==========================
    else:
        ax0 = fig.add_subplot(211)

        x = np.arange(Yc.shape[1])

        spm1d.plot.plot_mean_sd(Yc, ax=ax0,
                                linecolor='r',
                                facecolor=(1,0.7,0.7),
                                edgecolor='r',
                                label='Control')
        spm1d.plot.plot_mean_sd(Yk, ax=ax0,
                                linecolor='b',
                                facecolor=(0.7,0.7,1),
                                edgecolor='b',
                                label='Kyphotic')
        
        # --- Raw curves ---
        if plotRaw:
            for i in range(Yc.shape[0]):
                ax0.plot(x, Yc[i, :], color='r', alpha=0.25, linewidth=0.8)
            for i in range(Yk.shape[0]):
                ax0.plot(x, Yk[i, :], color='b', alpha=0.25, linewidth=0.8)

        ax0.set_ylabel(ylabel)
        ax0.legend()
        ax0.set_title(
            title + ' (Levels: ' + lvlRange[0] + ' → ' + lvlRange[-1] + ')'
        )

        ax1 = fig.add_subplot(212, sharex=ax0)
        inference.plot(ax=ax1)
        inference.plot_threshold_label(ax=ax1)
        inference.plot_p_values(ax=ax1)

        ax1.set_ylabel("SPM{t}")

        if xMode == "norm":
            nn = 6
            xticks = np.linspace(0, Yc.shape[1] - 1, nn)
            xticklabels = np.linspace(0, 100, nn)
            ax1.set_xticks(xticks)
            ax1.set_xticklabels([f"{x:.0f}" for x in xticklabels])
            ax1.set_xlabel("Measurement domain (%)")

        elif xMode == "levels":
            xticks = np.arange(len(lvlRange))
            ax1.set_xticks(xticks)
            ax1.set_xticklabels(lvlRange)
            ax1.set_xlabel("Spinal position")

        else:
            raise ValueError("xMode must be 'norm' or 'levels'.")

    plt.tight_layout()
    plt.show()

    return inference

def validNodes(Yc, Yk):
    """
    Node mask
    """
    return (
        np.all(np.isfinite(Yc), axis=0) &
        np.all(np.isfinite(Yk), axis=0)
    )

