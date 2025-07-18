
(
Ndef(\drumy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus2, \audio)), 2); 
	sig = in;
	//sig = sig + DelayC.ar(sig, 0.01, 0.0001 * [0.1235,1,0.86534]).mean/2;
	sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * \gain.kr(1);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
}).play;
);

// dub echo
// ?
(
// echo filterIn
Ndef(\echo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
	var mix;
	sig = in;
	//sig = sig + DelayC.ar(sig, 0.01, 0.0001 * [0.1235,1,0.86534]).mean/2;
	//sig = Compander.ar(sig, in, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	mix = Duty.kr(1/8/~t, 0, Dseq([
		0,1,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,1,0,
		0,0,0,0, 0,0,0,0,
	],inf));
	sig = SelectX.ar(mix, [DC.ar(0), in]);
	sig = CombL.ar(sig, 1/2/~t, 1/8/~t, 2/~t);
	sig = sig * \gain.kr(1);
	//sig = SelectX.ar(mix, [in, sig]);
	in + sig;
//}).play(BusDef(\sendbus1).index, 2);
}).play(0, 2);
);

Ndef(\verb, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
	sig =in;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig;
});

Ndef(\fx).put(50, \filter -> { arg in;
	var sig = in;
	
	sig = Greyhole.ar(sig, 
		\delay.kr(1/4),\damp.kr(0.1),\size.kr(1), \diff.kr(0.707) , \feedback.kr(0.8), \modDepth.kr(0.1), \modFreq.kr(2)
	);

	sig;
});



//////////////// FFT fx


(
	// it's some kind of lowpass multiband gate
Ndef(\localmax, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var osig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	osig = sig;
	sig = FFT(LocalBuf(2**10), sig);
	sig = PV_MagSquared(sig);
	sig = PV_LocalMax(sig, 22);
	sig = IFFT(sig) * 50;
	sig = sig * (-28.dbamp);
	sig = SelectX.ar(MouseX.kr(0,1), [osig, sig]);
	sig;
}).play;
);


////////////////////////

