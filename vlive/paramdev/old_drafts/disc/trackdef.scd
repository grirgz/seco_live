
// track.scd use the old and wrong TrackDef concept

(
ParamProto.init;
	SynthDef(\bri, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		freq = freq * ( 1 + ( SinOsc.ar(\fmfreq.kr(0)) * \fmamp.kr(1) ));
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(7100), \rq.kr(0.5));
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
Pdef(\pat1, Pbind(
	\instrument, \bri,
	\degree, Pseq([0,1,2,3,4,5,6,7,8,9],inf),
	\dur, 1/2,
	\amp, 0.1
)).play;
Pdef(\pat2, Pbind(
	\instrument, \bri,
	\degree, Pseq([5],inf),
	\dur, Pkeyd(\dur,1/4),
	\amp, Pkeyd(\amp,0.1),
));
Ndef(\node1, { arg freq=200, pan=0, amp=0.4;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr((1..8)/8) * 1 )));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

// track with sequencer
(
Pdef(\t1, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
));

WindowDef(\paramGroupProxy, { arg me, group;
	var view = View.new;
	view.addUniqueMethod(\mapGroup, { arg self, group;
		view.removeAll;
		if(group.notNil) {
			view.layout = ParamGroupLayout.two_panes(group)
		};
	});
	view.mapGroup(group);
	view;
});

TrackDef(\t1, (
	stepevent: { arg self; 
		StepEventDef(self.key) 
	},

	editor: { arg self;
		WindowDef(self.key, {
			var view;
			view = WindowDef(\paramGroupProxy).asView;
			VLayout (
				PlayerWrapper(self.players).asView,
				PopUpMenu.new.items_([
					\bri,
					\default,
				]).action_({ arg me;
					self.stepevent[\instrument] = me.items[me.value];
					view.mapGroup(self.asParamGroup)
				}),
				view
			)
		})
	},

	asParamGroup: { arg self, val;
		SynthDesc(self.stepevent[\instrument]).asParamGroup(self.stepevent)
	},

	edit: { arg self;
		self.editor.front;
	},

	init: { arg self;
		self.players = PlayerWrapperGroup([Pdef(self.key, self.stepevent.asPattern)])
	},

	play: { arg self;
		self.players.play;
	},

	stop: { arg self;
		self.players.stop;
	},
	
)).init;
TrackDef(\t1).edit;
)
TrackDef(\t1).players
TrackDef(\t1).stepevent.asPattern.play
TrackDef(\t1).asParamGroup[1].set(0.1)
TrackDef(\t1).asParamGroup[4].set(400)
TrackDef(\t1).stepevent[\amp].isKindOf(Number)
