
/////////////
// imitate larsen in rdn

(
SynthDef(\basslarsen, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * XLine.kr(0.01,100,10);
	sig = ( sig*\distamp.kr(50) ).tanh * \distpostamp.kr(1/8);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\basslarsen,
			\freq, 100,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
// more variation
SynthDef(\basslarsen, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,4,1],[10.1,0.8]), 1);
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq/2+1) * env1 + 1 ));
	sig = sig * XLine.kr(0.01,100,10);
	sig = ( sig*\distamp.kr(50) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\basslarsen,
			\freq, 100,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
// less disto
SynthDef(\basslarsen, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,4],[4,10.1]), 1);
	env2 = EnvGen.kr(Env([20000,15000,200],[4,10.1]), 1);
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq/2+1) * env1 + 1 ));
	sig = sig * XLine.kr(0.1,50,10);
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\basslarsen,
			\freq, 60,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

Window.closeAll
(
// less disto
SynthDef(\basslarbare, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,4],[4,10.1]), 1);
	env2 = EnvGen.kr(Env([20000,15000,200],[4,10.1]), 1);
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq/2) * \fma.kr(0) + 1 ));
	sig = sig * \oscamp.kr(1).poll;
	sig = ( sig*\distamp.kr(1) ).clip2(1) * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\basslarbare,
			\freq, 60,
			\dur, 1,
			\amp, 0.1,
		)
		<>
		Pseq([
			Pfindur(16,Pbind(
				\oscamp, PmodEnv(Pseq([0,50,50],1), 8).loop,
				\fma, PmodEnv(Pseq([0,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([20000,10000,7000],1), 8).loop,
			)),
			Pfindur(16,Pbind(
				\oscamp, PmodEnv(Pseq([50,5],1), 8).loop,
				\fma, PmodEnv(Pseq([4,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([20000,100,7000],1), 8).loop,
			)),
		],inf)
	])
)).play;
);



(
SynthDef(\chordlarbare, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var cfreq;
	env1 = EnvGen.kr(Env([0,1,4],[4,10.1]), 1);
	env2 = EnvGen.kr(Env([20000,15000,200],[4,10.1]), 1);
	cfreq = freq * [0,4,7].midiratio;
	sig = LFPulse.ar(cfreq * ( SinOsc.ar(freq*2 + [ [0,0.01] ]) * \fma.kr(0) + 1 ));
	sig = sig.mean;
	sig = sig * \oscamp.kr(1).poll;
	sig = ( sig*\distamp.kr(1) ).clip2(1) * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\chordlarbare,
			\note, Pseq([
				0,5,7,5,
			],inf),
			\dur, 2,
			\amp, 0.1,
		)
		<>
		Pseq([
			Pfindur(16,Pbind(
				//\oscamp, PmodEnv(Pseq([0,50,50],1), 8).loop,
				\fma, PmodEnv(Pseq([0,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([20000,100,7000,600],1), 4).loop,
			)),
			Pfindur(16,Pbind(
				//\oscamp, PmodEnv(Pseq([50,5],1), 8).loop,
				\fma, PmodEnv(Pseq([4,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000],1), 1).loop,
			)),
		],inf)
	])
)).play;
);


