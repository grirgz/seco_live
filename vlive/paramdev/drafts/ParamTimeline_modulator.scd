
// goal: use ParamTimeline not as an absolute value but as a modulator to a param in a PbindefEditor
// done


BusDef(\modbus1, \control, 1)
ParamTimeline(\rio, Param(BusDef(\modbus1), \bus, \bipolar)).edit
ParamTimeline(\rio).clear
ParamTimeline(\mod1, Param(ParamCombinator(~p).proxy, \inputs, \bipoloar).at(0)).edit
ParamTimeline(\mod1, ~p).edit
ParamTimeline(\mod1).edit
ParamTimeline(\mod1).clear;
BusDef(\modbus1).set(10.1)
~ps = Param(Pbindef(\ouy), \lpfr -> \source)
~p = Param(Pbindef(\ouy), \lpfr)
~ps.getRaw
ParamCombinator(~p).inBusMode
ParamCombinator(~p).edit
ParamCombinator(~p).inputParam.at(0).wrapper
ParamCombinator(~p).inputParam.at(0).spec
ParamCombinator(~p).inputParam.at(0).getRaw
ParamCombinator(~p).inputParam.at(0).accessor
ParamCombinator(~p).inputParam.at(0).setRaw(1)
ParamCombinator(~p).inputParam.at(0).set(ParamTimeline(\mod1).outBus.asMap)
ParamCombinator(~p).inputObjects[0] = ParamTimeline(\mod1)
ParamCombinator(~p).inputObjects[0].isKindOf(ProtoClass)
ParamCombinator(~p).inputObjects[0].eventType
ParamCombinator(~p).inputParam.at(0).setRaw(0)
ParamCombinator(~p).inputParam.getRaw
ParamCombinator(~p).inputParam.setRaw([0,0,0])
ParamTimeline(\mod1).outBus.asMap
ParamTimeline(\mod1).asControlInput
BusDef(\modbus1).asControlInput
PlayerWrapper(ParamCombinator(~p).proxy).outBus



ParamTimeline(\mod1).edit
~p = Param(Pbindef(\ouy), \lpfr)
~ps = Param(Pbindef(\ouy), \lpfr -> \source)
~p.isSet
~p.wrapper
~ps.wrapper

ParamCombinator(~p).inputObjects[0] = ParamTimeline(\mod1)

// TODO:
// - add modulator should be menu, which offer list of modulators (and maybe bus submenu ?)
// - if no modulator, create one in modulatorRack, display it, map it to param
//		eventually show a list of modulator template when available
// - add modulator in Pbindef should set it in source to make it start automatically
// - test if param router still work after all theses changes

WindowDef(\PbindefEditor).front(Pbindef(\montagne))
(
FileSystemProject.loadOnce("libdef/PbindefEditor.scd");
FileSystemProject.loadOnce("libdef/ModulatorRack.scd");
Pbindef(\montagne, 
	\instrument, \saw,
	\lodeg, 0,
	\hideg, 12,
	\degree, Plazy({ arg ev; Pseq([0,Pwhite(ev[\lodeg].debug("lodeg"),ev[\hideg],1)],1) }).loop,
	\octave, 3,
	\dur, 1,
	\amp, 0.1,
).play;
);

WindowDef(\PbindefEditor).front(Pbindef(\ouy))
~param.getCombinator.get
~param.getCombinator.set(2)
~param.get
~param.set(4)
~param.wrapper
~param.accessor.key
~param = Param(Pbindef(\ouy), \lpfr).getCombinator.inputParam
~combi = Param(Pbindef(\ouy), \lpfr).getCombinator
~param.getRaw
~param.at(1).getBus
~self.combinatorNextInputIndex(~combi)
TrackDef(\ModulatorRack).existingChildren
TrackDef(\ModulatorRack).childAt(0)
TrackDef(\ModulatorRack).keys
(
FileSystemProject.loadOnce("libdef/PbindefEditor.scd");
Pbindef(\ouy, 
	\instrument, \saw,
	\lodeg, 0,
	\hideg, 12,
	\degree, Plazy({ arg ev; Pseq([0,Pwhite(ev[\lodeg].debug("lodeg"),ev[\hideg],1)],1) }).loop,
	\octave, 3,
	\dur, 1,
	\amp, 0.1,
).play;
);

