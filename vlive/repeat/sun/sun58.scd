
~t = 300/4/60; TempoClock.default.tempo = ~t;

FileSystemProject.loadOnce("sndlib/synthaccu.scd");
/// expand sun27.scd blues
(
SynthDef(\olok, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\iGNUcius, {
	var freq, amp, gate, osc, lfo, out, aenv, filterEnv, bus, resoFilter, bowNoise;
   // [hackers]:free.be(ll), you!help(software).share;
	freq = \freq.kr(440);
	amp = \amp.kr(0.1) / 3;
	gate = \gate.kr(1);
	bus = \out.kr(0);
	
	// piles.of(can.get)hoarders.money,is[true];
	osc = Pulse.ar([freq, freq*2], LFNoise1.kr(0.5!2).range(0.1, 0.9)) +
		  Pulse.ar([freq*3, freq], LFNoise1.kr(0.5!2).range(0.1, 0.9));

	// neighbors.their(help).but!cannot; true.is[that];
	lfo = SinOsc.kr(\lfoFreq.kr(0.5)).range(-0.05, 0.05) * \lfoDepth.kr(1);
	bowNoise = WhiteNoise.ar(0.15) * EnvGen.kr(Env.perc(0.01, 0.1), gate); 

	// enough(when).software.free.have[we], call.our[at];
	out = (osc + bowNoise) * (1 + lfo);
	aenv = EnvGen.ar(Env.adsr(0.05, 0.2, 0.9, 0.5), gate, doneAction: Done.freeSelf) * amp;
	filterEnv = EnvGen.kr(Env.adsr(0.01, 0.3, 0.7, 0.5), gate);

	// dirty.those(licenses).kick[we'll] out.ever.more;
	resoFilter = RLPF.ar(out, freq * \filterMul.kr(4) * filterEnv, \resonance.kr(0.4));
	out = RHPF.ar(resoFilter, 100) * aenv;

	// be.free, hackers.you'll.join(us).now[and];
	Out.ar(bus, DFM1.ar(out));
	//Out.ar(bus, out);
}).add;
);
(
SynthDef(\Piano_rhodeySC, {
	//FM Rhodes Synthethizer
	|
	// standard meanings
	out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1,
	// all of these range from 0 to 1
	vel = 0.8, modIndex = 0.2, mix = 0.2, lfoSpeed = 0.4, lfoDepth = 0.1
	|
	var env1, env2, env3, env4;
	var osc1, osc2, osc3, osc4, snd;

	lfoSpeed = lfoSpeed * 12;

	freq = freq * 2;

	env1 = EnvGen.ar(Env.adsr(0.001, 1.25, 0.0, 0.04, curve: \lin));
	env2 = EnvGen.ar(Env.adsr(0.001, 1.00, 0.0, 0.04, curve: \lin));
	env3 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));
	env4 = EnvGen.ar(Env.adsr(0.001, 1.50, 0.0, 0.04, curve: \lin));

	osc4 = SinOsc.ar(freq * 0.5) * 2pi * 2 * 0.535887 * modIndex * env4 * vel;
	osc3 = SinOsc.ar(freq, osc4) * env3 * vel;
	osc2 = SinOsc.ar(freq * 15) * 2pi * 0.108819 * env2 * vel;
	osc1 = SinOsc.ar(freq, osc2) * env1 * vel;
	snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
	snd = snd * (SinOsc.ar(lfoSpeed) * lfoDepth + 1);

	// using the doneAction: 2 on the other envs can create clicks (bc of the linear curve maybe?)
	snd = snd * EnvGen.ar(Env.asr(0, 1, 0.1), gate, doneAction: 2);
	snd = Pan2.ar(snd, pan, amp);

	Out.ar(out, snd);
//By Nathan Ho aka Snappizz
//http://sccode.org/1-522
}).add;
);

//ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-AP62-B9C3", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.31512605042017,
	'gain', 0.23109243697479,
	'fb', 0.0001,
	'delay', 0.00043516650709244,
	'delay2', 0.58170913293744,
	'shift', -0.12605042016807,
	'shift2', 0.0,
	'distamp', 6.1647570563372,
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
//ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-1MAL-6OK2", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.35714285714286,
	'gain', 0.18067226890756,
	'fb', 0.0001,
	'delay', 0.92552159097914,
	'delay2', 0.00011674193588235,
	'shift', 0.71428571428571,
	'shift2', 0.12605042016807,
	'distamp', 5.3320075574803,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 166.41714337987,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);
//ProtoDef(\rdn3).presetCompileString.editorInsert
(
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-1P2U-BR5D", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.48319327731092,
	'gain', 0.29831932773109,
	'fb', 0.0001,
	'delay', 0.44366873309786,
	'delay2', 0.0001,
	'shift', 0.16806722689076,
	'shift2', 0.0,
	'distamp', 0.6408002744416,
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


(
Pdef(\part, Pdef(\basicbreak, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[879].value,
			\score, Pseq([
				1,0,0.4,0, 0.3,0,0.3,0,
				0,0,0.5,0.5, 0,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.15 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[771].value,
			\score, Pseq([
				1,0,0,0, 0,0,0,1,
				0,1,0,0, 0,0,0,1,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.05) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2 * Pkey(\score),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1090].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\score, Pseq([
				0.2,0,1,0, 0.2,0.2,1,0.2,
				0.2,0,0.2,0.1, 0.2,0,1,0.2,
			],inf),
			\isRest, Pkey(\score).coin.not,
			\dur, 1/8,
			\gain, 0.11 * (Pkey(\score) * 4).clip(0,1),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 3,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 7,
			\lpfr, ~pmodenv.(Pseq([0.1,2,1,4],1), 8).loop,
			\lpenv, Pseq([
				Pseq([
					[ Env([0.3,0.7,1],[1.1,0.8]) ],
				],16),
				Pser([
					[ Env([1,2,1],[0.1,0.8]) ],
					[ Env([1,1,4],[0.1,0.8]) ],
					[ Env([1,0.2,3],[0.1,0.8]) ],
				],16),
			],inf),
			\note, Pseq([
				Pser([
					[12,7],
					[12,7],
					7,
					[12,7],
					[12,7],
					6,
				],8),
				[0,7],
				[7-12,0],
				Pser([
					[12,7],
					12,
				],6),

				Pser([
					[12,7],
					[12,7],
					7,
					[12,7],
					[12,7],
					6,
				],8),
				Pser([
					[-12,0],
					-12,
					[7,3]
				],4),
				6,
				[-2,3],
				[0,7],
				[7-12,0],
			],inf),
			//\dur, PdurStutter(Pseq([1,4,2,8],inf), 1/2),

			\legato, Pseq([
				6,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,0,
				6,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,2,0,1,
				1,1,2,0, 1,1,1,1,

				4,0,0,0, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,

				1,0,2,0, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,8,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			
			\dur, 1/8,
			\amp, 0.051,
		),
		Pdef(\basicbreak),
		Pbind(
			\instrument, \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 7,
			\note, Pseq([
				Pseq([
					Prand([12,6,7],4),
					Prand([12,3,10,6,7],4),
					Prand([12,6,7],4),
					Prand([0,3,0,5,5,6],4),
					Prand([12,6,7],4),
					Prand([12,3,10,6,7],4),
					Prand([0,3,0,5,5,6],4),
					Prand([0,3,0,5,5,6],4),
					
				],1),
				//Pfin(30,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				//-12,\r,
			],inf),
			\isRest, Pseq([
				1,0.7,0.9,0.5
			],inf).coin.not,
			\legato, 0.8* Pseq([
				Prand([
					Pseq([ 4,0,0,0, ],1),
					Pseq([ 2,0,2,0, ],1),
					Pseq([ 0,1,1,1, ],1),
					Pseq([ 1,1,1,0, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 3,0,0, 3,0,0, 3,0 ],1),
					Pseq([ 1,2,0,1, ],1),
					Pseq([ 1,1,2,0, ],1),
				],1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\isRest] } }),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.061,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pseq([
				Pfin(14,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				7,10,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\basicbreak)
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pstep(Pseq([
				[0,3,5],
				[7-12,3,10],
			],inf),4),
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 5,
			\note, Pseq([
				Pfin(6,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pdef(\basicbreak)
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ptpar([
			8,  Pdef(\basicbreak),
			0, Pbind(
				\instrument, \iGNUcius,
				\lfoFreq, 0.5,
				\lfoDepth, 1.0,
				\filterMul, Pseq([
					9,Pwhite(2.0,9,3),
				],inf),
				\resonance, 0.40000000596046,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, Pseq([
					0.9,Pwhite(0.2,1),
				],inf),
				\octave, 2,
				\note, Pseq([
					0,0,3,0, 3,3,0,0,
					0,0,5,Prand([5,10],1),0,0,6,6,
				],inf),
				\isRest, Pseq([
					1,1
				],inf).coin.not,
				\dur, 1/4,
				\amp, 0.1 * Pseq([
					1,Pwhite(0.3,1,1)
				],inf),
			),
		]),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 5,
			\note, Pseq([
				Pfin(2,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				Prand([0,7,5,3],2),
			],inf),
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			//\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \largechord,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 7,
			\note, Pseq([
				Pfin(14,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12])),
				0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \olok,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 4,
			\note, Pseq([
				Pseq([
					Prand([12,6,7],2),
					Prand([12,3,10,6,7],2),
					Prand([12,6,7],2),
					Prand([0,3,0,5,5,6],2),
					Prand([12,6,7],2),
					Prand([12,3,10,6,7],2),
					Prand([0,3,0,5,5,6],2),
					Prand([0,3,0,5,5,6],2),

				],1),
				//Pfin(30,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				//-12,\r,
			],inf),
			\isRest, Pseq([
				1,0.7,0.9,0.5
			],inf).coin.not,
			\legato, 0.8* Pseq([
				Prand([
					Pseq([ 0,0,0,0, ],1),
					Pseq([ 0,0,0,0, 0,0,0,0,],1),
					Pseq([ 8,0,0,0, 0,0,0,0, ],1),
					Pseq([ 4,0,0,0, ],1),
					Pseq([ 4,0,0,0, ],1),
					Pseq([ 2,0,2,0, ],1),
					Pseq([ 0,1,1,1, ],1),
					Pseq([ 1,1,1,0, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 1,1,1,1, ],1),
					Pseq([ 3,0,0, 3,0,0, 3,0 ],1),
					Pseq([ 1,2,0,1, ],1),
					Pseq([ 1,1,2,0, ],1),
				],1),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 or: { ev[\isRest] } }),
			\dur, 1/4,
			\amp, 0.1,
			\amp, 0.051,
		),
	])
)).play;
);

/////// bass draft
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \iGNUcius,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.9,
			\octave, 2,
			\filterMul, 5,
			\note, Pseq([
				0,0,5,5,0,0,6,6,
			],inf),
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
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				10,10,9,9,0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
	])
)).play;
);

//////////////////////
(
Pdef(\part, Pdef(\apart1intro, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,1),
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Ptpar([
			8, Pbind(
				\instrument, \Piano_rhodeySC,
				\note, Pseq([
					0,5,
				],inf),
				\dur, 1,
				\amp, 0.1/1.5,
				\out, BusDef(\sendbus3, \audio),
			),
			16, Pbind(
				\instrument, \olok,
				\note, Pseq([
					3,5,6,
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
			),
			//32, Pdef(\smoothbreak6),
			16+8, Pdef(\basicbreak),
		])
	])
)).play;
);

(
///////////////// main //////////
ProtoDef(\FxManager).play;
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(32, Pdef(\apart1intro)),
		Pfindur(32, Pdef(\apart1)),
		Pfindur(8, Pdef(\apart1break)),
		Pfindur(32, Pdef(\apart2)),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\apart1, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pseq([
				Pfin(14,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				7,10,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\out, BusDef(\sendbus2, \audio),
		),
		Pdef(\basicbreak),
		Pdef(\smoothbreak6),
	])
)).play;
);

