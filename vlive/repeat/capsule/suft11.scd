(
SynthDef(\neo, { |bus=0|
	var freq, snd, env;
	freq = SinOsc.kr(190) * 500;
	snd = LFSaw.ar(freq,mul:0.3);
	env = Env([0,1,0],[0.5,0.6],[-3,\sine,3]).kr(2);
	snd = snd*env;
	Out.ar(bus,snd);
}).add
)
s.boot
Synth(\neo);

(
SynthDef(\neo, {
	|bus=0|
	var = freq, snd, env;
	freq = SinOsc.kr(190);
	snd = LFSaw.ar(freq,mul:0.3);
	env = Env([0,1,0],[0.5,0.6],[-3,\sine,3]).kr(2);
	snd = snd*env;
	Out.ar(bus,snd);
}.add;)
)
s.boot
Synth(\neo).play;


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

//)
//(

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


(
Ndef(\woof, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var tscale = 1/2;
	sig = WhiteNoise.ar;
	sig = Saw.ar(70 * EnvGen.kr(Env([1,2,7],[2.1 * tscale,0.8]), 1) * ( SinOsc.ar(100) * 0.2  * EnvGen.kr(Env([1,20,2],[2.1,0.8], 1))+ 1 )) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([200,5000,5000],[1.1 * tscale,0.8], [1,-1]), 1));
	sig = BPF.ar(sig, EnvGen.kr(Env([201,5000 * [1,1.1,2],1],[1.1 * tscale,0.8]), 1), 1) + ( sig/4 );
	//sig = SinOsc.ar(freq);
	pan = pan + SinOsc.ar((1..sig.size) * 1/1, mul: EnvGen.kr(Env([0,0.51,0],[1.1,0.8]), 1);); 
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,3.3 * tscale,0.008], [3,-1]), 1);
	sig;
});


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
	sig = FreqShift.ar(sig, EnvGen.kr(Env([0,[ -0.2, 0.2 ],-31],[1.1,0.8]), 1)) + sig;
	sig = LPF.ar(sig, EnvGen.ar(Env([14200,500,500],[1.1 * tscale,0.8], [1,-1]), 1));
	//sig = SinOsc.ar(freq);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	sig = sig * EnvGen.kr(Env([0.01,0.1,1,0],[0.3,1.3 * tscale,0.008], [3,-1]), 1);
	sig;
});


Ndef(\main, {
	var sig;
	var in;
	var fbsig;
	fbsig = LocalIn.ar(2) * \fb.kr(0.1) * EnvGen.kr(Env([0.1,1,0.001],[1.1,0.8]), 1);
	in = [
		Ndef.ar(\woof),
		Ndef.ar(\woof2),
	].sum;
	sig = in + fbsig;
	sig = sig.tanh;
	sig = AllpassL.ar(sig, 0.1, Rand(0.01,0.01!13),0.1).sum + sig;
	sig = Limiter.ar(sig);
	sig = LeakDC.ar(sig);
	LocalOut.ar(sig);
	sig = [
		Splay.ar(in, EnvGen.kr(Env([0,0,0],[1.1,0.8]), 1), 1, 0),
		Splay.ar(sig, EnvGen.kr(Env([0,0,0],[1.1,0.8]), 1), 1, 1),
	].sum;
	sig = LeakDC.ar(sig);
	sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.001), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig;
}).play;
);


(
	Ndef(\woof).send;
	Ndef(\woof2).send;
Ndef(\main, {
	var sig;
	var in;
	var fbsig;
	in = [
		Ndef.ar(\woof),
		//Ndef.ar(\woof2),
	].sum;
	sig = in;
	//sig = FreeVerb.ar(sig, mix:0.2, room:2.5, damp:0.5);
	//sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.001), \cpabove.kr(0.001), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig;
}).play;
)




