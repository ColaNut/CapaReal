function [ PntSigmaE, PntQ_s ] = calPntSigmaE( FaceCrdnt, p0Crdnt, PntSegMed, FacePhi, p0Phi, sigma, Epsilon )

PntSigmaE = zeros(1, 8, 3);
PntQ_s    = zeros(1, 8);
% The tetrahedron volume
E         = zeros(8, 3);
E_square  = zeros(8, 1);
SegSgm    = zeros(8, 1);

    [ E(1, :), E_square(1) ] = calE( FaceCrdnt(5, :)', FaceCrdnt(6, :)', FaceCrdnt(9, :)', p0Crdnt, ...
                    FacePhi(5), FacePhi(6), FacePhi(9), p0Phi );
    [ E(2, :), E_square(2) ] = calE( FaceCrdnt(5, :)', FaceCrdnt(9, :)', FaceCrdnt(8, :)', p0Crdnt, ...
                    FacePhi(5), FacePhi(9), FacePhi(8), p0Phi );
    [ E(3, :), E_square(3) ] = calE( FaceCrdnt(5, :)', FaceCrdnt(8, :)', FaceCrdnt(7, :)', p0Crdnt, ...
                    FacePhi(5), FacePhi(8), FacePhi(7), p0Phi );
    [ E(4, :), E_square(4) ] = calE( FaceCrdnt(5, :)', FaceCrdnt(7, :)', FaceCrdnt(4, :)', p0Crdnt, ...
                    FacePhi(5), FacePhi(7), FacePhi(4), p0Phi );
    [ E(5, :), E_square(5) ] = calE( FaceCrdnt(5, :)', FaceCrdnt(4, :)', FaceCrdnt(1, :)', p0Crdnt, ...
                    FacePhi(5), FacePhi(4), FacePhi(1), p0Phi );
    [ E(6, :), E_square(6) ] = calE( FaceCrdnt(5, :)', FaceCrdnt(1, :)', FaceCrdnt(2, :)', p0Crdnt, ...
                    FacePhi(5), FacePhi(1), FacePhi(2), p0Phi );
    [ E(7, :), E_square(7) ] = calE( FaceCrdnt(5, :)', FaceCrdnt(2, :)', FaceCrdnt(3, :)', p0Crdnt, ...
                    FacePhi(5), FacePhi(2), FacePhi(3), p0Phi );
    [ E(8, :), E_square(8) ] = calE( FaceCrdnt(5, :)', FaceCrdnt(3, :)', FaceCrdnt(6, :)', p0Crdnt, ...
                    FacePhi(5), FacePhi(3), FacePhi(6), p0Phi );

SegSgmMod = Epsilon(PntSegMed') + sigma(PntSegMed');
SegSgm    = sigma(PntSegMed');
% SegRho = rho(PntSegMed');

PntSigmaE = repmat(SegSgmMod, 1, 3) .* E;
PntQ_s    = ( SegSgm .* E_square ./ 2 )';

end