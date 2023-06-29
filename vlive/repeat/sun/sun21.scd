
/// make a parametrized framework that generate a whole loop
~t = 1; TempoClock.default.tempo = ~t;


(
	// synthdefs in sun20.scd
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			var packs = List.new;
			packs.addAll(
				10.collect { arg item, idx;
					(
						instrument: [
							\tredrone,
							//\default,
							\chordb,
							\chordc,
							\chordo,
							\kopchord_simple,
							\kopchord,
						].choose,
						//freq: exprand(50,1000.0),
						degree: Pseq([
							rrand(0,7*4)-(7*2),
						],inf),
						dur: rrand(1/16,2).round(1/16),
						restpat: rrand(0,7),
						restpat_drums: rrand(0,7),
						restpat_drums2: rrand(0,7),
						legato: rrand(0.1,1.2),
						amp: rrand(0.01,0.1),
						kick1: ~buflib.kick.size.rand.debug("k"),
						kick1mute: [true,false].choose,
						snare1: ~buflib.snare.size.rand.debug("s"),
						snare1mute: [true,true,false].choose,
						melotype: [\mono, \melo].choose,
					)
				};
			);
			packs.debug("packs");
			packs.do { arg pack, idx;
				sp.par(
					switch(pack.melotype,
						\mono, { Pbind() },
						\melo, { Pbind(\degree, Pseq([0,2],inf) + pack.degree) },
					) <>
					Pbind(
						\isRest, Pseq([
							Plazy({ arg ev;
								var res = [
									1,1,1,1, 0,0,0,0,
									0,0,0,0, 1,1,1,1,
									1,0,0,0, 0,0,0,0,
									1,0,0,0, 1,0,0,0,
									1,0,1,0, 1,0,1,0,
									0,0,0,0, 0,0,0,1,
									1,1,1,1, 1,1,1,1,
									1,1,0,0, 1,1,0,0,
								].clump(8)[ev[\restpat]];
								Pseq(res)
							}).loop,
						],inf).coin.not,
					)<>
					Pbind(*pack.asKeyValuePairs)
				);
				sp.par(
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.kick[1010].value,
						\bufnum, ~buflib.kick[pack.kick1].value,
						\isRest, if(pack.kick1mute) { true } {
							Pseq([
								Plazy({ arg ev;
									var res = [
										1,1,1,1, 0,0,0,0,
										0,0,0,0, 1,1,1,1,
										1,0,0,0, 0,0,0,0,
										1,0,0,0, 1,0,0,0,
										1,0,1,0, 1,0,1,0,
										0,0,0,0, 0,0,0,1,
										1,1,1,1, 1,1,1,1,
										1,1,0,0, 1,1,0,0,
									].clump(8)[ev[\restpat_drums]];
									Pseq(res);
								}).loop,
							],inf).coin.not
						},
						\gain, 0.1/2,
					)<>
					Pbind(*pack.asKeyValuePairs)
				);
				sp.par(
					Pbind(
						\instrument, \playersec,
						\bufnum, ~buflib.snare[pack.snare1].value,
						\isRest, if(pack.snare1mute) { true } {
							Pseq([
								Plazy({ arg ev;
									var res = [
										1,1,1,1, 0,0,0,0,
										0,0,0,0, 1,1,1,1,
										1,0,0,0, 0,0,0,0,
										1,0,0,0, 1,0,0,0,
										1,0,1,0, 1,0,1,0,
										0,0,0,0, 0,0,0,1,
										1,1,1,1, 1,1,1,1,
										1,1,0,0, 1,1,0,0,
									].clump(8)[ev[\restpat_drums2]];
									Pseq(res);
								}).loop,
							],inf).coin.not
						},
						\gain, 0.1/2,
					)<>
					Pbind(*pack.asKeyValuePairs)
				)
			};
		}),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(Plazy({ arg ev;
			Pbind(
				\instrument, \default,
				\freq, exprand(50,2000.0),
				\dur, 1/64,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				].scramble,inf).coin.not,
				\amp, 0.1,
			);
		}).loop ! 10),
		
	])
)).play;
);

