function slices = sliceAllAxes(vert, Px, Py, Pz, kr, ignoreBoundaries, ignorance)

    if nargin < 5
        slices.X = sliceGeometry('x', vert, Px);
        slices.Y = sliceGeometry('y', vert, Py);
        slices.Z = sliceGeometry('z', vert, Pz);
    else
        slices.X = sliceGeometry('x', vert, Px, kr, ignoreBoundaries, ignorance);
        slices.Y = sliceGeometry('y', vert, Py, kr, ignoreBoundaries, ignorance);
        slices.Z = sliceGeometry('z', vert, Pz, kr, ignoreBoundaries, ignorance);
    end
end

