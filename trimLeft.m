function PntSegMed = trimLeft(PntSegMed, outMed)
    
    PntSegMed(2, :)    = outMed;

    PntSegMed(1, 3: 6) = outMed;
    PntSegMed(3, 1: 2) = outMed;
    PntSegMed(3, 7: 8) = outMed;
    PntSegMed(5, 1: 2) = outMed;
    PntSegMed(5, 7: 8) = outMed;
    PntSegMed(6, 3: 6) = outMed;
    
end