(
SynthDef(\starshort, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	var ts = \timeScale.kr(1);
	env1 = EnvGen.kr(Env([1,2,1],[1.7,0.8]), 1, timeScale:ts);
	fspread = 0.0007 + Rand(0,0.007);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig1 = sig * (sig.abs > Rand(0.1,0.7));
	sig = SelectX.ar( EnvGen.kr(Env([0,1,0],[0.1+Rand(0,2.0),0.1+Rand(0,2.0)]), 1, timeScale:ts), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(Plazy({ arg ev;
			Pbind(
				\instrument, \starshort,
				\timeScale, Pseg(Pseq([0.1,1],inf),rrand(1.0,8)),
				\chord, [[0,1,2,3,4,5,6] +.x ( (0..3)*12 )],
				\scale, Scale.minor,
				\octave, 3,
				\degree, Pseq([
					Plazy({ arg ev;
						var tab = {ev[\chord][0].choose}.dup(8);
						Pseq([
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),

							Pseq([tab[0]],128),
							Pseq([tab[1]],128),
							Pseq([tab[0]],128),
							Pseq([tab[2]],128),
						],1);
					}).loop,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.3) ],
				],inf),
				\mtranspose, Pseq([0,3,0,3,0,3,3s,4],inf).stutter(128), 
				\dur, 1/64,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				].scramble,inf).coin.not,
				\amp, 0.2,
			);
		}).loop ! 20),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(Plazy({ arg ev;
			Pbind(
				\instrument, \starshort,
				\timeScale, Pseg(Pseq([0.1,1],inf),rrand(1.0,8)),
				\chord, [[0,0,0,1,2,2,2,3,4,4,4,5,6] +.x ( (0..3)*12 )],
				\scale, Scale.major,
				\octave, 3,
				\degree, Pseq([
					Plazy({ arg ev;
						var tab = {ev[\chord][0].choose}.dup(8);
						Pseq([
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),

							Pseq([tab[0]],128),
							Pseq([tab[1]],128),
							Pseq([tab[0]],128),
							Pseq([tab[2]],128),

							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[2]],128),

							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[1]],128),
							Pseq([tab[2]],128),
						],2);
					}).loop,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.3) ],
				],inf),
				\mtranspose, Pseq([0,3,0,3,0,3,1,4],inf).stutter(128), 
				\dur, 1/64,
				\isRest, Pseq([
					Pseq([
						Pser([0],8)
					],rrand(0,32*4)),
					Pseq([
						Pseq([
							Pser([0],8)
						],rrand(0,32)),
						Pseq([
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						].scramble,rrand(1,4))
					],inf),
				],inf).coin.not,
				\amp, 0.2,
			);
		}).loop ! 20),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Ppar(Plazy({ arg ev;
			Pbind(
				\instrument, \starshort,
				\timeScale, Pseg(Pseq([0.1,1],inf),rrand(1.0,8)),
				\chord, [[0,0,0,1,2,2,2,3,4,4,4,5,6] +.x ( (0..2)*12 )],
				\scale, Scale.major,
				\octave, 3,
				\degree, Pseq([
					Plazy({ arg ev;
						var tab = {ev[\chord][0].choose}.dup(8);
						Pseq([
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),

							Pseq([tab[0]],128),
							Pseq([tab[1]],128),
							Pseq([tab[0]],128),
							Pseq([tab[2]],128),

							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[2]],128),

							Pseq([tab[0]],128),
							Pseq([tab[0]],128),
							Pseq([tab[1]],128),
							Pseq([tab[2]],128),
						],2);
					}).loop,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.3) ],
				],inf),
				\mtranspose, Pstep(Pseq([0,3,0,3,0,3,1,4],inf),4), 
				\dur, 2/((1..32)*2).choose,
				\dur, 2/(2**(1..7)).choose,
				\isRest, Pseq([
					Pseq([
						Pser([0],8)
					],rrand(0,32)),
					Pseq([
						Pseq([
							Pser([0],8)
						],rrand(0,32)),
						Pfin(16*(1..4).choose,
							 Pseq([
								1,0,0,0, 0,0,0,0,
								1,0,0,0, 1,0,0,0,
								1,1,0,0, 1,1,0,0,
								1,0,1,0, 1,0,1,0,
								0,0,0,0, 1,1,1,1,
							].clump(8).choose.rotate(rrand(0,4)))
						)
					],inf),
				],inf).coin.not,
				\amp, 0.2,
				\out, BusDef(\mixer0, \audio),
			);
		}).loop ! 20),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(Plazy({ arg ev;
			Pseq([

				Pbind(
					\instrument, \default,
					\freq, exprand(50.0,1000),
					\dur, 1/64,
					\isRest, Pseq([
						Pseq([
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						].scramble,3).coin.not,
						Pseq([
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						].scramble,1).coin.not,
					],3),
					\amp, 0.1,
				),
				Pbind(
					\instrument, \default,
					\freq, exprand(50.0,1000),
					\dur, 1/64,
					\isRest, Pseq([
						Pseq([
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						].scramble,3).coin.not,
						Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						].scramble,1).coin.not,
					],1),
					\amp, 0.1,
				),
			],1);
		}).loop ! 10),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\strange1, 
	Ppar([
		Ppar(Plazy({ arg ev;
			var freq2;
			var freq1 = exprand(50.0,6000);
			freq2 = Pseq([freq1, exprand(50.0,6000)],inf);

			Pseq([

				Pbind(
					\instrument, [\kopchord, \kopchord_simple,\chordb].choose,
					\freq, freq1,
					\dur, 1/64,
					\legato, rrand(1/2,4),
					\isRest, Pseq([
						Pseq([
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						].scramble,3).coin.not,
						Pseq([
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						].scramble,1).coin.not,
					],1),
					\amp, 0.1,
				),
				Pbind(
					\instrument, [\kopchord, \kopchord_simple,\chordb].choose,
					\freq, freq2,
					\dur, 1/64,
					\legato, rrand(1/2,4),
					\isRest, Pseq([
						Pseq([
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						].scramble,3).coin.not,
						Pseq([
							1,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,0,
						].scramble,1).coin.not,
					],1),
					\amp, 0.1,
				),
			],1);
		}).loop ! 10),
		
	])
)).play;
);


