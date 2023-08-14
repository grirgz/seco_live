
// pmodsynth
FileSystemProject.load("libdef/pmodenv.scd")

(
Pdef(\plati, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, Pseq([
				~pmodsynth.({ XLine.kr(100,10300,8) }, 4),
				~pmodsynth.({ SinOsc.kr(2).range(4100,3001) }, 1),
				~pmodsynth.({ SinOsc.kr(1/2).range(4100,301) }, 1/8),
			],inf),
			\legato, 0.8,
			\dur, 1,
			\amp, 0.1,
		);
	])
).play;
);

{ SinOsc.ar(200) ! 2 * 0.1}.play;
{ SinOsc.ar(200) ! 2 * 0.1}
3.dumpAllMethods


(
Pdef(\plati, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, Pseq([
				Prout({ arg ev;
					ev.debug("ev!!");

					ev = nil.yield;
				}),
				Prout({ arg ev;
					ev.debug("ev2!!");

					ev = 400.yield;
				})
			],inf),
			\dur, 2,
			\amp, 0.1,
		);
	])
).play;
);


////////////////////////


(
SynthDef(\bla, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \bla,
			\lpfr, ~pmodsynth.({ SinOsc.kr(8 * XLine.kr(1/10,2,20)).range(7,1/4) }),
			\rq, ~pmodsynth.({ SinOsc.kr(1/3).range(0.1,1) }),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		);
	])
).play;
);
