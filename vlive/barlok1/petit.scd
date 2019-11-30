(
Ndef(\ota, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fac = 1/SelectX.kr( SinOsc.kr(1/113).range(0,6), [1/2,1,2,4,8,64,128] )/8;
	env1 = EnvGen.ar(Env([42,21,42,30,84],[4,4,7.5,0.5]/fac).circle, 1);
	env2 = EnvGen.kr(Env([0,0,2,1],[4,4,4]).circle, 1);
	env3 = XLine.kr(1,0.1,20*1);

	freq = 8.collect({ arg x;
		freq + ( env1 * x ) + [0,SinOsc.kr(x+1, mul:env2).range(0,10*x)];
	});
	//freq.debug.shape.debug("freq");
	sig = SinOsc.ar( freq / [1,2,4]);
	//sig.shape.debug("sig1");
	sig = sig.collect({ arg isig, x;
		isig = SelectX.ar( SinOsc.kr(x+1/34).range(0,1), [isig, isig.fold2(env3)]);
		isig = SelectX.ar( SinOsc.kr(1/223, 3pi/2).range(0,1), [isig, ( isig * SinOsc.kr(1/48 * ( x + 1 )).range(1,100) ).tanh]);
	});
	//sig.shape.debug("sig2");
	sig1 = sig.flop[1];
	sig = sig.flop[0];
	//sig.debug("sig");
	sig1 = Pan2.ar(sig1, SinOsc.ar(sig1.size.collect({ arg x; SinOsc.kr(x/10+1.2).range(0,8) })) * SinOsc.kr(1/48).range(0,1), amp).mean;
	sig = Pan2.ar(sig, SinOsc.ar(sig.size.collect({ arg x; SinOsc.kr(x/10+1.1).range(0,8) })) * SinOsc.kr(1/58).range(0,1), amp).mean;
	sig = sig + sig1;
	sig = sig / 1.0;
	sig = LPF.ar(sig, 1999);
	sig;
}).play;
);


(
~t = ~t ? 1;
Ndef(\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var cond = Line.kr(-1,1,64);
	var mix, index;
	var env1;
	env1  = EnvGen.kr(Env([0,2,128,128*10,128*100,128*500,128*7000],[52,8,8,8,8,8]), 1);
	cond = LFTri.ar(( 1/128*env1 ).poll, pi);
	mix = cond.range(0,1);
	index = cond.range(0,1);
	mix = IEnvGen.kr(Env([0,0.001,1,0],[1,1,1].normalizeSum),index);

	freq = 120 * 
	SelectX.kr(mix, [
	//SelectX.kr(0, [
		Duty.kr(1/~t, 0, Dseq([
			[0,3,7,12,-12] ,
		],inf)).midiratio,
		( [0,3,7,12,-12] * 0.1 ).midiratio,
	]) *.x [1/2,1,2] * Duty.kr(4/~t, 0, Dseq([
		0,2,
	],inf)
		).midiratio
	;

	sig4 = SinOsc.ar(Select.kr(mix**2 * 2, [4,8,32,128])) * 5;
	sig5 = LFSaw.ar(Select.kr(mix**2 + 1* 2, [4,8,32,128])) * 5;
	sig4 = SelectX.ar(mix**4 * 3, [DC.ar(1), sig4,sig5,sig4]);
	sig = SinOsc.ar(freq * sig4 * ( 1 + ( SinOsc.ar(freq) * ( SinOsc.kr(1/7/5 * (1..8)/8).range(0,4) * cond.range(1,10) ) )));
	sig1 = sig;
	sig2 = LFSaw.ar(freq*2 * [1,1/2,2]) + sig;
	sig = SelectX.ar(mix*4, [sig2, sig2, sig2, sig2, sig]);
	sig2 = sig.fold2(1 * SinOsc.kr((1..8)/4/8).range(0.3,1 * cond.range(0,1))) + sig;
	sig = SelectX.ar(mix, [sig, sig2]);
	sig2 = sig.wrap2(1 * SinOsc.kr((1..8)/8*1/5.2).range(0.3,1)) + sig;
	sig = SelectX.ar(mix, [sig, sig2]);
	sig2 = sig & (sig << 1 | LFSaw.ar(1/100 * (1..8)/8).range(0,10000));
	sig = SelectX.ar(mix, [sig, sig2]);
	sig = SelectX.ar( SinOsc.kr(1/7 * (1..8)/8).range(0,1), [sig, sig1]);
	//sig = sig * sig
	sig = sig.collect({ arg isig, x; isig * SinOsc.kr(1/7/5 * x).range(0.2,1) });

	sig = SelectX.ar(mix.lag(32), [
		sig,
		BPF.ar(sig, SinOsc.kr(1/8*~t).range(120,15000))
	]);

	//sig = sig * EnvGen.kr(\iadsr2.kr(Env.adsr(0.001,0.1,0.8,0.1)), Trig.kr(\itrig2.tr(1),\isustain2.kr(1)), doneAction:0);

	pan = 1;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	amp = amp * \gain.kr(1);
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size * pan, amp).mean;
	sig = * 2;
	sig;
}).play;

)
Ndef(\fx).play(BusDef(\fx1).index, 2)
Ndef(\fx).play(0, 2)
Ndef(\myfx1).play
Ndef(\myfx1).edit
