function doRun = shouldRunMeasurements(subj, cfg)

    fname = getSubjectDataFilename(subj.name, cfg);
    
    if exist(fname, 'file')

        % Load existing subject data
        S = load(fname, 'subject', 'meta');
        savedSubj = S.subject;
    
        % Check completeness
        isComplete = allLevelsMeasured(savedSubj, cfg);

        if cfg.overwrite.measures
            fprintf('Overwriting existing measurements for subject %s!\n', subj.name);
            doRun = true;
        elseif ~isComplete
            fprintf('Resuming incomplete measurements for subject %s!\n', subj.name);
            doRun = true;
        else
            fprintf('Skipping subject %s (measurements already exist)!\n', subj.name);
            doRun = false;
        end
    else
        doRun = true;
    end
end

