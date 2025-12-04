function isKidney = isKidneyBean(boundaryPoints)
    % Returns whether or not 3D boundary curve represented via boundaryPoints
    % follows a kidney bean shape

    P2D = boundaryPoints(:,1:2);
    x = P2D(:,1);
    y = P2D(:,2);

    % Convex hull
    [k, areaHull] = convhull(x, y);
    
    % Create polyshapes
    polyShapeOriginal = polyshape(x, y);
    polyShapeHull = polyshape(x(k), y(k));
    
    % Find concave regions (hull minus shape)
    concavePoly = subtract(polyShapeHull, polyShapeOriginal);
    
    % Area calculations
    areaOriginal = area(polyShapeOriginal);
    concavityRatio = (areaHull - areaOriginal) / areaHull;
    
    % Count number of concave parts
    concaveRegions = regions(concavePoly);
    numConcaveParts = numel(concaveRegions);

    % Classification rule
    isKidney = numConcaveParts == 1;
end
