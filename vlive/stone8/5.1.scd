(
Ndef(~name+++\lfo1, { LFNoise1.kr(1/7)  });
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;

Pdef(~name +++ \pre, 
	Pspawner({ arg sp;
	
		10.do { arg i;

			sp.par(
				Pbind(
					//\freq, Pseq([100,240, 320, Pwhite(100,200,1)],inf),
					\degree, 
						Pseq([
							Pseq(((1..(i+1))*2+i).debug(i)),
							Pseq(((1..(i+1))*1+(2*i)).debug(i)),
						],inf),
					\scale, Scale.minor,
					\dur, 1,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
						[ Env.adsr(0.01,0.1,0.8,0.1 + ( i/8 )) ],
					],inf),
					\spread, Pseg(Pseq([0,1],inf),9),
					\pan, Ndef(~name+++\lfo1),
					\legato, 1/7,
					\octave, 6,
					\lpf, Pwalk((1..8)*50,i),
					\isRest, Pseq([
						1,
					],inf).coin.not,
				)
			);

			1.321.wait;
		}
	
	})


)
);
