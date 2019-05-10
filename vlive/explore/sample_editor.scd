
/// first problem: can i stop playing in real time

/// non real time
(
Pdef(\part, Pdef(\long, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 500,
			\dur, 10,
			\amp, 0.1,
		),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\long2, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 600,
			\dur, 10,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\monolong, 
		Pmono(
			 \default,
			\freq, 600,
			\dur, 10,
			\amp, 0.1,
		),
)).play;
);
(
Pdef(\part, Pdef(\rawlong, 
		Pbind(
			\instrument, \default,
			\freq, 500,
			\dur, 10,
			\amp, 0.1,
		),
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pfindur(1,Pdef(\long)), // don't stop
			Pfindur(1,Pdef(\long2)),
		],1),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pfindur(1,Pdef(\rawlong)), // don't stop
			Pfindur(1,Pdef(\long2)),
		],1),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pseq([
			Pfindur(1,Pdef(\monolong)), // this stop!!!
			Pfindur(1,Pdef(\long)),
		],1),
		
	])
)).play;
);


/// but with timeline, it can cut events inside it

/// real time

Pdef(\long).play
Pdef(\long).stop // doesnt stop

Pdef(\rawlong).play
Pdef(\rawlong).stop // doesnt stop

Pdef(\monolong).play
Pdef(\monolong).stop // this stop!!!



/////////////////////////////////////////////
(
SynthDef(\sin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\def, 
	Pbind(
		\instrument, \default,
		\ctranspose, 0 + Pseq([
			4,-2,
		],inf),
		\degree, Pseq([0],inf),
		\dur, 1/2,
		\amp, 0.1,
	)
);
);

