(
Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([700,500,300],inf).stutter(2) + Pseq([50,0],inf),
	\freqlag, 0.05,
	\legato, 0.9,
	\n, 0.2,
	\dur, 1/1,
));
	//Ndef(~name+++\mlfo1, { arg freq; DC.kr(freq) });
	Ndef(~name+++\mlfo1, { arg t_xgate=1, freq; EnvGen.kr(Env([0,1,0.0,1,0],[0.1,0.1,0.1,0.1]),t_xgate).poll * 0.91 + 1 * freq });
	Ndef(~name+++\mlfo1, { arg freq; freq });
	Ndef(~name+++\mlfo1).fadeTime.debug("quant");
	Ndef(~name+++\mlfo1).fadeTime = 0.0;
Pdef(~name+++\mono, { arg freq, ins, n=1;
	var fre = freq;
	//TempoClock.default.beats.debug("wait what ?");
	//Ndef(ins+++\mlfo1, { EnvGen.kr(Env([0,0,0.0,0,0],[0.1,0.1,0.1,0.1]),1) * 0.91 + 1 * fre.value });
	Ndef(ins+++\mlfo1).set(\freq, fre.value, \xgate, 1);
	Pmono(ins.value,
		\type, \monoSet,
		//\instrument, ~name,
		\ffreq, Pseq([200,300,500,1000],inf),
		\ffreq, 1000,
		\rq, 0.1,
		\freq, Pseq([fre.value,fre.value*0.5,fre.value*0.1],inf),
		\freq, fre.value / 4,
		//\freq, Ndef(ins+++\mlfo1, { Linen.kr(1, 0.1,1,0.2) * 0.91 + 1 * fre.value }).bus.asMap,
		\freq, fre.value,
		//\freq, Ndef(ins+++\mlfo1, { EnvGen.kr(Env([0,0,0.0,0,0],[0.1,0.1,0.1,0.1]),1) * 0.91 + 1 * fre.value }).bus.asMap,
		\freq, Ndef(ins+++\mlfo1).bus.asMap,
		//\dur, Pseq([1/6,1/8],inf) * n.value,
		\dur, 1/1,
	)
});
);
