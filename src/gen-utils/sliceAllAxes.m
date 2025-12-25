function slices = sliceAllAxes(vert, Px, Py, Pz, kr, ignoreBoundaries, ignorance)

    if nargin < 6
        slices.X = sliceGeometry('x', vert, Px, kr);
        slices.Y = sliceGeometry('y', vert, Py, kr);
        slices.Z = sliceGeometry('z', vert, Pz, kr);
    else
        slices.X = sliceGeometry('x', vert, Px, kr, ignoreBoundaries, ignorance);
        slices.Y = sliceGeometry('y', vert, Py, kr, ignoreBoundaries, ignorance);
        slices.Z = sliceGeometry('z', vert, Pz, kr, ignoreBoundaries, ignorance);
    end
end

