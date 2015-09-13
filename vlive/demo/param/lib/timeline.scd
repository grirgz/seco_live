
Event.addEventType(\player, {
	var method = ~method ? \play;
	var args = ~arguments ? [];
	var receiver = ~receiver.value;
	var quant;
	[method, args, receiver].debug("player EventType: method, args, receiver");
	if(~disableQuant != false) {
		quant = receiver.tryPerform(\quant);
		receiver.tryPerform(\quant_, 0);
	};
	receiver.perform(method, *args);
	if(~disableQuant != false) {
		receiver.tryPerform(\quant_, quant);
	};
	if(method == \play) {
		TempoClock.default.sched(~sustain.value(currentEnvironment), {
			if(~disableQuant != false) {
				quant = receiver.tryPerform(\quant);
				receiver.tryPerform(\quant_, 0);
			};
			receiver.perform(\stop, *args);
			if(~disableQuant != false) {
				receiver.tryPerform(\quant_, quant);
			};
			
		}.inEnvir);
	};

});

~dereference_event = { arg spawner, ev; 
	[spawner, ev].debug("entering ~dereference_event");
	[ev[\eventType], ev[\nodeType], ev[\type]].debug("eventype, nodetype, type");
	switch(ev[\eventType] ? ev[\nodeType] ? ev[\type],
		\pattern, {
			var pat;
			debug("dereference_event: sub pattern type");
			pat = ev[\pattern].value ?? (ev[\key] !? { Pdef(ev[\key]) } );
			if(ev[\pattern].isNil) {
				pat.debug("pat!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			};
			spawner.par(Pfindur(ev[\sustain], ~timeline_pattern.(pat, ev[\event_dropdur])));
			spawner.wait(ev[\dur]);
		},
		\eventlist, {
			var sustain, eventlist, event_dropdur, dur;
			ev.use {
				sustain = ev.sustain;
				eventlist = ev.eventlist;
				event_dropdur = ev.event_dropdur;
				dur = ev.dur;
			};
			ev.debug("dereference_event: eventlist!!!!");
			//ev.sustain.debug("dereference_event: eventlist!!!! sustain");
			//ev.eventlist.debug("dereference_event: eventlist!!!! eventlist");
			//ev.event_dropdur.debug("dereference_event: eventlist!!!! event_dropdur");
			//		~timeline_pattern.(
			//			~eventlist_aspattern.(ev.eventlist),
			//		).play;
			//		"________".debug;
			spawner.par(Pfindur(
				sustain, 
				~timeline_pattern.(
					~eventlist_aspattern.(eventlist),
					event_dropdur,
				)
			));
			spawner.wait(dur);
		},
		//\player, {
		//	spawner.seq(Pseq([
		//		ev
		//	]))
		//},
		{
			debug("dereference_event: simple event type");
			spawner.seq(Pseq([
				ev
			]))
		}
	);

};

~split_event = { arg val;
	[val].debug("entering ~split_event");
	val.use {
		if(val.notNil) {
			var suboffset = val[\event_dropdur] - (val[\previous_event_dropdur] ? 0);
			if(suboffset == 0) {
				// we are on a border, do nothing;
				val.debug("we are on a border, do nothing; ");
			} {
				if( suboffset > val.sustain ) {
					// we are on a rest
					val[\sustain] = val.sustain - suboffset;
					val[\dur] = val.dur - suboffset;
					val[\isRest] = true;
					val.debug("we are on a rest");
				} {
					// we are on a note
					val[\sustain] = val.sustain - suboffset;
					val[\dur] = val.dur - suboffset;
					//val[\event_dropdur] = suboffset;
					val.debug("we are on a note");
				};
			}
		};
	};
};

~stream_dropdur = { arg drop_time, stream;
	var current_offset = 0;
	var previous_offset = 0;
	var val;
	var crossing_line = List.new;
	[drop_time, stream].debug("entering ~stream_dropdur");
	if(drop_time.notNil and: { drop_time != 0}) {

		while (
			{
				current_offset <= drop_time and: {
					val = stream.next(Event.default);
					val.notNil;
				}
			},
			{
				val.use {
					val[\previous_event_dropdur] = val[\event_dropdur]; // used by ~split_event to not substract sustain two times
					val.debug("stream_dropdur: val");
					[val.dur, val.sustain].debug("stream_dropdur: val: dur, sustain");
					previous_offset = current_offset;
					current_offset = current_offset + val.dur; 
					if(
						current_offset <= drop_time and: {
							( previous_offset + val.sustain ) > drop_time
						}
					) {
						val[\event_dropdur] = drop_time - previous_offset + (val[\event_dropdur] ? 0);
						val.debug("stream_dropdur: added to crossing_line");
						crossing_line.add(val);
					};
					[current_offset, previous_offset, val].debug("mangling");
				}
			}
		);
		// now current_offset point to the end of current event, ie: past the drop_time line


		if(val.notNil) {
			val[\event_dropdur] = drop_time - previous_offset + (val[\event_dropdur] ? 0);
			val = ~split_event.(val.copy);

			crossing_line = crossing_line.collect({ arg ev; 
				ev = ~split_event.(ev.copy);
				ev[\dur] = 0;
				ev.debug("stream_dropdur: transformed crossing_line");
			});

			Pseq(
				crossing_line ++
				[
					val,
					stream
				]
			).asStream;
		} {
			// if there is only one event crossing the line but it's not the last to start 
			// (meaning his dur < sustain), val will be nil, but not crossing_line
			if(crossing_line.size > 0) {
				val = crossing_line.pop;
				val = ~split_event.(val.copy);
				crossing_line = crossing_line.collect({ arg ev; 
					ev = ~split_event.(ev.copy);
					ev[\dur] = 0;
					ev.debug("stream_dropdur: transformed crossing_line");
				});
				Pseq(
					crossing_line 
					++
					[
						val;
					]
				).asStream;
			} {
				nil
			}
		}

		// first yield all the splitted event concurrent with current val, then val, then remaining stream

	} {
		"~stream_dropdur: return original stream untouched".debug;
		stream;
	};
};

~eventlist_aspattern = { arg eventlist;
	// to enable reading before start event or after end event, add a flag to ignore start and end event
	// will be set by toplevel timeline view
	var current_offset = 0;
	var previous_offset = 0;
	var val;
	var crossing_line = List.new;
	var drop_time;
	var original_eventlist = eventlist;
	eventlist = eventlist.copy;
	[eventlist].debug("entering ~eventlist_aspattern");

	eventlist.do { arg ev;
		if(ev[\type] == \start) {
			drop_time = ev[\absTime]
		};
		if(ev[\playDur].notNil) {
			ev[\dur] = ev[\playDur];
		}
	};

	while (
		{
			val = eventlist.removeAt(0);
			val = val.copy;
			val.notNil and: {
				val[\type] != \start;
			}
		},
		{
			val.use {
				val.debug("eventlist_aspattern: val");
				[val.dur, val.sustain].debug("eventlist_aspattern: val: dur, sustain");
				previous_offset = current_offset;
				current_offset = current_offset + val.dur; 
				if(
					val[\type] != \start and: {
						val.sustain.notNil and: {
							( previous_offset + val.sustain ) > drop_time
						}
					}
				) {
					val[\event_dropdur] = drop_time - previous_offset;
					val.debug("eventlist_aspattern: added to crossing_line");
					crossing_line.add(val);
				};
				[current_offset, previous_offset, val].debug("mangling");
			}
		}
	);
	// now current_offset point to the end of current event, ie: past the drop_time line
	// now val is the start event


	if(val.notNil) {

		crossing_line = crossing_line.collect({ arg ev; 
			ev = ~split_event.(ev.copy);
			ev[\dur] = 0; // every event start at the same time, \start event hold the delta to next event
			ev.debug("eventlist_aspattern: transformed crossing_line");
		});

		val.use {
			val = val.copy;
			val[\type] = \rest;
		};

		Prout({ arg inval;
			original_eventlist.changed(\cursor, \play);
			"============================= FUCKING OALAPLAY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".debug;
			"============================= FUCKING OALAPLAY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".debug;
			"============================= FUCKING OALAPLAY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".debug;
			"============================= FUCKING OALAPLAY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!".debug;
			crossing_line.collect({ arg x; 
				x.debug("crossing_line list");
				x.proto !? { x.proto.keys.debug("-proto") }
			});
			[val].collect({ arg x; 
				x.debug("val list");
				x.proto !? { x.proto.keys.debug("-proto") }
			});
			eventlist.collect({ arg x; 
				x.debug("eventlist list");
				x.proto !? { x.proto.keys.debug("-proto") }
			});
			( original_eventlist.endTime - original_eventlist.startTime ).debug("handling end event in pfindur");
			Pfindur(original_eventlist.endTime - original_eventlist.startTime, Pseq(
				( crossing_line ++ [val] ++ eventlist ).collect({ arg x; Pev(x) })
			)).embedInStream(inval);
			//original_eventlist.changed(\cursor, \stop);
		})
	} {
		"should never get there".throw;
		// if there is only one event crossing the line but it's not the last to start 
		// (meaning his dur < sustain), val will be nil, but not crossing_line
		//if(crossing_line.size > 0) {
		//	val = crossing_line.pop;
		//	val = ~split_event.(val.copy);
		//	crossing_line = crossing_line.collect({ arg ev; 
		//		ev = ~split_event.(ev.copy);
		//		ev[\dur] = 0;
		//		ev.debug("eventlist_aspattern: transformed crossing_line");
		//	});
		//	Pseq(
		//		crossing_line ++ [ val, ];
		//	);
		//} {
		//	nil
		//}
	}
};

~timeline_pattern = { arg pat, drop_time, model, is_toplevel=false;
	Pspawner({ arg spawner;
		var stream = pat.asStream;
		[pat, drop_time].debug("timeline_pattern: start");

		stream = ~stream_dropdur.(drop_time, stream);

		if(stream.notNil) {

			//model.changed(\cursor, \play);
			stream.do({ arg ev;
				ev.debug("timeline_pattern");
				~dereference_event.(spawner, ev);
				//spawner.wait(ev[\dur]);
			}, Event.default)
		};

	})
};

///////////////////////////////////////

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

	if(( maxy + 1 ) > timeline.areasize.y) {
		timeline.areasize.y = maxy + 1;
	};

	[timeline.viewport, timeline.viewport.top, maxy/timeline.areasize.y, timeline.viewport.height, (maxy-miny)/timeline.areasize.y].debug("ZOOM ZOOOOOOOOOOOOOOOOOOOOM viewport before");
	[timeline.areasize].debug("areasize");
	range = (maxy-miny+1)/timeline.areasize.y;
	timeline.viewport.top = (miny/timeline.areasize.y);
	timeline.viewport.height = range.clip(0.1,1);
	[timeline.viewport.top, timeline.viewport.height, maxy, miny, timeline.areasize.y].debug("top, height, maxy, miny, areasize");

	//timeline.viewport.top = 42/128;
	//timeline.viewport.height = ((54-42)/128);

	timeline.viewport.debug("ZOOM ZOOOOOOOOOOOOOOOOOOOOM viewport");

	timeline.changed(\viewport);
	timeline.refresh;
};


~event_get_label = { arg ev;
	var label;
	var receiver = ev[\receiver].value;
	label = if(receiver.notNil) {
		if(
			receiver.isKindOf(Ndef) or: {
				receiver.isKindOf(Pdef)
			}
		) {
			"% %".format(receiver.class, receiver.key);
		} {
			receiver.asCompileString; // FIXME: could be very long
		}
	} {
		var type;
		//type =  ev[\nodeType] ? ev[\type] ? ev[\eventType] ?
		if(ev[\eventType] == \pattern) {
			if(ev[\pattern].isKindOf(Pdef)) {
				"% %".format(ev[\pattern].class, ev[\pattern].key);
			} {
				if(ev[\key].notNil) {
					"Pdef %".format(ev[\key])
				}
			}
		}
	};
	label = label ?? { "No Name" };
	label
};

~event_type_player = (
	parent: Event.default,
	label: ~event_get_label,
	type: \player,
);

~event_type_pattern = (
	parent: Event.default,
	label: ~event_get_label,
	eventType: \pattern,

	pattern: { arg self;
		if(self.key.notNil) {
			Pdef(self.key);
		};
	},

	isEmbeddable: true,

	embedEvent: { arg self, inval;
		self.pattern.embedInStream(inval);
	}
);

~event_type_eventlist = (
	parent: Event.default,
	label: ~event_get_label,
	type: \eventlist,
	nodeType: \eventlist,

	eventlist: { arg self;
		self.eventloop.list;
	},

	pattern: { arg self;
		~eventlist_aspattern.(self.eventlist);
	},

	isEmbeddable: true,

	embedEvent: { arg self, inval;
		self.pattern.embedInStream(inval);
	}
);

~event_type_eventenv = (
	// not used, ~event_type_eventlist used currently
	parent: Event.default,
	label: ~event_get_label,
	type: \bus,
	nodeType: \eventlist,

	eventlist: { arg self;
		self.eventloop.list;
	},

	pattern: { arg self;
		~eventlist_aspattern.(self.eventlist);
	},

	isEmbeddable: true,

	embedEvent: { arg self, inval;
		self.pattern.embedInStream(inval);
	}
);

//Event.partialEvents.keys


~mkevent = { arg event;
	var proto = event.proto;
	if(proto.isNil) {
		event
	} {
		event = event.copy;
		event[\proto] = nil;
		proto = proto.copy;
		proto.putAll(event);
		proto;
	}
};


///////////////////////////////////////////////////////////////////// timeline panel


~timelinePanelView = (
	new: { arg self, eventloop;
		self = self.deepCopy;

		self.eventloop = eventloop;
		self.areasize = 9@1;
		self.quant_ref = Ref(Point(1/8,1));

		self.definePattern;

		self;
	},

	areasize: { arg self;
		if(self.timeline.notNil) {
			self.timeline.areasize 
		} {
			self.pr_areasize;
		}
	},

	areasize_: { arg self, val;
		if(self.timeline.notNil) {
			self.timeline.areasize = val;
		};
		self.pr_areasize = val;
	},

	makeRulerY: { arg self, timeline;
		//self.ruler_y = MidinoteTimelineRulerView.new;
		//self.ruler_y.mimicTimeline(timeline);
		//self.ruler_y;
		nil
	},

	make_stop_button: { arg self;
		XSimpleButton.new.label_("[]").action_({
			self.cursor.startPosition = self.eventloop.list.startTime;
			Pdef(self.eventloop.key).stop;
			self.cursor_timeline.stop; // FIXME: should be automatic when stoping Pdef
		});
	},

	make_quant_popup: { arg self;
		var quant_popup;
		var quant_spec;
		quant_spec = MenuSpec([
			"0",
			"1/32",
			"1/16",
			"1/8",
			"1/4",
			"1/2",
			"1",
			"2",
			"4",
			"8",
			"16",
		].collect({ arg x; x -> x.interpret }));

		self.quant_param = Param({ self.get_xquant }, { arg val; self.set_xquant(val) }, quant_spec);
		quant_popup = self.quant_param.asPopUpMenu;
		self.quant_popup = quant_popup;
		self.quant_popup;
	}, 

	make_header: { arg self;

		//self.header_layout = HLayout(
		//	PlayerWrapperView(Pdef(self.eventloop.key)).view,
		//	self.make_stop_button,
		//	XSimpleButton.new.label_("Add track").action_({
		//		self.add_track;
		//	}),
		//	self.make_quant_popup,
		//);
		//
		//self.header_layout;
		View.new;
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

	makeWindow: { arg self;
		var window = Window.new;
		var layout;
		layout = self.makeLayout;
		window.layout = layout;
		window.alwaysOnTop = true;
		window.front;	
	},

	add_track: { arg self;
		self.areasize = Point(self.areasize.x, self.areasize.y+1 );
		self.timeline.refreshEventList;
		self.timeline.refresh;
		self.update_track_header;
	},

	zoom_fit: { arg self;
		[self.areasize, self.timeline.areasize].debug("1");
		~zoom_fit.(self.timeline);
		[self.areasize, self.timeline.areasize].debug("2");
		self.areasize = self.timeline.areasize;
		[self.areasize, self.timeline.areasize].debug("4");
	},

	update_track_header: { arg self;
		var track_header_block = { arg x;
			var res = View.new.layout_(
				HLayout(
					XSimpleButton.new.label_("track %".format(x))
				)
			);
			//res.background_(Color.blue);
			res;
		};
		self.track_header.canvas_(
			self.track_header_view = View.new.layout_(
				VLayout(*
					self.areasize.y.asInteger.collect { arg x;
						[
							track_header_block.(x),
							align: \top,
						]
					}
				).spacing_(0).margins_(0)
			);
			self.track_header_view
		).maxWidth_(100);
		self.update_track_header_size;
		self.track_header.onResize = { self.update_track_header_size };
		if(self.track_header_controller.notNil) {
			self.track_header_controller.remove;
		};
		self.track_header_controller = SimpleController(self.timeline)
		.put(\viewport, {
			"update_track_header_size: viewport".debug;
			//TODO: remove controller
			self.update_track_header_size;
		})
		.put(\areasize, {
			"update_track_header_size: areasize".debug;
			self.update_track_header_size;
			//self.update_track_header;
		})
		;
	},

	update_track_header_size: { arg self;
		//self.vrange.view.doAction;
		if(self.timeline.notNil) {
			"update_track_header_size: real updating now!".debug;
			[self.timeline.bounds.height, self.timeline.viewport.height].debug("bh, vh");
			self.track_header_view.fixedHeight = self.timeline.bounds.height / self.timeline.viewport.height;
			self.track_header.visibleOrigin = Point(0,(1-self.timeline.viewport.bottom) * self.track_header.bounds.height);
			self.timeline.viewport.top.debug("top");
			[self.timeline.viewport, self.timeline.viewport.bottom, self.track_header.bounds.height, (1-self.timeline.viewport.bottom) * self.track_header.bounds.height].debug("[self.timeline.viewport, self.timeline.viewport.bottom, self.track_header.bounds.height, (1-self.timeline.viewport.bottom) * self.track_header.bounds.height]");
			self.track_header.visibleOrigin.debug("update_track_header_size: visibleOrigin");
		}
	},

	set_xquant: { arg self, quant;
		self.quant_ref.value = Point(quant, self.quant_ref.value.y);
	},

	get_xquant: { arg self;
		self.quant_ref.value.x;
	},

	set_yquant: { arg self, quant;
		self.quant_ref.value = Point(self.quant_ref.value.x, quant);
	},

	get_yquant: { arg self;
		self.quant_ref.value.y;
	},

	make_track_header: { arg self;
		var track_header;
		track_header = ScrollView.new;
		track_header.hasBorder = false;
		track_header.hasVerticalScroller = false;
		track_header.hasHorizontalScroller = false;
		self.track_header = track_header;

		self.vrange.view.addAction({ arg slider;
			self.track_header_view.fixedHeight = 1/slider.range * track_header.bounds.height;
			( 1/slider.range * track_header.bounds.height ).debug("vrange.view.action: fixedHeight");
			track_header.visibleOrigin = Point(0, ( 1-slider.hi ) / slider.range) * track_header.bounds.height;
			( Point(0, ( 1-slider.hi ) / slider.range) * track_header.bounds.height ).debug("vrange.view.action: visibleOrigin");
		});

		self.update_track_header;
		self.track_header;
	},

	makeLayout: { arg self;
		var layout;
		var tl_layout;
		var vlayout, timeline, vrange, hrange, size;
		var eventloop = self.eventloop;
		var ruler_x, ruler_y, sizer;
		var locatorbar;
		var sizer_action;
		var cursor_timeline;
		var track_header;
		var track_header_view;
		var quant_popup;
		"AZE".debug;
		layout = HLayout.new;
		self.layout = layout;
		vlayout = VLayout.new;
		layout.add(vlayout);

		timeline = self.timelineClass.new;
		timeline.areasize = self.pr_areasize.debug("==================seting areasize");
		~mytl = timeline;
		timeline.mouseDownAction = {|me, px, py, mod, buttonNumber, clickCount, chosennode|
			if(clickCount == 2) {
				if(chosennode.notNil) {
					~clipEditor.new(chosennode.model, self.eventloop.list)
				};
			}
		};

		timeline.quant = self.quant_ref;

		self.cursor = CursorTimeline.new;
		self.cursor.startPosition = self.eventloop.list.startTime;

		cursor_timeline = CursorTimelineView.new;
		~cursor_timeline = cursor_timeline;
		self.cursor_timeline = cursor_timeline;
		cursor_timeline.mapCursor(self.cursor);
		cursor_timeline.quant = self.quant_ref;


		ruler_x = TimelineRulerView.new;
		locatorbar = TimelineLocatorBarView.new;
		locatorbar.mapCursor(self.cursor);

		locatorbar.quant = self.quant_ref;

		ruler_x.mimicTimeline(timeline);
		locatorbar.mimicTimeline(timeline);
		cursor_timeline.mimicTimeline(timeline);

		hrange = TimelineScroller.new;
		hrange.mapTimeline(timeline);
		hrange.orientation = \horizontal;
		vrange = TimelineScroller.new;
		vrange.mapTimeline(timeline);
		vrange.orientation = \vertical;
		self.vrange = vrange;

		sizer = 
		HLayout(
			XSimpleButton.new.label_("<").action_({
				var point = Point(4,0);
				self.areasize = self.areasize - point;
				timeline.refresh;
			}).fixedSize_(Point(10,20)),
			XSimpleButton.new.label_(">").action_({
				var point = Point(4,0);
				self.areasize = self.areasize + point;
				timeline.refresh;
			}).fixedSize_(Point(10,20)),
		).spacing_(0)
		;


		track_header = self.make_track_header(timeline);


		tl_layout = GridLayout.rows(
			[
				nil,
				VLayout(
					locatorbar.view,
					ruler_x.view,
				),
				XSimpleButton.new.label_("z")
					.maxWidth_(10)
					.action_({
						self.zoom_fit;
					})
			],
			[
				track_header,
				StackLayout(
					cursor_timeline.view,
					timeline.view,
				).mode_(1),
				vrange.view,
			],
			[
				nil,
				hrange.view,
				sizer,
			]
		);
		tl_layout.spacing = 0;

		layout = VLayout(
			self.make_header,
			tl_layout,
		);

		size = self.areasize;
		size.debug("size!!!");

		timeline.areasize = size;

		ruler_x.view.minSize = Point(10,10);
		//ruler_y.view.minSize = Point(40,10);
		locatorbar.view.minSize = Point(10,15);

		timeline.mapEventList(eventloop.list);
		cursor_timeline.mapEventList(eventloop.list);
		locatorbar.mapEventList(eventloop.list);

		self.timeline = timeline;
		self.layout = layout;
		"iiAZE".debug;


		self.zoom_fit;

		layout;
	},

	asPattern: { arg self;
		Pfunc({})

	},

	refresh: { arg self;
		self.timeline.mapEventList(self.eventloop.list);
	},
);

~clipEditor = (
	new: { arg self, model, parent;
		self = self.deepCopy;
	
		self.model = model;
		self.parent_model = parent;
		self.makeWindow;
		
	
		self;
	},

	makeUpdater: { arg self;
		self.controller.remove;
		self.controller = SimpleController(self.model).put(\refresh, {
			var ev = self.model;
			[self.type_popup, ev].debug("entering clipEditor updater");
			if(self.type_popup.isNil or: {self.type_popup.isClosed}) {
				self.controller.remove;
			} {
				switch(ev[\eventType] ? ev[\nodeType] ? ev[\type],
					\player, {
						ev.debug("clipEditor: updater: player");
						self.type_popup.value = self.type_popup.items.detectIndex({ arg x; x == \Ndef });
						self.name_popup.items = Ndef.all[\localhost].envir.keys.asArray;
						self.name_popup.value = self.name_popup.items.detectIndex({ arg x; 
							x == ( ev[\key] ?? { ev[\receiver].value.key } )
						});
						[self.name_popup.value, self.name_popup.items, ev[\key], ev[\receiver], ev[\receiver].value.key].debug("name, items, key, rec, reckey");
					},
					\pattern, {
						ev.debug("clipEditor: updater: pattern");
						self.type_popup.value = self.type_popup.items.detectIndex({ arg x; x == \Pdef });
						self.name_popup.items = Pdef.all.keys.asArray;
						self.name_popup.value = self.name_popup.items.detectIndex({ arg x; 
							x == ( ev[\key] ?? { ev[\receiver].value.key } ) 
						});
						[self.name_popup.value, self.name_popup.items, ev[\key], ev[\receiver], ev[\receiver].value.key].debug("name, items, key, rec, reckey");
					}, {

						ev.debug("clipEditor: updater: other");
					}
				)
			}


		});
	},

	makeLayout: { arg self;
		var layout;
		var header;
		var editor;
		var type_popup, name_popup;
		var model = self.model;
		type_popup = PopUpMenu.new;
		name_popup = PopUpMenu.new;
		self.name_popup = name_popup;
		self.type_popup = type_popup;
		name_popup.allowsReselection = true;
		//type_popup.allowsReselection = true; // lose selection
		
		type_popup.items = [
			'Pdef',
			'Ndef',
			'Timeline',
			'MidinoteTimeline'
		];
		type_popup.action = {
			switch( type_popup.items[type_popup.value],
				\Ndef, {
					name_popup.items = Ndef.all[\localhost].envir.keys.asArray;
				},
				\Pdef, {
					name_popup.items = Pdef.all.keys.asArray;
				}
			);
		};
		name_popup.items = type_popup.items[type_popup.value].asClass.all.keys.asArray;
		name_popup.action = {
			var curname = name_popup.items[name_popup.value];
			switch( type_popup.items[type_popup.value],
				\Ndef, {
					model.putAll(~event_type_player);
					model[\receiver] = Ref(Ndef(curname));
					//model.changed(\refresh);
					self.parent_model.changed(\refresh);
				},
				\Pdef, {
					model.putAll(~event_type_pattern);
					model.receiver = Ref(Pdef(curname));
					//model.changed(\refresh);
					self.parent_model.changed(\refresh);
				}
			);
		};

		header = HLayout(
			type_popup,
			name_popup,
		);
		layout = VLayout(
			header,
			editor,
		);

		self.layout = layout;
		self.layout;
	},

	makeWindow: { arg self;
		var window = Window.new;
		var layout;
		layout = self.makeLayout;
		window.layout = layout;
		window.alwaysOnTop = true;
		window.front;

		self.makeUpdater;
		self.model.changed(\refresh);
	},

);