(
SynthDef(\krig, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01;
	var sig;
	var fm;
	var env1, env2, env3, env4, env5, env6, env7, env8;
//	var fspread = 1;
	fspread = EnvGen.kr(Env([0.00001,0.1,1],[1.4,0.8], [2]), 1);
	env1 =  EnvGen.kr(Env([0.00001,0.1,0],[1.4,0.8], [2]), 1);
	env2 =  EnvGen.kr(Env([0.00001,1,0],[1.4,0.8], [2]), 1);
	fm = ( LFSaw.ar(100* ((0..7)/7 - 0.5 * fspread + 1)) * env1  + 1 );
	fm = fm + ( SinOsc.ar(100* ((0..7)/7 - 0.5 * fspread + 1)) * env2  + 1 );
	sig = SinOsc.ar(freq * fm);
	pan = pan + SinOsc.ar((1..sig.size)/1000, (1..sig.size)); 

	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \krig,
			\freq, 200,
			\legato, 1,
			\dur, 4,
			\amp, 0.1,
		)
	])
)).play;
);


(
SynthDef(\envkrig, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01;
	var sig;
	var fm;
	var env1, env2, env3, env4, env5, env6, env7, env8;
//	var fspread = 1;
	fm = ( LFSaw.ar(\fm1.kr(1000)* ((0..7)/7 - 0.5 * \fmspread1.kr(0.1)/100 + 1)) * \fmamp1.kr(1)  + 1 );
	fm = fm + ( SinOsc.ar(\fm2.kr(1000)* ((0..7)/7 - 0.5 * \fmspread2.kr(0.1)/100 + 1)) * \fmamp2.kr(1)  + 1 );
	sig = SinOsc.ar(freq * fm);
	pan = pan + SinOsc.ar((1..sig.size)/1000, (1..sig.size)); 

	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		Pdef(\krig, 
			Pmono(
 \envkrig,
				\legato, 1,
				\dur, 1,
				\amp, 0.1,
			)
		).play;
);

EnvTimeline
CurveTimeline
ParamTimeline(\krig, Param( Pdef(\krig), \freq ))
ParamTimeline(\krig).edit

ParamTimeline(\krig_fmamp1, Param( Pdef(\krig), \fmamp1 , ControlSpec(0,10,\lin))).edit
ParamTimeline(\krig_fmamp1).clear
ParamTimeline(\krig_fmamp1, Param( Pdef(\krig), \fmamp1 , ControlSpec(0,10,\lin))).edit

ParamTimeline(\krig_fmspread1, Param( Pdef(\krig), \fmspread1 , ControlSpec(0,10,\lin))).edit
ParamTimeline(\krig_fmspread2, Param( Pdef(\krig), \fmspread2 , ControlSpec(0,2,\lin))).edit
ParamTimeline(\krig_fmamp2, Param( Pdef(\krig), \fmamp2 , ControlSpec(0,10,\lin))).edit
ParamTimeline(\krig_fm1, Param( Pdef(\krig), \fm1 ,\freq)).edit
ParamTimeline(\krig_fm2, Param( Pdef(\krig), \fm2 ,\freq)).edit


/////////////////////////////////////////////



(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \envkrig,
			\freq, Pseq([
				123,543,234,199,
			],inf) * Prand([1/2,1/4],inf),
			\dur, 1/2,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,0,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \envkrig,
			\freq, Pseq([
				1234,5432,2343,1999,
			],inf),
			\fmamp2, Pseq([1,2,0.5,0.01],inf),
			\legato, 0.1,
			\dur, 1/4,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,0,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \envkrig,
			\freq, Pstep(Pseq([
				1234,5432,2343,1999,
			],inf) * Pseq([
				1,2,3,4
			],inf)/5,1/4),
			\legato, 0.1,
			\lag, 0.1,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,0,
			],inf).coin.not,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Pseq([
		Pfindur(8, Ptpar([
			0, Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					123,543/2,234,199,
				],inf) * Prand([1/2],inf),
				\dur, 1/2,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			4, Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					1234,5432,2343,1999,
				],inf),
				\fmamp2, Pseq([1,2,0.5,0.01],inf),
				\legato, 0.7,
				\dur, 1/4,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			6, Pbind(
				\instrument, \envkrig,
				\freq, Pstep(Pseq([
					1234,5432,2343,1999,
				],inf) * Pseq([
					1,2,3,4
				],inf)/5,1/4),
				\legato, 0.9,
				\dur, 1/8,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
		])),
		Pfindur(8, Ppar([
			Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					123,543,234,199,
				],inf) * Prand([1/2,1/4],inf),
				\dur, 1/2,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					1234,5432,2343,1999,
				],inf),
				\fmamp2, Pseq([1,2,0.5,0.01],inf),
				\legato, 0.1,
				\dur, 1/4,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\instrument, \envkrig,
				\freq, Pstep(Pseq([
					1234,5432,2343,1999,
				],inf) * Pseq([
					1,2,3,4
				],inf)/5,1/4),
				\legato, Pseq([
					0.7,0.1,
				],inf).stutter(8*6),
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 1,1,1,0,
				],inf).coin.not,
			),
		])),
		Pfindur(8, Ppar([
			Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					123,543,234,199,
				],inf) * Prand([1/2,1/4],inf),
				\dur, 1/2,
				\out, BusDef(\bus0, \audio),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					1234,5432,2343,1999,
				],inf),
				\fmamp2, Pseq([1,2,0.5,0.01],inf),
				\legato, 0.1,
				\dur, 1/4,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\instrument, \envkrig,
				\freq, Pstep(Pseq([
					1234,5432,2343,1999,
				],inf) * Pseq([
					1,2,3,4
				],inf)/5,1/4),
				\legato, Pseq([
					0.1,
				],inf).stutter(8*6),
				\lag, 0.1,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 1,1,1,0,
				],inf).coin.not,
			),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, ~pmodenv.(Pseq([0,0,0.2,1],inf), 2),
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		])),
		Pfindur(8, Ppar([
			Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					123,543,234,199,
				],inf) * Prand([1/2,1/4],inf),
				\dur, 1/2,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					1234,5432,2343,1999,
				],inf),
				\fmamp2, Pseq([1,2,0.5,0.01],inf),
				\legato, 0.1,
				\dur, 1/4,
				\out, BusDef(\bus0, \audio),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\instrument, \envkrig,
				\freq, Pstep(Pseq([
					1234,5432,2343,1999,
				],inf) * Pseq([
					1,2,3,4
				],inf)/5,1/4),
				\legato, Pseq([
					0.1,
				],inf).stutter(8*6),
				\lag, 0.1,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 1,1,1,0,
				],inf).coin.not,
			),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, ~pmodenv.(Pseq([0.1,0,0.2,1],inf), 2),
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		])),
		Pfindur(8, Ppar([
			Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					123,543,234,199,
				],inf) * Prand([1/2,1/4],inf),
				\dur, 1/2,
				\out, BusDef(\bus0, \audio),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\instrument, \envkrig,
				\freq, Pseq([
					1234,5432,2343,1999,
				],inf),
				\fmamp2, Pseq([1,2,0.5,0.01],inf),
				\legato, 0.1,
				\dur, 1/4,
				\out, BusDef(\bus1, \audio),
				\isRest, Pseq([
					1,1,1,1, 1,1,1,0,
				],inf).coin.not,
			),
			Pbind(
				\instrument, \envkrig,
				\freq, Pstep(Pseq([
					1234,5432,2343,1999,
				],inf) * Pseq([
					1,2,3,4
				],inf)/5,1/4),
				\legato, Pseq([
					0.1,
				],inf).stutter(8*6),
				\lag, 0.1,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,1,0, 1,1,1,0,
				],inf).coin.not,
			),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.71,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus1, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, ~pmodenv.(Pseq([0,0,0.2,1],inf), 2),
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		])),
	],1),
)).play;

