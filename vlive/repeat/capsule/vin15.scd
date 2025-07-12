
~t = 140/4/60; TempoClock.default.tempo = ~t; // trap tempo

(
SynthDef(\bilinsim, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,2,1/2] * (\bilintab.kr({ 1.0.bilinrand }!30) * \fspread.kr(0.01) + 1);
	sig = sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\bilinenv, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, tsustain=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 =  EnvGen.kr(\mixenv.kr(Env([0,1,0.4,0],[0.01,0.8,0.8].normalizeSum)), gate, timeScale:tsustain);
	env2 =  EnvGen.kr(\fspreadenv.kr(Env([0.001,0.1,0.04,0.01],[0.01,0.8,0.8].normalizeSum)), gate, timeScale:tsustain);
	freq = freq * [1,2,1/2] * (\bilintab.kr({ 1.0.bilinrand }!20) * \fspread.kr(0.01) * env2 + 1);
	sig = sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2 * env1, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\bilinenvligth, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, tsustain=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var chan = { arg sig;
		(sig.flop.clump(2).mean.flop.debug("2") * [\oc2.kr(1),\oc3.kr(1),\oc1.kr(1)]).debug("3").mean.debug("4");
	};
	env1 =  EnvGen.kr(\mixenv.kr(Env([0,1,0.4,0],[0.01,0.8,0.8].normalizeSum)), gate, timeScale:tsustain);
	env2 =  EnvGen.kr(\fspreadenv.kr(Env([0.001,0.1,0.04,0.01],[0.01,0.8,0.8].normalizeSum)), gate, timeScale:tsustain);
	freq = freq * [1,2,1/2] *.t (\bilintab.kr({ 1.0.bilinrand }!20) * \fspread.kr(0.01) * env2 + 1);
	freq.debug("xx");
	
	sig = sig1 = chan.(LFSaw.ar(freq));
	sig2 = chan.(LFPulse.ar(freq));
	sig3 = chan.(SinOsc.ar(freq));
	sig = SelectX.ar(\oscmix.kr(0.5)*2 * env1, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	//sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

ProtoDef(\simpleMixer).edit

////////////////////
(
ProtoDef(\simpleMixer).play;
ProtoDef(\rdn).play;
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,
				],inf),
				\octave, 3,
				\legato, Pseq([
					Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf),
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,2,0,
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,1,0,
				],inf)*0.9,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4,1,-2) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bus1, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0012099467303085,
				'delay', 0.000600001231 * Pseq([
					Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,2,1/3,100,1000,
					],1) * 0.234,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,2,1/3,100,1000,
				],inf).stutter(1),
				'delay2', 0.001000543560101,
				'distamp', 41.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1153].value,
					\isRest, (Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf)* Pseq([
						1,1,0,1,
					],inf).stutter(8*4)).coin.not ,
					\dur, 1/8,
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1960].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[849].value,
					\isRest, Pseq([
						Pseq([
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
						],inf),
					],inf).coin.not,

					\dur, 1/16,
					\gain, 0.31 * Pseq([
						1/8,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),
					\isRest, true,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[846].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
							],1),
						],1),
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.31,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[848].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf),
						0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.01,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]+1,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
			]),


		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,-1,-1,-1,
				],inf),
				\octave, 3,
				\legato, Pseq([
					Pseq([
						1,0,1,1, 0,0,0,0,
						0,1,0,1, 0,0,0,0,
						1,0,0,0, 0,1,1,1,
						0,0,0,0, 0,0,1,0,
					],inf),
					Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf),
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,2,0,
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,1,0,
				],inf)*0.9,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4,1,-2) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bus1, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0012099467303085,
				'delay', 0.000600001231 * Pseq([
					Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,2,1/3,100,1000,
					],1) * 0.234,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,2,1/3,100,1000,
				],inf).stutter(1),
				'delay2', 0.001000543560101,
				'distamp', 41.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1153].value,
					\isRest, (Pseq([
						Pseq([
							1,0,1/2,1/2, 0,0,0,0,
							0,1,0,1, 0,0,0,0,
							1,0,0,0, 0,1/2,1/2,1/2,
							0,0,0,0, 0,0,1,0,
						],inf),
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf)* Pseq([
						1,1,0,1,
					],inf).stutter(8*4)).coin.not ,
					\dur, 1/8,
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1960].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[849].value,
					\isRest, Pseq([
						Pseq([
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
						],inf),
					],inf).coin.not,

					\dur, 1/16,
					\gain, 0.31 * Pseq([
						1/8,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),
					\isRest, true,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[846].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
							],1),
						],1),
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.31,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[848].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf),
						0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.01,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]+1,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
			]),


		])
	)).play;
);

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					0,-1,-1,-1,
				],inf),
				\octave, 3,
				\legato, Pseq([
					Pseq([
						1,0,1,1, 0,0,0,0,
						0,1,0,1, 0,0,0,0,
						1,0,0,0, 0,1,1,1,
						0,0,0,0, 0,0,1,0,
					],inf),
					Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf),
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,2,0,
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,1,0,
				],inf)*0.9,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4,1,-2) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bus1, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0012099467303085,
				'delay', 0.000600001231 * Pseq([
					Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,2,1/3,100,1000,
					],1) * 0.234,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,2,1/3,100,1000,
				],inf).stutter(1),
				'delay2', 0.001000543560101,
				'distamp', 41.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1153].value,
					\isRest, (Pseq([
						Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,1,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,1,0,
						],inf),
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf)* Pseq([
						1,1,0,1,
					],inf).stutter(8*4)).coin.not ,
					\dur, 1/8,
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1960].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[849].value,
					\isRest, Pseq([
						Pseq([
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
						],inf),
					],inf).coin.not,

					\dur, 1/16,
					\gain, 0.31 * Pseq([
						1/8,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),
					\isRest, true,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[846].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
							],1),
						],1),
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.31,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
					\isRest, true,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[848].value,
					\isRest, Pseq([
						Pseq([
							1,0,0,0,
						],inf),
						Prand([
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf),
						0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.01,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]+1,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
			]),


		])
	)).play;
);

