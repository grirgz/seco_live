~t = 135/2/60; TempoClock.default.tempo = ~t;

(
SynthDef(\clickrez, { arg out=0, trig=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	env = EnvGen.kr(Env([freq,60,80],[0.01,0.08]), 1);
	sig = SinOsc.ar(env);
	sig = sig * EnvGen.kr(Env.perc(0.001,\rel.kr(0.13)), trig, doneAction:2);
	sig = Resonz.ar(sig, \rezfreq.kr(700));
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\clickhi, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	//sig = Dust.ar(freq);
	sig = Decay.ar(Dust.ar(freq),0.01) * WhiteNoise.ar;

	sig = Resonz.ar(sig, \rezfreq.kr(1000));
	//sig = Ringz.ar(sig, \rezfreq.kr(1000) * rrand(1,4.1!4),0.02).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fond1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([0.01,2,0.01],[0.1,0.8]*10), 1);
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(exprand(50.0,4000!num)) * lfo1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, 2400);

	sig1 = SinOsc.ar(exprand(40.0,100!12));
	lfo2 = EnvGen.kr(Env([0.1,2,1],[4.1,0.8]), 1);
	sig1 = Pan2.ar(sig1, pan, amp).mean * lfo2;
	sig = sig + sig1;


	sig = sig.debug("sig") * 5;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\submarine, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	//freq = freq * Duty.kr(1/~t, 0, Dseq([
		//0,0,0,0,
		//0,-1,-1,-1,
	//].midiratio,inf));
	sig = SinOsc.ar(freq * ( SinOsc.kr(exprand(0.01,1!num)) * 1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = sig.debug("sig") * 10;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\blipchord, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	var chord;
	//freq = freq * Duty.kr(1/~t, 0, Dseq([
		//0,0,0,0,
		//0,-1,-1,-1,
	//].midiratio,inf));
	chord = \chord.kr([0,3,7]).midiratio;
	sig = Blip.ar(freq * Select.kr( LFNoise1.kr(1/1!num).exprange(0.1,1), [  exprand(0.98,1!num),1]) * chord, SinOsc.ar( SinOsc.ar(exprand(1/19,10!num)).range(1/3,10)/10  ).range(1, SinOsc.ar(exprand(1/30,10!num)).exprange(1,200) ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = sig.debug("sig") * 15;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\sdkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0 * 8;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
SynthDef(\woosh, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, hpenv;
	sig = WhiteNoise.ar;
	hpenv = EnvGen.kr(Env([20000,5314,10],[1.5,0.5], [2,0]), 1);
	lpenv = EnvGen.kr(Env([10000,14441,13000],[1,1]), 1);
	sig = LPF.ar(sig, lpenv);
	sig = HPF.ar(sig, hpenv);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bassdel, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, delay=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = SinOsc.ar(freq);

	lfo1 = LFSaw.ar(1/delay);
	sig = DelayL.ar(sig, \maxdelay.kr(0.1), lfo1 * delay * SinOsc.ar(\lfof.kr(2), mul:\lfoa.kr(0.1), add:1)) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bassdelf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, delay=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var lpenv;
	sig = SinOsc.ar(freq);

	lfo1 = LFSaw.ar(1/delay);
	sig = DelayL.ar(sig, \maxdelay.kr(0.1), lfo1 * delay * SinOsc.ar(\lfof.kr(2), mul:\lfoa.kr(0.1), add:1)) + sig;
	lpenv = EnvGen.kr(\lpenv.kr(Env([1,2,1],[0.04,0.2])), 1) * \lpenva.kr(2.7) + 1;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bassdelf2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var lpenv;
	var delay;
	sig = SinOsc.ar(freq);

	delay = 1/freq * \delfac.kr(1);
	lfo1 = LFSaw.ar(1/delay);
	sig = DelayL.ar(sig, \maxdelay.kr(0.1), lfo1 * delay * SinOsc.ar(\lfof.kr(2), mul:\lfoa.kr(0.1), add:1)) + sig;
	lpenv = EnvGen.kr(\lpenv.kr(Env([1,2,1],[0.04,0.2])), 1) * \lpenva.kr(2.7) + 1;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\hat1, 
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.hat[1153].value,
		//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
		\isRest, Pseq([
			1,0,1,0, 1,0,1,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
).play;
);

(
	Pdef(\drums1, 
		Ppar([

			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1153].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[373].value,
				//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\isRest, Pseq([
					0,0,1,0, 0,1,0,1,
				],inf).coin.not,
				\dur, 1/4,
				\gain, 0.11,
			),
		]),
	).play;
);

(
Pdef(\crackle,
	Ppar([
		Ppar(
			Pbind(
				\instrument, \clickrez,
				\freq, Pwhite(200,1500.0,inf),
				\rezfreq, Pexprand(120,14500.0 * Pseg(Pseq([1,1,0.01],1),8),inf),
				\dur, Pwhite(0.4,1.7,inf) * Pseg(Pseq([1,1,4],1),8),
				\amp, Pwhite(0.1,0.4,inf),
				\pan, Pwhite(-1.0,1,inf),
				\out, BusDef(\pfx1,\audio),
			)!28
		),
		Ppar(
			Pbind(
				\instrument, \clickhi,
				\freq, 2 * Pseg(Pseq([1,1,2],inf),8),
				\rezfreq, Pexprand(60 * Pseg(Pseq([1,1,100],1),8),15500.0,inf),
				\mix, 1,
				\rel, 0.01,
				\dur, Pwhite(0.4,1.7,inf),
				\amp, Pwhite(0.1,0.4,inf)*2 * Pseg(Pseq([1,1,0.1],inf),8),
				\pan, Pwhite(-1.0,1,inf),
				\out, BusDef(\pfx1,\audio),
			)!38
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\room, 1,
			\mix, 0.1,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sdkick,
			\freq, 200,
			\dur, Pn(1,1),
			\amp, 0.1,
			\env1, [ Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]) ],
			\env0, [Env.new([0, 1, 0.5, 0], [0.005, 0.46, 0.2], [-4, -2, -4])  ]
		),
	])
).play;
);


(
Pdef(\part, Pdef(\chordrise, 
	Ppar([
		Pmono(\fond1,
			\dur, 1,
			\amp, PmodEnv(Pseq([0,1,1,1,1]*0.1,1), 8-0.1),
			//\isRest, true,
		),
		Pmono(\submarine,
			\note, [0,7, 3,12],
			\dur, 1,
			\amp, PmodEnv(Pseq([0,0,1,1,1]*0.1,1), 8-0.1),
			//\isRest, true,
		),
		Pmono(\blipchord,
			\note, 0,
			\octave, 6,
			\dur, 1,
			\amp, PmodEnv(Pseq([0,0,0,1,1]*0.1,1), 8-0.1),
		),
		Pbind(
			\instrument, \woosh,
			\dur, 2,
			\isRest, Pseq([
				Pseq([
					0,0,0,0,
				],3),
				0,0,0,1,
			],1).coin.not,
			\legato, 1,
			\amp, 0.4,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\main, 
	Pseq([
		Ptpar([
			21, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, 1,
					\speed, 1.2,
					\legato, 0.1,
					\dur, Pn(1,1),
					\gain, 1/4,
					\out, BusDef(\pfxecho, \audio),
				),
			]),
			7, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, 0,
					\legato, 0.1,
					\dur, Pn(1,1),
					\gain, 1/4,
					\out, BusDef(\pfxecho, \audio),
				),
			]),
			13, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,1,
				],1).coin.not,
				\dur, 1/16,
				\gain, 0.11/4,
				\out, BusDef(\pfxecho, \audio),
			),
			3, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,1,
				],1).coin.not,
				\dur, 1/16,
				\gain, 0.11/4,
				\out, BusDef(\pfxecho, \audio),
			),
			0, Pseq([
				Pdef(\chordrise),
				Pdef(\crackle)
			],1),
			0, Pmono(\fx_echo,
					\inbus, BusDef(\pfxecho, \audio),
					\addAction, \addToTail,
					\delay, 1/4/~t,
					\decay, 8/~t,
					\lag, 0.0009,
					\dur, 1,
				),
		]),
	])
)).play;
)

