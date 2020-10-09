(
WindowDef(\SoundObjectView, { arg def, model;
		var player;
		var win, sf, sfview;
		var post_position;
		var vlayout;
		var zoom_slider;
		var task;
		var playerkey = \smpslicerplayer;
		var path;
		var positions;
		var compute_params;
		var controller;
		var asPresetCompileString;
		var update_selection;
		var sampleRate = s.sampleRate;
		var clock = TempoClock.default;
		var startParam = model.startParam;
		var sustainParam = model.sustainParam;
		var endParam = model.endParam;
		var speedParam = model.speedParam;
		var lengthParam = model.lengthParam;
		var file = model.buffer;
		var play_buffer;
		vlayout = VLayout.new;
		sfview = SoundFileView.new;

		sfview.onChange(model, \buffer, {
			"received buffer change!".debug(model.buffer);
			"received buffer change!".debug(model.buffer);
			"received buffer change!".debug(model.buffer);
			file = model.buffer;
			if(file.isKindOf(Buffer)) {
				path = file.path ?? { model.bufferTempPath ?? { 
					var pa;
					//"ERROR: buffer has not be saved: %".format(file);
					//BufDef(\empty, "empty.wav").path 
					pa = "/tmp/sc_tmp_buffer_%.flac".format(file.hash);
					file.write(pa);
					file.path.debug("file path after written temp file");
					model.bufferTempPath = pa;
					//file.path = pa;
					pa;
				}};
			} {
				path = file;
			};
			if(path.notNil) {
				Task({
					"x".debug;
					0.1.wait;
					sf.openRead(path);
					sfview.soundfile = sf;
					sfview.read(0, sf.numFrames);
					sfview.refresh;
					"loaded!!!!".debug(path);
				}, AppClock).play;
			} {
				file.debug("Path is nil");
			}

		}, true);


		//if(file.isKindOf(Buffer)) {
			//path = file.path ?? { 
				//var pa;
				////"ERROR: buffer has not be saved: %".format(file);
				////BufDef(\empty, "empty.wav").path 
				//pa = "/tmp/sc_tmp_buffer_%.flac".format(file.hash);
				//file.write(pa);
				//file.path = pa;
				//pa;
			//};
		//} {
			//path = file;
		//};
		if(true) {

			path.debug("soundfileview: file path");
			sf = SoundFile.new;
			zoom_slider = RangeSlider.new;
			zoom_slider.orientation = \horizontal;
			zoom_slider.action  = { arg sli;
				[\sliderLOW, sli.lo, \sliderHI, sli.hi].postln;
				sfview.zoomToFrac(sli.hi - sli.lo);
				sfview.scrollTo(sli.lo);

			};
			vlayout.add(sfview);
			vlayout.add(zoom_slider);
			//win.layout = vlayout;
			//sf.openRead(path);
			//sfview.soundfile = sf;
			//sfview.read(0, sf.numFrames);

			sfview.elasticMode = true;
			sfview.timeCursorOn = true;
			sfview.timeCursorColor = Color.red;
			sfview.timeCursorPosition = 0;
			sfview.drawsWaveForm = true;
			sfview.gridOn = false;
			sfview.gridResolution = 1;
			~sfview = sfview;

			sfview.action = {
				"yeahhh".debug;
				sfview.scrollPos.debug("scrollPos");
			};

			sfview.currentSelection = 1;
			sfview.setSelectionColor(1, ParamViewToolBox.color_ligth);

			post_position = { 
				var cur;
				cur = sfview.selections[sfview.currentSelection];
				// cur = [start, size] in frames
				positions = [
					cur++(cur[0]+cur[1]),
					cur++(cur[0]+cur[1]) / s.sampleRate,
					cur++(cur[0]+cur[1]) / sf.numFrames,
				];
				"Current selection is now [start, size, end]:\nframes: %\nseconds: %\nnormalized: %".format(
					*positions
				).postln;
			};
			post_position.();

			// init selection
			update_selection = {
				var sustain = if(sustainParam.notNil) {
					sustainParam.get / clock.tempo * sampleRate;
				} {
					endParam.get - startParam.get * sampleRate;
				};
				var start = startParam.get * sampleRate;
				(
					[startParam.get, sustainParam.get, startParam.get + sustainParam.get] 
					++ ( [startParam.get, sustainParam.get, startParam.get + sustainParam.get] * sampleRate)
					++ ( [
						( startParam.get + sustainParam.get * sampleRate ) - ( startParam.get * sampleRate ), 
						( startParam.get + sustainParam.get * sampleRate ) - ( startParam.get * sampleRate ) / sampleRate, 
					])
				).debug("start, sus, end, srstart, srsus, srend");
				sfview.setSelection(sfview.currentSelection, [start, lengthParam.get * sampleRate]);
			};
			update_selection.();

			asPresetCompileString = {
				//"Pbind(\n%%%);".format(
				//	"\t'instrument', \\playersec,\n",
				//	"\t'bufnum', BufDef(%),\n".format(bufdef.key.asCompileString),
				//	[\pos, \speed, \sustain, \dur, \gain].collect({ arg key;
				//		"\t%, %,\n".format(key.asCompileString, ( Pdef(playerkey).get(key) ? 1 ).asCompileString )
				//	}).join;
				//).pbcopy;
			};

			compute_params = {
				var speed;
				var sustain;
				var dur;
				speed = if(speedParam.notNil) {
					speedParam.get;
				} {
					1
				};
				if(startParam.notNil) {
					startParam.set( if(speed < 0) {
						positions[1][2]
					} {
						positions[1][0];
					});
				};
				lengthParam.set(positions[1][1]);
				sustain = positions[1][1] / speed.abs * clock.tempo ;
				if(sustain == 0) {
					sustain = 1;
				};
				if(sustainParam.notNil) {
					sustainParam.set(sustain);
				};
				//Pdef(playerkey).set(\dur, Pdef(playerkey).get(\sustain) * TempoClock.default.tempo);
			};

			if(speedParam.notNil) {
				speedParam.onChange({
					compute_params.();
					update_selection.();
				}, sfview);
			};

			if(startParam.notNil) {
				startParam.onChange({
					update_selection.();
				}, sfview);
			};

			if(endParam.notNil) {
				endParam.onChange({
					update_selection.();
				}, sfview);
			};

			if(sustainParam.notNil) {
				sustainParam.onChange({
					update_selection.();
				}, sfview);
			};

			sfview.mouseUpAction = { arg a;
				post_position.();
				compute_params.();
				asPresetCompileString.().postln;
			};

			play_buffer = { 
				var cur;
				var lastFrame;
				var view = sfview;
				debug("play_buffer");
				cur = view.selections[view.currentSelection];
				lastFrame = if(cur[1] == 0) { sf.numFrames } {cur[0]+cur[1]};
				if(player.notNil) {
					player.stop;
					player = nil;
				};
				player = sf.play(
					(
						firstFrame: cur[0],
						lastFrame: lastFrame
					)

				);
				if(task.notNil) {
					task.stop;
				};
				task = Task({
					var start;
					var x = 0;
					//[ sfview.timeCursorPosition, lastFrame, x, thisThread.beats , start, (thisThread.beats - start) ].debug("tc, lf, xbe, st, -");
					s.latency.wait;
					start = thisThread.beats;
					sfview.timeCursorPosition = cur[0];
					while({sfview.timeCursorPosition < lastFrame and: { x < 1000000 }}) {

						//[ thisThread.beats , start, (thisThread.beats - start) ].debug("be, st, -");
						sfview.timeCursorPosition = cur[0] + ( (thisThread.beats - start) * sf.sampleRate );
						x = x + 1;
						0.02.wait;
					};
					sfview.timeCursorPosition = cur[0];
				}).play(AppClock);
				post_position.();
			};
			model.gui_play_buffer = { 
				debug("gui_play_buffer");
				play_buffer.() 
			};

			sfview.keyDownAction = { arg view, char, modifiers, u, k; 
				var cur;
				var lastFrame;
				cur = view.selections[view.currentSelection];
				lastFrame = if(cur[1] == 0) { sf.numFrames } {cur[0]+cur[1]};
				//[char, modifiers, u, k].debug("KEYBOARD INPUT");
				if( u == 32 ) { // space
					play_buffer.();
				};
				if( u == 13 or: { char == $f }) { // Enter
					if(player.notNil) {
						task.stop;
						sfview.timeCursorPosition = cur[0];
						task = nil;
						player.stop;
						player = nil;
					};
					post_position.();
				}
			};

			if(def.window.notNil) {
				def.window.view.keyDownAction = { arg view, char, modifiers, u, k; 
					//[char, modifiers, u, k].debug("KEYBOARD INPUT");
					if( u == 27 ) { // Esc
						if(player.notNil) {
							player.stop;
							player = nil;
						};
						view.close();
					};
				};
			};
		};
		sfview
});
);

