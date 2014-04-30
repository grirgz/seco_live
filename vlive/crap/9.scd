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
