
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
			( t * freqfac * [1,1.03,1.02] ) //| (t  / 64 & (t >> 2))
			//| (t  * 64 & (t >> 2))
			//t * 40
			//t * 40
			//t * freqfac 
			//| ( (t * [10,9]) & (t >> [8,9]) )
			//( t * 10 ) & (t >> 2)
			//((t * 5) & (t >> [3, 4])) |
			//((t * 2) & (t >> 9)) |
			//((t * 8) & (t >> 11))
			//- 3 % 256
		) & 256
		, 20
	) * 0.05;
	//sig = sig * SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.04)),gate,doneAction:2);
	//sig = RLPF.ar(sig, ffreq, 0.3);
	sig = BPF.ar(sig, ffreq, 0.3);
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
	\xbus, BusDef(~name+++\xbus),
	\ffreq, Place([100,200,300,[100,200,400,800]],inf) + Place([560,700,300,[1500,5300]],inf).stutter(4),
	\freqfac, Pseq([0,0,0,0],inf)+70.3,
	\isRest2, Pseq([1,0.5,1,0.5],inf).coin,
	\isRest1, Veco(~namex).isrest(16),
	\isRest, Plazy({ arg ev;  ev[\isRest1] and: ev[\isRest2] }).loop,
	\dur, 1/8,
	//\amp, Pkey(\amp) //* 0.32,

));
);
