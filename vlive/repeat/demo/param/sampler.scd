
(
SynthDef(\sampler, { arg out=0, gate=1, speed=1, pos=0, trigger=1, loop=0, bufnum;
	var sig;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1) * \velamp.kr(1);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sampler_mono, { arg out=0, gate=1, pan=0, speed=1, pos=0, trigger=1, loop=0, mbufnum;
	var sig;
	sig = PlayBuf.ar(1, mbufnum, BufRateScale.kr(mbufnum) * speed, trigger, startPos: (pos*BufFrames.kr(mbufnum)), doneAction:0, loop: loop);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan);
	sig = sig * \gain.kr(1) * \velamp.kr(1);
	Out.ar(out, sig);
}).add;
);

(
Pbindef(\sampler, 
	\instrument, \sampler,
	\degree, Pseq([0],inf),
	\dur, 1,
	\gain, 0.1,
).play;
);

(
Pbindef(\sampler_mono, 
	\instrument, \sampler_mono,
	\degree, Pseq([0],inf),
	\dur, 1,
	\pan, Pwhite(-1,1.0,inf),
	\gain, 0.1,
).play;
);

BufDef(\moeten, "voices/02_moeten.flac");

(
ParamProto.init;
WindowDef(\win, { arg def;
	var popup;
	var param;
	VLayout (
		HLayout (
			PlayerWrapper(Pbindef(\sampler)),
			PlayerWrapper(Pbindef(\sampler_mono)),
		),
		Param(Pdef(\sampler), \bufnum, ParamBufferSpec(2)).asPopUpMenu,
		HLayout (
			popup = Param(Pdef(\sampler_mono), \mbufnum, ParamBufferSpec(1)).asPopUpMenu,
			BasicButton.new.string_("Load").action_({
				WindowDef(\filedialog_sample).front(nil, { arg path;
					var param = Param(Pdef(\sampler_mono), \mbufnum, ParamBufferSpec(1));
					switch(param.spec.numChannels,
						1, { param.set(BufDef.mono(path).bufnum) },
						2, { param.set(BufDef.stereo(path).bufnum) },
						{ param.set(BufDef(path).bufnum) }
					);
					//popup.refreshChange;
					 {
						param.spec.tagSpec.changed(\list);
					}.defer(0.1);

				})
			})
		),
		Param(Pdef(\sampler), \bufnum, ParamSampleSpec(2)).asPopUpMenu,
		Param(Pdef(\sampler), \bufnum, ParamSampleSpec(2)).asView,
		HLayout (
			param = Param(Pdef(\sampler_mono), \mbufnum, ParamSampleSpec(1));
			popup = param.asPopUpMenu.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				if(buttonNumber == 1) {
					WindowDef(\GlobalLibrary_select, { arg def, defaultValue, okHook, categories;
						var selected;
						categories = [ \AudioBuffer ];
						VLayout (
							WindowDef(\GlobalLibrary).asView(nil, { arg val; 
								selected = val;
							}, categories),
							HLayout (
								BasicButton.new.string_("Cancel").action_({
									def.closeWindow;
								}),
								BasicButton.new.string_("Ok").action_({
									okHook.(selected);
									def.closeWindow;
								}),
							)
						)
					}).front(nil, { arg val; 
						val.debug("selected");
						// val: [ Class, (key -> bufnum) ]
						param.set(val.last.value)
					})
				}
				
			}),
			BasicButton.new.string_("Load").action_({
				WindowDef(\filedialog_sample).front(nil, { arg path;
					switch(param.spec.numChannels,
						1, { param.set(BufDef.mono(path).bufnum) },
						2, { param.set(BufDef.stereo(path).bufnum) },
						{ param.set(BufDef(path).bufnum) }
					);
					//popup.refreshChange;
					 {
						param.spec.tagSpec.changed(\list);
					}.defer(0.1);

				})
			})
		)
	)
}).front;
);
ParamBufferSpec(1).tagSpec.changed(\list)
ParamBufferSpec(2).range
TreeListView
ListTreeView
TreeView

					~param = Param(Pdef(\sampler_mono), \mbufnum, ParamBufferSpec(1));
					~param.get


BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
BufDef.mono(\bomb, "vipere/bomb.flac");

FileSystemProject.load("libdef/soundfileview.scd");
FileSystemProject.load("libdef/filedialog.scd");


(
)

