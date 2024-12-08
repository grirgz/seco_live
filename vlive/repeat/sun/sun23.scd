~t = 175/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1395].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					0.1,1, 0.1,0.2, 0.1,0.2, 0.1,0.2,
				],8),
				Pseq([
					1,1, 0.1,0.2, 0.1,0.2, 0.1,0.2,
				],8),
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2468].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[726].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,0,1,
				1,1,1,1, 0,0,0,0,
				1,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([
				
				Pseq([
					1,1,1,1,
					1,1,1,1.04,
					1,1,1,1,
				],1),
				0.4,1,2,0.51,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				1,2,1,1,
			],inf).stutter(2),
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([
					1,
				],8),
				1,1.5,1.5,1.3,
				Pseq([
					1,
				],4),
			],inf) * 0.8 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.7,0.8,0.9,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],4),

				0.4,1,2,0.51,
				Pseq([
					1,1,1,1,
				],3),

				Pseq([
					1.7,0.4,0.4,0.2,
				],4),

				Pseq([
					1,1,1,1,
				],3),
				0.3,1,2,1,
			],inf),
			\pos, Pseq([
				0,1,2,3,
				4,9,10,12,
				0,1,1,1,
				4,5,5,5,
				0,0,0,0,
				4,4,4,4,
				(0..7),
				(0..7)+8,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([
					1,
				],8),
				1,1.5,1.5,1.3,
				Pseq([
					1,
				],4),
			],inf) * 1.7 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.7,0.8,0.9,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],4),

				0.4,1,2,0.51,
				Pseq([
					1,1,1,1,
				],3),

				Pseq([
					1.7,0.4,0.4,0.2,
				],4),

				Pseq([
					1,1,1,1,
				],3),
				0.3,1,2,1,
			],inf),
			\pos, Pseq([
				0,1,2,3,
				4,9,10,12,
				0,1,1,1,
				4,5,5,5,
				0,0,0,0,
				4,4,4,4,
				(0..7),
				(0..7)+8,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([
					1,
				],8),
				1,2,1,2,
				1,2,1,2,
			],inf) * 0.8 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.7,0.8,0.9,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],4),

			],inf),
			\pos, Pseq([
				0,3,3,0,
				4,7,7,9,
				0,13,0,13,
				4,17,17,1,
				//(0..7),
				//(0..7)+8,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],2) * 0.6,
				Pseq([
					1,1,1,1,
				],1)/4,
			],inf),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				Pser([
					2,5,13,
				],16),
				Pser([
					6,6,6,
					14,14,14,
				],16),
				Pser([
					5,2,14,
				],16),
				//7,10,6,
			],inf)/16 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.9,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					(0..15)
				].flat,3)/16,
				Pseq([
					0,1,1,0,
					1,1,0,1,
					10,12,2,2,
					4,0,0,12,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\isRest, Pseq([
				1,0,0,
				1,1,1,
				1,0.51,0.71,
			],inf).coin.not,
			\pos, Pseq([
				Pser([
					0,0,5,6,
					0,1,12,8,
					8,8,8,8,
					0,2,0,10,
					13,14,14,14,
				],24)/8,
			],inf)/ Pkey(\st),
			\dur, 1/12,
			\gain, 1/8,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					(0..15)
				].flat,3)/16,
				Pseq([
					0,1,1,0,
					1,1,0,1,
					10,12,2,2,
					4,0,0,12,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				[0,4,7,12,12+7],
				[0,4,7,12,12+7]-1,
				[0,3,7,12,12+3]-1,
				[0,3,7,12,12+3]-2,
			],inf),
			\lpf, ~pmodenv.(Pseq([1,7,1,10]*200,1), 2).loop,
			\dur, Pseq([2,1/4,1/4,1/2],inf),
			\amp, 0.1,
			\lag, 0.04,
			\isRest, true,
		),
	])
)).play;
);

NoteTimeline(\bla).edit

SynthDef(\basicpad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,0.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]);
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, ( \lpf.kr(8000) * env1 ).clip(20,20000));
	sig = [sig1, sig2].sum / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;


(
SynthDef(\grobass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.1,2.8]), 1);
	sig = SinOsc.ar(freq * ( LFPulse.ar(freq/2) * env1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\grobass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.1,2.8]), 1);
	sig1 = SinOsc.ar(freq * ( LFPulse.ar(freq/2) * env1 + 1 ));
	sig2 = LFPulse.ar(freq * ( SinOsc.kr(env1) * 1 + 1 ));
	sig = [sig1, sig2].sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\pik1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * ( SinOsc.ar(freq/2) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\pik2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * ( SinOsc.ar(freq*2) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \grobass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	// reggaeton like
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \pik1,
			\note, Pseq([
				0,
			],inf),
			\octave, 6,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\legato, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \grobass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, Pseq([
				13,0,0,0, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				10,0,0,0, 0,0,0,0,
				0,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],2) * 0.6,
				Pseq([
					1,1,1,1,
				],1)/4,
			],inf),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				Pser([
					2,5,13,
				],16),
				Pser([
					6,6,6,
					14,14,14,
				],16),
				Pser([
					5,2,14,
				],16),
				//7,10,6,
			],inf)/16 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					(0..15)
				].flat,3)/16,
				Pseq([
					0,1,1,0,
					1,1,0,1,
					10,12,2,2,
					4,0,0,12,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\isRest, Pseq([
				1,0,0,
				1,1,1,
				1,0.51,0.71,
			],inf).coin.not,
			\pos, Pseq([
				Pser([
					0,0,5,6,
					0,1,12,8,
					8,8,8,8,
					0,2,0,10,
					13,14,14,14,
				],24)/8,
			],inf)/ Pkey(\st),
			\dur, 1/12,
			\gain, 1/13,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \pik2,
			\note, Pseq([
				0,
			],inf),
			\octave, 6,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\legato, 0.2,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \grobass,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, Pseq([
				13,0,0,0, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				10,0,0,0, 0,0,0,0,
				0,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],2) * 0.6,
				Pseq([
					1,1,1,1,
				],1)/4,
			],inf),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				Pser([
					2,5,13,
				],16),
				Pser([
					6,6,6,
					14,14,14,
				],16),
				Pser([
					5,2,14,
				],16),
				//7,10,6,
			],inf)/16 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					(0..15)
				].flat,3)/16,
				Pseq([
					0,1,1,0,
					1,1,0,1,
					10,12,2,2,
					4,0,0,12,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\isRest, Pseq([
				1,0,0,
				1,1,1,
				1,0.51,0.71,
			],inf).coin.not,
			\pos, Pseq([
				Pser([
					0,0,5,6,
					0,1,12,8,
					8,8,8,8,
					0,2,0,10,
					13,14,14,14,
				],24)/8,
			],inf)/ Pkey(\st),
			\dur, 1/12,
			\gain, 1/13,
		),
		
	])
)).play;
);


///// bass sequence

(
SynthDef(\seqbass1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\famenv.kr(Env([0,1,0],[0.1,2.8]), 1));
	sig = SinOsc.ar(freq * ( LFPulse.ar(freq * \fmr.kr(1/2)) * env1 * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\seqbass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\famenv.kr(Env([0,1,0],[0.1,2.8]), 1));
	sig = SinOsc.ar(freq * ( LFPulse.ar(freq * \fmr.kr(1/2)) * env1 * \fma.kr(1) + 1 ));
	sig = sig * ( SinOsc.ar(freq) * \ama.kr(1) + 1 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\seqbass3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\famenv.kr(Env([0,1,0],[0.1,2.8]), 1));
	env2 = Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,
		7,2,5,
	],inf)).midiratio;
	sig = SinOsc.ar(freq * ( LFPulse.ar(freq * \fmr.kr(1/2)) * env1 * \fma.kr(1) + 1 ));
	sig = sig * LPF.ar(( LFPulse.ar(freq * env2 * ( env1 + 1 )) * \ama.kr(1) + 1 ), 10000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\seqbass4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\famenv.kr(Env([0,1,0],[0.1,2.8]), 1));
	env2 = Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,
		7,2,5,
	],inf)).midiratio;
	env3 = EnvGen.kr(\env3.kr(Env([0,1,0],[1.1,2.8]), 1));
	sig = SinOsc.ar(freq * ( LFPulse.ar(freq * \fmr.kr(1/2)) * env1 * \fma.kr(1) + 1 ));
	sig = sig * LPF.ar(( LFPulse.ar(freq * env2 * ( env1 + 1 )) * \ama.kr(1) + 1 ), env3 * 5000 + 100);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\seqbass5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\famenv.kr(Env([0,1,0],[0.1,2.8]), 1));
	env2 = Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,
		7,2,5,
	],inf)).midiratio;
	env3 = EnvGen.kr(\env3.kr(Env([0,1,0],[1.1,2.8]), 1));
	sig = SinOsc.ar(freq * ( LFPulse.ar(freq * \fmr.kr(1/2)) * env1 * \fma.kr(1) + 1 ));
	//sig = sig * LPF.ar(( LFPulse.ar(freq * env2 * ( env1 + 1 )) * \ama.kr(1) + 1 ), env3 * 5000 + 100);
	sig = sig + FreqShift.ar(sig, env1 * 100)  / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\seqbass1b, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.1,2.8]), 1);
	sig1 = SinOsc.ar(freq * ( LFPulse.ar(freq/2) * env1 + 1 ));
	sig2 = LFPulse.ar(freq * ( SinOsc.kr(env1) * 1 + 1 ));
	sig = [sig1, sig2].sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	// reggaeton like
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, Pstep(Pseq([
				\seqbass1,
				\seqbass2,
				\seqbass3,
				\seqbass4,
				\seqbass5,
			],inf),8),
			\note, Pseq([
				0,
			],inf),
			\fmr, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,4,1, 1,4,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,4,1,1,
			],inf)/2,
			\octave, 3,
			\legato, Pseq([
				13,0,0,0, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				10,0,0,0, 0,0,0,0,
				0,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],2) * 0.6,
				Pseq([
					1,1,1,1,
				],1)/4,
			],inf),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				Pser([
					2,5,13,
				],16),
				Pser([
					6,6,6,
					14,14,14,
				],16),
				Pser([
					5,2,14,
				],16),
				//7,10,6,
			],inf)/16 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, 
			Pseq([
				Pseq([
					(0..15)
				].flat,3)/16,
				Pseq([
					0,1,1,0,
					1,1,0,1,
					10,12,2,2,
					4,0,0,12,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\isRest, Pseq([
				1,0,0,
				1,1,1,
				1,0.51,0.71,
			],inf).coin.not,
			\pos, Pseq([
				Pser([
					0,0,5,6,
					0,1,12,8,
					8,8,8,8,
					0,2,0,10,
					13,14,14,14,
				],24)/8,
			],inf)/ Pkey(\st),
			\dur, 1/12,
			\gain, 1/13,
		),
		
	])
)).play;
);

