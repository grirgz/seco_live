
(
~t = 125/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
)

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
SynthDef(\fmrfe, { arg out=0, amp=0.1, gate=1, pan=0;
	var sig;
	var lpenv, lpfreq;
	sig = LFSaw.ar(\freq.ar(200) * ( 1 + ( SinOsc.ar(\fmf.kr(1) * [1,1+\fmfmul.kr(0.001)]) * \fma.kr(1) )));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = \freq.ar * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 3,3,9,8,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				0.3,0.6,0.9,0.5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,4,3,4,
			],inf),
			\saw, 0,
			\pulse, 1,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 0,7,12 ],
				[ 0,8,12 ],
			],inf),
			\octave, 6,
			\dur, 4,
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
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1500].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 3,3,9,8,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				0.3,0.6,0.9,0.5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,4,3,4,
			],inf),
			\saw, 0,
			\pulse, 1,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 0,7,12 ],
				[ 0,8,12 ],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,7,0,12, 12,7,11,12,
				],2),
				Pseq([
					12,7,3,12, 12,7,11,12,
				],2),
			],inf),
			\legato, Pseq([
				0,0,3,0, 0,0,1,1,
				0,0,1,0, 0,0,1,1,
			],inf)/4,
			\lpf, 500,
			\envamt, 4,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/4,
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
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[916].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,1,0, 1,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1500].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 3,3,9,8,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				0.3,0.6,0.9,0.5, 0.3,0.6,0.9,0.5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//0,4,3,4,
			//],inf),
			//\saw, 0,
			//\pulse, 1,
			//\octave, 5,
			//\lpf, PmodEnv(Pseq([100,4000],1), 16).loop,
			//\dur, 1/8,
			//\amp, 0.1/2,
		//),
		//Pbind(
			//\instrument, \snappad,
			//\note, Pseq([
				//[ 0,7,12 ],
				//[ 0,8,12 ],
			//],inf),
			//\octave, 6,
			//\dur, 4,
			//\amp, 0.1,
		//),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//Pseq([
					//12,7,0,12, 12,7,11,12,
				//],2),
				//Pseq([
					//12,7,3,12, 12,7,11,12,
				//],2),
			//],inf),
			//\legato, Pseq([
				//0,0,3,0, 0,0,1,1,
				//0,0,1,0, 0,0,1,1,
			//],inf)/4,
			//\lpf, 500,
			//\envamt, 4,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\octave, 6,
			//\dur, 1/4,
			//\amp, 0.1,
		//),
		Pseq([
			Pbind(
				\instrument, \fmrfe,
				\note, Pser([
					0,3,4,3,
				],8*8),
				\fmf, Pkey(\freq),
				\fma, PmodEnv(Pseq([2.1,4],1), 16).loop,
				\lpadsramt, PmodEnv(Pseq([1,4],1), 16).loop,
				//\lpf, PmodEnv(Pseq([100,8000],1), 8*2,\exp).loop,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf)/2,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1,
			),
			Pbind(
				\instrument, \fmrfe,
				\note, Pser([
					0,3,4,3,
				],8*8),
				\fmf, Pkey(\freq),
				\fma, PmodEnv(Pseq([2.1,4],1), 16).loop,
				\lpadsramt, PmodEnv(Pseq([1,4],1), 16).loop,
				//\lpf, PmodEnv(Pseq([100,8000],1), 8*2,\exp).loop,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf)/2,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.1 * Pseq([
					Ppatlace(
						Pseg(Pwhite(0.1,1.4,inf),Pwhite(1,8))!8
					)
				],inf),
			),
		],inf),
		Pbind(
			\instrument, \formant,
			\note, Pseq([
				3,
				0,
			],inf).stutter(4),
			\bwfreq, PmodEnv(Pseq([100,914],1), 8,\exp).loop,
			\formfreq, PmodEnv(Pseq([100,100,400],1), 8,\exp).loop,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				1/2,1/2,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pseq([
			Pfindur(8,Pbind(
				\instrument, \rolandsupersaw,
				\note, Pseq([
					0,
				],inf),
				\octave, 6,
				\lpf, PmodEnv(Pseq([100,1214],1), 8,\exp).loop,
				\dur, 1,
				\amp, 0.1,
			)),
			Pfindur(8,Pbind(
				\instrument, \rolandsupersaw,
				\note, Pseq([
					0,
				],inf),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					],7),
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\octave, 6,
				\lpf, PmodEnv(Pseq([1100,7214],1), 8,\exp).loop,
				\legato, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		],1),
		Pbind(\instrument, \simplegran,
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
			\pitch_stretch, PmodEnv(Pseq([1,4],inf), Pexprand(0.1,20), \exp),
			//\pitch_stretch, pmm3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\legato, Pseq([
				Ppatlace(
					Pseg(Pwhite(0.2,0.8,inf),8*2)!2
				,inf),
				//0.3,0.51
			],inf),
			\dur, 1/8,
			\gain, 1/2 * Ppatlace(
				Pseg(Pwhite(0.1,1,inf),Pwhite(1,8,inf))!2
			,inf),
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pser([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
				],8*7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[936].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[817].value,
			\bufnum, ~buflib.hat[1016].value,
			\bufnum, ~buflib.hat[1767].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1.4,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[817].value,
			\isRest, Pseq([
				 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,0.8,0.6,0.8,
			],inf),
		),
		Pbind(\instrument, \simplegran,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([1,2,1,4]/10+1,1), 8*8),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8*2),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 16),
			\pitch_stretch, 1/4,
			//\pitch_stretch, pmm3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.81,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\gain, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pser([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
				],8*7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[936].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[817].value,
			\bufnum, ~buflib.hat[1016].value,
			\bufnum, ~buflib.hat[1767].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1.4,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[817].value,
			\isRest, Pseq([
				 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,0.8,0.6,0.8,
			],inf),
		),
		Pbind(\instrument, \simplegran,
			\mbufnum, BufDef.mono('loop/loop3b_185bpm.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([1,2,1,4]/10+1,1), 8*8),
			],inf),
			\dephase, ~pmodenv.(Pseq([0,0.02,0.1,1],inf), 8*2),
			\gdur, ~pmodenv.(Pseq([0.1,0.02],inf), 16),
			\pitch_stretch, 1/4,
			//\pitch_stretch, pmm3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.81,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\gain, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[916].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,1,0, 1,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1500].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 3,3,9,8,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				0.3,0.6,0.9,0.5, 0.3,0.6,0.9,0.5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		//Pbind(
			//\instrument, \snappad,
			//\note, Pseq([
				//[ 0,7,12 ],
				//[ 0,8,12 ],
			//],inf),
			//\octave, 6,
			//\dur, 4,
			//\amp, 0.1,
		//),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//Pseq([
					//12,7,0,12, 12,7,11,12,
				//],2),
				//Pseq([
					//12,7,3,12, 12,7,11,12,
				//],2),
			//],inf),
			//\legato, Pseq([
				//0,0,3,0, 0,0,1,1,
				//0,0,1,0, 0,0,1,1,
			//],inf)/4,
			//\lpf, 500,
			//\envamt, 4,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\octave, 6,
			//\dur, 1/4,
			//\amp, 0.1,
		//),
		//Pseq([
			//Pbind(
				//\instrument, \fmrfe,
				//\note, Pser([
					//0,3,4,3,
				//],8*8),
				//\fmf, Pkey(\freq),
				//\fma, PmodEnv(Pseq([2.1,4],1), 16).loop,
				//\lpadsramt, PmodEnv(Pseq([1,4],1), 16).loop,
				////\lpf, PmodEnv(Pseq([100,8000],1), 8*2,\exp).loop,
				//\dur, 1/8,
				//\adsr, Pseq([
					//[ Env.adsr(0.01,0.1,0.8,0.1) ],
				//],inf),
				//\legato, Pseq([
					//1,1,1,1, 1,1,1,1,
				//],inf)/2,
				//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\amp, 0.1,
			//),
			//Pbind(
				//\instrument, \fmrfe,
				//\note, Pser([
					//0,3,4,3,
				//],8*8),
				//\fmf, Pkey(\freq),
				//\fma, PmodEnv(Pseq([2.1,4],1), 16).loop,
				//\lpadsramt, PmodEnv(Pseq([1,4],1), 16).loop,
				////\lpf, PmodEnv(Pseq([100,8000],1), 8*2,\exp).loop,
				//\dur, 1/8,
				//\adsr, Pseq([
					//[ Env.adsr(0.01,0.1,0.8,0.1) ],
				//],inf),
				//\legato, Pseq([
					//1,1,1,1, 1,1,1,1,
				//],inf)/2,
				//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\amp, 0.1 * Pseq([
					//Ppatlace(
						//Pseg(Pwhite(0.1,1.4,inf),Pwhite(1,8))!8
					//)
				//],inf),
			//),
		//],inf),
		Pbind(
			\instrument, \formant,
			\note, Pseq([
				3,
				0,
			],inf).stutter(4),
			\bwfreq, PmodEnv(Pseq([100,914],1), 8,\exp).loop,
			\formfreq, PmodEnv(Pseq([100,100,400],1), 8,\exp).loop,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				1/2,1/2,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pseq([
			Pfindur(8,Pbind(
				\instrument, \rolandsupersaw,
				\note, Pseq([
					0,
				],inf),
				\octave, 6,
				\lpf, PmodEnv(Pseq([100,1214],1), 8,\exp).loop,
				\dur, 1,
				\amp, 0.1,
			)),
			Pfindur(8,Pbind(
				\instrument, \rolandsupersaw,
				\note, Pseq([
					0,
				],inf),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					],7),
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\octave, 6,
				\lpf, PmodEnv(Pseq([1100,7214],1), 8,\exp).loop,
				\legato, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		],1),
		Pbind(\instrument, \simplegran,
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
			\pitch_stretch, PmodEnv(Pseq([1,4],inf), Pexprand(0.1,20), \exp),
			//\pitch_stretch, pmm3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\legato, Pseq([
				Ppatlace(
					Pseg(Pwhite(0.2,0.8,inf),8*2)!2
				,inf),
				//0.3,0.51
			],inf),
			\dur, 1/8,
			\gain, 1/2 * Ppatlace(
				Pseg(Pwhite(0.1,1,inf),Pwhite(1,8,inf))!2
			,inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,4,3,4,
			],inf),
			\saw, 0,
			\pulse, 1,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\mela, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mela),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,1,1],1), 16).loop,
			\sendbus0, BusDef(\mela0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fxechotab,
			\inbus, BusDef(\mela0, \audio),
			\addAction, \addToTail,
			\delay, 1/8/~t,
			\delmix, PmodEnv(Pseq([1,0],1), 32).loop,
			\decay, 0.1/~t,
			\mix, 1,
			\gain,0.2,
			//\mix, PmodEnv(Pseq([0,1],1), 32).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mela2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\mela2, \audio),
			\hpf, PmodEnv(Pseq([10000,4002,100,400,100],1), 8,\exp).loop,
			\addAction, \addToTail,
			\mix, 0,
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[916].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,1,0, 1,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snare, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\snare),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\snarefx, \audio, 2),
			\dur, 1,
		),
		Pmono(\fxechoshift,
			\inbus, BusDef(\snarefx, \audio),
			\addAction, \addToTail,
			\maxdelay, 2/~t,
			\delay, 3/8/~t * [1,2,3,4,5],
			\decay, 2/~t,
			\shift, 100 * ( (1..5) ) * Pseg(Pseq([0.1,2],1),32).loop,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\snarefx2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\snarefx2, \audio),
			\addAction, \addToTail,
			//\lpf, PmodEnv(Pseq([1000,14000],1), 32).loop,
			//\hpf, PmodEnv(Pseq([10000],1), 8).loop,
			\lpf, 13000,
			\hpf, 100,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\snarefx3, \audio),
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\snarefx3, \audio),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				//1,1,1,1, 1,1,1,1,
				//1,1,1,1, 1,1,1,1,
				//1,1,1,1, 1,1,1,1,
				//1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,1,0,1,
				1,1,0,1, 0,1,1,0,
				1,0,0,0, 0,1,1,1,
				0,0,1,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1500].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 3,3,9,8,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				0.3,0.6,0.9,0.5, 0.3,0.6,0.9,0.5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		//Pbind(
			//\instrument, \snappad,
			//\note, Pseq([
				//[ 0,7,12 ],
				//[ 0,8,12 ],
			//],inf),
			//\octave, 6,
			//\dur, 4,
			//\amp, 0.1,
		//),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pseq([
				//Pseq([
					//12,7,0,12, 12,7,11,12,
				//],2),
				//Pseq([
					//12,7,3,12, 12,7,11,12,
				//],2),
			//],inf),
			//\legato, Pseq([
				//0,0,3,0, 0,0,1,1,
				//0,0,1,0, 0,0,1,1,
			//],inf)/4,
			//\lpf, 500,
			//\envamt, 4,
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\octave, 6,
			//\dur, 1/4,
			//\amp, 0.1,
		//),
		//Pseq([
			//Pbind(
				//\instrument, \fmrfe,
				//\note, Pser([
					//0,3,4,3,
				//],8*8),
				//\fmf, Pkey(\freq),
				//\fma, PmodEnv(Pseq([2.1,4],1), 16).loop,
				//\lpadsramt, PmodEnv(Pseq([1,4],1), 16).loop,
				////\lpf, PmodEnv(Pseq([100,8000],1), 8*2,\exp).loop,
				//\dur, 1/8,
				//\adsr, Pseq([
					//[ Env.adsr(0.01,0.1,0.8,0.1) ],
				//],inf),
				//\legato, Pseq([
					//1,1,1,1, 1,1,1,1,
				//],inf)/2,
				//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\amp, 0.1,
			//),
			//Pbind(
				//\instrument, \fmrfe,
				//\note, Pser([
					//0,3,4,3,
				//],8*8),
				//\fmf, Pkey(\freq),
				//\fma, PmodEnv(Pseq([2.1,4],1), 16).loop,
				//\lpadsramt, PmodEnv(Pseq([1,4],1), 16).loop,
				////\lpf, PmodEnv(Pseq([100,8000],1), 8*2,\exp).loop,
				//\dur, 1/8,
				//\adsr, Pseq([
					//[ Env.adsr(0.01,0.1,0.8,0.1) ],
				//],inf),
				//\legato, Pseq([
					//1,1,1,1, 1,1,1,1,
				//],inf)/2,
				//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\amp, 0.1 * Pseq([
					//Ppatlace(
						//Pseg(Pwhite(0.1,1.4,inf),Pwhite(1,8))!8
					//)
				//],inf),
			//),
		//],inf),
		Pbind(
			\instrument, \formant,
			\note, Pseq([
				3,
				0,
			],inf).stutter(4),
			\bwfreq, PmodEnv(Pseq([100,914],1), 8,\exp).loop,
			\formfreq, PmodEnv(Pseq([100,100,400],1), 8,\exp).loop,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				1/2,1/2,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pseq([
			Pfindur(8,Pbind(
				\instrument, \rolandsupersaw,
				\note, Pseq([
					0,
				],inf),
				\octave, 6,
				\lpf, PmodEnv(Pseq([100,1214],1), 8,\exp).loop,
				\dur, 1,
				\amp, 0.1,
			)),
			Pfindur(8,Pbind(
				\instrument, \rolandsupersaw,
				\note, Pseq([
					0,
				],inf),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					],7),
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\octave, 6,
				\lpf, PmodEnv(Pseq([1100,7214],1), 8,\exp).loop,
				\legato, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		],1),
		Pbind(\instrument, \simplegran,
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
			\pitch_stretch, PmodEnv(Pseq([1,4],inf), Pexprand(0.1,20), \exp),
			//\pitch_stretch, pmm3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\legato, Pseq([
				Ppatlace(
					Pseg(Pwhite(0.2,0.8,inf),8*2)!2
				,inf),
				//0.3,0.51
			],inf),
			\dur, 1/8,
			\gain, 1/2 * Ppatlace(
				Pseg(Pwhite(0.1,1,inf),Pwhite(1,8,inf))!2
			,inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,4,3,4,
			],inf),
			\saw, 0,
			\pulse, 1,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\mela, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mela),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,1,1],1), 16).loop,
			\sendbus0, BusDef(\mela0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fxechotab,
			\inbus, BusDef(\mela0, \audio),
			\addAction, \addToTail,
			\delay, 1/8/~t,
			\delmix, PmodEnv(Pseq([1,0],1), 32).loop,
			\decay, 0.1/~t,
			\mix, 1,
			\gain,0.2,
			//\mix, PmodEnv(Pseq([0,1],1), 32).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mela2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\mela2, \audio),
			\hpf, PmodEnv(Pseq([10000,4002,100,400,100],1), 8,\exp).loop,
			\addAction, \addToTail,
			\mix, 0,
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[916].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,1,0, 1,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1500].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],7),
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 3,3,9,8,
			],inf).stutter(4),
			\octave, 3,
			\legato, Pseq([
				0.3,0.6,0.9,0.5, 0.3,0.6,0.9,0.5,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		//Pbind(
			//\instrument, \snappad,
			//\note, Pseq([
				//[ 0,7,12 ],
				//[ 0,8,12 ],
			//],inf),
			//\octave, 6,
			//\dur, 4,
			//\amp, 0.1,
		//),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					12,7,0,12, 12,7,11,12,
				],2),
				Pseq([
					12,7,3,12, 12,7,11,12,
				],2),
			],inf),
			\legato, Pseq([
				0,0,3,0, 0,0,1,1,
				0,0,1,0, 0,0,1,1,
			],inf)/4,
			\lpf, PmodEnv(Pseq([500,3500],1), 32,\exp).loop,
			\envamt, 7,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/4,
			\amp, 0.1/2,
			\out, BusDef(\melb, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\melb, \audio),
			\delay, 1/8/~t + 0.01,
			\addAction, \addToTail,
			\decay, 3/~t,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\melb2, \audio),
		),
		Pmono(\fx_tanh,
			\distamp, 5.0,
			\level, 1.0,
			\distpostamp, 1/4,
			\mix, 0.5,
			\gain, 1/2,
			\inbus, BusDef(\melb2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\melb3, \audio),
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\melb3, \audio),
			\addAction, \addToTail,
			\lpf, PmodEnv(Pseq([1000,20000],1), 32,\exp).loop,
			\room, 2,
			\hpf, PmodEnv(Pseq([2000,1000,124],1), 16,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
		Pbind(
			\instrument, \formant,
			\note, Pseq([
				3,
				0,
			],inf).stutter(4),
			\bwfreq, PmodEnv(Pseq([100,914],1), 8,\exp).loop,
			\formfreq, PmodEnv(Pseq([100,100,400],1), 8,\exp).loop,
			\legato, Pseq([
				0,0,0,0, 4,0,0,0,
				1/2,1/2,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1 * Pseg(Pseq([0,1],1),32).loop,
		),
		Pseq([
			Event.silent(16),
			Pfindur(8,Pbind(
				\instrument, \rolandsupersaw,
				\note, Pseq([
					0,
				],inf),
				\octave, 6,
				\lpf, PmodEnv(Pseq([100,1214],1), 8,\exp).loop,
				\dur, 1,
				\amp, 0.1,
			)),
			Pfindur(8,Pbind(
				\instrument, \rolandsupersaw,
				\note, Pseq([
					0,
				],inf),
				\isRest, Pseq([
					Pseq([
						1,1,1,1, 1,1,1,1,
					],7),
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\octave, 6,
				\lpf, PmodEnv(Pseq([1100,7214],1), 8,\exp).loop,
				\legato, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		],1),
		Pbind(\instrument, \simplegran,
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
			\pitch_stretch, PmodEnv(Pseq([1,4],inf), Pexprand(0.1,20), \exp),
			//\pitch_stretch, pmm3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\legato, Pseq([
				Ppatlace(
					Pseg(Pwhite(0.2,0.8,inf),8*2)!2
				,inf),
				//0.3,0.51
			],inf),
			\dur, 1/8,
			\gain, 1/2 * Ppatlace(
				Pseg(Pwhite(0.1,1,inf),Pwhite(1,8,inf))!2
			,inf),
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,4,3,4,
			],inf),
			\saw, 0,
			\pulse, 1,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000,6000],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\mela, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mela),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,1,1],1), 16).loop,
			\sendbus0, BusDef(\mela0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fxechotab,
			\inbus, BusDef(\mela0, \audio),
			\addAction, \addToTail,
			\delay, 1/8/~t,
			\delmix, PmodEnv(Pseq([1,0],1), 32).loop,
			\decay, 0.1/~t,
			\mix, 1,
			\gain,0.2,
			//\mix, PmodEnv(Pseq([0,1],1), 32).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mela2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\mela2, \audio),
			\hpf, PmodEnv(Pseq([10000,4002,100,400,100],1), 8,\exp).loop,
			\addAction, \addToTail,
			\mix, 0,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				1,4,3,\r,
				-3,3,-4,\r,
				-4,3,-5,\r,
				-5,-4,-12,-11,
			],inf),
			\octave, 4,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,4,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
