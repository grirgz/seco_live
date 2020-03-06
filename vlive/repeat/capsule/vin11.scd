~t = 134/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\overtune, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * [1,2,1/2,3,4]);
	sig = RLPF.ar(sig, ( \lpfr.kr(2.1) * freq * ( SinOsc.ar(\lpfmf.kr(10)*[1,2,3]) * 0.51 + 1 ) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\overbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq * [1/2,1,1.01,1.001]);
	sig = sig + SinOsc.ar(freq * [1/2,1,1.01,1.001]);
	sig = RLPF.ar(sig, ( \lpfr.kr(2.1) * freq * ( LFSaw.ar(1*[1,2,3]) * 0.51 + 1 ) ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
	~swing = 0.50;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \overbass,
			\note, Pseq([
				0
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.2,0.8,0.14) ],
			],inf),
			\legato, Pseq([
				0.6,0,0,1, 0,0,0,0.6,
				2.53,0,0,0.1, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \overtune,
			\note, Pseq([
				0,1,3,4
			],inf),
			\octave, 6,
			\sustain, 0.27,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.2,0.4,0.4) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 0,0,1,1,
				1,1,0,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[127].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,1,
				1,0,0,1, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, 
			Pseq([
				~buflib.hat[637].value,
				~buflib.hat[638].value,
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
				1,1,0,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1027].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\out, BusDef(\sendbus1, \audio),
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pmono(
			\playersec,
			\out, BusDef(\sendbus2, \audio),
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 4,
			\dur, Pseq([2],1),
			\gain, 1,
		).loop,
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
	])
)).play;
);

(
	~swing = 0.50;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \overbass,
			\note, Pseq([
				0
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.2,0.8,0.14) ],
			],inf),
			\legato, Pseq([
				0.6,0,0,1, 0,0,0,0.6,
				2.53,0,0,0.1, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\out, BusDef(\sendbus3, \audio),
			\instrument, \overtune,
			\note, Pseq([
				4,4,4,4, 4,3,2,1,
			],inf),
			\octave, 6,
			\legato, Pseq([
				4,0,0,2, 0,2,0,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\sustain, 0.27,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.2,0.4,0.4) ],
			],inf),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[127].value,
			\isRest, Pseq([
				1,0,1,1, 0,1,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, 
			Pseq([
				~buflib.hat[837].value,
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1, 
				1,0,1,0, 1,0,1,0, 
				1,0,1,1, 1,0,1,0, 
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\sustain, 0.2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1027].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\out, BusDef(\sendbus1, \audio),
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pmono(
			\playersec,
			\out, BusDef(\sendbus2, \audio),
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 4,
			\dur, Pseq([2],1),
			\gain, 1,
		).loop,
		
	])
)).play;
);

(
	~swing = 0.50;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \overbass,
			\note, Pseq([
				-1
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.2,0.8,0.14) ],
			],inf),
			\legato, Pseq([
				0.6,0,0,1, 0,0,0,0.6,
				2.53,0,0,0.1, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\out, BusDef(\sendbus3, \audio),
			\instrument, \overtune,
			\note, Pseq([
				4,4,4,4, 4,3,2,1,
			],inf),
			\lpfmf, Pseq([
				1,2,10,100
			],inf).stutter(10),
			\octave, 6,
			\legato, Pseq([
				4,0,0,2, 0,2,0,1,
				1,0,0,0, 0,2,0,1,
				1,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,1,

				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,2,0,1,
				4,0,0,2, 0,2,0,1,
				0.1,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\sustain, 0.27,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.2,0.4,0.4) ],
			],inf),
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		Pbind(\out, BusDef(\sendbus4, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[127].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,0,0,
					0,0,0,1, 0,0,0,1,
					0,0,0,1, 0,0,1,0,
					0,1,0,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, 
				Pseq([
					~buflib.hat[837].value,
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\sustain, 0.2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, 
				Pseq([
					~buflib.hat[917].value,
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
			
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\sustain, 0.2,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1027].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,1, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.21,
			),
		]),
		Pbind(
			\out, BusDef(\sendbus1, \audio),
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\dur, 1/8,
			\gain, 0.3,
		),
		Pmono(
			\playersec,
			\out, BusDef(\sendbus2, \audio),
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, 4,
			\dur, Pseq([1/4],16),
			\gain, 1,
			\gain, Pkey(\gain) * Pseq([
				1,0,1,1,
				0,0,0,0, 
				0,1,1,0,
				0,0,0,0,
			],inf),
		).loop,
		
	])
)).play;
);

