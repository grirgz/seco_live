
ProtoClassDef(\TrackMixerDef).new(\bla)
ProtoClassDef(\TrackMixerDef).new(\bla2).edit
ProtoInst(\TrackMixerDef, \bla3).edit
ProtoInst(\TrackMixerDef, \bla).edit
ProtoInst(\TrackMixerDef, \bla).insertFxAt(0).synthName
ProtoInst(\TrackMixerDef, \bla).insertFxAt(0).isPlaying
ProtoInst(\TrackMixerDef, \bla).insertFxAt(0).proxy[2000].isNil
ProtoInst(\TrackMixerDef, \bla).clear
ProtoInst(\TrackMixerDef, \bla).inbus
ProtoInst(\TrackMixerDef, \bla).play
ProtoInst(\TrackMixerDef, \bla).stop
ProtoInst(\TrackMixerDef, \bla).isPlaying
ProtoInst(\TrackMixerDef, \bla3).proxy.edit
ProtoInst(\TrackMixerDef, \bla9).proxy.source.asCompileString
ProtoInst(\TrackMixerDef, \bla10).proxy.objects[2000].source.asCompileString
PlayerWrapper(ProtoInst(\TrackMixerDef, \bla).proxy).isPlaying


TrackDef(\tlist, TrackTemplateDef(\TrackList));
TrackDef(\tlist).edit
TrackDef(\tlist).clear
NoteTimeline(\bla).edit
SimpleServerMeterView

NoteTimeline('tlist.0.0').edit
NoteTimeline('tlist.0.0').clear

Spec.add(\lpfr, ControlSpec(0.1,40,\exp))
MIDIdef.trace
k = MKtl('netktar');
k.postElements;
ProtoDef(\piano).startControl
ProtoDef(\piano).stopControl

(
Pdef(\zed, 
	Pbind(
		\out, BusDef(\trackMixerDef_bla2, \audio),
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\zed).stop
Ndef
AbstractPlayControl

ProtoInst(\TrackMixerDef, \bla).clear
WindowDef(\TrackMixerDef_fx).front(ProtoClassDef(\TrackMixerDef).new(\bla))
WindowDef(\TrackMixerDef_fx).front(ProtoClassDef(\TrackMixerDef).new(\bla1))
WindowDef(\TrackMixerDef_MeterMixer).front(ProtoClassDef(\TrackMixerDef).new(\bla2))
WindowDef(\TrackListMixerStrip).front(ProtoClassDef(\TrackMixerDef).new(\bla1), (sendCount:8))
WindowDef(\TrackMixerDef_fxlist).front(ProtoClassDef(\TrackMixerDef).new(\bla1), 4)
~equi.value.asArgsArray("kjkj")

ProtoClassDef(\TrackMixerDef).new(\bla).proto = ProtoTemplateDef(\TrackMixer_InsertFx_SynthDef)

[[[3]]].flatten
\wet.asSpec
(
)
Ndef(\bla9).source

ParamProto.init

(

WindowDef(\TrackMixerDef_MeterMixer, { arg def, mixer;
	var blockView = View.new;
	blockView.layout = VLayout (
		PlayerWrapper(mixer),
		WindowDef(\TrackListMixerStrip).asView(mixer, (sendCount:8));
	);
	blockView.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		if(buttonNumber == 1) {
			WindowDef(\TrackMixerDef_fxlist).front(mixer, 4)
		}
	});
	blockView;
});
)

