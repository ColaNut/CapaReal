function [ weight ] = calWeight( med2Layers, epsilon_r )
    
    weight = zeros(8, 1);
    tmp_Med2Layers = zeros( 2, 4 );
    
    tmp_Med2Layers = firstQdrt( med2Layers );
    [ weight(1), weight(2) ] = octantCube( tmp_Med2Layers, epsilon_r );

    tmp_Med2Layers = secondQdrt( med2Layers );
    [ weight(3), weight(4) ] = octantCube( tmp_Med2Layers, epsilon_r );

    tmp_Med2Layers = thirdQdrt( med2Layers );
    [ weight(5), weight(6) ] = octantCube( tmp_Med2Layers, epsilon_r );

    tmp_Med2Layers = fourthQdrt( med2Layers );
    [ weight(7), weight(8) ] = octantCube( tmp_Med2Layers, epsilon_r );

end