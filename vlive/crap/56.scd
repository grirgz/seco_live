{ Pan2.ar(Klank.ar(`[[100, 2.2, 3.5, 4.9], nil, Array.series(4, 1, -0.2)], PinkNoise.ar(EnvGen.ar(Env.perc(0.001,0.01), Impulse.ar(4))), 0), 0); }.play;