(
	// reggaeton like
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, Pstep(Pseq([
				\seqbass1,
				\seqbass2,
				\seqbass3,
				\seqbass4,
				\seqbass5,
			],inf),8),
			\note, Pseq([
				0,
			],inf),
			\fmr, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,4,1, 1,4,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				4,1,1,1, 1,1,1,1,
				1,1,1,1, 1,4,1,1,
			],inf)/2,
			\octave, 3,
			\legato, Pseq([
				13,0,0,0, 0,0,0,0,
				0,0,0,0, 0,3,0,0,
				10,0,0,0, 0,0,0,0,
				0,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Ptpar([
			4, Pbind(
			   	\instrument, \playersec,
			   	\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			   	\legato, Pseq([
			   		Pseq([
			   			1,1,1,1,
			   		],2) * 0.6,
			   		Pseq([
			   			1,1,1,1,
			   		],1)/4,
			   	],inf),
			   	\st, 122/4/60,
			   	\speed, 0.91 * ~t / Pkey(\st),
			   	\pos, Pseq([
			   		Pser([
			   			2,5,13,
			   		],16),
			   		Pser([
			   			6,6,6,
			   			14,14,14,
			   		],16),
			   		Pser([
			   			5,2,14,
			   		],16),
			   		//7,10,6,
			   	],inf)/16 / Pkey(\st),
			   	\adsr, Pseq([
			   		[ Env.adsr(0.01,0.1,0.8,0.1) ],
			   	],inf),
			   	\dur, 1/8,
			   	\gain, 0.5,
			   ),
			   0, Pbind(
			   	\instrument, \playersec,
			   	\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			   	\legato, 1,
			   	\st, 122/4/60,
			   	\speed, 1/2 * ~t / Pkey(\st),
			   	\pos, 
			   	Pseq([
			   		Pseq([
			   			(0..15)
			   		].flat,3)/16,
			   		Pseq([
			   			0,1,1,0,
			   			1,1,0,1,
			   			10,12,2,2,
			   			4,0,0,12,
			   		],1)/16,
			   	],inf) / Pkey(\st),
			   	\dur, 1/8,
			   	\gain, 1/8,
			   ),
			   12,Pbind(
			   	\instrument, \playersec,
			   	\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			   	\legato, 1,
			   	\st, 129/4/60,
			   	\speed, 1 * ~t / Pkey(\st),
			   	\isRest, Pseq([
			   		1,0,0,
			   		1,1,1,
			   		1,0.51,0.71,
			   	],inf).coin.not,
			   	\pos, Pseq([
			   		Pser([
			   			0,0,5,6,
			   			0,1,12,8,
			   			8,8,8,8,
			   			0,2,0,10,
			   			13,14,14,14,
			   		],24)/8,
			   	],inf)/ Pkey(\st),
			   	\dur, 1/12,
			   	\gain, 1/13,
			   ),
		])
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1/4,
			\st, 122/4/60,
			\speed, 1/2 * Pseq([
				1,1,1,0.9,
			],inf) * ~t / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,1,
				0,1,1,1,
			]/2,inf).coin.not,
			\pos, 
			Pseq([
				Pseq([
					Prand([0,8,16,24]),
				].flat,3)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * Pseq([
				1,1,1,1,
				1,1,1,0.9,
				1,1,1,1,
				1,1,1,1,

				1,1,1,1.5,
				1,1,1,1.5,
				1,1,1,1.5,
				1,1,1,1,
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, 
			Pseq([
				Pseq([
					6,1,2,1,
					6,1,9,1,
				].flat,3)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * Pseq([
				1,1,1,1.5,
				1,1,1,1.5,
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\pos, 
			Pseq([
				Pseq([
					0,1,2,1,
					4,1,2,1,
					0,1,0,1,
					4,1,2,1,
				].flat,3)/16,
				Pseq([
					0,1,1,0,
					1,1,0,1,
					10,12,2,2,
					4,0,0,12,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\legato, 1,
			\st, 92.10/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Plazy({ arg ev;
					var li = rrand(0,24!4);
					Pseq(
						( 8.partition(4)*8 ).collect { arg item, idx;
							Pser([
								li[idx]
							],item)
						},
						4
					)
				}).loop,
				//Pwalk( 
					//[
					//16,20,5,4,
					//15,6,5,4,
					//],
					//Pbrown(0,7,1)
				//)
			],inf)/16 / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * Pseq([
				1
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, 
			Pseq([
				Pseq([
					0,0,0,1, 0,1,2,1,
					4,1,2,0, 5,1,0,1,
					2,2,0,2, 2,1,0,1,
					4,1,2,0, 5,1,0,1,
				].flat,3)/16,
				Pseq([
					0,1,1,0, 1,1,0,1,
					10,10,4,2, 2,0,0,12,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\legato, 1,
			\st, 92.10/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pser([ 5, ],24),
				Pser([ 8, ],8),

				Pser([ 5, ],10),
				Pser([ 8, ],2),
				Pser([ 5, ],10),
				Pser([ 8, ],2),
				Pser([ 5, ],2),
				Pser([ 8, ],6),
			],inf)/16 / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * Pseq([
				1
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, 
			Pseq([
				Pseq([
					0,0,0,1, 0,1,2,1,
					4,1,2,0, 5,1,0,1,
					2,2,0,2, 2,1,0,1,
					4,1,2,0, 5,1,0,1,
				].flat,3)/16,
				Pseq([
					0,1,1,0, 1,1,0,1,
					10,10,4,2, 2,0,0,12,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\legato, 1,
			\st, 137/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			],1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/16,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\legato, 1,
			\st, 137/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					3,4,
					11,12,
				],inf),
				Pseq([
					3,4,
				],1),
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * Pseq([
				1
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, 
			Pseq([
				Pseq([
					0,0,0,1, 0,1,2,1,
					4,\r,\r,\r, \r,\r,\r,\r,
					2,2,0,2, 2,1,0,1,
					4,1,2,0, 5,1,0,1,
				].flat,3)/16,
				Pseq([
					0,1,1,0, 1,1,0,1,
					10,10,4,2, 2,0,0,12,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \madsin,
			\freq, 900,
			\legato, Pseq([
				0,0,4,0, 
				0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \madsin2,
			\note, Pseq([
				34,
			],inf),
			\octave, [3,4],
			\legato, Pseq([
				4,0,0,0, 
				0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1/4,
		),
		
	])
)).play;
);


(
SynthDef(\madsin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(8*~t) * 0.31 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\madsin2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * XLine.kr(1,0.032,4/~t) * ( SinOsc.ar(16*~t) * 0.31 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\madsin2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	mod1 = ( SinOsc.ar(freq) * 0.7 + 1 );
	sig = SinOsc.ar(freq * XLine.kr(1,0.032,4/~t) * ( SinOsc.ar(freq * mod1) * 0.31 + 1 ));
	sig = DelayL.ar(sig, 0.1, 0.01 * ( SinOsc.ar(1 * (1..8)/10) * 1 + 1 )) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);



//////////////



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			\playersec,
			\bufnum, BufDef('vipere/petanque.flac'),
			\speed, 0.2,
			\dur, Pn(1/2,2*2),
			\gain, 1/4,
		).loop,
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1450].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\legato, 0.21,
			\gdur, 0.2,
			\freq, 248,
			\pos, Pwhite(0.0,0.01) + 1.2,
			\hpf, 3400,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\legato, 1,
			\gdur, 0.1,
			\freq, 80,
			\pos, ~pmodenv.(Pseq([0,8],1), 8).loop ,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pmono(
			\playersec,
			\bufnum, BufDef.stereo('vipere/petanque.flac'),
			\speed, 0.25,
			\dur, Pn(1/2,2*2),
			\gain, 1/4,
		).loop,
		
	])
)).play;
);
1

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\pos, 1.0,
			\pos, ~pmodenv.(Pseq([1,1.1]+0.2,1), 8).loop,
			\pitch_stretch, 1,
			//\pitch_stretch, ~pmodenv.(Pseq([1,0.1],1), 8).loop,
			\gdur, 0.1/2,
			//\gdur, Pwhite(0.1,0.2,inf),
			\gdur, ~pmodenv.(Pseq([1.001,0.01,0.0002],1), 4).loop,
			//\freq, 300,
			\note, Pseq([
				0,4,7,
			],inf),
			\lpf, 4200,
			\hpf, 360,
			\octave, 5,
			//\freq, 60,
			\freq, ~pmodenv.(Pseq([90,32,1000],1), 4).loop,
			\dur, Pn(1/2,2*8),
			\gain, 1/4,
		).loop,
		
	])
)).play;
);

(
	// wet bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\pos, 1.0,
			\pos, ~pmodenv.(Pseq([1,1.01]+2,1), 8).loop,
			\pitch_stretch, 1,
			//\pitch_stretch, ~pmodenv.(Pseq([1,0.1],1), 8).loop,
			\gdur, 0.1/2,
			//\gdur, Pwhite(0.1,0.2,inf),
			\gdur, ~pmodenv.(Pseq([0.001,0.0002],1), 8).loop,
			//\freq, 300,
			\note, Pseq([
				0,4,7,
			],inf),
			\lpf, 2000,
			\lpf, ~pmodenv.(Pseq([20,200,20,2000,20,10000],1), 1).loop,
			\hpf, 60,
			\octave, 2,
			//\freq, 60,
			//\freq, ~pmodenv.(Pseq([30,92],1), 8).loop,
			\dur, Pn(1/2,2*8),
			\gain, 1/4,
		).loop,
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\pos, ~pmodenv.(Pseq([0,1],1), 8).loop,
			\pitch_stretch, ~pmodenv.(Pseq([1,1.2,0.7],1), 8).loop,
			\gdur, 0.1/1,
			\gdur, Pwhite(0.1,0.2,inf),
			//\freq, 300,
			\note, Pseq([
				0,4,7,
			],inf),
			\octave, 3,
			\freq, Pwhite(20.0,40,inf),
			\dur, Pn(1/2,2*8),
			\gain, 1/4,
		).loop,
		
	])
)).play;
);



(
SynthDef(\gregrain_norm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = HPF.ar(sig, \hpf.kr(180));
	sig = LPF.ar(sig, \lpf.kr(18000));
	sig = Normalizer.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\gregrain_resnorm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * \gain.kr(1);
	sig = RHPF.ar(sig, \hpf.kr(180), \hprq.kr(0.5));
	sig = RLPF.ar(sig, \lpf.kr(18000), \lprq.kr(0.5));
	sig = Normalizer.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)
(
	// slow
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1450].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1426].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1714].value,
			\speed, 0.8 + Pwhite(0,0.01,inf),
			\isRest, Pseq([
				//0,0,0,0, 0,0,0,0,
				//0,0,1,0, 1,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
			].rotate(3),inf).coin.not,
			\dur, 1/8,
			\legato, 3.8,
			\gain, 0.11,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\legato, Pseq([
				Pseq([
					1.5,
				],8),
				Pseq([
					0.5,
				],4),
			],inf),
			\st, 137/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseq([
					3,4,
					11,12,
				],inf),
				Pseq([
					3,4,
				],1),
			].flat,inf)/8 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				1,1,0,0, 1,0,1,1, 
				1,0,0,0, 1,0,1,0, 
				0,0,0,0, 1,1,1,1,
				1,1,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * Pseq([
				1
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, 
			Pseq([
				Pseq([
					0,\r,1,\r, 15,\r,\r,18,
					4,\r,\r,5, 3,\r,\r,\r,
					0,\r,1,\r, 6,7,0,\r,
					4,\r,\r,5, 3,\r,\r,\r,
					0,\r,0,14, 15,\r,15,\r,
					4,\r,\r,5, 3,\r,\r,\r,
				].flat,1)/16,
				Pseq([
					0,16,0,14, 15,\r,8,\r,
					4,\r,0,5, 3,\r,12,13,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
		PmonoArtic(
			 \gregrain_resnorm,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0, 0,1,0,0, 1,5,10,0]/80,1) + Pwhite(0.01,0.02,inf).stutter(8), 1/4).loop,
			//\pos, 0.01,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,7
			],inf),16),
			\lpf, 3000,
			//\hpf, ~pmodenv.(Pseq([10,1000,200,20000,4000],1), 13).loop,
			\lprq, ~pmodenv.(Pseq([1,0.2],1), 8).loop,
			\lpf, ~pmodenv.(Pseq([80,1000,10000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([10,2000,20000],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf).stutter(16*8),
			\octave, 7,
			\legato, Pseq([
				Pn(0.21,8),
				Pn(1,8),
				1,1,1,1,0.6,0.3,0.2,0.5,
				Pn(1,8*3),
			],inf),
			\dur, 1/16,
			\amp, 0.1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_norm,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			//\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10,0.02,inf).stutter(8), 8).loop,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,4,2,
			],inf),1),
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/2,
			\gain, 4,
		),
		
	])
)).play;
);


