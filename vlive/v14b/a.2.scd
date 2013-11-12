Pdef(~name +++ \pre, Pbind(
	\freq, Pseq([50,60,40],inf) + [0,1],
	\freq, Pseq([50,40,80,60,80],inf) + [0,1],

	//\freq, Pseq([50,60],inf) + 0,
	\legato, 1,
	\dur, Pseq([1/4,1/8,1/8,1/4,1/4]*8,inf);
));
Pdef(~name+++\pre).quant=4;

(
Ndef(~name+++\fx, { arg ffreq=300, rq=0.3, choose=1, freqshift=40, time=2;
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var ramp;
	var buf = LocalBuf(2*s.sampleRate, 2);
	var rate;
	var choosetrig;
	sig = in;
	sig1 = RLPF.ar(sig, ffreq, rq);
	ramp = Sweep.kr(Impulse.kr(1/time), 1/time * freqshift) * -1;
	//sig2 = FreqShift.ar(sig, ramp);
	choosetrig = choose > 0;
	RecordBuf.ar(sig, buf, loop:1, trigger:choosetrig);
	//rate = 1-Sweep.kr(Impulse.kr(1/time), 1/time * 0.1); 
	//choosetrig = Impulse.kr(1/time);
	rate = EnvGen.kr(Env([1,1,0.7],[0,time]), choosetrig);
	sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);
	sig = Select.ar(choose, [sig1, sig2]);
	//sig = sig2;
	sig;
});
Ndef(~name+++\lfo1, { arg freq=4, base=2100, choose=0, loval=5, hival=1000, time=1; 
	Select.kr(choose, [
		SinOsc.kr(freq).range(5,base), 
		//Line.kr(loval, hival, time)
		Sweep.kr(Impulse.kr(1/time), 1/time) * base + 50,
		//EnvGen.kr(Env([0,1,0],[time,0]).circle, 1),
	])
});
Ndef(~name+++\lfo1).quant=4;
Ndef(~name+++\fx).map(\ffreq, Ndef(~name+++\lfo1));
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\freq, Pseq([
		4,4,4,8,
		0,0,0,0,
		8,8,4,4,
		0,0,0,0,

		4,6,4,8,
		0,0,0,0,
		8,8,4,4,
		0,0,0,0,
	],inf) * Pfunc({ ~num_beats }),
	\choose, Pseq([
		0,0,0,0,
		1,1,1,1,
		0,0,0,0,
		1,1,1,1,
	],inf),
	\base, Pseq([1000,1500,5000,2000],inf).stutter(4) + Pseq([0,-500,0,500],inf),
	\time, Pseq([1,1,1,2],inf).stutter(4),
	\dur, 1/2,
));
Ndef(~name+++\fx).put(1, \set -> Pbind(
	//\freq, Pseq([
	//	4,4,4,8,
	//	0,0,0,0,
	//	8,8,4,4,
	//	0,0,0,0,
	//],inf),
	\choose, Pseq([
		0,0,0,0,
		0,0,0,1,
	],inf).stutter(4),
	\time, 2,
	//\base, Pseq([5000,5000,5000,2000],inf),
	//\time, Pseq([1,1,1,2],inf).stutter(4),
	\dur, 1/2,
));
);

// END

Ndef(~name+++\fx).play;
