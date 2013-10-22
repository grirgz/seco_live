(
Ndef(~name+++\fx, { arg freq=4, amp=1;
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var lfo;
	sig = in;
	//sig = sig * SinOsc.ar(4*t).range(0,1);
	lfo = LFCub.ar(freq*t).range(0,1);
	lfo = LFSaw.ar(freq*t).range(0,1);
	lfo = SinOsc.ar(freq*t).range(0,1);
	sig2 = RLPF.ar(sig, lfo*5000+400,0.3);
	sig = RLPF.ar(sig, lfo*100+400,0.3);
	sig2 = (sig2*2).distort;
	sig = Select.ar(freq >= 8,[
		//sig + FreqShift.ar(sig, SinOsc.kr(freq*t/2).range(0,1)*250-700),
		sig2,
		sig
	]);
	sig = SelectX.ar((freq <= 0).lag(0.1),[
		sig,
		Silent.ar,
	]);
	sig = sig * amp;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\freq, Pseq([
		4,0,4,4, 4,16,4,4,
		0,4,4,0, 4,16,4,8,
		4,4,8,8, 4,16,4,4,
		4,8,4,0, 4,16,4,4,
		//2,8,4,2, 2,8,4,0,
		//2,8,4,2, 2,8,4,0,
	],inf),
	\amp, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
	],inf),
	\dur, 1/4,
));

Ndef(~name+++\lfo1, { SinOsc.kr(0.1).range(500,9000)  });
Ndef(~name+++\lfo2, { SinOsc.kr(t/2).range(50,5900)  });
Pdef(~name +++ \pre, Pbind(
	//\degree, Pseq([0,4,2,2],inf),
	//\mtranspose, Pstep(Pseq([0,2],inf),4),
	//\root, -4,
	//Pseq([100,60],4),
	//Pseq([070,50],4),

		//Pseq([070,50],4),
		//Pseq([100,60],4),
		//Pseq([040,60],4),
		//Pseq([090,45],4),
	\freq, Pseq([070,40],inf) * 4,
	\freq2, Pseq([50,60],inf) * 4,
	\freq3, Pkey(\freq)*(1/4),
	//\isRest, Veco(~namex).isrest(16),
	\legato, 1.01,
	\ffreq, Ndef(~name+++\lfo2),
	\cutoff, Ndef(~name+++\lfo1),
	\amp, 0.4 * Pkey(\amp),
	\dur, 4,
));
)
// END

Ndef(~name+++\fx).quant=4;

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\freq, Pseq([
		4,0,4,4, 4,16,4,4,
		0,4,4,0, 4,16,4,8,
		4,4,8,8, 4,16,4,4,
		4,8,4,0, 4,16,4,4,
		//2,8,4,2, 2,8,4,0,
		//2,8,4,2, 2,8,4,0,
	],inf),
	\amp, Pseq([
		1,1,1,1, 1,1,1,1,
		1,1,1,1, 1,1,1,1,
	],inf),
	\dur, 1/4,
));

Ndef(~name+++\fx, { arg freq=4, amp=1;
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	sig = in;
	//sig = sig * SinOsc.ar(4*t).range(0,1);
	sig = sig * LFCub.ar(freq*t).range(0,1);
	sig2 = (sig*2).distort;
	sig2 = RLPF.ar(sig2, 100*freq.lag(0.1)+100,0.3);
	sig = Select.ar(freq >= 8,[
		//sig + FreqShift.ar(sig, SinOsc.kr(freq*t/2).range(0,1)*250-700),
		sig2,
		sig
	]);
	sig = SelectX.ar((freq <= 0).lag(0.1),[
		sig,
		Silent.ar,
	]);
	sig = sig * amp;
	sig;
});
