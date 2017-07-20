
KitTimeline(\flow2, PatKitDef(\algokit)).edit
KitTimeline(\flow2p2, PatKitDef(\algokit)).edit
KitTimeline(\flow2heavy, PatKitDef(\sample1)).edit
KitTimeline(\flow2heavy, PatKitDef(\sample1)).presetCompileString.editorInsert
(
KitTimeline(\flow2heavy, PatKitDef(\sample1));
KitTimeline('flow2heavy').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 0.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 0.25, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 0.25, \dur: 0.0, \kitIndex: 12.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 0.75, \dur: 0.25, \kitIndex: 8.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.125, \kitIndex: 1.0, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 1.125, \dur: 0.375, \kitIndex: 8.0, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 1.5, \dur: 0.25, \kitIndex: 4.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.0, \kitIndex: 8.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.1, ),
	(\absTime: 1.75, \dur: 0.0, \kitIndex: 14.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 1.75, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 2.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.125, ),
	(\absTime: 2.0, \dur: 0.5, \kitIndex: 12.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 2.5, \dur: 0.0, \kitIndex: 4.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 2.5, \dur: 0.25, \kitIndex: 14.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.75, \dur: 0.25, \kitIndex: 14.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.125, ),
	(\absTime: 3.0, \dur: 0.0, \kitIndex: 1.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 3.0, \dur: 0.25, \kitIndex: 12.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.5, ),
	(\absTime: 3.25, \dur: 0.25, \kitIndex: 1.0, \midinote: 0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 3.5, \dur: 0.0, \kitIndex: 4.0, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 3.5, \dur: 0.5, \kitIndex: 14.0, \midinote: 0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 4, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


(
Pdef(\drums, 
	Pseq([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 9,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 0,1,1,1,
					].clump(4).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.05,
					\dur, 1/16,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 10,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 0,1,1,1,
					].clump(4).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\dur, 1/16,
					\amp, 0.1
				),
			]),
		)
		
	])
).play;
)

(
TrackDef(\flow2, TrackDef(\playergrid));
TrackDef(\flow2).source = [
	[
		ProtoDef(\flow2rdn, ProtoTemplateDef(\rdn)),
	],
	[
		ProtoDef(\flow2rdn2, ProtoTemplateDef(\rdn)),
	],
	[
		KitTimeline(\flow2heavy),
	],
	[
		Pdef(\drums),
	],
	[
		Pdef(\bass),
	],
];
);

//TrackDef(\flow2).edit;
WindowDef(\multigrid).front;

(
Pdef(\drums, 
	Pseq([
		
		PatKitDef(\sample1).asPattern(
			Ppar([

				Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,0,0, 0,0,0,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // small kick
					\kitIndex, 0,
					\isRest, Pseq({[
						0,0,1,0, 0,0,0,0, 
						0,0,0,0, 0,0,0,1, 
						0,0,0,0, 0,1,0,0, 
						0,0,0,0, 0,0,0,0, 
				//		0,0,0,0, 0,0,0,0, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\pos, 0.04+0.04,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 12,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						1,1,0,0, 0,0,0,0, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.5,
					\dur, 1/4,
					\amp, 0.1
				),
				Pbind( // small bass guitar
					\kitIndex, 12,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						1,1,0,0, 0,0,0,0, 
						1,0,1,0, 1,0,1,0, 
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
						1,0,1,0, 0,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\gain, Pseq([
						0.3,0.5,1,0.5,
					],inf),
					\sustain, 0.1,
					\dur, 1/16,
					\amp, 0.1
				),
				Pbind( // contre temps
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 0,0,1,0, 
						0,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						0,1,0,0, 0,0,0,0, 
						0,0,1,0, 0,0,0,0, 
						0,0,0,0, 0,1,0,0, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\pos, 0.04+0.1,
					\sustain, 0.081,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 14,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,1,0, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.4,
					\dur, 1/4,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 10,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 0,1,1,1,
					].clump(4).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\dur, 1/16,
					\amp, 0.1
				),
			]),
		)
	])
).play;
)

(
Pdef(\drums, 
	Pseq([
		
		PatKitDef(\sample1).asPattern(
			Ppar([

				Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,0,0, 0,0,0,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // snare
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // bass guitar
					\kitIndex, 12,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.4,
					\dur, 1/4,
					\amp, 0.1
				),
				Pbind( // treb guitar
					\kitIndex, 14,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0, 
						0,0,0,0, 1,0,1,0, 
						0,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,1,0, 
						0,0,0,0, 0,0,0,1, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.4,
					\dur, 1/4,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 10,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 0,1,1,1,
					].clump(4).choose.dup(2)}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\dur, 1/16,
					\gain, Pseq([
						1,0.5,
						0.3,0.5,
					],inf)*0.9,
					\sustain, Pseq([0.02,0.02,0.08,0.02]/2,inf),
					\amp, 0.1
				),
			]),
		)
	])
).play;
)