(
	// dnb with filters
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1450].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * Pseq([
				1
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, 
			Pseq([
				Pseq([
					0,\r,10,\r, 4,\r,\r,\r,
					0,\r,\r,5, 4,\r,\r,\r,
				].flat,3)/16,
				Pseq([
					0,\r,10,\r, 4,0,\r,0,
					0,0,\r,5, 4,5,0,1,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
		PmonoArtic(
			 \gregrain_resnorm,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0, 0,1,0,0, 1,5,10,0]/80,1) + Pwhite(0.01,0.02,inf).stutter(8), 1/8).loop,
			//\pos, 0.01,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,7
			],inf),16),
			\lpf, 3000,
			//\hpf, ~pmodenv.(Pseq([10,1000,200,20000,4000],1), 13).loop,
			\lprq, ~pmodenv.(Pseq([1,0.2],1), 8).loop,
			\lpf, ~pmodenv.(Pseq([80,1000,10000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([10,2000,20000],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf).stutter(16*8),
			\octave, 7,
			\legato, Pseq([
				Pn(0.21,8),
				Pn(1,8),
				1,1,1,1,0.6,0.3,0.2,0.5,
				Pn(1,8*3),
			],inf),
			\dur, 1/16,
			\amp, 0.1,
		)
		
	])
)).play;
);
(
	// 4/4
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1450].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, 1,
			\st, 122/4/60,
			\speed, 1/2 * Pseq([
				1
			],inf) * ~t / Pkey(\st),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\pos, 
			Pseq([
				Pseq([
					0,\r,10,\r, 4,\r,\r,\r,
					0,\r,\r,5, 4,\r,\r,\r,
				].flat,3)/16,
				Pseq([
					0,1,4,0, 1,0,2,1,
					4,10,0,4, 2,\r,0,\r,
				],1)/16,
			],inf) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
		PmonoArtic(
			 \gregrain_norm,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0, 0,1,0,0, 1,5,10,0]/80,1) + Pwhite(0.01,0.02,inf).stutter(8), 1/8).loop,
			//\pos, 0.01,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,0,0,0,3,4,4,2,
				1,1,1,0,1,1,9,9,
			],inf),1/16),
			\lpf, 3000,
			\lpf, ~pmodenv.(Pseq([10,1000,200,20000,4000],1), 13).loop,
			\hpf, ~pmodenv.(Pseq([10,1000,20000],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\octave, 7,
			\legato, Pseq([
				Pn(1,inf),
				1,1,1,1,0.6,0.3,0.2,0.5,
			],inf),
			\dur, 1/16,
			\amp, 0.1,
		)
		
	])
)).play;
);


(
	// cool bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		PmonoArtic(
			 \gregrain_norm,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/80,1) + Pwhite(0.01,0.02,inf).stutter(8), 1/8).loop,
			//\pos, 0.01,
			\gdur, 0.1/8,
			\note, Pstep(Pseq([
				0,0,0,0,3,4,4,2,
			],inf),1),
			\lpf, 3000,
			\hpf, 60,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\octave, 7,
			\legato, Pseq([
				1,1,1,1,0.6,0.3,0.2,0.5,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		)
		
	])
)).play;
);

////////
// tentative de sequence



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1450].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\legato, 0.21,
			\gdur, 0.2,
			\freq, 1248,
			\pos, Pwhite(0.0,0.01) + 1.2,
			\hpf, 3400,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\legato, 1,
			\gdur, 0.1,
			\freq, 80,
			\pos, ~pmodenv.(Pseq([0,8],1), 8).loop ,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pmono(
			\playersec,
			\bufnum, BufDef('vipere/petanque.flac'),
			\speed, 0.25,
			\dur, Pn(1/2,2*2),
			\gain, 1/4,
		).loop,
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pseq([
				Pbind(
					\instrument, \gregrain_norm,
					\mbufnum, BufDef.mono('vipere/petanque.flac'),
					\legato, 0.21,
					\gdur, 0.2,
					\freq, 1248,
					\pos, Pwhite(0.0,0.01) + 1.2,
					\hpf, 3400,
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],1).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 1/8,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1450].value,
					\isRest, Pseq([
						1,0,0,1,
					],6).coin.not,
					\dur, 1/8,
					\gain, 0.1,
				),
			],2),
			Ppar([
				Pbind(
					\instrument, \gregrain_norm,
					\mbufnum, BufDef.mono('vipere/petanque.flac'),
					\legato, 0.21,
					\gdur, 0.2,
					\freq, 1248,
					\pos, Pwhite(0.0,0.01) + 1.2,
					\hpf, 3400,
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
						0,0,0,0, 0,0,0,0,
					],2).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 1/8,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1450].value,
					\isRest, Pseq([
						1,0,0,1,
					],2*4).coin.not,
					\dur, 1/8,
					\gain, 0.1,
				),
			]),
		],1),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1450].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\legato, 0.21,
			\gdur, 0.2,
			\gdur, ~pmodenv.(Pseq([0.2,0.1,0.01,0.001],1), 8).loop,
			\note, Pseq([
				Pseq([
					0,-3,-1,-1
				],inf).stutter(8),
			],inf),
			\octave, 7,
			\pos, Pwhite(0.0,0.01) + 1.2,
			//\pos, ~pmodenv.(Pseq([1,2.02],1), 8).loop,
			\pos, Pwhite(0.0,0.01) + Pwhite(0.0,1,inf).stutter(32),
			\hpf, 3400,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/10,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1.02 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\pos, Pseq([
				0,9,11,5, 4,5,7,5,
				8,9,10,5, 4,5,7,5,
			],inf)/8 / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\pos, 1.0,
			\pos, ~pmodenv.(Pseq([1,1.01]+2,1), 8).loop,
			\pitch_stretch, 1,
			//\pitch_stretch, ~pmodenv.(Pseq([1,0.1],1), 8).loop,
			\gdur, 0.1/2,
			//\gdur, Pwhite(0.1,0.2,inf),
			\gdur, ~pmodenv.(Pseq([0.001,0.0002],1), 8).loop,
			//\freq, 300,
			\note, Pseq([
				0,12,-12,
				0,0,0,
				-12,-12,-12,
				0,0,0,
				0,0,0,
				0,0,0,
				-12,-12,-12,
				-12,-12,-12,
				-12,-12,-12,
			],inf) +
				Pseq([
					0,-3,-1,-1
				],inf).stutter(8),
			\lpf, 2000,
			\lpf, ~pmodenv.(Pseq([20,200,20,2000,20,10000],1), 1).loop,
			\hpf, 60,
			\octave, 4,
			//\freq, 60,
			//\freq, ~pmodenv.(Pseq([30,92],1), 8).loop,
			\gain, 1/4,
			\dur, Pn(1/8,inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1450].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // lagged bip
			\instrument, \gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\legato, 0.71,
			\gdur, 0.2,
			\gdur, ~pmodenv.(Pseq([0.2,0.1,0.01,0.001],1), 8).loop,
			\note, Pseq([
				Pseq([
					0,-3,-1,-1
				],inf).stutter(8),
			],inf),
			\octave, 8,
			\pos, Pwhite(0.0,0.01) + 1.2,
			//\pos, ~pmodenv.(Pseq([1,2.02],1), 8).loop,
			\pos, Pwhite(0.0,0.01) + Pwhite(0.0,1,inf).stutter(32),
			\hpf, 3400,
			\lpf, 1000,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\lag, 1/8/2/~t * Pseg(Pseq([1,0.5,1.5],inf),32),
			\gain, 1/10,
			\amp, 0.1/2 * Pseq([
				Pseg(Pseq([0,1,0.2,0.4],inf),8),
			],inf),
			//\isRest, true,
		),
		Pbind( // bip
			\instrument, \gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\legato, 0.21,
			\gdur, 0.2,
			\gdur, ~pmodenv.(Pseq([0.2,0.1,0.01,0.001],1), 8).loop,
			\note, Pseq([
				Pseq([
					0,-3,-1,-1
				],inf).stutter(8),
			],inf),
			\octave, 7,
			\pos, Pwhite(0.0,0.01) + 1.2,
			//\pos, ~pmodenv.(Pseq([1,2.02],1), 8).loop,
			\pos, Pwhite(0.0,0.01) + Pwhite(0.0,1,inf).stutter(32),
			\hpf, 3400,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 1/10,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1.02 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\pos, Pseq([
				0,9,11,5, 4,5,7,5,
				8,9,10,5, 4,5,7,5,
			],inf)/8 / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\pos, 1.0,
			\pos, ~pmodenv.(Pseq([1,1.01]+2,1), 8).loop,
			\pitch_stretch, 1,
			//\pitch_stretch, ~pmodenv.(Pseq([1,0.1],1), 8).loop,
			\gdur, 0.1/2,
			//\gdur, Pwhite(0.1,0.2,inf),
			\gdur, ~pmodenv.(Pseq([0.001,0.0002],1), 8).loop,
			//\freq, 300,
			\note, Pseq([
				0,12,-12,
				0,0,0,
				-12,-12,-12,
				0,0,0,
				0,0,0,
				0,0,0,
				-12,-12,-12,
				-12,-12,-12,
				-12,-12,-12,
			],inf) +
				Pseq([
					0,-3,-1,-1
				],inf).stutter(8),
			\lpf, 2000,
			\lpf, ~pmodenv.(Pseq([20,200,20,2000,20,10000],1), 1).loop,
			\hpf, 60,
			\octave, 4,
			//\freq, 60,
			//\freq, ~pmodenv.(Pseq([30,92],1), 8).loop,
			\gain, 1/4,
			\dur, Pn(1/8,inf),
		),
	])
)).play;
);


////////////
/// tentative de sequence avec un pdef par track

