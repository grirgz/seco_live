
///// test real tracklist gui for CustomTrackList (instead of grid)
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)

TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))
TrackDef(\myseq).edit
StaticText
TrackDef(\myseq).presetCompileStringSavePath = nil
TrackDef(\myseq).presetCompileStringSavePath
TrackDef(\myseq).savePresetCompileString("/tmp/testme12/")
TrackDef(\myseq).loadedFromPath
TrackDef(\myseq).loadPresetCompileString
TrackDef(\myseq).isEmpty = true
FileSystemProject.load("/tmp/testme11/TrackDef_myseq.scd")
TrackDef(\myseq).dataPath
WindowDef(\CustomTrackList).front(TrackDef(\myseq))
SampleTimeline(\bla).edit

TrackDef(\myseq).clearTrack
TrackDef(\myseq).clipTimeline
TrackDef(\myseq).selectedPart
TrackDef(\myseq).selectedPart = 0
TrackDef(\myseq).childAt(0).childAt(0).asPreview
TrackDef(\myseq).childAt(0).childAt(1).outBus
TrackDef(\myseq).childAt(1).trackTemplate
TrackDef(\myseq).childAt(1).isEmpty
TrackDef(\myseq).children[1] = nil
TrackDef(\myseq).childAt(1).asCompileString
TrackDef(\myseq).childAt(0).isEmpty
TrackDef(\myseq).childAt(0).trackTemplate
TrackDef(\myseq).childAt(2).label
TrackDef(\myseq).childAt(0,0).isEmpty
TrackDef(\myseq).childAt(0,0).proxy.target.asCompileString
TrackDef(\myseq).childAt(0,0).score.asCompileString
TrackDef(\myseq).childAt(0,0).score.source.at(\velamp).source.list
TrackDef(\myseq).childAt(0,0).score.fadeOut
TrackDef(\myseq).childAt(0,0).score.postPatternPreset.asCompileString
TrackDef(\myseq).childAt(0,0).score.presetCompileString
TrackDef(\myseq).childAt(0,0).score.keys.do(_.postln)
TrackDef(\myseq).childAt(0,0).score.presetCompileString
TrackDef(\myseq).childAt(0,0).score.buffer.asString
BufDef.bufferCompileString(TrackDef(\myseq).childAt(0,0).score.buffer)
BufDef.bufferCompileString(~buf)
~buf = Buffer.alloc(s, 1000)
~buf.asString

TrackDef(\myseq).childAt(0,0).presetCompileString
TrackDef(\myseq).childAt(0).base.asParamGroup.getSetCompileString("sdf")
TrackDef(\myseq).childAt(0).base.asParamGroup[7].spec
TrackDef(\myseq).childAt(0).base.asParamGroup[7].isSet
Param(TrackDef(\myseq).childAt(0).base, \speed).get.asCompileString
Param(TrackDef(\myseq).childAt(0).base, \buffer).get.asCompileString
BufferProxy
TrackDef('myseq').childAt(0, 0).score = [ 0.0, 0.42543858289719, 0.47368422150612, 0.47368422150612, 0.43508777022362, 0.40350878238678, 0.0, 0.0  ];
~view_selector

~me = Menu( ~ma = MenuAction("hh") )
~me.front
~ma

~buf = Buffer.read(s, "/home/ggz/Musique/sc/samplekit/field/clap.flac")
(
Pdef(\zed, 
	Pbind(
		\instrument, \playersec,
		\pos, 0,
		\legato, 1,
		\dur, 1,
		\gain, 1,
	)
).play;
);
Pdef(\zed).asParamGroup.getSetCompileString
Pdef(\zed).asParamGroup.collect(_.spec)
~pa = Pdef(\zed).asParamGroup[6]
~pa.spec.tagSpec.unmapKey(6)
~pa.spec.tagSpec.l)ist
~pa.spec.tagSpec.key
TagSpecDef(\BufDef).unmapKey(6)
Param(Pdef('zed'), 'bufnum').get
Spec.add(\bufnum, ParamAudioBufferSpec())
Pdef(\zed).asParamGroup.getBufferCompileString(~pa)
BufDef('samplekit/com/HiHat/ClosedHH 606 1.wav').play
~pa.get
WindowDef(\ParamAsSoundFileView).front(Param(Pdef(\zed), \bufnum, ParamAudioBufferSpec()))

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * \fmr.kr(1/100)) * \fmamp.kr(0.5) + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\zed).asParamGroup.getSetCompileString
Ndef(\zed).nodeMap.keys
Ndef(\zed).edit

