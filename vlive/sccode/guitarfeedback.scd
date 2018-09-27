// results will vary with blocksize. this is tuned for 64.

(
{
    var snd, string, delay;
    string = { |freq|
        var delay;
        delay = freq.reciprocal;
        Pluck.ar(SinOsc.ar(Line.ar(1000, 50, 0.01)) * Env.perc(0.001, 0.01).ar, Impulse.ar(0), delay, delay, 5, 0.5)
    };
    snd = string.(100) + string.(150) + string.(200);
    snd = snd + (HPF.ar(LocalIn.ar(1), 3000) * -50.dbamp);
    snd = (snd * 32.dbamp).tanh;
    snd = RLPF.ar(snd, 3000, 0.5);
    snd = (snd * 32.dbamp).tanh;
    snd = RLPF.ar(snd, 500, 0.5);
    snd = (snd * 32.dbamp).tanh;
    snd = BHiShelf.ar(snd, 3200, 1, -3.0);
    snd = LeakDC.ar(snd);
    LocalOut.ar(snd);
    snd = DelayC.ar(snd, 0.1, SinOsc.kr(2, [0, 1pi]).range(0, 1e-4));
    // uncomment for reverb 3.10
    snd = snd + (GVerb.ar(snd, 1) * -5.dbamp);
    snd * -20.dbamp * 0.1;
}.scope(fadeTime: 0);
)


///////////


(
{
    var snd, string, delay;
    string = { |freq|
        var delay;
        delay = freq.reciprocal;
        Pluck.ar(SinOsc.ar(Line.ar(1000, 50, 0.01)) * Env.perc(0.001, 0.01).ar, Impulse.ar(0), delay, delay, 5, 0.5)
    };
    snd = string.(100) + string.(150) + string.(200);
    //snd = snd + (HPF.ar(LocalIn.ar(1), 3000) * -50.dbamp);
    //snd = (snd * 32.dbamp).tanh;
    //snd = RLPF.ar(snd, 3000, 0.5);
    //snd = (snd * 32.dbamp).tanh;
    //snd = RLPF.ar(snd, 500, 0.5);
    //snd = (snd * 32.dbamp).tanh;
    //snd = BHiShelf.ar(snd, 3200, 1, -3.0);
    //snd = LeakDC.ar(snd);
    //LocalOut.ar(snd);
    //snd = DelayC.ar(snd, 0.1, SinOsc.kr(2, [0, 1pi]).range(0, 1e-4));
    //// uncomment for reverb 3.10
    //snd = snd + (GVerb.ar(snd, 1) * -5.dbamp);
    snd * -20.dbamp * 0.1;
}.scope(fadeTime: 0);
)

(
SynthDef(\guitamp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
    sig = sig + (HPF.ar(LocalIn.ar(1), 3000) * -50.dbamp * \fb.kr(1));
    sig = (sig * 32.dbamp).tanh;
    sig = RLPF.ar(sig, 3000, 0.5);
    sig = (sig * 32.dbamp).tanh;
    sig = RLPF.ar(sig, 500, 0.5);
    sig = (sig * 32.dbamp).tanh;
    sig = BHiShelf.ar(sig, 3200, 1, -3.0);
    sig = RLPF.ar(sig, \lpf.kr(500), 0.5);
    sig = LeakDC.ar(sig);
    LocalOut.ar(sig);
    sig = DelayC.ar(sig, 0.1, SinOsc.kr(2, [0, 1pi]).range(0, 1e-4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1) * 0.05;
	Out.ar(out, sig);
}).add;
SynthDef(\guit, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var delay;
	delay = freq.reciprocal;
	sig = Pluck.ar(SinOsc.ar(Line.ar(1000, 50, 0.01)) * Env.perc(0.001, 0.01).ar, Impulse.ar(0), delay, delay, \decay.kr(1), 0.5);
	FreeSelf.kr(DetectSilence.ar(sig));
	//sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:0);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

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
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 0,0,1,0,
				1,0,1,0, 1,1,0,1,
				1,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 0.1 * Pseq([1,0.7],inf).stutter(2),
			\dur, 1/8,
		)),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \guit,
			\note, Pseq([
				[0,3,7,0+12],
				[0,3,7,0+12]+2,
				[0,3,7,0+12]+4,
				[0,3,7,0+12]+6,
			],inf),
			\octave, 3,
			//\freq, [100,150,200],
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\strum, 0.01 * Pseg(Pseq([5,20],inf),9),
			\decay, 1/1,
			\amp, 0.1/10 * Pseq([
				1,0.5,Pwhite(0.1,5.3,1),
			],inf),
			\out, BusDef(\gg, \audio),
		),
		Pmono(\guitamp,
			\inbus, BusDef(\gg, \audio),
			\fb, 1.0000,
			\lpf, ~pmodenv.(Pseq([1000,9000],inf), 1),
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
)
