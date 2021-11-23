
(

x = {

var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
var timeScale = 1;

locutoffenv = EnvGen.ar(Env.perc(0.5, 5), timeScale:timeScale) * 20000 + 10;

lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 3), timeScale:timeScale) * 10000);

hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);

hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25), timeScale:timeScale);

thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:timeScale);

freqs  = {exprand(300, 20000)}.dup(100);

res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;

((res * 1) + (lodriver * 2) + thwack).dup;

}.play;

)

(

x = {

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var timeScale = 1/1;

	locutoffenv = EnvGen.ar(Env.perc(0.5, 5), timeScale:timeScale) * 20000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);
	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 3), timeScale:timeScale) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25), timeScale:timeScale);
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:timeScale);
	freqs  = {exprand(300, 20000)}.dup(100);
	//res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;
	res    = Ringz.ar( thwack, freqs).mean;
	//((res * 1) + (lodriver * 2) + thwack).dup;
	res ! 2;

}.play;

)

(
SynthDef(\gong, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqs;
	sig = SinOsc.ar(freq);
	freqs  = {exprand(300, 20000)}.dup(100);
	sig    = Ringz.ar( Impulse.ar(1), freqs).mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\gong, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqs;
	var thwack;
	var timeScale = 1/4;
	sig = SinOsc.ar(freq);
	freqs  = \freqs.kr(100!100);
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:timeScale);
	sig    = Klank.ar( Ref( [freqs,0.1,1.1] ), thwack);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \gong,
	\degree, Pseq([0],inf),
	\freqs, Pfunc({
		[{exprand(300, 2000)}.dup(100)]
	}),
	\dur, 1,
	\amp, 0.1
)).play;
);



(
SynthDef(\gong, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqs;
	var thwack;
	var timeScale = 1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	freqs  = \freqs.kr(100!100);
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:timeScale);
	sig1 = BPF.ar(WhiteNoise.ar(1), 100 * EnvGen.kr(Env([1,20,20],[0.1,0.8]), 1));
	sig1 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1);
	thwack = thwack + sig1;
	sig    = Klank.ar( Ref( [freqs,0.1,1.1] ), thwack);
	//sig = sig * BPF.ar(sig, 10000);
	sig = sig / 4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \gong,
	\degree, Pseq([0],inf),
	\freqs, Pfunc({
		[{exprand(300, 2000)}.dup(100)]
	}),
	\dur, 1,
	\amp, 0.1
)).play;
);

/////////
(
SynthDef(\gong, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqs, freqs2;
	var thwack;
	var timeScale = 1;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	freqs  = \freqs.kr(100!100);
	freqs2  = \freqs2.kr(100!100);
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:timeScale);
	sig1 = LPF.ar(WhiteNoise.ar(1), 100 * EnvGen.kr(Env([1,10,21],[0.0001,1.8]), 1));
	sig1 = EnvGen.kr(Env([0,1,0],[0.000401,0.1]), 1) * sig1;
	//thwack = thwack + sig1;
	sig    = Klank.ar( Ref( [freqs,0.1,1.4] ), thwack + sig1);
	sig1    = Klank.ar( Ref( [freqs2,0.1,1.4] ), sig1);
	sig = sig + sig1;
	//sig = sig * BPF.ar(sig, 10000);
	sig = sig / 4;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.8),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\plop, Pbind(
	\instrument, \gong,
	\degree, Pseq([0],inf),
	\freqs, Pfunc({
		[{exprand(300, 20000)}.dup(100)]
	}),
	\freqs2, Pfunc({
		[{exprand(300, 2000)}.dup(100)]
	}),
	\dur, 1,
	\sustain, 0.1,
	\amp, 0.1/2
)).play;
);

////////

(

SynthDef(\cymbal, { arg amp=0.1, gate=1, out=0, pan=0;

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var timeScale = 1;
	var sig;

	locutoffenv = EnvGen.kr(Env([0,1,1],[0.1,0.8])) * 20000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);
	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 7), timeScale:timeScale) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25), timeScale:timeScale);
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:1);

	freqs  = \freqs.kr(100!100);

	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;
	sig = ((res * 1) + (lodriver * 2) + thwack);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.4, curve:-5)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);

}).add;

)

