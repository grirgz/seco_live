
// in this file, i will write the prototypes of the three base timeline classes
// - ClipTimeline(name)
// - NoteTimeline(name, param)
// - EnvTimeline(name, param)

Pdef(\plop).asParamGroup.edit
\adsr.asSpec

(
/////////////////////////////////////////////////////////////////
"/home/ggz/code/sc/seco/vlive/demo/param/lib/timeline.scd".load;
~el = nil;
/////////////////////////////////////////////////////////////////
//)
//(

/////////////////////

	Ndef(\siner, { arg freq=200, pan=0, amp=0.1;
		var sig;
		sig = SinOsc.ar(freq.lag(0.01) * [1,1.001]);
		sig = sig.tanh(SinOsc.kr([1,2,3,4]).abs);
		sig = Pan2.ar(sig, pan, amp).flop.mean;
	});
	//Ndef(\siner).set(\freq, BusDef(\freq, \control).asMap);
	Ndef(\siner).free;

	Ndef(\siner2, { arg freqx=400, lpfac=1, rq= 0.5, pan=0, amp=0.1;
		var sig;
		var freq = freqx;
		sig = LFSaw.ar(freq * [1,1.001] * lpfac.clip(0.5,10));
		lpfac.poll(label:"lpfac");
		//sig = RLPF.ar(sig, freq * lpfac.clip(0.5,10), rq);
		//sig = sig.tanh(SinOsc.kr([1,2,3,4]).abs);
		sig = Pan2.ar(sig, pan, amp).flop.mean;
	});
	//Ndef(\siner).set(\freq, BusDef(\freq, \control).asMap);
	Ndef(\siner2).free;
	//Ndef(\siner2).play;


	SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
		var sig, sig1, sig2, sig3;
		sig = LFSaw.ar(freq * [1.01,1,0.99]);
		sig = RLPF.ar(sig, ffreq, rq);
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;

	Pdef(\plop, Pbind(
		\instrument, \plop,
		\isRest, false,
		\dur, 1/8,
		\degree, Pseq((0..24),inf),
	));
	Spec.add(\adsr, XEnvSpec.adsr);
	Pdef(\plop).addHalo(\instrument, \plop);

	Pdef(\plop2, Pbind(
		\instrument, \plop,
		\isRest, false,
		\ffreq, 2000,
		\dur, 1/8,
		\degree, Pseq((0..24)+10,inf),
	));

	Pdef(\plop3, Pbind(
		\instrument, \plop,
		\isRest, false,
		\ffreq, 4000,
		\dur, 1/6,
		\degree, Pseq([1,2,3,4]*2,inf),
	));


	if(~el.isNil) {

		~midinote_eventlist = XEventList.newFrom(
			Pbind(
				\instrument, \default,
				//\midinote, Pseq([54,56,57,54,57,58]+20,2),
				//\midinote, Pseq([0,0,1,0,127,127,127,127]),
				//\midinote, Pseq((10..60)+40,1),
				\midinote, Pseq((0..5)*3+60,1),
				\dur, 1/1,
				\amp, 0.3
			);
		);

		~env_eventlist = XEventList.newFrom(
			Pbind(
				\instrument, \default,
				//\midinote, Pseq([54,56,57,54,57,58]+20,2),
				//\midinote, Pseq([0,0,1,0,127,127,127,127]),
				//\midinote, Pseq((10..60)+40,1),
				\midinote, Pseq([
					Pseq((0..15)*3+40,1),
					Pseq(0-(0..15)*3+45,1),
				],1),
				\dur, 1/8,
				\amp, 0.3
			);
		);

		~env_lpfac = XEventList.newFrom(
			Pbind(
				\instrument, \default,
				//\midinote, Pseq([54,56,57,54,57,58]+20,2),
				//\midinote, Pseq([0,0,1,0,127,127,127,127]),
				//\midinote, Pseq((10..60)+40,1),
				\lpfac, Pseq([
					Pseq((0..15)/3,1),
					Pseq(0-(0..15)/3+6,1),
				],1),
				\dur, 1/8,
				\amp, 0.3
			);
		);

		~el = XEventList.newFrom( 
			
				Pseq([
					~mkevent.((
						proto: ~event_type_eventlist,
						//nodeType: \eventlist,
						nodeType: \eventenv,
						freddy_brin_dacier: "oui mon pote",
						eventlist: ~env_eventlist,
						sustain: 6.5,
						midinote: 1,
						dur: 7,
					)),
					~mkevent.((
						proto: ~event_type_eventlist,
						//nodeType: \eventlist,
						freddy_brin_dacier: "oui mon pote",
						eventlist: ~midinote_eventlist,
						sustain: 6.5,
						midinote: 0,
						dur: 7,
					)),
				],1)

		);

		XEventLoop(\pdef).list = ~el;
		XEventLoop(\midinote).list = ~midinote_eventlist;
		XEventLoop(\env).list = ~env_eventlist;
		XEventLoop(\lpfac).list = ~env_lpfac;
	};


	~eventTimeline = (

		prAdd: { arg self, name;
			self.all[name] = self;
			self.key = name;
			self;
		},

		makeDefaultEventList: { arg self;
			var el = XEventList.new;
			el.start;
			el.finish(1);
		},

		asPatternAbs: { arg self, startPosition, endPosition;
			var relStartTime, totalDur;
			var eventlist = self.eventList;
			// currentlty, startPosition and endPosition are in absolute time in the GUI, but will be relative to start event in futur
			if(startPosition.isNil) {
				relStartTime = eventlist.relStartTime;
			} {
				relStartTime = ( startPosition - eventlist.firstTime ).clip(0,inf);
				// now relStartTime is independent of start event
				relStartTime = eventlist.relStartTime max: relStartTime;
				// now relStartTime is always after start event
			};

			if(endPosition.isNil) {
				totalDur = self.eventloop.list.totalDur - (startPosition - eventlist.startTime ).clip(0,inf);
			} {
				totalDur = endPosition - (startPosition ? eventlist.startTime);
			};
			[startPosition, endPosition, relStartTime, totalDur].debug("asPatternAbs: start, end, relstart, totdur");
			self.xasPattern(relStartTime, totalDur);
		},

		eventList: { arg self;
			self.eventloop.list
		},

		embedInTimeline: { arg self, drop_dur, sustain;
			var relStartTime;
			relStartTime = self.eventList.relStartTime + drop_dur;
			self.xasPattern(relStartTime, self.eventList.totalDur min: sustain);
		},

		xembedInStream: { arg self, inval;
			self.xasPattern
		},

		eventPlay: { arg self;
			[ self.cursor.startPosition, self.cursor.endPosition ].debug("eventPlay: start, end");
			self.asPatternAbs(self.cursor.startPosition, self.cursor.endPosition).play;
		},

		eventStop: { arg self;
			self.proxy.stop;
		},

		eventIsPlaying: { arg self;
			self.proxy.isPlaying;
		},

		label: { arg self;
			self.key;
		},


		repeatCount: inf,

	);

	~clipTimeline_all = IdentityDictionary.new;
	~clipTimeline = (
		parent: ~eventTimeline,
		all: { ~clipTimeline_all },
		eventType: \clipTimeline,

		new: { arg self, name;

			if(self.all[name].notNil) {
				self = self.all[name]
			} {
				self = self.deepCopy;
				self.prAdd(name).init;
			};
		
			self;
		},

		init: { arg self;
			var el = self.makeDefaultEventList;
			self.areasize = 10@4;
			self.eventloop = (list: el, key: { self.key }); // fake eventloop for the moment
			self.quant_ref = Ref(Point(1/8,1)); // TODO: replace by Quant class and change TimelineView code
			self.proxy = EventPatternProxy.new;
			self.cursor = CursorTimeline.new;
			self.cursor.startPosition = self.eventList.startTime;
			"=============clipTimeline: end init".debug;

			self;
		},

		xasPattern: { arg self, relStartTime, totalDur;
			self.proxy.source = Plazy({
				var eventlist = self.eventList;

				relStartTime = relStartTime ? eventlist.relStartTime;
				totalDur = totalDur ? eventlist.totalDur;

				[relStartTime, totalDur].debug("clip xasPattern: plazy: relstart, totdur");

				self.eventloop.list.changed(\cursor, \play);
				Pfindur(totalDur, ~timeline_pattern.(
					Pn(self.eventloop.list, 1),
					relStartTime
				));
			}).repeat(self.repeatCount);
			self.proxy;
		},

		edit: { arg self;
			~clipTimelinePanelView.new(self);
		},

	);


	~noteTimeline_all = IdentityDictionary.new;
	~noteTimeline = (
		parent: ~eventTimeline,
		all: { ~noteTimeline_all },

		eventType: \noteTimeline,

		new: { arg self, name, param;

			if(self.all[name].notNil) {
				self = self.all[name]
			} {
				self = self.deepCopy;
				self.prAdd(name).init(param);
			};
		
			self;
		},

		init: { arg self, param;

			var el = self.makeDefaultEventList;
			self.param = param;
			self.eventloop = (list: el, key: { self.key }); // fake eventloop for the moment
			self.areasize = 9@128;
			self.proxy = EventPatternProxy.new;
			self.cursor = CursorTimeline.new;
			self.cursor.startPosition = self.eventList.startTime;

			// note: this is grid quant, not playing quant
			self.quant_ref = Ref(Point(1/8,1)); // TODO: replace by Quant class and change TimelineView code
			
		},

		xasPattern: { arg self, relStartTime, totalDur;
			// there is 3 kinds of call to asPattern:
			// - the gui: currently relative startPosition to absTime_0 : asPatternAbs
			// - the live code: no startPosition given, defaulting to start event : asPattern
			// - when embedded in bigger timeline: startPosition is relative to start event : embedInTimeline

			// timeline_pattern take a start time relative to firstEvent
			// XEventList.relStartTime is relative to firstEvent
			self.proxy.source = Plazy({
				var eventlist = self.eventloop.list;

				relStartTime = relStartTime ? eventlist.relStartTime;
				totalDur = totalDur ? eventlist.totalDur;

				self.eventloop.list.changed(\cursor, \play);
				Pfindur(totalDur, ~timeline_pattern.(
					Pn(self.eventloop.list, 1),
					relStartTime
				))
				<>
				self.param.target
			}).repeat(self.repeatCount);
			self.proxy;
		},

		edit: { arg self;
			~noteTimelinePanelView.new(self)
		},

	);

	~envTimeline_all = IdentityDictionary.new;
	~envTimeline = (
		parent: ~eventTimeline,
		all: { ~envTimeline_all },
		eventType: \envTimeline,

		new: { arg self, name, param;
		
			if(self.all[name].notNil) {
				self = self.all[name]
			} {
				self = self.deepCopy;
				self.prAdd(name).init(param);
			};
		
			self;
		},

		levelParam: { arg self;
			Param(self.param.target, \level, self.param.spec);
		},

		outBus: { arg self;
			BusDef(self.key, \control);
		},

		// when clicking play in GUI, it call to asPatternAbs
		//listenToCursor: { arg self;
		//	self.cursor_controller = SimpleController(self.cursor).put(\refresh, {
		//		self.asPatternAbs;
		//	})
		//},

		init: { arg self, param;

			var el = self.makeDefaultEventList;
			self.param = param;
			self.eventloop = (list: el, key: { self.key }); // fake eventloop for the moment
			self.areasize = 9@128;
			self.proxy = EventPatternProxy.new;
			self.cursor = CursorTimeline.new;
			self.cursor.startPosition = self.eventList.startTime;

			// note: this is grid quant, not playing quant
			self.quant_ref = Ref(Point(1/8,1)); // TODO: replace by Quant class and change TimelineView code

			self.xasPattern; // init proxy

			self;
			
		},


		xasPattern: { arg self, relStartTime, totalDur;
			[relStartTime, totalDur].debug("xasPattern: relstart, totdur");
			self.proxy.source = Prout({ arg inval;
				var eventlist = self.eventloop.list;
				var pat;
				var str;
				var first;
				var first_level;

				relStartTime = relStartTime ? eventlist.relStartTime;
				totalDur = totalDur ? eventlist.totalDur;

				[relStartTime, totalDur].debug("xasPattern: prout: relstart, totdur");

				// FIXME: this should be an event
				if(self.param.notNil) {
					self.param.set(self.outBus.asMap);
					//default = self.param.default;
				};

				~compute_eventenv_sustain.(self.eventloop.list);

				pat = 
					Pbind(
						\instrument, \env_segment,
						//\level, Pfunc({ arg ev; ev[self.param.property] ? default }),
						\curve, 0,
						\out, self.outBus,
						\time, Pfunc({ arg ev; ev.debug("ev!!!!!!!!!!!!!!!!!!"); ev.use { ev.sustain } }),
					).trace(prefix:"MAIIIIIIIIIIIIIIIIIIIIIIII")
					<>
					Pfindur(totalDur, ~timeline_pattern.(
						Pn(self.eventloop.list, 1),
						relStartTime
					))
				;

				self.eventloop.list.changed(\cursor, \play);
				~pattern_to_envpattern.(pat).embedInStream(inval);

			}).repeat(self.repeatCount);
			self.proxy;
		},

		edit: { arg self;
			~envTimelinePanelView.new(self)
		},

	);

	//////////////////////////////// Views

	~clipTimelinePanelView = (
		parent: ~timelinePanelView,

		new: { arg self, timeline;
			self = ~timelinePanelView[\new].(self, timeline.eventloop);
		
			self.timeline_model = timeline;
			self.areasize = self.timeline_model.areasize;
			
			self.makeWindow;
		
			self;
		},

		cursor: { arg self;
			self.timeline_model.cursor;
		},

		key: { arg self;
			self.timeline_model.key;
		},

		param: { arg self;
			self.timeline_model.param;
		},


		make_header: { arg self;
			self.header_layout = HLayout(
				PlayerWrapperView(EventPlayerWrapper(self.timeline_model)).view,
				self.make_stop_button,
				XSimpleButton.new.label_("Add track").action_({
					self.add_track;
				}),
				self.make_quant_popup,
			);
			
			self.header_layout;
		},

		timelineClass: { arg self;
			PdefTimelineView
		},

		makeLayout: { arg self;
			self.clipEditor = ~clipEditor.new(nil, self.timeline_model.eventList);
			self.clipEditorLayout = self.clipEditor.makeLayout;
			self.clipEditor.clearEditor;
			self.layout = VLayout(
				//HLayout(
				//	PlayerWrapperView(Pdef(self.eventloop.key)).view,
				//	XSimpleButton.new.label_("yep"),
				//),
				[self.parent[\makeLayout].(self), stretch:1],
				self.clipEditorLayout,
				//self.parent.makeLayout,
			);
			self.timeline.mouseDownAction = { arg me, px, py, mod, buttonNumber, clickCount, chosennode;
				if(chosennode.notNil) {
					self.clipEditor.model = chosennode.model;
					self.clipEditor.makeUpdater;
					chosennode.model.changed(\refresh);
				} {
					self.clipEditor.model = nil;
					self.clipEditor.clearEditor;
				}
			};
			self.layout;
		},
	);

	~envTimelinePanelView = (
		parent: ~timelinePanelView,

		new: { arg self, timeline;
			self = ~timelinePanelView[\new].(self, timeline.eventloop);
		
			// self.timeline is timelineView actually
			self.timeline_model = timeline;

			self.makeWindow;
			
			self;
		},

		cursor: { arg self;
			self.timeline_model.cursor;
		},

		key: { arg self;
			self.timeline_model.key;
		},

		param: { arg self;
			self.timeline_model.param;
		},

		levelParam: { arg self;
			self.timeline_model.levelParam;
		},

		timelineClass: { arg self;
			TimelineEnvView;
		},

		make_track_header: { arg self, timeline;
			//self.track_header = View.new;
			//self.ruler_y = MidinoteTimelineRulerView.new;
			//self.track_header = self.ruler_y;
			//self.ruler_y.mimicTimeline(timeline);
			//self.ruler_y.view.minWidth_(50);
			nil
		},

		make_header: { arg self;
			HLayout(
				PlayerWrapperView(EventPlayerWrapper(self.timeline_model)).view,
				PlayerWrapperView(PlayerWrapper(self.param.target)).view,
				self.make_quant_popup,
			)
		},

		makeLayout: { arg self;
			self.layout = VLayout(
				//HLayout(
				//	PlayerWrapperView(Pdef(self.eventloop.key)).view,
				//	XSimpleButton.new.label_("yep"),
				//),
				self.parent[\makeLayout].(self),
				//self.parent.makeLayout,
			);
			self.timeline.eventFactory = { arg pos, nodesize;
				(absTime: pos.x, level: pos.y, legato:1);
			};
			self.timeline.mapParam(self.levelParam);
			self.set_yquant(self.param.spec.step);
			self.timeline.mouseUpAction = {|me, px, py, mod, buttonNumber, clickCount, chosennode|
				self.timeline.refreshEventList;
			};
			self.layout;
		},
	);


	~noteTimelinePanelView = (
		parent: ~timelinePanelView,

		new: { arg self, timeline;
			self = ~timelinePanelView[\new].(self, timeline.eventloop);
		
			self.timeline_model = timeline;
			self.areasize = self.timeline_model.areasize;
			self.makeWindow;
		
			self;
		},

		cursor: { arg self;
			self.timeline_model.cursor;
		},

		key: { arg self;
			self.timeline_model.key;
		},

		param: { arg self;
			self.timeline_model.param;
		},


		make_header: { arg self;
			self.header_layout = HLayout(
				PlayerWrapperView(EventPlayerWrapper(self.timeline_model)).view,
				self.make_stop_button,
				Param(Message(self.timeline_model), \repeatCount, ControlSpec(1,inf,\lin)).asNumberBox,
				self.make_quant_popup,
			);
			
			self.header_layout;
		},


		timelineClass: { arg self;
			MidinoteTimelineView;
		},

		make_track_header: { arg self, timeline;
			//self.track_header = View.new;
			self.ruler_y = MidinoteTimelineRulerView.new;
			self.track_header = self.ruler_y;
			self.ruler_y.mimicTimeline(timeline);
			self.ruler_y.view.minWidth_(50);
		},

		makeLayout: { arg self;
			self.layout = VLayout(
				//HLayout(
				//	PlayerWrapperView(EventPlayerWrapper(self.timeline_model)).view,
				//	XSimpleButton.new.label_("yep"),
				//),
				self.parent[\makeLayout].(self),
				//self.parent.makeLayout,
			);
			self.layout;
		},

	);

	////////////////////////////////////// Tests

	~nt = ~noteTimeline.new(\note, Param(Pdef(\plop), \midinote));

	~pt = ~clipTimeline.new(\clip);
	~pt.edit;

	~ct2 = ~clipTimeline.new(\miniclip);

	~et = ~envTimeline.new(\lpfac, Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\lin)));
)
	~ct2.edit;

	~nt.edit;
	~et.edit;

