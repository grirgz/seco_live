
(
TrackTemplateDef(\KitSeqGrid, (
	parent: TrackTemplateDef(\CustomTrackList),
	childClass: { TrackTemplateDef(\KitSeqTrack) },
	kit_: { arg self, kit;
		self[\kit] = kit;
		32.do { arg idx;
			self.childAt(idx)
		};
	},
));
TrackTemplateDef(\KitSeqTrack, (
	parent: TrackTemplateDef(\CustomInstrumentTrack),
	childClass: { TrackTemplateDef(\KitSeqTrackPart) },
	isEmpty: { arg self;
		if(self.parentTrack.kit.notNil and: { self.parentTrack.kit.childAt(self.index).isEmpty.not }) {
			false
		} {
			true
		};
	},

	kitItemPattern: { arg self;
		if(self.parentTrack.kit.notNil) {
			self.parentTrack.kit.childAt(self.index).target.asPattern
		};
	},

));
TrackTemplateDef(\KitSeqTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	outBus: { arg self;
		self.parentTrack.outBus;
	},
	outBus_: { arg self;
	},
	asPreview: { arg self;
		WindowDef(\KitSeqTrackPart_preview).asView(self.score);
	},
	makeScore: { arg self;
		self.score = Pdef(self.trackKey+++\score,Pbind());
		self.source = Pdef(self.trackKey+++\pat, Pbind(\isRest, Pkey(\kitseq).coin.not) <> self.score <> self.parentTrack.kitItemPattern);
	},
));

WindowDef(\KitSeqTrackPart_preview, { arg def, pdef;
	var prop = \kitseq;
	var defaultSize = 8;
	var defaultVal = 0;
	var spec = ControlSpec(0,1,\lin,1,0);
	var view = View.new;
	pdef.convertToPbindef;
	if(pdef.source.at(prop).source.isKindOf(PstepSeq).not) {
		// NOTE: use List instead of Array because Array not implemented in Param
		Pbindef(pdef.key, prop, PstepSeq(List.newFrom(defaultVal!defaultSize),inf));
	};
	view.layout_(HLayout(*
		Param( pdef, prop -> \stepseq, spec).collect { arg subp, idx;
			Button.new.states_([
				[ " ", Color.black, Color.white ],
				[ " ", Color.black, ParamViewToolBox.color_light ],
			]).action_({
				subp.set(subp.get + 1 % 2)

			}).value_(subp.get.debug("get===="))
		};
	))

});

TrackDef(\KitSeqGrid, TrackTemplateDef(\KitSeqGrid));
TrackDef(\KitSeqGrid).kit = PatKitDef(\kitrand2);
)

TrackDef(\KitSeqGrid).edit
TrackDef(\KitSeqGrid).clear
TrackDef(\KitSeqGrid).children
TrackDef(\KitSeqGrid).existingChildren
TrackDef(\KitSeqGrid).childAt(0,0).isEmpty
TrackDef(\KitSeqGrid).childAt(0).kitItemPattern
TrackDef(\KitSeqGrid).childAt(0,0).proxy.play
TrackDef(\KitSeqGrid).childAt(0,0)[\play].asCompileString
TrackDef(\KitSeqGrid).childAt(0,0).parentTrack.kitItemPattern
TrackDef(\KitSeqGrid).childAt(0,0).score.source.at(\kitseq).source.list
TrackDef(\KitSeqGrid).kit.childAt(0).target.asPattern



(
~drums = [
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.kick[1010].value,
		\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
		\isRest, Pseq([
			1,0,0,0, 0,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.1,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.snare[1719].value,
		\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
	Pbind(
		\instrument, \playersec,
		\bufnum, ~buflib.hat[1064].value,
		\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
		\isRest, Pseq([
			1,0,1,0, 1,0,1,0,
		],inf).coin.not,
		\dur, 1/8,
		\gain, 0.11,
	),
];
PatKitDef(\kitrand2, ~drums)
)
