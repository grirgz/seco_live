
~t = 160/4/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[909].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,

				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1064,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[456].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1848].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
Pdef(\part3, Pdef(\drumloop1, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\speed, 1/2 * (~t/( 92.15/4/60 )),
			\pos, Pseq([
				0,0,
				0,0,
				0,0,
				0,1.5,
			],inf)/( 92.20/4/60 ),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
)

(
Pdef(\melo1, 
	Pbind(
		\instrument, \corniaud,
		\fmamt, ~pmodenv.(Pseq([0,1],inf), 8),
	)
);
);
ProtoDef(\piano).startControl(Pdef(\melo, Pbind(\instrument, \corniaudouble4, \amp, 0.6,
	\fmamt, 0.2,
	\adsr, Pseq([
		[ Env.adsr(0.01,0.1,0.8,0.1) ],
	],inf),

)))

ClipTimeline('vin35_mainTimeline').clear
SampleTimeline('rec_vin35_mainTimeline_t0_201111_160559').clear

FileSystemProject.current.mainTimeline.eventList[1].out = nil
FileSystemProject.current.mainTimeline.eventList[1][\out]
FileSystemProject.current.mainTimeline.eventList[1].parent.parent.out

FileSystemProject.current.mainTimeline.presetCompileString.editorInsert
(
ClipTimeline('vin35_mainTimeline').tracks = [ ( 'index': 0, 'recordArmed': true, 'recordBus': BusDef('mixer0'), 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('vin35_mainTimeline').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.0, \dur: 8.0, \midinote: 0, \playDur: 8.0, \relDur: 8.0, \sustain: 8.0, \timeline: { SampleTimeline('rec_vin35_mainTimeline_t0_201111_160559') }, \type: 'pattern', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;
ClipTimeline('vin35_mainTimeline').recordedEvents = [ PatternEvent((playDur: 8.0, dur: 8.0, sustain: 4.0, midinote: 0, timeline: { SampleTimeline('rec_vin35_mainTimeline_t0_201111_160534') }, relDur: 8.0, type: 'pattern', absTime: 0.0)), PatternEvent((playDur: 8.0, dur: 8.0, sustain: 8.0, midinote: 0, timeline: { SampleTimeline('rec_vin35_mainTimeline_t0_201111_160559') }, relDur: 8.0, type: 'pattern', absTime: 0.0)) ];

SampleTimeline('rec_vin35_mainTimeline_t0_201111_160559').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 8.0, \label: 'start', \playDur: 8.0, \relDur: 8.0, \sustain: 0, \type: 'start', ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
SampleTimeline('rec_vin35_mainTimeline_t0_201111_160559').buffer = BufDef('./rec_vin35_mainTimeline_t0_201111_160559.wav');


);


NoteTimeline(\vin35_melo2, Pdef(\melo)).edit
NoteTimeline(\vin35_melo2, Pdef(\melo)).presetCompileString.editorInsert
(
NoteTimeline('vin35_melo2').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28248.133142429, \dur: 0.0, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.14203486266706, ),
	(\absTime: 0.0, \dur: 0.5, \label: 'start', \playDur: 0.5, \relDur: 0.5, \sustain: 0, \type: 'start', ),
	(\absTime: 0.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28248.578837946, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17269753399887, ),
	(\absTime: 0.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28248.817633529, \dur: 0.5, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.18766464799774, ),
	(\absTime: 1.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28249.304919107, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16387750799549, ),
	(\absTime: 1.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28249.556276133, \dur: 0.5, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.17890857599559, ),
	(\absTime: 2.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28250.082522104, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.24544689133472, ),
	(\absTime: 2.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28250.33952576, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15398479932992, ),
	(\absTime: 2.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28250.577368992, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16850287399939, ),
	(\absTime: 2.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28250.820866896, \dur: 0.375, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.13948130666904, ),
	(\absTime: 3.125, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28251.291464785, \dur: 0.0, \instrument: 'corniaudouble3', \kitIndex: 91, \midinote: 91, \playDur: 0.0, \relDur: 0.0, \sustain: 0.12783910666622, ),
	(\absTime: 3.125, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28251.384103996, \dur: 0.375, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93, \playDur: 0.375, \relDur: 0.375, \sustain: 0.16243403466797, ),
	(\absTime: 3.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28251.625630124, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14985946933666, ),
	(\absTime: 3.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28251.841593377, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12079957466631, ),
	(\absTime: 4.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28252.089329175, \dur: 0.5, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.16742210533266, ),
	(\absTime: 4.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28252.566646772, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.29873824400056, ),
	(\absTime: 4.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28252.849551421, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17478622066847, ),
	(\absTime: 5.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28253.092609076, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.13172097533243, ),
	(\absTime: 5.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28253.31117717, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16432927532878, ),
	(\absTime: 5.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28253.577548205, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1758211873348, ),
	(\absTime: 5.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28253.823638812, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.15289831799964, ),
	(\absTime: 6.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28254.11499377, \dur: 0.0, \instrument: 'corniaudouble3', \kitIndex: 100, \midinote: 100.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.035280113337649, ),
	(\absTime: 6.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28254.104049321, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12457024066316, ),
	(\absTime: 6.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28254.332272849, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.13080370932948, ),
	(\absTime: 6.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28254.582445082, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12436578666529, ),
	(\absTime: 6.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28254.823342588, \dur: 0.5, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.39406782733568, ),
	(\absTime: 7.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28255.238347066, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.21388469133308, ),
	(\absTime: 7.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28255.574159304, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.16952247133304, ),
	(\absTime: 7.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28255.804611608, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17064825533089, ),
	(\absTime: 8.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28256.07987733, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14043717333698, ),
	(\absTime: 8.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28256.596160292, \dur: 0.375, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.14305618866638, ),
	(\absTime: 8.625, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28256.956153074, \dur: 0.125, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.14543251400028, ),
	(\absTime: 8.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28257.051837178, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1717984466668, ),
	(\absTime: 9.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28257.310015658, \dur: 0.5, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.16433775199766, ),
	(\absTime: 9.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28257.787342428, \dur: 0.0, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.13009771200086, ),
	(\absTime: 9.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28257.860792822, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14159126666709, ),
	(\absTime: 9.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28258.100736277, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.14884391133455, ),
	(\absTime: 10.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28258.33125768, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.13885713333366, ),
	(\absTime: 10.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28258.567420395, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.12898437799959, ),
	(\absTime: 10.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28258.827578078, \dur: 0.375, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.18143993066769, ),
	(\absTime: 10.875, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28259.21982107, \dur: 0.0, \instrument: 'corniaudouble3', \kitIndex: 89, \midinote: 89.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.018914265336207, ),
	(\absTime: 10.875, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28259.196810454, \dur: 0.125, \instrument: 'corniaudouble3', \kitIndex: 91, \midinote: 91.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.10024293266542, ),
	(\absTime: 11.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28259.265981371, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25059563533068, ),
	(\absTime: 11.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28259.546520119, \dur: 0.0, \instrument: 'corniaudouble3', \kitIndex: 95, \midinote: 95.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.10143770733703, ),
	(\absTime: 11.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28259.542732658, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.11375543933536, ),
	(\absTime: 11.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28259.801545647, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1612591106641, ),
	(\absTime: 11.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28260.081941829, \dur: 0.5, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.11133051533034, ),
	(\absTime: 12.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28260.520294844, \dur: 0.0, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.11587398399934, ),
	(\absTime: 12.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28260.579157565, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.17175946066345, ),
	(\absTime: 12.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28260.859111593, \dur: 0.5, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.18826516199988, ),
	(\absTime: 13.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28261.28668343, \dur: 0.375, \instrument: 'corniaudouble3', \kitIndex: 101, \midinote: 101.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.18720647933151, ),
	(\absTime: 13.375, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28261.711431628, \dur: 0.0, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.24483279999549, ),
	(\absTime: 13.375, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28261.683417226, \dur: 0.375, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.10679628399885, ),
	(\absTime: 13.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28262.048830034, \dur: 0.375, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.17850447467208, ),
	(\absTime: 14.125, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28262.487710102, \dur: 0.125, \instrument: 'corniaudouble3', \kitIndex: 105, \midinote: 105.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.12841216866946, ),
	(\absTime: 14.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28262.5488476, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 103, \midinote: 103.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.134167654669, ),
	(\absTime: 14.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28262.828738009, \dur: 0.5, \instrument: 'corniaudouble3', \kitIndex: 101, \midinote: 101.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.37690852533342, ),
	(\absTime: 15.0, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28263.32163932, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.32094625266836, ),
	(\absTime: 15.25, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28263.60925362, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.2335074753355, ),
	(\absTime: 15.5, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28263.813220538, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1440940686698, ),
	(\absTime: 15.75, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28264.094204707, \dur: 0.25, \instrument: 'corniaudouble3', \kitIndex: 91, \midinote: 91.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.24531246333572, ),
	(\absTime: 16.0, \dur: 0.11009238568658, \label: 'end', \playDur: 0.11009238568658, \relDur: 0.11009238568658, \type: 'end', ),
	(\absTime: 16.110092385687, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28264.310092386, \dur: 0.25042553533058, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93, \playDur: 0.25042553533058, \relDur: 0.25042553533058, \sustain: 0.23256232866333, ),
	(\absTime: 16.360517921017, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28264.560517921, \dur: 0.037291409331374, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.037291409331374, \relDur: 0.037291409331374, \sustain: 0.14134834799916, ),
	(\absTime: 16.397809330349, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28264.59780933, \dur: 0.2131308106691, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98, \playDur: 0.2131308106691, \relDur: 0.2131308106691, \sustain: 0.033351866670273, ),
	(\absTime: 16.610940141018, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28264.810940141, \dur: 0.26944678533255, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98, \playDur: 0.26944678533255, \relDur: 0.26944678533255, \sustain: 0.21270128866672, ),
	(\absTime: 16.88038692635, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28265.080386926, \dur: 0.418109197999, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.418109197999, \relDur: 0.418109197999, \sustain: 0.13890390266897, ),
	(\absTime: 17.298496124349, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28265.498496124, \dur: 0.06121016133693, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93, \playDur: 0.06121016133693, \relDur: 0.06121016133693, \sustain: 0.13492618133387, ),
	(\absTime: 17.359706285686, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28265.559706286, \dur: 0.27298787133259, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.27298787133259, \relDur: 0.27298787133259, \sustain: 0.22664600666394, ),
	(\absTime: 17.632694157019, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28265.832694157, \dur: 0.25602130933476, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98, \playDur: 0.25602130933476, \relDur: 0.25602130933476, \sustain: 0.22262636599771, ),
	(\absTime: 17.888715466353, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28266.088715466, \dur: 0.23724572200081, \instrument: 'corniaudouble3', \kitIndex: 91, \midinote: 91, \playDur: 0.23724572200081, \relDur: 0.23724572200081, \sustain: 0.16590982532944, ),
	(\absTime: 18.125961188354, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28266.325961188, \dur: 0.24249273799796, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93, \playDur: 0.24249273799796, \relDur: 0.24249273799796, \sustain: 0.16543315466333, ),
	(\absTime: 18.368453926352, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28266.568453926, \dur: 0.27010175532996, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98, \playDur: 0.27010175532996, \relDur: 0.27010175532996, \sustain: 0.13851802133286, ),
	(\absTime: 18.638555681682, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28266.838555682, \dur: 0.47111528000096, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.47111528000096, \relDur: 0.47111528000096, \sustain: 0.19186503600213, ),
	(\absTime: 19.109670961683, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28267.309670962, \dur: 0.12498684733509, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.12498684733509, \relDur: 0.12498684733509, \sustain: 0.085931142664776, ),
	(\absTime: 19.234657809018, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28267.434657809, \dur: 0.22011244199894, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.22011244199894, \relDur: 0.22011244199894, \sustain: 0.10408050999831, ),
	(\absTime: 19.454770251017, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28267.654770251, \dur: 0.21422890599933, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.21422890599933, \relDur: 0.21422890599933, \sustain: 0.25958288533366, ),
	(\absTime: 19.668999157017, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28267.868999157, \dur: 0.20906168133661, \instrument: 'corniaudouble3', \kitIndex: 91, \midinote: 91, \playDur: 0.20906168133661, \relDur: 0.20906168133661, \sustain: 0.25922370600165, ),
	(\absTime: 19.878060838353, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28268.078060838, \dur: 0.25364492932931, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93, \playDur: 0.25364492932931, \relDur: 0.25364492932931, \sustain: 0.23327467866693, ),
	(\absTime: 20.131705767682, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28268.331705768, \dur: 0.24708261666819, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.24708261666819, \relDur: 0.24708261666819, \sustain: 0.14818949333494, ),
	(\absTime: 20.378788384351, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28268.578788384, \dur: 0.27002463533427, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98, \playDur: 0.27002463533427, \relDur: 0.27002463533427, \sustain: 0.1961211153357, ),
	(\absTime: 20.648813019685, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28268.84881302, \dur: 0.2258183399972, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.2258183399972, \relDur: 0.2258183399972, \sustain: 0.14409107999745, ),
	(\absTime: 20.874631359682, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28269.07463136, \dur: 0.045595689334732, \instrument: 'corniaudouble3', \kitIndex: 91, \midinote: 91, \playDur: 0.045595689334732, \relDur: 0.045595689334732, \sustain: 0.11247484266642, ),
	(\absTime: 20.920227049017, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28269.120227049, \dur: 0.21672229799879, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93, \playDur: 0.21672229799879, \relDur: 0.21672229799879, \sustain: 0.25283556600334, ),
	(\absTime: 21.136949347016, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28269.336949347, \dur: 0.42452281200531, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.42452281200531, \relDur: 0.42452281200531, \sustain: 0.15518059933311, ),
	(\absTime: 21.561472159021, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28269.761472159, \dur: 0.075496247998672, \instrument: 'corniaudouble3', \kitIndex: 93, \midinote: 93, \playDur: 0.075496247998672, \relDur: 0.075496247998672, \sustain: 0.12091226999837, ),
	(\absTime: 21.63696840702, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28269.836968407, \dur: 0.22599796199938, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.22599796199938, \relDur: 0.22599796199938, \sustain: 0.13548601532966, ),
	(\absTime: 21.862966369019, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28270.062966369, \dur: 0.23735021133325, \instrument: 'corniaudouble3', \kitIndex: 98, \midinote: 98, \playDur: 0.23735021133325, \relDur: 0.23735021133325, \sustain: 0.1831257486665, ),
	(\absTime: 22.100316580352, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28270.30031658, \dur: 0.2803661493308, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.2803661493308, \relDur: 0.2803661493308, \sustain: 0.15293867733271, ),
	(\absTime: 22.380682729683, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28270.58068273, \dur: 0.27416582066508, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.27416582066508, \relDur: 0.27416582066508, \sustain: 0.15392077533397, ),
	(\absTime: 22.654848550348, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28270.85484855, \dur: 0.47574195133348, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.47574195133348, \relDur: 0.47574195133348, \sustain: 0.36441597000157, ),
	(\absTime: 23.130590501682, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28271.330590502, \dur: 0.28623998133844, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0.28623998133844, \relDur: 0.28623998133844, \sustain: 0.1351680440057, ),
	(\absTime: 23.41683048302, \adsr: [ Env([ 0.0, 1.0, 0.8, 0.0 ], [ 0.01, 0.1, 0.1 ], -4.0, 2) ], \amp: 0.3, \clockTime: 28271.616830483, \dur: 0, \instrument: 'corniaudouble3', \kitIndex: 96, \midinote: 96, \playDur: 0, \relDur: 0, \sustain: 0.17095801266623, ),
]);
);


