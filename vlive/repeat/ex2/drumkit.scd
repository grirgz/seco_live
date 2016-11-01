
(
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

			path = file.path ?? { BufDef(\moeten, "voices/02_moeten.flac") };

		} {
			path = file;
		};
		if(path.notNil) {

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

WindowDef(\sampler, { arg def, target;
	var pkey = \sampler;
	var anchor;
	var sndfileview = View.new;
	var layout;
	var updatebuffer;
	var buffer = Param(target, \bufnum, MenuSpec(
		BufDef.all.keys.as(Array).sort.collect({ arg x; x -> BufDef(x) })
	));
	var oldbuf;
	layout = VLayout (
		HLayout (
			PlayerWrapper(target).asView,
			anchor = Param(target, \out, MenuSpec(
				[ \0 -> 0 ] ++ BusDef.all.keys.as(Array).sort.collect({ arg x; x -> BusDef(x) })
			)).asPopUpMenu,
		),
		sndfileview,
		buffer.asPopUpMenu,
		target.asParamGroup
			.add(Param(target, \sustain))
			.asView
	);
	anchor.debug("anchor");
	updatebuffer = {
		var buf = buffer.get;
		if(buf != 0 and: buf.notNil and: {oldbuf != buf}) {
			sndfileview.removeAll;
			sndfileview.layout = VLayout(WindowDef(\soundfileview).asView(
				buf,
				Param(target, \pos),
				Param(target, \sustain),
				nil,
				nil,
				\seconds,
				\seconds,
				\seconds,
			));
			oldbuf = buf;
		}
	};
	updatebuffer.();
	buffer.onChange(updatebuffer, anchor);
	layout;
	
});

	WindowDef(\samplekit, { arg def, group;
		var size = Point(4,4);
		var edit;
		var layout;
		var editlayout, kitlayout;
		var selector = List.new;
		var select, deselect;
		var selected = 0;
		var default_stepevent = { StepEvent.newFrom((instrument: \playersec)) };

		select = { arg x;
			deselect.(selected);
			selected = x;
			selector[x].background_(ParamView.color_dark)
		};
		deselect = { arg x;
			var tar = group.elAt(x).target;
			selector[x].background = if(tar.isNil or: { tar == default_stepevent.() }) {
				Color.white
			} {
				ParamView.color_ligth;
			}
		};

		kitlayout = VLayout (*
			size.y.collect({ arg y;
				HLayout(*
					size.x.collect({ arg x;
						var idx = y*size.y+x;
						var button;
						button = BasicButton.new.string_(idx).fixedSize_(50@50)
						.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
							[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
							if(buttonNumber == 0) {
								group.elAt(idx).play;
							};
							if(buttonNumber == 1) {
								edit.(idx);
							};
						})
						.action_({
							group.elAt(idx).stop;
						});
						selector.add(button);
						deselect.(idx);
						button;
					})
					++ [ nil ]
				)
			})
			++ [ nil ]
		);

		edit = { arg idx;
			var drum = group.elAt(idx);
			if(drum.target.isNil) {
				drum.target = default_stepevent.();
			};
			select.(idx);
			editlayout.removeAll;
			editlayout.layout = VLayout(
				//WindowDef(\vertical_paramgroup).asView(drum.target.asParamGroup)
				WindowDef(\sampler).asView(drum.target)
			);
		
		};

		editlayout = View.new;
		edit.(0);

		layout = HLayout (
			kitlayout,
			editlayout,
			nil,
		);

		layout;
	});

ParamProto.init;
	
