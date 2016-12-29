function maskXY(muscle_a, air_z, dx)
    x1 = [muscle_a, muscle_a + dx, muscle_a + dx, muscle_a];
    z1 = [- air_z / 2, - air_z / 2, air_z / 2, air_z / 2];
    patch(100* x1, 100* z1, 'white', 'EdgeColor', 'none');

    x2 = [- muscle_a, -muscle_a - dx, - muscle_a - dx, - muscle_a];
    z2 = [- air_z / 2, - air_z / 2, air_z / 2, air_z / 2];
    patch(100* x2, 100* z2, 'white', 'EdgeColor', 'none');
end