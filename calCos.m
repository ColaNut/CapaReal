function [ cosWeight ] = calCos( v )
    cosWeight = zeros(1, 3);
    ux = [1; 0; 0];
    uy = [0; 1; 0];
    uz = [0; 0; 1];
    cosWeight(1) = dot(v, ux) / norm(v);
    cosWeight(2) = dot(v, uy) / norm(v);
    cosWeight(3) = dot(v, uz) / norm(v);
end