{ SinOsc.ar(500) ! 2 * 0.1}.play;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseries(0,1/8,32),
				Pseries(0,1/8,4),
				Pseries(4/8,1/8,4),
				Pseries(0,1/8,4),
				Pseries(0,1/8,2),
				Pseries(0,1/8,2),
				Pseries(1/2,1/8,8),
			],inf) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\strange1),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 0.8 * ~t / Pkey(\st),
			\pos, Pseq([
				//Pseries(0,1/8,32),
				Pseries(0,1/32,32),
				Pseries(0,1/32,32),
				Pseries(0,1/32,32),
				Pseries(1,1/32,32),

				Pseries(0,1/32,32),
				Pseries(0/32,1/32,2).repeat(4),
				Pseries(8/32,1/32,24),
				Pseries(0,1/32,32),
				Pseries(0,1/32,24),
				Pseries(1/2,1/32,8),

				Pseries(0,1/32,32),
				Pseries(0,1/32,32),
				Pseries(0,1/32,32),
				Pseries(0,1/32,32/4).repeat(4),

				//Pseries(12/16,1/16,4).repeat(4),
				//Pseries(12/16,1/16,4).repeat(4),
			],inf) / Pkey(\st),
			\dur, 1/16,
			\gain, 1/8,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1423].value,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0, 
				0,0,1,0, 0,1,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				Plazy({ arg ev;
					Pseq([
						0.1,0.1,0.4,1,
					],1).stutter(rrand(1,8));
				}).loop,
			],inf),
			\gain, 0.11 * Pseq([
				Plazy({ arg ev;
					Pseq([
						1,0.5,0.7,Pwhite(0.1,1,4),0.3,
					],1).stutter(rrand(1,8));
				}).loop,
				
			],inf),
			\lag, 0.04,
			//\out, BusDef(\ifx1, \audio),
		),
		Pmono(\rdncooldrum,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.7436974789916,
			'gain', 0.46638655462185,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', 0.0001,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.2006878167665,
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
		)
	])
)).play;
);

~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

	SynthDef(\rdncooldrum, { arg out=0, gate=1;
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
		thisThread.randSeed = 443996.0;
		si = sig;
		sig = { arg si, env;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
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
		'mix', 0.7436974789916,
		'gain', 0.46638655462185,
		'fb', 0.0001,
		'delay', 0.0001,
		'delay2', 0.0001,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 0.2006878167665,
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
	)


);


//////////
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
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \freecordeenv,
			\note, Pseq([
				0,4,2,1,
			],inf),
			\timeScale, 0.1,
			\octave, 6,
			\fmr, 2.01,
			\amr, 1,
			\fspread, Pwhite(0.001,0.05),
			\fmamp, Pseq([0.2,0.4,0.7],inf),
			\amamp, 0.3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	// harmonic chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \freecordeenv,
			//\note, Pseq([
				////Prand([0,4,7,0,4,7,9,11] +.x ( (0..2)*12 )),
				//Prand([0,4,7,0,4,7] +.x ( (0..2)*12 )),
				////[0,4,7,9],
			//],inf),
			\degree, Pseq([
				Prand([0,2,4,5,6] +.x ( (0..2)*7 )),
			],inf),
			\octave, 3,
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\adsr, Prand([
				[ Env.adsr(1.1,0.1,0.8,2.1) ],
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\amampenv, Prand([
				[ Env([1,0.1,0],[0.1,2.8]) ],
				[ Env([0,0.1,1],[0.1,2.8]) ],
			],inf),
			\fmampenv, Prand([
				[ Env([1,0.1,0],[0.1,2.8]) ],
				[ Env([0,0.1,1],[0.1,2.8]) ],
			],inf),
			\fmr, 1,
			\fmr, Prand([1/2,1,2] +.x [0,0.051,0.01],inf),
			\fspread, 0.01,
			\amr, Prand([1,1/2] +.x [0,0.051,0.01],inf),
			\amamp, 0.4,
			\fmamp, 0.2,
			\sustain, Prand([2,3,4,5],inf)/~t,
			\dur, Pwhite(0.6,4),
			\amp, 0.1 * Pwhite(0.1,1,inf),
		)!2,
		Pbind(
			\instrument, \freecordeenv,
			//\note, Pseq([
				////Prand([0,4,7,0,4,7,9,11] +.x ( (0..2)*12 )),
				//Prand([0,4,7,0,4,7] +.x ( (0..2)*12 )),
				////[0,4,7,9],
			//],inf),
			\degree, Pseq([
				[0,2,4],
				//Prand([0,2,4] +.x ( (0..2)*12 )),
			],inf),
			\octave, 5,
			\fspread, ~pmodenv.(Pseq([0.001,0.1],1), Pwhite(1.0,12)).loop,
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\amr, 1,
			\adsr, Prand([
				//[ Env.adsr(1.1,0.1,0.8,2.1) ],
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
				//[ Env.adsr(0.1,0.1,0.8,2.1) ],
				//[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmr, Ptuple(Prand([1/2,1,2,1] +.x [0,0.051,0.01],inf)!3),
			\fmamp, 0.2,
			\amampenv, Pseq([
				[ Env([1,0.1,0],[0.1,0.8]) ],
			],inf),
			\fspread, 0.01,
			\amamp, 0.4,
			\sustain, 3/~t,
			\dur, 4,
			\amp, 0.1,
		)!1,
		
	].flat)
)).play;
);

