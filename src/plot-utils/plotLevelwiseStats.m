function plotLevelwiseStats(Tstats, structure, varargin)
% Visualize level-wise nonparametric summary statistics
% (median with interquartile range)
%
% Inputs
% ------
% Tstats    : output table from levelwiseNonparametricTests
% structure : 'vertebra' or 'disc'
%
% Optional name-value:
%   'UseAdj' : true (default) → use adjusted p-values
%   'Alpha'  : significance threshold (default 0.05)
%   'Title'  : custom title
%   'YLabel' : y-axis label

    % -------------------------
    % Options
    % -------------------------
    p = inputParser;
    addParameter(p,'UseAdj',true);
    addParameter(p,'Alpha',0.05);
    addParameter(p,'Title','');
    addParameter(p,'YLabel','Measurement');
    parse(p,varargin{:});
    opts = p.Results;

    % -------------------------
    % X-axis
    % -------------------------
    x = 1:height(Tstats);
    levels = Tstats.Level;
    dx = 0;   % horizontal offset

    % -------------------------
    % Significance mask
    % -------------------------
    if opts.UseAdj
        sig = Tstats.Signif_adj;
    else
        sig = Tstats.Signif_p;
    end

    % -------------------------
    % Figure
    % -------------------------
    figure('Color','w','Position',[100 100 1000 450]);
    hold on

    % Colors
    colC = [0.85 0.2 0.2];
    colK = [0.2 0.2 0.85];

    % -------------------------
    % Control IQR band
    % -------------------------
    fill([x-dx fliplr(x-dx)], ...
         [Tstats.Q1C' fliplr(Tstats.Q3C')], ...
         colC, 'FaceAlpha',0.25, 'EdgeColor','none');

    % Control median
    plot(x-dx, Tstats.MedianC, '-o', ...
         'Color',colC, 'MarkerFaceColor',colC, 'LineWidth',3);

    % -------------------------
    % Kyphotic IQR band
    % -------------------------
    fill([x+dx fliplr(x+dx)], ...
         [Tstats.Q1K' fliplr(Tstats.Q3K')], ...
         colK, 'FaceAlpha',0.25, 'EdgeColor','none');

    % Kyphotic median
    plot(x+dx, Tstats.MedianK, '-o', ...
         'Color',colK, 'MarkerFaceColor',colK, 'LineWidth',3);

    % -------------------------
    % Significance markers
    % -------------------------
    yMax = max([Tstats.Q3C Tstats.Q3K],[],2);
    yStar = yMax * 1.06;

    plot(x(sig), yStar(sig), 'k*', 'MarkerSize',12, 'LineWidth',1.5)

    % -------------------------
    % Formatting
    % -------------------------
    set(gca,'XTick',x,'XTickLabel',levels)
    xtickangle(45)

    xlabel('Spinal Level')
    ylabel(opts.YLabel)

    ylim([0 max(yStar)*1.1])
    xlim([min(x)-0.5 max(x)+0.5])

    extraYAxisProps = true;
    if extraYAxisProps
        % Get the current axes handle
        ax = gca;

        % Set the Exponent property to 0 to prevent scientific notation
        ax.YAxis.Exponent = 0;
        
        % Use ytickformat to ensure integer display without decimals
        ytickformat('%.0f');
    end

    if isempty(opts.Title)
        title(sprintf('Level-wise statistics (%s)',structure))
    else
        title(opts.Title)
    end

    box on
    hold off
end

