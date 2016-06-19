(
	"/home/ggz/.local/share/SuperCollider/Extensions/param/Proto/eventFactory.scd".load
)
ParamProto.init(true);
~noteTimeline
{ SinOsc.ar(200) ! 2 * 0.1}.play;	

//////////////// record notes!!!

(
MKtl(\lp, "novation-launchpad-s");
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
	~pat = Pbind(
		\instrument, \bri,
		\root, Pseq([0,2,4],inf),
		\midinote, Pkey(\root) + Pkeyd(\midinote, 0),
		\lpf, Pseq([7000,5000,3000, 4000],inf),
		\fmfreq, Pseq([7,5000,30],inf),
		\dur, 1/4,
		\amp, 0.1
	);
	Pdef(\pat, ~pat);
	~arppat = Pbind(
		\instrument, \bri,
		\root, Pseq([0,2,4],inf),
		\root, Prout({ arg ev;
			var idx = 0;
			inf.do {
				var cur;
				if(ev[\midinotes].size == 0) {
					ev = \rest.yield;
					idx = 0;
				} {
					cur = ev[\midinotes][idx];
					if(cur.isNil) {
						idx = 0;
					} {
						ev = cur.yield;
						idx = idx + 1;
					} 
				}
			}
		}).loop,
		\midinote, Pkey(\root) + Pkeyd(\midinote, 0),
		\lpf, Pseq([7000,5000,3000],inf),
		\dur, 1/4,
		\amp, 0.1
	);
	~monopat = Pmono(\bri,
		\root, Pseq([0,2,4],inf),
		\midinote, Pkey(\root) + Pkeyd(\midinote, 0),
		\lpf, Pseq([7000,5000,3000],inf),
		\dur, 1/4,
		\amp, 0.1
	);
)

(
~noteTimeline.new(\line1, Param(Pdef(\pat), \midinote));
//~noteTimeline.new(\line1).edit;
~event_factory = ~noteTimeline.new(\line1).eventFactory;
//~event_factory.mode = \note;
//~event_factory.playmode = \toggle;
//~event_factory.playmode = \gate;
WindowDef(\test, { arg win;
	var ms = MenuSpec([\pattern, \trigger, \note, \event]);
	var pms = MenuSpec([\toggle, \gate]);

	win.view.keyDownAction_({ arg me, key, modifiers, unicode, keycode;
		["down", me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
		"azertyuiop".as(Array).collect({ arg letter, x;
			var midinote = x+(5*12);
			[letter,key == letter ].asCompileString.debug("letter");
			if(key == letter) {
				~map_key.(\down, ~event_factory.childAt(midinote))
			}
		})
	});

	win.view.keyUpAction_({ arg me, key, modifiers, unicode, keycode;
		["up", me, key.asCompileString, modifiers, unicode, keycode].debug("keyUpAction");
		"azertyuiop".as(Array).collect({ arg letter, x;
			var midinote = x+(5*12);
			["up", letter,key == letter, midinote ].asCompileString.debug("letter");
			if(key == letter) {
				~map_key.(\up, ~event_factory.childAt(midinote))
			}
		})
	});

	VLayout (
		HLayout (
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \mode, ms)),
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \playmode, pms)),
			BasicButton.new.label_("Start Rec").action_({ ~event_factory.startRecording }),
			BasicButton.new.label_("Stop Rec").action_({ ~event_factory.stopRecording }),
			BasicButton.new.label_("Play Rec").action_({ ~event_factory.eventLoop.play; }),
		),
		VLayout(
			~noteTimeline.new(\line1).asView,
			HLayout (
				* 10.collect{ arg x;
					var but;
					var midinote = x+(5*12);
					but = Button.new;
					but.states = [
						[midinote.asString],
						[midinote.asString, Color.black, Color.yellow]
					];
					// TODO: what to use with MIDIMap and Mktl
					~map_button.(but, ~event_factory.childAt(midinote));
				};
			)
		)
	)
}).frontTop
)