Pdef(\zed).asParamGroup.collect(_.spec)
~pa = Param(Pdef(\zed), \bufnum, ParamAudioBufferSpec())
~pa.getRaw
Pdef(\zed).get(\bufnum)
Pdef(\zed).set(\xxx, 34)
Pdef(\zed).envir.keys
nil.keys
~en = Pdef(\zed).envir
~en.copy.parent_(nil)[\bufnum]

Param(Pdef(\zed), \bufnum, ParamAudioBufferSpec()).edit
Param(Pdef(\zed), \bufnum, ParamAudioBufferSpec()).get.asCompileString
Param(Pdef(\zed), \bufnum, ParamAudioBufferSpec()).presetCompileString
Pdef(\zed).get(\bufnum)
t
Param(Pdef(\zed), \buffer, ParamAudioBufferSpec()).spec.tagSpec.unmapKey(1);
FileSystemProject.load("holis/synthdef.scd")

~data = ProtoClass()
Param(Message(~data), \bla).edit
Param(Message(~data), \lab, ParamStringSpec()).edit
(
WindowDef(\win, { arg def;
	
	Menu(
		~ma = Param(Message(~data), \lab, ParamBoolSpec()).asMenuAction(action: { ~data.debug("data") })
	)
}).front;
)
~data
~ma.checked
~ma.checkable

///////////
TrackDef(\myseq).clear;
TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))
TrackDef(\myseq).edit
ProtoDef(\apc40).activate(TrackDef(\myseq)); 
ProtoDef(\apc40).colors.off
ProtoClass((off:12, on:54)).on
TrackDef(\myseq).startControl
TrackDef(\myseq).childAtOffset(1).mixer.asParam(\postfader).edit
Spec.add(\freqenv, ParamEnvSpec( \lofreq ))
Pbindef('myseq.0.0').convertToPbindef
Pbindef('myseq.0.0', \instrument, \default)
Pbindef('myseq.0.0').edit
TrackDef(\myseq).elAt(0,0)[\edit].asCompileString
TrackDef(\myseq).elAt(0,5).source
TrackDef(\myseq).elAt(0,5).edit
Pbindef('myseq.0.5').edit

TrackDef(\myseq).elAt(0).showTrackHeaders
TrackDef(\myseq).elAt(0).isMixerEnabled
TrackDef(\myseq).showTrackHeaders = true
TrackDef(\myseq).isMixerEnabled = false;
TrackDef(\myseq).isMixerEnabled = true
TrackDef(\myseq).isMixerEnabled 
TrackDef(\myseq).edit

~self.trackFaders[0].model = TrackDef(\myseq).elAt(0).mixer
~self.trackFaders[0].model = nil
TrackDef(\myseq).elAt(0).mixer

TrackMixerDef(\bla)[\storeOn]
TrackMixerDef(\bla2)

