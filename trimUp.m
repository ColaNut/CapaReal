function PntSegMed = trimUp(PntSegMed, outMed)

    PntSegMed(1, :)    = outMed;
    
    PntSegMed(2, 1: 4) = outMed;
    PntSegMed(4, 1: 4) = outMed;
    PntSegMed(5, 1: 4) = outMed;
    PntSegMed(6, 1: 4) = outMed;
end
