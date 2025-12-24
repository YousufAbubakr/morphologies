function fig = plotSliceMonitor(object, slices, k, cfg, measurements, fig)
% Visualizing slicing properties of 'object' which refers to a vertebra or 
% disc '.mesh' field.

    % Getting object properties:
    subjName = object.subjName;
    levelName = object.levelName;
    TR = object.alignedProperties.TR; % getting aligned TR field

    % Getting slices properties:
    sliceX = slices.X; sliceY = slices.Y; sliceZ = slices.Z;
    slicerTitle = "(" + string(k) + "/" + string(cfg.measurements.numSlices) + ")";

    % Getting measurement features:
    csaX = measurements.csa.X; csaY = measurements.csa.Y; csaZ = measurements.csa.Z;

    set(0, 'CurrentFigure', fig); clf;
    sgtitle("Subject " + subjName + " Visualization");

    % -------------------------------------------------
    % Plot object (aligned) mesh in sup-inf plane
    % -------------------------------------------------
    ax1 = subplot(4,9,[1 21]); ax1.SortMethod = 'childorder';
    hold on; view(3);
    title("Sup-inf (Z) slicing dimension for level " + levelName ,"Interpreter","none");
    xlabel('X'); ylabel('Y'); zlabel('Z')

    trisurf(TR,'FaceColor',[0.7 0.7 0.7],'EdgeColor','none','FaceAlpha',0.3);

    % Drawing the intersection line:
    intersectLines = sliceZ.curves3D;
    nLines = numel(intersectLines);
    for p = 1:nLines
        overlap = sliceZ.overlap(p);

        plot3(intersectLines{p}(:,1), ...
                intersectLines{p}(:,2), ...
                intersectLines{p}(:,3));

        F = 1:size(intersectLines{p},1); % one face, using all vertices
        if overlap
            patch('Vertices', intersectLines{p}, ...
              'Faces', F, ...
              'FaceColor', [1 1 1], ...
              'FaceAlpha', 0.4, ...
              'EdgeColor', 'k');
        else
            patch('Vertices', intersectLines{p}, ...
              'Faces', F, ...
              'FaceColor', [0.7 0.7 0.7], ...
              'FaceAlpha', 0.4, ...
              'EdgeColor', 'k');
        end
    end

    lighting gouraud
    camlight headlight
    material dull

    % --- Showing polyshape ---
    subplot(4,9,28);
    hold on; title("2D slice " + slicerTitle);
    
    polyZ = sliceZ.poly;
    plot(polyZ, 'FaceColor',[0.7 0.7 0.7])

    % --- Showing measurements ---
    subplot(4,9,[29 30]);
    hold on; title("Measurements");

    plot(1:k, csaZ(1:k),'-k.','DisplayName','csa')
    xlabel("Slice index");
    legend('Location','southeast');

    % -------------------------------------------------
    % Plot object (aligned) mesh in ant-post plane
    % -------------------------------------------------
    ax1 = subplot(4,9,[4 24]); ax1.SortMethod = 'childorder';
    hold on; view(3);
    title("Ant-post (Y) slicing dimension for level " + levelName ,"Interpreter","none");
    xlabel('X'); ylabel('Y'); zlabel('Z')
    
    trisurf(TR,'FaceColor',[0.7 0.7 0.7],'EdgeColor','none','FaceAlpha',0.3);

    % Drawing the intersection line:
    intersectLines = sliceY.curves3D;
    nLines = numel(intersectLines);
    for p = 1:nLines
        overlap = sliceY.overlap(p);

        plot3(intersectLines{p}(:,1), ...
                intersectLines{p}(:,2), ...
                intersectLines{p}(:,3));

        F = 1:size(intersectLines{p},1); % one face, using all vertices
        if overlap
            patch('Vertices', intersectLines{p}, ...
              'Faces', F, ...
              'FaceColor', [1 1 1], ...
              'FaceAlpha', 0.4, ...
              'EdgeColor', 'k');
        else
            patch('Vertices', intersectLines{p}, ...
              'Faces', F, ...
              'FaceColor', [0.7 0.7 0.7], ...
              'FaceAlpha', 0.4, ...
              'EdgeColor', 'k');
        end
    end

    lighting gouraud
    camlight headlight
    material dull

    % --- Showing polyshape ---
    subplot(4,9,31);
    hold on; title("2D slice " + slicerTitle);
    
    polyY = sliceY.poly;
    plot(polyY, 'FaceColor',[0.7 0.7 0.7])

    % --- Showing measurements ---
    subplot(4,9,[32 33]);
    hold on; title("Measurements");

    plot(1:k, csaY(1:k),'-k.','DisplayName','csa')
    xlabel("Slice index");
    legend('Location','southeast');

    % -------------------------------------------------
    % Plot object (aligned) mesh in left-right plane
    % -------------------------------------------------
    ax1 = subplot(4,9,[7 27]); ax1.SortMethod = 'childorder';
    hold on; view(3);
    title("Left-right (X) slicing dimension for level " + levelName ,"Interpreter","none");
    xlabel('X'); ylabel('Y'); zlabel('Z')
    
    trisurf(TR,'FaceColor',[0.7 0.7 0.7],'EdgeColor','none','FaceAlpha',0.3);

    % Drawing the intersection line:
    intersectLines = sliceX.curves3D;
    nLines = numel(intersectLines);
    for p = 1:nLines
        overlap = sliceX.overlap(p);

        plot3(intersectLines{p}(:,1), ...
                intersectLines{p}(:,2), ...
                intersectLines{p}(:,3));

        F = 1:size(intersectLines{p},1); % one face, using all vertices
        if overlap
            patch('Vertices', intersectLines{p}, ...
              'Faces', F, ...
              'FaceColor', [1 1 1], ...
              'FaceAlpha', 0.4, ...
              'EdgeColor', 'k');
        else
            patch('Vertices', intersectLines{p}, ...
              'Faces', F, ...
              'FaceColor', [0.7 0.7 0.7], ...
              'FaceAlpha', 0.4, ...
              'EdgeColor', 'k');
        end
    end

    lighting gouraud
    camlight headlight
    material dull

    % --- Showing polyshape ---
    subplot(4,9,34);
    hold on; title("2D slice " + slicerTitle);
    
    polyX = sliceX.poly;
    plot(polyX, 'FaceColor',[0.7 0.7 0.7])

    % --- Showing measurements ---
    subplot(4,9,[35 36]);
    hold on; title("Measurements");

    plot(1:k, csaX(1:k),'-k.','DisplayName','csa')
    xlabel("Slice index");
    legend('Location','southeast');

    drawnow;
end

