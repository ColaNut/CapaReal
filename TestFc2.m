% % % ==== % =========== % ==== %
% % % ==== % BORDER LINE % ==== %
% % % ==== % =========== % ==== %

% y_n = 0;
% arndNum = length( find(SheetPntsTable(:, int64(w_y / (2 * dy) + 1), :) == 1) );
% for v_idx = 1: 1: x_max_vertex * z_max_vertex
%     [ m_v, ell_v ] = getML(v_idx, x_max_vertex);
%     if SheetPntsTable(m_v, int64(w_y / (2 * dy) + 1), ell_v) == 1;
%         y_n = length( find( SheetPntsTable(m_v, :, ell_v) == 1 ) );
%         break
%     end
% end
% EdgeTable = false(N_e, 2); % first row for filled in; second row for prohibition look-up table
% EdgeTable(:, 2) = logical(B_k);
% sparseAug     =  cell( 3 * arndNum * 2 * (y_n - 1), 1 );
% CurrentIdxSet =  cell(     arndNum * 2 * (y_n - 1), 1 );
% AugBk         = zeros( 3 * arndNum * 2 * (y_n - 1), 1 );

% % boundary condition on current sheet 
% counter = int64(0);
% for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
%     [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
%     vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

%     if m_v == 9 && n_v == 9 && ell_v == 13
%         ;
%     end
%     auxiSegMed = ones(6, 8, 'uint8');
%     corner_flag = false(2, 6);
%     flag = getMNL_flag(m_v, n_v, ell_v);
%     SegMedIn = FetchSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%     % volume
%     switch flag
%         case { '111', '000' }
%             fc = str2func('fillNrml_K_Type1');
%             tpflag = 'type1';
%         case { '100', '011' }
%             fc = str2func('fillNrml_K_Type2');
%             tpflag = 'type2';
%             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%         case { '101', '010' }
%             fc = str2func('fillNrml_K_Type3');
%             tpflag = 'type3';
%             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%         case { '110', '001' }
%             fc = str2func('fillNrml_K_Type4');
%             tpflag = 'type4';
%             auxiSegMed = getAuxiSegMed( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, SegMed, flag );
%         otherwise
%             error('check');
%     end
    
%     TiltType = '';
%     EdgeRx = [0, 0];
%     if n_v >= 2 && SheetPntsTable(m_v, n_v, ell_v) == 1 && SheetPntsTable(m_v, n_v - 1, ell_v) == 1
%         counter = counter + 1;
%         if counter == 72 
%             ;
%         end
%         if Vertex_Crdnt(m_v, n_v, ell_v, 1) <= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) >= 0
%             % II-quadrant 
%             quadtantNum = 2;
%             tpflag = strcat(tpflag, '-II');
%             if SheetPntsTable(m_v - 1, n_v, ell_v) == 1
%                 TiltType = 'Horizental';
%                 % EdgeRx = [2, 4];
%             elseif SheetPntsTable(m_v - 1, n_v, ell_v - 1) == 1
%                 TiltType = 'Oblique';
%                 % EdgeRx = [2, 7];
%             elseif SheetPntsTable(m_v, n_v, ell_v - 1) == 1
%                 TiltType = 'Vertical';
%                 % EdgeRx = [2, 5];
%             end
%         elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) >= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) >= 0
%             % I-quadrant 
%             quadtantNum = 1;
%             tpflag = strcat(tpflag, '-I');
%             if SheetPntsTable(m_v - 1, n_v, ell_v) == 1
%                 TiltType = 'Horizental';
%                 % EdgeRx = [2, 4];
%             elseif SheetPntsTable(m_v - 1, n_v, ell_v + 1) == 1
%                 TiltType = 'Oblique';
%                 % EdgeRx = [2, 7];
%             elseif SheetPntsTable(m_v, n_v, ell_v + 1) == 1
%                 TiltType = 'Vertical';
%                 % EdgeRx = [2, 5];
%             end
%         elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) >= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) <= 0
%             % IV-quadrant 
%             quadtantNum = 4;
%             tpflag = strcat(tpflag, '-IV');
%             if SheetPntsTable(m_v + 1, n_v, ell_v) == 1
%                 TiltType = 'Horizental';
%                 % EdgeRx = [2, 4];
%             elseif SheetPntsTable(m_v + 1, n_v, ell_v + 1) == 1
%                 TiltType = 'Oblique';
%                 % EdgeRx = [2, 7];
%             elseif SheetPntsTable(m_v, n_v, ell_v + 1) == 1
%                 TiltType = 'Vertical';
%                 % EdgeRx = [2, 5];
%             end
%         elseif Vertex_Crdnt(m_v, n_v, ell_v, 1) <= 0 && Vertex_Crdnt(m_v, n_v, ell_v, 3) <= 0
%             % III-quadrant 
%             quadtantNum = 3;
%             tpflag = strcat(tpflag, '-III');
%             if SheetPntsTable(m_v + 1, n_v, ell_v) == 1
%                 TiltType = 'Horizental';
%                 % EdgeRx = [2, 4];
%             elseif SheetPntsTable(m_v + 1, n_v, ell_v - 1) == 1
%                 TiltType = 'Oblique';
%                 % EdgeRx = [2, 7];
%             elseif SheetPntsTable(m_v, n_v, ell_v - 1) == 1
%                 TiltType = 'Vertical';
%                 % EdgeRx = [2, 5];
%             end
%         end
%         [ sparseAug{6 * ( counter - 1 ) + 1}, sparseAug{6 * ( counter - 1 ) + 2}, sparseAug{6 * ( counter - 1 ) + 3}, ...
%             CurrentIdxSet{ 2 * (counter - 1) + 1 }, ...
%             sparseAug{6 * ( counter - 1 ) + 4}, sparseAug{6 * ( counter - 1 ) + 5}, sparseAug{6 * ( counter - 1 ) + 6}, ...
%             CurrentIdxSet{ 2 * (counter - 1) + 2 }, ...
%             AugBk(6 * ( counter - 1 ) + 1), AugBk(6 * ( counter - 1 ) + 2), AugBk(6 * ( counter - 1 ) + 3), ...
%             AugBk(6 * ( counter - 1 ) + 4), AugBk(6 * ( counter - 1 ) + 5), AugBk(6 * ( counter - 1 ) + 6) ] ...
%         = fc( m_v, n_v, ell_v, flag, ...
%             Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
%             B_k, SheetPntsTable, J_0, corner_flag, TiltType, quadtantNum, SegMed );