(
Pdef(\part, Pdef(\apart1break, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				Pseq([
					1,1,1,1,
					1,0,0,0,
				],4),
				Pseq([
					1,0,0,0,
					1,0,0,1,
				],4),
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pseq([
				Pfin(14,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				7,10,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\out, BusDef(\sendbus2, \audio),
		),
		//Pdef(\basicbreak),
		//Pdef(\smoothbreak6),
	])
)).play;
);

(
Pdef(\part, Pdef(\apart2, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pstep(Pseq([
				[0,3,5],
				[7-12,3,10],
			],inf),4),
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 5,
			\note, Pseq([
				Pfin(6,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pdef(\basicbreak)
	])
)).play;
);

(
Pdef(\part, Pdef(\apart3, 
	Ppar([
		
		Pbind(
			\instrument, \iGNUcius,
			\lfoFreq, 0.5,
			\lfoDepth, 1.0,
			\filterMul, Pseq([
				9,Pwhite(2.0,9,3),
			],inf),
			\resonance, 0.40000000596046,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseq([
				0.9,Pwhite(0.2,1),
			],inf),
			\octave, 2,
			\note, Pseq([
				0,0,5,Prand([5,10],1),0,0,6,6,
			],inf),
			\isRest, Pseq([
				1,1
			],inf).coin.not,
			\note, Pseq([
				12,12,11,11,Pseq([5],4),
				//12,12,11,11,Pseq([6],4),
			],inf).stutter(4),
			\dur, 1/4,
			\amp, 0.1 * Pseq([
				1,Pwhite(0.3,1,1)
			],inf),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 6,
			\note, Pstep(Pseq([
				[0,3,5],
				[7-12,3,10],
			],inf),4),
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\octave, 5,
			\note, Pseq([
				Pfin(6,Prand([\r,\r,\r,\r,\r,0,3,5,6,7,10,\r,\r] +.x [0,12],inf)),
				0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\amp, 0.071,
			\lag, -0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		Pdef(\basicbreak),
		Ptpar([
			8, Pbind(
				\instrument, \Piano_rhodeySC,
				\note, Pseq([
					0,5,
				],inf),
				\dur, 1,
				\amp, 0.1/1.5,
				\lag, -0.04,
				\out, BusDef(\sendbus3, \audio),
			),
			16, Pbind(
				\instrument, \olok,
				\note, Pseq([
					3,5,6,
				],inf),
				\octave, 5,
				\dur, 1/8,
				\amp, 0.1,
			),
			//32, Pdef(\smoothbreak6),
			//16+8, Pdef(\basicbreak),
		])
	])
)).play;
);

///////////

(
Pdef(\melo, 
	Pbind(
		\instrument, \olok,
		\amp, 0.3,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \olok,
			\note, Pseq([
				[5,8,12,15,17].mirror1,
				[4,8,12,15,16].mirror1,
			],inf),
			\strum, 0.3,
			\lag, Pwhite(0.0,0.1,inf),
			\legato, Ptuple(Pexprand(0.1,0.9,inf)!5),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\lpfr, 1,
			\octave, 6,
			\envampt, PmodEnv(Pseq([1,8],1), 16).loop,
			\lpf, Pseg(Pseq([150,1000],inf),3),
			\pan, Pseg(Pwhite(-1,1,inf),Prand([1/4,1/2,1,2,3],inf)),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pstep(Prand([5,8,12,15,17] +.x [-12,0,12],4*4),4),
				Pstep(Prand([4,8,12,15,16] +.x [-12,0,12],4*4),1/8),
			],inf),
			\dur, 1/8,
			\amp, 0.1/4 * Pseq([
				1,0.5,0.8,0.4,
			],inf).linlin(0,1, Pseg(Pseq([0,1],inf),9),1),
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\fx1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, PmodEnv(Pwhite(0,1,inf), Pwhite(0.1,4,inf)).loop,
			\sendbus0, BusDef(\sendbus3, \audio, 2),
			\dur, 1,
		),
		
	])
)).play;
);

