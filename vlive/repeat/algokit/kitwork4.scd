
(
SynthDef(\bigkick, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.ar(Env([1001,69,50],[0.01,0.1]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, env1, \rq.kr(0.001));
	sig = sig / 3;
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bigkick, Pbind(
	\instrument, \bigkick,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,1,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,0,0,
		1,0,0,0, 1,0,1,1,
	],inf).coin.not,
	\sustain, 1/16 + ( Pkey(\isRest).not.asInteger * 0.1 ),
	\dur, 1/16,
	//\out, BusDef(\sendbus0, \audio),
	\amp, 0.1
)).play;
);

(
Ndef(\acid, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
	sig = in;
	sig = RLPF.ar(sig, SinOsc.kr(1/4 * ~t * [1,1.5]).range(100,12000), \rq.kr(0.05)).flop.mean;
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.01), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * 1.8 + ( in * 0.8 );
	sig = sig /2;
	sig;
}).play;
);

(
SynthDef(\playerrepsec, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, velamp=1, trigfreq=1, at=0.001, rel=0.001;
	// pos in seconds
	var sig;
	var sig1;
	var trigger;
	trigfreq = XLine.kr(7,812,1.4);
	trigger = Impulse.ar(trigfreq);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(Env([ 0,1,1,0 ], [at, ( trigfreq.reciprocal - at - rel ).clip(0,100000),rel]),trigger,doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * amp * velamp);
}).add;
)

BufDef.loadDialog(\kick)
(
Pdef(\playerrepsec, Pbind(
	\instrument, \playerrepsec,
	\bufnum, BufDef(\kick),
	\degree, Pseq([0],inf),
	\pos, 0.04,
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
	],inf),
	\sustain, 0.6,
	\trigfreq, 10,
	\dur, 1,
	\amp, 0.5
)).play;
);

