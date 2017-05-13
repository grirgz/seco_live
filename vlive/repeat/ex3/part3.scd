
(
// init
	s.waitForBoot {
		
		~t = 215/4/60;
		TempoClock.default.tempo = ~t;
		Ndef.defaultQuant = 4;
		Pdef.defaultQuant = 4;
		
		FileSystemProject.load("ex3/lib.scd");
		FileSystemProject.load("ex3/part2_pdefs.scd");
	};
)
(
TrackDef(\part3, TrackDef(\playergrid)).source = [
	8.collect { arg x; KitTimeline(\part3_perc+++x, PatKitDef(\part3)); },
	8.collect { arg x; NoteTimeline(\part3_bass+++x, Param(Pdef(\part2_bass), \midinote)); },
	8.collect { arg x; NoteTimeline(\part3_bass_b+++x, Param(Pdef(\part2_bass), \midinote)); },
];
TrackDef(\part3).resources = [
	PatKitDef(\part3),
	PatKitDef(\part3_b),
];

TrackDef(\part3_fx, TrackDef(\playergrid)).source = [
	[
		ProtoDef(\part3_rdn, ProtoTemplateDef(\rdn))
	],
	[
		ProtoDef(\part3_rdn2, ProtoTemplateDef(\rdn))
	],
	[
		Ndef(\vardelay),
		Ndef(\vardelaydist),
	],

];
TrackDef(\part3).initFromPresetDir("ex3/part3_data/");
TrackDef(\part3_fx).initFromPresetDir("ex3/part3_data/");

)

WindowDef(\multigrid).front;


KitTimeline(\part3_perc0).target = PatKitDef(\part3)
KitTimeline(\part3_perc0).target 
KitTimeline(\part3_perc0).edit
KitTimeline(\part3_perc0).clear
KitTimeline(\part3_perc0, PatKitDef(\part3)).edit
PatKitDef(\part3).edit
WindowDef(\PdefEditor).front(Pdef(\part2_bass))

(
/////////// saving!
TrackDef(\part3).savePresetCompileString;
TrackDef(\part3_fx).savePresetCompileString;
)

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * (1..100)/10).mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	Pdef(\plop, 

		Ppar(

		8.collect({ arg x; 
			Pbind(
				\instrument, \default,
				\degree, Pseq([x,x-2,x+2,x-4],inf),
				\octave, 4,
				\sustain, 0.3,
				\dur, (x/Pseq([8,2],inf))+1,
				//\lag, 0.1*( x/10 ),
				\amp, 0.1
			)

		})
		)
	).play;
);
