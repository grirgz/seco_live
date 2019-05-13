
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

//// moved to Param/Proto/timeline_sample.scd


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
ProtoDef.all[\st2] = ProtoTemplateDef(\SampleTimeline).new(\st2);
ProtoDef(\st2).buffer = BufDef('voices/feynman.flac');
ProtoTemplateDef(\SampleTimeline).new('st').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 20.0, \label: 'start', \playDur: 20.0, \relDur: 20.0, \sustain: 0, \type: 'start', ),
	(\absTime: 20.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
)

(
ClipTimeline('inte').eventList = XEventList.newFrom([
	(\absTime: 0.0, \dur: 1.0, \label: 'start', \playDur: 1.0, \relDur: 1.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.0, \dur: 3.0, \midinote: 1.0, \playDur: 3.0, \relDur: 3.0, \sustain: 2.25, \timeline: { SampleTimeline('st') }, \type: 'pattern', )),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

SampleTimeline(\st).buffer = BufDef('voices/feynman.flac');
SampleTimeline(\st).eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 20.0, \label: 'start', \playDur: 20.0, \relDur: 20.0, \sustain: 0, \type: 'start', ),
	(\absTime: 20.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);

);


/////////////////
SampleTimeline(\st).buffer = BufDef('voices/feynman.flac');
ClipTimeline.all.keys

ClipTimeline(\inte).edit
ClipTimeline(\inte).proxy.reset;
ClipTimeline(\inte).proxy.play;
ClipTimeline(\inte).asSelectedPattern
1.2.trunc(0.1)