ClipTimeline(\clipy).edit
NoteTimeline(\notz, Pdef(\def))
NoteTimeline(\notz).presetCompileString.editorInsert
(
NoteTimeline('notz').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \midinote: 43.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.125, \dur: 0.375, \midinote: 49.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 0.5, \dur: 0.125, \midinote: 53.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.625, \dur: 0.375, \midinote: 60.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

////////////////////////////// display waveform

~buffer.numFrames

(
	~size = 10;
	~buffer = BufDef('voices/feynman.flac');
WindowDef(\distri, {
	var uv = UserView.new;
	var arr;
	var height = 300;
	~amp = 1;
	~buffer.loadToFloatArray(0, -1, {|data| arr= data.resamp0(1024)});
	uv.background = Color.black;
	uv.drawFunc = {
		var skipCount = 0;
		var index = 0;
		Pen.color = Color.green;
		arr.do{|y, x|
			if(skipCount == 0) {
				var p= Point(index, y*(height*~amp)+150);
				//p.debug("p");
				if(x==0, {Pen.moveTo(p)}, {Pen.lineTo(p)});
				skipCount = 0;
				index = index + 1;
			} {
				skipCount = skipCount - 1;
			}
		};
		Pen.stroke;
	};
	VLayout(
		uv
	)
}).front;
)

////////////////////////////// edit a buffer


/////////////////////////////// make a timeline view


///////////////////// /////////////////  /////////////////  /////////////////
///////////////////
/////////////////		 	SampleTimeline 				/////////////////
///////////////
/////////////  ///////////////// ///////////////// /////////////////

(
ParamProto.init;

SynthDef(\SampleTimeline_player, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, speed=1, trigger=1, loop=0, bufnum=0, startSeconds=0;
	var sig;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (startSeconds*BufSampleRate.kr(bufnum)), doneAction:2, loop: loop);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

ProtoTemplateDef(\SampleTimeline,(
	parent: ~eventTimeline,
	all: { PresetDictionary.new(\sampleTimeline) },
	eventType: \sampleTimeline,

	new: { arg self, name;
		//"so many strange".debug;

		if(self.all[name].notNil) {
			self = self.all[name]
		} {
			self = self.deepCopy;
			self.addInstance(name).init;
		};
	
		self;
	},

	init: { arg self;
		// TODO: make accept a PlayerWrapperGroup as optional argument to handle recording
		self.areasize = 10@4;
		//self.eventloop = (list: el, key: { self.key }); // fake eventloop for the moment
		self.eventloop = self.makeDefaultEventLoop;

		//self.eventFactory = ~class_player_event_factory.new;
		//self.eventFactory.eventLoop = self.eventloop;
		//self.eventFactory.mode = \note;
		//self.eventFactory.playmode = \gate;
		//self.eventFactory.fullrecord = false;

		self.quant_ref = Ref(Point(1/8,1)); // TODO: replace by Quant class and change TimelineView code
		self.proxy = EventPatternProxy.new;
		self.cursor = CursorTimeline.new;
		self.cursor.startPosition = self.eventList.startTime;
		self.tracks_bypassed = Set.new;
		//"=============clipTimeline: end init".debug;

		self;
	},

	new_load: { arg self, data;
		self = self.deepCopy;
		self.prAdd(data.name).init(data.param);
		self.eventloop = ~eventloop_loadArchiveData.(data.eventloop);
		self.eventList.reorder;
		self.areasize = data.areasize;
		self.cursor.startPosition = self.eventList.startTime;
		self.quant_ref = data.quant_ref;
		self.tracks_bypassed = data.tracks_bypassed;
		self;
	},

	asArchiveData: { arg self;
		(
			name: self.key,
			param: self.param,
			eventloop: ~eventloop_asArchiveData.(self.eventList),
			areasize: self.areasize,
			quant_ref: self.quant_ref,
			tracks_bypassed: self.tracks_bypassed,
			load: { arg me; ~clipTimeline.new_load(me) },
		)
	},

	asRefArchiveData: { arg self;
		(
			key: self.key,
			load: { arg me; ~clipTimeline.new(me.key) },
		)
	},

	bypass_track: { arg self, track_index, val=true;
		if(val) {
			self.tracks_bypassed.add(track_index);
		} {
			self.tracks_bypassed.remove(track_index);
		}
	},

	toggle_bypass_track: { arg self, track_index;
		if(self.is_track_bypassed(track_index)) {
			self.bypass_track(track_index, false)
		} {
			self.bypass_track(track_index, true)
		}
	},

	is_track_bypassed: { arg self, track_index;
		self.tracks_bypassed.includes(track_index);
	},

	bypass_pattern: { arg self, pat;
		Pcollect({ arg ev;
			//"entering pcollect".debug;
			ev = ev.copy;
			if(self.tracks_bypassed.includes(ev.use({ev.midinote}))) {
				ev[\type] = \rest;
				ev[\eventType] = nil;
				ev[\nodeType] = nil;
			};
			//"ending pcollect".debug;
			ev;
		}, pat)	
	},

	samplePattern: { arg self, startSeconds=0;
		Pmono(\SampleTimeline_player,
			\bufnum, self.buffer ? 0,
			\startSeconds, startSeconds,
			\dur, 1,
			\amp, 0.1,
		);
	},

	asPattern: { arg self, relStartTime, totalDur;
		self.proxy.source = Plazy({
			var eventlist = self.eventList;
			var xrelStartTime, xtotalDur;
			var xstartTime;

			xrelStartTime = relStartTime.value ? eventlist.relStartTime;
			xtotalDur = totalDur.value ? eventlist.totalDur;
			xstartTime = eventlist.startTime;

			[xrelStartTime, xtotalDur, xstartTime,xrelStartTime+xstartTime ].debug("sampleTimeline.asPattern: plazy: relstart, totdur");
			if(xtotalDur <= 0) {
				"ERROR: totalDur is negative or zero".postln;
				xtotalDur = 2
			};

			self.eventloop.list.changed(\cursor, \play);
			Pfindur(xtotalDur, Pembed(
				Pn(self.samplePattern(xrelStartTime+xstartTime), 1),
				xrelStartTime
			));
		}).repeat(self.repeatCount);
		self.proxy;
	},

	edit: { arg self;
		var x = ProtoTemplateDef(\SampleTimelineView).new(self);
		self.editor = { x };
		x;
	},

	asView: { arg self;
		ProtoTemplateDef(\SampleTimelineView).newView(self).makeLayout;
	},

	refCompileString: { arg self, name;
		if(name.isNil) {
			name = self.key.asCompileString
		};
		"ProtoTemplateDef(\\SampleTimeline).new(%)".format(name)
	},

	buffer_: { arg self, buffer;
		
		self[\buffer] = buffer;
		if(self.buffer.notNil) {
			self.refreshBufferData;
		}
	},

	refreshBufferData: { arg self;
		self.buffer.loadToFloatArray(0, -1, {|data| 
			var buffer = self.buffer;
			var sampleRate = buffer.sampleRate;
			var numFrames = buffer.numFrames;
			var bufferData = data;
			var resamplePerSecond = 30;
			var resampleCount = (numFrames/sampleRate*resamplePerSecond).asInteger;
			var numChannels = buffer.numChannels;
			var resample =bufferData.clump(numChannels).flop.collect(_.resamp1(resampleCount)).flop; 
			self.bufferData = bufferData; 
			self.resampledData = resample;
			self.resampleRate = resamplePerSecond;
			self.numChannels = numChannels;
			self.changed(\data);
			"loaded".debug;
		});
	},
));


ProtoTemplateDef(\SampleTimelineView, (
	parent: ~timelinePanelView,

	new: { arg self, timeline;
		//"so strange".debug;
		self = ~timelinePanelView[\new].(self, timeline.eventloop);
	
		self.timeline_model = { timeline };
		self.areasize = self.timeline_model.areasize;
		
		self.makeWindow;
	
		self;
	},

	newView: { arg self, timeline;
		self = ~timelinePanelView[\new].(self, timeline.eventloop);
	
		self.timeline_model = {timeline};
		self.areasize = self.timeline_model.areasize;
		
		//self.makeWindow;
	
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
			self.make_quant_popup,
		);
		
		self.header_layout;

	},

	make_track_header: { arg self, timeline;
		//self.track_header = View.new;
		//self.ruler_y = MidinoteTimelineRulerView.new;
		//self.track_header = self.ruler_y;
		//self.ruler_y.mimicTimeline(timeline);
		//self.ruler_y.view.minWidth_(50);
		nil
	},

	timelineClass: { arg self;
		SampleTimelineView
	},

	clipEditorNew: { arg self, model;
		~clipEditor.new(model ? self.model, self.timeline_model.eventList);
	},

	makeXRuler: { arg self;
		var cursor_timeline;
		var locatorbar;
		var ruler_x_beat;
		var ruler_x_second;
		cursor_timeline = CursorTimelineView.new;
		~cursor_timeline = cursor_timeline;
		self.cursor_timeline = cursor_timeline;
		cursor_timeline.mapCursor(self.cursor);
		cursor_timeline.quant = self.quant_ref;


		ruler_x_beat = TimelineRulerView.new;
		ruler_x_beat.mapCursor(self.cursor);
		ruler_x_beat.quant = self.quant_ref;
		self.ruler_x_beat = ruler_x_beat;

		ruler_x_second = TimelineSecondRulerView.new;
		ruler_x_second.mapCursor(self.cursor);
		ruler_x_second.quant = self.quant_ref;
		self.ruler_x_second = ruler_x_second;

		locatorbar = TimelineLocatorBarView.new;
		self.locatorbar = locatorbar;

		locatorbar.quant = self.quant_ref;

		ruler_x_beat.mimicTimeline(self.timeline);
		ruler_x_second.mimicTimeline(self.timeline);
		locatorbar.mimicTimeline(self.timeline);
		cursor_timeline.mimicTimeline(self.timeline);

		self.locatorbar.view.minSize = Point(10,15);
		self.ruler_x_beat.view.minSize = Point(10,10);
		self.ruler_x_second.view.minSize = Point(10,10);

		//ruler_x_second.mygrid = { arg thi;
			//14.do { arg x;
				//Pen.line(
					//thi.secondPointToPixelPoint(Point(x,0)).debug("dd"++x),
					//thi.secondPointToPixelPoint(Point(x,20))
				//);
				//Pen.stroke;
			//}

		//};
		
		VLayout(
			locatorbar.view,
			self.ruler_x_second.view,
			self.ruler_x_beat.view,
		);
	},

	makeLayout: { arg self;
		var clipEditor;
		//"clipTimelinePanelView.makeLayout: start init".debug;

		self[\makeVelocityView] = {}; // disable velocity view
		self.layout = VLayout(
			//HLayout(
			//	PlayerWrapperView(Pdef(self.eventloop.key)).view,
			//	XSimpleButton.new.label_("yep"),
			//),
			[~timelinePanelView[\makeLayout].(self), stretch:1],
		);
		//"clipTimelinePanelView.makeLayout: part 2".debug;
		//"clipTimelinePanelView.makeLayout: part 3".debug;
		self.timeline.view.onChange(self.eventloop, \list, { 
			{
				self.refresh;
			}.defer
		});
		self.timeline.view.onChange(self.timeline_model, \data, { 
			{
				"hey!! changed data".debug;
				self.timeline.resampleRate = self.timeline_model.resampleRate;
				self.timeline.numChannels = self.timeline_model.numChannels;
				[self.timeline.numChannels, self.timeline_model.numChannels].debug("A23");
				self.timeline.bufferData = self.timeline_model.resampledData;
				self.refresh;
			}.defer
		});
		self.timeline_model.changed(\data);
		//"clipTimelinePanelView.makeLayout: end init".debug;
		self.timeline.keyDownAction = self.getTimelineKeyDownAction;
		self.layout;
	},
));
)

