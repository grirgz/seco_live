SynthDef(\sendtoarbus2, { arg out=0, out2=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	Out.ar(out, sig);
	Out.ar(out2, sig * \gain2.kr(0));
}).add;
SynthDef(\chordb, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = {arg x; 
		var isig;
		var ffac = 8;
		isig = LFSaw.ar( freq/2 * x + ExpRand(freq/64,2*freq/64));
		isig = isig + LFPulse.ar( freq/ffac * x + ExpRand(freq/64/ffac,2*freq/64/ffac));

		isig = RLPF.ar(isig, freq/2 * x + ExpRand(freq/64,2*freq/64)* LFNoise1.kr(1/4).range(1.1,1) * \lpffac.kr(2) , \rq.kr(0.5));
	}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	//sig = FreqShift.ar(sig, 4 * SinOsc.kr(1/45).range(0,1)) + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 5;
	Out.ar(out, sig);
}).add;

SynthDef(\somemore, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 5;
	Out.ar(out, sig);
}).add;

SynthDef(\snapkickx, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = body + pop + click;
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Pbind(\out, BusDef(\mixer0, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snapkick,
			\dur, 1/8,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\fac1,0.1,
			\sustain, 0.05,
			\dur, 1/8,
			\amp, 0.051,
		),
		Pbind(
			\instrument, \snapsnare,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.5,
			\dur, 1/16,
			\amp, 0.051,
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
		),
	])
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,0, 0,0,1,0, 1,1,1,0,
					0,0,0,0, 0,0,1,1, 0,0,1,0, 1,0,1,0,
					0,0,0,0, 1,0,1,1, 0,0,1,0, 1,1,1,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
	]),
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,0, 0,0,1,0, 1,1,1,0,
					0,0,0,0, 0,0,1,1, 0,0,1,0, 1,0,1,0,
					0,0,0,0, 1,0,1,1, 0,0,1,0, 1,1,1,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
	]),
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,0, 0,0,1,0, 1,1,1,0,
					0,0,0,0, 0,0,1,1, 0,0,1,0, 1,0,1,0,
					0,0,0,0, 1,0,1,1, 0,0,1,0, 1,1,1,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind( // violin
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 1/1 * Pseq([
				0,0,0,-1,
			],inf).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),

			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),

			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/41*~t).range(0.2,1.2)+0.2 },2),
			],inf),

			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\legato, Pseq([
				16,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/16,
			\gain, 30,
			\gain, 1/8/4,
			\amp, 0.1,
			\out, BusDef(\mixer4, \audio),
		),
	]),
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,0,0, 1,0,1,0, 1,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,0, 0,0,1,0, 1,1,1,0,
					0,0,0,0, 0,0,1,1, 0,0,1,0, 1,0,1,0,
					0,0,0,0, 1,0,1,1, 0,0,1,0, 1,1,1,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind( // violin
			\instrument, \playersec_fixzig_stereo,
			\instrument, \playersec_osczig_stereo,
			\instrument, Pseq([
				\playersec_osc,
				\playersec_osczig,
				\playersec_osczig_stereo,
			],inf),
			\trigfreq, 400 * 2 * Pseq([
				0,0,2,1,
			]-5,inf).stutter(8).midiratio,
			\pos, Pseg(Pseq([0,0.1],inf),8)+0.1,
			\pos, 0.4,
			\speed, Pseq([
				1,1.1,0.8,
			],inf),

			//\speed, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			//\pos, ~pmodsynth.({ SinOsc.kr(4*~t).range(0.2,1) }),
			//\speed, ~pmodsynth.({ LFSaw.kr(1/2*~t).range(1.02,0.2)*2 }),
			//\pos, ~pmodenv.(Pseq([2.1,1,0.1,2],inf), 8),
			\speed, Pseq([
				4,4,4,1
			],inf).stutter(16*1),

			\pos, Pseq([
				~pmodsynth.({ SinOsc.kr(1/41*~t).range(0.2,1.2)+0.2 },2),
			],inf),

			\lpfr, 8,
			\legato, 0.5,
			\bufnum, BufDef(\table, "field/table.flac"),
			\bufnum, BufDef('loop/clean7_135bpm.flac'),
			\bufnum, BufDef('loop/loop3b_185bpm.flac'),
			\bufnum, BufDef('voices/feynman.flac'),
			\legato, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0.2,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 1,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\freq, 200,
			\dur, 1/16,
			\gain, 30,
			\gain, 1/8,
			\amp, 0.1,
			\out, BusDef(\mixer4, \audio),
		),
	]),
)).play;
)