TempoClock.default.tempo
(
ParamProto.init;
WindowDef(\win, { arg def;
	var popup;
	var param;
	var sndfileview = View.new;
	var spec = ParamAudioBufferSpec(1);
	spec
		.startParamName_(\pos)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed)
		;
	param = Param(Pdef(\sampler_mono), \mbufnum, spec);
	sndfileview.layout = VLayout(WindowDef(\ParamAsSoundFileView).asView(param));
	VLayout (
		HLayout (
			PlayerWrapper(Pbindef(\sampler_mono)),
		),
		sndfileview,
		HLayout (
			param.asPopUpMenu.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
				[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
				if(buttonNumber == 1) {
					WindowDef(\GlobalLibrary_select, { arg def, defaultValue, okHook, categories;
						var selected;
						categories = [ \AudioBuffer ];
						VLayout (
							WindowDef(\GlobalLibrary).asView(nil, { arg val; 
								selected = val;
							}, categories),
							HLayout (
								BasicButton.new.string_("Cancel").action_({
									def.closeWindow;
								}),
								BasicButton.new.string_("Ok").action_({
									okHook.(selected);
									def.closeWindow;
								}),
							)
						)
					}).front(nil, { arg val; 
						val.debug("selected");
						// val: [ Class, (key -> bufnum) ]
						param.set(val.last.value)
					})
				}
				
			}),
			BasicButton.new.string_("Load").maxWidth_(50).action_({
				WindowDef(\filedialog_sample).front(nil, { arg path;
					switch(param.spec.numChannels,
						1, { param.set(BufDef.mono(path).bufnum) },
						2, { param.set(BufDef.stereo(path).bufnum) },
						{ param.set(BufDef(path).bufnum) }
					);
					 {
						param.spec.tagSpec.changed(\list);
					}.defer(0.1);

				})
			})
		),
		Param(Pdef(\sampler_mono), \pos, \unipolar).asView,
		Param(Pdef(\sampler_mono), \sustain, ControlSpec(0,10,\lin)).asView,
		Param(Pdef(\sampler_mono), \speed, ControlSpec(-2,2,\lin)).asView,
		Param(Pdef(\sampler_mono), \gain, \unipolar).asView,
	)
}).front;
);

		Param(Pdef(\sampler_mono), \sustain).get

