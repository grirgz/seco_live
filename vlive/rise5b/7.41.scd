
(
SynthDef(~name, { arg out=0, gate=1, ffreq = 200, freqfac=15, freq=8000, amp=0.1, pan=0, spread=0.8, shift=1, toffset=0, sigmix=0.5, xbus;
	//var t = PulseCount.ar(Impulse.ar(8e3));
	var t = InFeedback.ar(xbus, 1);
	var sig;
	//out.poll;
	//freqfac.poll;
	sig = HPF.ar(
		(
			//((t * [14,15]) & (t >> 2)) | (t >> [4,8])
			//| ((t * [10,11]) & (t >> 3)) | (t >> [4,8])
			//(( t * log(freq) * 8 ) | (t >> 4)) | (t >> 2)
			//(t * (freq%[70,79])) & (t >> [4,8,12]) | (t * (freq % 4))
			( t * freqfac * [1.01,1.012,0.998] ) | (t  * 4 & (t >> shift))
			//t * 40
			//t * 40
			//t * freqfac 
			| ( (t * freqfac * [10,9]) & (t >> [8,9]) )
			//( t * 10 ) & (t >> 2)
			//((t * 5) & (t >> [3, 4])) |
			//((t * 2) & (t >> 9)) |
			//((t * 8) & (t >> 11))
			//- 3 % 256
		) & 256
		, 20
	) * 0.05;
	//sig = sig * SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.44)),gate,doneAction:2);
	sig = RLPF.ar(sig, ffreq, 0.3);
	sig = Splay.ar(sig, spread, amp, pan);
	//sig.poll;
	//sig = SinOsc.ar(100);

	Out.ar(out, sig);
}).add;
);

(
	Ndef(~name+++\xbus, { arg xbus;
		var x = PulseCount.ar(Impulse.ar(8e3));
		//x.poll;
		Out.ar(xbus, x);
	});
Ndef(~name+++\xbus).set(\xbus, BusDef(~name+++\xbus, \audio, 1));
Pdef(~name+++\pre, Pbind(
	\instrument, ~name,
	\time, Ptime(),
	\xbus, BusDef(~name+++\xbus),
	\degree, Pseq([Ptime()*2 % 10],inf),
	\adsr, Prand([
		[ Env.adsr(0.01,0.1,0.8,0.21) ],
		[ Env.adsr(0.4,0.1,0.8,0.4) ],
	],inf),
	\pan, Ptuple([Pwhite(-0.5,0.5),Pwhite(-0.5,0.5)]),
	\pan, 0,
	\ffreq, Ptuple([Pwhite(200,15000),Pwhite(200,15000)]),
	\ffreq, 15000,
	\freq, Pseq([1000,2000,1300,1500],inf).stutter(1),
	\degree, 40,
	\degree, Pseq([4,5,2,3],inf),
	\freqfac, Pseq([10,20,30],inf).stutter(4),
	\freqfac, Pseq([1,2,3,40,40,40,40,50],inf).stutter(4),
	\isRest, Plazy({
		Pseq([0.051,0.1,0.1,0.1].collect(_.coin))
	}).loop,
	\isRest, Veco(~namex).isrest(16),
	\legato, 0.8,
	\shift, Pseq([1,2,3,4],inf).stutter(8),
	//\isRest, false,
	\scale, Scale.minor,
	\octave, 3,
	\lag, Ptuple([0,0.01 + Pwhite(0,0.01)]),
	\lag, Ptuple([Prand([0,0.125,0.15,0.125,0.01,0.25],inf),Prand([0,0.125,0.15,0.125,0.01,0.25],inf)]),
	\lag, Prand([[0,1/8], [1/8,0], [0,0]],inf),
	\lag, 0,
	\dur, 1/8,
	\amp, 8.05 * Pkey(\amp),
));
);
