/////////////////////////////////////////////////////////////////
// Pdef Pattern macro

Pdef(~name+++\macro2, Pbind());

Pdef(~name+++\macro2).set(\oscmix, 0.2)
Pdef(~name+++\macro2).addSpec(\oscmix, \unipolar)

Pdef(~name+++\macro2).set(\osc2mix, 0.2)
Pdef(~name+++\macro2).addSpec(\osc2mix, \unipolar)

Pdef(~name+++\macro2).asRack.edit

/////////////
// shortcut
~dPdef.(~name+++\macro2,
	\instrument, \zegrainer2
);

~dPdef.(~name+++\macro2,
	\oscmix, \unipolar,
	\osc2mix, \unipolar,
);

Pdef(~name+++\macro2).asRack.edit
Pdef(~name+++\macro2).getSpec(\oscmix).default
Pdef(~name+++\macro2).get(\oscmix)

/////////////

Sdef(~name, \mypreset).pbind.asStream.next(Event.default);
Pdef.default = Pbind()
Pdef(~name+++\macro).addHalo(\instrument, \zegrainer2)
Pdef(~name+++\macro).asRack.edit
Pdef(~name+++\macro).setBusMode(\pos, \finepos, \time_stretch, \pitch_stretch)
(
~r = Rack([
	[Pdef(~name+++\macro), \time_stretch],
	[Pdef(~name+++\macro), \pitch_stretch],
	[Pdef(~name+++\macro), \pos],
	[Pdef(~name+++\macro), \finepos],
	[Pdef(~name+++\macro), \legato],
	[Pdef(~name+++\macro), \adsr, \adsr.asSpec],
	//[Pdef(~name+++\macro), \adsr],
])
)
~r.edit
~r.map_midi
\adsr.asSpec
Spec.add(\adsr, XEnvSpec(ControlSpec(0,1,\lin,0,0.1) ! 4, ControlSpec(0.001,4,\exp,0), ControlSpec(-9,9,\lin,0,0), Env.adsr(0.1,0.1,0.8,0.1)))


//^^ The preceding error dump is for ERROR: Message 'round' not understood.
//RECEIVER: an Env
// -------> mean the env argument of synthdef has not an env spec so it treat it like a number


~pre1 = ~r.save_preset
~pre2 = ~r.save_preset
~r.set_preset_list([~pre1, ~pre2])

(
~mr = Rack([
	[Pdef(~name+++\macro), \time_stretch],
	[Pdef(~name+++\macro), \pitch_stretch],
	[Pdef(~name+++\macro), \pos],
	[Pdef(~name+++\macro), \finepos],
	[Pdef(~name+++\macro), \legato],
	[Pdef(~name+++\macro), \adsr, \adsr.asSpec],
	[~r, \morph],
	//[Pdef(~name+++\macro), \adsr],
])
)
~mr.map_midi

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


(
	// map the default (play button) macro for knobs
	//ProxyChain(~name).gui(22);
	Veco.do { arg name;
	
		Veco(name).lib.map_it = {
			~midi_macro_manager.map_list(
				ProxyChain(name+++\fx).proxy.controlNames.collect({ arg control;
					var spec;
					control.debug("control!!!");
					if(control.name.asString.beginsWith("wet") or: {
						control.name.asString.beginsWith("mix")
					}) {
						spec = \unipolar.asSpec;
					} {
						spec = control.name.asSpec;
					};
					[ProxyChain(name+++\fx).proxy, control.name, spec]
				}).reject({ arg x; [\out, \i_out, \inbus].includes(x[1]) });
			)

		};
		MIDIBoard.map(\play, { Veco(name).lib.map_it.value });
		Veco(name).lib.map_it.value;
	};

);

Sdef(~name, \mymacro, \macro, 8);
Sdef(~name, \mymacro).pbind
Sdef(~name, \mymacro).pbind(\wet)
Sdef(~name, \mymacro).connect(1, Sdef(~name, \mypreset), \ffreq, \freq.asSpec)
Sdef(~name, \mymacro).modulate(1, Sdef(~name, \mypreset), \ffreq, \freq.asSpec, { arg val, macro; val + macro })
Sdef(~name, \mymacro).padd(2, Ndef(~name+++\fx), \wet, \freq.asSpec, { arg val, macro; val + macro })

