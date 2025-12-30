function doRun = shouldRunMeasurements(subj, cfg)

    fname = getSubjectDataFilename(subj.name, cfg);
    
    if exist(fname, 'file')

        % Load existing subject data
        S = load(fname, 'subject', 'meta');
        savedSubj = S.subject;
        savedConfig = S.meta.cfg;
    
        % Check completeness
        isComplete = allLevelsMeasured(savedSubj, savedConfig, cfg);

        if ~isComplete
            fprintf("Incomplete measurements, all existing measurements will be rewritten!\n");
            doRun = true;
        else
            fprintf("Subject %s's measurements already exist!\n", subj.name);
            doRun = false;
        end
    else
        doRun = true;
    end
end

