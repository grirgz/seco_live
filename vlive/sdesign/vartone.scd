
(
SynthDef(\vartone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	mod1 = Duty.kr(1/10, 0, Dseq([
		10,-5,0,0,-100,0,
		Dwhite(0,10.0,5)-5,
		Dwhite(-100.0,100.0,5),
	],inf));
	freq = freq * [1,1.01];
	sig1 = SinOsc.ar(freq + ( mod1 ));
	sig2 = LFSaw.ar(freq * ( sig1 * 1 + 1 ));
	sig3 = SinOsc.ar(freq * ( sig1 * 1 + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * 1 + 1 ));
	sig = sig1 + sig2 + sig3 + sig4 /3;
	sig = SelectX.ar( SinOsc.ar(1*~t).range(0,3), [sig1, sig2, sig3, sig4]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(\vartone,
			\note, Pseq([
				0,7,6,5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
)

////////

(
SynthDef(\vartone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	mod1 = Duty.kr(1/10, 0, Dseq([
		10,-5,0,0,-100,0,
		Dwhite(0,10.0,5)-5,
		Dwhite(-100.0,100.0,5),
	],inf));
	freq = freq * [1,1.01, 1/2,2, 3/4, 8/9];
	sig1 = SinOsc.ar(freq + ( mod1 ));
	sig2 = LFSaw.ar(freq * ( sig1 * 1 + 1 ));
	sig3 = SinOsc.ar(freq * ( sig1 * 1 + 1 ));
	sig4 = SinOsc.ar(freq * ( sig3 * 1 + 1 ));
	sig5 = LFSaw.ar(freq * ( sig1 * 1 + 1 ));
	sig5 = RLPF.ar(sig5, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig1 + sig2 + sig3 + sig4 /3;
	sig = SelectX.ar( SinOsc.ar([ 1/[1,2,3,1.1]/10 ]*~t).squared.range(0,4), [sig1, sig2, sig3, sig4, sig5]);
	sig = sig.flat;
	sig = sig * 1.3;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan+ SinOsc.ar(1/(1..sig.size)/9) * SinOsc.ar(1/2).range(0,1) ; 
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(\vartone,
			\note, Pseq([
				0,7,6,5,
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/2,2,4],inf), 2),
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
)
