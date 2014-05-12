
 // __1
{{({|i|x=i+1;SinOsc.ar(30*x+LFNoise2.ar(0.1).range(-2,2),0,LFNoise2.ar(0.5)*(Line.ar(0,0.1,99.rand)/(x*0.2)))}!rrand(9,28)).sum}!2}.play

// __2
play{{({|i|x=i+1;y=LFNoise2.ar(0.1);f=77*(x/2)+y.range(-2,2);LPF.ar(Saw.ar(f,y*(Line.ar(0,0.2,99.rand)/(x*0.3))),f*3)}!rrand(9,28)).sum}!2}


Pbind([\freq, \bla, 0.1], [100,200,300,1.0]).play

	Pdef(\x, Pbind(
		\instrument, \default,
		\degree, Pwalk([0,2,3,4], Prand([1,2,-1,-2],inf)),
		\dur, 1/8,
	)).play


(

	Pdef(\x,

		Pspawner({ arg sp;
			var dur = 1/2;
			10.do { arg x;
				x = x+1;
				sp.par(
					Pbind(
						\degree, x,
						\sustain, dur,
						\dur, x*2,
					)
				);
				dur.wait;
			};
		})
	).play
);

(

	Pdef(\x,

		Pspawner({ arg sp;
			var dur = 1/2;
			10.do { arg x;
				x = x+1;
				sp.par(
					Pbind(
						\degree, 24.rand,
						\octave, 3,
						\sustain, dur,
						\dur, 4.0.rand + 1,
					)
				);
				8.wait;
			};
		})
	).play
);


(

	Pdef(\x,

		Pspawner({ arg sp;
			var dur = 1/2;
			40.do { arg x;
				x = x+1;
				sp.par(
					Pbind(
						\degree, 24.rand,
						\freq, (107.0.rand + 10).midicps,
						\octave, 3,
						\sustain, dur.rand + 1/8,
						\dur, 4,
						\lag, 16.rand * 1/6,
					)
				);
				1.wait;
			};
		})
	).play
);

(
//fundamental pitch triad
~notes = [45,55,60].midicps;

s.waitForBoot({
	Routine{

		SynthDef.new(\tone, {
			arg freq=440, pan=0, rel=0.05;
			var sig;
			sig = LFSaw.ar(freq);
			sig = RLPF.ar(sig, MouseX.kr(200,15000), 0.3);
			sig = sig * EnvGen.kr(Env.perc(0.005,rel), doneAction:2);
			sig = Pan2.ar(sig, pan, 0.05);
			Out.ar(0, sig);
		}).add;

		s.sync;

		50.do{
			Pbind(
				\instrument, \tone,

				//trace some event times just for fun
				\dur, Pseq(Array.geom(50, rrand(1.5,1.51), rrand(0.923,0.929)).mirror,inf).trace,

				\freq, exprand(~notes[0],8000).round(~notes[0]),
				\pan, rrand(-1.0,1.0),
				\rel, exprand(0.005,0.35),
			).play;

			Pbind(
				\instrument, \tone,
				\dur, Pseq(Array.geom(50, rrand(1.5,1.51), rrand(0.923,0.929)).mirror,inf),
				\freq, exprand(~notes[1],11000).round(~notes[1]),
				\pan, rrand(-1.0,1.0),
				\rel, exprand(0.005,0.35),
			).play;

			Pbind(
				\instrument, \tone,
				\dur, Pseq(
					Array.geom(50, rrand(1.5,1.51), rrand(0.923,0.929)).mirror,inf
				),
				\freq, exprand(~notes[2],15000).round(~notes[2]),
				\pan, rrand(-1.0,1.0),
				\rel, exprand(0.005,0.35),
			).play;
		};
	}.play(AppClock);
});
)
