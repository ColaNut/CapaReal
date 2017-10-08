% === % ========================================= % === %
% === % Construction of coordinate and grid shift % === %
% === % ========================================= % === %
clc; clear;
digits;
disp('Esophagus: EQS, 1005');
Mu_0          = 4 * pi * 10^(-7);
Epsilon_0     = 10^(-9) / (36 * pi);
Omega_0       = 2 * pi * 8 * 10^6; % 2 * pi * 8 MHz
V_0           = 10; 

% paras: 
              %     1      2       3 ;
              % [ air, bolus, muscle ];
rho           = [   1,  1020,   1020 ]';
epsilon_r_pre = [   1, 113.0,    113 ]';
sigma         = [   0,  0.61,   0.61 ]';
epsilon_r     = epsilon_r_pre - j * sigma / ( Omega_0 * Epsilon_0 );

% There 'must' be a grid point at the origin.
loadParas_Mag;
% paras = [ w_x, w_y, w_z, h_x, h_y, h_z, ell_z, r_c, dx, dy, dz ];

x_idx_max = w_x / dx + 1;
y_idx_max = w_y / dy + 1;
z_idx_max = w_z / dz + 1;

GridShiftTableXZ = cell( y_idx_max, 1);
% GridShiftTableXZ: store [ 1, distance ], [ 3, distance ] and [ 2, distance ] for $x$-, $y$- and $z$ shift.
% Need to check whether [ 3, 1, 0.3 ] & [ 3, 1, -0.3 ] are stored in the same cell(idx).
% xy_grid_table format: [ x_coordonate, y_coordonate, difference ]
mediumTable = ones( x_idx_max, y_idx_max, z_idx_max, 'uint8');
% air                : 1 
% bolus              : 2
% muscle             : 3 
% current sheet bndry: 11

for y = - w_y / 2: dy: w_y / 2
    paras2dXZ_Mag = genParas2dXZ_Mag( y, Paras_Mag );
    y_idx = y / dy + w_y / (2 * dy) + 1;
    sample_valid = paras2dXZ_Mag(12);
    if sample_valid
        mediumTable(:, int64(y_idx), :) = getRoughMed_Mag( mediumTable(:, int64(y_idx), :), paras2dXZ_Mag );
    end
    [ GridShiftTableXZ{ int64(y_idx) }, mediumTable(:, int64(y_idx), :) ] = constructCoordinateXZ_all_Mag( paras2dXZ_Mag, mediumTable(:, int64(y_idx), :) );
end

% re-organize the GridShiftTable
GridShiftTable = cell( w_x / dx + 1, w_y / dy + 1, w_z / dz + 1 );
for y_idx = 1: 1: w_y / dy + 1
    tmp_table = GridShiftTableXZ{ y_idx };
    for x_idx = 1: 1: w_x / dx + 1
        for z_idx = 1: 1: w_z / dz + 1
            GridShiftTable{ x_idx, y_idx, z_idx } = tmp_table{ x_idx, z_idx };
        end
    end
end

% if the following command is added, the bug is fixed.
% mediumTable( find(mediumTable == 3) ) = 2;
shiftedCoordinateXYZ = constructCoordinateXYZ( GridShiftTable, [ w_y, w_x, w_z ], dx, dy, dz );

% === % =================== % === %
% === % Updating the SegMed % === %
% === % =================== % === % 
FillingMed = uint8(2);
SegMed = ones( x_idx_max, y_idx_max, z_idx_max, 6, 8, 'uint8');

MskMedTab = mediumTable;
MskMedTab( find(MskMedTab >= 10) ) = 0;
% update the SegMed for mediumTable(:) == 2;
disp('The fill up time of SegMed: ');
tic;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    % idx = ( ell - 1 ) * x_idx_max * y_idx_max + ( n - 1 ) * x_idx_max + m;
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    % idx = idx;

    if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        if MskMedTab(idx) ~= 0 % normal normal point
        % if mediumTable(idx) == 1 || mediumTable(idx) == 2 || mediumTable(idx) == 3 || mediumTable(idx) == 4 || mediumTable(idx) == 5 
            [ sparseA{ idx }, SegMed( m, n, ell, :, : ) ] = fillNrmlPt_A( m, n, ell, ...
                            shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab );
        elseif MskMedTab(idx) == 0 % normal bondary point
            [ sparseA{ idx }, SegMed( m, n, ell, :, : ) ] = fillBndrPt_A( m, n, ell, ...
                shiftedCoordinateXYZ, x_idx_max, y_idx_max, z_idx_max, MskMedTab, ...
                epsilon_r, squeeze( SegMed(m, n, ell, :, :) ) );
        end
    elseif ell == z_idx_max
        sparseA{ idx } = fillTop_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif ell == 1
        sparseA{ idx } = fillBttm_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif m == x_idx_max && ell >= 2 && ell <= z_idx_max - 1 
        sparseA{ idx } = fillRight_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif m == 1 && ell >= 2 && ell <= z_idx_max - 1 
        sparseA{ idx } = fillLeft_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif n == y_idx_max && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        sparseA{ idx } = fillFront_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    elseif n == 1 && m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        sparseA{ idx } = fillBack_A( m, n, ell, x_idx_max, y_idx_max, z_idx_max );
    end
