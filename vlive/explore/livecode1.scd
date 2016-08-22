(
SynthDef(\sdkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	son = LPF.ar(son, \lpf.kr(2000));
	
	//son = son * 1.2;
	//son = son.clip2(1);

	son = son * amp;
	son = son * env0 * 8 * 2;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;

SynthDef(\sdsnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var click=0, osc=0, snare=0;
	click = WhiteNoise.ar;
	click = click * EnvGen.kr(Env([0,1,0],[0.001,0.004]), 1) * 1;

	osc = SinOsc.ar( EnvGen.kr(Env([400,150,151],[0.01,0.08]), 1) );
	osc = osc * EnvGen.kr(Env([0,1,0],[0.001,0.20], -4), 1);
	osc = osc * 2;
	osc = HPF.ar(osc, 180);

	snare = WhiteNoise.ar;
	snare = LPF.ar(snare, EnvGen.ar(Env([14700,4852,3451],[0.01,0.1]), 1));
	snare = HPF.ar(snare, EnvGen.ar(Env([9700,4452,3451],[0.01,0.1]), 1));
	snare = snare * EnvGen.kr(Env([0,1,0],[0.001,0.18], -2), 1);

	sig = click + osc + snare;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\sdhat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, \lpf.kr(15100), \rq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(6100), \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1),-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

BusDef(\fxa, \audio,2);
(
Pdef(\sdkick, Pbind(
	\instrument, \sdkick,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		1,0,0,0, 0,0,1,0,
		0,0,1,0, 0,0,0,0,
		1,0,0.4,0, 0,0,1,0,
		0,0,1,0, 0,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\out, BusDef(\fxa),
	\amp, 0.1
)).play;
Pdef(\sdsnare, Pbind(
	\instrument, \sdsnare,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		0,0,0,0, 1,0,0,0,
	],inf).coin.not,
	\dur, 1/8,
	\out, BusDef(\fxa),
	\amp, 0.1
)).play;
Pdef(\sdhat, Pbind(
	\instrument, \sdhat,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		Pser([
			1,0,0,0, 1,0,0,0,
			1,0,1,0, 1,0,1,0,
			1,0,0,1, 0,0,1,0,
			1,1,1,0, 1,1,0,1,
		],32),
		Pser([
			1,1,0,0.4, 0,1,0,1,
			1,0,1,0, 1,1,0,1,
		],32),
		Pseq([
			1,0, 1,0, 1,0, 1,0,
			1,0, 1,0, 1,0, 1,0.2,
			1,0, 1,0, 1,0, 1,0.2,
			1,0.13, 1,0, 1,0, 1,0.12,
		],4),
		Pser([1,0,0,0],4*4*4)
	],inf).coin.not,
	\dur, 1/8,
	\out, BusDef(\fxa),
	\amp, 0.1/18
)).play;
);
BusDef(\yep).clear


(
Ndef(\revdel, { arg in=3, del=1, feed=1,dw=0.35;
	var ph, ph2, sr, trig,inlet,snd1,snd2;
	var sig;
	in = BusDef(\fxa, \audio, 2);
	sr=SampleRate.ir;
	inlet=InFeedback.ar(in,2);
	trig=Impulse.ar(del.reciprocal);
	ph=Phasor.ar(trig,del.reciprocal/sr);
	ph2=Wrap.ar(ph+0.5);
	snd1=AllpassL.ar(inlet,2,ph*del*2,feed)*sin(ph*pi);
	snd2=AllpassL.ar(inlet,2,ph2*del*2,feed)*sin(ph2*pi);
	sig = (inlet*(dw* -1+1))+(snd1+snd2*dw);
	sig.debug("sig");
	//sig.flop
}).play;
)
Ndef(\revdel).edit
NdefSubmix

