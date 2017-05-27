
(
SynthDef(\tigrain, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(\fmf.kr(24) * ( 1 + ( SinOsc.ar([4,8,16]*~t, 0.2) * 1.41 )) * XLine.kr(1,0.001,4)) * 1 )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 3;
	pan = pan + LFNoise1.ar((1..4)/48,mul:0.5);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\tigrain2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * [1,1.01]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 3;
	pan = pan + LFNoise1.ar((1..4)/48,mul:0.5);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\tigrain3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1/18,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([1,1.02,1],[0.1,0.8]), 1);
	freq = freq * env3;
	sig = LFSaw.ar(freq * [1,1.01,2,1/2]);
	sig = RLPF.ar(sig, ( \lpfratio.kr(1) * freq* [1,1.1] ).clip(20,19000), \rq.kr(0.1) * [1,1.1] * env1);
	sig = sig.tanh;
	sig = RLPF.ar(sig, ( \lpfratio.kr * freq* [2,1.1] * env2 ).clip(20,19000), 0.5);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * 2;
	pan = pan + LFNoise1.ar((1..4)/48,mul:0.5);
	sig = sig + DelayC.ar(sig,0.01,0.001 * [0.1,2,1]);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\kigrain1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq/8 * [1,1.01]) * 0.451;
	//sig = sig + LFNoise1.ar(freq);
	//sig = BPF.ar(sig, freq,0.1) + sig;
	//sig = BPF.ar(sig, freq * SinOsc.kr(Rand(0.1,2)).range(2,1),0.5);
	sig = sig.tanh;
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\trump, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1/18,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env3 = EnvGen.kr(Env([2.2,1.02,1],[0.001,0.8]), 1);
	freq = freq * env3;
	sig = LFSaw.ar(freq * [1,1.01,1.0002,1/2]) * \amps.kr([1,1,1,1]);
	sig = RLPF.ar(sig, ( \lpfratio.kr(1) * freq* [1,1.1] * env3 ).clip(20,19000), \rq.kr(0.1) * [1,1.1] * env1);
	sig = sig.tanh;
	sig = RLPF.ar(sig, ( \lpfratio.kr * freq* [2,1.1] * env2 * env3 ).clip(20,19000), 0.5);
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.6,0.1),gate,doneAction:2);
	sig = sig * 3;
	sig = sig + DelayC.ar(sig,0.01,0.001 * [0.1,2,1]);
	pan = pan + LFNoise1.ar((1..4)/48,mul:0.5);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\tigrain1, Pbind(
	\instrument, Prand([\tigrain, \tigrain2],inf),
	\fmf, Pexprand(1/100,4).stutter(8),
	\sustain, Pwhite(1/8,2,inf),
	\lpfratio, Pwhite(0.5,3),
	\freq, Pwhite(100,500,inf).stutter(Prand(16.partition,inf)),
	\dur, Pwhite(1/16,0.2,inf),
	\dur, 1/4,
	\amp, 0.1/2
));
);
Pdef(\tigrain1).play
(
Pdef(\tigrain1, Pbind(
	\instrument, Prand([\tigrain, \tigrain2],inf),
	\fmf, Pexprand(1/100,4).stutter(8),
	\sustain, Pwhite(1/8,1/2,inf),
	\lpfratio, Pwhite(0.5,3),
	\freq, Pwhite(100,500,inf).stutter(Prand(16.partition,inf)),
	\dur, Pwhite(1/16,0.2,inf),
	\dur, 1/4,
	\amp, 0.1
));
);

(
Pdef(\trump_march, Pbind(
	\instrument, \trump,
	\degree, Pseq([4,0],inf),
	\octave, 3,
	\dur, 1/8,
	\amp, 0.1
));
);

