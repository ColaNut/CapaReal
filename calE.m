function [ E_field, E_square ] = calE( Crdnt1, Crdnt2, Crdnt3, Crdnt4, Phi1, Phi2, Phi3, Phi4 )

coeffVec = zeros(4, 1);

% choose two out of four to be [ 0, 0, 0 ]; 
if length( find( [ isequal(Crdnt1, [0, 0, 0]'), isequal(Crdnt2, [0, 0, 0]'), isequal(Crdnt3, [0, 0, 0]'), isequal(Crdnt4, [0, 0, 0]') ] ) ) >= 2
    E_field = [ 0, 0, 0 ];
    E_square = 0;
    return;
end

A = [ 1, Crdnt1'; 
      1, Crdnt2';
      1, Crdnt3';
      1, Crdnt4' ];

B = [ Phi1, Phi2, Phi3, Phi4 ]';

coeffVec = A \ B;

E_field = [ - coeffVec(2), - coeffVec(3), - coeffVec(4) ];
E_square = norm( [ coeffVec(2), coeffVec(3), coeffVec(4) ] )^2;

end