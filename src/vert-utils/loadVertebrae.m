%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% File: loadVertebrae.m
% Author: Yousuf Abubakr
% Project: Morphologies
% Last Updated: 12-16-2025
%
% Description: loading and characterizing stl properties from the vertebral
% body mesh geometries 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % clearing command window

% Getting workspace variables at the start of the new script:
varsbefore = who;

%% VERTEBRA STL METADATA PROCESSING
% Loading mesh data into 'subjectData'

n = length(subjectData.subject); % number of subjects

% Looping through each subject's '.vertebrae' field and appending mesh
% metadata:
for i = 1:n

    % Getting ith subject's vertebra collection data:
    v = subjectData.subject(i).vertebrae;
    subjectName = subjectData.subject(i).name;

    % Getting level paths and names of ith subject's vertebrae:
    levelPaths = v.levelPaths;
    levelNames = v.levelNames;

    % Extracting mesh properties of ith subject's vertebrae:
    meshes = loadSTLCollection(levelPaths, levelNames, subjectName);

    % Appending metadata into 'subjectData'
    subjectData.subject(i).vertebrae.mesh = meshes;
end

%% SUBJECT SPINE METADATA PROCESSING
% Loading subjects' centerline data into 'subjectData'

n = length(subjectData.subject); % number of subjects

% Looping through each subject's '.vertebrae.mesh' field and appending
% centerline spline properties:
for i = 1:n
    % Computing a smooth spinal centerline from vertebral centroids:
    subjectData.subject(i).centerline = ...
            computeSpineCenterline(subjectData.subject(i).vertebrae);
end

% Secondary loop to compute centerline tangent properties at each vertebral
% centroid:
for i = 1:n
    % Computing unit tangent at subject i's vertebral centroids:
    subjectData.subject(i) = ...
            computeCenterlineTangents(subjectData.subject(i));
end

%% VISUALIZATION
% Plotting each subjects' vertebral bodies

showSubjectVertebrae = cfg.plot.showSubjectVertebrae; % getting config settings

% Skipping visualization if 'showSubjectVertebrae' = false:
if showSubjectVertebrae
    % Looping through each subject:
    for j = 1:n
        % Plotting all vertebra meshes for a single subject:
        plotSubjectVertebrae(subjectData.subject(j));
    end
end

%% MATLAB CLEANUP
% Deleting extraneous subroutine variables:
varsafter = who; % get names of all variables in 'varsbefore' plus variables
varsremove = setdiff(varsafter, varsbefore); % variables  defined in the script
varskeep = {''};
varsremove(ismember(varsremove, varskeep)) = {''};
clear(varsremove{:})