{ SinOsc.ar(200) ! 2 * 0.1}.play;
(
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

////////////////////////////////// main

(
Pdef(\trump_march, Pbind(
	\instrument, \trump,
	\degree, Pseq([4,0],inf),
	\octave, 3,
	\dur, 1/8,
	\amp, 0.1
));

Pdef(\trump_bass, Pbind(
	\instrument, \trump,
	\degree, Pseq([3,3,3,0, 3,0,-2,1],inf),
	\isRest, Pseq([
		1,1,1,0, 1,0,1,1,
	],inf).coin.not,
	\rq, 0.3,
	\legato, 0.8,
	\octave, 3,
	\lpfratio, Pseq([1,2,1.4,0.9],inf),
	\dur, Plazy({ 
		Pseq([
			Pseq(16.partition(4)/8/2,2),
			Pseq(16.partition(4)/8/4,2),
		],2);
	}).loop,
	\amp, 0.1
));

Pdef(\trump_bass2, PmonoArtic(\trump,
	\octave, 3,
	\degree, Pseq([
		3,3,3,0,
		3,-2,-2,0,
	],inf).stutter(4),
	\legato, Pseq({ [
		1,1,1,0.8, 1,1,1,1,
		0.9, 0.9, 0.9, 0.9, 1.9, 0.9, 0.9, 0.9,
	].clump(4).choose }.dup(16).flat,inf),
	\dur, 1/8,

));
Pdef(\trump_bass3, PmonoArtic(\trump,
	\octave, 3,
	\degree, Pseq([
		3,3,3,0,
		3,-2,-2,0,
	],inf).stutter(4),
	\legato, Pseq({ [
		1,1,1,0.8, 1,1,1,1,
		0.9, 0.9, 0.9, 0.9, 1.9, 0.9, 0.9, 0.9,
	].clump(4).choose }.dup(16).flat,inf)/2,
	\dur, 1/8,

))
);
Pdef(\trump_bass2).play;

(
	Pdef(\kigrain1, 
		Ppar(
			6.collect({ arg x;

				Pbind(
					\instrument, \kigrain1,
					//\degree, Pseq([0],inf),
					//\freq, Pseq([
					//	5000
					//],inf),
					\freq, Pexprand(500,15000),
					//\degree, Pwhite(0,24*2),
					\sustain, Pwhite(0.01,0.08),
					\dur, Pwhite(1/1,1/4) * ( 1/10 ),
					\amp, 0.2
				)
			})
		)
	);
	Pdef(\kigrain1).play;
);
(
Pdef(\main, Pseq([
	Ppar([
		//Pseq([
		//	Pfindur(4, Pdef(\trump_bass2)),
		//	Pfindur(4, Pdef(\trump_bass3)),
		//],inf),
		Pdef(\kigrain1),
		3.collect {Pbind(\dur, Pkey(\dur) * 2) <> ~kitlib.hiphop.kick.value},
		3.collect { arg x; Pbind(\dur, Pkey(\dur) * ( x+1/2 )) <> ~kitlib.hiphop.hat.value},
		1.collect {~kitlib.hiphop.snare.value},
	].flat)
	
])).play;
)

(
Pdef(\main, Pseq([
	Ppar([
		Pseq([
			Pfindur(4, Pdef(\trump_bass2)),
			Pfindur(4, Pdef(\trump_bass3)),
		],inf),
		3.collect {Pbind(\dur, Pkey(\dur) * 2) <> ~kitlib.hiphop.kick.value},
		3.collect { arg x; Pbind(\dur, Pkey(\dur) * ( x+1/2 )) <> ~kitlib.hiphop.hat.value},
		1.collect {~kitlib.hiphop.snare.value},
	].flat)
	
])).play;
)

////////////////////////////////////


(
Pdef(\kit_workspace, Pbind(
	\instrument, \trump,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		1
	],inf).coin.not,
	\rq, 0.3,
	\legato, 0.8,
	\octave, 3,
	\lpfratio, Pseq([1.4],inf),
	\dur, 2,
	\amp, 0.1
)).play;
)

(
SynthDef(\sinbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq* [2,1/2,1,1.002]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, [-0.1,0.1], amp).mean;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\kit_workspace, Pbind(
	\instrument, \sinbass,
	\degree, Pseq([0],inf),
	\isRest, Pseq([
		1
	],inf).coin.not,
	\rq, 0.3,
	\legato, 0.8,
	//\sustain, 0.1,
	\octave, 3,
	\lpfratio, Pseq([1.4],inf),
	\dur, 2,
	\amp, 0.1
)).play;
)

//////////////////////////

