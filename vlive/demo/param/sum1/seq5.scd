
///////////// in this file, i try to explore more code focused ideas for having a drum sequencer
// so i don't need to implement all features in a big sequencer but be more modular and live add features

// recall of needed features
// - multi instr
// - track instr choose from preset lib
// - stepseq/drumTimeline
// - save/load (stored in current project if possible)
// - add code modulator/code patterns
// - add envTimeline and align it with stepseq
// - have timeline of pages
// - interface with launchpad/veco



// workflow:
// - create a sequencer, add some instr from preset lib
StepSeq(~name+++\main).edit
// - compose a rytm with the stepseq gui
// - add some Ndef.kr/Pseq on some keys of some drums lines
StepSeq(~name+++\main)[0].page[0].pat = Pdef(~name+++\seq_0_0, Pbind(
	\fratio, Ndef(~name+++\lfo1, { SinOsc.kr(2).range(0,1) }),
))
StepSeq(~name+++\main)[0].page[0].register(Ndef(~name+++\lfo1));
// - add another page with an ending rytm
// - add a clipTimeline with multitrack-envTimeline
// - then combine the two pages in a timeline with AAAB pattern
// - add new page with new instr (instr are shared between pages but are disabled when not used)
// - add a new sequencer with instr and pages and combine first sequencer with second 



// other workflow:
// - there is a PresetRack which is a list a PresetEvent
// - there is a PresetRackList which



/////////////////////////////////////////////////////

Event
ParamProto.init
DrumRack(\yep).edit
DrumRack(\yep).drumrack.
DrumRack(\yep).get_pad(0).as_pattern
DrumRack(\yep).get_pad(0).keys
DrumRack(\yep).get_pad(0).play_preset

(
	Pdef(\perc, 
		DrumRack(\yep).get_pad(0).proxy 
		<> Pbind(
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\dur, 1/4,
		)

	).play;
)

(
	EnvInit(\stepEvent, StepEvent.new);
	Pdef(\perc, 
		DrumRack(\yep).get_pad(0).proxy 
		<> 
		~stepEvent.asPattern.loop

	).play;
)
~coins~presetEvent.edit
~secv = ~stepEventCoinView.new(~stepEvent)
~secv.hasCursor_(true).edit
~stepEvent.asPattern.play
~stepEvent[\isRest].addCursor

(
~el = XEventList.new;
~el.start;

~ev = ().putAll(~event_type_pattern);
~ev.pattern = {~stepEvent.asPattern.loop};
~ev.absTime = 1/2;
~ev.sustain = 1;

~el.addEvent(~ev);
~el.finish(2)
)

~timeline_pattern.(~el).play

(
	EnvInit(\stepEvent, StepEvent.new);
	Pdef(\perc, 
		DrumRack(\yep).get_pad(0).proxy 
		<> 
		~timeline_pattern.(~el).loop

	).play;
)

~el.play

~ct = ~clipTimeline.new(\hey)
~ct.edit
Ndef.all.envir

(
~stepTimeline = (
	new: { arg self, drumrack;
		self = self.deepCopy;
	
		self.drumrack = drumrack;
		self.timeline = ~clipTimeline.new;
		
	
		self;
	},
	
);
)


WindowLayout({ PlayerWrapperView(EventPlayerWrapper(~clipTimeline.new(\hey))).view })
WindowLayout({ PlayerWrapperView(~clipTimeline.new(\hey)).view })



