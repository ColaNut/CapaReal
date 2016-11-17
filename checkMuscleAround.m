function MuscleAround = checkMuscleAround( XZ9Med )

MuscleAround = false;

if ~isempty( find(XZ9Med == 3) )
    MuscleAround = true;
end

end