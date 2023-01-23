
KitTimeline(\sun2).edit
KitTimeline(\sun2).presetCompileString.editorInsert
KitTimeline(\sun2).kit
KitTimeline(\sun2).
NoteTimeline(\sun2).edit
NoteTimeline(\sun2).presetCompileString.editorInsert
NoteTimeline(\sun2).param.target.presetCompileString
PlayerWrapper(Pbindef(\NoteTimeline_default)).asSetCompileString

NoteTimeline(\sun2).param = Pbindef(\sunbass)
Pbindef(\sunbass).asParamGroup.getPbindCompileString
Pbindef(\sunbass).presetCompileString
(
Pbindef('sunbass',
	'instrument', 'sunbass',
	'lpfr', 3,
	'noisedelta', 0.019629236833786,
	'fma', 0.0044210768194263,
	'rq', '0.1',
	'lpfnoisedelta', 165.37981332121,
	'lpnoisedelta', 12.54077492058,
	'lpnoisefreq', 0.1,
	'fmnoisefreq', 39.381833831564,
	'fnoisefreq', 0.1,
);
)

Pbindef(\sunbass).edit


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		KitTimeline(\sun2).asPattern,
		NoteTimeline(\sun2).asPattern,
	])
)).play;
);

(
NoteTimeline('sun2').param = Param(Pdef('NoteTimeline_default'), 'midinote');
NoteTimeline('sun2').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.5, \midinote: 33.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.25, \midinote: 36.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.5, \midinote: 33.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 1.25, \dur: 0.25, \midinote: 37.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.375, \midinote: 34.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 1.875, \dur: 0.125, \midinote: 20.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 2.0, \dur: 0.5, \midinote: 33.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
	(\absTime: 2.5, \dur: 0.25, \midinote: 36.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.75, \dur: 0.375, \midinote: 33.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 3.125, \dur: 0.125, \midinote: 30.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 3.25, \dur: 0.375, \midinote: 27.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 3.625, \dur: 0.25, \midinote: 24.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.875, \dur: 0.125, \midinote: 20.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

(
KitTimeline('sun2').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 0.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.125, \kitIndex: 8.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.875, \dur: 0.125, \kitIndex: 5.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.0, \kitIndex: 4.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 1.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 2.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 2.25, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 2.25, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 2.25, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 2.5, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 2.75, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.0, \kitIndex: 4.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 3.25, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 3.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.5, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 3.75, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 3.75, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 3.75, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 4.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 4.0, \dur: 0.125, \kitIndex: 8.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 4.125, \dur: 0.125, \kitIndex: 5.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 4.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.5, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 4.5, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 4.75, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 4.75, \dur: 0.125, \kitIndex: 8.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 4.875, \dur: 0.125, \kitIndex: 5.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 5.0, \dur: 0.0, \kitIndex: 4.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 5.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 5.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 5.5, \dur: 0.25, \kitIndex: 5.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 5.75, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 5.75, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 6.0, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 6.0, \dur: 0.125, \kitIndex: 8.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 6.125, \dur: 0.125, \kitIndex: 5.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 6.25, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 6.25, \dur: 0.0, \kitIndex: 0.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 6.25, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 6.5, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 6.75, \dur: 0.125, \kitIndex: 12.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 6.875, \dur: 0.125, \kitIndex: 5.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.0, \kitIndex: 4.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 7.0, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 7.25, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 7.25, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.5, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 7.75, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 7.75, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
Ndef(\sunbass, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * LFNoise1.kr(1/2!8).range(0.999,1.0) * ( SinOsc.ar( LFNoise1.kr(1/2!8).range(0.1,100.0) ) * 0.1 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * LFNoise1.kr(1/2!8).range(1.0,4.0), \rq.kr(0.5));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\sunbass, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * LFNoise1.kr(\fnoisefreq.kr(1/2)!8).range(1.0, 1 + \noisedelta.kr(0.001)) * ( SinOsc.ar( LFNoise1.kr(\fmnoisefreq.kr(1/2)!8).range(0.1,100.0) ) * \fma.kr(0.1) + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * LFNoise1.kr(\lpnoisefreq.kr(1/2)!8).range(1.0,1 + \lpnoisedelta.kr(3)) ).clip(1,20000), \rq.kr(0.5));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
	//sig = Pan2.ar(sig, pan, amp);
}).add;
);

(
SynthDef(\sunbass, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * LFNoise1.kr(\fnoisefreq.kr(1/2)!8).range(1.0, 1 + \noisedelta.kr(0.001)) * ( SinOsc.ar( LFNoise1.kr(\fmnoisefreq.kr(1/2)!8).range(0.1,100.0) ) * \fma.kr(0.1) + 1 ));
	sig = sig + SinOsc.ar(freq * \sinfreqfac.kr(1));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * LFNoise1.kr(\lpnoisefreq.kr(1/2)!8).range(1.0,1 + \lpnoisedelta.kr(3)) ).clip(1,20000), \rq.kr(0.5));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
	//sig = Pan2.ar(sig, pan, amp);
}).add;
);

