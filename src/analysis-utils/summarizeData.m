%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% File: summarizeData.m
% Author: Yousuf Abubakr
% Project: Morphologies
% Last Updated: 12-25-2025
%
% Description: transporting subject data from 'data/measurements' files,
% summarizing it all into easy-to-use data structures, and visualizing the
% summarized raw data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % clearing command window

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

%% MATLAB CLEANUP
% Deleting extraneous subroutine variables:
varsafter = who; % get names of all variables in 'varsbefore' plus variables
varsremove = setdiff(varsafter, varsbefore); % variables  defined in the script
varskeep = {'T'};
varsremove(ismember(varsremove, varskeep)) = {''};
clear(varsremove{:})

