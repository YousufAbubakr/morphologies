function V = meshVolume(F, Verts)
    V = 0;
    for i = 1:size(F,1)
        v1 = Verts(F(i,1),:);
        v2 = Verts(F(i,2),:);
        v3 = Verts(F(i,3),:);
        V = V + dot(v1, cross(v2, v3)) / 6;
    end
    V = abs(V);
end
