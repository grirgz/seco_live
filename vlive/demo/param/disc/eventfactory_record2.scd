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
			NumberBox.new.mapParam(Param(Message(~event_factory.eventLoop), \currIndex, ControlSpec(0,32,\lin,1))),
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

	Pdef(\drums,
		PdrumStep(
			[
				Pdef(\kick),
				Pdef(\snare),
				Pdef(\snarehat),
				Pdef(\hat),
			],
			Pbind(
				\midinote, Pseq([0,1,2,3],inf),
				\isRest, false,
				\dur, 1/4,
			)
		)
	).play;
)


(

	Pdef(\score, Pseq([(midinote: 0, isRest: false),inf]));
	~dpat = 
		PdrumStep(
			[
				Pdef(\kick),
				Pdef(\snare),
				Pdef(\snarehat),
				Pdef(\hat),
			],
			Pdef(\score),
		).asStream;
)
	~ev = ~dpat.next(Event.default);
	Pswitch1(
		[
		Pdef(\kick),
		Pdef(\snare),
		],
		Pbind(
			
		)
	)

(

)

(
	Pdef(\drums, (
		Pdef(\drumrack)
		<>
		Ppar( [
			Pbind(
				\midinote, Pseq([0,\r,1,2, 0,\r,2,\r],inf),
				\isRest, false,
				\dur, 1/2,
			),
			Pbind(
				\midinote, Pseq([3],inf),
				\isRest, false,
				\dur, 1/4,
			),
			Pbind(
				\midinote, Pseq([0,3,2,3],inf),
				\isRest, false,
				\amp, 0.1/2,
				\lag, 0.04,
				\dur, 1/2,
			),
		])
	)).play;
)
(
	Pdef(\drums, (
		Pdef(\drumrack)
		<>
		~noteTimeline.new(\drums).asPattern.trace
	)).play;
)
		~s = ~noteTimeline.new(\drums).asPattern.asStream
		~noteTimeline.new(\drums).asPattern.play

			~s = Pdef(\kick).asStream
			~s.next((midinote:1))
			~s.next(())

(
)
~noteTimeline.new(\drums).composeParamPattern
~noteTimeline.new(\drums).clear

