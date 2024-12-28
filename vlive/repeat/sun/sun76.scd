
~t = 145/4/60; TempoClock.default.tempo = ~t;

(
// unison of pulse modulated by pulse width
SynthDef(\superpw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=8;
	var lpenv;
	sig = LFPulse.ar(freq, 0, LFNoise1.kr(1.1!num, mul:1, add:0).unipolar);
	sig = sig + LFPulse.ar(freq*2, 0, LFNoise1.kr(1.1, mul:1, add:0).unipolar, mul:0.2);
	//lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.04,0.4,0.2,4.1,4)), \itrig.tr(1), doneAction:0) * \lpenvamt.kr(4) + 1;
	lpenv = EnvGen.kr(\lpadsr.kr(Env.perc(1.6,0.4,curve:4)), \itrig.tr(1), doneAction:0) * \lpenvamt.kr(4) + 1;
	sig = RLPF.ar(sig, \lpf.kr(400) * lpenv, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\demo).reset;
);

(
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pbind(
			\instrument, \default,
			\legato, 0.5,
			\note, Pseq([
				[-3,0],
				[-1,2],
			],inf).stutter(8),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \superpw,
			\note, Pseq([
				5,5,5,5,
				7,7,7,7,
				5,5,5,5,
				7,7,7,7,
			],inf),
			\legato, 1,
			\lpf, Pseq([
				800,1300,
			],inf) * Pseg(Pseq([0.6,1],1),8),
			\octave, Pseq([3,3,3,2],inf),
			\legato, Pseq([
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 3,0,0,1,
				3,0,0,1, 4,0,0,0,
				4,0,0,1, 3,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.05,
		)
		
	])
)).play;
);

(
Pdef(\part, Pdef(\part2, 
	Ppar([
		Pbind(
			\instrument, \default,
			\legato, 0.5,
			\note, Pseq([
				[-3,0],
				[-1,2],
			],inf).stutter(8),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \superpw,
			\note, Pseq([
				4,
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\melo1, Pbind(
	\instrument, \superpw,
));
NoteTimeline('melo1').param = Param(Pdef('melo1'), 'midinote');
NoteTimeline('melo1').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \clockTime: 225.11885150006, \dur: 0.0, \legato: 0.8, \midinote: 76.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.21179240185415, \velocity: 88, ),
	(\absTime: 0.0, \clockTime: 225.1273363255, \dur: 0.25, \legato: 0.8, \midinote: 72.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.30342926199998, \velocity: 86, ),
	(\absTime: 0.25, \clockTime: 225.30073449152, \dur: 1.25, \legato: 0.8, \midinote: 79.0, \playDur: 1.25, \relDur: 1.25, \sustain: 0.12481678058336, \velocity: 65, ),
	(\absTime: 1.5, \clockTime: 226.59963249579, \dur: 0.125, \legato: 0.8, \midinote: 77.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.31283591043749, \velocity: 78, ),
	(\absTime: 1.625, \clockTime: 226.77441341142, \dur: 0.1174341509375, \legato: 0.8, \midinote: 76.0, \playDur: 0.1174341509375, \relDur: 0.1174341509375, \sustain: 0.22793846783333, \velocity: 110, ),
	(\absTime: 1.7424341509375, \clockTime: 226.94243415094, \dur: 0.1325658490625, \legato: 0.8, \midinote: 74, \playDur: 0.1325658490625, \relDur: 0.1325658490625, \sustain: 0.10552846854165, \velocity: 64, ),
	(\absTime: 1.875, \clockTime: 226.60251601352, \dur: 0.125, \legato: 0.8, \midinote: 72.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.375, \velocity: 47, ),
	(\absTime: 2.0, \clockTime: 227.15126534527, \dur: 0.25, \legato: 0.8, \midinote: 76.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17388249200002, \velocity: 56, ),
	(\absTime: 2.25, \clockTime: 227.33692327942, \dur: 1.75, \legato: 0.8, \midinote: 79.0, \playDur: 1.75, \relDur: 1.75, \sustain: 0.14443661397917, \velocity: 68, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
Pdef(\part, Pdef(\part3, 
	Ppar([
		Pbind(
			\instrument, \default,
			\legato, 0.5,
			\note, Pseq([
				[-3,0],
				[-1,2],
			],inf).stutter(8),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \superpw,
			\note, Pseq([
				5,5,5,5,
				7,7,7,7,
				5,5,5,5,
				7,7,7,7,
			],inf),
			\legato, 1,
			\lpf, Pseq([
				800,1300,
			],inf) * Pseg(Pseq([0.6,1],1),8).repeat(2),
			\octave, Pseq([3,3,3,2],inf),
			\legato, Pseq([
				4,0,0,0, 4,0,0,0,
				4,0,0,0, 3,0,0,1,
				3,0,0,1, 4,0,0,0,
				4,0,0,1, 3,0,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1126].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,

				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.071,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1038].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pwhite(0.9,1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1035].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,1,1, 0,0,0,0,
				0,0,1,1, 0,1,1,0,
				0,1,0,0, 0,0,1,1,

				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
				0,0,1,1, 0,1,1,0,
				0,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08 * Pwhite(0.9,1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1746].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1746].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,0,0,1,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/4,
		),
		Pbind(
			\instrument, \superpw,
			\note, Pseq([
				4,
			],inf),
			\lpf, PmodEnv(Pseq([100,999],1), 8*2),
			\dur, 4,
			\amp, 0.1/2,
		),
		Ptpar([8,Pbind(
			\instrument, \superpw,
			\note, Pseq([
				7,
			],inf),
			\octave, 6,
			\legato, 0.4,
			\lpf, PmodEnv(Pseq([600,3999],1), 8*2),
			\dur, 1/8,
			\amp, 0.1/8,
		)]),
		NoteTimeline(\melo1).asPattern,
		NoteTimeline(\melo1).automationRack.asPattern,

		
	])
)).play;
);

Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(12, Pdef(\part1)),
		Pfindur(4, Pdef(\part2)),
		Pfindur(16, Pdef(\part3)),
		
	])
)).play;

/////////////////////
(
Pdef(\melo, 
	Pbind(
		\instrument, \superpw,
		\amp, 0.07,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))

NoteTimeline(\melo1).edit
NoteTimeline(\melo1).presetCompileString.editorInsert

Pdef(\melo1).edit
Pdef(\melo1).asParamGroup.select(_.isSet).getPbindCompileString


Halo.inspect


//////////////

(
SynthDef(\gopad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * SinOsc.ar(0.1!10,Rand(0,2),mul:0.0003,add:1) );
	sig = LFPulse.ar(freq *2* ( LFSaw.ar(freq*2.001) * Line.kr(0,1/2,1/2) + 1 )) + sig;
	sig = DFM1.ar(sig, 1000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \gopad,
			\note, Pseq([
				[ 0,4+12,7,5 ],
				[ -2,3+12,7 ]+2,
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Place([1,[\r,5],2],inf).trace,
			\degree, 
			Pindex(
				[1,2,3,[4,5],\r],
				Place([[0,4,4,4], 1, 2, [4, 4, 3, 4, 3]],inf)
			),
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([1,2,3],inf),
			\prob, Pseq([
				1,0.3,
			],inf),
			\muter, Pif(Pkey(\prob).coin, 1, Rest()),
			\dur, 1/4,
		),
		
	])
)).play;
);