(
~t = 185/4/60; TempoClock.default.tempo = ~t;
SynthDef(\blik, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * XLine.kr(1,4,8) * ( 1 + ( SinOsc.kr(1/21 * (1..8)) * SinOsc.kr(2*~t).range(0,0.1) )));
	sig = RLPF.ar(sig, \lpf.kr(5400) * SinOsc.kr((1..8)/8*0.1 * ( 1 + ( SinOsc.kr(1/9 * (1..8)/8) * 1 ))).range(4,1), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..8) * ( 1 + ( SinOsc.kr(1/3) * 1 )), mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\blik2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.kr(1/21 * (1..8)) * SinOsc.kr(\fmampfmf.kr(1)).range(0,\fmampmax.kr(1)) * XLine.kr(0.001,1,\clean.kr(1)) )));
	sig = RLPF.ar(sig, \lpf.kr(5400) * SinOsc.kr((1..8)/8*0.1 * ( 1 + ( SinOsc.kr(1/9 * (1..8)/8) * 1 ))).range(4,1), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,3.1)),gate,doneAction:2);
	pan = pan + SinOsc.ar((1..8) * ( 1 + ( SinOsc.kr(1/3) * 1 )), mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\blik, Pbind(
	\instrument, \blik,
	\octave, 3,
	\degree, 0,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\legato, 8.59,
	\dur, 1,
	\amp, 0.1/2,
));
Pdef(\blikp1,
		Pbind(
			\instrument, \blik2,
			\clean, Pexprand(0.2,2),
			\octave, Prand([3,4,5],inf),
			\degree, Pseq([
				[0,2,4], [0,2,4],
				[5,7,9], [5,7,9],
			],inf),
			\isRest, Pseq({[
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\lpf, Pexprand(100,1000),
			\fmampmax, Pwhite(0.01,0.8),
			\fmampfmf, Pwhite(0.01,100),
			\legato, Pwhite(1,9),
			\dur, 1/4,
			\amp, 0.1/2,
		)
);

Pdef(\blikp2,
	Pbind(
		\dur, 1/2,
	)
	<> Pdef(\blikp1)
);

Pdef(\blikmain, 
	Pseq([
		Pfindur(8,Pdef(\blik)),
		Pfindur(32,Ppar([
			Pdef(\blikp1),
			Pdef(\blikp2),
		].collect({ arg p; Pbind(\dur, 1, \clean, 8) <> p }))),
		Pfindur(32,Ppar([
			Pdef(\blikp1),
			Pdef(\blikp2),
		].collect({ arg p; Pbind() <> p }))),
		Pfindur(16,Ppar([
			Pdef(\blikp1),
			Pdef(\blikp2),
		].collect({ arg p; Pbind(\dur, 1/8, \legato, 00.1) <> p }))),
	//	Pfindur(16,Ppar([
	//		Pdef(\blikp1),
	//		Pdef(\blikp2),
	//	].collect({ arg p; Pbind(
	//		\octave, 4,
	//		\adsr, [ Env.adsr(0.01,0.1,0.8,0.1) ],
	//		\sustain, Pseq([
	//			Pseq((1..64).reverse/128,1),
	//			Pn(1/2,inf)
	//		],inf),
	//		\dur, 1/8, \isRest, Pseq([1,1,0,1],inf), \clean, 8, \legato, 00.1) <> p }))),
	//	Pfindur(16,Ppar([
	//		Pdef(\blikp1),
	//		Pdef(\blikp2),
	//	].collect({ arg p; Pbind(
	//		\octave, 4,
	//		\note, Pseq((1..32),inf).stutter(4),
	//		\adsr, [ Env.adsr(0.01,0.1,0.8,0.1) ],
	//		\sustain, Pseq([
	//			Pseq((1..64).mirror/62,1),
	//			Pn(1/2,inf)
	//		],inf),
	//		\dur, 1/8, \isRest, Pseq([1,1,0,1],inf), \clean, Pseq((1..12)/10,inf), \legato, 00.1) <> p }))),
	//	
	],2)
).play;
);
Pdef(\blikmain).clear

(
	// short
	Pdef(\blikmain,
		Pdef(\blik, Pbind(
			\instrument, \blik2,
			\octave, [4,5,6],
			\degree, 0,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\lpfratio, 5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.19,
			\dur, 1/8,
			\amp, 0.1,
		))
	).play;
)
(
	// long
	Pdef(\blikmain,
		Pdef(\blik, Pbind(
			\instrument, \blik2,
			\octave, [4,5,6],
			\degree, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\lpfratio, 5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
			],inf),
			\legato, 7.19,
			\dur, 1/2,
			\amp, 0.1,
		))
	).play;
)
(
	Pdef(\kit_workspace,
		Pdef(\blik, Pbind(
			\instrument, \blik2,
			\octave, [4,5,6],
			\degree, 0,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\fmampmax, 5,
			\fmampfmf, Pseq([4,2],inf).stutter(8) * ~t,
			\clean, 5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.9) ],
			],inf),
			\legato, 7.19,
			\dur, 1/2,
			\amp, 0.1,
		))
	).play;
)

