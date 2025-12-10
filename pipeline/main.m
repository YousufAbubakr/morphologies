%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% File: main.m
% Author: Yousuf Abubakr
% Project: Morphologies
% Last Updated: 12-09-2025
%
% Description: main pipeline for spinal morphology measurement project
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc;

set(0,'DefaultFigureWindowStyle','docked') % docking figures
warning('off','all') % turning off warnings

%% DIRECTORY INFORMATION
% storing names of all necessary directories

projectPath = fileparts(pwd); % morphologies repo path

sourceDir = 'src'; % name of source code directory
sourcePath = fullfile(projectPath, sourceDir); % source code path

%% SUBJECT INFORMATION
% initializing subject data structures, according to the following format
% -->
% 
% subjects is a structure array that stores the necessary data associated
% with each subject, as such:
%       subjects(1). ...
%       subjects(2). ...
%       ...
%       subjects(N). ..., 
% where N refers to the number of subjects and each subject has the 
% following fields and subfields:
%     ┣ subjects(i).name = "..."
%     ┣ subjects(i).isKyphotic = boolean
%     ┣ subjects(i).folderPath = '...'
%     ┣ subjects(i).vertebrae
%               ┣ .vertebrae.levelNames
%               ┣ .vertebrae.levelPaths
%               ┣ .vertebrae.numLevels
%               ┣ .vertebrae.measurements
%                           ┣ .measurements.csas
%                           ┣ .measurements.heights
%                           ┣ .measurements.volumes
%                           ┣ ...
%     ┣ subjects(i).discs
%               ┣ .discs.levelNames
%               ┣ .discs.levelPaths
%               ┣ .discs.numLevels
%               ┣ .discs.measurements
%                       ┣ .measurements.csas
%                       ┣ .measurements.heights
%                       ┣ .measurements.volumes
%                       ┣ ...

% Before intializing the subject data structure, we must manually provide
% some information to get us started. 
% 
% ASSUMPTION: the data is structured such that each subject has a unique 
% 3-digit name and kyphotic state associated with it.
% 
% Therefore, we construct a dictionary of the subjects' names and their 
% associated kypthotic state:
subjectsDictKeys = ["643", "658", "660", "665", "666", "717", "723", ...
                        "735", "743", "764", "765", "766", "778", "779"];
subjectsDictVals = [false, true, true, true, true, false, false, ...
                        false, false, false, true, true, false, false];
subjectsDict = containers.Map(subjectsDictKeys, subjectsDictVals);
