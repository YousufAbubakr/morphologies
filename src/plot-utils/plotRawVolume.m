function plotRawVolume(T, varargin)
% Plots raw volume measurements across spinal levels.
% One line per subject, colored by group.
%
% INPUT
% -----
% T : table returned by buildMeasurementTables() for volumes
%
% OPTIONAL NAME-VALUE PAIRS
% -------------------------
% 'Structure' : 'vertebra' | 'disc' | 'all' (default)
% 'PlotType'  : 'line' (default) | 'scatter'
% 'Alpha'     : transparency (default)
%
% Control subjects  -> red
% Kyphotic subjects -> blue
%
% EXAMPLE
% -------
% plotRawVolume(Tvolume,'Structure','vertebra')
% plotRawVolume(Tvolume,'Structure','disc','PlotType','scatter')

    % -----------------------------
    % Parse inputs
    % -----------------------------
    p = inputParser;
    addRequired(p,'T',@(x)istable(x));

    addParameter(p,'Structure','all',@(x)ischar(x)||isstring(x));
    addParameter(p,'PlotType','line',@(x)ischar(x)||isstring(x));
    addParameter(p,'Alpha',0.3,@(x)isnumeric(x)&&isscalar(x));

    parse(p,T,varargin{:});
    opt = p.Results;

    % ----------------------------------
    % Filter by structure
    % ----------------------------------
    if opt.Structure ~= "all"
        T = T(T.Structure == opt.Structure,:);
    end
    
    % Remove unused categories
    T.LevelName = removecats(T.LevelName);
    
    % ----------------------------------
    % Build structure-specific x-axis
    % ----------------------------------
    levelCats = categories(T.LevelName);
    ord = sortLevelNames(levelCats);
    
    T.LevelName = categorical( ...
        T.LevelName, ...
        levelCats(ord), ...
        'Ordinal', true);

    % -----------------------------
    % Color convention
    % -----------------------------
    col.control  = [0.85 0.1 0.1];
    col.kyphotic = [0.1 0.3 0.8];

    % -----------------------------
    % Figure setup
    % -----------------------------
    figure('Color','w','Name','Raw Volume');

    title(sprintf('Raw Volume | Structure: %s | Plot: %s', ...
        opt.Structure, opt.PlotType), ...
        'FontWeight','bold');

    hold on;

    % Dummy legend handles
    hControl  = plot(nan,nan,'Color',col.control,'LineWidth',1.5);
    hKyphotic = plot(nan,nan,'Color',col.kyphotic,'LineWidth',1.5);

    % -----------------------------
    % Group by subject
    % -----------------------------
    [G, ~] = findgroups(T.SubjectID);

    for k = 1:max(G)

        idx = (G == k);
        Tk = T(idx,:);

        if Tk.isKyphotic(1)
            color = col.kyphotic;
        else
            color = col.control;
        end

        x = double(Tk.LevelName);   % ordinal
        y = Tk.Volume;

        switch lower(opt.PlotType)
            case 'line'
                plot(x, y, ...
                    'Color',[color opt.Alpha], ...
                    'LineWidth',0.8);

            case 'scatter'
                scatter(x, y, 18, color, ...
                    'filled', ...
                    'MarkerFaceAlpha',opt.Alpha);
        end
    end

    % -----------------------------
    % Axes & labels
    % -----------------------------
    set(gca,'XTick',1:numel(categories(T.LevelName)), ...
            'XTickLabel',categories(T.LevelName));

    xlabel('Spinal level');
    ylabel('Volume (mm^3)');

    legend([hControl hKyphotic], ...
        {'Control','Kyphotic'}, ...
        'Location','best');

    box on;
    grid off;
end