%         % replace the sparseK matrix
%         lastFlag = false;
%         if SheetPntsTable(m_v, n_v + 1, ell_v) == 0
%             lastFlag = true;
%         end
%         AuxiIdx = zeros(6, 1);
%         [ AuxiIdx, EdgeTable ] = getAuxiIdx(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, tpflag, TiltType, lastFlag, ...
%                         EdgeTable, CurrentIdxSet{ 2 * (counter - 1) + 1 }, CurrentIdxSet{ 2 * (counter - 1) + 2 });
%         sparseK{ AuxiIdx(1) } = sparseAug{ 6 * (counter - 1) + 1 };
%         sparseK{ AuxiIdx(2) } = sparseAug{ 6 * (counter - 1) + 2 };
%         sparseK{ AuxiIdx(3) } = sparseAug{ 6 * (counter - 1) + 3 };
%         sparseK{ AuxiIdx(4) } = sparseAug{ 6 * (counter - 1) + 4 };
%         sparseK{ AuxiIdx(5) } = sparseAug{ 6 * (counter - 1) + 5 };
%         sparseK{ AuxiIdx(6) } = sparseAug{ 6 * (counter - 1) + 6 };
%         B_k( AuxiIdx(1) ) = AugBk( 6 * (counter - 1) + 1 );
%         B_k( AuxiIdx(2) ) = AugBk( 6 * (counter - 1) + 2 );
%         B_k( AuxiIdx(3) ) = AugBk( 6 * (counter - 1) + 3 );
%         B_k( AuxiIdx(4) ) = AugBk( 6 * (counter - 1) + 4 );
%         B_k( AuxiIdx(5) ) = AugBk( 6 * (counter - 1) + 5 );
%         B_k( AuxiIdx(6) ) = AugBk( 6 * (counter - 1) + 6 );
%     end
% end

% count = 0;
% for idx = 1: 1: 3 * arndNum * 2 * (y_n - 1)
%     if isempty(sparseAug{ idx })
%         count = count + 1;
%     end
% end
% count

% for idx = 1: 1: arndNum  * (y_n - 1)
%     if AugBk( 3 * ( idx - 1 ) + 3 ) == 0
%         idx
%     end
% end