(
Pdef(\metro, Ppar([
	Pbind(\amp, 0.1/4, \sustain, 0.01)
]));
	///////////
	~peventSwitch = { arg list, key=\midinote;
		Prout({ arg ev;
			var streamlist = list.collect({ arg x;  x.loop.asStream});
			[streamlist, ev].debug("ev");
			while({ev.notNil}) {
				var nextev;
				var stream;
				var idx;
				var copev;
				var silence = Pbind(
					\isRest, true,
				).keep(1).asStream;
				ev.debug("evstart");
				idx = ev[key];
				if(ev.type == \rest or: { idx.isNil or: { idx == \r }}) {
					stream = silence;
				} {
					stream = streamlist[ev[key]];
				};
				if(stream.isNil) {
					stream = silence;
				};
				stream.debug("stream");
				nextev = stream.next(ev);
				copev = ev.copy;
				copev[\midinote] = nil;
				nextev.putAll(copev);
				nextev.debug("nextev");
				ev = nextev.yield;
				ev.debug("evend");
			}
		})
	};
	///////////

Pdef(\drumrack, 
		~peventSwitch.(
			[
				Pdef(\kick),
				Pdef(\snare),
				Pdef(\snarehat),
				Pdef(\hat),
			].collect({ arg pat; Pbind(\isRest, false, \sustain,1/8) <> pat })
		)

);
~noteTimeline.new(\drums, Param(Pdef(\drumrack), \midinote));
~timeline = ~noteTimeline.new(\drums);
//~noteTimeline.new(\line1).edit;
~event_factory = ~timeline.eventFactory;
~event_factory.mode = \event;
//~event_factory.playmode = \toggle;
//~event_factory.playmode = \gate;
MKtl(\lp).elAt(\pad).do ({ arg pad, idx;
	idx = idx;
	pad.elAt(\on).action = { arg me; me.value = 40.754; idx.debug("LPplay"); ~event_factory.childAt(idx).play };
	pad.elAt(\off).action = { arg me; me.value = 0.754; idx.debug("LPstop"); ~event_factory.childAt(idx).stop };
});
WindowDef(\test, { arg win;
	var ms = MenuSpec([\pattern, \trigger, \note, \event]);
	var pms = MenuSpec([\toggle, \gate]);

	win.view.keyDownAction_({ arg me, key, modifiers, unicode, keycode;
		["down", me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
		"azertyuiop".as(Array).collect({ arg letter, x;
			//var midinote = x+(5*12);
			var midinote = x;
			[letter,key == letter ].asCompileString.debug("letter");
			if(key == letter) {
				~map_key.(\down, ~event_factory.childAt(midinote))
			}
		})
	});

	win.view.keyUpAction_({ arg me, key, modifiers, unicode, keycode;
		["up", me, key.asCompileString, modifiers, unicode, keycode].debug("keyUpAction");
		"azertyuiop".as(Array).collect({ arg letter, x;
			//var midinote = x+(5*12);
			var midinote = x;
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
			NumberBox.new.mapParam(Param(Message(~event_factory.eventLoop), \currIndex, ControlSpec(0,32,\lin,1))),
			PlayerWrapper(Pdef(\metronome)).asView,
			Button.new.mapParam(Param(Message(~event_factory), \isRecording, XBoolSpec())).states_([
				["Rec", Color.black, Color.white],
				["Rec", Color.black, Color.red],
			]),
		),
		VLayout(
			~timeline.asView,
			HLayout (
				* 10.collect{ arg x;
					var but;
					//var midinote = x+(5*12);
					var midinote = x;
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


	ParamProto.init(true);
(
	// debug timeline
	ParamProto.init;
~noteTimeline.new(\drums, Param(Pdef(\drumrack), \midinote));
~timeline = ~noteTimeline.new(\drums);
~timeline.edit;
)
(
	// debug timeline
	ParamProto.init;
~noteTimeline.new(\notes4, Param(Pdef(\pat), \midinote)).edit;
)
(
/////////// good!!!
~gridy_collect = { arg view, fun;
	var pixelRect = view.gridRectToPixelRect(Rect(0,0,1,1));
	var gridRect = view.gridRectToPixelRect(Rect(0,0,1,1));

	var minsize = 80;
	var bounds = view.bounds;
	var areasize = view.areasize;
	var viewport = view.viewport;
	var xlen = view.gridRectToPixelRect(Rect(0,0,1,1)).width;
	var offset = pixelRect.left;
	var factor = 1;
	factor = 2**( xlen/minsize ).log2.asInteger;
	xlen.debug("xlen");

	[ (areasize.x * viewport.origin.x).asInteger, (areasize.x * factor * viewport.width + 1).asInteger ].debug("start, end XXXXXX");
	(areasize.x * factor * viewport.width + 1).asInteger.do { arg idx;
		var oidx, x;
		var orx;
		oidx = (idx + (areasize.x * viewport.origin.x * factor).asInteger + 1);
		x = oidx * xlen / factor + offset;
		orx = (idx) * xlen / factor + offset;
		//x = (idx + (areasize.x * viewport.origin.x * factor).asInteger + 1) * xlen / factor + offset;
		[idx, x, xlen, bounds.height, bounds, offset, factor].debug("grid drawer: x");
		fun.(factor, x, oidx, idx);
	}
};
~timeline.editor.timeline.mygrid = { arg bounds, areasize, viewport;
	~this = ~timeline.editor.timeline;
	(
		draw: {
			Pen.use {

				~gridy_collect.(~this, { arg factor, x, oidx, idx;
				
					if( oidx % 4 == 0 ) { 
						Pen.alpha = 0.9;
					} { 
						Pen.alpha = 0.5;
					};
					Pen.color = Color.black;
					Pen.line(Point(x,0), Point(x,~this.virtualBounds.height));
					Pen.stroke;
				})
			}
		}
	)
};
~timeline.editor.ruler_x.mygrid = { arg me;
	~this = me;
	~gridy_collect.(~this, { arg factor, x, oidx, idx;
		var yoffset;
		if( oidx % 4 == 0 ) { 
			yoffset = 0;
			Pen.color = Color.black;
			Pen.alpha = 1;
		} { 
			yoffset = 4;
			Pen.color = Color.black;
			Pen.alpha = 0.5;
		};
		Pen.line(Point(x,yoffset), Point(x,~this.virtualBounds.height));
		//Pen.stringAtPoint(x.asString, Point(x,10));
		Pen.stringAtPoint(" " ++ ( oidx/factor ).asString, Point(x,0), Font.new.size_(8));
		//Pen.stringAtPoint(" " ++ ( (idx+ ( areasize.x * viewport.origin.x * factor ).asInteger)/factor ).asString, Point(x,0), Font.new.size_(8));
		Pen.stroke;
	});
};
)


(

~timeline.editor.timeline.mygrid = { arg bounds, areasize, viewport;
	~this = ~timeline.editor.timeline;
	(
		draw: {
			Pen.use {

				var pixelRect = ~this.gridRectToPixelRect(Rect(0,0,1,1));
				var gridRect = ~this.gridRectToPixelRect(Rect(0,0,1,1));

				var minsize = 80;
				var xlen = ~this.gridRectToPixelRect(Rect(0,0,1,1)).width;
				var offset = pixelRect.left;
				var factor = 1;
				factor = 2**( xlen/minsize ).log2.asInteger;
				xlen.debug("xlen");

				[ (areasize.x * viewport.origin.x).asInteger, (areasize.x * factor * viewport.width + 1).asInteger ].debug("start, end XXXXXX");
				(areasize.x * factor * viewport.width + 1).asInteger.do { arg idx;
					var oidx, x;
					var orx;
					oidx = (idx + (areasize.x * viewport.origin.x * factor).asInteger + 1);
					x = oidx * xlen / factor + offset;
					orx = (idx) * xlen / factor + offset;
					//x = (idx + (areasize.x * viewport.origin.x * factor).asInteger + 1) * xlen / factor + offset;
					[idx, x, xlen, bounds.height, bounds, offset, factor].debug("grid drawer: x");
					if( oidx % 4 == 0 ) { 
						Pen.alpha = 0.9;
					} { 
						Pen.alpha = 0.5;
					};
					//Pen.lineDash = FloatArray[4,1];
					//Pen.lineDash.debug("DASH");
					Pen.color = Color.black;
					Pen.line(Point(x,0), Point(x,bounds.height));
					Pen.stroke;
					//Pen.lineDash = FloatArray[];
				}
			}
		}
	)
};
~timeline.editor.ruler_x.mygrid = { arg me;
				//~this = ~timeline.editor.timeline;
						var bounds = me.bounds;
						var areasize = me.areasize;
						var viewport = me.viewport;
						var minsize = 80;
						var offset;
						var factor = 1;
						var xlen;
						var pixelRect;
						"fuck!!!!!!!!!!!".debug;
				~this = me;
						pixelRect = ~this.gridRectToPixelRect(Rect(0,0,1,1));
						offset = pixelRect.left;

						xlen = ~this.gridRectToPixelRect(Rect(0,0,1,1)).width;
						factor = 2**( xlen/minsize ).log2.asInteger;
						xlen.debug("xlen");
						(areasize.x * factor * viewport.width + 1).asInteger.do { arg idx;
							var yoffset;
							var orx, x;
							var oidx;
							oidx = (idx + (areasize.x * viewport.origin.x * factor).asInteger + 1);
							x = oidx * xlen / factor + offset;
							orx = (idx) * xlen / factor + offset;
							if( oidx % 4 == 0 ) { 
								yoffset = 0;
								//Pen.color = Color.blue;
								Pen.color = Color.black;
								Pen.alpha = 1;
							} { 
								yoffset = 4;
								Pen.color = Color.black;
								Pen.alpha = 0.5;
							};
							[idx, x, xlen, bounds.height, bounds].debug("ruler drawer: x");
							Pen.line(Point(x,yoffset), Point(x,bounds.height));
							//Pen.stringAtPoint(x.asString, Point(x,10));
							Pen.stringAtPoint(" " ++ ( oidx/factor ).asString, Point(x,0), Font.new.size_(8));
							//Pen.stringAtPoint(" " ++ ( (idx+ ( areasize.x * viewport.origin.x * factor ).asInteger)/factor ).asString, Point(x,0), Font.new.size_(8));
							Pen.stroke;
					}
			};
)

(
~timeline.editor.timeline.view.mouseWheelAction = { arg view, x, y, modifiers, xDelta, yDelta;
				var newport;
				var oldport;
				var top;
				var maxtop;
				~this = ~timeline.editor.timeline;

				oldport = ~this.viewport;
				maxtop = 1-oldport.height;
				[oldport.top, maxtop, oldport.height].debug("top, maxtop, width");
				top = ( oldport.top + ( yDelta/~this.virtualBounds.height ) ).clip(0,maxtop);
				newport = Rect(oldport.left, top, oldport.width, oldport.height);
				[oldport, newport, oldport.height, oldport.top, oldport.bottom].debug("HACKED!oldport, newport");
				~this.viewport = newport;
				~this.refresh;
			};
)

~bla = (isRecording: 1);
~bla = (isRecording: true);
Param(Message(~bla), \isRecording, ControlSpec(0,1,\lin,1)).edit
(
WindowDef(\gui, {
	VLayout (
		Param(Message(~bla), \isRecording, XBoolSpec()).asButton.states_([
			[ "hhhh", Color.red ],
			[ "xxxhhhh" ],
		]) ,
		Param(Message(~bla), \isRecording, XBoolSpec()).asButton ,
		Param(Message(~bla), \isRecording, XBoolSpec()).asButton ,
	)
}).front;
)
~s = XBoolSpec.new
~s.map(0)
\freq.asSpec.map(0)

~bla

	Pseq([ Event.silent(8), Pdef(\bkick) ]),

(
Pdef(\dec, Ppar([
	Pbind(\lag, 0.rand) <> Pdef(\kick),
	Pbind(\lag, 1.0.rand) <> Pdef(\snare),
	Pbind(\lag, 1.0.rand) <> Pdef(\snarehat),
	Pbind(\lag, 1.0.rand) <> Pdef(\hat),
	
])).play;
)

(
Pdef(\main1, Pseq([
	Pfindur(32, Pdef(\part1)),
	Pfindur(32, Pdef(\dec)),
	Ppar([
		Pfindur(32, Pdef(\part1)),
		Pfindur(32, Pdef(\dec2)),
	]),
	Ppar([
		Pfindur(32, Pdef(\dec)),
		Pfindur(32, Pdef(\dec2)),
	]),
])).play;
)

~clipTimeline.new(\clip1).edit

(
Pdef(\dec2, Ppar([
	Pbind(\lag, 0.4.rand, \amp, Pkey(\amp)*1.0.rand) <> Pdef(\kick),
	Pbind(\lag, 0.4.rand, \amp, Pkey(\amp)*1.0.rand) <> Pdef(\snare),
	Pbind(\lag, 0.4.rand, \amp, Pkey(\amp)*1.0.rand) <> Pdef(\snarehat),
	Pbind(\lag, 0.4.rand, \amp, Pkey(\amp)*1.0.rand) <> Pdef(\hat),
	//Pseq([ Event.silent(4), Pdef(\bkick) ]),
	
])).play;
)


(
Pdef(\bkick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],

		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([40, 47, 35], [0.055, 0.49], [-4, -5]) ],

		[ Env.new([80, 40, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 34, 30], [0.055, 0.49], [-4, -5]) ],

		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 30], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([80, 37, 35], [0.055, 0.49], [-4, -5]) ],
		[ Env.new([40, 47, 35], [0.055, 0.49], [-4, -5]) ],
	],inf),
	\distmix, 0.61,

	\dist, 1.6,
	\distamp, 1/2,
	\env0, Pseq([
		[ Env.new([0, 1.2, 0.8,0], [0.015, 0.49,0.4], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 2,
	\isRest, Pseq([
		1,
	],inf).coin.not,
	\amp, 0.15
));
)


(
	ParamProto.init;
~noteTimeline.new(\notes4, Param(Pdef(\pat), \midinote));
~timeline = ~noteTimeline.new(\notes4);
WindowDef(\gui, { 
	var kb = MIDIKeyboardView.new;
	var curnote = nil;
	kb.keyDownAction = { arg note;
		~timeline.eventFactory.childAt(note).play;
		curnote = note;
	};
	kb.keyUpAction = { arg note;
		~timeline.eventFactory.childAt(note).stop;
	};
	kb.keyTrackAction = { arg note;
		note.debug("trackAction");
		if(curnote != note) {
			curnote !? {~timeline.eventFactory.childAt(curnote).stop };
			curnote = note;
			~timeline.eventFactory.childAt(note).play;
		};
	};
	VLayout(
		~timeline.asView,
		kb.asView.minHeight_(40),
	)
}).frontTop;
)

WindowDef(\yep, { WindowDef(\gui).source.value }).front

(
Pdef(\metro, Ppar([
	Pbind(\amp, 0.1/4, \sustain, 0.01)
]));
	///////////
	~peventSwitch = { arg list, key=\midinote;
		Prout({ arg ev;
			var streamlist = list.collect({ arg x;  x.loop.asStream});
			[streamlist, ev].debug("ev");
			while({ev.notNil}) {
				var nextev;
				var stream;
				var idx;
				var copev;
				var silence = Pbind(
					\isRest, true,
				).keep(1).asStream;
				ev.debug("evstart");
				idx = ev[key];
				if(ev.type == \rest or: { idx.isNil or: { idx == \r }}) {
					stream = silence;
				} {
					stream = streamlist[ev[key]];
				};
				if(stream.isNil) {
					stream = silence;
				};
				stream.debug("stream");
				nextev = stream.next(ev);
				copev = ev.copy;
				copev[\midinote] = nil;
				nextev.putAll(copev);
				nextev.debug("nextev");
				ev = nextev.yield;
				ev.debug("evend");
			}
		})
	};
	///////////

Pdef(\drumrack, 
		~peventSwitch.(
			[
				Pdef(\kick),
				Pdef(\snare),
				Pdef(\snarehat),
				Pdef(\hat),
			].collect({ arg pat; Pbind(\isRest, false, \sustain,1/8) <> pat })
		)

);
~noteTimeline.new(\drums, Param(Pdef(\drumrack), \midinote));
~timeline = ~noteTimeline.new(\drums);
//~noteTimeline.new(\line1).edit;
~event_factory = ~timeline.eventFactory;
~event_factory.mode = \event;
//~event_factory.playmode = \toggle;
//~event_factory.playmode = \gate;
MKtl(\lp).elAt(\pad).do ({ arg pad, idx;
	idx = idx;
	pad.elAt(\on).action = { arg me; me.value = 40.754; idx.debug("LPplay"); ~event_factory.childAt(idx).play };
	pad.elAt(\off).action = { arg me; me.value = 0.754; idx.debug("LPstop"); ~event_factory.childAt(idx).stop };
});
WindowDef(\test, { arg win;
	var ms = MenuSpec([\pattern, \trigger, \note, \event]);
	var pms = MenuSpec([\toggle, \gate]);

	win.view.keyDownAction_({ arg me, key, modifiers, unicode, keycode;
		["down", me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
		"azertyuiop".as(Array).collect({ arg letter, x;
			//var midinote = x+(5*12);
			var midinote = x;
			[letter,key == letter ].asCompileString.debug("letter");
			if(key == letter) {
				~map_key.(\down, ~event_factory.childAt(midinote))
			}
		})
	});

	win.view.keyUpAction_({ arg me, key, modifiers, unicode, keycode;
		["up", me, key.asCompileString, modifiers, unicode, keycode].debug("keyUpAction");
		"azertyuiop".as(Array).collect({ arg letter, x;
			//var midinote = x+(5*12);
			var midinote = x;
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
			NumberBox.new.mapParam(Param(Message(~event_factory.eventLoop), \currIndex, ControlSpec(0,32,\lin,1))),
			PlayerWrapper(Pdef(\metronome)).asView,
			Button.new.mapParam(Param(Message(~event_factory), \isRecording, XBoolSpec())).states_([
				["Rec", Color.black, Color.white],
				["Rec", Color.black, Color.red],
			]),
		),
		VLayout(
			~timeline.asView,
			HLayout (
				* 10.collect{ arg x;
					var but;
					//var midinote = x+(5*12);
					var midinote = x;
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


Class

PathName("/home/ggz/.local/share/SuperCollider/Extensions/param/Classes/Proto.sc").pathOnly




(
SynthDef(\test, { | amp = 0.5 |
        var freqs, sig;
        freqs = \series.kr(Array.series(31, 100, 100)); // Default
		freqs.poll;
        sig = freqs.collect{|freq| SinOsc.ar(freq, 0, 1/freqs.size)};
        sig = Splay.ar(sig);
        sig = sig * EnvGen.ar(Env.perc(releaseTime: 2),doneAction: 2);
        Out.ar(0, sig * amp);
}).add
)

// Compute the array in the language and send it via Pbind:
(
var array1, array2, out;
array1 = Array.geom(10, 100, 1.2);
array2 = Array.geom(22, array1.maxItem, 1.3);
array2.removeAt(0);
out = array1++array2;
Pbind(\instrument, \test,
        \amp, 0.1,
        \series, [ out ]
).play;
)



(
w = Window().front;
~views = [
	Knob.new,
	Knob.new,
];
PaneView(w.view, \horizontal, 2).panes.do({ arg p, idx;
	~views[idx]
})
)


(
w = Window().front;
~views = [
	Knob.new,
	Knob.new,
];
PaneView(w.view, \horizontal, 2).panes.do({ arg p, idx;
	Knob.new(p)
})
)

(
w = Window().front;
~views = [
	Knob.new,
	Knob.new,
];
PaneView(w.view, \horizontal, 2).panes.do({ arg p, idx;
	View.new.layout_(VLayout(~views[idx]))
})
)

(
w = Window().front;
~views = [
	Knob.new,
	Knob.new,
];
w.layout = VLayout(
	Knob.new,
	Knob.new,
	PaneView(nil, \horizontal, 2).panes.do({ arg p, idx;
		~views[idx];
		//View.new.layout_(~views[idx])
		//Knob.new(p)
	}),

	
)
)


( // example mix with (H|V)Layouts and FlowLayout 
w = Window("pane view", { |wh|
	Rect.aboutPoint(Window.availableBounds.center, wh.x/2, wh.y/2)
}.(800@600)).front;
p = PaneView(w.view, \horizontal, 3, [1,2,1]);
Slider2D(p.panes[0], p.panes[0].bounds.extent).resize_(5);
{|v|
	p.panes[1].layout_(VLayout(Knob(), HLayout(Knob(), v)));
	{|p|
		{|p| Knob(p, p.bounds.extent).resize_(5) }.(p.panes[0]);
		{|p| Slider2D(p, p.bounds.extent).resize_(5) }.(p.panes[1]);
	}.(PaneView(v, \vertical, 2));
}.(View());
{|p|
	var sp = PaneView(p, \vertical, 2);
	{ |p|
		var i = ScrollView(p, p.bounds.extent).hasBorder_(false).resize_(5);
		i.addFlowLayout;
		i.onResize_({|v| var d = v.decorator;
			d.bounds = v.bounds.extent@(0@0); d.reset; v.children.do(d.place(_))});
		{Knob(i)}!20 }.(sp.panes[0]);
	{|p| p.layout_(HLayout(*({Slider()}!4))) }.(sp.panes[1])
}.(p.panes[2]);
)

Let(View(), { arg x; x * 2 })
Let(View()) { arg x; x * 2 }
Let
VLayout( View()) {}

(
w = Window("pane view").front;
{|v|
	w.layout_(VLayout(Knob(), HLayout(Knob(), v)));
	{|p|
		{|p| Knob(p, p.bounds.extent).resize_(5) }.(p.panes[0]);
		{|p| Slider2D(p, p.bounds.extent).resize_(5) }.(p.panes[1]);
	}.(PaneView(v, \vertical, 2));
}.(View());
	
)

(
w = Window("pane view").front;
w.layout_(VLayout(Knob(), HLayout(Knob(), SplitView([ Knob(), Slider2D() ])))
)

(0..15).do { |n| n.grayCode.asBinaryDigits(4).reverse.postln };
4.grayCode.asBinaryDigits(8)

SynthDef(\tic, { |out, amp=0.1, pan, freq=(60.midicps), dec=0.1|
    var env = Line.kr(1, 0, dec, doneAction: 2).squared * amp;
    Out.ar(0, Pan2.ar(SinOsc.ar(freq) * env, pan));
}).add;

(instrument: \tic, freq: 600).play;

Pdef(\toc, Pbind(
    \amp, 1,
    \instrument, \tic,
    \freq, Pseq([200, 300], inf),
    \dur, 0.5)).play;

Pdef(\tic, Pbind(
    \instrument, \tic,
    \dur, 1/8,
    \freq, 600,
    \amp, Pseq( (0..15).collect { |n|
        Pseq(n.grayCode.asBinaryDigits(4).reverse / 8, 4)
    })
)).play;

Pdef(\tic, Pbind(
    \instrument, \tic,
    \dur, 1/8,
    \freq, 600,
	\amp, 1/8,
    \isRest, Pseq( (0..15).collect { |n|
        Pseq(n.grayCode.asBinaryDigits(4).reverse, 4)
    }).coin.not
)).play;

// much longer
Pdef(\tic, Pbind(
    \instrument, \tic,
    \dur, 1/8,
    \freq, 600,
    \amp, Pseq( (0..127).collect { |n|
        Pseq(n.grayCode.asBinaryDigits(8).reverse / 8, 4)
    })
)).play;


Pdef(\tic, Pbind(
    \instrument, \tic,
    \dur, 1/8,
    \freq, 600,
	\isRest, Pseq( (0..15).collect { |n|
        Pseq(n.grayCode.asBinaryDigits(4).reverse / 8, 4)
    }).coin.not,
    \amp, 1,
)).play;

Pseq([1,2]).coin

thisProcess.platform.name == \osx
thisProcess.platform.class == LinuxPlatform
thisProcess.platform.isKindOf(LinuxPlatform)
Platform.name.dump

Pbindef(\pb, \instrument, \default)
Pbindef(\wap)
Pbindef(\wap, \bla, 4)
Pbindef(\wap).get(\bla)
Pbindef(\wap).set(\bli, 56)
Pbindef(\wap).get(\bli)

Pbindef(\pb, \instrument, \default).play
~s = 42.asPattern.asStream
~s.nexT
