function PntSegMed = trimFar(PntSegMed, outMed)
    
    PntSegMed(5, :)    = outMed;

    PntSegMed(1, 1: 4) = outMed;
    PntSegMed(2, 3: 6) = outMed;
    PntSegMed(3, 1: 4) = outMed;
    PntSegMed(4, 1: 2) = outMed;
    PntSegMed(4, 7: 8) = outMed;
    
end
