(
SynthDef(\M_HENONC, {arg outbus=0, ctl=6, frq1=0.5, frq2=1.4, atck=0.01,
sust=0.1, release=1, pan=0, amp=0.5;
        var sound, env, gen, trigger;
        sound = HenonC.ar(SampleRate.ir/ctl, LFNoise2.kr([1, 1], frq1, frq2));
        env = Env.new([0,1,1,0], [atck, sust, release],[\sine]);
        gen = EnvGen.ar(env, doneAction: 2);
		(sound * gen).debug("sig");
        Out.ar(outbus, Pan2.ar(sound * gen, pan, amp).debug("sig2").mean.debug("sig3"));
}).add;
)

Synth(\M_HENONC, [\pan, rand2(-1.0,1)]); // no affect.
rand2(-1.0,1)
