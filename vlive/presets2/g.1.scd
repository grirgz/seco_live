(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\bomb),
		\amp, 25 * Pkey(\amp) * 0.4,
		\time_stretch, Pwhite(0.0,0.01) + Pkey(\time_stretch),
		\pitch_stretch, Pwhite(0.0,0.11) + Pkey(\pitch_stretch),
		\pitch_stretch, Pseq([1,2**(-2/12)],inf).stutter(4)* Pkey(\pitch_stretch),
		\isRest, Pseq([0,0,1,0],inf).coin.not,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 4,
	//\lag, 1/t,
	\dur, 2,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play
2**(-1/12)

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1, spread=0.8, freqA=100, freqB=100, freqC=100, ampB=1, ampC=1;
	var sig, sig1, sig2;
	var isig;
	isig = LocalIn.ar(4);
	isig = DelayC.ar(isig, 0.1,0.1) + isig;
	//sig = SinOsc.ar(freqA, SinOsc.ar([freqA*2,freqB,freqC,freqC*3,isig], SinOsc.ar(freqC * [1,1.0001,1.001])*ampC)*ampB);
	sig1 = SinOsc.ar(freqA*[1,1.01,1.001,2,3,3.03,1.5], SinOsc.ar(isig.range(1,freqB), SinOsc.ar(freqC * [1,1.0001,1.001])*ampC)*ampB);
	sig2 = SinOsc.ar(freqA * [1/7,2/7,3/7], SinOsc.ar(isig.range(1,freqB), SinOsc.ar(freqC * [1,1.0001,1.001] * LFNoise1.kr([1,1/2,1/8]).range(0.8,1))*ampC)*ampB);
	sig = sig1 + sig2;
	//sig = SinOscFB.ar(freqA, isig) * sig;
	sig = RLPF.ar(sig, \ffreq.kr(1000), \rq.kr(0.1));
	sig = DelayC.ar(sig, 0.1,0.1* [1,1.001,1.00001] * SinOsc.kr(100).range(0,0.05)) + sig;
	//sig = SinOsc.ar(freqA, SinOsc.ar(freqB, SinOsc.ar(sig * [1,1.0001,1.001])*ampC)*ampB) * sig;
	//sig = SinOsc.ar(freqB, SinOsc.ar(freqA, SinOsc.ar(sig * [1,1.0001,1.001])*ampC)*ampB) * sig;
	sig.postln;
	LocalOut.ar(sig);
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
);
Ndef(\plop).edit
