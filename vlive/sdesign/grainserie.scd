~t = 1; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \granularity,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\simplegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
SynthDef(\simplegran_adsr, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
SynthDef(\doublegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase + [0,\dephase.kr(0)] % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig.mean * 0.6;
	sig.debug("sig");
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)
BufDef.mono('voices/feynman.flac').play
(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([1,2,1,4],1), 8*8),
				~pmodenv.(Pseq([1,1.4]+0.4,1), 1/2),
				~pmodenv.(Pseq([1.4,1]+0.4,1), 1/2),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\pitch_stretch, ~pmodenv.(Pseq([2,0.4],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)
(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([0,1.2]/8,1), 8*8),
				~pmodenv.(Pseq([1,2,1,4]/8,1), 8*8),
				~pmodenv.(Pseq([1,1.4]+0.4,1), 1/2),
				~pmodenv.(Pseq([1.4,1]+0.4,1), 1/2),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 4),
			\gfreq, Ptuple([ Pseries(1,1,8*8),Pseries(1,1.1,8*8) ]),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ]),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ]),
			\pan, Ptuple([-1,1],inf),
			\pitch_stretch, ~pmodenv.(Pseq([2,0.4],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)
(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,3],
				[0,4],
			].midiratio * 100,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+1,
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, ~pmodenv.(Pseq([2,0.4],inf), Pexprand(0.1,20)),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, 
			Plazy({ arg ev;
				
				Ptuple([ Pseries(rrand(0.1,1),-0.01 * rrand(0.1,2),8*8),Pseries(0.01,0.01,8*8) ])
			}).loop,
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,5],
				[0,6],
				[5,0],
				[6,0],
			].midiratio * 100,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+0,
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, ~pmodenv.(Pseq([2,0.4],inf), Pexprand(0.1,20)),
			\pitch_stretch, Ptuple([ Pseries(1,0.01,8*8),Pseries(1,-0.01,8*8) ],inf),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,5],
				[0,6],
				[5,0],
				[6,0],
			].midiratio * 100,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+0,
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, ~pmodenv.(Pseq([2,0.4],inf), Pexprand(0.1,20)),
			\pitch_stretch, Ptuple([ Pseries(1,0.01,8*8*8),Pseries(1,-0.01,8*8*4) ],inf),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,5],
				[0,6],
				[5,0],
				[6,0],
			].midiratio * 100,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+0,
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, Ptuple([ Pseries(1,0.01,8*8*8),Pseries(1,-0.01,8*8*4) ],inf),
			\pitch_stretch, Ptuple([
				~pmodenv.(Pwhite(0.4,2,inf), Pexprand(0.1,20)),
				~pmodenv.(Pwhite(0.4,2,inf), Pexprand(0.1,20)),
			]),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\doublegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8),
			\gdur, Ptuple([ Pseries(0.2,-0.01,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,5],
				[0,6],
				[5,0],
				[6,0],
			].midiratio * 100,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ],inf)+0,
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, Ptuple([ Pseries(1,0.01,8*8*8),Pseries(1,-0.01,8*8*4) ],inf),
			\pitch_stretch, Ptuple([
				~pmodenv.(Pwhite(0.4,2,inf), Pexprand(0.1,20)),
				~pmodenv.(Pwhite(0.4,2,inf), Pexprand(0.1,20)),
			]),
			\dur, 1/16,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\gdur, Ptuple([ Pseries(0.2,-0.001,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,5],
				[0,6],
				[5,0],
				[6,0],
			].midiratio * 100,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ].reverse,inf)+0,
			\pos, Pseq([
				4,1.2,
			],inf)+Pwhite(0,0.04) + Pseq([0,1,2,3,4],inf).stutter(8*8),
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, Ptuple([ Pseries(1,0.01,8*8*8),Pseries(1,-0.01,8*8*4) ],inf),
			\pitch_stretch, Ptuple([
				~pmodenv.(Pwhite(0.4,2,inf), Pexprand(0.1,20)),
				~pmodenv.(Pwhite(0.4,2,inf), Pexprand(0.1,20)),
			]),
			\dur, 1/8,
			\legato, 1,
			\asr, Pseq([
				[ Env.asr(0.1,1,0.1) ],
			],inf),
			\gain, 1/4,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\gdur, Ptuple([ Pseries(0.2,-0.001,8*8),Pseries(0.01,0.01,8*8) ],inf),
			\gfreq, Ptuple([ Pseries(100,1,8*8),Pseries(100,1.1,8*8) ],inf),
			\gfreq, Pseq([
				[0,5],
				[0,6],
				[5,0],
				[6,0],
			].midiratio * 100,inf),
			\pos, Ptuple([ Pseries(0,0.01,8*8),Pseries(1,0.01,8*8) ].reverse,inf)+0,
			\pos, Pseq([
				4,1.2,
			],inf)+Pwhite(0,0.04) + Pseq([0,1,2,3,4],inf).stutter(8*8),
			\pan, Ptuple([-1 * Pwhite(0.5,1),1* Pwhite(0.5,1)],inf),
			\pitch_stretch, Ptuple([ Pseries(1,0.01,8*8*8),Pseries(1,-0.01,8*8*4) ],inf),
			\pitch_stretch, Ptuple([
				~pmodenv.(Pwhite(0.4,2,inf), Pexprand(0.1,20)),
				~pmodenv.(Pwhite(0.4,2,inf), Pexprand(0.1,20)),
			]),
			\dur, 1/8,
			\legato, 1,
			\asr, Pseq([
				[ Env.asr(0.1,1,0.1) ],
			],inf),
			\gain, 1/4,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\simplegran_adsr,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,2,1,0,
			],inf),
			\octave, 3,
			\pos, Pseries(0,0.01,8*8 ).loop,
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
			\steps, Pseq([
				1,1,1,0,
			],inf),
			\gain, Prout({ arg ev;
				Ndef(\vca, { arg reset=0, igate=0;
					//var gate = Duty.kr(1/~t, reset, Dseq([
						//1,1,1,0,
					//],inf));
					1/4 * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), igate, doneAction:0);
				});
				loop  {
					Ndef(\vca).set(\igate, ev[\steps]);
					ev = Ndef(\vca).asMap.yield;
				}
			})

		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\simplegran_adsr,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,2,1,0,
			],inf).stutter(4),
			\octave, 3,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.04],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\steps, Pseq([
				1,1,1,1,
				1,1,1,0,
				1,1,1,1,
				1,1,0,0,
			],inf),
			\gain, Prout({ arg ev;
				Ndef(\vca, { arg reset=0, igate=0;
					//var gate = Duty.kr(1/~t, reset, Dseq([
						//1,1,1,0,
					//],inf));
					1/4 * EnvGen.kr(\adsr.kr(Env.adsr(0.05,0.1,0.8,0.1)), igate, doneAction:0);
				});
				loop  {
					Ndef(\vca).set(\igate, ev[\steps]);
					ev = Ndef(\vca).asMap.yield;
				}
			})

		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \simplegran_adsr,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,2,1,0,
			],inf).stutter(4),
			\octave, 3,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.04],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				2,0,0,3, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
		
	])
)).play;
);
Pdef(\part).clear

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \simplegran_adsr,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,2,1,0,
			],inf).stutter(4),
			\octave, 3,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, ~pmodenv.(Pseq([0.8,0.3,0.8,0.5,0.5]/2,1), Pseq([1/4,1/4,1,2/4],1)).loop,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\gdur, ~pmodenv.(Pseq([0.8,0.3,0.8,0.5,0.5]/20,1), Pseq([1/4,1/4,1,2/4]*2,1)).loop,
			\out, BusDef(\fx1, \audio),
			\dur, 1/4,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				7,0,0,0, 0,0,0,0,
				2,0,0,3, 0,0,2,0,
				7,0,0,0, 0,0,0,1,
				2,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
		
	])
)).play;
);


