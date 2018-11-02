function PntsCrdnt = getImag27Pnts
    PntsCrdnt   = zeros( 3, 9, 3 ); 

    for x_idx = 1: 1: 3
        for y_idx = 1: 1: 3
            for z_idx = 1: 1: 3
                if ~isempty(GridShiftTable{ x_idx, y_idx, z_idx })
                    table_value = GridShiftTable{ x_idx, y_idx, z_idx };
                    if table_value(1) == 1
                        shiftedCoordinate( x_idx, y_idx, z_idx, 1 ) = shiftedCoordinate( x_idx, y_idx, z_idx, 1 ) + table_value(2);
                    elseif table_value(1) == 2
                        shiftedCoordinate( x_idx, y_idx, z_idx, 3 ) = shiftedCoordinate( x_idx, y_idx, z_idx, 3 ) + table_value(2);
                    elseif table_value(1) == 3
                        shiftedCoordinate( x_idx, y_idx, z_idx, 2 ) = shiftedCoordinate( x_idx, y_idx, z_idx, 2 ) + table_value(2);
                    else
                        error('invalid direction');
                    end
                end
            end
        end
    end

    PntsCrdnt(1, 1, )
end