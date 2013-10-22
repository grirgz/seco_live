s.boot



(

SynthDef(\aSynth, { |rel = 0, choose = 0, amp = 0|

    var klank, env;



    klank = Klank.ar(`[choose ! 12, {Rand(0.128, 0.7)} ! 12], BrownNoise.ar(0.7));

    env   = EnvGen.kr(Env.perc(0.01, rel), doneAction: 2);

    Out.ar(0, klank * env.dup * amp);

}).add;

)



(

{

    42.do{

        x = [70, 90, 120].choose;

        y = rrand(0.01, 5);

        // attack

        Synth(\aSynth, [\rel, y, \choose, x, \amp, 128e-6]);

        // resonance

        Synth(\aSynth, [\rel, 1, \choose, x, \amp, 128e-5]);

        y.wait;

    }

}.fork;

)
