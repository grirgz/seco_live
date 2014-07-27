(

Pdef(~name +++ \pre, 
	Pbind(
		\mbufnum, BufDef.mono(\bomb),
		\amp, 25 * Pkey(\amp) * 0.4,
		\time_stretch, Pwhite(0.0,0.01) + Pkey(\time_stretch),
		\pitch_stretch, Pwhite(0.0,0.11) + Pkey(\pitch_stretch),
		\isRest, Pseq([1,0],inf).coin.not,
	) <>
	Sdef(~name, \mypreset).pbind <>
	
	Pbind(
	\pos, 0.0348,
	\legato, 9,
	//\lag, 1/t,
	\dur, 4,
	\isRest, false,
	\time_stretch, 0.011,
	\pitch_stretch, 1,
	\freq, 100,
));
)

// END

Sdef(~name, \mypreset).pbind.trace.play

(
Ndef(~name+++\mixer).put(50, \filter -> { arg in;
	
	var sig = in;
	//sig = DelayC.ar(sig, 0.1,[0.01,0.03,0.001]) + sig;
	sig = Splay.ar(sig, \spread.kr(0.78), \amp.kr(1), \pan.kr(0));
	sig = HPF.ar(sig, LFNoise1.kr(1).range(4000,40));
	sig = LPF.ar(sig, LFNoise1.kr(1).range(14000,400));
	sig = sig * 6;
	sig;
})
)
(
Ndef(~name+++\mixer).put(50, \filter -> { arg in;
	
	var sig = in;
	sig = DelayC.ar(sig, 0.1,[0.01,0.03,0.001]) + sig;
	sig = Splay.ar(sig, \spread.kr(0.78), \amp.kr(1), \pan.kr(0));
	sig = HPF.ar(sig, 80);
	sig = LPF.ar(sig, 1400);
	sig = sig * 6;
	sig;
})
)

(
Ndef(~name+++\mixer).put(50, \filter -> { arg in;
	
	var sig = in;
	sig = DelayC.ar(sig, 0.1,[0.01,0.03,0.001]) + sig;
	//sig = HPF.ar(sig, 1080);
	//sig = LPF.ar(sig, 1400);
	sig = BPF.ar(sig, 
		{LFNoise1.kr(1/8).range(0,1)} ! 4 * [400,1000, 2000,2300], 
		[0.1,0.2]
	);
	sig = Splay.ar(sig, \spread.kr(0.08), \amp.kr(1), \pan.kr(0));
	sig = sig * 6;
	sig;
})
)
