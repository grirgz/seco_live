
(
Pdef(~name +++ \pre, Pbind(
		//\freq, Pseq([50,40,55,50, 60,65,45,50],inf),
		\degree, Pseq([
			Pser([0],30),
			Pser([7],2),
			Pser([0],26),
			Pser([7],6),
			Pser([0],30),
			Pser([-7],2),
			Pser([0],26),
			Pser([-7],6),
		],inf),
		\octave, 5,
		\isRest, Veco(~namex).isrest(16),
		\dur, 1/8,
		\fbase, 50,
		\fratio, Pseq([
			Pseq([[0.1,0.5,1.01,2, 2,4,6,8], 1].flop,1),
			Pseq([[0.1,0.5,1.01,2, 2,4,6,8].reverse, 1].flop,1),
		],inf),
		//\legato, Pseg(Pseq([0.1,1.5],inf), 16),
		//\legato, Pfunc({ arg ev; ev.debug("ev"); ev[\legato].debug("leg") }),
		\fratio, Ndef(~name+++\lfo1, { arg freq=(1/8), mul=1; SinOsc.kr(freq, mul:mul).range(0.91,6) }),
	)
	<> Sdef(~name, \mypreset).pbind
	<> Sdef(~name, \pat).get_active_score.valpbind

);
)

// END

	Sdef(~name, \pat).pbind.trace.asStream.next(Event.default)
	Sdef(~name, \pat).get_active_score.valpbind.trace.asStream.next(Event.default)

MIDIBoard.map(\k7, Ndef('5lfo1'), \freq, \lofreq.asSpec);
MIDIBoard.map(\k8, Ndef('5lfo1'), \mul, \unipolar.asSpec);
Ndef('5lfo1').edit

Sdef(~name, \mypreset, \preset, ~name);
Sdef(~name, \pat, \preset, [\legato, ControlSpec(0.01,2,'exp',0,1)]);
Sdef(~name, \pat).edit
Sdef(~name, \pat).rebuild
Sdef(~name, \mypreset).edit
Sdef(~name, \mypreset).rebuild
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant

Pdef.defaultQuant = 8;
Sdef(~name, \mynotes).record(64,8)
Sdef(~name, \mynotes).record(inf, 16)
Sdef(~name, \mynotes).stop_record;
Sdef(~name, \mynotes).get(0).recorder.stop_recording

[0.1,0.5] *.t [1,1.2]
[[0.1,0.5,1.01], 1].flop

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

