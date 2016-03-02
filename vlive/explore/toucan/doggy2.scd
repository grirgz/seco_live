

(
TempoClock.default.tempo = 190/60;
Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;
~t = TempoClock.default.tempo;

//Spec.add(\fb, ControlSpec(0.0001,0.9,\exp));
//Spec.add(\lpf, \freq.asSpec);
//Spec.add(\hpf, \freq.asSpec);
//Spec.add(\plpf, \freq.asSpec);
//Spec.add(\phpf, \freq.asSpec);
//Spec.add(\prelpf, \freq.asSpec);
//Spec.add(\prehpf, \freq.asSpec);
//Spec.add(\delay2, \delay.asSpec);
//Spec.add(\shift, ControlSpec(-5,5,\lin));
//Spec.add(\shift2, \shift.asSpec);
//Spec.add(\pitchmix, \unipolar.asSpec);
//Spec.add(\pitchlag, ControlSpec(0.001,1,\exp));
//
//Spec.add(\wet10, \unipolar.asSpec);
//Spec.add(\wet20, \unipolar.asSpec);
BusDef(\fx1, \audio, 2);

SynthDef(\zkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	son = LPF.ar(son, \lpf.kr(2000));
	
	//son = son * 1.2;
	//son = son.clip2(1);

	son = son * amp;
	son = son * env0 * 8;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	env0: XEnvSpec( ControlSpec(0,9,\lin)!4, ControlSpec(0,2,\lin)!4 ),
	env1: XEnvSpec( ControlSpec(0,127,\lin)!3, ControlSpec(0,2,\lin)!3 ),
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).store;
SynthDef(\hat2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\basicsnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(Env([400,150,151],[0.01,0.08]), 1) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.20], -4), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([14700,4852,3451],[0.01,0.1]), 1));
	snare = HPF.ar(snare, EnvGen.ar(Env([9700,4452,3451],[0.01,0.1]), 1));
	snare = snare * EnvGen.kr(Env([0,1,0],[0.001,0.18], -2), 1);

	sig = click + osc + snare;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\basicsnare2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(Env([400,150,151],[0.01,0.08]), 1) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.20], -4), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([14700,7852,5451],[0.01,0.1]), 1));
	snare = HPF.ar(snare, EnvGen.ar(Env([9700,3452,3451],[0.01,0.1]), 1));
	snare = snare * EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.08], -4), 1);

	sig = click + osc + snare;

	sig = sig / 2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Ndef(\bypass, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2);
	in;
});


Pdef(\basicsnare, Pbind(
	\instrument, \basicsnare,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\out, BusDef(\fx1),
	\amp, 0.2
));

Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		1,0,1,0, 0,0,1,0,
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		1,0,0,1, 0,0,0,0,
		1,1,0,0, 0,0,0,1,
	],inf).coin.not,
	\out, BusDef(\fx1),
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \hat2,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\sustain, 0.1,
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

//////////////////////////////////////////////////////////////////// perc presets

Pdef(\kick_p1, (
	Pdef(\kick)
));
Pdef(\snare_p1, (
	Pdef(\basicsnare)
));
Pdef(\hat_p1, (
	Pdef(\hat)
));

Pdef(\kick_p2, (
	Pbind(
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,1,
		],inf).coin.not,
		\dur, 1,
	)
	<>
	Pdef(\kick)
));
Pdef(\snare_p2, (
	Pbind(
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,1,1,1,
		],inf).coin.not,
		\dur, 1,
	)
	<>
	Pdef(\basicsnare)
));
Pdef(\hat_p2, (
	Pbind(
		\isRest, Pseq([
			0,0,1,0, 0,0,1,0,
		],inf).coin.not,
	)
	<>
	Pdef(\hat)
));

/////////////////////

