
(
TempoClock.default.tempo = 160/60;
Pdef.defaultQuant = 4;
Ndef.defaultQuant = 4;
~t = TempoClock.default.tempo;
BusDef(\fx1, \audio);

SynthDef(\zhat2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env([0,1,0.5,0],[0.01,1,\rel.kr(0.1)],-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\zhatadsr, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = (sig * 10).tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.2,0.4,0.2,4,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
			[ Env.new([80, 31, 35], [0.025, 0.19], [-4, -5]) ],
		Pseq([
		[ Env.new([80, 31, 35], [0.035, 0.39], [-4, -5]) ],
		],3),
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		//1,0,0,0, 0,0,1,0,
		//0,1,0,1, 0,0,0,0,
		1,0,0,0, 0,1,0,1,
		0,1,1,0, 0,0,0,1,
		1,0,1,0, 0,1,0,1,
		0,1,1,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.25 * Pseq([
		1.2,1,1,1,
	],inf)/1.2,
));

Pdef(\hat, Pbind(
	\instrument, \zhatadsr,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	//\dur, Pkey(\dur) * (1 + (0.11 * Pseq([1,0,-1,0],inf))).stutter(2),
	\lag, 0.01,
	\sustain, Pseq([
		1,Pn(0.1,7),
		Pn(0.1,2), Pn(1,2),Pn(0.1,4),
		1,0.5,Pn(0.1,6),
		Pn(0.1,2), Pn(1,2),Pn(0.1,4),
		//Pn(0.1,8),
		//Pn(0.1,8),
		
	],inf)+Pwhite(-0.05,0.051,inf),
	//\rel, Pkey(\sustain),
	\amp, Pkey(\amp) * Pseq([
		1,0.5,0.7,0.3,
	],inf)+Pwhite(0,0.1,inf),
	\isRest, Pseq([
		0,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		0,1,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,1,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\cym, Pbind(
	\instrument, \zcymbal,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\sustain, Pseq([
		1,Pn(0.1,7),
		Pn(0.1,2), Pn(1,2),Pn(0.1,4),
		1,0.5,Pn(0.1,6),
		Pn(0.1,2), Pn(1,2),Pn(0.1,4),
		//Pn(0.1,8),
		//Pn(0.1,8),
		
	],inf),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,

	\amp, 0.1/8,
));

Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
	],inf).coin.not,
	\amp, 0.2
));

Pdef(\snarehat, Pbind(
	\instrument, \zsnarehat,
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],2),
	],inf).coin.not,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\amp, 0.20
));

Pdef(\main).play;

)

(
Pdef(\main, Ppar([
	Pbind(\out, 0) <> Pdef(\kick),
	Pdef(\hat),
	Pdef(\cym),
	Pbind(\out, 0) <> Pdef(\snare),
	Pdef(\snarehat),
].collect({ arg x; Pbind(\out, BusDef(\fxcomp, \audio)) <> x }))).play;
)


(
Ndef(\fxcomp, { arg compt=0.4, compbelow=1, compabove=1, clamp=0.1, relax=0.1, mamp=1, preamp=1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	in = InFeedback.ar(\inbus.kr(BusDef(\fxcomp, \audio)), 2); 
	sig = CompanderD.ar(in, in, thresh:compt,slopeBelow:compbelow,slopeAbove:compabove, clampTime:clamp, relaxTime:relax);
	//sig = sig.tanh;
	sig = sig * preamp;
	sig = sig + (HPF.ar(sig,1000).tanh);
	sig = sig * mamp;
	sig;
}).play;
);

(
	// high low
Ndef(\fxcomp, { arg 
	mamp=1, preamp=1, cut=1000,
	compt=0.4, compbelow=1, compabove=1, clamp=0.1, relax=0.1, 
	compt2=0.4, compbelow2=1, compabove2=1, clamp2=0.1, relax2=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sigh, sigl;
	in = InFeedback.ar(\inbus.kr(BusDef(\fxcomp, \audio)), 2); 
	sig = in;
	sigh = HPF.ar(sig, cut);
	sigl = LPF.ar(sig, cut);
	sigl = CompanderD.ar(sigl, sigl, thresh:compt,slopeBelow:compbelow,slopeAbove:compabove, clampTime:clamp, relaxTime:relax);
	sigh = CompanderD.ar(sigh, sigh, thresh:compt2,slopeBelow:compbelow2,slopeAbove:compabove2, clampTime:clamp2, relaxTime:relax2);
	sig = sigl + sigh;
	//sig = sig.tanh;
	//sig = sig * preamp;
	//sig = sig + (HPF.ar(sig,1000).tanh);
	sig = sig * mamp;
	sig;
}).play;
);