(
Pdef(\plop, Pbind(
	\instrument, \cymbal,
	\degree, Pseq([0],inf),
	\adsr, Pseq([
		Pfunc({
			[ Env.adsr(0.001,0.1,0.8,0.8+2.0.rand,curve:-6) ]
		}),
	],inf),
	\freqs, Pfunc({
		//[{exprand(300, 20000)}.dup(100)]
		var tab = [ [ 399.09130009481, 2021.0082664068, 651.51615319166, 710.99400766402, 2488.2222464499, 13203.951224639, 14258.604864401, 13723.043494414, 4407.7975813173, 1826.4963443411, 537.30416723109, 1096.6137117423, 500.57993359318, 8444.2337469429, 1185.5790292566, 16214.892077193, 685.04359323871, 2999.5980389403, 12565.085500307, 705.43686360864, 449.3715460827, 13437.452048582, 751.84739687507, 1816.9734921465, 1543.4129649322, 9302.4341547237, 2013.4168465097, 300.88539016904, 2606.3313154844, 15185.088863865, 900.32915502701, 349.44538962947, 3728.422128516, 464.70665727115, 627.57554554506, 7381.3726249411, 4035.71612666, 18599.957753866, 7960.9133106445, 406.90732558019, 309.73967147988, 9360.2351495684, 322.75819320302, 1192.9503838129, 10031.144462751, 1626.9049906213, 1446.6484972079, 5549.8991339648, 5782.3382679731, 2238.5647166308, 495.61247800552, 317.15073705111, 15634.297160898, 926.71544040226, 382.64426331992, 1101.7031429722, 17002.807601934, 580.23326962048, 1984.3172445566, 740.8266158608, 11929.390567302, 5344.9202902011, 463.98725007629, 5339.5312136065, 567.75033673459, 513.0014020531, 13652.203334082, 639.96334515329, 422.68000533134, 1990.0281589904, 11628.476917287, 7048.032610839, 2275.9382067998, 2066.594685338, 17606.661203, 2048.0564015294, 781.14054107957, 3906.6908723773, 1683.0124529786, 15136.621959844, 3084.1151849017, 344.50030138219, 7378.6235067401, 2330.1582115245, 640.67574758462, 8684.1159500741, 15274.708459274, 452.13100911768, 1393.1723602525, 2725.9180963437, 15992.051904338, 4013.6314904242, 9914.4475710747, 2526.8823318363, 503.59102969078, 1666.2638444851, 12102.807445106, 494.30186498437, 2577.5320723269, 2132.8388093785  ]  ];

		tab = tab.collect({ arg x; x+10.0.rand });
		tab;
	}).stutter(1).trace,
	\sustain, 0.1,
	\dur, 1/2,
	\amp, 0.1
)).play;
);


////////

(

SynthDef(\cymbal, { arg amp=0.1, gate=1, out=0, pan=0;

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var timeScale = 1/4;
	var sig;

	locutoffenv = EnvGen.kr(Env([0,1,1],[0.1,0.8])) * 20000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);
	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 7), timeScale:timeScale) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25), timeScale:timeScale);
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:1/8);

	freqs  = \freqs.kr(100!100);

	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;
	sig = ((res * 1) + (lodriver * 2) + thwack);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.4, curve:-5)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);

}).add;

)

(
Pdef(\plop, Pbind(
	\instrument, \cymbal,
	\degree, Pseq([0],inf),
	\adsr, Pseq([
		Pfunc({
			[ Env.adsr(0.001,0.1,0.8,0.8+0.5.rand,curve:-6) ]
		}),
	],inf),
	\freqs, Pfunc({
		//[{exprand(300, 20000)}.dup(100)]
		var tab = [ [ 399.09130009481, 2021.0082664068, 651.51615319166, 710.99400766402, 2488.2222464499, 13203.951224639, 14258.604864401, 13723.043494414, 4407.7975813173, 1826.4963443411, 537.30416723109, 1096.6137117423, 500.57993359318, 8444.2337469429, 1185.5790292566, 16214.892077193, 685.04359323871, 2999.5980389403, 12565.085500307, 705.43686360864, 449.3715460827, 13437.452048582, 751.84739687507, 1816.9734921465, 1543.4129649322, 9302.4341547237, 2013.4168465097, 300.88539016904, 2606.3313154844, 15185.088863865, 900.32915502701, 349.44538962947, 3728.422128516, 464.70665727115, 627.57554554506, 7381.3726249411, 4035.71612666, 18599.957753866, 7960.9133106445, 406.90732558019, 309.73967147988, 9360.2351495684, 322.75819320302, 1192.9503838129, 10031.144462751, 1626.9049906213, 1446.6484972079, 5549.8991339648, 5782.3382679731, 2238.5647166308, 495.61247800552, 317.15073705111, 15634.297160898, 926.71544040226, 382.64426331992, 1101.7031429722, 17002.807601934, 580.23326962048, 1984.3172445566, 740.8266158608, 11929.390567302, 5344.9202902011, 463.98725007629, 5339.5312136065, 567.75033673459, 513.0014020531, 13652.203334082, 639.96334515329, 422.68000533134, 1990.0281589904, 11628.476917287, 7048.032610839, 2275.9382067998, 2066.594685338, 17606.661203, 2048.0564015294, 781.14054107957, 3906.6908723773, 1683.0124529786, 15136.621959844, 3084.1151849017, 344.50030138219, 7378.6235067401, 2330.1582115245, 640.67574758462, 8684.1159500741, 15274.708459274, 452.13100911768, 1393.1723602525, 2725.9180963437, 15992.051904338, 4013.6314904242, 9914.4475710747, 2526.8823318363, 503.59102969078, 1666.2638444851, 12102.807445106, 494.30186498437, 2577.5320723269, 2132.8388093785  ]  ];

		tab = tab.collect({ arg x; x+10.0.rand });
		//tab = tab * 0.2.rand;
		tab;
	}).stutter(1),
	\sustain, 0.1,
	\dur, 1/2,
	\amp, 0.1
)).play;
);


