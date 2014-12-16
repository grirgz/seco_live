

~pdef_channel.();

(

SynthDef(~name, { arg out=0, amp=0.1;
	var sig;
	var freq;
	var trig;
	var env1, env2;
	var fspread;
	fspread = 0.001;
	fspread = \fspread.kr(0.001);
	freq = \freq.kr(50);
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	//trig = Trig.kr(Impulse.kr(1*~t),0.1);
	trig = \gate.kr(1);
	env1 = EnvGen.kr(Env([0,2,1.0],[0.004,1.8]), trig);
	env2 = EnvGen.kr(Env([0,2,0.1],[0.004,0.8]), trig);
	sig = SinOsc.ar(freq * SinOsc.ar(freq ,mul:env2*1/2,add:1));

	sig = EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.3,0.31,1.0,1,-9)),trig,doneAction:2) * sig;
	sig = RLPF.ar(sig, \lpf.kr(200) * env2, \rq.kr(0.5));
	sig = HPF.ar(sig, 100);
	//sig = (sig*10 * LFNoise1.kr(1/2).range(0.0,7.0)).tanh;
	sig = sig * 1;
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)*0.1} ! sig.size, amp).flop;
	Out.ar(out, sig);
}).add;
);

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
