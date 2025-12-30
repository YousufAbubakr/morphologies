function zHits = intersectRayMesh(rayOrigin, tri)
% Intersect a ray with a triangular surface mesh
%
% Inputs:
%   rayOrigin : [1×3] ray origin
%
% Output:
%   zHits     : vector of Z coordinates where intersections occur

    x = rayOrigin(1);
    y = rayOrigin(2);
    zHits = [];

    % XY bounding box culling
    idx = ...
        x >= tri.xmin & x <= tri.xmax & ...
        y >= tri.ymin & y <= tri.ymax;

    if ~any(idx)
        return
    end

    v0 = tri.v0(idx,:);
    v1 = tri.v1(idx,:);
    v2 = tri.v2(idx,:);
    n  = tri.n(idx,:);

    for k = 1:size(v0,1)

        % --- 2D barycentric test (XY) ---
        if ~pointInTriangle2D(x, y, v0(k,:), v1(k,:), v2(k,:))
            continue
        end

        % --- Plane intersection ---
        % Plane: n·(P - v0) = 0
        % Solve for z
        nz = n(k,3);
        if abs(nz) < 1e-12
            continue
        end

        z = v0(k,3) - ...
            (n(k,1)*(x - v0(k,1)) + n(k,2)*(y - v0(k,2))) / nz;

        zHits(end+1,1) = z;
    end
end

