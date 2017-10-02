function SegMed = setBndrySegMed(SegMed, byndCD, x_idx_max, y_idx_max, z_idx_max)
    for idx = 1: 1: x_idx_max * y_idx_max * z_idx_max
        [ m, n, ell ] = getMNL(idx, x_idx_max, y_idx_max, z_idx_max);
        if ell == z_idx_max
            SegMed(m, n, ell, :, :) = trimUp( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
        end
        if ell == 1
            SegMed(m, n, ell, :, :) = trimDown( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
        end
        if m   == 1
            SegMed(m, n, ell, :, :) = trimLeft( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
        end
        if m   == x_idx_max
            SegMed(m, n, ell, :, :) = trimRight( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
        end
        if n   == y_idx_max
            SegMed(m, n, ell, :, :) = trimFar( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
        end
        if n   == 1
            SegMed(m, n, ell, :, :) = trimNear( squeeze( SegMed(m, n, ell, :, :) ), byndCD );
        end
    end
end