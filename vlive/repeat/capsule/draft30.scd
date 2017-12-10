(
SynthDef(\fmbellz1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([0,1,2],[0.4,0.8]), 1);
	env3 = EnvGen.kr(Env([0,1,1,0],[0.4,1.2,0.08],-1), 1);
	env4 = EnvGen.kr(Env([0,1,0],[0.03,1.8]), 1);
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 2.6706 + 0.13) * \fmamp.kr(2) * env1 + 1; 
	sig2 = SinOsc.ar(freq * 0.9998 * sig1);
	sig3 = SinOsc.ar(freq * 2.6629*3 * sig1 + 2.04);
	sig4 = LFCub.ar(freq * 0.9991 * sig1 + 2.14);
	sig5 = SinOsc.ar(freq * 2.6656 * sig1 * ( sig3 * env2 * 3 + 1 ) - 2);
	sig6 = SinOsc.ar(freq * 1 * sig1* ( sig2 * env1 * 0.1 + 1 ) + 1.84);
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0,0.5,0.0, 0.5,0.5,0.5]);
	//sig.debug("sig");
	//sig = sig /34;
	sig = RHPF.ar(sig, \hpfr.kr(3.1) * freq, \hprq.kr(0.5));
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq, \lprq.kr(0.5));
	sig = sig * \gain.kr(1);
	sig = Pan2.ar(sig, pan + [ 0, -0.1, -0.1, 0.1, 0.0, 0], amp).sum;
	sig = Pan2.ar(sig4 * env3 * ( [sig2,sig4] * [env4,env2] + 1 ), Rand(0,1) * ( LFNoise1.kr(2!2) * 1 ), amp).mean + sig;
	//sig = Pan2.ar(sig3 * env3 * ( sig3 * [env4,env2] + 1 ),  ( LFNoise1.kr(2) * 1 ), amp).mean + sig;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,2.1,1,-1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\fmz1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * ((0..1)/1 - 0.5 * 0.0007 + 1);
	env1 = EnvGen.kr(Env([0,1,0.051,0],[0.001,0.01,0.8], [4,-8]), 1);
	env2 = EnvGen.kr(Env([0,1,0.051,0],[0.005,0.5,1.5], [0,-8], releaseNode:2), 1);
	env3 = EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.2], [0,0,-4], releaseNode:2), gate);
	env4 = EnvGen.kr(Env([0,1,0],[0.002,2.8], [0,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.8], [4,0,-4], releaseNode:2), gate);
	env6 = EnvGen.kr(Env([0,1,0],[0.001,3.0], [0,-4], releaseNode:1), 1);
	//freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 11 + 0) * env1; 
	sig2 = SinOsc.ar(freq * 6 * ( sig1 * 2.5 + 1 )) * env2;
	sig3 = Pulse.ar(freq * 2 * 1 + 0) * env3;
	sig4 = SinOsc.ar(freq * 1 * ( sig3 * 2.5 + 1 ) + 0) * env4;
	sig5 = SinOsc.ar(freq * 1 * ( sig2 * 0.5 + 1 ) * (sig4 * 2.5 + 1)) * env5;
	sig6 = SinOsc.ar(freq * 2* ( sig4 * 0.5 + 1 )) * env6;
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0.0, 0.3, 0.3,  0.0, 0.5, 0.5]);
	sig.debug("sig");
	sig = sig /2;
	sig = sig.flop.sum;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.001,0,1,0.01, 1,-1) ),gate,doneAction:2);
	sig = sig * AmpComp.kr(freq);
	sig.debug("sigx");
	sig = Pan2.ar(sig, pan + [ 0, -0.5, 0.5, 0, 0, 0], amp).sum;
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\critaz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4]/100+1,[0.1,0.8,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4]/100+1,[1.1,1.8,4]), 1);
	sig = SinOsc.ar(freq * 1 * ( 1 + ( SinOsc.ar(freq * env1) * env2 )));
	sig = sig + LFSaw.ar(freq *( 1 + ( SinOsc.ar(freq * env2) * env1 )) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig /4;
	Out.ar(out, sig);
}).add;
SynthDef(\critaz2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4]/100+1,[0.1,0.8,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4]/100+1,[1.1,1.8,4]), 1);
	sig = SinOsc.ar(freq * [1,8/5,6/5] * ( 1 + ( SinOsc.ar(freq * env1) * env2 ))).mean;
	sig = sig + LFSaw.ar(freq * 0.95 *( 1 + ( SinOsc.ar(freq * env2) * env1 )) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig /4;
	Out.ar(out, sig);
}).add;
SynthDef(\critaz3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mod1=0.01;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4,1/2]*mod1+1,[0.1,0.8,4,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4,1/2]*mod1+1,[1.1,1.8,4,4]), 1);
	sig = SinOsc.ar(freq* ( 1 + ( SinOsc.ar(freq * env1) * env2 )));
	sig = sig * ( 1+LFSaw.ar(freq *( 1 + ( SinOsc.ar(freq * env2) * env1 )) ) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig /4;
	Out.ar(out, sig);
}).add;
SynthDef(\critaz4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mod1=0.01;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4,1/2]*mod1+1,[0.1,0.8,4,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4,1/2]*mod1+1,[1.1,1.8,4,4]), 1);
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq * env1) * env2 )));
	sig = sig * ( 1+LFSaw.ar(freq *( 1 + ( SinOsc.ar(freq * env2) * env1 )) ) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig /4;
	Out.ar(out, sig);
}).add;
SynthDef(\critaz5, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mod1=0.01;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1,4,1/2]*10,[0.1,0.8,4,4]), 1);
	env2 = EnvGen.kr(Env([1,2,1,4,1/2]*10,[1.1,0.8,0.1,4]), 1);
	env3 = EnvGen.kr(Env([1,2,10,4,1/2],[1.1,0.8,0.1,4]), 1);
	sig = Pulse.ar(freq * [1,1.01,1.001]);
	sig = sig * ( 1+LFSaw.ar(freq *( 1 + ( SinOsc.ar(freq * [1,1.001]* env2) * env1 )) ) );
	sig = sig * ( 1+SinOsc.ar(freq *( 1 + ( SinOsc.ar(freq) * env3 )) ) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = SinOsc.ar((1..sig.size)/100) * 0.4;
	sig = Pan2.ar(sig, pan, amp);
	sig = sig.mean;
	sig = sig /2;
	Out.ar(out, sig);
}).add;
);