(
WindowDef(\soundfileview, { arg def, file, startParam, sustainParam, endParam, speedParam, startType, sustainType, endType;
		var player;
		var win, sf, sfview;
		var post_position, compute_position;
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
		var conv; // conversion functions
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
			var getStart, setStart;

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
			sfview.setSelectionColor(1, ParamViewToolBox.color_ligth);

			// SoundFileView selection is in seconds
			// can't always use param spec because spec range is not same as buffer duration
			sustainType.debug("sustainType");
			conv = [startType, sustainType, endType].collect({ arg ptype;
				{ arg pa;
					ProtoClass((
						get: switch(ptype,
							\seconds, { { pa.get } },
							\beats, { { pa.get / clock.tempo } },
							\unipolar, { { pa.get * sf.duration } },
							\spec, { { pa.normGet * sf.duration } },
							{ { pa.normGet * sf.duration } },
						),
						set: switch(ptype,
							\seconds, { { arg se, x; [pa,x].debug("set seconds"); pa.set(x) } },
							\beats, { { arg se, x; pa.set(x * clock.tempo) } },
							\unipolar, { { arg se, x; [pa,x].debug("set unipolar"); pa.set(x / sf.duration) } },
							\spec, { { arg se, x; pa.normSet(x / sf.duration) } },
							{ { arg se, x; pa.normSet(x / sf.duration) } },
						),
					))
				}
			});

			conv = (
				start: conv[0].(startParam),
				sustain: conv[1].(sustainParam),
				end: conv[2].(endParam),
			);


			compute_position = { 
				var cur;
				cur = sfview.selections[sfview.currentSelection];
				// cur = [start, size] in frames
				positions = [
					cur++(cur[0]+cur[1]),					// frames
					cur++(cur[0]+cur[1]) / s.sampleRate,	// seconds
					cur++(cur[0]+cur[1]) / sf.numFrames,	// normalized
				];
				"Current selection is now [start, size, end]:\nframes: %\nseconds: %\nnormalized: %".format(
					*positions
				).postln;
			};

			post_position = { 
				compute_position.();
				"Current selection is now [start, size, end]:\nframes: %\nseconds: %\nnormalized: %".format(
					*positions
				).postln;
			};
			post_position.();

			// init selection
			update_selection = {
				var sustain, start;
				var speed;
				"0".debug("xxx");
				[startParam.get, conv.start.get, sfview.selections[sfview.currentSelection]].debug("update_selection: start really before");
				speed = if(speedParam.notNil) {
					speedParam.get;
				} {
					1
				};
				sustain = if(sustainParam.notNil) {
					[conv.sustain.get, clock.tempo, sampleRate].debug("xxx");
					conv.sustain.get * sampleRate * speed.abs;
				} {
					"1".debug("xxx");
					endParam.get - conv.start.get * sampleRate;
				};
				"1.2".debug("xxx");
				[startParam.get, conv.start.get].debug("update_selection: start before");
				start = conv.start.get * sampleRate;
				"2".debug("xxx");
				(
					[conv.start.get, conv.sustain.get, conv.start.get + conv.sustain.get] 
					++ ( [conv.start.get, conv.sustain.get, conv.start.get + conv.sustain.get] * sampleRate)
					++ ( [
						( conv.start.get + conv.sustain.get * sampleRate ) - ( conv.start.get * sampleRate ), 
						( conv.start.get + conv.sustain.get * sampleRate ) - ( conv.start.get * sampleRate ) / sampleRate, 
					])
				).debug("start, sus, end, srstart, srsus, srend");
				"3".debug("xxx");
				sfview.setSelection(sfview.currentSelection, 
					if(speed < 0) {
						[start - sustain, sustain]
					} {
						[start, sustain]
					}
				);
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
				compute_position.();
				speed = if(speedParam.notNil) {
					speedParam.get;
				} {
					1
				};
				if(startParam.notNil) {
					[startParam.get, conv.start.get, positions[1][0]].debug("compute_params: start");
					conv.start.set( if(speed < 0) {
						positions[1][2]
					} {
						positions[1][0];
					});
					[startParam.get, conv.start.get, positions[1][0]].debug("compute_params: start after");
				};
				sustain = positions[1][1] / speed.abs;
				if(sustain == 0) {
					if(sustainParam.notNil) {
						sustain = conv.sustain.get;
					} {
						sustain = 1;
					}
				};
				if(sustainParam.notNil) {
					conv.sustain.set(sustain);
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

WindowDef(\win).front
)

(
WindowDef(\ParamAsSoundFileView, { arg def, param;
	var spec = param.spec;
	var target = param.target;
	var buf = param.get;
	if(spec.isKindOf(ParamAudioBufferSpec)) {
		WindowDef(\soundfileview).asView(
			//BufDef(spec.tagSpec.unmapKey(param.get)),
			param,
			spec.startParamName !? { Param(target, spec.startParamName) },
			spec.sustainParamName !? { Param(target, spec.sustainParamName) },
			spec.endParamName !? { Param(target, spec.endParamName) },
			spec.speedParamName !? { Param(target, spec.speedParamName) },
			spec.startType ? \unipolar,
			spec.sustainType ? \beats,
			spec.endType ? \unipolar,
		);
	} {
		Slider.new;
		//WindowDef(\soundfileview).asView(
		//BufDef(spec.tagSpec.unmapKey(param.get)),
		//Param(target, \pos),
		//Param(target, \sustain),
		//nil,
		//nil,
		//\seconds,
		//\seconds,
		//\seconds,
		//);
	};
});
WindowDef(\soundfileview, (

	compute_position: { arg self;
		var cur;
		var positions;
		var sfview = self.sfview;
		var sf = self.sf;
		cur = sfview.selections[sfview.currentSelection];
		// cur = [start, size] in frames
		positions = [
			cur++(cur[0]+cur[1]),					// frames
			cur++(cur[0]+cur[1]) / s.sampleRate,	// seconds
			cur++(cur[0]+cur[1]) / sf.numFrames,	// normalized
		];
		"Current selection is now [start, size, end]:\nframes: %\nseconds: %\nnormalized: %".format(
			*positions
		).postln;
		self.positions = positions;
	},

	post_position: {  arg self;
		self.compute_position;
		"Current selection is now [start, size, end]:\nframes: %\nseconds: %\nnormalized: %".format(
			*self.positions
		).postln;
	},

	update_selection: { arg self;
		var sustain, start;
		var speed;
		var conv = self.accessor;
		var startParam = self.startParam, sustainParam = self.sustainParam, endParam = self.endParam;
		var speedParam = self.speedParam;
		var sampleRate = self.sampleRate;
		var sfview = self.sfview;
		var clock = self.tempoClock;
		"0".debug("xxx");
		[startParam.get, conv.start.get, sfview.selections[sfview.currentSelection]].debug("update_selection: start really before");
		speed = if(speedParam.notNil) {
			speedParam.get;
		} {
			1
		};
		sustain = if(sustainParam.notNil) {
			[conv.sustain.get, clock.tempo, sampleRate].debug("xxx");
			conv.sustain.get * sampleRate * speed.abs;
		} {
			"1".debug("xxx");
			endParam.get - conv.start.get * sampleRate;
		};
		"1.2".debug("xxx");
		[startParam.get, conv.start.get].debug("update_selection: start before");
		start = conv.start.get * sampleRate;
		"2".debug("xxx");
		(
			[conv.start.get, conv.sustain.get, conv.start.get + conv.sustain.get] 
			++ ( [conv.start.get, conv.sustain.get, conv.start.get + conv.sustain.get] * sampleRate)
			++ ( [
				( conv.start.get + conv.sustain.get * sampleRate ) - ( conv.start.get * sampleRate ), 
				( conv.start.get + conv.sustain.get * sampleRate ) - ( conv.start.get * sampleRate ) / sampleRate, 
			])
		).debug("start, sus, end, srstart, srsus, srend");
		"3".debug("xxx");
		sfview.setSelection(sfview.currentSelection, 
			if(speed < 0) {
				[start - sustain, sustain]
			} {
				[start, sustain]
			}
		);
	},

	asPresetCompileString: { arg self;
		//"Pbind(\n%%%);".format(
		//	"\t'instrument', \\playersec,\n",
		//	"\t'bufnum', BufDef(%),\n".format(bufdef.key.asCompileString),
		//	[\pos, \speed, \sustain, \dur, \gain].collect({ arg key;
		//		"\t%, %,\n".format(key.asCompileString, ( Pdef(playerkey).get(key) ? 1 ).asCompileString )
		//	}).join;
		//).pbcopy;
	},

	compute_params: { arg self;
		var speed;
		var sustain;
		var dur;
		var conv = self.accessor;
		var startParam = self.startParam, sustainParam = self.sustainParam, endParam = self.endParam;
		var speedParam = self.speedParam;
		var sampleRate = self.sampleRate;
		var sfview = self.sfview;
		var positions;
		var clock = self.tempoClock;
		self.compute_position;
		positions = self.positions;
		speed = if(speedParam.notNil) {
			speedParam.get;
		} {
			1
		};
		if(startParam.notNil) {
			[startParam.get, conv.start.get, positions[1][0]].debug("compute_params: start");
			conv.start.set( if(speed < 0) {
				positions[1][2]
			} {
				positions[1][0];
			});
			[startParam.get, conv.start.get, positions[1][0]].debug("compute_params: start after");
		};
		sustain = positions[1][1] / speed.abs;
		if(sustain == 0) {
			if(sustainParam.notNil) {
				sustain = conv.sustain.get;
			} {
				sustain = 1;
			}
		};
		if(sustainParam.notNil) {
			conv.sustain.set(sustain);
		};
		//Pdef(playerkey).set(\dur, Pdef(playerkey).get(\sustain) * TempoClock.default.tempo);
	},

	makeListeners: { arg self;
		var startParam = self.startParam, sustainParam = self.sustainParam, endParam = self.endParam;
		var speedParam = self.speedParam;
		var sfview = self.sfview;

		if(self.bufferParam.notNil) {
			self.bufferParam.onChange({
				self.compute_params;
				self.update_selection;
				self.openFile(self.bufferParam);
			}, sfview);
		};

		if(speedParam.notNil) {
			speedParam.onChange({
				self.compute_params;
				self.update_selection;
			}, sfview);
		};

		if(startParam.notNil) {
			startParam.onChange({
				self.update_selection;
			}, sfview);
		};

		if(endParam.notNil) {
			endParam.onChange({
				self.update_selection;
			}, sfview);
		};

		if(sustainParam.notNil) {
			sustainParam.onChange({
				self.update_selection;
			}, sfview);
		};

		sfview.mouseUpAction = { arg a;
			self.post_position;
			self.compute_params;
			self.asPresetCompileString.postln;
		};

	},

	openFile: { arg self, file;
		var path;
		if(file.isKindOf(Param)) {
			self.bufferParam = file;
			file = BufDef(self.bufferParam.spec.tagSpec.unmapKey(self.bufferParam.get));
		};
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
			self.sf.openRead(path);
			self.sfview.soundfile = self.sf;
			self.sfview.read(0, self.sf.numFrames);
		}
	},

	makeAccessor: { arg self;
		var startParam = self.startParam, sustainParam = self.sustainParam, endParam = self.endParam;
		var speedParam = self.speedParam;
		var sampleRate = self.sampleRate;
		var clock = self.tempoClock;
		var sf = self.sf;
		var conv;

		// SoundFileView selection is in seconds
		// can't always use param spec because spec range is not same as buffer duration
		self.sustainType.debug("sustainType");
		conv = [self.startType, self.sustainType, self.endType].collect({ arg ptype;
			{ arg pa;
				ProtoClass((
					get: switch(ptype,
						\seconds, { { pa.get } },
						\beats, { { pa.get / clock.tempo } },
						\unipolar, { { pa.get * sf.duration } },
						\spec, { { pa.normGet * sf.duration } },
						{ { pa.normGet * sf.duration } },
					),
					set: switch(ptype,
						\seconds, { { arg se, x; [pa,x].debug("set seconds"); pa.set(x) } },
						\beats, { { arg se, x; pa.set(x * clock.tempo) } },
						\unipolar, { { arg se, x; [pa,x].debug("set unipolar"); pa.set(x / sf.duration) } },
						\spec, { { arg se, x; pa.normSet(x / sf.duration) } },
						{ { arg se, x; pa.normSet(x / sf.duration) } },
					),
				))
			}
		});

		conv = (
			start: conv[0].(startParam),
			sustain: conv[1].(sustainParam),
			end: conv[2].(endParam),
		);
		self.accessor = conv;
	},

	asView: { arg self, def, file, startParam, sustainParam, endParam, speedParam, startType, sustainType, endType;
		var player;
		var win, sf, sfview;
		var post_position, compute_position;
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
		var conv; // conversion functions

		//BufDef(spec.tagSpec.unmapKey(param.get)),

		self.tempoClock = clock;
		self.sampleRate = sampleRate;

		self.startParam = startParam;
		self.sustainParam = sustainParam;
		self.endParam = endParam;
		self.speedParam = speedParam;

		self.sustainType = sustainType;
		self.startType = startType;
		self.endType = endType;

		vlayout = VLayout.new;
		sfview = SoundFileView.new;
		sf = SoundFile.new;
		self.sfview = sfview;
		self.sf = sf;

		path.debug("soundfileview: file path");
		self.openFile(file);

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


		self.makeAccessor;


		self.post_position;

		// init selection
		self.update_selection;

		self.makeListeners;

		sfview.mouseUpAction = { arg a;
			self.post_position;
			self.compute_params;
			self.asPresetCompileString.postln;
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
				self.post_position;
			};
			if( u == 13 or: { char == $f }) { // Enter
				if(player.notNil) {
					task.stop;
					sfview.timeCursorPosition = cur[0];
					task = nil;
					player.stop;
					player = nil;
				};
				self.post_position;
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

		sfview
	}

));

//WindowDef(\win).front
)


////////


(
ParamProto.init;
WindowDef(\win, { arg def;
	var popup;
	var param;
	var sndfileview = View.new;
	var spec = ParamAudioBufferSpec(1);
	var curval, editcurval;
	curval = StaticText.new;
	editcurval = TextField.new;
	spec
		.startParamName_(\pos)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed)
		;
	param = Param(Pdef(\sampler_mono), \mbufnum, spec);
	sndfileview.layout = VLayout(WindowDef(\ParamAsSoundFileView).asView(param));

	curval.followChange(Param, \lastTweaked, { arg view; 
		"there is a change! %: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet).postln;

		// map the last changed Param to the StaticText and TextField
		curval.mapParamLabel(Param.lastTweaked);
		editcurval.mapParam(Param.lastTweaked);
	});

	VLayout (
		HLayout (
			PlayerWrapper(Pbindef(\sampler_mono)),
			curval, 
			editcurval,
		),
		HLayout (
			VLayout (
				sndfileview,
				HLayout (
					param.asPopUpMenu.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
						[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
						if(buttonNumber == 1) {
							WindowDef(\GlobalLibrary_select, { arg def, defaultValue, okHook, categories;
								var selected;
								categories = [ \AudioBuffer ];
								VLayout (
									WindowDef(\GlobalLibrary).asView(nil, { arg val; 
										selected = val;
									}, categories),
									HLayout (
										BasicButton.new.string_("Cancel").action_({
											def.closeWindow;
										}),
										BasicButton.new.string_("Ok").action_({
											okHook.(selected);
											def.closeWindow;
										}),
									)
								)
							}).front(nil, { arg val; 
								val.debug("selected");
								// val: [ Class, (key -> bufnum) ]
								param.set(val.last.value)
							})
						}
				
					}),
					BasicButton.new.string_("Load").maxWidth_(50).action_({
						WindowDef(\filedialog_sample).front(nil, { arg path;
							switch(param.spec.numChannels,
								1, { param.set(BufDef.mono(path).bufnum) },
								2, { param.set(BufDef.stereo(path).bufnum) },
								{ param.set(BufDef(path).bufnum) }
							);
							 {
								param.spec.tagSpec.changed(\list);
							}.defer(0.1);
				
						})
					})
				),
			),
			VLayout(
				* [
					Param(Pdef(\sampler_mono), \pos, \unipolar),
					Param(Pdef(\sampler_mono), \sustain, ControlSpec(0,10,\lin)),
					Param(Pdef(\sampler_mono), \speed, ControlSpec(-2,2,\lin,0,1)),
				].collect({ arg pa;
					VLayout (
						[pa.asStaticTextLabel, align:\center],
						pa.asKnob.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
							[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
							if(buttonNumber == 2) {
								Param.lastTweaked = pa;
								Param.changed(\lastTweaked);
								false;
							} {
								if(buttonNumber == 1) {
									view.mode = \horiz;
								};
							}
						})
						.mouseMoveAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
							if(buttonNumber == 2) {
								false;
							}
						})
						.mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
							if(buttonNumber == 2) {
								false;
							} {
								if(buttonNumber == 1) {
									view.mode = \round;
								}
							}
						})
						.centered_(pa.spec.minval == pa.spec.maxval.neg),
					)
			
				}) ++ [nil]
			),
		),
		Param(Pdef(\sampler_mono), \gain, \unipolar).asView,
		Param(Pdef(\sampler_mono), \dur, ControlSpec(0.1,8,\lin)).asView,
	)
}).front;
);

