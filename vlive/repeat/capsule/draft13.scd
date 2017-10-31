(
SynthDef(\rono, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo = { 
		SinOsc.kr(rrand(0.01,(1..8)))
	};
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(lfo.().range(1,100)) * lfo.() )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\rono, 
	Pseq([
		Pmono(\rono,
			\freq, Pseq([
				200,1000,
			],inf),
			\dur, 1,
			\amp, 0.1,
		);
	])
).play;
);

(
SynthDef(\rono, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo = { 
		SinOsc.kr(rrand(0.01,(1..8))) * LFPulse.kr(2*~t).range(2,1);
	};
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(lfo.().range(1,100)) * lfo.() )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\rono, 
	Pseq([
		Pmono(\rono,
			\freq, Pseq([
				200,1000,
			],inf),
			\dur, 1,
			\amp, 0.1,
		);
	])
).play;
);

(
SynthDef(\rono2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo = { 
		SinOsc.kr(rrand(0.01,(1..8))/100)
	};
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(lfo.().range(1,100)) * lfo.() )));
	sig = sig * ( 1 + ( SinOsc.ar(lfo.()) * 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = CombL.ar(sig, 1/~t,1/~t,10/~t) + sig;

	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(2) ) + sig;
	
		isig = Limiter.ar(isig);
		isig;
	};

	sig = Pan2.ar(sig, pan, amp).mean;
	sig = HPF.ar(sig, 800);
	Out.ar(out, sig);
}).add;
Pdef(\rono, 
	Pseq([
		Pmono(\rono2,
			\freq, Pseq([
				Pseq([
					4200,1000,
				],6),
				10000,5000,
				500,600,
			],inf),
			\dur, PdurStutter(Pseq([1,4,2,8],inf), 2),
			\amp, 0.1,
		);
	])
).play;
);

Pdef(\rono).stop

ProtoDef(\rdn).edit
(
	~master.();
Pdef(\part, Pdef(\ronopart1,
	Ppar([

		Pbind(\out, BusDef(\sendbus1))<>Ppar([
			Pbind(
				\instrument, \snapkick,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
					1,1,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapclap,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],8*14),
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/1,
				\dur, 1/8,
				\amp, 0.28,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.1/2,
			),
			Pbind(
				\instrument, \snaretuned2,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],8*14),
						0,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\sustain, 0.1/4,
				\dur, 1/8,
				\amp, 0.04,
			),
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,1,1,0,
					1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,1, 1,0,1,0, 1,0,1,0,
					1,1,0,1, 1,0,1,0, 1,0,1,0, 1,0,1,1,
				],inf).coin.not,
				\sustain, Pseq([0.08,0.02],inf),
				\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
				\pan, Pseq([0.2,0.1,0,-0.1],inf),
				\fac1, Pseq([
					0.05,Pser([
						0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.04,
					],15),
					0.05,Pser([
						0.04, 0.74, 0.04, 0.04,  0.04, 0.04, 0.04, 0.04,
						0.04, 0.04, 0.04, 0.74,  0.04, 0.04, 0.04, 0.04,
					],15),
		
				],inf),
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (-0.08 * Pseq([-1,1],inf))),
				\pan, 0,
				\amp, 0.02,
			),
		Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
		
					0,0,0,0, 1,0,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0, 1,1,1,1, 0,1,0,0,
					0,0,0,0, 1,1,0,0, 1,1,1,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					0.1,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/16,
			\amp, 0.1,
		),
		]),
	])
)).play;
);
