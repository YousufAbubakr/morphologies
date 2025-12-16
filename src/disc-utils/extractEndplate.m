function endplate = extractEndplate(mesh, which, pct)
% Extracting the endplate datapoints from the "superior" and "inferior"
% vertebral meshes. 

    V = mesh.TR.Points;
    F = mesh.TR.ConnectivityList;
    c = mesh.centroid(:)';
    n = mesh.frame.SI(:)';   % SI unit vector

    % Project vertices onto SI axis
    s = (V - c) * n(:);

    switch lower(which)
        case 'sup'
            sCut = prctile(s, 100 - pct);
            idx = s >= sCut;
            normal = n;
        case 'inf'
            sCut = prctile(s, pct);
            idx = s <= sCut;
            normal = -n;
        otherwise
            error('which must be "sup" or "inf"');
    end

    % Keep faces whose vertices all lie in the slab
    faceMask = all(idx(F), 2);
    Fsub = F(faceMask, :);

    if isempty(Fsub)
        warning('No faces extracted for %s endplate (%s)', ...
            which, mesh.levelName);
    end

    % Reindex vertices
    oldToNew = zeros(size(V,1), 1);
    oldToNew(idx) = 1:nnz(idx);

    Vsub = V(idx, :);
    Fsub = oldToNew(Fsub);

    TR = triangulation(Fsub, Vsub);

    % Creating 'endplate' object:
    endplate.TR        = TR;
    endplate.centroid  = mean(Vsub,1);
    endplate.normal    = normal;
    endplate.pct       = pct;
    endplate.nVertices = size(Vsub,1);
    endplate.nFaces    = size(Fsub,1);
end

