

(
FileSystemProject.loadOnce("paramdev/drafts/FxTimeline.scd");
FileSystemProject.loadOnce("paramdev/drafts/PmodEnvView.scd");
SynthDef(\DrumTrack_player_mono, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}, metadata:(specs:(
	bufnum: ParamAudioBufferSpec()
		.startParamName_(\pos)
		.numChannels_(2)
		.startType_(\seconds)
		.sustainType_(\beats)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed),
	pos: ControlSpec(0,20,\lin),
	\velamp: \unipolar.asSpec,
))).add;

SynthDef(\DrumTrack_player_stereo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}, metadata:(specs:(
	bufnum: ParamAudioBufferSpec()
		.startParamName_(\pos)
		.numChannels_(2)
		.startType_(\seconds)
		.sustainType_(\beats)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed),
	pos: ControlSpec(0,20,\lin),
	\velamp: \unipolar.asSpec,
))).add;

TrackTemplateDef(\DrumTrack, (
	parent: TrackTemplateDef(\CustomTrack),
	childClass: { TrackTemplateDef(\DrumTrackPart) },
	trackEditor: { arg self;
		WindowDef(\DrumEditor);
	},
	editInstrument: { arg self;
		WindowDef(\DrumEditor).front(self);
	},
	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%.score = %".format(self.refCompileString, ParamGroup.getPbindefCompileString(self.score)) );
		str.join($\n);
	},
	outBus_: { arg self, outBus;
		self[\outBus] = outBus;
		//Param(self.score, \out -> \source).set(outBus);
		self.score.set(\out, outBus);
		self.changed(\outBus);
	},
	makeScore: { arg self;
		self[\score] = Pbindef(self.trackKey, 
			\instrument, \DrumTrack_player_stereo,
			\dur, 1/8,
			\gain, 0.1,
		);
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\DrumTrackPart, (
	parent: TrackTemplateDef(\CustomTrackPart),
	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%.score = %".format(self.refCompileString, ParamGroup.getPbindefCompileString(self.score)) );
		str.join($\n);
	},
	edit: { arg self;
		WindowDef(\DrumTrackPart).front(self);
	},
	score_: { arg self, val;
		self[\score] = val;
		self[\pchain] = Pdef( (self.trackKey++\_chain).asSymbol, 
			Pbind(
				\mutter, Pfunc({ arg ev;
					var gate = ev[\seq];
					var coin = ev[\coin];
					var muted = false;
					// cell is audible if gate exist and true and coin is true
					//ev.debug("mutter");
					if(gate.notNil) {
						if(gate.coin.not) {
							// if mute param is present and say this cell is muted
							muted = true;
						};
					};
					if(coin.notNil and: { muted == false }) {
						// take in account coin only if gate is true
						if(coin.coin.not) {
							// if coin param is present and say this cell is muted
							muted = true;
						};
					};
					if(muted) {
						ev[\type] = \rest;
					};
					//if(.notNil and: { mute.coin.not } and: { coin.coin.not }) {
						//ev[\type] = \rest;
						//ev.debug("mutter2");
					//};
					\mutter;
				}),
			) 
			<> (
				Pfunc({ arg ev;
					self.disabledKeys.do { arg key, idx;
						ev.removeAt(key);
					};
					ev;
				})
				<> self.score 
			)
			<> self.parentTrack.score 
		);
		self[\proxy] = PlayerWrapper(self.pchain);
	},
	cloneScore: { arg self;
		var newscore;
		newscore = Pbindef(self.trackKey).source_(PbindProxy());
		self.score.source.pairs.clump(2).collect { arg pair, idx;
			//[ pair, pair[1].source.copy ].debug("clone");
			newscore.source.set(pair[0], pair[1].source.copy);
		};
		//~newscore = newscore;
		newscore.envir = self.score.envir.copy;
		newscore;
	},
	makeScore: { arg self;
		self.disabledKeys = Set.new;
		self.score = Pbindef(self.trackKey).source_(PbindProxy(\seq, PstepSeq(0!8,inf)));
		//self.proxy.debug("makeScore proxy end");
	},
	selectSourceDialog: { arg self;
		TrackTemplateDef(\playerwrapper)[\selectSourceDialog].value(self);
	},

	asPreview: { arg self;
		WindowDef(\DrumTrackPartPreview).asView(self);
	},

	stepCount_: { arg self, count;
		count = count.asInteger;
		count.asCompileString.debug("count");
		self.score.asParamGroup.do { arg pa, idx;
			var val;
			pa.debug("pa");
			val = pa.get;
			val.debug("val");
			if(pa.propertyArray.last == \stepseq) {
				pa.debug("pa2");
				//val.stepCount = count;
				pa.set(val.extend(count, val.last));
			}
		};
		self.changed(\refresh);
	},

	stepCount: { arg self;
		self.score.source.at(\seq).source.stepCount;
		
	},


	getExistingStepSeqParams: { arg self, exclude;
		var pg;
		var existpg;
		var synthdef = self.parentTrack.score.source.at(\instrument).source;
		exclude = exclude ?? { [\dur, \out, \bufnum, \mbufnum, \adsr] };
		pg = self.score.asParamGroup(synthdef).rejectByProperty(exclude);
		pg.debug("getExistingStepSeqParams: pg");
		existpg = pg.select({ arg pa; 
			pa.propertyArray.last == \stepseq and: {
				pa.isSet
			}
		});
		existpg;
	},
));

