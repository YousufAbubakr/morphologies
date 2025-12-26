%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% File: summarizeData.m
% Author: Yousuf Abubakr
% Project: Morphologies
% Last Updated: 12-26-2025
%
% Description: transporting subject data from 'data/measurements' files,
% summarizing it all into easy-to-use data structures, and visualizing the
% summarized raw data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Getting workspace variables at the start of the new script:
varsbefore = who;

%% MEASUREMENT TABLE
% Constructs measurement table 'T' based on the subject data in the 
% 'data/measurements' repository

% Includes both vertebral & disc data:
T = buildMeasurementTable(cfg);

%% RAW VISUALIZATION
% Visualizing the raw data; accounting for each experiemental group, {X,Y,Z}
% direction, and measurement types {csa, widths, etc}

% Displaying raw vertebral body measurements, using the following settings:
%       Structure: vertebra
%       Grouping : kyphotic (blue) VS control (red)
%       PlotType : line
plotRawMeasurement(T,'CSA','Structure','vertebra','Group','separate')
plotRawMeasurement(T,'Width1','Structure','vertebra','Group','separate')
plotRawMeasurement(T,'Width2','Structure','vertebra','Group','separate')

% Displaying raw discal body measurements, using the following settings:
%       Structure: disc
%       Grouping : kyphotic (blue) VS control (red)
%       PlotType : line
plotRawMeasurement(T,'CSA','Structure','disc','Group','separate')
plotRawMeasurement(T,'Width1','Structure','disc','Group','separate')
plotRawMeasurement(T,'Width2','Structure','disc','Group','separate')

%% MATLAB CLEANUP
% Clearing leftover workspace variables, except measurement table 'T':
clearvars -except T cfg;

