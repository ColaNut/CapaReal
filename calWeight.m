function [ weight, SegMed ] = calWeight( med2Layers, epsilon_r )
    
    weight = zeros(8, 1);
    SegMed  = ones( 1, 8, 'uint8' );
    tmp_Med2Layers = zeros( 2, 4 );
    
    tmp_Med2Layers = firstQdrt( med2Layers );
    [ weight(1: 2), SegMed(1: 2) ] = octantCube( tmp_Med2Layers, epsilon_r );

    tmp_Med2Layers = secondQdrt( med2Layers );
    [ weight(3: 4), SegMed(3: 4) ] = octantCube( tmp_Med2Layers, epsilon_r );

    tmp_Med2Layers = thirdQdrt( med2Layers );
    [ weight(5: 6), SegMed(5: 6) ] = octantCube( tmp_Med2Layers, epsilon_r );

    tmp_Med2Layers = fourthQdrt( med2Layers );
    [ weight(7: 8), SegMed(7: 8) ] = octantCube( tmp_Med2Layers, epsilon_r );

end