(

ParamProto.init;
// stepTimeline is now in Proto/steptimeline.scd
~stepTimeline = (
	parent: ~eventTimeline,
	all: { PresetDictionary(\stepTimeline) },
	eventType: \stepTimeline,

	new: { arg self, name;

		//if(self.all[name].notNil) {
		if(false) {
			self = self.all[name]
		} {
			self = self.deepCopy;
			self.prAdd(name).init;
		};
	
		self;
	},

	init: { arg self;
		var el = self.makeDefaultEventList;
		//self.mod_eventlists = List.new;
		self.areasize = 10@1;
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
				Pn(eventlist, 1) <> (drumrack: self.drumrack),
				//Pn(eventlist, 1),
				relStartTime
			));
		}).repeat(self.repeatCount);
		self.proxy;
	},

	edit: { arg self;
		~stepTimelinePanelView.new(self);
	},

	initStepEvent: { arg self, ev;
		ev.putAll(~event_type_pattern);
		ev[\stepseq_page] = ~stepseq_page.new;
		ev[\label] = { arg me; me.stepseq_page.label };
		ev[\edit] = { arg me, drumrack; me.stepseq_page.edit(drumrack) };
		ev[\pattern] = { arg me; 
			Ppar(
				me.stepseq_page.asPatternList.collect({ arg pat,i;
					~pdemul.(
						PchainT(
							pat, 
							Plazy({
								me[\drumrack].debug("event drumrack ?");
								if(me[\drumrack].notNil) {
									[i,me[\drumrack].get_pad(i)].debug("drum i");
									me[\drumrack].get_pad(i).proxy.keep(1);
									//Pbind(
									//	\instrument, \default,
									//	\freq, 400,
									//).keep(1);
								} {
									Ptuple([Pbind().keep(1)])
								}
							}).loop
						)
					)
				})
			)
			//Pbind(
			//	\instrument, \default,
			//	\freq, 200,
			//	\dur, 1/8,
			//	\amp, 0.1
			//);
		};
		
	},

);


~stepTimelinePanelView = (
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
			PlayerWrapperView(self.timeline_model).view,
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

	drumrack: { arg self;
		self.timeline_model.drumrack;
	},

	makeLayout: { arg self;
		var edit_button;
		var drumrack_button;

		drumrack_button = XSimpleButton.new.label_("Edit DrumRack").action_({
			if(self.drumrack.notNil) {
				self.drumrack.edit;
			}
		});
		edit_button = XSimpleButton.new.label_("edit").action_({
			var ev = self.selected_event;
			if(ev.notNil) {
				if(ev[\stepseq_page].notNil) {
					ev.edit(self.drumrack);
				} {
					self.timeline_model.initStepEvent(ev);
					ev.edit(self.drumrack);
					self.timeline_model.eventList.changed(\refresh);
				}
			}
		});
		self.layout = VLayout(
			//HLayout(
			//	PlayerWrapperView(Pdef(self.eventloop.key)).view,
			//	XSimpleButton.new.label_("yep"),
			//),
			[self.parent[\makeLayout].(self), stretch:1],
			HLayout (
				drumrack_button,
				edit_button,
			),
			
			//self.clipEditorLayout,
			//self.parent.makeLayout,
		);
		self.timeline.mouseDownAction = { arg me, px, py, mod, buttonNumber, clickCount, chosennode;
			self.last_pixelpos = Point(px,py);
			if(chosennode.notNil) {
				self.selected_event = chosennode.model;
				edit_button.background_(ParamView.color_ligth)
			} {
				self.selected_event = nil;
				edit_button.background_(Color.white)
			}
		};
		self.timeline.keyDownAction = ({ arg me, key, modifiers, unicode, keycode;
			[me, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
			if(modifiers.isCtrl) {
				if(keycode == 54) {
					if(self.timeline.chosennode.notNil) {
						~stepTimeline_clipboard = self.timeline.chosennode.model;
					}
				};
				if(keycode == 55) {
					if(~stepTimeline_clipboard.notNil) {
						var gpos = self.timeline.pixelPointToGridPoint(self.last_pixelpos);
						var new;
						new = ~stepTimeline_clipboard.copy;
						new.stepseq_page = new.stepseq_page.clone;
						new[\absTime] = gpos.x;
						self.timeline.model.addEvent(new);
						//self.timeline.model.changed(\refresh);
						self.timeline.model.reorder;
					}
				}
			}
		});
		self.layout;
	},
);

~stepseq_page = (
	new: { arg self;
		self = self.deepCopy;
	
		
		self.lines = List.newFrom(
			16.collect({
				var se = StepEvent.new;
				se[\isRest] = StepList[0];
				se[\isRest].addSpec(\list, \unipolar.asSpec);
				//se[\isRest].bypass = 1;
				se;
			})
		);
		self.label = "No name";
	
		self;
	},

	clone: { arg self;
		var new = ~stepseq_page.new;
		new.lines = self.lines.deepCopy;
		new.lines.do { arg line;
			line[\isRest].addSpec(\list, \unipolar.asSpec);
		};
		new;
	},

	makeLayout: { arg self;
		var drumrack = self.drumrack;
		var drkey = drumrack !? { drumrack.key } ? "";
		VLayout (
			HLayout (
				TextField.new.string_(self.label).action_({ arg view;
					self.label = view.string;
				}),
				XSimpleButton.new.label_("Edit DrumRack " ++ drkey).action_({
					if(self.drumrack.notNil) {
						self.drumrack.edit;
					}
				}),
			),
			ScrollView.new.canvas_(View.new.layout_(
				VLayout (
					* self.lines.collect({ arg stepevent, i;
						HLayout (
							StaticText.new.string_(i).minWidth_(20),
							~stepEventCoinView.new(stepevent).asView
						)
					})
				)
			
			))
		)
	},

	makeWindow: { arg self;
		var window = Window.new;
		var layout;
		layout = self.makeLayout;
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
		
	},

	asPatternList: { arg self;
		self.lines.collect({ arg line;
			line.asPattern.loop
		})
	},

	edit: { arg self, drumrack;
		self.drumrack = drumrack;
		self.makeWindow;
	},
);

	~pdemul = { arg pat;

		Prout({ arg proutinval;
			var str;
			str = pat.asStream;

			"what".debug;
			pat.debug;
			inf.do{ 
				var inval = str.next(proutinval);
				inval.debug("inval");
				inval.drop(-1).do { arg in;
					var in1 = in.copy;
					"hhh".debug;
					in1[\delta] = 0;
					in1.yield;
				};
				inval.last.debug("what").yield(Event.default);
			}
		}).trace
	};

~st = ~stepTimeline.new(\bop);
~st.drumrack = DrumRack(\yep);
~st.edit;

)

