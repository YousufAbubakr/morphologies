function validateConfig(cfg)
% Preventing silent errors in the configuration settings

    arguments
        cfg struct
    end

    assert(cfg.disc.endplatePercentile > 0 && cfg.disc.endplatePercentile < 50, ...
        'Endplate percentile must be between 0 and 50.');

    assert(cfg.disc.numLoftSlices >= 5, ...
        'numLoftSlices must be >= 5.');

end

