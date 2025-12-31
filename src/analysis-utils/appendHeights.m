function rows = appendHeights(rows, measurements, levelNames, subjectID, isKyphotic, group, structure)

    axes = {"LAT","AP"};

    if ~isfield(measurements,'height') || isempty(measurements.height)
        return;
    end

    for lvl = 1:numel(measurements.height)

        levelName = levelNames(lvl);

        for a = 1:numel(axes)
            ax = axes{a};

            height = measurements.height(lvl);

            if ~isfield(height, ax)
                continue
            end

            heightVals   = height.(ax).profile(:);
            coordsPos    = height.(ax).coords(:);

            Nh = numel(heightVals);

            for h = 1:Nh
                rows(end+1,:) = { ...
                    categorical(subjectID), ...
                    isKyphotic, ...
                    group, ...
                    categorical(structure), ...
                    categorical(levelName), ...
                    categorical(ax), ...
                    h, ...
                    coordsPos(h), ...
                    heightVals(h)};
            end
        end
    end
end

