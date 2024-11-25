// bugs
// - can't remove lpfr param and root param
// - ParamTimeline shoud stop using pattern cleanup
// - ParamTimeline should not loop when NoteTimeline ends
// - ParamTimeline seems to start too late or too early
// - Synth param does not work (error with label)

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Spec.add(\lpfr, ControlSpec(0.1,4,\exp,0,1.1));
SynthDesc(\saw).addTag(\cool).addTag(\note);

SynthDef(\sawtab, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * \lptab.kr([1,1,1]) * freq ).mean.clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDesc(\saw).addTag(\cool).addTag(\note);

Ndef(\lfo1, { arg lofreq=2.5; SinOsc.kr(lofreq).unipolar  });
Ndef(\lfo2, { arg lofreq=4.5; LFPulse.kr(lofreq).unipolar  });
Ndef(\lfo3, { arg lofreq=1.5; LFSaw.kr(lofreq).unipolar  });
Ndef(\macro1, { arg unipolar=0.5; unipolar  });
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo1 -> Ndef(\lfo1));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo2 -> Ndef(\lfo2));
TagSpecDef(\ParamCombinatorInput).addUnique(\lfo3 -> Ndef(\lfo3));
TagSpecDef(\ParamCombinatorInput).addUnique(\macro1 -> Ndef(\macro1));


);


(
	~t = 1; TempoClock.default.tempo = ~t;
Pbindef(\pb, 
	\instrument, \default,
	\degree, PstepSeq([0,3,5,1],inf),
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb2, 
	\instrument, \saw,
	\lpfr, 2.1,
	\degree, PstepSeq([0,3,5,1],inf),
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb3, 
	\instrument, \saw,
	\lpfr, Pwhite(0.1,0.7)*4,
	\degree_steps, PstepSeq([0,3,5,1],inf),
	\chord, [0,2b,4],
	\degree, Pkey(\degree_steps) + Pkey(\chord),
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb4, 
	\instrument, \saw,
	\lpfr, Pwhite(0.1,0.7)*4,
	\root, PstepSeq([0,3,5,1],inf),
	\degree, [0,2b,4],
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb5, 
	\instrument, \default,
	\degree, 0,
	\dur, 1,
	\amp, 0.1,
);
Pbindef(\pb6, 
	\instrument, \sawtab,
	\degree, 0,
	\dur, 1,
	\amp, 0.1,
);
);

(
BufDef(\moeten, "voices/02_moeten.flac");
BufDef(\amen, "vipere/amenbreak.wav");
Pbindef(\pb7, 
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\gain, 0.1,
).play;
)
Pbindef(\pb).clear
Pbindef(\pb2).clear
(

FileSystemProject.load("libdef/PbindefEditor.scd");
//WindowDef(\PbindefEditor).front(Pbindef(\pb5));
//WindowDef(\test, WindowDef(\PbindefEditor)).front(Pbindef(\test, \instrument, \default));
WindowDef(\test, WindowDef(\PbindefEditor)).front(Pbindef(\pb2));

);
Scale.at(\ionian)
Scale.all.parent.asPairs.clump(2).collect(_.postln)
Scale.all.parent.asAssociations

NoteTimeline(\Pbindef_pb).edit
~self.modulators
~self.isMixerEnabled
~self.noteMode
~self.noteTimeline.edit
~plist
~self.mixer.insertFxAt(0).synthName
~self.modulators
~self.getParamForm(Param(~self.proxy, \lpfr -> \stepseq))
Param(~self.proxy, \lpfr -> \stepseq).get
Param(~self.proxy, \lpfr -> \source).get
~self.paramList.select{ arg p; p.propertyRoot == \lpfr }
Param(~self.proxy, \dfggd -> \source).get
Param(~self.proxy, \dfggd -> \source).type
Param(~self.proxy, \dfggd -> \stepseq).get
Param(~self.proxy, \dfggd -> \stepseq).type
Pbindef(\pb).source.at(\sustain).source
Pbindef(\pb).source.removeAt(\sustain)
Pbindef(\pb).source.set(\sustain, nil)
~self.noteMode = \degree
~self.noteMode = \freq
~self.noteMode = \midinote
~self.noteMode = \note
Pbindef(\pb).source.pairs.clump(2).flop.first
Pbindef(\pb).source.set(\degree, nil)
Pbindef(\pb).source.set(\freq, nil)
Pbindef(\pb).source.set(\midinote, nil)
Pbindef(\pb).source.set(\note, nil)
Pbindef(\pb).source.set(\degree, 0)
Pbindef(\pb).source.set(\lpfr, nil)
Pbindef(\pb).source.at(\midinote)
Pbindef(\pb).source.at(\NoteTimeline).source.value
Pbindef(\pb).source.at(\dur).source.value
Pbindef(\pb2).source.at(\amp).source.value
Pbindef(\pb).play
Pbindef(\pb).source.pairs
TrackMixerDef(\Pbindef_pb).edit
TrackMixerDef(\Pbindef_pb).clear
PbindProxy
Param(Pbindef(\pb), \legato).get
Param(Pbindef(\pb), \legato -> \source).get
Param(Pbindef(\pb), \legato -> \source).edit
Param(Pbindef(\pb), \degree -> \source).spec
Param(Pbindef(\pb), \degree -> \source).type
Param(Pbindef(\pb), \lpfr -> \source).type
Param(Pbindef(\pb), \lpfr -> \source).isDefined

