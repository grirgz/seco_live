
//////////
// rytm with foley
~t = 145/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\kick808, {arg out = 0, freq1 = 240, freq2 = 60, amp = 0.1, ringTime = 100, rel = 10000, dist = 1.5, pan = 0, tott=0.1, durr=0.001, gate=1;
	var snd, env;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, \glisdur.kr(0.1)),
		decaytime: ringTime);
	//env = EnvGen.ar(Env.perc(0.001, rel, amp), doneAction: 2);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env * \gain.kr(0.2);
	snd = Limiter.ar(snd, tott, durr) * 1.5 *(1/tott);
	snd = snd * EnvGen.kr(\adsr2.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:0);
	//snd = Clip.ar(snd, -1 * tott, tott);
	//	snd = Fold.ar(snd, -1 * tott, tott);
	//	snd = Wrap.ar(snd, -1 * tott, tott);
	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 0.95 + Pseq([
				0.1,0.03, -0.1,0.2,
			],inf),
			\pos, Pseq([
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,1.4,1.2,1,
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,-1,1,-1,
				-1,-1,-1,-1, 1,-1,1,-1,
				1.6,-1,-1,-1, -1,-1,-1,-1,
			],inf).collect({ arg x; if(x < 0) { Rest() } { x } })-1  + 0.1 + Pseq((0..7)/16,inf),
			\legato, 1,
			\dur, 1/16,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, Pseq([
				Pseq(\r ! 4),
				Pseq(\r ! 2),
				Pseq((0..3)/2)+0.4,
				Pseq(\r ! 1),
				Pseq((0..3)/10)+0.4,
				Pseq(\r ! 1),
			],inf),
			\speed, 0.8,
			\dur, 1/8,
			\gain, 1/3,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2330].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		
	])
)).play;
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
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,12-7,
			],inf).stutter(4),
			\fmffac, 0,
			\freqfac, Pseq([1],inf),
			\fma, 1,
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

		),
		
	])
)).play;
);

(
SynthDef(\gransinfm2, { arg out=0, amp=0.1, freq=100, mix=0.5, gain=1, gate=1, mbufnum=0, pitch_stretch=1, pos=0, gdur=0.1, pan;
	var sig;
	var clk;
	var phase;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var fdelta;
	lfo2 = LFNoise1.kr(\fmalfodeltaf.kr(0.31)) * \fmalfodeltaa.kr(0.01);
	lfo1 = LFNoise1.kr(\fmalfof.kr(0.31)) * [1 + lfo2, 1 - lfo2 ] * \fmalfoa.kr(0.31) + 1;
	//lfo1 = lfo1 + (LFNoise1.kr(\fmalfof2.kr(13.31)!2) * \fmalfoa2.kr(0.1) + 1);
	clk = Impulse.ar(\gfreq.kr(40));
	fdelta = \fdelta.kr(0.001) * SinOsc.ar(\fdeltaf.kr(1/8)).clip(0,1) ;
	//fdelta = 0.001 * SinOsc.ar(1/4).clip(0,1) ;
	//fdelta = fdelta + EnvGen.kr(Env([1,2,1],[0.1,0.1]), 1);
	//fdelta = fdelta + EnvGen.kr(Env.sine(1/4/~t), 1, mul:0.0);
	//phase = Phasor.ar(1, 1,0,BufDur.kr(bufnum)) + pos;
	phase = pos;
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, phase % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = SinOsc.ar(freq * [1 + fdelta,1 - fdelta] * ( LFSaw.ar(sig*\fmffac.kr(100)+(\freqfac.kr(1)*freq)) * \fma.kr(1) * lfo1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * gain * amp ;
	sig.debug("sig");
	//sig = sig * [1,0];
	//sig = sig.reverse;
	Out.ar(out, sig);
}).add;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gransinfm2,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,12-7,7
			],inf).stutter(4),
			\fmffac, 0,
			\freqfac, Pseq([1],inf),
			\fma, 1,
			\octave, 3,
			\fdelta, Pseq([1,0.01,0.1],inf),
			\fdeltaf, Pseq([1,16*~t,0.1,4*~t],inf).stutter(5),
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/8,
			//\out, BusDef(\sendbus1, \audio),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
					2,0,2,0, 4,0,0,0, 0,0,2,0, 0,0,1,0,
				],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
		
	])
)).play;
);

(
Ndef(\zed, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01); 
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq) * (1..10)*10 * lfo1 + 1 ));
	sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);

(
Ndef(\zed, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01); 
	sig = SinOsc.ar(freq * 1/2 * ( SinOsc.ar(freq) * (1..10)*10 * lfo1 + 1 ));
	sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);

(
Ndef(\zed, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01); 
	sig = SinOsc.ar(freq * 1/2 * ( SinOsc.ar(freq) * (1..10)*10 * lfo1 + 1 ));
	sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);

(
Ndef(\zed, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01); 
	sig = SinOsc.ar(freq * 1/2 * ( SinOsc.ar(freq * ( SinOsc.ar(freq/2) * 10 + 1 )) * (1..10)*10 * lfo1 + 1 ));
	sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);

(
Ndef(\zed, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01); 
	sig = SinOsc.ar(freq * 1/2 * ( SinOsc.ar(freq * ( SinOsc.ar(freq/2) * 100 + 1 )) * (1..10)*10 * lfo1 + 1 ));
	sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);

(
Ndef(\zed, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01); 
	lfo1 = Duty.kr(1/~t, 0, Dseq([
		1,2,4,2,
	],inf));
	sig = SinOsc.ar(freq  * ( SinOsc.ar(freq * 1/4 * ( LFNoise1.ar(0.1) * (1..10)*10*1 + 1 ))  * 1*lfo1 + 1 ));
	sig = SinOsc.ar(freq * ( sig * 1 + 1 ));
	sig = SinOsc.ar(freq * ( sig * 0.1 + 1 ));
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
}).play;
);


