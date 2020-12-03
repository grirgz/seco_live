
(
ProtoDef(\ParamCombinatorManager, (

	paramList: { arg self;
		self[\paramList] = List.new;
		self[\paramList];
	},

	play: { arg self;
		TagSpecDef(\ParamCombinator).list.do { arg paramcombi;
			paramcombi = paramcombi.value;
			paramcombi.proxy.wakeUp;
			paramcombi.inputParam.do { arg input;
				self.inputToPlayer(input) !? _.play;
			};
		}
	},

	inputToPlayer: { arg self, input;
		var val = input.get;
		var key;
		if(val.isKindOf(Number).not) {
			key = TagSpecDef(\ParamCombinatorInput_asMap).unmapKey(input.get);
			if(key.notNil) {
				var mod = TagSpecDef(\ParamCombinatorInput).asDict[key];
				if(mod.isKindOf(NodeProxy) or: { mod.isKindOf(EventPatternProxy) }) {
					PlayerWrapper(mod)
				}
			}
		};
		
	},

	isPlaying: { arg self;
		TagSpecDef(\ParamCombinator).list.every { arg paramcombi;
			paramcombi = paramcombi.value;
			PlayerWrapper(paramcombi.proxy).isPlaying;
		}
		
	},

	stop: { arg self;
		TagSpecDef(\ParamCombinator).list.do { arg paramcombi;
			paramcombi = paramcombi.value;
			PlayerWrapper(paramcombi.proxy).stop;
			paramcombi.inputParam.do { arg input;
				self.inputToPlayer(input) !? _.stop;
			};
		}
	},

	combinatorList: { arg self;
		var combilist = List.new;
		TagSpecDef(\ParamCombinator).list.do { arg paramcombi;
			var alreadyOneEmpty = false;
			paramcombi = paramcombi.value;
			self.paramList.add(paramcombi.targetParam);
			paramcombi.size.do { arg idx;
				if(alreadyOneEmpty.not or: {paramcombi.inputParam.at(idx).get != 0}) {
					combilist.add(
						(
							proxy: paramcombi.proxy,
							inputPlayer: self.inputToPlayer(paramcombi.inputParam.at(idx)),
							inputIndex: idx,
							paramCombinator: paramcombi,
							sourceParam: paramcombi.inputParam.at(idx),
							destParam: paramcombi.targetParam,
							baseParam: paramcombi.baseParam,
							rangeParam: paramcombi.rangeParam.at(idx),
						)
					);
				}
			};


		};
		combilist;
	},

));


WindowDef(\ParamCombinatorManager, { arg def, model;
	var combiListView = View.new;

	combiListView.followChange(TagSpecDef(\ParamCombinator), \list, {
		combiListView.removeAll;
		combiListView.layout = VLayout(
			* model.combinatorList.collect({ arg combi;
				var menuplayer = WindowDef(\ParamCombinatorInputPlayerButton).asView(combi.paramCombinator, combi.inputIndex);
				combi.inputPlayer.debug("inputPlayer");
				HLayout(
					PlayerWrapper(combi.proxy).label_("C").asView.maxWidth_(35),
					//PlayerWrapper(combi.inputPlayer).label_("M").asView.maxWidth_(35).rightClickEditorEnabled_(true),
					//combi.sourceParam.asValuePopUpMenu(TagSpecDef(\ParamCombinatorInput_asMap)),
					menuplayer[1].label_("M").asView.maxWidth_(35),
					menuplayer[0],
					combi.rangeParam.asSlider.orientation_(\horizontal),
					combi.rangeParam.asTextField.maxWidth_(80),
					combi.baseParam.asSlider.orientation_(\horizontal),
					combi.baseParam.asTextField.maxWidth_(80),
					combi.destParam.asStaticTextLabel(\full).minWidth_(100),
					PlayerWrapper(combi.destParam.target).label_("T").asView.maxWidth_(35).rightClickEditorEnabled_(true),
					//combi.destParam.asPopUpMenu( TagSpec(
						//model.paramList.collect({ arg p; p.fullLabel.asSymbol -> p })
					//) ),
				)
			}) ++ [nil]
		)
	});
	VLayout (
		HLayout (
			PlayerWrapper(model).asView,
			Button.new.string_("refresh").action_({ TagSpecDef(\ParamCombinator).changed(\list) }),
		),
		combiListView
	)
});
)

// END
///////////////////

(


Spec.add(\lpfr, ControlSpec(0.1,4,\lin));
WindowDef(\ParamCombinatorManager).front(ProtoDef(\ParamCombinatorManager));

Pdef(\zed, 
	Pbind(
		\instrument, \saw,
		//\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;

~pc = ParamCombinator( Param(Pdef(\zed), \freq) ).setBusMode(true);

	Ndef(\lfo1, { arg lofreq=2.5; SinOsc.kr(lofreq).unipolar  });
	Ndef(\lfo2, { arg lofreq=4.5; LFPulse.kr(lofreq).unipolar  });
	Ndef(\lfo3, { arg lofreq=1.5; LFSaw.kr(lofreq).unipolar  });
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo1 -> Ndef(\lfo1));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo2 -> Ndef(\lfo2));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo3 -> Ndef(\lfo3));
//TagSpecDef(\ParamCombinatorInput_asMap, { TagSpecDef(\ParamCombinatorInput).list.collect({ arg x; x.key -> x.value.asMap }) });
);

~a = "haha"
~a.addUniqueMethod(\haha_, { arg ...args; args.postln; 10 })
~a.haha_(300)

Ndef(\lfo1, { arg freq=1.2; SinOsc.kr(freq).unipolar  })

~pc.edit
Pdef(\zed).edit
TagSpecDef(\ParamCombinator).list
TagSpecDef(\ParamCombinatorInput).list
TagSpecDef(\ParamCombinatorInput_asMap).list
ProtoDef(\ParamCombinatorManager).inputToPlayer( TagSpecDef(\ParamCombinator).list.first.value.inputParam.at(0) )
~input = TagSpecDef(\ParamCombinator).list.first.value.inputParam.at(0)
TagSpecDef(\ParamCombinator).list.first.value.inputParam
TagSpecDef(\ParamCombinator).list.first.value.baseParam
TagSpecDef(\ParamCombinator).list.first.value.targetParam
TagSpecDef(\ParamCombinator).list.first.value.rangeParam
TagSpecDef(\ParamCombinator).list.first.value.size
TagSpecDef(\ParamCombinator).list.first.value.inputParam.at(0).get
TagSpecDef(\ParamCombinatorInput).add(\lfo1 -> Ndef(\lfo1).asMap)
TagSpecDef(\ParamCombinatorInput_asMap).list

ProtoDef(\ParamCombinatorManager).combinatorList
~input
			TagSpecDef(\ParamCombinatorInput_asMap).unmapKey(~input.get);
