
// another dnb try
(
~t = 170/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
Scale.all.put(\lydiandim, Scale([0,2,3,6,7,9,11]));
)

(
SynthDef(\fmline, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var spread;
	spread = ((0..3)/3 - 0.5 * \fspread.kr(0.002) + 1);
	env1 = EnvGen.kr(Env([1,41,2],[1.1,1.8],4), 1);
	env2 = EnvGen.kr(Env([1,2,1400],[0.1,1.8],1), 1);
	mod2 = SinOsc.ar(freq) * 10 * env2;
	mod1 = SinOsc.ar(freq * spread + mod2) * 10 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq *[1/2,1,2] + mod2, mul:0.2) * 0.4; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\scratchercq, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var phase;
	//phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	phase = LFTri.ar(\sfreq.kr(1)).lag(0.1) * \samp.kr(1)/\sfreq.kr.sqrt + \pos.kr(1) * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0,1,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fmline5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var spread;
	spread = ((0..3)/3 - 0.5 * \fspread.kr(0.002) + 1);
	freq = freq * SinOsc.ar(1,mul:0.001,add:1);
	env1 = EnvGen.kr(Env([\fac1.kr(100),141,2],[5.1,1.8],4), 1);
	env2 = EnvGen.kr(Env([1,12,1000],[4.1,9.8],[1,2]), 1);
	mod2 = SinOsc.ar(freq) * \fma2.kr(1) * env2;
	mod1 = SinOsc.ar(freq * spread + mod2) * 1 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq *[1/2,1,2] + mod2, mul:0.3).mean * 0.4; 
	sig = BRF.ar(sig, freq * ( SinOsc.kr(0.9) * 0.2 + 1 ));
	sig = HPF.ar(sig, EnvGen.kr(Env([5000,500,100],[1.1,7.8],\exp), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,2.1,1,1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\fmline6, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var spread;
	spread = ((0..3)/3 - 0.5 * \fspread.kr(0.002) + 1);
	freq = freq * SinOsc.ar(1,mul:0.001,add:1);
	env1 = EnvGen.kr(Env([\fac1.kr(100),141,2],[5.1,1.8],4), 1);
	env2 = EnvGen.kr(Env([50,12,40],[1.1,9.8],[1,2]), 1);
	mod2 = SinOsc.ar(freq * 1/2) * \fma2.kr(1) * env2;
	mod1 = SinOsc.ar(freq * spread + mod2) * 1 * env1;
	sig = SinOsc.ar(freq + mod1);
	sig = sig + SinOsc.ar(freq *[1/2,1,2].reverse + mod2, mul:0.3).mean * 0.4; 
	sig = BRF.ar(sig, freq * ( SinOsc.kr(0.9) * 0.2 + 1 ));
	sig = HPF.ar(sig, EnvGen.kr(Env([5000,500,100],[1.1,7.8],\exp), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,2.1,1,1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\sh101lag, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq, vcfmod;
	freq = freq.lag(\freqlag.kr(0.1)) * ( \vcomod.kr(0) + 1 );
	sig = LFPulse.ar(freq,0,\pwidth.kr(0.5)) * \pulse.kr(0.5);
	sig = sig + (LFSaw.ar(freq) * \saw.kr(0.5));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.8)), gate, doneAction:0) * \envamt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(130) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	vcfmod = \vcfmod.kr(0) + 1;
	sig = MoogFF.ar(sig, ( \lpf.kr(930) * lpenv * lpfreq * vcfmod ).clip(20,20000), 1/\rq.kr(0.8)) * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	lpadsr: ParamEnvSpec.adsr,
))).add;
);

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1194].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pser([
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],14*8),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1568].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pser([
					0,0,0,0, 1,0,0,0,
				],14*8),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
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
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The New Mastersounds - Dusty Groove 2.wav'),
			\legato, 1,
			\st, 119/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 8,
			]+0,1),8).loop / Pkey(\st),
			\pos, Pseq([
				(0..15)
			].flat,inf) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,-2,0, 4,0,-5,3,
				0,1,1,-1, 0,0,0,0,
			],inf) /4/ Pkey(\st),
			\isRest, Pseq([
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,1,1,0,
				1,0,0,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,
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

		//Pdef(\vbreaks_drums),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1194].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1194].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1568].value,
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
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.snare[1568].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
				1,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,1,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\lpf, Pseg(Pseq([4000,500,7000],1),1,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/The Bar-Kays - Do You See What I See.wav'),
			\legato, 1,
			\st, 128/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),2).loop + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				12,12,8,8, 0,0,4,4,
				12,12,8,8, 0,0,4,4,
			]/8,inf).stutter(2)/ Pkey(\st) ,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
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
			\bufnum, BufDef.stereo('vbreaks/The Bar-Kays - Do You See What I See.wav'),
			\legato, 1,
			\st, 128/4/60,
			\speed, 1/3 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0,1),4).loop / Pkey(\st) + Pseq([
				0,0,0,0, 0,0,0,0,
			]/8,inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\gain, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Chuck Jackson - Through All Times.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1/4,
			]+( 0/4 ),1),1).loop + Pseq([
				Pseq([
					Pseq([
						4,4,4,4,
						4,4,3,2,
						4,4,4,4,
						3,0,8,3,
					],inf),
					0,0,0,0, 4,4,4,4,
					8,0,0,-2, 3,3,0,0,
					0,0,0,0, 4,4,4,4,
					8,8,8,8, 0,2,8,8,
					0,0,0,0, 4,4,4,4,
					0,-1,2,0, 0,2,8,8,
				],8).stutter(4),
				//0,0,0,3, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,3,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//4,4,4,4, 2,6,6,6,
				//Pn(-2,8),
				//0,1,1,-1, 0,0,0,0,
			]/16,inf) * Pkey(\bufdur),
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 1,1,1,1,
				2,0,2,0, 2,0,2,0,
				1,1,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Chuck Jackson - Through All Times.wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1/4,
			]+( 0/4 ),1),1).loop + Pseq([
				Pseq([
					Pseq([
						4,4,4,4,
						4,4,3,2,
						4,4,4,4,
						3,0,8,3,
					],inf),
					0,0,0,0, 4,4,4,4,
					8,0,0,-2, 3,3,0,0,
					0,0,0,0, 4,4,4,4,
					8,8,8,8, 0,2,8,8,
					0,0,0,0, 4,4,4,4,
					0,-1,2,0, 0,2,8,8,
				],8).stutter(4),
				//0,0,0,3, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//0,0,3,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//4,4,4,4, 2,6,6,6,
				//Pn(-2,8),
				//0,1,1,-1, 0,0,0,0,
			]/16,inf) * Pkey(\bufdur),
			\legato, Pseq([
				2,0,2,0, 2,0,2,0,
				2,0,2,0, 1,1,1,1,
				2,0,2,0, 2,0,2,0,
				1,1,2,0, 2,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1/2,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Soul Drums (part2).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/7 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1/4,
			]+0,1),2).loop + Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,4,0, 0,0,0,0,
				0,0,8,1, 0,0,0,0,
				0,0,4,2, 0,0,0,0,
				
			]/16,inf).stutter(2) * Pkey(\bufdur),
			\dur, 1/8,
			\lpf, PmodEnv(Pseq([1000,2000,14000],1), 8,\exp).loop,
			\gain, 1/4 * Pstep(Pseq([1,1,1,0],inf),1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Soul Drums (part3).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),8).loop * Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8 * Pstep(Pseq([0,0,0,1],inf),1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1095].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([ 1,0,1,0, 1,0,1,0, ],5),
				1,0,1,0, 1,1,0,1, 
				Pseq([ 1,0,1,0, 1,0,1,0, ],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					0,2, 1,3,
				],1).stutter(8),
			],inf),
			\legato, Pseq([
				0,0,0,0, 6,0,0,0,
				0,0,6,0, 0,0,0,0,
				16,0,0,0, 6,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.6,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\lpf, 300,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 0,6, ],16),
				Pser([ -1,7, ],16),
				Pser([ 1,6, ],16),
				Pser([ 2,6, ],16),
			],inf),
			\dur, 1/4,
			\octave, 5+Pseq([
				0,0,0,1, 1,0,1,0,
			],inf),
			\lpf, 400,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\extdrums1, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Soul Drums (part2).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/7 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1/4,
			]+0,1),2).loop + Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,4,0, 0,0,0,0,
				0,0,8,1, 0,0,0,0,
				0,0,4,2, 0,0,0,0,
				
			]/16,inf).stutter(2) * Pkey(\bufdur),
			\dur, 1/8,
			\lpf, PmodEnv(Pseq([1000,2000,14000],1), 8,\exp).loop,
			\gain, 1/4 * Pstep(Pseq([1,1,1,0],inf),1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Soul Drums (part3).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),8).loop * Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8 * Pstep(Pseq([0,0,0,1],inf),1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1095].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([ 1,0,1,0, 1,0,1,0, ],5),
				1,0,1,0, 1,1,0,1, 
				Pseq([ 1,0,1,0, 1,0,1,0, ],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\extdrums2, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Soul Drums (part2).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/7 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1/4,
			]+0,1),2).loop + Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,4,0, 0,0,0,0,
				0,0,8,1, 0,0,0,0,
				0,0,4,2, 0,0,0,0,
				
			]/16,inf).stutter(2) * Pkey(\bufdur),
			\dur, 1/8,
			\lpf, PmodEnv(Pseq([1000,2000,14000],1), 8,\exp).loop,
			\gain, 1/8 * Pstep(Pseq([1,1,1,1, 1,1,1,0],inf),2),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Soul Drums (part3).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),8).loop * Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8 * Pstep(Pseq([0,0,0,0, 0,0,0,1],inf),2),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1095].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([ 1,0,1,0, 1,0,1,0, ],5),
				1,0,1,0, 1,1,0,1, 
				Pseq([ 1,0,1,0, 1,0,1,0, ],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
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
				Pser([ 3,7,10, ],16),
				Pser([ -1,3,5,3 ],16),
			],inf),
			\dur, 1/4,
			\octave, 5+Pseq([
				0,0,0,1, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf),
			\lpf, 400,
			\amp, 0.1/2,
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
				Pser([ 4,7,11, ],16),
				Pser([ 5,8,0, ],16),
				Pser([ 0+12,4,8, ],16),
				Pser([ 2+12,4,8, ],16),
				//Pser([ 2,7,10, ],16),
				//Pser([ -1,3,5,3 ],16),
			],inf),
			\dur, 1/4,
			\octave, 5+Pseq([
				0,0,0,1, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf),
			\lpf, 400,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\extdrums2),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,-1, -1,2, ],1).stutter(8),
				Pseq([ 5,0, 0,2, ],1).stutter(8),
				Pseq([ 4,0, 0,2, ],1).stutter(8),
				Pseq([ 4,2, 2,2, ],1).stutter(8),
			],inf),
			\legato, Pseq([
				0,0,0,0, 6,0,0,0,
				0,0,6,0, 0,0,0,0,
				16,0,0,0, 6,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.6,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\envamt, PmodEnv(Pseq([2,10],1), 32).loop,
			\lpf, 300,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 4,7,11, ],16),
				Pser([ 5,8,0, ],16),
				Pser([ 0+12,4,8, ],16),
				Pser([ 2+12,4,8, ],16),
			],inf),
			\dur, 1/4,
			\octave, 5+Pseq([
				0,0,0,1, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf),
			\lpf, 400,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
// with pad and arp
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\extdrums2),

		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,-1, -1,2, ],1).stutter(8),
				Pseq([ 5,0, 0,2, ],1).stutter(8),
				Pseq([ 4,0, 0,2, ],1).stutter(8),
				Pseq([ 4,2, 2,2, ],1).stutter(8),
			],inf),
			\legato, Pseq([
				0,0,0,0, 6,0,0,0,
				0,0,6,0, 0,0,0,0,
				16,0,0,0, 6,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.6,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\envamt, PmodEnv(Pseq([2,10],1), 32).loop,
			\lpf, 300,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 4,7,11, ],16),
				Pser([ 5,8,0, ],16),
				Pser([ 0+12,4,8, ],16),
				Pser([ 2+12,4,8, ],16),
			],inf),
			\dur, 1/4,
			\octave, 5+Pseq([
				0,0,0,1, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf),
			\lpf, PmodEnv(Pseq([400,2000],1), 32, \exp).loop,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 4+12,7,11, ],
				[ 5+12,8,0, ],
				[ 0+12,4,8, ],
				[ 2+12,4,8, ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\dirt, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpmod;
	sig = LFSaw.ar(freq);
	sig = sig * ( LFSaw.ar(freq+0.1) + 0.1 ); 
	lpmod = LFSaw.ar(\lpmf.kr(4*~t)).lag(0.05) * \lpma.kr(1);
	sig = RLPF.ar(sig, ( \lpf.kr(100) * ( lpmod + 1 ) ).clip(20,2e4), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \dirt,
			\note, Pseq([
				4,5,0,2,
			],inf),
			\lpf, PmodEnv(Pseq([100,6000],1), 32, \exp).loop,
			\lpmf, ~pmodstep.(Pseq([1,4,2,2]/2*~t,inf),1),
			\lpma, 0.7,
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
			\instrument, \dirt,
			\degree, Pseq([
				0,0,0,1,2,3,4,5,
			],inf),
			\scale, Scale([5,7,8,11,12,14,16]),
			\lpf, PmodEnv(Pseq([300,6000],1), 32, \exp).loop,
			\lpmf, ~pmodstep.(Pseq([1,4,2,2]/2*~t,inf),1),
			\lpma, 0.7,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
// with pad
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\extdrums2),

		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,-1, -1,2, ],1).stutter(8),
				Pseq([ 5,0, 0,2, ],1).stutter(8),
				Pseq([ 4,0, 0,2, ],1).stutter(8),
				Pseq([ 4,2, 2,2, ],1).stutter(8),
			],inf),
			\legato, Pseq([
				0,0,0,0, 6,0,0,0,
				0,0,6,0, 0,0,0,0,
				16,0,0,0, 6,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.6,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\envamt, PmodEnv(Pseq([2,10],1), 32).loop,
			\lpf, 300,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 4,7,11, ],16),
				Pser([ 5,8,0, ],16),
				Pser([ 0+12,4,8, ],16),
				Pser([ 2+12,4,8, ],16),
			],inf),
			\dur, 1/4,
			\octave, 5+Pseq([
				0,0,0,1, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf),
			\lpf, PmodEnv(Pseq([400,2000],1), 32, \exp).loop,
			\amp, 0.1/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 4+12,7,11, ],
				[ 5+12,8,0, ],
				[ 0+12,4,8, ],
				[ 2+12,4,8, ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \dirt,
			\degree, Pseq([
				Pser([ -1,-4, ],8),
				Pser([ 0,-3, ],8),
				Pser([ 2,-1 ],8),
				Pser([ -2,-4, ],8),
			],inf),
			\scale, Scale.at(\lydiandim), \root, 5,
			\lpf, PmodEnv(Pseq([800,6000],1), 32, \exp).loop,
			\lpmf, ~pmodstep.(Pseq([1,4,2,2]/2*~t,inf),1),
			\octave, 6,
			\lpma, 0.7,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);

