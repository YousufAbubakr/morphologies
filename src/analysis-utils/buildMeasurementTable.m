function T = buildMeasurementTable(cfg)

    measureDir = fullfile(cfg.paths.data, 'measurements');
    files   = dir(fullfile(measureDir, '*.mat'));
    
    rows = {};
    
    for f = 1:numel(files)
    
        tmp  = load(fullfile(files(f).folder, files(f).name));
        subj = tmp.subject;
    
        subjectID  = string(subj.name);
        isKyphotic = logical(subj.isKyphotic);
    
        if isKyphotic
            group = categorical("kyphotic");
        else
            group = categorical("control");
        end
    
        % ---- Vertebrae ----
        if isfield(subj, 'vertebrae') && isfield(subj.vertebrae, 'measurements')
            rows = appendStructure(rows, subj.vertebrae.measurements, ...
                subjectID, isKyphotic, group, "vertebra");
        end
    
        % ---- Discs ----
        if isfield(subj, 'discs') && isfield(subj.discs, 'measurements')
            rows = appendStructure(rows, subj.discs.measurements, ...
                subjectID, isKyphotic, group, "disc");
        end
    end
    
    T = cell2table(rows, 'VariableNames', { ...
        'SubjectID','isKyphotic','Group','Structure','Level','Axis','SliceIdx', ...
        'SlicePos','CSA','Width1','Width2'});
end

