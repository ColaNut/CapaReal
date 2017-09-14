function plotEllipse_liverXY( x1, z1, x2, z2, b, dx, dz )

a = 1 / 2 * sqrt( (x2 - x1)^2 + (z2 - z1)^2 );
% b = a * sqrt( 1 - e^2 );

t = linspace( - pi / 2 - 0.3, pi / 2 );
X = a * cos(t);
Z = b * sin(t);
w = atan2( z2 - z1, x2 - x1 );
x = ( x1 + x2 ) / 2 + X * cos(w) - Z * sin(w);
z = ( z1 + z2 ) / 2 + X * sin(w) + Z * cos(w);
plot(x, z, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 2.5);
% axis equal;
hold on;

% x_grid = - myCeil(a, dx): dx: myCeil(a, dx);
% z_grid = - myCeil(b, dz): dz: myCeil(b, dz);

% [ X_grid, Z_grid ] = meshgrid(x_grid, z_grid);
% for idx = 1: 1: size(Z_grid, 1)
%     scatter( x_grid, Z_grid(idx, :) );
%     hold on;
% end

end