// Basse type Röyksopp – What Else Is There
SynthDef(\royksoppBass, { |out=0, freq=55, pan=0, gate=1, amp=0.1,
    detune=1.002,       // très léger détune
    atk=0.005, dec=0.08, sus=0.6, rel=0.2,
    fAtk=0.002, fDec=0.12, fRel=0.2,
    cutoff=1800, rq=0.3,
    drive=3.0,          // disto douce
    flgRate=0.2, flgDepth=0.004, flgFeedback=0.2
|
    var env, fenv, mod, car, sig, flg;

    // enveloppe de filtrage rapide (accent sur l’attaque)
    fenv = EnvGen.kr(
        Env.asr(fAtk, 1, fRel),
        gate
    );

    // FM simple : un modulateur carré assez brillant
    mod = Pulse.ar(freq * 2, 0.5) / 2;              // proche du caractère DX7
    //mod = mod * (freq * 3);                        // index de modulation

    // Porteuse : sinus + légère copie détunée
    car = SinOsc.ar(freq, mod)
        + ( 0.4 * SinOsc.ar(freq * detune, mod) );

    // Filtre passe‑bas résonant avec envelope
    sig = RLPF.ar(
        car,
        (cutoff * fenv).clip(200, 10000),
        rq
    );

    // Saturation douce pour le côté « chewing-gum / caoutchouc »
    sig = tanh(sig * drive);

    // Légère simulation de chorus / flanger lent
    flg = CombL.ar(
        sig,
        0.02,
        SinOsc.kr(flgRate, 0, flgDepth, 0.01),
        flgFeedback
    );

    sig = (sig * 0.7) + (flg * 0.3);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
    // Sortie stéréo
    Out.ar(out, sig);
}).add;
)

