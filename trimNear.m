function PntSegMed = trimNear(PntSegMed, outMed)
    
    PntSegMed(6, :)    = outMed;

    PntSegMed(1, 5: 8) = outMed;
    PntSegMed(2, 1: 2) = outMed;
    PntSegMed(2, 7: 8) = outMed;
    PntSegMed(3, 5: 8) = outMed;
    PntSegMed(4, 3: 6) = outMed;
    
end