TrackDef(\myseq).elAt(0).source = Pbind(\instrument, \default, \degree, PstepSeq(0!8,inf), \velamp, PstepSeq(1!8,inf))
TrackDef(\myseq).elAt(0).preChain.play
TrackDef(\myseq).elAt(0).preChain
TrackDef(\myseq).elAt(0).seqpairs
TrackDef(\myseq).elAt(0).postChain = Pbind()
TrackDef(\myseq).elAt(0).postChain.patternpairs.last.nextFunc.asCompileString
TrackDef(\myseq).elAt(0).asParamGroup
TrackDef(\myseq).elAt(0)[\source_].asCompileString
TrackDef(\myseq).elAt(0).existingChildren
TrackDef(\myseq).elAt(0).parent.parent.parent.parent
TrackDef(\myseq).elAt(0).source
TrackDef(\myseq).elAt(0,0).score.source.pairs
TrackDef(\myseq).elAt(0,0).score.source.pairs.last.source.list
TrackDef(\myseq).elAt(0,0).score.source.pairs[1].source.list
TrackDef(\myseq).elAt(0,0).score.play
TrackDef(\myseq).elAt(0,0).play
TrackDef(\myseq).elAt(0).postChain = nil
TrackDef(\myseq).elAt(0).postChain
T
TrackDef(\myseq).elAt(0,0).score.clear
TrackDef(\myseq).elAt(0,0).makeScore
( TrackDef(\myseq).elAt(0).postChain <> TrackDef(\myseq).elAt(0,0).score <> TrackDef(\myseq).elAt(0).preChain ).play
(  TrackDef(\myseq).elAt(0,0).score <> TrackDef(\myseq).elAt(0).preChain ).trace.play
TrackDef(\myseq).elAt(0,0).source.source.patterns
TrackDef(\myseq).elAt(0,0).source.play
TrackDef(\myseq).elAt(0,0).source
TrackDef(\myseq).elAt(0,0).edit
TrackDef(\myseq).elAt(0).editor.
TrackDef(\myseq).elAt(0,0)[\editor].asCompileString


TrackDef(\myseq).elAt(0).seqpairs
TrackDef(\myseq).elAt(0).editInstrument
TrackDef(\myseq).elAt(0).mixer_obj
TrackDef(\myseq).elAt(0).isMixerEnabled
TrackDef(\myseq).mixer


TrackDef(\myseq).linePlayerAt(0)[\isPlaying].asCompileString
TrackDef(\myseq).linePlayerAt(1)[\isPlaying].asCompileString
TrackDef(\myseq).lineClass[\isPlaying].asCompileString
TrackDef(\myseq).lineClass
TrackTemplateDef(\lineplayer)[\isPlaying].asCompileString
TrackTemplateDef(\TrackListPart)[\isPlaying].asCompileString
TrackTemplateDef(\TrackListPart).clear
TrackDef(\myseq).linePlayers[0].parent
TrackDef(\myseq).linePlayers= nil
TrackDef(\myseq).obj_linePlayers= nil
SparseArray

TrackDef(\myseq).changed(\gridOffset)
TrackDef(\myseq).elAt(1).base.edit
TrackDef(\myseq).elAt(4).changed(\children)
TrackDef(\myseq).elAt(4)[\updateChildren].asCompileString
TrackDef(\myseq).childAt(0).trackTemplate = TrackTemplateDef(\SeqTrack)
TrackDef(\myseq).children[1] = nil
WindowDef(\customgrid).front(TrackDef(\myseq))
StaticText


////////////////////////////////////// draft
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\coin, Pseq([0,0.4,1],inf),
		\muter, Pif(Pkey(\coin).coin, {0}, {\rest}),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);



(
WindowDef(\win, { arg def;
	StaticText.new.string_("long long lon lon lon lon lon lon lon lon longgggggggg").minWidth_(5)
	
}).front;
);
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([2,5,-4,0],inf),
		\velamp, PstepSeq([1,0,1,1,0],inf),
		\muter, Pfunc({ arg ev; if(ev[\velamp] > 0) {0} {\rest} }),
		\dur, 1/8,
		\amp, 0.1 * Pwhite(0.1,0.5),
	) <>
	Pbind(
		\velamp, PstepSeq([0,0,0,0,0],inf),
	) 
).play;
);

(
Pdef(\zed, 
	Pbind(
		//\velamp, Pfunc({ arg ev; if(ev[\velamp] > 0) {ev[\velamp]} {Rest(ev[\velamp])} }),
			\velamp, Pfunc({ arg ev; 
				if(ev[\velamp].isNil) {
					1
				} {
					if(ev[\velamp] > 0) {ev[\velamp]} {Rest(ev[\velamp])}
				}
			});
	)<>
	Pbind(
		//\velamp, PstepSeq([0,0,0,0,1],inf),
	) <>
	Pbind(
		\instrument, \default,
		\degree, Pseq([2,5,-4,0],inf),
		//\velamp, PstepSeq([1,0,1,1,0],inf),
		//\muter, Pfunc({ arg ev; if(ev[\velamp] > 0) {0} {\rest} }),
		\dur, 1/8,
		\amp, 0.1 * Pwhite(0.1,0.5),
	) 
).play;
);

