{ [ Saw.ar(100), LFSaw.ar(100), LeakDC.ar(Saw.ar(100)) ] }.plot(0.1)
{ [ Pulse.ar(100), LFPulse.ar(100), LeakDC.ar(Pulse.ar(100)) ] }.plot(0.1)

(
Ndef(\zed, { arg freq=1200, pan=0, amp=0.1;
	var sig;
	var tab = {
		LFNoise1.kr(0.01!8) * 0.005 + 1;
	};
	sig = SinOsc.ar(freq * tab.()) * BPF.ar(LFSaw.ar(freq * tab.()), freq * tab.());
	pan = pan * tab.();
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
SynthDef(\noisetab, { arg out=0,gate=1, freq=1200, pan=0, amp=0.1;
	var sig;
	var tab = {
		var xi;
		xi = LFNoise1.kr(0.01!8) * 0.0005 + 1;
		xi = LFNoise1.kr(0.1!8) * 0.0001 + 1 * xi;
		xi = LFNoise1.kr(0.001!8) * 0.0008 + 1 * xi;
		xi;
	};
	sig = SinOsc.ar(freq * tab.()) * BPF.ar(LFSaw.ar(freq * tab.()), freq * tab.());
	pan = pan * tab.();
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \noisetab,
			\note, Pseq([
				0,4,8,1,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono( \noisetab,
			\note, Pseq([
				0,4,8,1,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
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
	])
)).play;
)

//////////////////////


(
SynthDef(\noisetab2, { arg out=0,gate=1, freq=1200, pan=0, amp=0.1;
	var sig;
	var tab = {
		var xi;
		xi = LFNoise1.kr(0.01!8) * 0.0005 + 1;
		xi = LFNoise1.kr(0.1!8) * 0.0001 + 1 * xi;
		xi = LFNoise1.kr(0.001!8) * 0.0008 + 1 * xi;
		xi;
	};
	sig = SinOsc.ar(freq * tab.()) * BPF.ar(LFSaw.ar(freq * tab.()), freq * tab.());
	pan = pan * tab.();
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono( \noisetab2,
			\note, Pseq([
				0,1,1,1,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(\instrument, \noisetab2,
			\note, Pseq([
				0,1,1,1,
			],inf),
			\octave, 4,
			\sustain, 0.01,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(\instrument, \noisetab2,
			\note, Pseq([
				0,1,13,1,
			],inf).stutter(2),
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,1,0,1,0,
			],inf).coin.not,
			\octave, 5,
			\sustain, 0.01,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono(\rdnroom,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 2,
			//'gain', ~pmodenv.(Pseq([1,1/2,2,0.04,2,2] * 0.4,inf), 8),
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.03101001,
			'delay3', 0.0100080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\addAction, \addToTail,
			\lag, 0.0007,
			\inbus, BusDef(\hpf, \audio),
			\hpf, 1000,
			\dur, 1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2/4,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
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
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\gain, 0.2/4,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \noisetab2,
			\note, Pseq([
				0,1,1,1,
			],inf),
			\octave, 6,
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/5,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.1344889782792,
			'fb', 0.00020099467303085 * Pseq([
				10,1,20,
			],inf),
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'delay2', ~pmodenv.(Prand([1,2,1,4]/10,inf), 1),
			'distamp', 5.361836201538,
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
			\instrument, \phyhat3,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0, 1,0, 0,0, 1,0,
				0,0, 1,0, 0,0, 1,0,
				1,0, 1,0, 1,0, 1,0,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\instrument, \noisetab2,
			\note, Pseq([
				0,1,1,1,
			],inf),
			\legato, Pseq([
				1,0,4,0, 0,0,0,0,
				1,0,4,0, 0,0,0,1/4,
				1,0,4,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1/4,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\bass, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\bass, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.1001080,
			'distamp', 3.604,
			'distamp2', 0.23,
			'distamp3', 3.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pbind(\instrument, \noisetab2,
			\note, Pseq([
				0,1,13,1,
			],inf).stutter(2),
			\isRest, Pseq([
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,1,0,1,0,
			],inf).coin.not,
			\octave, 5,
			\sustain, 0.01,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.01,
			'gain', 2,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.00001001,
			'delay3', 0.0000080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono(\rdnroom,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 1,
			'gain', 2,
			//'gain', ~pmodenv.(Pseq([1,1/2,2,0.04,2,2] * 0.4,inf), 8),
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.03101001,
			'delay3', 0.0100080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
			\out, BusDef(\hpf, \audio),
		),
		Pmono(\fx_hpf,
			\addAction, \addToTail,
			\lag, 0.0007,
			\inbus, BusDef(\hpf, \audio),
			\hpf, 1000,
			\dur, 1,
		),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2/4,
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus2, \audio, 2),
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
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\gain, 0.2/4,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
		)),
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \noisetab2,
			\note, Pseq([
				0,1,1,1,
			],inf),
			\octave, 6,
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/5,
			\out, BusDef(\sendbus3, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus3, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.1344889782792,
			'fb', 0.00020099467303085 * Pseq([
				10,1,20,
			],inf),
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'delay2', ~pmodenv.(Prand([1,2,1,4]/10,inf), 1),
			'distamp', 5.361836201538,
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
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 0,0, 1,0, 0,0,
				1,0, 0,0, 1,0, 0,1,
				1,0, 0,0, 1,0, 0,1,
				1,1, 1,1, 1,1, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
)
