%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% File: makeSlicerMeasurements.m
% Author: Yousuf Abubakr
% Project: Morphologies
% Last Updated: 12-23-2025
%
% Description: slicing through the subjects' goemetries through the three
% standard coordinate axes and measuring the associated geometric features
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % clearing command window

% Getting workspace variables at the start of the new script:
varsbefore = who;

%% SLICING



%% MATLAB CLEANUP
% Deleting extraneous subroutine variables:
varsafter = who; % get names of all variables in 'varsbefore' plus variables
varsremove = setdiff(varsafter, varsbefore); % variables  defined in the script
varskeep = {''};
varsremove(ismember(varsremove, varskeep)) = {''};
clear(varsremove{:})