////////////////////////////////


ProtoDef(\rdn).genfx

(

		SynthDef(\rdncleandist, { arg out=0, gate=1;
			var sig;
			var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
				var hasFreq, afreq;
				var pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
				var pitchmix = \pitchmix.kr(0.5);

			thisThread.randSeed = 16266;
			thisThread.randSeed = 16262;

				in = LPF.ar(in, \prelpf.kr(17000));
				in = HPF.ar(in, \prehpf.kr(17));
			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
				sig = LPF.ar(sig, \lpf.kr(17000));
				sig = HPF.ar(sig, \hpf.kr(17));
			si = sig;
			sig = { arg si, env;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = [
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);

].mean;
si = (si * 10.rand * \distamp.kr).tanh / 2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
}.value(si, env);

				sig1 = sig.tanh * \fbdistamp.kr(1/2.1);
				sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

			sig = Limiter.ar(sig);
				sig1 = sig;
				#afreq, hasFreq = Pitch.kr(sig1).flop;
				sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
				#afreq, hasFreq = Pitch.kr(sig1).flop;
				sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
				sig = SelectX.ar(pitchmix, [sig, sig1]);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
				sig = LPF.ar(sig, \postlpf.kr(17000));
				sig = HPF.ar(sig, \posthpf.kr(17));
				sig = Limiter.ar(sig);
				sig = sig * \wetamp.kr(1);
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		//	sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

		SynthDef(\rdncleandist_light, { arg out=0, gate=1;
			// no Pitch UGen, less cpu heavy
			var sig;
			var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
				var hasFreq, afreq;
				var pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
				var pitchmix = \pitchmix.kr(0.5);

			thisThread.randSeed = 16266;
			thisThread.randSeed = 16262;

				in = LPF.ar(in, \prelpf.kr(17000));
				in = HPF.ar(in, \prehpf.kr(17));
			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
				sig = LPF.ar(sig, \lpf.kr(17000));
				sig = HPF.ar(sig, \hpf.kr(17));
			si = sig;
			sig = { arg si, env;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = [
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);

].mean;
si = (si * 10.rand * \distamp.kr).tanh / 2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
}.value(si, env);

				sig1 = sig.tanh * \fbdistamp.kr(1/2.1);
				sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
				sig = LPF.ar(sig, \postlpf.kr(17000));
				sig = HPF.ar(sig, \posthpf.kr(17));
				sig = Limiter.ar(sig);
				sig = sig * \wetamp.kr(1);
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		//	sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

		SynthDef(\rdncleandist_fulllight, { arg out=0, gate=1;
			// no Pitch UGen, less cpu heavy
			// mix bpf instead of cutting everything
			var sig;
			var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
			var si2;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
				var hasFreq, afreq;
				var pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
				var pitchmix = \pitchmix.kr(0.5);

			thisThread.randSeed = 16266;
			thisThread.randSeed = 16262;

				in = LPF.ar(in, \prelpf.kr(17000));
				in = HPF.ar(in, \prehpf.kr(17));
			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
				sig = LPF.ar(sig, \lpf.kr(17000));
				sig = HPF.ar(sig, \hpf.kr(17));
			si = sig;
			sig = { arg si, env;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
si = [
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
}.value(si, env);

].mean;
si = (si * 10.rand * \distamp.kr).tanh / 2;
si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
si2 = BPF.ar(si, exprand(100,10000) * \bpffac1.kr(1), 0.5.rand* \bprqfac1.kr(1) + 0.01);
si = SelectX.ar(\bpmix.kr(0.5), [si, si2]);
}.value(si, env);

				sig1 = sig.tanh * \fbdistamp.kr(1/2.1);
				sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
				sig = LPF.ar(sig, \postlpf.kr(17000));
				sig = HPF.ar(sig, \posthpf.kr(17));
				sig = Limiter.ar(sig);
				sig = sig * \wetamp.kr(1);
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		//	sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;
		
		Pdef(\partfx).reset;
Pbind(
	'wet10', 1.0,
	'mix', 0.35714285714286,
	'gain', 1.5344889782792,
	'fb', 0.0004799467303085,
	'delay', 0.00090778539919376,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 54.361836201538,
	'pitchlag', 1.0,
	'pitchmix', 0.10924369747899,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 3.0388371966577,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.20503372119697,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 34.16751906158,
)

		
);


(
// simple percudistobass
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pmono( \rdncleandist,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0000110778539919376 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.101000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 155.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.00924369747899,
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
)


(
// more dynamic percudistobass
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pmono( \rdncleandist,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.01001099467303085,
			'delay', 0.0000001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 155.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
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
)


Pdef(\part).clear
(
// added simple chord nappe
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,0,-1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					1,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,0, 0,0,0,  0,0,0, 0,0,1,

					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(
			\instrument, \starlet,
			\note, Pseq([
				[0,4,7],	
				[-1,3,7],	
			],inf).stutter(4)-5,
			\scale, Scale.minor,
			\octave, 6,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,4.8) ],
				],1),
			],inf),
			\legato, 0.2,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pmono( \rdncleandist,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00051099467303085,
			'delay', 0.00100001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.00001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 55.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.00924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
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
)


(
// added fuller chord nappe
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4)-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pmono( \rdncleandist,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.01001099467303085,
			'delay', 0.0010001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 155.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
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
)


(
// fulnap + different fx param
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4)-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pmono( \rdncleandist,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0000401231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.100100543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 55.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
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
		),
				Pmono(\chorusdistlim,
					\inbus, BusDef(\sendbus2, \audio),
					//\out, BusDef(\fx2),
					\fb, 1.4,
					\delay, 0.04 * Pseq([1,1,5],inf),
					\diff, 0.01 * Pseq([100,1,10],inf).stutter(16*4),
					\addAction, \addToTail,
					\distamp, 10,
					\distmix, 1,
					\modamp, 0.010 * Pseq([1,1,1,1,5],inf).stutter(8),
					\modfreq, 1*~t,
					\gain, 0.51,
					\mix, 0.5,
					\dur, 1/4,
				),
	])
)).play;
)


