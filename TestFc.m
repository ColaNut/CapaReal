dt = 5; % 15 seconds
timeNum_all = 60; % 1 minutes
% timeNum_all = 50 * 60; % 50 minutes
loadThermalParas;

M_U   = sparse(N_v, N_v);
M_V   = sparse(N_v, N_v);
bar_d = zeros(N_v, 1);
disp('The filling time of M_U, M_V and d_m: ');
tic;
for vIdx = 1: 1: N_v
    bioValid = false;
    U_row = sparse(1, N_v);
    V_row = sparse(1, N_v);
    Pnt_d = 0;
    CandiTet = find( MedTetTable(:, vIdx));
    for itr = 1: 1: length(CandiTet)
        % v is un-ordered vertices; while p is ordered vertices.
        % fix the problem in the determination of v1234 here .
        v1234 = find( MedTetTable( CandiTet(itr), : ) );
        if length(v1234) ~= 4
            error('check');
        end
        MedVal = MedTetTable( CandiTet(itr), v1234(1) );
        % this judgement below is based on the current test case
        if MedVal == 3
            bioValid = true;
            if MedTetTable( CandiTet(itr), v1234(1) ) ~= MedTetTable( CandiTet(itr), v1234(2) )
                error('check');
            end
            % check the validity of Q_s_Vector input.
            p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
            [ U_row, V_row, Pnt_d ] = fillUVd( p1234, Bls_bndry, U_row, V_row, Pnt_d, ...
                        dt, Q_s_Vector(CandiTet(itr)), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                        x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt, BM_bndryNum );
        end
    end

    if bioValid
        M_U(vIdx, :) = U_row;
        M_V(vIdx, :) = V_row;
        bar_d(vIdx) = Pnt_d;
    else
        U_row(vIdx) = 1;
        V_row(vIdx) = 1;
        M_U(vIdx, :) = U_row;
        M_V(vIdx, :) = V_row;
    end
end
toc;

% === % ============================= % === %
% === % Initialization of Temperature % === %
% === % ============================= % === %

tic;
disp('Initialization of Temperature');
% from 0 to timeNum_all / dt
Ini_bar_b = zeros(N_v, 1);
% Ini_bar_b = T_air * ones(N_v, 1);
% The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
TetNum = size(MedTetTable, 1);
% get rid of redundancy

% % updating the bolus
% for tIdx = 1: 1: TetNum
%     v1234 = find( MedTetTable(tIdx, :) )';
%     MedVal = MedTetTable( tIdx, v1234(1) );
%     if MedVal == 2
%         Ini_bar_b(v1234) = T_bolus;
%     end
% end
% % updating the muscle
% for tIdx = 1: 1: TetNum
%     v1234 = find( MedTetTable(tIdx, :) )';
%     MedVal = MedTetTable( tIdx, v1234(1) );
%     if MedVal == 3
%         Ini_bar_b(v1234) = T_0;
%     end
% end

bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);
toc;

% === % ========================== % === %
% === % Calculation of Temperature % === %
% === % ========================== % === %

% implement the updating function 
tic;
for idx = 2: 1: size(bar_b, 2) + 1
    bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
end
toc;

% === % ==================== % === %
% === % Temperature Plotting % === %
% === % ==================== % === %

T_flagXZ = 1;
T_flagXY = 1;
T_flagYZ = 1;

T_plot;

return;