// Exemple d’utilisation avec une ligne de basse
(
Pdef(\royksoppLine,
    Pbind(
        \instrument, \royksoppBass,
        \scale, Scale.minor,
        \root, 2,                // D
        \degree, Pseq([0, 0, -3, -5], inf),
        \octave, 3,
        \dur, 0.5,
		\legato, 0.3,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.01,0.2,0.1) ],
		],inf),
        \cutoff, 2200,
        \amp, 0.3
    )
).play;
)

(
SynthDef(\xm1_organ2, { |out=0, freq=440, amp=0.3, gate=1,
    volume=0.8,
    detune=1.002, detuneSub=0.998,
    subOct=( -24 ), thirdOct=12,
    atk=0.004, dec=0.3, sus=1, rel=0.2,
    fAtk=0.005, fRel=0.15,
    cutoff=250, rq=0.4,
    chorus=0.2,
    pan=0.0
|
    var env, fenv, osc1, osc2, osc3, sub, mixed, sig, ch, flt;

    // enveloppe d’amplitude
    env = EnvGen.kr(
        Env.adsr(atk, dec, sus, rel),
        gate,
        doneAction:2
    );

    // enveloppe de filtre rapide (accent au début)
    fenv = EnvGen.kr(
        Env.asr(fAtk, 1, fRel),
        gate
    );

    // trois oscillateurs proches du M1 :
    // - fondamentale sinusoïdale
    // - tierce légèrement au‑dessus (plus "harmonique")
    // - sub très grave
    osc1 = SinOsc.ar(freq);
    osc2 = SinOsc.ar(freq * detune);
    osc3 = SinOsc.ar(freq * 1.5);                    // tierce
    sub  = SinOsc.ar(freq * thirdOct / 48);        // sub très grave

    mixed = ((osc1 + ( osc2 * 0.5 )) * 0.8)
        + ( osc3 * 0.4 )
        + ( sub * 0.6 );

    // filtre passe‑bas très chiant, type « organ house »
    flt = RLPF.ar(
        mixed,
        (cutoff * fenv).clip(100, 20000),
        rq
    );

    // légère saturation douce pour le côté « digital vintage »
    //sig = tanh(flt * 4) * 0.3;
	sig = flt;

    // chorus / léger détune pour le « groove M1 »
    ch = CombL.ar(
        sig,
        0.02,
        SinOsc.kr(0.3, 0, 0.004, 0.01),
        0.2
    );
    sig = (sig * (1 - chorus)) + (ch * chorus);
	sig = HPF.ar(sig, 60);

    // panning + sortie
    Out.ar(out, Pan2.ar(sig * env * amp * volume, pan));
}).add;
)