end
toc;

x_idx_left = int64(- h_x / (2 * dx) + w_x / (2 * dx) + 1);
x_idx_rght = int64(  h_x / (2 * dx) + w_x / (2 * dx) + 1);
y_idx_near = int64(- h_y / (2 * dy) + w_y / (2 * dy) + 1);
y_idx_far  = int64(  h_y / (2 * dy) + w_y / (2 * dy) + 1);
z_idx_down = int64(- h_z / (2 * dz) + w_z / (2 * dz) + 1);
z_idx_up   = int64(  h_z / (2 * dz) + w_z / (2 * dz) + 1);

for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if mediumTable(m, n, ell) == uint8(3)
        SegMed(m, n, ell, :, :) = uint8(3);

        if ell == z_idx_up
            SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), FillingMed );
        end
        if ell == z_idx_down
            SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), FillingMed );
        end
        if m   == x_idx_left
            SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), FillingMed );
        end
        if m   == x_idx_rght
            SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), FillingMed );
        end
        if n   == y_idx_far
            SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), FillingMed );
        end
        if n   == y_idx_near
            SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), FillingMed );
        end
    end
end

byndCD = 30;
% trim for SegMed: unvalid set to 30
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if ell == z_idx_max
        SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if ell == 1
        SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if m   == 1
        SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if m   == x_idx_max
        SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if n   == y_idx_max
        SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
    if n   == 1
        SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
    end
end

% === % ======================================================== % === %
% === % Vertex_Crdnt Construction and calculate basic parameters % === %
% === % ======================================================== % === % 

x_max_vertex = 2 * ( x_idx_max - 1 ) + 1;
y_max_vertex = 2 * ( y_idx_max - 1 ) + 1;
z_max_vertex = 2 * ( z_idx_max - 1 ) + 1;
N_v = x_max_vertex * y_max_vertex * z_max_vertex;
N_e = 7 * (x_max_vertex - 1) * (y_max_vertex - 1) * (z_max_vertex - 1) ...
    + 3 * ( (x_max_vertex - 1) * (y_max_vertex - 1) + (y_max_vertex - 1) * (z_max_vertex - 1) + (x_max_vertex - 1) * (z_max_vertex - 1) ) ...
    + (x_max_vertex - 1) + (y_max_vertex - 1) + (z_max_vertex - 1);

Vertex_Crdnt = zeros( x_max_vertex, y_max_vertex, z_max_vertex, 3 );
tic;
disp('Calculation of vertex coordinate');
Vertex_Crdnt = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ );
toc;

% return;

% === === % ======================================== % === === %
% === === % Draw The Second Rectangular Box Naming B % === === %
% === === % ======================================== % === === %
% region B: [-3, 3, 2, 8]
% region C: [-1, 1, 4, 6]
% domain B has actual size of [ w_x_B + dx, w_y_B + dy, w_z_B + dz ]
w_x_B = h_x;
w_y_B = h_y;
w_z_B = h_z; % w_x_B, w_y_B and w_z_B must be on the grid of domain A
dx_B = dx / 2;
dy_B = dy / 2;
dz_B = dz / 2;
% Domain B
x_idx_max_B = ( w_x_B + dx ) / dx_B + 1;
y_idx_max_B = ( w_y_B + dy ) / dy_B + 1;
z_idx_max_B = ( w_z_B + dz ) / dz_B + 1;
x_max_vertex_B = 2 * x_idx_max_B - 1;
y_max_vertex_B = 2 * y_idx_max_B - 1;
z_max_vertex_B = 2 * z_idx_max_B - 1;
% Larger Grid on Domain B; 
% check the usage of x_max_vertex_AinB
x_idx_max_AinB = w_x_B / ( 2 * dx_B ) + 1; % dx_A = 2 * dx_B
y_idx_max_AinB = w_y_B / ( 2 * dy_B ) + 1; % dy_A = 2 * dy_B
z_idx_max_AinB = w_z_B / ( 2 * dz_B ) + 1; % dz_A = 2 * dz_B
x_max_vertex_AinB = 2 * x_idx_max_AinB + 1;
y_max_vertex_AinB = 2 * y_idx_max_AinB + 1;
z_max_vertex_AinB = 2 * z_idx_max_AinB + 1;

