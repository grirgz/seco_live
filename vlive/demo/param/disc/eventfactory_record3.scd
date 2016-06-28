
(
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
	\degree, Pseq([0],inf),
	\dur, 1/2,
	\amp, 0.1
)).play;
);

ParamProto.init(true)
ParamProto.init
~envTimeline.new(\env1, Param(Pdef(\pat1), \fmfreq, ControlSpec(0,10)))
~envTimeline.new(\env1).edit
~envTimeline.new(\env1).param = (Param(Pdef(\pat1), \fmfreq, ControlSpec(0,10)))
~envTimeline.new(\env1).eventFactory
~envTimeline.new(\env1).event_factory
Pdef(\pat1).setBusMode(\fmfreq)
Pdef(\pat1).get(\fmfreq).asBus.get

~envTimeline.new(\env2, Param(Pdef(\pat1), \freq))
~envTimeline.new(\env2).edit
~envTimeline.new(\env2).timeline.viewport
~envTimeline.new(\env2).editor.timeline.viewport
~envTimeline.new(\env2).editor.timeline.areasize
Param(Pdef(\pat1), \freq).spec.step
~sc = SimpleController.new;
Param(Pdef(\pat1), \freq).putListener((myview:44), ~sc, { arg view, param; param.get.debug("param changed!!!") })
Param(Pdef(\pat1), \freq).edit
Pdef(\pat1).setVal(\freq, 10000)
Pdef(\pat1).set(\freq, 1000)
Param(Pdef(\pat1), \freq).get
Param(Pdef(\pat1), \freq).inBusMode
Param(Pdef(\pat1), \freq).setBusMode
Pdef(\pat1).get(\freq).asCachedBus.getCached
Pdef(\pat1).getVal(\freq)
Pdef(\pat1).inBusMode(\freq)
CachedBus.cache
(
Ndef(\ss, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);
Param(Ndef(\ss), \freq).inBusMode
~envTimeline.new(\env2).eventloop;
"jj"
ParamProto.init(true)
~envTimeline.new(\env2).clear;
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
	\degree, Pseq([0],inf),
	\dur, Pkeyd(\dur,1/4),
	\amp, Pkeyd(\amp,0.1),
));
Pdef(\pat2, Pbind(
	\instrument, \bri,
	\degree, Pseq([5],inf),
	\dur, Pkeyd(\dur,1/4),
	\amp, Pkeyd(\amp,0.1),
));
	~envTimeline.new(\env2, Param(Pdef(\pat1), \freq));
	~tl = ~envTimeline.new(\env2);
	//~ef = ~class_param_event_factory.new(~envTimeline.new(\env2).param);
	//~ef.eventLoop = ~envTimeline.new(\env2).eventloop;
	WindowDef(\env, {
		VLayout (
			Pdef(\pat1).asParamGroup.asView,
			~envTimeline.new(\env2).asView,
			~envTimeline.new(\lpf, Param(Pdef(\pat1), \lpf)).asView,
		)
	}).front
)


(
	~track1 = ProtoClass((
		label: \pat1,
		players: [
			Pdef(\pat1),
			~envTimeline.new(\env2, Param(Pdef(\pat1), \freq)),
			~envTimeline.new(\lpf,  Param(Pdef(\pat1), \lpf)),
		],

		play: { arg self;
			self.players.do(_.play)
		},

		stop: { arg self;
			self.players.do(_.stop)
		},

		isPlaying: { arg self;
			self.players.any(_.isPlaying.not).not
		},

		editor: { arg self;
			WindowDef(self.label, {
				VLayout (
					Pdef(\pat1).asParamGroup.asView,
					~envTimeline.new(\env2).asView,
					~envTimeline.new(\lpf, Param(Pdef(\pat1), \lpf)).asView,
				)
			})
		},

	));
)
~track1.editor.front
~track1.play