\pan.asSpec
Knob
// idea: mode to bind sustain and param, and add legato parameter
// asButton should be a load button ? but TagSpecDef button have already a role, no ? or asLoadButton
// asSoundFileView should work only for ParamBufferSpec, else show what ?
// integrate knob right click code and put the knob layout in asKnobEntry

(
	// integrated into Param quark
ParamProto.init;
WindowDef(\win, { arg def;
	var popup;
	var param;
	var spec;
	var curval, editcurval;
	curval = StaticText.new.minWidth_(80).align_(\right);
	editcurval = TextField.new;
	spec = ParamAudioBufferSpec(1)
		.startParamName_(\pos)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed)
		;
	param = Param(Pdef(\sampler_mono), \mbufnum, spec);

	curval.followChange(Param, \lastTweaked, { arg view; 
		"there is a change! %: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet).postln;

		// map the last changed Param to the StaticText and TextField
		curval.mapParamLabel(Param.lastTweaked);
		editcurval.mapParam(Param.lastTweaked);
	});

	VLayout (
		HLayout (
			PlayerWrapper(Pbindef(\sampler_mono)),
			curval, 
			editcurval,
		),
		HLayout (
			WindowDef(\ParamAsSoundFileView).asView(param),
			VLayout(
				* [
					Param(Pdef(\sampler_mono), \pos, \unipolar),
					Param(Pdef(\sampler_mono), \sustain, ControlSpec(0,10,\lin)),
					Param(Pdef(\sampler_mono), \speed, ControlSpec(-2,2,\lin,0,1)),
				].collect({ arg pa;
					ParamGroupLayout.knobView(pa);
				}) ++ [nil]
			),
		),
		param.asView,
		Param(Pdef(\sampler_mono), \gain, \unipolar).asView,
		Param(Pdef(\sampler_mono), \dur, ControlSpec(0.1,8,\exp)).asView,
	)
}).front;
);