(
	// angry bass
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					7,0,-1,0,
				],inf).stutter(4),
				\lpf, 7000,
				\octave, 3,
				\legato, Pseq([
					Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf),
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,2,0,
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,1,0,
				],inf)*0.9,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4,1,-2) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bus1, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0012099467303085,
				'delay', 0.000600001231 * Pseq([
					Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,2,1/3,100,1000,
					],1) * 0.0234,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,2,1/3,100,1000,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 41.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1153].value,
					\isRest, (Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf)* Pseq([
						1,1,0,1,
					],inf).stutter(8*4)).coin.not ,
					\dur, 1/8,
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1960].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[849].value,
					\isRest, Pseq([
						Pseq([
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
						],inf),
					],inf).coin.not,

					\dur, 1/16,
					\gain, 0.31 * Pseq([
						1/8,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),
					\isRest, true,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[846].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
							],1),
						],1),
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.31,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[848].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf),
						0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.01,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]+1,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
			]),


		])
	)).play;
);

(
	// long bass
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					7,0,-1,0,
				],inf).stutter(8),
				\lpf, 7000,
				\octave, 3,
				\legato, Pseq([
					Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf),
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,2,0,
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,1,0,
				],inf)*0.9,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4,1,-2) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bus1, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0012099467303085,
				'delay', 0.000600001231 * Pseq([
					Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,2,1/3,100,1000,
					],1) * 0.0234,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,2,1/3,100,1000,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 41.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1153].value,
					\isRest, (Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf)* Pseq([
						1,1,0,1,
					],inf).stutter(8*4)).coin.not ,
					\dur, 1/8,
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1960].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[849].value,
					\isRest, Pseq([
						Pseq([
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
						],inf),
					],inf).coin.not,

					\dur, 1/16,
					\gain, 0.31 * Pseq([
						1/8,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),
					\isRest, true,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[846].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
							],1),
						],1),
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.31,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[848].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf),
						0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.01,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]+1,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
			]),


		])
	)).play;
);

(
	// long bass, calm bass fb 
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					7,0,-1,0,
				],inf).stutter(8),
				\lpf, 7000,
				\octave, 3,
				\legato, Pseq([
					Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf),
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,2,0,
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,1,0,
				],inf)*0.9,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4,1,-2) ],
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bus1, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0012099467303085,
				'delay', 0.000600001231 * Pseq([
					Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,2,1/3,100,1000,
					],1) * 0.0234,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,2,1/3,100,1000,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 01.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1153].value,
					\isRest, (Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf)* Pseq([
						1,1,0,1,
					],inf).stutter(8*4)).coin.not ,
					\dur, 1/8,
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1960].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[849].value,
					\isRest, Pseq([
						Pseq([
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
						],inf),
					],inf).coin.not,

					\dur, 1/16,
					\gain, 0.31 * Pseq([
						1/8,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),
					\isRest, true,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[846].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
							],1),
						],1),
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.31,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[848].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf),
						0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.01,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]+1,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
			]),


		])
	)).play;
);

