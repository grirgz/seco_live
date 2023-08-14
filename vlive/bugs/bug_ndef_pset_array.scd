(
Ndef(\drone1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Ndef(\drone1).put(10, \pset -> Pbind(
	\freq, Pseq([100,200,400,300,302],inf).stutter(1),
	\dur, Pseq([2,2,2,1,1],inf).stutter(1),
))
)

//////
// trigger bug

(
Ndef(\drone1).quant = 1;
~t = 199/4/60; TempoClock.default.tempo = ~t;
)

(
Ndef(\drone1, { arg freq=300, pan=0, amp=0.1;
	var sig;
	freq = \chord.kr([0,3,7,10]).midiratio *.x [1/3,1/2,1,2,3] * freq;
	freq.debug;
	freq.size.debug;
	sig = SinOsc.ar(freq * ( LFNoise1.ar(38 * LFNoise1.ar(1/10)) * 0.4 * Demand.ar(Impulse.ar(10)!freq.size, 0, Dwrand([0.01,0.1,1,10],[15.1,2,1,0.4].normalizeSum,inf)).lag(0.01) + 1 ));
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, ( sig*413 ).tanh/6]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, FreqShift.ar(sig, LFNoise1.kr(1/2).range(-100.0,100.0))]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, sig * ( LFNoise1.ar(1!freq.size).unipolar.pow(4) * 1 + 0 )]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig * ( SinOsc.ar(freq) * 10 + 1 )]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig + DelayL.ar(sig, 0.1, LFNoise1.ar(1!freq.size).unipolar*0.1 )]);
	sig.debug;
	sig.size.debug;
	sig = sig * ( \chordamp.kr([ 1,1,1,1 ]) *.x \octamp.kr([1,1,1,1,1]) );
	sig = Pan2.ar(sig, LFNoise1.kr(4!freq.size).range(-0.5,0.5).pow(33) + LFNoise1.kr(1/2!freq.size).range(-1.0,1.0), amp).mean;
	sig.debug;
	sig.size.debug;
	sig = CombL.ar(sig, 1/~t, 1/8/~t,1/~t)*0.4 + sig;
	sig.debug;
	sig.size.debug;
	sig * 2;
}).play;
);

(
Ndef(\drone1).put(10, \pset -> Pbind(
	\freq, Pseq([100,200,400,300,302],inf).stutter(2),
	\chord, Pseq([
		[0,3,7,12],
		[0,3,7,11],
		[0,2,3,5],
		[0,2,7,15],
	],inf),
	\dur, Pseq([2,2,2,1,1],inf).stutter(2)*2,
))
)

// simplify

(
Ndef(\drone1).quant = 1;
~t = 199/4/60; TempoClock.default.tempo = ~t;
)

(
Ndef(\drone1, { arg freq=300, pan=0, amp=0.1;
	var sig;
	freq = \chord.kr([0,3]).midiratio *.x [1] * freq;
	freq.debug;
	freq.size.debug;
	sig = SinOsc.ar(freq * ( LFNoise1.ar(38 * LFNoise1.ar(1/10)) * 0.4 * Demand.ar(Impulse.ar(10)!freq.size, 0, Dwrand([0.01,0.1,1,10],[15.1,2,1,0.4].normalizeSum,inf)).lag(0.01) + 1 ));
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, ( sig*413 ).tanh/6]);
	//sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, FreqShift.ar(sig, LFNoise1.kr(1/2).range(-100.0,100.0))]);
	//sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, sig * ( LFNoise1.ar(1!freq.size).unipolar.pow(4) * 1 + 0 )]);
	//sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig * ( SinOsc.ar(freq) * 10 + 1 )]);
	//sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig + DelayL.ar(sig, 0.1, LFNoise1.ar(1!freq.size).unipolar*0.1 )]);
	sig.debug;
	sig.size.debug;
	//sig = sig * ( \chordamp.kr([ 1,1,1,1 ]) *.x \octamp.kr([1,1,1,1,1]) );
	sig = Pan2.ar(sig, LFNoise1.kr(4!freq.size).range(-0.5,0.5).pow(33) + LFNoise1.kr(1/2!freq.size).range(-1.0,1.0), amp).mean;
	sig.debug;
	sig.size.debug;
	//sig = CombL.ar(sig, 1/~t, 1/8/~t,1/~t)*0.4 + sig;
	sig.debug;
	sig.size.debug;
	sig * 2;
}).play;
);

