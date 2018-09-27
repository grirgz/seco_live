~t = 170/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, 
			Pseq([
				\phyhat3, \phyhat3, \phyhat4,
				\phyhat3, \phyhat3, \phyhat4,
				 \phyhat3, \phyhat4,
			],inf),
			\isRest, Pseq([
				0,1,
				1,1,
				1,1,
				1,1,
				1,1,
				1,0,
				1,1,
				1,1,
			].rotate(1),inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\pos, 0.01,
			\sustain, 0.1,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus0, \audio),
		)),
		Pbind(
			\instrument, 
			Pseq([
				\phyhat3, \phyhat3, \phyhat4,
				\phyhat3, \phyhat3, \phyhat4,
				 \phyhat3, \phyhat4,
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				1,1,0,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus0, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,0, 1,0,1,1,
				 0,0,0,0, 1,0,1,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				 0,1,1,0, 1,1,0,1,
				 1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			//\pos, 0.01,
			\sustain, 0.1/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus0, \audio),
		)),
		
	])
)).play;
)

ProtoDef(\rdn).edit
ProtoDef(\rdn2).edit
ProtoDef(\rdn2, ProtoTemplateDef(\rdn))

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, 
			Pseq([
				\phyhat3, \phyhat3, \phyhat4,
				\phyhat3, \phyhat3, \phyhat4,
				 \phyhat3, \phyhat4,
			],inf),
			\isRest, Pseq([
				0,1,
				1,1,
				1,1,
				1,1,
				1,1,
				1,0,
				1,1,
				1,1,
			].rotate(1),inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\pos, 0.01,
			\sustain, 0.1,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus0, \audio),
		)),
		Pbind(
			\instrument, 
			Pseq([
				\phyhat3, \phyhat3, \phyhat4,
				\phyhat3, \phyhat3, \phyhat4,
				 \phyhat3, \phyhat4,
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				1,1,0,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus0, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,0, 1,0,1,1,

				 0,0,0,0, 1,0,1,1,
				 0,1,1,0, 1,1,0,1,
				 1,0,1,0, 0,0,0,0,
				1,1,1,0, 1,0,1,1,

				 0,0,0,0, 1,0,1,1,
				 0,1,1,0, 1,1,0,1,
				 0,1,1,0, 1,1,0,1,
				 1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			//\pos, 0.01,
			\sustain, 0.1/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus0, \audio),
		)),
		
	])
)).play;
)

(
~master_simple = {
	ProtoDef(\rdn).play;
	ProtoDef(\rdn2).play;
};
)
(
	~master_simple.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \basicbass,
			\freq, ~pmodsynth.({
				XLine.kr(50,200,8/~t) * LFNoise1.kr(3,mul:0.1,add:1);
			}),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\freq, ~pmodsynth.({
				LFTri.kr(1/5,mul:10,add:500)
			}),
			\dur, 1/16,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\amp, ~pmodenv.(Pseq([0,0.1,1,1,1]*0.1,inf), 4),
			\out, BusDef(\sendbus0, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\freq, ~pmodsynth.({
				LFTri.kr(1/4 * ( SinOsc.kr(1/5 * ( Pulse.kr(1/0.4) * 1 + 1 )) * 1 + 1 ),mul:40,add:1000 * ( SinOsc.kr(1/3.65) * 0.91 + 1 ))
			}),
			\dur, 1/7,
			\isRest, Pseq([
				Pseq([
					0,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\amp, ~pmodenv.(Pseq([0,0.1,1,1,1]*0.1,inf), 5),
			\out, BusDef(\sendbus0, \audio),
		),
		Pbind(
			\instrument, \basicbass,
			\freq, ~pmodsynth.({
				LFTri.kr(1/7,mul:40,add:1100)
			}),
			\dur, 1/16,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\amp, ~pmodenv.(Pseq([0,0.1,1,1,1]*0.1,inf), 3),
			\out, BusDef(\sendbus0, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
)

(
	~master_simple.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				Pseq( 0-(1..16) ,3),
				Pseq( 0-(1..4) ,4),
			],inf),
			\lpfr, 4,
			\diff, 1,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1,
			\lag, 0.003,
			\amp, 0.1,
			\out, BusDef(\sendbus0, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, 
			Pseq([
				\phyhat3, \phyhat3, \phyhat4,
				\phyhat3, \phyhat3, \phyhat4,
				 \phyhat3, \phyhat4,
			],inf),
			\isRest, Pseq([
				0,1,
				1,1,
				1,1,
				1,1,
				1,1,
				1,0,
				1,1,
				1,1,
			].rotate(1),inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),

		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\pos, 0.01,
			\sustain, 0.1,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus0, \audio),
		)),
		Pbind(
			\instrument, 
			Pseq([
				\phyhat3, \phyhat3, \phyhat4,
				\phyhat3, \phyhat3, \phyhat4,
				 \phyhat3, \phyhat4,
			],inf),
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				1,1,0,0, 1,0,1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus0, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 6,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,0, 1,0,1,1,

				 0,0,0,0, 1,0,1,1,
				 0,1,1,0, 1,1,0,1,
				 1,0,1,0, 0,0,0,0,
				1,1,1,0, 1,0,1,1,

				 0,0,0,0, 1,0,1,1,
				 0,1,1,0, 1,1,0,1,
				 0,1,1,0, 1,1,0,1,
				 1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			//\pos, 0.01,
			\sustain, 0.1/2,
			\speed, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf),
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\sendbus0, \audio),
		)),
		
	])
)).play;
)