(
// quieter chords
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4)-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,3.1) ],
				],1),
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0100401231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 55.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
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
		),
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.34889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0000401231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.100000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 10.5388371966577,
			'fbdistmix', 0.48176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// quiter nap + different fx
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4)-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,3.1) ],
				],1),
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0100401231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 55.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
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
		),
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.34889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0000401231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.100000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 10.5388371966577,
			'fbdistmix', 0.48176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// less disto + skank
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4)-5,
			\octave, 8,
			\dur, 1/8,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.0105,0.1,1.0,0.01) ],
					[ Env.adsr(0.0105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				0,0, 1,0,
				0,0, 1,1,
				0,0, 1,0,
				0,0, 1,0,
				0,0, 1,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00000099467303085,
			'delay', 0.0000401231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
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
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.34889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0000401231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.100000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 10.5388371966577,
			'fbdistmix', 0.48176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// intro
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ptpar([
			16, Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			8, Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,1,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
			),
			16, Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4)-5,
			\octave, 8,
			\dur, 1/8,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.0105,0.1,1.0,0.01) ],
					[ Env.adsr(0.0105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				0,0, 1,0,
				0,0, 1,1,
				0,0, 1,0,
				0,0, 1,0,
				0,0, 1,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					2,0,0, 2,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00000099467303085,
			'delay', 0.0000401231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
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
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.34889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0000401231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.100000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 10.5388371966577,
			'fbdistmix', 0.48176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// quiet + fastsnare + sequenced double fx
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ptpar([
			0, Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			0, Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,1,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					0,0,1,0,
					1,1,0,1,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
			),
			0, Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4)-5,
			\octave, 8,
			\dur, 1/8,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.0105,0.1,1.0,0.01) ],
					[ Env.adsr(0.0105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 0.1,
			\isRest, Pseq([
				0,0, 1,0,
				0,0, 1,1,
				0,0, 1,0,
				0,0, 1,0,
				0,0, 1,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,1,0, 0,0,0,0, 1,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,1,0, 1,0,1,0, 1,1,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0, 0,0,0,0, 0,1,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0,

					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1, 0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					2,0,0, 2,0,0,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', 0.00000099467303085,
			'delay', 0.0000101231 * Pseq([
				1000,100,10,1,
			],inf).stutter(16*2),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
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
		Pmono( \rdncleandist_light,
			\inbus, BusDef(\sendbus2, \audio, 2),
			'wet10', 1.0,
			'mix', 0.95714285714286,
			'gain', 0.34889782792,
			'fb', 0.00001099467303085,
			'delay', 0.0000401231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.100000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 10.5388371966577,
			'fbdistmix', 0.48176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// quiet + fastsnare + double fx
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4)-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', Pseq([
				~pmodenv.(Pseq([0.00001,0.01],inf), 1),
			],inf),
			'delay', 0.0100001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 155.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 1700,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1/4
			],inf).stutter(8*4),
			\bpmix, ~pmodenv.(Pseq([0,1],inf), 8),
			\bpmix, 0.91,
			\out, BusDef(\mixer7, \audio),
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\out, BusDef(\mixer9, \audio),
			'wet10', 1.0,
			'mix', 0.95714285714286 * Pseq([
				1,1/3,
			],inf).stutter(8),
			'gain', 0.644889782792,
			'fb', 0.00101099467303085,
			'delay', 0.010001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 55.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 17,
			'fbdistamp', 14.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19000,
			'posthpf', 1017,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1.2
			],inf).stutter(8*4),
			\bpmix, ~pmodenv.(Pseq([0,1],inf), 8),
			\bpmix, 0.91,
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// sequenced double fx
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4).collect({ arg xx; var zz = xx.size.rand; xx[zz] = xx[zz]+12; xx  })-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', Pseq([
				~pmodenv.(Pseq([0.00001,0.001],inf), 2),
			],inf),
			'delay', 0.0000001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 1700,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1/4
			],inf).stutter(8*4),
			\bpmix, ~pmodenv.(Pseq([0,1],inf), 8),
			\bpmix, 0.91,
			\out, BusDef(\mixer7, \audio),
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\out, BusDef(\mixer9, \audio),
			'wet10', 1.0,
			'mix', 0.95714285714286 * Pseq([
				1/3,1/3,1/3,1, 1,1,1/3,1,
			],inf).stutter(1),
			'gain', 0.644889782792,
			'fb', 0.00101099467303085,
			'delay', 0.101001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 117,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.78176470588235,
			'postlpf', 19000,
			'posthpf', 1017,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1.9
			],inf).stutter(8*4),
			\bpmix, ~pmodenv.(Pseq([0,1],inf), 8),
			\bpmix, 0.91,
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// automated double fx, more bass
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4).collect({ arg xx; var zz = xx.size.rand; xx[zz] = xx[zz]+12; xx  })-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', Pseq([
				~pmodenv.(Pseq([0.00001,0.001],inf), 2),
			],inf),
			'delay', 0.0000001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 1700,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1/4
			],inf).stutter(8*4),
			\bpmix, ~pmodenv.(Pseq([0,1],inf), 8),
			\out, BusDef(\mixer7, \audio),
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\out, BusDef(\mixer9, \audio),
			'wet10', 1.0,
			'mix', 0.95714285714286 * Pseq([
				1/3,1/3,1/3,1, 1,1,1/3,1,
			],inf).stutter(1),
			'gain', 0.644889782792,
			'fb', 0.00101099467303085,
			'delay', 0.101001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 117,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.78176470588235,
			'postlpf', 19000,
			'posthpf', 1017,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1.9
			],inf).stutter(8*4),
			\bpmix, ~pmodenv.(Pseq([0,1],inf), 8),
			\bpmix, 0.91,
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// automated double fx, more treb
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4).collect({ arg xx; var zz = xx.size.rand; xx[zz] = xx[zz]+12; xx  })-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', Pseq([
				~pmodenv.(Pseq([0.00001,0.001],inf), 2),
			],inf),
			'delay', 0.0000001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 1700,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1/4
			],inf).stutter(8*4),
			\bpmix, Pseq([
				~pmodenv.(Pseq([0,1],1), 1),
			],inf),
			\out, BusDef(\mixer7, \audio),
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\out, BusDef(\mixer9, \audio),
			'wet10', 1.0,
			'mix', 0.95714285714286 * Pseq([
				1/3,1/3,1/3,1, 1,1,1/3,1,
			],inf).stutter(1),
			'gain', 0.644889782792,
			'fb', 0.00101099467303085,
			'delay', 0.101001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 5.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 117,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.78176470588235,
			'postlpf', 19000,
			'posthpf', 1017,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1.9
			],inf).stutter(8*4),
			\bpffac1, Pseq([
				~pmodenv.(Pseq([0.2,2],1), 4),
			],inf),
			\bpmix, ~pmodenv.(Pseq([0,1],inf), 8),
			\bpmix, 0.91,
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// automated double fx, more disto
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,1,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapkick,
				\dur, 1/8,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
				\isRest, true,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4).collect({ arg xx; var zz = xx.size.rand; xx[zz] = xx[zz]+12; xx  })-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,0,  5,0,0, 0,0,0,
					5,0,0, 0,0,0,  0,0,0, 0,0,1,
					1,0,1, 1,0,1,  3,0,0, 1,0,1,
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', Pseq([
				~pmodenv.(Pseq([0.00001,0.001],inf), 2),
			],inf),
			'delay', 0.0000001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 1700,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1/4
			],inf).stutter(8*4),
			\bpmix, Pseq([
				~pmodenv.(Pseq([0,1],1), 1),
			],inf),
			\out, BusDef(\mixer7, \audio),
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\out, BusDef(\mixer9, \audio),
			'wet10', 1.0,
			'mix', 0.95714285714286 * Pseq([
				1/3,1/3,1/3,1, 1,1,1/3,1,
			],inf).stutter(1),
			'gain', 0.644889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0000101001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.001000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 117,
			'fbdistamp', 1.5388371966577,
			'fbdistmix', 0.78176470588235,
			'postlpf', 19000,
			'posthpf', 117,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1.9
			],inf).stutter(8*4),
			\bpffac1, Pseq([
				~pmodenv.(Pseq([0.2,2],1), 4),
			],inf),
			\bpmix, ~pmodenv.(Pseq([0,1],inf), 8),
			\bpmix, 0.91,
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// automated double fx, clochete on track 5
// feedback generated melody when no send on (track2, fx 1)
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4).collect({ arg xx; var zz = xx.size.rand; xx[zz] = xx[zz]+12; xx  })-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pmono( \clochete,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\mixer5, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					Pseq([
						2,0,0, 0,0,0,  0,0,0, 0,0,1,
					],8),
					Pseq([
						8,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],4),
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,1, 0,0,0,0,

					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
					1,0,0,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,1,0,
					0,0,0,0, 0,0,1,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', Pseq([
				~pmodenv.(Pseq([0.00001,0.001],inf), 2),
			],inf),
			'delay', 0.1000001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 1700,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1/4
			],inf).stutter(8*4),
			\bpmix, Pseq([
				~pmodenv.(Pseq([0,1],1), 1),
			],inf),
			\out, BusDef(\mixer7, \audio),
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\out, BusDef(\mixer9, \audio),
			'wet10', 1.0,
			'mix', 0.95714285714286 * Pseq([
				1/3,1/3,1/3,1, 1,1,1/3,1,
			],inf).stutter(1),
			'gain', 0.644889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0000101001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.501000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 117,
			'fbdistamp', 11.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10000,
			'posthpf', 117,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				0.9
			],inf).stutter(8*4),
			\bpmix, 0.01,
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
	])
)).play;
)



