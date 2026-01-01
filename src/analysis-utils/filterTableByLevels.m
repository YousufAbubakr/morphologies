function T = filterTableByLevels(T, levelRange)
% Filters table T by a level range [startLevel, endLevel]
%
% levelRange : string array like ["T12","L3"]

    if isempty(levelRange)
        return
    end

    startLvl = string(levelRange(1));
    endLvl   = string(levelRange(2));

    % --- Extract all unique vertebra levels in table ---
    allLevels = categories(categorical(T.LevelName));

    % --- Separate vertebra & disc labels ---
    isDisc = contains(allLevels,'-');
    vertLevels = allLevels(~isDisc);

    % --- Sort anatomically ---
    ord = sortLevelNames(vertLevels);
    vertLevels = vertLevels(ord);

    % --- Find range indices ---
    iStart = find(vertLevels == startLvl,1);
    iEnd   = find(vertLevels == endLvl,1);

    if isempty(iStart) || isempty(iEnd)
        error('Requested level range not found in table.');
    end

    if iStart > iEnd
        tmp = iStart; iStart = iEnd; iEnd = tmp;
    end

    % --- Vertebra levels to keep ---
    keepVerts = vertLevels(iStart:iEnd);

    % --- Disc levels to keep (adjacent pairs) ---
    keepDiscs = strings(0);
    for i = 1:numel(keepVerts)-1
        keepDiscs(end+1) = keepVerts(i) + "-" + keepVerts(i+1);
    end

    % --- Apply filtering ---
    if ismember("Structure", T.Properties.VariableNames)
        isVert = T.Structure == "vertebra";
        isDisc = T.Structure == "disc";

        keep = false(height(T),1);

        keep(isVert) = ismember(T.LevelName(isVert), keepVerts);
        keep(isDisc) = ismember(T.LevelName(isDisc), keepDiscs);

        T = T(keep,:);
    else
        % Fallback (shouldn't happen)
        T = T(ismember(T.LevelName,[keepVerts; keepDiscs]),:);
    end

    % --- Drop unused categories ---
    T.LevelName = removecats(T.LevelName);
end