Pdef(\kick_p3, (
	Pbind(
		\isRest, Pseq([
			1,0,0,1, 0,0,1,0,
		],inf).coin.not,
		\dur, 1,
	)
	<>
	Pdef(\kick)
));
Pdef(\snare_p3, (
	Pbind(
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,1,1,
		],inf).coin.not,
		\dur, 1/2,
	)
	<>
	Pdef(\basicsnare)
));
Pdef(\hat_p3, (
	Pbind(
		\isRest, Pseq([
			1,0,1,0, 1,0,1,0,
		],inf).coin.not,
		\rel, Pseq([1,1,1,1, 1,1,1,Pwhite(1,8.0,1)],inf).stutter(2)/13,
	)
	<>
	Pdef(\hat)
));

////////////////////

Pdef(\kick_p4, (
	Pbind(
		\isRest, Pseq([
			1,0,1,0, 0,0,0,0,
			1,0,0,1, 0,0,1,0,
			1,0,0,0, 0,1,0,0,
			1,0,0,0, 0,0,0,0,

			1,0,1,0, 0,0,0,0,
			1,0,0,1, 0,0,1,0,
			1,0,0,0, 0,1,0,0,
			1,0,0,0, 0,1,0,1,
		],inf).coin.not,
		\dur, 1/2,
	)
	<>
	Pdef(\kick)
));
Pdef(\snare_p4, (
	Pseq([
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,1,0,
		
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				//0,0,0,0, 1,0,1,0,
			],1).coin.not,
			\dur, 1/2,
		),
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				1,1,0,1, 1,0,1,0,
			],1).coin.not,
			\dur, 1/4,
		),
	],inf)

	<>
	Pdef(\basicsnare)
));
Pdef(\hat_p4, (
	Pbind(
		\isRest, Pseq([
			1,0,1,0, 1,0,1,0,
			1,0,1,1, 1,0,1,0,
			1,0,1,0, 1,0,1,0,
			1,0,1,0, 1,1,0,1,
		],inf).coin.not,
		\rel, Pseq([1,1,1,1, 1,1,1,Pwhite(1,8.0,1)],inf).stutter(2)/13,
		\dur, 1/2,
	)
	<>
	Pdef(\hat)
));

////////////////////

Pdef(\kick_p5, (
	Pbind(
		\isRest, Pseq([
			1,1,1,1, 0,0,0,0,
			1,0,1,1, 0,0,1,0,
			1,0,0,1, 0,1,1,0,
			1,0,1,1, 0,1,0,1,
		],inf).coin.not,
		\dur, 1/2,
	)
	<>
	Pdef(\kick)
));
Pdef(\snare_p5, (
	Pbind(
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,1,1,
		],inf).coin.not,
		\dur, 1/2,
	)
	<>
	Pdef(\basicsnare)
));
Pdef(\hat_p5, (
	Pbind(
		\isRest, Pseq([
			1,0,0,0, 1,0,0,0,
			1,0,1,0, 1,1,1,1,
		],inf).coin.not,
		\rel, Pseq([
			1,1,1,1, Pwhite(1,8.0,1),1,1,1,
			1,1,1,1, 1,1,1,1,
		],inf).stutter(2)/13,
		\dur, 1/4,
	)
	<>
	Pdef(\hat)
));

///////////////////////////////////////////////////////////// fx presets

Pdef(\fxp1,

Pbind(  
        'inbus', Bus('audio', 20, 2, s),
        'wet10', 0.54444444444444,
        'pitchlag', 0.1,
        'delay', 0.00023865897868586,
        'delay2', 0.0001,
        'shift', 0.0,
        'shift2', 0.0,
        'distamp', 5.0182662231547,
        'prelpf', 17000,
        'prehpf', 207.82446076703,
        'fb', 0.0090188931305119,
        'lpf', 14158.915687683,
        'hpf', 17,
        'pitchmix', 0.5,
        'plpf', 17000,
        'phpf', 17,
        'poamp', 0.11880182554415,
        'wet20', 1.0,
        'mamp', 1.8205642030261,
)

);

