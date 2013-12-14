s.boot



//////////////////
// Ducking example
///////////////////

// Compander with
// low threshold (like 0.01)
// slopeBelow: leave at 1 (default)
// slopeAbove: small value (means input signal will be attenuated a LOT when control kicks in)
// clampTime and releaseTime: small (e.g., 0.1)
// but release time can be a bit more


/////////////////////////
// Kick and Low Synth Bass
/////////////////////////

(
Ndef(\plop,{
    var in, snd, control ;
    in = LPF.ar(Saw.ar(90*[0.990,1,1.0001]), 5500);
    control = Ringz.ar(
        in: LPF.ar(
            in: Impulse.ar(MouseY.kr(0,8).round(1)),
            freq: 30),
        freq: 30,
        decaytime: 0.15,
        mul: 7).tanh.sin*2;
    snd = Compander.ar(
        in: in,
        control: control,
        //thresh: 0.01,
        thresh: MouseX.kr(0.001,0.3),
        slopeBelow: 1,
        slopeAbove: 0.1,
        clampTime: 0.01,
        // longer release
        relaxTime: 0.1
    );
    Splay.ar([snd, control, snd])
}).play;
)



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
