
// TODO
// - elastic mode
// - selection rect should be visible
// - edit node coordinates in textfield
// - edit whole env
(
FileSystemProject.loadOnce("libdef/default_specs.scd");

SynthDef(\fullenv, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\fullenv.kr( Env([0,1,0] ++ (0!29),[0.1,0.8] ++ (0!29))), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	\fullenv: ParamEnvSpec( ControlSpec(0,10,\lin), ControlSpec(0,1,\lin) ) 
))).add;

Pdef(\full, 
		Pbind(
			\instrument, \fullenv,
			\degree, Pseq([0],inf),
			\degree, Pseq([0,3],inf),
			\legato, 0.3,
			\dur, 2,
			\amp, 0.1,
		),
);

WindowDef(\EnvEditor, (
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
		if(curves.every({ arg x; x == curves.first })) {
			curves = curves.first;
		} {
			curves = curves.as(Array);
		};
		times = times.drop(-1);
		Env(levels.as(Array), times.as(Array), curves, releaseNode, loopNode);
		
	},

	installUpdater: { arg self, el;
		// when GUI change, should change the param
		el.addDependant({ arg obj, msg ...args;
			[obj, msg, args].debug("dep");
			self.disableUpdate = true;
			self.param.set(self.eventListToEnv(obj));
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
				viewport = self.timeline.viewport;
				clickpoint = Point(x, y);
			}
			
		});
		self.timeline.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction XX");

			if(viewport.notNil) {
				var newwidth = y - clickpoint.y/400;
				var newxoffset = x - clickpoint.x/800;
				newwidth = viewport.width * ( newwidth + 1 );
				newxoffset = (viewport.origin.x - ( newxoffset  )).clip(self.viewportMargins.x,inf);
				[y, clickpoint.y, y - clickpoint.y, newwidth].debug("width");
				[x, clickpoint.x, x - clickpoint.x, newxoffset].debug("xoffset");
				self.timeline.viewport = Rect(newxoffset, self.viewportMargins.y, newwidth, self.timeline.viewport.height);
				self.timeline.refresh;
			}
			
		});
		self.timeline.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseMoveAction XX");

				viewport = nil;
				clickpoint = nil;
			
		});
		
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
		self.timeline = tlview;
		//margins = self.timeline.pixelPointToNormPoint(Point(5,self.timeline.virtualBounds.height-5)) * -1;
		//self.viewportMargins = margins;
		self.param = param;
		el = self.envToEventList(param.get.asEnv);
		self.installUpdater(el);
		self.timeline.mapEventList(el);
		self.timeline.mapParam(Param(Message(self), \level, self.param.spec.levels.first));
		~self = self;
		self.timeline.areasize = Point(2,param.spec.levels.first.range);
		margins = self.viewportMargins;
		margins.debug("margins");
		self.timeline.viewport = Rect(margins.x,margins.y,1,1);
		self.timeline.quant = Ref(Point(0, self.param.spec.step));
		self.installMouseActions;


		param.attachListener(self.timeline.view, {
			// when param change, should change the GUI
			var el;
			if(self.disableUpdate != true) {

				el = self.envToEventList(param.get.asEnv);
				self.installUpdater(el);
				self.timeline.mapEventList(el);
			}
		});
		widget = VLayout (
			self.timeline.view.minSize_(Point(100,100)),
			HLayout (
				StaticText.new.string_("Rel").font_(font),
				Param(Message(self), \releaseNode, ControlSpec(-1,1000,\lin)).asNumberBox.background_(Color.clear).font_(font2).fixedSize_(Point(25,15)).resize_(1),
				StaticText.new.string_("    Loop").font_(font),
				Param(Message(self), \loopNode, ControlSpec(-1,1000,\lin)).asNumberBox.background_(Color.clear).font_(font2).fixedSize_(Point(25,15)).resize_(1),
				nil
			).margins_(2).spacing_(2),
		).spacing_(0);
		debuglayout = VLayout (
			PlayerWrapper(self.param.target),
			widget,
			//param.asView,
		);
		debuglayout;
		//widget;
	
	},
));

//~el = WindowDef(\EnvEditor).proto.envToEventList(Param(Pdef(\bla), \adsr).get);
//WindowDef(\EnvEditor).proto.eventListToEnv(~el);
//WindowDef(\EnvEditor).front(Param(Pdef(\bla), \adsr));
WindowDef(\EnvEditor).front(Param(Pdef(\full), \fullenv));
);

NumberBox
~test = TestDependant();
Env.adsr
Param(Pdef(\bla), \adsr).spec
Param(Pdef(\full), \fullenv).get
Pdef(\bla).set(\adsr, Env.adsr)
Pen
~self.timeline.areasize = Point(2,1)
~self.timeline.areasize
~self.timeline.refresh
~self.timeline.virtualBounds
~self.timeline.gridPointToPixelPoint(Point(0,0))
~self.timeline.normRectToPixelRect(Rect(0,0.1,1,1))
~self.timeline.normRectToPixelRect(Rect(1,1,1,1))
~self.timeline.virtualBoundsOffset = 0;
~self.timeline.virtualBoundsOffset = 15;
~self.timeline.virtualBoundsOffset = 35;
(
Pdef(\bla, 
	Pbind(
		\instrument, \saw,
		\degree, Pseq([0,3],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\full, 
		Pbind(
			\instrument, \fullenv,
			\degree, Pseq([0],inf),
			\degree, Pseq([0,3],inf),
			\legato, 0.3,
			\dur, 2,
			\amp, 0.1,
		),
).play;
);
Pdef(\full).set(\fullenv, Env([0,1,0] ++ (0!29),[0.1,0.8] ++ (0!29)));

(
);


~e = Env.adsr(0.1,0.1,0.8,0.1);
~e = Env.adsr
~e.times
~e.xyc
~e.timeline
~e.asSignal
~e.asPolyLine.edit
PolyLine

ParamTimeline(\bla).edit
ParamTimeline(\bla2, Param(Pdef(\full), \bla, ControlSpec(0,100,\lin))).edit
ParamTimeline(\bla3, Param(Pdef(\full), \bla, ControlSpec(0.1,10,\exp))).edit
NoteTimeline(\bla).edit
ParamTimeline(\bla).eventList.print

~el = TimelineEventList.new

~el.select(_.notNil)
~el.as(List)
~el.start
~el.add((absTime:2, \midinote:100))
~el.finish(4)
NoteTimeline(\bla).eventList = ~el
NoteTimeline(\bla).edit;
~el
~el = TimelineEventList[ (absTime:2, midinote:100) ]
~el.drop(-1)
~el
~el.calcRelDur
~el.start(1)
~el.finish(4)

~el.

(
~removeStartAndEnd = { arg el;
	el.doAdjacentPairs { arg prev, next;
		if(next[\type] == \start) {

			
		}
   
	}

}
)
EnvelopeView