// Exemple d’utilisation
(
Pdef(\organ2_line,
    Pbind(
        \instrument, \xm1_organ2,
        \degree, Pseq([0, 2, 3, 5, 7, 5, 3, 2], inf),
        \octave, 4,
        \dur, 0.25,
        \amp, 0.25,
		\sus, 0.2,
		\legato, 0.5,
        \cutoff, 7750,
        \rq, 0.4
    )
).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \xm1_organ2,
			\degree, Pseq([0, 2, 3, 5, 7, 5, 3, 2], inf),
			\octave, 4,
			\dur, 1/8/2,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.25,
			\legato, 2.9,
			\cutoff, 270,
			\rel, 0.1,
			\sus, 0.3,
			\dec, 0.2,
			\rq, 0.4,
			\chorus, PmodEnv(Pseq([0,1],1), 8).loop,
		)
		
	])
)).play;
);


(
// added to synthbasic.scd
SynthDef(\m1_organ2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lpenv, lpfreq;
	sig1 = LFTri.ar(freq/2);
	sig2 = LFPulse.ar(freq*7.midiratio);
	sig = [ sig1, sig2 ].mean;
	lpenv = EnvGen.kr(\lpenv.kr(Env([0, 1,0.45,0],[0.001,0.1,0.01])), 1, doneAction:0) * \lpenvamt.kr(8) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(180) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.4,0.2,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpenv: ParamEnvSpec(\amp!4),
))).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \m1_organ2,
			\note, Pseq([
				-3
			],inf),
			\lpenvamt, 4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.1) ],
			],inf),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \m1_organ2,
			\note, Pseq([
				-3,-3,-3,-3, -3,-3,-3,0,
				-8,-8,-8,-8, -8,-8,-8,-7,
				-7,-7,-7,-7, -7,-7,-7,-7,
				-7,-7,-7,-7, -7,-7,-5,-7,
			],inf),
			\octave, 5,
			//\lpenvamt, PmodEnv(Pseq([0,4],1), 8).loop,
			//\lpf, PmodEnv(Pseq([100,4000],1), 8,\exp).loop,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\lpenvamt, 10,
			\lpf, 120,
			\dur, 1/8,
			\legato, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \m1_organ2,
			\note, Pseq([
				-3,-3,-3,-3, -3,-3,-3,0,
				-8,-8,-8,-8, -8,-8,-8,-7,
				-7,-7,-7,-7, -7,-7,-7,-7,
				-7,-7,-7,-7, -7,-7,-5,-7,
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\amp, 0.1,
		),
	])
)).play;
);



