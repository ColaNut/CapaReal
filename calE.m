function [ E_field ] = calE( Crdnt1, Crdnt2, Crdnt3, Crdnt4, Phi1, Phi2, Phi3, Phi4 )

coeffVec = zeros(4, 1);

A = [ 1, Crdnt1'; 
      1, Crdnt2';
      1, Crdnt3';
      1, Crdnt4' ];

B = [ Phi1, Phi2, Phi3, Phi4 ]';

coeffVec = A \ B;

E_field = [ - coeffVec(2), - coeffVec(3), - coeffVec(4) ];

end