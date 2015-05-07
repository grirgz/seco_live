
(
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var freq2;
	var pan;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var cond = Line.kr(-1,1,64);
	var mix, index;
	var env1;
	env1  = EnvGen.kr(Env([1,2,128,128*10,128*100,128*500,128*7000],[32,8,8,8,8,8]), 1);
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
	])
	*.x [1/2,1,2]
	* Duty.kr(4/~t, 0, Dseq([
		0,2,
	],inf)).midiratio
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
	sig;
});

Ndef(~name+++\fx).put(2, \set -> Pbind(
	\isustain2, Pseq([2],inf),
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,2.53) ],
			[ Env.adsr(0.08,0.1,0.8,7.53) ],
			[ Env.adsr(0.01,0.1,0.8,0.53) ],
			[ Env.adsr(0.01,0.1,0.8,2.53) ],
			[ Env.adsr(0.01,0.1,0.8,1.53) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\iadsr2, Plazy({ arg ev;
		Pwalk([
			[ Env.adsr(0.01,0.1,0.8,1.73) ],
		],Pseq([1,1,1,1,4,2,1,-4,Prand([2,1,-2,-3],1)],1));
	}).loop,
	\itrig2, Pseq([
		1,1,
	],inf),
	\dur, 1,
));
)

(
~name = \alternateur;
~t = ~t ? 1;
Ndef(~name+++\fx).put(0, { arg amp=0.1;
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
	])
	*.x [1/2,1,2]
	* Duty.kr(4/~t, 0, Dseq([
		0,2,
	],inf)).midiratio
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
	sig;
}).play;

)
