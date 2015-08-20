
(
SynthDef(\dr_kick, { |out=0, amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	freqpan = [1,0,-1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);
	
	son = son * 1.2;
	son = son.clip2(1);

	son = son * amp;
	son = Splay.ar(son, spread, amp, pan);
	
	OffsetOut.ar(out, son);
}).add;

	Pdef(\dr_kick, Pbind(
		\instrument, \dr_kick,

	));
	Pdef(\dr_kick).addSpec(\env0, XEnvSpec( ControlSpec(0,9,\lin)!4, ControlSpec(0,2,\lin)!4 ));
	Pdef(\dr_kick).addSpec(\env1, XEnvSpec( ControlSpec(0,127,\lin)!3, ControlSpec(0,2,\lin)!3 ));
	Pdef(\dr_kick).addHalo(\instrument, \dr_kick);
	Pdef(\dr_kick).addHalo(\params, [
		\amp, \env0, \env1, [\fratio, ControlSpec(0,20,\lin)]
	]);
	//Param.getSynthDefDefaultValue(\env0, \dr_kick).asEnv

	DrumRack.addInstr(\dr_kick);

	Pdef(\dr_kick2, Pbind(
		\instrument, \dr_kick,

	));

	Pdef(\dr_kick3, Pbind(
		\instrument, \dr_kick,

	));

DrumRack.all[\plop] = nil;
DrumRack.lib_drumrack[\default] = nil;
DrumRack(\plop);

~pg = ~class_presetgroup.new;
~pg2 = ~class_presetgroup.new;
~p1 = ~class_preset.new(\dr_kick);
~p2 = ~class_preset.new(\dr_kick2);
~p3 = ~class_preset.new(\dr_kick3);

~pg.add_preset(~p1);
~pg2.add_preset(~p2);
~pg2.add_preset(~p3);
DrumRack.lib_drumpad[\note1] = ~pg;
DrumRack.lib_drumpad[\note2] = ~pg2;

DrumRack(\plop).edit;
)

DrumRack.lib_drumrack[\default]

DrumRack(\plop).drumrack = ~class_drumrack.new;
DrumRack.lib_drumrack.get_list.first
~class_drumrack_view.new(DrumRack(\plop));

			"/home/ggz/code/sc/seco/vlive/demo/param/lib/drumrack.scd".load;

(
Pn(DrumRack(\plop, Pbind(
	\midinote, Pseq([0,1,1,0,2,2],inf),
	\dur, 1/4,
))).play;
)
Pdef(\plop).play

~p1.params
~p1.instr
~p1.paramlist
~pg.paramlist
~pg.list.first.paramlist

DrumRack(\plop).drumrack.get_pad(0).play_preset
DrumRack(\plop).drumrack.get_pad(0).play_preset
/////////////////////////////////////////////////////////////////////

Pdef(\dr_kick).play
Pdef(\dr_kick).asParamGroup.edit
Pdef(\dr_kick).addHalo(\instrument, \dr_kick)
Param(Pdef(\dr_kick), \env0).edit
(
ParamGroup([ 
	Param(Pdef(\dr_kick), \env0) ,
	Param(Pdef(\dr_kick), \env1) ,
]).edit
)

	Param(Pdef(\dr_kick), \env0).default
DrumRack(\plop).edit
DrumRack(\plop).play

DrumRack.addInstr(Pdef(\dr_kick), [
	\env0, \env1, [\fratio, ControlSpec(0,20,\lin)]
]);
DrumRack.addInstr(Pdef(\dr_snare), [
	\env0, \env1, [\fratio, ControlSpec(0,20,\lin)]
]);

Pseq(
	DrumRack(\plop).asPattern(
		Pbind(
			\midinote, Pseq([1,2,3,4,5,6]),
			\dur, 1/4
		)
	),
	DrumRack(\bla).asPattern(
		Pbind(
			\midinote, Pseq([1,2,3,4,5,6]),
			\dur, 1/4
		)
	),
)

Pseq(
	DrumRack(\plop).asPattern(
		Pdemul(
			DrumRack(\plop)
			Pbind(
				\midinote, Pseq([1,2,3,4,5,6]),
				\dur, 1/4
			)
			
		)
	)
)

	DrumRack(\plop).asPattern( StepSeq(\yep) ).play;
	WindowLayout({ HLayout(DrumRack(\plop).asView, StepSeq(\yep).asView)  })
	DrumSeq(\norta).edit



(
	(
	SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	);

	Pdef(\dr_kick, 
		PlazyEnvir({ arg freqfac=2, lpf=300;
			freqfac.debug("freqfaq");
			Pbind(
				\instrument, \saw,
				\freq, freqfac * Pseq([100,137,120,125]),
				\amp, Pkey(\amp) * 3,
			)
		}).loop;
	);
	Pdef(\dr_kick).play;
)
	Pdef(\dr_kick).set(\freqfac, 3.3);
	Pdef(\dr_kick).set(\freqfac, 1.155);
	Pdef(\dr_kick).unset(\freqfac);
	Pdef(\dr_kick).set(\lpf, 2000);
	Pdef(\dr_kick).set(\lpf, 1000);
	Pkey


(
	(
	SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	);

	Pdef(\dr_kick, 
		Pbind(
			\instrument, \saw,
			\freq, Pkeyd(\freqfac, 4) * Pseq([100,137,120,125],inf),
			\amp, Pkey(\amp) * 3,
		)
	);
	Pdef(\dr_kick).play;
)

(
	(
	SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	);

	Pdef(\dr_kick, 
		Pbind(
			\instrument, \saw,
			\freqfac, Pkeyd(\freqfac, 4),
			\freq, Pkey(\freqfac) * Pseq([100,137,120,125],inf),
			\amp, Pkey(\amp) * 3,
		)
	);
	Pdef(\dr_kick).play;
)