Sdef(~name, \mymacro).map(2, Ndef(~name+++\fx), \wet, \freq.asSpec, { arg val, macro; val + macro })

///// sources
// - gui
// - midi
// - ndef
// - pattern
// - osc
// - hid

///// dest
// - pattern preset
// - ndef
// - env var
// - dictionnary key
// - bus
// - synth/group node

~cont.map(1, 3, Ndef(~name+++\fx), \wet)

Ndef(~name+++\lfo1, { arg freq=1, fmax=200; SinOsc.kr(freq).range(50,fmax)  });
Ndef(~name+++\lfo1).put(1, \set -> Sdef(~name, \mymacro).pbind(\lfo1) <> Pbind(
	\freq, 2,
	\fmax, 500,
	\dur, 1,
))

Ndef(~name+++\lfo1).put(1, \set -> Sdef(~name, \lfo1).pbind <> Pbind(
	\freq, 2,
	\fmax, 500,
	\dur, 1,
))

pbind: { arg self, name;
	Pbind(
		name, Pfunc({ arg ev; 
			var norm = self.spec[name].unmap(ev[\freq]) + (in * range); 
			var res = self.spec[name].map(norm);
			res;
		})

	)
	
}

Pdef(~name, Sdef(~name, \name).pbind <> Pbind(
	
))

Pdef(~name, Pbind() <> Sdef(~name, \mymacro).filter(\name) <> Sdef(~name, \name).pbind <> Pbind(
	
))

Pdef(~name, Pbind() <> Sdef(~name, \name).mpbind <> Pbind(
	
))

Pdef(~name, Sdef(~name, \mymacro).filter(\name) <> Pbind() <> Sdef(~name, \name).pbind <> Pbind(
	
))

Pdef(~name, 
	Sdef(~name, \mymacro).select(\ffreq) <>
	Pbind(

	) <> 
	Sdef(~name, \name).mpbind <>
	Pbind(
	
	)
)

Sdef(~name, \mypreset).pbind
Sdef(~name, \mypreset).pbind(\lfo1)
Sdef(~name, \name, \preset, ~name);
Sdef(~name, \lfo1, \preset, Ndef(~name+++\lfo1));
Sdef(~name, \fx, \preset, Ndef(~name+++\fx));
Sdef(~name, \myrack, \rack, [\name, \lfo1, \fx])

Sdef(~name, \fx).map(\ffreq, Sdef(~name, \macro1).get(1))
Sdef(~name, \fx).map(\ffreq, Sdef(~name, \knobs).get(1))
Sdef(~name, \fx).map(\ffreq, Veco.knobs.get(1))
Sdef(~name, \fx).map(\ffreq, Veco.piano.knobs.get(1))
Sdef(~name, \fx).map(\ffreq, Veco.piano.knobs.get(1), -0.3)

// map knob 1 to a preset key
Veco.knobs.map(1, Sdef(~name, \fx), \ffreq) // preset has already spec
Veco.knobs.map(1, Sdef(~name, \fx), \ffreq, \freq.asSpec)

Sdef(~name, \mymacro, \macro)
// map macro 2 to a preset key
Sdef(~name, \mymacro).map(2, Sdef(~name, \fx), \ffreq, -0.3)

// map knob 1 to macro 2
Veco.knobs.map(1, Sdef(~name, \mymacro), 2)


Sdef(~name, \mymacro).map(2, Ndef(~name+++\fx), \wet, \freq.asSpec, { arg val, macro; val + macro })


Veco.force_init