////////

(
SynthDef(\bia, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lpenv, lpfreq;
	sig1 = LFPulse.ar(freq/2 * ((0..7)/7 - 0.5 * \fspread.kr(0.00101) + 1), 0.5, rrand(0.0,pi!7));
	sig1 = sig1.mean;
	sig2 = LFSaw.ar(freq, ((0..7)/7 - 0.5 * \fspread2.kr(0.000402) + 1), rrand(0.0,pi!7));
	sig2 = sig2.mean;
	sig = [ sig1, sig2 ].mean;
	//sig = LFSaw.ar(freq/2)/2;
	//sig = sig1;
	lpenv = EnvGen.kr(\lpenv.kr(Env([0, 1,0.05,0],[0.001,0.992,0.01],-3)), 1, doneAction:0) * \lpenvamt.kr(8) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(200) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.1,0.1,1,-3)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bia,
			\note, Pseq([
				0,1,-3,3,
			],inf).stutter(2),
			\octave, 3,
			\fspread2, PmodEnv(Pseq([0.001,1.1,0.5],1), 8,\exp).loop,
			\lpenvamt, PmodEnv(Pseq([1,4,9],1), 8).loop,
			//\lpenvamt, 1,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);


(
SynthDef(\dasoChords, {
    |out = 0, freq = 880, amp = 0.3, gate = 1, atk = 0.8, rel = 2, phRate = 0.3, phDepth = 0.7|
    var sig, env, phaser;
    
    // Ondes de scie pour un son riche et aigu, avec légère déviation pour élargissement stéréo
    sig = Saw.ar([freq, freq * 1.005], amp * 0.5);
    
    // Filtre passe-haut pour accentuer les aigus
    sig = HPF.ar(sig, 800);
    
    // Phaser ondulant pour l'effet "wavey"
    phaser = LPF.ar(sig, 4000);
    phaser = Phaser.ar(phaser, phRate * 0.5, phDepth, 200);
    sig = sig * 0.3 + phaser * 0.7;
    
    // Enveloppe douce et longue pour les pads chordaux
    env = EnvGen.ar(Env.asr(atk, 1, rel, \sine), gate, doneAction: Done.freeSelf);
    
    sig = sig * env;
    Out.ar(out, Pan2.ar(sig, 0));
}).add;
)

(
Pdef(\part, Pbind(
    \instrument, \dasoChords,
    \dur, 4,
    \octave, 6,
    \degree, Pseq([[-7, -3, 4], [-5, 0, 4], [-3, 4, 7], [-7, -3, 4]], inf),  // Cm/Gm-like
    \amp, 0.4,
	\sustain, 0.1,
	\rel, 0.8,
	\atk, 0.01,
    \phRate, Pwhite(0.2, 0.5),
    \phDepth, 0.6
)).play;
)

(
SynthDef(\dasoChords, {
    |out = 0, freq = 880, amp = 0.3, gate = 1, atk = 0.8, rel = 2, 
     phRate = 0.3, phDepth = 0.7, phFeedback = 0.4|
    var sig, env, phaser;
    
    // Ondes de scie détunées pour les accords riches
    sig = Mix(LFPulse.ar([freq, freq * 1.004, freq * 0.996]) * (amp * 0.4));
	//sig = sig + LFSaw.ar(freq, mul:0.02);
    
    // Filtre passe-haut pour les aigus
    sig = HPF.ar(sig, 900);
    sig = LPF.ar(sig, freq);
    
    // Phaser custom avec Allpass delays (plus authentique)
    phaser = sig;
    4.do({ |i|
        var delayTime = SinOsc.kr(phRate * (i+1) * 0.7, i * 1.57) * phDepth * 0.004 + 0.0025;
        phaser = AllpassN.ar(phaser, 0.05, delayTime, 2) * phFeedback + ( sig * (1-phFeedback) );
    });
    
    // Enveloppe douce
    env = EnvGen.ar(Env.asr(atk, 1, rel, \sine), gate, doneAction: Done.freeSelf);
    
    sig = phaser * env;
    Out.ar(out, Pan2.ar(sig, ( SinOsc.kr(0.1,Rand(0,pi))*0.3 ).poll));
}).add;
)


{ SinOsc.kr(1,pi/2) }.plot(1)


(
SynthDef(\dasoIntroHit, {
    |out = 0, freq = 1400, amp = 0.4, atk = 0.001, rel = 0.08, curve = -4|
    var sig, env, exciter;
    
    // Exciter pulse très court (comme un pluck glassy)
    exciter = Pulse.ar(freq * [1, 1.008], 0.03, amp);
    
    // Filtre formant aigu descendant rapidement
    sig = RLPF.ar(exciter, freq * LFNoise1.kr(12).range(0.95, 1.1), 0.3);
    
    // Enveloppe ultra-courte avec courbe raide
    env = EnvGen.ar(Env.perc(atk, rel, 1, curve), doneAction: Done.freeSelf);
    
    sig = sig * env;
    
    // Saturation légère pour le glassy
    sig = (sig * 3).tanh * 0.4;
    
    Out.ar(out, Pan2.ar(sig, 0.1));
}).add;
)

(
Pbind(
    \instrument, \dasoIntroHit,
    \freq, Pseq([1400, 1650, 1750], 1) * 1.02,  // Légère déviation
    \amp, Pseq([0.6, 0.4, 0.5], 1),
    \rel, 0.06,
    \dur, Pseq([0.2, 0.15], 1)
).play;
)

(
SynthDef(\dasoIntroStabs, {
    |out = 0, freq = 1200, amp = 0.35, atk = 0.002, rel = 0.12, curve = -6|
    var sig, env;
    
    // Accord : 3 ondes de scie très aiguës, détunées finement
    sig = Mix({
        var baseFreq = freq * [1, 1.008, 1.015];
        LFCub.ar(baseFreq, amp * 0.3)
    });
    
    // HPF + LPF pour zone glassy 1k-4kHz
    sig = HPF.ar(sig, 900);
    sig = LPF.ar(sig, 3800);
    
    // Enveloppe EXTRÊMEMENT courte et raide
    env = EnvGen.ar(Env.perc(atk, rel, 1, curve), doneAction: Done.freeSelf);
    
    sig = sig * env * 1.2;
    
    // Brillance analogique
    //sig = (sig * 2.5).tanh * 0.5;
    
    Out.ar(out, Pan2.ar(sig, LFNoise1.kr(8).range(-0.2, 0.2)));
}).add;
)

(
Pbind(
    \instrument, \dasoIntroStabs,
    \degree, Pseq([[-12, -7, 0], [-10, -5, 2]], 1),  // Cm-like en octave 6
    \octave, 5,
    \amp, Pseq([0.5, 0.45], 1),
    \rel, 0.4,
    \dur, Pseq([0.15, 0.15], 1)
).play;
)


////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('notes/trumpet.flac'), // la#
			\note, Pseq([
				//[0,4+12,7-12],
				//[-1,4+12,7-12],
				//[0,3+12,7-12]-4,
				[0,4,7],
				[0,3,7]+1,
			],inf).stutter(8*2),
			\octave, 4,
			\speed, ( Pkey(\note)+2 + ( Pkey(\octave)-5 * 12 ) ).midiratio,
			\pos, ( 0.1 * Pkey(\speed) ),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/2,
			\dur, 1/8,
			\gain, 1/8,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_formlet,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\freq, PmodEnv(Pseq([100,5002],1), 8*2,\exp).loop,
			\lag, 0.0009,
			\mix, 0.5,
			\decay, 0.070,
			\dur, 1,
			//\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\room, 1,
			\damp, 1,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);