Param(Pbindef(\pb6), \lptab -> \source).type
Param(Pbindef(\pb6), \lptab -> \source).get
Param(Pbindef(\pb6), \lpfr -> \source).get
Param(Pbindef(\pb6), \lpfr -> \source).getRaw
Param(Pbindef(\pb6), \lpfr -> \source).set([3,2,1])
Pbindef(\pb6).source.at(\lptab).source
Pbindef(\pb6).source.at(\adsr).source
Pbindef(\pb6).source.at(\lpfr).source
Pbindef(\pb6).source.at(\lpfr).source = [1,2,3]
Param(Pbindef(\pb6), \lptab).get
Param(Pbindef(\pb6), \lptab).set([1,2,3])
Param(Pbindef(\pb6), \adsr).get
Pbindef(\pb6).get(\lptab)
Pbindef(\pb6).get(\adsr)


(
Pdef(\zed, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		//\adsr, Pseq([
			//Env.adsr(0.1,0.1,0.8,1.1),
		//],inf),
		\adsr, Env.adsr(0.1,0.1,0.8,1.1),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pbindef(\zed, 
	\instrument, \saw,
	\degree, Pseq([0],inf),
	\adsr, Pseq([
		Env.adsr(0.1,0.1,0.8,1.1),
	],inf),
	\adsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,1.1) ],
	],inf),
	//\adsr, Env.adsr(0.1,0.1,0.8,1.1),
	\adsr, [ Env.adsr(0.1,0.1,0.8,1.1) ],
	\dur, 1,
	\amp, 0.1,
).play;
);

PdefParam.instrument(Pbindef(\pb))

Pbindef(\pb).source.at(\degree)
Pbindef(\pb).source.at(\freq)
Pbindef(\pb, \stretch, 1/2)

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

//////////////////

// instrument selector

(
Pdef(\zed, 
	Pbind(
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\zed).edit;

(
WindowDef(\win, { arg def, proxy;
	var instrparam;
	var paramlistView = View.new;
	instrparam = Param( proxy, \instrument, TagSpecDef(\SynthDef_keys));
	instrparam.onChange({ arg view, param;
		view.removeAll;
		view.layout = proxy.asParamGroup.asView;
	}, paramlistView);
	paramlistView.layout = proxy.asParamGroup.asView;
	VLayout (
		HLayout (
			PlayerWrapper(proxy),
			instrparam.asValuePopUpMenu.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

				if(buttonNumber == 1) {
					WindowDef(\GlobalLibrary_select).front(nil, { arg synth;
						//synth.debug("synth");
						instrparam.set(synth.last.key);

					}, [\SynthDef])
				}
			}),
		),
		paramlistView,
	)
	
}).front(Pdef(\zed));
);

Pdef(\zed).get(\out)

BusDef(\bla,\audio)

TagSpecDef(\Tag_SynthDef).addUnique(\o)

(
~get_by_tag = { arg tag, class;
	var res = List.new;
	Halo.lib.dictionary.keysValuesDo { arg key,val;
		if(val[\tag].keys.includes(tag)) {
			if(class.isNil or: {key.isKindOf(class)}) {
				res.add(key)
			}
		}
	};
	res;
};
~get_by_tag.(\bla).do(_.postln);
~get_by_tag.(\cool, SynthDef);
)

