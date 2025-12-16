function plotSubjectVertebrae(subject)
% Plotting all vertebra meshes for a single subject

    figure;
    ax1 = subplot(1,2,1); ax1.SortMethod = 'childorder';
    hold on; axis equal;
    title("Subject " + subject.vertebrae.subjName + ", vertebral bodies", ...
                "Interpreter","none");
    xlabel('X'); ylabel('Y'); zlabel('Z')

    lighting gouraud;
    camlight headlight;
    view(3);

    C = subject.centerline.C;
    T = subject.centerline.T;

    meshes = subject.vertebrae.mesh;
    cmap = lines(numel(meshes));

    for k = 1:numel(meshes)
        TR = meshes(k).TR;

        % -------------------------------------------------
        % Plot vertebral meshes
        % -------------------------------------------------
        trisurf(TR.ConnectivityList, ...
                TR.Points(:,1), ...
                TR.Points(:,2), ...
                TR.Points(:,3), ...
                'FaceColor', cmap(k,:), ...
                'EdgeColor','none', ...
                'FaceAlpha',0.9);

        % -------------------------------------------------
        % Plot centroids
        % -------------------------------------------------  
        c = meshes(k).centroid;
        plot3(c(1), c(2), c(3), 'k.', 'MarkerSize', 15);
        text(c(1), c(2), c(3), meshes(k).levelName, ...
                                'FontSize', 14, ...
                                'FontWeight', 'bold');

        % -------------------------------------------------
        % Evaluate and plot centerline
        % -------------------------------------------------
        tFine = linspace(0,1,200);
        x = ppval(subject.centerline.ppX, tFine);
        y = ppval(subject.centerline.ppY, tFine);
        z = ppval(subject.centerline.ppZ, tFine);

        plot3(x, y, z, 'r-', 'LineWidth',1.5)
    end
    legend({'vertebral bodies','centroids', 'centerline'},'Location','best')

    subplot(1,2,2)
    hold on; axis equal;
    title("Subject " + subject.vertebrae.subjName + ", centerline and tangents", ...
                "Interpreter","none");
    xlabel('X'); ylabel('Y'); zlabel('Z')

    % ----------------------------------------------------------
    % Plot centerline tangents (stored collectively in C and T)
    % ----------------------------------------------------------
    scale = 0.3;
    quiver3( ...
        C(:,1), C(:,2), C(:,3), ...
        T(:,1), T(:,2), T(:,3), ...
        scale,'Color',[0.5 0 0],'LineWidth',2,'MaxHeadSize',0.5);

    for k = 1:numel(meshes)
        % -------------------------------------------------
        % Plot centroids
        % -------------------------------------------------  
        c = meshes(k).centroid;
        plot3(c(1), c(2), c(3), 'k.', 'MarkerSize', 15);
        text(c(1), c(2), c(3), meshes(k).levelName, ...
                                'FontSize', 14, ...
                                'FontWeight', 'bold');

        % -------------------------------------------------
        % Evaluate and plot centerline
        % -------------------------------------------------
        tFine = linspace(0,1,200);
        x = ppval(subject.centerline.ppX, tFine);
        y = ppval(subject.centerline.ppY, tFine);
        z = ppval(subject.centerline.ppZ, tFine);

        plot3(x, y, z, 'r-', 'LineWidth',3)
    end
    view(3);

    legend({'tangents','centroids', 'centerline'},'Location','best')
end