///////////////////////////// sequencer

(
Pdef(\seqlist, 
	Ppar(
		5.collect { arg idx;
			Pbindef(\seq+++idx,
				\instrument, \sampler,
				\velamp, PstepSeq(0!8,inf),
				\muter, Pif(\velamp > 0, {0}, {\rest}),
			);
			//if(Pbindef(\seq+++idx).source.at(\velamp).source.isNil) {
				//Pbindef(\seq+++idx,
					//\velamp, PstepSeq(0!8,inf),
				//);
			//}
		};
	)
);
);

Pdef(\seq0).get(\bufnum)

Pdef(\seqlist).clear;
(
WindowDef(\smpsequencer, { arg def, seqlist;
	var durParam = Param(Pdef(\seq0), \dur, ControlSpec(0.1,8,\exp));
	var durView = durParam.asView;
	durParam.onChange({
		seqlist[1..].do({ arg x; Param(x.target, \dur).set( durParam.get ) })
	}, def.window);
	VLayout (
		HLayout (
			PlayerWrapper(Pdef(\seqlist)),
			durView,
		),
		VLayout(
			* seqlist.collect { arg item, idx;
				HLayout (
					BasicButton.new.string_(\seq+++idx).action_({
						WindowDef(\sampleEditor).front(Param(item.target, \bufnum))
					}),
					item.asMultiSlider,
				)
			}
		)
	)
	
}).front(
	5.collect { arg idx;
		Param(Pdef(\seq +++ idx), \velamp -> \stepseq, \unipolar)
	};
);

WindowDef(\sampleEditor, { arg def, param;
	var popup;
	var spec;
	var curval, editcurval;
	var target = param.target;
	curval = StaticText.new.minWidth_(80).align_(\right);
	editcurval = TextField.new;
	spec = ParamAudioBufferSpec(2)
		.startParamName_(\pos)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed)
		;
	param.spec = spec;

	curval.followChange(Param, \lastTweaked, { arg view; 
		"there is a change! %: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet).postln;

		// map the last changed Param to the StaticText and TextField
		curval.mapParamLabel(Param.lastTweaked);
		editcurval.mapParam(Param.lastTweaked);
	});

	VLayout (
		HLayout (
			PlayerWrapper(target),
			curval, 
			editcurval,
		),
		HLayout (
			WindowDef(\ParamAsSoundFileView).asView(param),
			VLayout(
				* [
					Param(target, \pos, \unipolar),
					Param(target, \sustain, ControlSpec(0,10,\lin)),
					Param(target, \speed, ControlSpec(-2,2,\lin,0,1)),
				].collect({ arg pa;
					ParamGroupLayout.knobView(pa);
				}) ++ [nil]
			),
		),
		param.asView,
		Param(target, \gain, \unipolar).asView,
		Param(target, \dur, ControlSpec(0.1,8,\exp)).asView,
		Param(target, \adsr ).asView,
	)
});
);


