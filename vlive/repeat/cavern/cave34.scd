// la bombe
~t = 140/2/60; TempoClock.default.tempo = ~t;
~t = 140/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\hili, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var freqenv;
	freqenv = EnvGen.kr(Env([1,1.02,0.99],[0.1,0.1]), 1, timeScale: \timeScale.kr(1));
	sig = LFSaw.ar(freq * [1.01,1,0.99] * freqenv);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\molbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var freqenv;
	sig = LFPulse.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\niarkbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	var freqenv;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[735].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[395].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.14,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[1242].value,
			\bufnum, ~buflib.hat[1713].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.16,
		),
		NoteTimeline(\himelo).asPattern,
		NoteTimeline(\molbass).asPattern,
		NoteTimeline(\niarkbass).asPattern,
		//Pbind(
			//\instrument, \hili,
			//\note, Pseq([7,7,7,7,6,6,5,4],inf),
			//\octave, 3,
			//\legato, 0.4,
			//\lpfr, 4.5,
			//\dur, 1/2,
			//\amp, 0.1,
		//),
		
	])
)).play;
);

/////////// himelo
(
Pdef(\himelo, 
	Pbind(
		\instrument, \hili,
		\degree, Pseq([0],inf),
		\lpfr, 4.5,
	)
);

NoteTimeline(\himelo, Pdef(\himelo));
NoteTimeline(\himelo).edit

NoteTimeline('himelo').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	(\absTime: 0.125, \amp: 0.1, \clockTime: 544.18938755633, \degree: 0, \dur: 0.125, \instrument: 'hili', \kitIndex: 75, \lpfr: 4.5, \midinote: 76.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.091219266833377, ),
	(\absTime: 0.25, \amp: 0.1, \clockTime: 544.457435047, \degree: 0, \dur: 0.25, \instrument: 'hili', \kitIndex: 70, \lpfr: 4.5, \midinote: 71.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11833051533324, ),
	(\absTime: 0.5, \amp: 0.1, \clockTime: 544.73012688833, \degree: 0, \dur: 0.25, \instrument: 'hili', \kitIndex: 75, \lpfr: 4.5, \midinote: 76.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.10017793916654, ),
	(\absTime: 0.75, \amp: 0.1, \clockTime: 544.99102912083, \degree: 0, \dur: 0.125, \instrument: 'hili', \kitIndex: 70, \lpfr: 4.5, \midinote: 71.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.12721600966665, ),
	(\absTime: 0.875, \dur: 0.375, \midinote: 76.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.25, \amp: 0.1, \clockTime: 544.457435047, \degree: 0, \dur: 0.25, \instrument: 'hili', \kitIndex: 70, \lpfr: 4.5, \midinote: 71.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11833051533324, ),
	(\absTime: 1.5, \amp: 0.1, \clockTime: 544.73012688833, \degree: 0, \dur: 0.25, \instrument: 'hili', \kitIndex: 75, \lpfr: 4.5, \midinote: 76.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.10017793916654, ),
	(\absTime: 1.75, \amp: 0.1, \clockTime: 544.99102912083, \degree: 0, \dur: 0.125, \instrument: 'hili', \kitIndex: 70, \lpfr: 4.5, \midinote: 71.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.12721600966665, ),
	(\absTime: 1.875, \dur: 0.25, \midinote: 76.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 2.125, \amp: 0.1, \clockTime: 544.18938755633, \degree: 0, \dur: 0.125, \instrument: 'hili', \kitIndex: 75, \lpfr: 4.5, \midinote: 76.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.091219266833377, ),
	(\absTime: 2.25, \amp: 0.1, \clockTime: 544.457435047, \degree: 0, \dur: 0.25, \instrument: 'hili', \kitIndex: 70, \lpfr: 4.5, \midinote: 72.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11833051533324, ),
	(\absTime: 2.5, \amp: 0.1, \clockTime: 544.73012688833, \degree: 0, \dur: 0.25, \instrument: 'hili', \kitIndex: 75, \lpfr: 4.5, \midinote: 76.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.10017793916654, ),
	(\absTime: 2.75, \amp: 0.1, \clockTime: 544.99102912083, \degree: 0, \dur: 0.125, \instrument: 'hili', \kitIndex: 70, \lpfr: 4.5, \midinote: 72.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.12721600966665, ),
	(\absTime: 2.875, \dur: 0.375, \midinote: 76.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 3.25, \amp: 0.1, \clockTime: 544.457435047, \degree: 0, \dur: 0.25, \instrument: 'hili', \kitIndex: 70, \lpfr: 4.5, \midinote: 72.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11833051533324, ),
	(\absTime: 3.5, \amp: 0.1, \clockTime: 544.73012688833, \degree: 0, \dur: 0.25, \instrument: 'hili', \kitIndex: 75, \lpfr: 4.5, \midinote: 76.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.10017793916654, ),
	(\absTime: 3.75, \amp: 0.1, \clockTime: 544.99102912083, \degree: 0, \dur: 0.25, \instrument: 'hili', \kitIndex: 70, \lpfr: 4.5, \midinote: 71.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12721600966665, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


/////////// molbass

(
Pdef(\molbass, 
	Pbind(
		\instrument, \molbass,
		\degree, Pseq([0],inf),
		\lpfr, 4.5,
	)
);
);

Pdef(\molbass).asParamGroup.getSetCompileString.editorInsert
(
Pdef('molbass').set('dur', 1.0);
Pdef('molbass').set('legato', 0.8);
Pdef('molbass').set('out', 0);
Pdef('molbass').set('amp', 0.31454886481342);
Pdef('molbass').set('pan', 0.0);
Pdef('molbass').set('spread', 0.80000001192093);
Pdef('molbass').set('freq', 261.6255653006);
Pdef('molbass').set('lpfr', 0.95867680851403);
Pdef('molbass').set('rq', 1.0940659150616);
Pdef('molbass').set('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));

);




NoteTimeline(\molbass, Pdef(\molbass)).edit
NoteTimeline(\molbass).presetCompileString.editorInsert
(
NoteTimeline('molbass').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \amp: 0.31454886481342, \clockTime: 4752.2136661918, \degree: 0, \dur: 0.5, \instrument: 'molbass', \kitIndex: 42, \lpfr: 0.95867680851403, \midinote: 55, \playDur: 0.5, \relDur: 0.5, \rq: 1.0940659150616, \sustain: 0.25, ),
	(\absTime: 0.5, \amp: 0.31454886481342, \clockTime: 4753.1920357343, \degree: 0, \dur: 0.5, \instrument: 'molbass', \kitIndex: 42, \lpfr: 0.95867680851403, \midinote: 55.0, \playDur: 0.5, \relDur: 0.5, \rq: 1.0940659150616, \sustain: 0.25, ),
	(\absTime: 1.0, \amp: 0.31454886481342, \clockTime: 4754.1866476799, \degree: 0, \dur: 0.5, \instrument: 'molbass', \kitIndex: 42, \lpfr: 0.95867680851403, \midinote: 55.0, \playDur: 0.5, \relDur: 0.5, \rq: 1.0940659150616, \sustain: 0.25, ),
	(\absTime: 1.5, \amp: 0.31454886481342, \clockTime: 4755.1785340954, \degree: 0, \dur: 0.5, \instrument: 'molbass', \kitIndex: 42, \lpfr: 0.95867680851403, \midinote: 55.0, \playDur: 0.5, \relDur: 0.5, \rq: 1.0940659150616, \sustain: 0.25, ),
	(\absTime: 2.0, \amp: 0.31454886481342, \clockTime: 4756.9023657359, \degree: 0, \dur: 0.5, \instrument: 'molbass', \kitIndex: 41, \lpfr: 0.95867680851403, \midinote: 54.0, \playDur: 0.5, \relDur: 0.5, \rq: 1.0940659150616, \sustain: 0.25, ),
	(\absTime: 2.5, \amp: 0.31454886481342, \clockTime: 4757.8753944066, \degree: 0, \dur: 0.5, \instrument: 'molbass', \kitIndex: 41, \lpfr: 0.95867680851403, \midinote: 54.0, \playDur: 0.5, \relDur: 0.5, \rq: 1.0940659150616, \sustain: 0.375, ),
	(\absTime: 3.0, \amp: 0.31454886481342, \clockTime: 4758.8708445358, \degree: 0, \dur: 0.5, \instrument: 'molbass', \kitIndex: 40, \lpfr: 0.95867680851403, \midinote: 53.0, \playDur: 0.5, \relDur: 0.5, \rq: 1.0940659150616, \sustain: 0.25, ),
	(\absTime: 3.5, \amp: 0.31454886481342, \clockTime: 4759.8096385809, \degree: 0, \dur: 0.5, \instrument: 'molbass', \kitIndex: 39, \lpfr: 0.95867680851403, \midinote: 52.0, \playDur: 0.5, \relDur: 0.5, \rq: 1.0940659150616, \sustain: 0.25, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

/////////// niarkbass

(
Pdef(\niarkbass, 
	Pbind(
		\instrument, \niarkbass,
		\degree, Pseq([0],inf),
		\lpfr, 16,
	)
);
);
NoteTimeline(\niarkbass, Pdef(\niarkbass)).edit
NoteTimeline(\niarkbass).presetCompileString.editorInsert
(
NoteTimeline('niarkbass').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \clockTime: 3559.6120197247, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 39, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21019444366675, ),
	(\absTime: 0.25, \clockTime: 3559.8918360155, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 46.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17960310550006, ),
	(\absTime: 0.5, \clockTime: 3560.150195764, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 39.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.2388941881668, ),
	(\absTime: 0.75, \clockTime: 3560.4225308072, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 46.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15705920883329, ),
	(\absTime: 1.0, \clockTime: 3560.7006622155, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 39.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22550701483351, ),
	(\absTime: 1.25, \clockTime: 3560.9426984038, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 46.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17858718033312, ),
	(\absTime: 1.5, \clockTime: 3561.195390964, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 39.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.27083925750048, ),
	(\absTime: 1.75, \clockTime: 3561.4551996635, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 46.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20329748366657, ),
	(\absTime: 2.0, \clockTime: 3561.709059021, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 39.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.26800743433296, ),
	(\absTime: 2.25, \clockTime: 3561.9808312152, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 46.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16338259700024, ),
	(\absTime: 2.5, \clockTime: 3562.2408866705, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 39.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21741236766638, ),
	(\absTime: 2.75, \clockTime: 3562.4819607987, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 46.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.18680625716661, ),
	(\absTime: 3.0, \clockTime: 3562.7285139668, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 39.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.25, \clockTime: 3563.0017717978, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 46.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.5, \clockTime: 3563.2888947143, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 39.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19062085583346, ),
	(\absTime: 3.75, \dur: 0.25, \midinote: 46.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.0, \clockTime: 3559.6120197247, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 35, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21019444366675, ),
	(\absTime: 4.25, \clockTime: 3559.8918360155, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 42.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17960310550006, ),
	(\absTime: 4.5, \clockTime: 3560.150195764, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 35.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.2388941881668, ),
	(\absTime: 4.75, \clockTime: 3560.4225308072, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 42.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15705920883329, ),
	(\absTime: 5.0, \clockTime: 3560.7006622155, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 35.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.22550701483351, ),
	(\absTime: 5.25, \clockTime: 3560.9426984038, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 42.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17858718033312, ),
	(\absTime: 5.5, \clockTime: 3561.195390964, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 35.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.27083925750048, ),
	(\absTime: 5.75, \clockTime: 3561.4551996635, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 42.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.20329748366657, ),
	(\absTime: 6.0, \clockTime: 3561.709059021, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 34.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.26800743433296, ),
	(\absTime: 6.25, \clockTime: 3561.9808312152, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 41.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16338259700024, ),
	(\absTime: 6.5, \clockTime: 3562.2408866705, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 34.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21741236766638, ),
	(\absTime: 6.75, \clockTime: 3562.4819607987, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 41.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.18680625716661, ),
	(\absTime: 7.0, \clockTime: 3562.7285139668, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 34.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.25, \clockTime: 3563.0017717978, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 46, \lpfr: 4.5, \midinote: 41.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 7.5, \clockTime: 3563.2888947143, \degree: 0, \dur: 0.25, \instrument: 'niarkbass', \kitIndex: 39, \lpfr: 4.5, \midinote: 34.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.19062085583346, ),
	(\absTime: 7.75, \dur: 0.25, \midinote: 41.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


///////////////////////////////// draft



(
Pdef(\piano, 
	Pbind(
		\instrument, \hili,
		\degree, Pseq([0],inf),
		\lpfr, 4.5,
	)
);
);
Pdef(\piano).stop

ProtoDef(\piano).startControl(Pdef(\piano))



(
Pdef(\bass, 
	Pbind(
		\instrument, \hili,
		\note, Pseq([7,7,7,7,6,6,5,4],inf),
		\octave, 3,
		\lpfr, 4.5,
		\dur, 1/2,
		\amp, 0.1,
	)
).play;
);


(
Pdef(\hili1, 
	Pbind(
		\instrument, \hili,
		\note, Pseq([
			3,\r,\r,-2,\r,\r,
			3,\r,\r,-2,\r,-2,
		],inf),
		\octave, 5,
		\lpfr, 4,
		\dur, 1/4/3,
		\amp, 0.1,
	)
).play;
);

NoteTimeline(\bla, Pdef(\piano)).edit
NoteTimeline(\bla).eventList.print
NoteTimeline(\bla).play
NoteTimeline(\bla).asPattern.asStream.nextN(10,()).do(_.postln)
NoteTimeline(\bla).presetCompileString.editorInsert


Pseq(NoteTimeline(\bla).eventList).play

MIDIdef.trace(false)

controller = SimpleController(param.controllerTarget);
FileSystemProject.load("libdef/controllers.scd")


NoteTimeline(\bli).edit
NoteTimeline(\bla).eventList.post



TrackDef(\himelo, TrackTemplateDef(\NoteTimelineTrack))
TrackDef(\himelo).edit


WindowDef(\trackcolumn, (
	parent: WindowDef(\customgrid).proto,

))

s.volume.gui

{ SinOsc.ar(500) ! 2 * 0.1}.play;
s.volume.volume = -1

(
TempoClock.sched(0, {
	{

	s.volume.volume = -3
	}.defer
	
})
)
