// CURRENT: j'en suis ou ? j'en suis a ecrire refresh_timelines_view, il faut deplacer tous les mapTimeline et autre mimic pour que ca se refresh quand on recrée la view avec add_modulator


// add env timelines
ParamProto.init(true);
(

	// in steptimeline.scd
ParamProto.init;

/////

//~st = ~stepTimeline.new(\bop);
//~st.drumrack = DrumRack(\yep);
//~st.edit;

~st = ~modStepTimeline.new(\wap);
~st.drumrack = DrumRack(\yep);
~st.edit;

)

~aa = ~modStepTimeline.new(\kobi)
~aa.edit
~aa.drumrack = DrumRack(\yep)
~modStepTimeline.new(\kobi).edit

~st.drumrack.key
~st.drumrack.get_pad(0).patternList
~st.drumrack.get_pad(0).update_proxy
~st.drumrack.get_pad(0)[\update_proxy].asCompileString

~st.remove_modulator(0)
~st.mod_timelines
~st.editor.refresh_timelines_view

~st.proxy.stop
~st.proxy
~st.stepTimeline.proxy.stop
~st.stepTimeline.proxy.play
~st.stepTimeline.proxy.source.asCompileString
~st.stepTimeline.eventList.print
~st.stepTimeline.eventList.totalDur

~st.get_pad_modulator_pattern(0,0).asStream.nextN(10,Event.default)
~st.mod_timelines.first.xasPattern.play
~st.xasPattern

~st.mod_timelines[0].param.target.bypass
~st.mod_timelines[0].param.target.bypassKey(~st.mod_timelines[0].param.property)
~st.mod_timelines[0].param.property

(
Pdef(\plop, (bla:1) <> Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
) <> (bla:1)

).play;
);

/////////////////////////////////////////////////////////////////////////////////

//////////// new gui for steptimeline + envtimelines
////////// this is a draft, not final

