(
~class_event_recorder = ProtoClass((
	new: { arg self, eventList, clock;
		self = self.deepCopy;
	
		self.clock = clock ? TempoClock.default;
		self.eventList = eventList ?? { XEventList.new };
	
		self;
	},

	
	startRecording: { arg self;
		self.recordStartBeat = self.clock.beats;
	},

));

~class_event_factory = ProtoClass((
	new: { arg self, pat;
		self = self.deepCopy;

		self.pattern = pat;
		self.children = SparseArray.new;
		self.in_event = Event.default;

		self;
	},

	newChild: { arg self, parent, inevent;
		self = self.deepCopy;

		self.parent_factory = parent ? ();
		//self.children = List.new;
		self.pattern = { arg self; self.parent_factory.pattern };
		self.mode = { arg self; self.parent_factory.mode };
		self.playmode = { arg self; self.parent_factory.playmode };
		self[\stream] = { arg self; self.parent_factory.stream };
		self[\stream_] = { arg self, val; self.parent_factory.stream = val;  };
		self.in_event = Event.default.copy.putAll(inevent ? ());

		self;
	},

	toggle: { arg self, but;
		[self.player.notNil, self.player.isPlaying ].debug("toggle: player, playing");
		if(self.player.notNil and: { self.player.isPlaying == true }) {
			"toggle.stop".debug;
			self.stop;
			if(but.notNil) {
				but.value = 0;
			};
		} {
			self.play;
			if(but.notNil) {
				but.value = 1;
			};
		}
	},

	child_is_playing: { arg self, index;
		var child = self.children[index];
		child.notNil and: { child.player.notNil and: { child.player.isPlaying == true } }
	},

	child: { arg self, event;
		self.newChild(self, event);
	},

	childfun: { arg self, midinote;
		self.newChild(self, (midinote:midinote));
	},

	childAt: { arg self, index;
		if(self.children[index].isNil) {
			self.children[index] = self.childfun(index);
		};
		self.children[index];
	},

	midinote: { arg self, midinote;
		self.newChild(self, (midinote:midinote));
	},

	get_playing_children_indexes: { arg self;
		var list = List.new;
		self.children.do({ arg child, idx; 
			if(self.child_is_playing(idx)) {
				list.add(idx);
			}
		});
		list
	},

	startRecording: { arg self;
		if(self.eventLoop.notNil) {
			self.eventLoop.startRec;
		}
	},

	stopRecording: { arg self;
		if(self.eventLoop.notNil) {
			self.eventLoop.stopRec;
		}
	},

	recordEvent: { arg self, ev;
		if(self.eventLoop.notNil) {
			self.eventLoop.recordEvent(ev);
		}
	},

	play: { arg self, inEvent;
		var mode;
		var playmode;
		if([nil, \proxy].includes(self.mode)) {
			mode = \pattern;
		} {
			mode = self.mode;
		};
		switch(mode,
			\pattern, {
				if(self.player.notNil) {
					self.player.stop;
				};
				self.player = ( self.pattern <> ( inEvent ? self.in_event ) ).play;
			},
			\trigger, {
				self.player = ( self.pattern <> ( inEvent ? self.in_event ) ).play;
			},
			\arp, {
				var arp;
				if(self.player.notNil) {
					self.player.stop;
				};
				arp = Prout({ arg in;
					block { arg break;
						loop {
							in = in.copy.putAll(midinotes: self.get_playing_children_indexes).yield;
							if(in.isNil) {
								break.value;
							}
						}
					}
				});
				self.player = ( self.pattern <> arp <> ( inEvent ? self.in_event ) ).play;
			},
			\event, {
				var ev;
				if(self.stream.isNil) {
					self.stream = self.pattern.loop.asStream;
				};
				ev = self.stream.next(inEvent ? self.in_event);
				if(ev.isNil) {
					self.stream = nil;
				} {
					if(self.player.notNil) {
						self.player.release;
					};
					ev = ev.copy;
					ev[\sustain] = inf;
					ev[\latency] = \;
					self.player = ev.play;
					ev;
				};
			},
			\note, {
				var ev;
				if(self.stream.isNil) {
					self.stream = self.pattern.loop.asStream;
				};
				ev = self.stream.next(Event.default);
				if(ev.isNil) {
					self.stream = nil;
				} {
					if(self.player.notNil) {
						self.player.release;
					};
					ev = ev.copy;
					ev[\sustain] = inf;
					ev[\latency] = \;
					ev.putAll(inEvent ? self.in_event);
					ev.debug("EV play");
					self.recordEvent(ev);
					self.player = ev.play;
					ev;
				};
			},
		
		)
		
	},

	stop: { arg self;
		var mode;
		"self.stop".debug;
		if([nil, \proxy].includes(self.mode)) {
			mode = \pattern;
		} {
			mode = self.mode;
		};
		switch(mode,
			\pattern, {
				if(self.player.notNil) {
					"self.stop: pattern".debug;
					self.player.stop;
					self.player = nil;
				};
			},
			\note, {
				if(self.player.notNil) {
					if(self.player.hasGate) {
						self.player.release;
					};
					self.player = nil;
				};
			},
			\event, {
				if(self.player.notNil) {
					if(self.player.hasGate) {
						self.player.release;
					};
					self.player = nil;
				};
			}
		);
		
	},

));

~map_button = { arg but, ef;
	but.mouseDownAction = {
		if(ef.playmode == \toggle or: { ef.playmode == nil }) {
		} {
			but.value = 1;
			ef.play;
		}
	};
	but.action = {
		if(ef.playmode == \toggle or: { ef.playmode == nil }) {
			ef.toggle(but);
		} {
			but.value = 0;
			ef.stop;
		}
	};
};
~map_key = { arg action, ef;
	switch(action,
		\down,{
			if(ef.playmode == \toggle or: { ef.playmode == nil }) {
				"down map_key: do nothing".debug;
			} {
				"down map_key: play".debug;
				ef.play;
			}
		},

		\up,{
			if(ef.playmode == \toggle or: { ef.playmode == nil }) {
				"up map_key: toggle".debug;
				ef.toggle;
			} {
				"up map_key: stop".debug;
				ef.stop;
			}
		},
	);
};
)