(
SynthDef(\bassfmenkor, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/10) * 100; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	sig = SinOsc.ar(freq  * ( SinOsc.ar(freq * 1/4 * ( LFNoise1.ar(0.1) * (1..10)*100*1 + 1 ))  * 10*lfo1 + 1 ));
	sig = SinOsc.ar(freq * ( sig * 24 + 1 ));
	sig = SinOsc.ar(freq * ( sig * 0.2 + 1 ));
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bassfmenkor,
			\note, Pseq([
				0,4,1,
			],inf) + [0,3,7],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
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
			\instrument, \bassfmenkor,
			\note, Pseq([
				0,4,1,
			],inf) + [0,3,7],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,1, 1,1,1,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,1, 0,0,0,
				1,0,0, 0,0,1,  0,0,0, 0,1,0,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,1,0,1,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 0.95 + Pseq([
				0.1,0.03, -0.1,0.2,
			],inf),
			\pos, Pseq([
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,1.4,1.2,1,
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,-1,1,-1,
				-1,-1,-1,-1, 1,-1,1,-1,
				1.6,-1,-1,-1, -1,-1,-1,-1,
			],inf).collect({ arg x; if(x < 0) { Rest() } { x } })-1  + 0.1 + Pseq((0..7)/16,inf),
			\legato, 1,
			\dur, 1/16,
			\gain, 1/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2330].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0
			],inf).coin.not,
			\dur, 1/6,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,12-7,
			],inf).stutter(4),
			\fmffac, 4,
			\freqfac, Pseq([1,2,1/2],inf),
			\fma, 4,
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

		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,4,
			],inf) + Pseq((0..7)*3).stutter(2),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.2,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				Ppatlace([0,Pseq((1..6),inf).stutter(8)],inf),
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			\octave, 6,
			\note, Pseq([
				0,-5,-7,3,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		//Pbind(
			//\instrument, \default,
			//\note, Pseq([
				//Ppatlace([0,Pseq((1..6)).stutter(8)],inf),
			//],inf)+3,
			//\dur, 1/4,
			//\amp, 0.1,
		//),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\instrument, \bassfmenkor,
			\note, Pseq([
				Ppatlace([0,Pseq((1..6),inf).stutter(8)],inf),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,2.1) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\freqfac3, 1/4,
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \default,
			//\instrument, \bassfmenkor,
			\octave, 6,
			\note, Pseq([
				Ppatlace([0,Pseq((1..6),inf).stutter(8)],inf),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,2.1) ],
			],inf),
			\legato, 0.1,
			\dur, 1/8,
			\amp, 0.1/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\fmffac, 4,
			\freqfac, Pseq([1/2],inf),
			\fma, ~pmodenv.(Pseq([1,2,1,4]/2,1), 8).loop,
			\octave, 3,
			\fdelta, 1,
			\octave, 4,
			\note, Pseq([
				0,-5,-7,3,
			],inf),
			\dur, 1/2,
			\amp, 0.1,
		),
		//Pbind(
			//\instrument, \default,
			//\note, Pseq([
				//Ppatlace([0,Pseq((1..6)).stutter(8)],inf),
			//],inf)+3,
			//\dur, 1/4,
			//\amp, 0.1,
		//),
		
	])
)).play;
);

(
SynthDef(\bassfmenkor2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/1) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	sig = SinOsc.ar(freq * \freqfac1.kr(1) * ( SinOsc.ar(freq * \freqfac2.kr(1) * ( LFNoise1.ar(0.1) * (1..10)* \fma2.kr(1) + 1 ))  * \fma1.kr(1)*lfo1 + 1 ));
	sig = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig * \fma3.kr(4) + 1 ));
	sig = SinOsc.ar(freq * ( sig * \fma4.kr(0.8) + 1 ));
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassfmenkor_env, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/100) * 1; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	lfo2 = EnvGen.kr(\fma4env.kr(Env([2,1,1],[0.02,0.1])), 1);
	sig = SinOsc.ar(freq * \freqfac1.kr(1) * ( SinOsc.ar(freq * \freqfac2.kr(1) * ( LFNoise1.ar(0.1) * (1..10)* \fma2.kr(1) + 1 ))  * \fma1.kr(1)*lfo1 + 1 ));
	sig = SinOsc.ar(freq * \freqfac3.kr(1) * ( sig * \fma3.kr(4) + 1 ));
	sig = SinOsc.ar(freq * ( sig * \fma4.kr(0.8) * lfo2 + 1 ));
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\instrument, \bassfmenkor_env,
			\note, Pseq([
				Ppatlace([0,Pseq((1..6),inf).stutter(8)],inf),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.4) ],
			],inf),
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma1, 1000,
			\fma2, 1000,
			\fma4env, Pseq([
				[ Env([1,2,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.1,0.8]) ],
				[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(3),
			\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma4, 1,
			\freqfac1, 8,
			\freqfac2, 8,
			\freqfac3, 1/4,
			\legato, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\fmtutu, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,4],[0.01,0.04]), 1);
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq*1/2) * env1 * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmtutu,
			\note, Pseq([
				0,-6,-7,-9,
			],inf),
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
);


///////////////



