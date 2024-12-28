// moved to param quark

//// GUI


// grid
(


WindowDef(\CustomInstrumentTrack_TemplateEditor, { arg def, track;
	var default;	
	var parent;
	parent = track.parent;
	VLayout (
		HLayout (
			StaticText.new.string_("label:"),
			Param( Message(track), \label, ).asTextField,
		),
		Param( Message(track), \trackTemplate, TagSpecDef(\CustomTrackTemplate) ).asPopUpMenu,
		nil
	)
});
);


// tracklist
(

);


(

WindowDef(\sampleEditor, { arg def, param;
	var popup;
	var spec;
	var curval, editcurval;
	var target = param.target;
	curval = StaticText.new.minWidth_(80).align_(\right);
	editcurval = TextField.new;
	spec = ParamAudioBufferSpec(2)
		.startParamName_(\pos)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed)
		;
	param.spec = spec;

	curval.followChange(Param, \lastTweaked, { arg view; 
		//"there is a change! %: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet).postln;

		// map the last changed Param to the StaticText and TextField
		curval.mapParamLabel(Param.lastTweaked);
		editcurval.mapParam(Param.lastTweaked);
	});

	VLayout (
		HLayout (
			PlayerWrapper(target),
			curval, 
			editcurval,
		),
		HLayout (
			WindowDef(\ParamAsSoundFileView).asView(param),
			VLayout(
				* [
					Param(target, \pos, \unipolar),
					Param(target, \sustain, ControlSpec(0,10,\lin)),
					Param(target, \speed, ControlSpec(-2,2,\lin,0,1)),
				].collect({ arg pa;
					ParamGroupLayout.knobView(pa);
				}) ++ [nil]
			),
		),
		param.asView,
		Param(target, \gain, \unipolar).asView,
		Param(target, \dur, ControlSpec(0.1,8,\exp)).asView,
		Param(target, \adsr ).asView,
	)
});
);


//////// experimental sequencing

(
SynthDef(\seqtrack_sampler, { arg out=0, gate=1, speed=1, pos=0, trigger=1, loop=0, bufnum;
	var sig;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1) * \velamp.kr(1);
	Out.ar(out, sig);
}).add;

TrackTemplateDef(\SeqTrack, (
	parent: TrackTemplateDef(\CustomTrack),
	childClass: { TrackTemplateDef(\SeqTrackPart) },
	base: { arg self;
		self[\base] = Pbindef(self.name+++\base,
			\instrument, \seqtrack_sampler,
			\muter, Pfunc({ arg ev; if(ev[\velamp] > 0) {0} {\rest} }),
		);
		self[\base]
	},
	trackEditor: { arg self;
		WindowDef(self.name+++\trackeditor, { arg def, child;
			WindowDef(\sampleEditor).asView(Param(self.base, \bufnum))
		});
	},
	editor: { arg self;
		WindowDef(self.name, { arg def, child;
			//[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.score.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.score);
					Param(child.score, \velamp -> \stepseq, \unipolar).asMultiSlider;
				}
				//Slider.new,
			)
		});
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%".format(self.base.asParamGroup.getSetCompileString("%.base".format(self.refCompileString))));
		str.join($\n);
	},

	makeScore: { arg self;
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\SeqTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	outBus_: { arg self, val;
		if(self.scoreproxy.notNil) {
			self.scoreproxy.set(\out, val);
		};
	},

	outBus: { arg self;
		if(self.scoreproxy.notNil) {
			self.scoreproxy.get(\out);
		} {
			self.parentTrack.outBus
		}
	},
	asPreview: { arg self;
		var view = View.new;
		view.layout = WindowDef(self.parentTrack.name, { arg def, child;
			//[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.scoreproxy.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.scoreproxy);
					Param(child.scoreproxy, \velamp -> \stepseq, \unipolar).asMultiSlider.mouseDownAction_({ 
						arg view, x, y, modifiers, buttonNumber, clickCount;
						//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
						if(buttonNumber == 1) { // right click
							self.edit;
							false;
						};
					});
				};
				//Slider.new,
			).spacing_(0).margins_(0)
		}).asView(self);
		view;
		//View.new.layout_(self.parentTrack.editor.asView(self))
	},

	score: { arg self;
		if(self.scoreproxy.notNil) {
			self.scoreproxy.source.at(\velamp).source.list
		};
	},

	score_: { arg self, list;
		if(self.scoreproxy.isNil) {
			self.makeScore;
		}; 
		self.scoreproxy.source.at(\velamp).source.list = list;
	},

	scorePresetCompileString: { arg self;
		var str;
		str = List.new;
		str.add( "%.score = %;".format(self.refCompileString, self.score.asCompileString));
		str.join($\n);
	},

	makeScore: { arg self;
		//self.proxy.debug("makeScore proxy start");
		self[\scoreproxy] = Pbindef(self.name+++\seq, \velamp, PstepSeq(0!8,inf));
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.parentTrack.base <>
			self.scoreproxy
		));
		//self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\SeqTrack -> TrackTemplateDef(\SeqTrack));
);