(
WindowDef(\TrackMixerDef_fx, { arg me, mixer;
	var param;
	var sends = [];
	var layout;
	var slider, knobs = List.new, textfield;
	var num = 4;
	layout = HLayout(
		VLayout (
			PlayerWrapper(mixer).asView,
			HLayout(
				VLayout (
					slider = Slider.new.orientation_(\vertical),
					textfield = TextField.new,
				),
				VLayout(*
					knobs = num.collect({ 
						Knob.new;
					})
				),
			),
		),
		VLayout(* num.collect { arg idx;
			HLayout (
				PlayerWrapper(mixer.insertFxAt(idx)).asView,
				//Param({ mixer.isInsertFxEnabled(idx) }, { mixer.enableInsertFx(idx) }, ParamBoolSpec()).asButton("Fx"++idx),
				Param(Message(mixer.insertFxAt(idx)), \synthName, TagSpecDef(\SynthDef_InsertFx)).asPopUpMenu,
				BasicButton.new.string_("Edit").action_({
					//if()
					mixer.insertFxAt(idx).edit;
					//WindowDef(\InsertFxEditor, { arg def, insertFx;
						//VLayout (
							//HLayout (
								//PlayerWrapper(mixer.insertFxAt(idx)).asView,
								////Param({ mixer.isInsertFxEnabled(idx) }, { mixer.enableInsertFx(idx) }, ParamBoolSpec()).asButton("Fx"++idx),
								//Param(Message(mixer.insertFxAt(idx)), \synthName, TagSpecDef(\SynthDef_InsertFx)).asPopUpMenu,
							//),

							//insertFx.asParamGroup.asView
						//)
					//}).front(mixer.insertFxAt(idx))
				}),
				mixer.insertFxAt(idx).getParam(\wet).asSlider.orientation_(\horizontal),
				mixer.insertFxAt(idx).getParam(\gain).asSlider.orientation_(\horizontal),
				//Param(mixer.insertFxAt(idx).proxy, \wet+++mixer.insertFxAt(idx).index, \unipolar).asSlider.orientation_(\horizontal),
				//Param(mixer.insertFxAt(idx).proxy, \gain+++mixer.insertFxAt(idx).index, \unipolar).asSlider.orientation_(\horizontal),
			)

		} ++ [nil]);
	);
	layout.addUniqueMethod(\model_, { arg me, mixer;
		if(mixer.isKindOf(Volume)) {
			//"volume".debug;
			param = Param(mixer, \volume);
			sends = num.collect({ arg x; nil });
		} {
			//"track".debug;
			param = mixer.asParam(\postfader);
			sends = num.collect({ arg x; mixer.asParam(\send+++x) });
		};
		//[slider, param].debug("slider, param: what ?");
		slider.mapParam(param);
		textfield.mapParam(param, 6);
		knobs.do({ arg x, idx; x.mapParam(sends[idx]) })
	});
	if(mixer.notNil) {
		layout.model = mixer;
	};
	layout.addUniqueMethod(\slider, { slider });
	layout.addUniqueMethod(\textfield, { textfield });
	layout.addUniqueMethod(\knobs, { knobs });
	layout;
});
)
(
WindowDef(\TrackMixerDef, { arg me, mixer;
	var param;
	var sends = [];
	var layout;
	var slider, knobs = List.new, textfield;
	layout = VLayout(
		HLayout(
			VLayout (
				slider = Slider.new.orientation_(\vertical),
				textfield = TextField.new,
			),
			VLayout(*
				knobs = 4.collect({ 
					Knob.new;
				})
			)
		)
	);
	layout.addUniqueMethod(\model_, { arg me, mixer;
		if(mixer.isKindOf(Volume)) {
			//"volume".debug;
			param = Param(mixer, \volume);
			sends = 4.collect({ arg x; nil });
		} {
			//"track".debug;
			param = mixer.asParam(\postfader);
			sends = 4.collect({ arg x; mixer.asParam(\send+++x) });
		};
		//[slider, param].debug("slider, param: what ?");
		slider.mapParam(param);
		textfield.mapParam(param);
		knobs.do({ arg x, idx; x.mapParam(sends[idx]) })
	});
	if(mixer.notNil) {
		layout.model = mixer;
	};
	layout.addUniqueMethod(\slider, { slider });
	layout.addUniqueMethod(\textfield, { textfield });
	layout.addUniqueMethod(\knobs, { knobs });
	layout;
});
)


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq) * 0.1/4 * ( SinOsc.kr(4).unipolar * 1 );
}).play;
);

(
	Ndef(\equi, {
		var sig, in;
		var sig2;
		in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
		sig = in.equi(nil,  "i3000");
		sig2 = sig.equi(nil,  "i3001");
	});
	WindowDef(\equi, { arg def, model;
		var equi = EQui(nil,nil,model, nil, prefix:"i3000");
		equi.value.asArgsArray("i3000").clump(2).flop[0].asCompileString.debug("args");

		equi;
	}).front(Ndef(\equi));
)
WindowDef(\equi).front(Ndef(\equi))
Ndef(\equi).edit
Ndef(\equi).asParamGroup.edit
Ndef(\equi).clear


