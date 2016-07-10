(
SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(\fm.kr(1) * freq) * \fmamp.kr(1) )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = ( sig * [100,200] ).tanh / 3;
	sig = RLPF.ar(sig, \lpf.kr(1000) * [1,1/2],0.1);
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/2,Rand(-2,2),mul:0.7) + pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, Pbind(
	\instrument, \default,
	\instrument, \bass,
	\degree, Pseq([0,2,4,2],inf),
	\fmamp, Pseq([0.1,0.5,0.2,2],inf) * Pseg(Pseq([0,1,20],inf),16),
	\lpf, Pseq([1000,1011]*2,inf),
	\lpf, Ndef(\lfo1, { SinOsc.kr(1/8).range(500,12001) }),
	\pan, Ndef(\lfo2, { SinOsc.kr(1/4.1) * 0.5 }),
	\fm, Pseq([1,2,1,1, 1,1/2,1.01],inf),
	\degree, Pseq([
		Pseq([0,1],4),
		Pseq([4,2],4),
	],inf),
	//\degree, Pseq([0,2,4,2],inf),
	\legato, 1/2,
	\legato, Pseq([2,Prand([2,0.5,0.5,0.5,0.5,1,1.5,1,1,1.3,0.2],6), 0.1],inf),
	\isRest, Pfunc({
		~prevlegato.debug("prevlegato");
		if(~prevlegato.notNil and: { ~prevlegato > 1 }) {
			true
		} {
			false
		}
	}),
	\prevlegato, Pfunc({ arg ev; ~prevlegato = ev[\legato] }),
	\octave, 3,
	\root, Pseq([0,2,3,5],inf).stutter(8),
	\root, Pseq([0,5,-1,5],inf).stutter(4),
	\dur, 1/4,
	\amp, 0.1
)).play;
);


(
Pdef(\kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([60, 41, 30], [0.045, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		1,0,0,0, 1,0,0,0,
	],inf).coin.not,
	\amp, 0.15
)).play;
)

(
Pdef(\hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\sustain, 0.1,
	\isRest, Pseq([
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,1,0, 1,0,1,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,

	\amp, 0.1/8,
)).play;
)

(
Pdef(\snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 1,0,0,0,
		],3),
		Prand([
			Pseq([
				0,0,0,0, 1,0,1,0,
			],1),
			Pseq([
				0,1,0,0, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,1, 1,0,0,0,
			],1),
			Pseq([
				0,0,0,0, 1,0,0,0,
			],1),
		],1),
	],inf).coin.not,
	\amp, 0.2
)).play;
)


///////////// aspects
// - playing/stopping OK
// - mixers and master volume
// - send and insert fx
// - triggering with controller OK
// - recording OK
// - arranging on a timeline OK
// - sequencing drums OK
// - sequencing notes or chords OK
// - editing parameters of players OK
// - having bank of variations to be sequenced/triggered/recorded/arranged Maybe
// - presets
// - save to disk
// - automations

(
~pg = PlayerWrapperGroup([
	Pdef(\bass),
	Pdef(\kick),
	Pdef(\snare),
	Pdef(\hat),
]);
WindowDef(\gui, {
	VLayout(
		HLayout(*
			~pg.collect({ arg p; PlayerWrapperSelectorView(p).asView })
		)
	)
}).front
)

(
)

~trackMixerDef.new(\bla).clear
~trackMixerDef.all.clear
~trackMixerDef.new(\bla).asParam(\inbus)
~trackMixerDef.new(\bla).asParam(\postfader).edit
~trackMixerDef.new(\bla).play;
Ndef(\trackMixerDef_bla).edit
Ndef(\trackMixerDef_bla).get(\inbus)

~trackMixerDef.new(\bla).numchannels;
~trackMixerDef.new(\bla).outbus
~trackMixerDef.new(\bla).inbus

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pwhite(-20,10,inf),
	\dur, 1/5,
	\amp, 0.4,
	\out, ~trackMixerDef.new(\bla).inbus,
)).play;
);

"jjj".beginsWith("hh")

