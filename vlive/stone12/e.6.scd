
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var rel;
	freq = 50 * Duty.kr(4/~t, 0, Dseq([
		//1,2,4,2,
		4
	],inf)).lag(1.4) * 1;
	freq = freq * Duty.kr(4/~t, 0, Dseq([
		//[0,3,7,12],
		//[0,3,7,15],
		//[0,3,8,12],
		//[0,3,8,11],
		[0,3,7,12],
		[0,3,8,13],
	],inf)).midiratio *.t [1/2,8/9,1,2];
	freq = freq *.x [1,1.001,1.00012];
	sig = LFSaw.ar(freq );
	env2 = Duty.kr(1/~t, 0, Dseq([
		1,0,1,0,
	],inf)).lag(0.1);
	env1 = EnvGen.kr(Env([1,200,1,1],[4.01,0.1,0.1].normalizeSum), env2, timeScale:1);
	rel = Duty.kr(2/~t, 0, Dseq([
		1,4,1,1/4,
	],inf));
	env3 = EnvGen.kr(Env([0,1,0.7,0],[4.01,rel*0.1,0.3].normalizeSum), env2, timeScale:1);
	sig = sig.collect({ arg isig, x;
		//isig = isig - Latch.ar(LPF.ar(isig.clip(0.1),100), Impulse.ar(50));
		isig = isig * SinOsc.ar(freq[x], isig * env1);
		isig = RLPF.ar(isig,  LFNoise1.kr(1/(x+24)).range(100,15000), SinOsc.kr(1/(x+ 12 )).range(0.6,1));
		isig = HPF.ar(isig, 1000);
		//isig = ( isig < 0.03 ) * isig;
		//isig = isig * DelayL.ar(isig,0.01*1.1,0.01 * SinOsc.kr(1/( x+74 )).range(1,1.01));
		//isig = isig * DelayL.ar(isig,0.041*1.1,0.041 * SinOsc.kr(1/(x+ 44 )).range(1,1.01));
		isig = SelectX.ar( SinOsc.kr(x+1/40).range(0,1) * (isig.size-1), isig);
		//isig = isig * SinOsc.kr(1/17).range(0,1);
	});

	sig.debug("sig");

	sig = sig / 4;

	sig = sig* env3;
	
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
})

// END

p
(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\note, 
	Pseq([
		
		[0,3,8,12],
		[0,3,8,13],
		[0,4,8,13],
		[0,4,8,12],
	],inf),
	\legato, 0.5,
	\dur, 1/2,
	\amp, 0.1
)).play;
);
