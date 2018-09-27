
~t = 124/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\zed, 
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
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.2,
			\dur, 1/8,
		)),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
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
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,1,0,0, 1,0,0,1,
				0,1,1,0, 1,0,0,1,
				0,1,0,0, 1,0,1,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.2,
			\dur, 1/8,
		)),
		Pbind(
			\instrument, \simpleacid,
			\note, Pseq([
				[0,3],
				[0,3],
				[3,7]+12,
				[0,3],
			],inf).stutter(2),
			\isRest, Pseq([
				0,0,1,0, 1,0,1,1,
				0,0,1,0, 1,1,1,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/4,
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
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\amp, 0.1,
			\amp, 0.1/8 * Pseq([
				8,0,0,0, 2,1,0,0, 
				0,0,5,0, 0,0,0,0,
				8,0,0,4, 0,0,0,0, 
				0,0,0,0, 0,1,0,7,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
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
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				0,0,0,0,
				0,1,0,1,
				1,1,0,1,
				1,0,0,1,
				1,1,1,1,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.01) ],
			],inf),
			\velamp, 1/10,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\gain, 0.2,
			\gain, 0.2/8 * Pseq([
				0,1,0,0, 1,0,0,1, 
				5,0,2,1, 0,1,5,1, 
				0,1,1,0, 0,0,0,1, 
				5,0,1,5, 0,1,5,0, 
				0,1,0,1, 1,0,0,1, 
				5,0,0,0, 0,1,5,1, 
				0,1,1,0, 0,0,0,1, 
				5,0,1,5, 0,1,5,0, 
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\gain, 0.2,
			\speed, 0.6,
			\gain, 0.2/8 * Pseq([
				0,0,2,1, 0,1,5,1, 
				0,2,1,0, 2,1,0,0, 
				0,2,0,0, 1,1,0,1, 
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		
	])
)).play;
)

