function writeSubjectData(subject, cfg)
    
    fname = getSubjectDataFilename(subject.name, cfg);
    
    meta           = struct();
    meta.created   = datetime('now');
    meta.cfg       = cfg;
    
    save(fname, 'subject', 'meta', '-v7.3');
end

