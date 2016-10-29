function [ Esqr ] = calEsqrLS( Crdnt1, Crdnt2, Crdnt3, Crdnt4, Phi1, Phi2, Phi3, Phi4 )

% coeffVec = zeros(4, 1);
E = zeros(3, 1);

A = [ Crdnt1 - Crdnt2;
      Crdnt1 - Crdnt3; 
      Crdnt1 - Crdnt4'; 
      Crdnt2 - Crdnt3; 
      Crdnt2 - Crdnt4'; 
      Crdnt3 - Crdnt4' ];

B = [   Phi1 - Phi2; 
        Phi1 - Phi3; 
        Phi1 - Phi4; 
        Phi2 - Phi3; 
        Phi2 - Phi4; 
        Phi3 - Phi4 ];

E = A \ B;

Esqr = abs(E(1))^2 + abs(E(2))^2 + abs(E(3))^2;

end