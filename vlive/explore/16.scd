
(
SynthDef(\yap, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [0,4,7].midiratio) *.t LFCub.ar(freq * [0,4,7].midiratio * SinOsc.kr(1/15).range(1.1,1));
	sig = SelectX.ar( \mix.kr(1), [sig, sig.flop] );
	sig = sig.sum;
	//sig = sig.fold2((1..8)+1/14);
	sig = SelectX.ar( \mix2.kr(1), [sig, sig.flop] );
	sig = sig.sum;
	sig = RLPF.ar(sig, \lpf.kr(1100), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	sig = LeakDC.ar(sig);
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\yap, Pbind(
	\instrument, \yap,
	\mix, Ndef(\lfo1, { SinOsc.kr(1/14).range(0,1) }),
	\mix2, Ndef(\lfo2, { SinOsc.kr(2/19).range(0,1) }),
	\mix2, 0,
	\degree, Pseq([10],inf),
	\octave, 3,
	\dur, 8,
	\amp, 0.1
)).play;
);


(
Ndef(\fer, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar( SinOsc.ar(1/23).range(0,1) , [sig1, sig2, sig3]);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\fer, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq * Array.series(8, 1, \delta.kr(0.1)));
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0) * 0.2} ! sig.size, amp).flop;
}).play;
);

(
Ndef(\fer, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq * Array.geom(8, 1, \fac.kr(1.01)));
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0) * 0.2} ! sig.size, amp).flop;
}).play;
);

(
Ndef(\fer, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq * Array.geom(8, 1, 1+\delta.kr(1.01)));
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0) * 0.2} ! sig.size, amp).flop;
}).play;
);

Ndef(\fer).edit