SynthDef(\filterfx, { arg out=0, amp=0.1, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = LPF.ar(sig, \lpf.kr(20000));
	sig = SelectX.ar(\lpmix.kr(0), [sig, sig1]);
	sig1 = HPF.ar(sig, \hpf.kr(20));
	sig = SelectX.ar(\hpmix.kr(0), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

////////////////////////////


(
SynthDef(\fmbell, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 2.6706 + 0.13) * 2 + 1; 
	sig2 = SinOsc.ar(freq * 0.9998 * sig1);
	sig3 = SinOsc.ar(freq * 2.6629 * sig1 + 2.04);
	sig4 = LFCub.ar(freq * 0.9991 * sig1 + 2.14);
	sig5 = SinOsc.ar(freq * 2.6656 * sig1 - 2);
	sig6 = SinOsc.ar(freq * 1 * sig1 + 1.84);
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0,0.5,0.5, 0.5,0.5,0.5]);
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,2.1,1,-1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + [ 0, -0.5, -0.5, 0.5, 0.5, 0], amp).sum;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\chorus, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.kr(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
//Pdef(\demo).reset;
);

Pdef(\demo).clear

(
Pdef(\demo, Pdef(\demotreb, 
	Ppar([
		Pbind(
			\instrument, \fmbell,
			\note, Pseq([
				2,9,5,-4,
			],inf),
			\octave, 4,
			\sustain, 0.1,
			\dur, 1,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		),
		Pmono(\chorus,
			\inbus, BusDef(\fx1, \audio),
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

////////////////////////////////////


// not working :(
(
SynthDef(\stutter, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, delay=0.1, mix=0, maxdelay=2;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var runtrig = Trig.kr(mix, delay);
	var bufnum = LocalBuf(SampleRate.ir*maxdelay,2);
	sig = SelectX.ar( mix, [DC.ar(0), in] );
	sig = CombC.ar(sig, maxdelay, delay, 0);
	sig = RecordBuf.ar(sig, bufnum, offset:0, recLevel:1, preLevel:0, run:mix, loop:1, trigger: mix);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * 1, Impulse.kr(1/delay), startPos: (0*BufFrames.kr(bufnum)), doneAction:0, loop: 1);
	sig = SelectX.ar( ToggleFF.kr(runtrig), [in, sig] );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;



Pdef(\demo, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, Pwhite(100.0,1000),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\stutter,
			\inbus, BusDef(\fx1, \audio),
			\mix, Pseq([
					0,0,0,0, 1,1,1,0,
			],inf),
			\delay, 1/~t,
			\freq, 200,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
)

/////////////////////////////////////////

~buf = Buffer.alloc(s, s.sampleRate * 5);

(
Ndef(\demo,{
    var trig, freq;
    var dry, snd, phase, iois;
    var cumulDelay;
    var decayFactor, lpfCutoff, numEchoes, ioiScale, ioiDecayFactor;

    // play with these!
    decayFactor = 0.75;
    lpfCutoff = 500;
    numEchoes = 16;
    ioiScale = 0.8;
    ioiDecayFactor = 0.75;

    // example input -- you can substitute other stuff here
    trig = Dust.ar(1);
    dry = Pulse.ar(100 * TIRand.ar(1, 12, trig));
    dry = dry * Decay2.ar(trig, 0.01, 0.2);

    phase = DelTapWr.ar(~buf, dry);
    iois = Array.geom(numEchoes, ioiScale, ioiDecayFactor);
    cumulDelay = iois.sum;
    (cumulDelay > ~buf.duration).if {
        Error("use a larger buffer").throw;
    };
    snd = Silent.ar;
    iois.reverse.do { |ioi|
        snd = (snd + DelTapRd.ar(~buf, phase, cumulDelay, interp: 4)) * decayFactor;
        // one-pole lowpass -- LPF was too aggressive
        snd = OnePole.ar(snd, lpfCutoff / SampleRate.ir);
        cumulDelay = cumulDelay - ioi;
    };
    snd = snd + dry;
    
    snd * 0.1!2;
}).play;

// contributors so far: Nathan Ho
)



(
	// with series instead of geom
Ndef(\demo, {
    var trig, freq;
    var dry, snd, phase, iois;
    var cumulDelay;
    var decayFactor, lpfCutoff, numEchoes, ioiScale, ioiDecayFactor;

    // play with these!
    decayFactor = 0.75;
    lpfCutoff = 5000;
    numEchoes = 16;
    ioiScale = 1;
    ioiDecayFactor = 0.75;

    // example input -- you can substitute other stuff here
    trig = Impulse.ar(4);
    dry = Pulse.ar(100 * TIRand.ar(1, 12, trig));
    dry = dry * Decay2.ar(trig, 0.01, 0.2);

    phase = DelTapWr.ar(~buf, dry);
    iois = Array.series(numEchoes, ioiScale, ioiDecayFactor).reciprocal.debug("a");
    cumulDelay = iois.sum;
    (cumulDelay > ~buf.duration).if {
        Error("use a larger buffer").throw;
    };
    snd = Silent.ar;
    iois.reverse.do { |ioi|
        snd = (snd + DelTapRd.ar(~buf, phase, cumulDelay, interp: 4)) * decayFactor;
        // one-pole lowpass -- LPF was too aggressive
        snd = OnePole.ar(snd, lpfCutoff / SampleRate.ir);
        cumulDelay = cumulDelay - ioi;
    };
    snd = snd + dry;
    
    snd * 0.1!2;
}).play;

// contributors so far: Nathan Ho
)


/////////////////////

// Source audio: simple sweep
{ Pulse.ar(XLine.kr(100, 1000, 5)) * 0.1!2 }.play;

// All you need is a varying delay.
// In this example, an 0.2s delay is switched on every other 0.2s. So every 0.2s of audio is repeated once.
(
{
    var snd = Pulse.ar(XLine.kr(100, 1000, 5));
    snd = DelayC.ar(snd, 0.2, LFPulse.ar((0.2 * 2).reciprocal) * 0.2);
    snd * 0.1!2;
}.play;
)

// More general version using Stepper instead of LFPulse. You can control the length of the repeat and the number of repeats.
(
{ |fragmentlength = 0.2, numrepeats = 3|
    var trig, reset, del, snd;
    snd = Pulse.ar(XLine.kr(100, 1000, 5));
    trig = Impulse.ar(fragmentlength.reciprocal);
    reset = Impulse.ar(0); // if we don't do this the stepper will start at 1...
    del = Stepper.ar(trig, reset, 0, numrepeats - 1) * fragmentlength;
    snd = DelayC.ar(snd, 10, del);
    snd * 0.1!2;
}.play(args: [\fragmentlength, 0.1, \numrepeats, 24]);
)

// With some enhancements, we can allow the reset counter to be out of sync.
(
{ |holdlength = 0.5, fragmentlength = 0.2|
    var reset, phase, fragment, del, snd;
    snd = Pulse.ar(XLine.kr(100, 1000, 5));

    reset = Impulse.ar(holdlength.reciprocal);
    phase = Sweep.ar(reset);
    // this is the easiest way to make an Impulse resettable? seriously?
    fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / fragmentlength % 1);
    del = Latch.ar(phase, fragment);
    snd = DelayC.ar(snd, 10, del);
    snd * 0.1!2;
}.play;
)

// Many stutter plugins let you play back the audio at a different rate.
// This is a little trickier. Speeding up 2x not as easy as adding a Sweep.ar(fragment) because otherwise you get negative delays.
// So you have to add in an extra delay equal to fragmentlength.
(
{ |holdlength = 0.5, fragmentlength = 0.2, rate = 0.5|
    var reset, phase, fragment, del, snd;
    snd = Pulse.ar(XLine.kr(100, 1000, 5));
    reset = Impulse.ar(holdlength.reciprocal);
    phase = Sweep.ar(reset);
    fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / fragmentlength % 1);
    del = Latch.ar(phase, fragment) + ((fragmentlength - Sweep.ar(fragment)) * (rate - 1));
    snd = DelayC.ar(snd, 10, del);
    snd * 0.1!2;
}.play;
)

(
~stutter = { |snd, reset, fragmentlength, rate = 1.0, maxdelay = 10|
    var phase, fragment, del;
    phase = Sweep.ar(reset);
    fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / fragmentlength % 1);
    del = Latch.ar(phase, fragment) + ((fragmentlength - Sweep.ar(fragment)) * (rate - 1));
    DelayC.ar(snd, maxdelay, del);
};
)

/*
// put this into your extensions dir to install as a pseudo-ugen
Stutter {
    *ar { |in, reset, length, rate = 1.0, maxdelay = 10|
        var phase, fragment, del;
        phase = Sweep.ar(reset);
        fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / length % 1);
        del = Latch.ar(phase, fragment) + ((length - Sweep.ar(fragment)) * (rate - 1));
        ^DelayC.ar(in, maxdelay, del);
    }
}
*/




// Next examples use this buffer
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");


// audio-rate stutter inspired by DestroyFX
(
{
    var snd, holdperiod, multiplier;
    snd = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
    holdperiod = MouseY.kr(0.01, 1.0, 1);
    multiplier = MouseX.kr(1, 20);
    snd = ~stutter.(snd, Impulse.ar(holdperiod.reciprocal), holdperiod / multiplier);
    snd * 0.3!2;
}.play;
)

// feedback loop inspired by Glitchmachines
(
{
    var in, loop, out;
    in = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
	out = (in!2*0.6) + DelayC.ar(LocalIn.ar(2), 0.3, [0.11, 0.13], 0.95);
    loop = out;
    loop = ~stutter.(loop, Impulse.kr([3.4, 5.5]), [0.1, 0.03], [0.8, 1.3]);
    loop = LPF.ar(loop, 5000);
	LocalOut.ar(loop.reverse);
    out * 0.3;
}.play;
)
)

// sequencing with Pmono
(
SynthDef(\stuttertest, {
    |out = 0, buf, t_reset = 0, fragmentlength = 0.1, amp = 0.1|
    var snd;
    snd = PlayBuf.ar(1, buf, BufRateScale.kr(buf), loop: 1);
    snd = ~stutter.(snd, t_reset, fragmentlength);
    Out.ar(out, snd * amp!2);
}).add;
)
(
Pmono(\stuttertest,
    \buf, b,
    \amp, 0.3,
    \reset, 1,
    \dur, 0.1,
    \fragmentlength, Pseq([0.01, 0.03, 0.07, 0.05, 0.06], inf)
).play;
)

// grab audio on onsets
// live performers like this because they can control the effect easily
(
{
    var snd, reset;
    snd = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
    reset = Onsets.kr(FFT(LocalBuf(512), snd), 0.5);
    snd = ~stutter.(snd, reset, 0.05);
    snd = DelayC.ar(snd, 0.2, 0.2);
    snd!2 * 0.3;
}.play;
)

// "scrambler" -- randomly samples from recent audio
// even simpler than stutter, a favorite effect of mine
(
{
    var snd;
    snd = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
    snd = DelayC.ar(snd, 1.0, LFNoise0.ar(13).range(0.0, 1.0));
    snd!2 * 0.3;
}.play;
)

///////////// adapted


(
SynthDef(\stutter, { arg out = 0, time= 0.1, mix=0, rate=1;
	var stutter = { arg sig, reset, time, rate = 1.0, maxdelay = 10;
		var phase, fragment, del;
		phase = Sweep.ar(reset);
		fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / time % 1);
		del = Latch.ar(phase, fragment) + ((time - Sweep.ar(fragment)) * (rate - 1));
		DelayC.ar(sig, maxdelay, del);
	};
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var reset;
	reset = Changed.kr(mix);
	sig = in;
	sig = stutter.(sig, reset, time, rate, \maxdelay.ir(10));
	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
)

(
Pmono(\stutter,
	\inbus, BusDef(\sendbus2, \audio),
	\mix, Pseq([
		0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0, 1,1,1,1, 0,1,1,1,
		0,1,1,1, 1,1,1,1, 0,1,1,1, 0,1,1,1,
		0,0,0,0, 0,0,0,0, 0,1,1,1, 0,0,0,0,
	],1),
	\rate, 1,
	\time, 1/Pseq([
		8,1,1,1, 8,8,4,4, 8,1,1,1, 8,8,4,4,
		1,1,1,1, 1,1,1,1, 16,8,1,1, 16,16,32,32,

	],inf)/~t,
	\dur, 1/16,
	\amp, 0.1,
).play;
)

////////////////////////////////
// infinite reverb by Eli Feldsteel

(
SynthDef(\allreverb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06), 3);
	};
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	Out.ar(out, sig);
}).add;
)

	(
	SynthDef(\allreverbf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		var fbsig;
		sig = LocalIn.ar(2) * \fb.kr(0.1);
		sig = sig + in;
		15.do {
			sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06), 3);
		};
		fbsig = sig;
		fbsig = LPF.ar(sig, \lpf.kr(1000));
		fbsig = HPF.ar(sig, \hpf.kr(100));
		sig = fbsig;
		LocalOut.ar(fbsig);
		sig = sig * EnvGen.ar(Env.adsr(0.4,0.1,0.8,0.1),gate,doneAction:2);
		sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
		Out.ar(out, sig);
	}).add;

	SynthDef(\allreverbif, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		var fbsig;
		sig = 
		sig = LocalIn.ar(2) * \fb.kr(0.1);
		sig = sig + SelectX.ar(\mix.kr(0.5), [DC.ar(0), in]);
		15.do {
			sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06), 3);
		};
		fbsig = sig;
		fbsig = LPF.ar(sig, \lpf.kr(1000));
		fbsig = HPF.ar(sig, \hpf.kr(100));
		sig = fbsig;
		LocalOut.ar(fbsig);
		sig = sig * EnvGen.ar(Env.adsr(0.4,0.1,0.8,0.1),gate,doneAction:2);
		sig = sig + in;
		Out.ar(out, sig);
	}).add;
	)


