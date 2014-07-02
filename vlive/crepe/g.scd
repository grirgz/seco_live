~name = 'g';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(\sawtab.kr({ 1000.rand }!8));
	sig = SelectX.ar(\sigmix.kr(0.5), [sig1, sig2]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Veco(~name).make_mixer;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

(
Ndef(~name+++\mixer)[50] = \filter -> { arg in, distamp=70; 
	var sig;
	var sig2;
	var sig3;
	sig = in;
	//sig = CombL.ar(sig, 0.1,0.1*SinOsc.ar(5).range(0.2,1),1) * 0.1 + sig;

	sig2 = sig;
	//sig2 = (sig2*distamp).clip2(1) * 0.4;
	sig2 = CombL.ar(sig2, 0.1,1/4/t,\combrelease.kr(1)) * 0.1;
	sig2 = (sig2*distamp);
	sig2 = SelectX.ar(\mixclip.kr(2), [
		sig2.clip(-1,1),
		sig2.softclip(-1,1),
		sig2.tanh,
		sig2.distort,
	] ) * 0.4;
	sig2 = FreqShift.ar(sig2,-5);


	sig = sig2;
	//sig = sig3;
};
Ndef(~name+++\mixer)[51] = \filterIn -> { arg in; 
	var sig;
	var sig2;
	var sig3;
	var ffreq;
	sig = in;
	//sig = CombL.ar(sig, 0.1,0.1*SinOsc.ar(5).range(0.2,1),1) * 0.1 + sig;

	sig3 = sig;
	//sig3 = CombL.ar(sig3, 0.1,1/16/t,1) * 1.3;
	//sig3 = sig3 * SinOsc.kr(1/4/t).range(0,1);
	//sig3 = DelayL.ar(sig3, 0.1,0.01*SinOsc.kr(1).range(0.1,1));
	ffreq = \ffreq.kr(14000) * Amplitude.kr(sig3,0.1,3).clip(-1,1) + 100;
	//ffreq.poll;
	sig3 = RLPF.ar(sig3, ffreq, \rq.kr(0.5));

	sig = sig3;
	//sig = sig3;
};
);

~set_macro.(\k1, Ndef(~name+++\mixer), \wet50, \unipolar.asSpec);
~set_macro.(\k2, Ndef(~name+++\mixer), \wet51, \unipolar.asSpec);
~set_macro.(\k3, Pdef(~name+++\mod), \sigmix, \unipolar.asSpec);
~set_macro.(\k4, Pdef(~name+++\mod), \randsawtab, \widefreq.asSpec);
~set_macro.(\k5, Ndef(~name+++\mixer), \distamp, \lofreq.asSpec);
~set_macro.(\k6, Ndef(~name+++\mixer), \mixclip, ControlSpec(0,4,\lin));
~set_macro.(\k7, Ndef(~name+++\mixer), \combrelease, ControlSpec(0,4,\lin));
~set_macro.(\s1, Pdef(~name+++\mod), \pdur, ControlSpec(1,4,\lin,1,1));
~set_macro.(\s2, Ndef(~name+++\mlfo1), \pfreq, ControlSpec(1,8,\lin,1,1));

// END

Ndef(~name+++\mlfo1, { arg pfreq=1; SinOsc.kr(2**pfreq/4/t).range(0,1.01) });
Ndef(~name+++\mlfo1).quant = 1;
Ndef(~name+++\mlfo2, { SinOsc.kr(4).range(0,4) });
Ndef(~name+++\mixer).set(\wet50, Ndef(~name+++\mlfo1).asMap);
Ndef(~name+++\mixer).set(\combrelease, Ndef(~name+++\mlfo2).asMap);

Ndef(~name+++\mlfo1, { DC.kr(0.5) });
Ndef(~name+++\mixer).unset(\combrelease);
Ndef(~name+++\mixer).unset(\wet50);
Ndef(~name+++\mixer).map(\wet50, Ndef(~name+++\mlfo1));

Ndef(~name+++\mixer)[51] = \filterIn -> { arg in; 
	var sig;
	var sig2;
	var sig3;
	sig = in;
	//sig = CombL.ar(sig, 0.1,0.1*SinOsc.ar(5).range(0.2,1),1) * 0.1 + sig;

	sig3 = sig;
	sig3 = CombL.ar(sig3, 0.1,1/16/t,1) * 1.3;
	//sig3 = sig3 * SinOsc.kr(1/4/t).range(0,1);
	//sig3 = DelayL.ar(sig3, 0.1,0.01*SinOsc.kr(1).range(0.1,1));

	sig = sig3;
	//sig = sig3;
};