(
ParamProto.init;
	~trackMixerDef = ProtoClass((
		all: {PresetDictionary(\trackMixerDef)},
		new: { arg self, key, numchannels=2, outbus=0;
		
			if(self.all[key].isNil) {
				self = self.deepCopy;
				self.key = key;
				self.init(key, numchannels, outbus);
				self.all[key] = self;
			} {
				self = self.all[key];
				//self.val = val;
			};
		
			self;
		},

		clear: { arg self;
			self.all[self.key] = nil;
		},

		init: { arg self, key, numchannels, outbus;
			self.outbus = outbus;
			self.numchannels = numchannels;
			self.define_mixer;
			self.asParam(\inbus).set(self.inbus)
		},

		inbus: { arg self;
			BusDef(\trackMixerDef_+++self.key, \audio, self.numchannels)
		},

		numchannels: 2,

		define_mixer: { arg self;
			//self.proxy = NodeProxy.new;
			self.proxy = Ndef(\trackMixerDef_+++self.key);
			self.proxy[0] = {
				In.ar(\inbus.kr(self.zerobus), self.numchannels);
			};
			self.proxy[1000] = \filter -> { arg in;
				in * \prefader.kr(1).dbamp;
			};
			self.proxy[2000] = \filter -> { arg in;
				in * \postfader.kr(1).dbamp;
			};
			self.proxy.addSpec(\inbus, XBusSpec());
			self.proxy.addSpec(\prefader, \db);
			self.proxy.addSpec(\postfader, \db);
		},

		play: { arg self;
			var outbus = self.outbus;
			if(outbus.isKindOf(Bus)) {
				outbus = outbus.index;
			};
			self.proxy.play(outbus, self.numchannels)
		},

		setOut: { arg self, outbus;
			self.outbus = outbus;
			self.play;
		},

		asParam: { arg self, key;
			if(key.asString.beginsWith("send")) {
				var idx = key.asString.drop(4).asInteger;
				self.build_sender(idx);
				Param(self.proxy, key);
			} {
				Param(self.proxy, key);
			}
		},

		asParamGroup: { arg self;
			self.proxy.asParamGroup
		},

		nullbus: { arg self;
			BusDef(\null+++self.numchannels, \audio, self.numchannels)
		},

		zerobus: { arg self;
			BusDef(\zero+++self.numchannels, \audio, self.numchannels)
		},

		build_sender: { arg self, idx;
			var sendkey = \send+++idx;
			self.proxy.addSpec(sendkey, \unipolar);
			self.proxy[idx+1100] = \filter -> { arg in;
				Out.ar(\sendbus.kr(self.zerobus), in * sendkey.kr(1));
				in;
			}
		},

		stop: { arg self;
			self.proxy.stop;
		},

		isPlaying: { arg self;
			self.proxy.isPlaying;
		},

	));
TrackDef(\proxy_player, (
	play: { arg self;
		self.proxy.play;
		if(self.mixer.notNil) {
			self.mixer.play;
		};
	},

	stop: { arg self;
		self.proxy.stop;
		if(self.mixer.notNil) {
			self.mixer.stop;
		};
	},

	isPlaying: { arg self;
		self.proxy.isPlaying and: {
			self.mixer.isNil or: { self.mixer.isPlaying }
		};
	},
));
TrackDef(\drum, (
	label: { arg self; self.key },
	stepevent: { arg self; StepEventDef(self.key) },

	init: { arg self;
		"hello!".debug;
		self.putAll(TrackDef(\proxy_player));
		self.proxy = EventPatternProxy.new;
		StepEventDef(self.key)[\isRest] = StepEventDef(self.key)[\isRest] ?? { StepList.newFrom(0!8) };
		//StepEventDef(self.key)[\freq] = StepEventDef(self.key)[\freq] ?? { StepList.newFrom(400!8) };
		"hello!".debug;
		StepEventDef(self.key).repeats = inf;
		"hello!".debug;
		StepEventDef(self.key).addSpec(\isRest, \unipolar);
		"hello!".debug;
		StepEventDef(self.key)[\isRest].addSpec(\list, \unipolar);
		"hello!".debug;
		self.mixer = ~trackMixerDef.new(self.key);
		self.mixer.define_mixer;
		self.proxy.set(\out, self.mixer.inbus);
	},

	source_: { arg self, val;
		val.debug("source set");
		self[\source] = val;
		self.proxy.source = StepEventDef(self.key).asPattern <> val;
		self.proxy.source.debug("source set");
	},

	asParamGroup: { arg self;
		ParamGroup(self.source.asParamGroup.collect{ arg par;
			Param(self.stepevent, par.property, par.spec).default_(par.get)
		})
	},

	edit: { arg self;
		WindowDef(self.key, { 
			VLayout(
				~stepEventCoinView.new(StepEventDef(self.key)).hasCursor_(true).asView,
				PlayerWrapper(self.proxy).asView,
			)
		}).front;
	},
));
TrackDef(\main, (
	children: PlayerWrapperGroup([
		TrackDef(\kick),
		TrackDef(\snare),
		TrackDef(\hat),
	]),

	proxy: { arg self; self.children },

	edit: { arg self;
		WindowDef(self.key, { 
			var editview = View.new;
			VLayout(
				PlayerWrapper(self).asView,
				VLayout( *
					self.children.collect({ arg child;
						HLayout(
							PlayerWrapperSelectorView(child).selectAction_({
								editview.removeAll;
								editview.layout_(
									VLayout(
										child.target.asParamGroup.asView,
										[nil, stretch:10]
									)
								) 
							}).asView.fixedWidth_(100),
							child.target.mixer.asParam(\postfader).asKnob,
							~stepEventCoinView.new(child.target.stepevent).hasCursor_(true).asView
						).margins_(0).spacing_(5)
					})
					++ [nil]
				).margins_(0).spacing_(0),
				editview,
				nil,
			)
		}).front;
	}

)).putAll(TrackDef(\proxy_player));
TrackDef(\kick, TrackDef(\drum)).init;
TrackDef(\kick).source = Pdef(\kick);
TrackDef(\snare, TrackDef(\drum)).init;
TrackDef(\snare).source = Pdef(\snare);
TrackDef(\hat, TrackDef(\drum)).init;
TrackDef(\hat).source = Pdef(\hat);
TrackDef(\main).edit;
)