(
SynthDef(\sin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDesc(\saw).addTag(\cool).addTag(\note);
SynthDesc(\sin).addTag(\cool).addTag(\note);
SynthDesc(\leady).addTag(\cool).addTag(\lead);
);

Pdef(\zed).addTag(\hehe)

WindowDef(\PdefInstrumentEditor, { arg def, instr;
	var target = instr.source;
	var pwrapper = PlayerWrapper(target);
	var paramView = View.new;
	paramView.followChange(instr, \source, {
		pwrapper.target = target;
	});
	paramView.followChange(instr, \playerSynthDef, {
		Log(\Param).debug("paramView: followChange playerSynthDef");
		paramView.removeAll;
		paramView.layout = ParamGroupLayout.two_panes(target.asParamGroup(nil, false, [\gate, \doneAction]));
	});
	VLayout(
		HLayout (
			pwrapper.asView,
			Param(Message(instr), \playerSynthDef, TagSpecDef(\SynthDef_keys)).asPopUpMenu,
			if(target.getHalo(\edit).notNil) {
				BasicButton.new.string_("Special edit").action_({
					target.getHalo(\edit).value(target);
				})
			}
		),
		paramView,
	);
});



//////////////////////
// need to write a Param Pbindef wrapper \lpfr -> \source

// OK! see tests/param.scd

////////////
// NoteTimeline tests

NoteTimeline(\bla).edit

(
Pbindef(\zed, 
	\instrument, \default,
	//\degree, Pseq([0],inf),
	\NoteTimeline, {NoteTimeline(\bla)},
	\dur, Prout({ arg ev;
		var pat = ev[\NoteTimeline].value.asPattern;
		pat.do { arg val;
			ev.putAll(val);
			//ev[\midinote] = val[\midinote];
			//ev[\type] = val[\type];
			//ev[\sustain] = val[\sustain];
			ev = val.dur.yield;
		};
	}),
	\amp, 0.1,
).play;
);
Pbindef(\zed).clear
(
NoteTimeline(\bla)[\asStream]= { arg self, inval; self.asPattern.asStream(inval) };
NoteTimeline(\bla)[\embedInStream]= { arg self, inval; self.asPattern.embedInStream( inval ) };
NoteTimeline(\bla)[\streamArg]= { arg self, inval; self.asStream(inval) };
)
NoteTimeline(\bla).eventType
NoteTimeline(\bla).keys

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\bla, Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdefn(\ba, Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1,
))
)
Pdefn(\ba).asStream.nextN(10,0)

(
Pdef(\gri, 
	Pbind(
		\instrument, \default,
		//\degree, Pseq([0],inf),
		\dur, Prout({ arg ev;
			var pat = NoteTimeline(\bla).asPattern;
			pat.do { arg val;
				ev[\midinote] = val[\midinote].debug("midinote");
				ev = val.dur.yield;
			};
		}),
		\amp, 0.1,
	)
).play;
);


(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out.poll, sig);
}).add;
);
(
Pdef(\zed, 
	DebugPbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
		//\out, BusDef(\trackMixerDef_bla, \audio),
		\out, TrackMixerDef(\bla3),
	).trace
).play;
TrackMixerDef(\bla3).play;
);

(
Pbindef(\zed, 
	\instrument, \saw,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
	\out, TrackMixerDef(\bla4),
).play;
TrackMixerDef(\bla4).play;
);

TrackMixerDef(\bla3).streamArg.asCompileString
TrackMixerDef(\bla3).asStream
TrackMixerDef(\bla4).streamArg.next
TrackMixerDef(\bla3).next
TrackMixerDef(\bla3).next = 3
TrackMixerDef(\bla3)[\next] = 3
TrackMixerDef(\bla4).next
123.streamArg.next
123.next
PbindProxy
Pbindef(\zed).source.set(\out, TrackMixerDef(\Pbindef_pb))
~p = PatternProxy.new
~p.source = TrackMixerDef(\bla3).asStream
~p.asStream.nextN(10,())

TrackMixerDef(\bla).edit
TrackMixerDef(\bla)
TrackMixerDef(\bla).play
Pattern

		Param(Pbindef(\pb), \out -> \source).get.isKindOf(TrackMixerDef)
		Param(Pbindef(\pb), \out -> \source).get.isKindOf(ProtoClass) and: {  }

//// next ???

Pseq([1,2,4]).streamArg(false).next
~p = Pseq([1,2,4]);
~r = Routine { arg inval; loop { inval = ~p.next(inval).yield } }
~r.next
Prout({}) === Prout({})

TrackMixerDef(\bla)[\asUgenInput] = { arg self; self.inbus }
TrackMixerDef(\bla)[\embedInStream] = { arg self; self.inbus.embedInStream }
TrackMixerDef(\bla)[\asStream] = { arg self; self.inbus.asStream }
TrackMixerDef(\bla).inbus.rate
TrackMixerDef(\Pbindef_pb).next
TrackMixerDef(\Pbindef_pb).clear
TrackMixerDef(\Pbindef_pb).next
TrackMixerDef(\Pbindef_pb).play
TrackMixerDef(\Pbindef_pb).stop
TrackMixerDef(\Pbindef_pb).asStream.next
TrackMixerDef(\Pbindef_pb).edit

/// test speed
// OK!

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
Spec.add(\lpfr, ControlSpec(0.1,4,\exp,0,1.1));
);

(
Pbindef(\pb, 
	\instrument, \saw,
	\degree, PstepSeq([0,3,5,1],inf),
	\dur, 1/2,
	\amp, 0.1,
).play;
);

