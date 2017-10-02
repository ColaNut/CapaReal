function [ sparseS_1, B_phi ] = PutOnDwnElctrd_Esophagus_Fine( sparseS_1, B_phi, N_v, V_0, x_max_vertex_B, y_max_vertex_B, w_x_B, w_y_B, w_z_B, dx_B, dy_B, dz_B )

loadParas;
loadParas_Eso0924;

y_idx_far  = (endo_y - 0 + tumor_hy_es / 2) / dy_B + ( w_y_B + dy ) / (2 * dy_B) + 1;
y_idx_near = (endo_y - 0 - tumor_hy_es / 2) / dy_B + ( w_y_B + dy ) / (2 * dy_B) + 1;

y_vIdx_far = 2 * y_idx_far - 1;
y_vIdx_near = 2 * y_idx_near - 1;
m_v = 2 * ( (endo_x - es_x) / dx_B + ( w_x_B + dx ) / (2 * dx_B) + 1 ) - 1;
ell_v = 2 * ( (endo_z - es_z) / dz_B + ( w_z_B + dz ) / (2 * dz_B) + 1 ) - 1;

for n_v = y_vIdx_near: 1: y_vIdx_far
    p0 = N_v + ( ell_v - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v - 1 ) * x_max_vertex_B + m_v;
    p_lft = N_v + ( ell_v - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v - 1 ) * x_max_vertex_B + m_v - 1;
    % p_dwn = ( ell_v - 2 ) * x_max_vertex_B * y_max_vertex_B + ( n_v - 1 ) * x_max_vertex_B + m_v;
    p_rght = N_v + ( ell_v - 1 ) * x_max_vertex_B * y_max_vertex_B + ( n_v - 1 ) * x_max_vertex_B + m_v + 1;

    S_row = zeros(1, 2); S_row(1) = p_lft; S_row(2) = 1;
    sparseS_1{ p_lft } = S_row;
    B_phi( p_lft ) = V_0;

    S_row = zeros(1, 2); S_row(1) = p0; S_row(2) = 1;
    sparseS_1{ p0 } = S_row;
    B_phi( p0 ) = V_0;

    S_row = zeros(1, 2); S_row(1) = p_rght; S_row(2) = 1;
    sparseS_1{ p_rght } = S_row;
    B_phi( p_rght ) = V_0;
end

end
