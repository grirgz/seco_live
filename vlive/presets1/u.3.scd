(
Pdef(~name +++ \pre, Pbind(
	\degree, Prand([0,2,4],inf),
	\octave, Prand([3,4,5,2,6,4],inf),
	\scale, Scale.minor,
	\ctranspose, Pstep(Pseq([0,4,2,5],inf),8),
	\ffreq, Prand([200,600],inf) * Pwhite(0.2,5.2),
	\ffreq, Prand([80,150,90,80, 200,600,1200,1000],inf),
	\legato, Prand([4.5,2,1.9,2.5],inf),
	\adsr, [Env.adsr(0.3,0.1,0.8,0.5)],
	\blende, Pseg(Pseq([0,1],inf),16),
	\adsr, Pfunc { arg ev;
		[Env.adsr(0.03,0.1,0.8,0.05)].blend(
			[Env.adsr(0.3,0.1,0.8,0.5)],
			ev[\blende]
		)
	},
	\adsr, [Env.adsr(0.03,0.1,0.8,0.05)],
	\legato, 1.2,
	\dur, Prand([0.5,0.7,0.8,0.9]/10,inf),
	\dur, Pseq([0.01,0.02,0.03,0.05]+0.1,inf),
	\dur, Pwhite(0.05,0.2),
	\out, BusDef(~name+++\fx),
	\dur, 1/8,
));

);

(

Ndef(~name+++\fx, { arg spread=0.8, pan=0, mul=10, fbamp=0.05, delaytime=0.5, ffreq=200, rq=0.6, shiftfreq=0.5;
	var sig;
	var in;
	in = InFeedback.ar(BusDef(~name+++\fx), 2);
	//sig = sig + SinOsc.ar([100,200]);
	//sig = FreqShift.ar(sig, SinOsc.kr(5).range(-10,10)) + sig;
	mul = mul.lag(0.5);
	pan = pan.lag(0.1);
	sig = in + Fb({ arg feedback; // this will contain the delayed output from the Fb unit
		var si;
		si = feedback * fbamp + in;
		//si = BPF.ar(feedback*fbamp + in, 2000+SinOsc.kr(0.4).range(-1500,900), 3.8).distort;
		ffreq = SinOsc.kr(0.5).range(50,700);
		//si = LPF.ar(si, ffreq);
		si = FreqShift.ar(si, SinOsc.kr(shiftfreq).range(-10,10)+LFCub.kr(shiftfreq/2).range(-1,1)*100) + si;
	},2,delaytime);
	sig = Splay.ar(sig,spread, 1, pan);
	sig;
	
});
Ndef(~name+++\fx).set(\shiftfreq, ~tempo / 8);
)

// END
Ndef(~name+++\fx).fadeTime = 1;
Ndef(~name+++\fx).set(\shiftfreq, ~tempo / 8);
Ndef(~name+++\fx).set(\shiftfreq, ~tempo / 4);
Ndef(~name+++\fx).set(\shiftfreq, ~tempo * 2);
Ndef(~name+++\fx).set(\delaytime, 1.00/~tempo);
Ndef(~name+++\fx).set(\delaytime, ~tempo / 8);
Ndef(~name+++\fx).set(\delaytime, ~tempo / 1);
Ndef(~name+++\fx).set(\fbamp, 0.4);
Ndef(~name+++\fx).set(\fbamp, 0.6);
Ndef(~name+++\fx).set(\fbamp, 0.014);

~newfx.(\fx)

(
Pdef(~name +++ \pre, Pbind(
	\degree, Prand([0,2,4],inf),
	\octave, Prand([3,4,5,2,6,4],inf),
	\scale, Scale.minor,
	\ctranspose, Pstep(Pseq([0,4,2,5],inf),8),
	\ffreq, Prand([200,600],inf) * Pwhite(0.2,5.2),
	\ffreq, Prand([80,150,90,80, 200,600,1200,1000],inf),
	\legato, Prand([4.5,2,1.9,2.5],inf),
	\adsr, [Env.adsr(0.3,0.1,0.8,0.5)],
	\blende, Pseg(Pseq([0,1],inf),16),
	\adsr, Pfunc { arg ev;
		[Env.adsr(0.03,0.1,0.8,0.05)].blend(
			[Env.adsr(0.3,0.1,0.8,0.5)],
			ev[\blende]
		)
	},
	\adsr, [Env.adsr(0.03,0.1,0.8,0.05)],
	\isRest, ~isrest.(Pseq([1,0,0,0, 1,1,0,0],inf)),
	\legato, 1.2,
	\dur, Prand([0.5,0.7,0.8,0.9]/10,inf),
	\dur, Pseq([0.01,0.02,0.03,0.05]+0.1,inf),
	\dur, Pwhite(0.05,0.2),
	\out, BusDef(~name+++\fx),
	\dur, 1/8,
));

);