////////////////////////////////////////////////:



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/crush.flac'),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\pos, 41.72,
			\dur, 1/8,
			\sustain,1/1,
			\gain, 1/12,
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
			'delay2', 0.210000543560101,
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
			\instrument, \basicbass,
			\note, Pseq([
				7,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \iron,
			\note, Pseq([
				0,2,1,0,
			],inf),
			\octave, 5,
			\env1, Pseq([
				[ Env([1,0.2,1]/4,[0.4,0.8]) ]
			],inf),
			\gain,4,
			\fmr, 1/2,
			\lpfr, 2,
			\rq, 0.41,
			\foldbias, -1.5,
			\foldlevel, 1.5,
			\diff, 0.02 * Pseq([1,1/10],inf),
			\trigenv, 1,
			\fmamp, 1.5,
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
			\instrument, \playersec,
			\bufnum, BufDef('vipere/crush.flac'),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\pos, 49.72,
			\dur, 1/8,
			\sustain,1/1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\gain, 1/12,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vipere/crush.flac'),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\pos, 47.72,
			\dur, 1/8,
			\sustain,1/2,
			\gain, 1/12,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000000001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 9.361836201538,
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
		
	])
)).play;
)

////////////////////////////

(
SynthDef(\grancru, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum, gdur=0.1, gfreq=8, pos=0;
	var sig;
	var clk = Impulse.ar(gfreq);
	pos = pos + LFNoise1.ar(8,mul:0.1) + XLine.kr(0.01,10,2);
	sig = TGrains.ar(2, clk, mbufnum, \pitch_stretch.kr(1), pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \grancru,
			\mbufnum, BufDef.mono('vipere/crush.flac'),
			\pos, 65,
			\gfreq, 140,
			\gdur, 0.1/2,
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
)


(
SynthDef(\grancru, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum, gdur=0.1, gfreq=8, pos=0, pitch_stretch=1;
	var sig;
	var clk = Impulse.ar(gfreq);
	pos = pos + LFNoise1.ar(gfreq,mul:0.01);
	//pitch_stretch = pitch_stretch + LFNoise1.ar(10, mul:0.1);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \grancru,
			\mbufnum, BufDef.mono('vipere/rocksteady.flac'),
			\pos, ~pmodenv.(Pseq([1,2,1,4]+3,inf), 8),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.4) ],
			],inf),
			\gfreq, 740,
			\gdur, 0.02,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 2,
			\gain, 1,
		)
		
	])
)).play;
)
