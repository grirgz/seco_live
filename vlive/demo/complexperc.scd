

(
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
	son = son + DelayC.ar(son, 0.01,\delay.kr(0.0001)) / 2;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).store;

SynthDef(\zhat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\zsnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(\oscfenv.kr(Env([400,150,151],[0.01,0.08])), 1, levelScale:\oscfenvls.kr(1)) );
	osc = osc * EnvGen.kr(\oscaenv.kr(Env([0,1,0],[0.001,0.20], -4)), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, \oschpf.kr(180));

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(\lpenv.kr(Env([14700,4852,3451],[0.01,0.1])), 1, levelScale:\lpenvls.kr(1)));
	snare = HPF.ar(snare, EnvGen.ar(\hpenv.kr(Env([9700,4452,3451],[0.01,0.1])), 1, levelScale:\hpenvls.kr(1)));
	snare = snare * EnvGen.kr(\snareenv.kr(Env([0,1,0],[0.001,0.18], -2)), 1);

	sig = click + osc + snare;

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.4)),gate,doneAction:2);

	sig = sig + DelayC.ar(sig, 0.01,\delay.kr(0.0001)) / 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\zsnarehat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
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


Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		1,0,1,0, 0,0,1,0,
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		1,0,0,1, 0,0,0,0,
		1,1,0,0, 0,0,0,1,
	],inf).coin.not,
	\amp, 0.15
));

Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\sustain, 0.1,
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
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
	\amp, 0.2
));

Pdef(\snarehat, Pbind(
	\instrument, \zsnarehat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
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
	\amp, 0.1
));

)

(
)

// complex

(

	~kick_mut = {
		Pbind(
			\instrument, \zkick,
			\env1, Pseq([
				[
					[ Env.new([rrand(50,100), rrand(35,50), rrand(30,40)], [0.055, exprand(0.1,0.3)], [-4, -5]) ],
				].choose
			],inf),
			\env0, Pseq([
				 [
					[ Env.new([0, 1, exprand(0.3,0.8),0], [exprand(0.01,0.03), exprand(0.01,0.3),exprand(0.01,0.3)], [-4, -5]) ],
				].choose
			],inf),
			\degree, Pseq([0],inf),
			\dur, 1/8,
			\delay, exprand(0.00001,0.002),
			\isRest, Pseq({[
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			].clump(8).debug("jk").choose.debug("lk")}.dup(4).debug("az").flat,inf).coin.not,
			\amp, 0.15
		);
	};
	~hat_mut = {
		Pbind(
			\instrument, \zhat,
			\degree, Pseq([0],inf),
			\dur, [1/16,1/8,1/4,1/8].choose,
			\rel, exprand(0.051,0.25),
			\hpf, exprand(100,10000)/2,
			\lpf, exprand(1000,15000),
			\isRest, Pseq({[
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,1,1,0,
				0,1,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,0, 0,1,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				1,1,1,0, 1,0,0,0,
				0,0,0,0, 1,1,1,1,
			].clump(8).debug("jk").choose.debug("lk")}.dup(4).debug("az").flat,inf).coin.not,

			\amp, 0.1/8,
		);
	};
	~snare_mut = {
		Pbind(
			\instrument, \zsnare,
			\degree, Pseq([0],inf),
			\dur, 1/8,
			\sustain, exprand(0.1,0.4),
			\oscfenvls, exprand(0.4,1.2),
			\snareenv, [
				Env([0,1,0],[0.01,exprand(0.01,0.4)]);
			],
			\hpenvls, exprand(0.5,1.2),
			\lpenvls, exprand(0.1,1.2),
			\delay, exprand(0.00001,0.002),
			\amp, 0.2,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0.51,0,
				0,0,0,0, 1,0,0.51,0,
				0,0,0,0.5, 1,0,0,0,
				0,0,0,0, 1,0,0,0.5,
				0,0.51,0,0, 1,0,0,0,
			].clump(8).choose}.dup(4).flat,inf).coin.not,

		);
	};
	~t = 185/4/60; TempoClock.default.tempo = ~t;
	Pdef(\main, 
		Pbind(\out, BusDef(\fx1, \audio)) <>
		Plazy({

			Pseq([
				Pfindur(7,Ppar([
					3.collect({~kick_mut.value}),
					3.collect({~snare_mut.value}),
					1.collect({~hat_mut.value}),
				].flat)),
				Pfindur(1,Ppar([
					4.collect({~kick_mut.value}),
					4.collect({~hat_mut.value}),
				].flat)),
				Pfindur(7,Ppar([
					4.collect({~kick_mut.value}),
					4.collect({~snare_mut.value}),
					1.collect({~hat_mut.value}),
				].flat)),
				Pfindur(1,Ppar([
					4.collect({~kick_mut.value}),
					4.collect({~hat_mut.value}),
				].flat)),
			],1)
		}).loop(2)
	).play;
)

ProtoDef(\rdn).edit
