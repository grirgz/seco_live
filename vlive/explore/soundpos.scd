
(
	w = Window.new("soundfile test", Rect(200, 300, 740, 100));
	a = SoundFileView.new(w, Rect(20,20, 700, 60));

	f = SoundFile.new;
	f.openRead(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
	f.inspect;

	a.soundfile = f;
	a.read(0, f.numFrames);
	a.elasticMode = true;

	a.timeCursorOn = true;
	a.timeCursorColor = Color.red;
	a.timeCursorPosition = 2050;
	a.drawsWaveForm = true;
	a.gridOn = true;
	a.gridResolution = 0.2;

	w.front;

)

(
	~select_sample_position = { arg path;
		var player;
		var win, sf, sfview;
		var post_position;
		var vlayout;
		var zoom_slider;
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

		post_position = { 
			var cur;
			cur = sfview.selections[sfview.currentSelection];
			"Current selection is now:\nframes: %\nseconds: %\nnormalized: %".format(
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
			cur = view.selections[view.currentSelection];
			//[char, modifiers, u, k].debug("KEYBOARD INPUT");
			if( u == 32 ) { // space
				if(player.notNil) {
					player.stop;
					player = nil;
				};
				player = sf.play(
					(
						firstFrame: cur[0],
						lastFrame: if(cur[1] == 0) { nil } {cur[0]+cur[1]}
					)

				);
				post_position.();
			};
			if( u == 13 ) { // Enter
				if(player.notNil) {
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
	//~select_sample_position.(BufDef(\amen).path);
	~select_sample_position.(Platform.resourceDir +/+ "sounds/a11wlk01.wav");
)
BufDef(\table).path


