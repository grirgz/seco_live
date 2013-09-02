~name = '41';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, 
						ifreq=5, maxdelaytime=0.05, delaytime= 0.05, decaytime=0.2, ffreq=1000, rq=0.3;
	var sig, sig1, sig2, sig3;
	sig = BPF.ar(
		Pluck.ar(
			Crackle.ar(\crackle.kr([1.9,1.8])),
			Impulse.ar(ifreq),
			maxdelaytime,
			delaytime,
			decaytime
		),
		ffreq,
		rq
	);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	//\degree, Pseq([0],inf),
	//\isRest, Veco(~name).isrest,
	\maxdelaytime, 0.15,
	\delaytime, Pwhite(0.0001,0.010),
	\ifreq, Pseq([3,5.2,2,4.33],inf),
	\ifreq, Pwhite(1.1,8.1),
	\legato, 1.5,
	\dur, 1,
	\amp, 4.0
))
);



//END


