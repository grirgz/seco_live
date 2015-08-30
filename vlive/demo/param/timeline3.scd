// projects
- quark minimal and solid
	- step sequencer gui
	- 
- use in veco
- research on making good ui easily
- big synth with great gui
	- DrumSequencer
	- FxSequencer
	- SampleSequencer

//TODO
- write a canvas with time meter
- write a canvas with y labels (drums, tracks, etc)
- write a canvas with x moveable labels (sound position)

- PRACTICAL: make an example of Ndef/Pdef with gui editables curves of params
	- BigEnvView
	- EventList

- write DrumSeq, a class which take in a list of channel associated with a midinote, 
	and can play a midinote/dur pattern (additional keys ?) triggering the channels
	channels are composed of parts
	you can add part and channels in real time
	each part can be associated with one or more

- make BufDef a subclass of Buffer with access to the path of the sample
	- DrumSeq depend on it
- find a way to save EventList/EventLoop
	- also in plain file
	- also integrated in veco
- make a timeline with different channels and scores
- BLOCKING: make a subclass of EventList/EventLoop to be able to share my code
- write the sampler using the soundfileview with a label bar
- write the fx sequencer glitch

- BLOCKING: add a noteoff mecanism to EventList

/// R&D
- make a Transport class, it's the veco project who now what is the selected track and clip
	- this class will handle play/stop and mode clip/row/timeline
		what about timeline of timeline ?
- find a way to update arrays with gui and code without need to repeat the pattern
- make easily feasible to have multiple blocks of pattern wich take the same arguments then build a gui using the same structure
	- see end of timeline2
- make a timeline for veco
- write Builder but before, test if Instr can't do the trick, and profite pour ajouter le support d'Inst a Param



////////////////// 
// score manager R&D

ScoreBank('track1') contains a list of EventList/isRest, a list of EventList/Seq of higher level, then another level
	can also contains subchannels with param automation
ScoreClip('track1.1', \track1) contains the current score of the clip in veco for example, may be an EventList/isRest or higher level
	can also contains subchannels with param automation
	by default use the pattern number ~index in veco
EventList
EventLoop

MidinoteTimeline - contains only an EventList spec'ed for midinote
MidinoteClip - can contains timeline of timeline or just timeline (for midinote)

EventTimeline - contains an EventLoop
EventTimelineDef

ScoreClip - can contains timeline or higher level, or stepseq and higher level

ParamTimeline - contains an EventList spec'ed to the param 

TimelineGroup - contains a list of EventClip/MidinoteTimeline and display them in parrallel
	
there is timeline which is just a timeline of notes
there is timeline which is just a way to put subtimeline in a timeline
	- by giving a way to select a subtimeline then putting it in the timeline
		- a nice way could be to drag the clip up or down to make switch to previous or nextsubtimeline
	- by displaying a row for each subtimeline
there is timeline which show different channel playing, by showing a timeline of note for each channel
there is timeline which show different channel playing, by showing a timeline of subtimeline for each channel
there is timeline which show different subtimeline in each row to select and compare subtimeline
there is timeline which show different timeline of subtimeline in each row to select and compare timeline

timeline can be
	- concern only one channel
	- multichannel in one eventlist
	- multichannel by parallelling eventlist

	TimelinePar([
		MidinoteClipDef(\plop1),
		MidinoteClipDef(\plop2),
	]).edit

	TimelineJoin([
		MidinoteClipDef(\plop1),
		MidinoteClipDef(\plop2),
	])

	TimelineSeq([
		MidinoteClipDef(\plop1),
		MidinoteClipDef(\plop2),
	])

i will choose three timeline, the most useful and versatile to begin
- timeline of notes
	- midinote
	- labeled
- timeline of subtimeline with optionally several rows

// complexity level

- just a view with methods to create and move rect
- a view tied to a model which is an event list, plus several method specifying what kind of event list it is and how to display it
	specialisation
	- midinote timeline
	- param timeline
	- drum timeline
	- fx timeline
	- timeline of timeline
- a set of common widget to use with timeline
	- rulers
	- locator bar
	- scroll bars
	- previous/next take
	- resize viewport (to make room to add notes)
- a view tied to a list of timeline of timeline to make it appear a single timeline
	- not necessary converted because we may need to access subtot separately
- conversion between timeline of timeline list, and timeline of timeline of timeline
	- probably a method of EventList


///////////////////////////////////////////////////////////////////


