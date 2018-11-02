function valid = is_sub_electrode_ROI( Crdnt )
    valid = false;
    loadParas;
    % inside the outer ellipse 
    if Crdnt(1)^2 / ( skin_a + 0.6 / 100 )^2 + Crdnt(3)^2 / ( skin_c + 0.6 / 100 )^2 - 1 <= 0
        % outside the inner ellipse
        if Crdnt(1)^2 / ( skin_a - 0.5 / 100 )^2 + Crdnt(3)^2 / ( skin_c - 0.5 / 100 )^2 - 1 >= 0
            valid = true;
        end
    end
end