Ndef(\zed)[10].source = \in -> { arg in; in * SinOsc.ar(123)  }
Ndef(\zed)[10].source
Ndef(\zed).sources[10] = \filter -> { arg in; in * SinOsc.ar(123)  }
Ndef(\zed).sources[10] = \filter -> { arg in; in * SinOsc.ar(123)  }
Ndef(\zed)[10] = \filter -> { arg in; in * SinOsc.ar(123)  }
Ndef(\zed)[9] = \filter -> { arg in; Out.ar(BusDef(\fx1,\audio), in); DC.ar(0) }
Ndef(\zed)[10] = \myfx
Ndef(\zed)[10] = \filter -> \myfx_ndef
Ndef(\zed)[10] = \filter -> { arg in; SynthDef.wrap(SynthDesc(\myfx_ndef).def.func, nil, [in]) };
Ndef(\zed)[10] = \filter -> SynthDesc(\myfx_ndef).def.func;
Ndef(\zed)[11] = \filter -> { arg in; SynthDef.wrap(SynthDesc(\myfx_ndef).def.func, nil, [in]) };

Ndef(\zed)[10] = \filter -> { arg in; SynthDef.wrap(SynthDesc(\ifx_freeverb2_x).def.func, nil, [in]) };
Ndef(\zed)[11] = \filter -> { arg in; SynthDef.wrap(SynthDesc(\ifx_freeverb2_x).def.func, nil, [in]) };

Ndef(\zed)[10] = \filter -> SynthDesc(\ifx_freeverb2_x).def.func;
Ndef(\zed)[11] = \filter -> SynthDesc(\ifx_freeverb2_x).def.func;
( // FAIL
Ndef(\zed)[11] = \filter -> { 

	var out = \out.kr(0);
	var in = In.ar(out, 2);
	var sig;
	sig = in;
	if(sig.size < 2) {
		sig = sig!2;
	};
	sig = FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	XOut.ar(out, \mix.kr(1), [in, sig]);
}
)
( // SUCCESS
Ndef(\zed)[11] = \filter -> { arg in;

	//var out = \out.kr(0);
	//var in = In.ar(out, 2);
	var sig;
	sig = in;
	if(sig.size < 2) {
		sig = sig!2;
	};
	sig = FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	//XOut.ar(out, \mix.kr(0), [in, sig]);
}
)
Ndef
( // SUCCESS
Ndef(\zed)[11] = { 

	var out = \out.kr(0);
	var in = In.ar(out, 2);
	var sig;
	sig = in;
	//if(sig.size < 2) {
		//sig = sig!2;
	//};
	sig = FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	XOut.ar(out, \mix.kr(1), [in, sig]);
}
)
( // SUCCESS
Ndef(\zed)[11] = { 

	var out = \out.kr(0);
	var in = In.ar(out, 2);
	var sig;
	sig = in;
	//if(sig.size < 2) {
		//sig = sig!2;
	//};
	sig = FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	XOut.ar(out, \mix.kr(1), [in, sig]);
}.asSynthDef
)
Ndef(\zed)[11] = \fx1; // SUCCESS
Ndef(\zed).edit
{ SinOsc.ar(500) ! 2 * 0.1}.asSynthDef(\bla);
Ndef(\zed).stop
Ndef(\zed).stop
Ndef(\zed).objects
Ndef(\zed).objects[10].source
Ndef(\zed).objects[10].controlNames.collect({ arg x; x.name.asCompileString })
Ndef(\zed).objects[11].controlNames.collect({ arg x; x.name.asCompileString })
Ndef(\zed).objects[11]
SynthDefControl
Ndef(\zed)[10] = \myfx_ndef
Ndef(\zed).set(\inbus10, BusDef(\fx1))
Ndef(\zed).edit

Ndef(\zed)[10] = \basicbass
Ndef(\zed)[11] = \basicbass

SynthDescLib.global.at(\ifx_freeverb2_x).def.func
SynthDescLib.global.at(\ifx_freeverb2_x).controlNames.collect({ arg x; x++10 })