(
Pdef(\part, Pdef(\zedpart, 
	Ptpar([
		0,Pbind(
			\instrument, \bassfmenkor,
			\note, Pseq([
				0,4,1,
			],inf) + [0,3,7],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			\amp, 0.1/2,
		),
		12,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,1, 1,0,1,
				1,0,1, 0,1,1,  0,0,1, 1,0,1,
				1,0,0, 0,0,1,  0,0,0, 0,1,0,
				1,1,1, 0,1,1,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,1, 0,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.3,
		),
		8, Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2330].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0
			],inf).coin.not,
			\dur, 1/6,
			\gain, 0.11/2,
		),
		10, Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[1914].value,
			\bufnum, ~buflib.hat[243].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				//0,0,0, 1,1,1,  0,0,0, 1,0,0,
				//0,0,1, 1,0,0,  0,0,1, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				1,0,0, 1,0,0,  1,0,0, 0,0,1,
				1,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 1,1,1,  0,0,0, 0,0,1,
				1,0,0, 0,0,0,  1,0,0, 0,0,0,
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/12,
			\gain, 0.08,
		),
		14, Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[243].value,
			\bufnum, ~buflib.hat[1914].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				//Pseq([
					//1,0,0, 1,0,0,  1,0,0, 1,0,0,
					//1,0,0, 1,0,0,  1,0,0, 1,0,0,
				//],4),
				//Pseq([
					//0,0,0, 1,1,1,  0,0,0, 1,0,0,
					//0,0,1, 1,0,0,  0,0,1, 1,0,0,
				//],4),
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				1,0,0, 1,0,0,  1,0,0, 0,0,1,
				1,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 1,1,1,  0,0,0, 0,0,1,
				1,0,0, 0,0,0,  1,0,0, 0,0,0,
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/12/2,
			\gain, 0.12,
		),
		4, Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,1, 1,0,0,0,
				1,0,1,0, 0,0,1,1,

				1,0,0,0, 1,1,0,1,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		16, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 0.95 + Pseq([
				0.1,0.03, -0.1,0.2,
			],inf),
			\pos, Pseq([
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,1.4,1.2,1,
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,-1,1,-1,
				-1,-1,-1,-1, 1,-1,1,-1,
				1.6,-1,-1,-1, -1,-1,-1,-1,
			],inf).collect({ arg x; if(x < 0) { Rest() } { x } })-1  + 0.1 + Pseq((0..7)/16,inf),
			\legato, 1,
			\dur, 1/16,
			\gain, 1/3,
		),
		8, Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,12-7,
			],inf).stutter(4),
			\fmffac, 4,
			\freqfac, Pseq([1,2,1/2],inf),
			\fma, 4,
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

		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ptpar([
		0,Pbind(
			\instrument, \bassfmenkor_env,
			\note, Pseq([
				0,4,1,
			],inf) + [0,3,7],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				[ Env([1,2,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.1,0.8]) ],
				[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(3),
			\fma1, 1,
			\fma2, 1000,
			\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma4, 0.4,
			\freqfac1, 4,
			\freqfac2, 1/8,
			\freqfac3, 1,
			\legato, 0.4,
			\amp, 0.1/4,
		),
		0,Pbind(
			\instrument, \bassfmenkor_env,
			\note, Pstep(Pseq([
				0,4,1,
			],inf),1/2) + Pseq([9,11,3,7,0],inf).stutter(1),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				[ Env([1,2,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.1,0.8]) ],
				[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(3),
			\fma1, 1000,
			\fma2, 1,
			\fma3, ~pmodenv.(Pseq([20.1,2,1,4],1), 9).loop,
			\fma4, 0.2,
			\freqfac1, 8,
			//\freqfac1, Pseq([1,2,8,4]/4,inf),
			\freqfac2, Pseq([1,2,8]/4,inf),
			\freqfac3, Pseq([1,2,1,1,1]/4,inf).stutter(3),
			\octave, 6,
			\legato, 0.8,
			\amp, 0.1/8 * Pseg(Pseq([0,1,Pwhite(0.6,1,inf)],inf),2),
		),
		12,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0, 0,0,0,  0,0,1, 1,0,1,
				1,0,1, 0,1,1,  0,0,1, 1,0,1,
				1,0,0, 0,0,1,  0,0,0, 0,1,0,
				1,1,1, 0,1,1,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,1, 0,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.3,
		),
		8, Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2330].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0
			],inf).coin.not,
			\dur, 1/6,
			\gain, 0.11/2,
		),
		10, Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[1914].value,
			\bufnum, ~buflib.hat[243].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				//0,0,0, 1,1,1,  0,0,0, 1,0,0,
				//0,0,1, 1,0,0,  0,0,1, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				1,0,0, 1,0,0,  1,0,0, 0,0,1,
				1,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 1,1,1,  0,0,0, 0,0,1,
				1,0,0, 0,0,0,  1,0,0, 0,0,0,
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/12,
			\gain, 0.08,
		),
		14, Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[243].value,
			\bufnum, ~buflib.hat[1914].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				//Pseq([
					//1,0,0, 1,0,0,  1,0,0, 1,0,0,
					//1,0,0, 1,0,0,  1,0,0, 1,0,0,
				//],4),
				//Pseq([
					//0,0,0, 1,1,1,  0,0,0, 1,0,0,
					//0,0,1, 1,0,0,  0,0,1, 1,0,0,
				//],4),
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				1,0,0, 1,0,0,  1,0,0, 0,0,1,
				1,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 1,1,1,  0,0,0, 0,0,1,
				1,0,0, 0,0,0,  1,0,0, 0,0,0,
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/12/2,
			\gain, 0.12,
		),
		4, Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,0, 1,0,1,0, 
				1,0,0,0, 1,0,1,0, 

				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,1, 1,0,0,0,
				1,0,1,0, 0,0,1,1,

				1,0,0,0, 1,1,0,1,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		16, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 0.95 + Pseq([
				0.1,0.03, -0.1,0.2,
			],inf),
			\pos, Pseq([
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,1.4,1.2,1,
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,-1,1,-1,
				-1,-1,-1,-1, 1,-1,1,-1,
				1.6,-1,-1,-1, -1,-1,-1,-1,
			],inf).collect({ arg x; if(x < 0) { Rest() } { x } })-1  + 0.1 + Pseq((0..7)/16,inf),
			\legato, 1,
			\dur, 1/16,
			\gain, 1/3,
		),
		8, Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,7-12,
			],inf).stutter(4),
			\fmffac, 4,
			\freqfac, Pseq([1,2,1/2],inf),
			\fma, 4,
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

		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ptpar([
		0,Pbind(
			\instrument, \bassfmenkor_env,
			\note, Pseq([
				0,4,1,
			],inf) + [0,3,7],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				[ Env([1,2,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.1,0.8]) ],
				[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(3),
			\fma1, 1,
			\fma2, 1000,
			\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma4, 0.4,
			\freqfac1, 4,
			\freqfac2, 1/8,
			\freqfac3, 1,
			\legato, 0.4,
			\amp, 0.1/4,
		),
		0,Pbind(
			\instrument, \bassfmenkor_env,
			\note, Pstep(Pseq([
				0,4,1,
			],inf),1/2) + Pseq([
				0,0,9,11,3,7,
				0,0,9,0,11,0,
				0,0,9,11,3,7,
				7,3,0,0,3,12,
			],inf).stutter(1),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				[ Env([1,2,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.1,0.8]) ],
				[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(3),
			\fma1, 1000,
			\fma2, 1,
			\fma3, ~pmodenv.(Pseq([20.1,2,1,4],1), 9).loop,
			\fma4, 0.2,
			\freqfac1, 8,
			//\freqfac1, Pseq([1,2,8,4]/4,inf),
			\freqfac2, Pseq([1,2,8]/4,inf),
			\freqfac3, Pseq([1,2,1,1,1]/4,inf).stutter(3),
			\octave, 6,
			\legato, 0.8,
			\amp, 0.1/8 * Pseg(Pseq([0,0,0.5,1,Pwhite(0.6,1,inf)],inf),2),
		),
		0,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([

				1,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,1, 0,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,0, 0,0,1,  0,0,0, 0,0,1,

				1,0,0, 0,0,0,  0,0,0, 0.71,0,0.2,
				0,0,1, 0.4,0,0.4,  0,0,0.4, 0.4,0,0.3,
				1,0,0, 0,0,0,  0,0,0, 0.71,0,0.2,
				0.1,0,1, 0.4,0,0.4,  0,0,0.4, 0.4,0,0.3,

			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.3,
		),
		0, Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2330].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0
			],inf).coin.not,
			\dur, 1/6,
			\gain, 0.11/2,
		),
		10, Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[1914].value,
			\bufnum, ~buflib.hat[243].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				//0,0,0, 1,1,1,  0,0,0, 1,0,0,
				//0,0,1, 1,0,0,  0,0,1, 1,0,0,
				Pseq([
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					1,0,0, 1,0,0,  1,0,0, 0,0,1,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,
					0,0,0, 1,1,1,  0,0,0, 0,0,1,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,
				],2),
				Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],6),
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/12,
			\gain, 0.08,
		),
		14, Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[243].value,
			\bufnum, ~buflib.hat[1914].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				//Pseq([
					//1,0,0, 1,0,0,  1,0,0, 1,0,0,
					//1,0,0, 1,0,0,  1,0,0, 1,0,0,
				//],4),
				//Pseq([
					//0,0,0, 1,1,1,  0,0,0, 1,0,0,
					//0,0,1, 1,0,0,  0,0,1, 1,0,0,
				//],4),
				Pseq([
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					1,0,0, 1,0,0,  1,0,0, 0,0,1,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,
					0,0,0, 1,1,1,  0,0,0, 0,0,1,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,
				],2),

				Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],4),
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/12/2,
			\gain, 0.12,
		),
		4, Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
					1,0,0,0, 1,0,1,0, 
					
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,1, 1,0,0,0,
					1,0,1,0, 0,0,1,1,
					
					1,0,0,0, 1,1,0,1,
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
					
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
				],2),

				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/8/2,
			\gain, 0.11 * (Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],4),

				Pseq([
					1,1,1,1, 1,1,1,1,
					1,0.7,0.9,0.6, 1,1,1,1,
					
					1,0.7,0.9,0.6, 1,1,0.9,0.6,
					1,0.7,1,1, 0.51,0.7,0.81,0.51,
				],2),
			],inf) + Pwhite(0,0.2,inf) - 0.1 ),
		),
		16, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 0.95 + Pseq([
				0.1,0.03, -0.1,0.2,
			],inf),
			\pos, Pseq([
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,1.4,1.2,1,
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,-1,1,-1,
				-1,-1,-1,-1, 1,-1,1,-1,
				1.6,-1,-1,-1, -1,-1,-1,-1,
			],inf).collect({ arg x; if(x < 0) { Rest() } { x } })-1  + 0.1 + Pseq((0..7)/16,inf),
			\legato, 1,
			\dur, 1/16,
			\gain, 1/3,
		),
		8, Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,7-12,
			],inf).stutter(4),
			\fmffac, 8,
			\freqfac, Pseq([1,2,1/2,4],inf),
			\fma, 4,
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
				4,0,0,0, 0,0,2,0,
				0,1,2,0, 1,2,0,1,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ptpar([
		0,Pbind(
			\instrument, \bassfmenkor_env,
			\note, Pseq([
				0,4,1,
			],inf) + [0,3,7],
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\dur, 1/2,
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				[ Env([1,2,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.1,0.8]) ],
				[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(3),
			\fma1, 1,
			\fma2, 1000,
			\fma3, ~pmodenv.(Pseq([0.1,20,1,4],1), 8).loop,
			\fma4, 0.4,
			\freqfac1, 4,
			\freqfac2, 1/8,
			\freqfac3, 1,
			\legato, 0.4,
			\amp, 0.1/4,
		),
		0,Pbind(
			\instrument, \bassfmenkor_env,
			\note, Pstep(Pseq([
				0,4,1,
			],inf),1/2) + Pseq([
				0,0,9,11,3,7,
				0,0,9,0,11,0,
				0,0,9,11,3,7,
				7,3,0,0,3,12,
			],inf).stutter(1),
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			//\freqfac2, ~pmodenv.(Pseq([1,2,1,4],1), 8).loop,
			\fma4env, Pseq([
				[ Env([1,2,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.01,0.8]) ],
				[ Env([2,1,1],[0.1,0.8]) ],
				[ Env([1,1,2],[0.1,0.8]) ],
			],inf).stutter(3),
			\fma1, 1000,
			\fma2, 1,
			\fma3, ~pmodenv.(Pseq([20.1,2,1,4],1), 9).loop,
			\fma4, 0.2,
			\freqfac1, 8,
			//\freqfac1, Pseq([1,2,8,4]/4,inf),
			\freqfac2, Pseq([1,2,8]/4,inf),
			\freqfac3, Pseq([1,2,1,1,1]/4,inf).stutter(3),
			\octave, 6,
			\legato, 0.8,
			\amp, 0.1/8 * Pseg(Pseq([0,0,0.5,1,Pwhite(0.6,1,inf)],inf),2),
		),
		6,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([

				1,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,1, 0,0,0,  0,0,0, 0,0,0,
				1,0,0, 0,0,0,  0,0,0, 1,0,0,
				0,0,0, 0,0,1,  0,0,0, 0,0,1,

				1,0,0, 0,0,0,  0,0,0, 0.71,0,0.2,
				0,0,1, 0.4,0,0.4,  0,0,0.4, 0.4,0,0.3,
				1,0,0, 0,0,0,  0,0,0, 0.71,0,0.2,
				0.1,0,1, 0.4,0,0.4,  0,0,0.4, 0.4,0,0.3,

			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.3,
		),
		4, Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2330].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0
			],inf).coin.not,
			\dur, 1/6,
			\gain, 0.11/2,
		),
		10, Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[1914].value,
			\bufnum, ~buflib.hat[243].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				//0,0,0, 1,1,1,  0,0,0, 1,0,0,
				//0,0,1, 1,0,0,  0,0,1, 1,0,0,
				Pseq([
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					1,0,0, 1,0,0,  1,0,0, 0,0,1,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,
					0,0,0, 1,1,1,  0,0,0, 0,0,1,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,
				],2),
				Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],6),
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/12,
			\gain, 0.08,
		),
		14, Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[243].value,
			\bufnum, ~buflib.hat[1914].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				//Pseq([
					//1,0,0, 1,0,0,  1,0,0, 1,0,0,
					//1,0,0, 1,0,0,  1,0,0, 1,0,0,
				//],4),
				//Pseq([
					//0,0,0, 1,1,1,  0,0,0, 1,0,0,
					//0,0,1, 1,0,0,  0,0,1, 1,0,0,
				//],4),
				Pseq([
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					0,0,0, 1,0,0,  0,0,0, 1,0,0,
					1,0,0, 1,0,0,  1,0,0, 0,0,1,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,
					0,0,0, 1,1,1,  0,0,0, 0,0,1,
					1,0,0, 0,0,0,  1,0,0, 0,0,0,
				],2),

				Pseq([
					0,0,0, 0,0,0,  0,0,0, 0,0,0,
				],4),
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/12/2,
			\gain, 0.12,
		),
		4, Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
					1,0,1,0, 1,0,1,0, 
					1,0,0,0, 1,0,1,0, 
					
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,0,0,0,
					0,0,1,1, 1,0,0,0,
					1,0,1,0, 0,0,1,1,
					
					1,0,0,0, 1,1,0,1,
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
					
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
				],2),

				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\lag, 0.02,
			\dur, 1/8/2,
			\gain, 0.11 * (Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],4),

				Pseq([
					1,1,1,1, 1,1,1,1,
					1,0.7,0.9,0.6, 1,1,1,1,
					
					1,0.7,0.9,0.6, 1,1,0.9,0.6,
					1,0.7,1,1, 0.51,0.7,0.81,0.51,
				],2),
			],inf) + Pwhite(0,0.2,inf) - 0.1 ),
		),
		16, Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 0.95 + Pseq([
				0.1,0.03, -0.1,0.2,
			],inf),
			\pos, Pseq([
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,1.4,1.2,1,
				-1,-1,-1,-1, 1,1,1,1,
				1.6,-1,1.3,1, -1,-1,1,-1,
				-1,-1,-1,-1, 1,-1,1,-1,
				1.6,-1,-1,-1, -1,-1,-1,-1,
			],inf).collect({ arg x; if(x < 0) { Rest() } { x } })-1  + 0.1 + Pseq((0..7)/16,inf),
			\legato, 1,
			\dur, 1/16,
			\gain, 1/3,
		),
		8, Pbind(
			\instrument, \gransinfm,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\note, Pseq([
				0,3,7-12,
			],inf).stutter(4),
			\fmffac, 8,
			\freqfac, Pseq([1],inf),
			\fma, 8,
			\octave, 3,
			\fdelta, 0.11,
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/8,
			//\out, BusDef(\sendbus1, \audio),
			\legato, Pseq([
				Pseq([
				12,0,0,0, 0,0,0,0,  0,0,0,0, 4,0,0,0,
				0,0,0,1, 4,0,0,0,  0,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,  0,0,0,0, 3,0,0,0,
				0,0,0,0, 2,0,0,1,  0,0,0,0, 0,0,1,0,
					
				8,0,0,0, 0,0,0,0,  0,0,0,0, 1,0,0,0,
				0,0,4,0, 0,0,0,0,  0,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,1,  0,0,0,0, 2,0,0,0,
				0,0,0,0, 0,0,1,0,  0,0,0,0, 0,0,1,0,

				],inf),
				Pseq([
					3,0,0,3, 0,0,2,0, 0,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,2,0,
					12,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,2,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 4,0,0,0,
				],2),
				12,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,2,0,
				1,3,0,0, 0,1,2,0, 2,0,0,0, 0,0,0,1,
			],inf)*0.9,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
		20,Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),4).loop / Pkey(\st),
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0.5,0.5,0.5,
				],8*4*2),

				Pser([
					0,0,0,0, 0,0.5,0.5,0.5,
					1,0.5,0.5,0.5, 1,0,0,0,
				],8*4*2),

				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0.5,0.5,0.5,
				],8*4*2),

				Pser([
					1,0.5,0.5,0.5, 0,0,0,0,
					0,0,0,0, 1,0.5,0.5,0.5,
				],8*4*2),
			],inf).coin.not,
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
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					// kick 3, 9, 15,19,25, 29,31, 35,41,47
					// hat, 2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50
					// doublehat, 1, 5, 11,13,17,21,27,33,37,43,45,49
					// snare 4, 12, 20, 28, 36,44
					// cymkick: 16, 42, 
					// snarekick, 10,26,32, 48,0
					//(0..15),
					Pseq([
						Prand([
							3, 9, 15,19,25, 29,31, 35,41,47
						],1),
						Prand([
							\r,\r,\r,\r,
							2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50,16,42,
							2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50,16,42,
1, 5, 11,13,17,21,27,33,37,43,45,49,
						],3),
						Prand([
							4, 12, 20, 28, 36,44
						],1).trace,
						Prand([
							\r,\r,\r,\r,
							2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50,16,42,
							2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50,16,42,
1, 5, 11,13,17,21,27,33,37,43,45,49,
						],3),
					],inf),
					Pseq([
						3,1,1,18,4,5,35,36,
						3,40,1,1,4,5,36,33,
						19,17,16,17,4,5,30,30,
					],inf),

					3,1,9,8,4,5,16,17,
					3,1,1,9,4,5,9,3,
					1,3,1,9,4,5,12,13,
					3,18,19,9,4,5,6,10,
				].flat,inf),
				Pseq([
					3,4
				],inf).stutter(4),
			]/8+0.6,inf) / Pkey(\st),
			\isRest, Pseq([

				Pser([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					//1,0,0,0, 1,0.5,0.5,0.5,
					//1,0.5,0.5,0.5, 1,0,0,0,
				],8*4*2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

(
	// rand rythm
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, Pseq([
				Pwhite(1,1.5,1),
				Pwhite(0.9,1.7,3),

				Pwhite(1,1.5,1),
				Pwhite(0.9,1.7,3),
			],inf),
			\st, 85/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseq([
				// kick 3, 9, 15,19,25, 29,31, 35,41,47
				// hat, 2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50
				// doublehat, 1, 5, 11,13,17,21,27,33,37,43,45,49
				// snare 4, 12, 20, 28, 36,44
				// cymkick: 16, 42, 
				// snarekick, 10,26,32, 48,0
				//(0..15),
				Prand([
					3, 9, 15,19,25, 29,31, 35,41,47
				],1),
				Prand([
					\r,\r,\r,\r,
					2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50,16,42,
					2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50,16,42,
					1, 5, 11,13,17,21,27,33,37,43,45,49,
				],3),
				Prand([
					4, 12, 20, 28, 36,44
				],1).trace,
				Prand([
					\r,\r,\r,\r,
					2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50,16,42,
					2, 6, 7, 8, 14, 18, 22, 23, 24, 30,34,38,39,40,46,50,16,42,
					1, 5, 11,13,17,21,27,33,37,43,45,49,
				],3),
			]/8+0.6,inf) / Pkey(\st),
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
			\bufnum, BufDef.stereo('vbreaks/Bill Withers - Kissing My Love (part1).wav'),
			\legato, 1,
			\st, 184/8/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bill Withers - Kissing My Love (part1).wav'),
			\legato, 1,
			\st, 184/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				Pseg(Pseq([
					0, 2,
				]+6,1),1),
				Pseg(Pseq([
					0, 4,
				]+0,1),4),
				Pseg(Pseq([
					3, 7,
				]+0,1),4),
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
		//Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1859].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 1,0,0,1,
				1,0,0,0, 1,1,1,0,
				0,0,1,0, 0,0,0,1,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[160].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0.4,0, 0,0,0.7,0,
				0,0.71,0,1, 0,0.71,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),

		Pmono(
			\playersec,
			\bufnum, BufDef('voices/praise.flac'),
			\dur, 1/8,
			\gain, 1,
			\lag, -0.04,
			\gain, Pkey(\gain) * Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],2),
			\out, BusDef(\sendbus2, \audio),
		).loop,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1687].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
			\legato, 1,
			\st, 177/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				(0..3)+8,
				(0..3)+10,
				(0..3)+14,
				(0..3)+8,

				(0..7)+4,
				(0..7)+12,
				//(0..7),
				//(0..15),
				//(0..15)+16,
			].flat/8,inf) / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8 * Pseq([
				1,0.6,0.8,0.3,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bill Withers - Kissing My Love (part1).wav'),
			\legato, 1,
			\st, 184/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				1,
				//(0..7),
				//(0..15),
				//(0..15)+16,
			].flat/8,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bill Withers - Kissing My Love (part1).wav'),
			\legato, 1,
			\st, 184/4/60,
			\speed, 1.1 * ~t / Pkey(\st),
			\pos, Pseq([
				0,1,2,3, 4,2,16,12,
				2,0,12,2, 4,2,16,32,
				0,4,2,0, 4,2,16,20,
				2,0,12,2, 4,2,16,32,
				//(0..7),
				//(0..15),
				//(0..15)+16,
			].flat/8,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
			Pbind(
				\instrument, \kick808,
				\note, Pseq([
					Pstep(Pseq([
						Pseq([
							Pseq([
								0
							],8*3),
							Pseq([
								0,4,3,2,3,-3,-1,-2,
							],1)+7,
						],inf)+4,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,5,2,10,9,7,5,
						],1)+12,

						2,2,2,2, 2,2,2,2,
						Pseq([
							0,2,10,9, 5,4,5+12,4+12,
						],1)+12,
					],1),1/4),
				],inf),
				\octave, 2,
				\freq2, Pkey(\freq),
				\freq1, Pkey(\freq)*2,
				\freq1, Pseq([
					Pstep(Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,1.2,1.2,1,
					],1),1/2)*2 * Pkey(\freq),
				],inf),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,2,0,
					0,0,1,3, 0,0,0,0, 0,0,0,0, 4,0,0,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 0,0,1,0,
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,2,0, 2,0,2,0,
				],inf),
				\glisdur, Pseq([
					Pstep(Pseq([
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.1,0.1,
						0.1,0.05,0.2,0.2,
						0.1,0.05,0.2,0.1,
					],1),1/2),
				],inf),
				\dist, 0.9,
				\ringTime, 100,
				//\durr, 0.01,
				//\lag, -0.04,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, PdurStutter(Pseq([8,8,8,8],inf), 1),
				//\out, BusDef(\chainin, \audio),
				//\out, BusDef(\sendbus1, \audio),
				\amp, 0.1,
			),
	])
)).play;
);

ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-H2PJ-3QCJ", BusDef('fx2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.78571428571429,
	'gain', 0.13445378151261,
	'fb', 0.0001,
	'delay', 0.76269858590234,
	'delay2', 0.00013628679593558,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.5705615758781,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 386.13954577665,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);