(

	// use class now
~class_midi_board_controller = (
	new: { arg self;
		self = self.deepCopy;
	
		self.controls = IdentityDictionary.new;
	
		self;
	},

	define: { arg self, channel, defs;
		defs.pairsDo { arg key, val;
			var kind=\cc, keychannel;
			if(val.class == Association) {
				kind = val.key;
				val = val.value;
			};
			if(val.isSequenceableCollection) {
				keychannel = val[1];
				val = val[0]
			} {
				keychannel = channel;
			};
			key.debug("kkKKey");
			val.debug("kkKKeyVVVVVVVVVVVVV");
			kind.debug("kkKKeykinddddddddddd");
			self.controls[key] = ~class_midi_cc_controller.new(val, key, keychannel, kind);
			self.controls[key].debug("YYYYYYYYYYYYYYYY");
		
		};
	},

	map: { arg self ... args;
		if(args[0].isSequenceableCollection) {
			args[0].do { arg val;
				var key;
				//val.debug("val");
				key = val.removeAt(0);
				key.debug("array key");
				//val.debug("val2");
				self.controls[key].map(*val);
			}
		} {
			var key;
			//args.debug("val");
			key = args.removeAt(0);
			key.debug("key");
			//args.debug("val2");
			self.controls[key].map(*args);
		}
	},
	/////

	~ctrl = ~class_midi_board_controller.new;
	~ctrl.define(1, [
		\k1, 1,
		\k2, 2,
		\k3, 4,
		\k4, 5,
		\mox, 21,
		\moy, 22,
		//\but1, [35, 1],
		\but1, 35,
		\but2, \note -> [36, 1],
	]);
	~ctrl.map(\k1, Sdef(~name, \mypreset), \fratio);
	~ctrl.map(\k2, Sdef(~name, \mypreset), \spread);
	"=========".postln;
	~ctrl.map(\but1, { 
		"kkljHEIN".postln;
	});
)

(
~ctrl.map(\but1, { 
	~ctrl.map([
		[\k1, Sdef(~name, \mypreset), \fratio, ControlSpec(0.01,8,'lin',0,2)],
		[\k2, Sdef(~name, \mypreset), \release],
	])
})
)

(
~ctrl.map(\but1, { 
	"3333kkljHEIN".postln;
	~ctrl.map([
		[\k1, Sdef(~name, \mypreset), \pan, \bipolar.asSpec],
		[\k2, Sdef(~name, \mypreset), \dist],
	])
})
)

(
~ctrl.map(\k1, { 
	"kkljHEIN444444".postln;
})
)



(
MIDIdef.cc(\hey, { arg val,b,c,d;
	["hey", val,b,c,d].postln;

})
)



	~ctrl.map(\k1, Sdef(~name, \mypreset), \fratio, ControlSpec(0.01,8,'lin',0,2));
	~ctrl.map(\k2, Sdef(~name, \mypreset), \dist, ControlSpec(0.01,40,'lin',0,2));
~ctrl.controls[\k1].target.specs_dict
~ctrl.controls[\k1].target.build_vals
~ctrl.controls[\k1].target
	~cc = ~class_midi_cc_controller.new(1);
	~cc.map(Sdef(~name, \mypreset), \fratio, ControlSpec(0.01,8,'lin',0,2));

~ctrl.map(\k1, Sdef(~name, \mypreset), \fratio, ControlSpec(0.01,8,'lin',0,2))
~cc.target.vals
~cc.target

Ndef(\bla, { arg freq=100, ffreq=200; RLPF.ar(LFSaw.ar(freq), ffreq, 0.3) ! 2 }).play
~ctrl.map(\k3, Ndef(\bla), \ffreq);
~ctrl.map(\k4, Ndef(\bla), \freq);
Ndef(\bla).edit

NodeProxy
NodeMap

(set: { arg x,y; x.postln; y.postln; }).set(true)


///////////////////////////////////////////////////////////////








(
~m =
~a = {
	var win;
	var slider;
	var layout;
	win = Window.new;
	layout = HLayout.new;
	slider = Slider.new(win);
	slider.action = { 
		slider.value.debug("slider");

	};
	//win.view = slider;
	layout.add(slider);
	win.layout = layout;
	win.front;
};
~a.()
)




(
~parent = (
	bla: { "kjkj".postln; }
);
~class = (
	parent: ~parent,
	rih: 4;
);

~dest = (
	ou: 56,
);
~dest.putAll(~class);
~dest.debug("dest");
)
~dest.bla
