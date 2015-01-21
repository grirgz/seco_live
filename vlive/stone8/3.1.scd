
(
Ndef(~name+++\fx).put(0, { arg amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1;
	var env0, env1, env1m, son;
	var son1, son2, son3, son4;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var env2, env3, env4;
	var distlim = 1;
	var trig;
	var lfo1, lfo2, lfo3;

	trig = Impulse.kr(8*~t);
	trig = \trig.kr(1);

	//freqpan = [-1,0,1] * freqpan;
	freqpan = 1 + ([1,0,-1] * freqpan);
	env0 = (Env.new([0, 1, 0.5, 0], [0.0105, 0.316* SinOsc.kr(1/4).range(1,1.8), 00.1]));
	env1 = (Env.new([110, 70 * SinOsc.kr(1/7).range(1,0.8), 32, 35], [0, 0.05105, 0.19] ));
	
	env0 =  EnvGen.ar(env0, trig, doneAction:0, timeScale:timeScale);
	env1 = EnvGen.ar(env1, trig, timeScale:timeScale);
	env1m = env1.midicps;
	
	lfo1 = SinOsc.ar(env1m/2 * SinOsc.kr(1/15).range(1,2)) * env0 * 1 * SinOsc.kr(1/12).range(0,1);
	//lfo1 = 0;
	sig = SinOsc.ar(lfo1 + 1 * env1m, pi/2);
	//sig = SinOsc.ar(env1m, pi/2);
	sig = sig * env0;
	sig = sig * 10;

	sig = Splay.ar(sig, spread, amp, pan);
	
	
	amp = amp * \gain.kr(1);
	sig = sig * amp;
	sig;
});

Ndef(~name+++\fx).put(1, \set -> Pbind(
	\trig, Pseq([1,0,0,1, 0,0,1,0],inf),
	\dur, 1/4,
));
)
