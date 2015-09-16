
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


	~eventTimeline = (

		asPatternAbs: { arg self, startPosition, endPosition;
			var relStartTime, totalDur;
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
			self.asPattern(relStartTime, totalDur);
		},

		eventList: {
			self.eventloop.list
		}

		embedInTimeline: { arg self, drop_dur, sustain;
			relStartTime = self.eventList.relStartTime + drop_dur;
			self.asPattern(relStartTime, self.eventList.totalDur min: sustain);
		},

		xembedInStream: { arg self, inval;
			this.asPattern
		},

		play: { arg self;
			this.asPatternAbs(self.cursor.startPosition, self.cursor.endPosition).play;
		},

		stop: { arg self;
			self.proxy.stop;
		},

		key: { arg self;
			self.name;
		},

		label: { arg self;
			self.key;
		},


	);

	~clipTimeline_all = IdentityDictionary.new;
	~clipTimeline = (
		parent: ~eventTimeline,

		new: { arg self, name;

			if(~clipTimeline_all[name].notNil) {
				self = ~clipTimeline_all[name]
			} {
				self = self.deepCopy;
				self.init.prAdd(name);
			};
		
			self;
		},

		prAdd: { arg self, name;
			~clipTimeline_all[name] = self;
		},

		init: { arg self;
			self.areasize = 10@4;
			self.eventloop = eventloop;
			self.quant_ref = Ref(Point(1/8,1)); // TODO: replace by Quant class and change TimelineView code
			self.proxy = EventPatternProxy.new;
		},

		asPattern: { arg self, relStartTime, totalDur;
			self.proxy.source = Plazy({
				var eventlist = self.eventList;

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

			if(~clipTimeline_all[name].notNil) {
				self = ~clipTimeline_all[name]
			} {
				self = self.deepCopy;
				self.init.prAdd(name);
			};
		
			self;
		},

		prAdd: { arg self, name;
			~noteTimeline_all[name] = self;
			self.key = name;
		},

		init: { arg self, param;

			var el = XEventList.new;
			el.start;
			el.finish(1);
			self.param = param;
			self.eventloop = (list: el); // fake eventloop for the moment
			self.areasize = 9@128;
			self.proxy = EventPatternProxy.new;

			// note: this is grid quant, not playing quant
			self.quant_ref = Ref(Point(1/8,1)); // TODO: replace by Quant class and change TimelineView code
			
		},

		asPattern: { arg self, relStartTime, totalDur;
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
				));
				<>
				self.param.target
			});
			self.proxy;
		},

		edit: { arg self;
			~noteTimelineView.(this)
		},

	);

	~envTimeline = (
		parent: ~timelinePanelView,

		new: { arg self, name, param;
			self = ~timelinePanelView[\new].(self, eventloop);
		
			if(~clipTimeline_all[name].notNil) {
				self = ~clipTimeline_all[name]
			} {
				self = self.deepCopy;
				self.init.prAdd(name);
			};
		
			self;
		},

		asPattern: { arg self;
			self.proxy.source = Prout({ arg inval;
				//PtimeGatePunch(self.eventloop.list.asPattern.trace(prefix:"xxxxxxxxxxxxxxxxxxxxx"))
				var start, end;
				var eventlist = self.eventloop.list;
				var default = 0;
				var pat;
				if(self.cursor.notNil) {
					start = self.cursor.startPosition;
					if(self.cursor.endPosition.notNil) {
						// FIXME: this is wrong
						//end = self.cursor.endPosition - eventlist.endTime;
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
			});
			self.proxy;
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
