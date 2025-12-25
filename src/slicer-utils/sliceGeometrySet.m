function measurements = sliceGeometrySet(meshArray, cfg, monitorFlag, jobInfo)
% meshArray : subj.vertebrae.mesh OR subj.discs.mesh

    numLevels = numel(meshArray);
    ignorance = cfg.measurements.slicerIgnorance;
    
    % Preallocate output
    measurements = repmat(struct( ...
        'csa', struct('X',[],'Y',[],'Z',[]), ...
        'widths', struct('X',[],'Y',[],'Z',[])), numLevels, 1);
    
    for lvl = 1:numLevels
        jobInfo.count = jobInfo.count + 1;
        measurements(lvl) = sliceOneGeometry( ...
            meshArray(lvl), cfg, ignorance, monitorFlag, jobInfo);
    end

    clc; % clearing command window after geometry set slicing is done
end

