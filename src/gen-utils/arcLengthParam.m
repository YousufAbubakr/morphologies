function s = arcLengthParam(P)
% Returns normalized arc-length parameter s ∈ [0,1)

    d = vecnorm(diff([P; P(1,:)]), 2, 2);
    s = cumsum(d);
    s = [0; s(1:end-1)];
    s = s / s(end);
end

