function writeSubjectData(subject, cfg)
    
    fname = getSubjectDataFilename(subject.name, cfg);
    
    meta = struct();
    meta.created   = datetime('now');
    meta.version   = '1.0';
    
    save(fname, 'subject', 'meta', '-v7.3');
end