(
Pdef(\kick1, 
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[1450].value,
		\isRest, Pseq([
			1,0,0,0, 1,0,0,0,
			1,0,1,0, 1,0,0,0,
			1,0,0,0, 1,0,0,0,
			1,0,0,1, 1,0,0,0,
			1,0,0,0, 1,0,0,0,
			1,0,0,0, 1,0,0,1,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
).play;
);

(
Pdef(\bass1, 
	Pmono(
		\gregrain_norm,
		\mbufnum, BufDef.mono('vipere/petanque.flac'),
		\pos, 1.0,
		\pos, ~pmodenv.(Pseq([1,1.01]+2,1), 8).loop,
		\pitch_stretch, 1,
		//\pitch_stretch, ~pmodenv.(Pseq([1,0.1],1), 8).loop,
		\gdur, 0.1/2,
		//\gdur, Pwhite(0.1,0.2,inf),
		\gdur, ~pmodenv.(Pseq([0.001,0.0002],1), 8).loop,
		//\freq, 300,
		\note, Pseq([
			0,12,-12,
			0,0,0,
			-12,-12,-12,
			0,0,0,
			0,0,0,
			0,0,0,
			-12,-12,-12,
			-12,-12,-12,
			-12,-12,-12,
		],inf) +
		Pseq([
			0,-3,-1,-1
		],inf).stutter(8),
		\lpf, 2000,
		\lpf, ~pmodenv.(Pseq([20,200,20,2000,20,10000],1), 1).loop,
		\hpf, 60,
		\octave, 4,
		//\freq, 60,
		//\freq, ~pmodenv.(Pseq([30,92],1), 8).loop,
		\gain, 1/4,
		\dur, Pn(1/8,inf),
	),
).play;
);

(
Pdef(\fastdrums1, 
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Baader Meinhof - It\'s a Moral Issue.wav'),
			\legato, 1,
			\st, 129/4/60,
			\speed, 1.02 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\pos, Pseq([
				0,9,11,5, 4,5,7,5,
				8,9,10,5, 4,5,7,5,
			],inf)/8 / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
).play;
);

(
Pdef(\bip1, 
	Pbind( // bip
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono('vipere/petanque.flac'),
		\legato, 0.21,
		\gdur, 0.2,
		\gdur, ~pmodenv.(Pseq([0.2,0.1,0.01,0.001],1), 8).loop,
		\note, Pseq([
			Pseq([
				0,-3,-1,-1
			],inf).stutter(8),
		],inf),
		\octave, 7,
		\pos, Pwhite(0.0,0.01) + 1.2,
		//\pos, ~pmodenv.(Pseq([1,2.02],1), 8).loop,
		\pos, Pwhite(0.0,0.01) + Pwhite(0.0,1,inf).stutter(32),
		\hpf, 3400,
		\isRest, Pseq([
			1,1,1,1, 1,1,1,1,
		],inf).coin.not,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\dur, 1/8,
		\gain, 1/10,
		//\isRest, true,
	),
).play;
);

(
Pdef(\bip1lag, 
	Pbind( // lagged bip
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono('vipere/petanque.flac'),
		\legato, 0.71,
		\gdur, 0.2,
		\gdur, ~pmodenv.(Pseq([0.2,0.1,0.01,0.001],1), 8).loop,
		\note, Pseq([
			Pseq([
				0,-3,-1,-1
			],inf).stutter(8),
		],inf),
		\octave, 8,
		\pos, Pwhite(0.0,0.01) + 1.2,
		//\pos, ~pmodenv.(Pseq([1,2.02],1), 8).loop,
		\pos, Pwhite(0.0,0.01) + Pwhite(0.0,1,inf).stutter(32),
		\hpf, 3400,
		\lpf, 1000,
		\isRest, Pseq([
			1,1,1,1, 1,1,1,1,
		],inf).coin.not,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\dur, 1/8,
		\lag, 1/8/2/~t * Pseg(Pseq([1,0.5,1.5],inf),32),
		\gain, 1/10,
		\amp, 0.1/2 * Pseq([
			Pseg(Pseq([0,1,0.2,0.4],inf),8),
		],inf),
		//\isRest, true,
	),
).play;
);

Tdef(\seq1).clear
Tdef(\seq1).quant = 1;
(
//Tdef(\seq).quant = 1;
[\bip1, \bip1lag, \bass1, \kick1, \fastdrums1].collect({ arg x; Pdef(x).stop }); // bug workaround
Tdef(\seq1, {
	Pdef(\bass1).play;
	4.wait;
	Pdef(\bip1).play;
	2.wait;
	Pdef(\bip1lag).play;
	2.wait;
	Pdef(\kick1).play;
	4.wait;
	Pdef(\fastdrums1).play;
	2.wait; 
	nil;
	//Pdef(\bass1).stop;

}).play;
)

ClipTimeline(\sun23main).edit

(
Pdef(\bip1, 
	Pbind( // bip
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono('vipere/petanque.flac'),
		\legato, 0.21,
		\gdur, 0.2,
		\gdur, ~pmodenv.(Pseq([0.2,0.1,0.01,0.001],1), 8).loop,
		\note, Pseq([
			Pseq([
				0,-3,-1,-1
			],inf).stutter(8),
		],inf),
		\octave, 7,
		\pos, Pwhite(0.0,0.01) + 1.2,
		//\pos, ~pmodenv.(Pseq([1,2.02],1), 8).loop,
		\pos, Pwhite(0.0,0.01) + Pwhite(0.0,1,inf).stutter(32),
		\hpf, 3400,
		\isRest, Pseq([
			1,1,1,1, 1,1,1,1,
		],inf).coin.not,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\dur, 1/8,
		\gain, 1/10,
		//\isRest, true,
	),
).play;
);
(
Pdef(\bip2, 
	Pbind( // bip
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono('vipere/petanque.flac'),
		\legato, 0.21,
		\gdur, 0.2,
		\gdur, ~pmodenv.(Pseq([0.2,0.1,0.01,0.001],1), 8).loop,
		\note, Pseq([
			Pseq([
				0,-3,-1,-1
			],inf).stutter(4),
		],inf),
		\octave, 7,
		\pos, Pwhite(0.0,0.01) + 1.2,
		//\pos, ~pmodenv.(Pseq([1,2.02],1), 8).loop,
		\pos, Pwhite(0.0,0.01) + Pwhite(0.0,1,inf).stutter(32),
		\hpf, 3400,
		\isRest, Pseq([
			1,1,1,1, 1,1,1,1,
		],inf).coin.not,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.1) ],
		],inf),
		\dur, 1/4,
		\gain, 1/10,
		//\isRest, true,
	),
).play;
);

(
//Tdef(\seq).quant = 1;
Tdef(\seq2, {
	Pdef(\bip1).play;
	1.wait;
	Pdef(\fastdrums1).play;
	//Pdef(\bass1).stop;
}).reset.play;
)

[\bip1, \bip1lag, \bass1, \kick1, \fastdrums1].collect({ arg x; Pdef(x).clear })
[\bip1, \bip1lag, \bass1, \kick1, \fastdrums1].collect({ arg x; Pdef(x).stop })

Pdef(\bip1).play
Pdef(\bip1).clear
Pdef(\bip1).asStream.next(())
Pdef(\fastdrums1).asStream.next(()).play
Pdef(\fastdrums1).play
Pdef(\fastdrums1).stop
Pdef(\fastdrums1).source = Pdef(\fastdrums1).source

P

(
Pdef(\noise1, 
	Pbind(
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\pos, ~pmodenv.(Pseq([0,5,10]/44,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
		\gdur, 0.1/8 * Pseg(Pseq([
			1,2,4,9,1/2
		],inf),4),
		//\freq, 100,
		//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
		//\freq, Pseq([
			//100,99
		//],inf),
		\note, Pseq([
			Pseq([
				0,-3,-1,-1
			],inf).stutter(2),
		],inf),
		\pitch_stretch, 1/8,
		\hpf, 49,
		\octave, 3,
		\legato, 0.71,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],inf),
		\dur, 1/2,
		\gain, 4,
	),
).play;
);
Pdef(\noise1).stop

(
Pdef(\noise3, 
	Pbind(
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(0,0.02,inf).stutter(8), 8).loop,
		\gdur, 0.1/8 * Pseg(Pseq([
			1,2,4,9,1/2
		],inf),4),
		//\freq, 100,
		//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
		\freq, Pseq([
			100,40,10,
		],inf),
		\octave, 3,
		\legato, 0.71,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],inf),
		\dur, 1/2,
		\gain, 4,
	),
).play;
);

(
Pdef(\noise2, 
	Pbind(
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\mbufnum, BufDef.mono('vipere/petanque.flac'), 
		\pos, ~pmodenv.(Pseq([0,5,10]/4,1) + Pwhite(10,0.02,inf).stutter(8), 8).loop,
		\gdur, 0.1/8,
		\freq, Pseq([
			500,
			[500/2,500],
			[500/2,500,500*6],
		],inf).stutter(16),
		\octave, 6,
		\legato, 1.01,
		\adsr, Pseq([
			[ Env.adsr(0.4,0.1,0.8,1.1) ],
		],inf),
		\dur, 1/2,
		\gain, 1/3,
		\amp, 0.1 * 1/2,
	),
).play;
);

(
Pdef(\noise1par, 
	Pbind(
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\mbufnum, BufDef.mono('vipere/petanque.flac'), 
		//\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10,0.02,inf).stutter(8), 8).loop,
		\pos, 0.2,
		\gdur, 0.1/1,
		\freq, 20,
		\octave, 6,
		\legato, 0.71,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.4,1.1) ],
		],inf),
		\dur, 1/2,
		\gain, 4,
	),
).play;
);
(
Pdef(\noise1par, 
	Pbind(
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\mbufnum, BufDef.mono('vipere/petanque.flac'), 
		//\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10,0.02,inf).stutter(8), 8).loop,
		\pos, 0.2,
		\gdur, 0.1/1,
		\freq, 20,
		\octave, 6,
		\legato, 0.71,
		\isRest, Pseq([
			0,1,
		],inf).coin.not,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.4,1.1) ],
		],inf),
		\dur, 1/2,
		\gain, 4,
	),
).play;
);
Pdef(\noise1par).stop;

(
Pdef(\noise1par2, 
	Pbind(
		\instrument, \gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\mbufnum, BufDef.mono('vipere/petanque.flac'), 
		//\pos, ~pmodenv.(Pseq([0,5,10]/440,1) + Pwhite(10,0.02,inf).stutter(8), 8).loop,
		\pos, ~pmodenv.(Pseq([1,2.04],1), 8).loop,
		\gdur, 0.1/4,
		\pitch_stretch, 1/2,
		\freq, 70,
		\octave, 6,
		\legato, 1.71,
		\isRest, Pseq([
			0,1,
		],inf).coin.not,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.4,1.1) ],
		],inf),
		\dur, 1/2,
		\gain, 4,
	),
).play;
);

(
Pdef(\part, Pdef(\strangedrums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1395].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					0.1,1, 0.1,0.2, 0.1,0.2, 0.1,0.2,
				],8),
				Pseq([
					1,1, 0.1,0.2, 0.1,0.2, 0.1,0.2,
				],8),
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2468].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[726].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,0,1,
				1,1,1,1, 0,0,0,0,
				1,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([
				
				Pseq([
					1,1,1,1,
					1,1,1,1.04,
					1,1,1,1,
				],1),
				0.4,1,2,0.51,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				1,2,1,1,
			],inf).stutter(2),
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([
					1,
				],8),
				1,1.5,1.5,1.3,
				Pseq([
					1,
				],4),
			],inf) * 0.8 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.7,0.8,0.9,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],4),

				0.4,1,2,0.51,
				Pseq([
					1,1,1,1,
				],3),

				Pseq([
					1.7,0.4,0.4,0.2,
				],4),

				Pseq([
					1,1,1,1,
				],3),
				0.3,1,2,1,
			],inf),
			\pos, Pseq([
				0,1,2,3,
				4,9,10,12,
				0,1,1,1,
				4,5,5,5,
				0,0,0,0,
				4,4,4,4,
				(0..7),
				(0..7)+8,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);


(
SynthDef(\longcry, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
	// chord
Pdef(\longcry, 
	Pmono(
		\gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\pos, ~pmodenv.(Pseq([0,5,10]/80,1) + Pwhite(0,1.02,inf).stutter(8) + 1.1, 8).loop,
		\gdur, 0.03,
		//\freq, 100,
		\pitch_stretch, 1/2,
		\note, Pseq([
			[0,4,7],
		],inf),
		//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
		//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
		\lpf, 4000,
		\hpf, 100,
		\octave, 6,
		\legato, 0.71,
		\adsr, Pseq([
			[ Env.adsr(2.1,2.1,0.4,2.1) ],
		],inf),
		\dur, Pn(1/2,2*4),
		\gain, 1/8,
	),
).play;
);

(
Pdef(\longcry, 
	Pmono(
		\gregrain_norm,
		\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
		\mbufnum, BufDef.mono('voices/feynman.flac'),
		\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 1.1, 8).loop,
		\gdur, 0.01,
		//\freq, 100,
		\pitch_stretch, 1/2,
		\note, Pseq([
			[0,4,7,10],
			[0,4,7,11],
		],inf).stutter(6),
		//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
		//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
		\lpf, 14000,
		\hpf, 100,
		\octave, 6,
		\legato, 0.71,
		\adsr, Pseq([
			[ Env.adsr(2.1,2.1,0.4,2.1) ],
		],inf),
		\dur, Pn(1/2,2*4),
		\gain, 1/8,
	),
).play;
);

(
Pdef(\part, Pdef(\fchord1, 
	Ppar([
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 1.1, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 1/2,
			\note, Pseq([
				[0,4,7,10],
				[0,4,7,10],
				[0,4,7,10],
				[0,4,7,11],
			],inf).stutter(2),
			//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
			//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
			\lpf, 14000,
			\lpf, ~pmodenv.(Pseq([10,12000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([10,7000],1), 16).loop,
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(2.1,2.1,0.4,2.1) ],
			],inf),
			//\dur, Pn(1/2,2*4),
			\dur, 1/2,
			\gain, 1/8,
			\out, BusDef(\ifx1, \audio),
		),
		Pdef(\fxmirror, Pbind(\instrument, \fxmirror)) <>
		Pmono(\fxmirror,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		)
	]),
)).play;
);

