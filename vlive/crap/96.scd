(
a = Bus.audio(s, 1);

SynthDef(\map_test, { |out = 0, freq = 400, amp = 0.1, mod = 0, gate = 1|
        var sig = SinOsc.ar(freq * (mod.poll), 0, amp) *
                EnvGen.ar(Env.asr, gate, doneAction: 2);
        Out.ar(out, sig ! 2)
}, \kr!3 ++ \ar ++ \kr).add;
)


// play

x = Synth(\map_test);


// start modulator

y = { Out.ar(a, SinOsc.ar(100) * 50) }.play;


// map

x.map(\mod, a);
x.map(\mod, -1);


// now still modulation after freeing !

y.free;


a.get({ arg x; x.debug("=============") })