(
	~master.();
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
				],inf).coin.not,
				\sustain, 0.021,
				\speed, 1+Pseg(Pseq([0,1.1],inf),8),
				\lag, 0.00,
				\gain, 0.4,
				\dur, 1/32,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(\pos, Pkey(\pos)+0.01)<>
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,0,1,1,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,1,
					0,0,1,0, 0,1,0,0,
				],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/16,
				\gain, 0.1,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,0,1,
					0,0,1,0, 1,1,0,1,
					1,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.07 * Pseq([1],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.3) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.4*Pseq([
					1,
				],inf),
				\dur, 1/16,
				\gain, 0.3/2,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,
					0,0,0,
					0,0,0,
					0,0,1,
					0,0,0,
					0,0,0,
					0,0,1,
					0,0,0,
				],inf).coin.not,
				\sustain, 0.02 * Pseq([1,1/2],inf),
				\gain, 0.2/2,
				\dur, 1/24,
				\amp, 0.1,
			)),
		]),
	])
)).play;
)




(
	~master.();
Pdef(\part, Pdef(\bassfile, 
	Ppar([
		Pdef(\drums1),
		Pbind(\out, BusDef(\mixer3))<>
		Pseq([
		Pbind(
			\instrument, \fmz1,
			\note, Pseq([
				3,4,3,4,
				3,4,0,0,
			],inf),
			\legato, Pseq([
				1
			],inf)*0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.5) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 4,
			\dur, 1/4,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fmbellz1,
			\note, Pseq([
				0,0,0,0,0,0,1,-2,
			],inf),
			\legato, Pseq([
					3,0,0,3, 0,0,1,1,
			],inf)*0.8,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 4,
			\sustain, 0.1,
			\dur, 1/4,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		),
			Pfindur(32,
				Ppar([
						Pbind(
							\instrument, \fm_grain_test,
							\fratio, 1/2,
							\fratio, Pseq([1],inf),
							\note, Pseq([
								3,
								2,
							],inf).stutter(8),
							\out, BusDef(\mixer4, \audio),
							\octave, Pseq([5,5],inf).stutter(2),
							\legato, Pseq([
									0,0,0,0, 0,0,1,0,
									0,0,0,0, 0,0,1,0,
									0,0,0,0, 0,0,1,0,
									0,0,0.51,0, 0,0,1,0,

									0,0,0,0, 0,0,1,0,
									0,0.3,0,0, 0.3,0,1,0,
									0,0,0,0, 0,0,0.3,0,
									0,0,0,0, 0.3,0,1,0,

									0,0,0,0, 0,0,1,0,
									0,0,0,0, 0,0,1,0,
									0,0,0,0, 0,0,1,0,
									0,0,0.31,0, 0,0.3,1,0,

									0,0,0,0, 0,0,1,0,
									0,0,0,0, 0,0,1,0,
									0,0,0,0, 0,0,0.3,0,
									0,0,0,0, 0.3,0,1,0,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\timeScale, 0.1,
							\legato, Pkey(\legato) * [
								0.9,0.71,
							],
							\dur, 1/4,
							\amp, 0.1/16,
						),
					Pbind(
						\instrument, \perctone,
						\note, Pseq([
							Pdefn(\percnotes,
							Pseq([
								0,4,7,9,
							],1).stutter(2),
						)
						],inf),
						\legato, Pseq([

								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,

								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,
								4,0,0,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,

								0,0,2,0, 1,1,0,0,
								0,0,1,0, 0,3,0,0,
								2,0,1,0, 0,3,0,0,
								0,0,1,0, 4,0,0,0,

								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,3,0,0,
								0,0,1,0, 0,1,2,0,
								0,0,1,0, 0,3,0,0,

						],inf),
						\octave, 6,
						\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
						\dur, 1/8,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \perctone,
						\note, Pseq([
							Pdefn(\percnotes),
						],inf),
						\legato, Pseq([
								3,0,0,1, 2,0,0,0,
								1,0,1,0, 1,0,0,0,
								2,0,1,1, 2,0,0,1,
								0,0,0,0, 0,0,0,0,

								3,0,0,1, 2,0,0,0,
								0,0,0,0, 0,0,0,0,
								2,0,1,1, 2,0,0,1,
								0,0,0,0, 0,0,0,0,

						],inf),
						\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
						\dur, 1/8,
						\amp, 0.1,
					),
				]),
			),
			Pfindur(16,
					Ppar([
						Pbind(
							\instrument, \fm_grain_test,
							\fratio, 1/2,
							\fratio, Pseq([1],inf),
							\note, Pseq([
								[0,3],
								[2,4],
								[2,4],
								[9,4],
							],inf).stutter(2),
							\out, BusDef(\mixer4, \audio),
							\octave, Pseq([5,5],inf).stutter(2),
							\legato, Pseq([
									1,0,0,0, 0,0,0,0,
									4,0,0,0, 0,0,0,0,
									1,0,0,0, 2,0,0,0,
									3,0,0,3, 0,0,0,0,
									2,0,0,1, 2,0,0,0,
									4,0,0,0, 0,0,0,0,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\timeScale, 0.1,
							\legato, Pkey(\legato) * [
								0.9,0.71,
							],
							\dur, 1/4,
							\amp, 0.1/16,
						),
						Pbind(
							\instrument, \fm_grain_test,
							\fratio, 1/2,
							\fratio, Pseq([1],inf),
							\note, Pseq([
								[0,3],
								[2,4],
								[2,4],
								[9,4],
							],inf).stutter(2),
							\out, BusDef(\mixer4, \audio),
							\octave, Pseq([5,5],inf).stutter(2),
							\legato, Pseq([
									0,0,0,0, 0,0,0,0.4,
									0,0,0,0, 0,0,0.4,0,
							],inf)*0.9,
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\timeScale, 0.01,
							\legato, Pkey(\legato) * [
								0.9,0.71,
							],
							\dur, 1/4,
							\amp, 0.1/16,
						),
				Pbind( // violin
					\instrument, \playersec_fixzig_stereo,
					\instrument, \playersec_osczig_stereo,
					\instrument, Pseq([
						\playersec_osc,
						\playersec_osczig,
						\playersec_osczig_stereo,
					],inf),
					\trigfreq, 460 * 1/1 * Pseq([
						0,0,0,-1,
					],inf).midiratio,
					\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
					\pos, 0.4,
					\speed, Pseq([
						1,1.1,0.8,
					],inf),
				
					//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
					//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
					//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
					\speed, Pseq([
						4,4,4,1
					],inf).stutter(16*1),
				
					\pos, Pseq([
						~pmodsynth.({ SinOsc.kr(1/41*~t).range(0.2,1.2)+0.2 },2),
					],inf),
				
					\lpfr, 8,
					\legato, 0.5,
					\bufnum, BufDef(\table, "field/table.flac"),
					\bufnum, BufDef('loop/clean7_135bpm.flac'),
					\bufnum, BufDef('loop/loop3b_185bpm.flac'),
					\bufnum, BufDef('voices/feynman.flac'),
					\legato, Pseq([
						1,0,1,0,
					],inf)*0.3,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\freq, 200,
					\dur, 1/8,
					\gain, 30,
					\gain, 1/8,
					\amp, 0.1,
				),
					]),
			),
			Pseq([
				//Pfindur(144,PmonoArtic(\critaz5)),
				Pfindur(4,PmonoArtic(\critaz)),
				Pfindur(4,PmonoArtic(\critaz2)),
				Pfindur(4,PmonoArtic(\critaz3)),
				Pfindur(4,PmonoArtic(\critaz4)),
				Pfindur(4,PmonoArtic(\critaz5)),
			].collect({ arg pat;
				pat <> Pbind(
					\note, Pstep(Pseq([0,1,1,1],inf),1),
					\mod1, ~pmodenv.(Pseq([1/50,1/100,1,4],inf), 8),
					\legato, Pseq([
						1,1,1,1, 1,1,1,0.8,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,0.8,
					],inf),
					\dur, 1/8,
					\amp, 0.1,
				)

			}),1),
		],inf),
		
	])
)).play;
)

////////////////////////


(
	~master.();
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0, 0,0,0,  0,0,1, 0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/12,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					//0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
				],inf).coin.not,
				\sustain, 0.021,
				\speed, 1+Pseg(Pseq([0,1.1],inf),8),
				\lag, 0.00,
				\gain, 0.4,
				\dur, 1/32,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(\pos, Pkey(\pos)+0.01)<>
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,0,1,1,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,1,0,1, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,1,
					0,0,1,0, 0,1,0,0,
				],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/16,
				\gain, 0.1,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,0,1,
					0,0,1,0, 1,1,0,1,
					1,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.07 * Pseq([1],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.3) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.4*Pseq([
					1,
				],inf),
				\dur, 1/16,
				\gain, 0.3/2,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,0,
				],inf).coin.not,
				\sustain, 0.02 * Pseq([1,1/2],inf),
				\gain, 0.2/2,
				\dur, 1/24,
				\amp, 0.1,
			)),
		]),
	])
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \fmz1,
			\note, Pseq([
				0,4,3,4,
				3,4,7,7,
				2,4,3,4,
				3,4,9,9,
			],inf),
			\legato, Pseq([
				2,0,0,0, 0,0,1,0,
				2,0,0,0, 0,0,1,0,
				2,0,0,0, 0,0,1,0,
				2,0,1,0, 2,0,1,0,
			],inf)*0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.5) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 4,
			\dur, 1/16,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,4,3,4,
				3,4,7,7,
				2,4,3,4,
				3,4,9,9,
			],inf),
			\legato, Pseq([
				2,0,0,0, 0,0,1,0,
				2,0,0,0, 0,0,1,0,
				2,0,0,0, 0,0,1,0,
				2,0,1,0, 2,0,1,0,
			],inf)*0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.5) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
				],inf).coin.not,
				\sustain, 0.021,
				\speed, 1+Pseg(Pseq([0,1.1],inf),8),
				\lag, 0.00,
				\gain, 0.4,
				\dur, 1/32,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1,1,1) ],
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(\pos, Pkey(\pos)+0.01)<>
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/16,
				\gain, 0.1,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,0,1,
					0,0,1,0, 1,1,0,1,
					1,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.07 * Pseq([1],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.3) ],
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.4*Pseq([
					1,
				],inf),
				\dur, 1/16,
				\gain, 0.3/2,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,
					0,0,0,
					0,0,0,
					0,0,1,
					0,0,0,
					0,0,0,
					0,0,1,
					0,0,0,
				],inf).coin.not,
				\sustain, 0.02 * Pseq([1,1/2],inf),
				\gain, 0.2/2,
				\dur, 1/24,
				\amp, 0.1,
				\isRest, true,
			)),
		]),
	])
)).play;
)


