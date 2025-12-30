function [coordsN, profileN] = resampleProfile(coords, profile, N, ignorance)
% Resample 1D height profile to fixed size N
%
% Inputs:
%   coords   - 1D coordinate array (mm)
%   profile  - 1D height values (mm)
%   N        - number of output samples
%
% Outputs:
%   coordsN  - resampled coordinates (1xN)
%   profileN - resampled height profile (1xN)

    coords  = coords(:)';
    profile = profile(:)';

    % ---- Remove NaNs ----
    valid = ~isnan(coords) & ~isnan(profile);
    coords  = coords(valid);
    profile = profile(valid);

    % ---- Minimum points check ----
    if numel(coords) < 4
        coordsN  = nan(1, N);
        profileN = nan(1, N);
        return
    end

    % ---- Select middle (1-'ignorance') ---- entries
    n_total = numel(coords);
    n_keep = round(n_total * (1 - ignorance)); % # of elements to keep

    n_remove_each_side = floor((n_total - n_keep) / 2); % # of elements to remove from each end

    start_index = n_remove_each_side + 1; % starting and ending indices
    end_index = n_total - n_remove_each_side;

    % Select the middle (1 - 'ignorance')% of the arrays:
    coords = coords(start_index:end_index);
    profile = profile(start_index:end_index);

    % ---- Enforce monotonic ordering ----
    [coords, idx] = sort(coords);
    profile       = profile(idx);

    % ---- Target uniform coordinates ----
    coordsN = linspace(min(coords), max(coords), N);

    % ---- Shape-preserving interpolation ----
    profileN = interp1(coords, profile, coordsN, 'pchip');
end