(
SynthDef(\acid, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFSaw.ar(freq);
	//sig = sig + PinkNoise.ar(1);
	env1 = EnvGen.kr(Env([1/2,4,1/4],[0.01,0.4]), 1);
	env2 = EnvGen.kr(Env([0.01,0.31,0.21],[0.1,0.01]), 1);

	env3 = EnvGen.kr(Env([2,1,1/4],[0.2,0.1]), 1);
	env4 = EnvGen.kr(Env([0.8,0.031,0.71],[0.2,0.4]), 1);
	sig = RLPF.ar(sig, ( env1 * freq ).clip(40,15000), env2) +
			RLPF.ar(sig, ( env3 * freq ).clip(40,15000), env4);
	sig = HPF.ar(sig, 100);
	sig = sig.tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

5.midiratio
1+1/3
4/3
9/6
7.midiratio

{ SinOsc.ar( SinOsc.kr(1/2, 3/4 * 2pi).range(100,200) *  ) * LFPulse.kr(4, [0.1,0.5]).lag(0.01) * 0.1}.play;
Ndef(\rock, { SinOsc.ar( SinOsc.kr(1/2, 3/4 * 2pi).range(100,200) * Duty.kr(2,0,Dseq([6,6,8,8,6,6,9,8]/6)) ) * DelayC.ar(LFPulse.kr(4,0,0.1).lag(0.01), 0.2, [0,0.16]).sum ! 2 * 0.1}).play;
Ndef(\blues, { SinOsc.ar( 80 * [1,1.0001] * SinOsc.kr(1/2, 3/4 * 2pi).range(1,2) * Duty.kr(2,0,Dseq([6,6,8,8,6,6,9,8]/6,inf)) ) * LFPulse.kr(4,0,0.3) * 0.1}).play;
Ndef(\blues, { SinOsc.ar( 80 * [1,1.0001] * SinOsc.kr(1/2, 3/4 * 2pi).range(1,2) * Duty.kr(2,0,Dseq([6,6,8,8,6,6,9,8]/6,inf)) )  * 0.1}).play;

{ SinOsc.ar( 80 * [1,1.0001] * SinOsc.kr(1/2, 3/4 * 2pi).range(1,2) * Duty.kr(2,0,Dseq([6,6,8,8,6,6,9,8]/6,inf)) ) * LFPulse.kr(4,0,0.3) * 0.1}.play;

(
Pdef(\acid, Pbind(
	\instrument, \acid,
	\freq, Pseg(Pseq([400,800],inf),1/2)/4 * Pstep(Pseq([0,0,5,5,0,0,7,5],inf),1).midiratio,
	\freq, Pseg(Pseq([200,100],inf),1) * Pstep(Pseq([1,5/4, 3/4],inf),2),
	\sustain, 0.1/2,
	\dur, 1/8,
	\amp, 0.1
)).play;
);

(
Pdef(\acid2, Pbind(
	\instrument, \acid,
	\freq, Pseg(Pseq([400,800],inf),1/2)/2 * Pstep(Pseq([0,0,5,5,0,0,7,5],inf),1).midiratio,
	\sustain, 0.1/2,
	\dur, 1/8,
	\amp, 0.1
)).play;
);

(
Pdef(\main, 
	Pseq([
		Ppar([
			Pdef(\bigkick),
			Pdef(\sawpad),
			Pdef(\sawlead),
			Pdef(\bass),
			//Pdef(\acid),
		]),
		
	])
).play;
)

(
SynthDef(\sawpad, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( (1..8)/ SinOsc.kr(1/2, 3pi/2).range(400,100) + 1 ));
	sig = RLPF.ar(sig, freq * ( (1..8)/44 + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\sawlead, Pbind(
	\instrument, \sawpad,
	\degree, Pseq([
		0,2,4
	],inf),
	\octave, 4,
	\dur, 1/8,
	\amp, 0.1
)).stop;
Pdef(\sawpad, Pbind(
	\instrument, \sawpad,
	\degree, Pseq([
		[ 0,2,4 ]
	],inf),
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,0,0,
	],inf).coin.not,
	\legato, 4,
	\dur, 1/8,
	\amp, 0.1
)).play;
Pdef(\sawpad2, Pbind(
	\instrument, \sawpad,
	\degree, Pseq([
		[ 0,2,4 ]
	],inf),
	\dur, 1,
	\amp, 0.1
)).stop;
);

(
SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1= EnvGen.kr(Env([1,1/2,1],[0.1,0.8]), 1);
	env2= EnvGen.kr(Env([1,1/42,1],[0.1,0.8]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(8) * freq * env1, \rq.kr(0.5) * env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\lfo1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * \scale.kr(1) + \bias.kr(2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.kr(out, sig);
}).add;
);

(
Pdef(\lfo1, Pmono(\lfo1,
	\freq, Pseq([
		4,4,4,4,
		4,4,4,8,
		4,4,4,4,
		4,4,8,8,
		4,4,4,4,
		4,4,4,2,
		4,4,4,4,
		4,4,2,2,
	],inf),
	\scale, 8,
	\bias, 8,
	\dur, 1/2,
	\out, BusDef(\lfo1, \control),
)).play;
);
(
Pdef(\bass, Pbind(
	\instrument, \bass,
	\degree, Pseq([0],inf),
	\lpfr, BusDef(\lfo1).asMap,
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);




(
TrackDef(\grid1, TrackDef(\playergrid));
TrackDef(\grid1).source = [
	[
		ProtoDef(\rdn),
	],
	[
		Pdef(\bigkick),
		Pdef(\bigkick2, Pbind(\dur, 1/4) <> Pdef(\bigkick)),
	],
	[
		Pdef(\sawpad),
	],
	[
		Pdef(\sawlead),
	],
	[
		Pdef(\acid),
	],
	[
		Pdef(\acid2),
	],
	[
		Pdef(\bass),
	],
	[
		Pdef(\drums),
	],
];
);

//TrackDef(\grid1).edit;
WindowDef(\multigrid).front;


KitTimeline(\kitwork4_loop, PatKitDef(\kitwork4_loop)).edit
(
PatKitDef(\kitwork4_loop).targets = 
[
	[
		BufDef('loop/loop3_185bpm.flac'),
		BufDef('loop/loop3b_185bpm.flac'),
		BufDef('loop/loop3c_185bpm.flac'),
	].collect({ arg buf;
		8.collect({ arg idx;
			StepEvent.newFrom((
				instrument: \playersec,
				speed: 1,
				bufnum: buf,
				pos: idx/4/~t + 0.04,
			))
		})

	
	})
].flat;
)
