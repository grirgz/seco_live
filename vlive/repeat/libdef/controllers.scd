
(
ControllerDef(\icon, { arg def, model;
	var ktl = MKtl('icon', "icon-icontrols");
	model.knobs.collect({ arg param, idx;
		ktl[\kn][idx].mapParam(param)
	});
	model.sliders.collect({ arg param, idx;
		ktl[\sl][idx].mapParam(param)
	});
}, [\knobs, \sliders]);

ControllerDef(\icon_knobs, { arg def, params;
	var ktl = MKtl('icon', "icon-icontrols");
	params.collect({ arg param, idx;
		ktl[\kn][idx].mapParam(param)
	});
}, [\knobline]);

ControllerDef(\icon_sliders, { arg def, params;
	var ktl = MKtl('icon', "icon-icontrols");
	params.collect({ arg param, idx;
		ktl[\sl][idx].mapParam(param)
	});
}, [\knobline]);

ControllerDef(\piano_generic, { arg def, target; 
        var playergroup;
        playergroup = ProtoTemplateDef(\SeqPlayerGroup).new(target);
        MIDIdef.noteOn(\piano, { arg ... args;
            var midinote = args[1];
            args.debug("generic on");
            playergroup.elAt(midinote).play;
        });
        MIDIdef.noteOff(\piano_off, { arg ... args;
            var midinote = args[1];
            args.debug("generic off");
            playergroup.elAt(midinote).stop;
        });
}, [ \piano ]);

ControllerDef(\nektar_piano, { arg def, target; 
        var playergroup;
        playergroup = ProtoTemplateDef(\SeqPlayerGroup).new(target);
        MIDIdef.noteOn(\piano, { arg ... args;
            var midinote = args[1];
            args.debug("nektar on");
            playergroup.elAt(midinote).play;
        }, srcID:~nektar_device_id);
        MIDIdef.noteOff(\piano_off, { arg ... args;
            var midinote = args[1];
            args.debug("nektar off");
            playergroup.elAt(midinote).stop;
        }, srcID:~nektar_device_id);
}, [ \piano ]);
)

// END

(
	ProtoDef(\paramRack, (
		new: { arg self, items;
			self = self.deepCopy;
		
			self.items = items;
		
			self;
		},

		params: { arg self;
			self.items.select(_.isKindOf(Param));
		},

		controller_: { arg self, cont;
			self[\controller] = cont;
			cont.startControl( (knobs: self.params) );
		},

		edit: { arg self;
			WindowDef(\paramRack, { arg def, players, params;
				VLayout (
					HLayout (
						StaticText.new.string_("controller"), 
						Param(Message(self), \controller, TagSpecDef(\ControllerDef_capabilities_knobs)).asPopUpMenu,
					),
					* self.items.collect({ arg item;
						ParamGroupLayout.formEntry(item)
					}) ++ [nil]
				)
			}).front(self.players, self.params)
		},
	));
);

(
SynthDef(\saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, diff=0.001;
	var sig;
	sig = LFSaw.ar(freq * [1+diff,1,1-diff]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\saw2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, diff=0.001;
	var sig;
	sig = LFSaw.ar(freq * [1+diff,1,1-diff]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\env.kr(Env([0,1,0],[0.1,0.8])), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	env: XEnvSpec(\unipolar!3)
))).add;
);

(
Pdef(\bla, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
ProtoDef(\paramRack).new([
	Pdef(\bla),
	Param(Pdef(\bla), \lpfr, ControlSpec(1/4,4,\lin)),
	Param(Pdef(\bla), \diff, ControlSpec(0.0001,0.1,\exp)),
	Param(Pdef(\bla), \adsr -> \times -> 0 ),
	Param(Pdef(\bla), \adsr, XEnvSpec.adsr(\unipolar)),
]).edit;
)
XEnvSpec(\unipolar!4)

	(
		s.boot;
Ndef(\target_object, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\array_param.kr(400 ! 8) + \scalar_param.kr(5) + \scalar_bus_param.kr(5)).mean;
	sig = sig * EnvGen.kr(\env_param.kr(Env([0,1,0.5,0],[0.1,0.8,0.1])), Impulse.kr(1/2));
	sig = Pan2.ar(sig, pan, amp);
});
//Param.trace = true;
	//WindowDef(\bla, { Param(Ndef(\target_object), \array_param).asView }).front;
	)
	
