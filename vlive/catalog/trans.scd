
Pdef(\demo).stop
(
// reversed snare
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\speed, -1 * 1.0,
			\pos, 1/2/~t,
			\sustain, 1.9,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
)).play;
)

/////// pitch based

(
SynthDef(\islurp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.9]*4,[ 1,-1 ]), 1).round(0.1);
	env2 = EnvGen.kr(Env([1,20,1,1/2],[0.1,0.9,1]*4), 1).round(0.1);
	env3 = EnvGen.kr(Env([1,1.20,0.1],[0.1,0.9]*4), 1).round(0.1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq * env3) * env2 + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.01),gate,doneAction:2);
	sig = sig * EnvGen.kr(Env([0,1,0],[1.0,0.08], [4,-1]), 1);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \islurp,
		\freq, 200,
		\legato, 4,
		\isRest, Pseq([
			1,0, 0,0, 0,0, 0,0,
			0,0, 0,0, 1,0, 0,0,
		],inf).coin.not,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
SynthDef(\metalcut, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.9]*4,[ 1,-1 ]), 1).round(0.1);
	env2 = EnvGen.kr(Env([100,200,1,1/2],[0.1,0.9,1]*4), 1).round(0.1);
	env3 = EnvGen.kr(Env([1,120,0.1],[0.1,0.9]*4), 1).round(0.1);
	sig = SinOsc.ar(freq * env1 * ( SinOsc.ar(freq * env3) * env2 + 1 ));
	//sig = CombL.ar(sig, 4/~t,0.01,1.1) + sig;
	sig = AllpassL.ar(sig, 4/~t,0.1,1.1) + sig;
	sig = FreeVerb.ar(sig,1,2);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,3.01),gate,doneAction:2);
	//sig = sig * EnvGen.kr(Env([0,1,0],[1.0,0.08], [4,-1]), 1);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \metalcut,
		\freq, 800,
		\legato, 4,
		\isRest, Pseq([
			1,0, 0,0, 0,0, 0,0,
			0,0, 0,0, 0,0, 0,0,
		],inf).coin.not,
		\dur, 1/8,
		\amp, 0.1,
	),
).play;
)

(
SynthDef(\nidi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,10,40,1],[4,4.1,0.8]), 1);
	sig = SinOsc.ar([234,234.43] * ( SinOsc.ar(freq) * env1 + 1 )).mean;
	sig1 = ( sig*\distamp.kr(1)*env1 ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\mix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(2.01,0.1,0.8,0.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \nidi,
			\freq, 200,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
)


(
SynthDef(\echh, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,12000,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,1000,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,7100,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,2.4),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \echh,
		\freq, 800,
		\legato, 1,
		\dur, Pn(4,1),
		\amp, 0.1,
	),
).play;
)



(
SynthDef(\echhlow, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,420,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,100,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \echhlow,
		\freq, 200,
		\legato, 1,
		\dur, Pn(4,1),
		\amp, 0.1,
	),
).play;
)

(
SynthDef(\echhhi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,10420,182],[0.04,5.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,10100,152],[0.04,4.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,710,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(7700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RHPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = LPF.ar(sig,  15000, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.4)),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo, 
	Pbind(
		\instrument, \echhhi,
		\freq, 200,
		\legato, 1,
		\dur, Pn(1,1),
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],inf),
		\amp, 0.1/2,
	),
).play;
)


//////////////////:



(
Ndef(\woof, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 1/2;
	sig = WhiteNoise.ar;
	sig = Saw.ar(70 * EnvGen.kr(Env([1,2,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(100) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([200,5000,5000],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = BPF.ar(sig, EnvGen.kr(Env([201,5000 * [1,1.1,2],1],[1.1 * tscale,0.8]), 1), 1) + ( sig/4 );
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,3.3 * tscale,0.008], [3,-1]), 1);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = SinOsc.ar(freq);
	pan = pan + SinOsc.ar((1..sig.size) * 100/1, mul: EnvGen.kr(Env([0,0.51,0],[1.1,0.8]), 1);); 
	sig = Pan2.ar(sig, pan, amp).mean;
	sig;
}).play;


Ndef(\woof2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 2/2;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar;
	sig = PinkNoise.ar * Duty.kr(1/32/~t, 0, Dseq([
		1,0,0,1,
		1,0,1,0,
		1,0,0,1,
	],inf));
	sig2 = Pulse.ar(70 * EnvGen.kr(Env([8,1,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(400) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig2 = sig2  * Duty.kr(1/30/~t, 0, Dseq([
		0,1,0,1,
		1,1,0,1,
		1,0,1,0,
	],inf));
	sig = sig + sig2;
	sig = FreqShift.ar(sig, EnvGen.kr(Env([0,-0.2,-31],[1.1,0.8]), 1)) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([14200,500,500],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,1.3 * tscale,0.008], [3,-1]), 1);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
	sig;
}).play;
);


///////////////:



(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 40;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = LFNoise1.ar(0.1);
	freq = Rand(100.0,4000!num);
	sig = SinOsc.ar(freq * ( LFSaw.ar(freq * lfo1) * lfo1 * 3 + 1 ));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \zed,
			\freq, 900,
			\dur, 1,
			\amp, 0.1,
		),	
	])
)).play;
);

/////////////////// up ramp

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = XLine.kr(1,4,20);
	sig = SinOsc.ar(freq * lfo1 * ( SinOsc.ar(freq+lfo1 * [1,1/4,1/8]) * lfo1 + 1 ) );
	sig = sig * SinOsc.ar([1,4,8]).unipolar; 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan) * 2;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = Duty.kr(1/~t, 0, Dseq([
		1,0,7,3,
	],inf)).midiratio * freq * [0,3,7].midiratio;
	lfo1 = XLine.kr(1,4,20);
	lfo1 = lfo1 * ( SinOsc.kr(1/4) * 0.1 + 1 );
	sig = SinOsc.ar(freq  * ( SinOsc.ar(freq+( lfo1 * [1,1/4,1/8] )) * lfo1 + 1 ) );
	sig = sig + RHPF.ar(sig, \lpfr.kr(1.1) * ( SinOsc.kr(1* [1,1/4,1/8]) * lfo1/4 + 1.1 ) * freq * lfo1, \rq.kr(0.5));
	sig = sig + RLPF.ar(sig, \lpfr.kr(1.1) * ( SinOsc.kr(3* [1,1/4,1/8]) * lfo1/4 + 1.1 ) * freq * lfo1, \rq.kr(0.5));
	sig = sig * ( SinOsc.ar([1,4,8]).unipolar * lfo1 + 1 ) / lfo1; 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan) / 2;
}).play;
);

////////////////// detune chord and exp

(
SynthDef(\chordgrow, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([1,4000,1],[6.1,4.8],\exp), 1);
	lfo2 = EnvGen.kr(Env([1/3,20,1],[6.1,4.8],\exp), 1);
	sig = SinOsc.ar(freq * \chord.kr([0,4,7]).midiratio);
	sig = sig + LFSaw.ar(freq/2 * \chord.kr([0,4,7]).midiratio);
	sig = sig.mean;
	sig = sig + DelayC.ar(sig, 0.1,0.0001 * lfo1);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * lfo2 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(5.1,0.1,0.8,0.1,1,4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \chordgrow,
			\note, 0,
			\chord, Pseq([
				[ [2,5,8] ],
			],inf),
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

