function P = removeDuplicatePoints(P, tol)

    if nargin < 2
        tol = 1e-8;
    end

    d = sqrt(sum(diff(P,1,1).^2,2));
    keep = [true; d > tol];
    P = P(keep,:);
end

