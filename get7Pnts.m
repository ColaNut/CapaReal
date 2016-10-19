function [ PntsCrdnt, PntsPhi ] = get7Pnts( m, ell, x_idx_max, z_idx_max, XZmidY_E, ThrXYZCrndt )

    PntsCrdnt    = zeros( 7, 3 );
    PntsPhi      = zeros( 7, 1 );

    PntsCrdnt( 1, : ) = ThrXYZCrndt( m    , 2, ell + 1, :);
    PntsCrdnt( 2, : ) = ThrXYZCrndt( m - 1, 2, ell    , :);
    PntsCrdnt( 3, : ) = ThrXYZCrndt( m    , 2, ell - 1, :);
    PntsCrdnt( 4, : ) = ThrXYZCrndt( m + 1, 2, ell    , :);
    PntsCrdnt( 5, : ) = ThrXYZCrndt( m    , 3, ell    , :);
    PntsCrdnt( 6, : ) = ThrXYZCrndt( m    , 1, ell    , :);
    PntsCrdnt( 7, : ) = ThrXYZCrndt( m    , 2, ell    , :);

    PntsPhi( 1, : ) = XZmidY_E( m    , 2, ell + 1);
    PntsPhi( 2, : ) = XZmidY_E( m - 1, 2, ell    );
    PntsPhi( 3, : ) = XZmidY_E( m    , 2, ell - 1);
    PntsPhi( 4, : ) = XZmidY_E( m + 1, 2, ell    );
    PntsPhi( 5, : ) = XZmidY_E( m    , 3, ell    );
    PntsPhi( 6, : ) = XZmidY_E( m    , 1, ell    );
    PntsPhi( 7, : ) = XZmidY_E( m    , 2, ell    );
    
end