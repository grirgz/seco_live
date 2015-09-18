
// in this file, i will write the prototypes of the three base timeline classes
// - ClipTimeline(name)
// - NoteTimeline(name, param)
// - EnvTimeline(name, param)

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
				relStartTime = ( startPosition - eventlist.startTime ).clip(0,inf);
			};

			if(endPosition.isNil) {
				totalDur = self.eventloop.list.totalDur;
			} {
				totalDur = endPosition - (startPosition ? eventlist.startTime);
			};
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


	);

	~clipTimeline_all = IdentityDictionary.new;
	~clipTimeline = (
		parent: ~eventTimeline,

		new: { arg self, name;

			self.all = {~clipTimeline_all};
			if(self.all[name].notNil) {
				self = self.all[name]
			} {
				self = self.deepCopy;
				self.init.prAdd(name);
			};
		
			self;
		},

		init: { arg self;
			var el = XEventList.new;
			self.areasize = 10@4;
			self.eventloop = (list: el); // fake eventloop for the moment
			self.quant_ref = Ref(Point(1/8,1)); // TODO: replace by Quant class and change TimelineView code
			self.proxy = EventPatternProxy.new;
		},

		xasPattern: { arg self, relStartTime, totalDur;
			self.proxy.source = Plazy({
				var eventlist = self.eventList;

				relStartTime = relStartTime ? eventlist.relStartTime;
				totalDur = totalDur ? eventlist.totalDur;

				Pfindur(totalDur, ~timeline_pattern.(
					Pn(self.eventloop.list, 1),
					relStartTime
				));
			});
			self.proxy;
		},

		edit: { arg self;
			~clipTimelineView.new(self);
		},

	);


	~noteTimeline_all = IdentityDictionary.new;
	~noteTimeline = (
		parent: ~eventTimeline,

		new: { arg self, name, param;

			self.all = { ~noteTimeline_all };
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
			self.eventloop = (list: el); // fake eventloop for the moment
			self.areasize = 9@128;
			self.proxy = EventPatternProxy.new;

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
				var totalDur;
				var relStartTime;
				var eventlist = self.eventloop.list;

				relStartTime = relStartTime ? eventlist.relStartTime;
				totalDur = totalDur ? eventlist.totalDur;

				Pfindur(totalDur, ~timeline_pattern.(
					Pn(self.eventloop.list, 1),
					relStartTime
				))
				<>
				self.param.target
			});
			self.proxy;
		},

		edit: { arg self;
			~noteTimelineView.new(self)
		},

	);

	~envTimeline_all = IdentityDictionary.new;
	~envTimeline = (
		parent: ~eventTimeline,

		new: { arg self, name, param;
		
			self.all = { ~envTimeline_all };
			if(self.all[name].notNil) {
				self = self.all[name]
			} {
				self = self.deepCopy;
				self.prAdd(name).init(param);
			};
		
			self;
		},

		outBus: { arg self;
			BusDef(self.key, \control);
		},

		init: { arg self, param;

			var el = self.makeDefaultEventList;
			self.param = param;
			self.eventloop = (list: el, key: { self.key }); // fake eventloop for the moment
			self.areasize = 9@128;
			self.proxy = EventPatternProxy.new;
			self.cursor = CursorTimeline.new;

			// note: this is grid quant, not playing quant
			self.quant_ref = Ref(Point(1/8,1)); // TODO: replace by Quant class and change TimelineView code

			self.xasPattern; // init proxy

			self;
			
		},


		xasPattern: { arg self, relStartTime, totalDur;
			self.proxy.source = Prout({ arg inval;
				var totalDur;
				var relStartTime;
				var eventlist = self.eventloop.list;
				var pat;
				var str;
				var first;
				var first_level;

				relStartTime = relStartTime ? eventlist.relStartTime;
				totalDur = totalDur ? eventlist.totalDur;

				// FIXME: this should be an event
				if(self.param.notNil) {
					self.param.set(self.outBus.asMap);
					//default = self.param.default;
				};

				pat = 
					Pbind(
						\instrument, \env_segment,
						//\level, Pfunc({ arg ev; ev[self.param.property] ? default }),
						\curve, 0,
						\out, self.outBus,
						\time, Pfunc({ arg ev; ev.debug("ev!!!!!!!!!!!!!!!!!!"); ev[\dur] }),
					).trace(prefix:"MAIIIIIIIIIIIIIIIIIIIIIIII")
					<>
					Pfindur(totalDur, ~timeline_pattern.(
						Pn(self.eventloop.list, 1),
						relStartTime
					))
				;

				self.eventloop.list.changed(\cursor, \play);
				~pattern_to_envpattern.(pat).embedInStream(inval);

			});
			self.proxy;
		},

		edit: { arg self;
			~envTimelinePanelView.new(self)
		},

	);

	//////////////////////////////// Views

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

		param: { arg self;
			self.timeline_model.param;
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
			self.timeline.mapParam(Param(self.param.target, \level, self.param.spec));
			self.set_yquant(self.param.spec.step);
			self.timeline.mouseUpAction = {|me, px, py, mod, buttonNumber, clickCount, chosennode|
				self.timeline.refreshEventList;
			};
			self.layout;
		},

	);



	////////////////////////////////////// Tests

	//~pt = ~pdefTimeline.new(XEventLoop(\pdef));
	//~pt.makeWindow;
	//~pt = ~midinoteTimeline.new(XEventLoop(\midinote));
	//~pt.makeWindow;
	//~pt = ~envTimeline.new(XEventLoop(\env), Param(Ndef(\siner), \midinote, \midinote));
	//~pt.makeWindow;

	~pt = ~envTimeline.new(\lpfac, Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\lin)));
	~pt.edit;
)

~pt
~pt.edit.new
~pt.eventList.print
~pt.proxy.source
~pt.xasPattern.play
~pt.init
(proxy:4).proxy

~pt.xasPattern
~str = ~pt.xasPattern.asStream;
~str.next(Event.default)

Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\lin)).get.get(_.debug("get"))
Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\lin)).get.set(2)

Ndef(\siner2).play
Ndef(\siner2).edit

(
~compute_eventenv_sustain = { arg eventlist;
	var previous;
	var el = eventlist.copy;
	previous = eventlist.removeAt(0);
	eventlist.do { arg ev;
		if([\start, \end].includes(ev.type)) {
			// NOOP
		} {
			previous[\sustain]  
			previous = ev;

		}
	};
	
},

~pattern_to_envpattern = { arg pattern;
	Prout({ arg inval;
		var str = pattern.asStream;
		var val;
		var first = true;
		var previous_val;
		
		block { arg break;
			while({
				val = str.next(Event.default);
				val.notNil;
			}, {
				val.debug("pattern_to_envpattern");
				//if(val.type == \start or: { val.type == \end }) { // don't know where and why it's transformed in rest
				if(val.type == \rest or: { val.type == \start or: { val.type == \end } }) { 
					val.type.debug("pattern_to_envpattern: start/end");
					val.yield;
					first = true;
				} {
					if(first == true) {
						var level = val.use { val.level };
						var busev = val.copy;
						level.debug("pattern_to_envpattern: first");
						busev.putAll(
							(
								type: \bus,
								array: [level],
								delta: 0,
							)
						);
						busev.yield;
						previous_val = val;
						first = false;
					} {
						previous_val[\level] = val.use { val.level };
						previous_val.debug("pattern_to_envpattern: yield previous");
						previous_val.yield;
						previous_val = val;
					};
				};
			});
		};
		previous_val[\type] = \rest;
		previous_val.yield;
	})

};
)


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
