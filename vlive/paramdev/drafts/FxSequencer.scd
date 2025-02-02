
(
TrackTemplateDef(\PlayerSeqTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\PlayerSeqTrackPart) },
	playerObject_: { arg self, player;
		self[\playerObject] = player;
		self.playerWrapperObject = PlayerWrapper(player);
		self.changed(\set, \playerObject);
	},
	editInstrument: { arg self;
		WindowDef(( self.trackKey++\_instrument ).asSymbol, { arg def;
			HLayout (
				Param(Message(self), \playerObject, ParamNonFloatSpec()).asTextField,
				BasicButton.new.string_("Edit").action_({
					self.playerWrapperObject.edit;
				}),
				BasicButton.new.string_("Select").action_({
					WindowDef(\GlobalLibrary_select).front(self.playerObject, { arg val;
						val.debug("GlobalLibrary_select");
						self.playerObject = val.last.value;
					}, [\Players])
				})
			)
		}).front;
	},
));
TrackTemplateDef(\PlayerSeqTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),

	outBus: { arg self;
		self.parentTrack.outBus;
	},
	outBus_: { arg self;
	},
	asPreview: { arg self;
		WindowDef(\stepseq_butlist).asView(self.score, \kitseq, self.parentTrack.parentTrack.defaultSeqSize).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
			if(buttonNumber == 1) {
				self.edit;
				
			};
		});
	},
	playerPattern: { arg self;
		Pbind(
			\player, { self.parentTrack.playerWrapperObject },
			\play, {
				if(~isRest == false) {
					if(~player.value.isPlaying) {
						// NOOP
					} {
						~player.value.play;
					};
				} {
					~player.value.stop;
				}
			},
		)
	},
	makeScore: { arg self;
		self.score = Pbindef(self.trackKey+++\score, \dur, 1/8);
		self.source = Pdef(self.trackKey+++\pat, self.playerPattern <> Pbind(\isRest, Pkey(\kitseq).coin.not) <> self.score);
	},

	edit: { arg self;
		WindowDef(( self.trackKey++\_editor ).asSymbol, { arg def;
			var seq;
			var refresh;
			var pgview = View.new;
			var pbindefEditorView;
			seq = WindowDef(\stepseq_butlist).asView(self.score, \kitseq);

			VLayout (
				HLayout (
					StaticText.new.string_("size"),
					Param(Message(seq), \listSize, ControlSpec(0,256,\lin,1,0)).asTextField,
				),
				seq,
			)
		}).front;
	},
));
TagSpecDef(\CustomTrackTemplate).addUnique(\PlayerSeqTrack -> TrackTemplateDef(\PlayerSeqTrack));


TrackTemplateDef(\InsertFxSeqTrack, (
	parent: TrackTemplateDef(\PlayerSeqTrack),
	childClass: { TrackTemplateDef(\PlayerSeqTrackPart) },
	playerObject_: { arg self, player;
		self[\playerObject] = player;
		self.playerWrapperObject = PlayerWrapper(player);
		self.changed(\set, \playerObject);
	},
	editInstrument: { arg self;
		WindowDef(( self.trackKey++\_instrument ).asSymbol, { arg def;
			var pgview = View.new;
			pgview.followChange(self, \set, { arg view, obj, msg, val;
				if(val == \playerObject) {
					pgview.removeAll;
					//pgview.layout = 
					
				};

			});
			VLayout (
				HLayout (
					Param(Message(self), \playerObject, ParamNonFloatSpec()).asTextField,
					BasicButton.new.string_("Select").action_({
						WindowDef(\GlobalLibrary_select).front(self.playerObject, { arg val;
							val.debug("GlobalLibrary_select");
							self.playerObject = val.last.value;
						}, [\Players])
					})
				),
				pgview;
			)
		}).front;
	},
));



)

TrackDef(\cc3, TrackTemplateDef(\CustomTrackList)).edit
TrackDef(\cc).childAt()

(
TrackMixerDef(\hello).play;
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,4,3,Pwhite(0,12,1)],inf),
		\legato, 1.5,
		\dur, 1,
		\out, TrackMixerDef(\hello).inBus,
		\amp, 0.1,
	)
).play;
);

(
)


///////////////////////////////
//// proof of concept

