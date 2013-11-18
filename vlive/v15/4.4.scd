Pdef(~name, Pbind(
	\instrument, \singrain,
	\freq, Pseq([
		100,50,60,50,
		100,50,60,50,
		100,50,60,70,
		100,50,160,50,
	],inf),
	\ffreq, 1100,
	\isRest, Veco(~namex).isrest(32),
	//\ii, i,
	//\amp, 1/~n,
	\amp, 0.1,
	//\dur, Pdefn(~name+++\period) / (i + 1),
	\dur, 1/8,
	\legato, 0.8
));

// END

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