(
	// harmonic chords + fx
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \freecordeenv,
			//\note, Pseq([
				////Prand([0,4,7,0,4,7,9,11] +.x ( (0..2)*12 )),
				//Prand([0,4,7,0,4,7] +.x ( (0..2)*12 )),
				////[0,4,7,9],
			//],inf),
			\degree, Pseq([
				Prand([0,2,4,5,6] +.x ( (0..2)*7 )),
			],inf),
			\octave, 3,
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\adsr, Prand([
				[ Env.adsr(1.1,0.1,0.8,2.1) ],
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\amampenv, Prand([
				[ Env([1,0.1,0],[0.1,2.8]) ],
				[ Env([0,0.1,1],[0.1,2.8]) ],
			],inf),
			\fmampenv, Prand([
				[ Env([1,0.1,0],[0.1,2.8]) ],
				[ Env([0,0.1,1],[0.1,2.8]) ],
			],inf),
			\fmr, 1,
			\fmr, Prand([1/2,1,2] +.x [0,0.051,0.01],inf),
			\fspread, 0.01,
			\amr, Prand([1,1/2] +.x [0,0.051,0.01],inf),
			\amamp, 0.4,
			\fmamp, 0.2,
			\sustain, Prand([2,3,4,5],inf)/~t,
			\dur, Pwhite(0.6,4),
			\amp, 0.1 * Pwhite(0.1,1,inf),
			\out, BusDef(\sendbus1, \audio),
		)!2,
		Pbind(
			\instrument, \freecordeenv,
			//\note, Pseq([
				////Prand([0,4,7,0,4,7,9,11] +.x ( (0..2)*12 )),
				//Prand([0,4,7,0,4,7] +.x ( (0..2)*12 )),
				////[0,4,7,9],
			//],inf),
			\degree, Pseq([
				[0,2,4] + {[0,7,-7].choose}.dup(3),
				//Prand([0,2,4] +.x ( (0..2)*12 )),
			],inf),
			\octave, 5,
			\fspread, ~pmodenv.(Pseq([0.001,0.1],1), Pwhite(1.0,12)).loop,
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\amr, 1,
			\adsr, Prand([
				//[ Env.adsr(1.1,0.1,0.8,2.1) ],
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
				//[ Env.adsr(0.1,0.1,0.8,2.1) ],
				//[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmr, Ptuple(Prand([1/2,1,2,1] +.x [0,0.051,0.01],inf)!3),
			\fmamp, 0.2,
			\amampenv, Pseq([
				[ Env([1,0.1,0],[0.1,0.8]) ],
			],inf),
			\fspread, 0.01,
			\amamp, 0.4,
			\sustain, 3/~t,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		)!1,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[420].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[344].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\pos, Pwhite(0,0.1)+0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/4,
			\gain, 1/2,
			\out, BusDef(\sendbus2, \audio),
		)
		
	].flat)
)).play;
);

NoteTimeline(\bla).edit

