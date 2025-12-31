function plotRawHeight(T, yvar, varargin)
% Plots raw height measurements vs slice position, separated by
% direction (LAT, AP).
%
% INPUTS
% ------
% T     : table returned by buildMeasurementTable() or height table
% yvar  : string or char, name of height column
%         e.g. 'Height'
%
% OPTIONAL NAME-VALUE PAIRS
% -------------------------
% 'Group'      : 'separate' (default) | 'kyphotic'
% 'PlotType'   : 'line' (default) | 'scatter'
% 'Structure'  : 'vertebra' | 'disc' | 'all' (default)
% 'Alpha'      : transparency (default)
%
% Control subjects  -> red
% Kyphotic subjects -> blue

    % -----------------------------
    % Parse inputs
    % -----------------------------
    p = inputParser;
    addRequired(p,'T',@(x)istable(x));
    addRequired(p,'yvar',@(x)ischar(x)||isstring(x));

    addParameter(p,'Group','separate',@(x)ischar(x)||isstring(x));
    addParameter(p,'PlotType','line',@(x)ischar(x)||isstring(x));
    addParameter(p,'Structure','all',@(x)ischar(x)||isstring(x));
    addParameter(p,'Alpha',0.3,@(x)isnumeric(x)&&isscalar(x));

    parse(p,T,yvar,varargin{:});
    opt = p.Results;
    yvar = string(yvar);

    if ~ismember(yvar, T.Properties.VariableNames)
        error('Column "%s" not found in table.', yvar);
    end

    % -----------------------------
    % Optional structure filtering
    % -----------------------------
    if opt.Structure ~= "all"
        T = T(T.Structure == opt.Structure,:);
    end

    % -----------------------------
    % Color convention
    % -----------------------------
    col.control  = [0.85 0.1 0.1];  % red
    col.kyphotic = [0.1 0.3 0.8];  % blue

    % -----------------------------
    % Figure setup
    % -----------------------------
    figure('Color','w','Name',sprintf('Raw %s',yvar));

    sgtitle(sprintf( ...
        'Raw %s | Structure: %s | Plot: %s', ...
        yvar, opt.Structure, opt.PlotType), ...
        'FontWeight','bold');

    directions = {'LAT','AP'};

    % -----------------------------
    % Loop over directions
    % -----------------------------
    for d = 1:2
        dirName = directions{d};
        subplot(1,2,d); hold on;

        % --- Filter table by direction ---
        T_dir = T(T.Axis == dirName,:);
        if isempty(T_dir)
            title(dirName + " (no data)");
            continue;
        end

        % --- Slice coordinate ---
        coordVar = "Coord";
        if ~ismember(coordVar, T_dir.Properties.VariableNames)
            error('Missing column "%s" in table.', coordVar);
        end

        % --- Legend handles (dummy) ---
        hControl  = plot(nan,nan,'Color',col.control,'LineWidth',1.5);
        hKyphotic = plot(nan,nan,'Color',col.kyphotic,'LineWidth',1.5);

        % --- Grouping ---
        for g = [0 1]  % 0 = control, 1 = kyphotic

            if g == 0
                T_g = T_dir(T_dir.isKyphotic == 0,:);
                color = col.control;
            else
                T_g = T_dir(T_dir.isKyphotic == 1,:);
                color = col.kyphotic;
            end

            if isempty(T_g)
                continue;
            end

            % Group by subject + level
            [G, ~] = findgroups(T_g.SubjectID, T_g.LevelName);

            for k = 1:max(G)
                idx = (G == k);

                x = T_g.(coordVar)(idx);
                y = T_g.(yvar)(idx);

                switch lower(opt.PlotType)
                    case 'line'
                        plot(x, y, ...
                            'Color',[color opt.Alpha], ...
                            'LineWidth',0.5);

                    case 'scatter'
                        scatter(x, y, 8, color, ...
                            'filled', ...
                            'MarkerFaceAlpha',opt.Alpha);
                end
            end
        end

        % --- Labels & cosmetics ---
        xlabel('Axis position');
        ylabel(yvar);

        title(sprintf( ...
            '%s direction | %s | %s', ...
            dirName, yvar, opt.Structure));

        legend([hControl hKyphotic], ...
            {'Control','Kyphotic'}, ...
            'Location','best');

        box on;
    end
end