% to-do
% The prolonged part of esophagus is not incorporated in the nest
% implement grid shift for esophagus and tumor
mediumTable_B = 3 * ones( int64(x_idx_max_B), int64(y_idx_max_B), int64(z_idx_max_B), 'uint8');
GridShiftTable_B = cell( int64(x_idx_max_B), int64(y_idx_max_B), int64(z_idx_max_B) );

shiftedCoordinateXYZ_B = constructCoordinateXYZ( GridShiftTable_B, [w_y_B + dx, w_x_B + dy, w_z_B + dz], dx_B, dy_B, dz_B );

% Get vertex coordinate in domain B
Vertex_Crdnt_B = zeros( int64(x_max_vertex_B), int64(y_max_vertex_B), int64(z_max_vertex_B), 3 );
tic;
disp('Calculation of vertex coordinate');
Vertex_Crdnt_B = buildCoordinateXYZ_Vertex( shiftedCoordinateXYZ_B );
toc;

% to-do
% SegMed determination in domain B
SegMed_B = 3 * ones( int64(x_idx_max_B), int64(y_idx_max_B), int64(z_idx_max_B), 6, 8, 'uint8');

save('1005Tmp.mat');

% === % ==================================== % === %
% === % Trimming: Invalid set to 30 (byndCD) % === %
% === % ==================================== % === % 
% unvalid SegMed and SegMed_B are set to byndCD; 
SegMed = setBndrySegMed(SegMed, byndCD, x_idx_max, y_idx_max, z_idx_max);
SegMed_B = setBndrySegMed(SegMed_B, byndCD, int64(x_idx_max_B), int64(y_idx_max_B), int64(z_idx_max_B));

% to-do 
% the line Cases is discard temporarily
validNum = getValidNum(x_idx_max, y_idx_max, z_idx_max);
validNum_AplusB = validNum - 48 * x_idx_max_AinB * y_idx_max_AinB * z_idx_max_AinB ...
                + getValidNum(x_idx_max_B, y_idx_max_B, z_idx_max_B) ... % volume
                + ( (4 - 1) + (2 - 1) )* 8 * (x_idx_max_AinB * y_idx_max_AinB + y_idx_max_AinB * z_idx_max_AinB + x_idx_max_AinB * z_idx_max_AinB) * 2 ... % 6 facets
                ; % + (2 - 1) * 4 * (x_idx_max + y_idx_max + z_idx_max) * 4; % 12 lines
ExpandedNum = 48 * (x_idx_max * y_idx_max * z_idx_max + x_idx_max_B * y_idx_max_B * z_idx_max_B) ...
                + ( 4 + 2 ) * 8 * (x_idx_max_AinB * y_idx_max_AinB + y_idx_max_AinB * z_idx_max_AinB + x_idx_max_AinB * z_idx_max_AinB) * 2 ... % 6 facets
                ; % + 2 * 4 * (x_idx_max + y_idx_max + z_idx_max) * 4; % 12 lines
MedTetTableCell_AplusB_pre = cell(ExpandedNum, 1); % each row consists the indices of the four vertices and is medium value.
validTetTable              = false(ExpandedNum, 1); 