TagSpecDef(\CustomTrackTemplate).addUnique(\DrumTrack -> TrackTemplateDef(\DrumTrack));

WindowDef(\DrumEditor, { arg def, track;
	var header;
	var score = track.score;
	var instrp = Param(score, \instrument -> \source);
	var pview = View.new;
	header = HLayout (
		PlayerWrapper(track),
		instrp.asView,
	);
	instrp.onChange({
		pview.removeAll;
		pview.layout = score.asParamGroup.rejectByProperty([\instrument]).asView;
	}, pview);
	instrp.sendChanged;
	View.new.layout_(VLayout (
		header,
		pview,
	));
});

WindowDef(\DrumTrackPartPreview, { arg def, part;
	var score = part.score;
	var param = Param(score, \seq -> \stepseq, \unipolar);
	var view = View.new;
	var layout;
	var modstrip;
	var areasizex = part.parentTrack.parentTrack.areasizex;
	modstrip = WindowDef("ModulatorStrip_button".asSymbol).asView( param );
	modstrip.proto.shouldDrawBarLabel = false;
	modstrip.fixedHeight_(50);
	modstrip.proto.stepDur = score.source.at(\dur).source ?? { 1/8 };
	areasizex.debug("DrumTrackPartPreview areasizex");
	if(areasizex.notNil and: { areasizex != 0 }) {
		areasizex.debug("DrumTrackPartPreview areasizex");
		modstrip.proto.seqSize = areasizex;
		//modstrip.proto.areasize = Point(areasizex, 1);
	} {
		modstrip.proto.seqSize = param.size*modstrip.proto.stepDur;
	};
	modstrip.proto.colors.empty = Color.grey(0.8);
	modstrip.proto.cursorEnabled = true;
	layout = HLayout (*
		modstrip
		//param.collect { arg subparam, idx;
			//subparam.asButton("")
		//};
	).margins_(0);
	view.layout_(layout);
	
});
WindowDef(\DrumTrackPart, (
	lineHeight: 50,
	makeParamView: { arg self, param, type;
		var disabledKeys = self.part.disabledKeys ?? { []};
		var label = param.asStaticTextLabel.fixedWidth_(100);
		var editor;
		var pval;
		label.setContextMenuActions(
			MenuAction("Enable PmodEnv mode", {
				"enable pmod".debug;
				param.set( PmodEnv(PstepSeq([1,2,1],1), PstepSeq([8,8],inf), PstepSeq([0,0],inf)).loop );
				self.part.changed(\refresh);
			}),
			Menu(
				*WindowDef(\ParamGenericContextMenuEntries).sourceValue(param)
			).title_("Param menu")
		);

		pval = param.get;
		if(pval.isKindOf(Pn)) {
			pval = pval.pattern;
		};
		if(pval.isKindOf(PmodEnv)) {
			editor = self.makePmodEnvEditor(param);
		} {
			editor = self.makeModstrip(param, type);
		};
		HLayout (
			CheckBox.new.fixedWidth_(20).action_({ arg cbview;
				if(cbview.value == true) {
					self.part.disabledKeys = self.part.disabledKeys.remove(param.propertyRoot)
				} {
					self.part.disabledKeys = self.part.disabledKeys.add(param.propertyRoot)
				};
			}).value_(disabledKeys.includes(param.propertyRoot).not),
			label,
			editor,
		)
	},

	makePmodEnvEditor: { arg self, param;
		var view = View.new;
		view.layout = WindowDef(\PmodEnvEditor).asView(param).margins_(0);
		view.fixedHeight_(self.lineHeight);
		view;
	},

	makeModstrip: { arg self, param, type;
		var modstrip;
		type = type ?? { \slider };
		modstrip = WindowDef("ModulatorStrip_%".format(type).asSymbol).asView( param );
		modstrip.proto.shouldDrawBarLabel = false;
		modstrip.fixedHeight_(self.lineHeight);
		modstrip.proto.stepDur = 1;
		modstrip.proto.colors.empty = Color.grey(0.8);
		modstrip.proto.cursorEnabled = true;
		modstrip;
	},
	
	fillMainView: { arg self;
		var main = self.mainView;
		var part = self.part;
		var score = self.part.score;
		var param = Param(score, \seq -> \stepseq, \unipolar);
		var pgain = Param(score, \velamp -> \stepseq, ControlSpec(0,1,\lin,0,1));
		//var ppan = Param(score, \pan -> \stepseq, \pan);
		var pcoin = Param(score, \coin -> \stepseq, ControlSpec(0,1,\lin,0,1));
		var exclude = [\dur, \out, \bufnum, \mbufnum, \adsr, \velamp, \seq, \coin];
		var synthdef = self.part.parentTrack.score.source.at(\instrument).source;
		var toolbar;
		var pg;
		var existpg;
		pgain.initPstepSeq;
		pcoin.initPstepSeq;
		pg = score.asParamGroup(synthdef).rejectByProperty(exclude);
		existpg = pg.select({ arg pa; 
			pa.propertyArray.last == \stepseq and: {
				pa.isSet
			} 
			or: {
				[pa.propertyArray, pa.get].debug("existpg building");
				pa.propertyArray.last == \source and: {
					var val = pa.get;
					val.isKindOf(Pn) and: {
						val.pattern.isKindOf(PmodEnv)
					}
				} 

			}
		});
		toolbar = HLayout (
			PlayerWrapper(self.part).asView,
			HLayout (
				StaticText.new.string_("size:"),
				Param(Message(part), \stepCount, ControlSpec(1,64,\lin)).asNumberBox,
			),
			HLayout (
				StaticText.new.string_("repeats:"),
				Param(Message(part), \seqRepeats, ControlSpec(1,64,\lin)).asNumberBox,
			),
			BasicButton.new.string_("Add param").action_({
				var exc = self.part.getExistingStepSeqParams.collect({ arg pa; pa.propertyRoot });
				var pbindprop = [\degree, \note, \octave, \strum, \lag, \legato, \sustain, \mtranspose, \ctranspose, \root];
				var pbindpg;
				synthdef = self.part.parentTrack.score.source.at(\instrument).source;
				pg = score.asParamGroup(synthdef).rejectByProperty(exclude);
				pbindpg = pbindprop.collect { arg prop, idx;
					Param(score, prop)
				};
				pg = (pg ++ pbindpg).asParamGroup;
				//pg.do(_.debug("Add param: param"));

				//var exc = existpg.collect({ arg pa; pa.propertyRoot });
				Menu(
					* pg.rejectByProperty(exc).collect { arg param, idx;
						MenuAction(param.label, {
							var pa;
							param.debug("Add param: param");
							//pa = param.at(\stepseq);
							pa.debug("Add param: pa");
							param.initPstepSeq(self.part.stepCount);
							self.refresh;
						});
					};
				).front;
			}),
			BasicButton.new.string_("...").fixedWidth_(30).action_({
				Menu(
					MenuAction("Edit instrument", {
						self.part.parentTrack.editInstrument;
					}),
					MenuAction("Duplicate score", {
						self.part.getExistingStepSeqParams.do { arg pa, idx;
							[pa, pa.get].debug("duplicate param");
							pa.set(( pa.get!2 ).flat);
						};
						self.refresh;
					}),

				).front;
			})
		);
		main.layout = VLayout (
			toolbar,
			VLayout (
				self.makeParamView(param, \button),
				self.makeParamView(pcoin),
				self.makeParamView(pgain),
				* existpg.collect { arg pa, idx;
					self.makeParamView(pa);
				} ++[nil]
			)
		).margins_(0);

	},

	refresh: { arg self;
		self.mainView.removeAll;
		self.fillMainView;
	},

	makeResponders: { arg self;
		self.mainView.followChange(self.part, \refresh, {
			self.refresh;
		})
	},

	asView: { arg self, def, part;
		self.mainView = View.new;
		self.score = part.score;
		self.part = part;
		self.makeResponders;
		//self.refresh;
		self.mainView;

	},

));