///////////////////// with tracklist

(
FileSystemProject.load("libdef/tracklist.scd");
FileSystemProject.load("libdef/tracklist_buildertrack.scd");
)

TrackDef(\tlist, TrackTemplateDef(\TrackList))
TrackDef(\tlist).elAt(1).instrumentId = [\TrackInstrument, (\BuilderTrack -> \BuilderTrack)];
TrackDef(\tlist).elAt(1).instrument.source = Builder(\drumscore);

TrackDef(\tlist).elAt(1).clearAllChannelParts
TrackDef(\tlist).clear

(

Builder(\drumscore, { arg def, trackCount=5;
	var name = def.key;
	def.proto.seqlist = 5.collect { arg idx;
		Param(Pdef(name+++\seq +++ idx), \velamp -> \stepseq, \unipolar)
	};

	def.proxy = Pdef(name+++\seqlist, 
		Ppar(
			trackCount.collect { arg idx;
				var pat;
				pat = Pbind(
					\muter, Pif(\velamp > 0, {0}, {\rest}),
				) <>
				Pbindef(name+++\seq+++idx,
					\instrument, \sampler,
					//\velamp, PstepSeq(0!8,inf),
				);
				if(Pbindef(name+++\seq+++idx).source.at(\velamp).source.isNil) {
					Pbindef(name+++\seq+++idx,
						\velamp, PstepSeq(0!8,inf),
					);
				};
				pat;
			};
		)
	);

	def.editor = WindowDef(name+++\editor, { arg wdef;
		var durParam = Param(Pdef(name+++\seq0), \dur, ControlSpec(0.1,8,\exp));
		var durView = durParam.asView;
		var seqlist = def.proto.seqlist;
		var player = PlayerWrapper(Pdef(name+++\seqlist)).asView;
		durParam.onChange({
			seqlist[1..].do({ arg x; Param(x.target, \dur).set( durParam.get ) })
		}, player);
		VLayout (
			HLayout (
				player,
				durView,
			),
			VLayout(
				* seqlist.collect { arg item, idx;
					HLayout (
						BasicButton.new.string_(\seq+++idx).action_({
							WindowDef(\sampleEditor).front(Param(item.target, \bufnum))
						}),
						item.asMultiSlider,
					)
				}
			)
		)
	});
});

WindowDef(\sampleEditor, { arg def, param;
	var popup;
	var spec;
	var curval, editcurval;
	var target = param.target;
	curval = StaticText.new.minWidth_(80).align_(\right);
	editcurval = TextField.new;
	spec = ParamAudioBufferSpec(2)
		.startParamName_(\pos)
		.sustainParamName_(\sustain)
		.speedParamName_(\speed)
		;
	param.spec = spec;

	curval.followChange(Param, \lastTweaked, { arg view; 
		"there is a change! %: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet).postln;

		// map the last changed Param to the StaticText and TextField
		curval.mapParamLabel(Param.lastTweaked);
		editcurval.mapParam(Param.lastTweaked);
	});

	VLayout (
		HLayout (
			PlayerWrapper(target),
			curval, 
			editcurval,
		),
		HLayout (
			WindowDef(\ParamAsSoundFileView).asView(param),
			VLayout(
				* [
					Param(target, \pos, \unipolar),
					Param(target, \sustain, ControlSpec(0,10,\lin)),
					Param(target, \speed, ControlSpec(-2,2,\lin,0,1)),
				].collect({ arg pa;
					ParamGroupLayout.knobView(pa);
				}) ++ [nil]
			),
		),
		param.asView,
		Param(target, \gain, \unipolar).asView,
		Param(target, \dur, ControlSpec(0.1,8,\exp)).asView,
		Param(target, \adsr ).asView,
	)
});

WindowDef(\PartView, { arg def, track;
	
		var cellplayer;
		var editView = View.new;
		var tlist = track.parentTrack;
		cellplayer = PlayerWrapperView.new;

		//track.instrumentId = [\TrackInstrument, (\BuilderTrack -> \BuilderTrack)];
		//track.instrument.source = Builder(\demo_builder);

		editView.followChange(tlist, \selectedPart, {
			var part = track.childAt(tlist.selectedPart);
			var score = part.score;
			cellplayer.model = PlayerWrapper(part);
			editView.removeAll;
			editView.layout = if(part.isEmpty.not) {
				part.asView;
			} {
				VLayout (
					BasicButton.new.string_("Create").action_({
						part.makeScore;
						tlist.changed(\selectedPart);
					})
				)
			};
		});

		VLayout (
			HLayout (
				cellplayer.asView.fixedWidth_(100),
				StaticText.new.string_("Part:"),
				Param(Message(tlist), \selectedPart, ControlSpec(0,16,\lin,1)).asNumberBox,
			),
			editView,
		)
}).front(TrackDef(\tlist).elAt(1));
);


