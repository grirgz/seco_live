(
Ndef(~name+++\lfo1).quant = Pdef.defaultQuant;
Ndef(~name+++\lfo1, { arg val=0.5, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		Pser([0.5,0.601],2),
		0.2,2.501,
	],inf) * 2,
	\vlag, Pseq([
		Pser([0.1],6),
		Pser([0.7],2),

	],inf),
	\dur, 1/4,
));

Ndef(~name+++\fx).set(\wet10, 1);
Ndef(~name+++\fx).put(10, \filter -> { arg in, ffreq = 400, rq =0.3, fmod=8, modrange=0.5;
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	sig = in;
	ffreq = SinOsc.ar(fmod) * modrange + 1 * ffreq;
	sig = RLPF.ar(sig, ffreq, rq);
	sig;
});
Ndef(~name+++\fx).quant = Pdef.defaultQuant;
Ndef(~name+++\fx).put(11, \set -> Pbind(
	\ffreq, Pseq([1000,200],inf).stutter(4),
	\fmod, Pseq([
		16,8,2,32,
		2,16,2,32,
	],inf),
	\frange, Pseq([0.9,0.2],inf),
	\dur, 1/4,
));

Veco.do { arg name, namex;
	Veco(~namex).response_unselect_hook = {
		"hey!!!2======================".debug;
		Ndef(name+++\fx).set(\wet10, 0);
	}
};

Pdef(~name +++ \pre, 
	Pbind(
	\reprate, Pseq([4,8,2,8],inf).stutter(2),
	\reprate, 50,
	\speed, Pseq([0.4,1],inf),
	\legato, 4.1,
	\isRest, Veco(~namex).isrest(32),
	//\speed, 0.5,
	//\pos, Pwhite(0,1.0).stutter(16),
	//\pos, Pwhite(0,1.0).stutter(16),
	\pos, 0.453,
	\pos, Prout({ arg e;
		loop {

			var list = [
				0.01.rand,
				0.01.rand,
				0.05.rand,
			];
			var res = e[\pos] + Pseq([list[0],list[1],list[0],list[2]],2).stutter(32);
			res.embedInStream;
	
		}
	}),
	//\pos, 0.4,
	//\pos, Ndef(~name+++\lfo1),

	) <>
	
	Sdef(~name, \mypreset).pbind <>
	Pbind(
	\freq, 100,
	\start, 0.1,
	\end, 0.72,
	\dur, 1/8,
	\pos, 0.2,
	\reprate, 18,
	\legato, 1.1,
	\loop, 0,
));
)

// END
Veco(~namex)[\responder_unselect_hook].value
Veco.do { arg name, namex;
	Veco(~namex)[\response_unselect_hook] = {
		"hey!!!======================".debug;
		Ndef(name+++\fx, { arg ffreq = 400, rq =0.3;
			var in = In.ar(BusDef(name+++\fx),2);
			var sig;
			var sig1,sig2,sig3,sig4,sig5;
			sig = in;
			//sig = RLPF.ar(sig, ffreq, rq);
			sig;
		});
	};
};

		Ndef(~name+++\fx).set(\wet10, 0);
		Ndef(~name+++\fx).edit
		Ndef(~name+++\fx).clear
