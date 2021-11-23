~endt = 115/4/60; TempoClock.default.tempo = ~t;

(
Ndef(\jupiter, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num=100;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = LFNoise1.kr(1/9).range(0.1,0.9);
	lfo2 = LFNoise1.kr(1/9).range(0.1,0.9);
	lfo3 = LFNoise1.kr(1/19).exprange(0.01,0.9);
	lfo4 = Duty.kr(Dseq([1,0.7,0.9,0.4],inf)*2, 0, Dseq([
		Drand([
			Dseq([1,2],2),
			Dseq([1],40),
			Dseq([lfo3],20),
			Dseq([1,0],7),
			Dseq([
				1,1,1,1,
				0,0,0,0,
				Dseq([lfo3],4),
			],4),
		],1),
	],inf)).lag(2);
	sig = LFSaw.ar(LFNoise1.kr(1/1122!num).exprange(50,18000) * ( SinOsc.ar( LFNoise1.kr(1/222!num).exprange(100.01,18000.0) * lfo4 ) * LFNoise1.kr(1/332!num).exprange(0.01,1.0) + 1 ));
	sig = RLPF.ar(sig,LFNoise1.kr(1/222!num).exprange(100.01,18000.0)  , lfo1);
	sig = BPF.ar(sig, Amplitude.kr(sig).lag(0.2).rotate(1).linexp(0,2,50,17000), lfo2);
	sig = sig * ( LFNoise1.kr(8) * 1 + 1 );
	pan = pan + LFNoise1.kr(1/432!sig.size).range(-1.0,1.0);
	sig = Pan2.ar(sig, pan, amp).mean * 8;
	sig = AllpassL.ar(sig, 1/2, 1/2,1) + sig;
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.4), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * 3;
	sig.debug("sig");
}).play;
);
Ndef(\jupiter).fadeTime = 4
Ndef(\jupiter).stop(4)
Ndef(\jupiter).play(BusDef(\sendbus3,\audio).index,2)



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 34.midicps, 34.midicps/2], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,0,0,
				],8+4),
				Pseq([
					1,0,0,0, 1,0,1,1,
				],32),
				Pseq([
					1,0,0,0, 0,0,0,0,
				],8),
				//1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
		),
		Psched(0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[56].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\bufnum, 
			Pseq([
				Pser([
					~buflib.drum[55].value,
				],inf),
				Pser([
					~buflib.drum[56].value,
				],1),
				Pser([
					~buflib.drum[55].value,
					~buflib.drum[56].value,
				],4),
				Pser([
					~buflib.drum[56].value,
				],4),
			],inf),
			\isRest, Pseq([
				0,1,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\isRest, Pseq([
				//0,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,1,1,
				0,0.71,1,1, 1,0.71,1,0, 0,0,0,0.51, 1,0,1,1,
			],inf).coin.not,
			\speed, Pseq([
				Pser([
					1,0.9778,
					1,
				],8),
				Pser([1],8),
			],inf),
			\legato, 1.2,
			\dur, 1/16,
			\gain, 0.3 * Pseq([
				Pser([
					Pexprand(0.6,0.9,1),
					Pexprand(0.2,0.9,1),
				],12),
				Pexprand(0.6,0.9,4),
			],inf),
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\out, BusDef(\sendbus2, \audio),
		)),
		Psched(0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\bufnum, ~buflib.snare[2407].value,
			\bufnum, ~buflib.snare[1652].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,0,
			],inf).coin.not,
			\speed, Pseq([0.95,1],inf).stutter(4),
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus2, \audio),
		)),
	])
)).play;
);
~swing = 0.6

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([

		Pbind(
			\instrument, \bilin,
			\note, Pseq([
				[0,4,7],
				[-2+12,2,7],
				[-3+12,2,5],
				[-3+12,0,4],
			].collect({ arg x;
				( x ++ [ ( x+12 ).choose ] ++ [ ( x-12 ).choose ] ).flat;
			}),inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
					[ { 0.02.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, 0.005,
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,1.1) ],
			],inf),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);
