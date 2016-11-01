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


with:
sfview.scrollPos
sfview.viewFrames
you can get the current viewport and adjust the scrollbar

the weird color keeping from viewing the selection is the grid ! resolution is too high or there is a bug

// To zoom in/out: Shift + right-click + mouse-up/down
// To scroll: right-click + mouse-left/right
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