Pdef(\fxmirror).edit

(
SynthDef(\fxmirror, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var num = 10;
	var fbnode;
	var del, delfmf, delfma, deldiff;
	fbnode = FbNode(2);
	sig = in;
	del = \delaytab.kr( exprand(0.001,0.5!num) );
	delfmf = \delayfmf.kr(exprand(0.001,10!num));
	delfma = \delayfma.kr(exprand(0.1,0.8!num));
	deldiff = \deldiff.kr(0.1);
	sig = num.collect { arg idx;
		var isig = sig;
		var isig1;
		isig = isig + ( ( fbnode + ( fbnode[[1,0]] * \crossfb.kr(0.5) ) ) * \fb.kr(0.7).poll * \fbgain.kr(1) );
		isig = isig * \igain.kr(1);
		isig = BPF.ar(isig, ( exprand(40,20000.0) * \bpfratio.kr(1) ).clip(20,20000), rrand(0.1,0.9));
		isig1 = DelayL.ar(isig, 0.5, del[idx] * ( SinOsc.kr(delfmf[idx] * [1,1 + deldiff]) * delfma[idx] + 1 ));
		isig = SelectX.ar(\imix.kr(0.5), [isig, isig1]);
		isig.debug("isig");
		isig;
	};
	sig = sig.mean;
	sig = HPF.ar(sig,\hpf.kr(40));
	sig = Limiter.ar(sig);
	fbnode.write(sig);
	sig = sig * \wetgain.kr(8);
	sig.debug("sig");
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\fchord1, 
	Ppar([
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 1.7, 8).loop,
			\gdur, 0.005,
			//\freq, 100,
			\pitch_stretch, 4,
			\note, Pseq([
				0,-2, -12,-2,
				0,-2, 12,-2+12,
			],inf).stutter(1),
			//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
			//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
			\lpf, 18000,
			\hpf, 100,
			//\lpf, ~pmodenv.(Pseq([10,12000],1), 8).loop,
			//\hpf, ~pmodenv.(Pseq([100,1000],1), 8).loop,
			\octave, 7,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(2.1,2.1,0.4,2.1) ],
			],inf),
			//\dur, Pn(1/2,2*4),
			\dur, 1/4 * Pseq([1-0.3,1+0.3],inf),
			\amp, 0.1 * Pseg(Pseq([0,0.1,1,0.3,0.7],inf),8),
			\gain, 1/8,
		),
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 0.7, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 2,
			\note, Pseq([
				0,-2
			],inf).stutter(1),
			//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
			//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
			\lpf, 14000,
			//\lpf, ~pmodenv.(Pseq([10,12000],1), 8).loop,
			//\hpf, ~pmodenv.(Pseq([100,1000],1), 8).loop,
			\octave, 7,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(2.1,2.1,0.4,2.1) ],
			],inf),
			//\dur, Pn(1/2,2*4),
			\dur, 1/4,
			\gain, 1/8,
		),
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 1.1, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 1/2,
			\note, Pseq([
				[0,4,7,10,4+12,7-12],
				[0,4,7,10,4+12,7-12],
				[0,3,7,10,3+12,7-12],
				[0,3,7,10,3+12,7-12],
				//[0,3,7,9,3+12,7-12],
				//[0,3,6,8,3+12,6-12],
			],inf).stutter(4),
			//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
			//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
			\lpf, 14000,
			\lpf, ~pmodenv.(Pseq([10,12000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([100,1000],1), 8).loop,
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(2.1,2.1,0.4,2.1) ],
			],inf),
			//\dur, Pn(1/2,2*4),
			\dur, 1/2,
			\gain, 1/8,
			//\isRest, true,
		),
	]),
)).play;
);

(
Pdef(\part, Pdef(\fchord1, 
	Ppar([
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/18,1) + Pwhite(0,0.02,inf).stutter(8) + 0.4, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 8,
			\note, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				0,-2, -12,0, 0,0, 0,-2+12,

				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				0,-2, -12,-2, 0,-2, 12,-2+12,

				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				0,0, 0,-12, 0,0, 0,-2+12,

				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				Pseq([ 0,0,0,0, 0,0,0,0, ],1),
				Pseq([ 0,0,0,0, 0,0,0,0, ],1)-2,
				0,-2, -12,-2, 0,-2, 12,-2+12,
			],inf).stutter(2),
			//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
			//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
			\lpf, 1000,
			\hpf, 500,
			//\lpf, ~pmodenv.(Pseq([10,12000],1), 8).loop,
			//\hpf, ~pmodenv.(Pseq([100,1000],1), 8).loop,
			\octave, 7,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(2.1,2.1,0.4,2.1) ],
			],inf),
			//\dur, Pn(1/2,2*4),
			\dur, 1/32 * Pseq([1-0.3,1+0.3],inf),
			\amp, 0.1 * Pseg(Pseq([0,0.1,1,0.3,0.7],inf),8),
			\gain, 1/8,
		),
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 0.7, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 2,
			\note, Pseq([
				0,-2
			],inf).stutter(1),
			//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
			//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
			\lpf, 14000,
			//\lpf, ~pmodenv.(Pseq([10,12000],1), 8).loop,
			//\hpf, ~pmodenv.(Pseq([100,1000],1), 8).loop,
			\octave, 7,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(2.1,2.1,0.4,2.1) ],
			],inf),
			//\dur, Pn(1/2,2*4),
			\dur, 1/4,
			\amp, 0.1 * Pseg(Pseq([0,0.1,1,0.3,0.7],inf),5),
			\gain, 1/8,
		),
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 1.1, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 1/2,
			\note, Pseq([
				[0,4,7,10,4+12,7-12],
				[0,4,7,10,4+12,7-12],
				[0,3,7,10,3+12,7-12],
				[0,3,7,10,3+12,7-12],
				//[0,3,7,9,3+12,7-12],
				//[0,3,6,8,3+12,6-12],
			],inf).stutter(4),
			//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
			//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
			\lpf, 14000,
			\lpf, ~pmodenv.(Pseq([10,1000,12000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([100,1000],1), 8).loop,
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(2.1,2.1,0.4,2.1) ],
			],inf),
			//\dur, Pn(1/2,2*4),
			\dur, 1/2,
			\gain, 1/8,
			//\isRest, true,
		),
	]),
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('vipere/metal.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,0.02,inf).stutter(8) + 0.1, 8).loop,
			\gdur, [0.001,0.01],
			//\freq, 100,
			\pitch_stretch, [1,1/2,2],
			\note, Pseq([
				[0,4,7,10,4+12,7-12],
				[0,3,7,10,3+12,7-12],
				[-1,3,7,10,3+12,7-12],
				[0,3,7,10,3+12,7-12],
				//[0,3,7,9,3+12,7-12],
				//[0,3,6,8,3+12,6-12],
			],inf).stutter(4),
			//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
			//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
			\lpf, 14000,
			\lpf, ~pmodenv.(Pseq([10,1000,12000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([100,1000],1), 8).loop,
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(2.1,2.1,0.4,2.1) ],
			],inf),
			//\dur, Pn(1/2,2*4),
			\dur, 1/2,
			\gain, 1/8,
			//\isRest, true,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			\gregrain_norm,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('vipere/metal.flac'),
			\pos, Ptuple(4.collect { arg idx;
				~pmodenv.(Pseq([0,5,10]/148,1) + Pwhite(0,0.02,inf).stutter(8) + 0.9, 8+idx).loop
			}),
			\gdur, [0.016,0.01],
			//\freq, 100,
			\pitch_stretch, [1,5/4,2],
			\note, Pseq([
				[0,4,7,10,4+12,7-12],
				[0,3,7,10,3+12,7-12],
				[-1,3,7,10,3+12,-1-12],
				[0,3,7,10,3+12,0-12],
				//[0,3,7,9,3+12,7-12],
				//[0,3,6,8,3+12,6-12],
			],inf).stutter(4),
			//\freq, ~pmodenv.(Pseq([0,0.1].midiratio * 70.midicps,1), 1).loop,
			//\freq, ~pmodenv.(Pseq([0,2,1,4].midiratio * 100,1), 1).loop,
			\lpf, 14000,
			\lpf, ~pmodenv.(Pseq([10,1000,12000],1), 8).loop,
			\hpf, ~pmodenv.(Pseq([60,300],1), 8).loop,
			\octave, 6,
			\legato, 0.71,
			\adsr, Pseq([
				[ Env.adsr(2.1,2.1,0.4,2.1) ],
			],inf),
			//\dur, Pn(1/2,2*4),
			\dur, 1/2,
			\gain, 1/8,
			\amp, 0.1/2,
			//\isRest, true,
		),
		
	])
)).play;
);

(
SynthDef(\kipik, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * ( SinOsc.ar(freq*\fmfr.kr(2)) * \fma.kr(1) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\ctranspose, Pstep(Pseq([
				0,10,
			],inf),4),
		)<>
		Pspawner({ arg sp;
			loop  {
				(rrand(0,4)/4).wait;
				sp.par(
					Pfindur([2,4,6,8,12].choose*2,Pbind(
						\instrument, \kipik,
						\note, Pseq([
							[0,4,7,10].choose + [-12,0,0,0,12,24].choose,
						],inf),
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,2.1) ],
						],inf),
						\fmfr, [0,-12,12,4,5].midiratio.choose,
						\legato, exprand(0.1,1),
						\lpfr, rrand(0.6,3.1),
						\lag, rrand(0.0,1.1),
						\fma, rrand(0.1,1),
						//\dur, Pn([1,1/2,1/8].choose,[2,8,12,16,32].choose*4),
						//\dur, PdurStutter(Prand([1,4,2,8,16],[2,4,8].choose).stutter(4), 1),
						\dur, exprand(0.1,4),
						\isRest, Pseq([
							1,0,
						],inf).coin.not.stutter([2,4,6,8].choose*8),
						\amp, 0.1/8,
					)),
					
				);
				2.wait;
			}
		}),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\ctranspose, Pstep(Pseq([
				0,10,
			],inf),4),
		)<>
		Pspawner({ arg sp;
			loop  {
				(rrand(0,4)/4).wait;
				sp.par(
					Pbind(
						\instrument, \kipik,
						\note, Pseq([
							[0,4,7,10].choose + [-12,0,0,0,12].choose,
						],inf),
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,2.1) ],
						],inf),
						\fmfr, [1,2,1/2,4/5,5/8,6/14,1,2,1/2].choose,
						\legato, rrand(0.1,1),
						\lpfr, rrand(0.6,3.1),
						\lag, rrand(0.0,1.1),
						\fma, rrand(0.1,2),
						//\dur, Pn([1,1/2,1/8].choose,[2,8,12,16,32].choose*4),
						//\dur, PdurStutter(Prand([1,4,2,8,16],[2,4,8].choose).stutter(4), 1),
						\dur, Pwhite(0.1,1),
						\amp, 0.1/8,
					),
					
				);
				1.wait;
			}
		}),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\ctranspose, Pstep(Pseq([
				0,10,
			],inf),4),
		)<>
		Pspawner({ arg sp;
			loop  {
				(rrand(0,4)/4).wait;
				sp.par(
					Pbind(
						\instrument, \kipik,
						\note, Pseq([
							[0,4,7,10].choose + [-12,0,0,0,12].choose,
						],inf),
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,2.1) ],
						],inf),
						\fmfr, [1,2,1/2,4/5,7/8,11/14,1,2,1/2].choose,
						\legato, rrand(0.1,1),
						\lpfr, rrand(0.6,3.1),
						\lag, rrand(0.0,0.1),
						\fma, rrand(0.1,2),
						\dur, Pn([1,1/2,1/8].choose,[2,8,12,16,32].choose*4),
						\dur, PdurStutter(Prand([1,4,2,8,16],[2,4,8].choose).stutter(4), 1),
						\amp, 0.1/8,
					),
					
				);
				1.wait;
			}
		}),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kipik,
			\freq, 700,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


