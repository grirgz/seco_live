


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		
	])
)).play;
);

ProtoDef(\piano).nektar(Pdef(\bass1))
s.latency = 0.2
ProtoDef(\piano).keys
SynthDesc(\default)

		Pdef(\bass1, Pbind(
			\instrument, \basicbass,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.001) ],
			],inf),
			\lpf, 16000,
			\dur, 0.1,
			\out, BusDef(\sendbus1, \audio),
			\amp, 0.1,
		));

		(
		MIDIdef.noteOn(\piano, { arg ... args;
			args.postln;
			//~bla.release;
			~bla = Synth(\default, [\freq, args[1].midicps]);
		});
		MIDIdef.noteOff(\piano_off, { arg ... args;
			args.postln;
			~bla.release;
		});
		)