(
// 
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\extdrums2),

		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,-1, -1,2, ],1).stutter(8),
				Pseq([ 5,0, 0,2, ],1).stutter(8),
				Pseq([ 4,0, 0,2, ],1).stutter(8),
				Pseq([ 4,2, 2,2, ],1).stutter(8),
			],inf),
			\legato, Pseq([
				0,0,0,0, 6,0,0,0,
				0,0,6,0, 0,0,0,0,
				16,0,0,0, 6,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.6,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\envamt, PmodEnv(Pseq([2,10],1), 32).loop,
			\lpf, 300,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 4,7,11, ],16),
				Pser([ 5,8,0, ],16),
				Pser([ 0+12,4,8, ],16),
				Pser([ 2+12,4,8, ],16),
			],inf),
			\dur, 1/4,
			\octave, 5+Pseq([
				0,0,0,1, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf),
			\lpf, PmodEnv(Pseq([400,2000],1), 32, \exp).loop,
			\amp, 0.1/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 4+12,7,11, ],
				[ 5+12,8,0, ],
				[ 0+12,4,8, ],
				[ 2+12,4,8, ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \dirt,
			\degree, Pseq([
				Pstep(Pseq([
					  	Pser([ -1,-4, ],2),
					  	Pser([ 0,-3, ],2),
					  	Pser([ 2,-1 ],2),
					  	Pser([ -2,-4, ],2),
					  ],1),2),

			],inf),
			\scale, Scale.at(\lydiandim), \root, 5,
			\lpf, PmodEnv(Pseq([800,6000],1), 32, \exp).loop,
			\lpmf, ~pmodstep.(Pseq([1,4,2,2]/2*~t,inf),1),
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 1,1,0,1,
				1,0,1,0, 0,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\octave, 6,
			\legato, 2,
			\lpma, 0.7,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
// 
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\extdrums2),

		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,-1, -1,2, ],1).stutter(8),
				Pseq([ 5,0, 0,2, ],1).stutter(8),
				Pseq([ 4,0, 0,2, ],1).stutter(8),
				Pseq([ 4,2, 2,2, ],1).stutter(8),
			],inf),
			\legato, Pseq([
				0,0,0,0, 6,0,0,0,
				0,0,6,0, 0,0,0,0,
				16,0,0,0, 6,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf)*0.7,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.3,0.6,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\envamt, PmodEnv(Pseq([2,10],1), 32).loop,
			\lpf, 300,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 4,7,11, ],16),
				Pser([ 5,8,0, ],16),
				Pser([ 0+12,4,8, ],16),
				Pser([ 2+12,4,8, ],16),
			],inf),
			\dur, 1/4,
			\octave, 5+Pseq([
				0,0,0,1, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf),
			\lpf, PmodEnv(Pseq([400,2000],1), 32, \exp).loop,
			\amp, 0.1/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 4+12,7,11, ],
				[ 5+12,8,0, ],
				[ 0+12,4,8, ],
				[ 2+12,4,8, ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \dirt,
			\degree, Pseq([
				Pser([ -1, ],8),
				Pser([ -2,-1 ],2).stutter(4),
				Pser([ 0, ],16),

				Pser([ 0, ],8),
				Pser([ -1,0 ],2).stutter(4),
				Pser([ -1, ],16),

				Pser([ 2,2,1,0 ],4).stutter(2),
				Pser([ 1,0 ],2).stutter(4),
				Pser([ -1, ],16),

				Pser([ -2, ],8),
				Pser([ -2,0 ],2).stutter(4),
				Pser([ -4, ],16),
				//Pstep(Pseq([
					//Pser([ -1,-4, ],2),
					//Pser([ 0,-3, ],2),
					//Pser([ 2,-1 ],2),
					//Pser([ -2,-4, ],2),
				//],1),2),

			],inf),
			\scale, Scale.at(\lydiandim), \root, 5,
			\lpf, PmodEnv(Pseq([800,6000],1), 32, \exp).loop,
			\lpmf, ~pmodstep.(Pseq([1,4,2,2]/2*~t,inf),1),
			\isRest, Pseq([
				1,0,0,0, 1,0,1,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 1,0,1,0,
				0,0,1,0, 1,0,1,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 1,0,1,0,
				0,0,1,0, 1,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				0,0,1,0, 1,0,0,0,
				1,1,0,1, 1,0,1,1,
				0,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\octave, 6,
			\lpma, 0.7,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

////////// draft
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \dirt,
			\degree, Pseq([
				Pser([
					-1,0,
				],8),
			],inf),
			\scale, Scale([5,7,8,11,12,14,16]),
			\lpf, PmodEnv(Pseq([800,6000],1), 32, \exp).loop,
			\lpmf, ~pmodstep.(Pseq([1,4,2,2]/2*~t,inf),1),
			\octave, 6,
			\lpma, 0.7,
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
			\instrument, \default,
			\degree, Pseq([
				//-1,0,
				Pseq((0..8)),

			],inf),
			//\scale, Scale([5,7,8,11,12,14,16]),
			//\scale, Scale.lydian, \root, 5,
			\scale, Scale.at(\lydiandim), \root, 5,
			\lpf, PmodEnv(Pseq([800,6000],1), 32, \exp).loop,
			\lpmf, ~pmodstep.(Pseq([1,4,2,2]/2*~t,inf),1),
			\octave, 6,
			\lpma, 0.7,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);
Scale.all
Scale.lydian.degrees
Scale.all.put(\lydiandim, Scale([0,2,3,6,7,9,11]))


////////////////////

SynthDef(\bassbla, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// sin into delay with lfo, xfade harms
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var lpenv;
	var delay;
	var lfoharms = [1,1/2,2,3,4];
	var delayharms = [1,2,1/2,1/3,1/4];
	//var lfoharms = [1,1,1];
	//var delayharms = [1,1,1];
	var voices;
	sig = SinOsc.ar(freq);

	voices = lfoharms.collect { arg lfoharm, idx;
		delayharms.collect { arg delayharm;
			var isig;
			delay = 1/freq * delayharm * \delayfac.kr(1);
			lfo1 = LFSaw.ar(1/delay);
			isig = DelayL.ar(sig, \maxdelay.kr(0.1), lfo1 * delay * SinOsc.ar(freq * lfoharm * \lfofac.kr(1), mul:\lfoa.kr(0.1), add:1)) + sig;
			isig;
		}
	};
	sig = SelectX.ar(\delayselect.kr(0) * ( lfoharms.size - 1 ), SelectX.ar(\lfoselect.kr(0) * ( delayharms.size - 1 ), voices));
	lpenv = EnvGen.kr(\lpenv.kr(Env([1,2,1],[0.04,0.2])), 1) * \lpenva.kr(2.7) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(400) * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 0.5;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
(
Pdef(\part, Pdef(\extdrums3, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Soul Drums (part3).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/7 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1/4,
			]+0,1),2).loop + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 8,0,0,0,
				0,0,0,8, 0,0,0,0,
				8,8,0,0, 0,0,0,0,
				2,2,0,2, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,4,4, 8,8,0,0,
				0,0,8,8,0,8,8,8,	
			]/16,inf).stutter(2) * Pkey(\bufdur),
			\dur, 1/8,
			\lpf, PmodEnv(Pseq([11000,5000,14000],1), 16,\exp).loop,
			\hpf, PmodEnv(Pseq([1000,100,4000],1), 16,\exp).loop,
			\gain, 1/8 * Pstep(Pseq([1,1,1,1, 1,1,1,0],inf),2),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Soul Drums (part2).wav'),
			\legato, 1,
			\bufdur, Pfunc({ arg ev; ev[\bufnum].duration }),
			\speed, 1/8 * ~t * Pkey(\bufdur),
			\pos, Pseg(Pseq([
				0, 1,
			]+0,1),8).loop * Pkey(\bufdur),
			\dur, 1/8,
			\gain, 1/8 * Pstep(Pseq([0,0,0,0, 0,0,0,1],inf),2),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1095].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([ 1,0,1,0, 1,0,1,0, ],5),
				1,0,1,0, 1,1,0,1, 
				Pseq([ 1,0,1,0, 1,0,1,0, ],2),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\extdrums3),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				Pser([
					0,
				],7),
				7,
				Pseq([
					Pser([
						0,
					],7),
					8,
				],2),
					Pser([
						0,
					],7),
					2,
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lfoselect, 0.5,
			\delayselect, 0.51,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 4+12,7,11, ],
				[ 5+12,8,0, ],
				[ 0+12,4,8, ],
				[ 2+12,4,8, ],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 600,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\extdrums3),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				Pstep(Pseq([
					Pser([
						0,
					],7),
					7,
					Pseq([
						Pser([
							0,
						],7),
						8,
					],2),
					Pser([
						0,
					],7),
					2,
				],1),1/4),
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lfoselect, 0.5,
			\delayselect, 0.51,
			\legato, Pseq([
				1,1,0,0, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				2,0, 2,0, 2,0, 2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 4+12,7,11, ],
				[ 5+12,8,0, ],
				[ 0+12,4,8, ],
				[ 2+12,4,8, ],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 600,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


Pdef.defaultQuant = 4
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\extdrums3),
		Pbind(
			\instrument, \bassbla,
			\note, Pseq([
				Pser([
					0,
				],7),
				7,
				Pseq([
					Pser([
						0,
					],7),
					8,
				],2),
					Pser([
						0,
					],7),
					2,
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 32,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lfoselect, 0.5,
			\delayselect, 0.51,
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[ 4+12,7,11, ],
				[ 5+12,8,0, ],
				[ 0+12,4,8, ],
				[ 2+12,4,8, ],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hpf, \audio),
			\addAction, \addToTail,
			\hpf, 600,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 4,7,11, ],16),
				Pser([ 5,8,0, ],16),
				Pser([ 0+12,4,8, ],16),
				Pser([ 2+12,4,8, ],16),
			],inf),
			\dur, 1/4,
			\octave, 5+Pseq([
				0,0,0,1, 1,0,1,0,
				0,0,0,1, 1,0,1,1,
			],inf),
			\isRest, Pseq([
				0,0,0.3,0, 0.3,0,0,0,
				0.3,0,1,1, 1,0.7,0.8,1,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\lpf, PmodEnv(Pseq([400,2000],1), 32, \exp).loop,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
SynthDef(\sindel, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	env1 = EnvGen.kr(\env1.kr(Env([0,1,0],[0.5,0.8])), 1) + 1;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.01) * env1 * ( SinOsc.ar(freq *\fmf.kr(1))*\fma.kr(0.03) + 1 ) ) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 0.7;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
// base chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sindel,
			\note, Pseq([
				[0,4,7],
				[0,4,6],
				[0,3,6],
				[-1,4,7],

				[-1,4,7],
				[-2,4,7],
				[-2,4,6],
				[-1,3,6],

				[-1,3,6],
				[-1,3,9],
				[-1,3,6],
				[0,4,7],
			],inf),
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.01) ],
			],inf),
			\fmf, 1/2,
			\fma, PmodEnv(Pseq([0.001,0.02,0.04],1), 8).loop,
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
			\instrument, \sindel,
			\note, Pseq([
				[0,4,7],
				[0,4,6],
				[0,3,6],
				[-1,4,7],

				[-1,4,7],
				[-2,4,7],
				[-2,4,6],
				[-1,3,6],


				[-1,3,6],
				[-2,3,6],
				[-2,3,5],
				[-1,3,6],


				[-1,3,6],
				[-1,3,9],
				[-1,3,6],
				[0,4,7],

				//[0,4,7],
				//[0,4,6],
				//[0,3,6],
				//[-1,4,7],

				//[0,4,7],
				//[0,4,11],
				//[0,4,7],
				//[-5,-1,4],

			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.01) ],
			],inf),
			\fmf, 2,
			\fma, PmodEnv(Pseq([0.001,0.02,0.04],1), 16).loop,
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
// with drums
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\extdrums3),
		Pbind(
			\instrument, \sindel,
			\note, Pseq([
				[0,4,7],
				[0,4,6],
				[0,3,6],
				[-1,4,7],

				[-1,4,7],
				[-2,4,7],
				[-2,4,6],
				[-1,3,6],

				[-1,3,6],
				[-1,3,9],
				[-1,3,6],
				[0,4,7],
			],inf),
			\legato,1,
			\adsr, Pseq([
				[ Env.adsr(1.1,0.1,0.8,1.01) ],
			],inf),
			\fmf, Pstep(Pseq([1/2,1,2],inf),32),
			\fma, PmodEnv(Pseq([0.001,0.02,0.04],1), 8).loop,
			\dur, 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\cnote, Pstep(Pseq([
				[0,4,7],
				[0,4,6],
				[0,3,6],
				[-1,4,7],

				[-1,4,7],
				[-2,4,7],
				[-2,4,6],
				[-1,3,6],

				[-1,3,6],
				[-1,3,9],
				[-1,3,6],
				[0,4,7],
			],inf),2),
			\note, Plazy({ arg ev;
				Pseq(ev[\cnote]);
			}).loop + Pseq([0,-12,0,-12],inf).stutter(1),
			\octave, 6,
			\lpf, PmodEnv(Pseq([400,2400,9000],1), 16,\exp).loop,
			\adsr, Pseq([
				PpatEnv.adsr( Pseg(Pseq([0.1,0.01],inf),32),0.1,0.8,0.1),
			],inf),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);


//////// chromatic chords movement

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0,4,7,11],
			],inf),
			\root, Pseq([
				0, 2,
			],1),
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
MIDIdef.noteOn(\track1, { arg velocity, noteNum, channel, deviceId;
	var chord = [0,4,7,11];
	[ velocity, noteNum, channel, deviceId ].debug("chord");
	~midi = ~midi ?? { nil!127 };
	~midi[noteNum] = (midinote: noteNum+chord, latency:Ref(nil), sustain: inf).play;
});
MIDIdef.noteOff(\track1_off, { arg velocity, noteNum, channel, deviceId;
	var chord = [0,4,7,11];
	[ velocity, noteNum, channel, deviceId ].debug;
	~midi = ~midi ?? { nil!127 };
	if(~midi[noteNum].notNil) {
		~midi[noteNum].release;
		~midi[noteNum] = nil;
	};
});
)

