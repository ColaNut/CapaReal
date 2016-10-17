function [ tmp_Med2Layers ] = fourthQdrt( med2Layers )
    tmp_Med2Layers = zeros( 2, 4 );

    tmp_Med2Layers(1, 1) = med2Layers(1, 5);
    tmp_Med2Layers(1, 2) = med2Layers(1, 2);
    tmp_Med2Layers(1, 3) = med2Layers(1, 6);
    tmp_Med2Layers(1, 4) = med2Layers(1, 3);

    tmp_Med2Layers(2, 1) = med2Layers(2, 5);
    tmp_Med2Layers(2, 2) = med2Layers(2, 2);
    tmp_Med2Layers(2, 3) = med2Layers(2, 6);
    tmp_Med2Layers(2, 4) = med2Layers(2, 3);

end