////////// nice stutter


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,1,1,1, 0,1,0,1,
			],inf),
			\rate, Pseg(Pseq([0.7,1,2],inf),1.8),
			\time, 1/16/~t,
			\time, Pstep(Pseq([1/4,1/8,1/16]/2,inf),1/4)/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
)

//////////// play with Comb and reverb


(
Ndef(\combchain, {
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
	var oin = in;
	in = in + CombC.ar(in, 2, SinOsc.ar(0.15* [0.13, 0.17]).range(0.5, 1) * [0.13, 0.17], 7);
	in = in + CombC.ar(in, 2, SinOsc.ar(0.1* [0.1, 0.15]).range(0.5, 1) * [0.1, 0.15], 7);
	in = in + CombC.ar(in, 2, [1.5, 1.0], 7);
	//in = in + GVerb.ar(in, 1);
	in = in + FreeVerb2.ar(in[0], in[1], 0.5, 1);
	in = in / 3 / 3;
	in = Compander.ar(in, in, \cpt.kr(0.2), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	in = SelectX.ar(\mix.kr(0.5), [oin, in]);
	in = in * \gain.kr(1);
	in;
}).play;
)

(
SynthDef(\sinosc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0.1,1],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) * env1 + 1));
	sig = sig * ( SinOsc.ar(freq * 4/5) * env1 + 1 );
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sinosc,
			\note, Pseq([
				0,3,2,1,
			],inf) + Pstep(Pseq([
				0,-1,-2,
			],inf),2),
			\octave, Pseq([6],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.4) ],
			],inf),
			\legato, 0.1,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		Pbind(
			\instrument, \sinosc,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\octave, Pseq([3,4,5],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,1.1,1.2,3.1) ],
			],inf),
			\legato, 0.1,
			\dur, 4,
			\amp, 0.2,
			\out, BusDef(\sendbus1, \audio),
			//\isRest, true,
		),
		
	])
)).play;
);