Pdef(\fxp2,

Pbind(  
        'inbus', Bus('audio', 20, 2, s),
        'wet10', 0.54444444444444,
        'pitchlag', 0.1,
        'delay', 0.00023865897868586,
        'delay2', 0.0001,
        'shift', 0.0,
        'shift2', 0.0,
        'distamp', 5.0182662231547,
        'prelpf', 17000,
        'prehpf', 207.82446076703,
        'fb', 0.0090188931305119,
        'lpf', 14158.915687683,
        'hpf', 17,
        'pitchmix', 0.5,
        'plpf', 17000,
        'phpf', 17,
        'poamp', 0.11880182554415,
        'wet20', 1.0,
        'mamp', 1.8205642030261,
)

);

//RandDelayNetwork(\default).make(\myfx1, "5-EQP1-S013", BusDef(\fx1));
)
RandDelayNetwork(\default).make(\myfx1, "5--", BusDef(\fx1));
RandDelayNetwork(\default).code

Ndef(\myfx1).asParamGroup.getPbindCompileString
Ndef(\myfx1).controlKeysValues


		"\nPbind(\n\t%\n)\n".format(
			Ndef(\myfx1).controlKeysValues.clump(2).collect({ arg p; 
				"%, %,".format(p[0].asCompileString, p[1].asCompileString)
			}).join("\n\t")
		)

(
Pdef(\fxp2,

Pbind(  
	\dur, 1/2,
		'wet10', 0.54444444,
		'pitchlag', 0.1,
		'delay', 0.000000658,
		'delay2', 0.00011,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.0182662231547 * Pseq([
			1,2,2,4,
		],inf),
		'prelpf', 17000,
		'prehpf', 07.82446076703,
		'fb', 0.0000188931305119 * Pseq([100,201,100,120, 1,1,100,1]/1,inf).stutter(4),
		'lpf', 14158.915687683,
		'hpf', 17,
		'pitchmix', 1.0,
		'plpf', 17000,
		'phpf', 17,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
)

);

Pdef(\fxp3,
	Pbind(  
		\dur, 1/2,
		'wet10', 0.54444444,
		'pitchlag', 0.1,
		'delay', 0.000000058,
		'delay2', 0.00004 * Pseq([1,1/2],inf).stutter(4),
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.7182662231547,
		'prelpf', 17000,
		'prehpf', 07.82446076703,
		'fb', 0.0041088931305119,
		'lpf', 17158.915687683,
		'hpf', 17,
		'pitchmix', 0.6,
		'plpf', 10000,
		'phpf', 217,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
	)
);

Pdef(\fxp4,
	Pbind(  
		\dur, 4,
		'wet10', 0.54444444,
		'pitchlag', 4.1,
		'delay', 0.001100058 * Pseq([1,1/1000],inf),
		'delay2', 0.40104 * Pseq([1,1/147],inf).stutter(1),
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.7182662231547,
		'prelpf', 17000,
		'prehpf', 07.82446076703,
		'fb', 0.0011088931305119,
		'lpf', 17158.915687683,
		'hpf', 217,
		'pitchmix', 1.6,
		'plpf', 10000,
		'phpf', 217,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
	)
);

Pdef(\fxp5,
	Pbind(  
		\dur, 4,
		'wet10', 0.54444444,
		'pitchlag', 4.1,
		'delay', 0.000000058 * Pseq([1,1*10],inf),
		'delay2', 0.01004 * Pseq([1*10,1*17],inf).stutter(1),
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.7182662231547,
		'prelpf', 17000,
		'prehpf', 107.82446076703,
		'fb', 0.0111088931305119,
		'lpf', 17158.915687683,
		'hpf', 047,
		'pitchmix', 0.6,
		'plpf', 10000,
		'phpf', 217,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
	)
);

)

RandDelayNetwork(\default).define_specs
Pdef(\hat_p1).play
Ndef(\myfx1).play;
Ndef(\myfx1).put(100, \pset -> Pdef(\fxp1));
Ndef(\myfx1).edit
Ndef(\myfx1).put(100, nil);

Pdef(\kick_p1).stop
Pdef(\snare_p3).play
Pdef(\snare_p3).stop