SynthDesc(\myfx_ndef).def.func

(
SynthDef(\myfx, { arg out=0, gate=1, amp=0.1, pan=0, freq=240;
	var sig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = sig * SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\myfx_ndef, { arg in, amp=0.1, pan=0, freq=240;
	var sig;
	sig = in;
	sig = sig * SinOsc.ar(freq);
	sig = CombL.ar(sig, 4/~t, 1/8/~t  * ( SinOsc.kr(1/2) * 0.4 + 1 ),1/~t) + sig;
	sig = CombL.ar(sig, 4/~t, 1/8/~t  * ( SinOsc.kr(1/2 + 0.1) * 0.4 + 1 ),1/~t) + sig;
}).add;
);

(
SynthDef(\ifx_freeverb2_x, { arg in, amp=0.1, pan=0, freq=240;
	var sig;
	sig = in;
	if(sig.size < 2) {
		sig = sig!2;
	};
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
}, [\ar]).add;
);

(
SynthDef(\ifx_freeverb2, { arg in, amp=0.1, pan=0, freq=240, verbmix=0.4, room=1, damp=0.5;
	var sig;
	sig = in;
	if(in.size > 1) {
		sig = FreeVerb2.ar(sig[0], sig[1], verbmix, room, damp);
	};
}).add;
);

(
SynthDef(\ifx_greyhole, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	sig = in;
	sig = Greyhole.ar(sig, \delay.kr(2), \damp.kr(0), \size.kr(1), \diff.kr(0.707), \fb.kr(0.9), \modDepth.kr(0.1), \modFreq.kr(2));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}).add;
SynthDef(\ifx_freeverb2, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	sig = in;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}).add;
Spec.add(\wet, \unipolar);
Spec.add(\mix, \unipolar);
Spec.add(\gain, \unipolar);
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_freeverb2);
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_greyhole);
TagSpecDef(\SynthDef_InsertFx).addUnique(\equi);
)

SynthDesc(\ifx_freeverb2).def.func.asCompileString

TagSpecDef(\SynthDef_InsertFx).addUnique(\myfx_ndef)
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_freeverb2_x)
TagSpecDef(\SynthDef_InsertFx).addUnique(\fx_freeverb2)


Ndef(\testme)[0] = { SinOsc.ar(200 * ( SinOsc.kr([1,1.01]) * 1 + 1 )) * 0.1/2  }
Ndef(\testme).play
Ndef(\testme)[100] = \ifx_freeverb2_test
Ndef(\testme).edit

(
SynthDef(\ifx_freeverb2_test, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	sig = in;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), [in,sig]* \gain.kr(1));
	XOut.ar(out, \wet.kr(0), [in,sig]* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}).add;
)

///////////////

SynthDesc(\ifx_freeverb2_x).controlNames.copy.drop(1)

(
~synthDef_to_indexedArgFunction = { arg synthName, index=100;
	var newArgs = List.new;
	newArgs = SynthDesc(synthName).controlNames.collect({ arg item;
		if(item != \in and: {item.asString.endsWith(index).not}) {
			( item ++ index ).asSymbol
		} {
			item;
		};
	});
	"{ arg %; SynthDef.wrap(%, nil, [%]); }".format(newArgs.join(", "), synthName.asCompileString, newArgs.join(", ")).interpret;
};
)
~synthDef_to_indexedArgFunction.(\ifx_freeverb2_x, 1000).asCompileString




~s = "{ arg bla, freq = 10, freqtab=[12,11]; SinOsc.ar(freq*2) }"
			~s.findRegexp("freq[^[:alnum:]]\>")
			~s.findRegexp("[^[:alnum:]](freq)[^[:alnum:]]")
			~s.findRegexp("[^[:w:]](freq)[^[:w:]]")
			~s.findRegexp("(?:[^[:w:]])(?<haha>freq)(?:[^[:w:]])")
			"arg ;^[freq]freq[ ,]".findRegexp(~s)

			~s[10] = "bar"
			~sa = ~s.as(Array); ~sa.putEach((11..14), "bar".as(Array) ++ (nil!10)); ~sa.select(_.notNil).join
			~sa = ~s.as(Array); ~sa.removeAt((11..14)).join

