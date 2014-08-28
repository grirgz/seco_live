
(
SynthDef(\acidstab, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lfo1;
	lfo1 = EnvGen.ar(Env.adsr(0,[0.9,1],0,1),gate,doneAction:0);
	sig = LFSaw.ar(freq * [1,1.001,1.0001,0.99]);
	sig = RLPF.ar(sig, [5110,4000] * lfo1, 0.1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \acidstab,
	\degree, Pseq([0,1,3,6],inf),
	\octave, Pseq([3,5],inf).stutter(4),
	\dur, Pseq([1,1/4,1/8,1/8],inf),
	\amp, 0.1
)).play;
);

(
SynthDef(\cutoff, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, cut=1000, rq=0.5;
	var sig;
	var lfo1;
	sig = LFSaw.ar(freq * [1,1.001,1.0001,0.99]);
	//sig = LFSaw.ar(freq);
	sig = BPF.ar(sig, cut * freq, rq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.7)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, Pbind(
	\instrument, \cutoff,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([1000,100,10000,300], [1,1,1,1]/4).circle).lag(0.1) }),
	\cut, Ndef(\lfo1, { EnvGen.kr(Env([100,50,20,60]/50 / 2, [1,1,1,1]/4).circle).lag(0.1) }),
	\degree, Pseq([0,2,4,2],inf),
	\rq, 0.7,
	\mtranspose, Pstep(Pseq([0,3,4,3],inf),2),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\legato, 0.5,
	\octave, Pseq([3],inf).stutter(4),
	\dur, Pseq([1/8],inf),
	\amp, 0.4
)).play;

Pdef(\string, Pbind(
	\instrument, \cutoff,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([1000,100,10000,300], [1,1,1,1]/4).circle).lag(0.1) }),
	\cut, Ndef(\lfo1, { EnvGen.kr(Env([100,50,20,60]/50, [1,1,1,1]/2).circle).lag(0.1) }),
	\degree, Pseq([0,3,4,3],inf) + [0,2,4],
	\octave, Pseq([6],inf).stutter(4),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.7) ],
	],inf),
	\legato, 1,
	\dur, Pseq([2],inf),
	\amp, 0.1
)).play;
);



(
SynthDef(\detune, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, cut=1, rq=0.5, det=0.1;
	var sig;
	var lfo1;
	sig = LFSaw.ar(freq * LFNoise1.kr([1,1.001,1.0001,0.99]).range(1-det,1+det));
	//sig = LFSaw.ar(freq);
	//sig = RLPF.ar(sig, cut * freq, rq);
	sig = SVF.ar(sig, cut * freq, rq, lowpass:1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.7)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, Pbind(
	\instrument, \detune,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([1000,100,10000,300], [1,1,1,1]/4).circle).lag(0.1) }),
	\cut, Ndef(\lfo1, { EnvGen.kr(Env([100,50,20,60]/50 * 2, [1,1,1,1]).circle).lag(0.1) }),
	//\cut, 4,
	\degree, Pseq([0,1,3,2],inf),
	\scale, Scale.minor,
	\rq, 0.2,
	\det, Pseq([0.7,0.07],inf),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\legato, 1.0,
	\octave, Pseq([5],inf).stutter(4),
	\dur, Pseq([1],inf),
	\amp, 0.4
)).play;
)


