
// gated reverb

(
SynthDef(\fx_gatedreverbmut1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var gater; 
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	gater = ( Amplitude.kr(in) > \gatelevel.kr(0.1) ).poll;
	gater = LagUD.kr(gater, \gatelagu.kr(0), \gatelagd.kr(0.9));
	sig = SelectX.ar(\mixfbgate.kr(1), [sig, sig*gater]);
	//sig = sig * ( Amplitude.kr(sig) > \gatelevel.kr(0.1) ).poll;
	sig1 = LPF.ar(sig, \lpf.kr(16000));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig1 = HPF.ar(sig, \hpf.kr(40));
	sig = SelectX.ar(\hpmix.kr(0.5), [sig, sig1]);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.6, Rand(0.001,0.06) * \delayfac.kr(1), \decay.kr(3) * gater);
	};
	sig = sig * \prelimitergain.kr(1);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Ndef(\fx_gatedrev, \fx_gatedreverbmut1);
)


(
	// gated reverb
Pdef(\part, Pdef(\petitdrum, 
	Ppar([
		Pbind(\out, BusDef(\fx1))<>
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([

					 [
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
						1,0,1,1, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
					].clump(8).collect({ arg xx; 
						 [
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
						] ++ xx
					})
				].flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
				\isRest, true,
			)),
			Pbind(
				\instrument, \default,
				\sustain, 0.01,
				\freq, Pseq([
					Pwhite(40,15000.0),
				],inf),
				\dur, 1,
				\amp, 0.1,
			\isRest, true,
			),
		]),
		Pmono(\fx_gatedreverbmut1,
			\inbus, BusDef(\fx1, \audio),
			//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
			\gatelevel, 0.10009,
			\gatelag, 0.01,
			\prelimitergain, 4,
			\gain, 0.3,
			\fb, 0.9,
			\lpmix, 0.91,
			\lpf, 10000,
			\delayfac, 1.1,
			\mix, 0.71,
			\decay, 4.39,
			\dur, 1,
			\amp, 0.1,
		),

		
	])
)).play;
)

Ndef(\fx_gatedrev, \fx_gatedreverbmut1).play;
Ndef(\fx_gatedrev, \fx_gatedreverbmut1).edit
Ndef(\fx_gatedrev, \fx_gatedreverbmut1).set(\inbus, BusDef(\fx1, \audio))

(
	// gated reverb
Pdef(\part, Pdef(\petitdrum, 
	Ppar([
		Pbind(\out, BusDef(\fx1))<>
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([

					 [
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
						1,0,1,1, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
					].clump(8).collect({ arg xx; 
						 [
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
						] ++ xx
					})
				].flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(
				\instrument, \default,
				\sustain, 0.01,
				\freq, Pseq([
					Pexprand(40,15000.0),
				],inf),
				\dur, 1,
				\amp, 0.1,
			),
		]),

		
	])
)).play;
)

(
Pdef(\part_ext, Pdef(\plop, 
	Pbind(\out, BusDef(\fx1))<>
	Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([

					 [
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
						1,0,1,1, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
					].clump(8).collect({ arg xx; 
						 [
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
						] ++ xx
					})
				].flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
	])
)).play;
)

(
Pdef(\part_ext, Pdef(\plop, 
	Pbind(\out, BusDef(\fx1))<>
	Ppar([
		
			Pbind(
				\instrument, \default,
				\sustain, 0.1,
				\freq, Pseq([
					Pwhite(40,15000.0),
				],inf),
				\dur, 1,
				\amp, 0.1,
			),
	])
)).play;
)

(
Pdef(\part_ext, Pdef(\plop, 
	Pbind(\out, BusDef(\fx1))<>
	Ppar([
		
			Pbind(
				\instrument, \basicbass,
				\sustain, 0.1,
				\freq, Pseq([
					Pwhite(40,150.0),
				],inf),
				\dur, 1,
				\amp, 0.1,
			),
	])
)).play;
)

(
Pdef(\part_ext, Pdef(\plop, 
	Pbind(\out, BusDef(\fx1))<>
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 4,
			\sustain, 1,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part_ext, Pdef(\plop, 
	Pbind(\out, BusDef(\fx1))<>
	Ppar([
		
		Pbind(
			\instrument, \fmbell2,
			\freq1, 1,
			\adsr, Pseq([
				[
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
				].choose
			],inf),
			\note, Pseq([
				[0,3,7,7-12],
				[0,5,7,5-12],
				[0,4,7,10],
				[0,3,7,10],
			],inf).stutter(16),
			\octave, 6,
			\sustain, Ptuple(Pwhite(0.5,1)!4),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/8,
		),
	])
)).play;
);

(
Pdef(\part_ext2, Pdef(\plop2, 
	Pbind(\out, BusDef(\fx1))<>
	Ppar([
		
		Pbind(
			\instrument, \fmbell,
			\freq1, 1,
			\adsr, Pseq([
				[
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
				].choose
			],inf),
			\note, Pseq([
				[0,3,7,7-12],
				[0,5,7,5-12],
				[0,4,7,10],
				[0,3,7,10],
			],inf).stutter(16),
			\octave, 4,
			\sustain, Ptuple(Pwhite(0.1,1)!4),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/8,
		),
	])
)).play;
)
