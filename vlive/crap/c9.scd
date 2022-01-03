// simple cross-FM, inspired by Joker Nies
(
Ndef(\xfm, { arg freqA = 32, freqB = 9, modAtoB=540, modBtoA=240;
	var fbIn = LocalIn.ar(2);
	var sigs = SinOsc.ar([freqA, freqB] + (fbIn.reverse * [modBtoA, modAtoB]));
	LocalOut.ar(sigs);
	sigs * \amp.kr(0.1);
}).play;

Spec.add(\freqA, [1, 10000, \exp]);
Spec.add(\freqB, [1, 10000, \exp]);
Spec.add(\modBtoA, [0, 1000, 5]);
Spec.add(\modAtoB, [0, 1000, 5]);

Ndef(\xfm).gui;
);

// some chaotic presets that display roughness, instabilities, or
Ndef('xfm').set('freqA', 9.0, 'freqB', 40.0, 'modAtoB', 205,  'modBtoA', 243.64);
Ndef('xfm').set('freqA', 5, 'freqB', 40.0, 'modAtoB', 90.0, 'modBtoA', 155); // try riding the modBtoA slider just slightly with the arrow buttons > find completely different states; hysteresis when returning. Pitch may move in reverse.
Ndef('xfm').set('freqA', 14, 'freqB', 6.69, 'modAtoB', 151, 'modBtoA', 402);

Ndef('xfm').set('freqA', 5, 'freqB', 40.0, 'modAtoB', 90.0, 'modBtoA', 204); // chaotic oscillation between several states

// settling after a short while - press 'send' on the GUI to restart process deterministically
Ndef('xfm').set('freqA', 5.0, 'freqB', 6.36, 'modAtoB', 342.65, 'modBtoA', 448.48);
Ndef('xfm').set('freqA', 223.46, 'freqB', 6.69, 'modAtoB', 70.57, 'modBtoA', 726.15);
Ndef('xfm').set('freqA', 18, 'freqB', 40.0, 'modAtoB', 90.0, 'modBtoA', 172.0);

// ideas to extend:
// - add sample-and-hold
// - more than 2 operators in circle feedback topology

///////////

(
Ndef(\xfm, { arg freq1_E = 1, freq1_M = 3.2, freq2_E = 1, freq2_M = 0.9,
	mod1_E = 2, mod1_M = 5.4, mod2_E = 2, mod2_M = 2.4, amp = 0.1;

	var freq1 = 10 ** freq1_E * freq1_M.lag(0.2);
	var freq2 = 10 ** freq2_E * freq2_M.lag(0.2);
	var mod1 = 10 ** mod1_E * mod1_M.lag(0.2);
	var mod2 = 10 ** mod2_E * mod2_M.lag(0.2);

	var fbIn = LocalIn.ar(2);
	var sigs = SinOsc.ar([freq1, freq2] + (fbIn.reverse * [mod2, mod1]));

	LocalOut.ar(sigs);
	sigs * amp.lag(0.2);
}).play;

Spec.add(\freq1_E, [-1, 2, \lin, 1, 1]);
Spec.add(\freq2_E, [-1, 2, \lin, 1, 1]);

Spec.add(\freq1_M, [0.1, 10, 2, 0, 1]);
Spec.add(\freq2_M, [0.1, 10, 2, 0, 1]);

Spec.add(\mod1_E, [-1, 2, \lin, 1, 1]);
Spec.add(\mod2_E, [-1, 2, \lin, 1, 1]);

Spec.add(\mod1_M, [0.1, 10, 2, 0, 1]);
Spec.add(\mod2_M, [0.1, 10, 2, 0, 1]);

Spec.add(\amp, [0, 0.5, \lin, 0, 0.1]);

Ndef(\xfm).gui;
);

(
Ndef(\xfm, { arg freq1_E = 1, freq1_M = 3.2, freq2_E = 1, freq2_M = 0.9,
	mod1_E = 2, mod1_M = 5.4, mod2_E = 2, mod2_M = 2.4, amp = 0.1;

	var freq1 = 10 ** freq1_E * freq1_M.lag(0.2);
	var freq2 = 10 ** freq2_E * freq2_M.lag(0.2);
	var mod1 = 10 ** mod1_E * mod1_M.lag(0.2);
	var mod2 = 10 ** mod2_E * mod2_M.lag(0.2);

	var fbIn = LocalIn.ar(2);
	var sigs = SinOsc.ar([freq1, freq2] + (fbIn.reverse * [mod2, mod1]) * \gmodfreq.kr(1));

	LocalOut.ar(sigs);
	sigs * amp.lag(0.2);
}).play;

Spec.add(\freq1_E, [-1, 2, \lin, 1, 1]);
Spec.add(\freq2_E, [-1, 2, \lin, 1, 1]);

Spec.add(\freq1_M, [0.1, 10, 2, 0, 1]);
Spec.add(\freq2_M, [0.1, 10, 2, 0, 1]);

Spec.add(\mod1_E, [-1, 2, \lin, 1, 1]);
Spec.add(\mod2_E, [-1, 2, \lin, 1, 1]);

Spec.add(\mod1_M, [0.1, 10, 2, 0, 1]);
Spec.add(\mod2_M, [0.1, 10, 2, 0, 1]);

Spec.add(\amp, [0, 0.5, \lin, 0, 0.1]);

Ndef(\xfm).gui;
);

(
Ndef(\xfm)[10] = \pset -> Pbind(
	\gmodfreq, Pseq([0,4,7,4]+(4*12),inf).midiratio,
	\dur, 1/2,
)
)
Ndef(\xfm).quant = 4

Pdef(\zed).quant = 4
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,4,7,4],inf),
		\dur, 1/2,
		\amp, 0.1,
	)
).play;
);


(
Ndef(\crossfeedback, {
    var freq = MouseY.kr(20, 4000, 1);
    var mratio = MouseX.kr(1/8, 8, 1);
    var in = LocalIn.ar(2);
    var mod = SinOsc.ar(freq * mratio) * freq * mratio * \index.kr(5);
    var car = SinOsc.ar([freq * mod * in[1], freq + mod + in[0]]);
    LocalOut.ar(car * \fb.kr([10, 5]));
    car = LeakDC.ar(Mix(car));
    car = Pan2.ar(car, \pan.kr(0), \amp.kr(0.3));
	car = car * \gain.kr(1/4);
}).play;
)
Ndef(\crossfeedback).edit

480/60
