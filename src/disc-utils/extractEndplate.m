function endplate = extractEndplate(mesh, side, pct)
% extracting the endplate datapoints from the "superior" and "inferior"
% vertebral meshes. 

    Z = mesh.TR.Points(:,3);

    switch side
        case "superior"
            zCut = prctile(Z, 100 - pct);
            idx = Z >= zCut;

        case "inferior"
            zCut = prctile(Z, pct);
            idx = Z <= zCut;

        otherwise
            error("Side must be 'superior' or 'inferior'");
    end

    endplate.Points = mesh.TR.Points(idx,:);
end

