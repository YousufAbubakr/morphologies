function rows = appendSlices(rows, measurements, levelNames, subjectID, isKyphotic, group, structure)

    axes = {"X","Y","Z"};

    if ~isfield(measurements,'slicer') || isempty(measurements.slicer)
        return;
    end

    for lvl = 1:numel(measurements.slicer)

        levelName = levelNames(lvl);

        for a = 1:numel(axes)
            ax = axes{a};

            slicer = measurements.slicer(lvl);

            if ~isfield(slicer.csa, ax)
                continue
            end

            csaVals   = slicer.csa.(ax)(:);
            widths    = slicer.widths.(ax);
            slicePos  = slicer.slice.(ax)(:);

            Ns = numel(csaVals);

            for s = 1:Ns
                rows(end+1,:) = { ...
                    categorical(subjectID), ...
                    isKyphotic, ...
                    group, ...
                    categorical(structure), ...
                    categorical(levelName), ...
                    categorical(ax), ...
                    s, ...
                    slicePos(s), ...
                    csaVals(s), ...
                    widths(s,1), ...
                    widths(s,2)};
            end
        end
    end
end

