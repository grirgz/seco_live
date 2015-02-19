(
	~select_sample_position = { arg path;
		var player;
		var win, sf, sfview;
		var post_position;
		var vlayout;
		var zoom_slider;
		var task;
		win = Window.new("select sample position", Rect(200, 300, 740, 100));
		sf = SoundFile.new;
		sfview = SoundFileView.new;
		vlayout = VLayout.new;
		zoom_slider = RangeSlider.new;
		zoom_slider.orientation = \horizontal;
		zoom_slider.action  = { arg sli;
			[\sliderLOW, sli.lo, \sliderHI, sli.hi].postln;
			sfview.zoomToFrac(sli.hi - sli.lo);
			sfview.scrollTo(sli.lo);

		};
		vlayout.add(sfview);
		vlayout.add(zoom_slider);
		win.layout = vlayout;
		sf.openRead(path);
		sfview.soundfile = sf;
		sfview.read(0, sf.numFrames);

		sfview.elasticMode = true;
		sfview.timeCursorOn = true;
		sfview.timeCursorColor = Color.red;
		sfview.timeCursorPosition = 0;
		sfview.drawsWaveForm = true;
		sfview.gridOn = true;
		sfview.gridResolution = 1;
		~sfview = sfview;

		sfview.action = {
			"yeahhh".debug;
		};

		sfview.currentSelection = 1;
		sfview.setSelectionColor(1, Color.green);

		post_position = { 
			var cur;
			cur = sfview.selections[sfview.currentSelection];
			"Current selection is now [start, size, end]:\nframes: %\nseconds: %\nnormalized: %".format(
				cur++(cur[0]+cur[1]),
				cur++(cur[0]+cur[1]) / s.sampleRate,
				cur++(cur[0]+cur[1]) / sf.numFrames,
			).postln;
		};

		sfview.mouseUpAction = { arg a;
			post_position.();
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
					var start = thisThread.beats;
					var x = 0;
					//[ sfview.timeCursorPosition, lastFrame, x, thisThread.beats , start, (thisThread.beats - start) ].debug("tc, lf, xbe, st, -");
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

		win.view.keyDownAction = { arg view, char, modifiers, u, k; 
			//[char, modifiers, u, k].debug("KEYBOARD INPUT");
			if( u == 27 ) { // Esc
				if(player.notNil) {
					player.stop;
					player = nil;
				};
				view.close();
			};
		};


		win.front;

	};


);

// END

// example
~select_sample_position.(Platform.resourceDir +/+ "sounds/a11wlk01.wav");

~sfview.timeCursorPosition = 1000

~select_sample_position.(BufDef(\amen).path);