~noteTimeline.all
	~pt = ~noteTimeline.new(\note, Param(Pdef(\plop2), \midinote));
	~pt.edit;
	~pt.param = Param(Pdef(\plop2), \midinote)

	TimelineEnvView.o
	~tp = TimelinePreview_Env.new
	~tp.mapEventList(~et.eventList)
	~tp.mapParam(~et.param)
	~et.param
	WindowLayout({ ~tp.view })

~pt.eventList.totalDur
~pt.eventPlay
~pt.edit.new
~pt.eventList.print
~pt.proxy.source
~pt.xasPattern.play
~pt.init
~pt.cursor.startPosition = 1
~pt.cursor.startPosition
~pt.cursor.changed(\refresh)
~pt.cursor.changed(\startPosition)
~view = ~pt.edit
~view.cursor.startPosition
(proxy:4).proxy

~pt.xasPattern
~str = ~pt.xasPattern.asStream;
~str.next(Event.default)

Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\lin)).get.asBus.get(_.debug("get"))
Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\lin)).get.asBus.set(2)

Pdef(\plop).play
~pt.eventList[1].pattern
~pt.eventList[1][\pattern].asCompileString
(pattern:3).pattern

Ndef(\siner2).play
Ndef(\siner2).edit
Ndef(\siner2).clear

(
)

3.6

(


~pat = ~pattern_to_envpattern.(
	Pbind(
		\instrument, \env_segment,
		\level, Pseq([1,5,2,3],2),
		\dur, 1,
		\legato, 1,
		\time, Pkey(\sustain),
		\out, BusDef(\test, \control),
		\amp, 0.1
	);
);

//~pat.play;
Pseq([~pat, ~pat]).play;


)


Ndef(\siner2).set(\lpfac, BusDef(\test).asMap).play
