function NewMed9 = QdrntRt( Med9, QdrntName )
    
    NewMed9 = ones(size(Med9), 'uint8');

    if strcmp(QdrntName, '1st')
        NewMed9(1, 1) = Med9(3, 1);
        NewMed9(2, 1) = Med9(2, 1);
        NewMed9(3, 1) = Med9(1, 1);
        NewMed9(1, 2) = Med9(3, 2);
        NewMed9(2, 2) = Med9(2, 2);
        NewMed9(3, 2) = Med9(1, 2);
        NewMed9(1, 3) = Med9(3, 3);
        NewMed9(2, 3) = Med9(2, 3);
        NewMed9(3, 3) = Med9(1, 3);
    elseif strcmp(QdrntName, '3rd')
        NewMed9(1, 1) = Med9(1, 3);
        NewMed9(2, 1) = Med9(2, 3);
        NewMed9(3, 1) = Med9(3, 3);
        NewMed9(1, 2) = Med9(1, 2);
        NewMed9(2, 2) = Med9(2, 2);
        NewMed9(3, 2) = Med9(3, 2);
        NewMed9(1, 3) = Med9(1, 1);
        NewMed9(2, 3) = Med9(2, 1);
        NewMed9(3, 3) = Med9(3, 1);
    elseif strcmp(QdrntName, '4th')
        NewMed9(1, 1) = Med9(3, 3);
        NewMed9(2, 1) = Med9(2, 3);
        NewMed9(3, 1) = Med9(1, 3);
        NewMed9(1, 2) = Med9(3, 2);
        NewMed9(2, 2) = Med9(2, 2);
        NewMed9(3, 2) = Med9(1, 2);
        NewMed9(1, 3) = Med9(3, 1);
        NewMed9(2, 3) = Med9(2, 1);
        NewMed9(3, 3) = Med9(1, 1);
    else
        error('check');
    end

end