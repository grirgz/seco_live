
//
(

~drumkit = [
	Pbind(
		\instrument, \default,
		\detune, Pseq([200,201,212]*1.4/200,inf),
		\midinote, 60,
		\dur, 1,
		\amp, 0.1
	),
	Pbind(
		\instrument, \default,
		\detune, Pseq([200,201,212]*1.4/200,inf),
		\midinote, Pseq([62],inf),
		\dur, 1,
		\amp, 0.1
	),
	Pbind(
		\instrument, \default,
		\detune, Pseq([200,201,212]*1.4/200,inf),
		\midinote, Pseq([64],inf),
		\dur, 1,
		\amp, 0.1
	),
];
)

(
// simple
WindowDef(\piano, {

	VLayout (*
		~drumkit.collect({ arg pat, idx;
			var ev;
			ev = pat.asStream.next(Event.default);
			ev[\isRest] = false;
			ev[\latency] = \;
			BasicButton.new.action_({
				ev.play;
			}).label_(idx);
		})
	)

}).front
)
)

(
// on off
WindowDef(\piano, {

	VLayout (*
		~drumkit.collect({ arg pat, idx;
			var ev;
			var player;
			var str;
			str = pat.asStream;
			BasicButton.new.mouseDownAction_({
				if(player.notNil) { // required for not overwriting player if already playing (too fast pushing)
					player.release;
				};
				ev = Event.default;
				ev = str.next(ev);
				ev[\isRest] = false;
				ev[\sustain] = inf;
				ev[\latency] = \;
				player = ev.play;
			}).action_({
				player.release;
				player = nil;
			}).label_(idx);
		})
	)

}).front;
)


(
// launchpad on off

~drumkit.do({ arg pat, idx;
	var ev;
	var player;
	var str;
	var pad = MKtl(\lp).elAt(\pad);
	str = pat.asStream;
	pad.elAt(idx).elAt(0).action_({
		"on".debug;
		if(player.notNil) { // required for not overwriting player if already playing (too fast pushing)
			player.release;
		};
		ev = Event.default;
		ev = str.next(ev);
		ev[\isRest] = false;
		ev[\sustain] = inf;
		ev[\latency] = \;
		player = ev.play;
	});
	pad.elAt(idx).elAt(1).action_({
		"off".debug;
		player.release;
		player = nil;
	});
});

)
k = MKtl(\lp, "novation-launchpad-s");
k.elAt(\pad).elAt(0).elAt(0).action = { "0 on pushed".postln; };
k.elAt(\pad).elAt(0).elAt(1).action = { "0xx off pushed".postln; };
k.postElements;
k.elAt(\pad).elAt(0).elAt(0).value = 0.05;

(
// recording (fake)

~record = { arg ev;
	"record: %".format(ev).postln;
};
~update = { arg ev;
	"update: %".format(ev).postln;
};
~drumkit.do({ arg pat, idx;
	var ev;
	var player;
	var str;
	var pad = MKtl(\lp).elAt(\pad);
	var recev;
	var startbeat;
	var clock = TempoClock.default;
	ev = Event.default;
	str = pat.asStream;
	pad.elAt(idx).elAt(0).action_({
		"on".debug;
		if(player.notNil) { // required for not overwriting player if already playing (too fast pushing)
			player.release;
		};
		ev = str.next(ev);

		recev = ev.copy;
		startbeat = clock.beats;
		~record.(recev);


		ev[\isRest] = false;
		ev[\sustain] = inf;
		ev[\latency] = \;
		player = ev.play;
	});
	pad.elAt(idx).elAt(1).action_({
		"off".debug;
		recev[\sustain] = clock.beats - startbeat;
		~update.(recev);
		player.release;
		player = nil;
	});
});

)