Formlet

(
SynthDef(\fx_formlet, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Formlet.ar(sig, \freq.kr(400), \attack.kr(0.001), \decay.kr(0.02));
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.009), \cpclamp.kr(0.001), \cprelax.kr(0.1));
	sig = sig /2;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

{ Formlet.ar(Impulse.ar(20, 0.5), 1000, 0.01, 0.1) }.play;

{ Formlet.ar(Blip.ar(XLine.kr(10,400,8), 1000, 0.1), 1000, 0.01, 0.1) }.play;

(
// modulating formant frequency
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1);
    Formlet.ar(in, XLine.kr(1500,700,8), 0.005, 0.04);
}.play;
)

(
// mouse control of frequency and decay time.
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1);
    Formlet.ar(in,
        MouseY.kr(700,2000,1),
        0.005, MouseX.kr(0.01,0.2,1));
}.play;
)

(
// mouse control of frequency and decay time.
{
    var freq;
    freq = Formlet.kr(
        Dust.kr(10 ! 2),
        MouseY.kr(7,200,1),
        0.005, MouseX.kr(0.1,2,1)
    );
    SinOsc.ar(freq * 200 + [500, 600] - 100) * 0.2
}.play;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		//Pbind(\out, BusDef(\ifx1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1472].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[2338].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \randgran,
			\mbufnum, BufDef.mono('notes/trumpet.flac'), // la#
			\note, Pseq([
				0,5,2,
			],inf),
			\pitch_stretch, ( Pkey(\note)+2 ).midiratio,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.3) ],
			],inf),
			\pos, PmodEnv(Pseq([0.1,0.71],3), 8).loop,
			\dur, 8,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('notes/trumpet.flac'), // la#
			\pos, 0,
			\legato, 1,
			\dur, 1,
			\gain, 0.1,
		)
		
	])
)).play;
);


