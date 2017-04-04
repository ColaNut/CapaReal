function PntSegMed = trimDown(PntSegMed, outMed)

    PntSegMed(3, :)    = outMed;
    
    PntSegMed(2, 5: 8) = outMed;
    PntSegMed(4, 5: 8) = outMed;
    PntSegMed(5, 5: 8) = outMed;
    PntSegMed(6, 5: 8) = outMed;
end
