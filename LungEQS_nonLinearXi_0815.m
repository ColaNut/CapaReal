% clc; clear;
% load('E:\Kevin\20180811_case_unaffected.mat');
% % === === === === === === === === % ================ % === === === === === === === === %
% % === === === === === === === === % Temperature part % === === === === === === === === %
% % === === === === === === === === % ================ % === === === === === === === === %
% 
% % === % ================================================= % === %
% % === % Initialization of Temperature and Other Parameter % === %
% % === % ================================================= % === %
% dt = 15; % 15 seconds
% % timeNum_all = 60; % 1 minutes
% timeNum_all = 50 * 60; % 50 minutes
% loadThermalParas;
% 
% tol = 1e-6;
% ext_itr_num = 5;
% int_itr_num = 20;
% 
% flagX  = zeros(1, timeNum_all / dt + 1);
% relres = zeros(1, timeNum_all / dt + 1);
% % in the first 20 minutes, the time is segmented every 2 minutes
% % timeSeg is unchanged; while other flag is needed to indicate the updating time of nonlinear \xi
% TimeSeg = 50 * 60 / dt; % 200 interval = 200 * 15 = 3,000 seconds = 50 minutes 
% ItrEnd = 11; % a total of 11 updating timing (1, 1, 1, 1, 1, 2, 3, 5, 10, 10, 15) or (0, 1, 2, 3, 4, 5, 7, 10, 15, 25, 35) or (
% 
% Ini_bar_b = zeros(N_v, 1);
% % The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
% bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);
% 
% % the process (calculation of temperature)-(get m_U, m_V) is repeated every 2 minutes
% m_U   = cell(N_v, 1);
% m_V   = cell(N_v, 1);
% % bar_d = zeros(N_v, 1);
% 
% % to-do
% % the xi of muscle is a function of temperature in the erange of 36 ^\circ C to 45 ^\circ C
% % test for non-linear xi of muscle
% 
% % === === % ========================================== % === === %
% % === === % Get m_U and m_V; Calculate The Temperature % === === %
% % === === % ========================================== % === === %  
% Itr = 1;
% variableFlag = true;
% % The script Get_m_U_m_V_and_T update m_U and m_V
% timing_flag = [ 0, 1, 2, 3, 4, 5, 7, 10, 15, 25, 35 ] * 4 + 1; 
% power_timing_flag = [ 0, 5, 35 ] * 4 + 1; 
% 
% Q_s_Vector_ori = Q_s_Vector;

tic;
for idx_T = 41: 1: size(bar_b, 2) - 1
    if find(timing_flag == idx_T)
        idx_T
        if idx_T == power_timing_flag(1)
            Q_s_Vector = Q_s_Vector_ori * 250 / abs(W);
        elseif idx_T == power_timing_flag(2)
            Q_s_Vector = Q_s_Vector_ori * 280 / abs(W);
        elseif idx_T == power_timing_flag(3)
            Q_s_Vector = Q_s_Vector_ori * 300 / abs(W);
        end
        Get_m_U_m_V_and_T_0815;
    end
    [ bar_b(:, idx_T + 1), flagX(idx_T + 1), relres(idx_T + 1) ] = gmres(M_U, M_V * bar_b(:, idx_T) + bar_d, int_itr_num, tol, ext_itr_num );
    % bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
end
toc;

% === % ==================== % === %
% === % Temperature Plotting % === %
% === % ==================== % === %

T_flagXZ = 1;
T_flagXY = 1;
T_flagYZ = 1;

T_plot;
max(max(bar_b))
max(max(T_xz))
max(max(T_xy))
max(max(T_yz))
T_yz(tumor_n_v, tumor_ell_v)

save('20180811_case_unaffected_nonlinear.mat');

return;