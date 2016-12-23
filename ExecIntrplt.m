function [ IntrpltSglPnt ] = ExecIntrplt( mI, ellI, SARseg, TtrVol, CrossSecText )

    % CrossSecText = 'XZ', 'XY' or 'YZ'
    IntrpltSglPnt = 0;
    % becareful for the data type and modulus operation
    m = (mI + 1) / 2;
    ell = (ellI + 1) / 2;
    mLft = mI / 2;
    mRght = mI / 2 + 1;
    ellUp = ellI / 2 + 1;
    ellDwn = ellI / 2;
    if mod(mI, 2) == 1 && mod(ellI, 2) == 1 
        IntrpltSglPnt = IntrpltOddOdd( squeeze( SARseg( m, ell, :, :) ), squeeze( TtrVol( m, ell, :, : ) ), CrossSecText );
    elseif  mod(mI, 2) == 1 && mod(ellI, 2) == 0 
        IntrpltSglPnt = IntrpltOddEven( squeeze( SARseg( m, ellUp, :, :) ), squeeze( TtrVol( m, ellUp, :, : ) ), ...
                                    squeeze( SARseg( m, ellDwn, :, :) ), squeeze( TtrVol( m, ellDwn, :, : ) ), CrossSecText );
    elseif  mod(mI, 2) == 0 && mod(ellI, 2) == 1 
        IntrpltSglPnt = IntrpltEvenOdd( squeeze( SARseg( mLft, ell, :, :) ), squeeze( TtrVol( mLft, ell, :, : ) ), ...
                                    squeeze( SARseg( mRght, ell, :, :) ), squeeze( TtrVol( mRght, ell, :, : ) ), CrossSecText );
    else
        IntrpltSglPnt = IntrpltEvenEven( squeeze( SARseg( mRght, ellUp, :, :) ), squeeze( TtrVol( mRght, ellUp, :, : ) ), ...
                                    squeeze( SARseg( mLft, ellUp, :, :) ), squeeze( TtrVol( mLft, ellUp, :, : ) ), ...
                                    squeeze( SARseg( mLft, ellDwn, :, :) ), squeeze( TtrVol( mLft, ellDwn, :, : ) ), ...
                                    squeeze( SARseg( mRght, ellDwn, :, :) ), squeeze( TtrVol( mRght, ellDwn, :, : ) ), CrossSecText );
    end

end