(
// automated double fx, clochete on track 5
// mysterious melody with somemore synthdef
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4).collect({ arg xx; var zz = xx.size.rand; xx[zz] = xx[zz]+12; xx  })-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
				\isRest, true,
		),
		Pbind(
			\instrument, \somemore,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			].collect(Pseq(_)),inf).stutter(1)-5,
			\octave, 6,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 0.8,
			\isRest, Pseq([
				1,
			],inf).coin.not,
				\out, BusDef(\mixer4, \audio),
		),
		Pmono( \clochete,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\mixer5, \audio),
		),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/8,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,2,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 300,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					Pseq([
						2,0,0, 0,0,0,  0,0,0, 0,0,1,
					],8),
					Pseq([
						8,0,0, 0,0,0,  0,0,0, 0,0,0,
						0,0,0, 0,0,0,  0,0,0, 0,0,0,
					],4),
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			'fb', Pseq([
				~pmodenv.(Pseq([0.00001,0.001],inf), 2),
			],inf),
			'delay', 0.1000001231 * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 2,0.1000,1,500,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 1700,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1/4
			],inf).stutter(8*4),
			\bpmix, Pseq([
				~pmodenv.(Pseq([0,1],1), 1),
			],inf),
			\out, BusDef(\mixer7, \audio),
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\out, BusDef(\mixer9, \audio),
			'wet10', 1.0,
			'mix', 0.95714285714286 * Pseq([
				1/3,1/3,1/3,1, 1,1,1/3,1,
			],inf).stutter(1),
			'gain', 0.644889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0000101001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.501000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 117,
			'fbdistamp', 11.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10000,
			'posthpf', 117,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				0.9
			],inf).stutter(8*4),
			\bpmix, 0.01,
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
	])
)).play;
)


