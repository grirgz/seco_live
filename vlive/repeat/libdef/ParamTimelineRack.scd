
(
ParamProto.init;
FileSystemProject.load("libdef/ParamSelectDialog.scd");
FileSystemProject.load("libdef/CustomTrackList.scd");
TrackTemplateDef(\ParamTimelineRackTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\ParamTimelineRack) },

));
TrackTemplateDef(\ParamTimelineRack, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	//paramList
	edit: { arg self;
		WindowDef(\ParamTimelineRack).edit(self)
		
	},

	//playHook: { arg self;
		//self.paramList.debug("playHook");
		//self.paramList.do { arg asso, idx;
			//asso.value.play;
		//};
	//},
	//stopHook: { arg self;
		//self.paramList.do { arg asso, idx;
			//asso.value.stop;
		//};
	//},

	index: { arg self;
		// when standalone, use 0
		0
	},

	proxy: { arg self;
		PlayerWrapperGroup(self.paramList.collect(_.value))
	},

	isEmpty: { arg self;
		self.paramList.size == 0
	},

	isPlaying: { arg self;
		self.paramList.size > 0 and: {
			self.paramList.any({ arg asso; asso.value.isPlaying.not }).not
		}
	},
	
	paramList: { arg self;
		self[\paramList] = List.new;
		self[\paramList];
	},

	addParam: { arg self, param;
		// FIXME: if two param have same proprerty, names will clash
		var tline;
		if(self.getParamTimeline(param).isNil) {
			tline = ParamTimeline("%_%".format(self.trackKey, param.propertyRoot).asSymbol, param);
			self.paramList.add(param -> tline);
			self.changed(\paramList);
		};
	},

	removeParam: { arg self, param;
		
		var idx = self.paramList.detectIndex { arg x; x.key == param }.value;
		if(idx.notNil) {
			self.paramList.removeAt(idx);
			self.changed(\paramList);
		};
	},

	addParamDialog: { arg self;
		
		WindowDef(\ParamSelectDialog).front(nil, { arg param;
			param.debug("ParamSelectDialog param");
			self.addParam(param);

		})
	},

	getParamTimeline: { arg self, param;
		self.paramList.detect { arg x; x.key == param }.value
	},

	asPreview: { arg self, param;
		self.getParamTimeline(param).asPreview
	},

	asStackPreview: { arg self, initfun;
		StackLayout(
			*self.paramList.collect { arg item, idx;
				var preview;
				preview = item.value.asPreview;
				preview.background = Color.grey(1,0);
				initfun.(preview);
				preview;
			};
		).mode_(1)
	},

	asView: { arg self, param;
		self.getParamTimeline(param).asView
	},

	makeScore: { arg self;
		self.addParamDialog
	},

	asPattern: { arg self;
		if(self.paramList.size > 0) {
			Ppar(
				self.paramList.collect { arg asso, idx;
					var pt = asso.value;
					pt.asPattern;
				};
			)
		} {
			nil
		};
		
	},

));
WindowDef(\ParamTimelineRack, { arg def, model;
	var childview = View.new;
	childview.followChange(model, \paramList, {
		childview.removeAll;
		childview.layout = VLayout (
			*model.paramList.collect { arg asso, idx;
				HLayout (
					PlayerWrapperView(PlayerWrapper(asso.value)).label_("").asView.fixedSize_(30),
					asso.key.asStaticTextLabel(\full).fixedWidth_(100).attachContextMenu,
					asso.value.asPreview;
				)
			} ++ [nil]
		)
	});
	VLayout (
		HLayout (
			PlayerWrapper(model).asView,
			BasicButton.new.string_("Add ParamTimeline").action_({
				model.addParamDialog;
			})
		),
		childview
	)
	
});

TagSpecDef(\CustomTrackTemplate).addUnique(\ParamTimelineRackTrack -> TrackTemplateDef(\ParamTimelineRackTrack));

///// test

Pdef(\happysaw, 
	Pbind(
		\instrument, \saw,
		//\degree, Pseq([0,4,2,1],inf),
		//\dur, 1/2,
		\amp, 0.1/4,
	)
);

)

// END