~protordn_to_fbstring.(ProtoDef(\rdn2)).editorInsert
(

SynthDef(\rdn_stutter, { arg out=0, gate=1;
	// code: 5-H2PJ-3QCJ
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 125331.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			}.value(si, env);

		].mean;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;


Pbind(
	'wet10', 1.0,
	'mix', 0.78571428571429,
	'gain', 0.28571428571429,
	'fb', 0.0001,
	'delay', 0.85659021536855,
	'delay2', 0.00012613637220374,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.5705615758781,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 386.13954577665,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)


);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[807].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2171].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\lag, -0.04,
			\out, BusDef(\ifx2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1015].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 0,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11 * Pwhite(0.8,1,inf) * Pseq([
				Pseq([
					1,0.61,0.81,0.41,
				],4).stutter(2) * Pseq([1,0.6],inf),
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0.51,0.51,0.51,0.51,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1911].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
					0,1,0,1, 0,0,1,0,
					0,0,0,0, 1,0,1,0,
				],2),
				Pseq([
					0,0,1,0, 0,0,1,0,
					0,0,0,1, 1,0,1,1,
					1,0,0,0, 0,0,1,1,
				],2),
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				Pwhite(0.1,1.2,2),
				Pwhite(0.7,1.5,1),
			],inf),
			\gain, 0.21,
		),
		Pmono(\rdn_stutter2,
			\inbus, BusDef(\ifx1, \audio),
			'mix', 0.18571428571429,
			'gain', 0.98571428571429,
			'fb', 0.000011,
			'delay', 1.60000025659021536855 * Pseq([1,1/2,2],inf),
			'delay', 1.60000025659021536855,
			'delay2', 0.0200012613637220374,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.0705615758781,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.17619047619048,
			'fbdistmix', 0.11176470588235,
			'postlpf', 1000,
			'posthpf', 20.13954577665,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			'delay', Pseq([1.6,0.8,0.9],inf),
			'delay2', 0.00020012613637220374 * Pseq([1,1/2,2,8],inf),
			//\lag, 1/~t,
			\dur, Pseq([1,Pn(2,inf)]),
			//\dur, 2,
		)<>
		Pmono(\rdn_stutter2,
			\inbus, BusDef(\ifx2, \audio),
			'mix', 0.18571428571429,
			'gain', 0.98571428571429,
			'fb', 0.0001,
			'delay', 1.60000025659021536855,
			'delay', 1.60000025659021536855,
			'delay2', 0.0020012613637220374 * Pseq([1,1/2,2],inf),
			'shift', 0.00,
			'shift2', 1.0,
			'distamp', 0.10705615758781,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.17619047619048,
			'fbdistmix', 0.11176470588235,
			'postlpf', 17000,
			'posthpf', 1686.13954577665,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', Pn(1,1),
			//\dur, 2,
			\amp, 0.1,
		).loop,
		
		Pbind(
			\instrument, \gransinfm2,
			\mbufnum, BufDef.mono('loop/pigs.flac'),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				5,4,3,1,
			],inf).stutter(4)-4,
			\fmffac, 0,
			\freqfac, Pseq([1],inf),
			\fma, 1,
			\octave, 3,
			\fdelta, Pseq([1,0.01,0.1],inf),
			\fdeltaf, Pseq([1,16*~t,0.1,4*~t],inf).stutter(5),
			\pos, Pseq([
				~pmodenv.(Pseq([0,0,0.03],1) + Pwhite(0,4.1).stutter(4), 2),
			],inf),
			\pitch_stretch, ~pmodenv.(Pseq([1,1/2,1/4,1/8],inf),8).loop,
			\pitch_stretch, Pwhite(0.4,0.1).stutter(4),
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,0.1) ],
			],inf),
			\gfreq, Pkey(\freq),
			\dur, 1/8,
			//\out, BusDef(\sendbus1, \audio),
				\legato, Pseq([
					6,0,0,0, 0,0,6,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 4,0,0,0, 0,0,2,0, 0,0,1,0,
				],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),

		),
	])
)).play;
);

