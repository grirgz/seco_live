Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([700,500,300],inf),
	\n, 0.9,
	\dur, 1,
));

// END


(
TempoClock.default.tempo = 80/60;
p = Pbind(
    \midinote, Pseq([88, 88, 86, 84, 79,79,79,76, 76, 76,74, 72,72, 72, 71, 67, 67], inf),
	\legato, 0.1,
    \dur, Pseq([0.5], inf)
);
p.play
)