/////////////


	SynthDef(\reverb, {
		arg in=0, out=0, dec=4, lpf=1500;
		var sig;
		sig = In.ar(in, 2).sum;
		sig = DelayN.ar(sig, 0.03, 0.03);
		sig = CombN.ar(sig, 0.1, {Rand(0.01,0.099)}!32, dec);
		sig = SplayAz.ar(2, sig);
		sig = LPF.ar(sig, lpf);
		5.do{sig = AllpassN.ar(sig, 0.1, {Rand(0.01,0.099)}!2, 3)};
		sig = LPF.ar(sig, lpf);
		sig = LeakDC.ar(sig);
		Out.ar(out, sig);
	}).add;


////////// harmonizer

(
// from Eli Fieldsteel's book
SynthDef(\harmonizer, {
    arg in = 0, out = 0, trnsp = 0, maxdel = 0.04, amp = 0.7;
    var sig, phs, sawrate;
    sawrate = (trnsp.midiratio - 1).neg;
    sig = In.ar(in, 1);
    phs = LFSaw.ar(sawrate / maxdel).unipolar(1);
    sig = DelayL.ar(sig, maxdel, phs * maxdel);
    sig = sig * amp ! 2;
    Out.ar(out, sig);
}).add;
)

(
// removed clicks and delay independent from maxdelay
SynthDef(\harmonizer, {
    arg in = 0, out = 0, trnsp = 0, maxdel = 0.04, delay=0.04;
    var sig, phs, sawrate;
	var insig;
	var of = delay/\atf.kr(2);
	of.poll;
    sawrate = (trnsp.midiratio - 1).neg;
    sig = insig = In.ar(in, 2);
    phs = LFSaw.ar(sawrate / delay).unipolar(1);
    sig = DelayL.ar(sig, maxdel, phs * delay);
	sig = sig * EnvGen.ar(Env([0,1,1,0],[of,delay/sawrate - (of*2),of]), Impulse.ar(sawrate/delay));
	sig = SelectX.ar(\mix.kr(1), [insig, sig]);
    sig = sig * \gain.kr(1);
    Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\note, Pseq([
				//3,
				0,3,7,0,
				//Pseq((0..12)),
			],inf),
			\octave, 4,
			\dur, 1/1,
			\legato, 0.3,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\harmonizer,
			\in, BusDef(\pfx1, \audio),
			//\instrument, \harmonizer,
			\trnsp, [0,4,7]+12,
			//\trnsp, 7,
			\mix, [0,1,1],
			\gain, [0.3,1,1],
			\maxdel, 0.2,
			\atf, 4,
			\delay, PmodEnv(Pseq([0.001,0.2],1), 8*2).loop,
			\delay, 1/2/1/~t,
			\dur, 1,
		)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\note, Pseq([
				//3,
				0,3,7,0,
				//Pseq((0..12)),
			],inf),
			\octave, 5,
			\dur, 1/1,
			\legato, 0.9,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\harmonizer,
			\in, BusDef(\pfx1, \audio),
			//\instrument, \harmonizer,
			\trnsp, [0,4,7] + Pseq([1,-1,2,3,-2]*12),
			//\trnsp, 7,
			\mix, [0,1,1],
			\gain, [0.3,1,1],
			\maxdel, 0.2,
			\atf, 8,
			\delay, PmodEnv(Pseq([0.001,0.2],1), 8*2).loop,
			\delay, 1/2/1/~t * Pseq([1,1/8/2,1/4],inf),
			\dur, 4,
		)
	])
)).play;
);