(
TrackTemplateDef(\SeqCoinTrack, (
	parent: TrackTemplateDef(\CustomTrack),
	childClass: { TrackTemplateDef(\SeqCoinTrackPart) },
	base: { arg self;
		self[\base] = Pbindef(self.name+++\base,
			\instrument, \seqtrack_sampler,
			\muter, Pfunc({ arg ev; if(ev[\coin].coin) { 0 } { \rest } }),
		);
		self[\base]
	},
	trackEditor: { arg self;
		WindowDef(self.name+++\trackeditor, { arg def, child;
			WindowDef(\sampleEditor).asView(Param(self.base, \bufnum))
		});
	},
	editor: { arg self;
		WindowDef(self.name, { arg def, child;
			//[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.score.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.score);
					Param(child.score, \coin -> \stepseq, \unipolar).asMultiSlider;
				}
				//Slider.new,
			)
		});
	},
	makeScore: { arg self;
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\SeqCoinTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	makeScore: { arg self;
		//self.proxy.debug("makeScore proxy start");
		self[\score] = Pbindef(self.name+++\seq, \coin, PstepSeq(0!8,inf));
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.parentTrack.base <>
			self.score
		));
		//self.proxy.debug("makeScore proxy");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\SeqCoinTrack -> TrackTemplateDef(\SeqCoinTrack));
);



(
TrackTemplateDef(\AutoSeqTrack, (
	parent: TrackTemplateDef(\CustomTrack),
	childClass: { TrackTemplateDef(\AutoSeqTrackPart) },
	postChain: { arg self;
		self[\postChain] = Pbind(
			\velamp, Pfunc({ arg ev; 
				if(ev[\velamp].isNil) {
					1
				} {
					if(ev[\velamp] > 0) {ev[\velamp]} {Rest(ev[\velamp])}
				}
			});
		);
		self[\postChain]
	},
	preChain: { arg self;
		
	},

	//base: { arg self;
		//self[\base] = Pdef(self.name+++\base,
			//\instrument, \sampler,
			//\muter, Pif(\velamp > 0, {0}, {\rest}),
		//);
		//self[\base]
	//},
	source_: { arg self, val;
		var seqpairs = List.new;
		var pairs;
		self.preChain = val;
		self[\source] = val;
		if(val.isKindOf(Pbindef) or: val.isKindOf(Pdef)) {
			if(val.source.isKindOf(PbindProxy)) {
				pairs = val.source.pairs;
			} {
				if(val.source.isKindOf(Pbind)) {
					pairs = val.patternpairs;
				} {
					pairs = []; // can't get pairs, do nothing
				}
			}
		} {
			if(val.isKindOf(PbindProxy)) {
				pairs = val.source.pairs;
			} {
				if(val.isKindOf(Pbind)) {
					self.preChain = Pdef(self.name+++\preChain, val).convertToPbindef;
					pairs = val.patternpairs;
				} {
					pairs = []; // can't get pairs, do nothing
				}
			};
		};
		pairs.clump(2).do { arg pair, idx;
			if(pair.last.isKindOf(PstepSeq)) {
				seqpairs.add(pair);
			};
		};

		self.seqpairs = seqpairs;
		
		self.existingChildren.do { arg child, idx;
			seqpairs.do { arg pair, idx;
				child.score.source.set(pair.first, pair.last.copy)
			};
		};
	},
	asParamGroup: { arg self;
		self.preChain.asParamGroup;
	},
	trackEditor: { arg self;
		WindowDef(self.name+++\trackeditor, { arg def, child;
			var pgroup;
			var lay;
		   
			if(self.preChain.notNil) {
				pgroup = self.asParamGroup
			} {
				pgroup = []
			};
			lay = VLayout(
				pgroup.asView,
			);
			if(pgroup.any({ arg pa; pa.property == \bufnum })) {
				lay.add(WindowDef(\sampleEditor).asView(Param(self.preChain, \bufnum)))
			};
			lay;
		});
	},
	editor: { arg self;
		WindowDef(self.name, { arg def, child;
			//[self.base, child, child.score].debug("editor call scoreEditor");
			VLayout (
				if(child.score.notNil) {
					//WindowDef(\scoreEditor).asView(self.base, child, child.score);
					VLayout (
						* self.seqpairs.collect { arg pair, idx;
							Param(child.score, pair.first -> \stepseq).asView;
						};
					)
				}
				//Slider.new,
			)
		});
	},
	makeScore: { arg self;
		self.source = Pbind(\instrument, \default, \degree, PstepSeq(0!8,inf), \velamp, PstepSeq(1!8,inf));
		//self.isEmpty = false;
	},
));
TrackTemplateDef(\AutoSeqTrackPart, (
	parent: TrackTemplateDef(\CustomInstrumentTrackPart),
	makeScore: { arg self;
		//self.proxy.debug("makeScore proxy start");
		self[\score] = Pbindef(self.name+++\seq, \isPbindef, true);
		self.parentTrack.seqpairs.do { arg pair, idx;
			self.score.source.set(pair.first, pair.last.copy)
		};
		self.proxy = PlayerWrapper(Pdef(self.name+++\part,
			self.parentTrack.postChain <>
			self.score <>
			self.parentTrack.preChain
		));
		//self.proxy.debug("makeScore proxy end");
	}
));

TagSpecDef(\CustomTrackTemplate).addUnique(\AutoSeqTrack -> TrackTemplateDef(\AutoSeqTrack));
);


//Spec.add(\degree, ControlSpec(0,14,\lin,1,0));
//Spec.add(\velamp, \unipolar);
//BufDef(\amen, "vipere/amenbreak.wav");

