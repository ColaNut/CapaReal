function plotSAR_Intrplt( SARseg, TtrVol, PntMidPnts9Crdnt, IntrpltPnts, CrossSecText, Tmprtr_flag, PntSegValue )
    
    EightRegion = zeros(8, 1);

    if strcmp(CrossSecText, 'XZ');
        SARsegUni = [ SARseg(4, 1), SARseg(4, 2), SARseg(4, 3), SARseg(4, 4), SARseg(5, 4), SARseg(6, 1);
                      SARseg(1, 1), SARseg(1, 2), SARseg(1, 7), SARseg(1, 8), SARseg(5, 3), SARseg(6, 2); 
                      SARseg(1, 3), SARseg(1, 4), SARseg(1, 5), SARseg(1, 6), SARseg(5, 2), SARseg(6, 3); 
                      SARseg(2, 1), SARseg(2, 2), SARseg(2, 3), SARseg(2, 4), SARseg(5, 1), SARseg(6, 4); 
                      SARseg(2, 5), SARseg(2, 6), SARseg(2, 7), SARseg(2, 8), SARseg(5, 8), SARseg(6, 5); 
                      SARseg(3, 1), SARseg(3, 2), SARseg(3, 7), SARseg(3, 8), SARseg(5, 7), SARseg(6, 6); 
                      SARseg(3, 3), SARseg(3, 4), SARseg(3, 5), SARseg(3, 6), SARseg(5, 6), SARseg(6, 7); 
                      SARseg(4, 5), SARseg(4, 6), SARseg(4, 7), SARseg(4, 8), SARseg(5, 5), SARseg(6, 8) ];

        TtrVolUni = [ TtrVol(4, 1), TtrVol(4, 2), TtrVol(4, 3), TtrVol(4, 4), TtrVol(5, 4), TtrVol(6, 1);
                      TtrVol(1, 1), TtrVol(1, 2), TtrVol(1, 7), TtrVol(1, 8), TtrVol(5, 3), TtrVol(6, 2); 
                      TtrVol(1, 3), TtrVol(1, 4), TtrVol(1, 5), TtrVol(1, 6), TtrVol(5, 2), TtrVol(6, 3); 
                      TtrVol(2, 1), TtrVol(2, 2), TtrVol(2, 3), TtrVol(2, 4), TtrVol(5, 1), TtrVol(6, 4); 
                      TtrVol(2, 5), TtrVol(2, 6), TtrVol(2, 7), TtrVol(2, 8), TtrVol(5, 8), TtrVol(6, 5); 
                      TtrVol(3, 1), TtrVol(3, 2), TtrVol(3, 7), TtrVol(3, 8), TtrVol(5, 7), TtrVol(6, 6); 
                      TtrVol(3, 3), TtrVol(3, 4), TtrVol(3, 5), TtrVol(3, 6), TtrVol(5, 6), TtrVol(6, 7); 
                      TtrVol(4, 5), TtrVol(4, 6), TtrVol(4, 7), TtrVol(4, 8), TtrVol(5, 5), TtrVol(6, 8) ];

    elseif strcmp(CrossSecText, 'XY');
        SARsegUni = [ SARseg(1, 1), SARseg(3, 4), SARseg(4, 1), SARseg(4, 2), SARseg(4, 7), SARseg(4, 8);
                      SARseg(1, 2), SARseg(3, 3), SARseg(5, 3), SARseg(5, 4), SARseg(5, 5), SARseg(5, 6); 
                      SARseg(1, 3), SARseg(3, 2), SARseg(5, 1), SARseg(5, 2), SARseg(5, 7), SARseg(5, 8); 
                      SARseg(1, 4), SARseg(2, 3), SARseg(2, 4), SARseg(2, 5), SARseg(2, 6), SARseg(3, 1); 
                      SARseg(1, 5), SARseg(2, 1), SARseg(2, 2), SARseg(2, 7), SARseg(2, 8), SARseg(3, 8); 
                      SARseg(1, 6), SARseg(3, 7), SARseg(6, 3), SARseg(6, 4), SARseg(6, 5), SARseg(6, 6); 
                      SARseg(1, 7), SARseg(3, 6), SARseg(6, 1), SARseg(6, 2), SARseg(6, 7), SARseg(6, 8); 
                      SARseg(1, 8), SARseg(3, 5), SARseg(4, 3), SARseg(4, 4), SARseg(4, 5), SARseg(4, 6) ]; 

        TtrVolUni = [ TtrVol(1, 1), TtrVol(3, 4), TtrVol(4, 1), TtrVol(4, 2), TtrVol(4, 7), TtrVol(4, 8);
                      TtrVol(1, 2), TtrVol(3, 3), TtrVol(5, 3), TtrVol(5, 4), TtrVol(5, 5), TtrVol(5, 6); 
                      TtrVol(1, 3), TtrVol(3, 2), TtrVol(5, 1), TtrVol(5, 2), TtrVol(5, 7), TtrVol(5, 8); 
                      TtrVol(1, 4), TtrVol(2, 3), TtrVol(2, 4), TtrVol(2, 5), TtrVol(2, 6), TtrVol(3, 1); 
                      TtrVol(1, 5), TtrVol(2, 1), TtrVol(2, 2), TtrVol(2, 7), TtrVol(2, 8), TtrVol(3, 8); 
                      TtrVol(1, 6), TtrVol(3, 7), TtrVol(6, 3), TtrVol(6, 4), TtrVol(6, 5), TtrVol(6, 6); 
                      TtrVol(1, 7), TtrVol(3, 6), TtrVol(6, 1), TtrVol(6, 2), TtrVol(6, 7), TtrVol(6, 8); 
                      TtrVol(1, 8), TtrVol(3, 5), TtrVol(4, 3), TtrVol(4, 4), TtrVol(4, 5), TtrVol(4, 6) ]; 
    elseif strcmp(CrossSecText, 'YZ');
        SARsegUni = [ SARseg(2, 4), SARseg(4, 1), SARseg(5, 1), SARseg(5, 2), SARseg(5, 3), SARseg(5, 4);
                  SARseg(1, 1), SARseg(1, 2), SARseg(1, 3), SARseg(1, 4), SARseg(2, 3), SARseg(4, 2); 
                  SARseg(1, 5), SARseg(1, 6), SARseg(1, 7), SARseg(1, 8), SARseg(2, 2), SARseg(4, 3); 
                  SARseg(2, 1), SARseg(4, 4), SARseg(6, 1), SARseg(6, 2), SARseg(6, 3), SARseg(6, 4); 
                  SARseg(2, 8), SARseg(4, 5), SARseg(6, 5), SARseg(6, 6), SARseg(6, 7), SARseg(6, 8); 
                  SARseg(2, 7), SARseg(4, 6), SARseg(3, 5), SARseg(3, 6), SARseg(3, 7), SARseg(3, 8); 
                  SARseg(2, 6), SARseg(3, 1), SARseg(3, 2), SARseg(3, 3), SARseg(3, 4), SARseg(4, 7); 
                  SARseg(2, 5), SARseg(4, 8), SARseg(5, 5), SARseg(5, 6), SARseg(5, 7), SARseg(5, 8) ];

        TtrVolUni = [ TtrVol(2, 4), TtrVol(4, 1), TtrVol(5, 1), TtrVol(5, 2), TtrVol(5, 3), TtrVol(5, 4);
                      TtrVol(1, 1), TtrVol(1, 2), TtrVol(1, 3), TtrVol(1, 4), TtrVol(2, 3), TtrVol(4, 2); 
                      TtrVol(1, 5), TtrVol(1, 6), TtrVol(1, 7), TtrVol(1, 8), TtrVol(2, 2), TtrVol(4, 3); 
                      TtrVol(2, 1), TtrVol(4, 4), TtrVol(6, 1), TtrVol(6, 2), TtrVol(6, 3), TtrVol(6, 4); 
                      TtrVol(2, 8), TtrVol(4, 5), TtrVol(6, 5), TtrVol(6, 6), TtrVol(6, 7), TtrVol(6, 8); 
                      TtrVol(2, 7), TtrVol(4, 6), TtrVol(3, 5), TtrVol(3, 6), TtrVol(3, 7), TtrVol(3, 8); 
                      TtrVol(2, 6), TtrVol(3, 1), TtrVol(3, 2), TtrVol(3, 3), TtrVol(3, 4), TtrVol(4, 7); 
                      TtrVol(2, 5), TtrVol(4, 8), TtrVol(5, 5), TtrVol(5, 6), TtrVol(5, 7), TtrVol(5, 8) ];
    else
        error('check CrossSecText');
    end

    for idx = 1: 1: 8
        TrtIdx = TtrVolUni(idx, :);
        NonZeroIdx = find( SARsegUni(idx, :) );
        if isempty( NonZeroIdx )
            EightRegion(idx) = 0;
        else
            EightRegion(idx) = ( SARsegUni(idx, :) * TrtIdx' ) / ( sum( TrtIdx( NonZeroIdx ) ) );
        end
    end

if ~isempty(find(EightRegion))  
    f = [ 5 6 9;
          5 9 8;
          5 8 7;
          5 7 4;
          5 4 1;
          5 1 2;
          5 2 3;
          5 3 6 ];

    if Tmprtr_flag
        % PntSegUni = [ PntSegValue(4, 1), PntSegValue(4, 2), PntSegValue(4, 3), PntSegValue(4, 4), PntSegValue(5, 4), PntSegValue(6, 1);
        %               PntSegValue(1, 1), PntSegValue(1, 2), PntSegValue(1, 7), PntSegValue(1, 8), PntSegValue(5, 3), PntSegValue(6, 2); 
        %               PntSegValue(1, 3), PntSegValue(1, 4), PntSegValue(1, 5), PntSegValue(1, 6), PntSegValue(5, 2), PntSegValue(6, 3); 
        %               PntSegValue(2, 1), PntSegValue(2, 2), PntSegValue(2, 3), PntSegValue(2, 4), PntSegValue(5, 1), PntSegValue(6, 4); 
        %               PntSegValue(2, 5), PntSegValue(2, 6), PntSegValue(2, 7), PntSegValue(2, 8), PntSegValue(5, 8), PntSegValue(6, 5); 
        %               PntSegValue(3, 1), PntSegValue(3, 2), PntSegValue(3, 7), PntSegValue(3, 8), PntSegValue(5, 7), PntSegValue(6, 6); 
        %               PntSegValue(3, 3), PntSegValue(3, 4), PntSegValue(3, 5), PntSegValue(3, 6), PntSegValue(5, 6), PntSegValue(6, 7); 
        %               PntSegValue(4, 5), PntSegValue(4, 6), PntSegValue(4, 7), PntSegValue(4, 8), PntSegValue(5, 5), PntSegValue(6, 8) ];

        % Pnt9SegValue = get9Seg(PntSegUni);
      patch( 'Faces', f(find(EightRegion), :), 'Vertices', 100 * PntMidPnts9Crdnt, ...
      'FaceVertexCData', IntrpltPnts,'FaceColor','interp', 'EdgeColor','none');

      % IntrpltPnts()
      % patch( 'Faces', f(find(Pnt9SegValue == 2), :), 'Vertices', 100 * PntMidPnts9Crdnt, ...
      % 'FaceVertexCData', IntrpltPnts,'FaceColor','interp', 'EdgeColor','none');
      
    else
      patch( 'Faces', f(find(EightRegion), :), 'Vertices', 100 * PntMidPnts9Crdnt, ...
        'FaceVertexCData', log10( IntrpltPnts ),'FaceColor','interp', 'EdgeColor','none');
    end
    
end

end