// to be insered in lib
~parPlayerGroup[\asPresetCompileString] = { arg self, varname="~ppg";
	"%.targets = [\n%];".format(
		varname,
		self.targets.collect({ arg target, idx;
			var xtar = target.copy;
			var template_key = "Buffer.new";
			var bufnum_compilestring;
			var res;
			res = "\t%,\n".format(target.asCompileString);
			if(target.notNil) {
				bufnum_compilestring = "BufDef(%)".format(target[\bufnum].key.asCompileString);
				res = res.replace(template_key, bufnum_compilestring);
			};
			res;
		}).join
	)
};
~parPlayerGroup[\edit] = { arg self;
	WindowDef(\samplekit).front(self);
};
~parPlayerGroup[\startControl] = { arg self;
	var count = 0;

	MKtl(\lp, "novation-launchpad-s");
	MKtl(\lp).elAt(\pad).do({ arg el, i;
		var idx = count;

		[i, i%8 < 4, idx].debug("i, iii, idx");
		if(i%8 < 4) {

			el.elAt(0).action = {
				~ppg.elAt(idx).play;
			};
			el.elAt(1).action = {
				~ppg.elAt(idx).stop;
			};
			count = count + 1;
		}
	})
};
)



// END



ParamProto.init(true);


~sfview.selections[~sfview.currentSelection] = [10000, 20000]
~sfview.setSelection(~sfview.currentSelection, [10000, 20000])
Param.freeAllSimpleControllers

BusDef.all.keys.as(Array).sort
BusDef(\out, 0);

WindowDef(\sampler).front(Pdef(\sampler));
(
Pdef(\sampler, Pbind(
	\instrument, \playersec,
)).play;
);
XEnvSpec.adsr
(
Spec.add(\adsr, XEnvSpec.adsr);
WindowDef(\samplebox, {
}).front
)

(
Pdef(\hello, Pbind(
	\instrument, \playerbeat,
	\bufnum, BufDef(\moeten),
	\sustain, 0.2,
	\pos, 0,
	\speed, 1,
	\dur, 1/4,
	\amp, 0.1
)).play;
);
{ SinOsc.ar(200) ! 2 * 0.1}.play;


ParamProto.init(true)

~ppg = ~parPlayerGroup.new({ nil } ! 16)
~ppg.elAt(0).play
~ppg.elAt(0).target
~ppg.elAt(4).target
~ppg.elAt(0).target.play
~ppg.elAt(0).target.asCompileString.editorInsert
StepEvent.newFrom((instrument: 'playersec', bufnum: Buffer.new))
StepEvent.newFrom((instrument: 'playersec'))
StepEvent.newFrom((instrument: 'playersec'))
~ppg.elAt(0).target.class
PlayerWrapper(~ppg.elAt(0).target).wrapper
StepEvent.newFrom(( bla:3))

(
~ppg.asPresetCompileString = { arg self, varname="~ppg";
	"%.targets = [\n%];".format(
		varname,
		self.targets.collect({ arg target, idx;
			var xtar = target.copy;
			var template_key = "Buffer.new";
			var bufnum_compilestring;
			var res;
			res = "\t%,\n".format(target.asCompileString);
			if(target.notNil) {
				bufnum_compilestring = "BufDef(%)".format(target[\bufnum].key.asCompileString);
				res = res.replace(template_key, bufnum_compilestring);
			};
			res;
		}).join
	)
}
)
~ppg.asPresetCompileString
~ppg.asPresetCompileString.editorInsert
(
~ppg = ~parPlayerGroup.new([
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('kick'))),
	StepEvent.newFrom((instrument: 'playersec', freq: 192.59125049198, speed: 0.77052049180328, bufnum: BufDef('snare'))),
	StepEvent.newFrom((instrument: 'playersec', bufnum: BufDef('hat'), pos: 1.2125623582766, sustain: 0.39431594860166)),
	StepEvent.newFrom((instrument: 'playersec', freq: 192.59125049198, speed: 1.17052049180328, bufnum: BufDef('snare'))),
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
]);
)


(
WindowDef(\test, {
	PlayerWrapper(~ppg.elAt(0).target).asView
}).front
)
(
)

StepEvent.newFrom((instrumet:\playerset)) == StepEvent.newFrom((instrumet:\playerset))