Param(Pbindef(\pb), \lpfr).edit
Pbindef(\pb).play
(
MIDIdef.cc(\ttt, { arg val, ccNum, channel;
	//[ ccNum, channel, val ].debug;
	Pbindef(\pb).set(\lpfr, Spec.specs[\lpfr].map(val/127))
	
}).learn;
)
Spec.specs[\adsr]
Spec.specs[\lpfr]


/////////// Pmod

(
SynthDef(\sawx, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(30,19000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
)

(
 Pdef(\bbb, Pbind(\lpfr, Pmod({ SinOsc.kr(1/4).range(0.3, 2) })) <>
Pbind(
   //\degree, Pseq([1, 3, 5, 3], inf),
   \degree, Pseq([[0,3],[0,4]],inf),
   \instrument, \sawx,
)).play
)


//////// param combinator




Ndef(\lfo1).wakeUp
~self.modulators.first.play

NoteTimeline(\bla, Pdef(\bla, Pbind(\instrument, \sawx))).edit


//////// chords



(
Pbindef(\pb3, 
	\instrument, \saw,
	\lpfr, Pwhite(0.1,0.7)*4,
	\degree_steps, PstepSeq([0,3,5,1],inf),
	\chord, [0,2b,4],
	\degree, Pkey(\degree_steps) + Pkey(\chord),
	\dur, 1,
	\amp, 0.1,
).play;
)


//// knob size

(
WindowDef(\win, { arg def;
	VLayout (
		Knob.new.minSize_(Point(1,1)),
		Param(Pbindef(\pb), \lpfr).asKnob.minSize_(Point(1,1)),
	)
}).front;
);


////// change param type

(
Pbindef(\pty, 
	\instrument, \default,
	\degree, PstepSeq([0,3,1,2],inf),
	\dur, 1/2,
	\amp, 0.1,
).play;
);

(
WindowDef(\win, { arg def, param;
	var pview = View.new;
	var slider;
	if(param.parent.at(\source).get.isKindOf(PstepSeq)) {
		slider = param.asMultiSlider;
	} {
		slider = param.parent.at(\source).asSlider;
	};

	pview.layout = VLayout (
		slider
	);
	VLayout (
		pview,
		BasicButton.new.string_("del").action_({
			pview.removeAll;
			
		}),
		BasicButton.new.string_("set").action_({
			~p.parent.at(\source).set(1);
			
		}),
		BasicButton.new.string_("del set").action_({
			pview.removeAll;
			 {
				~p.parent.at(\source).set(1);
			}.defer(1)
			
		}),
	)
	
}).front(~p);
);

~p = Param(Pbindef(\pty), \degree -> \stepseq)
~p.parent.at(\source).set(1)
~p.parent.at(\source).set(PstepSeq([1,4,2,6],inf))
~p.get
~bla = 1.3
~bla = nil


//////// nestOn nestOff synth array handling

(
Pbindef(\zed, 
	\instrument, \sawtab,
	\degree, Pseq([0],inf),
	\rq, PstepSeq([0.3,0.5],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);

Param(Pbindef(\zed), \lptab -> \source).get
Param(Pbindef(\zed), \lptab -> \source).set([2,0.4,2])
Param(Pbindef(\zed), \lptab -> \source).shouldBeNested
Param(Pbindef(\zed), \freq -> \source).shouldBeNested
Param(Pbindef(\zed), \freq -> \source).set([123,432,566])
Param(Pbindef(\zed), \freq -> \source).set(566)
Param(Pbindef(\zed), \freq -> \source).wrapper.propertyPath
Param(Pbindef(\zed), \freq -> \source).wrapper.property
Param(Pbindef(\zed), \lptab -> 0).wrapper.propertyPath
Param(Pbindef(\zed), \lptab -> 0).propertyPath
Param(Pbindef(\zed), \lptab).type
Param(Pbindef(\zed), \lptab -> \source).type
Param(Pbindef(\zed), \freq).type
Param(Pbindef(\zed), \freq -> \source).type
Param(Pbindef(\zed), \rq).type
Param(Pbindef(\zed), \rq -> \source).type
Param(Pbindef(\zed), \rq -> \stepseq).type
PdefParam.instrument(Pbindef(\zed))
Param.toSynthDefSpec(nil, \lptab, \sawtab)
Param.getSynthDefDefaultValue(\lptab, \sawtab)
Pbindef(\zed).source.at(\lptab).source
\lptab.asSpec




TrackMixerDef(\bli).insertFxAt(0).getParam(\gain).default
TrackMixerDef(\bli).insertFxAt(0).synthName
Param.getSynthDefDefaultValue(\gain, \ifx_default)



////////////// inBusMode


Param(Pbindef(\pb6), \lpfr).inBusMode
Param(Pbindef(\pb6), \lpfr -> \source).inBusMode
Param(Pbindef(\pb6), \lpfr -> \source).inBusMode_(true)
Param(Pbindef(\pb6), \lpfr -> \source).get
Param(Pbindef(\pb6), \lpfr -> \source).set(4)
Pbindef(\pb6).source.at(\lpfr).source



/////////////////// final test


(
Pbindef(\hoho, 
	\instrument, \default,
	\degree, PstepSeq([0,4,2,1],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);
Pbindef(\hoho).clear
Pbindef(\hoho).play

WindowDef(\PbindefEditor).front(Pbindef(\hoho))
Param(Pbindef(\hoho), \degree -> \source).get
Param(Pbindef(\hoho), \degree -> \source).set(1)
Pbindef(\hoho).source.at(\degree).source
Param(Pbindef(\pb6), \ctranspose -> \source).at(1).get
Param(Pbindef(\pb6), \ctranspose -> \source).size
Param(Pbindef(\pb6), \lpfr -> \source).inBusMode
Param(Pbindef(\pb6), \lpfr).inBusMode



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
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
		
	])
)).play;
);



		(
		Pbindef(\kick,
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufidx, PstepSeq([0,1,3],inf),
			\bufnum, Pswitch1(
{
~buflib.kick[~buflib.kick.size.rand.debug("k")].value
} ! 8,
				Pkey(\bufidx),
			),
			\step, PstepSeq((0..4),inf),
			\isRest, Pfunc({ arg ev; ev[\step].coin.not }),
			\dur, 1/8,
			\gain, 0.4 * Pkey(\step),
		)
		)
		Pbindef(\kick).play
		Spec.add(\step, \unipolar)
		Spec.add(\pos, \unipolar)
WindowDef(\PbindefEditor).front(Pbindef(\kick))
Pbindef(\kick).clear
TrackDef(\tlist, )

		(
		Pbindef(\amen,
			\instrument, \player,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, BufDef(\amen),
			//\bufidx, PstepSeq([0,1,3],inf),
			//\bufnum, Pswitch1(
//{
//~buflib.kick[~buflib.kick.size.rand.debug("k")].value
//} ! 8,
				//Pkey(\bufidx),
			//),
			\step, PstepSeq((0..4),inf),
			\isRest, Pfunc({ arg ev; ev[\step].coin.not }),
			\dur, 1/8,
			\gain, 0.4 * Pkey(\step),
		)
		)
WindowDef(\amen,WindowDef(\PbindefEditor)).front(Pbindef(\amen))
WindowDef(\kick,WindowDef(\PbindefEditor)).front(Pbindef(\hoho))

KitTimeline(\bla).edit



(
SynthDef(\fmbellp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * EnvGen.kr(\freqenv.kr(Env([1,1.002,0.998,1],[0.1,0.8])), gate);
	sig1 = SinOsc.ar(freq * \fac1.kr(2.6706) + \det1.kr(0.13)) * \fmamp.kr(2) + 1; 
	sig2 = SinOsc.ar(freq * \fac2.kr(0.9998) * sig1 + \det2.kr(0));
	sig3 = SinOsc.ar(freq * \fac3.kr(2.6629) * sig1 + \det3.kr(2.04));
	sig4 = LFCub.ar(freq * \fac4.kr(0.9991) * sig1 + \det4.kr(2.14));
	sig5 = SinOsc.ar(freq * \fac5.kr(2.6656) * sig1 + \det5.kr(-2));
	sig6 = SinOsc.ar(freq * \fac6.kr(1) * sig1 + \det6.kr(1.84));
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar(\opamptab.kr([0,0.5,0.5, 0.5,0.5,0.5]));
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,2.1,1,-1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + \pantab.kr([ 0, -0.5, -0.5, 0.5, 0.5, 0]), amp).sum;
	Out.ar(out, sig);
}, metadata:(specs:(
	freqenv: ParamEnvSpec( ControlSpec(0.1,2,\lin) ),
	pantab: ParamArraySpec(\pan.asSpec),
	opamptab: ParamArraySpec(\gain.asSpec),
	fac1: ControlSpec(0.1,8,\lin,0,1),
	fac2: ControlSpec(0.1,8,\lin,0,1),
	fac3: ControlSpec(0.1,8,\lin,0,1),
	fac4: ControlSpec(0.1,8,\lin,0,1),
	fac5: ControlSpec(0.1,8,\lin,0,1),
	fac6: ControlSpec(0.1,8,\lin,0,1),
	det1: ControlSpec(0,10,\lin,0,0),
	det2: ControlSpec(0,10,\lin,0,0),
	det3: ControlSpec(0,10,\lin,0,0),
	det4: ControlSpec(0,10,\lin,0,0),
	det5: ControlSpec(0,10,\lin,0,0),
	det6: ControlSpec(0,10,\lin,0,0),
))).add;
SynthDesc(\fmbellp).addTag(\cool).addTag(\note);
)

