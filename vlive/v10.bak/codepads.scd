
(
[
	//"tile",
	"buffer",
	"launchpad",
	"score",
].do { arg file;
	("Loading " ++ file ++".scd...").inform;
	(~veco_dir_path +/+ file++".scd").load;
};
"Done loading.".inform;
~codepads = ~class_codepads.new;
~codepads;
~scene_codepads = ~launchpad_scene_codepads.new(~codepads);
~scene_codepads.activate;
)



(
	~load_samplekit = { arg name;
		Mdef.samplekit[name].size.do { arg idx;
			var x;
			var codepad;
			x = idx % 8;
			y = (idx / 8).asInteger;
			codepad = ~codepads.get_codepad(Point(x,y));
			codepad.mystream = 
				Pbind(
					\instrument, \stereosampler,
					\bufnum, Mdef.sample(name,idx),
					\speed, Pseq([1,0.9,0.8,1.1,1,1.2],inf),
					//sustain: 0.1,
					\latency, 0.0,
				).asStream;
			codepad.payload = { arg self;
				"plop!!!!!!!".debug;
				self.record_on_event;
				self.player = self.mystream.next(Event.default).play;
				self.player.debug("player");
				//Synth(\stereosampler, [\bufnum, Mdef.sample(\default,idx)])
			};
			codepad.payload_off = { arg self;
				"DSTOP".debug;
				self.record_off_event;
				//self.player[\type] = \off;
				//self.player[\latency] = 0;
				//self.player = self.player[\type] = \off;
				self.player.synth.stop;
				
			};

		};
		~scene_codepads.render_state;
	};
	~load_samplekit.(\default);

	~make_record_pads = {
		var codepad;
		var recorder;
		recorder = ~codepads.recorder;
		codepad = ~codepads.get_codepad(Point(0,7));
		codepad.payload = { arg self;
			recorder.start_recording;
		};
		codepad = ~codepads.get_codepad(Point(1,7));
		codepad.payload = { arg self;
			recorder.stop_recording;
		}; 
	};


	~event_recorder = (
		new: { arg self;
			self = self.deepCopy;
		
			
			self.recclock = TempoClock.default;
			self.recclock.debug("gnill");
			self.is_recording = false;
		
			self;
		},

		start_recording: { arg self;
			debug("start_recording");
			self.start_time = self.recclock.beats;
			self.event_score = ~make_notescore.();
			self.is_recording = true;
		},

		stop_recording: { arg self;
			debug("stop_recording");
			self.stop_time = self.recclock.beats;
			self.event_score.set_end(self.stop_time - self.start_time);
			self.is_recording = false;
		},

		add_event_on: { arg self, event;
			var time;
			if(self.is_recording) {
				time = self.recclock.beats - self.start_time;
				self.event_score.add_note(event, time, event.event_key)
			}
		},

		add_event_off: { arg self, key;
			var time;
			if(self.is_recording) {
				time = self.recclock.beats - self.start_time;
				self.event_score.book.debug("BOOK");
				self.event_score.add_noteoff(key, time)
			}
		},
	);
	~codepads.recorder = ~event_recorder.new;
	~codepads.recorder.recclock.debug("clock bordel");
	~make_record_pads.();
)

(
	~play_event_score = { arg codepads, score;
		var events = score.get_rel_notes;
		Pbind(
			\score, Pseq(events),
			\dur, Pfunc({arg ev; ev[\score][\dur]}),
			\sustain, Pfunc({arg ev; ev[\score][\sustain]}),
			//\do, Pfunc({ arg ev; ev[\score].debug("play_event_score"); })
			\type, \rest,
			\do, Pfunc({ arg ev; 
				ev[\score].debug("play_event_score"); 
				if(ev[\score][\event_key].notNil) {
					codepads.codepads[ev[\score][\event_key]].response_on;
				};
				1;
			})
		).play;
	};
	~play_event_score.(~codepads, ~codepads.recorder.event_score)
)
~codepads.recorder.event_score.get_rel_notes
