function score = evaluateDiscMesh(compressPer, k, dataStruct)
    % Unpack precomputed data from your workspace
    gridRes = dataStruct.gridRes;
    xxSup = dataStruct.xxSup; yySup = dataStruct.yySup; zzSup = dataStruct.zzSup;
    xxInf = dataStruct.xxInf; yyInf = dataStruct.yyInf; zzInf = dataStruct.zzInf;
    x2DSup_b = dataStruct.x2DSup_b; y2DSup_b = dataStruct.y2DSup_b;
    x2DInf_b = dataStruct.x2DInf_b; y2DInf_b = dataStruct.y2DInf_b;
    
    % Pick a projection plane for parameterization (example: XY)
    [xqSup, yqSup] = meshgrid(linspace(min(xxSup), max(xxSup), gridRes), ...
                               linspace(min(yySup), max(yySup), gridRes));
    [xqInf, yqInf] = meshgrid(linspace(min(xxInf), max(xxInf), gridRes), ...
                               linspace(min(yyInf), max(yyInf), gridRes));
    
    % setting boundary of inferior + superior regions:
    pgonSup = polyshape(x2DSup_b, y2DSup_b); % x2D_b, y2D_b: polygon vertices
    inPgonSupVec = isinterior(pgonSup, xqSup(:), yqSup(:)); % x, y: query points
    inPgonSupArr = reshape(inPgonSupVec, gridRes, gridRes);
    
    pgonInf = polyshape(x2DInf_b, y2DInf_b); % x2D_b, y2D_b: polygon vertices
    inPgonInfVec = isinterior(pgonInf, xqInf(:), yqInf(:)); % x, y: query points
    inPgonInfArr = reshape(inPgonInfVec, gridRes, gridRes);

    % compressing boundary points:
    % compressPer ~ percentage of mask bonudary compression (ranges from 0-100)
    m = floor(compressPer/100 * gridRes/2); % divide by factor of 2 to account for uniform compression
    se = strel('disk', m); % creating a disk-shaped structuring element of radius m
    inPgonSupArr = imerode(inPgonSupArr, se); % shrinking mask by requiring distance > m
    inPgonInfArr = imerode(inPgonInfArr, se); % shrinking mask by requiring distance > m
    
    % Interpolate Z values from scattered (x,y,z)
    outPgonSupArr = ~inPgonSupArr;
    outPgonInfArr = ~inPgonInfArr;
    zqSup = griddata(xxSup, yySup, zzSup, xqSup, yqSup, 'natural'); 
    zqSup(outPgonSupArr) = NaN;
    zqSup(outPgonInfArr) = NaN;
    
    zqInf = griddata(xxInf, yyInf, zzInf, xqInf, yqInf, 'natural'); 
    zqInf(outPgonInfArr) = NaN;
    zqInf(outPgonSupArr) = NaN;

    % mask of boundary points in original grids:
    validMaskSup = ~isnan(zqSup); % creating a validity mask for superior surface
    validMaskInf = ~isnan(zqInf); % creating a validity mask for inferior surface
    
    % indices of mask of boundary points in original grids:
    BWSup = validMaskSup;
    BSup = bwboundaries(BWSup); % cell array of boundaries
    boundaryRCSup = BSup{1}; % first boundary [row, col] points, ordered
    linIdxSup = sub2ind(size(BWSup), boundaryRCSup(:,1), boundaryRCSup(:,2)); % converting to linear indices
    
    BWInf = validMaskInf;
    BInf = bwboundaries(BWInf); % cell array of boundaries
    boundaryRCInf = BInf{1}; % first boundary [row, col] points, ordered
    linIdxInf = sub2ind(size(BWInf), boundaryRCInf(:,1), boundaryRCInf(:,2)); % converting to linear indices
    
    % determining outer boundary coordinates:
    outerBoundary3DSup = [xqSup(linIdxSup), yqSup(linIdxSup), zqSup(linIdxSup)];
    outerBoundary3DInf = [xqInf(linIdxInf), yqInf(linIdxInf), zqInf(linIdxInf)];
    
    % smoothing boundary curves:
    xqSup(linIdxSup) = outerBoundary3DSup(:,1);
    yqSup(linIdxSup) = outerBoundary3DSup(:,2);
    zqSup(linIdxSup) = outerBoundary3DSup(:,3);
    
    xqInf(linIdxInf) = outerBoundary3DInf(:,1);
    yqInf(linIdxInf) = outerBoundary3DInf(:,2);
    zqInf(linIdxInf) = outerBoundary3DInf(:,3);

    % interpolating between the inferior/superior disc surfaces:
    N = 25; % number of interior surfaces
    
    % intializing total coordinate arrays:
    xxx = zeros((N+2)*gridRes, gridRes); 
    xxx(1:gridRes, 1:gridRes) = xqInf;
    xxx((N+1)*gridRes + 1:(N+2)*gridRes, 1:gridRes) = xqSup;
    
    yyy = zeros((N+2)*gridRes, gridRes);
    yyy(1:gridRes, 1:gridRes) = yqInf;
    yyy((N+1)*gridRes + 1:(N+2)*gridRes, 1:gridRes) = yqSup;
    
    zzz = zeros((N+2)*gridRes, gridRes);
    zzz(1:gridRes, 1:gridRes) = zqInf;
    zzz((N+1)*gridRes + 1:(N+2)*gridRes, 1:gridRes) = zqSup;
    
    % storing interior surfaces:
    for iii = 1:N
        tt = iii / (N+1);
        xxMid = (1 - tt) * xqInf + tt * xqSup;
        xxx(iii*gridRes + 1:(iii+1)*gridRes, 1:gridRes) = xxMid;
    
        yyMid = (1 - tt) * yqInf + tt * yqSup;
        yyy(iii*gridRes + 1:(iii+1)*gridRes, 1:gridRes) = yyMid;
    
        zzMid = (1 - tt) * zqInf + tt * zqSup;
        zzz(iii*gridRes + 1:(iii+1)*gridRes, 1:gridRes) = zzMid;
    end

    % flattening cooridinates into vectors:
    xv = xxx(:);
    yv = yyy(:);
    zv = zzz(:);
    
    % finding the logical locations of NaNs:
    nanLocations = isnan(zv);
    
    % repartitioning coordinate vectors:
    xvv = xv(~nanLocations);
    yvv = yv(~nanLocations);
    zvv = zv(~nanLocations);
    Vvv = [xvv, yvv, zvv];
    
    % k is a tightness parameter (1 = convex hull, smaller <1 = tighter wrap)
    F = boundary(xvv, yvv, zvv, k);  % F = faces, indices into point list

    % check watertightness
    discMesh = surfaceMesh(Vvv, F);
    isWT = isWatertight(discMesh);

    % Score = combination of metrics
    if ~isWT
        score = Inf; % penalize non-watertight meshes
        return
    end

    % Surface area
    surfArea = surfaceArea(F, Vvv);

    % Volume
    vol = meshVolume(F, Vvv);

    % Objective: minimize surface-to-volume ratio
    score = surfArea / vol;
    disp("score: " + string(score) + ", watertightness: " + string(isWT))
end
