function plotPntH_Reg( PntH, V9Crdnt, CrossText )
% plotPntH_Reg( squeeze(H_XZ(m - 1, ell - 1, :, dirFlag)), MidPnts9Crdnt, 'XZ' );
% PntH = zeros(8, 1);
    FourRegion = zeros(4, 1);
    % PntHUni = zeros(4, 2);
    switch CrossText
      case 'XZ'
        V9Crdnt(:, 2) = [];
        PntHUni = [ PntH(1), PntH(5);
                    PntH(2), PntH(6);
                    PntH(3), PntH(7);
                    PntH(4), PntH(8) ];
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
    

    for idx = 1: 1: 4
        NonZeroIdx = find( PntHUni(idx, :) );
        if isempty( NonZeroIdx )
            FourRegion(idx) = 0;
        else
            FourRegion(idx) = sum(PntHUni(idx, :)) / 2;
        end
    end

if ~isempty(find(FourRegion))  
    f = [ 5 9 3;
          5 7 9;
          5 1 7;
          5 3 1 ];
    patch( 'Faces', f(find(FourRegion), :), 'Vertices', 100 * V9Crdnt, ...
    'FaceVertexCData', FourRegion( find(FourRegion) ),'FaceColor','flat', 'EdgeColor','none');
end

end