(
Ndef(\drone1).put(10, \pset -> Pbind(
	\freq, Pseq([100,200,400,300,302],inf),
	//\chord, Pseq([
		//[0,3,7,12],
		//[0,3,7,11],
		//[0,2,3,5],
		//[0,2,7,15],
	//],inf),
	\dur, Pseq([2,2,2,1,1],inf),
))
)

////////// problem with arrays args!!

(
Ndef(\drone1).quant = 1;
~t = 199/4/60; TempoClock.default.tempo = ~t;
)

(
Ndef(\drone1, { arg freq=300, pan=0, amp=0.1;
	var sig;
	freq = \chord.kr([0,3,7,10]).poll.midiratio *.x [1/3,1/2,1,2,3] * freq;
	freq.debug;
	freq.size.debug;
	sig = SinOsc.ar(freq * ( LFNoise1.ar(38 * LFNoise1.ar(1/10)) * 0.4 * Demand.ar(Impulse.ar(10)!freq.size, 0, Dwrand([0.01,0.1,1,10],[15.1,2,1,0.4].normalizeSum,inf)).lag(0.01) + 1 ));
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, ( sig*413 ).tanh/6]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, FreqShift.ar(sig, LFNoise1.kr(1/2).range(-100.0,100.0))]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(23) + LFNoise1.kr(1/3!freq.size).unipolar.pow(13), [sig, sig * ( LFNoise1.ar(1!freq.size).unipolar.pow(4) * 1 + 0 )]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig * ( SinOsc.ar(freq) * 10 + 1 )]);
	sig = SelectX.ar( LFNoise1.kr(13!freq.size).unipolar.pow(43) + LFNoise1.kr(1/3!freq.size).unipolar.pow(33), [sig, sig + DelayL.ar(sig, 0.1, LFNoise1.ar(1!freq.size).unipolar*0.1 )]);
	sig.debug;
	sig.size.debug;
	sig = sig * ( \chordamp.kr([ 1,1,1,1 ]) *.x \octamp.kr([1,1,1,1,1]) );
	sig = Pan2.ar(sig, LFNoise1.kr(4!freq.size).range(-0.5,0.5).pow(33) + LFNoise1.kr(1/2!freq.size).range(-1.0,1.0), amp).mean;
	sig.debug;
	sig.size.debug;
	sig = CombL.ar(sig, 1/~t, 1/8/~t,1/~t)*0.4 + sig;
	sig.debug;
	sig.size.debug;
	sig * 2;
}).play;
);
Ndef(\drone1).edit

(
	// strange args in ndef editor
	// bug: should work
Ndef(\drone1).put(10, \pset -> Pbind(
	\freq, Pseq([100,200,400,300,302],inf).stutter(2),
	\chord, Pseq([
		[ [0,3,7,12] ],
		[ [0,3,7,11] ],
		[ [0,2,3,5] ],
		[ [0,2,7,15] ],
	],inf),
	\dur, Pseq([2,2,2,1,1],inf).stutter(2)*2,
))
)

(
	// strange args in ndef editor + chord not set correctly
Ndef(\drone1).put(10, \pset -> Pbind(
	\freq, Pseq([100,200,400,300,302],inf).stutter(2),
	\chord, Pseq([
		[0,3,7,12],
		[0,3,7,11],
		[0,2,3,5],
		[0,2,7,15],
	],inf),
	\dur, Pseq([2,2,2,1,1],inf).stutter(2)*2,
))
)

(
	// OK!!!
Ndef(\drone1).put(10, \set -> Pbind(
	\freq, Pseq([100,200,400,300,302],inf).stutter(2),
	\chord, Pseq([
		[ [0,3,7,12] ],
		[ [0,3,7,11] ],
		[ [0,2,3,5] ],
		[ [0,2,7,15] ],
	],inf),
	\dur, Pseq([2,2,2,1,1],inf).stutter(2)*2,
))
)

(
	// chord not set correctly
Ndef(\drone1).put(10, \set -> Pbind(
	\freq, Pseq([100,200,400,300,302],inf).stutter(2),
	\chord, Pseq([
		[0,3,7,12],
		[0,3,7,11],
		[0,2,3,5],
		[0,2,7,15],
	],inf),
	\dur, Pseq([2,2,2,1,1],inf).stutter(2)*2,
))
)

Ndef(\drone1).clear