(

SynthDef(\rdn_stutter2, { arg out=0, gate=1;
	// code: 5-H2PJ-3QCJ fork
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 125331.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		//si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			}.value(si, env);

		].mean;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;


Pbind(
	'wet10', 1.0,
	'mix', 0.78571428571429,
	'gain', 0.28571428571429,
	'fb', 0.0001,
	'delay', 0.85659021536855,
	'delay2', 0.00012613637220374,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.5705615758781,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 386.13954577665,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
);
Pdef(\part).reset;


);


/////////////////



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[160].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2152].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\accent, Pseq([
				
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,1,1,1,
			],inf),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\accent]/2 * 0.1) ]
				}),
			],inf),
			\legato, Pkey(\accent) * 0.4,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent) * 0.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1859].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1862].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1870].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1871].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1187].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0,0,0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11/3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[160].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				3,0,0.5,0, 0,0,1,0,
				0,1,0,1, 0,0,0,1,
			]/3,inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2152].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,1, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\accent, Pseq([
				
				1,1,1,1, 2,1,1,1,
				1,1,1,1, 2,1,1,1,
			],inf),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\accent]/2 * 0.1) ]
				}),
			],inf),
			\legato, Pkey(\accent) * 0.4,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent) * 0.5,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1859].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1862].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1870].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,0,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1871].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,0,0,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1187].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,0,0,0,0,0,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11/3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[160].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				3,0,0.5,0, 0,0,1,0,
				0,1,0,1, 0,0,0,1,
			]/3,inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2152].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,1, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\accent, Pseq([
				
				1,1,1,1, 2,1,1,1,
				1,1,1,1, 2,1,1,1,
			],inf),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\accent]/2 * 0.1) ]
				}),
			],inf),
			\legato, Pkey(\accent) * 0.4,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent) * 0.5,
		),
		Pbind(\out, BusDef(\sendbus3, \audio), \lag, -0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1859].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1862].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1870].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1871].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1187].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/3,
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 1.95 + Pseq([
				1
			],inf),
			\pos, Pseq([
				1,1,1,1,
				-1,-1,-1,-1, 
				-1,-1,-1,-1, 
				-1,-1,-1,-1, 
				-1,-1,-1,-1, 

				-1,-1,-1,-1,
				-1,-1,-1,-1,
				(0..3)+8,
				//(0..15)+16,
			].flat/16,inf).collect({ arg x; if(x < 0) { Rest() } { x } }),
			\legato, 1,
			\dur, 1/16,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[160].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				3,0,0.5,0, 0,0,1,0,
				0,1,0,1, 0,0,0,1,
			]/3,inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2152].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,1, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\accent, Pseq([
				
				1,1,1,1, 2,1,1,1,
				1,1,1,1, 2,1,1,1,
			],inf),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\accent]/2 * 0.1) ]
				}),
			],inf),
			\legato, Pkey(\accent) * 0.4,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent) * 0.5,
			\isRest, true,
		),
		Pbind(\out, BusDef(\sendbus3, \audio), \lag, -0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1859].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1862].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1870].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1871].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1187].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/3,
			),
		]),
	])
)).play;
);


ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-QDRT-43G4", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.34873949579832,
	'gain', 0.80672268907563,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001123104501833,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 16.065060038537,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 651.08102373701,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 5112.0256101056,
	'wetamp', 0.44251074739002,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\speed, 1.95 + Pseq([
				1
			],inf),
			\pos, Pseq([
				1,1,1,1,
				-1,-1,-1,-1, 
				-1,-1,-1,-1, 
				-1,-1,-1,-1, 
				-1,-1,-1,-1, 

				-1,-1,-1,-1,
				-1,-1,-1,-1,
				(0..3)+8,
				//(0..15)+16,
			].flat/16,inf).collect({ arg x; if(x < 0) { Rest() } { x } }),
			\legato, 1,
			\dur, 1/16,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[160].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				3,0,0.5,0, 0,0,1,0,
				0,1,0,1, 0,0,0,1,
			]/3,inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2152].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,1, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\accent, Pseq([
				
				1,1,1,1, 2,1,1,1,
				1,1,1,1, 2,1,1,1,
			],inf),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\accent]/2 * 0.1) ]
				}),
			],inf),
			\legato, Pkey(\accent) * 0.4,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent) * 0.5,
			\isRest, true,
		),
		Pbind(\out, BusDef(\sendbus3, \audio), \lag, -0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1859].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1862].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1870].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1871].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1187].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,0,0,0,1,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/3,
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\basedrums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[160].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				3,0,0.5,0, 0,0,1,0,
				0,1,0,1, 0,0,0,1,
			]/3,inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2152].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,0,1, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\accent, Pseq([
				
				1,1,1,1, 2,1,1,1,
				1,1,1,1, 2,1,1,1,
			],inf),
			\adsr, Pseq([
				Pfunc({ arg ev;
					[ Env.adsr(0.01,0.1,0.8,ev[\accent]/2 * 0.1) ]
				}),
			],inf),
			\legato, Pkey(\accent) * 0.4,
			\dur, 1/8,
			\gain, 0.11 * Pkey(\accent) * 0.5,
		),
		//Pbind(\out, BusDef(\sendbus3, \audio), \lag, -0.04) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1859].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1862].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1870].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1871].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1187].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,1,0,0,0,0,0,0,1,
				],inf).coin.not,
				\dur, 1/8/2,
				\gain, 0.11/3,
			),
		]),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basedrums1),
		Pseq([
			Pbind(
				\freqfac1, 4,
				\fma1, 100,
				\fma3, 100,
				\fma2, 1000,
				\freqfac2, 4,
			) <>
			Pfindur(16,Ppar([
				Pbind(
					\instrument, \bassfmenkor2,
					\note, Pseq([
						0,2,-5,-7
					],inf)-1 + Pseq([
						0,0,0,0,
						0,12,0,0,
						0,0,0,0,
						0,0,-12,12,
					],inf).stutter(2),
					\legato, Pseq([
						Pser([
							0.8
						],8*4),
						Pser([
							0.28,
							0.18,
						],8*4),
					],inf),
					\dur, 1/8,
					\amp, 0.1/3,
				),
				Pbind(
					\instrument, \bassfmenkor2,
					\note, Pseq([
						-7,-7, -8,-8,
						-9,-9, -10,-10,
						-7,-8,-9,-10,
					],inf).stutter(4)-1,
					\dur, 1/4,
					\amp, 0.1/3,
				),
			])),
			Pfindur(16,Ppar([
				Pbind(
					\instrument, \bassfmenkor2,
					\note, Pseq([
						0,2,-5,-7
					],inf)-1,
					\dur, 1/8,
					\amp, 0.1/3,
				),
				Pbind(
					\instrument, \bassfmenkor2,
					\note, Pseq([
						-7,-7, -8,-8,
						-9,-9, -10,-10,
						-7,-8,-9,-10,
					],inf).stutter(4)-1,
					\dur, 1/4,
					\amp, 0.1/3,
				),
			])),
			Pfindur(16,Ppar([
				Pbind(
					\instrument, \bassfmenkor2,
					\note, Pseq([
						0,-5,
					],inf)-1,
					\dur, 1/4,
					\amp, 0.1/3,
				),
				Pbind(
					\instrument, \bassfmenkor2,
					\note, Pseq([
						-7,-7, -8,-8,
						-9,-9, -10,-10,
						-7,-8,-9,-10,
					],inf).stutter(4)-1,
					\dur, 1/4,
					\amp, 0.1/3,
				),
			])),
		],1),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				//Pseq([
					//[0,3],
				//],8),
				Pseq([
					0,
				],8),
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basedrums1),
		Pseq([
			Pfindur(16,Ppar([
				Pbind(
					\instrument, \bassfmenkor2,
					\fma1, 100,
					\fma3, 1,
					\fma2, 1,
					\note, Pstep(Pseq([
						Pseq([
							\D2m_a, \As1M, \G2M_d, \C2M_e
						].chordProg,1),
						//[\As3M].chordProg
					],inf),2),
					\octave, [3,5],
					\legato, Pseq([
						Pser([
							0.78,
							0.18,
						],8*4),
					],inf),
					\legato, Pseq([
						3,0,0,1, 0,3,0,0,
						0,0,2,0, 0,0,2,0,
					],inf)*0.9,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,1.1) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1/3,
					\out, BusDef(\ifx1, \audio),
				),
				Pmono(\chorusdistlim,
					\inbus, BusDef(\ifx1, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\mix, 0.41,
					\delay, 0.01,
					\modamp, 0.01,
					\modfreq, 2.1,
					\gain, 1/2,
					\fb, 0.1,
					\dur, 1,
				),
				Pbind(
					\instrument, \bassfmenkor2,
					\note, Pstep(Pseq([
						Pseq([
							\Dm_a, \Dm7, \As, \As7, \G, \G7, \C_e, \C7
						].chordProg,1),
					],inf),1).collect { arg item, idx;
						item.choose
					},
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,1.1) ],
					],inf),
					\freqfac3, 4,
					\freqfac2, 1/4,
					\freqfac1, 2,
					\legato, Pseq([
						Pser([
							0.88, 0.18, 0.18, 0.88, 0.18, 0.18, 0.88, 0.18, 
							0.88, 0.18, 0.8, 0.88, 0.18, 0.18, 0.88, 0.18, 
							0.88, 0.18, 0.18, 0.88, 0.18, 0.18, 0.1, 0.18, 
							0.88, 0.18, 0.8, 0.88, 0.18, 0.8, 0.1, 0.18, 
						],8*4),
					],inf),
					\octave, 4,
					\dur, 1/8,
					\amp, 0.1/3,
				),
			])) <> Pbind(
				\freqfac1, 4,
				\fma1, 100,
				\fma3, 100,
				\fma2, 1000,
				\freqfac2, 4,
			),
			Pfindur(4, Pbind( \type, \rest,)),
		],4),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\basedrums1),
		Pseq([
			Pfindur(16,Ppar([
				Pbind(
					\instrument, \bassfmenkor2,
					\fma1, 100,
					\fma3, 1,
					\fma2, 1,
					\note, Pstep(Pseq([
						Pseq([
							\D2m_a, \As1M, \G2M_d, \C2M_e
						].chordProg,1),
						//[\As3M].chordProg
					],inf),1),
					//\octave, [3,5],
					\octave, 4,
					\legato, Pseq([
						Pser([
							0.78,
							0.18,
						],8*4),
					],inf),
					\legato, Pseq([
						3,0,0,1, 1,3,0,0,
						1,0,2,0, 1,0,2,0,
					],inf)*0.9,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,1.1) ],
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1/3,
					\out, BusDef(\ifx1, \audio),
				),
				Pmono(\chorusdistlim,
					\inbus, BusDef(\ifx1, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\mix, 0.41,
					\delay, 0.01,
					\modamp, 0.01,
					\modfreq, 2.1,
					\gain, 1/2,
					\fb, 0.1,
					\dur, 1,
				),
				Pbind(
					\instrument, \bassfmenkor2,
					\note, Pseq([
						2,\r,\r,\r, \r,2,\r,0,
						-2,\r,\r,\r, \r,-2,\r,-3,
						-5,\r,\r,\r, \r,-5,\r,-5,
						0,\r,\r,\r, \r,0,\r,1,


					],inf),
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,1.1) ],
					],inf),
					\freqfac3, 1,
					\freqfac2, 1/1,
					\freqfac1, 2,
					\legato, Pseq([
						Pser([
							0.88, 0.18, 0.18, 0.88, 0.18, 0.18, 0.88, 0.18, 
							0.88, 0.18, 0.8, 0.88, 0.18, 0.18, 0.88, 0.18, 
							0.88, 0.18, 0.18, 0.88, 0.18, 0.18, 0.1, 0.18, 
							0.88, 0.18, 0.8, 0.88, 0.18, 0.8, 0.1, 0.18, 
						],8*4),
					],inf),
					\octave, 6,
					\dur, 1/8,
					\amp, 0.1/3,
				),
			])) <> Pbind(
				\freqfac1, 4,
				\fma1, 100,
				\fma3, 100,
				\fma2, 1000,
				\freqfac2, 4,
			),
			Pfindur(4, Pbind( \type, \rest,)),
		],4),

	])
)).play;
);