(
PatKitDef(\vin11_p1, [
	StepEvent.newFrom((instrument: 'playersec', bufnum: ~buflib.kick[127].value, gain: 0.2)),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: ~buflib.snare[1027].value, gain: 0.21)),
	nil,
	nil,
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: ~buflib.hat[837].value, gain: 0.11)),
	StepEvent.newFrom((instrument: 'playersec', bufnum: ~buflib.hat[907].value, gain: 0.11)),
	
]);
)

(
KitTimeline('vin11_p1').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.5, \kitIndex: 0.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 7.5, \kitIndex: 4.0, \playDur: 7.5, \relDur: 7.5, \sustain: 0.1, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

ClipTimeline(\vin11).edit
KitTimeline(\vin11_p1, PatKitDef(\vin11_p1)).edit
KitTimeline(\vin11_p1).presetCompileString.editorInsert

KitTimeline(\vin11_p1).play;
KitTimeline(\vin11_p1).asPattern.trace.play
KitTimeline(\vin11_p1).asPattern_old.trace.play
~s =Pn(KitTimeline(\vin11_p1).eventList, 1).asStream
~s = PdrumStep(KitTimeline(\vin11_p1).kit, Pn(KitTimeline(\vin11_p1).eventList, 1), 1, key: \kitIndex).asStream
PdrumStep(KitTimeline(\vin11_p1).kit, Pn(KitTimeline(\vin11_p1).eventList, 1), 1, key: \kitIndex).play
PdrumStep(KitTimeline(\vin11_p1).kit, Pn(KitTimeline(\vin11_p1).eventList, 1), 1, key: \kitIndex).trace.play

Prout({ PdrumStep(KitTimeline(\vin11_p1).kit, Pn(KitTimeline(\vin11_p1).eventList, 1), 1, key: \kitIndex).embedInStream }).play
Pseq([Prout({ Pn(PdrumStep(KitTimeline(\vin11_p1).kit, Pn(KitTimeline(\vin11_p1).eventList, 1), 1, key: \kitIndex),1).embedInStream })]).play
Pseq([Prout({ Pn(PdrumStep(KitTimeline(\vin11_p1).kit, Pn(KitTimeline(\vin11_p1).eventList.collect({arg x; Event.newFrom(x)}), 1), 1, key: \kitIndex),1).embedInStream })]).play

Prout({ PdrumStep(KitTimeline(\vin11_p1).kit, Pn(KitTimeline(\vin11_p1).eventList, 1), 1, key: \kitIndex).embedInStream }).play
PdrumStep(KitTimeline(\vin11_p1).kit, Pn(KitTimeline(\vin11_p1).eventList, 1), 1, key: \kitIndex).collect({ arg x; x.dump }).play

KitTimeline(\vin11_p1).eventList.collect({arg x; Event.newFrom(x)})
KitTimeline(\vin11_p1).eventList.collect({arg x; x.dump})

KitTimeline(\vin11_p1).cutPatternFunction.value.play
~s= KitTimeline(\vin11_p1).asPattern.asStream
 ~s.next
StepEvent.newFrom((instrument: 'playersec', bufnum: ~buflib.kick[127].value, gain: 0.2)).play
(instrument: 'playersec', bufnum: ~buflib.kick[127].value, gain: 0.2).play

ParamProto.init(true)

KitTimeline(\vin11_p1).clear




PdrumStep(KitTimeline(\vin11_p1).kit, Pn(KitTimeline(\vin11_p1).eventList, 1), 1, key: \kitIndex).play

Event.newFrom(StepEvent.newFrom((instrument: 'playersec', bufnum: ~buflib.kick[127].value, gain: 0.2)))



(
Pdef(\part, Pdef(\zed, 
	Ppar([
	Pbind(
		\instrument, \snapkickx,
		\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
		\dur, 1/8,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\out, BusDef(\sendbus1, \audio),
		\amp, 0.1,
	),
	Pbind(
		\lag, 0.04,
		\instrument, \basicbass,
		\out, BusDef(\sendbus1, \audio),
		\sustain, 0.5,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.01) ],
		],inf),
		\octave, 3,
		\note, Pseq([
			Pseq((0..32)-16).trace,
		],inf),
		\dur, 1,
		\amp, 0.1,
	),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1027].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
				\gain, 0.21,
			),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
	Pbind(
		\instrument, \snapkickx,
		\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
		\dur, 1/8,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\out, BusDef(\sendbus1, \audio),
		\amp, 0.1,
	),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1027].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
				\gain, 0.21,
			),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
	Pbind(
		\instrument, \snapkickx,
		\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
		\dur, 1/8,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,1,
			1,0,0,1, 0,0,0,0,
		],inf).coin.not,
		\out, BusDef(\sendbus1, \audio),
		\amp, 0.1,
	),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1027].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
				\gain, 0.21,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1025].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				//\out, BusDef(\sendbus2, \audio),
				\lag, 0.04,
				\sustain, 0.12,
				\gain, 0.21,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
				\bufnum, 
				Prand([
					~buflib.drum[29].value,
					~buflib.drum[21].value,
				],inf),
				\isRest, Pseq([
					Prand([
						Pseq([ 1,1,0,1, 0,0,0,0, ],1),
						Pseq([ 0,0,0,0, 1,0,1,1, ],1),
						Pseq([ 0,0,0,0, 1,1,0,1, ],1),
						Pseq([ 0,0,0,0, 0,0,0,0, ],1),
						Pseq([ 0,0,0,0, 0,0,0,0, ],1),
						Pseq([ 0,0,0,0, 0,0,0,0, ],1),
						Pseq([ 0,0,0,0, 0,0,0,1, ],1),
						Pseq([ 0,0,0,0, 0,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,0,0,0, ],1),
					],1),
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.051,
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\out, BusDef(\sendbus2, \audio),
				\isRest, Pseq([
					Prand([
						Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
						Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
						Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
					],1),
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.31,
				\gain, Pkey(\gain) * Pseq([
					Prand([
						Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
						Pseq([ 1,1,0,1, 1,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,1,1,0, ],1),
						Pseq([ 1,1,0,1, 0,1,1,0, ],1),
					],inf) + 0.7 / 1.7,
				],1),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1066].value,
				\out, BusDef(\sendbus2, \audio),
				\isRest, Pseq([
					Prand([
						Pseq([ 1,1,0,1, 1,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,1,1,0, ],1),
						Pseq([ 1,1,0,1, 0,1,1,0, ],1),
					],inf),
					0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\sustain, 0.01,
				\gain, 0.05,
				\gain, Pkey(\gain) * Pseq([
					Prand([
						Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
						Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
						Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
						Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
						Pseq([ 1,1,0,1, 1,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,1,1,0, ],1),
						Pseq([ 1,1,0,1, 0,1,1,0, ],1),
					],inf) + 0.7 / 1.7,
				],1),
			),
		
	])
)).play;
);


