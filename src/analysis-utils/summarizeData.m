%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% File: summarizeData.m
% Author: Yousuf Abubakr
% Project: Morphologies
% Last Updated: 12-31-2025
%
% Description: transporting subject data from 'data/measurements' files,
% summarizing it all into easy-to-use data structures, and visualizing the
% summarized raw data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % clearing command window

%% MEASUREMENT TABLE
% Constructs measurement table 'T' based on the subject data in the 
% 'data/measurements' repository

% Command window update:
fprintf('Summarizing measurements ...\n');

% Includes both vertebral & disc data:
[Tslice, Theight, Tvolume] = buildMeasurementTables(cfg);

%% RAW VISUALIZATION
% Visualizing the raw data; accounting for each experiemental group, {X,Y,Z}
% direction, and measurement types {csa, widths, etc}

% Endpoint spinal levels to be visualized ([] = all levels):
levels = ["T14","L3"]; % choosing levels associated with major apex region

% ---- Slicer measurements (using the following settings) ----
%       Structure : vertebra & disc
%       Grouping  : kyphotic (blue) VS control (red)
%       Plot Type : line
%       Axes      : X, Y, and Z (vertebra) and Z (disc)
plotRawSlicer(Tslice,'CSA','Structure','vertebra','Group','separate', 'AxesList', 'XYZ','Levels',levels)
plotRawSlicer(Tslice,'CSA','Structure','disc','Group','separate','AxesList', 'Z','Levels',levels)

% ---- Height measurements (using the following settings) ----
%       Structure : vertebra & disc
%       Grouping  : kyphotic (blue) VS control (red)
%       PlotType  : line
%       Axes      : LAT and AP
plotRawHeight(Theight,'Height','Structure','vertebra','Group','separate','Levels',levels)
plotRawHeight(Theight,'Height','Structure','disc','Group','separate','Levels',levels)

% ---- Volume measurements (using the following settings) ----
%       Structure: vertebra & disc
%       Grouping : kyphotic (blue) VS control (red)
%       PlotType : line
plotRawVolume(Tvolume,'Structure','vertebra','Levels',levels)
plotRawVolume(Tvolume,'Structure','disc','Levels',levels)

%% MATLAB CLEANUP
% Clearing leftover workspace variables, except the measurement tables:
clearvars -except Tslice Theight Tvolume cfg;

clc; % clearing command window

