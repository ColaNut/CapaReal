function plot3YZ( siftedCoordinateXYZ, x, h_torso, air_x, air_z, dx, dy, dz )

x_idx = x / dx + air_x / (2 * dx) + 1;

for z_idx = 1: 1: air_z / dz + 1
    scatter3( 100 * siftedCoordinateXYZ( x_idx, :, z_idx, 1 ), 100 * siftedCoordinateXYZ( x_idx, :, z_idx, 2 ), ...
        100 * siftedCoordinateXYZ( x_idx, :, z_idx, 3 ), 10, 'k', 'filled' );
    plot3( 100 * siftedCoordinateXYZ( x_idx, :, z_idx, 1 ), 100 * siftedCoordinateXYZ( x_idx, :, z_idx, 2 ), ...
        100 * siftedCoordinateXYZ( x_idx, :, z_idx, 3 ), 'k', 'LineWidth', 0.5 );
    set(gca,'fontsize',30);
    axis( [ - 100 * air_x / 2, 100 * air_x / 2, - 100 * h_torso / 2, 100 * h_torso / 2, ...
            - 100 * air_z / 2, 100 * air_z / 2 ] );
    xlabel('$x$ (cm)', 'Interpreter','LaTex', 'FontSize', 30);
    ylabel('$y$ (cm)','Interpreter','LaTex', 'FontSize', 30);
    zlabel('$z$ (cm)','Interpreter','LaTex', 'FontSize', 30);
    hold on;
end

% for ext_idx = 1: 1: len_sc
%     y = - h_torso / 2 + (ext_idx - 1) * dy;
%     shiftedCoordinateXZ = shiftedCoordinate{ext_idx};
%     for idx = 1: 1: size(shiftedCoordinateXZ, 2)
%         scatter3( shiftedCoordinateXZ(:, idx, 1 ), shiftedCoordinateXZ(:, idx, 2 ), ...
%             ones(size(shiftedCoordinateXZ(:, idx, 1))) * y, 10, 'k', 'filled' );
%         plot3( shiftedCoordinateXZ(:, idx, 1 ), shiftedCoordinateXZ(:, idx, 2 ), ...
%             ones(size(shiftedCoordinateXZ(:, idx, 1))) * y, 'k', 'LineWidth', 0.5 );
%         hold on;
%     end

%     for idx = 1: 1: size(shiftedCoordinateXZ, 1)
%         plot3( shiftedCoordinateXZ(idx, :, 1 ), shiftedCoordinateXZ(idx, :, 2 ), ...
%             ones(size(shiftedCoordinateXZ(idx, :, 1))) * y, 'k', 'LineWidth', 0.5 );
%         hold on;
%     end
% end

end