~t = 1;
(
Ndef(\revdel).put(0, { arg in=3, del=1, feed=1,dw=0.35;
	var ph, ph2, sr, trig,inlet,snd1,snd2;
	var sig;
	del = [[1, 1/4 ]];
	in = BusDef(\fxa, \audio, 2);
	sr=SampleRate.ir;
	inlet=InFeedback.ar(in,2) + ( Ndef.ar(\revdel) / 4 );
	trig=Impulse.ar(del.reciprocal);
	//ph=Phasor.ar(trig,del.reciprocal/sr * SinOsc.kr(1/42).range(3,1));
	ph=Phasor.ar(trig,del.reciprocal/sr * Duty.kr(2/~t, 0, Dseq([
		1,2,1,4,
	]/5,inf))).lag(0.0);
	ph2=Wrap.ar(ph+2).lag(0.2);
	feed = SinOsc.kr(1/23).exprange(0.001,4);
	feed = Duty.kr(1/~t, 0, Dseq([
		1,0,5,0,
		1,0,0,2,
	],inf));
	snd1=AllpassL.ar(inlet,2,ph*del*2,feed)*sin(ph*pi);
	snd2=AllpassL.ar(inlet,2,ph2*del*2,feed)*sin(ph2*pi);
	snd1 = LPF.ar(snd1, 400 * SinOsc.kr(1/13).range(1,14));
	snd2 = LPF.ar(snd2, 400 * SinOsc.kr(1/14).range(1,14));
	dw = 0.5;
	dw = Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,1, 0,0,1,0,
		0,0,0,1, 1,1,1,0,
		1,1,0,1, 1,1,1,0,
		1,0,1,1, 0,1,1,0,
	],inf));
	//inlet = 0;
	sig = (inlet*(dw* -1+1))+(snd1+snd2*dw);
	sig = inlet + (snd1+snd2 * dw);
	//snd2;
	sig.debug("sig");
	sig = sig.flop.sum;
}).play;
)

(
Ndef(\revdel).put(1, \filter -> { arg in;
	var sig;
	var infb;
	sig = in;
	infb = Ndef.ar(\revdel);
	sig = sig + ( ( infb * 10 ).tanh * ( \fb.kr(0.3) ) );
	sig = sig + Greyhole.ar(sig, \delay.kr(4),\damp.kr(0.1),\size.kr(1/6), \diff.kr(0.107) , \feedback.kr(0.1), \modDepth.kr(0.1), \modFreq.kr(2));
	sig = sig /4;
	sig = Limiter.ar(sig);
	sig = sig /4;
});
)

(
Ndef(\ss, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Ndef.ar(\ss);
	//sig = Ndef(\e)
	sig = sig + SinOsc.ar(freq!2 * SinOsc.kr(1/23).range(2,1), mul:XLine.kr(1,0.0001,2));
	sig;
}).play;
);

(
Ndef(\revdel).put(2, \set -> Pbind(
	\diff, 0.05,
	\diff, Pseq([
		0,0,0,0, 0,0,0,0,
		1,3,0.3,0.7, 1,3,0.3,0.7,
		0,0,0,0, 0,0,0,0,
		1,3,0.3,0.7, 0,0.3,1.3,0.7,
	],inf) / 3,
	\fb, Pseq([1,0.5,0.1,0],inf).stutter(1),
	\fb, Pseq([1,1,1,8, 0,0,0,0],inf).stutter(1),
	\damp, Pseq([0.2,0.2,0.2,1,0],inf),
	\feedback, Pseq([1,3,0.3,0.7],inf).stutter(4) / 5,
	\feedback, Pseq([1,0.01,1,0.5],inf),
	//\size, Pseq([3,0.3,0.7],inf).stutter(5),
	\delay, Pseq([1,1/4,1/8,2],inf),
	\dur, 1/4,
));
)


Ndef(\revdel).put(1, nil)
Ndef(\revdel).fadeTime = 4

Ndef.defaultQuant = 2;
Pdef.defaultQuant = 2;
