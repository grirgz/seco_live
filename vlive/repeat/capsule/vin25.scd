
// album de 10 tracks d'ambiant en 10 minutes

~t = 185/4/60; TempoClock.default.tempo = ~t;

// track 1

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,1,0.1,0.1,1,1,0],[16,16,1,14,1,16,16]), 1);
	sig1 = CuspN.ar([200,2400,5000] * env1);
	sig2 = SinOsc.ar(200 * [0,3,7,12,12+3] * (CuspN.ar(0.1) * 0.3 + 1));
	sig2 = sig2 * EnvGen.kr(Env([0,1,0],[0.01,0.1]*env1*4), Dust.kr(4!( sig2.size ) * env1));

	sig3 = CuspN.ar([200,2400,5000] * CuspN.ar(1.1).range(1/2,2).lag(1));
	sig3 = BPF.ar(sig3, CuspN.ar(1,1).exprange(100,16500).lag(1), \rq.kr(0.5)) * 1;
	sig = sig1 + sig2 + sig3;
	pan = pan + LFNoise1.kr(0.1!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * env1;
}).play;
);

// track 2

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var size = 60;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([0,1,1,0.1,0.1,1,1,0],[16,16,1,14,1,16,16]), 1);
	env2 = SinOsc.ar( ExpRand(0.0001,0.1!size) ) * 10 * ( env1**5 );
	env3 = SinOsc.ar( ExpRand(0.0001,0.1) ) * 10 * ( env1**5 );
	sig = SinOsc.ar(ExpRand(80,12000!size) * ( SinOsc.ar( ExpRand(0.0001,0.01!size) * env2, ExpRand(0.0001,0.01!size) ) * SinOsc.ar( ExpRand(0.01,0.1!size)).unipolar + 1 ));
	sig = sig * SinOsc.kr(Rand(0.01,10!size)).range(0,1);
	pan = pan + SinOsc.ar(Rand(0.01,1!size)); 
	sig = Pan2.ar(sig, pan, amp).mean * 2;
	sig1 = CombL.ar([sig], 4/~t, SinOsc.ar(Rand(0.001,0.1!4) * ( SinOsc.kr( Rand(0.001,0.1!4) * env1 ) * 1 + 1 ) ).range(0.01,0.1) ,1);
	sig1.debug("sig1");
	sig = SelectX.ar(SinOsc.ar(Rand(0.01,1!4) * ( SinOsc.kr( Rand(0.01,1!4) * env1 ) * 1 + 1 ) ).range(0,1) * env1, [sig, sig1]);
	sig.debug("sig");
	sig = sig.mean;
	sig.debug("sigb");
	sig;
}).play;
);

// track 3

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFPulse.ar(50);
	sig1 = sig1 * LFPulse.kr(4, 0,SinOsc.ar(1).unipolar ).unipolar;
	sig2 = LFPulse.ar(60);
	sig2 = sig2 * LFPulse.kr(5, 0,SinOsc.ar(2).unipolar ).unipolar;
	sig3 = LFPulse.ar(70);
	sig3 = sig3 * LFPulse.kr(6, 0,SinOsc.ar(3).unipolar ).unipolar;
	sig = sig1 + sig2;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

// track 4

//////////////////// some sounds

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	],inf)).midiratio * freq;
	sig = SinOsc.ar(freq * [0,4,7].midiratio * 4);
	sig = Latch.ar(sig, Impulse.ar(1410 * ( SinOsc.kr(0.1 * [1,1.12]) * 0.01 + 1 )));
	sig = sig + Latch.ar(sig, Impulse.ar(720 * ( SinOsc.kr(0.0231 * [1,1.12]) * 0.01 + 1 )));
	sig = Pan2.ar(sig, pan + [-1,1], amp).mean;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
	],inf)).midiratio * freq * 8;
	sig = SinOsc.ar(freq * [0,4,7].midiratio).mean;
	sig = Latch.ar(sig, Impulse.ar(freq * ( SinOsc.kr(0.1 * [1,1.12]) * 0.01 + 1 )));
	sig = sig + Latch.ar(sig, Impulse.ar(freq * ( SinOsc.kr(0.0231 * [1,1.12]) * 0.01 + 1 )));
	sig = Pan2.ar(sig, pan + [-1,1], amp).mean;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,4,7,4,
	],inf)).midiratio * freq;
	sig = SinOsc.ar(freq * ( SinOsc.kr(1/~t * ( SinOsc.kr([1.01,1.02]/~t) * 1 + 1 )) * 1 + 1 ));
	sig = Pan2.ar(sig, pan + [-1,1], amp).mean;
}).play;
);

