(
Ndef(~name+++\lfo1, { SinOsc.kr(1*~t).range(0,1)  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Ndef(~name+++\lfo2, { SinOsc.kr(1.1*~t).range(0,1)  });
Ndef(~name+++\lfo2).quant = Pdef.defaultQuant;

Pdef(~name +++ \pre, 
	Pspawner({ arg sp;
		var durs = [1,1.1];
	
		durs.do { arg dur, x;

			sp.par(
				Pbind(
					\instrument, ~name+++\b,
					\degree, Pseq([1,2,3],inf),
					\scale, Scale.minor,
					\dur, 1,
					\mix1, Pseg(Pseq([0,1],inf),8),
					\ringfreq, Ndef(~name+++\lfo2),
					\adsr, 
					Prout({
						8.do { arg i;
							Pseq([
								[ Env.adsr(0.01,0.1,0.8,0.1) ],
								[ Env.adsr(0.01,0.1,0.8,0.1 + ( i/8 )) ],
							],inf).embedInStream;
						}
					}).loop,
					\freqfac, Ndef(~name+++\lfo1),
					\legato, Pseq([4/7,1,0.1],inf),
					\octave, 6,
					\pan, Pseq([0,0.3,0,-0.3,0],inf),
					\lpf, [1000,2000][x],
					\dur, dur,
					\amp, Pkey(\amp) * 0.1,
					\isRest, Pseq([
						1,
					],inf).coin.not,
				)
			);

		}
	
	})


);
)
