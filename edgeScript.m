% load('0522Bk.mat', 'B_k');
% build up a look up table for current sheet.
% edgeTable = false(size(B_k));
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    auxiSegMed = ones(6, 8, 'uint8');
    corner_flag = false(2, 6);
    flag = getMNL_flag(m_v, n_v, ell_v);
    SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
    % volume
    switch flag
        case { '111', '000' }
            fc = str2func('fillNrml_K_Type1');
            tpflag = 'type1';
        case { '100', '011' }
            fc = str2func('fillNrml_K_Type2');
            tpflag = 'type2';
            auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        case { '101', '010' }
            fc = str2func('fillNrml_K_Type3');
            tpflag = 'type3';
            auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        case { '110', '001' }
            fc = str2func('fillNrml_K_Type4');
            tpflag = 'type4';
            auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
        otherwise
            error('check');
    end

    TiltType = '';
    EdgeRx = [0, 0];
    if n_v >= 2 && SheetPntsTable(m_v, n_v, ell_v) == 1 && SheetPntsTable(m_v, n_v - 1, ell_v) == 1
        % counter = counter + 1;
        if Vertex_Crdnt(m_v, n_v, ell_v, 1) <= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) >= 0
            % II-quadrant 
            quadtantNum = 2;
            tpflag = strcat(tpflag, '-II');
            if SheetPntsTable(m_v - 1, n_v, ell_v) == 1
                TiltType = 'Horizental';
                % EdgeRx = [2, 4];
            elseif SheetPntsTable(m_v - 1, n_v, ell_v - 1) == 1
                TiltType = 'Oblique';
                % EdgeRx = [2, 7];
            elseif SheetPntsTable(m_v, n_v, ell_v - 1) == 1
                TiltType = 'Vertical';
                % EdgeRx = [2, 5];
            end
        elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) >= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) >= 0
            % I-quadrant 
            quadtantNum = 1;
            tpflag = strcat(tpflag, '-I');
            if SheetPntsTable(m_v - 1, n_v, ell_v) == 1
                TiltType = 'Horizental';
                % EdgeRx = [2, 4];
            elseif SheetPntsTable(m_v - 1, n_v, ell_v + 1) == 1
                TiltType = 'Oblique';
                % EdgeRx = [2, 7];
            elseif SheetPntsTable(m_v, n_v, ell_v + 1) == 1
                TiltType = 'Vertical';
                % EdgeRx = [2, 5];
            end
        elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) >= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) <= 0
            % IV-quadrant 
            quadtantNum = 4;
            tpflag = strcat(tpflag, '-IV');
            if SheetPntsTable(m_v + 1, n_v, ell_v) == 1
                TiltType = 'Horizental';
                % EdgeRx = [2, 4];
            elseif SheetPntsTable(m_v + 1, n_v, ell_v + 1) == 1
                TiltType = 'Oblique';
                % EdgeRx = [2, 7];
            elseif SheetPntsTable(m_v, n_v, ell_v + 1) == 1
                TiltType = 'Vertical';
                % EdgeRx = [2, 5];
            end
        elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) <= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) <= 0
            % III-quadrant 
            quadtantNum = 3;
            tpflag = strcat(tpflag, '-III');
            if SheetPntsTable(m_v + 1, n_v, ell_v) == 1
                TiltType = 'Horizental';
                % EdgeRx = [2, 4];
            elseif SheetPntsTable(m_v + 1, n_v, ell_v - 1) == 1
                TiltType = 'Oblique';
                % EdgeRx = [2, 7];
            elseif SheetPntsTable(m_v, n_v, ell_v - 1) == 1
                TiltType = 'Vertical';
                % EdgeRx = [2, 5];
            end
        end
        
        lastFlag = false;
        if SheetPntsTable(m_v, n_v + 1, ell_v) == 0
            lastFlag = true;
        end

        CandiSet1 = [];
        CandiSet2 = [];
        edgeTable = fillSheetIdx(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                                        tpflag, TiltType, lastFlag, edgeTable, CandiSet1, CandiSet2);
    end
end

% myDiffSet = find(edgeTable - logical(B_k));
% length(myDiffSet)
% length(find(B_k))

% arndNum = length( find(SheetPntsTable(:, int64(w_y / (2 * dy) + 1), :) == 1) );
% for v_idx = 1: 1: x_max_vertex * z_max_vertex
%     [ m_v, ell_v ] = getML(v_idx, x_max_vertex);
%     if SheetPntsTable(m_v, int64(w_y / (2 * dy) + 1), ell_v) == 1;
%         y_n = length( find( SheetPntsTable(m_v, :, ell_v) == 1 ) );
%         break
%     end
% end

% tic;
% disp('The filling time of K_1, K_EV, K_VE and B: ');
% T_Flag = false;
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

%     auxiSegMed = ones(6, 8, 'uint8');
%     flag = getMNL_flag(m_v, n_v, ell_v);
%     corner_flag = false(2, 6);
%     % first row: prime coordinate
%     % second row: original coordinate
%     corner_flag = getCornerFlag(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex);
%     % 1: up; 2: left; 3: down; 4: righ; 5: far; 6: near
%     % flag = '000' or '111' -> SegMedIn = zeros(6, 8, 'uint8');
%     % flag = 'otherwise'    -> SegMedIn = zeros(2, 8, 'uint8');
%     SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );

%     if m_v == 9 && n_v == 14 && ell_v == 13
%         T_Flag = true;
%     end

%     if T_Flag
%     % volume
%     switch flag
%         case { '111', '000' }
%             fc = str2func('fillNrml_K_Type1');
%         case { '100', '011' }
%             fc = str2func('fillNrml_K_Type2');
%             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%         case { '101', '010' }
%             fc = str2func('fillNrml_K_Type3');
%             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%         case { '110', '001' }
%             fc = str2func('fillNrml_K_Type4');
%             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%         otherwise
%             error('check');
%     end
%     % volume
%     if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK1{7 * ( vIdx_prm - 1 ) + 1}, sparseK1{7 * ( vIdx_prm - 1 ) + 2}, sparseK1{7 * ( vIdx_prm - 1 ) + 3}, ...
%             sparseK1{7 * ( vIdx_prm - 1 ) + 4}, sparseK1{7 * ( vIdx_prm - 1 ) + 5}, sparseK1{7 * ( vIdx_prm - 1 ) + 6}, ...
%             sparseK1{7 * ( vIdx_prm - 1 ) + 7}, sparseKEV{7 * ( vIdx_prm - 1 ) + 1}, sparseKEV{7 * ( vIdx_prm - 1 ) + 2}, ...
%             sparseKEV{7 * ( vIdx_prm - 1 ) + 3}, sparseKEV{7 * ( vIdx_prm - 1 ) + 4}, sparseKEV{7 * ( vIdx_prm - 1 ) + 5}, ...
%             sparseKEV{7 * ( vIdx_prm - 1 ) + 6}, sparseKEV{7 * ( vIdx_prm - 1 ) + 7}, sparseKVE{7 * ( vIdx_prm - 1 ) + 1}, ...
%             sparseKVE{7 * ( vIdx_prm - 1 ) + 2}, sparseKVE{7 * ( vIdx_prm - 1 ) + 3}, sparseKVE{7 * ( vIdx_prm - 1 ) + 4}, ...
%             sparseKVE{7 * ( vIdx_prm - 1 ) + 5}, sparseKVE{7 * ( vIdx_prm - 1 ) + 6}, sparseKVE{7 * ( vIdx_prm - 1 ) + 7}, B_k ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                 Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                 B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     % three surfaces
%     if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 6, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 5, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     if m_v >= 2 && m_v <= x_max_vertex && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseK1{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 4, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     % three lines
%     if m_v >= 2 && m_v <= x_max_vertex && n_v == 1 && ell_v == 1
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     if m_v == 1 && n_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     if m_v == 1 && n_v >= 2 && n_v <= y_max_vertex && ell_v == 1
%         [ sparseK1{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKEV{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) }, ...
%             sparseKVE{ vIdx2eIdx(vIdx_prm, 2, x_max_vertex, y_max_vertex, z_max_vertex) } ] ...
%             = fc( m_v, n_v, ell_v, flag, ...
%                         Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%                         B_k, SheetPntsTable, J_0, corner_flag );
%     end
%     end
% end
% toc;



% % % ==== % =========== % ==== %
% % % ==== % BORDER LINE % ==== %
% % % ==== % =========== % ==== %

% load('B_k.mat', 'B_k');
% bknz = find(B_k);
% tol = 1e-6;
% ext_itr_num = 5;
% int_itr_num = 10;

% % bar_x_my_gmres = zeros(size(B_k));
% % nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-3) );
% toc;
% % tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = my_gmres( sparseK, B_k, int_itr_num, tol, ext_itr_num );
% toc;
% AFigsScript;
% save('Case0521_debug.mat', 'bar_x_my_gmres');
% save('Case0521_debug.mat', 'bar_x_my_gmres', 'B_k', 'nrmlM_K');
% clc; clear;
% Shift2d;
% load('0521K_Sol.mat', 'bar_x_my_gmres');
% AFigsScript
% load('Case0521_debugBk.mat', 'B_k');
% edgeXZ = zeros(x_max_vertex, z_max_vertex);

% for idx = 1: 1: x_max_vertex * z_max_vertex
%     [ m_v, ell_v ] = getML(idx, x_max_vertex);
%     n_v = int64( w_y / (2 * dy) + 1 );
%     vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     edgeXZ(m_v, ell_v) = bar_x_my_gmres(vIdx2eIdx(vIdx_prm, 1, x_max_vertex, y_max_vertex, z_max_vertex));
% end

% norm( nrmlM_K * bar_x_my_gmres - B_k) / norm(B_k)
% AFigsScript
% AFigsScript;

% % ==== % =========== % ==== %
% % ==== % BORDER LINE % ==== %
% % ==== % =========== % ==== %

% % ==== % =========== % ==== %
% % ==== % BORDER LINE % ==== %
% % ==== % =========== % ==== %