(
	// calm hat other bass
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					7,7,6,6,
					-1,-1,-2,-1,
				],inf).stutter(8),
				\lpf, 7000,
				\octave, 3,
				\legato, Pseq([
					Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf),
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,2,0,
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,1,0,
				],inf)*0.9,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.4,1,-8) ],
					[ Env.adsr(0.01,0.1,0.8,0.1,1,-8) ],
					[ Env.adsr(0.01,0.1,0.8,0.5,1,0) ],
				],inf).stutter(2),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bus1, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0072099467303085,
				'delay', 0.000600001231 * Pseq([
					Pseq([
						1,1,1,1100,
						1,1,100,1,
						1,100,1,100,
						1,2,1/3,100,1,
					],6) * 0.0734,
					Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,2,1/3,100,1000,
					],1) * 0.0234,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,2,1/3,100,1000,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 101.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1153].value,
					\isRest, (Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf)* Pseq([
						1,1,0,1,
					],inf).stutter(8*4)).coin.not ,
					\dur, 1/8,
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1960].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[849].value,
					\isRest, Pseq([
						Pseq([
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
						],inf),
					],inf).coin.not,

					\dur, 1/16,
					\gain, 0.31 * Pseq([
						1/8,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),
					\isRest, true,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[846].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ]*0,1),
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ]*0,1),
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ]*0,1),
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
							],1),
						],1),
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.31,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[848].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]*0,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf),
						0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.01,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]+1,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
			]),


		])
	)).play;
);

(
	// calm hat other bass
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pseq([
					7,7,6,6,
					-1,-1,-2,-1,
				],inf).stutter(8),
				\lpf, 7000,
				\octave, 3,
				\legato, Pseq([
					Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf),
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,2,0,
					6,0,0,0, 0,0,6,0,
					0,0,2,0, 0,0,1,0,
				],inf)*0.9,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.4,1,-8) ],
					[ Env.adsr(0.01,0.1,0.8,0.1,1,-8) ],
					[ Env.adsr(0.01,0.1,0.8,0.5,1,0) ],
				],inf).stutter(2),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
				\out, BusDef(\bus1, \audio),
			),
			Pmono( \rdncleandist_fulllight,
				\inbus, BusDef(\bus1, \audio, 2),
				\addAction, \addToTail,
				'mix', 0.75714285714286,
				'gain', 0.7344889782792,
				'fb', 0.0072099467303085,
				'delay', 0.000600001231 * Pseq([
					Pseq([
						1,1,1,1100,
						1,1,100,1,
						1,100,1,100,
						1,2,1/3,100,1,
					],6) * 0.0734,
					Pseq([
						1,1,1,1,
						1,1,1,1,
						1,1,1,1,
						1,2,1/3,100,1000,
					],1) * 0.0234,
					1,1,1,1,
					1,1,1,1,
					1,1,1,1,
					1,2,1/3,100,1000,
				],inf).stutter(1),
				'delay2', 0.000000543560101,
				'distamp', 101.361836201538,
				'prelpf', 19900,
				'prehpf', 17,
				'lpf', 19900,
				'hpf', 17,
				'fbdistamp', 4.5388371966577,
				'fbdistmix', 0.98176470588235,
				'postlpf', 19900,
				'posthpf', 17,
				\bpmix, 0,
				'wetamp', 0.20503372119697,
				'indelay', 0.04,
				\dur, 1/8,
				\out, BusDef(\sendbus1, \audio),
			),
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1153].value,
					\isRest, (Pseq([
						1,0,0,0, 0,0,0,0,
					],inf)* Pseq([
						1,1,0,1,
					],inf).stutter(8*4)).coin.not ,
					\dur, 1/8,
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\bufnum, ~buflib.kick[1152].value,
					\isRest, (Pseq([
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf).stutter(4)* Pseq([
						1,1,0,1,
					],inf).stutter(8*4)).coin.not ,
					\dur, 1/16,
					\gain, 0.3,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1959].value,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,1/6,
						0,1/6,0,0, 0,0,0,0,
						0,1/2,1/3,1/3, 1/2,1/3,1/2,1/3,
						0,0,1,0, 0,1,0,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1960].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.61,
				),
				Pbind(
					\instrument, \playersec,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[849].value,
					\isRest, Pseq([
						Pseq([
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
						],inf),
					],inf).coin.not,

					\dur, 1/16,
					\gain, 0.31 * Pseq([
						1/8,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1,
					],inf),
					\isRest, true,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[846].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ]*0,1),
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ]*0,1),
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ]*0,1),
							Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
							Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,1,0,1, 0,1,0,0, 0,0,1,0, 1,0,1,0,
							],1),
							Pseq([
								1,0,0,1, 0,0,1,0, 0,1,1,1, 0,0,1,0,
							],1),
							Pseq([
								0,0,1,0, 0,1,0,1, 0,0,1,1, 0,1,0,0,
							],1),
						],1),
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.31,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[848].value,
					\isRest, Pseq([
						Prand([
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]*0,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf),
						0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.01,
					\gain, 0.15,
					\gain, Pkey(\gain) * Pseq([
						Prand([
							Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
							Pseq([ 1,1,0,1, 1,0,1,0, ],1),
							Pseq([ 1,1,0,1, 1,0,1,0, ]+1,1),
							Pseq([ 1,0,1,1, 0,1,1,0, ],1),
							Pseq([ 1,1,0,1, 0,1,1,0, ],1),
						],inf) + 0.7 / 1.7,
					],1),
				),
			]),

	Pbind(
		\instrument, \bilinsim,
		\fspread, 0.001,
		\oscmix, Ptuple(Pwhite(0,1.0,inf)!4).stutter(4),
		\octave, Ptuple(Prand([5,6,7],inf)!4).stutter(8),
		\legato, 0.4,
		\dur, 1/8,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,2.1) ],
		],inf),
				\note, Pseq([
					[4, 7, 11, 13],
					[5, 10, 13, 9],
				],inf).stutter(8),
		\amp, 0.1,
		\legato, Pseq([
			7,0,0,0, 0,0,0,0,
			6,0,0,0, 0,0,0,1,
			3,0,0,3, 0,0,0,0,
			6,0,0,0, 0,0,1,0,

			7,0,0,0, 0,0,0,0,
			3,0,0,3, 0,0,2,0,
			7,0,0,0, 0,0,0,0,
			7,0,0,0, 0,0,0,1,

		],inf),
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\out, BusDef(\sendbus3, \audio),
		//\lag, 0.08,
	)

		])
	)).play;
);


