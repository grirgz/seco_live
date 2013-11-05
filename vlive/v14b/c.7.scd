(
Ndef(~name+++\lfo1, { SinOsc.kr(4).range(500,1800)  });
Ndef(~name+++\lfo2, { SinOsc.kr(2).range(0,10)  });
Pdef(~name +++ \pre, Pbind(
	//\freq, Pseq([300,500,520,480]*5/7,inf).stutter(2),
	\degree, Pseq([1,7,0,5],inf).stutter(2),
	\octave, 5,
	\mtranspose, Pstep(Pseq([0,2],inf),2),
	\ffreq, Ndef(~name+++\lfo1),
	//\mix1, Ndef(~name+++\lfo2),
	\tabspread, Ndef(~name+++\lfo2),
	\isRest, Veco(~namex).isrest(16),
));

Ndef(~name+++\fx, {
	var in = In.ar(BusDef(~name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var env;
	var trig;
	var spread=0.8;
	var pan = 0;
	sig = in;
	trig = in > 0.4;
	env = EnvGen.kr(Env([0,1,0],[0.1]), trig);
	//env = EnvGen.kr(Env.adsr(0.1,0.1,0.8,0.1), trig);
	sig = sig + DelayL.ar(sig, 0.4,0.4*env+0.001);
	sig1 = sig * SinOsc.ar(Latch.ar(sig, trig).lag(0.1).range(1,2) * 400);
	sig = SelectX.ar(Latch.ar(sig, trig).lag(0.01).range(0,2),[sig,(sig*100).tanh/50],sig1);
	//sig = RLPF.ar(sig, SinOsc.kr(1+Latch.ar(sig, trig).lag(0.1)).range(100,1000) * Array.series(8,1/4,1/4), 0.3);
	sig = RLPF.ar(sig, SinOsc.kr(1+Latch.ar(sig, trig).lag(0.1)).range(100,1000), 0.3);
	//sig = Splay.ar(sig, spread, 1, pan);
	//sig = CombL.ar(sig, 0.4,t/2,1) + sig;
	//sig = CombL.ar(sig, 0.4,t/8,1) + sig;
	sig;
});
)

