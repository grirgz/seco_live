
(
TempoClock.default.tempo = 190/60;
Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;
~t = TempoClock.default.tempo;

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
)).play;
);

(
Pdef(\basicsnare, Pbind(
	\instrument, \sossnare,
	\degree, Pseq([0],inf),
	\dur, 2,
	\amp, 0.1
)).play;
);

(
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
	\amp, 0.15
)).play;
);

(
Pdef(\hat, Pbind(
	\instrument, \hat2,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,

	\amp, 0.1/8,
)).play;
);

(
Pdef(\kick).play;
Pdef(\basicsnare).play;
)

(
Ndef(\myfx1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del;
	var inamp;
	sig = in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	inamp = Amplitude.ar(in);
	//sig = sig * SinOsc.ar(freq);

	sig1 = LocalIn.ar(2) * 0.1;
	sig = sig + sig1;

	//sig = AllpassL.ar(sig, 1, ( in+1*4.10 + [0.21,0.2,0.201,0.23] * 0.03 ).poll,0).mean + sig;
	//sig = AllpassL.ar(sig, 1, ( in + 1  /14!2).poll,0).mean + sig;
	//sig = AllpassL.ar(sig, 1, ( in + 1  /48!2).poll,0).mean + sig;
	del= 114.1 * LagUD.ar(3-inamp, 0,1);
	del.poll;
	sig = sig + DelayL.ar(sig, 1, 0.0001 * del);
	sig = sig + DelayL.ar(sig, 1, 0.00011 * del);
	sig = sig + DelayL.ar(sig, 1, 0.000111 * del);
	//sig = FreqShift.ar(sig, in) + sig / 2;
	//sig = AllpassL.ar(sig, 1/~t,1/2/~t,0) + sig;
	//sig = sig + sig.tanh / 2;
	//sig = sig.tanh;
	//sig = Compander.ar(sig, sig, \compt.kr(0.4), \complo.kr(1.700), \comphi.kr(0) );
	sig = LeakDC.ar(sig);
	sig = Limiter.ar(sig);
	//sig = HPF.ar(sig, 200);
	//sig = LPF.ar(sig, 5000);
	LocalOut.ar(sig);
	sig = sig * 1/18;
	//sig = sig * LagUD.ar(Amplitude.ar(in)*4, 0,4);
	sig = SelectX.ar(\mix.kr(1.0), [in, sig]);
}).play;
);
1/~t