(
SynthDef(\gregrainrand_pan, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, mbufnum, pitch_stretch=1, pos=0, gdur=0.1;
	var sig, clk;
	var randpos;
	randpos = LFNoise1.kr(\randfreq.kr(1)).range(0.0,1.0) * \randfac.kr(0.05);
	clk = Impulse.ar(freq * \trigfreqfac.kr(1));
	pan = Dseq([1,0.4,-1,0.1,-0.9],inf);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos + randpos % BufDur.kr(mbufnum), gdur, pan, 1, 4);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Ndef(\sunbass).quant = 4
(
	Ndef(\sunbass).put(1, \pset -> Pbind(
		\note, Pseq([
			3,0,2,2
		],inf),
		\octave, 4,
		\dur, 1,
	));
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.81,1.5
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0,1, 1,1,0,1,
				0,0,0,1, 1,1,1,1,
				1,1,0,1, 0,1,1,1,
				0,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
		),
		Pdef(\sunbass,
			Pbind(
				\instrument, \sunbass,
				\note, Pseq([
					-5,
				],inf),
				\lpfr, ~pmodenv.(Pseq([0.5,Pwhite(2.0,40,1),1],1), Pseq([0.05,3],1)).loop,
				\sinfreqfac, ~pmodenv.(Pseq([0.5,1,0.7],1), Pseq([0.05,3],1)).loop,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\octave, 3,
				\dur, 4,
				\amp, 0.1/2,
			),
		)
		
	])
)).play;
);
~pmodenv

Pdef(\sunbass).edit


////////////////

(
Ndef(\sundrone, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(rrand(40,140) * \ffac.kr(1) * ( SinOsc.ar(rrand(40,140) * \fmffac.kr(1)) * \fma.kr(1) + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

WindowDef(\NdefEditor).edit(\sundrone)


(
SynthDef(\sunfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(40)) * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sunfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 4;
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(40)) * \fma.kr(1) + 1 ));
	num.do { arg x;
		sig = sig + ( SinOsc.ar(freq * (1/(x+1)) * ( SinOsc.ar(\fmf.kr * ( x+1 )) * \fma.kr + 1 )) * (1/(x+1)) );
	} / num;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sunfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var num = 4;
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(40)) * \fma.kr(1) + 1 ));
	num.do { arg x;
		sig = sig + ( SinOsc.ar(freq * (1/(x+1)) * ( SinOsc.ar(\fmf.kr * ( x+1 )) * \fma.kr + 1 )) * (1/(x+1)) );
	} / num;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sunfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * [1,1.01] * ( SinOsc.ar(\fmf.kr(40)) * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sunfm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(40) + [SinOsc.ar(freq+1).range(1,100), SinOsc.ar(freq).range(1,1000)]) * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sunfm,
			\freq, Pwhite(40,140),
			//\freq, Pseq([74,48],inf),
			//\note, Pseq([
				//0,10,
			//],inf),
			\octave, 3,
			\fmf, Pwhite(40,140),
			\legato, 1,
			\dur, 4,
			\amp, 0.1,
		).trace,
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
//( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  //'amp': 0.1, 'freq': 124, 'fmf': 104 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 49, 'fmf': 98 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 113, 'fmf': 41 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 112, 'fmf': 61 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 55, 'fmf': 122 ),

		],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \sunfm,
			\freq, Pwhite(40,140),
			\freq, Pseq([74,48],inf),
			//\note, Pseq([
				//0,10,
			//],inf),
			\octave, 3,
			\fmf, Pwhite(40,140),
			\fmf, Pseq([
				77,53,
			],inf),
			\legato, 1,
			\dur, 4,
			\amp, 0.1,
		).trace,
		
	])
)).play;
);


////

(
SynthDef(\sunfmvib, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(\fmf.kr(40) + [SinOsc.ar(freq+1).range(1,100), SinOsc.ar(freq).range(1,1000)]) * \fma.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * LFPulse.ar(\vibf.kr(1)).lag( ( 1/\vibf.kr ) * \viblagfac.kr(0.01)).range(0,1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pspawner({ arg sp;
			var fac=1;
			loop {
				sp.par(
					Pbind(
						\instrument, \sunfmvib,
						\freq, Pseq([
							rrand(40,140)*fac,
							rrand(40,140)*fac,
						],inf),
						//\freq, Pseq([74,48],inf),
						//\note, Pseq([
						//0,10,
						//],inf),
						\vibf, fac,
						\octave, 3,
						\fmf, Pseq([
							rrand(40,140)*fac,
							rrand(40,140)*fac,
						],inf),
						\isRest, Prand([
							Pser([0],2*( fac-1 )),
							Pser([1],2),
						].scramble,inf).coin.not,
						\legato, 1,
						\dur, ( (1..16).reciprocal * 4 ).wrapAt(fac),
						\amp, 0.1,
					),
				);
				fac= fac+1;
				4.wait;
			}
	   
		})
		
	])
)).play;
);

