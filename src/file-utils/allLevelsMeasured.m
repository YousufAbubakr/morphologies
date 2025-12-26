function tf = allLevelsMeasured(subj, cfg)

    tf = true;
    
    % ---- Vertebrae ----
    if cfg.measurements.makeVertebraSlices
        meas = subj.vertebrae.measurements;
    
        if isempty(meas) || numel(meas) ~= subj.vertebrae.numLevels
            tf = false;
            return
        end
    
        % Checking if the measurements fields inside of 'meas' are either
        % empty of all non-zero:
        for i = 1:numel(meas)
            if ~isfield(meas(i), 'csa') || ...
               ~isfield(meas(i), 'widths') || ...
               (all(meas(i).csa.X == 0) || all(meas(i).csa.Y == 0) || all(meas(i).csa.Z == 0)) || ...
               (all(all(meas(i).widths.X == 0)) || all(all(meas(i).widths.Y == 0)) || all(all(meas(i).widths.Z == 0)))
                tf = false;
                return
            end
        end
    end
    
    % ---- Discs ----
    if cfg.measurements.makeDiscSlices
        meas = subj.discs.measurements;
    
        if isempty(meas) || numel(meas) ~= subj.discs.numLevels
            tf = false;
            return
        end
    
        % Checking if the measurements fields inside of 'meas' are either
        % empty of all non-zero:
        for i = 1:numel(meas)
            if ~isfield(meas(i), 'csa') || ...
               ~isfield(meas(i), 'widths') || ...
               (all(meas(i).csa.X == 0) || all(meas(i).csa.Y == 0) || all(meas(i).csa.Z == 0)) || ...
               (all(all(meas(i).widths.X == 0)) || all(all(meas(i).widths.Y == 0)) || all(all(meas(i).widths.Z == 0)))
                tf = false;
                return
            end
        end
    end
end

