
(
WindowDef(\PmodEnvEditor, (
	envToEventList: { arg self, env;
		var el = TimelineEventList.new;
		var emptyCount;
		el.start;
		env.times.collect { arg time, idx;
			var ev = (
				level: env.levels[idx],
				dur: time,
				curve: env.curves.asSequenceableCollection.wrapAt(idx),
			);
			if(env.releaseNode.notNil and: { ( env.releaseNode ) == idx }) {
				ev[\releaseNode] = true
			};
			if(env.loopNode.notNil and: { ( env.loopNode ) == idx }) {
				ev[\loopNode] = true
			};
			el.add(ev);
		};
		el.add(
			(
				level: env.levels.last,
				dur: 0,
			)
		);
		env.debug("env");
		emptyCount = block { arg break;
			// remove empty nodes: support for variable length enveloppes
			var count = 0;
			el.reverse.do { arg ev, idx;
				[ev, idx, count].debug("emptyCount ev");
				if(ev.dur == 0 and: { ev.level == 0 }) {
					count = count + 1;
				} {
					break.(count)
				}
			};
		};
		emptyCount.debug("emptyCount");
		if(emptyCount>2) {
			el = el.drop((  -1 * ( emptyCount - 1 ) ).debug("dddd"));
		};

		el.calcAbsTimes;
		el.finish(env.times.sum.debug("in"));
		el.debug("el");
		el;
	},


	eventListToEnv: { arg self, eventList;
		var levels = List.new;
		var times = List.new;
		var curves = List.new;
		var releaseNode;
		var loopNode;
		var absTime = 0;
		eventList = eventList.clone;
		eventList.doAdjacentPairs { arg prev, next;
			if(next[\type] == \start) {
				prev[\dur] = prev[\dur] + next[\dur];
			};
			if(next[\type] == \end) {
				prev[\dur] = prev[\dur] + next[\dur];
			};
		};
		eventList = eventList.reject({ arg ev; [\start, \end].includes(ev[\type]) });
		eventList.do { arg ev, idx;
			levels.add(ev[\level]);
			times.add(ev[\dur]);
			curves.add(ev[\curve]);
			if(ev[\releaseNode] == true) {
				releaseNode = idx;
			};
			if(ev[\loopNode] == true) {
				loopNode = idx;
			};
		};
		curves = curves.drop(-1);
		curves = curves.collect({ arg x; if(x.isNil) { 0 } { x } });
		curves = curves.as(Array);
		times = times.drop(-1);
		Env(levels.as(Array), times.as(Array), curves, releaseNode, loopNode);
		
	},

	pmodEnvToEventList: { arg self, pmod;
		pmod.asCompileString.debug("pmodEnvToEventList pmod");
		pmod = self.standardizePmodEnv(pmod);
		self.envToEventList(Env(pmod.valPat.list, pmod.timePat.list, pmod.curvePat.list));
	},

	eventListToPmodEnv: { arg self, el, pmod;
		var env = self.eventListToEnv(el);
		env.debug("env ?");
		if(pmod.isNil) {
			pmod = PmodEnv(PstepSeq(self.param.spec.map([0,1,0]),1), PstepSeq([1/2,1/2],inf), PstepSeq([0,0],inf));
		};
		pmod.timePat.list = env.times;
		pmod.valPat.list = env.levels;
		pmod.curvePat.list = env.curves;
		pmod;
	},

	installUpdater: { arg self, el;
		// when GUI change, should change the param
		el.addDependant({ arg obj, msg ...args;
			var oldquant;
			[obj, msg, args].debug("dep");
			self.disableUpdate = true;
			//self.eventListToPmodEnv(obj, self.pmod);
			self.pmod = self.eventListToPmodEnv(obj);
			self.cursorTimeline.mapControllerTarget(self.pmod);
			oldquant = self.param.target.source.at(self.param.propertyRoot).quant;
			self.param.target.source.at(self.param.propertyRoot).quant = self.timeline.areasize.x;
			self.param.set(self.pmod.loop);
			self.param.target.source.at(self.param.propertyRoot).quant = oldquant; // this maybe override default quant
			//self.param.set(self.eventListToEnv(obj));
			self.disableUpdate = false;
		});
	},

	releaseNode: { arg self;
		self.param.get.asEnv.releaseNode;
	},

	releaseNode_: { arg self, val;
		self.param.set(self.param.get.asEnv.releaseNode_(val));
	},

	loopNode: { arg self;
		self.param.get.asEnv.loopNode;
	},

	loopNode_: { arg self, val;
		self.param.set(self.param.get.asEnv.loopNode_(val));
	},

	installMouseActions: { arg self;
		var viewport;
		var clickpoint;
		self.timeline.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction XX");

			if(buttonNumber == 1) { // right click
				Menu(
					MenuAction("Set view duration", {
						WindowDef(\PmodEnvView_duration, { arg def;
							var durfield;
							VLayout (
								HLayout (
									StaticText.new.string_("Dur"),
									durfield = TextField.new.string_(self.timeline.areasize.x),
								),
								HLayout (
									BasicButton.new.string_("OK").action_({
										var ars = self.timeline.areasize;
										ars.x = durfield.value.interpret;
										self.timeline.areasize = ars;
										self.timeline.changed(\areasize);
										//self.timeline.changed(\redraw);
										//self.cursorTimeline.mimicTimeline(self.timeline);
										self.timeline.refresh;
										def.closeWindow;
									}),
									BasicButton.new.string_("Cancel"),
								)
							)
						}).front;
					})
				).front;
				//viewport = self.timeline.viewport;
				//clickpoint = Point(x, y);
			}
			
		});
		//self.timeline.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction XX");

			//if(viewport.notNil) {
				//var newwidth = y - clickpoint.y/400;
				//var newxoffset = x - clickpoint.x/800;
				//newwidth = viewport.width * ( newwidth + 1 );
				//newxoffset = (viewport.origin.x - ( newxoffset  )).clip(self.viewportMargins.x,inf);
				//[y, clickpoint.y, y - clickpoint.y, newwidth].debug("width");
				//[x, clickpoint.x, x - clickpoint.x, newxoffset].debug("xoffset");
				//self.timeline.viewport = Rect(newxoffset, self.viewportMargins.y, newwidth, self.timeline.viewport.height);
				//self.timeline.refresh;
			//}
			
		//});
		//self.timeline.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction XX");

				//viewport = nil;
				//clickpoint = nil;
			
		//});
		
	},
	
	standardizePmodEnv: { arg self, pmod;
		var vlist, tlist, clist;
		var val;
		pmod.asCompileString.debug("standardizePmodEnv pmod");
		val = pmod;
		if(val.isKindOf(Pn)) {
			val = val.pattern;
		};
		if(val.isKindOf(PmodEnv).not) {
			val = PmodEnv(PstepSeq(self.param.spec.map([0,1,0]),1), PstepSeq([1/2,1/2],inf), PstepSeq([0,0],inf));
		} {
			vlist = val.valPat;
			if(vlist.isKindOf(Number)) {
				vlist = PstepSeq([vlist],1);
			};
			if(vlist.isKindOf(Pseq)) {
				vlist = PstepSeq(vlist.list,vlist.repeats);
			};

			tlist = val.timePat;
			if(tlist.isKindOf(Number)) {
				tlist = PstepSeq([tlist],inf);
			};
			if(tlist.isKindOf(Pseq)) {
				tlist = PstepSeq(tlist.list,tlist.repeats);
			};

			clist = val.curvePat ?? 0;
			if(clist.isKindOf(Number)) {
				clist = PstepSeq([clist],inf);
			};
			if(clist.isKindOf(Pseq)) {
				clist = PstepSeq(clist.list,clist.repeats);
			};

			val = PmodEnv(vlist, tlist, clist);
		};
		val.asCompileString.debug("standardizePmodEnv return");
		val;
	},

	viewportMargins: { arg self;
		self.timeline.pixelPointToNormPoint(Point(5,self.timeline.virtualBounds.height-5)) * -1;
		Point(0,0);
	},

	asView: { arg self, def, param;
		var tlview = TimelineEnvView.new;
		var el;
		var font = Font.default.copy.size_(7);
		var font2 = Font.default.copy.size_(8);
		var widget;
		var debuglayout;
		var margins;
		var val;
		self.timeline = tlview;
		//margins = self.timeline.pixelPointToNormPoint(Point(5,self.timeline.virtualBounds.height-5)) * -1;
		//self.viewportMargins = margins;
		if(param.propertyArray.last == \stepseq) {
			param = param.parent.at(\source);
		};
		self.param = param;
		self.pmod = self.standardizePmodEnv(param.get);
		param.set(self.pmod.loop);
		el = self.pmodEnvToEventList(self.pmod);
		self.installUpdater(el);
		self.timeline.mapEventList(el);
		self.timeline.quant = Point(1/8,self.param.spec.step);
		self.timeline.mapParam(Param(Message(self), \level, self.param.spec));
		~self = self;
		el.totalDur.debug("el totalDur");
		//self.timeline.areasize = Point(el.totalDur,param.spec.range);
		self.timeline.areasize = Point(8,param.spec.range);
		margins = self.viewportMargins;
		margins.debug("margins");
		self.timeline.viewport = Rect(margins.x,margins.y,1,1);
		self.timeline.quant = Ref(Point(0, self.param.spec.step));
		self.installMouseActions;

		self.cursorTimeline = SimpleCursorTimelineView.new;
		self.cursorTimeline.mapEventList(el);
		self.cursorTimeline.mimicTimeline(tlview);
		self.cursorTimeline.mapControllerTarget(self.pmod);

		param.attachListener(self.timeline.view, {
			// when param change, should change the GUI
			var el;
			if(self.disableUpdate != true) {

				debug("refresh GUI because param changed");
				//el = self.envToEventList(param.get.asEnv);
				//self.installUpdater(el);
				//self.timeline.mapEventList(el);
			}
		});
		debuglayout = VLayout (
			//PlayerWrapper(self.param.target),
			StackLayout (
				self.cursorTimeline.view,
				self.timeline.view.minSize_(Point(10,10)),
			).mode_(1)
			//self.timeline.viewWithCursor,
		);
		debuglayout;
		//widget;
	
	},
));



