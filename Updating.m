function SARseg = Updating( m, n, ell, SARseg, Med9, medValue, InnOut )

    if strcmp(InnOut, 'inner')
        lineArr = [ Med9(1, 2), Med9(1, 1), Med9(2, 1), Med9(3, 1), Med9(3, 2), Med9(3, 3), Med9(2, 3), Med9(1, 3) ];
    elseif strcmp(InnOut, 'outer')
        lineArr = [ Med9(3, 2), Med9(3, 3), Med9(2, 3), Med9(1, 3), Med9(1, 2), Med9(1, 1), Med9(2, 1), Med9(3, 1) ];
    else
        error('check the flag');
    end

    Idx11 = find(lineArr == Med9(2, 2));

    if length(Idx11) ~= 2
        error('check');
    end
    if Idx11(end) == 8
        error('check rotations');
    end

    SARsegUni = [ SARseg(4, 1), SARseg(4, 2), SARseg(4, 3), SARseg(4, 4), SARseg(5, 4), SARseg(6, 1);
              SARseg(1, 1), SARseg(1, 2), SARseg(1, 7), SARseg(1, 8), SARseg(5, 3), SARseg(6, 2); 
              SARseg(1, 3), SARseg(1, 4), SARseg(1, 5), SARseg(1, 6), SARseg(5, 2), SARseg(6, 3); 
              SARseg(2, 1), SARseg(2, 2), SARseg(2, 3), SARseg(2, 4), SARseg(5, 1), SARseg(6, 4); 
              SARseg(2, 5), SARseg(2, 6), SARseg(2, 7), SARseg(2, 8), SARseg(5, 8), SARseg(6, 5); 
              SARseg(3, 1), SARseg(3, 2), SARseg(3, 7), SARseg(3, 8), SARseg(5, 7), SARseg(6, 6); 
              SARseg(3, 3), SARseg(3, 4), SARseg(3, 5), SARseg(3, 6), SARseg(5, 6), SARseg(6, 7); 
              SARseg(4, 5), SARseg(4, 6), SARseg(4, 7), SARseg(4, 8), SARseg(5, 5), SARseg(6, 8) ];

    for idx = Idx11(1): 1: Idx11(end) - 1
        if strcmp(InnOut, 'inner')
            idx = idx + 4;
        elseif strcmp(InnOut, 'outer')
            ;
        end
        if idx >= 9
            idx = idx - 8;
        end
        RibIdx = find(SARsegUni(idx, :) == 6);
        SARsegUni(idx, :) = medValue;
        SARsegUni(idx, RibIdx) = 6;
    end

    SARseg(4, 1) = SARsegUni(1, 1);   SARseg(1, 1) = SARsegUni(2, 1);   SARseg(1, 3) = SARsegUni(3, 1);
    SARseg(4, 2) = SARsegUni(1, 2);   SARseg(1, 2) = SARsegUni(2, 2);   SARseg(1, 4) = SARsegUni(3, 2);
    SARseg(4, 3) = SARsegUni(1, 3);   SARseg(1, 7) = SARsegUni(2, 3);   SARseg(1, 5) = SARsegUni(3, 3);
    SARseg(4, 4) = SARsegUni(1, 4);   SARseg(1, 8) = SARsegUni(2, 4);   SARseg(1, 6) = SARsegUni(3, 4);
    SARseg(5, 4) = SARsegUni(1, 5);   SARseg(5, 3) = SARsegUni(2, 5);   SARseg(5, 2) = SARsegUni(3, 5);
    SARseg(6, 1) = SARsegUni(1, 6);   SARseg(6, 2) = SARsegUni(2, 6);   SARseg(6, 3) = SARsegUni(3, 6);

    SARseg(2, 1) = SARsegUni(4, 1);   SARseg(2, 5) = SARsegUni(5, 1);   SARseg(3, 1) = SARsegUni(6, 1);
    SARseg(2, 2) = SARsegUni(4, 2);   SARseg(2, 6) = SARsegUni(5, 2);   SARseg(3, 2) = SARsegUni(6, 2);
    SARseg(2, 3) = SARsegUni(4, 3);   SARseg(2, 7) = SARsegUni(5, 3);   SARseg(3, 7) = SARsegUni(6, 3);
    SARseg(2, 4) = SARsegUni(4, 4);   SARseg(2, 8) = SARsegUni(5, 4);   SARseg(3, 8) = SARsegUni(6, 4);
    SARseg(5, 1) = SARsegUni(4, 5);   SARseg(5, 8) = SARsegUni(5, 5);   SARseg(5, 7) = SARsegUni(6, 5);
    SARseg(6, 4) = SARsegUni(4, 6);   SARseg(6, 5) = SARsegUni(5, 6);   SARseg(6, 6) = SARsegUni(6, 6);

    SARseg(3, 3) = SARsegUni(7, 1);   SARseg(4, 5) = SARsegUni(8, 1);
    SARseg(3, 4) = SARsegUni(7, 2);   SARseg(4, 6) = SARsegUni(8, 2);
    SARseg(3, 5) = SARsegUni(7, 3);   SARseg(4, 7) = SARsegUni(8, 3);
    SARseg(3, 6) = SARsegUni(7, 4);   SARseg(4, 8) = SARsegUni(8, 4);
    SARseg(5, 6) = SARsegUni(7, 5);   SARseg(5, 5) = SARsegUni(8, 5);
    SARseg(6, 7) = SARsegUni(7, 6);   SARseg(6, 8) = SARsegUni(8, 6);
end