(
// recording with EventList

~el = XEventLoop(\ex);
~record = { arg ev;
	"record: %".format(ev).postln;
	~el.recordEvent(ev);
};
~update = { arg ev;
	"update: %".format(ev).postln;
	ev.changed(\refresh);
};
~el.startRec;
~drumkit.do({ arg pat, idx;
	var ev;
	var player;
	var str;
	var pad = MKtl(\lp).elAt(\pad);
	var recev;
	var startbeat;
	var clock = TempoClock.default;
	ev = Event.default;
	str = pat.asStream;
	pad.elAt(idx).elAt(0).action_({
		"on".debug;
		ev = str.next(ev);

		// record
		recev = ev.copy;
		startbeat = clock.beats;
		recev = ~record.(recev.copy);
		// or
		//~el.recordEvent(ev); 

		// play
		if(player.notNil) { // required for not overwriting player if already playing (too fast pushing)
			player.release;
		};
		ev[\isRest] = false;
		ev[\sustain] = inf;
		ev[\latency] = \;
		player = ev.copy.play;
	});
	pad.elAt(idx).elAt(1).action_({
		"off".debug;

		// record stop
		recev[\sustain] = clock.beats - startbeat;
		~update.(recev);

		// play stop
		player.release;
		player = nil;
	});
});

)
~el.stopRec;
~el.printLists
~el.play
~el.play
~el.list.asPattern.play


// ParamRecorder serait en realité, un XEventLoop subclassé ?
// ou bien une classe de recording a laquelle on peut fournir un event list comme pour EventFactory
ParamRecorder(Param(x,y,z))
PlayerGroupRecorder( DrumPlayerGroup(~drumkit) )
PlayerGroupRecorder( NotePlayerGroup(~rhodes) )
PlayerGroupRecorder( PlayerWrapperGroup(~tracks) )
PlayerGroupRecorder( TrackDef(\drums) )

NotePlayerGroup(Pdef(\rhodes))
MidinoteTimeline(Param(Pdef(\rhodes), \midinote)).record
PianoView.new( NotePlayerGroup(Pdef(\rhodes), \midinote) )
PianoView.new( DrumPlayerGroup( [Pdef(\kick), Pdef(\snare)] ) )
PianoView.new( PlayerWrapperGroup( [Pdef(\drums), Pdef(\melody)] ) )
NotePlayerGroup

(
// recording with DrumPlayerWrapperGroup

DrumPlayerGroup(~drumkit).do({ arg player, idx;
	var pad = MKtl(\lp).elAt(\pad);
	pad.elAt(idx).elAt(0).action_({
		"on".debug;
		player.play;
	});
	pad.elAt(idx).elAt(1).action_({
		"off".debug;
		player.stop;
	});
});

// now record

PlayerWrapperRecorder( XEventLoop(\drum), DrumPlayerGroup(~drumkit) );
DrumGroupRecorder(ParPlayerGroup(~drumkit))

)


(
)

(
Pseq([
	Rest(1.2),
	Pbind(
		\midinote, Pseq([63,54,64]),
		\dur, Pseq([0.2,0.4345345,0.323123123]),
		\sustain, Pseq([0.1231231,0.323434,0.12312313]),
	)
]).play
)

~pg = ~parPlayerGroup.new(~drumkit)
~pg.elAt(0).play
~pg.elAt(0)
~pg.elAt(0).stop

~pg.elAt(0).asPlayerEvent
~pg.elAt(0)
~ev = ();
~ev.asPlayerEvent = { 12 }
~ev.asPlayerEvent 

(
~pg = nil;
~pg = ~pg ?? { ~parPlayerGroup.new(~drumkit) };
// recording with DrumPlayerWrapperGroup

MKtl(\lp, "novation-launchpad-s");
~pg.elDo({ arg player, idx;
	var pad = MKtl(\lp).elAt(\pad);
	player.debug("player");
	pad.elAt(idx).elAt(0).action_({
		"on".debug;
		player.play;
	});
	pad.elAt(idx).elAt(1).action_({
		"off".debug;
		player.stop;
	});
});

)

(
// now record

//~PlayerWrapperRecorder( XEventLoop(\drum), DrumPlayerGroup(~drumkit) );
~pr = ~playerGroupRecorder.new(~pg);

~pr.stopRecording;
~pr.startRecording;
)

