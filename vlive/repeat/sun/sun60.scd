
~t = 150/4/60; TempoClock.default.tempo = ~t;
~t = 167/4/60; TempoClock.default.tempo = ~t;

~t = 145/4/60; TempoClock.default.tempo = ~t;

FileSystemProject.loadOnce("holis/synthdef.scd");
(
SynthDef(\largechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0.1,0.32,2.1],[0.7,1.8])), 1);
	freq = freq * [1/4,1/2,1,2,3,4,5,6,7];
	sig = LFSaw.ar(freq *.x [1,1+\diff.kr(0.00001)]);
	sig = sig + SinOsc.ar(freq,mul:\sinamp.kr(0.2));
	sig = RLPF.ar(sig, ( \lpfr.kr(8.1) * env1 * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size); 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\gransinfm, { arg out=0, amp=0.1, freq=100, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	clk = Impulse.ar(\gfreq.kr(40));
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = SinOsc.ar(freq * [1,1 + \fdelta.kr(0.001)] * ( LFSaw.ar(sig*\fmffac.kr(100)+(\freqfac.kr(1)*freq)) * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain * amp ;
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\freecordeenv, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01, spread=1, timeScale=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fspreadenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	env2 = EnvGen.kr(\fmrenv.kr(Env([1,1,1],[0.1,1.8])), 1, timeScale:timeScale);
	env3 = EnvGen.kr(\fmampenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	env4 = EnvGen.kr(\amrenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	env5 = EnvGen.kr(\amampenv.kr(Env([1,1,1],[0.1,0.8])), 1, timeScale:timeScale);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread * env1 + 1) * ( SinOsc.ar(freq*\fmr.kr(1.2) * env2) * \fmamp.kr(1) * env3 + 1 )) * ( SinOsc.ar(freq * \amr.kr(0.2) * env4) * \amamp.kr(1) * env5 + 1 );
	sig.debug("sig");
	sig = sig * 0.3;
	sig = SelectX.ar( LFNoise1.ar((1..8)/12 * \selratio.kr(1)).range(0,sig.size-1), sig  );
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\gregrain_norm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	clk = Impulse.ar(freq);
	pan = Dseq(\panseq.kr([1,0.4,-1,0.1,-0.9]),inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = HPF.ar(sig, \hpf.kr(180));
	sig = LPF.ar(sig, \lpf.kr(18000));
	sig = Normalizer.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \largechord,
			\note, Pseq([
				[-3,1,4],
				[1,4,8],
				[2,6,9],
				[4,8,11],
			],inf).stutter(4),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \gregrain_norm,
			\note, Pseq([
				[-3,1,4],
				[1,4,8],
				[2,6,9],
				[4,8,11],
			],inf).stutter(8),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.02) ],
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
				[ Env.adsr(0.1,0.1,0.8,0.05) ],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				Pseq([
					1,1,0,1,
					0.6,1,0,1,
					0,0,1,1,
				],inf),
				1,1,0,1, 0,1,1,0,
				0,1,0,1, 0,0,1,1,
				0,1,0,1, 0,1,0,1,
			],inf).coin.not,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 2.1, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 1/2,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Pwhite(0.1,2,inf)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2590].value,
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0.51,
				0,0.51,1,0.5, 1,0,0.5,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			//\bufnum, ~buflib.snare[2590].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		~swing = 0.3;
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[386].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pwhite(0.1,1,inf),
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.1,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			\bufnum, ~buflib.hat[1487].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,0.3, 1,0.2,1,0.3,
				1,0,0,0.3, 1,0.2,1,0.3,
				0.51,0,0,0, 1,0.4,1,0,
				0,1,1,0.3, 1,0.2,1,0.3,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11 * Pseq([
				1,0.2,
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,Pn(0.5,7),
			],inf).coin.not,
			\gain, 2/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[96].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				1,0,0,0, 0.2,0,0.81,0,
				0,0,0,0, 1,0,0,0,
				0.81,0,1,0, 0,0,0.81,0,
				0,0,1,0, 0,0,0.81,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[95].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				0,0,0,0.2, 0,0,0,0,
				0,0,0,0, 0,0.21,
				0,0,0,0, 0,0.21,
				//0,0,0,0, 0,0,0,0,
				//0,1,0,0, 0,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//0,1,0,1, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				\r,\r,\r,4, 9,9,\r,1,
				\r,1,1,\r, \r,\r,\r,\r,
				\r,\r,\r,4, 2,-1,\r,4,
				\r,4,4,\r, \r,\r,\r,\r,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \basicbass,
	)
)
);
(
Pdef(\melo, 
	Pbind(
			\instrument, \nosepad,
			\fma, Pseg(Pseq([0,1,10,100,50],inf),8),
			\fma2, Pseg(Pseq([0,1,10,100,50],inf),10),
			\rampendfac, Pseq([
				1,1,1,1,2,1,1,1,1/2,
			],inf).stutter(14),
			\ramptime, 0.01,
			\combdecayfac, Pseg(Pseq([0,1,10],inf),11),
			\decaytime, 3,
			\octave, 4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.01) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melo))

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \largechord,
			\note, Pseq([
				[-3,1,4],
				[1,4,8],
				[2,6,9],
				[4,8,11],
			],inf).stutter(4),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \gregrain_norm,
			\note, Pseq([
				[-3,1,4],
				[1,4,8],
				[2,6,9],
				[4,8,11],
			],inf).stutter(8),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.02) ],
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
				[ Env.adsr(0.1,0.1,0.8,0.05) ],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				Pseq([
					1,1,0,1,
					0.6,1,0,1,
					0,0,1,1,
				],inf),
				1,1,0,1, 0,1,1,0,
				0,1,0,1, 0,0,1,1,
				0,1,0,1, 0,1,0,1,
			],inf).coin.not,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 2.1, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 1/2,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Pwhite(0.1,2,inf)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2590].value,
			\isRest, Pseq([
				1,0,0,1, 1,0,1,0.51,
				0,0.51,1,0.5, 1,0,0.5,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			//\bufnum, ~buflib.snare[2590].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		~swing = 0.3;
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[386].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pwhite(0.1,1,inf),
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.1,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			\bufnum, ~buflib.hat[1487].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,0.3, 1,0.2,1,0.3,
				1,0,0,0.3, 1,0.2,1,0.3,
				0.51,0,0,0, 1,0.4,1,0,
				0,1,1,0.3, 1,0.2,1,0.3,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11 * Pseq([
				1,0.2,
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Grady Tate - Be Black Baby.wav'),
			\legato, 1,
			\st, 110/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,Pn(0.5,7),
			],inf).coin.not,
			\gain, 2/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[96].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.5) ],
			],inf),
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				1,0,0,0, 0.2,0,0.81,0,
				0,0,0,0, 1,0,0,0,
				0.81,0,1,0, 0,0,0.81,0,
				0,0,1,0, 0,0,0.81,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[95].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\isRest, Pseq([
				0,0,0,0.2, 0,0,0,0,
				0,0,0,0, 0,0.21,
				0,0,0,0, 0,0.21,
				//0,0,0,0, 0,0,0,0,
				//0,1,0,0, 0,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//0,1,0,1, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				\r,\r,\r,4, 9,9,\r,1,
				\r,1,1,\r, \r,\r,\r,\r,
				\r,\r,\r,4, 2,-1,\r,4,
				\r,4,4,\r, \r,\r,\r,\r,
			],inf),
			\isRest, Pseq([
				1,Pn(0.5,7),
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
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
			\bufnum, ~buflib.hat[386].value,
			\bufnum, ~buflib.hat[1487].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pwhite(0.1,1,inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\legato, 4,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.1,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			\bufnum, ~buflib.hat[1487].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0.3,
				0.51,0,0,0, 1,0.4,1,0,
				0,1,1,0.3, 1,0.2,1,0.3,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11 * Pseq([
				1,0.2,
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			//\bufnum, ~buflib.snare[2590].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \freecordeenv,
			\amr, 1/2.01,
			\fmr, 1.01,
			\spread, Pseq([1,0,1,1,0],inf),
			\pan, Pseq([-1,1],inf)*0.4,
			\amampenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([0,1.3,0.3],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fspreadenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fmampenv, Pseq([
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([1,1,1],[0.1,1.8]) ],
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\note, Pseq([
				[-3,1,4],
				[1,4,8-12],
				[2,6,9-12],
				[4,8-12,11-12],
			],inf).stutter(8),
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.02) ],
				[ Env.adsr(0.1,0.1,0.8,1.2) ],
				[ Env.adsr(0.1,0.1,0.8,0.05) ],
			],inf),
			\octave, 6,
			\isRest, Pseq([
				Pseq([
					1,1,0,1,
					0.6,1,0,1,
					0,0,1,1,
				],inf),
				1,1,0,1, 0,1,1,0,
				0,1,0,1, 0,0,1,1,
				0,1,0,1, 0,1,0,1,
			],inf).coin.not,
			//\amamp, 0.1,
			//\fmr, ~pmodenv.(Pseq([1,1.002,1.1,7.4,1.04]+0.7,inf), 3),
			//\amamp, ~pmodenv.(Pseq([0,0.2,0.4],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				\r,\r,\r,4, 9,9,\r,1,
				\r,1,1,\r, \r,\r,\r,\r,
				\r,\r,\r,4, 2,-1,\r,4,
				\r,4,4,\r, \r,\r,\r,\r,
			],inf),
			\isRest, Pseq([
				1,Pn(0.5,7),
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[395].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,1,1,0, 0,1,0,0,
				0,1,1,0, 0,1,0,0,
				1,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1576].value,
			\bufnum, ~buflib.kick[1089].value,
			\bufnum, ~buflib.kick[796].value,
			\bufnum, ~buflib.kick[14].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[386].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pwhite(0.1,1,inf),
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.1,1)
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[386].value,
			\bufnum, ~buflib.hat[1487].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pwhite(0.1,1,inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\legato, 4,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.1,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			\bufnum, ~buflib.hat[1487].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0.3,
				0.51,0,0,0, 1,0.4,1,0,
				0,1,1,0.3, 1,0.2,1,0.3,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11 * Pseq([
				1,0.2,
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			//\bufnum, ~buflib.snare[2590].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \freecordeenv,
			\amr, 1/2.01,
			\fmr, 1.01,
			\spread, Pseq([1,0,1,1,0],inf),
			\pan, Pseq([-1,1],inf)*0.4,
			\amampenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([0,1.3,0.3],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fspreadenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fmampenv, Pseq([
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([1,1,1],[0.1,1.8]) ],
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\note, Pseq([
				[-3,1,4],
				[1,4,8-12],
				[2,6,9-12],
				[4,8-12,11-12],
			],inf).stutter(8),
			\legato, 0.4,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.02) ],
				],8),
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,0.02) ],
					[ Env.adsr(0.1,0.1,0.8,1.2) ],
					[ Env.adsr(0.1,0.1,0.8,0.05) ],
				],6),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				Pseq([
					0,0.51,0,0.5, 0,0.51,0,0.5,
					0,0,1,1, 0,0,1,1,
					1,1,0,1, 0.6,1,0,1,
					0,0,1,1, 0,0,1,1,
				],inf),
			],inf).coin.not,
			//\amamp, 0.1,
			//\fmr, ~pmodenv.(Pseq([1,1.002,1.1,7.4,1.04]+0.7,inf), 3),
			//\amamp, ~pmodenv.(Pseq([0,0.2,0.4],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				\r,\r,\r,4, 9,9,\r,1,
				\r,1,1,\r, \r,\r,\r,\r,
				\r,\r,\r,4, 2,-1,\r,4,
				\r,4,4,\r, \r,\r,\r,\r,
			],inf),
			\isRest, Pseq([
				1,Pn(0.5,7),
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[395].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,1,1,0, 0,1,0,0,
				0,1,1,0, 0,1,0,0,
				1,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1576].value,
			\bufnum, ~buflib.kick[1089].value,
			\bufnum, ~buflib.kick[796].value,
			\bufnum, ~buflib.kick[14].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[386].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pwhite(0.1,1,inf),
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.1,1)
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[386].value,
			\bufnum, ~buflib.hat[1487].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pwhite(0.1,1,inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\legato, 4,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.1,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[26].value,
			\bufnum, ~buflib.hat[1487].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0.3,
				0.51,0,0,0, 1,0.4,1,0,
				0,1,1,0.3, 1,0.2,1,0.3,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11 * Pseq([
				1,0.2,
				
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1662].value,
			//\bufnum, ~buflib.snare[2590].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.04,
		),
		Pbind(
			\instrument, \freecordeenv,
			\amr, 1/2.01,
			\fmr, 1.01,
			\spread, Pseq([1,0,1,1,0],inf),
			\pan, Pseq([-1,1],inf)*0.4,
			\amampenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([0,1.3,0.3],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fspreadenv, Pseq([
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\fmampenv, Pseq([
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([0,0,0],[0.1,1.8]) ],
				[ Env([1,1,1],[0.1,1.8]) ],
				[ Env([0,0.3,8],[0.1,1.8]) ],
				[ Env([1,0.3,0],[0.1,1.8]) ],
			],inf),
			\note, Pseq([
				[-3,1,4],
				[1,4,8-12],
				[2,6,9-12],
				[4,8-12,11-12],
			],inf).stutter(8),
			\legato, 0.4,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.02) ],
				],8),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				Pseq([
					0,0.51,0,0.5, 0,0.51,0,0.5,
				],inf),
			],inf).coin.not,
			//\amamp, 0.1,
			//\fmr, ~pmodenv.(Pseq([1,1.002,1.1,7.4,1.04]+0.7,inf), 3),
			//\amamp, ~pmodenv.(Pseq([0,0.2,0.4],1), 8).loop,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				\r,\r,\r,4, 9,9,\r,1,
				\r,1,1,\r, \r,\r,\r,\r,
				\r,\r,\r,4, 2,-1,\r,4,
				\r,4,4,\r, \r,\r,\r,\r,
			],inf),
			\isRest, Pseq([
				1,Pn(0.5,7),
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[395].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,1,1,0, 0,1,0,0,
				0,1,1,0, 0,1,0,0,
				1,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1576].value,
			\bufnum, ~buflib.kick[1089].value,
			\bufnum, ~buflib.kick[796].value,
			\bufnum, ~buflib.kick[14].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[386].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pwhite(0.1,1,inf),
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.1,1)
			],inf),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1576].value,
			\bufnum, ~buflib.kick[1089].value,
			\bufnum, ~buflib.kick[796].value,
			\bufnum, ~buflib.kick[14].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,1,0, 1,0,1,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,12-7,
			],inf).stutter(4),
			\fmffac, 100,
			\freqfac, Pseq([1,2,4,1/2],inf),
			\octave, 3,
			\fdelta, 1,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
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
				7,0,0,0, 0,0,0,1,
				2,0,3,0, 0,3,0,0,
			],inf),
			\gain, 0.1,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			\note, Pseq([
				9,\r,4,4, 9,9,1,1,
				\r,1,1,1, 1,\r,11,11,
				9,4,4,4, 2,-1,4,4,
				4,4,4,\r, \r,\r,2,\r,
			],inf),
			\legato, Pseq([
				0,0,0,1, 1,1,0,1,
				0,1,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				0,1,1,0, 0,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0, 
				0,0,1,0, 1,0,0,0, 
			],inf).coin.not,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1727].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[488].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,1,0,1, 1,0,0,1,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,
				Prand([1,0.3],1),
				Prand([1,0.3],1),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),1).loop / Pkey(\st),
			\dur, 1/16,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				\r,\r,\r,4, 9,9,\r,1,
				\r,1,1,\r, \r,\r,\r,\r,
				\r,\r,\r,4, 2,-1,\r,4,
				\r,4,4,\r, \r,\r,\r,\r,
			],inf),
			\isRest, Pseq([
				1,Pn(0.5,7),
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \gregrain_norm,
			\note, Pseq([
				[-3,1,4],
				[1,4,8],
				[2,6,9],
				[4,8,11],
			],inf).stutter(8),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.02) ],
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
				[ Env.adsr(0.1,0.1,0.8,0.05) ],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				Pseq([
					0,0,0,0,
					1,1,0,1,
					0.6,1,0,1,
					0,0,1,1,
				],inf),
				1,1,0,1, 0,1,1,0,
				0,1,0,1, 0,0,1,1,
				0,1,0,1, 0,1,0,1,
			],inf).coin.not,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 2.1, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 1/2,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Pwhite(0.1,2,inf)
			],inf),
		),
		Pbind(
			\instrument, \simpleacid,
			//\out, BusDef(\fx2),
			\env1, Pseq([
				Pseq([
					[ Env([1,2,1],[0.01,0.8]) ],
					[ Env([1,2,1],[0.1,0.8]) ],
				],8),
				Pseq([
					[ Env([1,2,1],[0.01,0.8]) ],
					[ Env([1,2,1],[0.01,0.2]) ],
				],4),
				Pseq([
					[ Env([1,2,1],[0.01,0.6]) ],
					[ Env([1,2,1],[0.1,0.8]) ],
					[ Env([1,2,1],[0.01,0.8]) ],
				],8),
			],inf),
			\note, Pseq([
				[-3,1,4],
				[1,4,8-12],
				[2,6,9-12],
				[4,8-12,11-12],
			],inf).stutter(8) + Pseq([
				Ptuple(Prand([0,-12,12],inf)!3)

			],inf),
			\lpfr, ~pmodenv.(Pseq([1,2,1,4]/2,inf), Pseq([4],inf)),
			\rq, ~pmodenv.(Pseq([0.1,0.2,0.1,0.4]/2,inf), Pseq([4],inf)),
			\octave, 6,
			\legato, Pseq([
				Pser([
					0.2,0.7,
				],12),
				Pser([
					2,1,1,1,
				],4),
			],inf) * Pseg(Pseq([0.4,1,0.2,0.8],inf),8) * Pseq([
				Ptuple(Prand([0.3,0.3,1],inf)!3)

			],1),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,0,0.4,1, 0.5,1,0.5,0,1, 
				0.5,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.011 * Pseq([
				Ptuple(Pwhite(0.1,1,inf)!3)

			],inf),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/myboat.flac'),
			\pos, 0,
			\legato, 1,
			\dur, 1,
			\gain, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1750].value,
			\speed, Pseq([
				1,0.9,0.9,0.91, 1,1,1,1,
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[685].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,1,1,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\playersec,
			\bufnum, BufDef('loop/myboat.flac'),
			\st, 145/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, 0.836,
			\gain, 1/4 * Pseq([
				1,1,
			],inf),
			\dur, Pn(1/8,4*8),
			\out, BusDef(\xfx1, \audio),
		).loop,
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\xfx1),
			\dur, 1/16,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 0,0,0,0,
				1,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\amp, 1,
		),
		Pbind(
			\instrument,\locstarlet,
			//\freq, 100,
			\mix, Pseg(Pseq([0,1],inf),Prand([8,3]*3,inf)),
			//\freq, Pseq([1000,330],inf),
			\note, Pseq([
				Pseq([
					\r
				],27),
				Pseq([
					11,9,
				],4),
				11,9,9,
				11,9,9,9,9,
			],inf) + [0,-12],
			\scale, Scale.minor,
			\octave, 6,
			\dur, Pseg(Pseq([0.7,2],inf),8),
			\legato, Pseg(Pseq([1,0.31],inf),10),
			\isRest, false,
			\amp, 0.1,
		),
		Pmono(\fx_env,
			\inbus, BusDef(\sendbus1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \largechord,
			\note, Pseq([
				[-3,1,4],
				[1,4,8],
				[2,6,9],
				[4,8,11],
			],inf).stutter(4),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,12-7,
			],inf).stutter(4),
			\fmffac, 100,
			\freqfac, Pseq([1,2,4,1/2],inf),
			\octave, 3,
			\fdelta, 1,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
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
				7,0,0,0, 0,0,0,1,
				2,0,3,0, 0,3,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
			\note, Pseq([
				9,\r,4,4, 9,9,1,1,
				\r,1,1,1, 1,\r,11,11,
				9,4,4,4, 2,-1,4,4,
				4,4,4,\r, \r,\r,2,\r,
			],inf),
			\legato, Pseq([
				0,0,0,1, 1,1,0,1,
				0,1,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				0,1,1,0, 0,0,0,1,
			],inf),
			\mmute, Pseq([
				0.5,0.3
			],inf).coin.not,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: {ev[\mmute] }}),
			\octave, 3,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \gregrain_norm,
			\note, Pseq([
				[-3,1,4],
				[1,4,8],
				[2,6,9],
				[4,8,11],
			],inf).stutter(8),
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.02) ],
				[ Env.adsr(0.1,0.1,0.8,0.2) ],
				[ Env.adsr(0.1,0.1,0.8,0.05) ],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				Pseq([
					1,1,0,1,
					0.6,1,0,1,
					0,0,1,1,
				],4),
				1,1,0,1, 0,1,1,0,
				0,1,0,1, 0,0,1,1,
				0,1,0,1, 0,1,0,1,
			],inf).coin.not,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, ~pmodenv.(Pseq([0,5,10]/48,1) + Pwhite(0,1.02,inf).stutter(8) + 2.1, 8).loop,
			\gdur, 0.01,
			//\freq, 100,
			\pitch_stretch, 1/2,
			\dur, 1/8,
			\amp, 0.051 * Pseq([
				Pwhite(0.1,2,inf)
			],inf),
		),
		
	])
)).play;
);

(
SynthDef(\locstarlet, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	env1 = EnvGen.kr(Env([1,20,1],[0.1,0.3]), 1);
	fspread = 0.0007 + Rand(0,0.007)* env1;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) );
	sig1 = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)