WindowDef(\TrackMixerDef_advanced).front()

(
WindowDef(\win, { arg def;
	var mix1, mix2;
	var options = (showOutbus:true, showSends:true, showFaderTextField: true, showPlay: true, showDelay:true, showFx:true);
	HLayout (
		mix1 = WindowDef(\TrackMixerDef_advanced).asView(nil, options),
		mix2 = WindowDef(\TrackMixerDef_advanced).asView(nil, options),
		WindowDef(\TrackMixerDef_advanced).asView(nil, options),
		BasicButton.new.string_("bla").action_({
			mix1.model = TrackDef(\myseq).elAt(0).mixer;
			mix2.model = TrackDef(\myseq).elAt(1).mixer;
		}),
		BasicButton.new.string_("remobve").action_({
			mix1.model = nil;
			mix2.model = nil;
		})
	)
	
}).front;
);

TrackDef(\myseq).elAt(0,0).outBus
(
TrackDef(\myseq, TrackTemplateDef(\CustomTrackList));
TrackDef(\myseq).elAt(0).isMixerEnabled = true;
TrackDef(\myseq).elAt(1).isMixerEnabled = true;
)


//////////



(
/// debug customgrid mixer
WindowDef(\customgrid, (
	trackCount: 1,
	rowCount: 2,
	masterTrackIndex: 8,
	showToolBar: true,
	
	asView: { arg self, me, maintrack;
		var viewgrid;
		var mainview;
		var make_view;
		var playerviews;
		var map_players;
		var mixerviews;
		maintrack = maintrack ?? { TrackDef(\main) };

		self.maintrack = maintrack;
		// commented because at caller level
		//if(me.window.notNil) {
		//	me.window.bounds = Rect(144, 217, 1090, 438);
		//};

		mainview = View.new;
		mainview.onChange(maintrack, \gridOffset, { {map_players.()}.defer });

		self.trackFaders = nil ! self.trackCount;
		mixerviews = self.trackCount.collect({ arg x;
			self.makeTrackFader2(x)
		});

		if(me.window.notNil) {
			me.window.name = "playergrid: " ++ maintrack.key;
		};

		map_players = {
			mixerviews.do({ arg child, x;
				[child, x].debug("set mixerview model: child");
				child.model = maintrack.childAtOffset(x).mixer;
			})

		};

		//map_players.();
		VLayout (
			self.makeToolBar,
			HLayout(*mixerviews)
		)
	},

	makeToolBar: { arg self;
		HLayout (
			BasicButton.new.string_("^").action_({
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(0,-1);
			}),
			BasicButton.new.string_("v").action_({
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(0,1);
			}),
			BasicButton.new.string_("<").action_({
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(-1,0);
			}),
			BasicButton.new.string_(">").action_({
				self.maintrack.gridOffset = self.maintrack.gridOffset + Point(1,0);
			}),
			BasicButton.new.string_("debug self").action_({
				~self = self;

			}),
			BasicButton.new.string_("debug model").action_({
				~dbmix.model = self.maintrack.elAt(0).mixer;
				//self.trackFaders[0] = self.maintrack.elAt(0).mixer;
				~dbfirstmix.model = self.maintrack.elAt(0).mixer;

			}),
			BasicButton.new.string_("debug model nil").action_({
				~dbmix.model = nil;
				//self.trackFaders[0] = nil;
				~dbfirstmix.model = nil;
			}),

			~dbmix = WindowDef(\customgrid_mixer+++\azer, WindowDef(\TrackMixerDef_advanced)).asView,
			nil
		)
	},

	makeTrackFader2: { arg self, trackidx;
		var res = WindowDef(\customgrid_mixer+++trackidx, WindowDef(\TrackMixerDef_advanced)).asView;
		self.trackFaders[trackidx] = res;
		if(trackidx == 0) {
			Log(\Param).debug("AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
			~dbfirstmix = res;
		};
		~dbfader = res;
		res
	},

	makeTrackFader: { arg self, trackidx;
		var child, boxview, mixer, mixerview;
		child = self.maintrack.childAtOffset(trackidx);
		if(child.notNil) {
			var win = WindowDef(\customgrid_mixer+++trackidx, WindowDef(\TrackMixerDef_advanced));
			mixer = child.mixer;
			win.proto.showPlay = false;
			//mixerview = win.asView(mixer);
			mixerview = win.asView;
			// model_ is already defined in mixer view
			mixerview.debug("created mixerview");
			//self.trackFaders = self.trackFaders ?? { nil ! self.trackCount };
			//if(self.trackFaders[trackidx].notNil) {
				//trackidx.throw;
			//};
			if(trackidx == 0) {
				~dbfirstmix = mixerview;
			};
			self.trackFaders[trackidx] = mixerview;
			mixerview;
		};
	},

	makeTrackHeader: { arg self, trackidx;
		var playerview;
		if(trackidx != 8) {
			var child;
			var maintrack = self.maintrack;
			child = maintrack.childAtOffset(trackidx);
			[child, child.source, trackidx].debug("showTrackHeaders: child");
			playerview = PlayerWrapperGridCellView(child).asView.addUniqueMethod(\model_, { arg view, val;
				view.parentView.model = val;
			}).mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				if(buttonNumber == 1) {
					child.editTrackTemplate;
				};
			});

			playerview.layout.margins_(1);
			playerview.button.fixedWidth_(20);
			playerview.labelView.minWidth_(10);
			self.trackHeaders = self.trackHeaders ?? { nil ! self.trackCount };
			self.trackHeaders[trackidx] = playerview;
			playerview;
		} {
			playerview = PlayerWrapperGridCellView(nil).asView.addUniqueMethod(\model_, { arg me, val;
		   
				//view.parentView.model = val;
			});
			playerview.layout.margins_(1);
			playerview.button.fixedWidth_(20);
			playerview.labelView.minWidth_(10);
			self.trackHeaders = self.trackHeaders ?? { nil ! self.trackCount };
			self.trackHeaders[trackidx] = playerview;
			"volume!!!".debug;
			playerview;
			//nil;
		}
	},

	makeOverlayMenu: { arg self, view, x, y, amodel;
		WindowDef(\OverlayMenu).front(view, x, y, { arg def;
			var model = amodel;
			VLayout (
				* [
					if(model.parentTrack.isEmpty.not) {
						if(model.isEmpty) {
							[
								BasicButton.new.string_("Create cell").action_({
									[model, model[\makeScore].asCompileString].debug("model");
									model.makeScore;
									def.closeWindow;
								}),
								BasicButton.new.string_("Create and edit cell").action_({
									[model].debug("model");
									model.makeScore;
									model.edit;
									def.closeWindow;
								}),
							]
						} {
							[
								BasicButton.new.string_("Edit cell").action_({
									model.edit;
									def.closeWindow;
								}),

								BasicButton.new.string_("Erase cell").action_({
									model.clear;
									def.closeWindow;
								}),
							]
						} ++ [
							BasicButton.new.string_("Edit track instrument").action_({
									model.parentTrack.editInstrument;
									def.closeWindow;
							}),
							BasicButton.new.string_("Erase track").action_({
									model.parentTrack.clearTrack;
									def.closeWindow;
							}),
						]
					},
					BasicButton.new.string_("Choose track template").action_({
						[model].debug("model");
						model.parentTrack.editTrackTemplate;
						def.closeWindow;
					}),
					Param(Message(model.parentTrack.parentTrack), \showTrackHeaders, ParamBoolSpec()).asButton("Show track headers"),
					Param(Message(model.parentTrack), \isMixerEnabled, ParamBoolSpec()).asButton("Enable mixer"),
				].flatten.select(_.notNil) ++ [nil]
			)
		})
	},
));
WindowDef(\customgrid).front(TrackDef(\myseq))
)


//////////////////////////////////////////



