function [faces_sub, vertices_sub] = subdivideMesh(faces, vertices)
% Subdivide each triangle into 4 smaller triangles by adding midpoints

    edgeMap = containers.Map('KeyType','char','ValueType','int32');
    vertices_sub = vertices;
    faces_sub = [];

    for i = 1:size(faces,1)
        tri = faces(i,:);
        v1 = tri(1); v2 = tri(2); v3 = tri(3);

        % Get or create midpoints for each edge
        m12 = getMidpoint(v1, v2);
        m23 = getMidpoint(v2, v3);
        m31 = getMidpoint(v3, v1);

        % Create 4 new triangles
        faces_sub(end+1,:) = [v1, m12, m31];
        faces_sub(end+1,:) = [v2, m23, m12];
        faces_sub(end+1,:) = [v3, m31, m23];
        faces_sub(end+1,:) = [m12, m23, m31];
    end

    function idx = getMidpoint(i, j)
        key = sprintf('%d_%d', min(i,j), max(i,j));
        if isKey(edgeMap, key)
            idx = edgeMap(key);
        else
            newV = (vertices(i,:) + vertices(j,:)) / 2;
            vertices_sub(end+1,:) = newV;
            idx = size(vertices_sub, 1);
            edgeMap(key) = idx;
        end
    end
end