(
Pbindef(\fmbellp, 
	\instrument, \fmbellp,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);

WindowDef(\fmbellp, WindowDef(\PbindefEditor)).front(Pbindef(\fmbellp))

WindowDef(\test, WindowDef(\PbindefEditor)).front(Pbindef(\test, \instrument, \default))
WindowDef(\test, WindowDef(\PbindefEditor)).front(Pbindef(\pb2))

MIDIdef.noteOn(\piano).remove
MIDIdef.noteOff(\piano_off).remove

SampleTimeline(\cdh).edit

NoteTimeline(\bla).edit
NoteTimeline(\bla).recorder[\startRecordingHook].asCompileString
NoteTimeline(\bla).recorder.startRecordingHook = { 123 }
NoteTimeline(\bla).controller
NoteTimeline(\bla).param = nil
NoteTimeline(\wow).edit
NoteTimeline(\wow).controller
NoteTimeline(\ii2).edit
ControllerDef.getTagSpec(\piano).list.asDict[\generic_piano]
~t
temp
NoteTimeline(\bla2, Pdef(\saw, Pbind(\instrument, \saw))).edit
NoteTimeline(\bla2).startControl

~pr = PbindProxy(\instrument, \saw)
~pr.play;
Param( ~pr, \freq )
Param( ~pr, \freq ).edit

ParamTimeline(\bla).class
ParamTimeline(\bla).asCompileString
Param(Pbindef(\pb5), \lpfr -> \source).getRaw
Pbindef(\pb5).source.at(\legato).source.isKindOf(ProtoClass)
Pbindef(\pb5).source.at(\legato).source.value.eventType 
Pbindef(\pb2).source.at(\lpfr).source.value.clear
Pbindef(\pb2).source.at(\lpfr).source.asStream.next(())
Pbindef(\pb2).source.at(\lpfr).source.streamArg.next(())
Pbindef(\pb2).source.at(\lpfr).source.streamArg
Pbindef(\pb2).source.at(\lpfr).source
Pbindef(\pb2).source.at(\lpfr).source = nil;
Pbindef(\pb2).source.at(\lpfr).source.edit
Pbindef(\pb2).source.at(\lpfr).source.clear
Pbindef(\pb2).source.at(\lpfr).source[\clear].asCompileString
Pbindef(\pb2).source.at(\lpfr).source.key
Pbindef(\pb2).source.at(\lpfr).source.param.target.getSynchronous
Pbindef(\pb2).asStream.next(())

Param(BusDef(\bla, \control), \value).get
Param(BusDef(\bla, \control), \value).set(10)


(
m = Menu(
    a = MenuAction("Option A"),
    b = MenuAction("Option B")
).title_("Event Example");
f = {
    |action, what, value|
    "MenuAction '%' sent event %, value = %".format(action.string, "\\" ++ what, value).postln;
    if (what == \hovered) { "Hovering over: %".format(action).postln };
    if (what == \triggered) { "Action triggered: %".format(value).postln; m.destroy };
};
a.addDependant(f);
b.addDependant(f);
m.onClose_({ a.removeDependant(f); b.removeDependant(f) }).front;
)


WindowDef(\sdkfj, { arg def;
	
m = Menu(
    a = MenuAction("Option A"),
    b = MenuAction("Option B")
).title_("Event Example");
m

}).front;
~plist.collect(_.property)


//////////////// env mode


(
SynthDef(\saw2, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1).poll * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pbindef(\bla, 
	\instrument, \saw2,
	\degree, Pseq([0],inf),
	\legato, 0.2,
	\freq, Prout({ arg ev;
		var envev;
		var spec = \freq.asSpec;
	   
		loop {
			envev = ev.copy;
			envev[\instrument] = \modadsr;
			envev[\out] = BusDef(\blabli, \control);
			envev[\levelScale] = spec.range;
			envev[\levelBias] = spec.minval;
			envev.debug("envev");
			ev[\finish] = ev[\finish].addFunc({
				envev.play;
			});
			ev = envev[\out].asMap.yield;
		};
		ev
	}),
	\dur, 1,
	\amp, 0.1,
).play;
);
\lpfr.asSpec.range;
(
Pbindef(\bla2, 
	\instrument, \saw2,
	\degree, Pseq([0],inf),
	\legato, 0.2,
	\note, Pseq([
		0,4,2,5,
	],inf),
	\lpfr, Prout({ arg ev;
		var envev;
		var spec = \lpfr.asSpec;
	   
		loop {
			envev = ev.copy;
			envev[\instrument] = \modadsr;
			envev[\out] = BusDef(\blabli, \control);
			envev[\levelScale] = spec.range;
			envev[\levelBias] = spec.minval;
			envev.debug("envev");
			ev[\finish] = ev[\finish].addFunc({
				envev.play;
			});
			ev = envev[\out].asMap.yield;
		};
		ev
	}),
	\dur, 1,
	\amp, 0.1,
).play;
);


(
//~pr.edit;
~pr = ProtoTemplateDef(\PdefEditor_InlineEnv).new(\bla3_lpfr, \lpfr.asSpec);
WindowDef(\win, { arg def;
	HLayout (
		~pr.asView.debug("view"),
	)
	
}).front;
)
WindowDef.tryModeEnabled = false

(
Pbindef(\bla3, 
	\instrument, \saw2,
	\degree, Pseq([0],inf),
	\legato, 0.2,
	\note, Pseq([
		0,4,2,5,
	],inf),
	\lpfr, ProtoTemplateDef(\PdefEditor_InlineEnv).new(\bla3_lpfr, \lpfr.asSpec),
	\dur, 1,
	\amp, 0.1,
).play;
);

~pr = ProtoTemplateDef(\PdefEditor_InlineEnv).new(\bla3_lpfr, \lpfr.asSpec)

~pr.asParamGroup.edit
~pr.edit
(
WindowDef(\win, { arg def;
	HLayout (
		~pr.asView.debug("view"),
	)
	
}).front;
);

(
Pbindef(\bla3, 
	\instrument, \saw2,
	\degree, Pseq([0],inf),
	\legato, 0.2,
	\note, Pseq([
		0,4,2,5,
	],inf),
	\lpfr, ~pr,
	\dur, 1,
	\amp, 0.1,
).play;
);

~ev = ();
Param(~ev, \bla).spec
~ev.addSpec(\bla, \unipolar.asSpec)

(
	
	var res = block { arg break;
		//break.value(123)
		432;
	};
	res.debug("res");
)
~param.spec

WindowDef(\ParamAsSoundFileView).edit(~param)

(
WindowDef(\win, { arg def;
	WindowDef(\ParamAsSoundFileView).asView(~param)
	
}).front;
);

(
WindowDef(\win, { arg def;
	var param = ~param;
	var spec = param.spec;
	var target = param.target;
	//var buf = param.get;
	//param.spec.tagSpec.unmapKey(param.get.bufnum).debug("file");
	WindowDef(\soundfileview).asView(
		//BufDef(spec.tagSpec.unmapKey(param.get)),
		param,
		spec.startParamName !? { Param(target, spec.startParamName -> \source) },
		spec.sustainParamName !? { Param(target, spec.sustainParamName -> \source) },
		spec.endParamName !? { Param(target, spec.endParamName -> \source) },
		spec.speedParamName !? { Param(target, spec.speedParamName -> \source) },
		spec.startType ? \unipolar,
		spec.sustainType ? \beats,
		spec.endType ? \unipolar,
	);
}).front;
);
.get
BufDef(\amen).plot
~param.get
~param.spec.startParamName

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


(
Pbindef(\zed, 
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1,
).play;
);

Pbindef(\zed).edit
Pbindef(\zed).source.asCompileString.editorInsert
(
PbindProxy('instrument', 'zegrainer', 'mbufnum', 6, 'trate', 48.486535844729, 'time_stretch', ParamTimeline('Pbindef_zed_time_stretch'), 'pos', PstepSeq([ 0.87197753009105, 2.2058650817405, 4.2122023180768, 5.1287275041592, 16.711387612484, 16.711387612484, 54.452196126272, 24.77502532049 ], inf), 'pitch_stretch', ParamCombinator.new, 'randframes', 0.053286685208871, 'randrate', 1.8949003057565, 'release', 0.19975458075301, 'freq', 135.50809735187, 'gdur', 4.3381294964029, 'amp', 0.76997719398272, 'legato', 0.98480353756541, 'out', TrackMixerDef('Pbindef_zed'), 'finepos', ProtoClass(( 'spec': ControlSpec(-0.3, 0.3, 'linear', 0, 0, ""), 'baseEvent': ( 'levelScale': 2.2730256681473, 'adsr': Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.089361703617776, 0.11063829936246, 0.1000000089407 ], -4.0, 2), 'levelBias': -0.3 ), 'busKey': 'Pbindef_zed_finepos' )
.parent_(ProtoTemplateDef('PdefEditor_InlineEnv'))), 'NoteTimeline', { "open Function" }, 'dur', Prout({ arg ev;
				ev.debug("PbindefEditor NoteTimeline dur Prout");
				if(ev[\disableNoteTimeline] == true) {
					loop {
						ev = ev[\dur].yield;
					}
				} {
					var pat;
					ev.debug("PbindefEditor NoteTimeline dur now in pattern mode");
					pat = ev[\NoteTimeline].value.asPattern;
					pat.do { arg val;
						ev.putAll(val);
						//ev[\midinote] = val[\midinote];
						//ev[\type] = val[\type];
						//ev[\sustain] = val[\sustain];
						ev = val.dur.yield;
					};
				};
				ev;
			}))
);

