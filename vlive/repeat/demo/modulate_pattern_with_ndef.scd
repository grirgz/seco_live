
(
~bus = ~bus ?? { Bus.control(s,1).set(400) };
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\freqscale,Pgauss( 0.5, 0.125, inf ), 
		\freq, Prout({ arg ev;
			Ndef(\lfo1, { arg scale=1;
				In.kr(~bus)* scale;
			});
			loop{
				Ndef(\lfo1).set(\scale, ev[\freqscale]);
				ev = Ndef(\lfo1).asMap.yield;
			}
		}),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

~makemod = { arg name, key, bus, fun;
	Prout({ arg ev;
		Ndef(name, fun);
		loop{
			Ndef(name).set(\scale, ev[\freqscale]);
			ev = Ndef(\lfo1).asMap.yield;
		}
	}),
}
