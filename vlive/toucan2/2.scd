~name = 'toucan2-2';

~pdef_channel.();


(
SynthDef(\zsnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(Env([400,150,151],[0.01,0.08]), 1) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.20], -4), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([14700,4852,3451],[0.01,0.1]), 1));
	snare = HPF.ar(snare, EnvGen.ar(Env([9700,4452,3451],[0.01,0.1]), 1));
	snare = snare * EnvGen.kr(Env([0,1,0],[0.001,0.18], -2), 1);

	sig = click + osc + snare;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	//sig.debug("sitg");
	Out.ar(out, sig);
}).add;
);

(
SynthDef(~name+++\zsnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = LFCub.ar( EnvGen.kr(Env([400,140,121],[0.01,0.08]), 1) * ( 1 + ( SinOsc.ar([470,123,321]).sum * 0.5 )) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.10], -4), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([14700,4852,3451],[0.01,0.1]), 1));
	snare = HPF.ar(snare, EnvGen.ar(Env([9700,4452,3451],[0.01,0.1]), 1));
	snare = snare * EnvGen.kr(Env([0,1,0],[0.001,0.18], -2), 1);

	sig = click + osc + snare;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	//sig.debug("sitg");
	Out.ar(out, sig);
}).add;
);

(
~pdef_init.(Pbind(
	\instrument, ~name+++\zsnare,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
))
);

// END

Ndef(~name+++\mixer).clear
