

~pdef_channel.();

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1, env2, env3;
	var fspread = 0.01;
	env1 = EnvGen.ar(Env.adsr(0.1,0.1,1,0.1),gate,doneAction:0, levelScale:1);
	sig1 = SinOsc.kr(freq * (env1+8) * ( (1..8)/8 * env1 +1)) * env1;
	freq = freq * ((0..7)/7 - 0.5 * fspread + 1);
	sig = SinOsc.ar(freq *.t [1,1/2,2], sig1);
	sig.debug("sig");
	sig = sig.flop.collect({ arg sig,x; sig * SinOsc.kr(1/( 7+x )).range(0,1) });
	sig = sig.flop * \harm.kr([1,1,1]);
	sig = sig.flat;
	sig = RLPF.ar(sig, \xlpf.kr(1/2) * freq * (1..8)/8, \rq.kr(0.5));
	//sig = HPF.ar(sig, 400);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
~pdef_init.(Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1
))
);
