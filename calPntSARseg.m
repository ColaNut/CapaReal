function [ PntSARseg, TtrVol, Pnt_absE ] = calPntSARseg( MidPntsCrdnt, p0Crdnt, PntSegValue, MidPntsPhi, p0Phi, sigma, rho )

PntSARseg = zeros(1, 8);
Pnt_absE  = zeros(1, 8);
% The tetrahedron volume
TtrVol    = zeros(1, 8);
Esqr      = zeros(8, 1);
SegSgm    = zeros(8, 1);
SegRho    = zeros(8, 1);

    TtrVol(1) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(6, :), MidPntsCrdnt(9, :), p0Crdnt' );
    TtrVol(2) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(9, :), MidPntsCrdnt(8, :), p0Crdnt' );
    TtrVol(3) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(8, :), MidPntsCrdnt(7, :), p0Crdnt' );
    TtrVol(4) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(7, :), MidPntsCrdnt(4, :), p0Crdnt' );
    TtrVol(5) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(4, :), MidPntsCrdnt(1, :), p0Crdnt' );
    TtrVol(6) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(1, :), MidPntsCrdnt(2, :), p0Crdnt' );
    TtrVol(7) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(2, :), MidPntsCrdnt(3, :), p0Crdnt' );
    TtrVol(8) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(3, :), MidPntsCrdnt(6, :), p0Crdnt' );

    Esqr(1) = calEsqr( MidPntsCrdnt(5, :), MidPntsCrdnt(6, :), MidPntsCrdnt(9, :), p0Crdnt, ...
                    MidPntsPhi(5), MidPntsPhi(6), MidPntsPhi(9), p0Phi );
    Esqr(2) = calEsqr( MidPntsCrdnt(5, :), MidPntsCrdnt(9, :), MidPntsCrdnt(8, :), p0Crdnt, ...
                    MidPntsPhi(5), MidPntsPhi(9), MidPntsPhi(8), p0Phi );
    Esqr(3) = calEsqr( MidPntsCrdnt(5, :), MidPntsCrdnt(8, :), MidPntsCrdnt(7, :), p0Crdnt, ...
                    MidPntsPhi(5), MidPntsPhi(8), MidPntsPhi(7), p0Phi );
    Esqr(4) = calEsqr( MidPntsCrdnt(5, :), MidPntsCrdnt(7, :), MidPntsCrdnt(4, :), p0Crdnt, ...
                    MidPntsPhi(5), MidPntsPhi(7), MidPntsPhi(4), p0Phi );
    Esqr(5) = calEsqr( MidPntsCrdnt(5, :), MidPntsCrdnt(4, :), MidPntsCrdnt(1, :), p0Crdnt, ...
                    MidPntsPhi(5), MidPntsPhi(4), MidPntsPhi(1), p0Phi );
    Esqr(6) = calEsqr( MidPntsCrdnt(5, :), MidPntsCrdnt(1, :), MidPntsCrdnt(2, :), p0Crdnt, ...
                    MidPntsPhi(5), MidPntsPhi(1), MidPntsPhi(2), p0Phi );
    Esqr(7) = calEsqr( MidPntsCrdnt(5, :), MidPntsCrdnt(2, :), MidPntsCrdnt(3, :), p0Crdnt, ...
                    MidPntsPhi(5), MidPntsPhi(2), MidPntsPhi(3), p0Phi );
    Esqr(8) = calEsqr( MidPntsCrdnt(5, :), MidPntsCrdnt(3, :), MidPntsCrdnt(6, :), p0Crdnt, ...
                    MidPntsPhi(5), MidPntsPhi(3), MidPntsPhi(6), p0Phi );

SegSgm = sigma(PntSegValue);
SegRho = rho(PntSegValue);

PntSARseg = (SegSgm .* Esqr) ./ (2 * SegRho);
Pnt_absE = sqrt(Esqr);

end