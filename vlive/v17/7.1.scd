BusDef(~name+++\fx, \audio);
(
Ndef(~name+++\fx, { arg ffreq, rq=0.3;
	var in, sig;
	var seq;
	var sfreq;
	var ffreq2;
	var amp;
	in = InFeedback.ar(BusDef(~name+++\fx),2);
	sig = in;
	seq = Dseq([1,3,5,7],inf);
	seq = Dseq([1,4,8,2],inf);
	seq = Dseq([
		1,0.9,0.8,0.2, 1,0.3,0.9,0.9,
		1,0.4,0.5,1.2, 1,1.3,0.9,0.9,
	],inf);
	sfreq = Demand.kr(Impulse.kr([4,8]), 0, seq);
	ffreq2 = SinOsc.ar(LFSaw.kr(sfreq).range(1/16,1/8)).range(30,500) * [0.3,1.2,1,0.4,0.3];
	ffreq2 = [1500,500,LFNoise1.kr(4).range(200,5000),600,3000] * sfreq;
	ffreq2 = LFNoise1.kr([1,4,2,8]).range(50,15000) * [1,1.11,2];
	//ffreq = SinOsc.ar(sfreq*[1.01,1,2]).range(50,7900);
	ffreq = SinOsc.ar(sfreq*[1.01,0.1,1,2]/8).range(0.1,0.9);
	//sig = CombL.ar(sig, 1/8,1/8*ffreq,1); 
	sig = RLPF.ar(sig, ffreq2 * [0.5,1,1.5,0.5], rq);
	amp = SinOsc.kr([0.02,0.021,0.05234]).range(0.5,1);
	sig = amp *  sig;
	sig = Splay.ar(sig, 0.8+SinOsc.kr(1).range(0,1));
	sig;

});
);

Ndef(~name+++\fx).fadeTime = 1;
Ndef(~name+++\fx).play(BusDef(~name+++\mixer));
//Ndef(~name+++\gain, { XLine.kr(0.0001,1,50) });
//Ndef(~name+++\gain).quant = Pdef.defaultQuant;
//Ndef(~name+++\mixer).map(\amp, Ndef(~name+++\gain));
//Ndef(~name+++\mixer).play


(

Ndef(~name+++\lfo1, { SinOsc.kr([0.01,0.011,0.01234]).range(1.0,1.4).sum/3  });
Ndef(~name+++\lfo1b, { SinOsc.kr([0.013,0.015,0.03234]).range(0.3,0.4).sum/3  });
Ndef(~name+++\lfo2, { SinOsc.kr([0.1,0.01,0.15]).range(0.8,1.09).sum/3;  });
Pdef(~name +++ \pre, Pbind(
	//\pitch_stretch, Pseq([0.4,0.3]+0.5,inf).stutter(3),
	//\pitch_stretch, Ndef(~name+++\lfo2),
	\pitch_stretch, Pseq([3.9,4.1,2.1]/5,inf).stutter(3),
	\pitch_stretch, 0.77 + Pwhite(0,0.1),
	\pitch_stretch, [Ndef(~name+++\lfo1), Ndef(~name+++\lfo1b)],
	\time_stretch, Pseq([0.03,8.03],inf).stutter(3),
	\time_stretch, Pseq([1.03],inf).stutter(3),
	\time_stretch, Pseq([0.03],inf).stutter(3),
	\mbufnum, BufDef.mono(\woodshop),
	\out, BusDef(~name+++\fx),
	//\pos, Ndef(~name+++\lfo1),
	\pos, Pseq([0,0.3,0.32,0.12]+0.23,inf),
	\pos, 0.40,
	\adsr, Pseq([
		[ Env.adsr(0.4001,0.1,0.8,0.9) ],
		//[ Env.adsr(0.3,0.3,0.4,0.1) ],
	],inf),
	\randrate, 1.00,
	\randframes, 0.0102,
	\pitch_stretch, 1/1,
	\time_stretch, Pseq([0.03],inf).stutter(3),
	\time_stretch, Pseq([4.03],inf).stutter(3),
	\legato, 2.0,
	\mixmpos, 1.8,
	\mixmpos, 0.0,
	\posmfreq, 1.0,
	\posmrange, 0.2,
	\dur, 2,
	\amp, 1.111 * Pkey(\amp),
	\freq, 100,
));
);

// END

Ndef(~name+++\mixer).set(\amp, 0);
Ndef(~name+++\mixer).set(\amp, 1);
Ndef(~name+++\mixer).edit;
Ndef(~name+++\fx).stop;
