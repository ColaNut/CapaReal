function [ Ex, Ey, Ez ] = calE( XZmidY_E, ThrXYZCrndt, dx, dy, dz, x_idx_max, z_idx_max )

XZmidY = squeeze(XZmidY_E(:, 2, :));
minusEx = zeros(size(XZmidY));
minusEy = zeros(size(XZmidY));
minusEz = zeros(size(XZmidY));

for idx = 1: 1: x_idx_max * z_idx_max
    % idx = ( ell - 1 ) * x_idx_max + m;
    tmp_m = mod( idx, x_idx_max );
    if tmp_m == 0
        m = x_idx_max;
    else
        m = tmp_m;
    end

    ell = int64( ( idx - m ) / x_idx_max + 1 );
    
    p0 = idx;

    if m >= 2 && m <= x_idx_max - 1 && ell >= 2 && ell <= z_idx_max - 1 
        PntsCrdnt = zeros( 7, 3 );
        oblqValue = zeros( 6, 1 );
        cosWeight = zeros( 6, 3 );
        [ PntsCrdnt, PntsPhi ] = get7Pnts( m, ell, x_idx_max, z_idx_max, XZmidY_E, ThrXYZCrndt );
        
        oblqValue(1) = calOblqValue( squeeze(PntsCrdnt(1, :)), squeeze(PntsCrdnt(7, :)), PntsPhi(1), PntsPhi(7) );
        oblqValue(2) = calOblqValue( squeeze(PntsCrdnt(7, :)), squeeze(PntsCrdnt(2, :)), PntsPhi(7), PntsPhi(2) );
        oblqValue(3) = calOblqValue( squeeze(PntsCrdnt(7, :)), squeeze(PntsCrdnt(3, :)), PntsPhi(7), PntsPhi(3) );
        oblqValue(4) = calOblqValue( squeeze(PntsCrdnt(4, :)), squeeze(PntsCrdnt(7, :)), PntsPhi(4), PntsPhi(7) );
        oblqValue(5) = calOblqValue( squeeze(PntsCrdnt(5, :)), squeeze(PntsCrdnt(7, :)), PntsPhi(5), PntsPhi(7) );
        oblqValue(6) = calOblqValue( squeeze(PntsCrdnt(7, :)), squeeze(PntsCrdnt(6, :)), PntsPhi(7), PntsPhi(6) );

        cosWeight(1, :) = calCos( squeeze( PntsCrdnt(1, :) - PntsCrdnt(7, :) ) );
        cosWeight(2, :) = calCos( squeeze( PntsCrdnt(7, :) - PntsCrdnt(2, :) ) );
        cosWeight(3, :) = calCos( squeeze( PntsCrdnt(7, :) - PntsCrdnt(3, :) ) );
        cosWeight(4, :) = calCos( squeeze( PntsCrdnt(4, :) - PntsCrdnt(7, :) ) );
        cosWeight(5, :) = calCos( squeeze( PntsCrdnt(5, :) - PntsCrdnt(7, :) ) );
        cosWeight(6, :) = calCos( squeeze( PntsCrdnt(7, :) - PntsCrdnt(6, :) ) );

        minusEx(m, ell) = sum( oblqValue .* cosWeight(:, 1) ) / 2;
        minusEy(m, ell) = sum( oblqValue .* cosWeight(:, 2) ) / 2;
        minusEz(m, ell) = sum( oblqValue .* cosWeight(:, 3) ) / 2;
    end

% E_x = - \frac{\partial \Phi}{\partial x}
Ex = - minusEx';
Ey = - minusEy';
Ez = - minusEz';

end