///

(

SynthDef(\cymbal, { arg amp=0.1, gate=1, out=0, pan=0;

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var timeScale = 1/1;
	var sig;

	locutoffenv = EnvGen.kr(Env([0,1,1],[0.1,0.8])) * 2000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);
	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 1), timeScale:timeScale) * 1000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25), timeScale:timeScale);
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1), timeScale:1)/4;

	freqs  = \freqs.kr(100!100);

	res    = Ringz.ar(lodriver + hidriver + thwack, freqs,0.0418).mean;
	sig = ((res * 1) + (lodriver * 2) + thwack);

	sig = LPF.ar(sig, 1700);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.4, curve:-5)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);

}).add;

)

(
Pdef(\plopx, Pbind(
	\instrument, \cymbal,
	\degree, Pseq([0],inf),
	\adsr, Pseq([
		Pfunc({
			[ Env.adsr(0.001,0.1,0.8,1.7+0.5.rand,curve:-6) ]
		}),
	],inf),
	\freqs, Pfunc({
		//[{exprand(300, 20000)}.dup(100)]
		var tab = [ [ 399.09130009481, 2021.0082664068,
			651.51615319166, 710.99400766402, 2488.2222464499,
			13203.951224639, 14258.604864401, 13723.043494414,
			4407.7975813173, 1826.4963443411, 537.30416723109,
			1096.6137117423, 500.57993359318, 8444.2337469429,
			1185.5790292566, 16214.892077193, 685.04359323871,
			2999.5980389403, 12565.085500307, 705.43686360864,
			449.3715460827, 13437.452048582, 751.84739687507,
			1816.9734921465, 1543.4129649322, 9302.4341547237,
			2013.4168465097, 300.88539016904, 2606.3313154844,
			15185.088863865, 900.32915502701, 349.44538962947,
			3728.422128516, 464.70665727115, 627.57554554506,
			7381.3726249411, 4035.71612666, 18599.957753866,
			7960.9133106445, 406.90732558019, 309.73967147988,
			9360.2351495684, 322.75819320302, 1192.9503838129,
			10031.144462751, 1626.9049906213, 1446.6484972079,
			5549.8991339648, 5782.3382679731, 2238.5647166308,
			495.61247800552, 317.15073705111, 15634.297160898,
			926.71544040226, 382.64426331992, 1101.7031429722,
			17002.807601934, 580.23326962048, 1984.3172445566,
			740.8266158608, 11929.390567302, 5344.9202902011,
			463.98725007629, 5339.5312136065, 567.75033673459,
			513.0014020531, 13652.203334082, 639.96334515329,
			422.68000533134, 1990.0281589904, 11628.476917287,
			7048.032610839, 2275.9382067998, 2066.594685338,
			17606.661203, 2048.0564015294, 781.14054107957,
			3906.6908723773, 1683.0124529786, 15136.621959844,
			3084.1151849017, 344.50030138219, 7378.6235067401,
			2330.1582115245, 640.67574758462, 8684.1159500741,
			15274.708459274, 452.13100911768, 1393.1723602525,
			2725.9180963437, 15992.051904338, 4013.6314904242,
			9914.4475710747, 2526.8823318363, 503.59102969078,
			1666.2638444851, 12102.807445106, 494.30186498437,
			2577.5320723269, 2132.8388093785  ]  ];

		//tab = tab.collect({ arg x; x+1.0.rand });
		tab = tab * 0.02 + 80;
		tab;
	}).stutter(1),
	\sustain, 0.1,
	\dur, 1/2,
	\amp, 0.1,
	//\out, BusDef(\sendbus1, \audio),
)).play;
);