NoteTimeline(\bla).edit
NoteTimeline(\bla).presetCompileString.editorInsert
(
NoteTimeline('bla').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \midinote: 76.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 0.125, \dur: 0.375, \midinote: 62.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.25, ),
	(\absTime: 0.5, \dur: 0.375, \midinote: 66.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 0.875, \dur: 0.125, \midinote: 49.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.25, \midinote: 71.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.25, \dur: 0.125, \midinote: 74.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.375, \dur: 0.125, \midinote: 101.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.5, \dur: 0.25, \midinote: 101.0, \playDur: 0.25, \relDur: 0.25, \sustain: 0.1, ),
	(\absTime: 1.75, \dur: 0.375, \midinote: 79.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 2.125, \dur: 0.75, \midinote: 84.0, \playDur: 0.75, \relDur: 0.75, \sustain: 0.1, ),
	(\absTime: 2.875, \dur: 0.5, \midinote: 89.0, \playDur: 0.5, \relDur: 0.5, \sustain: 0.1, ),
	(\absTime: 3.375, \dur: 0.375, \midinote: 93.0, \playDur: 0.375, \relDur: 0.375, \sustain: 0.1, ),
	(\absTime: 3.75, \dur: 0.125, \midinote: 99.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 3.875, \dur: 0.125, \midinote: 61.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

SampleTimeline(\st).edit;
SampleTimeline(\st).cursor.endPoint
SampleTimeline(\st).selection_cursor.endPoint
SampleTimeline(\st).clear
ProtoTemplateDefProtoDef(\st).clear
"".beginsWith("")
ClipTimeline(\inte).presetCompileString.editorInsert
(
ClipTimeline('inte').eventList = XEventList.newFrom([
	(\absTime: 0.0, \dur: 0.5, \label: 'start', \playDur: 0.5, \relDur: 0.5, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.5, \dur: 0.125, \event_dropdur: 1.625, \midinote: 5.0, \playDur: 0.125, \relDur: 0.125, \sustain: 3.0, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.625, \dur: 0.125, \event_dropdur: 1.625, \midinote: 3.0, \playDur: 0.125, \relDur: 0.125, \sustain: 3.0, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.75, \dur: 0.125, \event_dropdur: 1.625, \midinote: 4.0, \playDur: 0.125, \relDur: 0.125, \sustain: 3.0, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 0.875, \dur: 0.125, \event_dropdur: 0.75, \midinote: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 3.375, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 1.0, \dur: 1.625, \midinote: 1.0, \playDur: 1.625, \relDur: 1.625, \sustain: 0.75, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 2.625, \dur: 0.0, \event_dropdur: 1.625, \midinote: 6.0, \playDur: 0.0, \relDur: 0.0, \sustain: 3.0, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 2.625, \dur: 1.0, \event_dropdur: 1.625, \midinote: 1.0, \playDur: 1.0, \relDur: 1.0, \sustain: 0.625, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 3.625, \dur: 0.625, \midinote: 1.0, \playDur: 0.625, \relDur: 0.625, \sustain: 2.25, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 4.25, \dur: 0.5, \event_dropdur: 1.625, \midinote: 4.0, \playDur: 0.5, \relDur: 0.5, \sustain: 3.0, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 4.75, \dur: 3.25, \event_dropdur: 4.625, \midinote: 2.0, \playDur: 3.25, \relDur: 3.25, \sustain: 1.25, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);


UserView

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

Rect.fromPoint(Point(1,1), Point())
Rect(10,10,2,2).rightBottom
Rect(10,10,2,2).left
Rect(10,10,-2,-2).rightBottom
Rect(10,10,-2,-2).left
							(
							~getLeftTop = { arg rect;
								var x = rect.origin.x;
								var y = rect.origin.y;
								if(rect.height < 0) {
									y = rect.origin.y + rect.height;
								};
								if(rect.width < 0) {
									x = rect.origin.x + rect.width;
								};
								Point(x,y)
							};
							~realRightBottom = { arg rect;
								var x = rect.rightBottom.x;
								var y = rect.rightBottom.y;
								if(rect.height < 0) {
									y = rect.rightBottom.y - rect.height;
								};
								if(rect.width < 0) {
									x = rect.rightBottom.x - rect.width;
								};
								Point(x,y)
							};
							~getLeftTop.(Rect(10,10,2,2));
							~getLeftTop.(Rect(10,10,-2,-2));
							~getLeftTop.(Rect(10,10,-2,2));
							~getLeftTop.(Rect(10,10,2,-2));

							~realRightBottom.(Rect(10,10,2,2));
							~realRightBottom.(Rect(10,10,-2,-2));
							~realRightBottom.(Rect(10,10,-2,2));
							~realRightBottom.(Rect(10,10,2,-2));
							)

ProtoTemplateDef(\bla, (rah:3))
ProtoTemplateDef(\bla, (rah:3)).keys
ProtoTemplateDef(\bla).rah

ProtoDef(\bla, (rah:3))
ProtoDef(\bla, (rah:3)).keys
ProtoDef(\bla).rah
ProtoTemplateDef(\SampleTimeline).new(\sti)
ProtoTemplateDef(\SampleTimeline).keys


/////////////////// record

ClipTimeline(\inte).edit
ClipTimeline(\inte)
ClipTimeline(\inte).recorder = 1
ClipTimeline(\inte).recorder.startRecording
ClipTimeline(\inte).recorder.stopRecording
ClipTimeline(\inte).clear
1+1
ClipTimeline(\inte).eventList.print
(

)
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
	(\absTime: 0.0, \dur: 1.0, \label: 'start', \playDur: 1.0, \relDur: 1.0, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 1.0, \dur: 0.0, \midinote: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 3.25, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 1.0, \dur: 0.875, \midinote: 1.0, \playDur: 0.875, \relDur: 0.875, \sustain: 0.875, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 1.875, \dur: 1.0, \event_dropdur: 0.875, \midinote: 1.0, \playDur: 1.0, \relDur: 1.0, \sustain: 1.0, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	PatternEvent((\absTime: 2.875, \dur: 1.125, \event_dropdur: 1.875, \midinote: 1.0, \playDur: 1.125, \relDur: 1.125, \sustain: 1.375, \timeline: { ProtoTemplateDef(\SampleTimeline).new('st') }, \type: 'pattern', )),
	(\absTime: 4.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

TempoClock.default.tempo


//////////////////// play now
(
Pdef(\part, Pdef(\testme, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq((0..27).mirror,inf),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
));
);
Pdef(\part).clear;
Pdef(\part).play
Pdef(\part).play(quant:0, doReset:true)
Pdef(\part).reset; Pdef(\part).play(quant:0)

"~/.local/share/SuperCollider/Extensions/param/Proto/timeline.scd".standardizePath.load
SampleTimeline(\st).asSelectedPattern
ClipTimeline(\bla10).edit
ClipTimeline(\bla10).quant = nil;
ClipTimeline(\bla10).clear
ClipTimeline(\bla10).proxy.stop
ClipTimeline(\bla10).proxy.reset
ClipTimeline(\bla10).proxy.play;
ClipTimeline(\bla10).proxy.quant
ClipTimeline(\bla10).proxy.quant = 0
ClipTimeline(\bla10).proxy.stop; ClipTimeline(\bla10).proxy.play;
ClipTimeline(\bla10).proxy.clear
ClipTimeline(\bla10).presetCompileString.editorInsert
(
ClipTimeline('bla10').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.5, \label: 'start', \playDur: 0.5, \relDur: 0.5, \sustain: 0, \type: 'start', ),
	PatternEvent((\absTime: 0.5, \dur: 7.5, \midinote: 2.0, \pattern: Pdef('testme'), \playDur: 7.5, \relDur: 7.5, \sustain: 5.5, \type: 'pattern', )),
	(\absTime: 8.0, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

ClipTimeline(\bla10).eventList.addEvent((bla:3, \absTime:100))
ClipTimeline(\bla10).eventList.reorder
ClipTimeline(\bla10).eventList


/////////// Pmono doesnt stop

(
Pdef(\momo, 
	Pmono(\SampleTimeline_player,
		\bufnum, BufDef('voices/feynman.flac'),
		\dur, 1,
		\gain, 0.1,
		\amp, 0.1,
	),
).play;
);

Pdef(\momo).play
Pdef(\momo).reset // no bug
Pdef(\momo).play(quant:0, doReset:true) // pmono doesnt stop
Pdef(\momo).stop; Pdef(\momo).play(quant:0) // pmono doesnt stop


/////////////
 PatKitDef(\kd).edit
 PatKitDef(\kd).presetCompileString.editorInsert // not working!
 // TOOD: change ~ppg and do something for default buffer
(
~ppg.targets = [
	StepEvent.newFrom((pos: 3.5007029478458, instrument: 'playersecmax', bufnum: Buffer.new, maxsustain: 0.22091373939148, sustain: 0.16249433106576)),
	StepEvent.newFrom((pos: 3.0662585034014, instrument: 'playersecmax', bufnum: Buffer.new, maxsustain: 0.22091373939148, sustain: 0.22630385487528)),
	StepEvent.newFrom((pos: 4.3849206349206, instrument: 'playersecmax', bufnum: Buffer.new, maxsustain: 0.41648648066795, sustain: 0.20446712018141)),
	nil,
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('com/Kick/Kick Alkaloid 4 V2.wav'))),
];
);

(
PatKitDef(\kd).targets = [
	StepEvent.newFrom((pos: 3.5007029478458, instrument: 'playersecmax', bufnum: Buffer.new, maxsustain: 0.22091373939148, sustain: 0.16249433106576)),
	StepEvent.newFrom((pos: 3.0662585034014, instrument: 'playersecmax', bufnum: Buffer.new, maxsustain: 0.22091373939148, sustain: 0.22630385487528)),
	StepEvent.newFrom((pos: 4.3849206349206, instrument: 'playersecmax', bufnum: Buffer.new, maxsustain: 0.41648648066795, sustain: 0.20446712018141)),
];
);

 FileSystemProject.load("libdef/drumkit.scd")
 FileSystemProject.load("libdef/synthplayrec.scd")
KitTimeline(\mkit, PatKitDef(\kd)).edit
KitTimeline(\mkit2, PatKitDef(\kd)).edit
KitTimeline(\mkit).presetCompileString.editorInsert
(
KitTimeline('mkit').eventList = XEventList.newFrom([
	(\absTime: 0, \dur: 0.0, \label: 'start', \playDur: 0.0, \relDur: 0.0, \sustain: 0, \type: 'start', ),
	(\absTime: 0.0, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 0.125, \dur: 0.125, \kitIndex: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.0625, ),
	(\absTime: 0.25, \dur: 0.0, \kitIndex: 0.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.25, ),
	(\absTime: 0.25, \dur: 0.125, \kitIndex: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.375, \dur: 0.125, \kitIndex: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.0625, ),
	(\absTime: 0.5, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 0.625, \dur: 0.125, \kitIndex: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 0.75, \dur: 0.125, \kitIndex: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.0625, ),
	(\absTime: 0.875, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.0, \dur: 0.0, \kitIndex: 2.0, \playDur: 0.0, \relDur: 0.0, \sustain: 0.0625, ),
	(\absTime: 1.0, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.125, ),
	(\absTime: 1.125, \dur: 0.125, \kitIndex: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.0625, ),
	(\absTime: 1.25, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 1.375, \dur: 0.125, \kitIndex: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.0625, ),
	(\absTime: 1.5, \dur: 0.125, \kitIndex: 1.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.25, ),
	(\absTime: 1.625, \dur: 0.125, \kitIndex: 2.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.0625, ),
	(\absTime: 1.75, \dur: 0.125, \kitIndex: 0.0, \playDur: 0.125, \relDur: 0.125, \sustain: 0.1, ),
	(\absTime: 1.875, \dur: 6.125, \kitIndex: 2.0, \playDur: 6.125, \relDur: 6.125, \sustain: 0.125, ),
	(\absTime: 8, \dur: 0, \label: 'end', \playDur: 0, \relDur: 0, \type: 'end', ),
]);
);