~pr.eventLoop.play
~pr.eventLoop.list = nil
~pr.eventLoop.list.print

~pr.getPresetCompileString.pbcopy.vimpbpaste
XEventList.newFrom(Pbind(
	\midinote, Pseq([ 60, 62, 64, 64, 64, 62, 60 ]),
	\dur, Pseq([ 0.386960472, 0.205024394, 0.333994924, 0.213998773, 0.361970546, 0.142059008, 1.969582556 ]),
	\sustain, Pseq([ 0.210998829, 0.176026983, 0.164098992, 0.141957228, 0.184994163, 0.183996918, 0.208952562 ]),
));
(
~noteTimeline.new(\hello).eventLoop.list =
XEventList.newFrom(Pseq([ Rest(0.375), Pbind(
	\midinote, Pseq([ 71.0, 62, 64, 64, 64, 62, 60 ]),
	\dur, Pseq([ 0.011960472000002, 0.205024394, 0.333994924, 0.213998773, 0.361970546, 0.142059008, 1.969582556 ]),
	\sustain, Pseq([ 0.210998829, 0.176026983, 0.164098992, 0.141957228, 0.184994163, 0.183996918, 0.208952562 ]),
) ]));
XEventList.newFrom(
	Pseq([
		Rest(1.2),
Pbind(
	\midinote, Pseq([ 60, 64, 62, 60, 62, 64, 60 ]),
	\dur, Pseq([ 0.33598567100034, 0.30794733799939, 0.22097838800073, 0.20740912499969, 0.21362033599962, 0.19199567299984, 3.8401007660004 ]),
	\sustain, Pseq([ 0.1979601590001, 0.15493561599942, 0.21001464600067, 0.20610201699947, 0.24716092600011, 0.2427285520007, 0.21499617500012 ]),
)

	])

);
)

	(
~pat=	Pseq([
		Rest(10.0),
Pbind(
	\midinote, Pseq([ 60, 64, 62, 60, 62, 64, 60 ]),
	\dur, Pseq([ 0.33598567100034, 0.30794733799939, 0.22097838800073, 0.20740912499969, 0.21362033599962, 0.19199567299984, 3.8401007660004 ]),
	\sustain, Pseq([ 0.1979601590001, 0.15493561599942, 0.21001464600067, 0.20610201699947, 0.24716092600011, 0.2427285520007, 0.21499617500012 ]),
)

	])
	)
	(
~pat=	Pseq([
		Event.silent(10.0),
Pbind(
	\midinote, Pseq([ 60, 64, 62, 60, 62, 64, 60 ]),
	\dur, Pseq([ 0.33598567100034, 0.30794733799939, 0.22097838800073, 0.20740912499969, 0.21362033599962, 0.19199567299984, 3.8401007660004 ]),
	\sustain, Pseq([ 0.1979601590001, 0.15493561599942, 0.21001464600067, 0.20610201699947, 0.24716092600011, 0.2427285520007, 0.21499617500012 ]),
)

	])
	)

	~pat.play
	~str = ~pat.asStream;
	~str.next(Event.default)

(
ParamProto.init;
~noteTimeline.new(\hello, Param( Pdef(\def), \degree, ControlSpec(0,14,\lin) ));
Pdef(\def, Pbind(
	\instrument, \default,
	//\freq, 200,
	\dur, 1,
	\amp, 0.1
));
)
~noteTimeline.new(\hello).eventLoop = ~pr.eventLoop;
~noteTimeline.new(\hello).edit;
~noteTimeline.new(\hello).clear

~pr = ~playerGroupRecorder.new(~pg);
~pr.tempoClock = TempoClock.default
~pr.clock

~pr.eventLoop.list.print
XEventLoop(\bla).clear
XEventLoop(\bla).lists = List.new

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2,7,5],inf),
	\dur, 1/4,
	\amp, 0.1,
	\dur, Pseq([0.1,0.2,\rest,0.5],inf),
)).play;
);