% % check empty rows: 
% for eIdx = 1: 1: N_e
%     if isempty(sparseK{ eIdx })
%         [ m_v, n_v, ell_v, edgeNum ] = eIdx2vIdx(eIdx, x_max_vertex, y_max_vertex, z_max_vertex)
%     end
% end

% tol = 1e-6;
% ext_itr_num = 5;
% int_itr_num = 10;

% bar_x_my_gmres = zeros(size(B_k));
% nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-1, 'udiag', 1) );
% toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = gmres( nrmlM_K, B_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
% toc;

% % load('UnNormalized.mat');
% % tilde_b = zeros(size(B_k));
% % tilde_b = A_ast_b( sparseK, bar_x_my_gmres );
% % diffB = norm(tilde_b - B_k);
% AFigsScript

y_n = 0;
arndNum = length( find(SheetPntsTable(:, int64(w_y / (2 * dy) + 1), :) == 1) );
for v_idx = 1: 1: x_max_vertex * z_max_vertex
    [ m_v, ell_v ] = getML(v_idx, x_max_vertex);
    if SheetPntsTable(m_v, int64(w_y / (2 * dy) + 1), ell_v) == 1;
        y_n = length( find( SheetPntsTable(m_v, :, ell_v) == 1 ) );
        break
    end
end
EdgeTable = false(N_e, 2); % first row for filled in; second row for prohibition look-up table
EdgeTable(:, 2) = logical(B_k);
sparseAug     =  cell( 3 * arndNum * 2 * (y_n - 1), 1 );
CurrentIdxSet =  cell(     arndNum * 2 * (y_n - 1), 1 );
AugBk         = zeros( 3 * arndNum * 2 * (y_n - 1), 1 );

% boundary condition on current sheet 
counter = int64(0);
for vIdx = 1: 1: x_max_vertex * y_max_vertex * z_max_vertex
    [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
    vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );

    if m_v == 9 && n_v == 9 && ell_v == 13
        ;
    end
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
        counter = counter + 1;
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
        [ sparseAug{6 * ( counter - 1 ) + 1}, sparseAug{6 * ( counter - 1 ) + 2}, sparseAug{6 * ( counter - 1 ) + 3}, ...
            CurrentIdxSet{ 2 * (counter - 1) + 1 }, ...
            sparseAug{6 * ( counter - 1 ) + 4}, sparseAug{6 * ( counter - 1 ) + 5}, sparseAug{6 * ( counter - 1 ) + 6}, ...
            CurrentIdxSet{ 2 * (counter - 1) + 2 }, ...
            AugBk(6 * ( counter - 1 ) + 1), AugBk(6 * ( counter - 1 ) + 2), AugBk(6 * ( counter - 1 ) + 3), ...
            AugBk(6 * ( counter - 1 ) + 4), AugBk(6 * ( counter - 1 ) + 5), AugBk(6 * ( counter - 1 ) + 6) ] ...
        = fc( m_v, n_v, ell_v, flag, ...
            Vertex_Crdnt, x_max_vertex, y_max_vertex, z_max_vertex, SegMedIn, auxiSegMed, epsilon_r, mu_r, Omega_0, ...
            B_k, SheetPntsTable, J_0, corner_flag, TiltType, quadtantNum, SegMed );

        % replace the sparseK matrix
        lastFlag = false;
        if SheetPntsTable(m_v, n_v + 1, ell_v) == 0
            lastFlag = true;
        end
        AuxiIdx = zeros(6, 1);
        [ AuxiIdx, EdgeTable ] = getAuxiIdx(m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, tpflag, TiltType, lastFlag, ...
                        EdgeTable, CurrentIdxSet{ 2 * (counter - 1) + 1 }, CurrentIdxSet{ 2 * (counter - 1) + 2 });
        sparseK{ AuxiIdx(1) } = sparseAug{ 6 * (counter - 1) + 1 };
        sparseK{ AuxiIdx(2) } = sparseAug{ 6 * (counter - 1) + 2 };
        sparseK{ AuxiIdx(3) } = sparseAug{ 6 * (counter - 1) + 3 };
        sparseK{ AuxiIdx(4) } = sparseAug{ 6 * (counter - 1) + 4 };
        sparseK{ AuxiIdx(5) } = sparseAug{ 6 * (counter - 1) + 5 };
        sparseK{ AuxiIdx(6) } = sparseAug{ 6 * (counter - 1) + 6 };
        B_k( AuxiIdx(1) ) = AugBk( 6 * (counter - 1) + 1 );
        B_k( AuxiIdx(2) ) = AugBk( 6 * (counter - 1) + 2 );
        B_k( AuxiIdx(3) ) = AugBk( 6 * (counter - 1) + 3 );
        B_k( AuxiIdx(4) ) = AugBk( 6 * (counter - 1) + 4 );
        B_k( AuxiIdx(5) ) = AugBk( 6 * (counter - 1) + 5 );
        B_k( AuxiIdx(6) ) = AugBk( 6 * (counter - 1) + 6 );
    end
end

count = 0;
for idx = 1: 1: 3 * arndNum * 2 * (y_n - 1)
    if isempty(sparseAug{ idx })
        count = count + 1;
    end
end
count

for idx = 1: 1: arndNum  * (y_n - 1)
    if AugBk( 3 * ( idx - 1 ) + 3 ) == 0
        idx
    end
end

% load('B_k.mat', 'B_k');
% bknz = find(B_k);
% tol = 1e-6;
% ext_itr_num = 5;
% int_itr_num = 10;

% % bar_x_my_gmres = zeros(size(B_k));
% % nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% % tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = my_gmres( sparseK, B_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
% toc;
% AFigsScript;
% load('Case0518_1e2udiag.mat', 'bar_x_my_gmres');
% edgeXZ = zeros(x_max_vertex, z_max_vertex);

% for idx = 1: 1: x_max_vertex * z_max_vertex
%     [ m_v, ell_v ] = getML(idx, x_max_vertex);
%     n_v = int64( w_y / (2 * dy) + 1 );
%     vIdx_prm = get_idx_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
%     edgeXZ(m_v, ell_v) = bar_x_my_gmres(vIdx2eIdx(vIdx_prm, 3, x_max_vertex, y_max_vertex, z_max_vertex));
% end

% AFigsScript;

% counter = 0;
% for eIdx = 1: 1: N_e
%     if B_k(eIdx) ~= 0
%         counter = counter + 1;
%         sparseK{ eIdx } = sparseAug{ counter };
%         B_k( eIdx ) = AugBk( counter );
%     end
% end
% counter

% === % ========================= % === %
% === % Old Normalization Process % === %
% === % ========================= % === %

% for idx = 1: 1: N_e
%     tmp_vector = sparseK{ idx };
%     num = uint64(size(tmp_vector, 2)) / 2;
%     MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
%     tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
%     sparseK{ idx } = tmp_vector;
%     B_k( idx ) = B_k( idx ) ./ MAX_row_value;
% end

% === % =========================== % === %
% === % LU preconditioner and GMRES % === %
% === % =========================== % === %

% tol = 1e-6;
% ext_itr_num = 5;
% int_itr_num = 20;

% bar_x_my_gmres = zeros(size(B_k));
% nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% tic;
% disp('Calculation time of iLU: ')
% [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-3) );
% toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = my_gmres( sparseK, B_k, int_itr_num, tol, ext_itr_num, L_K, U_K );
% toc;

% save('Case0516_1e2.mat', 'bar_x_my_gmres');

% AFigsScript;

% % Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% xy_grid_table format: [ x_coordonate, y_coordonate, difference ]

% % ==== % =========== % ==== %
% % ==== % BORDER LINE % ==== %
% % ==== % =========== % ==== %

% tol = 1e-6;
% ext_itr_num = 10;
% int_itr_num = 50;

% bar_x_my_gmres = zeros(size(B_k));
% % nrmlM_K      = mySparse2MatlabSparse( sparseK, N_e, N_e, 'Row' );
% % tic;
% % disp('Calculation time of iLU: ')
% % [ L_K, U_K ] = ilu( nrmlM_K, struct('type', 'ilutp', 'droptol', 1e-2) );
% % toc;
% tic;
% disp('The gmres solutin of Ax = B: ');
% bar_x_my_gmres = my_gmres( sparseK, B_k, int_itr_num, tol, ext_itr_num );
% toc;

% % save('Case0511_1e2.mat', 'bar_x_my_gmres');

% AFigsScript;

% load('0511sparseK1_equal_sparseK.mat', 'sparseK', 'B_k');

% % ==== % =========== % ==== %
% % ==== % BORDER LINE % ==== %
% % ==== % =========== % ==== %