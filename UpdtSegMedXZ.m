function PntSegMed = UpdtSegMedXZ(PntSegMed, medIn, idx)
    switch idx
        case 1
            PntSegMed(4, 1) = medIn;
            PntSegMed(4, 2) = medIn;
            PntSegMed(4, 3) = medIn;
            PntSegMed(4, 4) = medIn;
            PntSegMed(5, 4) = medIn;
            PntSegMed(6, 1) = medIn;
        case 2
            PntSegMed(1, 1) = medIn;
            PntSegMed(1, 2) = medIn;
            PntSegMed(1, 7) = medIn;
            PntSegMed(1, 8) = medIn;
            PntSegMed(5, 3) = medIn;
            PntSegMed(6, 2) = medIn;
        case 3
            PntSegMed(1, 3) = medIn; 
            PntSegMed(1, 4) = medIn; 
            PntSegMed(1, 5) = medIn; 
            PntSegMed(1, 6) = medIn; 
            PntSegMed(5, 2) = medIn; 
            PntSegMed(6, 3) = medIn; 
        case 4
            PntSegMed(2, 1) = medIn; 
            PntSegMed(2, 2) = medIn; 
            PntSegMed(2, 3) = medIn; 
            PntSegMed(2, 4) = medIn; 
            PntSegMed(5, 1) = medIn; 
            PntSegMed(6, 4) = medIn; 
        case 5
            PntSegMed(2, 5) = medIn; 
            PntSegMed(2, 6) = medIn; 
            PntSegMed(2, 7) = medIn; 
            PntSegMed(2, 8) = medIn; 
            PntSegMed(5, 8) = medIn; 
            PntSegMed(6, 5) = medIn; 
        case 6
            PntSegMed(3, 1) = medIn; 
            PntSegMed(3, 2) = medIn; 
            PntSegMed(3, 7) = medIn; 
            PntSegMed(3, 8) = medIn; 
            PntSegMed(5, 7) = medIn; 
            PntSegMed(6, 6) = medIn; 
        case 7
            PntSegMed(3, 3) = medIn; 
            PntSegMed(3, 4) = medIn; 
            PntSegMed(3, 5) = medIn; 
            PntSegMed(3, 6) = medIn; 
            PntSegMed(5, 6) = medIn; 
            PntSegMed(6, 7) = medIn; 
        case 8
            PntSegMed(4, 5) = medIn; 
            PntSegMed(4, 6) = medIn; 
            PntSegMed(4, 7) = medIn; 
            PntSegMed(4, 8) = medIn; 
            PntSegMed(5, 5) = medIn; 
            PntSegMed(6, 8) = medIn; 
    end
        
end