
(
ProtoDef(\ParamCapture, (
		isCapturing:false,
		isCapturing_: { arg self, val;
			self[\isCapturing] = val;
			self.changed(\isCapturing);
		},
		controller_: { arg self, val;
			self[\controller] = val;
			self.changed(\controller);
		},
));

ControllerDef(\icon_knobs, { arg def, model;
	var ktl = MKtl('icon', "icon-icontrols");
	8.do { arg idx;
		ktl.elAt(\kn, idx).mapParam(model.knobs[idx])
	}
}, [\knobs]);

WindowDef(\ParamCapture, { arg def;
	var view = View.new;
	var captured, update;
	var cont;
	var model = ProtoDef(\ParamCapture);
	view.followChange(Param, \lastTweaked, { arg x;
		if(Param.lastTweaked.notNil) {
			[ ( model.captured ?? {[]} ).includesEqual(Param.lastTweaked), model.captured, Param.lastTweaked ].debug("captured");
			if(model.isCapturing and: {model.captured.isNil or: { model.captured.includes(Param.lastTweaked).not }}) {
				if(Param.lastTweaked.type == \scalar) {
					model.captured = model.captured.add(Param.lastTweaked);
					update.();
				};
			};
		}
	}, false);
	update = { 
		model.captured.debug("update");
		view.removeAll;
		view.layout = VLayout(
			ParamGroupLayout(model.captured)
		)
   
	};
	VLayout (
		HLayout (
			Param(Message(model), \isCapturing, ParamBoolSpec()).asButton("Capturing"),
			BasicButton.new.string_("Clear").action_({
				model.captured = nil;
				update.();
			}),
			Param(Message(model), \controller, TagSpecDef(\ControllerDef_capabilities_knobs)).asPopUpMenu,
			BasicButton.new.string_("Assign").action_({
				model.controller.startControl((knobs:model.captured));
			}),
		),
		view,
	)
	
}).front;
)
(
SynthDef(\saw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\saw, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);
Pdef(\saw).edit
ParamProto.init

(
)
~icon_map_param.(MKtl('icon')[\kn][0], Param(Ndef(\rdn), \delay));
k[\kn].collect({ arg k; k })
k[\kn][0]
k.postElements;

k = MKtl('icon', "icon-icontrols");
~icon_map_param.(MKtl('icon')[\kn][0], Param(Ndef(\rdn), \delay));
k[\kn].collect({ arg k; k })
k[\kn][0]
k.postElements;
