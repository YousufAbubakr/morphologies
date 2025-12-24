function slice = sliceGeometry(axis, geometry, plane)
% geometry : triangulation or surface mesh
% plane    : triangulated slicing plane (patch/triangulation)

    % Initialize output
    slice.curves3D = {};
    slice.poly     = polyshape();
    slice.overlap  = false;
    slice.area     = 0;

    % --- Surface intersection ---
    try
        [~, intSurf] = SurfaceIntersection(geometry, plane);
    catch
        return
    end

    if isempty(intSurf) || ~isfield(intSurf,'edges') || isempty(intSurf.edges)
        return
    end

    V = intSurf.vertices;
    E = intSurf.edges;

    % --- Build boundary ---
    loops = extractOrderedLoops(V, E);
    nLoops = numel(loops);

    polys = polyshape.empty;

    % --- Loop over connected components ---
    for k = 1:nLoops

        % --- Order loop in 3D ---
        Pord = V(loops{k},:);
        slice.curves3D{end+1} = Pord;
        if size(slice.curves3D{end},1) > 2
            slice.curves3D{end}(end+1,:) = slice.curves3D{end}(1,:); % closing 3D curve
        end

        % --- Project to 2D plane ---
        switch lower(axis)
            case 'x'  % YZ plane (x = const)
                X2 = Pord(:,[2 3]);
            case 'y'  % XZ plane (y = const)
                X2 = Pord(:,[1 3]);
            case 'z'  % XY plane (z = const)
                X2 = Pord(:,[1 2]);
            otherwise
                error("Axis must be 'x', 'y', or 'z'");
        end

        % --- Make planar polygon ---
        newPolys = polyshape(X2(:,1), X2(:,2), 'Simplify', true);

        % Addes new polyshape as long as it doesn't overlap with any
        % preceding polyshapes in 'polys':
        if isempty(polys)
            polys = [newPolys, polys];
        else
            for j = 1:length(polys)
                polysJ = polys(j); % jth polyshape in 'polys'
                if overlaps(newPolys, polysJ)
                    polysJ = subtract(polysJ, newPolys);
                    polys(j) = polysJ;

                    slice.overlap = [slice.overlap, true];
                else
                    polys = [newPolys, polys];

                    slice.overlap = [slice.overlap, false];
                end
            end
        end
    end

    % --- Outputs ---
    slice.poly = polys;
    slice.area = sum(area(polys));
end