////////////////////
// last version

(
	~replaceAllRegexp = { arg string, regexp, replaceString;
		var strar = string.as(Array);
		var res = string.findRegexp(regexp);
		res = res.clump(2).collect({ arg x; x.last }).reverse; // retrieve only the grouped expr
		//res.debug("res");
		res.do { arg item, idx;
			//strar[item.first..replaceString.size-1]
			( item.first .. item.first + item.last.size-1 ).reverseDo { arg remidx;
				//[remidx, strar[remidx]].debug("remidx");
				strar.removeAt(remidx);
			};
			replaceString.as(Array).do { arg char, repidx;
				//[char, repidx, repidx + item.first].debug("char repidx");
				strar = strar.insert(repidx + item.first, char);
				//strar.join.debug("strar");
			};
			
		};
		strar.join;
	};
	~replaceAllRegexp.(~s, "[^[:alnum:]](freq)[^[:alnum:]]", "lpfabcdef");
)


(
SynthDef(\fx1, { arg gain=1;
	
	var out = \out.kr(0);
	var in = In.ar(out, 2);
	var sig;
	sig = in;
	sig = FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	XOut.ar(out, \wet.kr(1), [in, sig]);
	
}).add;
)

(
	// replace variables in code
~synthDef_to_indexedArgFunction = { arg synthName, index=100;
	var newArgs = List.new;
	var code = SynthDescLib.global.at(synthName).def.func.asCompileString;
	var excluded = [\in, \out];
	SynthDesc(synthName).controlNames.do({ arg item;
		var newname;
		if(excluded.includes(item).not and: {item.asString.endsWith(index).not}) {
			newname = ( item ++ index ).asSymbol;
			code = ~replaceAllRegexp.(code, "[^[:w:]](%)[^[:w:]]".format(item), newname);
		}
	});
	code.interpret;
	//"{ arg %; SynthDef.wrap(%, nil, [%]); }".format(newArgs.join(", "), synthName.asCompileString, newArgs.join(", ")).interpret;
};
~synthDef_to_indexedArgFunction.(\fx1, 10).asCompileString
)




//////////////// test ifx

(
SynthDef(\ifx_greyhole, { arg out=0, gate=1;
	var sig;
	var in = In.ar(out, 2); 
	out.debug("----- out");
	out.poll;
	sig = in;
	sig = Greyhole.ar(sig, \delay.kr(2), \damp.kr(0), \size.kr(1), \diff.kr(0.707), \fb.kr(0.9), \modDepth.kr(0.1), \modFreq.kr(2));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = sig * \gain.kr(1);
	XOut.ar(out, \wet.kr(0), sig* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}).add;
)

Ndef(\bla)[0] = { SinOsc.ar(200 * ( SinOsc.kr(0.4) * 1 + 1 )) ! 2 * 0.07  }
Ndef(\bla)[0] = { Silent.ar ! 2 * 0.07  }
Ndef(\bla).play
Ndef(\bla).stop

Ndef(\bla)[10] = \ifx_greyhole
Ndef(\bla).set(\wet10, 1)
Ndef(\bla).edit

Ndef(\bla2)[0] = { SinOsc.ar(300 * ( SinOsc.kr(1.4) * 1 + 1 )) ! 2 * 0.07  }
Ndef(\bla2).play


////////////// LevelIndicator

(
WindowDef(\win, { arg def, orientation=\vertical;
	var ticks = LevelIndicator.new.value_(0.7).numTicks_(16);
	var layout;
	if(orientation == \vertical) {
		ticks.fixedWidth_(3);
		layout = HLayout;
	} {
		ticks.fixedHeight_(3);
		layout = VLayout;
	};
	layout.new (
		LevelIndicator.new.value_(0.7),
		LevelIndicator.new.value_(0.4),
		ticks,
	).spacing_(0)
	
}).front;
);
WindowDef(\win).front(\horizontal)


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\out, BusDef(\mybus, \audio),
		\pan, 0.2,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
WindowDef(\win, { arg def;
	VLayout (
		CompactServerMeterView(nil, 0,2, BusDef(\mybus)).hideTicks_(true).orientation_(\horizontal).view,
		CompactServerMeterView(nil, 0,2, BusDef(\mybus)).hideTicks_(false).orientation_(\horizontal).view,
		//SimpleServerMeterView(nil, 0,2, BusDef(\mybus)).view
	).spacing_(0).margins_(0)
	
}).front;
);

