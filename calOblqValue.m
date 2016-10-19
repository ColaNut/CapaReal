function [ oblqValue ] = calOblqValue( FrntCrdnt, BckCrdnt, FrntPhi, BckPhi )
    distance = norm( FrntCrdnt - BckCrdnt );
    oblqValue = ( FrntPhi - BckPhi ) / distance;
end