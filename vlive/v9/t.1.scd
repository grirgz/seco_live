BusDef(~name+++\fx, \audio);
(
Ndef(~name+++\fx, { arg ffreq, rq=0.3;
	var in, sig;
	var seq;
	var sfreq;
	in = InFeedback.ar(BusDef(~name+++\fx),2);
	sig = in;
	seq = Dseq([1,3,5,7],inf);
	seq = Dseq([1,4,8,2],inf);
	sfreq = Demand.kr(Impulse.kr(4), 0, seq);
	//ffreq = SinOsc.ar(LFSaw.kr(sfreq).range(1/4,8)).range(50,900);
	ffreq = SinOsc.ar(sfreq*[1.01,1,,2]).range(50,7900);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = Splay.ar(sig, 0.8);
	sig;

});
);

Ndef(~name+++\fx).play;

(

Ndef(~name+++\lfo1, { SinOsc.kr(1).range(0.3,0.4)  });
Ndef(~name+++\lfo2, { SinOsc.kr([0.1,0.01,0.15]).range(0.8,1.09).sum/3;  });
Pdef(~name +++ \pre, Pbind(
	//\pitch_stretch, Pseq([0.4,0.3]+0.5,inf).stutter(3),
	//\pitch_stretch, Ndef(~name+++\lfo2),
	\pitch_stretch, Pseq([3.9,4.1,2.1]/3,inf).stutter(3),
	\time_stretch, Pseq([0.03],inf).stutter(3),
	\randrate, 0,
	\randframes, 0,
	\out, BusDef(~name+++\fx),
	//\pos, Ndef(~name+++\lfo1),
	\pos, Pseq([0,0.3,0.32,0.12]+0.43,inf),
	\legato, 1.5,
	\amp, 0.3,
	\freq, 100,
));
);

// END