////////// fx echo

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kipik,
			\degree, Pseq([0,4,7,9,11],inf),
			\sustain, 0.1,
			\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/2/~t,
			\delay, ~pmodenv.(Pseq([1,1/2,1,1/4]/8/~t,1), 8).loop,
			\decay, 8,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			loop  {
				sp.par(
					Pbind(
						\instrument, \kipik,
						\degree, Pseq([ [0,4,7,9,11].choose ],inf),
						\octave, [3,4,5,6].choose,
						\sustain, 0.1,
						//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
						\lpfr, rrand(0.6,4),
						\dur, rrand(1/4,3),
						\amp, 0.1/2,
						\out, BusDef(\ifx1, \audio),
					)
				);
				rrand(1,4.0).wait;
			}
		}),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/4/~t,
			//\delay, ~pmodenv.(Pseq([1,1/2,1,1/4]/8/~t,1), 8).loop,
			\decay, 8,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			loop  {
				sp.par(
					Pbind(
						\instrument, \kipik,
						\degree, Pseq([ [0,4,7,9,11].choose ],inf),
						\octave, [3,4,5,6].choose,
						\sustain, 0.1,
						//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
						\lpfr, rrand(0.6,4),
						\dur, rrand(1/4,3),
						\amp, 0.1/2,
						\out, BusDef(\ifx1, \audio),
					)
				);
				rrand(1,4.0).wait;
			}
		}),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/4/~t,
			//\delay, ~pmodenv.(Pseq([1,1/2,1,1/4]/8/~t,1), 8).loop,
			\decay, 8,
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
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf),8),
		) <>
		Pspawner({ arg sp;
			loop  {
				sp.par(
					Pfindur(rrand(8,32),Pbind(
						\instrument, \kipik,
						\note, Pseq([ [0,4,7,9,11].choose ],inf),
						\octave, [3,4,5,3,4,5,6].choose,
						\sustain, 0.1,
						\fmfr, [1/2,1/3,2,1].choose,
						//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
						\lpfr, exprand(0.6,4),
						\dur, rrand(1/4,3),
						\amp, 0.1/2,
						\out, BusDef(\ifx1, \audio),
					))
				);
				rrand(1,4.0).wait;
			}
		}),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/~t,
			//\delay, ~pmodenv.(Pseq([1,1/2,1,1/4]/8/~t,1), 8).loop,
			\decay, 8,
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
			\ctranspose, Pstep(Pseq([
				0,5,
			],inf),8),
		) <>
		Pspawner({ arg sp;
			loop  {
				sp.par(
					Pfindur(rrand(8,32),Pbind(
						\instrument, \kipik,
						\note, Pseq([ [0,4,7,9,11].choose ],inf),
						\octave, [3,4,5,3,4,5,6].choose,
						\sustain, 0.1,
						\fmfr, [1/2,1/3,2,1].choose,
						\fma, ~pmodenv.(Pseq([1,0.1,10,2,1,4],1), rrand(1/3,15)).loop,
						//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
						\lpfr, exprand(0.6,4),
						\dur, exprand(1/8,3),
						\amp, 0.1/2,
						\out, BusDef(\ifx1, \audio),
					))
				);
				rrand(1,4.0).wait;
			}
		}),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\delay, 2/3/~t,
			//\delay, ~pmodenv.(Pseq([1,1/2,1,1/4]/8/~t,1), 8).loop,
			\decay, 8,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * [1,2.01] * LFNoise2.kr(2).range(0.9,1.2)).mean * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(7));
	sig = LFSaw.ar(freq*3 * [1,2.01] * LFNoise2.kr(2).range(0.9,1.2)).mean * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(1)) + sig;
	sig = CombL.ar(sig, 4/~t, 1/2/~t,8*2/~t) + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * [1,2.01] * LFNoise2.kr(2).range(0.9,1.2)).mean * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(7));
	sig = LFSaw.ar(freq*3 * [1,2.01] * LFNoise2.kr(2).range(0.9,1.2)).mean * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(1)) + sig;
	sig = CombL.ar(sig, 4/~t, 1/2/~t * LFNoise1.kr(0.1).range(0.9,1.1),8*2/~t) + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * [1,1.01] * LFNoise2.kr(2).range(0.9,1.2)).mean * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(7));
	sig = CombL.ar(sig, 4/~t, 1/2/~t,8/~t) + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFCub.ar(freq*2 * [1,1.01] * LFNoise2.kr(2).range(0.9,1.2)).mean * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(1));
	sig = CombL.ar(sig, 4/~t, 1/2/~t * [ [1,2,1/2,1/4] ],8/~t).flop.mean + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFCub.ar(freq * [1,1.01] * LFNoise2.kr(2).range(0.2,7.2)).mean * EnvGen.kr(Env([0,1,0],[0.01,0.02]), Dust.kr(3)) * 2;
	sig = CombL.ar(sig, 4/~t, 1/2/~t * [ LFNoise1.kr(0.1!4).range(0.5,1.5) ],8*2/~t).flop.mean + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * LFNoise2.kr(2).range(0.2,4.0)) * EnvGen.kr(Env([0,1,0],[0.01,0.1]), Dust.kr(2));
	sig = CombL.ar(sig, 4/~t, 1/2/~t,8/~t) + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * LFNoise0.kr(2).range(0.2,4.0)) * EnvGen.kr(Env([0,1,0],[0.01,0.1]), Dust.kr(2));
	sig = CombL.ar(sig, 4/~t, 1/3/~t,8/~t) + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * LFNoise2.kr(2).range(0.2,4.0)) * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(XLine.kr(1/2,10,40)));
	sig = CombL.ar(sig, 4/~t, 1/2/~t,8*2/~t) + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * LFNoise2.kr(2).range(0.2,4.0)) * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(XLine.kr(1/2,10,40)));
	sig = CombL.ar(sig, 4/~t, 1/2/~t * XLine.kr(8.1,0.1,40),8*2/~t) + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * XLine.kr(8,1/4,50) * LFNoise2.kr(2).range(0.2,4.0)) * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(XLine.kr(1/2,10,40)));
	sig = CombL.ar(sig, 4/~t, 1/2/~t * XLine.kr(8.1,0.1,40),8*2/~t) + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * XLine.kr(8,1/4,50)) * EnvGen.kr(Env([0,1,0],[0.01,0.05]), Dust.kr(XLine.kr(2,10,40)));
	sig = CombL.ar(sig, 4/~t, 1/2/~t * XLine.kr(8.1,0.1,40),8*2/~t) + sig;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\punchy, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * EnvGen.kr(Env([1,1,0.1],[0.01,0.08]), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1531].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([
					1,
				],8),
				1,1.5,1.5,1.3,
				Pseq([
					1,
				],4),
			],inf) * 0.8 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.7,0,0.7,
				1,0.7,1,0.7,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],4)*0.5,

				0.4,1,2,0.51,
				Pseq([
					1,1,1,1,
				],3)*0.7,

				Pseq([
					1.7,0.4,0.4,0.2,
				],4),

				Pseq([
					1,1,1,1,
				],3)*0.5,
				0.3,1,2,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				\r,1,4,3,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([
					1,
				],4),
			],inf) * 0.8 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\isRest, Pseq([
				1
			],inf).coin.not,
			\legato, Pseq([
				1/4,
			],inf),
			\pos, Pseq([
				\r,3,3,3,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \punchy,
			\note, Pseq([
				0,
			],inf),
			\freq, 120,
			\octave, 4,
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);


///////////// chaos composition
(
SynthDef(\kipik2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpfenv.kr(Env([1,2,1],[0.1,0.8])), 1);
	sig = LFPulse.ar(freq * ( SinOsc.ar(freq*\fmfr.kr(2)) * \fma.kr(1) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * env1 * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fxcombhorror, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = CombL.ar(sig, \maxdelay.kr(4/~t), \delay.kr(2/~t) * [ LFNoise1.kr(\noiseftab.kr(0.01!4)) * \noiseamp.kr(1) + 1 ],\decay.kr(8*2/~t)).flop.mean;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kipik2,
			\note, Pseq([
				0,5,9,14,
			],inf),
			\legato, 0.1,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxcombhorror,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
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
			\instrument, \kipik2,
			\note, Pseq([
				0,3,7,
			],inf),
			\lpfenv, Pseq([
				[ Env([1,4,1/4],[0.01,0.1]) ]
			],inf),
			\legato, 0.2,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxcombhorror,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
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
			\instrument, \kipik2,
			\note, Pseq([
				0,3,7,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,5,-1,-2
			],inf),4),
			\lpfenv, Prand([
				[ Env([1,4,1/4],[0.01,0.1]) ],
				[ Env([4,1/2,1],[0.01,0.1]) ],
			],inf),
			\legato, 0.2,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxcombhorror,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\noiseamp, 0.9,
			\delay, 1/6/~t,
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
			\instrument, \kipik2,
			\note, Pseq([
				0,3,7,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,5,-1,-2
			],inf),8),
			\lpfenv, Prand([
				[ Env([1,4,1/4],[0.01,0.1]) ],
				[ Env([4,1/2,1],[0.01,0.1]) ],
				[ Env([4,1,2],[0.01,0.1]) ],
			],inf),
			\legato, 0.2,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxcombhorror,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\noiseamp, 0.9,
			\delay, 4/3/~t,
			\mix, 0.6,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \kipik2,
			\note, Pseq([
				0,3,7,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,5,-1,-2
			],inf),8),
			\lpfenv, Prand([
				[ Env([1,4,1/4],[0.01,0.1]) ],
				[ Env([4,1/2,1],[0.01,0.1]) ],
				[ Env([4,1,2],[0.01,0.1]) ],
			],inf),
			\legato, 0.2,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxcombhorror,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\noiseamp, 0.9,
			\delay, 4/3/~t,
			\mix, 0.6,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

/////////////////////////////////
/// grain ambient

(
SynthDef(\gregrain_chaos, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	clk = Dust.ar(freq);
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0,0.1,-0.9],inf);
	lfo1 = ( LFNoise1.kr(100) * 0.005 );
	lfo2 = ( Phasor.kr(1, 100 * 0.5/s.sampleRate, 0, BufDur.kr(mbufnum))).poll;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos + lfo2 + lfo1 % BufDur.kr(mbufnum), gdur, 0, 1);
	//sig = HPF.ar(sig, \hpf.kr(180));
	//sig = LPF.ar(sig, \lpf.kr(18000));
	//sig = Normalizer.ar(sig);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_chaos,
			\mbufnum, BufDef.mono('vfoley/box1.flac'),
			\legato, 1.01,
			\gdur, 0.02,
			\freq, 444,
			\pitch_stretch, 1,
			\pos, Pwhite(0.0,0.01) + 1.2,
			//\pos, ~pmodenv.(Pseq([0.1,1/4],1), 1/2).loop,
			\pos, 0.00,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2,
			\gain, 3,
		)
		
	])
)).play;
);