(
TrackDef(\main, (
	children: [
		TrackDef(\track1),
		TrackDef(\track2),
	],

	players: { arg self; self.children },

	play: { arg self;
		self.players.do(_.play)
	},

	stop: { arg self;
		self.players.do(_.stop)
	},

	isPlaying: { arg self;
		self.players.any(_.isPlaying.not).not
	},

	editor: { arg self;
		WindowDef(self.key, {
			var track_editor = View.new;
			var players = self.children;
			var selector = ~view_selector.new(players.size);
			var views;
			views = self.children.collect({ arg pla, idx;
				var selview = PlayerWrapperSelectorView(PlayerWrapper(pla)).selectAction_({ arg my, view;
					selector.select_item(idx)
				});
				selview.asView;
			});
			selector.views = views;
			// after setting view to avoid error
			selector.select_action = { arg me, view;
				view.debug("selected");
				view.selected = true;
				track_editor.removeAll;
				track_editor.layout = self.children[selector.selected_index.debug("selidx")].editor.asView;
			};
			selector.deselect_action = { arg me, view;
				view.debug("deselected");
				view.selected = false;
			};
			selector.select_item(0);
			VLayout (
				HLayout(*
					views
					++ [nil]
				),
				track_editor,
			)

		})
	},

	collect: { arg self, fun;
		self.children.collect(fun)
	},

	do: { arg self, fun;
		self.children.do(fun)
	},
));
TrackDef(\main).editor.front
)
WindowDef(\test, {PlayerWrapperSelectorView(TrackDef(\track2)).selectAction_({ "hello".debug }).asView }).front
WindowDef(\test, {PlayerWrapperSelectorView(Pdef(\pat1)).asView }).front
TrackDef(\main).do({ arg x, y; [x, y].debug("xxx") })
TrackDef(\main).as(Event).collect({ arg x, y; [x, y].debug("xxx") })
TrackDef(\main).as(Event)[\bla] = 4
TrackDef(\main).children
TrackDef(\main).bla

ParamProto.init(true)
~clipTimeline.new(\clip1).edit

(

TrackDef(\track1, (
		label: { arg self; self.key },
		players: [
			Pdef(\pat1),
			~envTimeline.new(\env2, Param(Pdef(\pat1), \freq)),
			~envTimeline.new(\lpf,  Param(Pdef(\pat1), \lpf)),
		],

		play: { arg self;
			self.players.do(_.play)
		},

		stop: { arg self;
			self.players.do(_.stop)
		},

		isPlaying: { arg self;
			self.players.any(_.isPlaying.not).not
		},

		editor: { arg self;
			WindowDef(self.key, {
				VLayout (
					Pdef(\pat1).asParamGroup.asView,
					~envTimeline.new(\env2).asView,
					~envTimeline.new(\lpf, Param(Pdef(\pat1), \lpf)).asView,
				)
			})
		},

));
TrackDef(\track2, ( 
	parent: TrackDef(\track1),
	players: [Pdef(\pat2)],

	editor: { arg self;
		WindowDef(self.label, {
			VLayout (
				Pdef(\pat2).asParamGroup.asView,
			)
		})
	},

))
)

TrackDef(\track1).source
TrackDef(\track1).play
TrackDef(\track1).editor.front

~clipTimeline.new(\main).edit


~envTimeline.new(\lpf).clear
~envTimeline.new(\lpf).clear
~envTimeline.new(\lpf).edit
~envTimeline.new(\lpf).param
~envTimeline.new(\lpf, Param(Pdef(\pat1), \lpf))

~tl.isRecording
~tl[\isRecording]
~tl.eventloop.isRecording
~ef.eventLoop.list
~ef.eventLoop.list.print
TempoClock.default.tempo


~tl = ~envTimeline.new(\env2)
~tl.repeatCount
~s = ~envTimeline.new(\env2).asPattern.asStream;
~s = ~timeline_pattern.(~tl.eventLoop.list).asStream
~tl.eventLoop.list.print
~remove_envlist_duplicate.(~tl.eventLoop.list)
~nn = ~s.nextN(10,())
~nn.do(_.debug("==========="))
~nn.size


~s.next(())


(
~ev = (
	parent: Event.default,
	\legato: 1,
	\dur: 12
	
)
)
~ev.use { arg ev; ev.sustain }
~ev.use { arg ev; ev.dur }
~ev.use { arg ev; ev[\sustain] }

TempoClock.default.tempo = 1/2

(
Pbind(
	\instrument, \nogate,
	\legato, 0.5,
	\dur, 1.5,
	\time, Pfunc({ arg ev; ev.use { ev.sustain } / thisThread.clock.tempo })
).trace.play
)

(
SynthDef(\nogate, { arg out=0, amp=0.1, time=1, pan=0, freq=200, sustain=1;
	var sig;
	sig = SinOsc.ar(freq);
	sustain.poll(label:"sustain");
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),Trig1.kr(1,time).poll,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pfindur(1, Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 50,
	\amp, 0.8
)).play;
)



ParamProto.init
~noteTimeline.new(\note1, Param(Pdef(\pat1), \midinote)).edit
