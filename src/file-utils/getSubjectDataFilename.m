function fname = getSubjectDataFilename(subjectID, cfg)

    outDir = fullfile(cfg.paths.data, 'measurements');
    
    if ~exist(outDir, 'dir')
        mkdir(outDir)
    end
    
    fname = fullfile(outDir, sprintf('%s.mat', subjectID));
end

