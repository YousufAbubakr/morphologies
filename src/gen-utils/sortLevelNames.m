function idx = sortLevelNames(levelNames)
% Robust sorter for vertebra AND disc level names
% Handles: T1, T12, L3, T6-T7, L1-L2, etc.

    n = numel(levelNames);
    order = nan(n,1);

    for i = 1:n
        s = string(levelNames{i});

        % ---- Disc levels (e.g. T6-T7) ----
        if contains(s,"-")
            tok = regexp(s,'([TL])(\d+)-([TL])(\d+)','tokens','once');
            region = tok{1};
            number = str2double(tok{2});   % LOWER vertebra

        % ---- Vertebra levels (e.g. T6) ----
        else
            tok = regexp(s,'([TL])(\d+)','tokens','once');
            region = tok{1};
            number = str2double(tok{2});
        end

        % ---- Region weighting ----
        switch region
            case 'T'
                regionWeight = 1;
            case 'L'
                regionWeight = 2;
            otherwise
                regionWeight = 99;
        end

        order(i) = regionWeight*100 + number;
    end

    [~,idx] = sort(order);
end