(
WindowDef(\BufferEditor, { arg def, buf;

	var params;
	var bufferPathText, bufferTempPathText;
	var saveButton;
	var model = (
		startValue: 0,
		sustainValue: 0.12,
		lengthValue: buf.numFrames/buf.sampleRate,
		endValue: 1,
		buffer: buf, // path is reset when buffer content is changed
		bufferPath: buf.path, // this is the original path of the buffer
		bufferTempPath: nil, // this temporary path is written each time the buffer is saved to disk to render, also reset on change
			// if buffer.path was used, no way to differentiate temp path to original path
		isModified: buf.path == nil,

		bufferPath_: { arg self, val;
			self[\bufferPath] = val;
			self.changed(\bufferPath)
		},
		bufferTempPath_: { arg self, val;
			self[\bufferTempPath] = val;
			self.changed(\bufferTempPath)
		},
		isModified_: { arg self, val;
			self[\isModified] = val;
			self.changed(\isModified)
		},
	);
	model.startParam = { Param(Message(model), \startValue) };
	model.sustainParam = { Param(Message(model), \sustainValue) };
	model.endParam = { Param(Message(model), \endValue) };
	model.lengthParam = { Param(Message(model), \lengthValue, ControlSpec(0,model.buffer.numFrames/model.buffer.sampleRate,\lin)) };
	params = #[startParam, lengthParam].collect({ arg n; model[n].value; });// FIXME: removed endParam because not bound in SoundObjectView yet

	bufferPathText = StaticText.new;
	bufferPathText.followChange(model, \bufferPath, {
		bufferPathText.string = model.bufferPath;
	});
	bufferTempPathText = StaticText.new;
	bufferTempPathText.followChange(model, \bufferTempPath, {
		bufferTempPathText.string = model.bufferTempPath;
	});
	saveButton = BasicButton.new.string_("Save").action_({
		WindowDef(\filedialog_save).front(model.bufferPath, { arg dir, name;
			var fpath = dir +/+ name;
			fpath.debug("saving buffer to file");
			model.buffer.write(fpath);
			model.bufferPath = fpath;
			model.buffer.path = fpath;
			model.bufferTempPath = nil;
			model.isModified = false;
		})


	});
	saveButton.followChange(model, \isModified, {
		defer {
			saveButton.background = if(model.isModified) {
				Color.red;
			} {
				Color.white;
			}
		}
	});


	VLayout (
		HLayout (
			BasicButton.new.string_("Play").action_({
				model.gui_play_buffer;
			}),
			BasicButton.new.string_("Reverse").action_({
				"ém".debug;
				buf.loadToFloatArray(action:{ arg arr;
					"ém1".debug;
					arr = arr.reverse;
					buf.loadCollection(arr, action:{
						model.bufferTempPath = nil;
						model.changed(\buffer);
						model.isModified = true;
						"reversing and loading done".debug;
					})
				})
			}),
			BasicButton.new.string_("Reverse selected"),
			saveButton,
			BasicButton.new.string_("Load"),
			BasicButton.new.string_("Open"),
			BasicButton.new.string_("Copy"),
			BasicButton.new.string_("Paste"),
			BasicButton.new.string_("Export selected").action_({
				var exportedFrameCount = (model.lengthValue * model.buffer.sampleRate);
				var newbuf;
				exportedFrameCount = exportedFrameCount.clip(0, model.buffer.numFrames -(model.startValue*model.buffer.sampleRate));
				exportedFrameCount.debug("exportedFrameCount");
				[model.startValue, model.lengthValue, model.buffer.numChannels].debug("start end chan");
				newbuf = Buffer.alloc(Server.default, exportedFrameCount+1, model.buffer.numChannels);
				model.buffer.debug("now getting slice");
				model.buffer.loadToFloatArray(model.startValue* model.buffer.sampleRate, exportedFrameCount, { arg col;
					col.size.debug("got colsize");
					newbuf.debug("now loading in newbuf");
					newbuf.loadCollection(col, action: { arg xbuf;
						newbuf.debug("newbuf loaded slice");
						xbuf.debug("xbuf loaded slice");
						{
							newbuf.debug("newbuf loaded slice2");
							xbuf.debug("xbuf loaded slice2");
							~newbuf = newbuf;
							WindowDef("%_%".format("BufferEditor", 100000000.rand).asSymbol, WindowDef(\BufferEditor)).front(newbuf);
						}.defer
					})
				});
			}),
			BasicButton.new.string_("Clipboard").action_({
				"% %".format(model.buf.asCompileString, model.bufferPath).pbcopy
			}),
		),
		WindowDef(\SoundObjectView).asView(model),
		VLayout (*
			[
				HLayout(
					StaticText.new.string_("Buffer path:").fixedWidth_(100), 
					bufferPathText
				),
				HLayout(
					StaticText.new.string_("Buffer temp path:").fixedWidth_(100),
					bufferTempPathText
				),
			] ++
			params.collect({ arg param;
				var hs = ParamViewToolBox.horizontal_slider(param);
				hs.label.fixedWidth_(100);
				hs;
			}) ++ [
				nil
			]
		),
		nil,
	)

});
//WindowDef(\BufferEditor).front(BufDef(\moeten));
);

