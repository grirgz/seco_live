
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
