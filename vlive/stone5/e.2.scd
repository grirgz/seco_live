BusDef(~name+++\fx, \audio);
(
Ndef(~name+++\fx, { arg ffreq, rq=0.3;
	var in, sig;
	var seq;
	var sfreq;
	var ffreq2;
	in = InFeedback.ar(BusDef(~name+++\fx),2);
	sig = in;
	sig = sig + DelayL.ar(sig, 0.1,0.1 * SinOsc.ar(418).range(1,1.01));
	sig = sig + DelayL.ar(sig, 0.1,0.1 * SinOsc.ar(18).range(1,1.01));
	sig = sig + DelayL.ar(sig, 0.1,0.01);
	//Out.ar(BusDef(~name+++\fx), sig * 0.9);
	//sig = Splay.ar(sig, 0.8+SinOsc.kr(1).range(0,1));
	sig;

});
);

Ndef(~name+++\fx).fadeTime = Pdef.defaultQuant * 2;
Ndef(~name+++\fx).play;

(

Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.3,0.4)  });
Ndef(~name+++\lfo2, { SinOsc.kr([0.1,0.01,0.15]).range(0.8,1.09).sum/3;  });
Pdef(~name +++ \pre, Pbind(
	//\pitch_stretch, Pseq([0.4,0.3]+0.5,inf).stutter(3),
	//\pitch_stretch, Ndef(~name+++\lfo2),
	\pitch_stretch, Pseq([3.9,4.1,2.1]/5,inf).stutter(3),
	\pitch_stretch, 1.77,
	\time_stretch, Pseq([0.03,8.03],inf).stutter(3),
	\time_stretch, Pseq([1.03],inf).stutter(3),
	\time_stretch, Pseq([0.03],inf).stutter(3),
	\time_stretch, 1 * Pseg(Pseq([1,0.82],inf),8),
	\randrate, 0,
	\randframes, 0,
	\out, 0,
	\out, BusDef(~name+++\fx),
	//\pos, Ndef(~name+++\lfo1),
	\pos, Pseq([0,0.3,0.32,0.12]+0.23,inf),
	\pos, 0.71 + Pseq([0,0.1],inf),
	\pos, 0.2 + Pseg(Pseq([0,0.1],inf),8),
	\adsr, Pseq([
		[ Env.adsr(0.001,0.1,0.8,0.1) ],
		//[ Env.adsr(0.3,0.3,0.4,0.1) ],
	],inf),
	\isRest, false,
	\legato, 0.8,
	\dur, 1/8,
	\amp, 0.151,
	\freq, 100,
));
);

// END