(
SynthDef(\randgran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos + LFNoise0.kr(\gfreq.kr,mul:\range.kr(0.01));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \randgran,
			\mbufnum, BufDef.mono('notes/trumpet.flac'), // la#
			\note, Pseq([
				[0,4,7],
			],inf),
			\pitch_stretch, ( Pkey(\note)+2 ).midiratio,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.3) ],
			],inf),
			\gain, 0.1/3,
			\pos, PmodEnv(Pseq([0.1,0.2],3), 8).loop,
			\dur, 8,
			\amp, 0.1,
		),
		
	])
)).play;
);

BufDef.mono('notes/trumpet.flac').duration

(
SynthDef(\notegran, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, normpos=0, gdur=0.2, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(90));
	pitch_stretch = \freq.kr(200)/60.midicps * pitch_stretch * \samplenote.kr(0).neg.midiratio;
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = ( normpos.fold(0,1) * BufDur.kr(mbufnum) ) + \pos.kr(0) + LFNoise0.kr(\gfreq.kr,mul:\range.kr(0.01));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase , gdur, pan, 1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)
Spec.add(\mbufnum, ParamAudioBufferSpec(1))

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \notegran,
			\mbufnum, BufDef.mono('notes/trumpet.flac'), // la#
			\note, Pseq([
				[0,4,7],
				[0,3,7]+4,
				[0,4,7]+5,
				[0,4,7]+7,
			],inf),
			\octave, [6,5,4],
			\samplenote, -2,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.3) ],
			],inf),
			\gain, 0.1/3,
			\normpos, PmodEnv(Pseq([0.2,0.9],3), 8).loop,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \notegran,
			\mbufnum, BufDef.mono('notes/trumpet.flac'), // la#
			\note, Pseq([
				0,
			],inf),
			\samplenote, -2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.3) ],
			],inf),
			\gdur, 0.2,
			\gfreq, 90,
			\gain, 0.1,
			\normpos, PmodEnv(Pseq([0.2,0.8],3), 8).loop,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \randgran,
			\mbufnum, BufDef.mono('notes/trumpet.flac'), // la#
			\note, Pseq([
				0
			],inf),
			\pitch_stretch, ( Pkey(\note)+2 ).midiratio,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.3) ],
			],inf),
			\gain, 0.1,
			\pos, PmodEnv(Pseq([0.1,0.2],3), 8).loop,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\notegranrfe, { arg out=0, freq=200, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, normpos=0, gdur=0.2, pan;
	var sig;
	var clk;
	var phase;
	var lpenv, lpfreq;
	clk = Impulse.ar(\gfreq.kr(90));
	pitch_stretch = freq/60.midicps * pitch_stretch * \samplenote.kr(0).neg.midiratio;
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = ( normpos.fold(0,1) * BufDur.kr(mbufnum) ) + \pos.kr(0) + LFNoise0.kr(\gfreq.kr,mul:\range.kr(0.01));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase , gdur, pan, 1);

	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\notegranrlpf, { arg out=0, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, normpos=0, gdur=0.2, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	pitch_stretch = \freq.kr(200)/60.midicps * pitch_stretch * \samplenote.kr(0).neg.midiratio;
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = ( normpos.fold(0,1) * BufDur.kr(mbufnum) ) + \pos.kr(0) + LFNoise0.kr(\gfreq.kr,mul:\range.kr(0.01));
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase , gdur, pan, 1);
	sig = RLPF.ar(sig, \lpf.kr(100).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \notegran,
			\mbufnum, BufDef.mono('notes/violin.flac'), // re
			\note, Pseq([
				[0,4,7],
				[-1,4,7],
				[0,5,9],
				[-1,2,7],
			],inf),
			\samplenote, 2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.3) ],
			],inf),
			\gdur, 0.2,
			\gfreq, 90,
			\gain, 0.1/3,
			\normpos, PmodEnv(Pseq([0.05,0.1],3), 8).loop,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \notegranrfe,
			\mbufnum, BufDef.mono('notes/violin.flac'), // re
			\note, Pseq([
				[0,4,7],
				[-1,4,7],
				[0,5,9],
				[-1,2,7],
			],inf),
			\samplenote, 2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.3) ],
			],inf),
			\gdur, 0.2,
			\lpadsramt, PmodEnv(Pseq([1,8],1), 8).loop,
			\gfreq, 90,
			\gain, 0.1/3,
			\normpos, PmodEnv(Pseq([0.05,0.1],3), 8).loop,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \notegranrfe,
			\mbufnum, BufDef.mono('notes/trumpet.flac'),
			\chord, Pstep(Pseq([
				[0,4,7],
				[-1,4,7],
				[0,5,9],
				[-1,2,7],
			],inf),2),
			\note, Plazy({ arg ev;
				//Pseq(4.collect{ ev[\chord].choose },1).stutter(3);
				Pindex(ev[\chord], Pseq((0..7)));
			}).loop,
			\samplenote, -2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.3) ],
			],inf),
			\gdur, 0.2,
			\lpadsramt, PmodEnv(Pseq([4,8],1), 8).loop,
			\lpf, 500,
			\octave, 6,
			\gfreq, 90,
			\gain, 0.1/3,
			\normpos, PmodEnv(Pseq([0.05,0.1],3), 8).loop,
			\dur, 1/8,
			\amp, 0.1,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1472].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2338].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);