Pdef(\fxpart, Pdef(\plopfx, 
	Ppar([
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		)
	])
)).play;
)



(
Pdef(\part, Pdef(\dis_part1, 
	Ppar([
		Ptpar([
			0, Pbind(
			   	\instrument, \snapkickx,
			   	\dur, 1/8,
			   	\isRest, Pseq([
			   		1,0,0,0, 0,0,0,0,
			   		1,0,1,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\amp, 0.1,
			   	\out, BusDef(\bus0, \audio),
			   ),
			4,   Pbind(
			   	\instrument, \envkrig,
			   	\freq, Pseq([
			   		123,543,234,199,
			   	],inf) * Prand([1/2,1/4],inf),
			   	\dur, 1/2,
			   	\legato, 0.1,
			   	\isRest, Pseq([
			   		1,1,1,1, 1,1,1,0,
			   	],inf).coin.not,
			   	\out, BusDef(\bus0, \audio),
			   ),
			8,  	Pbind(
			   		\instrument, \envkrig,
			   		\freq, Pseq([
			   			1234,5432,2343,1999,
			   		],inf),
			   		\fmamp2, Pseq([1,2,0.5,0.01],inf),
			   		\legato, 0.1,
			   		\dur, 1/4,
			   		\out, BusDef(\bus0, \audio),
			   		\isRest, Pseq([
						Pseq([
							1,1,1,1, 1,1,1,0,
						],2),
						Pseq([
							0,1,0,1, 0,1,0,0,
						],2),
						Pseq([
							1,0,0,0, 0,0,0,0,
						],4),
			   		],inf).coin.not,
					\amp, 0.1/2,
			   	),
			0, Pbind(
				\instrument, \envkrig,
				\fmspread1, ~pmodenv.(Pseq([0.0001,0.2],inf), 8),
				\freq, Pseq([430,450],inf),
				\dur, 4,
				\amp, 0.1,
			),
		]),

			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.71,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		)
		
	])
)).play;
);


(
Pdef(\part, Pdef(\dis_part2, 
	Ppar([
		Ptpar([
			0, Pbind(
			   	\instrument, \snapkickx,
			   	\dur, 1/8,
			   	\isRest, Pseq([
			   		1,0,0,0, 0,0,0,0,
			   		1,0,1,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\amp, 0.1,
			   	\out, BusDef(\bus0, \audio),
			   ),
			   0, PatKitDef(\ksh2b).asPattern(Pbind(
			   	\kitIndex, 5,
			   	\isRest, Pseq([
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\sustain, 0.1,
			   	\gain, 0.2,
			   	\dur, 1/8,
			   	\out, BusDef(\bus0, \audio),
			   )),
			0,   Pbind(
			   	\instrument, \envkrig,
			   	\freq, Pseq([
			   		123,543,234,199,
			   	],inf) * Prand([1/2,1/4],inf),
			   	\dur, 1/2,
			   	\legato, 0.1,
			   	\isRest, Pseq([
			   		1,1,1,1, 1,1,1,0,
			   	],inf).coin.not,
			   	\out, BusDef(\bus0, \audio),
			   ),
			0,  	Pbind(
			   		\instrument, \envkrig,
			   		\freq, Pseq([
			   			1234,5432,2343,1999,
			   		],inf),
			   		\fmamp2, Pseq([1,2,0.5,0.01],inf),
			   		\legato, 0.1,
					\fspread1, 1,
					\fm1, Pkey(\freq)*3/4,
					\fm2, Pkey(\freq)*3/5,
					\adsr, Pseq([
						[ Env.adsr(0.2,0.1,0.2,0.7) ],
					],inf),
			   		\dur, 1/4,
			   		\out, BusDef(\bus0, \audio),
			   		\isRest, Pseq([
						Pseq([
							1,1,1,1, 1,1,1,0,
						],2),
						Pseq([
							0,1,0,1, 0,1,0,0,
						],2),
						Pseq([
							1,0,0,0, 0,0,0,0,
						],4),
			   		],inf).coin.not,
					\amp, 0.1/2,
			   	),
			0, Pbind(
				\instrument, \envkrig,
				\fmspread1, ~pmodenv.(Pseq([0.0001,0.2],inf), 8),
				\fm1, ~pmodenv.(Pseq([1,2,1,4]*400,inf), 8),
				\fmspread2, ~pmodenv.(Pseq([1.0001,0.002],inf), 8),
				\freq, Pseq([430,450],inf),
				\dur, 4,
				\amp, 0.1,
			),
		]),

			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.71,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		)
		
	])
)).play;
);

(
// try with no dry in fx and delay send to have sync
Pdef(\part, Pdef(\dis_part2b, 
	Ppar([
		Ptpar([
			0, Pbind(
			   	\instrument, \snapkickx,
			   	\dur, 1/8,
			   	\isRest, Pseq([
			   		1,0,0,0, 0,0,0,0,
			   		1,0,1,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\amp, 0.1,
			   	\out, BusDef(\bus0, \audio),
			   ),
			   0, PatKitDef(\ksh2b).asPattern(Pbind(
			   	\kitIndex, 5,
			   	\isRest, Pseq([
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\sustain, 0.1,
			   	\gain, 0.2,
			   	\dur, 1/8,
			   	\out, BusDef(\bus0, \audio),
			   )),
			0,   Pbind(
			   	\instrument, \envkrig,
			   	\freq, Pseq([
			   		123,543,234,199,
			   	],inf) * Prand([1/2,1/4],inf),
			   	\dur, 1/2,
			   	\legato, 0.1,
			   	\isRest, Pseq([
			   		1,1,1,1, 1,1,1,0,
			   	],inf).coin.not,
			   	\out, BusDef(\bus0, \audio),
			   ),
			0,  	Pbind(
			   		\instrument, \envkrig,
			   		\freq, Pseq([
			   			1234,5432,2343,1999,
			   		],inf),
			   		\fmamp2, Pseq([1,2,0.5,0.01],inf),
			   		\legato, 0.1,
					\fspread1, 1,
					\fm1, Pkey(\freq)*3/4,
					\fm2, Pkey(\freq)*3/5,
					\adsr, Pseq([
						[ Env.adsr(0.2,0.1,0.2,0.7) ],
					],inf),
			   		\dur, 1/4,
			   		\out, BusDef(\bus0, \audio),
			   		\isRest, Pseq([
						Pseq([
							1,1,1,1, 1,1,1,0,
						],2),
						Pseq([
							0,1,0,1, 0,1,0,0,
						],2),
						Pseq([
							1,0,0,0, 0,0,0,0,
						],4),
			   		],inf).coin.not,
					\amp, 0.1/2,
			   	),
			0, Pbind(
				\instrument, \envkrig,
				\fmspread1, ~pmodenv.(Pseq([0.0001,0.2],inf), 8),
				\fm1, ~pmodenv.(Pseq([1,2,1,4]*400,inf), 8),
				\fmspread2, ~pmodenv.(Pseq([1.0001,0.002],inf), 8),
				\freq, Pseq([430,450],inf),
				\dur, 4,
				\amp, 0.1,
			),
		]),

			Pmono(\sendtoarbusdel2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.71,
				\out2, 0,
				\gain2, 1.0,
				\delay2, 0.00,
				\dur, 1,
			),

		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\dis_part3, 
	Ppar([
		Ptpar([
			0, Pbind(
			   	\instrument, \snapkickx,
			   	\dur, 1/8,
			   	\isRest, Pseq([
			   		1,0,0,0, 0,0,1,0,
			   		1,0,1,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\amp, 0.1,
			   	\out, BusDef(\bus0, \audio),
			   ),
			   0, PatKitDef(\ksh2b).asPattern(Pbind(
			   	\kitIndex, 5,
			   	\isRest, Pseq([
			   		0,0,1,0, 1,0,0,0,
			   		0,1,0,0, 1,0,0,0,
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,1, 0,0,0,0,
			   	],inf).coin.not,
			   	\sustain, 0.1,
			   	\gain, 0.2,
			   	\dur, 1/8,
			   	\out, BusDef(\bus0, \audio),
			   )),
			   0, PatKitDef(\ksh2b).asPattern(Pbind(
			   	\kitIndex, 4,
			   	\isRest, Pseq([
			   		0,0,1,0, 0,0,0,1,
			   		0,0,1,0, 0,1,1,0,
			   	],inf).coin.not,
			   	\sustain, 0.1,
			   	\gain, 0.2,
			   	\dur, 1/8,
			   	\out, BusDef(\bus0, \audio),
			   )),
			   0, Pbind(
			   	\instrument, \phyhat3,
			   	\isRest, Pseq([
			   		1,1,
			   	],inf).coin.not,
			   	\sustain, 0.05,
			   	\fac1,0.1,
			   	\dur, 1/8,
			   	\amp, 0.01 * Pseq([1,0.7],inf),
			   ),
			0,   Pbind(
			   	\instrument, \envkrig,
			   	\freq, Pseq([
			   		123,543,234,199,
			   	],inf) * Prand([1/2,1/4],inf),
			   	\dur, 1/2,
			   	\legato, 0.1,
			   	\isRest, Pseq([
			   		1,1,1,1, 1,1,1,0,
			   	],inf).coin.not,
			   	\out, BusDef(\bus0, \audio),
			   ),
			0,  	Pbind(
			   		\instrument, \envkrig,
			   		\freq, Pseq([
			   			1234,5432,2343,1999,
			   		],inf),
			   		\fmamp2, Pseq([1,2,0.5,0.01],inf),
			   		\legato, 0.1,
					\fspread1, 1,
					\fm1, Pkey(\freq)*3/4,
					\fm2, Pkey(\freq)*3/5,
					\adsr, Pseq([
						[ Env.adsr(0.2,0.1,0.2,0.7) ],
					],inf),
			   		\dur, 1/4,
			   		\out, BusDef(\bus0, \audio),
			   		\isRest, Pseq([
						Pseq([
							1,1,1,1, 1,1,1,0,
						],2),
						Pseq([
							0,1,0,1, 0,1,0,0,
						],2),
						Pseq([
							1,0,0,0, 0,0,0,0,
						],4),
			   		],inf).coin.not,
					\amp, 0.1/2,
			   	),
			0, Pbind(
				\instrument, \envkrig,
				\fmspread1, ~pmodenv.(Pseq([0.0001,0.2],inf), 8),
				\fm1, ~pmodenv.(Pseq([1,2,1,4]*400,inf), 8),
				\fmspread2, ~pmodenv.(Pseq([1.0001,0.002],inf), 8),
				\freq, Pseq([430,450],inf),
				\dur, 4,
				\amp, 0.1,
			),
		]),

			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.71,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				Pseq([
					1000
				],8*2),
				Pseq([
					10000,1/10,
					1000,1/10,
					100,1/10,
					10,1/10,
				],1),
				Pseq([
					1,
				],inf),
			],inf).stutter(1),
			'delay2', 0.200000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\dis_part4, 
	Ppar([
		Ptpar([
			0, Pbind(
			   	\instrument, \snapkickx,
			   	\dur, 1/8,
			   	\isRest, Pseq([
			   		1,0,0,0, 0,0,1,0,
			   		1,0,1,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\amp, 0.1,
			   	\out, BusDef(\bus0, \audio),
			   ),
			   0, PatKitDef(\ksh2b).asPattern(Pbind(
			   	\kitIndex, 5,
			   	\isRest, Pseq([
			   		0,0,1,0, 1,0,0,0,
			   		0,1,0,0, 1,0,0,0,
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,1, 0,0,0,0,
			   	],inf).coin.not,
			   	\sustain, 0.1,
			   	\gain, 0.2,
			   	\dur, 1/8,
			   	\out, BusDef(\bus0, \audio),
			   )),
			   0, PatKitDef(\ksh2b).asPattern(Pbind(
			   	\kitIndex, 4,
			   	\isRest, Pseq([
			   		0,0,1,0, 0,0,0,1,
			   		0,0,1,0, 0,1,1,0,
			   	],inf).coin.not,
			   	\sustain, 0.1,
			   	\gain, 0.2,
			   	\dur, 1/8,
			   	\out, BusDef(\bus0, \audio),
			   )),
			   0, Pbind(
			   	\instrument, \phyhat3,
			   	\isRest, Pseq([
			   		1,1,
			   	],inf).coin.not,
			   	\sustain, 0.05,
			   	\fac1,0.1,
			   	\dur, 1/8,
			   	\amp, 0.01 * Pseq([1,0.7],inf),
			   ),
			0,   Pbind(
			   	\instrument, \envkrig,
			   	\freq, Pseq([
			   		123,543,234,199,
			   	],inf) * Prand([1/2,1/4],inf),
			   	\dur, 1/2,
			   	\legato, 0.1,
			   	\isRest, Pseq([
			   		1,1,1,1, 1,1,1,0,
			   	],inf).coin.not,
			   	\out, BusDef(\bus0, \audio),
			   ),
			0,  	Pbind(
			   		\instrument, \envkrig,
			   		\freq, Pseq([
			   			1234,5432,2343,1999,
			   		],inf),
			   		\fmamp2, Pseq([1,2,0.5,0.01],inf),
			   		\legato, 0.1,
					\fspread1, 1,
					\fm1, Pkey(\freq)*3/4,
					\fm2, Pkey(\freq)*3/5,
					\adsr, Pseq([
						[ Env.adsr(0.2,0.1,0.2,0.7) ],
					],inf),
			   		\dur, 1/4,
			   		\out, BusDef(\bus0, \audio),
			   		\isRest, Pseq([
						Pseq([
							1,1,1,1, 1,1,1,0,
						],2),
						Pseq([
							0,1,0,1, 0,1,0,0,
						],2),
						Pseq([
							1,0,0,0, 0,0,0,0,
						],4),
			   		],inf).coin.not,
					\amp, 0.1/2,
			   	),
			0, Pbind(
				\instrument, \envkrig,
				\fmspread1, ~pmodenv.(Pseq([0.0001,0.2],inf), 8),
				\fm1, ~pmodenv.(Pseq([1,2,1,4]*400,inf), 8),
				\fmspread2, ~pmodenv.(Pseq([1.0001,0.002],inf), 8),
				\freq, Pseq([430,450],inf),
				\dur, 4,
				\amp, 0.1,
			),
		]),

			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus1, \audio),
				\gain, 0.71,
				\out2, 0,
				\gain2, 1.0,
				\dur, 1,
			),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				Pseq([
					1000
				],8*2),
			],inf).stutter(1),
			'delay2', 0.200000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				Pseq([
					1,
				],inf),
			],inf).stutter(1),
			'delay2', 0.200000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 41.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(16, Pdef(\dis_part1)),
		Pfindur(8, Pdef(\dis_part2)),
		Pfindur(8, Pdef(\dis_part3)),
		Pfindur(16, Pdef(\dis_part4)),
	])
)).play;
)


///////////////

(
SynthDef(\repeater, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;

	sig1 = sig;
	sig1 = DelayL.ar(sig1, 1,\delay.kr(1));

	sig1 = DelayL.ar(sig1, 1,\delay.kr(1)) + sig1;
	sig1 = DelayL.ar(sig1, 1,\delay.kr(1)) + sig1;
	sig1 = DelayL.ar(sig1, 1,\delay.kr(1)) + sig1;
	sig1 = DelayL.ar(sig1, 1,\delay.kr(1)) + sig1;

	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\clochete, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = Dust.ar(10 * SinOsc.kr(1/8).range(10,1/2));
	sig1 = Ringz.ar(sig1, rrand(100,10000.0!8) * LFNoise0.kr(1/2).range(1/4,1), 1.1).mean/2;
	sig2 = Dust.ar(7);
	sig2 = Ringz.ar(sig2, rrand(100,10000.0!8), 1.1).mean/2;
	sig = sig1 + sig2;
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
// echo
Pdef(\part, Pdef(\dis_part2b, 
	Ppar([
		Ptpar([
			0, Pbind(
			   	\instrument, \snapkickx,
			   	\dur, 1/8,
			   	\isRest, Pseq([
			   		1,0,0,0, 0,0,0,0,
			   		1,0,1,0, 0,0,0,0,
			   		1,0,0,0, 0,0,0,0,
			   		1,1,1,1, 0,0,0,0,
			   		1,0,1,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\amp, 0.1,
			   	\out, BusDef(\bus0, \audio),
			   ),
			   0, PatKitDef(\ksh2b).asPattern(Pbind(
			   	\kitIndex, 5,
			   	\isRest, Pseq([
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,0, 1,0,0,0,
			   		0,0,0,0, 0,0,0,0,
			   	],inf).coin.not,
			   	\sustain, 0.1,
			   	\gain, 0.2,
			   	\dur, 1/8,
			   	\out, BusDef(\bus0, \audio),
			   )),
			   0, PatKitDef(\ksh2b).asPattern(Pbind(
			   	\kitIndex, 4,
			   	\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,1,1,1, 1,0,0,0,
			   	],inf).coin.not,
			   	\sustain, 0.071,
			   	\gain, 0.152,
			   	\dur, 1/16,
			   	\out, BusDef(\bus0, \audio),
			   )),
			0,   Pbind(
			   	\instrument, \envkrig,
			   	\freq, Pseq([
			   		123,543,234,199,
			   	],inf) * Prand([1/2,1/4],inf),
			   	\dur, 1/2,
			   	\legato, 0.1,
			   	\isRest, Pseq([
			   		1,1,1,1, 1,1,1,0,
			   	],inf).coin.not,
			   	\out, BusDef(\bus1, \audio),
			   ),
			0,  	Pbind(
			   		\instrument, \envkrig,
			   		\freq, Pseq([
			   			1234,5432,2343,1999,
			   		],inf),
			   		\fmamp2, Pseq([1,2,0.5,0.01],inf),
			   		\legato, 0.1,
					\fspread1, 1,
					\fm1, Pkey(\freq)*3/4,
					\fm2, Pkey(\freq)*3/5,
					\adsr, Pseq([
						[ Env.adsr(0.2,0.1,0.2,0.7) ],
					],inf),
			   		\dur, 1/4,
			   		\isRest, Pseq([
						Pseq([
							1,1,1,1, 1,1,1,0,
						],2),
						Pseq([
							0,1,0,1, 0,1,0,0,
						],2),
						Pseq([
							1,0,0,0, 0,0,0,0,
						],4),
			   		],inf).coin.not,
			   		\out, BusDef(\bus1, \audio),
					\amp, 0.1/2,
			   	),
			0, Pbind(
				\instrument, \envkrig,
				\fmspread1, ~pmodenv.(Pseq([0.0001,0.2],inf), 8),
				\fm1, ~pmodenv.(Pseq([1,2,1,4]*400,inf), 8),
				\fmspread2, ~pmodenv.(Pseq([1.0001,0.002],inf), 8),
				\freq, Pseq([430,450],inf),
				\dur, 4,
				\out, BusDef(\bus1, \audio),
				\amp, 0.1,
				\isRest, true,
			),
		]),

			Pmono(\simpletrackmixer,
				\inbus, BusDef(\bus1, \audio),
				\postgain, 0,
				\sendbus0, BusDef(\sendbus2, \audio),
				\send0, 1,
				\dur, 1,
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\bus0, \audio),
				\postgain, 1,
				\sendbus0, BusDef(\sendbus0, \audio),
				\send0, Pseq([
					0,0, 0,1,
				],inf).stutter(1),
				\sendbus1, BusDef(\sendbus1, \audio),
				\send1, 1,
				\dur, 1,
			),
			Pmono(\repeater,
				\inbus, BusDef(\sendbus0, \audio),
				\delay, 3/2/~t,
				\mix, 1,
				\gain, 1,
				\out, BusDef(\sendbus1, \audio),
				\dur, 1,
			),
		Pmono( \clochete,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\bus0, \audio),
		),


		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.001600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 11.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 44.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.200600001231 * Pseq([
				1,1/10,1/2,1/200,
			],inf).stutter(4),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 44.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		)
		
	])
)).play;
);