///////// distortion


// CrossoverDistortion
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	//sig = SinOsc.ar(freq);
	sig = SinOsc.ar(freq * ( SinOsc.ar(12) * 1 + 1 ));
	sig = CrossoverDistortion.ar(sig, 1, 0.01);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	//sig = SinOsc.ar(freq);
	sig = SinOsc.ar(freq * ( SinOsc.ar(12) * 1 + 1 ));
	sig = InsideOut.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

///////////// kind of echo reverb chorus


(
SynthDef(\fxhall, { arg out=0, gate=1, pan=0;
	var sig;
	var num=8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = AllpassL.ar(sig, \apmaxdelay.kr(0.3),\apdelay.kr(0.3),\apdecay.kr(4)) + sig;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.3) * ( LFNoise1.kr(\noisefreq.kr(1/12)!num) * \noiseamp.kr(0.9) + 1 ));
	sig = sig.clump(2).flop.flat; // apply num/2 delay on each channel and keep order
	sig.debug("sig");
	sig = FreqShift.ar(sig, LFNoise1.kr(\fsfreq.kr(1/8)!num) * \freqshift.kr(3.5));
	sig = Splay.ar(sig, \spread.kr(0.8), 1, pan);
	sig = \wetgain.kr(1) * sig;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fxhalldist, { arg out=0, gate=1, pan=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = AllpassL.ar(sig, \apmaxdelay.kr(0.3),\apdelay.kr(0.3),\apdecay.kr(4)) + sig;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.3) * ( LFNoise1.kr(\noisefreq.kr(1/12)!num) * \noiseamp.kr(0.9) + 1 ));
	sig = sig.clump(2).flop.flat; // apply num/2 delay on each channel and keep order
	sig.debug("sig");
	sig = FreqShift.ar(sig, LFNoise1.kr(\fsfreq.kr(1/8)!num) * \freqshift.kr(3.5));
	sig = ( sig*\distamp.kr(80) * ( LFNoise1.kr(0.1!num) * 0.9 + 1 ) ).tanh * \distpostamp.kr(1/2);
	sig1 = BPF.ar(sig, ( \bpf.kr(10000*1.2)*( LFNoise1.kr(1/8!num) * \bpflfoamp.kr(0.9) + 1 ) ).clip(10,20000),0.9);
	sig = SelectX.ar(\bpfmix.kr(0.7), [sig, sig1]);
	sig = Splay.ar(sig, \spread.kr(0.8), 1, pan);
	sig = \wetgain.kr(1) * sig;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscfmpad,
			\note, Pseq([
				[0,4+12,7,12],
				[0,4+12,8,12],
				[0,5+12,9,12],
				[0,5+12,9,12]+2,
			],inf),
			\octave, 5,
			\lpadsr, Pseq([
				[ Env.adsr(5.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsr, Pseq([
				[ Env.adsr(2.1,5.1,0.1,0.1) ],
			],inf),
			\fma, 0.02,
			\dur, 2,
			\amp, 0.1/6,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhall,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pn(1,8),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhall,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\apdelay, PmodEnv(Pseq([0.01,1],1), 8*2).loop,
			\apmaxdelay, 1.01,
			\apdecay, 4.7,
			\wetgain,0.5,
			\delay, 0.51,
			//\delay, PmodEnv(Pseq([1,0.01],1), 8*2).loop,
			\noiseamp, 1,
			\noisefreq, 0.01,
			\mix, 0.7,
			\freqshift, 1,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscfmpad,
			\note, Pseq([
				[0,4+12,7,12,7+12,24],
				[0,4+12,8,12,8+12],
				[0,5+12,9,12,9+12],
				[0,5+12,9,12,9+12,24]+2,
			],inf),
			\octave, 5,
			\lpadsr, Pseq([
				[ Env.adsr(5.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsr, Pseq([
				[ Env.adsr(2.1,5.1,0.1,0.1) ],
			],inf),
			\fma, 0.02,
			\dur, 2,
			\amp, 0.1/6,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhall,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			//\apdelay, PmodEnv(Pseq([0.01,1],1), 8*2).loop,
			\apmaxdelay, 1.01,
			\apdecay, 4.7,
			\wetgain,0.5,
			\delay, 0.51,
			//\delay, PmodEnv(Pseq([1,0.01],1), 8*2).loop,
			\noiseamp, 1,
			\noisefreq, 0.01,
			\mix, 0.7,
			\freqshift, 1,
			\dur, 1,
		),
	])
)).play;
);

(
// bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhall,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			//\apdelay, PmodEnv(Pseq([0.01,1],1), 8*2).loop,
			\apmaxdelay, 1.01,
			\apdecay, 4.7,
			\wetgain,0.5,
			\delay, 0.51,
			//\delay, PmodEnv(Pseq([1,0.01],1), 8*2).loop,
			\noiseamp, 1,
			\noisefreq, 0.01,
			\mix, 0.7,
			\freqshift, 1,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,4,6,2
			],inf).stutter(8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhalldist,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			//\apdelay, PmodEnv(Pseq([0.01,1],1), 8*2).loop,
			\apmaxdelay, 1.01,
			\apdecay, 4.7,
			\wetgain,0.5,
			\delay, 0.51,
			//\delay, PmodEnv(Pseq([1,0.01],1), 8*2).loop,
			\noiseamp, 1,
			\noisefreq, 0.01,
			\mix, 0.5,
			\freqshift, 1,
			\dur, 1,
		),
	])
)).play;
);
