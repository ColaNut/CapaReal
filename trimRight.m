function PntSegMed = trimRight(PntSegMed, outMed)
    
    PntSegMed(4, :)    = outMed;

    PntSegMed(1, 1: 2) = outMed;
    PntSegMed(1, 7: 8) = outMed;
    PntSegMed(3, 3: 6) = outMed;
    PntSegMed(5, 3: 6) = outMed;
    PntSegMed(6, 1: 2) = outMed;
    PntSegMed(6, 7: 8) = outMed;

end