///////
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( \out, BusDef(\sendbus1, \audio), ) <>
		Pseq([
//( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  //'amp': 0.1, 'freq': 124, 'fmf': 104 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 49, 'fmf': 98 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 113, 'fmf': 41 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 112, 'fmf': 61 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 55, 'fmf': 122 ),

		],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.81,1.5
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0,1, 1,1,0,1,
				0,0,0,1, 1,1,1,1,
				1,1,0,1, 0,1,1,1,
				0,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
		),
		Pbind( \out, BusDef(\sendbus1, \audio), ) <>
		Pseq([
//( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  //'amp': 0.1, 'freq': 124, 'fmf': 104 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 113, 'fmf': 41 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 112, 'fmf': 61 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 55, 'fmf': 122 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 49, 'fmf': 98 ),

		],inf),
		Pmono(
			 \gregrainrand_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			//\pos, 4.0983836717573,
			\pos, ~pmodenv.(1 + Pseq([0,5,10]/398,1) + Pwhite(0,0.02,inf).stutter(8), Prand([1,2,4],inf)).loop,
			\randfac, 0.0001,
			\randfreq, 8,
			\gdur, 0.1/8,
			\freq, Pstep(Pseq([
				113,112,55,49,
			],inf), 4) * Pseq([
				0,0,0,0, 0,3,9,0,
				0,0,0,0, 0,9,12,0,
			],inf).midiratio * Prand([2,3,4,5],inf).stutter(4*4*2),
			\pitch_stretch, 1/2,
			\trigfreqfac, 1,
			\legato, 1,
			\dur, 1/4,
			\amp, 0.8,
			\lag, 0.04,
		)
		
	])
)).play;
);

BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");

Log(\Param).level = \warning
NoteTimeline(\sun2melo2, Pdef(\sun2melo2))
NoteTimeline(\sun2melo2, Pdef(\sun2melo2)).edit
(
Pdef(\sun2melo2, 
	Pbind(
		\instrument, \gregrainrand_pan,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono(\amen),
			//\pos, 4.0983836717573,
			\pos, ~pmodenv.(2 + Pseq([0,5,10]/198,1) + Pwhite(0,0.02,inf).stutter(8), Prand([1,2,4],inf)).loop,
			//\pos, 2,
			\randfac, 0.0001,
			\randfreq, 8,
			\gdur, 0.1/8,
			\note, Pseq([

				Prand([0,3,7,0,Prand((0..12),1)]),
			],inf),
			\pitch_stretch, 1/2,
			\trigfreqfac, 1*2,
			\octave, 5,
			\legato, 1,
			\dur, 1,
			\amp, 0.2,
	)
);
);




(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,1,1,0, 0,1,0,1,
				0,0,0,1, 0,0,1,0,
				0,1,0,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,1,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,1, 0,1,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 0.2,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.81,1.5
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.4,0.4,Prand([0.2,0.4,2],1),0.4,
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,1,0,0, 1,0,0,1,
				0,0,1,0, 1,0,0,1,
				0,0,1,1, 0,0,1,1,

				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,0,1, 0,1,1,0,
				1,0,0,0, 1,1,0,0,
				1,0,0,1, 1,0,1,1,
				0,1,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0,1, 1,1,0,1,
				0,0,0,1, 1,1,1,1,
				1,1,0,1, 0,1,1,1,
				0,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1555].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,0,0,1, 1,0,1,0,
				1,0,0,0, 1,1,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,1,
				1,0,0,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11 * Pseq([
				1,1/2, 
			],inf).stutter(2),
		),
		Pbind( \out, BusDef(\sendbus1, \audio), ) <>
		Pbind(
			\instrument, \sunfm,
			\freq, Pwhite(40,140),
			\freq, Pseq([74,48],inf),
			//\note, Pseq([
				//0,10,
			//],inf),
			\octave, 3,
			\fmf, Pwhite(40,140),
			\fmf, Pseq([
				77,53,
			],inf),
			\legato, 1,
			\dur, 4,
			\amp, 0.1,
		).trace,
		
		Pmono(
			 \gregrainrand_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			//\pos, 4.0983836717573,
			\pos, ~pmodenv.(1 + Pseq([0,5,10]/398,1) + Pwhite(0,0.02,inf).stutter(8), Prand([1,2,4],inf)).loop,
			\randfac, 0.0001,
			\randfreq, 8,
			\gdur, 0.1/8,
			\freq, Pstep(Pseq([
				113,112,55,49,
			],inf), 4) * Pseq([
				0,0,0,0, 0,3,9,0,
				0,0,0,0, 0,9,12,0,
			],inf).midiratio * Prand([2,3,4,5],inf).stutter(4*4*2),
			\pitch_stretch, 1/2,
			\trigfreqfac, 1,
			\legato, 1,
			\dur, 1/4,
			\amp, 0.8,
			\lag, 0.04,
			\isRest, true,
		)
		
	])
)).play;
);

(
Pdef(\sun2melo2, 
	Pbind(
		\instrument, \gregrainrand_pan,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono(\amen),
			//\pos, 4.0983836717573,
			\pos, ~pmodenv.(2 + Pseq([0,5,10]/798,1) + Pwhite(0,0.02,inf).stutter(8), Prand([1,2,4],inf)).loop,
			//\pos, 2,
			\randfac, 0.0001,
			\randfreq, 8,
			\gdur, 0.1/8,
			\note, Pseq([

				Prand([0,3,7,0,Prand((0..12),1)]),
			],inf),
			\pitch_stretch, 1/2,
			\trigfreqfac, 1*2,
			\octave, 5,
			\legato, 1,
			\dur, 1,
			\amp, 0.2,
	)
);
);

