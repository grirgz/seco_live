
///////// wood

FileSystemProject.loadOnce("sndlib/synthbasic.scd");

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \snappad,
			\freq, 360,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \woodBlock,
			\freq, 468.16545523566,
			\decay, 1,
			\dur, 1/1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \wkick,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
SynthDef(\wkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
Pdef(\woodBlock, 
		Pbind(
			\instrument, \woodBlock,
			\dur, 1/1,
			\amp, 0.1,
		),
).edit;
);

(
// with klank
SynthDef(\woodBlock, { arg out=0, freq=280, amp=0.3, decay=0.15, gate=1;
    var hit, res, sig;
    hit = Impulse.ar(0) * Hasher.ar( SinOsc.ar(freq)  ) * EnvGen.ar(Env.perc(0.0001, 0.004, 1, -12));
    
    res = Klank.ar(Ref([0.71, 0.64,0.95, 1.3, 2.1, 2.134,5], [ 1 ], [ 0.7 ]), hit, freqscale:freq, decayscale:decay);
    res = RLPF.ar(res, freq*1.8, 0.1);
    res = HPF.ar(res, 20);
    
    sig = (hit * 1.5) + res;
    sig = sig * EnvGen.ar(Env.perc(0.002, decay, 1, -8), gate, doneAction: 2);
    Out.ar(out, Pan2.ar(sig * 3.5, 0, amp));
}).add;
)
(
// modify
SynthDef(\woodBlock, {
    |out=0, freq=280, amp=0.3, decay=0.15, gate=1|
    var hit, res, snd;
    // Compact woody transient: short impulse burst
    hit = Impulse.ar(0) * Hasher.ar( SinOsc.ar(freq)  ) * EnvGen.ar(Env.perc(0.0001, 0.004, 1, -12));
    
    // Low-mid wood resonance only (200-800Hz), heavily damped
    res = Ringz.ar(hit, freq*[0.71, 0.64,0.95, 1.3, 2.1, 2.134,5], decay*0.7, 0.4).mean;
    res = RLPF.ar(res, freq*1.8, 0.1);
    res = HPF.ar(res, 20);
    
    snd = (hit * 1.5) + res;
    snd = snd * EnvGen.ar(Env.perc(0.002, decay, 1, -8), gate, doneAction: 2);
    Out.ar(out, Pan2.ar(snd * 3.5, 0, amp));
}).add;
)

(
// nice
SynthDef(\woodBlock, {
    |out=0, freq=280, amp=0.3, decay=0.15, gate=1|
    var hit, res, snd;
    // Compact woody transient: short impulse burst
    hit = Impulse.ar(0) * Hasher.ar( SinOsc.ar(freq)  ) * EnvGen.ar(Env.perc(0.0001, 0.004, 1, -12));
    
    // Low-mid wood resonance only (200-800Hz), heavily damped
    res = Ringz.ar(hit, [freq*0.95, freq*1.3, freq*2.1], decay*0.7, 0.4).mean;
    res = RLPF.ar(res, freq*1.8, 0.5);
    res = HPF.ar(res, 120);
    
    snd = (hit * 1.5) + res;
    snd = snd * EnvGen.ar(Env.perc(0.002, decay, 1, -8), gate, doneAction: 2);
    Out.ar(out, Pan2.ar(snd * 3.5, 0, amp));
}).add;
)

{ Formlet.ar(Impulse.ar(20, 0.5), 1000, 0.01, 0.1) }.play;

{ Formlet.ar(Blip.ar(XLine.kr(10,400,8), 1000, 0.1), 1000, 0.01, 0.1) }.play;

(
// modulating formant frequency
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1);
    Formlet.ar(in, XLine.kr(1500,700,8), 0.005, 0.04);
}.play;
)

(
// mouse control of frequency and decay time.
{
    var in;
    in = Blip.ar(SinOsc.kr(5,0,20,300), 1000, 0.1);
    Formlet.ar(in,
        MouseY.kr(700,2000,1),
        0.005, MouseX.kr(0.01,0.2,1));
}.play;
)

(
// mouse control of frequency and decay time.
{
    var freq;
    freq = Formlet.kr(
        Dust.kr(10 ! 2),
        MouseY.kr(7,200,1),
        0.105, MouseX.kr(0.1,2,1)
    );
	SinOsc.ar(freq * 800 + [500, 600] - 100) * 0.1
}.play;
)

(
// mouse control of frequency and decay time.
Ndef(\formlet,{
    var freq;
    freq = Formlet.kr(
        Dust.kr(10 ! 2),
        MouseY.kr(7,200,1),
        0.105, MouseX.kr(0.1,2,1)
    );
	SinOsc.ar(freq * 800 + [500, 600] - 100) * 0.1
}).play;
)
