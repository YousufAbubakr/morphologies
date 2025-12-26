function tf = allLevelsMeasured(subj, cfg)

    tf = true;

    % Measurement frequencies:
    numSlices = cfg.measurements.numSlices;
    
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
               ~isfield(meas(i), 'slice') || ...
               (all(meas(i).csa.X == 0) || all(meas(i).csa.Y == 0) || all(meas(i).csa.Z == 0)) || ...
               (all(all(meas(i).widths.X == 0)) || all(all(meas(i).widths.Y == 0)) || all(all(meas(i).widths.Z == 0))) || ...
               (all(meas(i).slice.X == 0) || all(meas(i).slice.Y == 0) || all(meas(i).slice.Z == 0))
                tf = false;
                return
            end
        end

        % Checking that the config settings are the same as the measurement 
        % settings (width measurements have twice the number of elements 
        % because there are two width measurements):
        for i = 1:numel(meas)
            if (numel(meas(i).csa.X) ~= numSlices || numel(meas(i).csa.Y) ~= numSlices || numel(meas(i).csa.Z) ~= numSlices) || ...
               (numel(meas(i).widths.X) ~= numSlices*2 || numel(meas(i).widths.Y) ~= numSlices*2 || numel(meas(i).widths.Z) ~= numSlices*2) || ...
               (numel(meas(i).slice.X) ~= numSlices || numel(meas(i).slice.Y) ~= numSlices || numel(meas(i).slice.Z) ~= numSlices)
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
               ~isfield(meas(i), 'slice') || ...
               (all(meas(i).csa.X == 0) || all(meas(i).csa.Y == 0) || all(meas(i).csa.Z == 0)) || ...
               (all(all(meas(i).widths.X == 0)) || all(all(meas(i).widths.Y == 0)) || all(all(meas(i).widths.Z == 0))) || ...
               (all(meas(i).slice.X == 0) || all(meas(i).slice.Y == 0) || all(meas(i).slice.Z == 0))
                tf = false;
                return
            end
        end

        % Checking that the config settings are the same as the measurement 
        % settings (width measurements have twice the number of elements 
        % because there are two width measurements):
        for i = 1:numel(meas)
            if (numel(meas(i).csa.X) ~= numSlices || numel(meas(i).csa.Y) ~= numSlices || numel(meas(i).csa.Z) ~= numSlices) || ...
               (numel(meas(i).widths.X) ~= numSlices*2 || numel(meas(i).widths.Y) ~= numSlices*2 || numel(meas(i).widths.Z) ~= numSlices*2) || ...
               (numel(meas(i).slice.X) ~= numSlices || numel(meas(i).slice.Y) ~= numSlices || numel(meas(i).slice.Z) ~= numSlices)
                tf = false;
                return
            end
        end
    end
end

