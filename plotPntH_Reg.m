function plotPntH_Reg( PntH, V9Crdnt, CrossText )
% plotPntH_Reg( squeeze(H_XZ(m - 1, ell - 1, :, dirFlag)), MidPnts9Crdnt, 'XZ' );
% PntH = zeros(8, 1);
    FourRegion = zeros(4, 1);
    % PntHUni = zeros(4, 2);
    PntHUni = [ PntH(1), PntH(5);
                PntH(2), PntH(6);
                PntH(3), PntH(7);
                PntH(4), PntH(8) ];
    switch CrossText
      case 'XZ'
        V9Crdnt(:, 2) = [];
      case 'XY'
        V9Crdnt(:, 3) = [];
      case 'YZ'
        V9Crdnt(:, 1) = [];
      otherwise
        error('check');
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