(
SynthDef(\target_synthdef, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(\array_param.kr(400 ! 8) + \scalar_param.kr(5) + \scalar_bus_param.kr(5)).mean;
	sig = sig * EnvGen.kr(\env_param.kr(Env([0,1,0.5,0],[0.1,0.8,0.1])), \gate.kr(1), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(\out.kr(0), sig);
}, metadata:(specs:(
		env_param: XEnvSpec(\unipolar ! 4),
		//array_param: XArraySpec(), // FIXME: this should be commented, Param should detect spec from default value, but bug in 3.11
))).add;
Param.trace = true;
Pdef(\target_object, Pbind(
	\instrument, \target_synthdef
));
	~p = Param(Pdef(\target_object), \array_param);
	WindowDef(\bla, { ~p.asView }).front;
)
	~p = Param(Ndef(\target_object), \scalar_param);

	~p = Param(Ndef(\target_object), \array_param);
	~p0 = Param(Ndef(\target_object), \array_param -> 0);
	WindowDef(\bla, { ~p.asView }).front;
	~env = Ndef(\target_object).get(\env_param)
	~env.asCompileString
	~env.levels = ~env.levels.copy;
	~env.times = ~env.times;
	Ndef(\target_object).set(\env_param, ~env)
	Ndef(\target_object).set(\env_param, Env([ 0, 1, 0.5, 0  ], [ 0, 0.8, 0.1  ], [ 0, 0, 0  ]) )
	~p.at(0).set(1)
	~p.at(0).get
	~p.at(0)
	Ndef(\target_object).get(\array_param)
	~p0.set(1)
	~p.set(200!8);
	~p.size
	~p.edit
	~p.spec.isDynamic
	~p.spec.size
	~p.spec
	~p.get.size

	WindowDef(\bla, { ~p.asView }).front;

	Param(Ndef(\target_object), \array_param).get
	Param(Ndef(\target_object), \scalar_param).get
	Param(Ndef(\target_object), \array_param).propertyLabel
	Param(Ndef(\target_object), \array_param).fullLabel
	Param(Ndef(\target_object), \array_param).at(0).get
	Param(Ndef(\target_object), \array_param).at(0).set(0)
	Param(Ndef(\target_object), \array_param).at(1).get
	Param(Ndef(\target_object), \array_param).at(1).set(1)
	Param(Ndef(\target_object), \array_param).at(0).spec.unmap(Param(Ndef(\target_object), \array_param).at(0).get)
	Param(Ndef(\target_object), \array_param).at(0).normGet
	Param(Ndef(\target_object), \array_param).at(0)
	Param(Ndef(\target_object), \scalar_param)
	Param(Ndef(\target_object), \array_param).edit
	Param(Ndef(\target_object), \array_param).edit
	Param(Ndef(\target_object), \env_param).get
	Param(Ndef(\target_object), \env_param).get
	Param(Ndef(\target_object), \env_param).edit
	Param(Ndef(\target_object), \env_param).spec
	Param(Ndef(\target_object), \env_param).defaultUpdateMode
	Param.defaultUpdateMode
	Param.trace = true
	Param(Ndef(\target_object), \env_param -> \times -> 0).get
	Param(Ndef(\target_object), \env_param -> \times -> 0).spec
	Param(Ndef(\target_object), \env_param -> \attack).get
	Param(Ndef(\target_object), \env_param -> \levels -> 0).get
	WindowDef(\bla, { Param(Ndef(\target_object), \env_param).asEnvelopeView }).front;


	Param(Pdef(\target_object), \array_param).at(0).wrapper.accessor
	Param(Pdef(\target_object), \array_param).at(0).wrapper
	Param(Pdef(\target_object), \array_param).at(0)
	Param(Pdef(\target_object), \array_param)
	Param(Pdef(\target_object), \array_param).spec
	Param(Pdef(\target_object), \array_param).wrapper.accessor
	Param(Pdef(\target_object), \array_param).accessor
	Param(Pdef(\target_object), \array_param -> 0).accessor
	Param(Pdef(\target_object), \array_param -> 0)
	Param(Pdef(\target_object), \array_param)
	Param(Pdef(\target_object), \scalar_bus_param).get
	Param(Pdef(\target_object), \scalar_bus_param).inBusMode

	Param(Pdef(\bla), \adsr -> \attack )
	Param(Pdef(\bla), \adsr -> \attack ).get
	Param(Pdef(\bla), \adsr -> \attack ).spec
	Param(Pdef(\bla), \adsr -> \attack ).edit
	Param(Pdef(\bla), \adsr -> \attack ).wrapper
	Param(Pdef(\bla), \adsr -> \times -> 0 ).get
	Param(Pdef(\bla), \adsr -> \times -> 0 ).spec
	Param(Pdef(\bla), \adsr -> \times -> 0 ).wrapper
	Param(Pdef(\bla), \adsr -> \times -> 0 ).edit
	Param(Pdef(\bla), \env -> \times -> 0 ).edit
	Param(Pdef(\bla), \env -> \times -> 0, XEnvSpec(\unipolar!4) ).edit
	Param(Pdef(\bla), \env -> \times -> 0, XEnvSpec(\unipolar!4) ).normGet
	Param(Pdef(\bla), \env -> \times -> 0, XEnvSpec(\unipolar!4) ).spec
	Param(Pdef(\bla), \env).spec
	Spec.specs[\env]
	Spec.specs[\adsr]
	Param(Pdef(\target_object), \env_param -> \times -> 0 ).edit
	Param(Pdef(\bla), \adsr -> \times -> 0).set(0.2)
	Param(Pdef(\bla), \adsr -> \times -> 0).get
	Param(Pdef(\bla), \adsr -> \times -> 0).asLabel
	Param(Pdef(\bla), \adsr -> \times -> 0).propertyLabel
	Param(Pdef(\bla), \adsr -> \times -> 0).wrapper.asLabel
	Param(Ndef(\bla), \adsr -> \times -> 0).wrapper.propertyLabel
	Param(Pdef(\bla), \adsr -> \times -> 0).wrapper.asLabel

k = MKtl('icon', "icon-icontrols");
~icon_map_param.(MKtl('icon')[\kn][0], Param(Ndef(\rdn), \delay));
k[\kn].collect({ arg k; k })
k[\kn][0]
k.postElements;


Pbindef(\rah, \instrument, \saw, \freq, 1000).play
Pbindef(\rah).get(\freq)
Pbindef(\rah).get(\freq)
Pbindef(\rah).source.at(\freq).source
Pbindef(\rah).source.at(\freq).source = Pseq([200,1000],inf);