//////////// cloud

(
Pdef(\part, Pdef(\zedpart, 
	Ppar({
		Pmono(\simplegran,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\pos, Pseries(rrand(0,4), rrand(0.001,0.1),8*8),
			\gfreq, 100,
			\gdur, 0.2,
			\dur, rrand(1/8,1),
			\gain, 1/8,
		)
		
	}!8 )
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar({
		Pseq([
			Event.silent(rrand(1/8,4)),
			Pmono(\simplegran_adsr,
				\mbufnum, BufDef.mono('loop/pigs.flac'),
				\pos, ~pmodenv.(Pseq([0,0.02*rrand(1.0,10)] + rrand(0,2.0),1), rrand(1.0,16)).loop,
				//\gfreq, exprand(100.0,1000),
				//\note, rrand(0,12*4),
				\degree, rrand(0,7*4),
				\octave, 3,
				\gfreq, Pkey(\freq),
				\pan, rrand(-1,1.0),
				\gdur, Pseg(Pseq([rrand(0.02,0.2),0.1],inf),rrand(1.0,16)),
				\pitch_stretch, Prand([1,1/2,1/4,2,4],inf),
				\pitch_stretch, [1,1/2,1/4,2,4].choose,
				\adsr, Pseq([
					[ Env.adsr(0.3,0.1,0.8,0.9) ],
				],inf),
				\dur, Pn(rrand(1/8,1),rrand(4,8*8)),
				\gain, 1/4,
			),
		],inf)
		
	}!16 )
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar({
		Pseq([
			Event.silent(rrand(1.0,8)),
			Pmono(\simplegran_adsr,
				//\mbufnum, BufDef.mono('loop/pigs.flac'),
				//\mbufnum, BufDef.mono('bruit1/07_ukraine.flac'),
				\mbufnum, BufDef.mono('voices/feynman.flac'),
				\pos, ~pmodenv.(Pseq([0,0.02*rrand(1.0,10)] + rrand(0,6.0),1), rrand(1.0,16)).loop,
				//\freq, exprand(100.0,1000),
				\note, [0,3,7,12,15,19].choose,
				\ctranspose, Pstep(Pseq([0,4],inf),8),
				//\degree, rrand(0,7*4),
				\octave, 3,
				\gfreq, Pkey(\freq),
				\pan, rrand(-1,1.0),
				\gdur, Pseg(Pseq([exprand(0.02,0.2),exprand(0.02,0.2)],inf),rrand(1.0,16)),
				\pitch_stretch, Prand([1,1/2,1/4,2,4],inf),
				\pitch_stretch, [1,1/2,1/4,2,4].choose,
				\adsr, Pseq([
					[ Env.adsr(0.3,0.1,0.8,0.9) ],
				],inf),
				\dur, Pn(rrand(1/8,1),rrand(4,8*8)),
				\gain, 1/8,
			),
		],inf)
		
	}!16 )
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar({
		Pseq([
			//Event.silent(rrand(1.0,8)),
		Pbind(
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\instrument, \simplegran_adsr,
			\pos, ~pmodenv.(Pseq([0,0.02*rrand(1.0,10)] + rrand(0,6.0),1), rrand(1.0,16)).loop,
			\note, Pseq([
				0,3,7,12,
			],inf),
			\note, [
				0,3,7,12,15,19
			].choose,
			\octave,4,
			\ctranspose, Pstep(Pseq([0,5],inf),8),
				\note, [0,3,7,12,15,19].choose,
				\ctranspose, Pstep(Pseq([0,4],inf),8),
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,0.5) ],
				],inf),
			\gfreq, Pkey(\freq),
			\gdur, 1/Pkey(\gfreq),
			\dur, (1..8).choose/(1..8).choose,
			\pan, rrand(-1,1.0),
			\isRest, Pseq([
				0,1,0,1,1,
			].scramble,inf).coin.not,
			\gain, 1/4,
		),
		],inf)
		
	}!6 )
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\instrument, \simplegran_adsr,
			\pos, ~pmodenv.(Pseq([0,0.02*rrand(1.0,10)] + rrand(0,6.0),1), rrand(1.0,16)).loop,
			\gdur, 0.02,
			\note, Pseq([
				0,3,7,12,
			],inf),
			\ctranspose, Pstep(Pseq([0,4],inf),8),
			\gfreq, Pkey(\freq),
			\dur, 1,
			\gain, 1/4,
		),
	])
)).play;
);