///////////
// sdesign fm

(
SynthDef(\fmsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	var lpenv, lpfreq;
	mod = LFSaw.ar(freq * \mratio.kr(1)) * \modAmp.kr(5) * EnvGen.kr(Env([0,1,0],[0.01,3.7],-4), 1);
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,1.4,0.0,0.1,1,-4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				0,3,7,3,
				Pseq([
					0,3,7,3,
				],1)+1,
			],inf),
			\modAmp, 400 * Pseg(Pseq([1,4],inf),8),
			\mratio, [1,2,1/2],
			\cratio, 1,
			\lpf, 100,
			\lpf, PmodEnv(Pseq([204,2000],1), 8,\exp).loop,
			//\lpadsramt, PmodEnv(Pseq([1,8],1), 8).loop,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1/3,
		),
		
	])
)).play;
);

(
SynthDef(\fmsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	var lpenv, lpfreq;
	mod = LFSaw.ar(freq * \mratio.kr(1)) * \modAmp.kr(5) * EnvGen.kr(Env([0,1,0],[0.01,3.7],-4), 1);
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,1.4,0.0,0.1,1,-4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fmsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	var lpenv, lpfreq;
	var mod2;
	mod2 = SinOsc.ar(freq * [1,1.01] * \mratio2.kr(1)) * \modAmp2.kr(5) * EnvGen.kr(Env([0,1,0],[0.01,0.7],-4), 1);
	mod = LFSaw.ar(freq * \mratio.kr(1) + mod2) * \modAmp.kr(5) * EnvGen.kr(Env([0,1,0],[0.01,3.7],-4), 1);
	sig = SinOsc.ar(freq * \cratio.kr(1) + mod);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,1.4,0.0,0.1,1,-4)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				0,3,7,3,
				Pseq([
					0,3,7,3,
				],1)+1,
			],inf),
			\modAmp, 10 * Pseg(Pseq([1,8*4],inf),8,\exp),
			\mratio, 2,
			\cratio, 1,
			\lpf, 100,
			\lpf, PmodEnv(Pseq([204,2000],1), 8,\exp).loop,
			//\lpadsramt, PmodEnv(Pseq([1,8],1), 8).loop,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1/3,
		),
		
	])
)).play;
);


//////////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,4,3,4,
			],inf),
			\saw, 0,
			\pulse, 1,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000],1), 16).loop,
			\lpf, 4000,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\mela, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\mela, \audio),
			\addAction, \addToTail,
			\delay, 1/16/~t,
			\decay, 1/~t,
			\diffadd, PmodEnv(Pseq([0,0,0.01,0.02,0.1],1), 8).loop,
			\mix, 0.5,
			//\mix, PmodEnv(Pseq([0,1],1), 32).loop,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\fxechotab, { arg out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var num = 5;
	sig = in;
	sig = CombC.ar(sig, \maxdelay.kr(1), \delay.kr(1) * (1..num),\decay.kr(1));
	sig = SelectX.ar(\delmix.kr(0)*(num-1), sig);
	sig1 = sig;
	sig1 = LPF.ar(sig1, \lpf.kr(19000));
	sig1 = HPF.ar(sig1, \hpf.kr(50));
	sig = SelectX.ar(\pfmix.kr(0.5), [sig, sig1]);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,4,3,4,
			],inf),
			\saw, 0,
			\pulse, 1,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\mela, \audio),
		),
		Pmono(\fxechotab,
			\inbus, BusDef(\mela, \audio),
			\addAction, \addToTail,
			\delay, 1/8/~t,
			\delmix, PmodEnv(Pseq([1,0],1), 32).loop,
			\decay, 0.1/~t,
			\mix, 0.5,
			\gain,0.5,
			\mix, PmodEnv(Pseq([0,1],1), 32).loop,
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
			\instrument, \sh101,
			\note, Pseq([
				0,4,3,4,
			],inf),
			\saw, 0,
			\pulse, 1,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,4000],1), 16).loop,
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\mela, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\mela),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pseq([0,1,1],1), 16).loop,
			\sendbus0, BusDef(\mela0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fxechotab,
			\inbus, BusDef(\mela0, \audio),
			\addAction, \addToTail,
			\delay, 1/8/~t,
			\delmix, PmodEnv(Pseq([1,0],1), 32).loop,
			\decay, 0.1/~t,
			\mix, 1,
			\gain,0.2,
			//\mix, PmodEnv(Pseq([0,1],1), 32).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mela2, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\mela2, \audio),
			\hpf, PmodEnv(Pseq([10000,4002,100,400,100],1), 8,\exp).loop,
			\addAction, \addToTail,
			\mix, 0,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\fxechoshift, { arg out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var num = 5;
	sig = in;
	sig = CombC.ar(sig, \maxdelay.kr(1), \delay.kr(1) * (1..num),\decay.kr(1));

	sig1 = sig;
	sig1 = FreqShift.ar(sig1, \shift.kr(0));
	sig = SelectX.ar(\shiftmix.kr(1), [sig, sig1]);

	sig1 = sig;
	sig1 = LPF.ar(sig1, \lpf.kr(19000));
	sig1 = HPF.ar(sig1, \hpf.kr(50));
	sig = SelectX.ar(\pfmix.kr(0.5), [sig, sig1]);

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodsynth.({ SinOsc.ar(4*~t).range(200,300* XLine.kr(0.01,2,32/~t))   }),
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
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 0,5,4,5, ],4),
				Pseq([ -1,3,2,3,],4),
			],inf),
			\octave, 5,
			\lpf, ~pmodsynth.({ SinOsc.ar(8*~t).exprange(200,200 * XLine.kr(1,8,16/~t))  }),
			\envamt, 5,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);