(
	Ndef(\myfx1).play;
	//Ndef(\myfx1).put(100, \pset -> Pdef(\fxp1));
	RandDelayNetwork(\default).make(\myfx1, "5-aQP1-S013", BusDef(\fx1));
	Pdef(\main, 
		Ppar([
			Pdef(\kick_p1),
			Pdef(\snare_p1),
			Pdef(\hat_p1),

		])
	).play;
)
(
	Ndef(\myfx1).play;
	RandDelayNetwork(\default).make(\myfx1, "5-lttt-St13", BusDef(\fx1));
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxp3));
	Pdef(\main, 
		Ppar([
			Pdef(\kick_p2),
			Pdef(\snare_p2),
			Pdef(\hat_p2),

		])
	).play;
)
	Ndef(\myfx1).edit;
(
	Ndef(\myfx1).play;
	//Ndef(\myfx1).put(100, \pset -> Pdef(\fxp5));
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxp1));
	RandDelayNetwork(\default).make(\myfx1, "5-a3a1-1413", BusDef(\fx1));
	Pdef(\main, 
		Ppar([
			Pdef(\kick_p3),
			Pdef(\snare_p3),
			Pdef(\hat_p3),

		])
	).play;
)
(
	Ndef(\myfx1).play;
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxp3));
	Pdef(\main, 
		Ppar([
			Pdef(\kick_p4),
			Pdef(\snare_p4),
			Pdef(\hat_p4),

		])
	).play;
)
(
	Ndef(\myfx1).play;
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxp2));
	RandDelayNetwork(\default).make(\myfx1, "5-a1h9-2113", BusDef(\fx1));
	Pdef(\main, 
		Ppar([
			Pdef(\kick_p5),
			Pdef(\snare_p5),
			Pdef(\hat_p5),
		])
	).play;
)

(
	Ndef(\myfx1).play;
	//Ndef(\myfx1).put(100, \pset -> Pdef(\fxp4));
	RandDelayNetwork(\default).make(\myfx1, "5-a1h9-2113", BusDef(\fx1));
	Pdef(\main, 
		Ppar([
			Pdef(\kick_p4),
			Pdef(\snare_p4),
			Pdef(\hat_p4),

		])
	).play;
)

(
	Ndef(\myfx1).play;
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxp5));
	RandDelayNetwork(\default).make(\myfx1, "5-01h9-2113", BusDef(\fx1));
	Pdef(\main, Pdef(\perc_p6)).play;
)

	RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i413", BusDef(\fx1)); // bass
	RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
(
	Ndef(\myfx1).play;
	RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1));
	//Ndef(\myfx1).put(100, \pset -> Pdef(\fxp1));
	//Ndef(\myfx1).put(100, \pset -> Pbind( \wet10, 0 ));
	Pdef(\main, Pdef(\perc_p2)).play;
)


Ndef(\myfx1).put(100, nil)