~t = 101/2/60; TempoClock.default.tempo = ~t;
(
	~master.();
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \fmz1,
			\note, Pseq([
				0,4,3,4,
				3,4,7,7,
				2,4,3,4,
				3,4,9,9,
			],inf),
			\legato, Pseq([
				2,0,0,0, 0,0,1,0,
				2,0,0,0, 0,0,1,0,
				2,0,0,0, 0,0,1,0,
				2,0,1,0, 2,0,1,0,
			],inf)*0.8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.5) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\octave, 4,
			\dur, 1/16,
			\amp, 0.1,

		),
		Pbind(
			\instrument, \basicbass,
			\lpf, 400,
			\rq, 0.9,
			\note, Pseq([
				0,4,0,4, 3,4,7,7,
			],inf),
			\legato, Pseq([
				1,0,0,0, 1,0,1,0,
			],inf)*0.9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,1,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\hpfr, ~pmodenv.(Pseq([1,2,1/2,1/4],inf), 8),
			\out, BusDef(\mixer3, \audio),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 1,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
				],inf).coin.not,
				\sustain, 0.021,
				\speed, 1+Pseg(Pseq([0,1.1],inf),8),
				\lag, 0.00,
				\gain, 0.4,
				\dur, 1/32,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1/2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1,1,1) ],
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(\pos, Pkey(\pos)+0.01)<>
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/16,
				\gain, 0.1,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,1, 0,0,1,0,
				],inf).coin.not,
				\sustain, 0.03 * Pseq([1],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\gain, 0.4*Pseq([
					1,
				],inf),
				\dur, 1/8,
				\gain, 0.3/2,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,
					0,0,0,
					0,0,0,
					0,0,1,
					0,0,0,
					0,0,0,
					0,0,1,
					0,0,0,
				],inf).coin.not,
				\sustain, 0.02 * Pseq([1,1/2],inf),
				\gain, 0.2/2,
				\dur, 1/24,
				\amp, 0.1,
				\isRest, true,
			)),
		]),
	])
)).play;
)

