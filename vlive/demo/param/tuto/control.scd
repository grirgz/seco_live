
(
SynthDef(\tuto_synthdef, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, freq * \lpfratio.kr(2), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\tuto2_synthdef, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(sig, freq * \lpfratio.kr(2), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pdef(\tuto, Pbind(
	\instrument, \tuto_synthdef,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
));

Pdef(\tuto2, Pbind(
	\instrument, \tuto2_synthdef,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
));
);

//////////////////////////////////////////////// Param

FileSystemProject.load("ex3/lib.scd");

///////////// GUI

(
WindowDef(\PdefEditor, { arg me, target;
	VLayout(
		PlayerWrapper(target).asView,
		ParamGroupLayout.two_panes(target.asParamGroup),
	);
});
)

WindowDef(\PdefEditor).front(Pdef(\tuto));

///////////// Control

(
KtlCenter(\nano_faders, \ParamGroup, { arg def, group
	Ktl(\nano).elAt(\faders).do { arg fader, idx; fader.mapParam(group[idx]) };
});
)

KtlCenter(\nano_faders).startControl(Pdef(\tuto).asParamGroup)

///////////// Record

ParamTimeline(\tuto_lpf, Param(Pdef(\tuto), \lpfratio)).edit
Param(Pdef(\tuto), \lpfratio).setBusMode



///////////////////////////////////////////////////// Piano

NotePlayer(\piano, Pdef(\tuto));

NoteTimeline(\piano, Param(Pdef(\tuto), \midinote));

////////// GUI
(
WindowDef(\PianoEditor, { arg me, target;
	VLayout(
		PianoKeyboardView.new(target),
		VLayout(
			* target.collect({ arg note;
				note.asView;
			});
		);
	)
});
)

WindowDef(\PianoEditor).front(NotePlayer(\piano));
NoteTimeline(\piano).edit;

////////// Control

(
KtlCenter(\apro_piano, \NotePlayer, { arg def, group
	Ktl(\nano).elAt(\keys).do { arg but, idx; 
		but.elAt(\on).action = { group.childAt(idx).play } ;
		but.elAt(\off).action = { group.childAt(idx).stop } ;
	};
});
)

KtlCenter(\nano_buttons).startControl(NoteTimeline(\piano).notePlayer);
KtlCenter(\nano_buttons).startControl( NotePlayer(\piano) );

///////////////////////////////////////////// Step Sequencer

StepEventDef(\tutoseq, Param(Pdef(\tuto), \isRest))

///////////// GUI

StepEventDef(\tutoseq).edit;
(
WindowDef(\StepEventDefEditor, { arg def, group;
	VLayout(
		* group.collect({ arg player;
			player.asView
		}) ++ [ nil ]
	)
}).front(~pwg);
)

//////////// Control


(
KtlCenter(\nano_button, \PlayerWrapperGroup, { arg def, group
	Ktl(\nano).elAt(\buttons).do { arg but, idx; 
		but.action = { group[idx].togglePlay } 
	};
});
)

KtlCenter(\nano_buttons).startControl( StepEventDef(\tutoseq) )

/////////////// Record

// not really needed ? complexe


///////////////////////////////////////////////////// Drum Kit

PatKitDef(\tutokit, [
	Pdef(\tuto),
	Pdef(\tuto2),
]);

/////////////// GUI


(
WindowDef(\PatKitDefEditor, { arg def, group;
	VLayout(
		* group.collect({ arg player;
			player.asView
		}) ++ [ nil ]
	)
}).front( PatKitDef(\tutokit) );
)

//////////////// Control

(
KtlCenter(\apro_kit, \KitPlayer, { arg def, group
	Ktl(\nano).elAt(\keys).do { arg but, idx; 
		but.elAt(\on).action = { group.childAt(idx).play } ;
		but.elAt(\off).action = { group.childAt(idx).stop } ;
	};
});
)

KtlCenter(\apro_kit).startControl(PatKitDef(\tutokit));

/////////////// Record

KitTimeline(\tutokit_line1, PatKitDef(\tutokit));

/////////////////////////////////////////////// Launcher

~pwg = PlayerWrapperGroup([Pdef(\tuto), Pdef(\tuto2)]);

///////////// GUI

(
WindowDef(\PlayerWrapperGroupEditor, { arg def, group;
	VLayout(
		* group.collect({ arg player;
			player.asView
		}) ++ [ nil ]
	)
}).front(~pwg);
)

///////////// Control

(
KtlCenter(\nano_button, \PlayerWrapperGroup, { arg def, group
	Ktl(\nano).elAt(\buttons).do { arg but, idx; 
		but.action = { group[idx].togglePlay } 
	};
});
)

KtlCenter(\nano_buttons).startControl(~pwg)


/////////////// Record

// FIXME: no record button
// FIXME: doesnt take in account ~pwg
ClipTimeline(\tutogroup, ~pwg).edit

//////////////////////////////////////////////// Mixer

~trackgroup = [
	TrackDef(\tuto_track, TrackTemplateDef(\playertrack)).source_(Pdef(\tuto)),
	TrackDef(\tuto_track2, TrackTemplateDef(\playertrack)).source_(Pdef(\tuto2)),
];

////////////// GUI

(
WindowDef(\MixerEditor, { arg def, group;
	VLayout(
		* group.collect({ arg player;
			VLayout(
				player.asView,
				player.mixer.asView,
			)
		}) ++ [ nil ]
	)
}).front(~trackgroup);
)

////////////// Control

(
KtlCenter(\nano_button, \TrackGroup, { arg def, group
	Ktl(\nano).elAt(\buttons).do { arg but, idx; 
		but.action = { group[idx].togglePlay } 
	};
});
)

KtlCenter(\nano_buttons).startControl( ~trackgroup )

//////////// Record

TrackTimeline(\tuto_tracks, ~trackgroup);