ParamProto.init(true);
NoteTimeline(\bla1, Pdef(\happysaw)).play;
NoteTimeline(\bla1, Pdef(\happysaw)).edit
GridLayout
NoteTimeline(\bla1, Pdef(\happysaw)).cursor.startTime
NoteTimeline(\bla1, Pdef(\happysaw)).presetCompileString.editorInsert
(
NoteTimeline('bla1').param = Param(Pdef('happysaw'), 'midinote');
NoteTimeline('bla1').eventList = TimelineEventList.newFrom([
	(\absTime: 0.0, \amp: 0.025, \clockTime: 527.159060742, \dur: 0.0, \instrument: 'saw', \kitIndex: 60, \lpfr: 'c0', \midinote: 57.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.7741643620001, ),
	(\absTime: 0.0, \amp: 0.025, \clockTime: 527.154978584, \dur: 0.0, \instrument: 'saw', \kitIndex: 55, \lpfr: 'c0', \midinote: 52.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.807846125, ),
	(\absTime: 0.0, \amp: 0.025, \clockTime: 527.181485077, \dur: 0.0, \instrument: 'saw', \kitIndex: 64, \lpfr: 'c0', \midinote: 61.0, \playDur: 0.0, \relDur: 0.0, \sustain: 1.7534319890001, ),
	(\absTime: 0, \dur: 1.971723238, \label: 'start', \playDur: 1.971723238, \relDur: 1.971723238, \sustain: 0, \type: 'start', ),
	(\absTime: 1.971723238, \amp: 0.025, \clockTime: 529.171723238, \dur: 0.020026669999993, \instrument: 'saw', \kitIndex: 58, \lpfr: 'c0', \midinote: 55.0, \playDur: 0.020026669999993, \relDur: 0.020026669999993, \sustain: 0.99333295299994, ),
	(\absTime: 1.991749908, \amp: 0.025, \clockTime: 529.191749908, \dur: 0.00039302799996221, \instrument: 'saw', \kitIndex: 64, \lpfr: 'c0', \midinote: 61.0, \playDur: 0.00039302799996221, \relDur: 0.00039302799996221, \sustain: 1.838393139, ),
	(\absTime: 1.992142936, \amp: 0.025, \clockTime: 529.192142936, \dur: 1.032635876, \instrument: 'saw', \kitIndex: 55, \lpfr: 'c0', \midinote: 52.0, \playDur: 1.032635876, \relDur: 1.032635876, \sustain: 1.905459475, ),
	(\absTime: 3.024778812, \amp: 0.025, \clockTime: 530.224778812, \dur: 0.99422949500001, \instrument: 'saw', \kitIndex: 58, \lpfr: 'c0', \midinote: 55.0, \playDur: 0.99422949500001, \relDur: 0.99422949500001, \sustain: 0.75423092900007, ),
	(\absTime: 4.019008307, \amp: 0.025, \clockTime: 531.219008307, \dur: 0.051321134999966, \instrument: 'saw', \kitIndex: 55, \lpfr: 'c0', \midinote: 52.0, \playDur: 0.051321134999966, \relDur: 0.051321134999966, \sustain: 1.931548103, ),
	(\absTime: 4.0703294419999, \amp: 0.025, \clockTime: 531.270329442, \dur: 0.00048051100009161, \instrument: 'saw', \kitIndex: 65, \lpfr: 'c0', \midinote: 62.0, \playDur: 0.00048051100009161, \relDur: 0.00048051100009161, \sustain: 1.827485441, ),
	(\absTime: 4.070809953, \amp: 0.025, \clockTime: 531.270809953, \dur: 1.9412102169999, \instrument: 'saw', \kitIndex: 60, \lpfr: 'c0', \midinote: 57.0, \playDur: 1.9412102169999, \relDur: 1.9412102169999, \sustain: 1.889219252, ),
	(\absTime: 6.01202017, \amp: 0.025, \clockTime: 533.21202017, \dur: 0.049237027999993, \instrument: 'saw', \kitIndex: 60, \lpfr: 'c0', \midinote: 57.0, \playDur: 0.049237027999993, \relDur: 0.049237027999993, \sustain: 0.93164143800004, ),
	(\absTime: 6.061257198, \amp: 0.025, \clockTime: 533.261257198, \dur: 0.00059230199997273, \instrument: 'saw', \kitIndex: 55, \lpfr: 'c0', \midinote: 52.0, \playDur: 0.00059230199997273, \relDur: 0.00059230199997273, \sustain: 1.785791499, ),
	(\absTime: 6.0618494999999, \amp: 0.025, \clockTime: 533.2618495, \dur: 1.014238276, \instrument: 'saw', \kitIndex: 64, \lpfr: 'c0', \midinote: 61.0, \playDur: 1.014238276, \relDur: 1.014238276, \sustain: 0.81841969100003, ),
	(\absTime: 7.076087776, \amp: 0.025, \clockTime: 534.276087776, \dur: 0.0058855199999925, \instrument: 'saw', \kitIndex: 62, \lpfr: 'c0', \midinote: 59.0, \playDur: 0.0058855199999925, \relDur: 0.0058855199999925, \sustain: 0.74838108000006, ),
	(\absTime: 7.0819732959999, \amp: 0.025, \clockTime: 534.281973296, \dur: 0.88668511399999, \instrument: 'saw', \kitIndex: 60, \lpfr: 'c0', \midinote: 57.0, \playDur: 0.88668511399999, \relDur: 0.88668511399999, \sustain: 0.73768837800003, ),
	(\absTime: 7.9686584099999, \amp: 0.025, \clockTime: 535.16865841, \dur: 0.0064885000000459, \instrument: 'saw', \kitIndex: 57, \lpfr: 'c0', \midinote: 54.0, \playDur: 0.0064885000000459, \relDur: 0.0064885000000459, \sustain: 1.89060068, ),
	(\absTime: 7.97514691, \amp: 0.025, \clockTime: 535.17514691, \dur: 0.0042183489999843, \instrument: 'saw', \kitIndex: 60, \lpfr: 'c0', \midinote: 57.0, \playDur: 0.0042183489999843, \relDur: 0.0042183489999843, \sustain: 1.841266903, ),
	(\absTime: 7.979365259, \amp: 0.025, \clockTime: 535.179365259, \dur: 2.0423164590001, \instrument: 'saw', \kitIndex: 53, \lpfr: 'c0', \midinote: 50.0, \playDur: 2.0423164590001, \relDur: 2.0423164590001, \sustain: 1.872038834, ),
	(\absTime: 10.021681718, \amp: 0.025, \clockTime: 537.221681718, \dur: 0.024927200999969, \instrument: 'saw', \kitIndex: 57, \lpfr: 'c0', \midinote: 54.0, \playDur: 0.024927200999969, \relDur: 0.024927200999969, \sustain: 1.970680221, ),
	(\absTime: 10.046608919, \amp: 0.025, \clockTime: 537.246608919, \dur: 0.00044909799999004, \instrument: 'saw', \kitIndex: 53, \lpfr: 'c0', \midinote: 50.0, \playDur: 0.00044909799999004, \relDur: 0.00044909799999004, \sustain: 1.9505194769999, ),
	(\absTime: 10.047058017, \amp: 0.025, \clockTime: 537.247058017, \dur: 1.551640924, \instrument: 'saw', \kitIndex: 62, \lpfr: 'c0', \midinote: 59.0, \playDur: 1.551640924, \relDur: 1.551640924, \sustain: 1.528216941, ),
	(\absTime: 11.598698941, \amp: 0.025, \clockTime: 538.798698941, \dur: 0.49065725100002, \instrument: 'saw', \kitIndex: 61, \lpfr: 'c0', \midinote: 58.0, \playDur: 0.49065725100002, \relDur: 0.49065725100002, \sustain: 0.278282558, ),
	(\absTime: 12.089356192, \amp: 0.025, \clockTime: 539.289356192, \dur: 0.0069345539999404, \instrument: 'saw', \kitIndex: 57, \lpfr: 'c0', \midinote: 54.0, \playDur: 0.0069345539999404, \relDur: 0.0069345539999404, \sustain: 1.7832039269999, ),
	(\absTime: 12.096290746, \amp: 0.025, \clockTime: 539.296290746, \dur: 0.019186811000054, \instrument: 'saw', \kitIndex: 60, \lpfr: 'c0', \midinote: 57.0, \playDur: 0.019186811000054, \relDur: 0.019186811000054, \sustain: 1.7553085100001, ),
	(\absTime: 12.115477557, \amp: 0.025, \clockTime: 539.315477557, \dur: 1.894879072, \instrument: 'saw', \kitIndex: 53, \lpfr: 'c0', \midinote: 50.0, \playDur: 1.894879072, \relDur: 1.894879072, \sustain: 1.733683395, ),
	(\absTime: 14.010356629, \amp: 0.025, \clockTime: 541.210356629, \dur: 0.0032686150000245, \instrument: 'saw', \kitIndex: 57, \lpfr: 'c0', \midinote: 54.0, \playDur: 0.0032686150000245, \relDur: 0.0032686150000245, \sustain: 1.763693076, ),
	(\absTime: 14.013625244, \amp: 0.025, \clockTime: 541.213625244, \dur: 0.021766634999949, \instrument: 'saw', \kitIndex: 62, \lpfr: 'c0', \midinote: 59.0, \playDur: 0.021766634999949, \relDur: 0.021766634999949, \sustain: 0.85965702699991, ),
	(\absTime: 14.035391879, \amp: 0.025, \clockTime: 541.235391879, \dur: 0.81307746900006, \instrument: 'saw', \kitIndex: 53, \lpfr: 'c0', \midinote: 50.0, \playDur: 0.81307746900006, \relDur: 0.81307746900006, \sustain: 1.7490419860001, ),
	(\absTime: 14.848469348, \amp: 0.025, \clockTime: 542.048469348, \dur: 0.6358614909999, \instrument: 'saw', \kitIndex: 64, \lpfr: 'c0', \midinote: 61.0, \playDur: 0.6358614909999, \relDur: 0.6358614909999, \sustain: 0.58368725599996, ),
	(\absTime: 15.484330839, \amp: 0.025, \clockTime: 542.684330839, \dur: 0.51566916100006, \instrument: 'saw', \kitIndex: 62, \lpfr: 'c0', \midinote: 59.0, \playDur: 0.51566916100006, \relDur: 0.51566916100006, \sustain: 0.25647749500001, ),
	(\absTime: 16.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

ParamTimeline('AutomationRack_noteTimeline_bla1_lpfr').param = Param(Pdef('happysaw'), 'lpfr');
ParamTimeline('AutomationRack_noteTimeline_bla1_lpfr').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \curve: 0, \dur: 1.0, \legato: 1, \level: 2.0695252745375, \midinote: 0, \next_absTime: 1.0, \next_level: 2.0749690210657, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 1.0, \curve: 0, \dur: 0.375, \legato: 1, \level: 2.0749690210657, \midinote: 0, \next_absTime: 1.375, \next_level: 2.2605007904969, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 1.375, \curve: 0, \dur: 0.375, \legato: 1, \level: 2.2605007904969, \midinote: 0, \next_absTime: 1.75, \next_level: 0.91189591078067, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 1.75, \curve: 0.35, \dur: 0.25, \legato: 1, \level: 0.91189591078067, \midinote: 0, \next_absTime: 2.0, \next_level: 2.0365295047643, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.0, \curve: 0, \dur: 0.25, \legato: 1, \level: 2.0365295047643, \midinote: 0, \next_absTime: 2.25, \next_level: 2.9416356877324, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 2.25, \curve: 0, \dur: 0.75, \legato: 1, \level: 2.9416356877324, \midinote: 0, \next_absTime: 3.0, \next_level: 2.7386617100372, \playDur: 0.75, \relDur: 0.75, \sustain: 0.75, ),
	(\absTime: 3.0, \curve: -3.8, \dur: 1.0, \legato: 1, \level: 2.7386617100372, \midinote: 0, \next_absTime: 4.0, \next_level: 0.60743494423792, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, ),
	(\absTime: 4.0, \curve: 0, \dur: 0.5, \legato: 1, \level: 0.60743494423792, \midinote: 0, \next_absTime: 4.5, \next_level: 1.3468401486989, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 4.5, \curve: 0.35, \dur: 0.375, \legato: 1, \level: 1.3468401486989, \midinote: 0, \next_absTime: 4.875, \next_level: 3.7390334572491, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 4.875, \curve: 0, \dur: 0.375, \legato: 1, \level: 3.7390334572491, \midinote: 0, \next_absTime: 5.25, \next_level: 1.0568773234201, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 5.25, \dur: 0.5, \legato: 1, \level: 1.0568773234201, \midinote: 0, \next_absTime: 5.75, \next_level: 0.50594795539033, \playDur: 0.5, \relDur: 0.5, \sustain: 0.5, ),
	(\absTime: 5.75, \dur: 0.75, \legato: 1, \level: 0.50594795539033, \midinote: 0, \next_absTime: 6.5, \next_level: 2.4052044609665, \playDur: 0.75, \relDur: 0.75, \sustain: 0.75, ),
	(\absTime: 6.5, \dur: 0.875, \legato: 1, \level: 2.4052044609665, \midinote: 0, \next_absTime: 7.375, \next_level: 1.0133828996283, \playDur: 0.875, \relDur: 0.875, \sustain: 0.875, ),
	(\absTime: 7.375, \dur: 0.375, \legato: 1, \level: 1.0133828996283, \midinote: 0, \next_absTime: 7.75, \next_level: 2.1152416356877, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
	(\absTime: 7.75, \dur: 0.25, \legato: 1, \level: 2.1152416356877, \midinote: 0, \next_absTime: 8.0, \next_level: 2.057249070632, \playDur: 0.25, \relDur: 0.25, \sustain: 0.25, ),
	(\absTime: 8.0, \dur: 0.0, \legato: 1, \level: 2.057249070632, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1, ),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);



NoteTimeline(\bla1).automationRack.paramList
NoteTimeline(\bla1).automationRack.paramList.first.value.param
NoteTimeline(\bla1).automationRack.paramList.first.value.isPlaying
NoteTimeline(\bla1).automationRack.paramList.first.value.edit
NoteTimeline(\bla1).automationRack.paramList.first.value.play
NoteTimeline(\bla1).automationRack.paramList.first.value.presetCompileString.editorInsert
NoteTimeline(\bla1).automationRack.paramList
NoteTimeline(\bla1).automationRack.edit
(
WindowDef(\win, { arg def;
	StackLayout(
		*NoteTimeline(\bla1).automationRack.paramList.collect { arg item, idx;
			var preview;
			preview = item.value.asPreview;
			preview.background = Color.grey(1,0);
			preview;
		};
	).mode_(1)
	
}).front;
);
(
);


~p  = NoteTimeline(\bla1).automationRack.paramList.first.value.asPatternEvent
~pt = NoteTimeline(\bla1).automationRack.paramList.first.value
~pt.eventList.totalDur
Ppar([Pseq([~p])]).play
~p
NoteTimeline(\bla1).automationRack.playNow
NoteTimeline(\bla1).automationRack.proxy.asPattern
NoteTimeline(\bla1).automationRack.asPattern.list
NoteTimeline(\bla1).automationRack.asPattern.list

NoteTimeline(\bla1).automationRack.playNow

Pdef(\happysaw, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,4,2,1],inf),
		\dur, 1/2,
		\amp, 0.1,
	)
);
TrackDef(\ptr, \ParamTimelineRack);
TrackDef(\ptr).edit
TrackDef(\ptr).paramList
TrackDef(\ptr).proxy.stop
TrackDef(\ptr).play
TrackDef(\ptr).stop
TrackDef(\ptr).parentActiveIndex
TrackDef(\ptr).index
TrackDef(\ptr).refCompileString
TrackDef(\ptr).trackKey
TrackDef(\ptr).isEmpty
TrackDef(\ptr).playHook
TrackDef(\ptr).play
NoteTimeline(\aze).edit
(
ParamProto.init(true);
Pdef(\happysaw, 
	Pbind(
		\instrument, \saw,
		//\degree, Pseq([0,4,2,1],inf),
		//\dur, 1/2,
		//\amp, 0.1,
	)
);
)
NoteTimeline(\bla3, Pdef(\happysaw)).edit
ParamTimeline(\aze2, Param(Pdef(\happysaw), \lpfr)).edit