Pbindef(\ouy).source.at(\xxhideg)
(
FileSystemProject.loadOnce("libdef/ModulatorRack.scd");
Pdef(\zed, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\zed).edit
Pbindef(\zed).edit
TagSpecDef(\Modulators).list
{ SinOsc.ar(500) ! 2 * 0.1}.play;
Pdef(\zed).set(\freq, nil)
0.numChannels

Pdef(\zed).set(\lpfr, DebugMethodTracer())
Pdef(\zed).set(\lpfr, nil)
Pdef(\zed).play
Pdef(\zed).get(\lpfr).asControlInput
DebugMethodTracer().asControlInput
(
ProtoDef(\tracer, (
	doesNotUnderstand: { arg self;
		"kjkj".postln;
		
	},
))
)
ProtoDef(\tracer).bla

(
	Ndef(\anolfo2, { var sig = SinOsc.kr(3.3).bipolar; Out.ar(BusDef(\amodbus4, \audio, 1).index, K2A.ar(sig)); sig  })
)
BusDef(\amodbus4).index

(
FileSystemProject.loadOnce("libdef/ScopeView.scd");
FileSystemProject.loadOnce("libdef/PbindefEditor.scd");
FileSystemProject.loadOnce("libdef/ModulatorRack.scd");
)
Param(Pdef(\zed),\lpfr).combinatorEnabled
Param(Pdef(\zed),\lpfr).hasCombinator
Param(Pdef(\zed),\lpfr).getBus
~p = Param(Pdef(\zed),\lpfr);
~p.edit
~c = Param(Pdef(\zed),\lpfr).getCombinator
PlayerWrapper(~c.inputObjects[0]).outBus.asMap
Ndef(\lfo2).bus
Ndef(\lfo2).initMonitor.out
Ndef(\lfo2).rate

PlayerWrapper()
WindowDef(\ParamSpecEditor).front(~p)

//////////////
// new param combinator editor

(
Ndef(\lfo1, { arg freq=2.5; SinOsc.kr(freq).unipolar  }).addSpec(\freq, \lofreq);
Ndef(\lfo2, { LFPulse.kr(4.5).unipolar  });
Ndef(\lfo3, { LFSaw.kr(1.5).unipolar  });
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo1 -> Ndef(\lfo1));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo2 -> Ndef(\lfo2));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo3 -> Ndef(\lfo3));
)
(
WindowDef(\ParamCombinatorModulatorEditor, { arg def, param;
	if(param.hasCombinator) {
		var combi = param.getCombinator;
		VLayout (*
			[
				HLayout (
					param.asView,
					PlayerWrapper(combi.proxy),
				)
			] ++
			combi.inputObjects.collect { arg obj, idx;
				var player = PlayerWrapper(obj);
				var inputp = Param(Message(combi), \inputObjects -> idx, TagSpecDef(\Modulators));
				HLayout(
					inputp.asPopUpMenu.addAction({
						obj = combi.inputObjects[idx];
						[ obj].debug("obj");
						[ PlayerWrapper(obj).outBus.asMap ].debug("bus");
						player.mapPlayer(obj);
						combi.inputParam.at(idx).setBus(PlayerWrapper(obj).outBus.asMap)
					}),
					player.asView,
					combi.rangeParam.at(idx).asSlider.orientation_(\horizontal),
					BasicButton.new.string_("Edit").action_({
						player.edit;
					}),
				)
			
			} ++ [nil];
		)
	} {
		BasicButton.new.string_("Add Combinator").action_({
			"add it now!".debug;
		})
	}
	
}).front(Param(Pdef(\zed),\lpfr));
)


