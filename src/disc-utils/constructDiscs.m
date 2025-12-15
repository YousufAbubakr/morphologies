%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% File: constructDiscs.m
% Author: Yousuf Abubakr
% Project: Morphologies
% Last Updated: 12-14-2025
%
% Description: constructing and exporting disc geometries via an endplate 
% extraction → surface lofting pipeline
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % clearing command window

% Getting workspace variables at the start of the new script:
varsbefore = who;

%% DISC STL METADATA PROCESSING
% Loading mesh data into 'subjectData'

n = length(subjectData.subject); % number of subjects

% Looping through each subject and building disc mesh data:
for i = 1:n

    subjectName = subjectData.subject(i).name; % subject name

    % -----------------------------------------------------------
    % Build vertebra lookup table (one per subject)
    % -----------------------------------------------------------
    vMeshes = subjectData.subject(i).vertebrae.mesh;
    vNames  = [vMeshes.levelName];

    vMap = containers.Map(vNames, 1:numel(vNames));

    % -----------------------------------------------------------
    % Preallocate disc mesh array
    % -----------------------------------------------------------
    D = subjectData.subject(i).discs;
    nDiscs = D.numLevels;

    discMeshes = repmat(struct(), nDiscs, 1);

    % -----------------------------------------------------------
    % Build each disc using stored sup/inf info
    % -----------------------------------------------------------
    for d = 1:nDiscs

        supVertName = D.supVertNames(d);
        infVertName = D.infVertNames(d);
    
        % Safety check
        if ~isKey(vMap, supVertName) || ~isKey(vMap, infVertName)
            warning("Skipping disc %s (missing vertebra mesh).", ...
                    D.levelNames(d));
            continue;
        end
    
        supVertMesh = vMeshes(vMap(supVertName));
        infVertMesh = vMeshes(vMap(infVertName));
    
        discMeshes(d) = buildDiscFromAdjacentVertebrae( ...
            supVertMesh, infVertMesh, cfg);
    end

end

%% VISUALIZATION
% Plotting each subjects' discs

%% EXPORTING
% Plotting each subjects' discs

%% MATLAB CLEANUP
% Deleting extraneous subroutine variables:
varsafter = who; % get names of all variables in 'varsbefore' plus variables
varsremove = setdiff(varsafter, varsbefore); % variables  defined in the script
varskeep = {''};
varsremove(ismember(varsremove, varskeep)) = {''};
clear(varsremove{:})