(
SynthDef(\gregrain_chaos, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	clk = Dust.ar(freq);
	//clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0,0.1,-0.9],inf);
	lfo1 = ( LFNoise1.ar(\posrandfreq.kr(100)) * \posrandamt.kr(0.005) );
	lfo2 = ( Phasor.kr(1, 100 * 0.5/s.sampleRate, 0, BufDur.kr(mbufnum))) * \phasoramt.kr(0);
	lfo3 = ( LFNoise1.ar(\pitchrandfreq.kr(1)) * \pitchrandamt.kr(0.5) + 1 );
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch * lfo3, pos + lfo2 + lfo1 % BufDur.kr(mbufnum), gdur, 0, 1);
	//sig = HPF.ar(sig, \hpf.kr(180));
	//sig = LPF.ar(sig, \lpf.kr(18000));
	//sig = Normalizer.ar(sig);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_chaos,
			\mbufnum, BufDef.mono('vfoley/box1.flac'),
			\legato, 1.01,
			\gdur, 0.4,
			\freq, 4,
			\pitch_stretch, 1,
			\pos, Pwhite(0.0,0.01) + 1.2,
			//\pos, ~pmodenv.(Pseq([0.1,1/4],1), 1/2).loop,
			\pos, Pseq([
				0.65,
				0.60,
			],inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\posrandamt, 0.1,
			\phasoramt, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2,
			\gain, 3,
		)
		
	])
)).play;
);


(
SynthDef(\gregrain_chaos, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	clk = Dust.ar(freq);
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0,0.1,-0.9],inf);
	lfo1 = ( LFNoise1.ar(\posrandfreq.kr(100)) * \posrandamt.kr(0.005) );
	lfo2 = ( Phasor.kr(1, 100 * 0.5/s.sampleRate, 0, BufDur.kr(mbufnum))) * \phasoramt.kr(0);
	lfo3 = ( LFNoise0.ar(\pitchrandfreq.kr(113)) * \pitchrandamt.kr(0.5) + 1 );
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch * lfo3, pos + lfo2 + lfo1 % BufDur.kr(mbufnum), gdur, 0, 1);
	//sig = HPF.ar(sig, \hpf.kr(180));
	//sig = LPF.ar(sig, \lpf.kr(18000));
	//sig = Normalizer.ar(sig);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_chaos,
			\mbufnum, BufDef.mono('vfoley/box1.flac'),
			\legato, 1.01,
			\gdur, 0.03,
			\freq, 434,
			\pitch_stretch, 1,
			\pos, Pwhite(0.0,0.01) + 1.2,
			//\pos, ~pmodenv.(Pseq([0.1,1/4],1), 1/2).loop,
			\pos, Pseq([
				0.65,
				0.60,
			],inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\posrandamt, 0.1,
			\phasoramt, 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2,
			\gain, 3,
		)
		
	])
)).play;
);

(
SynthDef(\gregrain_chaos, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	clk = Dust.ar(freq);
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0,0.1,-0.9],inf);
	lfo1 = ( LFNoise1.ar(\posrandfreq.kr(100)) * \posrandamt.kr(0.005) );
	lfo2 = ( Phasor.kr(1, 100 * 0.5/s.sampleRate, 0, BufDur.kr(mbufnum))) * \phasoramt.kr(0);
	lfo3 = ( LFNoise0.ar(\pitchrandfreq.kr(113)) * \pitchrandamt.kr(0.5) + 1 );
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch * lfo3, pos + lfo2 + lfo1 % BufDur.kr(mbufnum), gdur, 0, 1);
	//sig = HPF.ar(sig, \hpf.kr(180));
	//sig = LPF.ar(sig, \lpf.kr(18000));
	//sig = Normalizer.ar(sig);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
	// grince
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_chaos,
			\mbufnum, BufDef.mono('vfoley/box1.flac'),
			\legato, 1.01,
			\gdur, 0.17,
			\freq, 134,
			\pitch_stretch, 1,
			\pitchrandamt, 0.01,
			\pos, Pwhite(0.0,0.01) + 1.2,
			//\pos, ~pmodenv.(Pseq([0.1,1/4],1), 1/2).loop,
			\pos, Pseq([
				0.0,
				0.1,
				0.3,
				0.4,
				0.65,
			],inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\posrandamt, 0.3,
			\phasoramt, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2,
			\gain, 3,
		)
		
	])
)).play;
);

(
SynthDef(\gregrain_chaos, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	clk = Dust.ar(freq);
	clk = Impulse.ar(freq);
	pan = Dseq([1,0.4,-1,0,0.1,-0.9],inf);
	lfo1 = ( LFNoise1.ar(\posrandfreq.kr(100)) * \posrandamt.kr(0.005) );
	lfo2 = ( Phasor.kr(1, 100 * 0.5/s.sampleRate, 0, BufDur.kr(mbufnum))) * \phasoramt.kr(0);
	lfo3 = ( LFNoise0.ar(\pitchrandfreq.kr(113)) * \pitchrandamt.kr(0.5) + 1 );
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch * lfo3, pos + lfo2 + lfo1 % BufDur.kr(mbufnum), gdur, 0, 1);
	//sig = HPF.ar(sig, \hpf.kr(180));
	//sig = LPF.ar(sig, \lpf.kr(18000));
	//sig = Normalizer.ar(sig);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_chaos,
			\mbufnum, BufDef.mono('vfoley/box1.flac'),
			\legato, 1.01,
			\gdur, 0.01,
			\freq, 514,
			\pitch_stretch, 1,
			\pitchrandamt, 0.01,
			\pos, Pseq([
				0.0,
				0.1,
				0.3,
				0.4,
				0.65,
			],inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\posrandamt, 0.03,
			\phasoramt, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2,
			\gain, 3,
		)
		
	])
)).play;
);

(
SynthDef(\gregrain_chaos, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	clk = Dust.ar(freq);
	clk = Impulse.ar(freq);
	//pan = Dseq([1,0.4,-1,0,0.1,-0.9],inf);
	lfo1 = ( LFNoise1.ar(\posrandfreq.kr(100)) * \posrandamt.kr(0.005) );
	lfo2 = ( Phasor.kr(1, 100 * 0.5/s.sampleRate, 0, BufDur.kr(mbufnum))) * \phasoramt.kr(0);
	lfo3 = ( LFNoise0.ar(\pitchrandfreq.kr(113)) * \pitchrandamt.kr(0.5) + 1 );
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch * lfo3, pos + lfo2 + lfo1 % BufDur.kr(mbufnum), gdur, pan, 1);
	//sig = HPF.ar(sig, \hpf.kr(180));
	//sig = LPF.ar(sig, \lpf.kr(18000));
	//sig = Normalizer.ar(sig);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gregrain_chaos,
			\mbufnum, BufDef.mono('vfoley/box1.flac'),
			\legato, 1.01,
			\gdur, 0.1,
			\freq, 1514,
			\pitch_stretch, 1,
			\pitchrandamt, 0.01,
			\pos, Pseq([
				0.0,
				0.1,
				0.3,
				0.4,
				0.65,
			],inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\posrandamt, 0.03,
			\phasoramt, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2,
			\pan, ~pmodenv.(Pseq([-1,0.2,-0.4,0.7],1), Prand([1,3,6],inf)).loop,
			\gain, ~pmodenv.(Pseq([1,0.1,0.7,0.3],1), Prand([1,3],inf)).loop,
			\out, BusDef(\sendbus1, \audio),
		)
		
	])
)).play;
);




///////////// deepbass groove

