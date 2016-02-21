

(
TempoClock.default.tempo = 190/60;
Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;
~t = TempoClock.default.tempo;

Spec.add(\fb, ControlSpec(0.0001,0.9,\exp));
Spec.add(\lpf, \freq.asSpec);
Spec.add(\hpf, \freq.asSpec);
Spec.add(\plpf, \freq.asSpec);
Spec.add(\phpf, \freq.asSpec);
Spec.add(\prelpf, \freq.asSpec);
Spec.add(\prehpf, \freq.asSpec);
Spec.add(\delay2, \delay.asSpec);
Spec.add(\shift, ControlSpec(-5,5,\lin));
Spec.add(\shift2, \shift.asSpec);
Spec.add(\pitchmix, \unipolar.asSpec);
Spec.add(\pitchlag, ControlSpec(0.001,1,\exp));

Spec.add(\wet10, \unipolar.asSpec);
Spec.add(\wet20, \unipolar.asSpec);
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
);

(
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
		],inf).coin.not,
		\dur, 1/2,
	)
	<>
	Pdef(\kick)
));
Pdef(\snare_p4, (
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

RandDelayNetwork(\default).make(\myfx1, "5-EQP1-S013", BusDef(\fx1));
)
RandDelayNetwork(\default).make(\myfx1, "5--", BusDef(\fx1));
RandDelayNetwork(\default).code

Ndef(\myfx1).asParamGroup.getPbindCompileString


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

)

Pdef(\hat_p1).play
Ndef(\myfx1).play;
Ndef(\myfx1).put(100, \pset -> Pdef(\fxp1));
Ndef(\myfx1).edit
Ndef(\myfx1).put(100, nil);

(
	Ndef(\myfx1).play;
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxp1));
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
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxp2));
	Pdef(\main, 
		Ppar([
			Pdef(\kick_p2),
			Pdef(\snare_p2),
			Pdef(\hat_p2),

		])
	).play;
)
(
	Ndef(\myfx1).play;
	//Ndef(\myfx1).put(100, \pset -> Pdef(\fxp5));
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
	Ndef(\myfx1).put(100, \pset -> Pdef(\fxp1));
	Pdef(\main, 
		Ppar([
			Pdef(\kick_p5),
			Pdef(\snare_p5),
			Pdef(\hat_p5),

		])
	).play;
)