FileSystemProject.loadOnce("sndlib/buflib.scd");
);

// END


TrackDef(\bla1, \TrackList).edit
TrackDef(\bla2).childAt(0,0).score
~t = 120/2/60; TempoClock.default.tempo = ~t;

Param.lastTweaked
~newscore.source.pairs
~newscore.source.set(\bla, 1)
TrackDef(\bla1).childAt(3,6).score.source.at(\freq).source
TrackDef(\bla1).childAt(3,6).score.source.at(\note)
TrackDef(\bla1).presetCompileStringSavePath = "~/tmp/azeaze3/".standardizePath
TrackDef(\bla1).savePresetCompileString
TrackDef(\bla1).loadPresetCompileString
TrackDef(\bla1).childAt(5,0).score.eventList.startTime
TrackDef(\bla1).childAt(0,0).score.asParamGroup.collect(_.at(\source)).asParamGroup.rejectUnsetParams
TrackDef(\bla1).childAt(0,0).score.asParamGroup
TrackDef(\bla1).childAt(0,0).getExistingStepSeqParams
ParamGroup

NoteTimeline(\bla).edit
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
Pbindef(\pz, 
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\hello, 3,
	\amp, 0.1,
).play;
);
Pdef(\zed).asParamGroup
Pbindef(\pz).asParamGroup.collect(_.property)
Pbindef(\pz).asParamGroup.asPropertyDict[\pan]
Pbindef(\pz).source.isKindOf(PbindProxy)

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

