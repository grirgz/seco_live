
(
~n = 48;
Pdefn(~name+++\period, 100);
Pdef(~name, Ppar(
    Array.fill(~n, { arg i;
        Pbind(
            \instrument, \singrain,
            \freq, 55 * (i + 1),
			\ffreq, 100 * (i+1),
			\ii, i,
            \amp, 1/~n,
            \dur, Pdefn(~name+++\period) / (i + 1),
            \legato, 0.8
        )
    })
));
)
