
WindowDef(\soundfileview, { arg def, file, startParam, sustainParam, endParam, speedParam, startType, sustainType, endType;
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
		vlayout = VLayout.new;
		sfview = SoundFileView.new;
		if(file.isKindOf(Buffer)) {
			path = file.path ?? { 
				var pa;
				//"ERROR: buffer has not be saved: %".format(file);
				//BufDef(\empty, "empty.wav").path 
				pa = "/tmp/sc_tmp_buffer_%.flac".format(file.hash);
				file.write(pa);
				file.path = pa;
				pa;
			};
		} {
			path = file;
		};
		if(path.notNil) {

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
			sf.openRead(path);
			sfview.soundfile = sf;
			sfview.read(0, sf.numFrames);

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
			sfview.setSelectionColor(1, ParamView.color_ligth);

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
				sfview.setSelection(sfview.currentSelection, [start, sustain]);
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

			sfview.keyDownAction = { arg view, char, modifiers, u, k; 
				var cur;
				var lastFrame;
				cur = view.selections[view.currentSelection];
				lastFrame = if(cur[1] == 0) { sf.numFrames } {cur[0]+cur[1]};
				//[char, modifiers, u, k].debug("KEYBOARD INPUT");
				if( u == 32 ) { // space
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
