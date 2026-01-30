function [Tout, stats] = levelwiseTests(T, structure, levelRange, yvar, opts)
% Perform level-wise t-tests from a summary table
%
% Inputs
% ------
% T         : table with variables:
%             - Level (string/cellstr)
%             - Group ('control' or 'kyphotic')
%             - (yvar) (numeric)
% structure : 'vertebra' or 'disc'
% opts      : (optional) struct
%             opts.alpha (default = 0.05)
%             opts.multComp (default = 'bonferroni')
%
% Outputs
% -------
% Tout  : table with level-wise statistics
% stats : struct with p, q, and metadata

    % -------------------------
    % Defaults
    % -------------------------
    if nargin < 5
        opts = struct();
    end
    if ~isfield(opts,'alpha')
        opts.alpha = 0.05;
    end

    if ~isfield(opts,'multComp')
        opts.multComp = 'bonferroni';   % 'bonferroni'
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

    medC = nan(nL,1); q1C = nan(nL,1); q3C = nan(nL,1);
    medK = nan(nL,1); q1K = nan(nL,1); q3K = nan(nL,1);
    pVals = nan(nL,1);
    nC = nan(nL,1); nK = nan(nL,1);

    % -------------------------
    % Level-wise tests
    % -------------------------
    for i = 1:nL
        lvl = levels{i};

        Tc = T(T.LevelName == lvl & T.Group == 'control', :);
        Tk = T(T.LevelName == lvl & T.Group == 'kyphotic', :);

        xc = Tc.(yvar);
        xk = Tk.(yvar);

        xc = xc(~isnan(xc));
        xk = xk(~isnan(xk));

        nC(i) = numel(xc);
        nK(i) = numel(xk);

        if nC(i) < 2 || nK(i) < 2
            continue
        end

        % Robust summaries
        medC(i) = median(xc);
        q1C(i)  = prctile(xc,25);
        q3C(i)  = prctile(xc,75);

        medK(i) = median(xk);
        q1K(i)  = prctile(xk,25);
        q3K(i)  = prctile(xk,75);

        % Mann–Whitney U test
        pVals(i) = ranksum(xc, xk);
    end

    % -------------------------
    % Multiple-comparison correction
    % -------------------------
    switch lower(opts.multComp)
    
        case 'bonferroni'
            m = sum(~isnan(pVals));          % number of valid tests
            adjVals = min(pVals * m, 1);     % Bonferroni-adjusted p
            adjLabel = 'pBonf';
    
        otherwise
            error('Unknown multiple-comparison method: %s', opts.multComp);
    end

    Tout = table( ...
        levels(:), ...
        medC, q1C, q3C, ...
        medK, q1K, q3K, ...
        medC - medK, ...
        nC, nK, ...
        pVals, adjVals, ...
        pVals < opts.alpha, ...
        adjVals < opts.alpha, ...
        'VariableNames', { ...
            'Level', ...
            'MedianC','Q1C','Q3C', ...
            'MedianK','Q1K','Q3K', ...
            'MedianDiff', ...
            'numControl','numKyphotic', ...
            'pValue', adjLabel, ...
            'Signif_p','Signif_adj'});

    % -------------------------
    % Stats struct
    % -------------------------
    stats = struct();
    stats.structure = structure;
    stats.levels    = levels;
    stats.alpha     = opts.alpha;
    stats.method    = sprintf( ...
                        'Level-wise Mann–Whitney U tests with %s correction', ...
                        upper(opts.multComp));
    stats.table     = Tout;
end

