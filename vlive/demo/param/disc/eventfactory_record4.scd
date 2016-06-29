
ParamProto.init(true);
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

PlayerEvent.new
ParamProto.init(true);
PlayerWrapper(Ndef(\node1))
~ef.eventLoop.list.print
~ef.eventLoop.list[2].type
~clipTimeline.new(\line).edit
~clipTimeline.new(\line).editor.clipEditor.refreshPopups
~clipTimeline.new(\line).clear

~pwg = PlayerWrapperGroup([
	Pdef(\pat1),
	Pdef(\pat2),
	Ndef(\node1),
	TrackDef(\track2),
]);
~pwg.label
~pwg.label = 122

~pw = PlayerWrapper(~pwg)
~pw.label
~pw.isPlaying
~pw.play
~pw.stop
~pwg.isPlaying
~pwg.isPlaying

(
//~ef = ~class_player_event_factory.new([
//	Pdef(\pat1),
//	Pdef(\pat2),
//	Ndef(\node1),
//]);
//~ef.eventLoop = ~clipTimeline.new(\line).eventLoop;
~ef = ~clipTimeline.new(\line).eventFactory;
~ef.set_players([
	Pdef(\pat1),
	Pdef(\pat2),
	Ndef(\node1),
	TrackDef(\track2),
]);
~player_group = ~ef.players;
//~clipTimeline.new(\line).eventFactory = ~ef;
~event_factory = ~ef;
WindowDef(\test, { arg wd;
	var ms = MenuSpec([\pattern, \trigger, \note, \event]);
	var pms = MenuSpec([\toggle, \gate]);
	var win = wd.window;

	//win.view.keyDownAction_({ arg me, key, modifiers, unicode, keycode;
	//	["down", me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
	//	"azertyuiop".as(Array).collect({ arg letter, x;
	//		var midinote = x+(5*12);
	//		[letter,key == letter ].asCompileString.debug("letter");
	//		if(key == letter) {
	//			~map_key.(\down, ~event_factory.childAt(midinote))
	//		}
	//	})
	//});

	//win.view.keyUpAction_({ arg me, key, modifiers, unicode, keycode;
	//	["up", me, key.asCompileString, modifiers, unicode, keycode].debug("keyUpAction");
	//	"azertyuiop".as(Array).collect({ arg letter, x;
	//		var midinote = x+(5*12);
	//		["up", letter,key == letter, midinote ].asCompileString.debug("letter");
	//		if(key == letter) {
	//			~map_key.(\up, ~event_factory.childAt(midinote))
	//		}
	//	})
	//});

	HLayout(
		~clipTimeline.new(\line).asView,
		VLayout (
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \mode, ms)),
			PopUpMenu.new.mapParam(Param(Message(~event_factory), \playmode, pms)),
			BasicButton.new.label_("Play Rec").action_({ ~event_factory.eventLoop.play; }),
			Button.new.mapParam(Param(Message(~event_factory), \isRecording, XBoolSpec())).states_([
				["Rec", Color.black, Color.white],
				["Rec", Color.black, Color.red],
			]),
			BasicButton.new.label_("Start Rec").action_({ ~event_factory.startRecording }),
			BasicButton.new.label_("Stop Rec").action_({ ~event_factory.stopRecording }),
			HLayout(
				* ~player_group.collect(_.asView)
			)
			
			//VLayout(
			//	* 10.collect{ arg x;
			//		var but;
			//		var midinote = x+(5*12);
			//		but = Button.new;
			//		but.states = [
			//			[midinote.asString],
			//			[midinote.asString, Color.black, Color.yellow]
			//		];
			//		// TODO: what to use with MIDIMap and Mktl
			//		~map_button.(but, ~event_factory.childAt(midinote));
			//	};
			//)
		)
	)
}).frontTop
)


~d = TestDependant.new
~d.update = 10

:tab
~d.addDependant( Ndef(\note1) )
Ndef(\node1).set(\freq, 200)
Ndef(\node1).play
Ndef(\node1).end
Pdef(\pat1).play
Pdef(\pat1).set(\freq, 400)
Pdef(\pat1).stop
Ndef(\node1).changed(\plop, \bla, \rah)
Ndef(\node1).addDependant(~d)
Pdef(\pat1).addDependant(~d)
TrackDef(\track2).addDependant(~d)
TrackDef(\track2).changed(\play, 1)
TrackDef(\track2).play
TrackDef(\track2).stop

NotificationCenter

TestDependant

~pw = PlayerWrapper(Pdef(\pat1));
~pw = PlayerWrapper(TrackDef(\track2));
~c = SimpleController.new(~pw.target).put(\play, { arg ...args; args.debug("aqrgf play"); })
~pw.play
~pw.stop
PlayerWrapper(Pdef(\pat1)).makeListener({ arg ...args; args.debug("aqrgf play"); })
~pw.makeListener({ arg ...args; args.debug("aqiiiirgf play"); })
~pw = ~ef.players[0]


~el = XEventLoop.newInstance
~el.startRec(true)
~el.recordEvent((bla:4))
