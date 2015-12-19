


(
Ndef(\plop2, { arg freq=700, pan=0, amp=0.1;
	var sig;
	var igate;
	igate = Impulse.kr(1);
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), igate);
	sig = sig * 5;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([10,9],inf),
	\legato, 0.1,
	\sustain, 0.05,
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\bla, 
	Pspawner({ arg sp;
		5.do {
			sp.par(Pbind(\degree, 10.rand, \dur, Pn(1,16))<> Pdef(\plop));
			1.wait;
		};
		5.do {
			sp.par(Pbind(\degree, 10.rand, \dur, Pn(1/2,16))<> Pdef(\plop));
			1.wait;
		};
		5.do {
			sp.par(Pbind(\degree, 10.rand, \dur, Pn(1/3,16))<> Pdef(\plop));
			1.wait;
		};
		5.do {
			sp.par(Pbind(\degree, 10.rand, \dur, Prand([1/3,1/2,1/4,1/8,1/6],16))<> Pdef(\plop));
			1.wait;
		};

	})

).play;
);


~ndef_as_synthdef = { arg ndef;
	
}

(
Ndef(\plop).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * LFSaw.ar(freq * SinOsc.kr(1/4).range(1.10,1)) ;
	sig = sig + LFSaw.ar(freq/2);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
(
Ndef(\plop).put(1, \filter -> { arg in;
	var sig;
	var focus;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig.debug("in");
	sig = CombL.ar([ sig ], 1/4,1 / [1,4,8,16,32],\combdec.kr(1)) + [sig];
	//sig = FreqShift.ar(sig, -500);
	//sig = sig.flop;
	sig = sig.mean;
	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.1) ) + sig;
	
		//sig4 = LocalIn.ar(2) * \fb.kr(0.5);
		//sig4.poll;
		sig = isig;
		sig1 = BPF.ar(sig, \blpf.kr(90), \brq.kr(0.002), 8);
		sig2 = BPF.ar(sig, \blpf.kr, \brq.kr, 1);
		sig = RLPF.ar(sig, \lpf.kr(700), \rq.kr(0.5));
		sig2 = FreqShift.ar(sig2, SinOsc.kr(2).range(0,100)) + sig2;
		sig2.debug("--sigx1");
		sig2 = sig2.flatten(1);
		sig2.debug("--sigx1.5");
		sig2 = Pan2.ar(sig2, SinOsc.kr(4).range(-1,1)).flop;
		sig2.debug("--sigx2");
		focus = SinOsc.kr(2).range(0,2);
		sig = SelectXFocus.ar( SinOsc.kr(1/4).range(0,sig.size-1), sig, focus);
		sig = sig + ( sig1 * 1 );
		sig.sum.debug("--sigout");
		sig = sig2 + sig;
		sig = sig.tanh;
		sig = sig / 4;
		//isig = Limiter.ar(isig);
		sig.mean;
	};
	//LocalOut.ar(sig.mean.poll);
	sig.debug("sig");
}).play;
);
Ndef(\plop).edit

(
Ndef(\plop).put(2, \filter -> { arg in;
	var sig;
	var igate;
	var seq1;
	sig = in;
	seq1 = Duty.kr(1/8/~t, 0, Dseq([
		16,4,8,4,
		8,4,8,16,
	],inf));
	seq1 = \ifreq.kr(1);
	igate = Trig1.kr(Impulse.kr(seq1), 0.04);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), igate);
}).play;
);

(
	Ndef(\plop).put(3, \set -> Pbind(
		\ifreq, Pseq([
			4,8,4,8,
			4,8,4,16,
		],inf),
	)).play;
);

(
	Ndef(\plop).put(3, \set -> Pbind(
		\ifreq, Pseq([
			16,
		],inf),
	)).play;
);
