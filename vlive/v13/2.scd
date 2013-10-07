~name = '2';

SynthDef(~name, { arg out=0, gate=1, pan=0, amp=0.1, freq=111, doneAction=2,
		fac1 = 1, res1=0.01;
	var mid, ou, ou2, env1, env2, ou3, env;
	var ou4;
	var env3, env4, env5;
	var line;

	env1 = EnvGen.kr(\adsr1.kr(Env.adsr(0.40001,0.01,0.1,0.4001)), gate, doneAction:0);
	ou = LFTri.ar(freq) * 79;
	ou3 = FreqShift.ar(ou, [175, 224,200,-400]);
	ou = ou3/1 + ou;
	ou = ou * env1;
	//env1 = EnvGen.ar(~make_adsr.(\adsr),gate, doneAction:2);

	env = EnvGen.kr(\adsr.kr(Env.adsr(0.00001,0.01,0.8,0.4001,1, -4)), gate, doneAction:doneAction);

	//env2 = EnvGen.ar(~make_adsr.(\adsr_short),gate);
	env2 = EnvGen.kr(\adsr2.kr(Env.adsr(0.0001,0.0011,0.8,0.411,1,-5)), gate, doneAction:0);
	env3 = EnvGen.kr(\env3.kr(Env([1.0001,-1.71],[0.01])), gate, doneAction:0);
	env4 = EnvGen.kr(\env4.kr(Env([0.0001,1.11],[0.051])), gate, doneAction:0);
	env5 = EnvGen.kr(\adsr5.kr(Env.adsr(0.0001,0.01,0.1,2.001)), gate, doneAction:0);
	ou2 = SinOsc.ar([130,480]).sum*env2;
	ou2 = WhiteNoise.ar(1);
	//ou2 = LPF.ar(ou2, 5000 * [1,0.9,0.25,0.8,1.3,2.3]);
	ou2 = LPF.ar(ou2, 2100 * Array.geom(8,0.1,1.18).clip2(10000));
	//ou2 = LPF.ar(ou2, 1000);
	ou2 = HPF.ar(ou2, 010);
	//ou2 = FreqShift.ar(ou2, [425, 424,200,12] * env3).sum;
	//ou2 = DynKlank.ar(`[[50,100,200,500],nil,0.04], ou2);
	//ou2 = DynKlank.ar(`[Array.geom(8, 340,1.5).clip2(10000),nil,0.01], ou2);
	line = SinOsc.kr(8).range(0.2,3);
	//line = EnvGen.kr(\line.kr(Env([0.0001,1.11],[0.051])), gate, doneAction:0);
	line = XLine.kr(4.0,0.2,0.01);
	line = EnvGen.kr(\line.kr(Env([0.0001,5.011,0.51],[0.007,0.041],[-1,2])), gate, doneAction:0);
	res1 = 0.001;
	ou2 = DynKlank.ar(`[Array.series(8, 41,440.5 - Rand(50)).clip2(10000)*fac1,nil,res1], ou2)/1 * line + ou2;
	ou4 = ou2;
	ou2 = DynKlank.ar(`[Array.series(8, 840,40.5).clip2(10000),nil,0.02], ou2)/2 + ou2;
	ou2 = ou2 * env2;
	//ou2 = LPF.ar(ou2, 210 * Array.geom(8,0.1,2.28).clip2(10000));
	ou2 = LPF.ar(ou2, 070 * [1,2]) * 20;
	ou3 = LFTri.ar(freq * env4);
	//ou3 = 0;

	ou3 = WhiteNoise.ar(4) * env2;
	ou3 = LPF.ar(ou3, (7000 * Array.geom(8,0.7,7.18)).clip2(10000));
	//ou2 = LPF.ar(ou2, 1000);
	ou3 = HPF.ar(ou3, 010);

	//ou = ou + ou2 + ou3;
	ou = ou2 + (ou4 * 1);
	//ou = ou3 + ou2;
	ou = ou;
	//ou = ou + ou.softclip;
	ou = ou / 22;

	//ou = AllpassC.ar(ou, 0.1,0.05,0.001) + ou;
	//ou = AllpassC.ar(ou, 0.1,0.05,0.001) + ou;
	//ou = ou + Fb({ arg fb;
	//	fb = fb * 1.0 + ou;


	//	fb = fb + WhiteNoise.ar(1);
	//	fb = LPF.ar(fb, 10000);
	//	fb = HPF.ar(fb, 0500);

	//},0.1);
	ou = Compander.ar(ou, ou, MouseX.kr(0.01, 1), 0.9,0.9,0.0001,0.01);

	ou = ou * env;
	ou = ou * amp;
	ou = Limiter.ar(ou, 1);
	ou = Splay.ar(ou, 0.8);



	Out.ar(out,ou.dup)
	
}).add;

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	//\degree, Pseq([0],inf),
	\freq, 880,
	\res1, Pseq([0.01,0.02,0.05]/5,inf),
	\fac1, Pseq([1,1.2,0.8],inf),
	\fac1, 4.5,
	\res1, 0.01,
	\isRest, Veco(~name).isrest(16),
	\sustain, 0.09,
	\dur, 1/4,
	\amp, 0.13 * Pkey(\amp),
	) <> Veco(~name).mixer)
);

