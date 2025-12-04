function A = surfaceArea(F, V)
    % F : (#faces x 3) face indices
    % V : (#verts x 3) vertices

    v1 = V(F(:,1),:);
    v2 = V(F(:,2),:);
    v3 = V(F(:,3),:);

    % Cross product gives parallelogram area
    crossProd = cross(v2 - v1, v3 - v1, 2);
    triAreas = 0.5 * sqrt(sum(crossProd.^2, 2));

    A = sum(triAreas);
end
