
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
ProtoInst(\TrackMixerDef, \bla).proxy.edit
ProtoInst(\TrackMixerDef, \bla9).proxy.source.asCompileString
ProtoInst(\TrackMixerDef, \bla10).proxy.objects[2000].source.asCompileString
PlayerWrapper(ProtoInst(\TrackMixerDef, \bla).proxy).isPlaying

(
Pdef(\zed, 
	Pbind(
		\out, BusDef(\trackMixerDef_bla17, \audio),
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

ProtoInst(\TrackMixerDef, \bla).clear
WindowDef(\TrackMixerDef_fx).front(ProtoClassDef(\TrackMixerDef).new(\bla))
WindowDef(\TrackMixerDef_fx).front(ProtoClassDef(\TrackMixerDef).new(\bla17))
\wet.asSpec
Spec.add(\wet, \unipolar)
Ndef(\bla9).source

Param

(
WindowDef(\TrackMixerDef_fx, { arg me, mixer;
	var param;
	var sends = [];
	var layout;
	var slider, knobs = List.new, textfield;
	var num = 4;
	layout = VLayout(
		PlayerWrapper(mixer).asView,
		HLayout(
			VLayout (
				slider = Slider.new.orientation_(\vertical),
				textfield = TextField.new,
			),
			VLayout(*
				knobs = 4.collect({ 
					Knob.new;
				})
			),
		),
		VLayout(* num.collect { arg idx;
			HLayout (
				PlayerWrapper(mixer.insertFxAt(idx)).asView,
				//Param({ mixer.isInsertFxEnabled(idx) }, { mixer.enableInsertFx(idx) }, ParamBoolSpec()).asButton("Fx"++idx),
				Param(Message(mixer.insertFxAt(idx)), \synthName, TagSpecDef(\SynthDef_InsertFx)).asPopUpMenu,
				BasicButton.new.string_("Edit").action_({
					if()
					WindowDef(\InsertFxEditor, { arg def, insertFx;
						VLayout (
							HLayout (
								PlayerWrapper(mixer.insertFxAt(idx)).asView,
								//Param({ mixer.isInsertFxEnabled(idx) }, { mixer.enableInsertFx(idx) }, ParamBoolSpec()).asButton("Fx"++idx),
								Param(Message(mixer.insertFxAt(idx)), \synthName, TagSpecDef(\SynthDef_InsertFx)).asPopUpMenu,
							),

							insertFx.asParamGroup.asView
						)
					}).front(mixer.insertFxAt(idx))
				}),
				mixer.insertFxAt(idx).getParam(\wet).asSlider.orientation_(\horizontal),
				mixer.insertFxAt(idx).getParam(\gain).asSlider.orientation_(\horizontal),
				//Param(mixer.insertFxAt(idx).proxy, \wet+++mixer.insertFxAt(idx).index, \unipolar).asSlider.orientation_(\horizontal),
				//Param(mixer.insertFxAt(idx).proxy, \gain+++mixer.insertFxAt(idx).index, \unipolar).asSlider.orientation_(\horizontal),
			)

		});
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
	XOut.ar(out, \wet.kr(0), [in,sig]* \gain.kr(1));
	//XOut.ar(out, \wet.kr(0), [in,sig]);
}).add;
)

SynthDesc(\ifx_freeverb2).def.func.asCompileString

TagSpecDef(\SynthDef_InsertFx).addUnique(\myfx_ndef)
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_freeverb2)
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_freeverb2_x)
TagSpecDef(\SynthDef_InsertFx).addUnique(\fx_freeverb2)
TagSpecDef(\SynthDef_InsertFx).addUnique(\ifx_greyhole)


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