(
	// left right
Ndef(\fxcomp, { arg 
	mamp=1, preamp=1, cut=1000, pan=0,
	compt=0.4, compbelow=1, compabove=1, clamp=0.1, relax=0.1, 
	compt2=0.4, compbelow2=1, compabove2=1, clamp2=0.1, relax2=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sigh, sigl;
	in = InFeedback.ar(\inbus.kr(BusDef(\fxcomp, \audio)), 2); 
	sig = in;
	sigh = sig[0];
	sigl = sig[1];
	sigl = CompanderD.ar(sigl, sigl, thresh:compt,slopeBelow:compbelow,slopeAbove:compabove, clampTime:clamp, relaxTime:relax);
	sigh = CompanderD.ar(sigh, sigh, thresh:compt2,slopeBelow:compbelow2,slopeAbove:compabove2, clampTime:clamp2, relaxTime:relax2);
	sig = [ sigh , sigl ];
	sig = Pan2.ar(sig, pan * [-1,1], 1).mean;
	//sig = sig.tanh;
	//sig = sig * preamp;
	//sig = sig + (HPF.ar(sig,1000).tanh);
	sig = sig * mamp;
	sig;
}).play;
);

(
	// mid side
Ndef(\fxcomp, { arg 
	mamp=1, preamp=1, cut=1000, pan=0,
	compt=0.4, compbelow=1, compabove=1, clamp=0.1, relax=0.1, 
	compt2=0.4, compbelow2=1, compabove2=1, clamp2=0.1, relax2=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sigh, sigl;
	in = InFeedback.ar(\inbus.kr(BusDef(\fxcomp, \audio)), 2); 
	sig = in;
	sig = [sig[0] + sig[1], sig[0] - sig[1]] * (-3).dbamp; 
	sigh = sig[0];
	sigl = sig[1];
	sigl = CompanderD.ar(sigl, sigl, thresh:compt,slopeBelow:compbelow,slopeAbove:compabove, clampTime:clamp, relaxTime:relax);
	sigh = CompanderD.ar(sigh, sigh, thresh:compt2,slopeBelow:compbelow2,slopeAbove:compabove2, clampTime:clamp2, relaxTime:relax2);
	sig = [ sigh , sigl ];
	sig = [sig[0] + sig[1], sig[0] - sig[1]].reverse * (-3).dbamp; 
	//sig = sig.tanh;
	//sig = sig * preamp;
	//sig = sig + (HPF.ar(sig,1000).tanh);
	sig = sig * mamp;
	sig;
}).play;
);
Ndef(\fxcomp).edit

(
Spec.add(\lowc, ControlSpec(0.01,8,\exp));
Ndef(\fxcomp).addSpec(\compt, \lowc);
Ndef(\fxcomp).addSpec(\compabove, \lowc);
Ndef(\fxcomp).addSpec(\compbelow, \lowc);
Ndef(\fxcomp).addSpec(\clamp, \lowc);
Ndef(\fxcomp).addSpec(\relax, \lowc);

Ndef(\fxcomp).addSpec(\compt2, \lowc);
Ndef(\fxcomp).addSpec(\compabove2, \lowc);
Ndef(\fxcomp).addSpec(\compbelow2, \lowc);
Ndef(\fxcomp).addSpec(\clamp2, \lowc);
Ndef(\fxcomp).addSpec(\relax2, \lowc);
)

(
	// randband
Ndef(\fxcomp, { arg 
	mamp=1, preamp=1, pan=0,
	compt=0.4, compbelow=1, compabove=1, clamp=0.1, relax=0.1, 
	compt2=0.4, compbelow2=1, compabove2=1, clamp2=0.1, relax2=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sigh, sigl;
	var prev;
	var cuts;
	in = InFeedback.ar(\inbus.kr(BusDef(\fxcomp, \audio)), 2); 
	sig = in;

	prev = 0;


	cuts = ( 4.collect({ exprand(20,20000) }) ++ [20000] ).sort;
	cuts.debug("cuts");
	cuts = cuts.collect({ arg cut, idx;
		var isig = sig;
		isig = LPF.ar(isig, cut);
		isig = HPF.ar(isig, prev);
		sig = DelayL.ar(sig, 1.1, 0.1.rand * \del.kr(1))  / 1.1;
		prev = cut;
		isig;
	});

	sig = cuts.sum * 2.dbamp;
	//sig = in;


	sig = sig * mamp;
	sig;
}).play;
);

