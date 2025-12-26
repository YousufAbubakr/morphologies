function plotRawMeasurement(T, yvar, varargin)
% Plots raw slice-wise measurements vs slice position, separated by
% anatomical plane (X, Y, Z).
%
% INPUTS
% ------
% T     : table returned by buildMeasurementTable()
% yvar  : string or char, name of scalar measurement column
%         e.g. 'CSA', 'WidthMean'
%
% OPTIONAL NAME-VALUE PAIRS
% -------------------------
% 'Group'      : 'none' (default) | 'kyphotic'
% 'PlotType'   : 'line' (default) | 'scatter'
% 'Structure'  : 'vertebra' | 'disc' | 'all' (default)
% 'Alpha'      : transparency
%
% Control subjects  -> red
% Kyphotic subjects -> blue
%
% EXAMPLE
% -------
% plotRawMeasurement(T,'CSA','Group','kyphotic')
% plotRawMeasurement(T,'Width','PlotType','scatter')

    % -----------------------------
    % Parse inputs
    % -----------------------------
    p = inputParser;
    addRequired(p,'T',@(x)istable(x));
    addRequired(p,'yvar',@(x)ischar(x)||isstring(x));

    addParameter(p,'Group','separate',@(x)ischar(x)||isstring(x));
    addParameter(p,'PlotType','line',@(x)ischar(x)||isstring(x));
    addParameter(p,'Structure','all',@(x)ischar(x)||isstring(x));
    addParameter(p,'Alpha',0.15,@(x)isnumeric(x)&&isscalar(x));

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

    axesList = {'X','Y','Z'};

    % -----------------------------
    % Loop over anatomical planes
    % -----------------------------
    for a = 1:3
        axName = axesList{a};
        subplot(1,3,a); hold on;

        % --- Filter table by plane ---
        T_ax = T(T.Axis == axName,:);
        if isempty(T_ax)
            title(axName + " plane (no data)");
            continue;
        end

        % --- Pick correct slice coordinate ---
        sliceVar = "SlicePos";
        if ~ismember(sliceVar, T_ax.Properties.VariableNames)
            error('Missing column "%s" in table.', sliceVar);
        end

        % --- Legend handles (dummy) ---
        hControl  = plot(nan,nan,'Color',col.control,'LineWidth',1.5);
        hKyphotic = plot(nan,nan,'Color',col.kyphotic,'LineWidth',1.5);

        % --- Grouping ---
        for g = [0 1]  % 0 = control, 1 = kyphotic

            if g == 0
                T_g = T_ax(T_ax.isKyphotic == 0,:);
                color = col.control;
            else
                T_g = T_ax(T_ax.isKyphotic == 1,:);
                color = col.kyphotic;
            end

            if isempty(T_g)
                continue;
            end

            % Group by subject + level
            [G, ~] = findgroups(T_g.SubjectID, T_g.Level);

            for k = 1:max(G)
                idx = (G == k);

                x = T_g.(sliceVar)(idx);
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

        % --- Labels, legend, cosmetics ---
        xlabel(sprintf('%s coordinate', axName));
        ylabel(yvar);

        title(sprintf( ...
            '%s plane | %s | %s', ...
            axName, yvar, opt.Structure));

        legend([hControl hKyphotic], ...
            {'Control','Kyphotic'}, ...
            'Location','best');

        grid off;
        box on;
    end
end

