
(
~t = 180/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
)

(
SynthDef(\hikick, { |out=0, amp=0.1, pan=0, fratio=1.5, freqpan=0.01, spread=0.08, timeScale=1|
	var env0, env1, env1m;
	var sig;

	//freqpan = [-1,0,1] * freqpan;
	env0 = \env.kr(Env.new([0, 1, 0.5, 0], [0.005, 0.16, 00.2], [-4, -2, -4]));
	env1 = \freqenv.kr(Env.new([210, 62, 59], [0.045, 0.29], [-4, -5]));
	
	env0 =  EnvGen.ar(env0, doneAction:2, timeScale:timeScale);
	env1 = EnvGen.ar(env1, timeScale:timeScale);
	
	sig = LFPulse.ar(env1 * freqpan, 0, 0.5, 1, -0.5);
	sig = sig + WhiteNoise.ar(1);
	sig = LPF.ar(sig, env1*fratio);
	sig = sig + SinOsc.ar(env1, 0.5);
	sig = LPF.ar(sig, \lpf.kr(2000));
	
	//sig = sig * 1.2;
	//sig = sig.clip2(1);

	sig = sig * env0;
	sig = Pan2.ar(sig, pan, amp);
	
	OffsetOut.ar(out, sig);
}, metadata:(specs:(
	timeScale: ControlSpec(0.001,4,\lin, 0, 1),
))).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \hikick,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\env, [ Env.new([0, 1, 1.5, 0], [0.005, 0.06, 0.02], [-4, -2, -4]) ],
			\freqenv, PpatEnv([Pseg(Pseq([100,1001],inf),8*4), 82, 89], [0.045, 0.29], [-4, -5]),
			\legato, 1,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, 3,
			\octave, 3,
			\lpf, 400,
			\dur, 1/8,
			\legato, 0.3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.03) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			//\envamt, PmodEnv(Pseq([1,8],1), 8*4).loop,
			\envamt, Pseg(Pseq([0,8],inf),8*4),
			//\envamt, 3,
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		
	])
)).play;
);

~s = PpatEnv([Pseq([100,1001],inf), 82, 89], [0.045, 0.29], [-4, -5]).asStream
~v = ~s.next
~v[0].dump

(
SynthDef(\sawenv2, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
    var sig, sig1, sig2, sig3;
    var env;
    sig = LFSaw.ar(freq * [1.01,1,0.99]);
    env = EnvGen.kr(\lpenv.kr(Env([1,2,1,2],[0.1,0.8,0.1].normalizeSum)), gate);
    sig = RLPF.ar(sig, env * freq, \rq.kr(0.5));
    sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
    sig = Splay.ar(sig, spread, amp, pan);
    Out.ar(out, sig);
}).add;
);

(
Pdef(\doc,
    Pbind(
        \instrument, \sawenv2,
        \note, Pseq([1,5,2,0],inf),
        // env must have same size as env in SynthDef
        //\lpenv, PpatEnv( Pwhite(0.1,2.9,inf)!4, Pwhite(0.1,1/2,inf)!3 ),
        \lpfr, 1,
        \legato, 1,
        \dur, 1,
    ),
).trace.play;
)

{ SinOsc.ar(500) ! 2 * 0.1}.play;