[63,56].midicps/8
[74,48].cpsmidi
(
Pdef(\sun2melo2, 
	Pbind(
		\instrument, \default,
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono(\amen),
			//\pos, 4.0983836717573,
			//\pos, ~pmodenv.(2 + Pseq([0,5,10]/798,1) + Pwhite(0,0.02,inf).stutter(8), Prand([1,2,4],inf)).loop,
			//\pos, 2,
			\randfac, 0.0001,
			\randfreq, 8,
			\gdur, 0.1/8,
			\note, Pseq([

				Prand([0,3,7,0,Prand((0..12),1)]),
			],inf),
			\pitch_stretch, 1/2,
			\trigfreqfac, 1*2,
			\octave, 5,
			\legato, 1,
			\dur, 1,
			\amp, 0.2,
	)
);
);


//////

(
{
    var snd, freq, formantCount, formantFreq, sineCycles, pulsaretPhase, window, randomLFO, randomLFOs;
    formantCount = 3;
    randomLFO = { LFNoise2.kr(5) };
    randomLFOs = { { randomLFO.() } ! formantCount };
    freq = randomLFO.().linexp(-1, 1, 1, 1000);
    formantFreq = randomLFOs.().linexp(-1, 1, 2, 8000);
    sineCycles = randomLFOs.().linlin(-1, 1, 1, 4);
    pulsaretPhase = LFSaw.ar(freq, iphase: 1).linlin(-1, 1, 0, 1) * formantFreq / freq;
    window = pulsaretPhase.lincurve(0, 1, 1, 0, -2);
    snd = sin(pulsaretPhase * 2pi * sineCycles.floor) * window * (pulsaretPhase < 1);
    snd = snd * randomLFOs.().linlin(-1, 1, 0, 1);
    snd = Pan2.ar(snd, randomLFOs.() * 0.4);
    snd = snd.flop.sum;
    snd = snd * -2.dbamp;
    snd;
}.play(fadeTime: 0);
)


////

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lpf, lpf2;
	sig = WhiteNoise.ar(1/2) + LFSaw.ar(70);
	sig1 = sig;
	lpf = SinOsc.ar(2).range(500,600);
	lpf2 = SinOsc.ar(2.2).range(900,1000);
	sig = BPF.ar(sig1, lpf, \rq.kr(0.1/2));
	sig = sig + BPF.ar(sig1, lpf2, \rq2.kr(0.051));
	sig = sig *4;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


//////

(
	SynthDef(\envdelay, { arg out=0, gate=1, timeScale=1, levelScale=1;
		var sig;
		var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		var envdelay;
		sig = in;
		envdelay = EnvGen.kr(\env.kr(Env([1,2,1],[0.1,0.8])), timeScale:timeScale, levelScale:levelScale,gate:1);
		sig = DelayC.ar(sig, \delaymax.kr(1), \delayfac.kr(1) * envdelay);
		sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
		sig = sig * \gain.kr(1);
		Out.ar(out, sig);
		}, metadata:(specs:(
			env: ParamEnvSpec(\lofreq)
		))).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1719].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx1, \audio),
		),
		Pdef(\envdelay, Pbind(\instrument, \envdelay))<>
		Pbind(
			\instrument, \envdelay,
			\dur, 1,
			\mix, 0,
			\delayfac, 0.001,
			\env, [ Env([1,2,1],[0.1,0.8]) ],
			\inbus, BusDef(\cfx1, \audio),
		),
		
	])
)).play;
);

Pdef(\envdelay).edit

(
	SynthDef(\envcomb, { arg out=0, gate=1, timeScale=1, levelScale=1;
		var sig;
		var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		var envdelay;
		sig = in;
		envdelay = EnvGen.kr(\env.kr(Env([1,2,1],[0.1,0.8])), timeScale:timeScale, levelScale:levelScale,gate:1);
		sig = CombC.ar(sig, \delaymax.kr(1), \delayfac.kr(1) * envdelay, \decay.kr(1));
		sig = SelectX.ar(\mix.kr(1.5), [in, sig]);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
		sig = sig * \gain.kr(1);
		Out.ar(out, sig);
		}, metadata:(specs:(
			env: ParamEnvSpec(\lofreq)
		))).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[39].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\cfx2, \audio),
		),
		Pdef(\envcomb, Pbind(\instrument, \envcomb))<>
		Pbind(
			\instrument, \envcomb,
			\dur, 4,
			\mix, 0,
			\lag, 1/2,
			\delayfac, 0.001,
			\env, [ Env([1,2,1],[0.1,0.8]) ],
			\inbus, BusDef(\cfx1, \audio),
		),
		Pdef(\envcomb2, Pbind(\instrument, \envcomb))<>
		Pbind(
			\instrument, \envcomb,
			\dur, 4,
			\mix, 0,
			\delayfac, 0.001,
			\env, [ Env([1,2,1],[0.1,0.8]) ],
			\inbus, BusDef(\cfx1, \audio),
		),
		Pdef(\envcomb3, Pbind(\instrument, \envcomb))<>
		Pbind(
			\instrument, \envcomb,
			\dur, 4,
			\mix, 0,
			\delayfac, 0.001,
			\env, [ Env([1,2,1],[0.1,0.8]) ],
			\inbus, BusDef(\cfx2, \audio),
		),
		
	])
)).play;
);

