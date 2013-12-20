~name = '2';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, index=0.8, rfreq=100, ffreq=300, rq=0.1;
	var sig, sig1, sig2, sig3;
	var rfreqtab, ross;

	rfreqtab = \rfreqtab.kr([0.1,1,1.1,2,3,4,9]);
	ross = RosslerL.ar(freq:rfreq*rfreqtab, a: 0.2, b: 7.2 * rfreqtab, c: 0.7 * rfreqtab, h: 0.25, xi: 1.1, yi: 0, zi: 0);
	ross.debug("ross");
	ffreq = SinOsc.ar(Lag.ar(ross))*ffreq*index+ffreq;
	freq = SinOsc.ar(Lag.ar(ross))*freq*index+freq;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig.flatten;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig.debug("sig1");
	sig = Splay.ar(sig, spread, amp, pan);
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);
(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest(32),
	//\sustain, 1,
	//\sustain, 0.1,
	\legato, 1,
	\dur, 1/2,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);


// END


// vary frequency - these parameters are for "one-pulse" orbit
{ RosslerL.ar(MouseX.kr(20, SampleRate.ir), 0.36, 0.35, 4.5) * 0.3 }.play(s);

// randomly modulate params
(
{ RosslerL.ar(
    SampleRate.ir, 
    0.2, // First variable tends to lead to NaN if modulated in this example
    LFNoise0.kr(1, 0.01, 0.2),
    LFNoise0.kr(1, 0.2, 0.7)
) * 0.2 }.play(s);
)

// as a frequency control
{ SinOsc.ar(Lag.ar(RosslerL.ar(MouseX.kr(1, 200)))*800+900)*0.4 }.play(s);