~noteTimeline.new(\line1).eventList.print
ParamProto.init(true);
ParamProto.init;
~noteTimeline.new(\line1).edit
~noteTimeline.new(\line1).proxy.quant = 4
Pdef.defaultQuant = 4;
XEventLoop.newInstance.list
XEventLoop.newInstance.setList(0)
XEventLoop.newInstance.addList(XEventList.new.start.finish(1));
~loop = XEventLoop.newInstance;
~loop
~loop.list
~loop.addList(XEventList.new.start.finish(1));
XEventList.new.start.finish(1).isEmpty

(make: { "yep" }).make
(next: { "yep" }).next
ProtoClass((next: { "yep" })).next
ProtoClass((make: { "yep" })).make

/////////////////////// launchpad
	(
	Pdef(\pat, Pbind(
		\instrument, \bri,
		\root, Pseq([0,2,4],inf),
		\midinote, Pkey(\root) + Pkeyd(\midinote, 0),
		\lpf, Pseq([7,5,3, 4],inf)*10 + Pkey(\freq) * 3,
		\fmfreq, Pkey(\freq) * Pseq([1,1.0005,1.0002],inf),
		//\fmfreq, Pseq([1000,100,10000],inf),
		//\fmfreq, Ndef(\lfo1, { SinOsc.kr(1).range(1000,7000) }),
		\lpf, Ndef(\lfo1, { SinOsc.kr(0.4).range(1000,7000) }),
		\fmamp, Ndef(\lfo2, { SinOsc.kr(0.014).range(0.1,7) }),
		\dur, 1/4,
		\amp, 0.1
	));
	)
	(
	Pdef(\pat, Pbind(
		\instrument, \bri,
		\root, Pseq([0,2,4],inf),
		\midinote, Pkey(\root) + Pkeyd(\midinote, 0),
		\lpf, Pseq([7,5,3, 4],inf)*10 + Pkey(\freq) * 3,
		\fmfreq, Pkey(\freq) * Pseq([1,1.0005,1.0002],inf),
		//\fmfreq, Pseq([1000,100,10000],inf),
		//\fmfreq, Ndef(\lfo1, { SinOsc.kr(1).range(1000,7000) }),
		\lpf, Ndef(\lfo1, { SinOsc.kr(0.4).range(11000,7000) }),
		\fmamp, Ndef(\lfo2, { SinOsc.kr(0.014).range(00.1,0.70) }),
		\dur, 1/4,
		\amp, 0.1
	));
	)
	(
	SynthDef(\bri, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		freq = freq * ( 1 + ( SinOsc.ar(\fmfreq.kr(0)) * \fmamp.kr(1) * SinOsc.kr([1,1.04]) ));
		sig = LFSaw.ar(freq).mean;
		sig = RLPF.ar(sig, \lpf.kr(7100), \rq.kr(0.5));
		sig = sig + RLPF.ar(sig, 200, 0.1);
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan * SinOsc.ar([1,20]) * SinOsc.kr(1/4).exprange(0.1,1), amp).flop.mean;
		Out.ar(out, sig);
	}).add;
	)

	(
	SynthDef(\bri, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		freq = freq * ( 1 + ( SinOsc.ar(\fmfreq.kr(0)) * \fmamp.kr(1) * SinOsc.kr([1/2,1.04]/2) ));
		sig = LFSaw.ar(freq);
		sig = RLPF.ar(sig, \lpf.kr(7100), \rq.kr(0.5));
		sig = sig + RLPF.ar(sig, 200, 0.1);
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan * SinOsc.ar([1,20]) * SinOsc.kr(1/4).exprange(0.1,1), amp).flop.mean;
		Out.ar(out, sig);
	}).add;
	)


//MKtl.find
MKtl(\lp).postElements
(
MKtl(\lp).elAt(\pad).do ({ arg pad, idx;
	pad.elAt(\on).action = { idx.debug("LPplay");};
	pad.elAt(\off).action = { idx.debug("LPstop");};
});
)

