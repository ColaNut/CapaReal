function PntsCrdnt = getCoord( m, n, ell, shiftedCoordinateXYZ, x_max_vertex, y_max_vertex, z_max_vertex )

PntsCrdnt = zeros(1, 1, 3);
    if (m > x_max_vertex) || (n > y_max_vertex) || (ell > z_max_vertex)
        return;
    else
        PntsCrdnt = shiftedCoordinateXYZ(m, n, ell, :);
    end

end