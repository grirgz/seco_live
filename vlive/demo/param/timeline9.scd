// in this file, I test the timeline panel, a generic class to build scrollers, rulers and track headers around a timeline
// used to build 
// - pdef timeline (clip timeline)
// - midinote timeline
// - event env timeline


Ndef(\siner2).get(\lpfac)
Ndef(\siner2).set(\lpfac, BusDef(\lpfac).asMap)
BusDef(\lpfac).set(4)
BusDef(\lpfac).set(2)
~pt.param.set(1)
~pt.param.set(1)

(
/////////////////////////////////////////////////////////////////
"/home/ggz/code/sc/seco/vlive/demo/param/lib/timeline.scd".load;
~el = nil;
/////////////////////////////////////////////////////////////////
//)
//(

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
		lpfac.poll;
		//sig = RLPF.ar(sig, freq * lpfac.clip(0.5,10), rq);
		//sig = sig.tanh(SinOsc.kr([1,2,3,4]).abs);
		sig = Pan2.ar(sig, pan, amp).flop.mean;
	});
	//Ndef(\siner).set(\freq, BusDef(\freq, \control).asMap);
	Ndef(\siner2).free;
	Ndef(\siner2).play;


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



	~pdefTimeline = (
		parent: ~timelinePanelView,

		new: { arg self, eventloop;
			self = ~timelinePanelView[\new].(self, eventloop);
		
			self.eventloop = eventloop;
			self.areasize = 9@2;
			self.quant_ref = Ref(Point(1/8,1));
			
			self.definePattern;
		
			self;
		},

		make_header: { arg self;
			self.header_layout = HLayout(
				PlayerWrapperView(Pdef(self.eventloop.key)).view,
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

		definePattern: { arg self;
			Pdef(self.eventloop.key, Plazy({
				//PtimeGatePunch(self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"))
				var start, end;
				var eventlist = self.eventloop.list;
				if(self.cursor.notNil) {
					start = self.cursor.startPosition - eventlist.startTime;
					if(self.cursor.endPosition.notNil) {
						end = self.cursor.endPosition - eventlist.endTime;
					}
				};
				~timeline_pattern.(
					~eventlist_aspattern.(
						self.eventloop.list
					).trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"),
					start, end
				);
				//self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx")
			}));
		},

	);


	~midinoteTimeline = (
		parent: ~timelinePanelView,

		new: { arg self, eventloop;
			self = ~timelinePanelView[\new].(self, eventloop);
		
			self.eventloop = eventloop;
			self.areasize = 9@128;
			
			self.definePattern;
		
			self;
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

		definePattern: { arg self;
			Pdef(self.eventloop.key, Plazy({
				//PtimeGatePunch(self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"))
				var start, end;
				var eventlist = self.eventloop.list;
				if(self.cursor.notNil) {
					start = self.cursor.startPosition - eventlist.startTime;
					if(self.cursor.endPosition.notNil) {
						end = self.cursor.endPosition - eventlist.endTime;
					}
				};
				~timeline_pattern.(
					~eventlist_aspattern.(
						self.eventloop.list
					).trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"),
					start, end
				);
				//self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx")
			}));
		},

		makeLayout: { arg self;
			self.layout = VLayout(
				HLayout(
					PlayerWrapperView(Pdef(self.eventloop.key)).view,
					XSimpleButton.new.label_("yep"),
				),
				self.parent[\makeLayout].(self),
				//self.parent.makeLayout,
			);
			self.layout;
		},

	);

	~envTimeline = (
		parent: ~timelinePanelView,

		new: { arg self, eventloop, param;
			self = ~timelinePanelView[\new].(self, eventloop);
		
			self.eventloop = eventloop;
			//self.areasize = Point(9, param.spec.range);
			self.areasize = Point(9,128);
			self.param = param;
			
			self.definePattern;
		
			self;
		},

		key: { arg self;
			self.eventloop.key;
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
				PlayerWrapperView(Pdef(self.eventloop.key)).view,
				PlayerWrapperView(PlayerWrapper(self.param.target)).view,
				self.make_quant_popup,
			)
		},

		definePattern: { arg self;
			Pdef(self.eventloop.key, Prout({ arg inval;
				//PtimeGatePunch(self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"))
				var start, end;
				var eventlist = self.eventloop.list;
				var default = 0;
				var pat;
				if(self.cursor.notNil) {
					start = self.cursor.startPosition - eventlist.startTime;
					if(self.cursor.endPosition.notNil) {
						end = self.cursor.endPosition - eventlist.endTime;
					}
				};


				//Pbind(
				//	\type, \param,
				//	\param, self.param,
				//	\method, \set,
				//	\val, Pfunc({ arg ev; ev[self.param.property]; })
				//) <>

				if(self.param.notNil) {
					self.param.set(BusDef(self.key, \control).asMap);
					default = self.param.default;
				};

				//Pbind(
				//	\type, \bus,
				//	\out, BusDef
				//	\array, Pfunc({ arg ev; 
				//		ev.use({ ev.freq })
				//	})
				//) <>
				Pbind(
					\type, \bus,
					\array, [1],
					\dur, Pseq([0],1),
					\out, BusDef(self.key, \control),
				).embedInStream(inval);

				pat = Pbind(
					\instrument, \env_segment,
					\time, Pfunc({ arg ev; ev.debug("ev!!!!!!!!!!!!!!!!!!"); ev[\dur] }),
					\level, Pfunc({ arg ev; ev[self.param.property] ? default }),
					\curve, 0,
					\out, BusDef(self.key, \control),
				).trace(prefix:"MAIIIIIIIIIIIIIIIIIIIIIIII") <>
				~timeline_pattern.(
					~eventlist_aspattern.(
						self.eventloop.list
					).trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"),
					start, end
				).trace(prefix:"YAAAAAAAAAAAAAAAAAAAAAAAAAAA");
				//self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx")
				pat.embedInStream(inval);
			}));
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
			self.timeline.mapParam(self.param);
			self.set_yquant(self.param.spec.step);
			self.timeline.mouseUpAction = {|me, px, py, mod, buttonNumber, clickCount, chosennode|
				self.timeline.refreshEventList;
			};
			self.layout;
		},

	);

	//~pt = ~pdefTimeline.new(XEventLoop(\pdef));
	//~pt.makeWindow;
	//~pt = ~midinoteTimeline.new(XEventLoop(\midinote));
	//~pt.makeWindow;
	//~pt = ~envTimeline.new(XEventLoop(\env), Param(Ndef(\siner), \midinote, \midinote));
	//~pt.makeWindow;

	~pt = ~envTimeline.new(XEventLoop(\lpfac), Param(Ndef(\siner2), \lpfac, ControlSpec(0.1,5,\exp)));
	~pt.makeWindow;
)
~pt.timeline.param
~pt.timeline.mapParam(~pt.param)
~pt.timeline.mapParam(~pt.param)
~pt.eventloop.list.print

~pt.quant_param.get
~pt.quant_param.set(1/8)
~pt.quant_param.spec.mapIndex(0)
~pt.get_xquant
~pt.set_xquant(1/4)
~pt.quant_ref
~pt.make_quant_popup

	(
	~pt = ~envTimeline.new(XEventLoop(\env), Param(Ndef(\siner), \lpfac, ControlSpec(0.1,5,\exp)));
	~pt.makeWindow;
	)
	~pt.timeline.quant
	~pt.popup_quant

	(
	~pt = ~pdefTimeline.new(XEventLoop(\pdef));
	~pt.makeWindow;
	)
	~pt.areasize

	~pt = ~midinoteTimeline.new(XEventLoop(\midinote));
	~pt.makeWindow;

XEventLoop(\mi)
Pdef(\midinote).play
Pdef(\pdef).play

Param(Ndef(\siner), \lpfac, ControlSpec(1,3)).default


(
SynthDef(\env_segment, { arg out=0, level=0.1, time=0.1, curve=1, gate=1;
	var sig;
	var in = In.kr(out);
	sig = EnvGen.kr(Env([in,level], [time], curve),gate,doneAction:2);
	Out.kr(out, sig);
}).add;


Pdef(\envtest, Pbind(
	\instrument, \env_segment,
	\level, Pseq([100,200,5000,200],1),
	\time, 1,
	\dur, 1,
	\out, BusDef(\envtest, \control),
)).play;

Ndef(\siner).map(\freq, BusDef(\envtest).asMap);
Ndef(\siner).play;



)


(
SynthDef(\env_segment, { arg out=0, level=0.1, time=0.1, curve=0, gate=1;
	var sig;
	var in = In.kr(out);
	sig = EnvGen.kr(Env([in,level], [time], curve),gate,doneAction:2);
	Out.kr(out, sig);
}).add;


Pdef(\envtest, 
	
	Pseq([
		Pbind(
			\type, \bus,
			\array, [1],
			\dur, Pseq([0],1),
			\out, BusDef(\lpfac, \control),
		),
		Pbind(
			\instrument, \env_segment,
			\level, Pseq([1,2,1,5,2,6,3],2),
			\time, 1,
			\dur, 1,
			\out, BusDef(\lpfac, \control),
		)
	],1),
).play;

//Ndef(\siner).map(\freq, BusDef(\envtest).asMap);
Ndef(\siner2).play;



)
BusDef(\lpfac).set(1)
Ndef(\siner).play;
Ndef(\siner2).play;
Ndef(\siner2).edit

XEventLoop(\lpfac).list.print
