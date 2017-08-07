function ABCDEF = getSqrCoeff( a_x, a_y, a_c )
% A * x^2 + B * x * y + C * y^2 + D * x + E * y + F = ( a_x x + a_y y + a_c )^2
ABCDEF = zeros(1, 6);
ABCDEF(1) = a_x^2;
ABCDEF(2) = 2 * a_x * a_y;
ABCDEF(3) = a_y^2;
ABCDEF(4) = 2 * a_x * a_c;
ABCDEF(5) = 2 * a_y * a_c;
ABCDEF(6) = a_c^2;

end