///////////////// ///////////////// ///////////////// /////////////////
///////////////// ///////////////// ///////////////// /////////////////
///////////////// ///////////////// ///////////////// /////////////////

~p = ProtoClass(())
~p.numChannels  = 3
~p.numChannels
~t = 2; TempoClock.default.tempo = ~t;
~t = 185/4/60; TempoClock.default.tempo = ~t;
1/~t
(
//ProtoDef(\st, ProtoTemplateDef(\SampleTimeline).new(\st));
ProtoDef.all[\st] = ProtoTemplateDef(\SampleTimeline).new(\st);
ProtoDef(\st).buffer = BufDef('voices/feynman.flac');
ProtoDef(\st).edit;
)
ProtoDef(\st).eventList.startTime
ProtoDef(\st).asPatternEvent
ProtoDef(\st).play
ProtoDef(\st).buffer.sampleRate
ProtoDef(\st).buffer.numFrames
ProtoDef(\st).buffer
ProtoDef(\st).buffer.loadToFloatArray(0, -1, {|data| ProtoDef(\st).bufferData = data; "loaded".debug;});

(
	{

		var buffer = ProtoDef(\st).buffer;
		var sampleRate = ProtoDef(\st).buffer.sampleRate;
		var numFrames = ProtoDef(\st).buffer.numFrames;
		var bufferData = ProtoDef(\st).bufferData;
		var resamplePerSecond = 30;
		var resampleCount = numFrames/sampleRate*resamplePerSecond;
		var numChannels = buffer.numChannels;
		var resample =bufferData.resamp1(resampleCount).clump(numChannels); 
		~sampleTimelineView_draw = { arg thi;
			//Pen.color = Color.green;
			var height = thi.bounds.height;
			var width = thi.bounds.width;
			var drawChannel = { arg chanidx, chandata;
				var drawWave = { arg yfac=1;
					chandata.do{|y, x|
						var p;
						var offset = chanidx*2+1;
						y = y[chanidx] ? 0;
						y = y * 2;
						p = thi.secondPointToPixelPoint(Point(x/resamplePerSecond,y*yfac+offset));
						//p.debug("p");
						if(x==0, {Pen.moveTo(p)}, {Pen.lineTo(p)});
					};
				};
				Pen.width = 1;

				drawWave.(1);
				Pen.color = Color.black;
				Pen.fill;

				//drawWave.(1);
				//Pen.color = Color.blue;
				//Pen.stroke;

				drawWave.(-1);
				Pen.color = Color.black;
				Pen.fill;

				//drawWave.(-1);
				//Pen.color = Color.blue;
				//Pen.stroke;
			};
			~this = thi;
			numChannels.do { arg idx;
				drawChannel.(idx, resample);
			};

		}
	}.value;
)
~this.bounds.width
UserView


