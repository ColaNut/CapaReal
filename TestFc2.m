% === % ========================= % === %
% === % Tetrahedron test function % === %
% === % ========================= % === %

% plot for a surface
% case1:
% InnExtText = 'ext'
% P1_Crdt = [0, 0, 0];
% P2_Crdt = [1, 0, 0];
% P3_Crdt = [0, 1, 0];
% P4_Crdt = [0, 0, 1];

% case2:
InnExtText = 'inn'
P1_Crdt = [0, 0, 0];
P2_Crdt = [1, 0, 0];
P3_Crdt = [0, 0, 1];
P4_Crdt = [0, 1, 0];

nabla      = zeros(4, 3);
switch InnExtText
    case 'inn'
        nabla(1, :) = calTriVec( P2_Crdt, P3_Crdt, P4_Crdt );
        nabla(2, :) = calTriVec( P3_Crdt, P1_Crdt, P4_Crdt );
        nabla(3, :) = calTriVec( P4_Crdt, P1_Crdt, P2_Crdt );
        nabla(4, :) = calTriVec( P2_Crdt, P1_Crdt, P3_Crdt );
    case 'ext'
        nabla(1, :) = calTriVec( P2_Crdt, P4_Crdt, P3_Crdt );
        nabla(2, :) = calTriVec( P4_Crdt, P1_Crdt, P3_Crdt );
        nabla(3, :) = calTriVec( P4_Crdt, P2_Crdt, P1_Crdt );
        nabla(4, :) = calTriVec( P3_Crdt, P1_Crdt, P2_Crdt );
    otherwise
        error('check');
end

lambda = zeros(4, 4);
lambda = inv( vertcat( horzcat(P1_Crdt', P2_Crdt', P3_Crdt', P4_Crdt'), [1, 1, 1, 1] ) );

[x, y] = meshgrid(0:0.1:1,0:0.1:1);
u_1 = ( lambda(1, 1) * x + lambda(1, 2) * y + lambda(1, 4) ) * nabla(2, 1) ...
    - ( lambda(2, 1) * x + lambda(2, 2) * y + lambda(2, 4) ) * nabla(1, 1);
v_1 = ( lambda(1, 1) * x + lambda(1, 2) * y + lambda(1, 4) ) * nabla(2, 2) ...
    - ( lambda(2, 1) * x + lambda(2, 2) * y + lambda(2, 4) ) * nabla(1, 2);

u_2 = ( lambda(1, 1) * x + lambda(1, 2) * y + lambda(1, 4) ) * nabla(3, 1) ...
    - ( lambda(3, 1) * x + lambda(3, 2) * y + lambda(3, 4) ) * nabla(1, 1);
v_2 = ( lambda(3, 1) * x + lambda(3, 2) * y + lambda(3, 4) ) * nabla(3, 2) ...
    - ( lambda(1, 1) * x + lambda(1, 2) * y + lambda(1, 4) ) * nabla(1, 2);

u_3 = ( lambda(1, 1) * x + lambda(1, 2) * y + lambda(1, 4) ) * nabla(4, 1) ...
    - ( lambda(4, 1) * x + lambda(4, 2) * y + lambda(4, 4) ) * nabla(1, 1);
v_3 = ( lambda(4, 1) * x + lambda(4, 2) * y + lambda(4, 4) ) * nabla(4, 2) ...
    - ( lambda(1, 1) * x + lambda(1, 2) * y + lambda(1, 4) ) * nabla(1, 2);

u_4 = ( lambda(2, 1) * x + lambda(2, 2) * y + lambda(2, 4) ) * nabla(3, 1) ...
    - ( lambda(3, 1) * x + lambda(3, 2) * y + lambda(3, 4) ) * nabla(2, 1);
v_4 = ( lambda(2, 1) * x + lambda(2, 2) * y + lambda(2, 4) ) * nabla(3, 2) ...
    - ( lambda(3, 1) * x + lambda(3, 2) * y + lambda(3, 4) ) * nabla(2, 2);

u_5 = ( lambda(2, 1) * x + lambda(2, 2) * y + lambda(2, 4) ) * nabla(4, 1) ...
    - ( lambda(4, 1) * x + lambda(4, 2) * y + lambda(4, 4) ) * nabla(2, 1);
v_5 = ( lambda(2, 1) * x + lambda(2, 2) * y + lambda(2, 4) ) * nabla(4, 2) ...
    - ( lambda(4, 1) * x + lambda(4, 2) * y + lambda(4, 4) ) * nabla(2, 2);

u_6 = ( lambda(3, 1) * x + lambda(3, 2) * y + lambda(3, 4) ) * nabla(4, 1) ...
    - ( lambda(4, 1) * x + lambda(4, 2) * y + lambda(4, 4) ) * nabla(3, 1);
v_6 = ( lambda(4, 1) * x + lambda(4, 2) * y + lambda(4, 4) ) * nabla(4, 2) ...
    - ( lambda(3, 1) * x + lambda(3, 2) * y + lambda(3, 4) ) * nabla(3, 2);

for idx = 2: 1: 11
    u_1(13 - idx: 11, idx) = 0;
    v_1(13 - idx: 11, idx) = 0;
    u_2(13 - idx: 11, idx) = 0;
    v_2(13 - idx: 11, idx) = 0;
    u_3(13 - idx: 11, idx) = 0;
    v_3(13 - idx: 11, idx) = 0;
    u_4(13 - idx: 11, idx) = 0;
    v_4(13 - idx: 11, idx) = 0;
    u_5(13 - idx: 11, idx) = 0;
    v_5(13 - idx: 11, idx) = 0;
    u_6(13 - idx: 11, idx) = 0;
    v_6(13 - idx: 11, idx) = 0;
end


switch InnExtText
    case 'ext'
        figure(20);
        clf;
        hold on;
        quiver(x, y, u_1, v_1, 'b');
        quiver(x, y, u_2, v_2, 'k');
        quiver(x, y, u_4, v_4, 'r');
        fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0523TetReport';
        figure(21);
        clf;
        hold on;
        quiver(x, y, u_3, v_3, 'b');
        quiver(x, y, u_5, v_5, 'k');
        quiver(x, y, u_6, v_6, 'r');
        saveas(figure(20), fullfile(fname, 'ext124'), 'jpg');
        saveas(figure(21), fullfile(fname, 'ext356'), 'jpg');
    case 'inn'
        figure(20);
        clf;
        hold on;
        quiver(x, y, u_1, v_1, 'b');
        quiver(x, y, u_3, v_3, 'k');
        quiver(x, y, u_5, v_5, 'r');
        fname = 'D:\Kevin\GraduateSchool\Projects\ProjectBio\Simlation\CapaReal\0523TetReport';
        figure(21);
        clf;
        hold on;
        quiver(x, y, u_2, v_2, 'b');
        quiver(x, y, u_4, v_4, 'k');
        quiver(x, y, u_6, v_6, 'r');
        saveas(figure(20), fullfile(fname, 'inn135'), 'jpg');
        saveas(figure(21), fullfile(fname, 'inn246'), 'jpg');
    otherwise
        error('check');
end


% axis( [ 0, 1, 0, 1 ]);

% myDiffSet = find(edgeTable_check - logical(B_k));
% length(myDiffSet)
% length(find(B_k))

% norm( nrmlM_K * bar_x_my_gmres - B_k) / norm(B_k)
% AFigsScript
% AFigsScript;

% % ==== % =========== % ==== %
% % ==== % BORDER LINE % ==== %
% % ==== % =========== % ==== %

% % ==== % =========== % ==== %
% % ==== % BORDER LINE % ==== %
% % ==== % =========== % ==== %