(
	// intro seq
Pdef(\drums, 

		Plazy({
			var plist = [

					Pbind( // kick 1
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,1,0,
							1,0,0,1, 0,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 0,0,0,1,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, 0.1,
						\dur, 1/8,
						\amp, 0.1
					),
					Pbind( // snare
						\kitIndex, 4,
						\isRest, Pseq({[
							0,0,0,0, 1,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
						\dur, 1/8,
						\amp, 0.1
					),
					Pbind( // bass guitar
						\kitIndex, 12,
						\isRest, Pseq({[
							1,0,0,0, 0,0,0,0, 
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, 0.4,
						\dur, 1/4,
						\amp, 0.1
					),
					Pbind( // treb guitar
						\kitIndex, 14,
						\isRest, Pseq({[
							0,0,0,0, 1,0,0,0, 
							0,0,0,0, 1,0,1,0, 
							0,0,0,0, 0,0,0,0, 
							0,0,0,0, 0,0,1,0, 
							0,0,0,0, 0,0,0,1, 
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\sustain, 0.4,
						\dur, 1/4,
						\amp, 0.1
					),
					Pbind(
						\kitIndex, 10,
						\isRest, Pseq({[
							1,0,1,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							1,0,1,0, 1,0,1,0,
							1,1,1,1, 0,1,1,1,
						].clump(4).choose.dup(2)}.dup(8).flat,inf).coin.not,
						\freq, 200,
						\dur, 1/16,
						\gain, Pseq([
							1,0.5,
							0.3,0.5,
						],inf)*0.9,
						\sustain, Pseq([0.02,0.02,0.08,0.02]/2,inf),
						\amp, 0.1
					),
			];


			PatKitDef(\sample1).asPattern(
				Pseq([
					Pfindur(2*3,
						Ppar([
							plist[0],
							plist[1],
							//plist[2],
						]),
					),
					Pfindur(2*1 - (0.5),
						Ppar([
							plist[0],
							plist[1],
							plist[2],
							plist[3],
							plist[4],
						]),
					),
					Rest(0.5),
					Pfindur(2*4,
						Ppar([
							plist[0],
							plist[1],
							plist[2],
							plist[3],
							plist[4],
						]),
					),
				],inf)
			);
		})
).play;
)

Pdef(\drums).clear
Pdef(\drums).set(\out, BusDef(\fbfx))
Pdef(\drums).set(\out, 0)

(
SynthDef(\dbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1= EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = LFSaw.ar(freq * [1,1.00001] *.t [1,1/2]).flop.mean;
	sig = RLPF.ar(sig, \lpfr.kr(4) * env1 * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.21,0.4,0.8,0.1, 0.2),gate,doneAction:2);
	sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, Pbind(
	\instrument, \dbass,
	\degree, Pseq([1],inf),
	\octave, 3,
	\isRest, Pseq([
		1,0
	],inf).coin.not,
	\dur, 1,
	\amp, 0.8
)).play;
)
(
Pdef(\bass, Pbind(
	\instrument, \dbass,
	\degree, Pstep(Pseq([1,1,1,0],inf),1),
	\octave, 3,
	\isRest, Pseq([
		1,0
	],inf).coin.not,
	\dur, PdurStutter(Pseq([8,8,4,4, 2,2,3,4],inf), 1),
	\amp, 0.8
)).play;
);

(
	// no kick snare
Pdef(\drums, 
	Pseq([
		
		PatKitDef(\sample1).asPattern(
			Ppar([

				Pbind(
					\kitIndex, 12,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						1,1,0,0, 0,0,0,0, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.5,
					\dur, 1/4,
					\amp, 0.1
				),
				Pbind( // small bass guitar
					\kitIndex, 12,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						1,1,0,0, 0,0,0,0, 
						1,0,1,0, 1,0,1,0, 
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 0,0,0,0,
						0,0,0,0, 1,1,1,1,
						1,0,1,0, 0,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\gain, Pseq([
						0.3,0.5,1,0.5,
					],inf),
					\sustain, 0.1,
					\dur, 1/16,
					\amp, 0.1
				),
				Pbind( // contre temps
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 0,0,1,0, 
						0,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						0,1,0,0, 0,0,0,0, 
						0,0,1,0, 0,0,0,0, 
						0,0,0,0, 0,1,0,0, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\pos, 0.04+0.1,
					\sustain, 0.081,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 14,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0, 
						0,0,0,0, 0,0,0,0, 
						0,0,0,0, 0,0,1,0, 
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.4,
					\dur, 1/4,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 10,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 0,1,1,1,
					].clump(4).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\dur, 1/16,
					\amp, 0.1
				),
			]),
		)
	])
).play;
)

(
	// kick snare
Pdef(\drums, 
	Pseq([
		
		PatKitDef(\sample1).asPattern(
			Ppar([

				Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,0,0, 0,0,0,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // snare
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
					\dur, 1/8,
					\amp, 0.1
				),
			]),
		)
	])
).play;
)

(
	// kick snare hat
Pdef(\drums, 
	Pseq([
		
		PatKitDef(\sample1).asPattern(
			Ppar([

				Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
						1,0,0,0, 0,0,0,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // snare
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 9,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 0,1,1,1,
					].clump(4).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.05,
					\dur, 1/16,
					//\gain, 1,
					\amp, 0.1
				),
			]),
		)
	])
).play;
)

(
	// calm kick snare hat
Pdef(\drums, 
	Pseq([
		
		PatKitDef(\sample1).asPattern(
			Ppar([

				Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // snare
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
						0,1,0,0, 1,0,0,0,
						0,0,0,0, 1,0,1,0,
						0,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, Pseq({Pseq([rrand(0.1,0.02),rrand(0.45,0.2)],1) }!8,inf).stutter(8),
					\dur, 1/8,
					\gain, 0.7,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 9,
					\isRest, Pseq({[
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 0,1,1,1,
					].clump(4).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.05,
					\dur, 1/16,
					//\gain, 1,
					\gain, 0.1* Pseq([
						Pseq({[
							1,1,1,0.7,
							1,0.8,0.8,0.8,
							0.8,0.8,1,0.8,
							0.8,0.2,1,0.2,
							1,0.8,1,0.8,
						].clump(4).choose}.dup(16).flat,inf)
					],1),
					\amp, 0.1
				),
			]),
		)
	])
).play;
)

(
	// slow snare hat
Pdef(\drums, 
	Pseq([
		
		PatKitDef(\sample1).asPattern(
			Ppar([

				Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					].clump(16).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 2.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // kick 2
					\kitIndex, 0,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,0,
						0,0,1,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,1,0,
					].clump(16).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // snare
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0,
					].clump(16).choose}.dup(8).flat,inf).coin.not,
					\freq, 200,
					\sustain, Pseq({rrand(0.45,0.2)}!8,inf).stutter(8),
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 9,
					\isRest, Pseq({[
						0,0,0,0, 0,0,1,0,
						1,0,0,0, 0,0,0,0,
						1,0,1,0, 0,0,0,0,
						1,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,1,1,1, 0,1,1,1,
					].clump(4).choose}.dup(16).flat,inf).coin.not,
					\freq, 200,
					\sustain, 0.05,
					\dur, 1/16,
					\gain, 1,
					\amp, 0.1
				),
			]),
		)
	])
).play;
)