(
SynthDef(\granu, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos + LFNoise1.kr(1,mul:\posrandamt.kr(0));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * \ffreq.kr(1000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[32].value,
			\bufnum, ~buflib.kick[1502].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[70].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[108].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[350].value,
			\isRest, Pseq([
					1,1,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,0,0, 
					1,0,0,0, 1,1,1,1,
				Pseq([
					1,1,1,0, 1,0,1,0,
					1,0,1,0, 1,0,0,0, 
					1,0,0,0, 1,1,1,1,
				],3),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.5,0.1
			],inf),
		),
		Pbind(
			\instrument, \default,
			\note, 0,
			\octave, 3,
			\ctranspose, Pstep(Pseq([0,4],inf),8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbell,
			\dur, 1,
			\isRest, Pseq([
				0,0,1,0,
				1,0,0,0,
				0,0,1,0,
				0,1,0,0,
				0,0,1,0,
				0,0,0,1,
			],inf).coin.not,
			\note, Prand([
				0,
				3,7
			],inf),
			\legato, Prand([1,1/2,1/4],inf),
			\octave, Prand([3,4,5,6],inf),
				\ctranspose, Pstep(Pseq([0,4],inf),8),
			\amp, 0.1/10,
				\out, BusDef(\fx1, \audio),
		),
		Ppar({
			Pseq([
				//Event.silent(rrand(1.0,8)),
			Pbind(
				\instrument, \granu,
				\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
				\pos, ~pmodenv.(Pseq([0,0.02*rrand(1.0,10)] + rrand(0,6.0),1), rrand(1.0,16)).loop,
				\note, Pseq([
					0,3,7,12,
				],inf),
				\note, [
					0,
					3,7
				].choose,
				\octave,6,
				\ctranspose, Pstep(Pseq([0,4],inf),8),
				\pitch_stretch, [2,1,1/2,1/4].choose,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,rrand(0.5,2)) ],
				],inf),
				\gfreq, Pkey(\freq),
				\ffreq, Pkey(\freq),
				\lpfr, 4,
				\rq, 0.1,
				\gdur, exprand(1/10,20.0)/Pkey(\gfreq),
				\dur, (1..8).choose/(1..8).choose,
				\pan, rrand(-1,1.0),
				\isRest, Pseq([
					0,1,0,1,1,0,0,0
				].scramble,inf).coin.not,
				\gain, 1/8,
				\out, BusDef(\fx1, \audio),
			),
			],inf)
		
		}!6 )
	]),
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[32].value,
			\bufnum, ~buflib.kick[1502].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[70].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[108].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[350].value,
			\isRest, Pseq([
					1,1,1,0, 1,0,1,0,
					1,0,0,1, 0,0,1,0,
					1,0,1,0, 1,0,0,0, 
					1,0,0,0, 1,1,1,1,
				Pseq([
					1,1,1,0, 1,0,1,0,
					1,0,1,0, 1,0,0,0, 
					1,0,0,0, 1,1,1,1,
				],3),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,0.5,0.1
			],inf),
		),
		Pbind(
			\instrument, \default,
			\note, 0,
			\octave, 3,
			\ctranspose, Pstep(Pseq([0,4],inf),8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbell,
			\dur, 1,
			\isRest, Pseq([
				0,0,1,0,
				1,0,0,0,
				0,0,1,0,
				0,1,0,0,
				0,0,1,0,
				0,0,0,1,
			],inf).coin.not,
			\note, Prand([
				0,
				3,7
			],inf),
			\legato, Prand([1,1/2,1/4],inf),
			\octave, Prand([3,4,5,6],inf),
				\ctranspose, Pstep(Pseq([0,4],inf),8),
			\amp, 0.1/10,
				\out, BusDef(\fx1, \audio),
		),
		Ppar({
			Pseq([
				//Event.silent(rrand(1.0,8)),
			Pbind(
				\instrument, \granu,
				\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
				\pos, ~pmodenv.(Pseq([0,0.02*rrand(1.0,10)] + rrand(0,6.0),1), rrand(1.0,16)).loop,
				\note, Pseq([
					0,3,7,12,
				],inf),
				\note, [
					0,
					3,7
				].choose,
				\octave,6,
				\posrandamt, 0.03,
				\ctranspose, Pstep(Pseq([0,4],inf),8),
				\pitch_stretch, [2,1,1/2,1/4].choose,
				\adsr, Pseq([
					[ Env.adsr(0.05,0.1,0.8,rrand(0.5,2)) ],
				],inf),
				\gfreq, Pkey(\freq),
				\ffreq, Pkey(\freq),
				\lpfr, 4,
				\rq, 0.1,
				\gdur, exprand(1/10,20.0)/Pkey(\gfreq),
				\dur, (1..8).choose/(1..8).choose,
				\pan, rrand(-1,1.0),
				\isRest, Pseq([
					0,1,0,1,1,0,0,0
				].scramble,inf).coin.not,
				\gain, 1/8,
				\out, BusDef(\fx1, \audio),
			),
			],inf)
		
		}!6 )
	]),
)).play;
);

