~t = 185/4/60; TempoClock.default.tempo = ~t;

(
Ndef(\full, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), Impulse.kr(1*~t));
	mod1 = Duty.kr(1/~t, 0, Dseq([
		Dseq([
			9,
		],8),
		1,0,0,0,
	],inf)).midiratio * 200;
	mod2 = XLine.kr(0.1,200,20);
	mod2 = 0;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	sig = SinOsc.ar(mod1 * ( SinOsc.ar(70*(19..40)*6+mod2) * 1 + 1 ));
	sig = Ringz.ar( sig, SinOsc.kr(exprand(0.0001,0.51!10), rrand(0.1,2!10)).exprange(20,19900), 0.1  ) * 0.5;
	//sig = sig * EnvGen.kr(Env([0,1,0],[0.1,0.8]), Impulse.kr(1*~t));
	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) * env1 ) + sig;
		isig = DelayL.ar(isig, 1,rrand(1/19000, 1/2000).debug("del") * ( SinOsc.kr(rrand(0.001,0.1)) * 1 + 1 ));
		isig = DelayL.ar(isig, 1,rrand(1/19000, 1/2000).debug("del") * ( SinOsc.kr(rrand(0.001,0.1)) * 1 + 1 )) + isig;
		isig = DelayL.ar(isig, 1,rrand(1/19000, 1/2000).debug("del") * ( SinOsc.kr(rrand(0.001,0.1)) * 1 + 1 )) + isig;
	
		isig = Limiter.ar(isig);
		isig;
	};
	sig = ( sig /2 ).softclip * 4;
	sig = LPF.ar(sig, 19000) * 4;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play(BusDef(\fx1, \audio).index, 2);
);

ProtoDef(\rdn).edit


(
Ndef(\full, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
	])
)).play;
)
