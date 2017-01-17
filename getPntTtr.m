function SideTtrVol = getPntTtr( MidPntsCrdnt, p0Crdnt )

    SideTtrVol = zeros(1, 8);

    SideTtrVol(1) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(6, :), MidPntsCrdnt(9, :), p0Crdnt' );
    SideTtrVol(2) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(9, :), MidPntsCrdnt(8, :), p0Crdnt' );
    SideTtrVol(3) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(8, :), MidPntsCrdnt(7, :), p0Crdnt' );
    SideTtrVol(4) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(7, :), MidPntsCrdnt(4, :), p0Crdnt' );
    SideTtrVol(5) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(4, :), MidPntsCrdnt(1, :), p0Crdnt' );
    SideTtrVol(6) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(1, :), MidPntsCrdnt(2, :), p0Crdnt' );
    SideTtrVol(7) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(2, :), MidPntsCrdnt(3, :), p0Crdnt' );
    SideTtrVol(8) = calTtrVol( MidPntsCrdnt(5, :), MidPntsCrdnt(3, :), MidPntsCrdnt(6, :), p0Crdnt' );

end