NoteTimeline(\vin35_melo1, Pdef(\melo1)).edit
NoteTimeline(\vin35_melo1).eventList.do({ arg x; x[\instrument] = \corniaudouble2 })
NoteTimeline(\vin35_melo1).presetCompileString.editorInsert
NoteTimeline(\vin35_melo1).clear
NoteTimeline(\vin35_melo1).composeParamPattern = true
(
NoteTimeline('vin35_melo1').eventList = TimelineEventList.newFrom([
	(\absTime: -0.12191611498201, \clockTime: 24842.078083885, \dur: 0.12191611498201, \instrument: 'corniaudouble2', \kitIndex: 89, \midinote: 77, \playDur: 0.12191611498201, \relDur: 0.12191611498201, \sustain: 1.9782156360016, ),
	(\absTime: 0.0, \dur: 2.0, \instrument: 'corniaudouble2', \label: 'start', \playDur: 2.0, \relDur: 2.0, \sustain: 0, \type: 'start', ),
	(\absTime: 2.0, \clockTime: 24844.090155181, \dur: 1.25, \instrument: 'corniaudouble2', \kitIndex: 84, \midinote: 72.0, \playDur: 1.25, \relDur: 1.25, \sustain: 1.3730615826717, ),
	(\absTime: 3.25, \clockTime: 24845.411508919, \dur: 0.25, \instrument: 'corniaudouble2', \kitIndex: 96, \midinote: 84.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.26750343933236, ),
	(\absTime: 3.5, \clockTime: 24845.619134799, \dur: 0.5, \instrument: 'corniaudouble2', \kitIndex: 97, \midinote: 85.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.444056854667, ),
	(\absTime: 4.0, \clockTime: 24846.11686304, \dur: 2.0, \instrument: 'corniaudouble2', \kitIndex: 89, \midinote: 77.0, \playDur: 2.0, \relDur: 2.0, \sustain: 1.8966720326607, ),
	(\absTime: 6.0, \clockTime: 24848.107192313, \dur: 1.25, \instrument: 'corniaudouble2', \kitIndex: 84, \midinote: 72.0, \playDur: 1.25, \relDur: 1.25, \sustain: 1.2774527360016, ),
	(\absTime: 7.25, \clockTime: 24849.334448576, \dur: 0.25, \instrument: 'corniaudouble2', \kitIndex: 100, \midinote: 88.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.28235915333062, ),
	(\absTime: 7.5, \clockTime: 24849.56128645, \dur: 0.25, \instrument: 'corniaudouble2', \kitIndex: 99, \midinote: 87.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.32047023266568, ),
	(\absTime: 7.75, \clockTime: 24849.808947718, \dur: 0.25, \instrument: 'corniaudouble2', \kitIndex: 97, \midinote: 85.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.23618235399772, ),
	(\absTime: 8.0, \dur: 0, \instrument: 'corniaudouble2', \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);




ProtoDef(\piano).startControl(Pdef(\melo, Pbind(\instrument, \corniaud)))


// tempo of loveyoumore
4 * 3 / 7.67 * 60 // = 93.87222946545

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/loveyoumore.flac'),
			\legato, 1,
			\pos, Pseq([0,1],inf) / (93.8722 / 2 / 60 ),
			\speed, 1/2 * ~t/(93.8722 / 4 / 60 ),
			\dur, 2,
			\gain, 1,
		)
		
	])
)).play;
);
4*3 / BufDef('loop/loveyoumore.flac').numFrames / BufDef('loop/loveyoumore.flac').sampleRate