^(true)
3
(isPlaying:true).isPlaying
(isPlaying:false).isPlaying

~ev = (freq:1500, sustain:inf)
~ep = ~ev.play
~ev
~ep
~ep = (instrument: \zkick, freq:1500, sustain:inf).play
~ep.release
~ep.isPlaying
~ep.class
~ep[\isPlaying]
Event
~ep[\isPlaying]
~ep.stop
~ep.release
~ev = Pbind(\instrument, \zkick).asStream.next(Event.default)
~ev = Pmono(\default).asStream.next(Event.default)
~ev.play
~ev.set
~ev[\hasGate].asCompileString
~ev[\hasGate]
SynthDesc(\zkick).hasGate

(
	///// mono 
	~str = Pmono(\default, \degree, Pseq([0,2,4],inf)).asStream;
	~ev = ~str.next(Event.default);
	~ev.play;
	~ev
	~ev.release;
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
Param(Message(~event_factory), \mode, MenuSpec([\pattern, \trigger, \note, \event])).spec
(
~event_factory = ~class_event_factory.new(~pat);
~event_factory.mode = \pattern;
~event_factory.playmode = \toggle;
~event_factory.playmode = \gate;
WindowDef(\test, { arg win;
	var ms = MenuSpec([\pattern, \trigger, \note, \event]);
	var pms = MenuSpec([\toggle, \gate]);
	//~m = MenuSpec([\pattern, \trigger, \note, \event].collect({ x -> x }));
	//~m = MenuSpec([\pattern, \trigger, \note, \event]);
	//~m.map(0)
	//~m.labelList
	//~m.valueList
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
		VLayout(
			* 10.collect{ arg x;
				var but;
				var midinote = x+(5*12);
				but = Button.new;
				but.states = [
					[midinote.asString],
					[midinote.asString, Color.black, Color.yellow]
				];
				~map_button.(but, ~event_factory.childAt(midinote));
			};
		)
	)
}).front
)

~event_factory.mode = \pattern;
(
~event_factory = ~class_event_factory.new(Pbind( \degree, Pseq([0,2,3,5],inf) ));
~event_factory.mode = \note;
~event_factory.playmode = \gate;
WindowDef(\test, {
	var but;
	but = Button.new;
	but.states = [
		["X"]
	];
	~map_button.(but, ~event_factory);
}).front
)



/////////////////////////////


(
~pp = ProtoClass((
	collect: { arg self, fun;
		(1..8).collect(fun);
	},
));
// apparently, collect is not possible currently with ProtoClass
~pp.collect({ arg x, y; [x,y].debug("heihih") })
)
