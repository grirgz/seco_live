
(
~t = 153/4/60; TempoClock.default.tempo = ~t; // bub styles fat farm
~swing = 0.4;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1238].value,
			\isRest, Pseq([
				1,0,0,1, 0,1,1,0,
				0,1,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1001].value,
			\bufnum, ~buflib.snare[1718].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		
	])
)).play;
);

{ SinOsc.ar(500) ! 2 * 0.8}.play;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1238].value,
			\isRest, Pseq([
				1,0,0,1, 0,1,1,0,
				0,1,1,0, 0,0,0,1,
			],inf).coin.not,
			\gain, 0.1,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1001].value,
			\bufnum, ~buflib.snare[1718].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[338].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.04,
			//\lag, 0.04,
			\out, BusDef(\sendbus3, \audio),
		),
		
	])
)).play;
);

ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "5-986T-E7LM", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.59243697478992,
	'fb', 0.00095554995240486,
	'delay', 0.0001,
	'delay2', 0.00010804718223181,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 5.0313053129795,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 257.20161612211,
	'lpf', 20000.0,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-QVNG-8A29", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.21428571428571,
	'gain', 0.97058823529412,
	'fb', 0.0035086914797844,
	'delay', 0.00021683753109874,
	'delay2', 0.55962764453196,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 14.725404276241,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 2,
).keep(1));

);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1238].value,
			\isRest, Pseq([
				1,0,0,1, 0,1,1,0,
				0,1,1,0, 0,0,0,1,
			],inf).coin.not,
			\gain, 0.1,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1001].value,
			\bufnum, ~buflib.snare[1718].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[338].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.04,
			//\lag, 0.04,
			\out, BusDef(\mixer2, \audio),
		),
		
	])
)).play;
);

320/60

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus4, \audio),
		),
		
	])
)).play;
);

FileSystemProject.current.addResource(TrackDef(\recgrid))

FileSystemProject.load("libdef/CustomTrackList.scd");
TrackDef(\recgrid, TrackTemplateDef(\CustomTrackList))
TrackDef(\recgrid).edit
SampleTimeline('recgrid.0.1score').label = "first snare"

(
SynthDef(\freecorde, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.01, spread=1;
	var sig;
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * ( SinOsc.ar(freq*\fmr.kr(1.2)) * \fmamp.kr(1) + 1 )) * ( SinOsc.ar(freq * \amr.kr(0.2)) * \amamp.kr(1) + 1 );
	sig = sig * 0.9;
	sig = SelectX.ar( LFNoise1.ar((1..8)/12).range(0,1), sig  );
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pbind(
			\instrument, \freecorde,
			\note, Pseq([
				Pser([
					0,1,-1
				],16),
			],inf),
			\octave, 6,
			\fspread, 1/Pkey(\freq) * Pseq([1,1.2,4,8],inf).stutter(8),
			\amr, 1.01,
			\fmr, 1.4,
			\fmr, ~pmodenv.(Pseq([1,1.002,1.1,7.4,1.04]+0.7,inf), 2),
			\amamp,1,
			\dur, 1/8,
			\isRest, Pseq([
				1,1,1,0, 1,1,1,0,
				1,1,0,1, 1,1,0,1,
				1,1,1,0, 1,1,1,0,
				1,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1/8,
			\out, BusDef(\sendbus4, \audio),
			//\lag, 0.04,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave50_mainTimeline_t0_220921_222144').buffer,
			\legato, 1,
			\dur, 4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave50_mainTimeline_t1_220921_222144').buffer,
			\legato, 1,
			\dur, 4,
			\gain, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave50_mainTimeline_t0_220921_222144').buffer,
			\legato, 1,
			\dur, 4,
			\gain, 1,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_cave50_mainTimeline_t1_220921_222144').buffer,
			\legato, 1,
			\dur, 4,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, BufDef('loop/pigs.flac'),
			\bufnum, SampleTimeline('rec_cave50_mainTimeline_t0_220921_222144').buffer,
			\legato, 1,
			\st, ~t,
			\speed, ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			],1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1,
		)
		
	])
)).play;
);

Pspawner
