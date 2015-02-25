(
SynthDef(\testing,{ arg freq = 440;
        var sound;
        sound = SinOsc.ar(freq.poll,0,mul:0.5)*
        EnvGen.kr(Env.linen(0,0.1,0.1),doneAction:2);
        Out.ar(0, sound);
}).add;
)

(
t = Task({
        loop { [60, 62, 64, 65, 67, 69, 71, 72].do({ |midi|
                Synth("testing", [freq: midi.midicps]);
                0.25.wait;
                });
        }
}).play;
)



(
t = Task({
        loop { [60, 62, 64, 65, 67, 69, 71, 72].do({ |midi|
                (
                  instrument: "testing",
                  freq: midi.midicps
                ).play;

                0.25.wait;
                });
        }
}).play;
)

(
	Pbind(
		\instrument, "testing",
		\freq, Pseq([60, 62, 64, 65, 67, 69, 71, 72],inf).midicps,
		\dur, 0.25,
	).play
)

