function plotPntH( PntH, V9Crdnt, CrossText )

    EightRegion = zeros(8, 1);
    switch CrossText
      case 'XZ'
        V9Crdnt(:, 2) = [];
        PntHUni = [ PntH(4, 1), PntH(4, 2), PntH(4, 3), PntH(4, 4), PntH(5, 4), PntH(6, 1);
                    PntH(1, 1), PntH(1, 2), PntH(1, 7), PntH(1, 8), PntH(5, 3), PntH(6, 2); 
                    PntH(1, 3), PntH(1, 4), PntH(1, 5), PntH(1, 6), PntH(5, 2), PntH(6, 3); 
                    PntH(2, 1), PntH(2, 2), PntH(2, 3), PntH(2, 4), PntH(5, 1), PntH(6, 4); 
                    PntH(2, 5), PntH(2, 6), PntH(2, 7), PntH(2, 8), PntH(5, 8), PntH(6, 5); 
                    PntH(3, 1), PntH(3, 2), PntH(3, 7), PntH(3, 8), PntH(5, 7), PntH(6, 6); 
                    PntH(3, 3), PntH(3, 4), PntH(3, 5), PntH(3, 6), PntH(5, 6), PntH(6, 7); 
                    PntH(4, 5), PntH(4, 6), PntH(4, 7), PntH(4, 8), PntH(5, 5), PntH(6, 8) ];
      case 'XY'
        V9Crdnt(:, 3) = [];
        PntHUni = [ PntH(1, 1), PntH(3, 4), PntH(4, 1), PntH(4, 2), PntH(4, 7), PntH(4, 8);
                    PntH(1, 2), PntH(3, 3), PntH(5, 3), PntH(5, 4), PntH(5, 5), PntH(5, 6); 
                    PntH(1, 3), PntH(3, 2), PntH(5, 1), PntH(5, 2), PntH(5, 7), PntH(5, 8); 
                    PntH(1, 4), PntH(2, 3), PntH(2, 4), PntH(2, 5), PntH(2, 6), PntH(3, 1); 
                    PntH(1, 5), PntH(2, 1), PntH(2, 2), PntH(2, 7), PntH(2, 8), PntH(3, 8); 
                    PntH(1, 6), PntH(3, 7), PntH(6, 3), PntH(6, 4), PntH(6, 5), PntH(6, 6); 
                    PntH(1, 7), PntH(3, 6), PntH(6, 1), PntH(6, 2), PntH(6, 7), PntH(6, 8); 
                    PntH(1, 8), PntH(3, 5), PntH(4, 3), PntH(4, 4), PntH(4, 5), PntH(4, 6) ]; 
      case 'YZ'
        V9Crdnt(:, 1) = [];
        PntHUni = [ PntH(2, 4), PntH(4, 1), PntH(5, 1), PntH(5, 2), PntH(5, 3), PntH(5, 4);
                    PntH(1, 1), PntH(1, 2), PntH(1, 3), PntH(1, 4), PntH(2, 3), PntH(4, 2); 
                    PntH(1, 5), PntH(1, 6), PntH(1, 7), PntH(1, 8), PntH(2, 2), PntH(4, 3); 
                    PntH(2, 1), PntH(4, 4), PntH(6, 1), PntH(6, 2), PntH(6, 3), PntH(6, 4); 
                    PntH(2, 8), PntH(4, 5), PntH(6, 5), PntH(6, 6), PntH(6, 7), PntH(6, 8); 
                    PntH(2, 7), PntH(4, 6), PntH(3, 5), PntH(3, 6), PntH(3, 7), PntH(3, 8); 
                    PntH(2, 6), PntH(3, 1), PntH(3, 2), PntH(3, 3), PntH(3, 4), PntH(4, 7); 
                    PntH(2, 5), PntH(4, 8), PntH(5, 5), PntH(5, 6), PntH(5, 7), PntH(5, 8) ];
      otherwise
        ;
    end
    

    for idx = 1: 1: 8
        NonZeroIdx = find( PntHUni(idx, :) );
        if isempty( NonZeroIdx )
            EightRegion(idx) = 0;
        else
            EightRegion(idx) = sum(PntHUni(idx, :)) / 6;
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
    patch( 'Faces', f(find(EightRegion), :), 'Vertices', 100 * V9Crdnt, ...
    'FaceVertexCData', log10(EightRegion( find(EightRegion) )),'FaceColor','flat', 'EdgeColor','none');
end

end