(
	// randband
Ndef(\fxcomp, { arg 
	mamp=1, preamp=1, pan=0,
	compt=0.4, compbelow=1, compabove=1, clamp=0.1, relax=0.1, 
	compt2=0.4, compbelow2=1, compabove2=1, clamp2=0.1, relax2=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sigh, sigl;
	var prev;
	var cuts;
	in = InFeedback.ar(\inbus.kr(BusDef(\fxcomp, \audio)), 2); 
	sig = in;

	prev = 0;


	cuts = ( 10.collect({ exprand(20,20000) }) ++ [20000] ).sort;
	cuts.debug("cuts");
	cuts = cuts.collect({ arg cut, idx;
		var isig = sig;
		isig = LPF.ar(isig, cut);
		isig = HPF.ar(isig, prev);
		//isig = DelayL.ar(isig, 1.1, 0.1.rand * \del.kr(1)) + isig / 1.1;
		isig = [
			{ isig = FreqShift.ar(sig, 0.01.rand) + isig; },
			{ isig = DelayL.ar(sig, 0.1, 0.01.rand) + isig; },
			{ isig = FreqShift.ar(sig, 10.01.rand) + isig; },
			{ isig = isig * LFNoise1.ar(9500.0.rand + 1000) + isig; },
		].choose.value / 2;
		prev = cut;
		isig;
	});

	sig = cuts.sum * 2.dbamp;
	//sig = in;


	sig = sig * mamp;
	sig;
}).play;
);

(
	// randband
Ndef(\fxcomp, { arg 
	mamp=1, preamp=1, pan=0,
	compt=0.4, compbelow=1, compabove=1, clamp=0.1, relax=0.1, 
	compt2=0.4, compbelow2=1, compabove2=1, clamp2=0.1, relax2=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sigh, sigl;
	var prev;
	var cuts;
	in = InFeedback.ar(\inbus.kr(BusDef(\fxcomp, \audio)), 2); 
	sig = in;

	prev = 0;


	cuts = ( 10.collect({ exprand(20,20000) }) ++ [20000] ).sort;
	cuts.debug("cuts");
	cuts = cuts.collect({ arg cut, idx;
		var isig = sig;
		isig = LPF.ar(isig, cut);
		isig = HPF.ar(isig, prev);
		//isig = DelayL.ar(isig, 1.1, 0.1.rand * \del.kr(1)) + isig / 1.1;
		isig = Amplitude.ar(isig) * LFSaw.ar(cut + prev / 2);
		isig = Amplitude.ar(isig) * WhiteNoise.ar(8) + isig;
		isig = LPF.ar(isig, cut);
		isig = HPF.ar(isig, prev);
		isig = isig * 2;
		prev = cut;
		isig;
	});

	sig = cuts.sum * 1.dbamp;
	//sig = in;
	sig = SelectX.ar(1.0, [in, sig]);
	sig = sig * 2;


	sig = sig * mamp;
	sig;
}).play;
);

Pdef(\main).play
Ndef(\fxcomp).edit

(
	// reverb
Ndef(\fxcomp).put(0, { arg 
	mamp=1, preamp=1, pan=0,
	compt=0.4, compbelow=1, compabove=1, clamp=0.1, relax=0.1, 
	compt2=0.4, compbelow2=1, compabove2=1, clamp2=0.1, relax2=0.1;
	var sig;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sigh, sigl;
	var prev;
	var cuts;
	in = InFeedback.ar(\inbus.kr(BusDef(\fxcomp, \audio)), 2); 
	sig = in;

	prev = 0;


	//sig = GreyholeRaw.ar(sig[0],sig[1], 0, 0.03, 1.1, 0.9, 1, 1, 0.2) + sig;
	sig = SelectX.ar(\inmix.kr(1), [DC.ar(0), in]);
	sig = Greyhole.ar(sig, \del.kr(1/8) / ~t, damp:0.51, size:0.1, diff:1, feedback:\fb.kr(2)) + sig;
	sig = SelectX.ar(\inmix.kr, [in+sig, sig]);

	sig = Limiter.ar(sig);
	//sig = cuts.sum * 1.dbamp;
	//sig = in;
	//sig = SelectX.ar(1.0, [in, sig]);
	//sig = sig * 2;


	sig = sig * mamp;
	sig;
}).play;
);
Ndef(\fxcomp).edit
Spec.add(\inmix, \unipolar);
(
Ndef(\fxcomp).put(10, \pset -> Pbind(
	\inmix, Pseq([
		1,0,1,1, 1,1,1,0,
		0,0,0,0, 0,0,0,0,
		1,0,0,0, 1,0,0,0,
	],inf),
	\fb, 0.71,
	\fb, Pseq([2,2,2,8,0],inf).stutter(1),
	\del, 1/Pseq([8,2,4,2],inf),
	\del, Pseq([1/2,1/2,1/2,1/4],inf).stutter(2),
	\dur, 1/4,
);)
)