TrackDef(\tlist).elAt(0).mixer.proxy.set(\sendbus3003, BusDef(\sendbus0))


		Param.toSynthDefSpec(nil, \sendbus, \ifx_send)
		Param.toSynthDefSpec(nil, \adsr, \ifx_send)
		SynthDesc(\ifx_send).metadata.specs[\adsr]
		Param.toSpec( SynthDesc(\ifx_send).metadata.specs[\sendbus].asSpec )

TrackDef(\tlist).childAt(0).presetCompileString.editorInsert
TrackDef(\tlist).childAt(0,0).score.timeline.presetCompileString.editorInsert

TrackDef(\tlist).edit
TrackDef(\tlist).clear

(
TrackDef(\tlist, TrackTemplateDef(\TrackList));
NoteTimeline('tlist.0.0').eventList = TimelineEventList.newFrom([
	(\absTime: 0, \dur: 0.25, \label: 'start', \playDur: 0.25, \relDur: 0.25, \sustain: 0, \type: 'start', ),
	(\absTime: 0.25, \dur: 0.5, \midinote: 52.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.25, \midinote: 70.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.5, \midinote: 55.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.625, \midinote: 64.0, \playDur: 0.625, \relDur: 0.625, \sustain: 0.1, ),
	(\absTime: 2.125, \dur: 0.75, \midinote: 76.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1, ),
	(\absTime: 2.875, \dur: 0.125, \midinote: 60.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.0, \dur: 0.375, \midinote: 78.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 3.375, \dur: 0.125, \midinote: 74.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.5, \dur: 0.375, \midinote: 51.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 3.875, \dur: 0.125, \midinote: 45.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

TrackDef('tlist').childAt(0).instrument = ProtoTemplateDef('TrackInstrument').new([ 'TrackInstrument', ('NoteTimelineTrack' -> 'NoteTimelineTrack') ]);
TrackDef('tlist').childAt(0).label = "NoteTimelineTrack TrackInstrument";

TrackDef('tlist').childAt(0).instrument.source = Pdef('tlist.0.instr');

);
FileSystemProject.resolve("repeat/tests/tmp")
TrackDef(\tlist).presetCompileStringSavePath = FileSystemProject.resolve("repeat/tests/tmp").fullPath +/+ "ttt"
TrackDef(\tlist).presetCompileStringSavePath 
TrackDef(\tlist).savePresetCompileString
TrackDef(\tlist).loadPresetCompileString



/////////////////////////////////////////////:


ParamProto.init
ProtoInst(\TrackMixerDef, \tr1).edit
ProtoInst(\TrackMixerDef, \tr1).inBus
WindowDef(\TrackMixerDef_advanced).front(ProtoInst(\TrackMixerDef, \tr1))

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\out, BusDef(\trackMixerDef_tr1, \audio),
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
)
)

/////////////////////////// solo mute tests

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\out, TrackMixerDef(\bla),
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
)


TrackMixerDef(\bla).edit


NoteTimeline(\bla).edit
XNoteTimeline(\xbla).edit
XNoteTimeline(\xbla).class
XNoteTimeline(\xbla).keys
XNoteTimeline(\xbla).parent
~a = ProtoClass()
~a.play = { arg self; self.debug("self") }
~a.play

/// in trackgrid

