/// integrate rdn sound back by using simple fx

~t = 185/4/60; TempoClock.default.tempo = ~t;

(
// from vin10
// dry
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,

					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,0,1,
					1,1,1,0, 0,0,0,0,

				Pseq([
					1,0,0,0, 0,0,0,0,
					
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.3,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1064].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		
	])
)).play;
);

(
// try to replicate this arbitrary rdn
ProtoDef('rdn').make('deldefault', 'rdn', "5-TLBS-28SS", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.40336134453782,
	'fb', 0.0,
	'delay', 0.0,
	'delay2', 0.0,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.99037192233053,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);
(
// with rdn
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\sendbus1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
			
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
			
					Pseq([
						1,0,0,0, 0,0,0,0,
			
					],4),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		]),

		
	])
)).play;
);

(
// with simple dist
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\distfx, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
			
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
			
					Pseq([
						1,0,0,0, 0,0,0,0,
			
					],4),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		]),
		Pmono(\fxsomedist,
			\inbus, BusDef(\distfx, \audio),
			\addAction, \addToTail,
			\preamp, 300,
			\postamp, 1/300 * 18,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert

(
SynthDef(\fxsomedist, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = ( sig * \preamp.kr(1) ).tanh * \postamp.kr(0.3);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fxsomedist, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig, isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig1 = ( isig * \preamp.kr(1) ).tanh * \postamp.kr(0.3);
		isig = SelectX.ar(\distmix.kr(0.96), [isig, isig1]);
		//isig = LPF.ar(isig, 10000);
		//isig = Limiter.ar(isig);
		isig;
	});
	sig = LPF.ar(sig, 5000);
	sig = Limiter.ar(sig);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// with fb dist
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\distfx, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
			
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
			
					Pseq([
						1,0,0,0, 0,0,0,0,
			
					],4),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1719].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		]),
		Pmono(\fxsomedist,
			\inbus, BusDef(\distfx, \audio),
			\addAction, \addToTail,
			\preamp, 1800,
			\fb, 0.01,
			\postamp, 1/300 * 8,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);

(
// lpf inside
SynthDef(\fxsomedist, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig, isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig1 = ( isig * \preamp.kr(1) ).tanh * \postamp.kr(0.3);
		isig = SelectX.ar(\distmix.kr(0.96), [isig, isig1]);
		isig = LPF.ar(isig, 1000);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = LPF.ar(sig, 5000);
	sig = Limiter.ar(sig);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// only kick
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\distfx, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
			
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
			
					Pseq([
						1,0,0,0, 0,0,0,0,
			
					],4),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
		]),
		Pmono(\fxsomedist,
			\inbus, BusDef(\distfx, \audio),
			\addAction, \addToTail,
			\preamp, 18,
			\fb, 0.9,
			\postamp, 1/8,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);

(
// lpf by amplitude
SynthDef(\fxsomedist, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig, isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig1 = ( isig * \preamp.kr(1) ).tanh * \postamp.kr(0.3);
		isig = SelectX.ar(\distmix.kr(0.96), [isig, isig1]);
		isig = DelayL.ar(isig, \maxdelay.kr(0.4), \delay.kr(0.001)) + isig;
		//isig = LPF.ar(isig, Amplitude.ar(isig).linlin(0,4,50,15000).lag(1));
		isig = Limiter.ar(isig);
		isig;
	});
	sig = LPF.ar(sig, 5000);
	sig = Limiter.ar(sig);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// add a delay
SynthDef(\fxsomedist, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig, isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		isig1 = ( isig * \preamp.kr(1) ).clip2 * \postamp.kr(0.3);
		isig = SelectX.ar(\distmix.kr(0.96), [isig, isig1]);
		isig = DelayL.ar(isig, \maxdelay.kr(0.4), 0.001) + isig;
		isig = DelayL.ar(isig, \maxdelay.kr(0.4), 0.00002) + isig;
		isig = DelayL.ar(isig, \maxdelay.kr(0.4), 0.0003) + isig;
		//isig = LPF.ar(isig, Amplitude.ar(isig).linlin(0,4,50,15000).lag(1));
		isig = Limiter.ar(isig);
		isig;
	});
	//sig = LPF.ar(sig, 5000);
	sig = Limiter.ar(sig, 0.1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// only kick
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\distfx, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
			
						1,0,0,0, 0,0,0,1,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,1,
						1,1,1,0, 0,0,0,0,
			
					Pseq([
						1,0,0,0, 0,0,0,0,
			
					],4),
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1010].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.3,
				\isRest, true,
			),
		]),
		Pmono(\fxsomedist,
			\inbus, BusDef(\distfx, \audio),
			\addAction, \addToTail,
			\preamp, 14,
			\fb, 0.09,
			\postamp, 1/4,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
		),

		
	])
)).play;
);
