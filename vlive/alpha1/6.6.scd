
(
Ndef(~name+++\fx).put(10, \filter -> { arg in;
	var sig;
	var freq;
	var freq2;
	var pan;
	var fspread = 0.00001;
	pan = 0;
	sig = in;

	sig = sig * EnvGen.kr(\xiadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\xitrig.tr(1),\xisustain.kr(1)), doneAction:0);

	sig;
});

Ndef(~name+++\fx).put(11, \set -> Pbind(
	\xitrig, Pseq([
		0,1
	],inf),
	\xisustain, 1.00 / ~t,
	\xiadsr, Plazy({ arg ev;
		Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.03) ],
		],1).stutter(Prand([1,2,3,4,10],inf));
	}).loop,
	\dur, 1,
));
)