(
SynthDef(\bassamp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, pitch_stretch=1, pos=0, gdur=0.1, gfreq=100, mbufnum=0;
	var sig;
	var clk = Impulse.ar(gfreq);
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	pos = pos + LFNoise1.kr(10,mul:0.1);
	freq = freq * [1,1.001,1.0002,2];
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos + [1,0.3,1.3,0.8] % BufDur.kr(mbufnum), gdur, pan, 1) * [1,1,1,0.1];
	sig.debug("sig");
	sig1 = LFSaw.ar(freq * ( sig * \fmamp.kr(2.9) + 1 )).mean;
	sig.debug("sig");
	sig2 = SinOsc.ar(freq * ( sig * \fmamp.kr(2.9) + 1 )).mean;
	sig = SelectX.ar(\mix.kr(0.2), [sig1, sig2]);
	sig.debug("sig");
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
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\amp, 0.1,
			\amp, 0.1/8 * Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,8,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,8,1, 0,8,0,2,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
		),
		Pbind(
			\instrument, \bassamp,
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\note, Pseq([
				0,3,1,1
			],inf).stutter(4),
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,0,1,0,
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\mix, ~pmodenv.(Pseq([
				1,1,0.5,1,
				1,0.1,1,0,
			],inf), 1/8),
			\pos, 0.9,
			\gdur, 0.02,
			\gfreq, 40,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.1,
			'gain', 1/3,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.2000080,
			'distamp', 1.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
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
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\speed, 1.1,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.31) ],
			],inf),
			\velamp, 1/10,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\gain, 0.2,
			\gain, 0.2/8 * Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,1, 0,1,0,0,
				0,0,0,1, 0,2,1,0,
				8,0,2,0, 0,1,0,0,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\gain, 0.2,
			\speed, 0.9,
			\gain, 0.2/8 * Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\amp, 0.1,
			\amp, 0.1/8 * Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,8,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,8,1, 0,8,0,2,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bassamp,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\note, Pseq([
				0,3,1,1
			],inf).stutter(4),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,8,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,8,1, 0,8,0,2,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\mix, ~pmodenv.(Pseq([
				1,1,0.5,1,
				1,0.1,1,0,
			],inf), 1/8),
			\pos, 1.9,
			\gdur, 0.12,
			\gfreq, 4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.02,
			'gain', 1.5,
			'fb', 0.000010031,
			'delay', 0.00200001,
			'delay2', 0.00000001,
			'delay3', 0.4000080,
			'distamp', 2.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', 0,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \bassamp,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\note, Pseq([
				0,3,1,1
			],inf).stutter(4),
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,0,1,0,
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\mix, ~pmodenv.(Pseq([
				1,1,0.5,1,
				1,0.1,1,0,
			],inf), 1/8),
			\pos, 1.9,
			\gdur, 0.12,
			\gfreq, 4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.1,
			'gain', 1/3,
			'fb', 0.000000031,
			'delay', 0.01000001,
			'delay2', 0.00101001,
			\delay2, ~pmodenv.(Pseq([0.0001,0.2,0.2,0.01,0.001].stutter(2),inf), 1/2),
			'delay3', 0.0000080,
			'distamp', 1.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
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
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\speed, 1.1,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.31) ],
			],inf),
			\velamp, 1/10,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\gain, 0.2,
			\gain, 0.2/8 * Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,1, 0,1,0,0,
				0,0,0,1, 0,2,1,0,
				8,0,2,0, 0,1,0,0,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\gain, 0.2,
			\speed, 0.9,
			\gain, 0.2/8 * Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\amp, 0.1,
			\amp, 0.1/8 * Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,8,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,8,1, 0,8,0,2,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bassamp,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\note, Pseq([
				0,3,1,1
			],inf).stutter(4),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,8,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,8,1, 0,8,0,2,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\mix, ~pmodenv.(Pseq([
				1,1,0.5,1,
				1,0.1,1,0,
			],inf), 1/8),
			\pos, 1.9,
			\gdur, 0.12,
			\gfreq, 4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.02,
			'gain', 1.5,
			'fb', 0.000010031,
			'delay', 0.00200001,
			'delay2', 0.00000001,
			'delay3', 0.4000080,
			'distamp', 4.604,
			'distamp2', 2.23,
			'distamp3', 0.89,
			'shift', 0,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \bassamp,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\note, Pseq([
				0,3,1,1
			],inf).stutter(4),
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,0,1,0,
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\mix, ~pmodenv.(Pseq([
				1,1,0.5,1,
				1,0.1,1,0,
			],inf), 1/8),
			\pos, 1.9,
			\gdur, 0.12,
			\gfreq, 4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.1,
			'gain', 1/3,
			'fb', 0.000000031,
			'delay', 0.01000001,
			'delay2', 0.00101001,
			\delay2, ~pmodenv.(Pseq([
				0.00001, 0.0000001, 0.1001, 0.05001,
				0.00101, 0.0000001, 0.00001, 0.000001,
				0.00001, 0.0101, 0.0001, 0.00001,
				0.00001, 0.0001, 0.2001, 0.00001,
				0.00001, 0.0001, 0.0001, 0.02001,
			].stutter(2),inf), 1/16),
			'delay3', 0.0000080,
			'distamp', 1.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'indelay', 0.04,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,1,1,0,
				0,1,1,0, 0,0,0,1,
				0,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
			],inf),
			\rate, 1,
			\time, 1/16/~t,
			\time, Pstep(Pseq([1/4,1/8,1/16]/2,inf),1/4)/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
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
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\speed, 1.1,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.31) ],
			],inf),
			\velamp, 1/10,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\gain, 0.2,
			\gain, 0.2/8 * Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,1, 0,1,0,0,
				0,0,0,1, 0,2,1,0,
				8,0,2,0, 0,1,0,0,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\gain, 0.2,
			\speed, 0.9,
			\gain, 0.2/8 * Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\amp, 0.1,
			\amp, 0.1/8 * Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,8,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,8,1, 0,8,0,2,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bassamp,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\note, Pseq([
				0,3,1,1
			],inf).stutter(4),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,8,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,2,
				8,0,0,0, 0,0,0,0,
				0,0,8,1, 0,8,0,2,
			],inf)/2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\mix, ~pmodenv.(Pseq([
				1,1,0.5,1,
				1,0.1,1,0,
			],inf), 1/8),
			\pos, 1.9,
			\gdur, 0.12,
			\gfreq, 4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1/4,
			\out, BusDef(\sendbus2, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.02,
			'gain', 1.5,
			'fb', 0.000010031,
			'delay', 0.00200001,
			'delay2', 0.00000001,
			'delay3', 0.4000080,
			'distamp', 4.604,
			'distamp2', 2.23,
			'distamp3', 0.89,
			'shift', 0,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'indelay', 0.04,
		),
		Pbind(
			\instrument, \bassamp,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\note, Pseq([
				0,3,1,1
			],inf).stutter(4),
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,0,1,0,
				4,0,0,0, 0,0,1,0,
				2,0,4,0, 0,1,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\mix, ~pmodenv.(Pseq([
				1,1,0.5,1,
				1,0.1,1,0,
			],inf), 1/8),
			\pos, 1.9,
			\gdur, 0.12,
			\gfreq, 4,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.1,
			'gain', 1/3,
			'fb', 0.000000031,
			'delay', 0.01000001,
			'delay2', 0.00101001,
			\delay2, ~pmodenv.(Pseq([
				0.00001, 0.0000001, 0.1001, 0.05001,
				0.00101, 0.0000001, 0.00001, 0.000001,
				0.00001, 0.0101, 0.0001, 0.00001,
				0.00001, 0.0001, 0.2001, 0.00001,
				0.00001, 0.0001, 0.0001, 0.02001,
			].stutter(2),inf), 1/16),
			'delay3', 0.0000080,
			'distamp', 1.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'indelay', 0.04,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,1,1,1, 0,1,0,1,
			],inf),
			\rate, Pseg(Pseq([0.7,1,2],inf),1.8),
			\time, 1/16/~t,
			\time, Pstep(Pseq([1/4,1/8,1/16]/2,inf),1/4)/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
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
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 8,
			\speed, 1.1,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/4,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.31) ],
			],inf),
			\velamp, 1/10,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 5,
			\gain, 0.2,
			\gain, 0.2/8 * Pseq([
				0,0,0,0, 0,0,0,0,
				8,0,0,1, 0,1,0,0,
				0,0,0,1, 0,2,1,0,
				8,0,2,0, 0,1,0,0,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		PatKitDef(\rim).asPattern(Pbind(
			\kitIndex, 4,
			\gain, 0.2,
			\speed, 0.9,
			\gain, 0.2/8 * Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).collect({ arg x; if(x==0){Rest(0)}{x} }),
			\sustain, 0.1/2,
			\dur, 1/16,
		)),
		
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\stut, \audio),
		),
		Pmono(\fx_stutter,
			\inbus, BusDef(\stut, \audio),
			\addAction, \addToTail,
			\lag, 0.0005,
			\mix, Pseq([
				0,1,1,1, 0,1,0,1,
			],inf),
			\rate, Pseg(Pseq([0.7,1,2],inf),1.8),
			\time, 1/16/~t,
			\time, Pstep(Pseq([1/4,1/8,1/16]/2,inf),1/4)/~t,
			\dur, Pser([1/8],inf),
			\amp, 0.1,
		),
	])
)).play;
)



