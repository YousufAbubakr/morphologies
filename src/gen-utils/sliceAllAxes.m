function slices = sliceAllAxes(vert, Px, Py, Pz)

    slices.X = sliceGeometry('x', vert, Px);
    slices.Y = sliceGeometry('y', vert, Py);
    slices.Z = sliceGeometry('z', vert, Pz);
end