(
	~kits = (
		kick: 4.collect({~kitgen.patkit.kick}),
		snare: 4.collect({~kitgen.patkit.snare}),
		hat: 4.collect({~kitgen.patkit.hat}),
	)
)
(
	// hiphop
Pdef(\fdrums, 
	Ppar([
		Pbind(
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1
		) <> ~kits.kick[0],
		Pbind(
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1
		) <> ~kits.snare[0],
		Pbind(
			\dur, 1/8,
			\sustain, 0.04,
			\isRest, Pseq({[
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,0,1,1, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\amp, 0.1
		) <> ~kits.hat[0],
		Pbind(
			\dur, 1/16,
			\sustain, 0.04,
			\isRest, Pseq({[
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\gain, Pkey(\gain)/2,
		) <> ~kits.hat[2],
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef("synth/chord1.flac"),
			\sustain, 0.7,
			\isRest, Pseq({[
				1,0,0,1, 0,0,1,0,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\dur, 1/4,
		)
	]),
).play;
)

(
	~kits = (
		kick: 4.collect({~kitgen.patkit.kick}),
		snare: 4.collect({~kitgen.patkit.snare}),
		hat: 4.collect({~kitgen.patkit.hat}),
	)
)
(
BufDef(\moeten, "voices/02_moeten.flac");
Pdef(\fdrums, 
	Ppar([
		Pbind(
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1
		) <> ~kits.kick[0],
		Pbind(
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1
		) <> ~kits.snare[0],
		Pbind(
			\dur, 1/8,
			\sustain, 0.04,
			\isRest, Pseq({[
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0, 
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\amp, 0.1
		) <> ~kits.hat[0],
		Pbind(
			\dur, 1/16,
			\sustain, 0.04,
			\isRest, Pseq({[
				1,0,1,0, 0,0,1,0,
				1,1,0,0, 0,0,1,0,
				1,1,0,0, 0,1,0,0,
			].clump(8).choose}.dup(4).flat,inf).coin.not,
			\gain, Pkey(\gain)/2,
		) <> ~kits.hat[2],
		//Pbind(
		//	\instrument, \playersec,
		//	\bufnum, BufDef("synth/chord1.flac"),
		//	\sustain, 0.7,
		//	\pos, 0.9,
		//	\speed, 0.2,
		//	\isRest, Pseq({[
		//		1,0,0,1, 0,0,1,0,
		//	].clump(8).choose}.dup(4).flat,inf).coin.not,
		//	\dur, 1/4,
		//),
		Plazy({
			var ac = 0;
			var speeds = Pseq({ rrand(0.6,1.4) } ! 4,inf);
			Pseq([
				 4.partition(2).collect({ arg time, idx;
					var tt = 1/[4,8,8,4,16].choose;
					tt = [ 1/8, 1/12 ].choose;
					time = time/4;
					ac = ac+tt;
					Pfindur(time,
						Pbind(
							\instrument, \playersec,
							//\bufnum, BufDef("synth/chord1.flac"),
							\bufnum, BufDef(\moeten),
							//\sustain, time/~t,
							\speed, speeds.stutter(Pseq(8.partition(2)*2,inf)),
							\isRest, Pseq([
								1,1,0,0, 0,0,0,0,
								1,1,1,1, 1,1,1,1,
							],inf).coin.not,
							\isRest, Pseq({[
								1,1,0,0, 0,0,0,0,
								0,1,0,1, 0,0,0,0,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,1,
								0,1,0,1, 0,1,0,1,
								0,1,0,1, 0,1,0,1,
								0,1,0,1, 0,1,0,1,
							].clump(8).choose}.dup(4).flat,inf).coin.not,
							\legato, 1,
							\pos, ac,
							\gain, 0.2,
							\dur, tt,
						)
					)

				}) ! 2,
				4.partition(2).collect({ arg time, idx;
					var tt = 1/[4,8,12,6].choose;
					time = time/4;
					ac = ac+tt;
					Pfindur(time,
						Pbind(
							\instrument, \playersec,
							//\bufnum, BufDef("synth/chord1.flac"),
							\bufnum, BufDef(\moeten),
							\speed, Pwhite(0.8,1.2),
							\speed, Pwhite(0.8,1.2).stutter(Pseq(8.partition(2)*2,inf)),
							\speed, speeds.stutter(Pseq(8.partition(2)*2,inf)),
							//\sustain, time/~t,
							\isRest, Pseq({[
								1,0,0,0, 0,0,0,0,
								1,0,1,0, 1,0,1,0,
								1,1,1,0, 1,1,1,1,
								1,0,1,1, 1,1,1,1,
								1,1,1,1, 1,1,1,0,
								1,1,1,1, 1,0,1,1,
							].clump(8).choose}.dup(4).flat,inf).coin.not,
							\isRest, Pseq([
								1,1,0,0, 0,0,0,0,
								1,1,1,1, 1,1,1,1,
								1,1,1,1, 0,0,0,0,
								0,0,0,1, 0,0,1,0,
								1,0,0,0, 0,0,0,0,
								0,1,0,1, 0,1,0,1,
								0,1,0,1, 0,1,0,1,
								0,1,1,1, 0,1,0,1,
								0,1,1,0, 0,1,1,0,
								1,0,1,0, 1,1,1,0,
							],inf).coin.not,
							\legato, 1,
							\pos, ac,
							\gain, 0.2,
							\dur, tt,
						)
					)

				}) ! 2
			].flat,inf);
		})
	]),
).play;
);

Pdef(\fdrums).set( \out, BusDef(\sendbus0, \audio) )
ProtoDef(\rdn).edit;