Param(TrackDef(\bla3).childAt(0).score, \bufnum).spec
Param(TrackDef(\bla3).childAt(0).score, \bufnum).edit
\bufnum.asSpec.tagSpec.list
BufDef.all

/////////////////:
// fix mixer bug

(
WindowDef(\win, { arg def;
	var view = View.new;
	var meter;
	//meter.asView;
	VLayout (
		view,
		BasicButton.new.string_("reset").action_({
			//100.do { arg item, idx;
				
			meter = CompactServerMeterView(nil, 0, 2, BusDef(\bla1, \audio));
			//view.removeAll;
			view.layout = VLayout(meter)
			//};
		}),
		BasicButton.new.string_("reset2").action_({
			meter.bus = BusDef(\bla1++(rrand(1,2)), \audio);
		})
	)

	
}).front;
)

TrackMixerDef(\aze).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, TrackMixerDef(\aze),
		),
	])
)).play;
);


(
WindowDef(\win, { arg def;
	HLayout (
		TrackMixerDef(\aze).asView,
		TrackMixerDef(\aze).asView,
	)
}).front;
)

//////////

(
ProtoDef(\test, (
	start: {
		var synth;
		s.bind({

		synth = SynthDef(\ttt, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
			var sig;
			sig = SinOsc.ar(freq * LFNoise1.ar(1).range(0.5,1.3));
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
			sig = Pan2.ar(sig, pan, amp);
			Out.ar(out, sig);
		}).play;
		synth.register;
		synth.isPlaying.debug("isPlaying");
		~s = synth;
		s.sync;
		synth.isPlaying.debug("isPlaying");
		synth.free;
		});

	},
	stop: { arg self;
		
	},
))
)

ProtoDef(\test).start
~s.isPlaying

Param(Pdef(\bla), \speed -> \stepseq).edit
Param(Pdef(\bla), \speed -> \stepseq, \unipolar).default
Param(Pdef(\bla), \speed -> \stepseq).spec
Param(Pdef(\bla), \speed).spec
Spec.add(\speed, \unipolar)
ParamArraySpec
Param(Pdef(\bla), \speed -> \stepseq).at(0).default
Param(Pdef(\bla), \speed -> \stepseq, \unipolar).initPstepSeq
Param(Pdef(\bla), \speed -> \stepseq, \unipolar).parent.spec
Param(Pdef(\bla), \speed -> \stepseq).size
Param(Pdef(\bla), \speed -> \stepseq).get
Param(Pdef(\bla), \speed -> \stepseq).setDefaultIfNil
Pbindef(\bla, \aaa, 1, \hey, PstepSeq([1,2,3],inf)).edit
Pbindef(\bla2, \aaa, 1, \degree, PstepSeq([1,2,3],inf)).edit
Pbindef(\bla3, \degree, PstepSeq([1,2,3],inf), \aaa, 1, ).edit
Pbindef(\bla3, \hihi, 10);
Param(Pbindef(\bla), \instrument).get
Param(Pbindef(\bla), \instrument).getRaw
Param(Pbindef(\bla), \instrument -> \source).get
Param(Pbindef(\bla), \instrument -> \source, TagSpecDef(\SynthDef_keys)).edit
Param(Pbindef(\bla), \instrument -> \source, TagSpecDef(\SynthDef_keys)).getRaw
Param(Pbindef(\bla), \instrument -> \source, TagSpecDef(\SynthDef_keys)).default
TagSpecDef(\SynthDef_keys).default
Param(Pbindef(\bla), \instrument -> \source).spec
Param(Pbindef(\bla), \instrument).spec
Param(Pbindef(\bla), \instrument -> \source).getRaw

NoteTimeline(\bla).edit
ClipTimeline(\bla).edit
FileSystemProject.loadOnce("sndlib/synthbasic.scd")

(
Pbindef(\rez, 
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);

Param(Pdef(\rez), \amp).spec
~p = Param(Pdef(\rez), \amp -> \source)
~px = Param(Pdef(\rez), \amp -> \stepseq)
~p.initPstepSeq(8)
~p.get
~p.spec
~p.set(1)

~px.get
~px.spec
~px.parent.at(\source).spec