ClipTimeline(\vin15).edit

(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('voices/wuhan.flac'),
				\pos, 4,
				\dur, 2,
				\isRest, Pseq([
					1,0,
				],inf).coin.not,
				\out, BusDef(\sendbus3, \audio),
				\gain, 1,
			)

		])
	)).play;
);


(
	Pdef(\part, Pdef(\zed, 
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31,
				\out, BusDef(\sendbus3, \audio),
			),

		])
	)).play;
);


(
Pdef(\melo, 
	Pbind(
		\instrument, \bilinenv,
		\mixenv, Pseq([
			[Env([0,1,0.4,0],[0.01,0.8,0.8].normalizeSum)  ]
		],inf),
		\out, BusDef(\sendbus3, \audio),
		\tsustain, 2,
		\fspread, 0.01,
		\oscmix, 0.9,
		\dur, 1,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,2.1) ],
		],inf),
		\amp, 0.1,
	)
);
ProtoDef(\piano).startControl(Pdef(\melo));
);



(
Pdef(\demo, Pdef(\demox, 
	Ppar([
		Pbind(
			\instrument, \bilin,
			\note, Pseq([
				[0,3,7],
				[0,3,7]+4,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		Pbind(
			\instrument, \bilinenvligth,
			\octave, Pseq([
				4,5,6, 4,5,6, 4,5,
				4,5,6, 4,5, 4,5,6,
				4,5, 4,5,6, 4,5,6,
			],inf).stutter(8),
			\octave, 5,
			\oc1, Pseg(Pseq([0,1],inf),30),
			\oc2, Pseg(Pseq([1,0,1],inf),21),
			\oc3, Pseg(Pseq([0,1],inf),29),
			\note, Pseq([
				0,1,0,-1,
				0,1,0,-1,
			],inf).stutter(1),
			\oscmix, Pseg(Pseq([0,0.5,0.2,1],inf),18),
			\dur, 1/16,
			\amp, 0.1 * Pseq([
				Ppatlace(
					[
					Pseg(Pseq([1,0.1,1],inf),7).asStream,
					Pseg(Pseq([0.1,0.5,0.1],inf),8).asStream,
					]
				)
			],inf),
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);

ProtoDef(\simpleMixer).tracks[0].outbus
