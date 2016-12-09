
(

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

////////////// drumkit

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


///////////////// perc presets

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

////////////////////////////////////////// scores

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

Pdef(\perc_p2, 
		Ppar([
			Pdef(\kick_p2),
			Pdef(\snare_p2),
			Pdef(\hat_p2),

		])
);

///////////

Pdef(\perc_scar1, (
	Ppar([

		// small kick
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			//\amp, Pkey(\amp) * 4/5,
			\timeScale, 3/4,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// kick
		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// snare 1
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// snarehat
		Pbind(
			\instrument, \basicsnare2,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 1/2,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// hat
		Pbind(
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
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


Pdef(\perc_scar2, (
	Ppar([

		// small kick
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 4/5,
			//\timeScale, 1/4,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// kick
		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0.2,0, 0.2,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0.9,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0.5,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0.5,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// snare 1
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// snarehat
		Pbind(
			\instrument, \basicsnare2,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 1/2,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// hat
		Pbind(
			\isRest, Pseq([
				Pseq([
					0,0,0.1,0, 0.4,0,0,0,
					0.2,0,0.1,0, 1,0,0,0,
				],6),
				Prand([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],1),
					Pseq([
						1,0,0,1, 0,0,1,0,
					],1),
					Pseq([
						1,0,0,1, 0,0,1,0,
					],1),
					Pseq([
						1,0,1,0, 1,0,1,0,
					],1),
					Pseq([
						1,1,1,0, 1,0,1,0,
					],1),
				],2),
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,4,1,
				1,1,1,1, 1,1,1,1,
				Plazy({
					Prand([
						Pseq([1,1,1,1, 1,1,1,1/4].scramble),
						Pseq([1,1,1,1, 1,1,1,4].scramble)
					],1)
				}),
			],inf).stutter(1)/13 * Pseq([
				1.0,0.7,0.9,0.5,
			],inf).stutter(2),
			\dur, 1/4,
		)
		<>
		Pdef(\hat)
	])
));

Pdef(\perc_scar3, (
	Ppar([

		// small kick
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 4/5,
			//\timeScale, 1/4,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// kick
		Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\kick),

		// snare 1
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

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// snarehat
		Pbind(
			\instrument, \basicsnare2,
			\sustain, 1,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, Pkey(\amp) * 1/2,
			\dur, 1/4,
		)
		<>
		Pdef(\basicsnare),

		// hat
		Pbind(
			\isRest, Pseq([
				//1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
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

/////////////////////////////////// fx presets

Pdef(\fxzoo_default_args, 
	Pbind(
		\fbdistmix, 1,
		\fbdistamp, 1,
	)
);

Pdef(\fxzoo1,

	Pbind(  
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
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
	).keep(1)
	<>
	Pdef(\fxzoo_default_args)

);
Pdef(\fxzoo2,

	Pbind(  
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
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
	)
	<>
	Pdef(\fxzoo_default_args)

);
Pdef(\fxzoo3,

	Pbind(  
		'wet10', 0.54444444444444,
		'pitchlag', 0.1,
		\dur, 1/1,
		\delay, 0.00012386 ,
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
		'postlpf', 17000,
		'posthpf', Pseq([500,17],inf).stutter(2),
		'wetamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
	)
	<>
	Pdef(\fxzoo_default_args)

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
		'distmix', 1,
		'prelpf', 17000,
		'prehpf', 207.82446076703,
		'fb', 0.013517530317881,
		'lpf', 14158.915687683,
		'hpf', 17,
		'pitchmix', 0.51666666666667,
		'postlpf', 17000,
		'posthpf', 17,
		'wetamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
	).keep(1)
);

Pdef(\fx_fast1, 
	Pbind(  
		'wet10', 0.54444444444444,
		'pitchlag', 1.0,
		'delay', 0.00014307229891938,
		'delay2', 0.00056958108107377,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 5.3637122991511,
		'prelpf', 12144.04391382,
		'prehpf', 20.0,
		'fb', 0.050357680118343,
		'lpf', 14158.915687683,
		'hpf', 20.0,
		'pitchmix', 0.53333333333333,
		'plpf', 17000,
		'phpf', 17,
		'wetamp', 0.057120705093586,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
	).keep(1)
);

); // end block

(
	Tdef(\fx, {
		//s.latency.wait;
		1.do  {
		//// intro
			"sec intro".postln;
			Ndef(\myfx1).play;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
			RandDelayNetwork(\default).make(\myfx1, "4-1aw9-t5ta", BusDef(\fx1)); // clock + fxzoo3
			( 24-s.latency ).wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-11e2-5bta", BusDef(\fx1)); // slow rise
			8.wait;

		//////////////////////////////////////////// sec 1
			"sec 1".postln;
			//// part 1
			// B

			//Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i413", BusDef(\fx1)); // bass
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-lual", BusDef(\fx1)); // bass disto
			4.wait;

			//// part 2
			// BB
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D159", BusDef(\fx1)); // steady feedback
			(32+24).wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C9", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;

			//// part 2b
			// B
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D058", BusDef(\fx1)); // steady feedback
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C8", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;

			//// part 2c
			// B
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D057", BusDef(\fx1)); // steady feedback
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C7", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;

			//// part reverb
			// B

			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Pdef(\hat).set(\out, BusDef(\fx1));
			RandDelayNetwork(\default).make(\myfx1, "5-51E0-M5RH", BusDef(\fx1)); // good reverb
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
			8.wait;
			Pdef(\hat).set(\out, 0);

		////////////////////////////////////////////// sec rest
			"sec rest".postln;
			//// part 1
			// BB

			Ndef(\myfx1).put(100, \pset -> ( Pbind(\fb, Pkey(\fb) * 041) <> Pdef(\fxrev1) ));
			RandDelayNetwork(\default).make(\myfx1, "5-a3lo-4358", BusDef(\fx1)); // steady feedback
			( 32+24 ).wait;
			Pdef(\hat).set(\out, BusDef(\fx1));
			Pdef(\hat).play;
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-lual", BusDef(\fx1)); // bass disto
			4.wait;
			//Pdef(\hat).set(\out, 0);
			//Pdef(\hat).stop;

			// BB
			Ndef(\myfx1).put(100, \pset -> ( Pbind(\fb, Pkey(\fb) * 041) <> Pdef(\fxrev1) ));
			RandDelayNetwork(\default).make(\myfx1, "5-a3lo-4357", BusDef(\fx1)); // steady feedback
			( 32+24 ).wait;
			Pdef(\hat).set(\out, BusDef(\fx1));
			Pdef(\hat).play;
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugk7", BusDef(\fx1)); // calm
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-lua7", BusDef(\fx1)); // bass disto
			4.wait;
			Pdef(\hat).set(\out, 0);
			Pdef(\hat).stop;

		//////////////////////////////////////////// sec 3
			"sec 3".postln;

			//// part 3
			
			// BB
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			(32+24).wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 3c
			
			// B
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-11ek-71ta", BusDef(\fx1)); 
			(24).wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 3b
			
			// B
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bt1", BusDef(\fx1)); // feedback
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 3d
			
			// B
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-e1ek-71ta", BusDef(\fx1)); 
			(24).wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 1b
			// B

			//Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-u1kl", BusDef(\fx1)); // calm
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i113", BusDef(\fx1)); // bass
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-l1al", BusDef(\fx1)); // bass disto
			4.wait;

		//////////////////////////////////////////////////////// REPEAT
			"/////////////// REPEAT".debug;
		//////////////////////////////////////////// sec 1
			"sec 1".postln;
			//// part 1

			//Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i413", BusDef(\fx1)); // bass
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-lual", BusDef(\fx1)); // bass disto
			4.wait;

			//// part 2
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D159", BusDef(\fx1)); // steady feedback
			(32+24).wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C9", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;

			//// part 2b
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D058", BusDef(\fx1)); // steady feedback
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C8", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;

			//// part 2c
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-NFD0-D057", BusDef(\fx1)); // steady feedback
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "5-C4RC-H6C7", BusDef(\fx1)); // slow rise 2
			4.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			4.wait;

			//// part reverb
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Pdef(\hat).set(\out, BusDef(\fx1));
			RandDelayNetwork(\default).make(\myfx1, "5-51E0-M5RH", BusDef(\fx1)); // good reverb
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
			8.wait;
			Pdef(\hat).set(\out, 0);

		////////////////////////////////////////////// sec rest
			"sec rest".postln;
			//// part 1

			Ndef(\myfx1).put(100, \pset -> ( Pbind(\fb, Pkey(\fb) * 041) <> Pdef(\fxrev1) ));
			RandDelayNetwork(\default).make(\myfx1, "5-a3lo-4358", BusDef(\fx1)); // steady feedback
			( 32+24 ).wait;
			Pdef(\hat).set(\out, BusDef(\fx1));
			Pdef(\hat).play;
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugkl", BusDef(\fx1)); // calm
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-lual", BusDef(\fx1)); // bass disto
			4.wait;
			//Pdef(\hat).set(\out, 0);
			//Pdef(\hat).stop;

			Ndef(\myfx1).put(100, \pset -> ( Pbind(\fb, Pkey(\fb) * 041) <> Pdef(\fxrev1) ));
			RandDelayNetwork(\default).make(\myfx1, "5-a3lo-4357", BusDef(\fx1)); // steady feedback
			( 32+24 ).wait;
			Pdef(\hat).set(\out, BusDef(\fx1));
			Pdef(\hat).play;
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-ugk7", BusDef(\fx1)); // calm
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-lua7", BusDef(\fx1)); // bass disto
			4.wait;
			Pdef(\hat).set(\out, 0);
			Pdef(\hat).stop;

		//////////////////////////////////////////// sec 3
			"sec 3".postln;

			//// part 3
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			(32+24).wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 3d
			
			// B
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-e1ek-ccba", BusDef(\fx1)); 
			(24).wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;


			//// part 3b
			
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bt1", BusDef(\fx1)); // feedback
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 3c
			
			// B
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			//RandDelayNetwork(\default).make(\myfx1, "5-baig-0Ihl", BusDef(\fx1)); // reso bass 2
			RandDelayNetwork(\default).make(\myfx1, "5-diil-ccba", BusDef(\fx1)); 
			(24).wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			8.wait;

			//// part 1b

			//Ndef(\myfx1).put(100, \pset -> Pdef(\fxrev1));
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "6-bzir-u1kl", BusDef(\fx1)); // calm
			24.wait;
			RandDelayNetwork(\default).make(\myfx1, "6-gi1n-i113", BusDef(\fx1)); // bass
			4.wait;
			//RandDelayNetwork(\default).make(\myfx1, "5-41e2-5bta", BusDef(\fx1)); // feedback
			RandDelayNetwork(\default).make(\myfx1, "6-yzir-l1al", BusDef(\fx1)); // bass disto
			4.wait;

		//////////////////////////////////////////// outro
			"sec outro".postln;
			//// outro

			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
			RandDelayNetwork(\default).make(\myfx1, "5-11e2-5bta", BusDef(\fx1)); // slow rise
			24.wait;
			Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo3));
			RandDelayNetwork(\default).make(\myfx1, "4-1aw9-t5ta", BusDef(\fx1)); // clock + fxzoo3
			8.wait;
			Ndef(\myfx1).put(100, nil);
			Pdef(\hat).stop;
		};
		//Ndef(\myfx1).stop(5);

		nil;
	});
	//Ndef(\myfx1).put(100, \pset -> Pdef(\fxzoo1));
	//Ndef(\myfx1).put(100, \pset -> Pbind( \wet10, 0 ));
	Pdef(\archeo, 
		Pseq([
			Pfindur(32,
				Pdef(\perc_p2)
			),
			// sec 1
			Pfindur(6 * 32,
				Pdef(\perc_scar2)
			),
			// sec rest
			Rest(32*4),
			// sec 3
			Pfindur(6 * 32,
				Pdef(\perc_scar2)
			),

			// REPEAT

			Pfindur(6 * 32,
				Pdef(\perc_scar2)
			),
			// sec rest
			Rest(4*32),
			// sec 3
			Pfindur(6 * 32,
				Pdef(\perc_scar2)
			),
			// outro
			Pfindur(32,
				Pdef(\perc_p2)
			),
		],1);
	);
);