//// test

//Pbindef(\bla, 
		//\instrument, \sh101,
		//\freq, PmodEnv(PstepSeq([100,400,100],1), PstepSeq([1,5],inf), PstepSeq([0,0],inf)).loop,
		//\dur, 1,
		//\amp, 0.1,
//);
//WindowDef(\win, { arg def;
	
	//VLayout (
		//PlayerWrapper(Pdef(\bla)).asView,
		//WindowDef(\PmodEnvEditor).asView(Param(Pdef(\bla), \freq -> \source)),
	//)
//}).front;
)

// END
///////////////////////////////////////


Pbindef(\bla).play;
(
Pbindef(\bla, 
		\instrument, \sh101,
		\freq, PmodEnv(PstepSeq([100,400,100],1), PstepSeq([1,5],inf), PstepSeq([0,0],inf)).loop,
		\dur, 1,
		\amp, 0.1,
).play;
);
Pbindef(\bla, \dur, 1)


~t = 180/4/60; TempoClock.default.tempo = ~t;
s.latency = 1

(
WindowDef(\PmodEnvView, { arg def;
	var ptl = TimelineEnvView.new;
	~ptl = ptl;
	ptl.view;
}).front;
)

~ptl.eventList

~pm = PmodEnv([300,1000,300],[1]);
~pm = PmodEnv(Pseq([100,400,100],1), 8)
~lev = PstepSeq([100,400,300],1);
~time = PstepSeq([8],inf);
~pm = PmodEnv(~lev, ~time)
~pm.levels

~lev.list[1] = 1000
~pm.loop.pattern

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pm.loop,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