ClipTimeline(\sun82).presetCompileStringSavePath = "sun/ClipTimeline_sun82.scd";
ClipTimeline(\sun82).loadPresetCompileString;
ClipTimeline(\sun82).edit

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Ptpar([
			21, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, 1,
					\speed, 1.2,
					\legato, 0.1,
					\dur, Pn(1,1),
					\gain, 1/4,
					\out, BusDef(\pfxecho, \audio),
				),
			]),
			7, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, BufDef('voices/feynman.flac'),
					\pos, 0,
					\legato, 0.1,
					\dur, Pn(1,1),
					\gain, 1/4,
					\out, BusDef(\pfxecho, \audio),
				),
			]),
			13, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,1,
				],1).coin.not,
				\dur, 1/16,
				\gain, 0.11/4,
				\out, BusDef(\pfxecho, \audio),
			),
			3, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,1,0,1,
				],1).coin.not,
				\dur, 1/16,
				\gain, 0.11/4,
				\out, BusDef(\pfxecho, \audio),
			),
			0, Pseq([
				Pfindur(8*4,Pdef(\chordrise)),
				Pfindur(8*2,Pdef(\crackle))
			],4),
			0, Pmono(\fx_echo,
					\inbus, BusDef(\pfxecho, \audio),
					\addAction, \addToTail,
					\delay, 1/4/~t,
					\decay, 8/~t,
					\lag, 0.0009,
					\dur, 1,
				),
		]),
	])
)).play;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \woosh,
			\freq, 200,
			\dur, 2,
			\legato, 1,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sdkick,
			\freq, 200,
			\dur, 2,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\amp, 0.1,
			\env1, [ Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]) ],
			\env0, [Env.new([0, 1, 0.5, 0], [0.005, 0.46, 0.2], [-4, -2, -4])  ]
		),
	])
)).play;
);

(
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 0.1,
			\dur, Pn(1,1),
			\gain, 1,
			\out, BusDef(\pfx2, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\delay, 1/4/~t,
			\decay, 4/~t,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bassdel,
			\octave, 3,
			\note, Pseq([
				0,5,-4,-1
			],inf),
			\delay, 1/Pkey(\freq)*Pseq([2,4],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
			\instrument, \bassdel,
			\delay, 1/Pkey(\freq)*Pseq([2],inf),
			\octave, 4,
			\amp, 0.2,
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melo))


/////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\out, BusDef(\pfx1, \audio),
		) <>
		Pdef(\bassback),
		Pmono(\fx_echo,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\decay, 4/~t,
			\delay, 1/2/~t,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

Pdef(\bassback).edit
Pdef(\bassback).asParamGroup.getPbindefCompileString.editorInsert
