~name = 'a';

SynthDef(~name,
    { arg out = 0, freq=800, sustain=0.001, amp=0.5, pan = 0;
        var window;
        window = Env.perc(0.002, sustain, amp * AmpCompA.kr(freq));
        Out.ar(out,
            Pan2.ar(
                Ringz.ar(PinkNoise.ar(0.1), freq, 2.6),
                pan
            ) * EnvGen.ar(window, doneAction:2)
        )
    }
).add;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1
))
);
