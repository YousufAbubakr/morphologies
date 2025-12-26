%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grace O'Connell Biomechanics Lab, UC Berkeley Department of Mechanical
% Engineering - Etchverry 2162
%
% File: makeSlicerMeasurements.m
% Author: Yousuf Abubakr
% Project: Morphologies
% Last Updated: 12-25-2025
%
% Description: slicing through the subjects' goemetries through the three
% standard coordinate axes and measuring the associated geometric features
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % clearing command window

warning('off','all') % turning on warnings

% Getting workspace variables at the start of the new script:
varsbefore = who;

%% GEOMETRY SLICING
% Slicing through each subjects' vertebra and disc geometry and appending 
% the associated measurement data to 'subject.{vertebrae,discs}..."

% --- Slicer progress tracking ---
job.total = 0;
if cfg.measurements.makeVertebraSlices
    job.total = job.total + sum(arrayfun(@(s) s.vertebrae.numLevels, subjectData.subject));
end
if cfg.measurements.makeDiscSlices
    job.total = job.total + sum(arrayfun(@(s) s.discs.numLevels, subjectData.subject));
end
job.count = 0;

tic
% Looping through each subject:
for i = 1:subjectData.numSubjects
    subj = subjectData.subject(i);

    % If subject i is already written, then measurements for this subject
    % will be skipped:
    if ~shouldRunMeasurements(subj, cfg)
        continue
    end

    job.subjectIdx  = i;
    job.numSubjects = subjectData.numSubjects;

    % Vertebra slices:
    if cfg.measurements.makeVertebraSlices
        job.levelIdx = 0;
        [subjectData.subject(i).vertebrae.measurements, job] = ...
            sliceGeometrySet(subj.vertebrae.mesh, cfg, ...
            cfg.plot.monitorVertebraSlices, job);
    end

    % Disc slices:
    if cfg.measurements.makeDiscSlices
        job.levelIdx = 0;
        [subjectData.subject(i).discs.measurements, job] = ...
            sliceGeometrySet(subj.discs.mesh, cfg, ...
            cfg.plot.monitorDiscSlices, job);
    end

    % Write to 'data/measurements' directory:
    writeSubjectData(subjectData.subject(i), cfg);
end
fprintf('Slicer measurements done in %.2f seconds (%.2f minutes)!\n', toc, toc/60);

%% MATLAB CLEANUP
% Deleting extraneous subroutine variables:
varsafter = who; % get names of all variables in 'varsbefore' plus variables
varsremove = setdiff(varsafter, varsbefore); % variables  defined in the script
varskeep = {''};
varsremove(ismember(varsremove, varskeep)) = {''};
clear(varsremove{:})