TrackDef(\ptrack, \ParamTimelineRackTrack);
TrackDef(\ptrack).childAt(0).edit;

TrackDef(\myc, \CustomTrackList).edit

(
);
Pdef(\happysaw).play
TrackDef(\ptr).paramList.first.value.param
TrackDef(\ptr).paramList.first.value.stop
TrackDef(\ptr)[\play].asCompileString
ProtoD
TrackDef(\ptr).isEmpty
TrackDef(\ptr).parent.parent.parent
TrackDef(\ptr).parent.parent

NoteTimeline(\bla).edit

//// test very long timeline
(
NoteTimeline('bla1').param = Param(Pdef('happysaw'), 'midinote');
NoteTimeline('bla1').eventList = TimelineEventList.newFrom([
		(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
		(\absTime: 0.0, \dur: 0.625, \midinote: 66.0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.375, ),
		(\absTime: 0.625, \dur: 0.375, \midinote: 83.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
		(\absTime: 1.0, \dur: 0.0, \midinote: 63.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
		(\absTime: 1.375, \dur: 0.375, \midinote: 70.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
		(\absTime: 1.75, \dur: 0.5, \midinote: 78.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
		(\absTime: 2.25, \dur: 1.0, \midinote: 76.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.625, ),
		(\absTime: 3.25, \dur: 0.375, \midinote: 84.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.625, ),
		(\absTime: 3.625, \dur: 1.125, \midinote: 70.0, \playDur: 1.125, \relDur: 1.125, \sustain: 0.75, ),
		(\absTime: 4.75, \dur: 0.75, \midinote: 62.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.625, ),
		(\absTime: 5.5, \dur: 0.5, \midinote: 72.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
		(\absTime: 6.0, \dur: 0.625, \midinote: 93.0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.5, ),
		(\absTime: 6.625, \dur: 0.875, \midinote: 76.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.625, ),
		(\absTime: 7.5, \dur: 0, \midinote: 80.0, \playDur: 0, \relDur: 0, \sustain: 0.5, ),
	100.collect {

		[
		(\absTime: 0.0, \dur: 0.625, \midinote: 66.0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.375, ),
		(\absTime: 0.625, \dur: 0.375, \midinote: 83.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
		(\absTime: 1.0, \dur: 0.0, \midinote: 63.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
		(\absTime: 1.375, \dur: 0.375, \midinote: 70.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.375, ),
		(\absTime: 1.75, \dur: 0.5, \midinote: 78.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.375, ),
		(\absTime: 2.25, \dur: 1.0, \midinote: 76.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.625, ),
		(\absTime: 3.25, \dur: 0.375, \midinote: 84.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.625, ),
		(\absTime: 3.625, \dur: 1.125, \midinote: 70.0, \playDur: 1.125, \relDur: 1.125, \sustain: 0.75, ),
		(\absTime: 4.75, \dur: 0.75, \midinote: 62.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.625, ),
		(\absTime: 5.5, \dur: 0.5, \midinote: 72.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.25, ),
		(\absTime: 6.0, \dur: 0.625, \midinote: 93.0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.5, ),
		(\absTime: 6.625, \dur: 0.875, \midinote: 76.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.625, ),
		(\absTime: 7.5, \dur: 0, \midinote: 80.0, \playDur: 0, \relDur: 0, \sustain: 0.5, ),
		]
	}
].flat);
);

[[[[]]]].flat
NoteTimeline(\bla1).edit

NoteTimeline('bla1').eventList = TimelineEventList.newFrom( Pbind(\midinote, Pwhite(0,12*4)+24,\dur,1/16), 10000/2)
NoteTimeline('bla1').eventList.totalDur / ~t / 60 

~t
10 / ~t
~t = 185/4/60; TempoClock.default.tempo = ~t;
NoteTimeline('bla1').eventList = TimelineEventList.newFrom( Pbind(\midinote, Pwhite(0,12*4)+24,\dur,1/16), 1000)



NoteTimeline('bla1').eventList = TimelineEventList.newFrom( Pbind(\midinote, Pwhite(0,12*5)+24,\dur,4), 1000)


PatternPlayer
Pattern
EventPatternProxy
NoteTimeline('bla1').play
NoteTimeline('bla1').proxy.player.routine.beats
TempoClock.default.beats
Ptime

(
Pdef(\rere, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([6,5,6,5,6,5,6,5],inf),
		\octave, 5,
		\legato, 0.1 * Pwhite(1,9.0),
		\pan, Pbrown(-1,1),
		\dur, Prand([1/8],inf),
		\isRest, Pseq([
			Prand([
				Pseq([
					0.3,0.4,0.5,
				],1),
				Pseq([
					1,0.3,0.4,0,
				],1),
				Pseq([
					1,0.7,0.7,0,
				],1),
				Pseq([
					0.5,0.1,0.1,0.1,
				],1),
			],1),
		],inf).coin.not,
		\amp, 0.1/2 * Pwhite(0.6,1),
	)
).play;
);

ParamTimeline(\azaz).edit
ParamTimeline(\rdn).edit
NoteTimeline(\aaa).edit
KitTimeline(\zzz).edit
ClipTimeline(\aaa).edit
FileSystemProject.load("capsule/PatKitDef_comkit.scd");


Fil
NoteTimeline(\aze).presetCompileString.editorInsert
(
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
NoteTimeline('aze').param = Param(Pdef('NoteTimeline_default'), 'midinote');
NoteTimeline('aze').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	(\absTime: 0.25, \dur: 0.375, \midinote: 78.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.625, ),
	(\absTime: 0.625, \curve: 0, \dur: 0.625, \midinote: 68.0, \playDur: 0.625, \relDur: 0.625, \sustain: 2.2019714490019, ),
	(\absTime: 1.25, \dur: 6.75, \midinote: 54.0, \playDur: 6.75, \relDur: 6.75, \sustain: 0.625, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
NoteTimeline(\aze).edit;
);

\sustain.asSpec
NoteTimeline(\aze).selection_cursor.selection_rect
NoteTimeline(\aze).selection_cursor.gtgt
CursorTimeline

(
Pdef(\bla, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
ParamTimeline(\vvv, Param(Pdef(\bla), \freq)).edit
ParamTimeline(\vvvpan, Param(Pdef(\bla), \pan)).edit
ParamTimeline(\vvv).eventList.print
ParamTimeline(\vvvpan).eventList.print
-0.11.clip(-0.4,inf)
ParamTimeline(\vvvleg, Param(Pdef(\bla), \legeto, \unipolar)).edit
ParamTimeline(\vvvleg).eventList.print
NoteTimeline(\nono).edit
(
WindowDef(\win, { arg def;
	VLayout (
		NoteTimeline(\nono).editor.timeline
	)
}).front;
);

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq.poll * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\sss, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\amp, 0.1,
	)
).play;
);


ClipTimeline(\koko).edit
ClipTimeline(\koko).presetCompileString.editorInsert

ParamTimeline(\hey).edit
ParamTimeline(\hey).presetCompileString.editorInsert
(
ClipTimeline('koko').tracks = [ ( 'index': 0, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 1, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 2, 'recordArmed': false, 'recordBus': 0, 'muted': false ), ( 'index': 3, 'recordArmed': false, 'recordBus': 0, 'muted': false ) ];
{
ClipTimeline('koko').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 1.375, \label: 'start', \playDur: 1.375, \relDur: 1.375, \sustain: 0, \type: 'start', ),
	PlayerEvent((\absTime: 1.375, \dur: 6.625, \legato: 1, \midinote: 1.0, \playDur: 6.625, \receiver: PlayerWrapper(ParamTimeline('hey')), \relDur: 6.625, \sustain: 3.75, \type: 'player', )),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
 }.value;


ParamTimeline('hey').param = Param(Message(( 'empty': 1 )), 'empty', 'unipolar');
ParamTimeline('hey').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \curve: 0.35, \dur: 1.125, \legato: 1, \level: 0.37328767123288, \midinote: 0, \playDur: 1.125, \relDur: 1.125, \sustain: 1, ),
	(\absTime: 1.125, \dur: 0.875, \legato: 1, \level: 0.59931506849315, \midinote: 0, \playDur: 0.875, \relDur: 0.875, \sustain: 1, ),
	(\absTime: 2.0, \curve: -0.35, \dur: 1.25, \legato: 1, \level: 0.28424657534247, \midinote: 0, \playDur: 1.25, \relDur: 1.25, \sustain: 1, ),
	(\absTime: 3.25, \curve: 0.35, \dur: 1.625, \legato: 1, \level: 0.64383561643836, \midinote: 0, \playDur: 1.625, \relDur: 1.625, \sustain: 1, ),
	(\absTime: 4.875, \dur: 1.25, \legato: 1, \level: 0.39041095890411, \midinote: 0, \playDur: 1.25, \relDur: 1.25, \sustain: 1, ),
	(\absTime: 6.125, \curve: 0.25, \dur: 1.125, \legato: 1, \level: 0.78082191780822, \midinote: 0, \playDur: 1.125, \relDur: 1.125, \sustain: 1, ),
	(\absTime: 7.25, \dur: 0.75, \legato: 1, \level: 0.39041095890411, \midinote: 0, \playDur: 0.75, \relDur: 0.75, \sustain: 1, ),
	(\absTime: 8.0, \dur: 0.0, \legato: 1, \level: 0.46917808219178, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
ClipTimeline(\koko).edit;
);