(
SynthDef(\osciboom, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, freqfac=( 2*~t );
	var sig;
	freq = Duty.kr(1/~t, 0, Dseq([
		0,4,7,4,
	],inf)).midiratio * freq;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freqfac * ( SinOsc.ar([1.01,1.02]*freqfac) * \fmamt2.kr(1) + 1 )) * \fmamt.kr(1) + 1 ));
	sig = Pan2.ar(sig, pan + [-1,1], amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([

			Pmono(
				 \osciboom,
				\degree, Pseq([0],inf),
				\dur, 1,
				\amp, 0.1,
			),
		])
	)).play;
);

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 8*~t,
				\octave, 6,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 2*~t,
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 4*~t,
				\octave, 4,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[16].value,
				\isRest, Pseq([
					1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		Pmono(\fx_sidechain,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\kickdel, \audio),
			\cpt, 0.01,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\kick, \audio),
			\out, BusDef(\kickdel, \audio),
			\delay, 0.04,
			\dur, 1,
		),
		Pbind(
			\lag, 0.04,
			\fmamt, ~pmodenv.(Pseq([0.01,2],inf), 8),
			\fmamt2, ~pmodenv.(Pseq([0.01,2],inf), 9),
			\out, BusDef(\comp, \audio),
		)<>
		Ppar([
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 8*~t,
				\octave, 6,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 4*~t,
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 2*~t,
				\octave, 4,
				\dur, 1,
				\amp, 0.1,
			),
		]),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[16].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
				\out, BusDef(\track1, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\track1),
				\pregain, 1,
				\postgain, 0,
				\delay, 0,
				\send0, 1,
				\sendbus0, BusDef(\kick, \audio, 2),
				\send1, 1,
				\sendbus1, BusDef(\sendbus1, \audio, 2),
				\dur, 1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[676].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[17].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,1,0,1,
					1,0,1,0, 1,0,1,0, 
					1,1,0,1, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.05,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2546].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		
	])
)).play;
);


// rdn play is really just adding chorus reverb and dist and playing with filter

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		Pmono(\fx_sidechain,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\kickdel, \audio),
			\cpt, 0.01,
			\pregain, 1,
			\cpabove, 0.5,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			//\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\kick, \audio),
			\out, BusDef(\kickdel, \audio),
			\delay, 0.04,
			\delay, 0,
			\dur, 1,
		),
		Pbind(
			//\lag, 0.04,
			\fmamt, ~pmodenv.(Pseq([0.01,2],inf), 8),
			\fmamt2, ~pmodenv.(Pseq([0.01,2],inf), 9),
			\out, BusDef(\sendbus2, \audio),
		)<>
		Ppar([
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 8*~t,
				\octave, 6,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 4*~t,
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 2*~t,
				\octave, 4,
				\dur, 1,
				\amp, 0.1,
			),
		]),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[16].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
				\out, BusDef(\track1, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\track1),
				\pregain, 1,
				\postgain, 0,
				\delay, 0,
				\send0, 1,
				\sendbus0, BusDef(\kick, \audio, 2),
				\send1, 1,
				\sendbus1, BusDef(\sendbus1, \audio, 2),
				\dur, 1,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[676].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[82].value,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.031 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[17].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,1,0,1,
					1,0,1,0, 1,0,1,0, 
					1,1,0,1, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.05,
			),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2546].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		Pmono(\fx_sidechain,
			\inbus, BusDef(\comp, \audio),
			\sideinbus, BusDef(\kickdel, \audio),
			\cpt, 0.01,
			\pregain, 1,
			\cpabove, 0.5,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
			\out, BusDef(\mixer0, \audio),
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\kick, \audio),
			\out, BusDef(\kickdel, \audio),
			\delay, 0.04,
			\delay, 0,
			\dur, 1,
		),
		Pbind(
			//\lag, 0.04,
			\fmamt, ~pmodenv.(Pseq([0.01,2],inf), 8),
			\fmamt2, ~pmodenv.(Pseq([0.01,2],inf), 9),
			\out, BusDef(\sendbus2, \audio),
		)<>
		Ppar([
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 8*~t,
				\octave, 6,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 4*~t,
				\octave, 5,
				\dur, 1,
				\amp, 0.1,
			),
			Pmono(
				\osciboom,
				\degree, Pseq([0],inf),
				\freqfac, 2*~t,
				\octave, 4,
				\dur, 1,
				\amp, 0.1,
			),
		]),
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[16].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.3,
				\out, BusDef(\track1, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\track1),
				\pregain, 1,
				\postgain, 0,
				\delay, 0,
				\send0, 1,
				\sendbus0, BusDef(\kick, \audio, 2),
				\send1, 1,
				\sendbus1, BusDef(\sendbus1, \audio, 2),
				\dur, 1,
			),
			Pbind(
				\lag, 0.04,
				\out, BusDef(\mixer1, \audio),
			) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[676].value,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.11,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[82].value,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.031 * Pseq([1,0.7],inf),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[17].value,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,1,
						1,0,1,0, 1,1,0,1,
						1,0,1,0, 1,0,1,0, 
						1,1,0,1, 1,0,1,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.05,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[2546].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.31,
				),
			]),
		
	])
)).play;
);
