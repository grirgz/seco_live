Pdef(~name +++ \pre, Pbind(
	\freq, 400 * (2**([0/12,2/12,5/12])),
	\freq, Pseq([
		(2**([0/12,2/12,5/12])),
		(2**([5/12,8/12,10/12])),
		(2**([6/12,8/12,11/12])),
		(2**([7/12,9/12,12/12])),

		(2**([0/12,2/12,5/12])),
		(2**([5/12,3/12,10/12])),
		(2**([1/12,8/12,11/12])),
		(2**([7/12,9/12,12/12])),
	],inf).stutter(4) * Pseq([400, [400,200], [400,100,800], [100,200,400]],inf).stutter(1),
	\dur, 1/2,
	\sawtab, Plazy({ arg ev;
		Pseq([
			[ { 10.rand} ! 8 + ev[\freq]];
		])
	}).loop,
	\adsr, Pseq([
		[ Env.adsr(0.20,0.1,0.8,0.4) ],
	],inf),
	\sigmix, Pseg(Pseq([0.2,0.8,Pwhite(0.0,8,1),Pwhite(0.0,8,1)],inf),16),
	\detune, Pseq([1,0,5,-8],inf).stutter(8) * 2,
	\legato, 0.051,
	\amp, Pseq([1,0.5,0.7,0.3],inf).stutter(1) * Pkey(\amp) * Pseq([1,0.8,1,0.8,1,0.4],inf).stutter(8),
));

// END

(
Ndef(~name+++\mixer)[50] = \filterIn -> { arg in; 
	var sig;
	var sig2;
	var sig3;
	sig = in;
	//sig = CombL.ar(sig, 0.1,0.1*SinOsc.ar(5).range(0.2,1),1) * 0.1 + sig;

	sig2 = sig;
	sig2 = CombL.ar(sig2, 0.1,1/4/t,1) * 0.1;
	sig2 = (sig2*70).clip2(0.4) * 0.4;
	sig2 = FreqShift.ar(sig2,-5);


	sig = sig2;
	//sig = sig3;
};
Ndef(~name+++\mixer)[51] = \filterIn -> { arg in; 
	var sig;
	var sig2;
	var sig3;
	sig = in;
	//sig = CombL.ar(sig, 0.1,0.1*SinOsc.ar(5).range(0.2,1),1) * 0.1 + sig;

	sig3 = sig;
	sig3 = CombL.ar(sig3, 0.1,1/16/t,1) * 1.3;
	//sig3 = sig3 * SinOsc.kr(1/4/t).range(0,1);
	sig3 = DelayL.ar(sig3, 0.1,0.01*SinOsc.kr(1).range(0.1,1));

	sig = sig3;
	//sig = sig3;
};
)

~set_macro.(\k1, Ndef(~name+++\mixer), \wet50, \unipolar.asSpec);
~set_macro.(\k2, Ndef(~name+++\mixer), \wet51, \unipolar.asSpec);