(
SynthDef(\punchbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,2],[1.1,0.8]), 1);
	sig = SinOsc.ar( EnvGen.kr(Env([150,60,50],[0.09,0.8]), 1) * ( SinOsc.ar(2*~t) * 0.1 * env1 + 1 ) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\punchbass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fmaenv.kr(Env([0,1,6],[0.1,0.8])), 1);
	sig = SinOsc.ar( EnvGen.kr(Env([100,40,70],[0.1,0.8]), 1) * ( SinOsc.ar(\fmf.kr(4*~t)) * env1 * \fma.kr(0.1) + 1 ) * ( SinOsc.ar(60) * 0.1 + 1 ) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



(
Pdef(\part2, Pdef(\deepbass, 
	Ppar([
		Pbind(
			\instrument, \punchbass,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \punchbass2,
			\dur, 1,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\calmdrums3, 
	Ppar([
		Pbind(
			\instrument, \punchbass,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \punchbass2,
			\dur, 1,
			\fmaenv, Pseq([
				[ Env([1,2,1],[0.1,0.8]) ],
				[ Env([1,2,4],[0.1,0.8]) ],
			],inf).stutter(2),
			\legato, 1,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],2) * 0.6,
				Pseq([
					1,1,1,1,
				],1)/4,
			],inf),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				Pser([
					2,5,13,
				],16),
				Pser([
					6,6,6,
					14,14,14,
				],16),
				Pser([
					5,2,14,
				],16),
				//7,10,6,
			],inf)/16 / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.5 * Pseq([
				Pser([
					1,0.6,0.7,
					1,0.6,0.3,
					1,0.6,
				],8*4),
				Pser([
					1,0.6,
				],8*4),
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				0,8,
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				4
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\calmdrum4, 
	Ppar([
		Pbind(
			\instrument, \punchbass,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \punchbass2,
			\dur, 1,
			\fmaenv, Pseq([
				[ Env([1,2,1],[0.1,0.8]) ],
				[ Env([1,2,4],[0.1,0.8]) ],
			],inf).stutter(2),
			\legato, 1,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				0,8,
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				4
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				18
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,0,1,0, 0,1,0,0,
				0,1,0,0, 1,0,0,1,

				0,0,0,0, 0,0,0,1,
				0,0,1,1, 0,0,1,0,
				1,0,1,0, 1,0,1,1,

				0,0,1,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\calmdrums1, 
	Ppar([
		Pbind(
			\instrument, \punchbass,
			\dur, 2,
			\isRest, Pseq([
				Pser([1],3),
				0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \punchbass2,
			\dur, 1,
			\fmaenv, Pseq([
				[ Env([1,2,1],[0.1,0.8]) ],
				[ Env([1,2,4],[0.1,0.8]) ],
			],inf).stutter(2),
			\legato, 1,
			\isRest, Pseq([
				Pser([0,1],6),
				0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \punchbass,
			\dur, 1/8,
			\isRest, Pseq([
				Pser([0],8*6),
				0,0,1,0, 0,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				0,8,
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				4
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				18
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,0,1,0, 0,1,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,1, 0,0,1,0,

				1,0,1,0, 1,0,1,1,
				0,0,1,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
	])
)).play;
);

(
Pdef(\part2, Pdef(\calmdrums2, 
	Ppar([
		Pbind(
			\instrument, \punchbass,
			\dur, 1/8,
			\legato, Pseq([
				4,0,0,0, 0,1,1,1,
				2,0,0,1, 0,1,0,1,
				4,0,0,0, 0,0,1,1,
				2,0,1,0, 0,1,1,0,

				4,0,0,0, 0,1,1,1,
				2,0,0,1, 0,1,0,1,
				4,0,0,0, 0,0,1,0,
				2,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/2,
		),
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				0,8,
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				4
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
		Pbind( // small snare
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				12
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,1,0,0,
				0,0,0,0.4, 0,0,0,0,
				0,0,1,0, 0,0.71,0,1,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1/3,1/4,1/2,1/4
				
			],inf),
		),
		Pbind( // sparse hat
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				18
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,0,1,0, 0,1,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,1, 0,0,1,0,

				1,0,1,0, 1,0,1,1,
				0,0,1,0, 1,0,0,1,
				1,0,0,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),
	])
)).play;
);


(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pdef(\calmdrums1),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[347].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.01,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[346].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,1, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,1, 1,0,1,1,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \shorthinoise1,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1,
			\bpftab, Pfunc({ arg ev;
				thisThread.randSeed = 2;
				[ exprand(100,17000!10) ]
			}),
			\isRest, Pseq([
				0,1,
				0,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 2,
			\sustain, 0.05,
			\pos, 0.60,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\hpf, 1000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,1) ],
			],inf),
			//\lag, 1/8/2/~t,
			\dur, 1/8,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \shorthinoise2,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1/1,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				[0,12]-24,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,0.1,1,-2) ],
			],inf),
			\isRest, Pseq([
				0,0, 0,0,
				0,0,0,1,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pdef(\calmdrums1),
		Pbind(
			\instrument, \shorthinoise1,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 4/1,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				3,0,0,3, 0,0,2,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[708].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				Pseq([
					1,0,1,1, 1,1,1,0,
				],1),
				Pseq([
					1,0,1,0, 1,0,1,0,
				],6),
				0,0,0,0, 1,1,1,1,
				1,1,1,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.07 * Pseq([
				1,0.3,0.8,0.6
			],inf),
		),
		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				//[0,12]-24,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				1,-1,-1,0,1,0,0,0,
				1,-1,-1,0,1,0,0,0,
			],inf).stutter(1),
			\octave, [3,4],
			\det, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01,1,-2) ],
			],inf),
			\legato, Pseq([
				4,0,0,0, 1,0,0,0,
				4,0,0,0, 0,0,1,0,
				4,0,0,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,

				4,0,0,0, 0,0,0,1,
				3,0,0,2, 0,3,0,0,
				4,0,0,0, 0,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/B.T. Express - Still Good - Still Like It.wav'),
			\st, 122/4/60,
			\speed, 0.91 * ~t / Pkey(\st),
			\pos, Pseq([
				0,8,
			],inf)/16 / Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				0,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1
				
			],inf),
		),

		Pbind(
			\instrument, \basicpad,
			\note, Pseq([
				//[0,12]-24,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				0,-1,-1,0,1,0,0,0,
				1,-1,-1,0,1,0,0,0,
				1,-1,-1,0,1,0,0,0,
			],inf).stutter(1),
			\octave, [3,4],
			\det, 0.01,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01,1,-2) ],
			],inf),
			\legato, Pseq([
				4,0,0,0, 1,0,0,0,
				4,0,0,0, 0,0,1,0,
				4,0,0,0, 1,0,0,1,
				1,1,1,1, 1,1,1,1,

				4,0,0,0, 0,0,0,1,
				3,0,0,2, 0,3,0,0,
				4,0,0,0, 0,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 2,
			\sustain, 0.05,
			\pos, 0.60,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\hpf, 1000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,1) ],
			],inf),
			//\lag, 1/8/2/~t,
			\dur, 1/8,
			\gain, 1/6,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 2,
			\sustain, 0.05,
			\pos, 0.61,
			\isRest, Pseq([
				0,1,0,0, 0,1,0,1,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\hpf, 1000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,1) ],
			],inf),
			//\lag, 1/8/2/~t,
			\dur, 1/8,
			\gain, 1/8/2,
		),
		Pbind(
			\instrument, \shorthinoise3,
			\freq, 800,
			\legato, 1.0,
			\timeScale, 1,
			\rseed, Pseq([
				15,20,
				15,20,
				15,20,
				15,20,
				15,15,20,
				15,15,20,
			],inf)+2,
			\bpftab, Pfunc({ arg ev;
				thisThread.randSeed = ev[\rseed];
				[ exprand(50,12000!10) ]
			}),
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\legato, Pseq([
				0,0,2,0, 4,0,0,2,
				0,0,2,0, 0,2,0,4,
				0,0,2,0, 4,0,0,2,
				0,0,2,0, 0,2,0,4,
			],inf),
			\lpfenv, [ Env([6000,200,1000],[0.1,0.8]) ],
			\lpfenv, [ Env([10000,20,1350],[0.2,2.2],1,1) ],
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1,1,1) ],
				[ Env.adsr(0.051,0.1,0.8,0.01,1,1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \shorthinoise2,
			\freq, 800,
			\legato, 1.0,
			\timeScale, 1/1,
			\bpftab, Pfunc({ arg ev;
				thisThread.randSeed = 9;
				[ exprand(50,19000!10) ]
			}),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(2.1,0.1,0.8,0.01,1,3) ],
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


Pdef(\part2).clear;

//////////////

(
SynthDef(\shorthinoise1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var bpftab;
	env1 = EnvGen.kr(Env([1,1,0.1],[1.1,0.1],1,1), gate, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,2,0.1],[0.1,0.8]), 1);
	sig = PinkNoise.ar;
	bpftab = \bpftab.kr(exprand(100,17000!num));
	sig = num.collect { arg idx;
		BPF.ar(sig, bpftab[idx] * env1,0.1 * env2);
	};
	sig = sig.sum * 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.9)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\shorthinoise2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var bpftab;
	env1 = EnvGen.kr(Env([1,1,1],[1.1,0.1],1,1), gate, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,2,0.1],[1.1,0.8]), 1);
	env3 = EnvGen.kr(Env([100,10000,100],[1.1,0.1],1,1), gate, timeScale:timeScale);
	sig = PinkNoise.ar;
	bpftab = \bpftab.kr(exprand(100,17000!num));
	sig = num.collect { arg idx;
		BPF.ar(sig, bpftab[idx] * env1,0.1 * env2);
	};
	sig = sig.sum * 2;
	sig = LPF.ar(sig, env3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \shorthinoise2,
			\freq, 200,
			\legato, 0.9,
			\timeScale, 1/1,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 5,
			\sustain, 0.05,
			\pos, 0.30,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,1) ],
			],inf),
			\dur, 1,
			\gain, 1/6,
		)
		
	])
)).play;
);

(
SynthDef(\shorthinoise3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num = 10;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var bpftab;
	env1 = EnvGen.kr(Env([1,1,1],[1.1,0.1],1,1), gate, timeScale:timeScale);
	env2 = EnvGen.kr(Env([1,2,0.1],[1.1,0.8]), 1);
	env3 = EnvGen.kr(\lpfenv.kr(Env([100,10000,100],[1.1,0.1],1,1)), gate, timeScale:timeScale);
	sig = WhiteNoise.ar;
	bpftab = \bpftab.kr(exprand(100,17000!num));
	sig = num.collect { arg idx;
		BPF.ar(sig, bpftab[idx] * env1,0.1 * env2);
	};
	sig = sig.sum * 2;
	sig = LPF.ar(sig, env3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


//////////////:

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1395].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					0.1,1, 0.1,0.2, 0.1,0.2, 0.1,0.2,
				],8),
				Pseq([
					1,1, 0.1,0.2, 0.1,0.2, 0.1,0.2,
				],8),
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2468].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[726].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,0,1,
				1,1,1,1, 0,0,0,0,
				1,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([
				
				Pseq([
					1,1,1,1,
					1,1,1,1.04,
					1,1,1,1,
				],1),
				0.4,1,2,0.51,
			],inf),
			\dur, 1/8,
			\legato, Pseq([
				1,2,1,1,
			],inf).stutter(2),
			\gain, 0.07,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([
					1,
				],8),
			],inf) * 0.8 * ~t / Pkey(\st),
			\isRest, Pseq([
				1,0,0,0,
				//1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1,
					1/2,1,1,1,
				],4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				0,3,2,2,
				4,15,14,14,
				0,2,2,2,
				4,15,14,12,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, Pseq([
				Pseq([
					1
				],8),
			],inf) * 1 * ~t / Pkey(\st),
			\isRest, Pseq([
				1,1,1,1,
				1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1,
				],4) 
			],inf),
			\lpf, Pseq([
				10000,5000,2000,1000,
			],inf).stutter(1),
			\hpf, 100,
			\hpmix, 1,
			\hpmix, 0,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				\r,\r,\r,\r, 3,\r,3,\r,
				2,\r,14,\r, 2,2,2,2,
				9,\r,8,\r, 9,\r,9,\r,
				14,14,14,\r, 3,2,3,9,
				//\r,\r,\r,\r,
			].flat,inf)/8 / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		),
		
	])
)).play;
);


Pdef(\part).clear;

//////// machine gun sample

(
SynthDef(\gregrain_gun, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	//pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = HPF.ar(sig, \hpf.kr(180));
	sig = LPF.ar(sig, \lpf.kr(18000));
	sig = Normalizer.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/petanque.flac'),
			\pos, 0.5,
			\speed, 0.3,
			\legato, 1,
			\dur, 1/16,
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \gregrain_gun,
			\mbufnum, BufDef.mono('vipere/petanque.flac'),
			\legato, 0.91,
			\gdur, 0.15,
			\freq, 16*~t * 4,
			\freq, 16*~t,
			\pos, 0.24,
			\lpf, 14000,
			\hpf, 30,
			\pitch_stretch, 1.1,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
);




//////////

TDuty
{ WhiteNoise.ar * Decay.kr(TDuty.kr(Dwhite(0.2,0.21), 0, Dwhite(0.01,1)), 0.1) * 0.1 ! 2 }.play
{ WhiteNoise.ar * Decay.kr(TDuty.kr(1/20, Impulse.kr(1), Dseq([1,0,0.1,1,0.4],2)), 0.1) * 0.1 ! 2 }.play
{ WhiteNoise.ar * Decay.kr(TDuty.kr(1/8, Impulse.kr(1/2), Dseq([1,0,0],inf)), 0.1) * 0.1 ! 2 }.play
{ WhiteNoise.ar * Decay.kr(TDuty.kr(1/8, 0, Dseq([1,0,0],inf)), 0.1) * 0.1 ! 2 }.play

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, Pseq([
				100,200,300,
			],inf),
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\freq, Pseq([
				100,200,300,
			],inf),
			\legato, 1,
			\dur, 1/2,
			\lag, 0.210,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\freq, Pseq([
				100,200,300,
			],inf),
			\legato, 1,
			\dur, 1/2,
			\lag, 10,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\sinduty, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar( Duty.kr(1/2/~t, 0, Dseq([ 100,200,300, ],inf)));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono( \sinduty,
			\dur, 1,
			\amp, 0.1,
		),
		Pmono( \sinduty,
			\dur, 1,
			\amp, 0.1,
			\lag, 4.1,
		),
		Pmono( \sinduty,
			\dur, 1,
			\amp, 0.1,
			\lag, 2.3,
		),
		Pmono( \sinduty,
			\dur, 1,
			\amp, 0.1,
			\lag, 6.2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			loop {
				sp.par(
					Pmono( \sinduty,
						\dur, 1,
						\amp, 0.1,
						\out, BusDef(\sendbus1, \audio),
					),
				
				);
				( 2.1/~t ).wait
			}
		}),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			loop {
				sp.par(
					Pmono( \sinduty,
						\dur, 1,
						\amp, 0.1,
						\out, BusDef(\sendbus1, \audio),
					),
				
				);
				( 2 + rrand(0.1,2) /~t ).wait
			}
		}),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			loop {
				sp.par(
					Pmono( \sinduty,
						\dur, 1,
						\amp, 0.1,
						\out, BusDef(\sendbus1, \audio),
					),
				
				);
				( 2 + rrand(0.1,2) /~t ).wait
			}
		}),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,\r,0,0, \r,\r,\r,\r,
				\r,\r,\r,\r, \r,\r,\r,\r,

				\r,\r,\r,\r, \r,\r,\r,\r,
				0,\r,\r,\r, \r,\r,8,0,
				\r,\r,\r,\r, \r,\r,\r,\r,
				\r,0,8,\r, \r,\r,\r,\r,
				//0,3,3,0, 8,3,6,0,
				//4,3,3,0, 8,3,0,\r,
			],inf)/16 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Big City Lights.wav'),
			\legato, 1,
			\st, 102/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				12,12,12,12, 11,10,10,0,
				4,9,9,9, 8,10,10,0,
				//0,3,3,0, 8,3,6,0,
				//4,3,3,0, 8,3,0,\r,
			],inf)/16 / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-P3DL-SG93", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.47478991596639,
	'gain', 0.48319327731092,
	'fb', 0.0001,
	'delay', 0.51794746792312,
	'delay2', 0.11015819387359,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.1416643274669,
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
).keep(1));

);

ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-S8VB-QUNK", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.51260504201681,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.45233707447721,
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
).keep(1));

);

// see sun25
