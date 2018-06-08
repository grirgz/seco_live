
~t = 185/4/60; TempoClock.default.tempo = ~t;
(
SynthDef(\acidtry, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var ttrig = \ttrig.tr(1);
	env2 = SinOsc.kr(1/18,mul:0.2,add:1);
	env1 = EnvGen.kr(Env([1.2,1.24 * env2,0.91],[0.01,0.1]), ttrig);
	sig = LFSaw.ar(freq * [1,1.01,1.001,1/2,2]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * SinOsc.kr(1/16,mul:0.2,add:1) * [1,1.01,1.001,2,1/2] * freq * env1, \rq.kr(0.01)* SinOsc.kr(1/16,mul:0.2,add:1));
	sig = sig / 1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo).reset;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pmono(
			 \acidtry,
			\note, Pseq([
				0,3,5,-1,
				0,3,2,-1,
			],inf),
			\ttrig, 1,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
)
(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 200 * (x+1),
				\sustain, 0.1,
				\dur, 1/(x+1) * 2,
				\amp, 0.1
			);
		})
	)).play;
);
(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 200 * (x+1),
				\sustain, 0.1,
				\dur, 1/8 * (x+1),
				\amp, 0.1
			);
		})
	)).play;
);

(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 3200 / (x+1),
				\sustain, 0.1,
				\dur, 1/8 * (x+1),
				\amp, 0.1
			);
		})
	)).play;
);

(
	Pdef(\durserie, Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 3200 / (x+1),
				\sustain, 0.1,
				\dur, 2 / (x+1),
				\amp, 0.1
			);
		})
	)).play;
);

///////////////// add or substract dur and freq by the naturals
// which is equivalent of adding some offset to the previous method
(
	Pdef(\durserie,
	   	Ppar(
		8.collect({ arg x;
			Pbind(
				\instrument, \default,
				\freq, 200 + (x+1*200),
				\sustain, 0.1,
				\dur, 1/4+(x/16),
				\amp, 0.1
			);
		})
	)
).play;
);
(
Ndef(\saro, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = LFSaw.ar(freq * ( 1 + ( SinOsc.kr((1..8)/148) * 0.01 )));
	sig2 = LFSaw.ar(freq * ( 1 + ( SinOsc.kr((1..8)/148 + 0.0001) * 0.01 )));
	sig = sig1 + sig2;
	//sig = BPF.ar(sig, SinOsc.kr((1..8)/20).range(140,9001));
	sig = BPF.ar(sig, SinOsc.kr((1..8)/40).range(freq/1.2,freq*1.2), 0.01) + (sig/4 );
	sig = LPF.ar(sig, 5000);
	sig = Pan2.ar(sig, pan, amp).flop;
}).play;
);


(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.2,1.4]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([1,1,0,0],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	//sig = sig * ( SinOsc.ar(freq) + 1  );
	sig1 = ( SinOsc.ar(freq) + 1  );
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig * sig1;
	sig = LPF.ar(sig, \lpfr.kr(8.1) * freq);

	sig1 = SinOsc.ar(2*~t).exprange(0.1,1);
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig/4 + LPF.ar(sig.fold2( sig1 ), 10000);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);

