function [ triArea ] = calTriArea( p1Crdt, p2Crdt, p3Crdt, u )

    triArea = 0.5 * norm( dot( cross( p2Crdt - p1Crdt, p3Crdt - p1Crdt ), u ) );

end