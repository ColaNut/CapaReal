function GVV_row4Pnt = fillGVV(p1234, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt)

GVV_row4Pnt = zeros(1, 4);
% get the vol
m_v   = zeros(1, 4);
n_v   = zeros(1, 4);
ell_v = zeros(1, 4);
[ m_v(1), n_v(1), ell_v(1) ] = getMNL(r2v(p1234(1)), x_max_vertex, y_max_vertex, z_max_vertex);
[ m_v(2), n_v(2), ell_v(2) ] = getMNL(r2v(p1234(2)), x_max_vertex, y_max_vertex, z_max_vertex);
[ m_v(3), n_v(3), ell_v(3) ] = getMNL(r2v(p1234(3)), x_max_vertex, y_max_vertex, z_max_vertex);
[ m_v(4), n_v(4), ell_v(4) ] = getMNL(r2v(p1234(4)), x_max_vertex, y_max_vertex, z_max_vertex);
P1_Crdt = zeros(1, 3);
P2_Crdt = zeros(1, 3);
P3_Crdt = zeros(1, 3);
P4_Crdt = zeros(1, 3);
P1_Crdt = squeeze( Vertex_Crdnt(m_v(1), n_v(1), ell_v(1), :) );
P2_Crdt = squeeze( Vertex_Crdnt(m_v(2), n_v(2), ell_v(2), :) );
P3_Crdt = squeeze( Vertex_Crdnt(m_v(3), n_v(3), ell_v(3), :) );
P4_Crdt = squeeze( Vertex_Crdnt(m_v(4), n_v(4), ell_v(4), :) );

TtrVol = calTtrVol( P1_Crdt, P2_Crdt, P3_Crdt, P4_Crdt );
W_ration = [2, 1, 1, 1];

GVV_row4Pnt = repmat(TtrVol, 1, 4) .*  W_ration / 20;

end