// END

Color.nil

////// test

BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\clap, "rev/clap1.wav");
WindowDef(\BufferEditor).front(BufDef(\clap));

/////////////////

WindowDef(\BufferEditor).front(~newbuf);
~newbuf
~buf = Buffer(Server.default, 44100, 2)
~buf.loadCollection(0!44100, action:{ "done".debug })


BufDef(\clap, "~/Musique/sc/reckit/rev/clap1.wav");
BufDef(\clap, "reckit/rev/clap1.wav");
BufDef.clear(\clap)

ProtoDef(\BufferEditor, (

));

BufDef(\clap, "~/Musique/sc/reckit/rev/clap1.wav".standardizePath);
BufDef(\clapnorev, "~/Musique/sc/reckit/rev/clapnorev.flac".standardizePath);
BufDef(\clapnorev).asCompileString
BufDef(\clapnorev).presetCompileString
BufDef(\clapnorev)
BufDef.clear(\clap)
BufDef(\)

				BufDef.all[\clap]=nil

WindowDef(\BufferEditor).front(BufDef(\clap))


(
v = Signal.sineFill(128, [1,2,3,4,5,6]);
b = Buffer.alloc(s, 128);
)
(
b.loadCollection(v, action: {|buf|
	buf.debug("buf");
    x = { PlayBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf), loop: 1)
        * 0.2 }.play;
});
)
x.free; b.free;

b
b.loadToFloatArray()
