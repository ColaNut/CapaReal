function [ TriVec ] = calTriVec( p1Crdt, p2Crdt, p3Crdt )

% calculate the normal vector of the trangle

    TriVec = zeros(1, 3);
    
    TriVec = 0.5 * cross( p2Crdt - p1Crdt, p3Crdt - p1Crdt );

end