TrackDef(\kick).stepevent

(
WindowDef(\mixer, { arg me, trackgroup;
	HLayout(
		HLayout(*
			trackgroup.collect { arg track;
				var mixer;
				if(track.isKindOf(PlayerWrapper)) {
					track = track.target;
				};
				mixer = track.mixer;
				VLayout(
					//StaticText.new.string_(track.label).background_(track.color ? ParamView.color_ligth),
					PlayerWrapperSelectorView(PlayerWrapper(track)).asView,
					mixer.asParam(\postfader).asStaticTextLabel,
					mixer.asParam(\postfader).asSlider.orientation_(\vertical),
					mixer.asParam(\postfader).asTextField,
				);
			}
		),
		VLayout (
			PlayerWrapperSelectorView(trackgroup).asView,
			Param(Server.default.volume, \volume).asStaticTextLabel,
			Param(Server.default.volume, \volume).asSlider.orientation_(\vertical),
			Param(Server.default.volume, \volume).asTextField,
		)
	)
}).front(TrackDef(\main).children)
)

{ SinOsc.ar(200) ! 2 * 0.1}.play;


			Param(Server.default.volume, \volume).spec
			\fader.asSpec
			\db.asSpec


TrackDef(\drum).init;
TrackDef(\drum).init
TrackDef(\drum).edit;
TrackDef(\drum).edit;

Pdef(\snare).asParamGroup
Pdef(\snare).instrument
Pdef(\snare)
TrackDef(\snare).play
TrackDef(\snare).stop
TrackDef(\snare).edit
TrackDef(\kick).edit

Trac


TrackDef(\drum).source = Pdef(\kick)
TrackDef(\drum).play
TrackDef(\drum).proxy
TrackDef(\drum).proxy.source
Pdef(\kick).play;


Param(StepEventDef(\drum)[\isRest], \list).edit
Param(StepEventDef(\drum)[\isRest], \list).spec
Param(StepEventDef(\drum), \isRest).spec
Param(StepEventDef(\drum), \isRest).edit
StepEventDef(\drum).getSpec
StepEventDef(\drum).addSpec(\isRest, \unipolar)

StepEventDef(\drum)
StepEventDef(\drum).asView
StepEventDef(\drum).repeats = inf
StepEventDef(\drum).dur = 1/8
~se = StepEventDef(\drum)
ParamProto.init
(
WindowDef(\gui, { 
	~stepEventView.new(~se).makeLayout 
}).front;
)


~pb = PbindProxy.new
~pb.amp
~pb[\amp].source
~pb[\amp] = Pseq([1,1,0])
~pb[\dur] = 1/8;
~pb.at(\amp)
~pb.set(\amp, Pseq([1,0,1],inf))
~pb.play
~pb.set(\dur, 1/4)

