function [ x0, y0, a, b, t ] = plotQuaEllipse( ABCDEF )
A = ABCDEF(1);
B = ABCDEF(2);
C = ABCDEF(3);
D = ABCDEF(4);
E = ABCDEF(5);
F = ABCDEF(6);
% A * x^2 + B * x * y + C * y^2 + D * x + E * y + F = 0
% e.g. A = 2; B = -4; C = 5; D = 0; E = 0; F = -36;

% get the point value from the below code.
% hand-calculate the value myself.  

e = 4 * A * C - B^2; 
if e <= 0, error('This conic is not an ellipse.'), end

x0 = ( B * E - 2 * C * D ) / e;
y0 = ( B * D - 2 * A * E ) / e;   % Ellipse center
F0 = - 2 * ( A * x0^2 + B * x0 * y0 + C * y0^2 + D * x0 + E * y0 + F );
g = sqrt( ( A - C )^2 + B^2 ); 
a = F0 / ( A + C + g ); 
b = F0 / ( A + C - g );
if ( a <= 0 ) | ( b <= 0 )
    t = 0;
    return
    % error('This is a degenerate ellipse.')
end
a = sqrt(a); 
b = sqrt(b); % Major & minor axes
t = 1 / 2 * atan2( B , A - C ); 
ct = cos(t); 
st = sin(t);   % Rotation angle
p = linspace( 0, 2 * pi, 500 ); 
cp = cos(p); 
sp = sin(p);   % Variable parameter
x = x0 + a * ct * cp - b * st * sp; 
y = y0 + a * st * cp + b * ct * sp;   % Generate points on ellipse

% plot( x, y, 'y.' ), axis equal   % Plot them