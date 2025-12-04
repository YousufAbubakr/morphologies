function [V_rot,R,origin,B] = alignCloudToCanonical(V, vZ_ref, vY_ref, enforceSigns)
% V       : Nx3 point cloud (rows = points)
% vZ_ref  : 1x3 vector ~ desired Z direction (e.g., SI normal)
% vY_ref  : 1x3 vector ~ desired in-plane direction (e.g., post-axis)
% enforceSigns (optional struct): .x,.y,.z each ±1 to force axis signs
% Returns:
%   V_rot : rotated cloud
%   R     : 3x3 rotation (use V_rot = (V - origin) * R)
%   origin: centroid used
%   B     : columns are unit axes [x y z] in original coords

    if nargin < 4, enforceSigns = struct('x',+1,'y',+1,'z',+1); end

    origin = mean(V,1);
    P = V - origin;

    % --- 1) Z axis from vZ_ref (normalize, set sign) ---
    z = vZ_ref(:);  z = z / norm(z);
    z = enforceSigns.z * z;

    % --- 2) Y axis from vY_ref, projected to plane ⟂ z ---
    y = vY_ref(:);
    y = y - (y.'*z)*z;             % remove z component
    if norm(y) < 1e-9
        % fallback: PCA in the plane if vY_ref is nearly parallel to z
        C = cov(P - (P*z)*z.');    % covariance of in-plane residuals
        [U,S] = eig(C,'vector');
        [~,iMax] = max(S);
        y = U(:,iMax);
        y = y - (y.'*z)*z;
    end
    y = y / norm(y);
    y = enforceSigns.y * y;

    % --- 3) X to complete right-handed frame ---
    x = cross(y,z);  x = x / norm(x);
    x = enforceSigns.x * x;         % flip if you need ML to be +X
    % re-orthogonalize (guards numerical drift)
    y = cross(z,x);  y = y / norm(y);

    % --- 4) Build rotation and apply (row-vector convention) ---
    B = [x y z];           % columns are axes expressed in original coords
    R = B;                 % for row vectors: V_rot = P * R
    V_rot = P * R;
end