~pb[
~pb.set(\freq, Pseq([4441,411],inf))
~pb.set(\amp, 0.1)
~pb.set(\freq, StepList.newFrom([741,1411]).asPattern)
~pb.set()
~pb.at(\freq).source.edit
~pb.at(\freq).source.stepCount = 8
~pb[\freq]
Pattern
~pb.at(\freq).source.list.edit
~pb[\freq].edit
~pb.freq.edit

(
~se = StepEvent.new;
~se[\freq] = 1000;
)
~se.play;
~se[\instrument] = \default








//////////////////////////////////////



(
SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(\fm.kr(1) * freq) * \fmamp.kr(1) )));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = ( sig * [100,200] ).tanh / 3;
	sig = RLPF.ar(sig, \lpf.kr(1000) * [1,1/2],0.1);
	sig = Pan2.ar(sig, SinOsc.kr([1,1.1]/2,Rand(-2,2),mul:0.7) + pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\bass, Pbind(
	\instrument, \default,
	\instrument, \bass,
	\degree, Pseq([0,2,4,2],inf),
	\fmamp, Pseq([0.1,0.5,0.2,2],inf) * Pseg(Pseq([0,1,20],inf),16),
	\lpf, Pseq([1000,1011]*2,inf),
	\lpf, Ndef(\lfo1, { MouseX.kr(100,17001) }),
	\rq, Ndef(\lfo2, { MouseY.kr(0.01,1) }),
	\fmamp, Ndef(\lfo3, { MouseY.kr(0.01,10) }),
	//\pan, Ndef(\lfo2, { SinOsc.kr(1/4.1) * 0.5 }),
	\fm, Pseq([1,2,1,1, 1,1/2,1.01],inf),
	\degree, Pseq([
		Pseq([0,1],4),
		Pseq([4,2],4),
	],inf),
	//\degree, Pseq([0,2,4,2],inf),
	\legato, 1/2,
	\legato, Pseq([2,Prand([2,0.5,0.5,0.5,0.5,1,1.5,1,1,1.3,0.2],6), 0.1],inf),
	\isRest, Pfunc({
		~prevlegato.debug("prevlegato");
		if(~prevlegato.notNil and: { ~prevlegato > 1 }) {
			true
		} {
			false
		}
	}),
	\prevlegato, Pfunc({ arg ev; ~prevlegato = ev[\legato] }),
	\octave, 3,
	\root, Pseq([0,2,3,5],inf).stutter(8),
	\root, Pseq([0,5,-1,5],inf).stutter(4),
	\dur, Pfunc({ Ndef(\lfodur).bus.getSynchronous }),
	\amp, 0.1
)).play;
);

Ndef(\lfodur, { MouseY.kr(1/32,1, \exponential) })




(

var w= Window("popuptreemenu - simple", Rect(200, 400, 300, 100)).front;

a= PopUpTreeMenu.new(w, Rect(50, 30, 100, 20))

	.tree_(

		(

			'a drum': (),

			'bass': (

				'funky': (),

				'unhip': (

					'umpahTuba': (),

					'umpahUpright': ()

				)

			),

			'melo': ()

		)

	);

a.action_{|view, val| ("selected:"+val).postln};

)

a.value_(['bass', 'funky'])

a.value_(['melo'])

a.valueAction_(['bass', 'unhip', 'umpahTuba'])

(

var w= Window("popuptreemenu - simple").front;

w.layout_(
	VLayout(
		Knob.new.mouseDownAction_({
			var pop;
			var win = Window("kkk").front;
			pop = PopUpTreeMenu.new(win);
			pop.tree_((
				\akakakak: (),
				\wwjakakakak: (),
				\wwwakakakak: (),
			))
		})
	)
)

)


ContextMenuWindow.new([
	"Set seq mode",
	"Start automation",
]).action_({ arg me, idx; idx.debug("selected") }).front(view, x,y);

(


WindowDef(\popup, {
		VLayout(
			Knob.new.mouseDownAction_({ arg view, x, y, mod, mouseButton;
				var pop;
				var bo = view.absoluteBounds;
				var win;
				mouseButton.debug("button");
				if(mouseButton == 1) {
					//win = Window("kkk",Rect(x+bo.origin.x,view.absoluteBounds.top-y,100,100), border:false).front;
					win = Window("kkk",Rect(x+bo.origin.x,Window.screenBounds.height - view.absoluteBounds.top - y,1,1), border:false).front;
					[x,y, view.absoluteBounds, view.bounds, Window.screenBounds].debug("BOUDS");
					if(~win.notNil) {
						~win.close;
						~win = nil;
					};
					~win = win;
					win.endFrontAction = {
						win.close;
					};
					win.layout_(
						VLayout(
							ListView.new.items_(["jjj","lll"]).mouseDownAction_({
								
								//{ win.close }.defer(1);
							}).selectionAction_({ arg me;
								me.selection.debug("selection!!");
								if(me.selection.size > 0) {

									win.close;
								}

							}).selection_(nil).selectionMode_(\single)
						).margins_(0).spacing_(0)
					)
				}
			})
		)

}).front;

)

(


WindowDef(\popup, {
		VLayout(
			Knob.new.mouseDownAction_({ arg view, x, y, mod, mouseButton;
				var menu = MenuSpec(
					[
						"Setmode" -> { "k".debug },
						"remove" -> { "xxxk".debug },
					]
				);
				ContextMenuWindow(menu.labelList.asArray).front(view, x, y, mouseButton).action_({ arg me, idx;
					menu.valueList[idx].value

				})
			})
		)

}).front;

)
