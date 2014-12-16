
(
~n = 4;
Pdefn(~name+++\period, 50);
Pdef(~name, Ppar(
    Array.fill(~n, { arg i;
        Pbind(
            \instrument, \singrain,
            \freq, 55 * (i + 1),
			\ffreq, 100 * (i+1),
			\ii, i,
            \amp, 1/~n/4,
            \dur, Pdefn(~name+++\period) / (i + 1),
            \legato, 0.8
        )
    })
));
)
