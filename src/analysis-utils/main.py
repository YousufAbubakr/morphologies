#######################################################################################
# Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
# Engineering - Etchverry 2162
#
# File: main.py
# Author: Yousuf Abubakr
# Project: Morphologies
# Last Updated: 1-2-2026
#
# Description: main pipeline for accessing, computing, and visualizing summary 
# statistics across control and kyphotic experimental groups
#
#######################################################################################

# Import statements
import numpy as np

from spmUtils import runSPM1D

## IMPORTING SUMMARY DATA ##
# Loading summary data from MATLAB into Python formatting via 'loadSummaryData.py'
# which outputs the following sets of variables:
#       Yc{struc}{axis}
#       Yk{struc}{axis}
#       X{struc}{axis}, 
#           --> where {struc} = {Vert, Disc} and {axis} = {LAT, AP, Vol, Z} which fully
#                           characterizes the measurement arrays
#           --> for example, YcVertZ = (control, vertebra, CSA, Z-axis)
# Variable can be accessed like so: loadSummaryData.Yc{struc}{axis}

from loadSummaryData import (YcVertAP, YcVertLAT, YcVertVol, YcVertZ, 
                             YkVertAP, YkVertLAT, YkVertVol, YkVertZ)

from loadSummaryData import (YcDiscAP, YcDiscLAT, YcDiscVol, YcDiscZ, 
                             YkDiscAP, YkDiscLAT, YkDiscVol, YkDiscZ)

from loadSummaryData import (lvlRangeVertAP, lvlRangeVertLAT, lvlRangeVertVol, lvlRangeVertZ, 
                             lvlRangeDiscAP, lvlRangeDiscLAT, lvlRangeDiscVol, lvlRangeDiscZ)

## SPM ANALYSIS ##
# Running continuous two-sample t-tests and plotting results

# Vertebra and disc SPM:
runSPM1D(Yc=YcVertAP,Yk=YkVertAP,lvlRange=lvlRangeVertAP,title="Height (AP) - Vertebra",ylabel="inf-sup height [mm]")
runSPM1D(Yc=YcVertLAT,Yk=YkVertLAT,lvlRange=lvlRangeVertLAT,title="Height (LAT) - Vertebra",ylabel="inf-sup height [mm]")
runSPM1D(Yc=YcVertZ,Yk=YkVertZ,lvlRange=lvlRangeVertZ,title="CSA (Z) - Vertebra",ylabel="csa [mm²]")

runSPM1D(Yc=YcDiscAP,Yk=YkDiscAP,lvlRange=lvlRangeDiscAP,title="Height (AP) - Disc",ylabel="inf-sup height [mm]")
runSPM1D(Yc=YcDiscLAT,Yk=YkDiscLAT,lvlRange=lvlRangeDiscLAT,title="Height (LAT) - Disc",ylabel="inf-sup height [mm]")
runSPM1D(Yc=YcDiscZ,Yk=YkDiscZ,lvlRange=lvlRangeDiscZ,title="CSA (Z) - Disc",ylabel="csa [mm³]")

