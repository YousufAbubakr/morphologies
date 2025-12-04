function [indInf, dummyFigure] = findInferiorSurface(ns, Pt, plane, model, makeplot, showQuivers, dummyFigure)
    % Finds the index of the inferior surface index location, indInf, by 
    % measuring concavity of the 3D surfaces

    % min-max of each axis:
    xl = [min(Pt(:,1)), max(Pt(:,1))];
    yl = [min(Pt(:,2)), max(Pt(:,2))];
    zl = [min(Pt(:,3)), max(Pt(:,3))];
    
    % constructing the slice plane at placeholder z-level:
    [xx, yy] = meshgrid(xl, yl);
    plane.vertices = [xx(:), yy(:), zeros(4,1)];
    plane.faces = [1 3 4; 1 4 2]; % two triangles
    zlevels = (linspace(zl(1), zl(2), ns))';
    
    % initializing polyshape array:
    ps = polyshape();
    ps = repmat(ps, [ns, 1]);
    
    % measurement loop:
    for sl = 1:ns
	    z = zlevels(sl);
	    plane.vertices(:,3) = repmat(z, [4 1]); % update slice plane data
		    
        % updating current polyshape model paramaters:
        currmodel.vertices = model.vertices;
        currmodel.faces = model.faces;
    
	    % find the intersection
	    pgons = {};
	    [~, section] = SurfaceIntersection(currmodel, plane);
        % OUTPUT:
        % * section - a structure with following fields:
        %     section.vertices - N x 3 array of unique points
        %     section.edges    - N x 2 array of edge vertex ID's
        %     section.faces    - N x 3 array of face vertex ID's
	    
        % reorder the edge segments and identify unique polygons:
	    E = unique(section.edges, 'rows'); % only unique edges
	    E = E(diff(E,1,2) ~= 0,:); % get rid of degenerate edges (contain a pair of same vertices)
	    p = 1;
	    while ~isempty(E)
		    pgons{p} = E(1,:); % pick the first edge
		    E = E(2:end,:); % remove it from the pile
		    atend = false; % we're not at the end of this curve
		    v = 1;
		    while ~atend % run until there are no more connecting segments
			    nextv = pgons{p}(end,2); % look at the last vertex on this curve
			    idx = find(E(:,1) == nextv,1,'first'); % try to find an edge that starts at this vertex
			    
			    atend = isempty(idx); % we're at the end if there are no more connecting edges
			    if ~atend
				    v = v+1;
				    pgons{p}(end+1,:) = E(idx,:);
				    E(idx,:) = [];
			    end
		    end
		    p = p+1;
	    end
	    
	    % discard open curves
	    goodpgons = false(numel(pgons),1);
	    for p = 1:numel(pgons)
		    goodpgons(p) = pgons{p}(1,1) == pgons{p}(end,2);
	    end
	    pgons = pgons(goodpgons);
	    
	    % construct ordered vertex lists from ordered edge lists
	    for p = 1:numel(pgons)
		    thisE = pgons{p};
		    thisE = [thisE(:,1); thisE(end,2)];
		    pgons{p} = section.vertices(thisE,:);
	    end
	    ipgons = pgons.';
		    
	    % throw all the polygons into one polyshape() 
	    if isempty(ipgons)
		    iPS = polyshape();
        else
            for p = 1:numel(ipgons)
                thisP = ipgons{p};
                if p == 1
                    iPS = polyshape(thisP(:,1), thisP(:,2));
                else
                    iPS = addboundary(iPS, thisP(:,1), thisP(:,2));
                end
            end
	    end
	    
        ps(sl) = iPS;
        
        % Determining surface points of pv:
        pv = plane.vertices; % vertices that describe surface boundary plane
    
        % choosing three vertices and calculate two vectors, for each plane:
        v1 = pv(2,:) - pv(1,:);
        v2 = pv(3,:) - pv(1,:);
        
        % calculating normal vector, for each plane:
        n = cross(v1, v2);
        
        % choosing vertex and finding equation, for each plane:
        D = -n * pv(1,:)';
        p = [n, D]';
        
        % calculating z-coordinates on inferior/superior planes:
        zPlane = (-p(1)*Pt(:,1) - p(2)*Pt(:,2) - p(4)) ./ p(3);
        
        % comparing z-coordinates to boundary planes:
        belowPlane = Pt(:,3) <= zPlane;
        
        % partitioning surface:
        points = Pt(belowPlane,:);
        numPoints = size(points, 1);
        
        % contructing point clouds if there are enough points:
        if numPoints > 1
            plotPoint = mean(points, 1);
            plotPoint(:,3) = min(points(:,3));
            zNorm = [0, 0, -1];

            % intializing point cloud:
            ptCloud = pointCloud(points);
            
            % reconstructing the surface mesh:
            [mesh, ~] = pc2surfacemesh(ptCloud, "ball-pivot");
            
            % computing normals of the surface meshes (creates VertexNormals + FaceNormals feature inside each mesh):
            computeNormals(mesh);
            
            % flipping vertex normals of mesh if most of the normals are facing
            % inwards:
            if mean(mesh.VertexNormals(:,3)) > 0
                mesh.VertexNormals = -mesh.VertexNormals;
            end
    
            % obtaining averaged normal vector for each surface mesh (using the
            % vertices as a reference):
            vertexNormals = mesh.VertexNormals;
            vertices = mesh.Vertices;
            dotProduct = sum(mesh.VertexNormals .* zNorm, 2);
        end
    
        if makeplot
            set(0, 'CurrentFigure', dummyFigure)
            sgtitle('Indentifying Inferior & Superior Surfaces')

            updatetime = 0.5;
            if sl == 1
		        ec = 'k';
                % display the object and slice plane
                title("(Inferior surface search) 3D Polyshape for layer: " + sl)
		        hp{1} = patch(model,'facecolor','w','edgecolor',ec);
		        hp{2} = patch(plane,'facecolor','m','edgecolor',ec,'facealpha',0.5);
                xlabel('X'); ylabel('Y'); zlabel('Z');
		        view([0 1 0]);
		        followerlight(hp{1});
		        axis equal
		        grid on
                hold on
		        
		        % draw the intersection line
		        npgons = numel(ipgons);
		        hp{3} = gobjects(npgons,1);
                for p = 1:npgons
			        hp{3}(p) = plot3(ipgons{p}(:,1),ipgons{p}(:,2),ipgons{p}(:,3),'y','linewidth',2);
                end
		        drawnow
    
                pause(updatetime)
	        else
		        % update the slice plane
                title("(Inferior surface search) 3D polyshape for layer: " + sl)
                xlabel('X'); ylabel('Y'); zlabel('Z');
		        hp{2}.Vertices = plane.vertices;
		        
		        % update the intersection line
		        delete(hp{3}); % the array won't be the same size, so just nuke everything
		        npgons = numel(ipgons);
		        hp{3} = gobjects(npgons,1);
                for p = 1:npgons
			        hp{3}(p) = plot3(ipgons{p}(:,1),ipgons{p}(:,2),ipgons{p}(:,3),'y','linewidth',2);
                end
                if exist('hscatter', 'var')
                    delete(hscatter);
                end
                if exist('qNorm', 'var')
                    delete(qNorm);
                end
                if exist('qMesh', 'var')
                    delete(qMesh);
                end
                qNorm = quiver3(plotPoint(:,1), plotPoint(:,2), plotPoint(:,3), ...
                            zNorm(:,1), zNorm(:,2), zNorm(:,3), 3, 'k', 'LineWidth', 3);
                if showQuivers
                    qMesh = quiver3(vertices(:,1), vertices(:,2), vertices(:,3), ...
                                    vertexNormals(:,1), vertexNormals(:,2), vertexNormals(:,3), ...
                                    3, 'r', 'LineWidth', 3);
                end
                hscatter = scatter3(points(:,1), points(:,2), points(:,3));
		        drawnow
        		        
                pause(updatetime)
            end 

            % checking to see if any dot products between the vertex
            % normals and the z-normal, [0, 0, -1], are less than 0:
            if exist('dotProduct', 'var') && any(dotProduct <= 0)
                break;
            end
        end
    end
    hold off

    indInf = sl;
end
