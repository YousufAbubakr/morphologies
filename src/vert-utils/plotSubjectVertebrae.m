function plotSubjectVertebrae(subject)
% Plotting all vertebra meshes for a single subject

    figure; 
    ax = axes; ax.SortMethod = 'childorder';
    hold on; axis equal;
    title("Subject " + subject.vertebrae.subjName, "Interpreter","none");

    meshes = subject.vertebrae.mesh;
    cmap = lines(numel(meshes));

    for k = 1:numel(meshes)
        TR = meshes(k).TR;
        frame = meshes(k).frame;
        SI = frame.SI;

        trisurf(TR.ConnectivityList, ...
                TR.Points(:,1), ...
                TR.Points(:,2), ...
                TR.Points(:,3), ...
                'FaceColor', cmap(k,:), ...
                'EdgeColor','none', ...
                'FaceAlpha',0.9);

        c = meshes(k).centroid;
        plot3(c(1), c(2), c(3), 'k.', 'MarkerSize', 15);
        text(c(1), c(2), c(3), meshes(k).levelName, ...
                                'FontSize', 14, ...
                                'FontWeight', 'bold');

        h = quiver3(c(1), c(2), c(3), ...
                        SI(1), SI(2), SI(3), ...
                        20, 'r','LineWidth',3);
        h.MaxHeadSize = 2;

        set(h, 'Clipping', 'off');
        set(h, 'PickableParts', 'none');
    end

    lighting gouraud;
    camlight headlight;
    view(3);
end