/////////////////////////


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \basicbass,
			\note, Pseq([
				0,0,0, 0,0,0, 0,0,0, 0,0,0,
				2,2,2, 2,2,2, 2,2,2, 2,2,2,
			],inf),
			\lpf, 202,
			\rq, 0.9,
			\isRest, Pseq([
				1,0,0, 1,0,0,  0,0,0, 0,0,1,
				1,0,0, 1,0,0,  0,0,0, 0,0,1,
				1,1,1, 1,0,0,  0,0,0, 0,0,1,
				1,0,1, 1,1,1,  0,0,1, 1,1,1,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/12,
			\out, BusDef(\mixer3, \audio),
			\amp, 0.1,
		),
						Pbind(
							\instrument, \fm_grain_test,
							\fratio, Pseq([1],inf),
							\fratio, 1/2,
							\note, Pseq([
								2,
								2,
								2,
								6,
							],inf).stutter(12),
							\out, BusDef(\mixer4, \audio),
							\octave, Pseq([6],inf).stutter(2),
							\legato, Pseq([
								6,0,0, 0,0,0, 0,0,0, 0,0,0,
								6,0,0, 0,0,0, 0,0,0, 3,0,0,
								3,0,0, 1,0,1, 0,0,0, 0,0,0,
								6,0,0, 0,0,0, 0,0,0, 3,0,0,
							],inf),
							\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
							\timeScale, 0.1,
							\dur, 1/12,
							\amp, 0.1/16 * Pseg(Pseq([1,1,0,0.41],inf),11),
						),
						Pbind(\out, BusDef(\mixer5))<>
						Ppar([
							Pbind( // violin
								\instrument, \playersec_fixzig_stereo,
								\instrument, \playersec_osczig_stereo,
								\instrument, Pseq([
									\playersec_osc,
									\playersec_osczig,
									\playersec_osczig_stereo,
								],inf),
								\trigfreq, 400 * 1/1 * Pseq([
									0,0,0,-1,
								],inf).midiratio,
								\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
								\pos, 0.4,
								\speed, Pseq([
									1,1.1,0.8,
								],inf),
							
								//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
								//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
								//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
								//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
								\speed, Pseq([
									4,4,4,1
								],inf).stutter(16*1),
							
								\pos, Pseq([
									~pmodsynth.({ SinOsc.kr(1/41*~t).range(0.2,1.2)+0.2 },2),
								],inf),
							
								\lpfr, 8,
								\legato, 0.5,
								\bufnum, BufDef(\table, "field/table.flac"),
								\bufnum, BufDef('loop/clean7_135bpm.flac'),
								\bufnum, BufDef('loop/loop3b_185bpm.flac'),
								\bufnum, BufDef('voices/feynman.flac'),
								\legato, Pseq([
									1,0,1,0,
								],inf)*0.3,
								\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
								\freq, 200,
								\dur, 1/8,
								\gain, 30,
								\gain, 1/8,
								\gain, 1/8 * Pseg(Pseq([0,0,1,0.41],inf),10),
								\amp, 0.1,
							),
						]),
		Pbind(\out, BusDef(\mixer4))<>
		Ppar([
			Pbind(
				\instrument, \perctone,
				\degree, Pseq([
					[0,2,4],
				],inf) + Pseq([
					0,0,12,
				],inf),
				\root, Pseq([0,2],inf).stutter(12),
				\sustain, Pseq([
					0.01,
					0.01,
					0.01,
					0.04,
					0.01,
					0.01,
				],inf),
				\isRest, Pseq([
						0,0,1, 1,0,1,  0,0,0, 1,0,1,
						0,0,1, 1,0,0,  0,0,1, 1,0,0,
				],inf).coin.not,
				\dur, 1/12,
				\octave, 6,
				\amp, 0.1/4 * Pseg(Pseq([0,1,0.4],inf),7),
			),
			Pbind(
				\instrument, \perctone,
				\degree, Pseq([
					[0,2,4],
				],inf) + Pseq([
					0,0,12,
				],inf),
				\root, Pseq([0,2],inf).stutter(12),
				\sustain, Pseq([
					0.1,
				],inf),
				\isRest, Pseq([
						0,1,1, 1,1,0,  0,0,0, 0,0,0,
						0,1,1, 1,1,0,  0,0,0, 0,0,0,
						0,1,1, 1,1,1,  1,0,0, 0,0,0,
						0,1,0, 0,1,1,  1,1,1, 1,0,0,
				],inf).coin.not,
				\dur, 1/12,
				\octave, 6,
				\amp, 0.1/4 * Pseg(Pseq([0,1],inf),8),
			),
			Pbind(
				\instrument, \perctone,
				\degree, Pseq([
					[0,2,4],
				],inf) + Pseq([
					0,0,12,
				],inf),
				\root, Pseq([0,2],inf).stutter(12),
				\sustain, Pseq([
					0.1,
				],inf),
				\isRest, Pseq([
						0,1,1, 1,1,0,  0,0,0, 0,0,0,
						0,1,1, 1,1,0,  0,0,0, 0,0,0,
						0,1,1, 1,1,1,  1,0,0, 0,0,0,
						0,1,0, 0,1,1,  1,1,1, 1,0,0,
				],inf).coin.not,
				\dur, 1/12,
				\octave, 6,
				\amp, 0.1/4 * Pseg(Pseq([0,1],inf),8),
			),
			Pbind(
				\instrument, \perctone,
				\degree, Pseq([
					[0,2,4],
				],inf) + Pseq([
					0,0,12,
				],inf),
				\root, Pseq([0,2],inf).stutter(12),
				\sustain, Pseq([
					0.01,
					0.01,
					0.01,
					0.1,
					0.01,
					0.01,
				],inf),
				\isRest, Pseq([
						1,1,1, 1,1,1,  0,1,1, 1,1,1,
						0,0,0, 1,1,1,  0,1,1, 1,1,1,
						1,1,1, 1,1,1,  0,1,1, 1,1,1,
						1,1,1, 1,1,1,  0,0,0, 1,1,1,
						1,1,1, 1,1,1,  0,1,1, 1,1,1,
						1,1,1, 0,0,0,  0,1,1, 1,1,1,
				],inf).coin.not,
				\dur, 1/12,
				\octave, 5,
				\amp, 0.1/8 * Pseq([
					1,1,1, 4,1,1, 1,1,4, 1,1,1,
					4,1,3, 1,1,1, 1,1,4, 1,1,1,
				],inf),
				\isRest, true,
			),
		]),
		Pbind(
			\out, BusDef(\mixer2),
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,0, 1,0,0, 0,0,0, 1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.02) ],
			],inf),
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.1,0.01,0.01
		
			],inf),
			\dur, 1/12,
			//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.0132,
		),
		Pbind(
			\out, BusDef(\mixer2),
			\instrument, \phyhat2,
			\isRest, Pseq([
				0,0,0, 0,0,0, 1,1,1, 0,0,0,
				0,0,0, 0,0,1, 1,1,0, 0,0,0,
				0,0,0, 0,0,0, 1,0,0, 0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.02) ],
			],inf),
			\sustain, Pseq([0.08,0.02],inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.01,0.01
			],inf),
			\dur, 1/12/2,
			//\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.0132 * Pseg(Pseq([0,0.2,0,1],inf),12),
		),
		Pbind(
			\out, BusDef(\mixer0),
			\instrument, \snapkick,
			\isRest, Pseq([
		
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
			],inf).coin.not,
			\sustain, 0.01,
			\dur, 1/12,
			\amp, 0.1,
		),
				Pbind( // hi snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,1,  0,0,0, 0,0,1,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\sustain, 0.1/2,
					\dur, 1/12,
					\amp, 0.1/2,
				),
				Pbind( // low snare
					\out, BusDef(\mixer1),
					\instrument, \snaretuned,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.13) ],
					],inf),
					\isRest, Pseq([
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,1, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 0,1,0,  0,0,0, 0,0,0,
					],inf).coin.not,
					//\lag, 0.120/~t,
					\sustain, 0.1/4,
					\dur, 1/12,
					\amp, 0.1/4,
				),
		Pbind( // oscsmp bass
			\instrument, \playersec_osc,
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				2.0,1
			],inf).stutter(1),
			\trigfreq, 400 * Pseq([
				0
			],inf).midiratio,
			\pos, ~pmodsynth.({ 
				SinOsc.kr(1/20).range(0,0.01)+1.7 + Duty.kr(1/8/~t, 0, Dseq([
					0,Dwhite(0.1,0.4,1),0,0,
				],inf)) 
			}),
			\speed, 0.45,
			\legato, Pseq([
				1,0,0,0,
				1,0,0,0,
				1,0,0,0,
				1,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 0.2 * Pseg(Pseq([0,0.4,1],inf),9),
			\dur, 1/12,
		),
	])
)).play;
)