(
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
Pdef(\treb, 
	Pbind(
		\instrument, \clochete,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

Ndef(\bitshift, {
	var t = PulseCount.ar(Impulse.ar(8e3));
	var sig = HPF.ar(
		(  
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2; 
	sig/4;
	//sig = Greyhole.ar(sig, sig, 0.5, sig).flop.mean/4;
}).play;


///////////////////////////////////////////////////////////////:

(
SynthDef(\bitbit, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var t = PulseCount.ar(Impulse.ar(8e3*~t * \freqfac.kr(1)));
	sig = HPF.ar(
		(  
			((t * \f1.kr(100)) & (t >> \s1.kr(5))) |
			((t * \f2.kr(2)) & (t >> \s2.kr(5))) |
			((t * \f3.kr(8)) & (t >> \s3.kr(11)))
			- 3 % 256
		) / 127-1 * 3
		, \hpf.kr(20)
	).distort * 0.2; 
	sig = sig*4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([461, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101 ,
			'delay2', ~pmodenv.(Pseq([0.000001,0.0002],inf), 8),
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pbind(
			\instrument, \bitbit,
			\legato, 1,
			\f1, Pseg(Pseq([190,1/10],inf),8),
			\s1, Pseg(Pseq([19,1],inf),8),
			\freq, 200,
			\dur, 1,
			\amp, 0.1/1.5,
			\lag, 0.04,
		),
		PmonoArtic(\noisybass,
			\note, Pseq([
				0,0,0,0, 0,0,0,0, 0,1,
				0,0,0,0, 0,0,0,0, 0,1,
				0,0,0,0, 0,0,0,0, 0,1,
				0,4,4,4, 4,5,0,0, 0,1,
			],inf),
			\legato, Pseq([
				1,0.7,1,1,0.1
			],inf),
			\lpfr, Pseq([
				1,2,8,4
			],inf),
			\trigx, Pseq([
				1,0,0,1,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),

		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0, 0,0,1,
				0,0,0, 0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/6,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, PdurStutter(Pseq([1,4,2,8,6,6,6,3],inf), 1/2),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \clochete,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([461, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101 ,
			'delay2', ~pmodenv.(Pseq([0.000001,0.0002],inf), 8),
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		Pbind(
			\instrument, \bitbit,
			\legato, 1,
			\f1, Pseg(Pseq([190,1/10],inf),8),
			\s1, Pseg(Pseq([19,1],inf),8),
			\freq, 200,
			\dur, 1/8,
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				4,0,0,0, 1,1,1,1,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/1.5,
			\lag, 0.04,
		),
		PmonoArtic(\noisybass,
			\note, Pseq([
				0,0,0,0, 0,0,0,0, 0,1,
				0,0,0,0, 0,0,0,0, 0,1,
				0,0,0,0, 0,0,0,0, 0,1,
				0,4,4,4, 4,5,0,0, 0,1,
			],inf),
			\legato, Pseq([
				1,0.7,1,1,0.1
			],inf),
			\lpfr, Pseq([
				1,2,8,4
			],inf),
			\trigx, Pseq([
				1,0,0,1,0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),

		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0, 1,0,0,
				0,0,0, 1,0,1,
				0,0,0, 0,0,0,
				0,0,0, 0,0,1,
				0,0,0, 0,1,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/6,
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, PdurStutter(Pseq([
				1, 1, 1, 1,
				Pseq([ 4 ],4),
				1, 1, 3, 3,
				Pseq([ 3,1 ],2),
			],inf), 1/2),
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
		Pbind(
			\instrument, \clochete,
			\isRest, Pseq([
				0,0,0,1,
			],inf).coin.not,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono( \bitbit,
			\s2, 10,
			\f1, 0.1,
			\f2, 0.1,
			\s1, 1,
			\freqfac, 2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.05,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.80001001,
			'delay3', 0.2000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 4.89,
			'shift', -0.05,
			'shiftmix', 1.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \bitbit,
			\s2, 10,
			\f1, 8.1,
			\f2, 4.1,
			\f3, 1.1,
			\s1, 1,
			\s2, 1,
			\s3, Pseq([
				10,2
			],inf),
			\f1, Pseq([
				1,2
			],inf),
			\freqfac, 1/2,
			\dur, 1/8,
			\amp, 0.1,
			\hpf, 1000,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			\lag, 0.0005,
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.1,
			'gain', 1/2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 4.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,1,0,0, 1,0,0,1,
				0,0,0,0, 1,0,1,1,
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 1,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16*2,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono( \bitbit,
			\s2, 10,
			\f1, 8.1,
			\f2, 4.1,
			\f3, 1.1,
			\s1, 10,
			\s2, 6,
			\s3, Pseq([
				10,2
			],inf),
			\f1, Pseq([
				1,2
			],inf),
			\freqfac, 1/2,
			\dur, 1/8,
			\amp, 0.1,
			\hpf, 1000,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			\lag, 0.0005,
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.1,
			'gain', 1/2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001 * Pseq([
				1,10000,1,1,1,
				1,1,1,1,
			],inf),
			'delay3', 0.0001080 * Pseq([
				1,1,1,1, 1,10, 1,1,
				1,2,1,1, 2,1, 1,2,
			],inf),
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 4.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 1.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 1700,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 1700,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
		
	])
)).play;
)

////////////////////////////////////////////////////////////


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pseq([
			Pfindur(32,
				Ppar([
					Pmono( \bitbit,
						\s2, 10,
						\f1, 0.1,
						\f2, 0.1,
						\s1, 1,
						\freqfac, 2,
						\dur, 1,
						\amp, 0.1,
						\out, BusDef(\sendbus1, \audio),
					),
					Pmono(\rdnroom,
						\inbus, BusDef(\sendbus1, \audio, 2),
						\dur, 1/8,
						'wet10', 1.0,
						'mix', 0.05,
						\mix, ~pmodenv.(Pseq([0,0,0.01, Pn(0.06,inf)],inf), Pseq([4],inf)),
						'gain', 2,
						'fb', 0.000000031,
						'delay', 0.00000001,
						'delay2', 0.80001001,
						'delay3', 0.2000080,
						'distamp', 0.604,
						'distamp2', 0.23,
						'distamp3', 4.89,
						'shift', ~pmodenv.(-0.05 * Pseq([0,0,0,1,40],inf), 8),
						'shiftmix', 1.0,
						'shiftmix', ~pmodenv.(Pseq([0,0,0, Pn(1)],inf), 8),
						'stereo', 1.0,
						'indelay', 0.04,
					),
				
				])
			),
			Pfindur(32,
				Ppar([

					Pbind(
						\instrument, \snapkickx,
						\dur, 1/8,
						\isRest, Pseq([
							1,0,0,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
						],inf).coin.not,
						\amp, 0.1,
						\out, BusDef(\sendbus1, \audio),
					),
					Pmono( \bitbit,
						\s2, 10,
						\f1, 8.1,
						\f2, 0.1,
						\f3, 1.1,
						\s1, 1,
						\s2, 1,
						\s3, Pseq([
							1,2
						],inf),
						\f1, Pseq([
							1,2
						],inf),
						\freqfac, 1/2,
						\dur, 1/8,
						\amp, 0.1,
						\hpf, 1000,
						\out, BusDef(\sendbus1, \audio),
					),
					Pmono(\rdnroom,
						\inbus, BusDef(\sendbus1, \audio, 2),
						\addAction, \addToTail,
						\lag, 0.0005,
						\dur, 1/8,
						'wet10', 1.0,
						'mix', 0.01,
						'gain', 2,
						'fb', 0.000000031,
						'delay', 0.00000001,
						'delay2', 0.00001001,
						'delay3', 0.2000080,
						'distamp', 0.604,
						'distamp2', 0.23,
						'distamp3', 0.89,
						'shift', -5.0,
						'shiftmix', 0.0,
						'stereo', 1.0,
						'indelay', 0.04,
					),
				]),
			),
		],1),
		
	])
)).play;
)


////////////////////////////////////
(
Pdef(\part, Pdef(\zed, 
	Pseq([
		Pfindur(6,
			Ppar([
			
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
					\out, BusDef(\dsendbus1, \audio),
				),
				Pmono( \bitbit,
					\s2, 10,
					\f1, 8.1,
					\f2, 0.1,
					\f3, 1.1,
					\s1, 1,
					\s2, 1,
					\s3, Pseq([
						1,2
					],inf),
					\f1, Pseq([
						1,2
					],inf),
					\freqfac, 1/2,
					\dur, 1/8,
					\amp, 0.1,
					\hpf, 1000,
					\out, BusDef(\dsendbus1, \audio),
				),
				Pmono(\rdnroom,
					\inbus, BusDef(\dsendbus1, \audio, 2),
					\addAction, \addToTail,
					\lag, 0.0005,
					\dur, 1/8,
					'wet10', 1.0,
					'mix', 0.01,
					'gain', 2,
					'fb', 0.000000031,
					'delay', 0.00000001,
					'delay2', 0.00001001 * Pseq([
						1,100,
					],inf).stutter(8*2),
					'delay3', 0.2000080,
					'distamp', 0.604,
					'distamp2', 0.23,
					'distamp3', 0.89,
					'shift', -5.0,
					'shiftmix', 0.0,
					'stereo', 1.0,
					'indelay', 0.04,
				),
						Pmono(\rdnroom,
							\inbus, BusDef(\dsendbus1, \audio, 2),
							\addAction, \addToTail,
							\lag, 0.0005,
							\dur, 1/8,
							'wet10', 1.0,
							'mix', 0.1 * Pseq([
								0
							],inf),
							'gain', 1/2,
							'fb', 0.000000031,
							'delay', 0.00000001,
							'delay2', 0.00001001 * Pseq([
								1,10000,1,1,1,
								1,1,1,1,
							],inf),
							'delay3', 0.0001080 * Pseq([
								1,1,1,1, 1,10, 1,1,
								1,2,1,1, 2,1, 1,2,
							],inf),
							'distamp', 0.604,
							'distamp2', 0.23,
							'distamp3', 4.89,
							'shift', -5.0,
							'shiftmix', 0.0,
							'stereo', 1.0,
							'indelay', 0.04,
						),
			]),
		),
		Pfindur(2,
			Ppar([
			
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
					\out, BusDef(\dsendbus1, \audio),
				),
				Pmono( \bitbit,
					\s2, 10,
					\f1, 8.1,
					\f2, 0.1,
					\f3, 1.1,
					\s1, 1,
					\s2, 1,
					\s3, Pseq([
						1,2
					],inf),
					\f1, Pseq([
						1,2
					],inf),
					\freqfac, 1/2,
					\dur, 1/8,
					\amp, 0.1,
					\hpf, 1000,
					\out, BusDef(\dsendbus1, \audio),
				),
				Pmono(\rdnroom,
					\inbus, BusDef(\dsendbus1, \audio, 2),
					\addAction, \addToTail,
					\lag, 0.0005,
					\dur, 1/8,
					'wet10', 1.0,
					'mix', 0.01,
					'gain', 2,
					'fb', 0.010000031,
					'delay', 0.80000001,
					'delay2', 0.00001001,
					'delay3', 0.2000080,
					'distamp', 0.604,
					'distamp2', 0.23,
					'distamp3', 0.89,
					'shift', -5.0,
					'shiftmix', 0.0,
					'stereo', 1.0,
					'indelay', 0.04,
				),
						Pmono(\rdnroom,
							\inbus, BusDef(\dsendbus1, \audio, 2),
							\addAction, \addToTail,
							\lag, 0.0005,
							\dur, 1/8,
							'wet10', 1.0,
							'mix', 0.1,
							'gain', 1/2,
							'fb', 0.010000031,
							'delay', 0.00000001,
							'delay2', 0.00001001 * Pseq([
								1,10000,1,1,1,
								1,1,1,1,
							],inf),
							'delay3', 0.0001080 * Pseq([
								1,1,1,1, 1,10, 1,1,
								1,2,1,1, 2,1, 1,2,
							],inf),
							'distamp', 0.604,
							'distamp2', 0.23,
							'distamp3', 4.89,
							'shift', -5.0,
							'shiftmix', 0.0,
							'stereo', 1.0,
							'indelay', 0.04,
						),
			]),
		),
		Pfindur(6,
			Ppar([
			
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
					\out, BusDef(\dsendbus1, \audio),
				),
				Pmono( \bitbit,
					\s2, 10,
					\f1, 8.1,
					\f2, 0.1,
					\f3, 1.1,
					\s1, 1,
					\s2, 1,
					\s3, Pseq([
						1,2
					],inf),
					\f1, Pseq([
						1,2
					],inf),
					\freqfac, 1/2,
					\dur, 1/8,
					\amp, 0.1,
					\hpf, 1000,
					\out, BusDef(\dsendbus1, \audio),
				),
				Pmono(\rdnroom,
					\inbus, BusDef(\dsendbus1, \audio, 2),
					\addAction, \addToTail,
					\lag, 0.0005,
					\dur, 1/8,
					'wet10', 1.0,
					'mix', 0.01,
					'gain', 2,
					'fb', 0.000000031,
					'delay', 0.00000001,
					'delay2', 0.00001001 * Pseq([
						1,100,
					],inf).stutter(8*2),
					'delay3', 0.2000080,
					'distamp', 0.604,
					'distamp2', 0.23,
					'distamp3', 0.89,
					'shift', -5.0,
					'shiftmix', 0.0,
					'stereo', 1.0,
					'indelay', 0.04,
				),
						Pmono(\rdnroom,
							\inbus, BusDef(\dsendbus1, \audio, 2),
							\addAction, \addToTail,
							\lag, 0.0005,
							\dur, 1/8,
							'wet10', 1.0,
							'mix', 0.1 * Pseq([
								1
							],inf),
							'gain', 1/2,
							'fb', 0.000000031,
							'delay', 0.00000001,
							'delay2', 0.00001001 * Pseq([
								1,10000,1,1,1,
								1,1,1,1,
							],inf),
							'delay3', 0.0001080 * Pseq([
								1,1,1,1, 1,10, 1,1,
								1,2,1,1, 2,1, 1,2,
							],inf),
							'distamp', 0.604,
							'distamp2', 0.23,
							'distamp3', 4.89,
							'shift', -5.0,
							'shiftmix', 0.0,
							'stereo', 1.0,
							'indelay', 0.04,
						),
			]),
		),
		Pfindur(2,
			Ppar([
			
				Pbind(
					\instrument, \snapkickx,
					\dur, 1/8,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\amp, 0.1,
					\out, BusDef(\dsendbus1, \audio),
				),
				Pbind(
					\instrument, \noisybass,
					\freq, 70,
					\dur, 2,
					\legato, 1,
					\amp, 0.1/4,
					\out, BusDef(\dsendbus1, \audio),
				),
				Pmono( \bitbit,
					\s2, 10,
					\f1, 8.1,
					\f2, 0.1,
					\f3, 1.1,
					\s1, 10,
					\s2, 1,
					\s3, Pseq([
						1,2
					],inf),
					\f1, Pseq([
						1,2
					],inf),
					\freqfac, 1/2,
					\dur, 1/8,
					\amp, 0.1,
					\hpf, 1000,
					\out, BusDef(\dsendbus1, \audio),
				),
				Pmono(\rdnroom,
					\inbus, BusDef(\dsendbus1, \audio, 2),
					\addAction, \addToTail,
					\lag, 0.0005,
					\dur, 1/8,
					'wet10', 1.0,
					'mix', 0.01,
					'gain', 2,
					'fb', 0.010000031,
					'delay', 0.80000001,
					'delay2', 0.00001001,
					'delay3', 0.2000080,
					'distamp', 0.604,
					'distamp2', 0.23,
					'distamp3', 0.89,
					'shift', -5.0,
					'shiftmix', 0.0,
					'stereo', 1.0,
					'indelay', 0.04,
				),
						Pmono(\rdnroom,
							\inbus, BusDef(\dsendbus1, \audio, 2),
							\addAction, \addToTail,
							\lag, 0.0005,
							\dur, 1/8,
							'wet10', 1.0,
							'mix', 0.1,
							'gain', 1/2,
							'fb', 0.010000031,
							'delay', 0.80000001,
							'delay2', 0.00001001 * Pseq([
								10000,
							],inf),
							'delay3', 0.0001080 * Pseq([
								1,1,1,1, 1,10, 1,1,
								1,2,1,1, 2,1, 1,2,
							],inf),
							'distamp', 0.604,
							'distamp2', 0.23,
							'distamp3', 4.89,
							'shift', -5.0,
							'shiftmix', 0.0,
							'stereo', 1.0,
							'indelay', 0.04,
						),
			]),
		),
				Pfindur(32,
					Ppar([
						Pbind(
							\instrument, \snapkickx,
							\dur, 1/8,
							\isRest, Pseq([
								1,0,0,0, 0,0,0,0,
								0,0,0,0, 0,0,0,0,
								1,0,0,0, 0,0,0,0,
								1,0,1,0, 0,0,0,0,
								1,0,0,0, 0,0,0,0,
								0,0,1,0, 0,0,0,1,
								1,0,0,0, 0,0,0,0,
								0,0,0,0, 1,0,0,0,
							],inf).coin.not,
							\amp, 0.1,
							\out, BusDef(\sendbus1, \audio),
						),
						PatKitDef(\ksh2b).asPattern(Pbind(
							\kitIndex, 5,
							\isRest, Pseq([
								Pseq([
									0,0,0,0, 0,0,0,0,
								],inf),
								0,1,0,0, 1,0,0,1,
								0,0,0,0, 1,0,1,1,
								0,0,1,0, 0,1,0,1,
								0,0,0,0, 1,1,0,1,
							],inf).coin.not,
							\sustain, 0.1,
							\gain, 0.2,
							\dur, 1/16*2,
							\out, BusDef(\sendbus1, \audio),
						)),
						Pmono( \bitbit,
							\s2, 10,
							\f1, 8.1,
							\f2, 4.1,
							\f3, 1.1,
							\s1, 10,
							\s2, 6,
							\s3, Pseq([
								10,2
							],inf),
							\f1, Pseq([
								1,2
							],inf),
							\freqfac, 1/2,
							\dur, 1/8,
							\amp, 0.1,
							\hpf, 1000,
							\out, BusDef(\sendbus1, \audio),
						),
						Pbind(
							\instrument, \phyhat3,
							\isRest, Pseq([
								1,0,1,0, 1,0,1,0, 
								0,0,0,0, 0,0,0,0,
								0,0,0,0, 1,1,0,0,
								0,0,0,0, 0,0,0,0,
								1,1,1,1, 0,0,0,0,
							],inf).coin.not,
							\sustain, 0.05,
							\fac1,0.1,
							\dur, 1/8,
							\amp, 0.01 * Pseq([1,0.7],inf),
							\out, BusDef(\sendbus1, \audio),
						),

						Pseq([
							Event.silent(8),
							Pfindur(6,
									   Ppar(
									8.collect({ arg x;
										Pbind(
											\instrument, \default,
											\freq, 200 * (x+1),
											\sustain, 0.1,
											\dur, 1/1+(x/16),
											\amp, 0.1/4,
											\amp, ~pmodenv.(Pseq([0,0.1],inf), 8),
											\out, BusDef(\sendbus1, \audio),
										);
									})
								),
							),
							Pbind(
								\instrument, \noisybass,
								\freq, ~pmodenv.(Pseq([100,92,71],inf), 1),
								\dur, Pn(1,1),
								\amp, 0.1,
							),
							Event.silent(2),

							// 16 b

							Event.silent(2),
							Pfindur(5,
								Ppar(
									8.collect({ arg x;
										Pbind(
											\instrument, \default,
											\freq, 200 * (x+1),
											\sustain, 0.1,
											\dur, 1/(x+1) * 2,
											\amp, 0.1/4,
											\out, BusDef(\sendbus1, \audio),
										);
									})
								)
							),
							Event.silent(1),
							Pfindur(8,
								Ppar(
									8.collect({ arg x;
										Pbind(
											\instrument, \default,
											\freq, 100 * (x+3),
											\sustain, 0.1*(x+1/4),
											\dur, 1/(x+1) * 4,
											\amp, 0.1/4,
											\out, BusDef(\sendbus1, \audio),
										);
									})
								)
							),
						],1),
						Pmono(\rdnroom,
							\inbus, BusDef(\sendbus1, \audio, 2),
							\addAction, \addToTail,
							\lag, 0.0005,
							\dur, 1/8,
							'wet10', 1.0,
							'mix', 0.1,
							'gain', 1/2,
							'fb', 0.000000031,
							'delay', 0.00000001,
							'delay2', 0.00001001 * Pseq([
								1,10000,1,1,1,
								1,1,1,1,
							],inf),
							'delay3', 0.0001080 * Pseq([
								1,1,1,1, 1,10, 1,1,
								1,2,1,1, 2,1, 1,2,
							],inf),
							'distamp', 0.604,
							'distamp2', 0.23,
							'distamp3', 4.89 * Pseq([
								Pseq([
									1
								],8*16),
								Pser([
									1/8,1/8,1
								],8*16),
							],inf),
							'shift', -5.0,
							'shiftmix', 0.0,
							'stereo', 1.0,
							'indelay', 0.04,
						),
						Pmono( \rdncleandist_fulllight,
							\inbus, BusDef(\sendbus1, \audio, 2),
							\addAction, \addToTail,
							'mix', 0.15714285714286,
							'gain', 0.7344889782792,
							'fb', 0.0002099467303085,
							'delay', 0.000600001231 * Pseq([
								1,
							],inf).stutter(1),
							'delay2', 0.210000543560101,
							'distamp', 1.361836201538,
							'prelpf', 19900,
							'prehpf', 17,
							'lpf', 19900,
							'hpf', 1700,
							'fbdistamp', 4.5388371966577,
							'fbdistmix', 0.98176470588235,
							'postlpf', 19900,
							'posthpf', 1700,
							\bpmix, 0,
							'wetamp', 0.20503372119697,
							'indelay', 0.04,
							\dur, 1,
						),
					]),
				),
		
	])
)).play;
)
