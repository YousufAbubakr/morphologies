function q = fdrBH(p)
% Benjamini–Hochberg FDR correction

    p = p(:);
    m = numel(p);

    [pSorted, idx] = sort(p);
    qSorted = pSorted .* m ./ (1:m)';
    qSorted = min(1, cummin(flipud(qSorted)));
    qSorted = flipud(qSorted);

    q = zeros(size(p));
    q(idx) = qSorted;
end