(
Pdef(\plop, 
	MidinoteClipDef(\plop, Pdef(\plop)) <>
	Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);

MidinoteClipDef(\plop).play
MidinoteClipDef(\plop).edit

TimelineGroup([
	MidinoteClipDef(\plop),
	MidinoteClipDef(\plop2),
]).edit

MidinoteTimeline([])

////////////////////////////////////// rulers


(
~make_ruler = {
	var window = Window.new;
	var layout;
	var ruler = TimelineRulerView.new;
	//ruler.mygrid = { arg self;
	//	var areasize = self.areasize, viewport = self.viewport, bounds = self.bounds;
	//	var minstepsize = 30;
	//	var small_line_count;
	//	var high_line_count;
	//	var len = (areasize * viewport)
	//	var len = self.pixelRectToGridRect(bounds).width;
	//	small_line_count = bounds.width/minstepsize;
	//	high_line_count = bounds.width/minstepsize*4;
	//	bounds.debug("bounds");

	//};
	layout = VLayout(
		ruler.view
	);
	ruler.viewport = Rect(0.1,0,0.1,1);
	window.layout = layout;
	//window.alwaysOnTop = true;
	window.front;
	
}.value;
)

(
~make_locatorbar = {
	var window = Window.new;
	var layout;
	var el = XEventList.new;
	var locator;
	el.start;
	el.finish(1);
	locator = TimelineLocatorBarView.newFromEventList(el);
	locator.areasize = 2@1;
	locator.paraNodes.debug("nodes").collect({ arg x; x.origin.debug("rect") });
	layout = VLayout(
		locator.view
	);
	//locator.viewport = Rect(0.1,0,0.1,1);
	window.layout = layout;
	//window.alwaysOnTop = true;
	window.front;
	
}.value;
)


(
~canvas = {
	var window = Window.new;
	var layout;
	var ruler = UserView.new;
	//ruler.mygrid = { arg self;
	//	var areasize = self.areasize, viewport = self.viewport, bounds = self.bounds;
	//	var minstepsize = 30;
	//	var small_line_count;
	//	var high_line_count;
	//	var len = (areasize * viewport)
	//	var len = self.pixelRectToGridRect(bounds).width;
	//	small_line_count = bounds.width/minstepsize;
	//	high_line_count = bounds.width/minstepsize*4;
	//	bounds.debug("bounds");

	//};
	ruler.background = Color.white;
	ruler.drawFunc = {

		//var point;
		//var len=8;
		//var height=15;
		//var box = {
		//	var middle = height*3/4;
		//	Pen.moveTo(point);
		//	Pen.lineTo(point + Point(len,0));
		//	Pen.lineTo(point + Point(len,middle));
		//	Pen.lineTo(point + Point(len/2,height));
		//	Pen.lineTo(point + Point(0,middle));
		//	Pen.lineTo(point + Point(0,0));

		//	//Pen.lineTo(point + Point(len,0));
		//	//Pen.lineTo(point + Point(len,middle));
		//	//Pen.lineTo(point + Point(len/2+1,middle));
		//	//Pen.lineTo(point + Point(len/2,height));
		//	//Pen.lineTo(point + Point(len/2-1,middle));
		//	//Pen.lineTo(point + Point(0,middle));
		//	//Pen.lineTo(point + Point(0,0));
		//};
		//point = Point(10,10);

		////Pen.scale(5,2);

		////Pen.scale(1,-1);

		//box.();
		//Pen.color = Color.green;
		//Pen.fill;

		//box.();
		//Pen.color = Color.black;
		//Pen.stroke;
		////Pen.stringInRect("hello bla", Rect(point.x,point.y, 10,8), Font('sans', 3));
		//Pen.stringAtPoint(" hello bla", Point(point.x+len,point.y+2),Font('sans', 8));

		var grid;
		var bounds = this.bounds;
		var piano_pattern = [0,1,0,1,0, 0,1,0,1,0,1,0];
		var areasize = 10@10;
		Pen.alpha = 0.5;
		Pen.color = Color.black;


		areasize.debug("drawFunc: areasize");
		areasize.y.do { arg py;
			var start;
			var next;
			//[this.gridPointToPixelPoint(Point(0,py)),this.gridPointToPixelPoint(Point(areasize.x, py))].debug("line");
			start = this.gridPointToPixelPoint(Point(0,py));
			next = this.gridPointToPixelPoint(Point(0,py+1));
			Pen.line(start,this.gridPointToPixelPoint(Point(areasize.x/4, py)));
			Pen.stroke;
			//Pen.fillRect( Rect(start.x, start.y, areasize.x/4, next.y-start.y  ) )
		};
	};
	layout = VLayout(
		ruler
	);
	window.layout = layout;
	//window.alwaysOnTop = true;
	window.front;
	
}.value;
)


~el = nil;
(
	if(~el.isNil) {
		~el = EventList.new;
		a = ~el;
			a.start;
			a.addEvent((absTime: 0, midinote: 50, sustain:1/4));    // events should begin with time 0;
			a.addEvent((absTime: 0.3, midinote: 47, sustain:1/4));
			a.addEvent((absTime: 0.52, midinote: 42, sustain:1/4));
			a.addEvent((absTime: 0.72, midinote: 52, sustain:1/4));
			a.addEvent((absTime: 0.93, midinote: 54, sustain:1/4));
			//a.finish(1.88);
		a.finish(1.50);
		EventLoop(\a).list = a;
	};

	~zoom_fit = { arg timeline;
		var maxy=0, miny=127;
		var range;
		timeline.model.do { arg ev, x;
			var midi = ev.use { ev.midinote };
			[x, maxy, miny, midi, ev].debug("zoom_fit: midi");
			if(midi.notNil) {
				[x, midi].debug("zoom_fit, notnil");
				if(midi > maxy) {
					maxy = midi;
				};
				if(midi < miny) {
					miny = midi;
				};
			}
		};
		[timeline.viewport, timeline.viewport.top, maxy/timeline.areasize.y, timeline.viewport.height, (maxy-miny)/timeline.areasize.y].debug("ZOOM ZOOOOOOOOOOOOOOOOOOOOM viewport before");
		[timeline.areasize].debug("areasize");
		range = (maxy-miny+1)/timeline.areasize.y;
		timeline.viewport.top = (miny/timeline.areasize.y).debug("top");
		timeline.viewport.height = range;

		//timeline.viewport.top = 42/128;
		//timeline.viewport.height = ((54-42)/128);

		timeline.viewport.debug("ZOOM ZOOOOOOOOOOOOOOOOOOOOM viewport");

		timeline.changed(\viewport);
		timeline.refresh;
	};

	/*
	a = Rect(0,0,1,1)
	a.top
	a.top = 0.2
	a
	a.bottom 
	a.bottom = 0.3
	a.height = 0.1
	*/

	~zoom_bar = (
		new: { arg self;
			self = self.deepCopy;
		
			
		
			self;
		},


	);

	~midinoteTimeline = (
		new: { arg self, eventloop;
			self = self.deepCopy;
		
			self.eventloop = eventloop;
			self.area_size = 8@128;
			
		
			self;
		},

		makeWindow: { arg self;
			var window = Window.new;
			var layout;
			layout = self.makeLayout;
			window.layout = layout;
			window.alwaysOnTop = true;
			window.front;	
		},

		makeLayout: { arg self;
			var layout;
			var vlayout, timeline, vrange, hrange, size;
			var eventloop = self.eventloop;
			var ruler_x, ruler_y, sizer;
			var locatorbar;
			var sizer_action;
			"AZE".debug;
			layout = HLayout.new;
			self.layout = layout;
			vlayout = VLayout.new;
			layout.add(vlayout);

			timeline = MidinoteTimelineView.new;
			~mytl = timeline;
			ruler_x = TimelineRulerView.new;
			ruler_y = MidinoteTimelineRulerView.new;
			locatorbar = TimelineLocatorBarView.new;

			ruler_y.mimicTimeline(timeline);
			ruler_x.mimicTimeline(timeline);
			locatorbar.mimicTimeline(timeline);

			hrange = TimelineScroller.new;
			hrange.mapTimeline(timeline);
			hrange.orientation = \horizontal;
			vrange = TimelineScroller.new;
			vrange.mapTimeline(timeline);
			vrange.orientation = \vertical;

			sizer = 
				HLayout(
					XSimpleButton.new.label_("<").action_({
						var point = 0 - Point(4,0);
						timeline.areasize = timeline.areasize + point;
						timeline.refresh;
					}).fixedSize_(Point(10,20)),
					XSimpleButton.new.label_(">").action_({
						var point = Point(4,0);
						timeline.areasize = timeline.areasize + point;
						timeline.refresh;
					}).fixedSize_(Point(10,20)),
				).spacing_(0);

			layout = GridLayout.rows(
					[
						nil,
						VLayout(
							locatorbar.view,
							ruler_x.view,
						),
						XSimpleButton.new.label_("z")
							.maxWidth_(10)
							.action_({
								~zoom_fit.(timeline);
							})
					],
					[
						ruler_y.view,
						timeline.view,
						vrange.view,
					],
					[
						nil,
						hrange.view,
						sizer,
					]
			);
			layout.spacing = 0;

			size = self.area_size;
			size.debug("size!!!");

			timeline.areasize = size;

			ruler_x.view.minSize = Point(10,10);
			ruler_y.view.minSize = Point(40,10);
			locatorbar.view.minSize = Point(10,15);

			timeline.mapEventList(eventloop.list);
			locatorbar.mapEventList(eventloop.list);

			self.timeline = timeline;
			self.layout = layout;
			"iiAZE".debug;
			layout;
		},

		refresh: { arg self;
			self.timeline.mapEventList(self.eventloop.list);
		},
	);
	~mt = ~midinoteTimeline.new(EventLoop(\a));
	~mt.makeWindow;

)

(Pbind(\instrument, \default) <> EventLoop(\a)).play

~mytl.viewport = Rect(0, 42/128, 1,1-((52-42)/128)); ~mytl.refresh;
~mytl.viewport = Rect(0, 1/4, 1,(1/4)); ~mytl.refresh;
~mytl.viewport = Rect(0, 0, 1,1); ~mytl.refresh;

(
	~make = {
		var window = Window.new;
		var layout;
		layout = VLayout(
			//TextField.new
			//	.string_("kljkj")
			a = RangeSlider.new.orientation_(\vertical)
		);
		//a.orientation.debug("kk");
		window.layout = layout;
		//window.alwaysOnTop = true;
		window.front;
	}.value;
)

a = (label: "kkjkj"); TimelineLocatorPropertiesView.new(a)
a
a