(
SynthDef(\ifx_am, { arg out=0, gate=1, fadeTime;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = sig * \ingain.kr(1);
	sig = sig * SinOsc.ar(\freq.kr(200));
	env = EnvGen.ar(Env.adsr(fadeTime,0.1,1,fadeTime),gate,doneAction:2);
	XOut.ar(out, \wet.kr(0) * env, sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
}, metadata:(specs:(
	ingain: \unipolar.asSpec,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_am);
)

(
TrackMixerDef(\hello).play;
TrackMixerDef(\hello).insertFxAt(0).synthName = \ifx_am;
TrackMixerDef(\hello).insertFxAt(0).getParam(\wet).set(1);
)
TrackMixerDef(\hello).proxy.fadeTime = 0.1;

(out: TrackMixerDef(\hello).inBus, sustain:inf, \note: 12).play
TrackMixerDef(\hello).insertFxAt(0).play; // play and stop to hear click
TrackMixerDef(\hello).insertFxAt(0).stop


(
TrackMixerDef(\hello).play;
TrackMixerDef(\hello).insertFxAt(0).synthName = \ifx_am;
TrackMixerDef(\hello).insertFxAt(0).getParam(\wet).set(1);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, TrackMixerDef(\hello).inBus,
		),
		Pbind(
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\play, {
				~isRest.debug;
				if(~isRest == false) {
					TrackMixerDef(\hello).insertFxAt(0).play;
				} {
					TrackMixerDef(\hello).insertFxAt(0).stop;
				}
			},
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

////////////// draft

TrackMixerDef(\hello).edit
TrackMixerDef(\hello).insertFxList = SparseArray[]
TrackMixerDef(\hello).inBus
TagSpecDef(\SynthDef_InsertFx).list

FileSystemProject.load("cavern/ifxsimple.scd")

(
SynthDef(\ifx_am, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = sig * \ingain.kr(1);
	sig = sig * SinOsc.ar(\freq.kr(200));
	env = EnvGen.ar(Env.adsr(0.5,0.1,1,0.5),gate,doneAction:2).poll;
	XOut.ar(out, \wet.kr(0) * env, sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
}, metadata:(specs:(
	ingain: \unipolar.asSpec,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_am);
)

TrackMixerDef(\hello).insertFxAt(0).synthName = \ifx_am;
(out: TrackMixerDef(\hello).inBus, sustain:inf).play
TrackMixerDef(\hello).play;
TrackMixerDef(\hello).insertFxAt(0).getParam(\wet).set(1);


TrackMixerDef(\hello).insertFxList = nil
TrackMixerDef(\hello).insertFxAt(0).play;
TrackMixerDef(\hello).insertFxAt(0).stop
TrackMixerDef(\hello).insertFxAt(0).proxy.release(1)
TrackMixerDef(\hello).insertFxAt(0).proxy.sources
TrackMixerDef(\hello).insertFxAt(0).proxy.objects[3000].release
SynthDefControl
NodeProxy
TrackMixerDef(\hello).insertFxAt(0).index
TrackMixerDef(\hello).insertFxAt(0).fxValue.add
~a = TrackMixerDef(\hello).insertFxAt(0).fxValue
~b = TrackMixerDef(\hello).insertFxAt(0).fxValue
~a === ~b
~a.name
~a.add;
~a

(
Pdef(\zed, 
	Pbind(
		\instrument, \ifx_am3000,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

TrackMixerDef(\hello).insertFxAt(0).proxy.fadeTime = 0.5;
TrackMixerDef(\hello).insertFxAt(0).proxy[3000].dump
TrackMixerDef(\hello).insertFxAt(0).proxy[3000] = nil
TrackMixerDef(\hello).insertFxAt(0).proxy[3000] = \ifx_am3000;
TrackMixerDef(\hello).insertFxAt(0).proxy[3000] = \ifx_am;
TrackMixerDef(\hello).insertFxAt(0).proxy[3000] = SynthDesc(\ifx_am3000).def.name.asSymbol;
SynthDesc(\ifx_am3000)
SynthDesc(\ifx_am3000).def.name.asCompileString
SynthDesc(\ifx_am3000).def.add
(
TrackMixerDef(\hello).play;
TrackMixerDef(\hello).insertFxAt(0).synthName = \ifx_am;
TrackMixerDef(\hello).insertFxAt(0).getParam(\wet).set(1);
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\dur, 4,
			\amp, 0.1,
			\out, TrackMixerDef(\hello).inBus,
		),
		Pbind(
			\instrument, \default,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\play, {
				~isRest.debug;
				if(~isRest == false) {
					TrackMixerDef(\hello).insertFxAt(0).play;
				} {
					TrackMixerDef(\hello).insertFxAt(0).stop;
				}
			},
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


//////// proof that using doneAction:2 prevent clipping when stopping the fx

(
// click on stop
SynthDef(\ifx_am, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = sig * \ingain.kr(1);
	sig = sig * SinOsc.ar(\freq.kr(200));
	env = EnvGen.ar(Env.adsr(0.5,0.1,1,0.5),gate,doneAction:0).poll;
	XOut.ar(out, \wet.kr(0) * env, sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
}, metadata:(specs:(
	ingain: \unipolar.asSpec,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_am);
)

(
// no click on stop
SynthDef(\ifx_am, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = sig * \ingain.kr(1);
	sig = sig * SinOsc.ar(\freq.kr(200));
	env = EnvGen.ar(Env.adsr(0.5,0.1,1,1.5),gate,doneAction:2).poll;
	XOut.ar(out, \wet.kr(0) * env, sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
}, metadata:(specs:(
	ingain: \unipolar.asSpec,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_am);
)

(
TrackMixerDef(\hello).play;
TrackMixerDef(\hello).insertFxAt(0).synthName = \ifx_am;
TrackMixerDef(\hello).insertFxAt(0).getParam(\wet).set(1);
)

(out: TrackMixerDef(\hello).inBus, sustain:inf).play
TrackMixerDef(\hello).insertFxAt(0).play; // play and stop to hear click
TrackMixerDef(\hello).insertFxAt(0).stop



//////// using fadeTime
// work ok!


(
SynthDef(\ifx_am, { arg out=0, gate=1, fadeTime;
	var sig;
	var in = In.ar(out, 2); 
	var env;
	sig = in;
	sig = sig * \ingain.kr(1);
	sig = sig * SinOsc.ar(\freq.kr(200));
	env = EnvGen.ar(Env.adsr(fadeTime,0.1,1,fadeTime),gate,doneAction:2);
	XOut.ar(out, \wet.kr(0) * env, sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
}, metadata:(specs:(
	ingain: \unipolar.asSpec,
))).add;
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_am);
)

(
TrackMixerDef(\hello).play;
TrackMixerDef(\hello).insertFxAt(0).synthName = \ifx_am;
TrackMixerDef(\hello).insertFxAt(0).getParam(\wet).set(1);
)
TrackMixerDef(\hello).proxy.fadeTime = 0.05;

(out: TrackMixerDef(\hello).inBus, sustain:inf).play
TrackMixerDef(\hello).insertFxAt(0).play; // play and stop to hear click
TrackMixerDef(\hello).insertFxAt(0).stop