(
PbindProxy('instrument', 'zegrainer', 'mbufnum', 6, 'trate', 48.486535844729, 'time_stretch', ParamTimeline('Pbindef_zed_time_stretch'), 'pos', PstepSeq([ 0.87197753009105, 2.2058650817405, 4.2122023180768, 5.1287275041592, 16.711387612484, 16.711387612484, 54.452196126272, 24.77502532049 ], inf), 'pitch_stretch', ParamCombinator.new, 'randframes', 0.053286685208871, 'randrate', 1.8949003057565, 'release', 0.19975458075301, 'freq', 135.50809735187, 'gdur', 4.3381294964029, 'amp', 0.76997719398272, 'dur', 0.22930463576159, 'legato', 0.98480353756541, 'out', TrackMixerDef('Pbindef_zed'), 'finepos', ProtoClass(( 'spec': ControlSpec(-0.3, 0.3, 'linear', 0, 0, ""), 'baseEvent': ( 'levelScale': 2.2730256681473, 'adsr': Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.089361703617776, 0.11063829936246, 0.1000000089407 ], -4.0, 2), 'levelBias': -0.3 ), 'busKey': 'Pbindef_zed_finepos' )
.parent_(ProtoTemplateDef('PdefEditor_InlineEnv'))))
);

(
PbindProxy('instrument', 'zegrainer', 'mbufnum', 6, 'trate', 48.486535844729, 'time_stretch', ParamCombinator.new, 'pos', PstepSeq([ 0.87197753009105, 2.2058650817405, 4.2122023180768, 5.1287275041592, 16.711387612484, 16.711387612484, 54.452196126272, 24.77502532049 ], inf), 'pitch_stretch', ParamCombinator.new, 'randframes', 0.053286685208871, 'randrate', 1.8949003057565, 'release', 0.19975458075301, 'freq', 135.50809735187, 'gdur', 4.3381294964029, 'amp', 0.76997719398272, 'dur', 0.22930463576159, 'legato', 0.98480353756541, 'out', TrackMixerDef('Pbindef_zed'), 'finepos', ProtoClass(( 'spec': ControlSpec(-0.3, 0.3, 'linear', 0, 0, ""), 'baseEvent': ( 'levelScale': 2.2730256681473, 'adsr': Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.089361703617776, 0.11063829936246, 0.1000000089407 ], -4.0, 2), 'levelBias': -0.3 ), 'busKey': 'Pbindef_zed_finepos' )
.parent_(ProtoTemplateDef('PdefEditor_InlineEnv'))))
);

