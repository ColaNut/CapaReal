function PntsCrdnt = getCoord( m_v, n_v, ell_v, Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex )

PntsCrdnt = zeros(1, 1, 3);
    if (m_v > x_max_vertex) || (n_v > y_max_vertex) || (ell_v > z_max_vertex) || m_v < 1 || n_v < 1 || ell_v < 1
        return;
    else
        PntsCrdnt = Vertex_Crdnt(m_v, n_v, ell_v, :);
    end

end