ProtoDef(\FxManager).presetCompileString.editorInsert
(
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = BusDef('fx1');
ProtoDef('rdn').make('deldefault', 'rdn', "5-64GT-JI3L", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.0,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.3012947724727,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.027786635608165,
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

ProtoDef('rdn2').inbus = BusDef('zero');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('default', 'rdn2', nil, BusDef('zero'));
Ndef('rdn2').put(100, \pset -> Pbind(
	
).keep(1));

ProtoDef('rdn3').inbus = BusDef('zero');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('default', 'rdn3', nil, BusDef('zero'));
Ndef('rdn3').put(100, \pset -> Pbind(
	
).keep(1));

ProtoDef('rdn4').inbus = BusDef('zero');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('default', 'rdn4', nil, BusDef('zero'));
Ndef('rdn4').put(100, \pset -> Pbind(
	
).keep(1));




Ndef('fx1').source = 'simplecomp';
PlayerWrapper(Ndef('fx1')).outBus = BusDef('fx2');
Ndef('fx1').set('inbus', BusDef('fx1'));
Ndef('fx1').set('pregain', 3.3577943163959);
Ndef('fx1').set('cpt', 0.012653723333544);
Ndef('fx1').set('cpbelow', 1.00100004673);
Ndef('fx1').set('cpabove', 0.22286785025456);
Ndef('fx1').set('cpclamp', 0.0099999997764826);
Ndef('fx1').set('cprelax', 0.10000000149012);
Ndef('fx1').set('mix', 1.0);
Ndef('fx1').set('gain', 1.0);

Ndef('fx2').source = 'fx_greyhole';
PlayerWrapper(Ndef('fx2')).outBus = 0;
Ndef('fx2').set('inbus', BusDef('fx2'));
Ndef('fx2').set('delay', 0.31031536417972);
Ndef('fx2').set('damp', 0.1);
Ndef('fx2').set('size', 0.17337275899694);
Ndef('fx2').set('diff', 0.15686635126876);
Ndef('fx2').set('fb', 0.89999997615814);
Ndef('fx2').set('modDepth', 2.1147425268811);
Ndef('fx2').set('modFreq', 0.1);
Ndef('fx2').set('adsr', [ 0.0, 3.0, 2.0, -99.0, 1.0, 0.10000000149012, 5.0, -4.0, 0.80000001192093, 0.10000000149012, 5.0, -4.0, 0.0, 0.10000000149012, 5.0, -4.0 ]);
Ndef('fx2').set('mix', 0.37704918032787);
Ndef('fx2').set('gain', 1.0);
Ndef('fx2').set('room', 0.92007585850355);
Ndef('fx2').set('verbmix', 0.57786885245902);

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;


);

