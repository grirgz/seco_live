
// copy eventfactory.scd because i will probably mess up everything

(
	"/home/ggz/.local/share/SuperCollider/Extensions/param/Proto/eventFactory.scd".load
)


(
	SynthDef(\bri, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
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
		\lpf, Pseq([7000,5000,3000],inf),
		\dur, 1/4,
		\amp, 0.1
	);
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
~event_factory = ~class_event_factory.new(~pat);
~event_factory.eventLoop = XEventLoop(\rec1, { arg ev; ev.play.debug("ev!!!!") }).verbosity_(3);
~event_factory.mode = \note;
~event_factory.playmode = \toggle;
~event_factory.playmode = \gate;
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
		PopUpMenu.new.mapParam(Param(Message(~event_factory), \mode, ms)),
		PopUpMenu.new.mapParam(Param(Message(~event_factory), \playmode, pms)),
		BasicButton.new.label_("Start Rec").action_({ ~event_factory.startRecording }),
		BasicButton.new.label_("Stop Rec").action_({ ~event_factory.stopRecording }),
		BasicButton.new.label_("Play Rec").action_({ ~event_factory.eventLoop.play; }),
		VLayout(
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
}).frontTop
)


XEventLoop(\test).play
XEventLoop(\test).list.print

(
	//~el = XEventLoop(\testx, { arg ev; ev.debug("ev!!"); });
	~el = XEventLoop(\testy);

	{

		1.wait;
		"start".debug;
		~el.startRec;

		~el.recordEvent(
			( 'instrument': \bri, 'dur': 0.25, 'amp': 0.1, 'midinote': 65,
				'sustain': inf, 'lpf': 7000, 'root': 0, 'latency':\ 
			).postln
		);
		0.25.wait;

		~el.recordEvent(
			( 'instrument': \bri, 'dur': 0.25, 'amp': 0.1, 'midinote': 66,
				'sustain': inf, 'lpf': 7000, 'root': 0, 'latency':\ 
			).postln
		);
		0.25.wait;

		~el.recordEvent(
			( 'instrument': \bri, 'dur': 0.25, 'amp': 0.1, 'midinote': 68,
				'sustain': inf, 'lpf': 7000, 'root': 0, 'latency': \ 
			).debug("3")
		);
		0.25.wait;

		~el.stopRec;

	}.fork
)

//////////////////// using in timeline

ParamProto.init
~noteTimeline.new(\line1)
~noteTimeline.new(\line1).composeParamPattern = false
~noteTimeline.new(\line1).edit
~noteTimeline.new(\line1).editor.timeline.mapEventList(XEventLoop(\rec1).list)
~noteTimeline.new(\line1).eventloop = XEventLoop(\rec1)

// works ok with embeded instrument parameters
// now adding note graphically shoud use the eventFactory

~noteTimeline.new(\line1).editor.timeline.eventFactory = ~event_factory.get_eventFactory_function

// ok this works
// but this is so ugly!!!
// also this work only for \note mode eventFactory

// now how to enable recording only key pressed and time, so the others keys are added with pattern composition ?



// now eventFactory should be created automatically when creating a timeline



/////////////////////////////////// Ndef factory draft

// how about a controller with 4 buttons each launching or stopping a Ndef or other PlayerWrapper ?

TrackGroupDef(\bla, [
	Ndef(\a1),
	Ndef(\a2),
	Ndef(\a3),
	Ndef(\a4),
]);

ClipTimellne(\line, TrackGroupDef(\bla)); // create automatically an EventFactory

// manually (full event way)
~ef = EventFactory.new;
~ef.childfun = { arg midinote; (type: \player, player: TrackGroupDef(\bla)[midinote]) };

// manually (score way)
~ef = EventFactory.new( 
	Pbind(
		\type, \player,
		\player, Pfunc({ arg ev;
			TrackGroupDef(\bla)[ev.midinote]
		})
	)
);
~ef.childfun = { arg midinote; (midinote:midinote) };

// midimap eventFactory
Mktl(\mycont).elAt(\buttons).collect({ arg but, idx; but.mapParam( ~ef.childAt(idx) ) });
Mktl(\mycont).elAt(\buttons).mapParam(~ef) // collect internally


// midi map timeline
Mktl(\mycont).elAt(\buttons).collect({ arg but, idx; but.mapParam( ~timeline.eventFactory.childAt(idx) ) });
Mktl(\mycont).elAt(\buttons).mapParam(ClipTimellne(\line)) // collect internally


///////////////////////////////////// design questions
constructor should take stream or childfun or both and in what order ?
childfun seems more important, on the other hand, for a note timeline, it can be default and the instrument is more important


is .startRecording should be implemented on eventFactory ? it's already implemented on XEventLoop, but it doesnt have stream, so put the eventFactory in XEventLoop ?
or EventFactory is the intermediate between XEventLoop and stream and MIDI ?

///////////////////////////////

(
Pbind(
	\parent, (play: { "hello".postln }),
	\play, { "bla".postln; },
	\finish, { "2bla".postln; },
	\bla, Pfunc({ arg ev; "============================".postln; ev.parent.asCompileString.postln }),
).trace.play
)

EventPatternPlayer
PatternPlayer
EventStreamPlayer


Event.new[\freq]
Event.default[\freq]

(
	(
		Prout({ arg ev;
			ev.asCompileString.debug("ev")
			//ev.debug("ev")
		})
		<>
		Pevent(Pbind(
			\note, Pseq([1,2,3,4])
		), (bla:4))

	).play
)


(bla: 4) <> (rai: 56)
(bla: 4) <> { ~rai = 34 }
Event.default.eventTypes[\note]

~s = Pseq([
	(
		proto: (yep:10),
		bla: 45
	)
]).asStream.next(Event.default)
~s.yep


~s = Pseq([
	Pev((
		parent: (yep:10),
		bla: 45
	))
]).asStream.next(Event.default)


~p = ProtoClass((
	asEvent: { "hello" }
))
~p.asEvent

PlayerEvent
PatternEvent


(
SynthDef(\my, { arg gate;
	var sig;
	sig = SinOsc.ar(( \freq.kr(200).poll + \out.kr(100) + \amp.kr(10) + \legato.kr(20) ).poll );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig);
	Out.ar(0, sig);
}).add;
)

(
	(
		
		Pfunc({ arg ev; ev.debug("ev"); ev.parent.debug("parent") }) <>
Pevent(
	Pbind(
		\instrument, \my,
	),
	//Environment.new
	(parent:nil)
)
	).trace.play
)
().parent
Event.new.parent
Event.default.parent

(
	(
		
		Pfunc({ arg ev; ev.debug("ev"); ev.parent.debug("parent") }) <>
	Pbind(
		\instrument, \my,
	)
	).trace.play
)

Parent
Event

(
	(
		

Pevent(
	Pbind(
		\instrument, \my,
		\freq, 120,
	),
	//Environment.new
	(parent:Event.partialEvents.playerEvent),
)
	).trace.play
)



(
	(
		

	Pbind(
		\type, \Synth,
		\instrument, \my,
		\freq, 120,
	)
	).trace.play
)



/home/ggz/.local/share/SuperCollider/Extensions/param/Classes/Event.sc

