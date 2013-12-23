Pdef(~name +++ \pre, Sdef(~name, \mynotes).pbind <> Pbind(
	//\freq, Pseq([50,40,55,50, 60,65,45,50],inf),
	\degree, Pseq([0,1,2,4],inf),
	\octave, 3,
	\fbase, 50,
	\fratio, Pseq([
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8], 1].flop,1),
		Pseq([[0.1,0.5,1.01,2, 2,4,6,8].reverse, 1].flop,1),
	],inf),
	\fratio, Ndef(~name+++\lfo1, { SinOsc.kr(1).range(1.51,4) }),
));

// END

Pdef.defaultQuant = 8;
Sdef(~name, \mynotes).record(64,8)
Sdef(~name, \mynotes).record(inf)
Sdef(~name, \mynotes).stop_record;
Sdef(~name, \mynotes).get(0).recorder.stop_recording

[0.1,0.5] *.t [1,1.2]
[[0.1,0.5,1.01], 1].flop