(
Pdef(\perc_p2, 
		Ppar([
			Pdef(\kick_p2),
			Pdef(\snare_p2),
			Pdef(\hat_p2),

		])
);

Pdef(\perc_p6, (
	Ppar([

		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 0,1,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,1,
				1,0,1,1, 0,0,0,0,

				1,0,0,0, 1,1,0,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 0,1,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,1,
				1,0,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		Pbind(
			\isRest, Pseq([
				//0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/1,
		)
		<>
		Pdef(\basicsnare),

		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, Pwhite(1,8.0,1),1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(2)/13,
			\dur, 1/4,
		)
		<>
		Pdef(\hat)
	])
));
)

(
Pdef(\perc_p7, (
	Ppar([

		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 4/5,
			\timeScale, 3/4,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		Pbind(
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		Pbind(
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,Pwhite(1,8.0,1),1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(2)/13 * Pseq([1,0.7,Prand([0.9,0.2,0.9,0.5],1),0.6],inf).stutter(2),
			\dur, 1/4,
		)
		<>
		Pdef(\hat)
	])
));
)

(
Pdef(\fxp1,

Pbind(  
        'inbus', Bus('audio', 20, 2, s),
        'wet10', 0.54444444444444,
        'pitchlag', 0.1,
		\dur, 1/4,
        'delay', 0.00023865897868586 ,
        'delay2', 0.0001,
        'shift', 0.0,
        'shift2', 0.0,
        'distamp', 5.0182662231547* Pseq([1,1/10,1,1],inf),
        'prelpf', 17000,
        'prehpf', 207.82446076703,
        'fb', 0.0090188931305119* Pseq([1,1,1,1, 1/100,2,1,1/10],inf).stutter(1),
        'lpf', 14158.915687683,
        'hpf', 17,
        'pitchmix', 0.5,
        'plpf', 17000,
        'phpf', 17,
        'poamp', 0.11880182554415,
        'wet20', 1.0,
        'mamp', 1.8205642030261,
)

);
Pdef(\perc_p8, (
	Ppar([

		Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,

				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			//\amp, Pkey(\amp) * 4/5,
			\timeScale, 3/4,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		Pbind(
			\instrument, \basicsnare2,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		Pbind(
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,1,0, 1,0,1,0,

				0,0,0,0, 0,1,1,1,
				0,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				0,0,0,0, 0,1,1,1,
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1)/13 * Pseq([
				1.0,0.7,0.9,0.5,
			],inf).stutter(2),
			\dur, 1/4,
		)
		<>
		Pdef(\hat)
	])
));
)

Ndef(\myfx1).put(100, \pset -> Pbind( \wet10, 0 ))
Ndef(\myfx1).edit

(
	Ndef(\myfx1).play;
	RandDelayNetwork(\default).make(\myfx1, "5-01h9-2113", BusDef(\fx1));
	Ndef(\myfx1).put(100, \pset -> Pbind( \wet10, 0 ));
	Pdef(\main, Pdef(\perc_p8)).play;
)







/////////////////////////////////////////////////////



	RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i413", BusDef(\fx1)); // bass
	RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
	RandDelayNetwork(\default).make(\myfx1, "6-yzir-lual", BusDef(\fx1)); // bass disto
	RandDelayNetwork(\default).make(\myfx1, "6-azig-1Ihl", BusDef(\fx1));
	RandDelayNetwork(\default).make(\myfx1, "5-baig-1Ihl", BusDef(\fx1)); // reso bass
	RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
	RandDelayNetwork(\default).make(\myfx1, "4-1aw9-3aaa", BusDef(\fx1)); // reverb
	RandDelayNetwork(\default).make(\myfx1, "4-1aw9-t5ta", BusDef(\fx1)); // clock + fxzoo3
	RandDelayNetwork(\default).make(\myfx1, "5-11e2-5bta", BusDef(\fx1)); // slow rise
	RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
	RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D159", BusDef(\fx1)); // steady feedback

	RandDelayNetwork(\default).make(\myfx1, "5-51E0-M5RH", BusDef(\fx1)); // good reverb
	RandDelayNetwork(\default).make(\myfx1, "5-9JJJ-77OP", BusDef(\fx1)); // good reverb + fxrev1
	RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C9", BusDef(\fx1)); // slow rise 2
	
		RandDelayNetwork(\default).make(\myfx1, "5--", BusDef(\fx1));
(
	Ndef(\myfx1).play;
	Tdef(\fx, {
		loop  {
			//Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i413", BusDef(\fx1)); // bass
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-lual", BusDef(\fx1)); // bass disto
			4.wait;
			
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D159", BusDef(\fx1)); // steady feedback
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C9", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;
		};

		nil;
	}).play;
	//Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
	//Ndef(\myfx1).put(100, \pset -> Pbind( \wet10, 0 ));
	Pdef(\main, 
		Pdef(\perc_p2)
	).play;
)
Ndef(\myfx1).put(100, \pset -> Pbind());
Ndef(\myfx1).put(100, nil);
Ndef(\myfx1).edit
Ndef(\myfx1).asParamGroup.getPbindCompileString

(
	Ndef(\myfx1).play;
	RandDelayNetwork(\default).make(\myfx1, "4-1aw9-t5ta", BusDef(\fx1)); // clock + fxzoo3
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
	//Ndef(\myfx1).put(100, \pset -> Pbind( \wet10, 0 ));
	Pdef(\main, Pdef(\perc_p2)).play;
)

(
	Ndef(\myfx1).play;
	RandDelayNetwork(\default).make(\myfx1, "5-51E0-M5RH", BusDef(\fx1)); // good reverb
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
	//Ndef(\myfx1).put(100, \pset -> Pbind( \wet10, 0 ));
	Pdef(\main, Pdef(\perc_p2)).play;
)

(
Pdef(\fxzoo1,

Pbind(  
        'inbus', Bus('audio', 20, 2, s),
        'wet10', 0.54444444444444,
        'pitchlag', 0.1,
		\dur, 1/4,
        'delay', 0.00023865897868586 ,
        'delay2', 0.0001,
        'shift', 0.0,
        'shift2', 0.0,
        'distamp', 5.0182662231547,
        'prelpf', 17000,
        'prehpf', 207.82446076703,
        'fb', 0.0090188931305119,
        'lpf', 14158.915687683,
        'hpf', 17,
        'pitchmix', 0.5,
        'plpf', 17000,
        'phpf', 17,
        'poamp', 0.11880182554415,
        'wet20', 1.0,
        'mamp', 1.8205642030261,
)

);
Pdef(\fxzoo2,

Pbind(  
        'inbus', Bus('audio', 20, 2, s),
        'wet10', 0.54444444444444,
        'pitchlag', 0.1,
		\dur, 1/4,
        'delay', 0.00023865897868586 ,
        'delay2', 0.0001,
        'shift', 0.0,
        'shift2', 0.0,
        'distamp', 5.0182662231547* Pseq([1,1/10,1,1],inf),
        'prelpf', 17000,
        'prehpf', 207.82446076703,
        'fb', 0.0090188931305119* Pseq([1,1,1,1, 1/100,2,1,1/10],inf).stutter(1),
        'lpf', 14158.915687683,
        'hpf', 17,
        'pitchmix', 0.5,
        'plpf', 17000,
        'phpf', 17,
        'poamp', 0.11880182554415,
        'wet20', 1.0,
        'mamp', 1.8205642030261,
)

);
Pdef(\fxzoo3,

Pbind(  
        'wet10', 0.54444444444444,
        'pitchlag', 0.1,
		\dur, 1/1,
        'delay', Pdict([
			0.000238656 ,
			0.001238656 ,
			0.000008656 ,
		], Pseq([1,1,0,1, 1,1,2,1],inf)),
		\delay, 
			0.00012386 ,
        'delay2', 0.0101,
        'shift', 0.0,
        'shift2', 0.0,
        'distamp', 5.0182662231547,
        'prelpf', 17000,
        'prehpf', 207.82446076703,
        'fb', 0.0000188931305119,
        'fb', 0.0090188931305119,
        'lpf', 14158.915687683,
        'hpf', 17,
        'pitchmix', 0.5,
        'plpf', 17000,
        'phpf', Pseq([500,17],inf).stutter(2),
        'poamp', 0.11880182554415,
        'wet20', 1.0,
        'mamp', 1.8205642030261,
)

);

Pdef(\fxrev1,
	Pbind(  
		'wet10', 0.53888888888889,
		'pitchlag', 0.1,
		'delay', 0.00081491274690207,
		'delay2', 0.1,
		'shift', 4.7777777777778,
		'shift2', 3.7222222222222,
		'distamp', 0.9189743006352,
		'prelpf', 17000,
		'prehpf', 207.82446076703,
		'fb', 0.013517530317881,
		'lpf', 14158.915687683,
		'hpf', 17,
		'pitchmix', 0.51666666666667,
		'plpf', 17000,
		'phpf', 17,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
	)
);
)