FileSystemProject.load("libdef/tracks.scd");
(
Pdef(\zed1, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([3,5,7],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
Pdef(\zed2, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
Pdef(\zed3, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,0,3,4],inf),
		\dur, 1/2,
		\amp, 0.1,
	)
);
Pdef(\zed4, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4]+4,inf),
		\dur, 1/3,
		\amp, 0.1,
	)
);
FileSystemProject.loadOnce("libdef/CustomTrackList.scd");
FileSystemProject.loadOnce("libdef/controllers.scd");
FileSystemProject.loadOnce("libdef/apc.scd");
FileSystemProject.loadOnce("libdef/rdngui.scd");
FileSystemProject.loadOnce("libdef/multifbdel.scd");
FileSystemProject.loadOnce("libdef/default_specs.scd");
TrackDef(\mygrid, TrackTemplateDef(\playergrid));
TrackDef(\mygrid).source = [[Pdef(\zed1)],[Pdef(\zed2)], [Pdef(\zed3)], nil, nil, nil,[Pdef(\zed4)]];
TrackDef(\mygrid).edit;
TrackDef(\mygrid).controller = ProtoDef(\apc40); 
)
s.volume
s.makeView
s.makeGui
{ SinOsc.ar(500) ! 2 * 0.1}.play;
s.volume.gui
s.showVolume
WindowDef(\ServerVolumeEditor).frontTop
WindowDef(\customgrid).front(TrackDef(\mygrid));
ProtoDef(\apc40)
TrackDef(\mygrid).edit
TrackDef(\mygrid).clear;
TrackDef(\mygrid).controller
TrackDef(\mygrid)[\controller_].asCompileString
TrackDef(\mygrid).elAt(0).mixer.soloMode
TrackDef(\mygrid).elAt(0).mixer.soloMode = true
TrackDef(\mygrid).elAt(0).mixer.muteMode
TrackDef(\mygrid).elAt(0).mixer.muteMode = true
TrackDef(\mygrid).elAt(1).mixer.soloMode
TrackDef(\mygrid).elAt(1).mixer.soloMode = true
TrackDef(\mygrid).elAt(1).mixer.muteMode
TrackDef(\mygrid).elAt(1).mixer.muteMode = true
TrackDef(\mygrid).elAt(0).existingChildren
TrackDef(\mygrid).elAt(0,0).isEmpty
TrackDef(\mygrid).elAt(1,0).isEmpty
TrackDef(\mygrid).elAt(0).mixer.edit
TrackDef(\mygrid).elAt(1).mixer.edit
(
WindowDef(\win, { arg def;
	var options = (showPlay: true);
	HLayout (
		TrackDef(\mygrid).elAt(0).mixer.asView(options),
		TrackDef(\mygrid).elAt(1).mixer.asView(options),
	)
	
}).front;
);


Pdef(\zed1).get(\out)
Pdef(\zed1).isPlaying
(
Pdef(\zed1, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([3,5,7],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
Pdef(\zed2, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
Pdef(\zed3, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,0,3,4],inf),
		\dur, 1/2,
		\amp, 0.1,
	)
);
Pdef(\zed4, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4]+4,inf),
		\dur, 1/3,
		\amp, 0.1,
	)
);
)

////////////////////////// volume

ParamProto.init;
WindowDef(\TrackMixerDef_advanced).front(ProtoClassDef(\TrackMixerDef_volume))
{ SinOsc.ar(500) ! 2 * 0.1}.play;


///////////
(
{
 (0..10000).inject([List(10000),List(10000)], { arg a, b; (if(b.odd) { a.first } { a.last }).add(b); a })    
}.bench
)

(
{
 (0..10000).inject([List(),List()], { arg a, b; (if(b.odd) { a.first } { a.last }).add(b); a })    
}.bench
)

(
{
~even = (0..10000).select(_.even);
~odd = (0..10000).select(_.odd);    
}.bench
)

s.queryAllNodes; // note the Group within the default group (ID 1)
~g = Group.new;
Synth(\default, target:~g)
~g.queryTree({ arg x; x.debug("xxx"); "kjkj".debug })

(
~g.queryTree({|msg|
   var i = 1, tabs = 0, dumpFunc;
   ("XXXNODE TREE Group" + msg[1]).postln;
   if(msg[2] > 0, {
       dumpFunc = {|numChildren|
           tabs = tabs + 1;
           numChildren.do({
               i = i + 3;
               tabs.do({ "   ".post });
               msg[i].post;
               (" " ++ msg[i + 2]).postln;
               if(msg[i + 1] > 0, { dumpFunc.value(msg[i + 1]) });
           });
           tabs = tabs - 1;
       };
       dumpFunc.value(msg[2]);
   });
});
)

[].select({ arg x; x.odd })