(
SynthDef(\pierre, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpf.kr(7000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\def, Pbind(
	\instrument, \pierre,
	\degree, Pseg(Pseq([2,0,1,-2],inf),1),
	\scale, Scale.minor,
	\octave, Prand([4,5,6,3],inf).stutter(4),
	\lpf, 1000,
	\dur, 2/1 * Pstep(Pseq([1,1/16],inf),8),
	\isRest, Pseq([
		1,1,1,0, 1,0,1,1,
		1,0,0,0, 0,1,0,0,
		1,0,1,0, 1,0,0,1,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,
	\legato, 0.47 * Pseq([
		1,1,1,2,
	],inf),
	\out, BusDef(\fx1),
	\amp, 0.1
)).play;
);
Pdef(\def).stop

(
Ndef(\myfx1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del;
	var inamp;
	sig = in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	inamp = Amplitude.ar(in);
	//sig = sig * SinOsc.ar(freq);

	sig1 = LocalIn.ar(2) * \fb.kr(0.01);
	sig = sig + sig1;

	//sig = AllpassL.ar(sig, 1, ( in+1*4.10 + [0.21,0.2,0.201,0.23] * 0.03 ).poll,0).mean + sig;
	//sig = AllpassL.ar(sig, 1, ( in + 1  /14!2).poll,0).mean + sig;
	//sig = AllpassL.ar(sig, 1, ( in + 1  /48!2).poll,0).mean + sig;
	sig = RandDelayNetwork.ar(sig, "4--");
	//sig = FreqShift.ar(sig, in) + sig / 2;
	//sig = AllpassL.ar(sig, 1/~t,1/2/~t,0) + sig;
	//sig = sig + sig.tanh / 2;
	//sig = sig.tanh;
	//sig = Compander.ar(sig, sig, \compt.kr(0.4), \complo.kr(1.700), \comphi.kr(0) );
	sig = LeakDC.ar(sig);
	sig = Limiter.ar(sig);
	//sig = HPF.ar(sig, 200);
	//sig = LPF.ar(sig, 5000);
	LocalOut.ar(sig);
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1/1);
	//sig = sig * LagUD.ar(Amplitude.ar(in)*4, 0,4);
	sig = SelectX.ar(\mix.kr(1.0), [in, sig]);
}).play;
);
	~mkrdn.(\myfx1, "4-R9RB-DCVB");
    ~mkrdn.(\myfx1, "4-34H7-JQC9").play;
    ~mkrdn.(\myfx1, "4--").play;
Ndef(\myfx1).edit
4-34H7-JQC9
BusDef(\fx1,  \audio,2)
Pdef(\kick).set(\out, BusDef(\fx1));
Pdef(\hat).set(\out, BusDef(\fx1));
Pdef(\hat).set(\out, 0);
Pdef(\hat).stop
(
Ndef(\myfx1).play;
Pdef(\kick).play;
Pdef(\basicsnare).play;
Pdef(\hat).play;
)


4-81DF-HDFQ
    ~mkrdn.(\myfx1, "4-81DF-HDFQ", BusDef(\fx1)).play;

	Ndef(\myfx1).asParamGroup.getPbindCompileString
	RandDelayNetwork(\default).code
	RandDelayNetwork(\default).make(\myfx1, "4-11aF-fDFQ").play
	Ndef(\myfx1).sources[1].value.asCompileString

(
Ndef(\myfx1).put(100, \pset ->
Pbind(
		'wet10', 0.45555555555556,
		'pitchlag', 0.1,
		'delay', 0.021544346900319,
		'delay2', 0.0001 * Pseq([1040.1,1,1,1, 10000, 1000,1,1000],inf).stutter(1),
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.1221184404165,
		'prelpf', 17000,
		'prehpf', 17,
		'fb', 0.006275055282164 * Pseq([0,1],inf).stutter(2),
		'lpf', 17000,
		'hpf', 17,
		'pitchmix', 0.5,
		'plpf', 17000,
		'phpf', 17,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
		'wetamp', 0.31192048005673,
		'mix', 0.46666666666667,
		\dur, 1,
));

)

(
Ndef(\myfx1).put(100, \pset ->
Pbind(
		'wet10', 0.45555555555556,
		'pitchlag', 0.1,
		'delay', 0.021544346900319,
		'delay2', 0.0001 * Pseq([1040.1,1],inf).stutter(2),
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.1221184404165,
		'prelpf', 17000,
		'prehpf', 17,
		'fb', 0.006275055282164 * Pseq([0,1],inf).stutter(2),
		'lpf', 17000,
		'hpf', 17,
		'pitchmix', 0.5,
		'plpf', 17000,
		'phpf', 17,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
		'wetamp', 0.31192048005673,
		'mix', 0.46666666666667,
		\dur, 1,
));

)
Ndef(\myfx1).put(100, nil)


(
Ndef(\myfx1).put(100, \pset ->
Pbind(
		'wet10', 0.45555555555556,
		'pitchlag', 0.1,
		'delay', 0.021544346900319,
		'delay2', 0.0001,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.1221184404165,
		'prelpf', 17000,
		'prehpf', 17,
		'fb', 0.006275055282164 * Pseq([0,1],inf).stutter(2),
		'lpf', 17000,
		'hpf', 1417 * Pseq([1,1/5,1/12],inf),
		'pitchmix', 0.5,
		'plpf', 17000,
		'phpf', 17,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
		'wetamp', 0.31192048005673,
		'mix', 0.46666666666667,
		\dur, 1/2,
));

)

(
Ndef(\myfx1).put(100, \pset ->
Pbind(
		'wet10', 0.45555555555556,
		'pitchlag', 0.1,
		'delay', 0.00014346900319,
		'delay2', 0.00041 * Pseq([1,1/10,1,1],inf).stutter(2)* Pseq([1,5.midiratio],inf).stutter(16),
		'shift', 0.00,
		'shift2', 0.0,
		'distamp', 1.1221184404165,
		'prelpf', 17000,
		'prehpf', 17,
		'fb', 0.01275055282164 * Pseq([1,1,1,1/10],inf).stutter(2) * Pseq([1,1/2],inf).stutter(16),
		'lpf', 17000,
		'hpf', 1417 * Pseq([1,1/5,1,1/12],inf).stutter(2),
		'pitchmix', 0.0,
		'plpf', 17000,
		'phpf', 17,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
		'wetamp', 0.31192048005673,
		'mix', 0.46666666666667,
		\dur, 1/2,
));

)

(
Ndef(\myfx1).put(100, \pset ->
Pbind(
		'wet10', 0.45555555555556,
		'pitchlag', 0.1,
		'delay', 0.011544346900319 * Pseq([1,1/8,1/16,1/1000],inf).stutter(8),
		'delay2', 0.001 * Pseq([1,1/10],inf).stutter(16),
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 1.1221184404165,
		'prelpf', 10000,
		'prehpf', 170,
		'fb', 0.006275055282164 * Pseq([0,1],inf).stutter(2),
		'lpf', 17000 * Pseq([1,1/10],inf).stutter(4),
		'hpf', 141 * Pseq([1,10,1/12,10],inf),
		'pitchmix', 0.5,
		'plpf', 17000,
		'phpf', 17,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
		'wetamp', 0.31192048005673,
		'mix', 0.46666666666667,
		\dur, 1,
));

)

(
Ndef(\myfx1).put(100, \pset ->
Pbind(
		'wet10', 0.45555555555556,
		'pitchlag', 4.1,
		'delay', 0.000044346900319 * Pseq([1,1000,1,1, 1,1,1,10000],inf),
		'delay2', 0.0001,
		'shift', 0,
		'shift2', 1.0,
		'distamp', 4.1221184404165,
		'prelpf', 17000,
		'prehpf', 17,
		'fb', 0.006275055282164 * Pseq([1,1,0.1,10],inf).stutter(4),
		'lpf', 1000,
		'hpf', 11,
		'pitchmix', 0.0,
		'plpf', 17000,
		'phpf', 17,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
		'wetamp', 0.31192048005673,
		'mix', 0.46666666666667,
		\dur, 1/2,
));

)

(
Ndef(\myfx1).put(100, \pset ->
Pbind(
		'wet10', 0.45555555555556,
		'pitchlag', 4.1,
		'delay', 0.000044346900319 * Pseq([1,1000,1,1, 1,1,1,10000],inf),
		\delay, 0.001,
		'delay2', 0.004,
		'shift', 0,
		'shift2', 1.0 * Pseq([1,0,0,0],inf),
		\shift2, 0,
		'distamp', 1.1221184404165,
		'prelpf', 17000,
		'prehpf', 17,
		'fb', 0.000275055282164 * Pseq([0.1,100,0.1,10],inf).stutter(4),
		'lpf', 1000 * Pseq([1,10,10,10],inf),
		\lpf, 17800,
		'hpf', 110,
		'pitchmix', 0.0,
		'plpf', 17000,
		'phpf', 17,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
		'wetamp', 0.31192048005673,
		'mix', 0.46666666666667,
		\dur, 1/2,
));

)

(
	RandDelayNetwork(\bet).dict = IdentityDictionary.newFrom([
		\delay, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		},
		\delay2, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		},
		\flanger, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		},
		\shift, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
		},
		\shift2, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
		},
		\bpf, { arg si;
			BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		},
		\brf, { arg si;
			BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		},
		\dist, { arg si;
			(si * 10.rand * \distamp.kr).tanh / 2;
		},
		\end, { arg si;
			si;
		}
	]);

	RandDelayNetwork(\bet).grow = { 
		var block, algo;
		block = [
			\flanger!4,
			\delay!8,
			\delay2!8,
			\bpf!2, 
			\brf!2,
			\shift!4,
			\shift2!4,
			\dist!2,
		].flatten.choose;
		algo = [
			\par, \seq
		].wchoose([0.1,0.9].normalizeSum);
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> ([block] ++ (\end ! [1,2].choose))
		}
	};
)



