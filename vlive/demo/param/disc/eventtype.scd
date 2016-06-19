
~pembed = ProtoClass((

	new: { arg self, pat, start_offset, stop_offset;
		if(pat.isKindOf(Pattern)) {
			self.embed_pattern(pat, start_offset);
		} {
			self.embed_event(spawner, pat);
		};
		
	},

	embed_pattern: { arg self, pat, start_offset;
		Pspawner({ arg spawner;
			var stream = pat.asStream;
			[pat, drop_time].debug("timeline_pattern: start");

			stream = self.cut_stream(start_offset, stream);

			if(stream.notNil) {
				stream.do({ arg ev;
					self.embed_event(spawner, ev);
				}, Event.default)
			};

		})
		
	},

	embed_event: { arg self, spawner, ev;
		if(ev.type == \pattern) {
			spawner.par(ev.embedPattern);
			spawner.wait(ev.dur);
		} {
			spawner.seq(Pseq([
				ev
			]))
		};
	},

	split_event: { arg self, val;
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
	},

	cut_stream: { arg self, drop_time, stream;
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
				val = self.split_event.(val.copy);

				crossing_line = crossing_line.collect({ arg ev; 
					ev = self.split_event.(ev.copy);
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
					val = self.split_event.(val.copy);
					crossing_line = crossing_line.collect({ arg ev; 
						ev = self.split_event.(ev.copy);
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
	},

	embed_eventlist: { arg self, eventlist;
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
				ev = self.split_event.(ev.copy);
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
	},
));