(
PbindProxy('instrument', 'zegrainer', 'mbufnum', 6, 'trate', 48.486535844729, 'time_stretch', ParamCombinator.new, 'pos', PstepSeq([ 0.87197753009105, 2.2058650817405, 4.2122023180768, 5.1287275041592, 16.711387612484, 16.711387612484, 54.452196126272, 24.77502532049 ], inf), 'pitch_stretch', ParamCombinator.new, 'randframes', 0.053286685208871, 'randrate', 1.8949003057565, 'release', 0.19975458075301, 'freq', 135.50809735187, 'gdur', 4.3381294964029, 'amp', 0.76997719398272, 'dur', 0.22930463576159, 'legato', 0.98480353756541, 'out', TrackMixerDef('Pbindef_zed'), 'finepos', ProtoClass(( 'spec': ControlSpec(-0.3, 0.3, 'linear', 0, 0, ""), 'baseEvent': ( 'levelBias': -0.3, 'levelScale': 2.2730256681473 ), 'busKey': 'Pbindef_zed_finepos' )
.parent_(ProtoTemplateDef('PdefEditor_InlineEnv'))))
);

(
PbindProxy('instrument', 'zegrainer', 'mbufnum', 5, 'trate', 48.486535844729, 'time_stretch', ParamCombinator.new, 'pos', PstepSeq([ 66.300395381369, 80.726515077413, 44.721359549996, 24.775007295708, 20.347594437948, 16.711387612484, 20.347594437948, 54.452196126272 ], inf), 'pitch_stretch', ParamCombinator.new, 'randframes', 0.053286685208871, 'randrate', 1.8949003057565, 'release', 0.19975458075301, 'freq', 135.50809735187, 'gdur', 4.3381294964029, 'amp', 0.33957869675483, 'dur', 0.22930463576159, 'legato', 0.98480353756541, 'out', TrackMixerDef('Pbindef_zed'))
);

(
Pbindef('zed')
);


//////////// test PbindefEditorParamView

(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)

~p = Param(Pbindef(\pb), \degree);
~p = Param(Pbindef(\pb), \degree -> \source);
~p.edit
~p.parent
(
WindowDef(\win, { arg def;
	WindowDef(\PbindefEditorParamView).asView(~p)
}).front;
)
valueAction


WindowDef(\ParamSpecEditor).front(~p)
~mp.valueAction = 1
TextField
