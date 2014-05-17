//Ndef(~name+++\lfo1, { SinOsc.kr(0.01).range(0.05,1)  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo3).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo1, { arg val=1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		1,0.2,0.2,0.21,
		0.1,0.2,0.2,0.21,
	],inf)/10+1,
	\val, -60.midiratio,
	\val, Pseq([-60,-55],inf).midiratio,
	\flag, 4.1,
	\dur, 4,
));

Ndef(~name+++\lfo2, { arg val=1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo2).put(1, \set -> Pbind(
	\val, Pseq([0.1,0.2,0.01,0.02],inf),
	\flag, 0.1,
	\dur, 1/2,
));

Ndef(~name+++\lfo3, { arg val=0.1, flag=0.1; val.lag(flag) });
Ndef(~name+++\lfo3).put(1, \set -> Pbind(
	\val, Pseq([
		0.1,0.12,
		0.2,0.2,
		0.5,0.5,
	],inf),
	\val, Pseg(Pseq([0.1,0.2],inf),8),
	\dur, 1,
	\flag, Pkey(\dur),
));

Pdef(~name+++\mod, Pbind());
Pdef(~name+++\macro, Pbind());
Pdef(~name+++\macro).addHalo(\instrument, \zegrainer2);

(
Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\ukraine),
		\dur, 1/8,
		//\legato, 1,
		\pitch_stretch, 0.1,
		\pitch_stretch, Pseq([1,0.3],inf),
		\pitch_stretch, Pseq([1,0.3,0.2,0.7, 1, 2, 2,1],inf),
		\pitch_stretch, [Ndef(~name+++\lfo1)],
		\time_stretch, Ndef(~name+++\lfo2),
		\dur, 1/5,
		\amp, Pkey(\amp) * 2,
	) <>
	Pdef(~name+++\macro) <>
	Pbind(

		\pitch_stretch, Ndef(~name+++\lfo1),
		//\time_stretch, Ndef(~name+++\lfo2),
		\finepos, Ndef(~name+++\lfo3),
		//\pitch_stretch, 1.0,
		//\pitch_stretch, Pseq([
		//	1.0,2,0.8,0.7,
		//	2.0,1,0.8,0.4,
		//],inf).stutter(4),
		//\pitch_stretch, Pseg(Pseq([0.1,4],inf),16),
		//\pos, ~midi.(\k1, nil, ControlSpec(0,0.1,'lin',0,0)).vpattern + 0.3,
		\ffreq, 1000,
		\legato, Pseq([
			1,0.5,
			1,0.1,
			1,0.8,
			1,0.4,

			1,1.0,
			1,0.1,
			0.1,0.8,
			1,0.4,
		],inf) * Pswitch1([Pseg(Pseq([1,0],inf),8).asStream, 1.01],Pseq([0,1],inf))+0.1,
		\legato, 1.0,
	) <>
	
	//Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\time_stretch, 0,
		\freq, 100,
		\pos, Pseq([0.1,0.12,0.3,0.2],inf) + Pwhite(0,0.01),
		\pos, Pseq([
			0.3,0.21,
			0.4,0.31,
		],inf) + Pwhite(0,0.007),
		\pos, 0.3,
	)
)

)

// END

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
Pdef.default = Pbind()
Pdef(~name+++\macro).addHalo(\instrument, \zegrainer2)
Pdef(~name+++\macro).asRack.edit
Pdef(~name+++\macro).setBusMode(\pos, \finepos, \time_stretch, \pitch_stretch)
(
~r = Rack([
	[Pdef(~name+++\macro), \time_stretch],
	[Pdef(~name+++\macro), \pitch_stretch],
	[Pdef(~name+++\macro), \pos],
	[Pdef(~name+++\macro), \finepos],
	[Pdef(~name+++\macro), \legato],
	[Pdef(~name+++\macro), \adsr, \adsr.asSpec],
	//[Pdef(~name+++\macro), \adsr],
])
)
~r.edit
~r.map_midi
\adsr.asSpec
Spec.add(\adsr, XEnvSpec(ControlSpec(0,1,\lin,0,0.1) ! 4, ControlSpec(0.001,4,\exp,0), ControlSpec(-9,9,\lin,0,0), Env.adsr(0.1,0.1,0.8,0.1)))

~pre1 = ~r.save_preset
~pre2 = ~r.save_preset
~r.set_preset_list([~pre1, ~pre2])

(
~mr = Rack([
	[Pdef(~name+++\macro), \time_stretch],
	[Pdef(~name+++\macro), \pitch_stretch],
	[Pdef(~name+++\macro), \pos],
	[Pdef(~name+++\macro), \finepos],
	[Pdef(~name+++\macro), \legato],
	[Pdef(~name+++\macro), \adsr, \adsr.asSpec],
	[~r, \morph],
	//[Pdef(~name+++\macro), \adsr],
])
)
~mr.map_midi


(
play {
    var sig, amp;
    amp = MouseX.kr(700, 758);
    sig = SinOsc.ar(220, 0, amp.neg.dbamp);
    sig = sig * amp.dbamp;
    sig!2
};
)