(
SynthDef(\electricity, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, cut=1000, rq=0.5, det=0.1;
	var sig;
	var lfo1, lfo2;
	lfo1 = SinOsc.kr(1/4).unipolar * 0.5;
	lfo2 = LFNoise1.kr(1/2).unipolar;
	sig = LFPulse.ar(freq * [1,1.001,1.0001,0.99,0.5,0.25,2]);
	sig = sig + LFSaw.ar(freq * [1,1.001,1.0001,0.99,0.5,0.25,2]);
	//sig = LFSaw.ar(freq);
	sig = RHPF.ar(sig, (lfo1 + lfo2) * cut + 0.51 * freq, rq);
	//sig = SVF.ar(sig, cut * freq, rq, lowpass:1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.7)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, Pbind(
	\instrument, \electricity,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([1000,100,10000,300], [1,1,1,1]/4).circle).lag(0.1) }),
	\cut, 1.02,
	\cut, Ndef(\lfo1, { EnvGen.kr(Env([100,50,20,60]/50 * 2, [1,1,1,1]/8).circle).lag(0.1) }),
	//\cut, 4,
	\degree, Pseq([0,1,3,2],inf),
	\scale, Scale.minor,
	\rq, 0.7,
	\det, Pseq([0.7,0.07],inf),
	\adsr, Pseq([
		[ Env.adsr(1.1,0.1,0.8,1.1) ],
	],inf),
	\legato, 0.7,
	\octave, Pseq([3,4],inf).stutter(1),
	\dur, Pseq([2],inf),
	\amp, 0.1
)).play;
)

(
SynthDef(\motion, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, cut=1000, rq=0.5, det=0.1;
	var sig;
	var lfo1, lfo2;
	var env1;
	//lfo1 = SinOsc.kr(1 * XLine.kr(0.01,32,1/2)).unipolar;
	env1 = EnvGen.ar(Env.adsr(0.4,0.1,0.1,1.1),gate,doneAction:0);
	lfo1 = SinOsc.kr(1 * env1 * 44).unipolar;
	//lfo2 = LFNoise1.kr(1/2).unipolar;
	sig = LFTri.ar(freq * [1,1.001,1.0001,0.99,0.5,0.25,2]);
	//sig = sig + LFSaw.ar(freq * [1,1.001,1.0001,0.99,0.5,0.25,2]);
	//sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, lfo1 * cut + 0.51 * freq, rq);
	//sig = SVF.ar(sig, cut * freq, rq, lowpass:1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.7)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, Pbind(
	\instrument, \motion,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([1000,100,10000,300], [1,1,1,1]/4).circle).lag(0.1) }),
	\cut, 1.02,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([100,50,20,60]/50 * 2, [1,1,1,1]/8).circle).lag(0.1) }),
	//\cut, 4,
	\degree, Pseq([0,1,3,2],inf),
	\scale, Scale.minor,
	\rq, 0.7,
	\det, Pseq([0.7,0.07],inf),
	\adsr, Pseq([
		[ Env.adsr(1.1,0.1,0.8,1.1) ],
	],inf),
	\legato, 0.7,
	\octave, Pseq([3,4,5],inf).stutter(1),
	\dur, Pseq([2,1/4],inf).stutter(1),
	\amp, 0.1
)).play;
)

(
SynthDef(\motion, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, cut=1000, rq=0.5, det=0.1;
	var sig;
	var sig1, sig2, sig3;
	var lfo1, lfo2;
	var env1;
	//lfo1 = SinOsc.kr(1 * XLine.kr(0.01,32,1/2)).unipolar;
	env1 = EnvGen.ar(Env.adsr(0.4,[2,4/5,1,0.5],0.7,1.1),gate,doneAction:0);
	lfo1 = LFSaw.kr(1 * env1 * 4).unipolar;
	//lfo2 = LFNoise1.kr(1/2).unipolar;
	sig = LFTri.ar(freq * [1,1.001,1.0001,0.99,0.5,0.25,2]);
	sig = sig + LFSaw.ar(freq * [1,1.001,1.0001,0.99,0.5,0.25,2] + (lfo1 * freq /4));
	//sig = LFSaw.ar(freq);
	sig1 = sig.wrap2(1.5 * lfo1 + 0.5);
	sig = RLPF.ar(sig, lfo1 * cut + 0.51 * freq, rq);
	sig2 = sig.fold2(1.5 * env1 + 0.5);
	sig = [sig, sig1, sig2].lace;
	//sig = SVF.ar(sig, cut * freq, rq, lowpass:1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.7)),gate,doneAction:2);
	sig.postln;
	sig = AllpassL.ar(sig, 0.1,0.001,0.0) + sig;
	sig = sig / 3;
	sig = Pan2.ar(sig, (0..sig.size-1)/4-0.5 * LFNoise1.kr(1!sig.size), amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, Pbind(
	\instrument, \motion,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([1000,100,10000,300], [1,1,1,1]/4).circle).lag(0.1) }),
	\cut, 1.02,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([100,50,20,60]/50 * 2, [1,1,1,1]/8).circle).lag(0.1) }),
	//\cut, 4,
	\degree, Pseq([0,-3],inf) + [0,3b,9],
	\scale, Scale.minor,
	\rq, 0.7,
	\det, Pseq([0.7,0.07],inf),
	\adsr, Pseq([
		[ Env.adsr(1.1,0.1,0.8,2.1) ],
	],inf),
	\legato, 0.7,
	\octave, Pseq([3,4,5],inf).stutter(1),
	\octave, Pseq([6],inf).stutter(1),
	\dur, Pseq([2,1/4],inf).stutter(2),
	\dur, 4,
	\amp, 0.1
)).play;
)

