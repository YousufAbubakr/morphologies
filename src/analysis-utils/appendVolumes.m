function rows = appendVolumes(rows, measurements, levelNames, subjectID, isKyphotic, group, structure)

    if ~isfield(measurements,'vol') || isempty(measurements.vol)
        return
    end

    for lvl = 1:numel(measurements.vol)

        levelName = levelNames(lvl);

        volVal = measurements.vol(lvl);

        rows(end+1,:) = { ...
            categorical(subjectID), ...
            isKyphotic, ...
            group, ...
            categorical(structure), ...
            categorical(levelName), ...
            volVal};
    end
end

