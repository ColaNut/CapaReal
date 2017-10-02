function [ mediumTableXZ ] = getRoughMed_Eso_B( mediumTableXZ, y_idx, w_x_B, w_y_B, w_z_B, dx_B, dy_B, dz_B )

loadParas_Eso0924;

% fill in air of esophgus
mediumTableXZ = medFill_Eso( mediumTableXZ, es_x, es_z, es_r, es_r, dx_B, dz_B, 1, w_x_B, w_z_B );

tumor_y_idx_far  = (tumor_y_es + tumor_hy_es / 2) / dy_B + w_x_B / (2 * dy_B) + 1;
tumor_y_idx_near = (tumor_y_es - tumor_hy_es / 2) / dy_B + w_x_B / (2 * dy_B) + 1;
if y_idx <= tumor_y_idx_far && y_idx >= tumor_y_idx_near
    % fill in esophgeal tumor 
    mediumTableXZ = medFill_Eso( mediumTableXZ, tumor_x_es, tumor_z_es, tumor_r_es, tumor_r_es, dx_B, dz_B, 9, w_x_B, w_z_B );
    % fill in bolus of endoscopy
    mediumTableXZ = medFill_Eso( mediumTableXZ, endo_x, endo_z, endo_r, endo_r, dx_B, dz_B, 2, w_x_B, w_z_B );
end

end