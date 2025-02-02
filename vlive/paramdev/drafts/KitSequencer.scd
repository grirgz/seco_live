(
FileSystemProject.loadOnce("paramdev/drafts/FxTimeline.scd");
FileSystemProject.loadOnce("paramdev/drafts/KitSeqTrack.scd");

WindowDef(\KitSequencer, (
	asView: { arg self, def, kitseqgrid, currentSection;
		self.kitSeqGrid = kitseqgrid;
		if(currentSection.notNil) {
			self.currentSection = currentSection;
		};
		
		self.makeLayout;
	},

	makeLayout: { arg self;
		VLayout (
			self.makeToolbar,
			self.makeSeqGridView,
		)
	},

	seqSize_: { arg self, val;
		val = val.asInteger;
		val.debug("change size");
		self.kitSeqGrid.sectionAt(self.currentSection).seqSize = val;
		[ self.kitSeqGrid.sectionAt(self.currentSection).seqSize ].debug("seqSize after");
		self.seqParams.do { arg param, idx;
			var li = param.get;
			var mod = self.modViewList[idx];
			//li.dump;
			if(val > li.size) {
				li = li.extend(val, li.last);
			} {
				li = li.keep(val);
			};
			param.set(li);
			mod.seqSize = param.size;
		};
		self.changed(\seqSize);
	},
	seqSize: { arg self;
		self.kitSeqGrid.sectionAt(self.currentSection).seqSize ? 8;
	},

	stepDur_: { arg self, val;
		self.kitSeqGrid.sectionAt(self.currentSection).stepDur = val;
		self.seqParams.do { arg param, idx;
			var mod = self.modViewList[idx];
			mod.stepDur = val;
		};
		self.changed(\stepDur);
	},
	stepDur: { arg self;
		self.kitSeqGrid.sectionAt(self.currentSection).stepDur ?? { 1/8 };
	},

	makeToolbar: { arg self;
		self.sectionPlayerView = PlayerWrapperView();
		HLayout (
			self.sectionPlayerView,
			HLayout (
				StaticText.new.string_("Section:"),
				Param(Message(self), \currentSection, ControlSpec(0,31,\lin,1,0)).asNumberBox,
			),
			HLayout (
				StaticText.new.string_("Size:"),
				Param(Message(self), \seqSize, ControlSpec(1,32,\lin,1,8)).asNumberBox,
			),
			HLayout (
				StaticText.new.string_("Dur:"),
				Param(Message(self), \stepDur, ControlSpec(1/16,4,\lin,0,1/8)).asNumberBox,
			),
		)
	},

	currentSection: 0,
	currentSection_: { arg self, val;
		self[\currentSection] = val;
		self.changed(\currentSection);
		self.kitSeqGrid.changed(\tracks);
	},

	seqItems: { arg self;
		var item = self.kitSeqGrid.sectionAt(self.currentSection);
		self.kitSeqGrid.existingChildren.collect { arg header, idx;
			item.childAt(header.index);
		};
	},

	seqParams: { arg self;
		self.seqItems.collect { arg item, idx;
			Param(item.score, \kitseq -> \stepseq);
		};
	},

	makeSeqGridView: { arg self;
		self.seqGridView = View.new;
		self.seqGridView.followChange(self.kitSeqGrid, \tracks, {
			var item = self.kitSeqGrid.sectionAt(self.currentSection);
			if(item.isEmpty) {
				item.makeScore;
			};
			self.sectionPlayerView.model = PlayerWrapper(item);
			self.modViewList = [];
			self.seqGridView.removeAll;
			self.seqGridView.layout = VLayout (
				* self.kitSeqGrid.existingChildren.collect { arg header, idx;
					var seqitem;
					var param;
					var mod;
					seqitem = item.childAt(header.index);
					if(seqitem.isEmpty) {
						seqitem.makeScore;
					};
					param = Param(seqitem.score, \kitseq -> \stepseq);
					param.initPstepSeq(8);
					~param = param;
					mod = WindowDef(\ModulatorStrip_slider).asView( param ).minHeight_(40);
					self.modViewList = self.modViewList.add(mod.proto);
					self.changed(\seqSize);
					HLayout (
						PlayerWrapperView(PlayerWrapper(seqitem)).label_("%: %".format(header.index, param.propertyRoot)).view.fixedWidth_(70),
						mod,
					)
				}.asArray
			)


		});
		self.seqGridView;
	},

));

WindowDef(\KitSequencerPreview, (
	parent: WindowDef(\KitSequencer).proto,

	asView: { arg self, def, section;
		self.section = section;
		
		self.makeLayout;
	},


	makeLayout: { arg self;
		self.makeSeqGridView
	},

	makeSeqGridView: { arg self;
		self.seqGridView = View.new;
		self.seqGridView.followChange(self, \tracks, {
			var item = self.section;
			//if(item.isEmpty) {
				//item.makeScore;
			//};
			//self.sectionPlayerView.model = PlayerWrapper(item);
			self.seqGridView.removeAll;
			self.seqGridView.layout = VLayout (
				* self.section.existingChildren.collect { arg seqitem, idx;
					var param;
					var modstrip;
					//if(seqitem.isEmpty) {
						//seqitem.makeScore;
					//};
					param = Param(seqitem.score, \kitseq -> \stepseq);
					modstrip = WindowDef(\ModulatorStrip_slider).asView( param );
					modstrip.proto.shouldDrawBarLabel = false;
					modstrip.minHeight_(5);
					modstrip.proto.colors.empty = Color.grey(0.8);
					//param.initPstepSeq(8);
					modstrip
				}.asArray
			).spacing_(1).margins_(1)


		});
		self.seqGridView;
	},

));

//// debug

TrackDef(\hel4, \TrackList);
~tra = TrackDef(\hel4).childAt(0);
~tra.trackTemplate = TrackTemplateDef(\KitSeqGridTrack);
~tra.grid.kit = PatKitDef(\comkit);
WindowDef(\KitSequencer).front( ~tra.grid );
TrackDef(\hel4).edit;
)

// END
/////////////

TrackDef(\hel4).editGrid
TrackDef(\hel4).edit
TrackDef(\hel4).selectedPart
TrackDef(\hel4).childAt(0,0).key
TrackDef(\hel4).childAt(0).grid.existingChildren
~tra.childAt(0).existingChildren
~tra.grid.existingChildren
~tra.grid.kit = PatKitDef(\comkit)
~tra.grid.editGrid
~tra.grid.childAt(0,0).play
~tra.grid.childAt(0,0).isPlaying
~tra.grid.childAt(0,0).source.source.patterns


PatKitDef(\comkit).edit

( Pbind() <> nil ).play


(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\zed, 
	Pmono(\zed,
		\freq, Pseg(Pseq([200,1000],inf),8),
		\dur, 1/32,
		\amp, 0.1,
	),
).play;
);
