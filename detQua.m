function quaAns = detQua( qua )
    quaAns = false(2, 1);

    MskQua = false(size(qua));
    MskQua( find(qua >= 10) ) = true;
    
    if MskQua(1) == false
        error('check');
    end
    % eight cases:
    if MskQua(2) == false && MskQua(3) == false && MskQua(4) == false
        ;
    elseif MskQua(2) == false && MskQua(3) == false && MskQua(4) == true
        error('check');
    elseif MskQua(2) == false && MskQua(3) == true  && MskQua(4) == false
        ;
    elseif MskQua(2) == false && MskQua(3) == true  && MskQua(4) == true
        quaAns(2) = true;
    elseif MskQua(2) == true  && MskQua(3) == false && MskQua(4) == false
        ;
    elseif MskQua(2) == true  && MskQua(3) == false && MskQua(4) == true
        quaAns(1) = true;
    elseif MskQua(2) == true  && MskQua(3) == true && MskQua(4) == false
        quaAns(1) = true;
        quaAns(2) = true;
    elseif MskQua(2) == true  && MskQua(3) == true && MskQua(4) == true
        quaAns(1) = true;
        quaAns(2) = true;
    end
end