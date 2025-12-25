function measures = sliceOneGeometry(mesh, cfg, ignorance, monitor, jobInfo)

    numSlices = cfg.measurements.numSlices;
    levelName = mesh.levelName;
    
    % Extract aligned geometry
    V = mesh.alignedProperties.Points;
    F = mesh.alignedProperties.Faces;
    
    geom.vertices = V;
    geom.faces    = F;
    
    % Bounding box
    bbox = [min(V,[],1); max(V,[],1)]';
    
    % Slice positions
    sx = linspace(bbox(1,1), bbox(1,2), numSlices);
    sy = linspace(bbox(2,1), bbox(2,2), numSlices);
    sz = linspace(bbox(3,1), bbox(3,2), numSlices);
    
    % Planes (built once)
    [Px, Py, Pz] = makeAllPlanes(sx, sy, sz, bbox);
    
    % Preallocate
    measures.csa.X    = zeros(numSlices,1);
    measures.csa.Y    = zeros(numSlices,1);
    measures.csa.Z    = zeros(numSlices,1);
    measures.widths.X = zeros(numSlices,2);
    measures.widths.Y = zeros(numSlices,2);
    measures.widths.Z = zeros(numSlices,2);
    
    % Slice loop
    for k = 1:numSlices
        frac = k / numSlices;
    
        slices = sliceAllAxes(geom, Px(k), Py(k), Pz(k), frac, ignorance);
    
        measures.csa.X(k)    = slices.X.area;
        measures.csa.Y(k)    = slices.Y.area;
        measures.csa.Z(k)    = slices.Z.area;
    
        measures.widths.X(k,:) = slices.X.widths.w;
        measures.widths.Y(k,:) = slices.Y.widths.w;
        measures.widths.Z(k,:) = slices.Z.widths.w;
    
        sliceProgressUpdate(jobInfo, k, numSlices, levelName);
    
        if monitor
            plotSliceMonitor(mesh, slices, k, cfg, measures, gcf);
        end
    end
end