(
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
)

(
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
)

(
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
)

(
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
)

(
	
Pdef(\kick).stop;
Ndef(\myfx1).play;
Pdef(\basicsnare).stop;
Pdef(\hat).stop;
Pdef(\kick_p2).play;
Pdef(\snare_p2).play;
Pdef(\hat_p2).play;
)

(
	Ndef(\myfx1).play;
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
	Pdef(\main, 
		Ppar([
			Pdef(\kick_p5),
			Pdef(\snare_p5),
			Pdef(\hat_p5),

		])
	).play;
)

(
Ndef(\myfx1).put(100, \pset ->
Pbind(
		'wet10', 0.45555555555556,
		'pitchlag', 4.1,
		'delay', 0.000044346900319 * Pseq([1,1000,1,1, 1,1,1,10000],inf),
		'delay2', 0.0001,
		'shift', 0,
		'shift2', 1.0,
		'distamp', 4.1221184404165,
		'prelpf', 17000,
		'prehpf', 17,
		'fb', 0.006275055282164 * Pseq([10,1,0.1,10,100,100,100,100,1/10,1/10,1,1],inf).stutter(1),
		'lpf', 17000,
		'hpf', 11,
		'pitchmix', 0.0,
		'plpf', 17000,
		'phpf', 70,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
		'wetamp', 0.31192048005673,
		'mix', 0.46666666666667,
		\dur, 1/2,
));

)

(
Ndef(\myfx1).put(100, \pset ->
Pbind(
		'wet10', 0.45555555555556,
		'pitchlag', 4.1,
		'delay', 0.000044346900319 * Pseq([1,1000,1,1, 1,1,1,10000],inf),
		'delay2', 0.0001,
		'shift', 0,
		'shift2', 1.0,
		'distamp', 4.1221184404165,
		'prelpf', 17000,
		'prehpf', 17,
		'fb', 0.000775055282164 * Pseq([1,2],inf).stutter(1),
		'lpf', 17000,
		'hpf', 11,
		'pitchmix', 0.0,
		'plpf', 17000,
		'phpf', 70,
		'poamp', 0.11880182554415,
		'wet20', 1.0,
		'mamp', 1.8205642030261,
		'wetamp', 0.31192048005673,
		'mix', 0.46666666666667,
		\dur, 1/2,
));

)