(
// more octave
SynthDef(\chordlarbare, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var cfreq;
	env1 = EnvGen.kr(Env([0,1,4],[4,10.1]), 1);
	env2 = EnvGen.kr(Env([20000,15000,200],[4,10.1]), 1);
	cfreq = freq * \chord.kr([0,4,7]).midiratio;
	sig = LFPulse.ar(cfreq * ( SinOsc.ar(freq*2 + [ [0,0.01] ]) * \fma.kr(0) + 1 ));
	sig1 = ( cfreq *.x [3,2,1/2] ).collect { arg fr, idx;
		var isig;
		isig = LFPulse.ar(fr * ( SinOsc.ar(freq*2 + [0,0.01]) * \fma.kr(0) + 1 ));
		isig = isig * ( SinOsc.kr(1/( idx+1 )).clip(0,1) * 1 );
	};
	sig1.debug("sig1");
	sig1.shape.debug("sig1s");
	sig = sig + sig1;
	sig = sig.mean;
	sig.postln;
	sig = sig * \oscamp.kr(1);
	sig = ( sig*\distamp.kr(1) ).tanh * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\chordlarbare,
			\note, Pseq([
				7,2+12,9,5
			],inf),
			\chord, Pseq([
				[ [ 0,4,7 ] ],
				[ [ 0,-5,-9 ] ],
				[ [ 0,4,7-12 ] ],
				[ [ 0,4,7 ] ],
			],inf),
			\dur, 2,
			\amp, 0.07,
		)
		<>
		Pseq([
			Pbind(
				\oscamp, PmodEnv(Pseq([0,4,3],1), 8),
				\fma, PmodEnv(Pseq([0,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000,600],1), 4).loop,
			),
			Pbind(
				\oscamp, PmodEnv(Pseq([1,1,1.5],1), 8),
				\fma, PmodEnv(Pseq([4,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000],1), 1).loop,
			),
		],inf)
	])
)).play;
);

(
// add melo
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//0,Prand([5,4]),Prand([7,9,10]),2,
				Prand([2,0]), 0, Prand([-3,2]),
			],inf),
			\octave, 6,
			\envamt, PmodEnv(Pseq([1,2,8],1), 8).loop,
			\lpf, 300,
			\dur, 1/8,
			\amp, 0.1/2 * Ppatlace([
				Pseg(Pseq([0,1,Pn(1,inf)],inf),4), Pseg(Pseq([0,0.1,1],inf),8),
			],inf),
		),
		Pmono(\chordlarbare,
			\note, Pseq([
				7,2+12,9,5
			],inf),
			\chord, Pseq([
				[ [ 0,4,7 ] ],
				[ [ 0,-5,-9 ] ],
				[ [ 0,4,7-12 ] ],
				[ [ 0,4,7 ] ],
			],inf),
			\dur, 2,
			\amp, 0.07,
		)
		<>
		Pseq([
			Pbind(
				\oscamp, PmodEnv(Pseq([0,4,3],1), 8),
				\fma, PmodEnv(Pseq([0,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000,600],1), 4).loop,
			),
			Pbind(
				\oscamp, PmodEnv(Pseq([1,1,1.5],1), 8),
				\fma, PmodEnv(Pseq([4,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000],1), 1).loop,
			),
		],inf)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//0,Prand([5,4]),Prand([7,9,10]),2,
				Prand([2,0]), 0, Prand([-3,2]),
			],inf),
			\octave, 6,
			\envamt, PmodEnv(Pseq([1,2,8],1), 8).loop,
			\lpf, 300,
			\dur, 1/8,
			\amp, 0.1/2 * Ppatlace([
				Pseg(Pseq([0,1,Pn(1,inf)],inf),4), Pseg(Pseq([0,0.1,1],inf),8),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\out, BusDef(\fx1, \audio),
			\pan, Pbrown(-1,1,inf)/2,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\fx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/~t,
			\mix, 0.1,
			\lag, 0.0008,
			\dur, 1,
			\out, BusDef(\fx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.4,
			\dur, 1,
		),
		Pmono(\chordlarbare,
			\note, Pseq([
				7,2+12,9,5
			],inf),
			\chord, Pseq([
				[ [ 0,4,7 ] ],
				[ [ 0,-5,-9 ] ],
				[ [ 0,4,7-12 ] ],
				[ [ 0,4,7 ] ],
			],inf),
			\dur, 2,
			\amp, 0.07,
		)
		<>
		Pseq([
			Pbind(
				\oscamp, PmodEnv(Pseq([0,4,3],1), 8),
				\fma, PmodEnv(Pseq([0,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000,600],1), 4).loop,
			),
			Pbind(
				\oscamp, PmodEnv(Pseq([1,1,1.5],1), 8),
				\fma, PmodEnv(Pseq([4,0.1,4],1), 8).loop,
				\lpf, PmodEnv(Pseq([2000,100,7000],1), 1).loop,
			),
		],inf)
	])
)).play;
);
