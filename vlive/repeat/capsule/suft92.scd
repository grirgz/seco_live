
// baxter

~t = 212/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\grange, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var amps = [1,1,1,1,1/2];
	freq = freq * [1/2,1,2,1/4,4/5];

	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * ( SinOsc.ar(freq/100) * 1 + 1 )) * 1 + 1 )) * amps;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\grange2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var amps = [1,1,1,1/2,1/2];
	freq = freq * [1/2,1,2,4,4/5];

	sig = LFSaw.ar(freq * ( SinOsc.ar(freq * ( SinOsc.ar(freq/100) * 1 + 1 )) * 1 + 1 )) * amps;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.4)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassron, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	freq = freq * [1/2,1,2];
	sig = LFPulse.ar(freq * [1,1.01]) * [1,1.4,1.4];
	//sig = RLPF.ar(sig, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	//sig = HPF.ar(sig, 40);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "4-CO78-DJD4", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.42038826827877,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.5846456692913,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
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
	'distamp2', 3.9466141732283,
).keep(1));

);

(
~master = {
	ProtoDef(\rdn).play;
};
)

(
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			 \bassron,
			\note, Pseq([
				0,0,1,4,
				0,0,1,4,
				0,0,1,4,
				0,0,4,1,
			],inf),
			\root, -1,
			\octave, 3,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/16,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([801, 74, 21], [0.015, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.1) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 2910,
			\formfreq, 4760,
			\formbw, 8110,
			\lpf, 13140,
			\clickat, 0.001,
			\clickrel, 0.051,
			\clickamp, 0.15,
		
			\distpreamp, 50,
			\distpostamp, 1/2,
		
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \grange,
			\note, Pseq([
				0,2,
				0,2,
				1,3,
				1,3,
			],inf),
			\root, Pseq([
				1
			],inf),
			\octave, 6,
			\dur, 1/4,
			\legato, 0.1,
			//\dur, 1, \legato, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \grange2,
			\note, Pseq([
				0,1,
				0,1,
				0,1,
				0,1,
				2,3,
				2,3,
				2,3,
				2,3,
			],inf),
			\lag, 0.00,
			\root, Pseq([
				-1
			],inf),
			\octave, 5,
			\dur, 1/8 * Pseq([0.7,0.8,0.9,1.6],inf),
			\legato, 0.1,
			//\dur, 1, \legato, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,1,
				0,1,
				0,1,
				0,1,
				2,3,
				2,3,
				2,3,
				2,3,
			],inf),
			\lag, 0.03,
			\root, Pseq([
				-1
			],inf),
			\octave, 5,
			\dur, 1/8 * Pseq([0.8,0.8,0.8,1.6],inf),
			\legato, 0.1,
			//\dur, 1, \legato, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\march, "vipere/march.flac"),
			\pos, 0.13,
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 4,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\speed, Pseq([
				0.5,0.6,
			],inf)+0.961,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\march, "vipere/march.flac"),
			\dur, 2,
			\speed, ~pmodenv.(Pseq([1,1,1,1, 1,1,0.99,1.0],1), 1/4).loop,
			\gain, 1/10,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\march, "vipere/march.flac"),
			\pos, 0.01,
			\dur, 2,
			\speed, ~pmodenv.(Pseq([1,1,1,1, 1,1,1.09,1.0],1), 1/4).loop,
			\gain, 1/10,
		),
		
	])
)).play;
);


//////////////// parts




(
Pdef(\part, Pdef(\bass, 
	Ppar([
		Pmono(
			 \bassron,
			\note, Pseq([
				0,0,1,4,
				0,0,1,4,
				0,0,1,4,
				0,0,4,1,
			],inf),
			\root, -1,
			\octave, 3,
			\dur, 1/2,
			\amp, 0.081,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\cringe, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\march, "vipere/march.flac"),
			\pos, 0.13,
			\dur, 1/8,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 4,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\speed, Pseq([
				0.5,0.6,
			],inf)+0.961,
			\gain, 1/4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\march, "vipere/march.flac"),
			\dur, 2,
			\speed, ~pmodenv.(Pseq([1,1,1,1, 1,1,0.99,1.0],1), 1/4).loop,
			\gain, 1/10,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\march, "vipere/march.flac"),
			\pos, 0.01,
			\dur, 2,
			\speed, ~pmodenv.(Pseq([1,1,1,1, 1,1,1.09,1.0],1), 1/4).loop,
			\gain, 1/10,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\silly, 
	Ppar([
		Pbind(
			\instrument, \grange,
			\note, Pseq([
				0,2,
				0,2,
				1,3,
				1,3,
			],inf),
			\root, Pseq([
				1
			],inf),
			\octave, 6,
			\dur, 1/4,
			\legato, 0.1,
			//\dur, 1, \legato, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \grange2,
			\note, Pseq([
				0,1,
				0,1,
				0,1,
				0,1,
				2,3,
				2,3,
				2,3,
				2,3,
			],inf),
			\lag, 0.00,
			\root, Pseq([
				-1
			],inf),
			\octave, 5,
			\dur, 1/8 * Pseq([0.7,0.8,0.9,1.6],inf),
			\legato, 0.1,
			//\dur, 1, \legato, 1,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,1,
				0,1,
				0,1,
				0,1,
				2,3,
				2,3,
				2,3,
				2,3,
			],inf),
			\lag, 0.03,
			\root, Pseq([
				-1
			],inf),
			\octave, 5,
			\dur, 1/8 * Pseq([0.8,0.8,0.8,1.6],inf),
			\legato, 0.1,
			//\dur, 1, \legato, 1,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums, 
	Ppar([
		
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\bat).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\velamp, 1/3,
			\dur, 1/16,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/16,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 0,0,0,0,
				1,1,0,0, 1,0,0,1,
				Pseq([
					0,0,1,0, 0,0,1,0,
					0,1,0,0, 1,0,1,1,
					0,0,1,0, 0,0,1,0,
					1,0,0, 1,0,0,1,
				],6),
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
	])
)).play;
);

(
Pdef(\part, Pdef(\bigkick, 
	Ppar([
		
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([801, 74, 21], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 2910,
			\formfreq, 4760,
			\formbw, 8110,
			\lpf, 13140,
			\clickat, 0.001,
			\clickrel, 0.051,
			\clickamp, 0.15,
		
			\distpreamp, 10,
			\distpostamp, 1/2,
		
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\lag, 0.04,
			\amp, 0.1/1.2,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\bigkick),
		Pdef(\silly),
		Pdef(\drums),
		Pdef(\cringe),
		Pdef(\bass),
	])
)).play;
);

Pdef(\part).stop

