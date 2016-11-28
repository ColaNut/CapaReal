function [ pre_I_seg ] = cal_I_oblique_up( p_18MidCrdnt, p_18Phi )
    
    pre_I_seg = 0;
    E_field = zeros(4, 3);
    TriVec  = zeros(4, 3);

    E_field(1, :) = calE( squeeze( p_18MidCrdnt(1, 4, :) ), squeeze( p_18MidCrdnt(1, 7, :) ), ...
                            squeeze( p_18MidCrdnt(2, 4, :) ), squeeze( p_18MidCrdnt(2, 5, :) ), ...
                            p_18Phi(1, 4, :), p_18Phi(1, 7, :), p_18Phi(2, 4, :), p_18Phi(2, 5, :) );
    E_field(2, :) = calE( squeeze( p_18MidCrdnt(1, 5, :) ), squeeze( p_18MidCrdnt(1, 7, :) ), ...
                            squeeze( p_18MidCrdnt(1, 8, :) ), squeeze( p_18MidCrdnt(2, 5, :) ), ...
                            p_18Phi(1, 5, :), p_18Phi(1, 7, :), p_18Phi(1, 8, :), p_18Phi(2, 5, :) );
    E_field(3, :) = calE( squeeze( p_18MidCrdnt(1, 5, :) ), squeeze( p_18MidCrdnt(1, 8, :) ), ...
                            squeeze( p_18MidCrdnt(1, 9, :) ), squeeze( p_18MidCrdnt(2, 5, :) ), ...
                            p_18Phi(1, 5, :), p_18Phi(1, 8, :), p_18Phi(1, 9, :), p_18Phi(2, 5, :) );
    E_field(4, :) = calE( squeeze( p_18MidCrdnt(1, 6, :) ), squeeze( p_18MidCrdnt(1, 9, :) ), ...
                            squeeze( p_18MidCrdnt(2, 5, :) ), squeeze( p_18MidCrdnt(2, 6, :) ), ...
                            p_18Phi(1, 6, :), p_18Phi(1, 9, :), p_18Phi(2, 5, :), p_18Phi(2, 6, :) );

    TriVec(1, :) = calTriVec( squeeze( p_18MidCrdnt(2, 4, :) ), squeeze( p_18MidCrdnt(2, 5, :) ), ...
                                squeeze( p_18MidCrdnt(1, 7, :) ) );
    TriVec(2, :) = calTriVec( squeeze( p_18MidCrdnt(1, 7, :) ), squeeze( p_18MidCrdnt(2, 5, :) ), ...
                                squeeze( p_18MidCrdnt(1, 8, :) ) );
    TriVec(3, :) = calTriVec( squeeze( p_18MidCrdnt(1, 9, :) ), squeeze( p_18MidCrdnt(1, 8, :) ), ...
                                squeeze( p_18MidCrdnt(2, 5, :) ) );
    TriVec(4, :) = calTriVec( squeeze( p_18MidCrdnt(1, 9, :) ), squeeze( p_18MidCrdnt(2, 5, :) ), ...
                                squeeze( p_18MidCrdnt(2, 6, :) ) );

    pre_I_seg = sum(sum( ( E_field .* TriVec ) ));

end