function tri = preprocessTriangles(V, F)

    tri.v0 = V(F(:,1),:);
    tri.v1 = V(F(:,2),:);
    tri.v2 = V(F(:,3),:);

    tri.e1 = tri.v1 - tri.v0;
    tri.e2 = tri.v2 - tri.v0;

    tri.n  = cross(tri.e1, tri.e2, 2);

    % Bounding boxes (XY only – critical!)
    tri.xmin = min([tri.v0(:,1), tri.v1(:,1), tri.v2(:,1)], [], 2);
    tri.xmax = max([tri.v0(:,1), tri.v1(:,1), tri.v2(:,1)], [], 2);
    tri.ymin = min([tri.v0(:,2), tri.v1(:,2), tri.v2(:,2)], [], 2);
    tri.ymax = max([tri.v0(:,2), tri.v1(:,2), tri.v2(:,2)], [], 2);
end