(
// sendtoarbus2 with automation !
// automated double fx, clochete on track 5
// mysterious melody with somemore synthdef
	~master_simple.();
Pdef(\part, Pdef(\plopfx, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/8,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,1,

					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,1,0, 0,1,0,0,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snaretuned,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/8,
				\amp, 0.051,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.5,
				\dur, 1/16,
				\amp, 0.051,
				\isRest, true,
			),
		]),
		Pbind(
			\instrument, \chordb,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			],inf).stutter(4).collect({ arg xx; var zz = xx.size.rand; xx[zz] = xx[zz]+12; xx  })-5,
			\octave, 8,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 3.8,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
				\out, BusDef(\bus0, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus0, \audio),
				\out, BusDef(\sendbus2, \audio),
				\gain, ~pmodenv.(Pseq([0,0.31,0,0.01],inf), 8),
				\out2, BusDef(\sendbus1, \audio),
				\gain2, ~pmodenv.(Pseq([0,0.21,0,0.01,0],inf), 9),
				\dur, 1,
			),
		Pbind(
			\instrument, \somemore,
			\note, Pseq([
				[0,3,7,9],	
				[1,4,8,11],	
				[0,3,7,10],	
				[1,4,8,13],	
			].collect(Pseq(_)),inf).stutter(1)-5,
			\octave, 6,
			\dur, 1/4,
			\lag, Pseq([
				Ptuple(
					Pwhite(0,0.05,1) / ~t ! 3
				,1),
			],inf),
			\lag, 0,
			\adsr, Pseq([
				Prand([
					[ Env.adsr(0.105,0.1,1.0,0.1) ],
				],1),
			],inf),
			\legato, 0.8,
			\isRest, Pseq([
				1,
			],inf).coin.not,
				\out, BusDef(\bus1, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus1, \audio),
				\out, BusDef(\sendbus2, \audio),
				\gain, ~pmodenv.(Pseq([0,0.41],inf), 3),
				\out2, BusDef(\sendbus1, \audio),
				\gain2, ~pmodenv.(Pseq([0,0.41],inf), 13),
				\dur, 1,
			),
		Pmono( \clochete,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\bus2, \audio),
		),
			Pmono(\sendtoarbus2,
				\inbus, BusDef(\bus1, \audio),
				\out, BusDef(\sendbus2, \audio),
				\gain, ~pmodenv.(Pseq([0,0.41],inf), 10),
				\out2, BusDef(\sendbus1, \audio),
				\gain2, ~pmodenv.(Pseq([0,0.41],inf), 11),
				\dur, 1,
			),
		Pbind(\out, BusDef(\mixer2, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \phyhat3,
				\isRest, Pseq([
					1,0,1,0, 1,0,0,0,
					1,0,1,0, 1,0,1,1,
					1,0,0,0, 1,0,1,0,
					1,1,0,1, 1,0,0,1,
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.1,
				\dur, 1/16,
				\amp, 0.01 * Pseq([1,0.7],inf),
			),
			Pbind(
				\instrument, \phyhat4,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					],4),
					Pseq([
						1,0,1,0, 1,0,1,0, 1,0,1,0, 1,0,1,0,
					],4),
				],inf).coin.not,
				\sustain, 0.05,
				\fac1,0.4,
				\dur, 1/16,
				\amp, 0.01 * Pseq([1,0.7],inf) / 2,
			),
		]),
			Pbind(
				\instrument, \basicbass,
				\chaos, 1.93500,
				\note, Pseq([
					0,1,1,
				],inf).stutter(8)-5,
				\rq, 0.1,
				\trigenv, 0,
				\shift, 1,
				\lpf, 700,
				\octave, 3,
				\modamp, 0.4,
				\legato, Pseq([
					Pseq([
						1,0,0, 0,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,0, 0,0,0,
						1,0,0, 1,0,0,  0,0,0, 1,0,0,
						0,0,0, 1,0,0,  0,0,1, 0,0,1,
						0,0,1, 1,0,0,  0,0,0, 0,0,1,
					],8),
				],inf)*0.8,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				//\out, BusDef(\fx2, \audio),
				\dur, 1/12,
				\amp, 0.1,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \snapkickx,
				\dur, 1/16,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \snapsnare,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\fac1,0.1,
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.101,
			),
		]),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			'wet10', 1.0,
			'mix', 0.35714285714286,
			'gain', 1.0344889782792,
			\fb, 0.00000000001,
			'delay', 0.0010001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.361836201538,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.48176470588235,
			'postlpf', 1700,
			'posthpf', 17,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				1/4
			],inf).stutter(8*4),
			\bpmix, 0,
			\out, BusDef(\mixer7, \audio),
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\out, BusDef(\mixer9, \audio),
			'wet10', 1.0,
			'mix', 0.95714285714286 * Pseq([
				1/3,1/3,1/3,1, 1,1,1/3,1,
			],inf).stutter(1),
			'gain', 0.644889782792,
			'fb', 0.00101099467303085,
			'delay', 0.0000101001231 * Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).stutter(1),
			'delay2', 0.501000543560101,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 15.361836201538,
			'pitchlag', 1.0,
			'pitchmix', 0.50924369747899,
			'prelpf', 19000,
			'prehpf', 17,
			'lpf', 19000,
			'hpf', 117,
			'fbdistamp', 11.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 10000,
			'posthpf', 117,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\bpffac1, Pseq([
				0.9
			],inf).stutter(8*4),
			\bpmix, 0.01,
			//\bprqfac1, 0.1,
			\dur, 1/8,
		),
	])
)).play;
)
