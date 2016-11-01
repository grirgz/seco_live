
(
	WindowDef(\smpslicer, {

	})
)


// END

// inspiration:
(
	WindowDef(\smpslicer, { arg def, bufdef;
		var player;
		var win, sf, sfview;
		var post_position;
		var vlayout;
		var zoom_slider;
		var task;
		var playerkey = \smpslicerplayer;
		var path = bufdef !? {bufdef.path};
		var positions;
		var compute_params;
		var controller;
		var asPresetCompileString;
		vlayout = VLayout.new;
		sfview = SoundFileView.new;
		if(path.notNil) {

			//win = Window.new("select sample position", Rect(200, 300, 740, 100));
			//if(def.window.notNil) { def.window.title = "samp" }
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
			sfview.setSelectionColor(1, Color.green);

			post_position = { 
				var cur;
				cur = sfview.selections[sfview.currentSelection];
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

			asPresetCompileString = {
				"Pbind(\n%%%);".format(
					"\t'instrument', \\playersec,\n",
					"\t'bufnum', BufDef(%),\n".format(bufdef.key.asCompileString),
					[\pos, \speed, \sustain, \dur, \gain].collect({ arg key;
						"\t%, %,\n".format(key.asCompileString, ( Pdef(playerkey).get(key) ? 1 ).asCompileString )
					}).join;
				).pbcopy;
			};

			compute_params = {
				var speed;
				var sustain;
				var dur;
				speed = Pdef(playerkey).get(\speed) ? 1;
				Pdef(playerkey).set(\pos, if(speed < 0) {
					positions[1][2]
				} {
					positions[1][0];
				});
				sustain = positions[1][1] / speed.abs;
				if(sustain == 0) {
					sustain = 1;
				};
				Pdef(playerkey).set(\sustain, sustain);
				Pdef(playerkey).set(\dur, Pdef(playerkey).get(\sustain) * TempoClock.default.tempo);
			};

			Param(Pdef(playerkey), \speed).onChange({
				compute_params.();
			}, sfview);

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

		Pdef(playerkey, Pbind(
			\instrument, \playerbeat,
			\bufnum, bufdef,
		));

		VLayout (
			vlayout,
			PlayerWrapper(Pdef(playerkey)).asView,
			WindowDef(\vertical_paramgroup).asView(
				 [
					Param(Pdef(playerkey), \speed, ControlSpec(-3,3,\lin, 0,1)),
					Param(Pdef(playerkey), \pos),
					Param(Pdef(playerkey), \sustain),
					Param(Pdef(playerkey), \dur),
					Param(Pdef(playerkey), \gain),
				]
			)
		)

	}).front(BufDef(\a11, Platform.resourceDir +/+ "sounds/a11wlk01.wav"));


);

BufDef(\a11,Platform.resourceDir +/+ "sounds/a11wlk01.wav")

WindowDef(\smpslicer).front


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

a.soundfile = f;
a.read(0, f.numFrames);
a.elasticMode = true;

a.timeCursorOn = true;
a.timeCursorColor = Color.red;
a.timeCursorPosition = 2050;
a.drawsWaveForm = true;
a.gridOn = true;
a.gridResolution = 5.5;

w.front;
)


(
Pbind(
		'instrument', \playersec,
		'bufnum', BufDef('a11'),
		'pos', 2.0087074829932,
		'speed', 1,
		'sustain', 0.23630385487528,
		'gain', 1,
).play;
)

