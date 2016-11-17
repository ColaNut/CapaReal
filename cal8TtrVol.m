function TtrVol = cal8TtrVol( MidPntsCrdnt, p0Crdnt )

    % The tetrahedron volume
    TtrVol    = zeros(1, 8);

    TtrVol(1) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(6, :), MidPntsCrdnt(9, :), p0Crdnt' );
    TtrVol(2) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(9, :), MidPntsCrdnt(8, :), p0Crdnt' );
    TtrVol(3) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(8, :), MidPntsCrdnt(7, :), p0Crdnt' );
    TtrVol(4) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(7, :), MidPntsCrdnt(4, :), p0Crdnt' );
    TtrVol(5) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(4, :), MidPntsCrdnt(1, :), p0Crdnt' );
    TtrVol(6) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(1, :), MidPntsCrdnt(2, :), p0Crdnt' );
    TtrVol(7) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(2, :), MidPntsCrdnt(3, :), p0Crdnt' );
    TtrVol(8) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(3, :), MidPntsCrdnt(6, :), p0Crdnt' );

end