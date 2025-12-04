function indices = insideCylinder(pts, cen, rad, h, axis)
    % Finds the points inside the cylinder given by the goemetry parameters
    % (rad, h), centered at [cen], with axis [axis]

    indices = [];
    for i = 1:length(pts)
        point = pts(i, :);
    
        % Calculate distance to cylinder axis (using cross product)
        axisVector = cen - point;
        distanceToAxis = norm(cross(axisVector, axis));
    
        % Check if the point is within the cylinder's radius
        if distanceToAxis <= rad
    
            % Check if the point is within the cylinder's height
            projectedPoint = cen + (dot(axisVector, axis) / norm(axis)^2) * axis;
            zCoord = projectedPoint(3);
    
            if zCoord >= cen(3) - h/2 && zCoord <= cen(3) + h/2
                indices = [indices, i];
            end
        end
    end
end