ProtoDef(\rdn).proxy.put(111, nil)
(
ProtoDef(\rdn).proxy.put(111, \pset -> Pbind(
	\delay, Plazy({ arg ev;
		var a = exprand(0.0001,0.01);
		var b = exprand(0.0001,0.01);
		var c = exprand(0.0001,0.01);
		Pseq([
			a,a,a,a, a,a,b,a,
			a,a,a,b, a,c,a,b
		],1)
	}).loop,
	\delay2, Plazy({ arg ev;
		var a = exprand(0.0001,0.01);
		var b = exprand(0.0001,0.01);
		var c = exprand(0.0001,0.01);
		Pseq([
			a,a,a,a, a,a,b,b,
			a,a,a,b, a,c,a,b
		],1)
	}).loop,
	\dur, 1,
))
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
	Pbind(
		\instrument, \snapkickx,
		\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
		\dur, 1/8,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,1,
			1,0,0,1, 0,0,0,0,
			1,0,0,0, 0,0,0,1,
			0,0,1,0, 0,0,0,0,
		],inf).coin.not,
		\out, BusDef(\sendbus1, \audio),
		\amp, 0.1,
	),
	Pbind(
		\lag, 0.04,
		\instrument, \basicbass,
		\out, BusDef(\sendbus1, \audio),
		\sustain, 0.5,
		\adsr, Pseq([
			[ Env.adsr(0.01,0.1,0.8,0.01) ],
		],inf),
		\octave, 3,
		\note, Pseq([
			//Pseq((0..32)-16).trace,
			0,1,0,-1,
			0,0,-1,-1,
		],inf).stutter(8),
		\legato, Pseq([
			1,0,0,0, 0,0,0,1,
			1,0,0,1, 0,0,0,0,
			1,0,0,0, 0,0,0,1,
			0,0,1,0, 0,0,0,0,
		],inf)*2,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/8,
		\amp, 0.1,
	),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1027].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\out, BusDef(\sendbus2, \audio),
				\gain, 0.21,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1025].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				//\out, BusDef(\sendbus2, \audio),
				\lag, 0.04,
				\sustain, 0.12,
				\gain, 0.21,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
				\bufnum, 
				Prand([
					~buflib.drum[29].value,
					~buflib.drum[21].value,
				],inf),
				\isRest, Pseq([
					Prand([
						Pseq([ 1,1,0,1, 0,0,0,0, ],1),
						Pseq([ 0,0,0,0, 1,0,1,1, ],1),
						Pseq([ 0,0,0,0, 1,1,0,1, ],1),
						Pseq([ 0,0,0,0, 0,0,0,0, ],1),
						Pseq([ 0,0,0,0, 0,0,0,0, ],1),
						Pseq([ 0,0,0,0, 0,0,0,0, ],1),
						Pseq([ 0,0,0,0, 0,0,0,1, ],1),
						Pseq([ 0,0,0,0, 0,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,0,0,0, ],1),
					],1),
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.051,
				\out, BusDef(\sendbus2, \audio),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1064].value,
				\out, BusDef(\sendbus2, \audio),
				\isRest, Pseq([
					Prand([
						Pseq([ 0,0,1,0, 0,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
						Pseq([ 0,0,0,0, 1,0,0,0, 1,0,0,0, 0,0,1,0, ],1),
						Pseq([ 0,0,0,0, 1,0,0,0, 0,0,1,0, 0,0,1,0, ],1),
					],1),
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.31,
				\gain, Pkey(\gain) * Pseq([
					Prand([
						Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
						Pseq([ 1,1,0,1, 1,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,1,1,0, ],1),
						Pseq([ 1,1,0,1, 0,1,1,0, ],1),
					],inf) + 0.7 / 1.7,
				],1),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1066].value,
				\out, BusDef(\sendbus2, \audio),
				\isRest, Pseq([
					Prand([
						Pseq([ 1,1,0,1, 1,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,1,1,0, ],1),
						Pseq([ 1,1,0,1, 0,1,1,0, ],1),
					],inf),
					0,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,0,0,0, 1,0,1,1, 0,0,0,1, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\sustain, 0.01,
				\gain, 0.05,
				\gain, Pkey(\gain) * Pseq([
					Prand([
						Pseq([ 1,1,1,1, 0,0,0,0, ]-0.7,1),
						Pseq([ 0,0,0,0, 1,1,1,1, ]-0.7,1),
						Pseq([ 0,0,0,0, 0,0,0,0, ]-0.7,1),
						Pseq([ 1,1,0,1, 1,0,1,0, ]-0.7,1),
						Pseq([ 1,1,0,1, 1,0,1,0, ],1),
						Pseq([ 1,0,1,1, 0,1,1,0, ],1),
						Pseq([ 1,1,0,1, 0,1,1,0, ],1),
					],inf) + 0.7 / 1.7,
				],1),
			),
		
	])
)).play;
);