(
TagSpecDef(\Modulators, {
	TagSpecDef(\ParamCombinatorInput).list 
	++ ProtoDef(\ModulatorRack).existingChildren.collect({ arg child, idx;
		child.trackKey -> child
	})
	
});
)
TagSpecDef(\Modulators).list

/////////////
// choose color for isSet param handler
(
WindowDef(\win, { arg def;
	HLayout (
		Slider.new,
		Slider.new.knobColor_(Color.black), 
		Slider.new.knobColor_(Color.grey), 
		Slider.new.knobColor_(Color.grey(0.7)), 
		Slider.new.knobColor_(Color.clear), 
		Slider.new.knobColor_(Color.white), 
	)
	
}).front;
)
(
WindowDef(\win, { arg def;
	HLayout (
		Slider.new,
		Slider.new.background_(Color.grey), 
		Slider.new.background_(Color.clear), 
		Slider.new.background_(Color.white), 
	)
	
}).front;
)
(
WindowDef(\win, { arg def;
	HLayout (
		Knob.new,
		Knob.new,
		Knob.new,
		Knob.new,
		Knob.new.background_(Color.white), 
		Knob.new.background_(Color.white), 
		Knob.new.background_(Color.white), 
		Knob.new.background_(Color.grey), 
		Knob.new.background_(Color.gray), 
		Knob.new.background_(Color.clear), 
		Knob.new.background_(Color.white), 
	)
	
}).front;
)

Pbindef(\ouy).clear
Pbindef(\ouy).source.pairs

ParamTimeline(\mod1).presetCompileString.editorInsert
(
ParamTimeline('mod1').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 1.5, \legato: 1, \level: 0.48014440433213, \midinote: 0, \playDur: 1.5, \relDur: 1.5, \sustain: 1, ),
	(\absTime: 1.5, \curve: 0.65, \dur: 2.25, \legato: 1, \level: 0.88086642599278, \midinote: 0, \playDur: 2.25, \relDur: 2.25, \sustain: 1, ),
	(\absTime: 3.75, \dur: 1.0, \legato: 1, \level: 0.32490974729242, \midinote: 0, \playDur: 1.0, \relDur: 1.0, \sustain: 1, ),
	(\absTime: 4.75, \curve: 0.45, \dur: 2.75, \legato: 1, \level: 0.74729241877256, \midinote: 0, \playDur: 2.75, \relDur: 2.75, \sustain: 1, ),
	(\absTime: 7.5, \dur: 0.375, \legato: 1, \level: 0.48014440433213, \midinote: 0, \playDur: 0.375, \relDur: 0.375, \sustain: 1, ),
	(\absTime: 7.875, \dur: 0.125, \legato: 1, \level: 0.4187725631769, \midinote: 0, \playDur: 0.125, \relDur: 0.125, \sustain: 1, ),
	(\absTime: 8.0, \dur: 0.0, \legato: 1, \level: 0.50541516245487, \midinote: 0, \playDur: 0.0, \relDur: 0.0, \sustain: 1, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);



//////////////////////

// minimal ParamCombinator

(
ProtoDef(\minicombi, (
	mapParam: { arg self, param;
		var rate = \audio;
		var name = \minicombi;
		var targetParam = param;
		Ndef(name).source = {
			var input, range;
			var fval;
			var sig;
			//Log(\Param).debug("ParamCombinator: rate %", rate);
			fval = \base.perform(rate, 0);
			fval = targetParam.spec.unmap(fval);
			input = \input.perform(rate,0);
			range = \range.perform(rate,0);

			fval = input*range+fval;
			sig = targetParam.spec.map(fval);
			sig;
			//sig.poll(label:"final sig");
		};
		Ndef(name).play(self.outBus.index);
	},
	asControlInput: { arg self;
		self.outBus.asMap
	},
	
));
)


/////////////////

FileSystemProject.loadOnce("libdef/CustomTrackList.scd");
TrackDef(\myc, \CustomTrackList).edit
Param(Pdef('myc.0.0'), \isRest -> \stepseq).spec


//////////////