(
~event_factory = ~class_event_factory.new(Pbind(
	\instrument, \default,
)).mode_(\note)
)
~event_factory.childAt(70).play
~event_factory.childAt(70).stop

(
)
(
~noteTimeline.new(\line1, Param(Pdef(\pat), \midinote));
//~noteTimeline.new(\line1).edit;
~event_factory = ~noteTimeline.new(\line1).eventFactory;
//~event_factory.mode = \note;
//~event_factory.playmode = \toggle;
//~event_factory.playmode = \gate;
MKtl(\lp).elAt(\pad).do ({ arg pad, idx;
	idx = idx+24;
	pad.elAt(\on).action = { arg me; me.value = 40.754; idx.debug("LPplay"); ~event_factory.childAt(idx).play };
	pad.elAt(\off).action = { arg me; me.value = 0.754; idx.debug("LPstop"); ~event_factory.childAt(idx).stop };
});
WindowDef(\test, { arg win;
	var ms = MenuSpec([\pattern, \trigger, \note, \event]);
	var pms = MenuSpec([\toggle, \gate]);

	win.view.keyDownAction_({ arg me, key, modifiers, unicode, keycode;
		["down", me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
		"azertyuiop".as(Array).collect({ arg letter, x;
			var midinote = x+(5*12);
			[letter,key == letter ].asCompileString.debug("letter");
			if(key == letter) {
				~map_key.(\down, ~event_factory.childAt(midinote))
			}
		})
	});

	win.view.keyUpAction_({ arg me, key, modifiers, unicode, keycode;
		["up", me, key.asCompileString, modifiers, unicode, keycode].debug("keyUpAction");
		"azertyuiop".as(Array).collect({ arg letter, x;
			var midinote = x+(5*12);
			["up", letter,key == letter, midinote ].asCompileString.debug("letter");
			if(key == letter) {
				~map_key.(\up, ~event_factory.childAt(midinote))
			}
		})
	});

	VLayout (
		HLayout (
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \mode, ms)),
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \playmode, pms)),
			BasicButton.new.label_("Start Rec").action_({ ~event_factory.startRecording }),
			BasicButton.new.label_("Stop Rec").action_({ ~event_factory.stopRecording }),
			BasicButton.new.label_("Play Rec").action_({ ~event_factory.eventLoop.play; }),
		),
		VLayout(
			~noteTimeline.new(\line1).asView,
			HLayout (
				* 10.collect{ arg x;
					var but;
					var midinote = x+(5*12);
					but = Button.new;
					but.states = [
						[midinote.asString],
						[midinote.asString, Color.black, Color.yellow]
					];
					// TODO: what to use with MIDIMap and Mktl
					~map_button.(but, ~event_factory.childAt(midinote));
				};
			)
		)
	)
}).frontTop
)
/////////////////////////////////////////////////////////////////////////////
//////////////// record drums!!!

(

	Pdef(\yep,
		PdrumStep(
			[
				Pbind(
					\instrument, \default,
					\freq, 200,
					\amp, 0.1
				),
				Pbind(
					\instrument, \default,
					\freq, 500,
					\amp, 0.1
				),
				Pbind(
					\instrument, \default,
					\freq, 300,
					\amp, 0.1
				),
				Pbind(
					\instrument, \default,
					\freq, 401,
					\amp, 0.1
				),
			],
			Pbind(
				\midinote, Pseq([0,1,2],inf),
			)
		)
	).play;
)

// with chain

(

	Pdef(\yep,
		PdrumStep(
			[
				Pbind(
					\instrument, \default,
					\freq, 200,
					\amp, 0.1
				),
				Pbind(
					\instrument, \default,
					\freq, 500,
					\amp, 0.1
				),
				Pbind(
					\instrument, \default,
					\freq, 300,
					\amp, 0.1
				),
				Pbind(
					\instrument, \default,
					\freq, 401,
					\amp, 0.1
				),
			]
		) <>
			Pbind(
				\midinote, Pseq([0,1,2],inf),
			)
	).play;
)
