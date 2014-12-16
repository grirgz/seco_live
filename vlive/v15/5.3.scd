
(
~n = 8;
Pdefn(~name+++\period, 40);
Pdef(~name, Ppar(
    Array.fill(~n, { arg i;
        Pbind(
            \instrument, \singrain,
            \instrument, ~name,
            //\freq, 55 * (i + 1),
			\degree, i.fold(0,7),
			\octave, 3,
			\ffreq, 100 * (i+1),
			\ii, i,
            \amp, 1/~n,
            \dur, Pdefn(~name+++\period) / Pseq([10,20,10,40].rotate(i),4),
			\lag, i/8,
			\sustain, 0.2,
            //\legato, 0.1
        )
    })
));
)
