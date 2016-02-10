
{LPCAnalyzer.ar(SoundIn.ar,Impulse.ar(140,0,0.2), 256, 50)}.play
{LPCAnalyzer.ar(SoundIn.ar,LFSaw.ar(MouseX.kr(0.01,10000))/44, 256, 50)}.play
{SoundIn.ar*LFSaw.ar(140)}.play

(
Ndef(\anal, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = MouseX.kr(0.01,500) * ((1..3)/MouseY.kr(1,16) + 1);
	sig = LPCAnalyzer.ar(SoundIn.ar([0,1]),
		SinOsc.ar(freq) 
		/14
	, 256/1, 50/4);
	sig.debug("sig");
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\anal, { arg freq=200, pan=0, amp=0.1;
	var sig;
	SoundIn.ar([0,1]);
}).play;
);

(
Ndef(\anal, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = MouseX.kr(0.01,500);
	sig = LPCAnalyzer.ar(SoundIn.ar([0,1]),
		Impulse.ar(freq) /1
	, 256/1, 50);
	sig.debug("sig");
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\anal).put(0, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LPCAnalyzer.ar(SoundIn.ar([0,1]),
		LFSaw.ar(freq) /85
	, 256/1, 50);
	sig = LeakDC.ar(sig);
	sig = sig / 28;
	sig.debug("sig");
	//sig = Pan2.ar(sig, pan, amp);
}).play;
Ndef(\anal).put(10, \set -> Pbind(
	\degree, Pseq([0,0,0,-2, 0,-1,0,1],inf),
	\octave, 5,
	\dur, 1/4,
	\amp, 0.1
));
);

(
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([70, 40, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.2], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.1
)).play;
);

(
SynthDef(\zkick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m, son;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env0.kr(Env.new([0, 1, 0.5, 0], [0.105, 0.16, 00.2], [-4, -2, -4]));
	env1 = \env1.kr(Env.new([110, 32, 29], [0.105, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	env1m = env1.midicps;
	
	son = LFPulse.ar(env1m * freqpan, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*fratio);
	son = son + SinOsc.ar(env1m, 0.5);
	son = LPF.ar(son, \lpf.kr(2000));
	
	//son = son * 1.2;
	//son = son.clip2(1);

	son = son * amp;
	son = son * env0 * 6;
	son = Pan2.ar(son, pan, amp);
	
	OffsetOut.ar(out, son);
}, metadata:(specs:(
	env0: XEnvSpec( ControlSpec(0,9,\lin)!4, ControlSpec(0,2,\lin)!4 ),
	env1: XEnvSpec( ControlSpec(0,127,\lin)!3, ControlSpec(0,2,\lin)!3 ),
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).store;
)