////////////////////////////////////:
// build directly using TrackList



(
FileSystemProject.load("libdef/tracklist.scd");
FileSystemProject.load("libdef/tracklist_buildertrack.scd");
)

TrackDef(\myseq, TrackTemplateDef(\TrackList))
(
TrackDef(\myseq).elAt(1).makeInstrument = { arg self;
	
	self.instrumentProxies = trackCount.collect { arg idx;
		Pbindef(name+++\seqbase,
			\instrument, \sampler,
			\muter, Pif(\velamp > 0, {0}, {\rest}),
		);
	};
};
TrackDef(\myseq).elAt(1).makePartScore = { arg self, partidx;
	
	self.instrumentProxies[idx] <> Pbindef(name+++\seq)
		Pbindef(name+++\seqbase,
			\instrument, \sampler,
			\muter, Pif(\velamp > 0, {0}, {\rest}),
		);
	};
};
)




TrackDef(\myseq).elAt(1).instrumentId = [\TrackInstrument, (\BuilderTrack -> \BuilderTrack)];
TrackDef(\myseq).elAt(1).instrument.source = Builder(\drumscore);

TrackDef(\myseq).elAt(1).clearAllChannelParts
TrackDef(\myseq).clear


//////////

		Pdefn(\pdefR, Pfunc({ arg ev; if(ev[\isRest]== true) { \ } { \ } }));
		Pdefn(\pdefR, Pfunc({ arg ev; if(ev[\isRest]== true) { \ } { \ } }));
		Pdefn(\pdefR, Pfunc({ arg ev; if(ev[\xisRest]== true) { \ } { 0 } }));
Pdefn(\pdefR, Pfunc({ arg ev; if(ev[\xisRest]== true) { 1 } { \ } }));
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\xisRest, Pseq([
			true, false, true, true, false, false,
		],inf),
		\bla, Pdefn(\pdefR),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\step, Pseq([
			1,0,0,0,
		],inf),
		\type, Pif(Pkey(\step) > 0, \note, \rest),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\isRest, Pseq([
			1,0,0,0,
		],inf).coin.not,
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);
