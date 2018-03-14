if constantXiFlag
    disp('Get m_U, m_V and d_m: ');
    tic;
    parfor vIdx = 1: 1: N_v
        bioValid = false;
        U_row = zeros(1, N_v);
        V_row = zeros(1, N_v);
        Pnt_d = 0;
        CandiTet = find( MedTetTable(:, vIdx));
        for itr = 1: 1: length(CandiTet)
            % v is un-ordered vertices; while p is ordered vertices.
            % fix the problem in the determination of v1234 here .
            TetRow = MedTetTableCell{ CandiTet(itr) };
            v1234 = TetRow(1: 4);
            if length(v1234) ~= 4
                error('check');
            end
            MedVal = TetRow(5);
            % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
            % this judgement below is based on the current test case
            if MedVal >= 3 && MedVal <= 9
                bioValid = true;
                if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
                    error('check');
                end
                % check the validity of Q_s_Vector input.
                p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                [ U_row, V_row, Pnt_d ] = fillUVd( p1234, BndryTable, U_row, V_row, Pnt_d, ...
                        dt, Q_s_Vector(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                        x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
            end
        end

        if bioValid
            m_U{vIdx} = Mrow2myRow(U_row);
            m_V{vIdx} = Mrow2myRow(V_row);
            bar_d(vIdx) = Pnt_d;
        else
            m_U{vIdx} = [vIdx, 1];
            m_V{vIdx} = [vIdx, 1];
        end
    end
    toc;

    M_U   = sparse(N_v, N_v);
    M_V   = sparse(N_v, N_v);
    tic;
    disp('Transfroming M_U and M_V from my_sparse to Matlab sparse matrix')
    M_U = mySparse2MatlabSparse( m_U, N_v, N_v, 'Row' );
    M_V = mySparse2MatlabSparse( m_V, N_v, N_v, 'Row' );
    toc;

    % === % ===================== % === %
    % === % Calculate Temperature % === %
    % === % ===================== % === %
    for idx = 2: 1: size(bar_b, 2)
        [ bar_b(:, idx), flagX(idx), relres(idx) ] = gmres(M_U, M_V * bar_b(:, idx - 1) + bar_d, int_itr_num, tol, ext_itr_num );
        % bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
    end
else
    if variableTmprtrFlag
        disp('Getting MedTetTableCell_T');
        MedTetTableCell_T = cell(validNum, 1);
        for idx = 1: 1: validNum
            TetRow = MedTetTableCell{ idx };
            v1234 = TetRow(1: 4);
            MedTetTableCell_T{idx} = mean( bar_b(v1234, TimeSeg * (Itr - 1) + 1) );
        end

        disp('Get m_U, m_V and d_m: ');
        tic;
        parfor vIdx = 1: 1: N_v
            bioValid = false;
            U_row = zeros(1, N_v);
            V_row = zeros(1, N_v);
            Pnt_d = 0;
            CandiTet = find( MedTetTable(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here .
                TetRow = MedTetTableCell{ CandiTet(itr) };
                % retrieve the temperature
                TetTmprtr = MedTetTableCell_T{ CandiTet(itr) };
                v1234 = TetRow(1: 4);
                if length(v1234) ~= 4
                    error('check');
                end
                MedVal = TetRow(5);
                % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
                % this judgement below is based on the current test case
                if MedVal >= 3 && MedVal <= 9
                    bioValid = true;
                    if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
                        error('check');
                    end
                    % check the validity of Q_s_Vector input.
                    p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                    if MedVal == 3
                        % to-do
                        % implement the fx muscleXi in the range from 36$^\circ$C to 45$^\circ$C.
                        [ U_row, V_row, Pnt_d ] = fillUVd( p1234, BndryTable, U_row, V_row, Pnt_d, ...
                                    dt, Q_s_Vector(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), muscleXi(TetTmprtr), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                                    x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
                    elseif MedVal == 7
                        [ U_row, V_row, Pnt_d ] = fillUVd( p1234, BndryTable, U_row, V_row, Pnt_d, ...
                                    dt, Q_s_Vector(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), fatXi(TetTmprtr), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                                    x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
                    else
                        [ U_row, V_row, Pnt_d ] = fillUVd( p1234, BndryTable, U_row, V_row, Pnt_d, ...
                                    dt, Q_s_Vector(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                                    x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
                    end
                end
            end

            if bioValid
                m_U{vIdx} = Mrow2myRow(U_row);
                m_V{vIdx} = Mrow2myRow(V_row);
                bar_d(vIdx) = Pnt_d;
            else
                m_U{vIdx} = [vIdx, 1];
                m_V{vIdx} = [vIdx, 1];
            end
        end
        toc;

        M_U   = sparse(N_v, N_v);
        M_V   = sparse(N_v, N_v);
        tic;
        disp('Transfroming M_U and M_V from my_sparse to Matlab sparse matrix')
        M_U = mySparse2MatlabSparse( m_U, N_v, N_v, 'Row' );
        M_V = mySparse2MatlabSparse( m_V, N_v, N_v, 'Row' );
        toc;

        % === % ===================== % === %
        % === % Calculate Temperature % === %
        % === % ===================== % === %
        for idx = TimeSeg * (Itr - 1) + 2: 1: TimeSeg * Itr + 1
            [ bar_b(:, idx), flagX(idx), relres(idx) ] = gmres(M_U, M_V * bar_b(:, idx - 1) + bar_d, int_itr_num, tol, ext_itr_num );
            % bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
        end
    else
        tic;
        for idx = TimeSeg * (Itr - 1) + 2: 1: size(bar_b, 2)
            [ bar_b(:, idx), flagX(idx), relres(idx) ] = gmres(M_U, M_V * bar_b(:, idx - 1) + bar_d, int_itr_num, tol, ext_itr_num );
            % bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
        end
        toc;
    end
end