(
	// harmonic chords + fx delayrytm
	ProtoDef(\rdn).play;
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pluckym,
			\fspread, 0.001 * Pseg(Pseq([1,10],inf),8),
			\legato, 0.2,
			\legato, Pseq([
				Pswitch1(
					[
						Pseg(Pseq([0.01,8],inf),9),
						Pseg(Pseq([0.01,0.2],inf),7),
						Pseg(Pseq([8,0.01],inf),10),
						Pseg(Pseq([0.01,8],inf),11),
						Pseg(Pseq([0,0.2],inf),12),
						Pseg(Pseq([1,0.01],inf),13),
					], 
					Pseq([0,1,2,3,4,5],inf)
				),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0.05 }),
			\envfamt, Pswitch1(
					[
						Pseg(Pseq([0.01,1],inf),8.3),
						Pseg(Pseq([0,0.2],inf),6.1),
						Pseg(Pseq([1,0.01],inf),9.2),
						Pseg(Pseq([0.01,1],inf),9.1),
						Pseg(Pseq([0,0.2],inf),8.1),
						Pseg(Pseq([1,0.01],inf),10.1),
					]* 5 , 
					Pseq([0,1,2,3,4,5],inf)
			),
			\lpfr, ~pmodenv.(Pseq([1/4,2,1,1.4],inf), 8),
			\env1, Pseq([
				[ Env.adsr(0.1,0.351,0.3,0.4) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.081,0.051,0.8,0.4) ],
			],inf),
			\decay, Pswitch1(
				[
					Pseg(Pseq([1/4,4],inf),6),
					Pseg(Pseq([1/4,2],inf),7),
					Pseg(Pseq([2,1/4],inf),9),
					Pseg(Pseq([1/8,4],inf),10),
					Pseg(Pseq([1/8,2],inf),11),
					Pseg(Pseq([2,1/8],inf),12),
				], 
				Pseq([0,1,2,3,4,5],inf)
			),
			\degree, Pseq([
				Pser([0,-1,-2,-4,-5,-6],32 )+ Prand(( (0..2)*7 )),
				//Pseq([0,2,4,5,6] +.x ( (0..2)*7 )),
				//Pseq([1,2,0,2,4] +.x ( (0..2)*7 )),
				//Pseq([7,6,5,5,6] +.x ( (0..2)*7 )),
				//Pseq([1,2,0,2,4] +.x ( (0..2)*7 )),
			],inf),
			\octave, 3,
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\dur, 1/16,
			\amp, 0.1 * Pseq([
				Pswitch1(
					[
						Pseg(Pseq([0.1,1],inf),3),
						Pseg(Pseq([1,0.21],inf),7),
						Pseg(Pseq([1,0.71],inf),9),
						Pseg(Pseq([1,0.1],inf),11),
						Pseg(Pseq([0.31,1],inf),12),
						Pseg(Pseq([1,0.031],inf),13),
					], 
					Pseq([3,2,1, 0,1,2,3,4,5],inf)
				)
			],inf),
			//\lag, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \freecordeenv,
			//\note, Pseq([
				////Prand([0,4,7,0,4,7,9,11] +.x ( (0..2)*12 )),
				//Prand([0,4,7,0,4,7] +.x ( (0..2)*12 )),
				////[0,4,7,9],
			//],inf),
			\degree, Pseq([
				Prand([0,2,4,5,6] +.x ( (0..2)*7 )),
			],inf),
			\octave, 3,
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\adsr, Prand([
				[ Env.adsr(1.1,0.1,0.8,2.1) ],
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\amampenv, Prand([
				[ Env([1,0.1,0],[0.1,2.8]) ],
				[ Env([0,0.1,1],[0.1,2.8]) ],
			],inf),
			\fmampenv, Prand([
				[ Env([1,0.1,0],[0.1,2.8]) ],
				[ Env([0,0.1,1],[0.1,2.8]) ],
			],inf),
			\fmr, 1,
			\fmr, Prand([1/2,1,2] +.x [0,0.051,0.01],inf),
			\fspread, 0.01,
			\amr, Prand([1,1/2] +.x [0,0.051,0.01],inf),
			\amamp, 0.4,
			\fmamp, 0.2,
			\sustain, Prand([2,3,4,5],inf)/~t,
			\dur, Pwhite(0.6,4),
			\amp, 0.1 * Pwhite(0.1,1,inf),
			\out, BusDef(\sendbus1, \audio),
		)!2,
		Pbind(
			\instrument, \freecordeenv,
			//\note, Pseq([
				////Prand([0,4,7,0,4,7,9,11] +.x ( (0..2)*12 )),
				//Prand([0,4,7,0,4,7] +.x ( (0..2)*12 )),
				////[0,4,7,9],
			//],inf),
			\degree, Pseq([
				[0,2,4] + {[0,7,-7].choose}.dup(3),
				//Prand([0,2,4] +.x ( (0..2)*12 )),
			],inf),
			\octave, 5,
			\fspread, ~pmodenv.(Pseq([0.001,0.1],1), Pwhite(1.0,12)).loop,
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\amr, 1,
			\adsr, Prand([
				//[ Env.adsr(1.1,0.1,0.8,2.1) ],
				[ Env.adsr(2.1,0.1,0.8,2.1) ],
				//[ Env.adsr(0.1,0.1,0.8,2.1) ],
				//[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\fmr, Ptuple(Prand([1/2,1,2,1] +.x [0,0.051,0.01],inf)!3),
			\fmamp, 0.2,
			\amampenv, Pseq([
				[ Env([1,0.1,0],[0.1,0.8]) ],
			],inf),
			\fspread, 0.01,
			\amamp, 0.4,
			\sustain, 3/~t,
			\dur, 4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		)!1,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[420].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[344].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 0.11,
			\out, BusDef(\sendbus2, \audio),
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef('voices/feynman.flac'),
			//\isRest, Pseq([
				//1,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
				//0,0,0,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
				//0,0,0,0, 1,0,0,0,
				//1,0,0,0, 0,0,1,0,
				//0,0,1,0, 0,0,0,0,
				//1,0,0,0, 0,0,0,0,
				//0,0,1,0, 0,0,1,0,
			//],inf).coin.not,
			//\dur, 1/4,
			//\pos, Pwhite(0,1.1)+0.3,
			//\speed, 0.7,
			//\speed, Pwhite(0.9,1.1,inf)*0.7,
			//\adsr, Pseq([
				//[ Env.adsr(0.01,0.1,0.8,0.1) ],
			//],inf),
			//\sustain, 0.1/8,
			//\gain, 1/2,
			//\out, BusDef(\sendbus2, \audio),
		//),
		Pmono(\delayrytm16,
			\inbus, BusDef(\sendbus2, \audio),
			\addAction, \addToTail,
			\deltab, [ (1..32).scramble.keep(16)/16 ]/~t,
			\delamptab, [ (1..64).keep(16)/64 ],
			\maxdel, 2/~t,
			\lag, 0.0009,
			\dur, 1,
		),
		
	].flat)
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[420].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\delayrytm,
			\inbus, BusDef(\sendbus2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\pluckym, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var xfreq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	env1 = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	//sig = Decay.ar(WhiteNoise.ar, 0.1);
	sig = Pluck.ar(WhiteNoise.ar, 1, 100.reciprocal, xfreq.reciprocal, \decay.kr(1));
	sig = sig + (sig.tanh * \distamp.kr(1));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * (env1 * \envfamt.kr(1) + 1) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\delayrytm, { arg out=0, gate=1, maxdel=2;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var deltab;
	sig = in;
	//sig = DelayL.ar(sig, maxdel, [1/8,6/8,14/8,24/8]/2/~t * ( SinOsc.kr(4) * 0.01 + 1 ) );
	//sig = DelayL.ar(sig, maxdel, (1..16).scramble.keep(8).postln/8/~t * ( SinOsc.kr(4) * 0.01 + 1 ) );

	deltab = \deltab.kr([ 13, 15, 4, 1, 11, 2, 6, 16  ]/8/~t);
	//deltab = (1..16).scramble.keep(8).postln/8;

	sig = DelayL.ar(sig, maxdel, deltab * ( SinOsc.kr(0.8 * (1..deltab.size), 2.0.rand) * 0.01 + 1 ) );
	sig = sig * \delamptab.kr(( (1..sig.size).reverse/sig.size )/2);
	sig = sig * LFPulse.kr((1..sig.size)/12).range(0.1,1);
	sig = sig.clump(2);
	sig = sig.sum;

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\delayrytm16, { arg out=0, gate=1, maxdel=2;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var deltab;
	sig = in;
	//sig = DelayL.ar(sig, maxdel, [1/8,6/8,14/8,24/8]/2/~t * ( SinOsc.kr(4) * 0.01 + 1 ) );
	//sig = DelayL.ar(sig, maxdel, (1..16).scramble.keep(8).postln/8/~t * ( SinOsc.kr(4) * 0.01 + 1 ) );

	deltab = \deltab.kr((1..16)/16/~t);
	//deltab = (1..16).scramble.keep(8).postln/8;

	sig = DelayL.ar(sig, maxdel, deltab * ( SinOsc.kr(0.8 * (1..deltab.size), 2.0.rand) * 0.01 + 1 ) );
	sig = sig * \delamptab.kr(( (1..sig.size).reverse/sig.size )/2);
	sig = sig * LFPulse.kr((1..sig.size)/12).range(0.1,1);
	sig = sig.clump(2);
	sig = sig.sum;

	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
{ LFPulse.ar(5) ! 2 * 0.1}.plot(1);



(
SynthDef(\latchsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, noisefreq=0.1, noiseamp=0.01;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq * [1* LFNoise1.ar(noisefreq,mul:noiseamp,add:1),1/2 * LFNoise1.ar(noisefreq,mul:noiseamp,add:1),LFNoise1.ar(noisefreq,mul:noiseamp,add:1) ]).mean;
	//sig = sig.fold2(( Pulse.ar(100).range(0,1) * \amamp.kr(1) + 1 ));
	sig = sig * ( Pulse.ar(40).range(0,1) * \amamp.kr(1) + 1 );
	sig1 = ( sig*\distamp.kr(100) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(1.0), [sig, sig1]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( 
		Latch.ar( SinOsc.ar(\fmf.kr(1000.2)).unipolar, Impulse.ar(\latchfreq.kr(10))).lag(\latchlag.kr(0.01)) * \latchamt.kr(0.1) + 1 
	), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \latchsaw,
			 \latchamt, Pseg(Pseq([0,3.71],inf),8),
			 \latchlag, Pseg(Pseq([0,0.01,1],inf),9),
			 \fmf, Pseq([
			 	[3,2.1,4,1],
				 //[3,1.1,2,1],
				 //[300,1.1,2,1],
			 ],inf),
			 \lpfr, 0.8,
			 \lpfr, Pseg(Pseq([0.2,2,0.8,0.5],inf),8),
			 \latchfreq, Pseq([2,4,1,8, 4,16,1,32],inf)*~t,
			 \latchfreq, Pstep(Prand([4,3],inf),2)*~t,
			 \noiseamp, ~pmodenv.(Pseq([0,0.01,0.001,0.0001],1), 8).loop,
			 \noisefreq, ~pmodenv.(Pseq([0.1,1,10],1), 3).loop,

			\degree, Pstep(Pseq([
				[0,2,4,7],
				[0,2,4,7],
				[0,2,4,7],
				[0,2,4,4-7],
				[0,2,4,7],
				[0,2,4,7],
				[0,2,4,6],
				[0,2,4,6b],
			],inf),1),
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
SynthDef(\cleanchord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0.4,0.1],[0.1,0.8]), 1);
	//sig = SinOsc.ar(freq * [1,3/4,4,7], mul:[1,1/2,1/4,1/8]);
	sig = LFSaw.ar(freq) * SinOsc.ar(freq+0.05) ;
	//sig = ( sig*\distamp.kr(100) * [1,3,4,7] ).tanh * \distpostamp.kr(1/2);
	//sig = sig * [1,1/2,1/4,1/8];
	//sig = sig.mean;
	//sig = SinOsc.ar(freq); 
	sig = RHPF.ar(sig, freq * \hpfr.kr(1/2) * ( LFNoise1.ar(1/2) * 0.3 + 1 ), \hprq.kr(0.4) );
	//sig = RLPF.ar(sig, \lpfr.kr(3.1) * freq * ( LFNoise1.ar(1/2) * 0.3 + 1 ), \rq.kr(0.5));
	sig = RLPF.ar(sig, \lpfr2.kr(3.1) * freq * ( SinOsc.ar(freq/8/8/2) * env1 + 1 ), \rq2.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \atechordtrem,
			\degree, Pstep(Pseq([
				[0,2,4,7],
				[0,2,4,7],
				[0,2,4,7],
				[0,2,4,4-7],
				[0,2,4,7],
				[0,2,4,7],
				[0,2,4,6],
				[0,2,4,6b],
			],inf),1),
			\adsr, Pseq([
				[ Env.adsr(0.7,0.1,0.8,1.1) ],
			],inf),
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\lpfr, Pseg(Pseq([0.8,1,2],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\dur, Pwhite(0.1,2,inf),
			\amp, 0.1,
		)
		
	])
)).play;
);


//////////////////////// atelier de chord


(
SynthDef(\atechordsin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\atechordsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\atechordtrem, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0.4,0.1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([0,0.4,1.1],[0.4,1.8]), 1);
	sig = LFSaw.ar(freq) * SinOsc.ar(freq+0.05) ;
	sig = RHPF.ar(sig, freq * \hpfr.kr(1/2) * ( LFNoise1.ar(1/4) * env2 + 1 ), \hprq.kr(0.2) );
	sig = RLPF.ar(sig, \lpfr.kr(3.1) * freq * ( SinOsc.ar(freq/8/8/2) * env1 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

SynthDef(\latchsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, noisefreq=0.1, noiseamp=0.01;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq * [1* LFNoise1.ar(noisefreq,mul:noiseamp,add:1),1/2 * LFNoise1.ar(noisefreq,mul:noiseamp,add:1),LFNoise1.ar(noisefreq,mul:noiseamp,add:1) ]).mean;
	//sig = sig.fold2(( Pulse.ar(100).range(0,1) * \amamp.kr(1) + 1 ));
	sig = sig * ( Pulse.ar(40).range(0,1) * \amamp.kr(1) + 1 );
	sig1 = ( sig*\distamp.kr(100) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(1.0), [sig, sig1]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( 
		Latch.ar( SinOsc.ar(\fmf.kr(1000.2)).unipolar, Impulse.ar(\latchfreq.kr(10))).lag(\latchlag.kr(0.01)) * \latchamt.kr(0.1) + 1 
	), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

(
SynthDef(\atechord_sawmix, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, noiseamp=0.01, noisefreq=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0.4,0.1],[0.1,0.8]), 1);
	sig = LFSaw.ar(freq * [1* LFNoise1.ar(noisefreq,mul:noiseamp,add:1),1/2 * LFNoise1.ar(noisefreq,mul:noiseamp,add:1),LFNoise1.ar(noisefreq,mul:noiseamp,add:1) ]).mean;
	sig = RHPF.ar(sig, freq * \hpfr.kr(1/2) * ( LFNoise1.ar(1/2) * 0.3 + 1 ), \hprq.kr(0.4) );
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.ar(freq/8/8/2) * env1 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\atechord_double, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, noiseamp=0.01, noisefreq=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0.4,0.1],[0.1,0.8]), 1);
	env2 = Duty.kr(1/4/~t, 0, Dseq([
		1,2,3,2,1/2,
	],inf)).lag(0.1/~t);
	sig = LFSaw.ar(freq * [1* LFNoise1.ar(noisefreq,mul:noiseamp,add:1),1/2 * LFNoise1.ar(noisefreq,mul:noiseamp,add:1),LFNoise1.ar(noisefreq,mul:noiseamp,add:1)*env2 ]).mean;
	sig = BRF.ar(sig, freq * ( SinOsc.kr(2*~t) * 0.41 + 1 ), 0.8);
	sig = sig * ( LFSaw.ar(freq+[0.01,1,freq/2]).mean * 1 + 1 );
	sig = RHPF.ar(sig, freq * \hpfr.kr(1/2) * ( LFNoise1.ar(1/2) * 0.3 + 1 ), \hprq.kr(0.4) );
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.ar(freq/8/8/2) * env1 + 1 ), \rq.kr(0.5));
	sig4 = sig;


	sig = ( LFSaw.ar(freq+[0.01,1,freq/2] * [1,1/2]).mean * 1 + 1 );
	sig = BPF.ar(sig, freq*4 * XLine.kr(1,0.1,4),0.1 * XLine.kr(1,10,4));
	sig = sig * 2;

	sig = SelectX.ar(\wavemix.kr(0.6), [sig, sig4]);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\atechord_double, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, noiseamp=0.01, noisefreq=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0.4,0.1],[0.1,0.8]), 1);
	//sig = SinOsc.ar(freq * [1,3/4,4,7], mul:[1,1/2,1/4,1/8]);
	//sig = LFSaw.ar(freq) * SinOsc.ar(freq+0.05) ;
	env2 = Duty.kr(1/4/~t, 0, Dseq([
		1,2,3,2,1/2,
	],inf)).lag(0.1/~t);
	sig = LFSaw.ar(freq * [1* LFNoise1.ar(noisefreq,mul:noiseamp,add:1),1/2 * LFNoise1.ar(noisefreq,mul:noiseamp,add:1),LFNoise1.ar(noisefreq,mul:noiseamp,add:1)*env2 ]).mean;
	sig = BRF.ar(sig, freq * ( SinOsc.kr(2*~t) * 0.41 + 1 ), 0.8);
	sig = sig * ( LFSaw.ar(freq+[0.01,1,freq/2]).mean * 1 + 1 );
	//sig1 = ( sig*\distamp.kr(100) ).clip2(1) * \distpostamp.kr(1/4);
	//sig = SelectX.ar(\mix.kr(1.0), [sig, sig1]);
	//sig = sig * [1,1/2,1/4,1/8];
	//sig = sig.mean;
	//sig = SinOsc.ar(freq); 
	sig = RHPF.ar(sig, freq * \hpfr.kr(1/2) * ( LFNoise1.ar(1/2) * 0.3 + 1 ), \hprq.kr(0.4) );
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.ar(freq/8/8/2) * env1 + 1 ), \rq.kr(0.5));
	sig4 = sig;


	sig = ( LFSaw.ar(freq+[0.01,1,freq/2] * [1,1/2]).mean * 1 + 1 );
	sig = BPF.ar(sig, freq*4 * XLine.kr(1,0.1,4),0.1 * XLine.kr(1,10,4));
	sig = sig * 2;

	sig = SelectX.ar(\wavemix.kr(0.6), [sig, sig4]);

	//sig = RLPF.ar(sig, \lpfr.kr(3.1) * freq * ( LFNoise1.ar(1/2) * 0.3 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, Pseq([
				\atechord_double,
				//\atechordsaw,
				//\atechordsin,
				//\atechordtrem,
			],inf),
			\degree, Pstep(Pseq([
				[0,2,4,7],
				[0,2,4,7],
				[0,2,4,7],
				[0,2,4,4-7],
				[0,2,4,7],
				[0,2,4,7],
				[0,2,4,6],
				[0,2,4,6b],
			],inf),1),
			\adsr, Pseq([
				[ Env.adsr(0.7,0.1,0.8,1.1) ],
			],inf),
			\mtranspose, Pstep(Pseq([0,3],inf),8),
			\lpfr, Pseg(Pseq([0.8,1,2],inf),8),
			\scale, Pstep(Pseq([
				Scale.major,
				Scale.minor,
			],inf), 8),
			\dur, Pwhite(0.1,2,inf),
			\amp, 0.1,
		)
		
	])
)).play;
);

(
	Pdef(\part, Pdef(\zedpart, 
		Ppar([
			4.collect { arg idx;
				Pbind(
					\instrument, Prand([
						\atechordsaw,
						\atechordsin,
						\atechordtrem,
						\atechord_sawmix,
						\atechord_double,
						\atechord_sawmix,
						\atechord_double,
					],inf),
					\degree, Pstep(Pseq([
						[0,2,4,7],
						[0,2,4,7],
						[0,2,4,7],
						[0,2,4,4-7],
						[0,2,4,7],
						[0,2,4,7],
						[0,2,4,6],
						[0,2,4,6b],
					],inf),1).collect({ arg x; x[idx] }),
					\adsr, Pseq([
						[ Env.adsr(0.7,0.1,0.8,1.1) ],
					],inf),
					\mtranspose, Pstep(Pseq([0,3],inf),8),
					\lpfr, Pseg(Pseq([0.8,1,2],inf),8),
					\scale, Pstep(Pseq([
						Scale.major,
						Scale.minor,
					],inf), 8),
					\dur, Pwhite(0.1,4,inf),
					\amp, 0.1,
				)
			}

		].flat)
	)).play;
);
