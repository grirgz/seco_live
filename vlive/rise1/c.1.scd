Ndef(~name+++\lfo1, { SinOsc.kr(0.01).range(0.95,1)  });

Pdef(~name +++ \pre, 
	Pbind(

		\mbufnum, BufDef.mono(\metal),
		\dur, 1/8,
		\legato, 0.2,
		\pos, Plazy({
			var list = List.new;
			list.add(1.0.rand);
			list.add(1.0.rand);
			list.add(1.0.rand);
			Pseq([list[0],list[1],list[0],list[2]],2).stutter(16);
		}).loop,
		\amp, Pkey(\amp) * 2,

	) <>
	
	Sdef(~name, \mypreset).pbind <> 
	Pbind(
		\ffreq, 1000,
		\time_stretch, 0,
		\freq, 100,
		\pos, Pseq([0.1,0.12,0.3,0.2],inf) + Pwhite(0,0.01),
		\pos, Pseq([
			0.3,0.21,
			0.4,0.31,
		],inf) + Pwhite(0,0.007),
		\pos, 0.3,
	)
)

// END

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