(
	~multiTimeline = (
		new: { arg self;
			self = self.deepCopy;
		
			
		
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

		make_vrange: { arg self;
			self.ruler_y_view = RangeSlider.new;
			self.ruler_y_view.action = { arg slider;
				self.timelines_view.fixedHeight = 1/slider.range * self.timelines_scrollview.bounds.height;
				self.timelines_scrollview.visibleOrigin = Point(0, ( 1-slider.hi ) / slider.range) * self.timelines_scrollview.bounds.height;
			
			};
			//~vrange.action = { arg slider;
			//	var range = slider.range.clip(0.0001,1); // prevent division by 0

			//	[slider.hi, slider.lo, slider.range].debug("slider v");
			//	~wid.viewport.top = (1-slider.hi) / range;
			//	~wid.viewport.height = range;
			//	[~wid.viewport, slider.hi, slider.lo, slider.range].debug("range action");
			//	~wid.refresh;
			//};
			
			self.ruler_y_view;
		},

		makeLayout: { arg self;
			var layout;
			var timelines_layout;
			var timelines;
			var vlayout, timeline, vrange, hrange, size;
			var eventloop;
			var ruler_x, ruler_y, sizer;
			var locatorbar;
			var sizer_action;
			var timelines_view;
			var timelines_scrollview;
			var param = Param(BusDef(\plop, \control), \fratio, ControlSpec(0.1,5,\lin));
			timelines = 
				[
					~stepTimelinePanelView.newView(~stepTimeline.newInstance(\yep))
						.make_header_(nil)
						.disable_footer_(true)
						.disable_hrange_(true) // FIXME: why this break all!
						.disable_track_header_(true)
				]
				++
				[
					//~stepTimeline.new(\bla),
					~envTimeline.newInstance(param),
					~envTimeline.newInstance(param),
					~envTimeline.newInstance(param),
				].collect({ arg x; 
					~envTimelinePanelView.newView(x)
						.make_header_(nil) 
						.disable_hrange_(true)
				})
			;
			self.timelines = timelines;
			timelines_layout = GridLayout.rows(*
				timelines.collect({ arg x; 
					x.makeLayout;
					x.timeline.debug("timeline---");
					//x.timeline.view.minHeight_(100);
					//View.new.layout_(x.layout).minHeight_(200);
					[
						x.track_header,
						x.layout,
					]
				})
			).spacing_(0).margins_(0);
			timelines_layout.setColumnStretch(0,0);
			timelines_layout.setColumnStretch(1,1);
			timelines_view = View.new.layout_(timelines_layout);
			self.timelines_view = timelines_view;
			//timelines_view = ScrollView.new.layout_(timelines_layout);
			timelines_scrollview = ScrollView.new.canvas_(timelines_view);
			timelines_scrollview.hasBorder = false;
			timelines_scrollview.hasVerticalScroller = false;
			self.timelines_scrollview = timelines_scrollview;

			timeline = timelines[0].timeline;
			eventloop = timelines[0].eventloop;

			"multiTimelines".debug;
			layout = HLayout.new;
			self.layout = layout;
			vlayout = VLayout.new;
			layout.add(vlayout);

			ruler_x = TimelineRulerView.new;
			//ruler_y = MidinoteTimelineRulerView.new;
			locatorbar = TimelineLocatorBarView.new;

			//ruler_y.mimicTimeline(timeline);
			ruler_x.mimicTimeline(timeline);
			locatorbar.mimicTimeline(timeline);
			//timeline.mimicTimeline(timelines[1].timeline);
			//timelines[1].timeline.mimicTimeline(timeline);
			timelines.reduce({ arg a, b; b.timeline.mimicTimeline(a.timeline, \horizontal); a });

			hrange = TimelineScroller.new;
			hrange.mapTimeline(timeline);
			hrange.orientation = \horizontal;
			//vrange = TimelineScroller.new;
			//vrange.mapTimeline(timeline);
			//vrange.orientation = \vertical;
			vrange = self.make_vrange;

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
					//[
					//	nil,
					//	VLayout(
					//		locatorbar.view,
					//		ruler_x.view,
					//	),
					//	XSimpleButton.new.label_("z")
					//		.maxWidth_(10)
					//		.action_({
					//			~zoom_fit.(timeline);
					//		})
					//],
					[
						//ruler_y.view,
						nil,
						timelines_scrollview,
						//[timelines_view, columns:2],
						vrange,
						//vrange.view,
					],
					[
						nil,
						hrange.view,
						sizer,
					]
			);
			layout.spacing = 0;

			ruler_x.view.minSize = Point(10,10);
			//ruler_y.view.minSize = Point(40,10);
			locatorbar.view.minSize = Point(10,15);

			timeline.mapEventList(eventloop.list);
			locatorbar.mapEventList(eventloop.list);
			//layout = timelines_layout;

			self.layout = layout;
			layout;
		},
		
	);

	~pt = ~multiTimeline.new;
	~pt.makeWindow;
)
				~stepTimeline.new(\bla).timeline


(
~a = Ptuple([
	Pbind(
		\instrument, \default,
		\freq, 200,
		\dur, 1,
		\amp, 0.1
	),
	Pbind(
		\instrument, \default,
		\freq, 700,
		\dur, 1,
		\amp, 0.1
	),
]);
~b = Ptuple([
	Pbind(
		\dur, 1/2,
	),
	Pbind(
		\dur, 1/4,
	),
]);
~c = ~a <> ~b;
~cs = ~c.asStream;
)
~cs.next(Event.default)


Param((), \bli) == Param((), \bla)


(
WindowLayout({ 

	var lpls = [
		ListParamLayout.gridButton(Param(List.newFrom((0..32)), \list)),
		ListParamLayout.knob(Param(List.newFrom((0..32)), \list)),
	];
		VLayout (*
			{ arg x;
				var lpl = lpls[x];
	var color;
	var color_ring = [
			Color.newHex("D5F8F8"),
			Color.newHex("D5F8F8"),
			Color.newHex("A0E6E6"),
			Color.newHex("A0E6E6"),
			//Color.newHex("168C8C"),
			//Color.newHex("ACEDED"),
		];
			HLayout(*
				lpl.viewlist.collect({ arg x; 
					x.fixedWidth = 30;
					x.minHeight_(30+3);
				}).clump(4).collect({ arg group4;
					color = color_ring[0]; 
					color_ring = color_ring.rotate(-1);
					View.new.layout_(
						HLayout (
							* group4.collect({ arg view;
								view;
							})
						).spacing_(5).margins_([5,5])
					).background_(color);
				}) 
				++ [nil];
			).spacing_(0).margins_(0)
			} ! 2
		).spacing_(0).margins_(0)
})
)