(
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(\SampleTimeline_player,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);


///////////// integration to ClipTimeline



(
ClipTimeline('inte').eventList = XEventList.newFrom([
	(\absTime: 0.0, \dur: 1.0, \label: 'start', \playDur: 1.0, \relDur: 1.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.0, \dur: 3.0, \midinote: 1.0, \playDur: 3.0, \relDur: 3.0, \sustain: 2.25, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

ProtoDef.all[\st] = ProtoTemplateDef(\SampleTimeline).new(\st);
ProtoDef(\st).buffer = BufDef('voices/feynman.flac');
ProtoTemplateDef(\SampleTimeline).new('st').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 20.0, \label: 'start', \playDur: 20.0, \relDur: 20.0, \sustain: 0, \type: 'start', ),
	(\absTime: 20.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

/////////////////

ClipTimeline(\inte).edit
ProtoDef(\st).edit;
ClipTimeline(\inte).presetCompileString.editorInsert


ProtoDef(\st).presetCompileString.editorInsert

ProtoTemplateDef(\SampleTimeline).all
ProtoTemplateDef(\SampleTimeline)[\parent].keys
ProtoDef(\st, ProtoTemplateDef(\SampleTimeline).new(\st)); ProtoDef(\st) == ProtoTemplateDef(\SampleTimeline).all[\st]
ProtoDef.all[\st] = ProtoTemplateDef(\SampleTimeline).new(\st)
ProtoDef(\st)
\df_df
ProtoDef(\st).edit
ProtoDef(\st).edit
ProtoTemplateDef(\SampleTimeline).all[\st].edit
ProtoTemplateDef(\SampleTimeline).all[\bla] = nil
ProtoTemplateDef(\SampleTimeline).all
ProtoTemplateDef(\SampleTimeline).parent.prAdd(\tui)
ProtoTemplateDef(\SampleTimeline).new(\rah)
ProtoDef.all == ProtoTemplateDef.all
ProtoDef.all
ProtoDef.all[\bleu] = 666
ProtoTemplateDef.all[\bleu] = 666
ProtoTemplateDef(\vert, (val:777))
ProtoTemplateDef.all.keys.collect(_.postln)

ProtoTemplateDef(\bla, (rah:3))
ProtoTemplateDef(\bla, (rah:3)).keys
ProtoTemplateDef(\bla).rah

ProtoDef(\bla, (rah:3))
ProtoDef(\bla, (rah:3)).keys
ProtoDef(\bla).rah
ProtoTemplateDef(\SampleTimeline).new(\sti)
ProtoTemplateDef(\SampleTimeline).keys


/////////////////// record
ClipTimeline(\inte).eventList.print
(
	ProtoTemplateDef(\SampleClipTimelineRecorder, (
		isRecording: false,
		init: { arg self, timeline;
			"ini".debug;
			self.recorder = Recorder(Server.default);
			self.drawTask = TaskProxy.new;
			self.tempoClock = TempoClock.default;
			self.tempoClock.debug("clock");
			self.timeline = timeline;

			self;
		},
		startRecording: { arg self;
			var name = "rec_%".format(Date.localtime.stamp);
			var clip;
			var ev;
			var tl = self.timeline;
			if(self.isRecording == false) {
				self.isRecording = true;

				clip = ProtoTemplateDef(\SampleTimeline).new(name.asSymbol);
				ev = clip.asPatternEvent;
				self.recordedEvent = ev;
				self.recordedClip = clip;
				self.recordName = name;
				ev[\absTime] = tl.selection_cursor.startPosition !? _.x ? 0;
				ev[\sustain] = 1/2;
				ev[\midinote] = tl.selection_cursor.startPosition !? _.y ? 0;
				tl.eventList.addEvent(ev);
				tl.eventList.reorder;
				self.startRecordingTime = self.tempoClock.beats;
				self.drawTask.source = {
					inf.do { arg idx;
						1.wait;
						ev[\sustain] = idx + 1;
						ev.changed(\refresh);
					}
				};
				self.drawTask.play;
				self.filename = "/tmp/%.wav".format(name);
				self.recorder.record(path:self.filename, numChannels:2);
			} {
				"Already recording".debug;
			}

		},
		stopRecording: { arg self;
			if(self.isRecording == true) {
				self.isRecording = false;

				self.drawTask.stop;
				self.recorder.stopRecording;
				self.recordedDuration = self.tempoClock.beats - self.startRecordingTime;
				self.recordedEvent[\sustain] = self.recordedDuration;
				self.recordedEvent.changed(\refresh);
				{
					self.recordedClip.buffer = BufDef(self.filename.asSymbol);
					self.recordedClip.eventList.setEndPosition(self.recordedDuration);
				}.defer(2);
			} {
				"Was not recording".debug;
			}
		},

	));

)
ClipTimeline(\inte).edit
ProtoTemplateDef(\SampleTimeline).new(~rec.recordName.asSymbol).edit
	~rec = ProtoTemplateDef(\SampleClipTimelineRecorder).init(ClipTimeline(\inte));
	~rec.clock
	~rec.startRecording;
	~rec.stopRecording;
	~rec.filename.editorInsert
~rec.recordedClip.buffer = BufDef('/tmp/rec_190510_011504.wav').play
~rec.recordedClip.eventType

	~rec.recordedClip.buffer
	~rec.recordedClip.refreshBufferData
	~rec.recordedClip.edit

	(
	~rec.recordedClip.buffer.loadToFloatArray(0, -1, {|data| 
			var self = ~rec.recordedClip;
			var buffer = self.buffer;
			var sampleRate = buffer.sampleRate;
			var numFrames = buffer.numFrames;
			var bufferData = data;
			var resamplePerSecond = 30;
			var resampleCount = (numFrames/sampleRate*resamplePerSecond).asInteger;
			var numChannels = buffer.numChannels;
			//var resample =bufferData.resamp1(resampleCount).clump(numChannels); 
			//self.bufferData = bufferData; 
			//self.resampledData = resample;
			//self.resampleRate = resamplePerSecond;
			//self.numChannels = numChannels;
			//self.changed(\data);
			//"loaded".debug;
		});
	)
~record.()
TempoClock.default
{ SinOsc.ar(700 * ( SinOsc.ar(100.2 * ( SinOsc.kr(0.2) * 1 + 1 )) * 0.5 + 1 ) * ( SinOsc.ar(XLine.kr(1,10000,50)) * 1 + 1 )) ! 2 * 0.1}.play;

(
ClipTimeline('inte').eventList = XEventList.newFrom([
	(\absTime: 0.0, \dur: 1.0, \label: 'start', \playDur: 1.0, \relDur: 1.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.0, \dur: 1.0, \midinote: 1.0, \playDur: 1.0, \relDur: 1.0, \sustain: 2.25, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 2.0, \dur: 8.0, \eventType: 'timeline', \midinote: 3.0, \playDur: 8.0, \relDur: 8.0, \sustain: 7.7695562150002, \timeline: { ProtoTemplateDef(\SampleTimeline).new('rec_190510_011504') }, )),
	(\absTime: 10.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

ProtoTemplateDef(\SampleTimeline).new(\niark).edit
ProtoTemplateDef(\SampleTimeline).new(\tt).buffer = ~rec.recordedClip.buffer

(
ClipTimeline('inte').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 1.0, \label: 'start', \playDur: 1.0, \relDur: 1.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.0, \dur: 5.875, \eventType: 'timeline', \midinote: 2.0, \playDur: 5.875, \relDur: 5.875, \sustain: 13.680008571, \timeline: { ProtoTemplateDef(\SampleTimeline).new('rec_190510_015926') }, )),
	(\absTime: 6.875, \dur: 10.25, \midinote: 1.0, \playDur: 10.25, \relDur: 10.25, \sustain: 1.25, ),
	(\absTime: 17.125, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

ClipTimeline(\inte).presetCompileString.editorInsert
(
ClipTimeline('inte').eventList = XEventList.newFrom([
	(\absTime: 0.0, \dur: 0.125, \label: 'start', \playDur: 0.125, \relDur: 0.125, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.125, \dur: 3.875, \midinote: 0.0, \playDur: 3.875, \relDur: 3.875, \sustain: 11.252750944, \timeline: { ProtoTemplateDef(\SampleTimeline).new('rec_190510_024337') }, )),
	PatternEvent((\absTime: 5.625, \dur: 0, \midinote: 1.0, \playDur: 0, \relDur: 0, \sustain: 2.25, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
]);
);
	(\absTime: 4.0, \dur: 1.625, \label: 'end', \playDur: 1.625, \relDur: 1.625, \type: 'end', ),
	PatternEvent((\absTime: 0.125, \dur: 3.875, \midinote: 0.0, \playDur: 3.875, \relDur: 3.875, \sustain: 11.252750944, \timeline: { ProtoTemplateDef(\SampleTimeline).new('rec_190510_024337') }, )).type

(
ClipTimeline('inte').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 1.375, \label: 'start', \playDur: 1.375, \relDur: 1.375, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.375, \dur: 10.625, \eventType: 'timeline', \midinote: 2.0, \playDur: 10.625, \relDur: 10.625, \sustain: 19.065545584, \timeline: { ProtoTemplateDef(\SampleTimeline).new('rec_190510_022621') }, )),
	PatternEvent((\absTime: 12.0, \dur: 8.625, \midinote: 0.0, \playDur: 8.625, \relDur: 8.625, \sustain: 15.625, \timeline: { ProtoTemplateDef(\SampleTimeline).new('tt') }, \type: 'pattern', )),
	PatternEvent((\absTime: 20.625, \dur: 12.75, \midinote: 1.0, \playDur: 12.75, \relDur: 12.75, \sustain: 6.75, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	(\absTime: 33.375, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

	PatternEvent((\absTime: 1.375, \dur: 10.625, \eventType: 'timeline', \midinote: 2.0, \playDur: 10.625, \relDur: 10.625, \sustain: 19.065545584, \timeline: { ProtoTemplateDef(\SampleTimeline).new('rec_190510_022621') }, )),
	PatternEvent((\absTime: 12.0, \dur: 8.625, \midinote: 0.0, \playDur: 8.625, \relDur: 8.625, \sustain: 15.625, \timeline: { ProtoTemplateDef(\SampleTimeline).new('tt') }, \type: 'pattern', )),

	ClipTimeline(\inte).eventList[1].type = \pattern
