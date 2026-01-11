function [Tout, stats] = levelwiseTtests(T, structure, levelRange, opts)
% Perform level-wise t-tests from a summary table
%
% Inputs
% ------
% T         : table with variables:
%             - Level (string/cellstr)
%             - Group ('control' or 'kyphotic')
%             - Volume (numeric)
% structure : 'vertebra' or 'disc'
% opts      : (optional) struct
%             opts.alpha (default = 0.05)
%
% Outputs
% -------
% Tout  : table with level-wise statistics
% stats : struct with p, q, and metadata

    % -------------------------
    % Defaults
    % -------------------------
    if nargin < 4
        opts = struct();
    end
    if ~isfield(opts,'alpha')
        opts.alpha = 0.05;
        opts.Vartype = 'unequal';
    end
    
    % -----------------------------
    % Resolve valid levels
    % -----------------------------
    levels = resolveLevels(structure, levelRange);

    % Keep only valid levels for this structure
    isValidLevel = ismember(T.LevelName, levels);
    T = T(isValidLevel,:);

    % Enforce canonical ordering
    [~, idx] = ismember(T.LevelName, levels);
    T.LevelOrder = idx;

    % -------------------------
    % Preallocate
    % -------------------------
    nL = numel(levels);
    meanC = nan(nL,1); stdC = nan(nL,1);
    meanK = nan(nL,1); stdK = nan(nL,1);
    tVals = nan(nL,1); pVals = nan(nL,1);
    nC = nan(nL,1); nK = nan(nL,1);

    % -------------------------
    % Level-wise tests
    % -------------------------
    for i = 1:nL
        lvl = levels{i};

        Tc = T(T.LevelName == lvl & T.Group == 'control', :);
        Tk = T(T.LevelName == lvl & T.Group == 'kyphotic', :);

        if height(Tc) < 2 || height(Tk) < 2
            continue
        end

        meanC(i) = mean(Tc.Volume,'omitnan');
        stdC(i)  = std(Tc.Volume,'omitnan');
        nC(i) = sum(~isnan(Tc.Volume), 1); % control n per level

        meanK(i) = mean(Tk.Volume,'omitnan');
        stdK(i)  = std(Tk.Volume,'omitnan');
        nK(i) = sum(~isnan(Tk.Volume), 1); % kyphotic n per level

        [~, pVals(i), ~, s] = ttest2(Tc.Volume, Tk.Volume, ...
                                        'Vartype', opts.Vartype, ...
                                        'Alpha', opts.alpha);
        tVals(i) = s.tstat;
    end

    % -------------------------
    % FDR correction
    % -------------------------
    qVals = fdrBH(pVals);

    % -------------------------
    % Output table
    % -------------------------
    Tout = table( ...
        levels(:), ...
        meanC, stdC, ...
        meanK, stdK, ...
        meanC - meanK, ...
        nC, nK, ...
        tVals, pVals, qVals, ...
        pVals < opts.alpha, ...
        qVals < opts.alpha, ...
        'VariableNames', { ...
            'Level','MeanC','StdC','MeanK','StdK', ...
            'Diff','numControl','numKyphotic','tValue', ...
            'pValue','qValue','Signif_p','Signif_q'});

    % -------------------------
    % Stats struct
    % -------------------------
    stats = struct();
    stats.structure = structure;
    stats.levels    = levels;
    stats.alpha     = opts.alpha;
    stats.method    = 'Level-wise t-tests with BH-FDR';
    stats.table     = Tout;
end

