function meshes = refineSpineAxes(meshes)

    N = numel(meshes);
    C = vertcat(meshes.centroid);

    T = zeros(N,3);

    for i = 2:N-1
        T(i,:) = C(i+1,:) - C(i-1,:);
    end

    T(1,:)   = C(2,:)   - C(1,:);
    T(end,:) = C(end,:) - C(end-1,:);

    T = T ./ vecnorm(T,2,2);

    % Aligning to global z-axis:
    z = [0 0 1];
    for i = 1:N
        if dot(T(i,:), z) < 0
            T(i,:) = -T(i,:);
        end
        meshes(i).frame.SI = T(i,:);
    end
end