~st.xasPattern.play

~sp = ~stepseq_page.new;
~sp.edit;
Spec.addSpec(\isRest, \unipolar.asSpec)
~st.eventList[1]
DrumRack(\yep).edit

(
Pdef(\plop, 
	
	Ptrace(
			Pbind(
			\instrument, \default,
			\degree, Pseq([0],inf),
			\dur, 1,
			\amp, 0.1
		)
		<> (bla:4)
	),
).play;
);

(~timeline_pattern.(~st.eventList) <> (drumrack:~st.drumrack)).play
~st.eventList
~st.eventList[1].pattern.play
(~st.eventList[1].pattern <> (drumrack:~st.drumrack)).play
(~st.eventList[1].pattern <> (drumrack:~st.drumrack)).play
(PchainT(~st.eventList[1].pattern, ~st.drumrack.get_pad(0).proxy)).play
(PchainT(Pbind(\isRest, Pseq([1,0,1,1,0],inf).coin.not, \dur, 1/4), ~st.drumrack.get_pad(0).proxy)).play
~st.drumrack.get_pad(0).proxy.keep(1).play


~st.eventList[1]
~st.eventList[2]

PchainT( 
	Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
), [ Pbind(\isRest, 1/2) ]; )
o
(
	Pcollect(
		{ arg x;
			x.debug("hhhhhhhhhhhh");
			Ppar(x)

		},
		PchainT(
			Pbind(\isRest, Pseq([1,0,1,1,0],inf).coin.not),
			Ptuple(
				[
					Pbind(
						\instrument, \default,
						\freq, 700,
						\dur, 1,
						\amp, 0.1
					),
					Pbind(
						\instrument, \default,
						\freq, 200,
						\dur, 1,
						\amp, 0.1
					),
				])
			)
		).trace.play
)

(

	~pdemul.(
		PchainT(
			Pbind(\isRest, Pseq([1,0,1,1,0],inf).coin.not, \dur, 1/4),
			~st.drumrack.get_pad(0).proxy
		)
	).play
)

Pcollect({ arg x; x.debug("xxx"); (freq: 300) }, Pseq([1,2,3])).asStream.nextN(5,Event.default)
Pcollect({ arg x; x.debug("xxx"); (freq: 300) }, Pseq([1,2,3])).play
(PchainT(Pbind(\isRest, Pseq([1,0,1,1,0],inf).coin.not, \dur, 1/4), ~st.drumrack.get_pad(0).proxy)).play
( 'freq': 300  ).play



		(
		PchainT(
			Pbind(\isRest, Pseq([1,0,1,1,0],inf).coin.not),
			~st.drumrack.get_pad(0).proxy
		).asStream.next(Event.default)
		)
		


//////////////////// crap


(
127.do { arg chan;
	127.do { arg note;
		[0,127].do { arg veloc;
			m.noteOn (chan, note, veloc)
		}
	}
}
)

m = MIDIOut(0)

"kjkj"