(
SynthDef(\motion, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, cut=1000, rq=0.5, det=0.1;
	var sig;
	var sig1, sig2, sig3;
	var lfo1, lfo2;
	var env1;
	//lfo1 = SinOsc.kr(1 * XLine.kr(0.01,32,1/2)).unipolar;
	env1 = EnvGen.ar(Env.adsr(0.4,[2,4/5,1,0.5],0.7,1.1),gate,doneAction:0);
	lfo1 = LFSaw.kr(1 * env1 * 4).unipolar;
	//lfo2 = LFNoise1.kr(1/2).unipolar;
	sig = LFPulse.ar(freq * [1,1.001,1.0001,0.99,0.5,0.25,2]);
	sig = sig + LFSaw.ar(freq * [1,1.001,1.0001,0.99,0.5,0.25,2] + (lfo1 * freq /4));
	sig = Klank.ar(Ref([[1.041,2.020,4.020,0.5211], 0.01,0.1]), sig, freq) + sig;
	//sig = LFSaw.ar(freq);
	sig1 = sig.wrap2(0.5 * lfo1 + 0.1);
	sig = RLPF.ar(sig, lfo1 * cut + 0.51 * freq, rq);
	sig2 = sig.fold2(0.5 * env1 + 0.1);
	sig = [sig, sig1, sig2].lace;
	//sig = SVF.ar(sig, cut * freq, rq, lowpass:1);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.7)),gate,doneAction:2);
	sig.postln;
	//sig = AllpassL.ar(sig, 0.1,0.001,0.0) + sig;
	sig = sig / 9;
	sig = Pan2.ar(sig, (0..sig.size-1)/4-0.5 * LFNoise1.kr(1!sig.size), amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, PmonoArtic(\motion,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([1000,100,10000,300], [1,1,1,1]/4).circle).lag(0.1) }),
	\cut, 1.02,
	//\cut, Ndef(\lfo1, { EnvGen.kr(Env([100,50,20,60]/50 * 2, [1,1,1,1]/8).circle).lag(0.1) }),
	//\cut, 4,
	\degree, Pseq([0,-3],inf) + [0],
	\mtranspose, Pstep(Pseq([0,2,-6,-1],inf),2),
	\scale, Scale.minor,
	\rq, 0.7,
	\det, Pseq([0.7,0.07],inf),
	\adsr, Pseq([
		[ Env.adsr(1.1,0.1,0.8,0.1) ],
	],inf),
	\legato, Pseq([1,1,1,1, 1,1,1,0.9],inf),
	\octave, Pseq([3,4,5],inf).stutter(1),
	\octave, Pseq([6],inf).stutter(1),
	\dur, 4,
	\dur, Pseq([1/4],inf).stutter(2),
	\amp, 0.1
)).play;
)