Pdef(\envcomb).edit
Pdef(\envcomb2).edit
Pdef(\envcomb3).edit

Pdef(\envcomb).presetCompileString.editorInsert

(
	// mario
Pdef('envcomb').setVal('env', Env([ 2.8610263416219, 3.6466953494925, 1.0000000686224 ], [ 0.21750599145889, 0.68249404430389 ], [ 0.0, 0.0 ]));
Pdef('envcomb').setVal('mix', 0.50869565217391);

);



( Pdef(\envcomb).presetCompileString ++ Pdef(\envcomb2).presetCompileString ++ Pdef(\envcomb3).presetCompileString ++ ProtoDef(\rdn).presetCompileString ).editorInsert
(
Pdef('envcomb').setVal('legato', 1.236134276269);
Pdef('envcomb').setVal('out', BusDef('sendbus1'));
Pdef('envcomb').setVal('timeScale', 5.3529937672857);
Pdef('envcomb').setVal('levelScale', 0.75131549735929);
Pdef('envcomb').setVal('env', Env([ 0.23713737056617, 2.9112092303904, 45.457829527821 ], [ 0.16714628040791, 0.54820144187203 ], [ 0.0, 0.0 ]));
Pdef('envcomb').setVal('delaymax', 3.6919944729209);
Pdef('envcomb').setVal('delayfac', 0.17927821585702);
Pdef('envcomb').setVal('decay', 4.8139416815075);
Pdef('envcomb').setVal('mix', 0.79130434782609);
Pdef('envcomb').setVal('gain', 1.0);
Pdef('envcomb2').setVal('out', BusDef('sendbus1'));
Pdef('envcomb2').setVal('timeScale', 2.5218233540608);
Pdef('envcomb2').setVal('levelScale', 2.3780935838699);
Pdef('envcomb2').setVal('env', Env([ 0.1, 0.16794530620133, 0.1 ], [ 0.065789498388767, 0.17894735187292 ], [ 0.0, 0.0 ]));
Pdef('envcomb2').setVal('delaymax', 3.189022231604);
Pdef('envcomb2').setVal('delayfac', 2.5218233540608);
Pdef('envcomb2').setVal('decay', 4.0327419354286);
Pdef('envcomb2').setVal('mix', 1.0);
Pdef('envcomb2').setVal('gain', 1.0);
Pdef('envcomb3').setVal('out', BusDef('sendbus1'));
Pdef('envcomb3').setVal('timeScale', 4.4637322006176);
Pdef('envcomb3').setVal('levelScale', 0.12881898574756);
Pdef('envcomb3').setVal('env', Env([ 2.015337902407, 0.20251857637293, 0.19902749333123 ], [ 0.21009173989296, 0.71055049770469 ], [ 0.0, 0.0 ]));
Pdef('envcomb3').setVal('delaymax', 3.834512926661);
Pdef('envcomb3').setVal('delayfac', 1.0275781332275);
Pdef('envcomb3').setVal('decay', 4.9395806604837);
Pdef('envcomb3').setVal('mix', 0.4896265560166);
Pdef('envcomb3').setVal('gain', 1.0);
ProtoDef('rdn').make('deldefault', 'rdn', "5-1M2C-K1J0", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.22268907563025,
	'gain', 0.68067226890756,
	'fb', 0.0001,
	'delay', 0.33838551534282,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.1787686347936,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
Pdef('envcomb').setVal('legato', 0.98752694389871);
Pdef('envcomb').setVal('out', BusDef('sendbus1'));
Pdef('envcomb').setVal('timeScale', 0.49140400882153);
Pdef('envcomb').setVal('levelScale', 4.3291727060437);
Pdef('envcomb').setVal('env', Env([ 0.23713737056617, 2.9112092303904, 45.457829527821 ], [ 0.16714628040791, 0.54820144187203 ], [ 0.0, 0.0 ]));
Pdef('envcomb').setVal('delaymax', 3.6919944729209);
Pdef('envcomb').setVal('delayfac', 0.17927821585702);
Pdef('envcomb').setVal('decay', 4.8139416815075);
Pdef('envcomb').setVal('mix', 0.0);
Pdef('envcomb').setVal('gain', 1.0);
Pdef('envcomb2').setVal('out', BusDef('sendbus1'));
Pdef('envcomb2').setVal('timeScale', 11.59694004135);
Pdef('envcomb2').setVal('levelScale', 0.61667643788929);
Pdef('envcomb2').setVal('env', Env([ 0.1, 2.4198504640291, 0.24723129040648 ], [ 0.065789498388767, 0.16052629798651 ], [ 0.0, 0.0 ]));
Pdef('envcomb2').setVal('delaymax', 3.189022231604);
Pdef('envcomb2').setVal('delayfac', 2.5218233540608);
Pdef('envcomb2').setVal('decay', 4.0327419354286);
Pdef('envcomb2').setVal('mix', 1.0);
Pdef('envcomb2').setVal('gain', 1.0);
Pdef('envcomb3').setVal('out', BusDef('sendbus1'));
Pdef('envcomb3').setVal('timeScale', 4.4637322006176);
Pdef('envcomb3').setVal('levelScale', 0.12881898574756);
Pdef('envcomb3').setVal('env', Env([ 2.015337902407, 0.20251857637293, 0.19902749333123 ], [ 0.21009173989296, 0.71055049770469 ], [ 0.0, 0.0 ]));
Pdef('envcomb3').setVal('delaymax', 3.834512926661);
Pdef('envcomb3').setVal('delayfac', 1.0275781332275);
Pdef('envcomb3').setVal('decay', 4.9395806604837);
Pdef('envcomb3').setVal('mix', 1.0);
Pdef('envcomb3').setVal('gain', 1.0);
ProtoDef('rdn').make('deldefault', 'rdn', "5-1M2C-K1J0", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.22268907563025,
	'gain', 0.68067226890756,
	'fb', 0.0001,
	'delay', 0.33838551534282,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.1787686347936,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
Pdef('envcomb').setVal('legato', 0.98752694389871);
Pdef('envcomb').setVal('out', BusDef('sendbus1'));
Pdef('envcomb').setVal('timeScale', 5.3529937672857);
Pdef('envcomb').setVal('levelScale', 4.3291727060437);
Pdef('envcomb').setVal('env', Env([ 0.23713737056617, 2.9112092303904, 45.457829527821 ], [ 0.16714628040791, 0.54820144187203 ], [ 0.0, 0.0 ]));
Pdef('envcomb').setVal('delaymax', 3.6919944729209);
Pdef('envcomb').setVal('delayfac', 0.17927821585702);
Pdef('envcomb').setVal('decay', 0.67565723890883);
Pdef('envcomb').setVal('mix', 0.50869565217391);
Pdef('envcomb').setVal('gain', 1.0);
Pdef('envcomb2').setVal('timeScale', 0.77983054085393);
Pdef('envcomb2').setVal('levelScale', 0.1);
Pdef('envcomb2').setVal('env', Env([ 6.6174345589086, 0.45672068714453, 100.0 ], [ 0.12105266749859, 0.69210524857044 ], [ 0.0, 0.0 ]));
Pdef('envcomb2').setVal('delaymax', 1.1759809527899);
Pdef('envcomb2').setVal('delayfac', 2.5218233540608);
Pdef('envcomb2').setVal('decay', 0.34292578683877);
Pdef('envcomb2').setVal('mix', 0.54326923076923);
Pdef('envcomb2').setVal('gain', 1.0);
Pdef('envcomb3').setVal('out', BusDef('sendbus1'));
Pdef('envcomb3').setVal('timeScale', 0.30472736189874);
Pdef('envcomb3').setVal('levelScale', 0.1);
Pdef('envcomb3').setVal('env', Env([ 15.303213040901, 0.38338820684061, 1.0000000686224 ], [ 0.24908256722153, 0.65091746854126 ], [ 0.0, 0.0 ]));
Pdef('envcomb3').setVal('delaymax', 3.834512926661);
Pdef('envcomb3').setVal('delayfac', 1.0275781332275);
Pdef('envcomb3').setVal('decay', 4.6956325720556);
Pdef('envcomb3').setVal('mix', 0.47302904564315);
Pdef('envcomb3').setVal('gain', 1.0);
ProtoDef('rdn').make('deldefault', 'rdn', "5-7L89-T9E3", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.37394957983193,
	'gain', 0.68243243243243,
	'fb', 0.0001,
	'delay', 0.11450475699383,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 11.015819387359,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
Pdef('envcomb').setVal('legato', 0.98752694389871);
Pdef('envcomb').setVal('out', BusDef('sendbus1'));
Pdef('envcomb').setVal('timeScale', 0.49140400882153);
Pdef('envcomb').setVal('levelScale', 4.3291727060437);
Pdef('envcomb').setVal('env', Env([ 0.23713737056617, 2.9112092303904, 45.457829527821 ], [ 0.16714628040791, 0.54820144187203 ], [ 0.0, 0.0 ]));
Pdef('envcomb').setVal('delaymax', 3.6919944729209);
Pdef('envcomb').setVal('delayfac', 0.17927821585702);
Pdef('envcomb').setVal('decay', 4.8139416815075);
Pdef('envcomb').setVal('mix', 0.50869565217391);
Pdef('envcomb').setVal('gain', 1.0);
Pdef('envcomb2').setVal('timeScale', 10.312690153776);
Pdef('envcomb2').setVal('levelScale', 0.92994529836957);
Pdef('envcomb2').setVal('env', Env([ 0.1, 2.4198504640291, 0.24723129040648 ], [ 0.065789498388767, 0.16052629798651 ], [ 0.0, 0.0 ]));
Pdef('envcomb2').setVal('delaymax', 3.189022231604);
Pdef('envcomb2').setVal('delayfac', 2.5218233540608);
Pdef('envcomb2').setVal('decay', 4.0327419354286);
Pdef('envcomb2').setVal('mix', 1.0);
Pdef('envcomb2').setVal('gain', 1.0);
Pdef('envcomb3').setVal('out', BusDef('sendbus1'));
Pdef('envcomb3').setVal('timeScale', 0.37316023012453);
Pdef('envcomb3').setVal('levelScale', 0.2032093333976);
Pdef('envcomb3').setVal('env', Env([ 2.0153378482907, 0.20251857637293, 1.0000000686224 ], [ 0.21009173989296, 0.68990829586983 ], [ 0.0, 0.0 ]));
Pdef('envcomb3').setVal('delaymax', 3.834512926661);
Pdef('envcomb3').setVal('delayfac', 1.0275781332275);
Pdef('envcomb3').setVal('decay', 4.9395806604837);
Pdef('envcomb3').setVal('mix', 1.0);
Pdef('envcomb3').setVal('gain', 1.0);
ProtoDef('rdn').make('deldefault', 'rdn', "5-9K5H-TDF1", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.37394957983193,
	'gain', 0.68243243243243,
	'fb', 0.00053831493658073,
	'delay', 0.55962764453196,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.9236664026787,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
Pdef('envcomb').setVal('legato', 0.98752694389871);
Pdef('envcomb').setVal('out', BusDef('sendbus1'));
Pdef('envcomb').setVal('timeScale', 0.49140400882153);
Pdef('envcomb').setVal('levelScale', 4.3291727060437);
Pdef('envcomb').setVal('env', Env([ 0.23713737056617, 2.9112092303904, 45.457829527821 ], [ 0.16714628040791, 0.54820144187203 ], [ 0.0, 0.0 ]));
Pdef('envcomb').setVal('delaymax', 3.6919944729209);
Pdef('envcomb').setVal('delayfac', 0.17927821585702);
Pdef('envcomb').setVal('decay', 4.8139416815075);
Pdef('envcomb').setVal('mix', 0.50869565217391);
Pdef('envcomb').setVal('gain', 1.0);
Pdef('envcomb2').setVal('timeScale', 8.6479825795967);
Pdef('envcomb2').setVal('levelScale', 0.1);
Pdef('envcomb2').setVal('env', Env([ 6.6174345589086, 0.45672068714453, 100.0 ], [ 0.12105266749859, 0.69210524857044 ], [ 0.0, 0.0 ]));
Pdef('envcomb2').setVal('delaymax', 1.1759809527899);
Pdef('envcomb2').setVal('delayfac', 2.5218233540608);
Pdef('envcomb2').setVal('decay', 4.0327419354286);
Pdef('envcomb2').setVal('mix', 0.54326923076923);
Pdef('envcomb2').setVal('gain', 1.0);
Pdef('envcomb3').setVal('out', BusDef('sendbus1'));
Pdef('envcomb3').setVal('timeScale', 0.53194554716604);
Pdef('envcomb3').setVal('levelScale', 0.1);
Pdef('envcomb3').setVal('env', Env([ 15.303213040901, 0.38338820684061, 1.0000000686224 ], [ 0.24908256722153, 0.65091746854126 ], [ 0.0, 0.0 ]));
Pdef('envcomb3').setVal('delaymax', 3.834512926661);
Pdef('envcomb3').setVal('delayfac', 1.0275781332275);
Pdef('envcomb3').setVal('decay', 4.9395806604837);
Pdef('envcomb3').setVal('mix', 0.47302904564315);
Pdef('envcomb3').setVal('gain', 1.0);
ProtoDef('rdn').make('deldefault', 'rdn', "5-7L89-T9E3", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.37394957983193,
	'gain', 0.68243243243243,
	'fb', 0.0001,
	'delay', 0.28985772146511,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 11.015819387359,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


//////////////////////////////


(
Pdef(\part, Pdef(\drumpart1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.81,1.5
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,0,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0,1, 1,1,0,1,
				0,0,0,1, 1,1,1,1,
				1,1,0,1, 0,1,1,1,
				0,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\drumpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.81,2.5
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.41,
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,0,1,1, 1,1,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 1,0,1,0,
				],8),
					0,0,1,0, 1,0,1,0,
					0,0,1,0, 1,0,1,0,
					0,0,1,0, 1,0,1,0,
					0,0,1,0, 1,0,1,0,

					0,0,1,0, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
					0,0,0,1, 1,0,1,0,
					0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\melopart1, 
	Ppar([
		Pbind( \out, BusDef(\sendbus1, \audio), ) <>
		Pseq([
//( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  //'amp': 0.1, 'freq': 124, 'fmf': 104 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 113, 'fmf': 41 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 112, 'fmf': 61 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 55, 'fmf': 122 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 49, 'fmf': 98 ),

		],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\melopart2, 
	Ppar([
		Pbind( \out, BusDef(\sendbus1, \audio), ) <>
		Pseq([
//( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  //'amp': 0.1, 'freq': 124, 'fmf': 104 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 113, 'fmf': 41 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 112, 'fmf': 61 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 55, 'fmf': 122 ),
( 'instrument': \sunfm, 'octave': 3, 'legato': 1, 'dur': 4,
  'amp': 0.1, 'freq': 49, 'fmf': 98 ),

		],inf),
		Pmono(
			 \gregrainrand_pan,
			\mbufnum, BufDef.mono("com/Kick/Kick House 4.wav"),
			\mbufnum, BufDef.mono('voices/feynman.flac'),
			\mbufnum, BufDef.mono('voices/kaspi.flac'),
			//\pos, 4.0983836717573,
			\pos, ~pmodenv.(1 + Pseq([0,5,10]/398,1) + Pwhite(0,0.02,inf).stutter(8), Prand([1,2,4],inf)).loop,
			\randfac, 0.0001,
			\randfreq, 8,
			\gdur, 0.1/8,
			\freq, Pstep(Pseq([
				113,112,55,49,
			],inf), 4) * Pseq([
				0,0,0,0, 0,3,9,0,
				0,0,0,0, 0,9,12,0,
			],inf).midiratio * Prand([2,3,4,5],inf).stutter(4*4*2),
			\pitch_stretch, 1/2,
			\trigfreqfac, 1,
			\legato, 1,
			\dur, 1/4,
			\amp, 0.8,
			\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Ppar([
			Pseq([
				Pfindur(16,Pdef(\drumpart2)),
				Pfindur(16,Pdef(\drumpart1)),
			],inf),
			Pseq([
				Pfindur(16,Pdef(\melopart1)),
				Pfindur(16*3,Pdef(\melopart2)),
			],inf),
		])
		
	])
)).play;
);
(
Pdef(\part, Pdef(\main, 
	Pseq([
		Ppar([
Pbind( \out, BusDef(\sendbus4, \audio) ) <>
			Pseq([
				Pfindur(16,Pdef(\drumpart3)),
				Pfindur(16,Pdef(\drumpart2)),
				Pfindur(16,Pdef(\drumpart1)),
				Pfindur(16,Pdef(\drumpart2)),

				Event.silent(16),
				Pfindur(16,Pdef(\drumpart3)),
				Pfindur(16,Pdef(\drumpart1)),
				Pfindur(16,Pdef(\drumpart2)),

				Pfindur(16,Pdef(\drumpart2)),
				Pfindur(16,Pdef(\drumpart1)),
				Pfindur(16,Pdef(\drumpart2)),
				Pfindur(16,Pdef(\drumpart1)),
			],inf),
			Pseq([
				Pfindur(16,Pdef(\melopart1)),
				Pfindur(16*3,Pdef(\melopart2)),
			],inf),
		])
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( \out, BusDef(\sendbus4, \audio) ) <> Pdef(\drumpart3),
			Pseq([
				Pfindur(16,Pdef(\melopart1)),
				Pfindur(16*3,Pdef(\melopart2)),
			],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drumpart3, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.81,4.5
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.41,
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
					0,0,1,0, 1,0,1,0,
					0,0,1,0, 1,0,1,0,
					0,0,1,0, 1,0,1,0,
					0,0,1,0, 1,0,1,0,

					0,0,1,0, 1,0,1,0,
					1,0,0,0, 1,1,1,0,
					0,0,0,1, 1,0,1,0,
					0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
		),
	])
)).play;
);

ProtoDef(\rdn4).presetCompileString.editorInsert
(
ProtoDef('rdn4').make('deldefault', 'rdn4', "5-MLEF-A53I", BusDef('sendbus4'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.36554621848739,
	'gain', 1.0,
	'fb', 0.00011653539627239,
	'delay', 0.0001,
	'delay2', 0.33838551534282,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 15.605486450071,
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
	'wetamp', 0.1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1.0,
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
Pdef(\part, Pdef(\drumpart4, 
	Ppar([
		
		Pdef(\melopart1),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[190].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.81,4.5
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\legato, 0.2,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1931].value,
			\bufnum, ~buflib.snare[1846].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\legato, Pseq([
				0.41,
			],inf).stutter(16),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,0,0,1, 0,1,1,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,1,1,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 1,0,1,0,
					0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\melopart1),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[39].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\cfx2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[733].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1/2,1,1/2,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 4,1,1/2,1,
			],inf) * 0.8,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\cfx2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1128].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
					1,0,1,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				1,1,2,1, 1,1,1/2,1/4,
			],inf),
			\speed, Pseq([
				1,1,2,1, 1,1,1/2,1/4,
				
			],inf)*0.9,
			\gain, 0.11/2 * Pseq([
				1,1,1,1, 1,1,1/2,1/2,
			],inf),
			\lag, 0.04,
		),

		Pdef(\envcomb, Pbind(\instrument, \envcomb))<>
		Pbind(
			\instrument, \envcomb,
			\dur, 4,
			\mix, 0,
			\lag, 1/2,
			\delayfac, 0.001,
			\env, [ Env([1,2,1],[0.1,0.8]) ],
			\inbus, BusDef(\cfx1, \audio),
		),
		Pdef(\envcomb2, Pbind(\instrument, \envcomb))<>
		Pbind(
			\instrument, \envcomb,
			\dur, 4,
			\mix, 0,
			\delayfac, 0.001,
			\env, [ Env([1,2,1],[0.1,0.8]) ],
			\inbus, BusDef(\cfx1, \audio),
		),
		Pdef(\envcomb3, Pbind(\instrument, \envcomb))<>
		Pbind(
			\instrument, \envcomb,
			\dur, 4,
			\mix, 0,
			\delayfac, 0.001,
			\env, [ Env([1,2,1],[0.1,0.8]) ],
			\inbus, BusDef(\cfx2, \audio),
		),
		
	])
)).play;
);
