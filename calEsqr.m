function [ Esqr ] = calEsqr( Crdnt1, Crdnt2, Crdnt3, Crdnt4, Phi1, Phi2, Phi3, Phi4 )

coeffVec = zeros(4, 1);

A = [ 1, Crdnt1; 
      1, Crdnt2;
      1, Crdnt3;
      1, Crdnt4' ];

B = [ Phi1, Phi2, Phi3, Phi4 ]';

coeffVec = A \ B;

Esqr = abs(coeffVec(2))^2 + abs(coeffVec(3))^2 + abs(coeffVec(4))^2;

end