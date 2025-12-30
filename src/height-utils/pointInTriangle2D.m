function inside = pointInTriangle2D(x, y, a, b, c)

    v0 = c(1:2) - a(1:2);
    v1 = b(1:2) - a(1:2);
    v2 = [x y] - a(1:2);

    dot00 = dot(v0,v0);
    dot01 = dot(v0,v1);
    dot02 = dot(v0,v2);
    dot11 = dot(v1,v1);
    dot12 = dot(v1,v2);

    invDen = 1 / (dot00*dot11 - dot01*dot01);
    u = (dot11*dot02 - dot01*dot12) * invDen;
    v = (dot00*dot12 - dot01*dot02) * invDen;

    inside = (u >= 0) && (v >= 0) && (u + v <= 1);
end