(
Ndef(\echo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig1 = DelayC.ar(sig, 4/~t, \delay.kr(1/4/~t)) + sig;
	sig = SelectX.ar(\mix.kr(1).lag(0.1), [sig, sig1]);
}).play;
Ndef(\echo).set(\inbus, BusDef(\sendbus1, \audio))
);

Ndef(\echo).unset(\delay, rrand(0.01,1))
(
Ndef(\echo).put(100, \set -> Pbind(
	\delay, Pwhite(0.1,1/4/~t).stutter(4),
	\mix, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 1,1,1,1,
	],inf),
	\dur, 1/2,
))
)

(
	// kick snare hat end
Pdef(\drums, 
	Pseq([
		
		PatKitDef(\sample1).asPattern(
			Ppar([

				Pbind( // kick 1
					\kitIndex, 0,
					\isRest, 
					Place([
						Pseq({[
							1,0,1,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 0,0,1,0,
							1,0,0,1, 0,0,0,0,
							1,0,0,1, 0,0,1,0,
							1,0,0,0, 0,0,0,1,
						].clump(8).choose}.dup(6).flat,1).coin.not,
						4.collect  {
							Pseq({[
								1,0,0,1, 0,1,1,0,
								1,1,1,1, 0,0,0,0,
								1,0,1,0, 1,1,0,0,
								0,0,0,0, 0,0,1,0,
								0,0,0,0, 1,1,1,0,
							].clump(8).choose}.dup(2).flat,1).coin.not;
						}
					],inf),
					\freq, 200,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind( // snare
					\kitIndex, 4,
					\isRest, 
					Place([
						Pseq({[
							0,0,0,0, 1,0,0,0,
						].clump(8).choose}.dup(6).flat,1).coin.not,
						4.collect  {
							Pseq({[
								0,0,0,0, 0,0,0,0,
								0,1,0,0, 0,0,0,0,
								0,0,0,0, 0,0,1,0,
								0,1,0,0, 1,0,1,0,
							].clump(8).choose}.dup(2).flat,1).coin.not;
						},
					],inf),
					\freq, 200,
					\sustain, Pseq({rrand(0.05,0.2)}!8,inf).stutter(8),
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 9,
					\isRest, 
					Place([
						Pseq({[
							1,0,1,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							1,0,1,0, 1,0,1,0,
							1,1,1,1, 0,1,1,1,
						].clump(4).choose}.dup(6).flat,1).coin.not.repeat(2),
						4.collect{
							Pseq({[
								1,1,1,0, 1,1,0,0,
								1,1,1,1, 0,1,1,1,
								0,0,0,0, 0,0,0,0,
								1,1,1,1, 0,0,0,0,
							].clump(8).choose}.dup(2).flat,1).coin.not;
						}
					],inf),
					\freq, 200,
					\sustain, 0.05,
					\dur, 1/16,
					//\gain, 1,
					\amp, 0.1
				),
			]),
		)
	])
).play;
)