tic;
disp('Getting MedTetTableCell_AplusB -- Domain A: ');
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    PntMedTetTableCell  = cell(48, 1);
    PntMedTetTableCell = getPntMedTetTable_2( squeeze( SegMed(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
    MedTetTableCell_AplusB_pre( 48 * (idx - 1) + 1: 48 * idx ) = PntMedTetTableCell;
    % to-do
    % cuting domain B our of domain A
    PntValidTet = false(48, 1);
    PntValidTet( find( squeeze( SegMed(m, n, ell, :, :) )' ~= byndCD ) ) = true;
    validTetTable( 48 * (idx - 1) + 1: 48 * idx ) = PntValidTet;
end
toc;

tic;
disp('Getting MedTetTableCell_AplusB -- Domain B: ');
BaseIdx = 48 * x_idx_max * y_idx_max * z_idx_max;
for idx = 1: 1: double(int64(x_idx_max_B * y_idx_max_B * z_idx_max_B))
    [ m, n, ell ] = getMNL(idx, x_idx_max_B, y_idx_max_B, z_idx_max_B);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    PntMedTetTableCell  = cell(48, 1);
    PntMedTetTableCell = getPntMedTetTable_2( squeeze( SegMed_B(m, n, ell, :, :) )', N_v, m_v, n_v, ell_v, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B );
    MedTetTableCell_AplusB_pre( BaseIdx + 48 * (idx - 1) + 1: BaseIdx + 48 * idx ) = PntMedTetTableCell;
    PntValidTet = false(48, 1);
    PntValidTet( find( squeeze( SegMed_B(m, n, ell, :, :) )' ~= byndCD ) ) = true;
    validTetTable( BaseIdx + 48 * (idx - 1) + 1: BaseIdx + 48 * idx ) = PntValidTet;
end
toc;

% modify the PntMedTetTableCell in the range of [ BaseIdx + 1, BaseIdx + 48 * x_idx_max_B * y_idx_max_B * z_idx_max_B ]
for idx = BaseIdx + 1: 1: BaseIdx + 48 * x_idx_max_B * y_idx_max_B * z_idx_max_B
    TmpTet = MedTetTableCell_AplusB_pre{ idx };
    TmpTet(1: 4) = TmpTet(1: 4) + N_v;
    MedTetTableCell_AplusB_pre{ idx } = TmpTet;
end

RegionB = false(x_idx_max, y_idx_max, z_idx_max);
m_Rght  = ( + w_x_B / 2 ) / dx + w_x / (2 * dx) + 1;
m_Lft   = ( - w_x_B / 2 ) / dx + w_x / (2 * dx) + 1;
n_Far   = ( + w_y_B / 2 ) / dy + w_y / (2 * dy) + 1;
n_Near  = ( - w_y_B / 2 ) / dy + w_y / (2 * dy) + 1;
ell_Top = ( + w_z_B / 2 ) / dz + w_z / (2 * dz) + 1;
ell_Dwn = ( - w_z_B / 2 ) / dz + w_z / (2 * dz) + 1;
RegionB(m_Lft: m_Rght, n_Near: n_Far, ell_Dwn: ell_Top) = true;

% clc; clear;
% check A_MNEllv_2_B_MNEllv.m and A_MNEllv_2_B_MNEll.m
% load('PreSurrounding.mat');
% the line cases are discarded in the first simulation
tic;
disp('Getting MedTetTableCell_AplusB -- Surrounding Part of Domain B: ');
BaseIdx = 48 * ( x_idx_max * y_idx_max * z_idx_max + x_idx_max_B * y_idx_max_B * z_idx_max_B );
TetCounter = BaseIdx;
TetCounter2 = 0;
TetCounter3 = 0;
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    if m >= 2 && m <= x_idx_max - 1 && n >= 2 && n <= y_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        Med27Value = zeros(3, 9);
        Med27Value = get27MedValue( m, n, ell, RegionB );
        if ~isempty(find(Med27Value)) && RegionB(m, n, ell) == false
            m_v = 2 * m - 1;
            n_v = 2 * n - 1;
            ell_v = 2 * ell - 1;
            p0_v = ( ell_v - 1 ) * x_max_vertex * y_max_vertex + ( n_v - 1 ) * x_max_vertex + m_v;
            % to-do (to be amended for the line case)
            [ PntMedTetTableCell, InvalidTetIdcs ] = getPntMedTetTable_B_arnd_SMALL( squeeze( SegMed(m, n, ell, :, :) )', Med27Value, ...
                                    idx, p0_v, m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                                    x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, N_v, w_x_B, w_y_B, w_z_B, dx_B, dy_B, dz_B );

            MedTetTableCell_AplusB_pre( TetCounter + 1: TetCounter + length(PntMedTetTableCell) ) = PntMedTetTableCell;
            validTetTable( TetCounter + 1: TetCounter + length(PntMedTetTableCell) ) = true;
            TetCounter = TetCounter + length(PntMedTetTableCell);
            if ~isempty(InvalidTetIdcs)
                if validTetTable(InvalidTetIdcs) ~= true(length(InvalidTetIdcs), 1)
                    [m, n, ell]
                    idx
                end
                TetCounter3 = TetCounter3 + length(InvalidTetIdcs);
            end
            % eliminate the exisinting large tetrahedra
            validTetTable(InvalidTetIdcs) = false;
        end
        if RegionB(m, n, ell)
            if length( find(validTetTable(48 * (idx - 1) + 1: 48 * idx)) ) ~= 48
                error('check');
            end
            TetCounter2 = TetCounter2 + 48;
            validTetTable(48 * (idx - 1) + 1: 48 * idx) = false;
        end
    end
end
toc;

MedTetTableCell_AplusB = MedTetTableCell_AplusB_pre;
MedTetTableCell_AplusB(~validTetTable) = [];

if size(MedTetTableCell_AplusB, 1) ~= validNum_AplusB
    error('check the construction');
end

% to-do -- done
% the total vertex in regin A (original) + B (newly-imposed domain)
N_v_B = N_v + x_max_vertex_B * y_max_vertex_B * z_max_vertex_B ...
            - x_max_vertex_AinB * y_max_vertex_AinB * z_max_vertex_AinB; % actual number in column of MedTetTable_B
total_N_v = N_v + x_max_vertex_B * y_max_vertex_B * z_max_vertex_B;
MedTetTable_B = sparse(double(validNum_AplusB), double(total_N_v));
tic;
disp('Transfroming MedTetTable from my_sparse to Matlab sparse matrix')
MedTetTable_B = mySparse2MatlabSparse( MedTetTableCell_AplusB, validNum_AplusB, total_N_v, 'Row' );
toc;

return;

% to-do
% fill sparseS
% === === % ================== % === === %
% === === % Filling of sparseS % === === %
% === === % ================== % === === %
sparseS = cell(total_N_v, 1);
B_phi = zeros(total_N_v, 1);
tic;
disp('The Filling Time of S \cdot Phi = b_phi in Finner grid Coordinate: ');
% note for the boudary point, i.e., fillTop_A, fillBttm_A, fillRight_A, fillLeft_A, fillFront_A, fillBack_A
tic;
for vIdx = 1: 1: total_N_v
    % vFlag = 0, 1 and 2 correspond to invalid AinB, valid A, valid A boundary and valid B, respectively.
    vFlag = VrtxValidFx(vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, w_x_B, w_y_B, w_z_B, dx, dy, dz );
    if vFlag == 0
        sparseS{ vIdx } = [ vIdx, 1 ];
        B_phi{ vIdx } = 1;
    else
        if vFlag == 2
            [ m_v, n_v, ell_v ] = getMNL(vIdx, x_max_vertex, y_max_vertex, z_max_vertex);
            if ell_v == z_max_vertex
                sparseS{ vIdx } = fillTop_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
            elseif ell_v == 1
                sparseS{ vIdx } = fillBttm_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
            elseif m_v == x_max_vertex && ell_v >= 2 && ell_v <= z_max_vertex - 1 
                sparseS{ vIdx } = fillRight_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
            elseif m_v == 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
                sparseS{ vIdx } = fillLeft_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
            elseif n_v == y_max_vertex && m_v >= 2 && m_v <= x_max_vertex - 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
                sparseS{ vIdx } = fillFront_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
            elseif n_v == 1 && m_v >= 2 && m_v <= x_max_vertex - 1 && ell_v >= 2 && ell_v <= z_max_vertex - 1 
                sparseS{ vIdx } = fillBack_A( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex );
            end
        else % vFlag == 1 || vFlag == 3 ( valid A || valid B )
            S1_row = zeros(1, total_N_v);
            CandiTet = find( MedTetTable_B(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here .
                TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
                v1234 = TetRow(1: 4);
                if length(v1234) ~= 4
                    error('check');
                end
                MedVal = TetRow(5);
                % this judgement below is based on the current test case
                if MedTetTable_B( CandiTet(itr), v1234(1) ) ~= MedTetTable_B( CandiTet(itr), v1234(2) )
                    error('check');
                end
                p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                S1_row = fillS1_Eso( p1234, S1_row, epsilon_r(MedVal), ...
                            N_v, x_max_vertex, y_max_vertex, z_max_vertex, ...
                            w_x_B, w_y_B, w_z_B, dx, dy, dz, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, ...
                            Vertex_Crdnt, Vertex_Crdnt_B );
            end
            sparseS{vIdx} = Mrow2myRow(S1_row);
        end
    end
end
toc;

% to-do
% put on Electrode

return;
clc; clear;
% this version is actually effected by the PutOnTopElctrd_liver fx.
load('0929PreElectrode.mat');
Vertex_Crdnt_B(:, :, :, 3) = Vertex_Crdnt_B(:, :, :, 3) + es_z;
B_phi = zeros(total_N_v, 1);
y_mid = ( h_torso / ( 2 * dy ) ) + 1;
BndryTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
% 19: position of top-electrode
TpElctrdPos = 19;
% % save('0924EsoBeforeElctrd_v2.mat')
% % return;
% % endowment of electrode, where the upper electrode is set to be zero
[ sparseS, B_phi, BndryTable ] = PutOnTopElctrd_liver( sparseS, B_phi, 0, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
                        dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex, z_max_vertex, BndryTable, TpElctrdPos );
% to-do
% put on down electrode
% [ sparseS, B_phi, BndryTable ] = PutOnTopElctrd( sparseS, B_phi, V_0, squeeze(mediumTable(:, y_mid, :)), tumor_x, tumor_y, ...
%                         dx, dy, dz, air_x, air_z, h_torso, x_max_vertex, y_max_vertex, z_max_vertex, BndryTable, TpElctrdPos );
[ sparseS, B_phi ] = PutOnDwnElctrd_Esophagus_Fine( sparseS, B_phi, N_v, V_0, x_max_vertex_B, y_max_vertex_B, w_x_B, w_y_B, w_z_B, dx_B, dy_B, dz_B );

Nrml_sparseS = cell(total_N_v, 1);
Nrml_B_phi = zeros(total_N_v, 1);
% Normalize each rows
for idx = 1: 1: total_N_v
    tmp_vector = sparseS{ idx };
    num = uint8(size(tmp_vector, 2)) / 2;
    MAX_row_value = max( abs( tmp_vector( num + 1: 2 * num ) ) );
    tmp_vector( num + 1: 2 * num ) = tmp_vector( num + 1: 2 * num ) ./ MAX_row_value;
    Nrml_sparseS{ idx } = tmp_vector;
    Nrml_B_phi( idx ) = B_phi( idx ) ./ MAX_row_value;
end

% === % ============== % === %
% === % GMRES solution % === %
% === % ============== % === %
tol = 1e-6;
ext_itr_num = 5;
int_itr_num = 20;

bar_x_my_gmresPhi = zeros(size(B_phi));
M_S = mySparse2MatlabSparse( Nrml_sparseS, total_N_v, total_N_v, 'Row' );
tic;
disp('Calculation time of iLU: ')
[ L_S, U_S ] = ilu( M_S, struct('type', 'ilutp', 'droptol', 1e-2) );
toc;
tic;
disp('The gmres solutin of M_S x = B_phi: ');
bar_x_my_gmresPhi = gmres( M_S, Nrml_B_phi, int_itr_num, tol, ext_itr_num, L_S, U_S );
% bar_x_my_gmres = my_gmres( sparseS, B_phi, int_itr_num, tol, ext_itr_num );
toc;

FigsScriptEsophagusEQS_Fine;

% === === === === === === === === % ============================ % === === === === === === === === %
% === === === === === === === === % Preparing Q_s and BndryTable % === === === === === === === === %
% === === === === === === === === % ============================ % === === === === === === === === %
% filling BndryTable in domain A
BndryTable = zeros( x_max_vertex, y_max_vertex, z_max_vertex );
BndryTable_B = zeros( x_max_vertex_B, y_max_vertex_B, z_max_vertex_B );

% return;
% Set boundary SegMed back to an valid medium number, i.e. 1
SegMed = setBndrySegMed(SegMed, 1, x_idx_max, y_idx_max, z_idx_max);
SegMed_B = setBndrySegMed(SegMed_B, 1, int64(x_idx_max_B), int64(y_idx_max_B), int64(z_idx_max_B));

bar_x_my_gmres1 = bar_x_my_gmresPhi;
SigmaE = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8, 3);
Q_s    = zeros(x_idx_max, y_idx_max, z_idx_max, 6, 8);
tic;
disp('Calclation Time Of SigmeE And Q_s In Domain A');
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;
    Phi27 = zeros(3, 9);
    PntsIdx      = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    % PntsIdx in get27Pnts_prm act as an tmp acceptor; updated to real PntsIdx in get27Pnts_KEV
    [ PntsIdx, PntsCrdnt ] = get27Pnts_prm( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
    PntsIdx = get27Pnts_KEV( m_v, n_v, ell_v, x_max_vertex, y_max_vertex, z_max_vertex, Vertex_Crdnt );
    Phi27 = bar_x_my_gmresPhi(PntsIdx);

    [ SigmaE(m, n, ell, :, :, :), Q_s(m, n, ell, :, :) ] = getSigmaE( Phi27, PntsCrdnt, squeeze( SegMed(m, n, ell, :, :) ), sigma, j * Omega_0 * Epsilon_0 * epsilon_r_pre );
end
toc;

SigmaE_B = zeros(x_idx_max_B, y_idx_max_B, z_idx_max_B, 6, 8, 3);
Q_s_B    = zeros(x_idx_max_B, y_idx_max_B, z_idx_max_B, 6, 8);
tic;
disp('Calclation Time Of SigmeE And Q_s In Domain B');
for idx_B = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
    [ m_B, n_B, ell_B ] = getMNL(idx_B, x_idx_max_B, y_idx_max_B, z_idx_max_B);
    m_v_B = 2 * m_B - 1;
    n_v_B = 2 * n_B - 1;
    ell_v_B = 2 * ell_B - 1;
    Phi27        = zeros(3, 9);
    PntsIdx      = zeros( 3, 9 );
    PntsCrdnt    = zeros( 3, 9, 3 );
    % PntsIdx in get27Pnts_prm act as an tmp acceptor; updated to real PntsIdx in get27Pnts_KEV
    [ PntsIdx, PntsCrdnt ] = get27Pnts_prm( m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt_B );
    PntsIdx = get27Pnts_KEV( m_v_B, n_v_B, ell_v_B, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, Vertex_Crdnt_B );
    Phi27 = bar_x_my_gmresPhi(PntsIdx + N_v);

    % the SigmaE_B cannot be used in the following code !!!
    [ SigmaE_B(m_B, n_B, ell_B, :, :, :), Q_s_B(m_B, n_B, ell_B, :, :) ] = getSigmaE( Phi27, PntsCrdnt, squeeze( SegMed(m_B, n_B, ell_B, :, :) ), sigma, j * Omega_0 * Epsilon_0 * epsilon_r_pre );
end
toc;

% Set boundary SegMed back to byndCD
SegMed = setBndrySegMed(SegMed, byndCD, x_idx_max, y_idx_max, z_idx_max);
SegMed_B = setBndrySegMed(SegMed_B, byndCD, int64(x_idx_max_B), int64(y_idx_max_B), int64(z_idx_max_B));

% === % =========== % === %
% === % Getting Q_s % === %
% === % =========== % === % 
% to-do
% the facets and line boundary tetrahdron are ignored
Q_s_Vector       = zeros(ExpandedNum, 1);
tic;
disp('Rearranging Q_s In Domain A:');
for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
    [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntQ_s          = zeros(48, 1);
    % rearrange (6, 8, 3) to (48, 3);
    tmp = zeros(8, 6);
    tmp = squeeze(Q_s(m, n, ell, :, :))';
    PntQ_s = tmp(:);
    Q_s_Vector( 48 * (idx - 1) + 1: 48 * idx ) = PntQ_s;
end
toc;

tic;
disp('Rearrangement of Q_s_B In Domain B: ');
BaseIdx = 48 * x_idx_max * y_idx_max * z_idx_max;
for idx = 1: 1: x_idx_max_B * y_idx_max_B * z_idx_max_B
    [ m, n, ell ] = getMNL(idx, x_idx_max_B, y_idx_max_B, z_idx_max_B);
    m_v = 2 * m - 1;
    n_v = 2 * n - 1;
    ell_v = 2 * ell - 1;

    PntQ_s          = zeros(48, 1);
    % rearrange (6, 8, 3) to (48, 3);
    tmp = zeros(8, 6);
    tmp = squeeze(Q_s_B(m, n, ell, :, :))';
    PntQ_s = tmp(:);
    Q_s_Vector( BaseIdx + 48 * (idx - 1) + 1: BaseIdx + 48 * idx ) = PntQ_s;
end
toc;

Q_s_Vector(~validTetTable) = [];

% return;
% === === === === === === === === % ================ % === === === === === === === === %
% === === === === === === === === % Temperature part % === === === === === === === === %
% === === === === === === === === % ================ % === === === === === === === === %
dt = 15; % 20 seconds
loadThermalParas_Esophagus;
Q_s_Vector_mod = Q_s_Vector;

disp('Checking bio and bolus related vetrices: ');
bioChecker_total = false(total_N_v, 1);
tic;
parfor vIdx = 1: 1: total_N_v
    Pnt_d = 0;
    CandiTet = find( MedTetTable_B(:, vIdx));
    for itr = 1: 1: length(CandiTet)
        % v is un-ordered vertices; while p is ordered vertices.
        % fix the problem in the determination of v1234 here .
        TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
        v1234 = TetRow(1: 4);
        if length(v1234) ~= 4
            error('check');
        end
        MedVal = TetRow(5);
        % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
        % this judgement below is based on the current test case
        % if MedVal == 5 
        if MedVal >= 3 && MedVal <= 9
            bioChecker_total(vIdx) = true;
            break;
        end
    end
end
toc;

m_U   = cell(total_N_v, 1);
m_V   = cell(total_N_v, 1);
bar_d = zeros(total_N_v, 1);
tic;
disp('The Filling Time of m_U, m_V and d in Finner Grid Coordinate: ');
% note for the boudary point, i.e., fillTop_A, fillBttm_A, fillRight_A, fillLeft_A, fillFront_A, fillBack_A
tic;
parfor vIdx = 1: 1: total_N_v
    if bioChecker_total(vIdx)
        % vFlag = 0, 1, 2 and 3 correspond to invalid AinB, valid A, valid A boundary and valid B, respectively.
        vFlag = VrtxValidFx(vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top );
        if ~vFlag % invalid AinB
            m_U{ vIdx } = [ vIdx, 1 ];
            m_V{ vIdx } = [ vIdx, 1 ];
        else % vFlag == 1 || vFlag == 2 || vFlag == 3 ( valid A || valid A boundary ||valid B )
            U_row = zeros(1, total_N_v);
            V_row = zeros(1, total_N_v);
            Pnt_d = 0;
            CandiTet = find( MedTetTable_B(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
                v1234 = TetRow(1: 4);
                if length(v1234) ~= 4
                    error('check');
                end
                MedVal = TetRow(5);
                % this judgement below is based on the current test case
                if MedTetTable_B( CandiTet(itr), v1234(1) ) ~= MedTetTable_B( CandiTet(itr), v1234(2) )
                    error('check');
                end
                if MedVal >= 3 && MedVal <= 9
                    p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx)));
                    [ U_row, V_row, Pnt_d ] = fillUVd_B( p1234, N_v, U_row, V_row, Pnt_d, ...
                                dt, Q_s_Vector_mod(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                                x_max_vertex, y_max_vertex, z_max_vertex, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, ...
                                w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                Vertex_Crdnt, Vertex_Crdnt_B, BndryTable, BndryTable_B, BM_bndryNum );
                end
            end
            m_U{vIdx} = Mrow2myRow(U_row);
            m_V{vIdx} = Mrow2myRow(V_row);
            bar_d(vIdx) = Pnt_d;
        end
    else
        m_U{vIdx} = [vIdx, 1];
        m_V{vIdx} = [vIdx, 1];
    end
end
toc;

M_U   = sparse(total_N_v, total_N_v);
M_V   = sparse(total_N_v, total_N_v);
tic;
disp('Transfroming M_U and M_V from my_sparse to Matlab sparse matrix')
M_U = mySparse2MatlabSparse( m_U, total_N_v, total_N_v, 'Row' );
M_V = mySparse2MatlabSparse( m_V, total_N_v, total_N_v, 'Row' );
toc;

bar_d = zeros(total_N_v, 1);
disp('The filling time d_m: ');
tic;
parfor vIdx = 1: 1: total_N_v
    Pnt_d = 0;
    if bioChecker_total(vIdx)
        if VrtxValidFx(vIdx, N_v, x_max_vertex, y_max_vertex, z_max_vertex, m_v_Lft, n_v_Near, ell_v_Dwn, m_v_Rght, n_v_Far, ell_v_Top );
        % if vFlag == 1 || vFlag == 3 % valid A || valid B )
            CandiTet = find( MedTetTable_B(:, vIdx));
            for itr = 1: 1: length(CandiTet)
                % v is un-ordered vertices; while p is ordered vertices.
                % fix the problem in the determination of v1234 here .
                TetRow = MedTetTableCell_AplusB{ CandiTet(itr) };
                v1234 = TetRow(1: 4);
                if length(v1234) ~= 4
                    error('check');
                end
                MedVal = TetRow(5);
                % MedVal = MedTetTable( CandiTet(itr), v1234(1) );
                % this judgement below is based on the current test case
                % if MedVal == 5 
                if MedVal >= 3 && MedVal <= 9
                    %               %  air,  bolus, muscle, lung, tumor, bone, fat
                    % Q_met          = [ 0,      0,   4200, 1700,  8000,  0,   5 ]';
                    if MedTetTable_B( CandiTet(itr), v1234(1) ) ~= MedTetTable_B( CandiTet(itr), v1234(2) )
                        error('check');
                    end
                    p1234 = horzcat( v1234(find(v1234 == vIdx)), v1234(find(v1234 ~= vIdx))); 
                    Pnt_d = filld_Fine( p1234, N_v, Pnt_d, ...
                                    dt, Q_s_Vector_mod(CandiTet(itr)) + Q_met(MedVal), rho(MedVal), xi(MedVal), zeta(MedVal), cap(MedVal), rho_b, cap_b, alpha, T_blood, T_bolus, ...
                                    x_max_vertex, y_max_vertex, z_max_vertex, x_max_vertex_B, y_max_vertex_B, z_max_vertex_B, ...
                                    w_x_B, w_y_B, w_z_B, dx, dy, dz, ...
                                    Vertex_Crdnt, Vertex_Crdnt_B, ...
                                    BndryTable, BndryTable_B, BM_bndryNum );
                end
            end
            bar_d(vIdx) = Pnt_d;
        end
    end
end
toc;

% === % ============================= % === %
% === % Initialization of Temperature % === %
% === % ============================= % === %
tic;
disp('Initialization of Temperature');
% from 0 to timeNum_all / dt
Ini_bar_b = zeros(total_N_v, 1);
% Ini_bar_b = T_air * ones(N_v, 1);
% The bolus-muscle bondary has temperature of muscle, while that on the air-bolus boundary has temperature of bolus.
timeNum_all = 30 * 60; % 30 minutes
bar_b = repmat(Ini_bar_b, 1, timeNum_all / dt + 1);
toc;

% === % ========================== % === %
% === % Calculation of Temperature % === %
% === % ========================== % === %
tol = 1e-6;
ext_itr_num = 5;
int_itr_num = 20;

flagX  = zeros(1, timeNum_all / dt + 1);
relres = zeros(1, timeNum_all / dt + 1);
tic;
for idx = 2: 1: size(bar_b, 2)
    [ bar_b(:, idx), flagX(idx), relres(idx) ] = gmres(M_U, M_V * bar_b(:, idx - 1) + bar_d, int_itr_num, tol, ext_itr_num );
    % bar_b(:, idx) = M_U\(M_V * bar_b(:, idx - 1) + bar_d);
end
toc;

% === % ==================== % === %
% === % Temperature Plotting % === %
% === % ==================== % === %
T_flagXZ = 1;
T_flagXY = 1;
T_flagYZ = 1;
% to-do
% implement the plotting function 
T_plot_Esophagus_Fine;
% save('0922EsophagusEQS_v2.mat');
return;
