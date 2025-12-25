function slices = sliceAllAxes(geometry, Px, Py, Pz, frac, ignorance)

    slices.X = sliceGeometry('x', geometry, Px, frac, ignorance);
    slices.Y = sliceGeometry('y', geometry, Py, frac, ignorance);
    slices.Z = sliceGeometry('z', geometry, Pz, frac, ignorance);
end

