%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% File: makeSlicerMeasurements.m
% Author: Yousuf Abubakr
% Project: Morphologies
% Last Updated: 12-24-2025
%
% Description: slicing through the subjects' goemetries through the three
% standard coordinate axes and measuring the associated geometric features
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % clearing command window

warning('off','all') % turning on warnings

% Getting workspace variables at the start of the new script:
varsbefore = who;

%% VERTEBRAE SLICING
% Slicing through each subjects' vertebrae geometry and appending the
% associated measurement data to 'subject.vertebrae..."

n = subjectData.numSubjects; % number of subjects
numSlices = cfg.measurements.numSlices; % slicer frequency

% Looping through each subject:
for i = 1:n

    subj = subjectData.subject(i); % ith subject
    numLevels = subj.vertebrae.numLevels; % # of vertebral levels

    % Preallocate struct array
    measurements = repmat(struct('csa', struct('X',[],'Y',[],'Z',[])), ...
                                numLevels,1);

    % Looping through each vertebra of subject i:
    for v = 1:numLevels

        % Getting vertebra mesh properties:
        vMesh = subj.vertebrae.mesh(v);

        V = vMesh.alignedProperties.Points; % vertebra aligned points
        F = vMesh.alignedProperties.Faces; % faces aligned points
        
        vert.vertices = V;
        vert.faces    = F;

        % Geometric limits:
        bbox = [min(V,[],1); max(V,[],1)]'; % (3x2) bounding box of geometry

        % Slice locations along {x,y,z} axes:
        sx = linspace(bbox(1,1), bbox(1,2), numSlices);
        sy = linspace(bbox(2,1), bbox(2,2), numSlices);
        sz = linspace(bbox(3,1), bbox(3,2), numSlices);

        % Defining sets of three anatomical planes:
        [Px, Py, Pz] = makeAllPlanes(sx, sy, sz, bbox);

        % Initializing slicer measurements along {x,y,z} axes:
        measures.csa.X = zeros(1, numSlices);
        measures.csa.Y = zeros(1, numSlices);
        measures.csa.Z = zeros(1, numSlices);

        % Looping through slices for all three anatomical planes:
        for k = 1:numSlices
            % --- Slice mesh with each plane ---
            slices = sliceAllAxes(vert, Px(k), Py(k), Pz(k));

            % --- Measurement outputs ---
            measures.csa.X(k) = slices.X.area;
            measures.csa.Y(k) = slices.Y.area;
            measures.csa.Z(k) = slices.Z.area;
        
            % --- Live visualization ---
            monitorSlices = cfg.plot.monitorSlices; % getting config settings
            
            % Monitoring disc construction process:
            if monitorSlices
                % reusing figure for slicing process:
                if ~exist('slicesfig','var') || ~ishandle(slicesfig)
                    slicesfig = plotSliceMonitor(vMesh, slices, k, cfg, measures, figure);
                else
                    slicesfig = plotSliceMonitor(vMesh, slices, k, cfg, measures, slicesfig);
                end
            end
        end

        % Appending 'measures' to 'measurements' struct:
        measurements(v) = measures;
    end

    % Appending 'measurements' to 'subjectData' struct:
    subjectData.subject(i).vertebrae.measurements = measurements;
end

%% MATLAB CLEANUP
% Deleting extraneous subroutine variables:
varsafter = who; % get names of all variables in 'varsbefore' plus variables
varsremove = setdiff(varsafter, varsbefore); % variables  defined in the script
varskeep = {''};
varsremove(ismember(varsremove, varskeep)) = {''};
clear(varsremove{:})

