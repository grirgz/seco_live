// deprecated, fresh code is in libdef/soundfileview.scd
// and libdef/drumkit.scd

(
SynthDef(\sampler, { arg out=0, gate=1, speed=1, pos=0, trigger=1, loop=0, bufnum;
	var sig;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:0, loop: loop);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1) * \velamp.kr(1);
	Out.ar(out, sig);
}).add;

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
	// deprecated, fresh code is in libdef/soundfileview.scd
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
		//"there is a change! %: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet).postln;

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
		//"there is a change! %: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet).postln;

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


////////

TrackDef(\myseq, TrackTemplateDef(\TrackList))

// individual init
(
TrackDef(\myseq).elAt(1).initTrack = { arg self;
	self.proxy = Pbindef(self.name+++\seqbase,
			\instrument, \sampler,
			\muter, Pif(\velamp > 0, {0}, {\rest}),
		);
	});
}
)


(
TrackDef(\myseq).elAt(1,0).initTrack = { arg self;
	self.proxy = Pdef(self.name+++\seq,
		Pdef(self.name+++\seqbase) <>
		Pbind(\velamp, PstepSeq(0!8,inf))
	);
}
)


//// generator


(
FileSystemProject.load("libdef/soundfileview.scd");
FileSystemProject.load("libdef/tracklist.scd");
FileSystemProject.load("libdef/tracklist_buildertrack.scd");
)

(
	// freshest version is in demo/param/CustomTrackList.scd
TrackTemplateDef(\CustomTrackList, (
	parent: TrackTemplateDef(\TrackList),
	childClass: { TrackTemplateDef(\CustomInstrumentTrack) },

));
TrackTemplateDef(\CustomInstrumentTrack, (
	parent: TrackTemplateDef(\InstrumentTrack),
	childClass: { TrackTemplateDef(\CustomInstrumentTrackPart) },

	new: { arg self, parent, index;
		self = ProtoClass(( parent: self ));

		self.selectChild(0);
		self.index = index.asInteger;
		self.parentTrack = {parent};
		self[\storeOn] = { arg self, str; str << self.refCompileString };
		self;
	},
	childAt: { arg self, idx;
		var ret;
		//idx.debug("childAt!!!!x");
		//this.dumpBackTrace;	
		self.children = self.children ?? { SparseArray.new };
		ret = self.children[idx] ?? { 
			self.children[idx] = self.childClass.new(self, idx);
			//idx.debug("childAt init!!!!");
			self.children[idx].initTrack;
			self.children[idx];
		};
		ret;
	},
	name: { arg self;
		self.trackKey;
	},

));
TrackTemplateDef(\CustomInstrumentTrackPart, (
	parent: TrackTemplateDef(\InstrumentTrackPart),
	new: { arg self, parent, index;
		self = ProtoClass(( parent: self ));

		self.parentTrack = {parent};
		self.index = index.asInteger;
		self[\storeOn] = { arg self, str; str << self.refCompileString };
		self;
	},

	initTrack: { arg self; 
		self.parentTrack.initChild(self);
	},

	name: { arg self;
		self.trackKey;
	},

	editor: { arg self;
		self.parentTrack.editor
	},

	asView: { arg self ...args;
		self.parentTrack.editor.asView(self, *args);
	},

	edit: { arg self;
		var target = self.source;
		if(self.editor.notNil) {
			self.editor.front(self);
		} {
			if(target.getHalo(\edit).notNil) {
				target.getHalo(\edit).value(target);
			} {
				if(target.isKindOf(Pdef)) {
					WindowDef(\PdefEditor).front(target)
				} {
					if(target.isKindOf(Ndef)) {
						WindowDef(\NdefEditor).front(target)
					} {
						target.edit
					}
				};
			};
		};
	},

));
)

TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))
TrackDef(\myseq).elAt(1)

(
TrackDef(\myseq).elAt(1).initTrack = { arg self;
	self.proxy = Pbindef(self.name+++\seqbase,
		\instrument, \sampler,
		\muter, Pif(\velamp > 0, {0}, {\rest}),
	);
	self.editor = WindowDef(self.name, { arg def, child;
		var editView = View.new;
		var cellplayer;
		var seqview = MultiSliderView.new;
		var createbut = BasicButton.new.string_("Create");
		var tlist = child.parentTrack.parentTrack;
		child.debug("edit: child:");
		cellplayer = PlayerWrapperView.new;
		editView.layout = VLayout(
			seqview;
		);
		editView.followChange(tlist, \selectedPart, {
			var part, score;
			part = child.parentTrack.childAt(tlist.selectedPart);
			[child, tlist, tlist.selectedPart, part].debug("followChange: part");
			score = part.score;
			cellplayer.model = PlayerWrapper(part);
			if(part.isEmpty) {
				createbut.action_({
					[child, tlist, tlist.selectedPart, part].debug("createbut: part");
					part[\makeScore].asCompileString.debug("makeScore code");
					part.makeScore;
					tlist.changed(\selectedPart);
				});
				createbut.visible = true;
				editView.visible = false;
				seqview.unmapParam;
			} {
				createbut.visible = false;
				editView.visible = true;
				seqview.mapParam(
					Param(Pbindef(part.name+++\seq), \velamp -> \stepseq, ParamArraySpec())
				);
			};
			//Param(Pbindef(child.name+++\seq), \velamp -> \stepseq, ParamArraySpec()).asView;
		});
		VLayout (
			HLayout (
				cellplayer.asView.fixedWidth_(100),
				StaticText.new.string_("Part:"),
				Param(Message(tlist), \selectedPart, ControlSpec(0,16,\lin,1)).asNumberBox,
			),
			createbut,
			editView,
			nil
			//Param(Pbindef(child.name+++\seq), \velamp -> \stepseq, ParamArraySpec()).asView;
		)
	});
	self.initChild = { arg parent, child;
		child.name.debug("initChild!!!!");
		child.makeScore = { arg self;
			self.proxy = PlayerWrapper(Pdef(self.name+++\part,
				self.parentTrack.proxy <>
				Pbindef(self.name+++\seq, \velamp, PstepSeq(0!8,inf))
			));
			self.proxy.debug("makeScore proxy");
		}
	};
	self.childAt(self.activeIndex).initTrack; // compense early init of part 0
};
TrackDef(\myseq).elAt(1).initTrack;
)

TrackDef(\myseq).elAt(1).initTrack
TrackDef(\myseq).elAt(1,9).proxy.target
TrackDef(\myseq).elAt(1,1).proxy
TrackDef(\myseq).elAt(1).children
TrackDef(\myseq).elAt(1,13).edit
TrackDef(\myseq).elAt(1,14).edit
TrackDef(\myseq).elAt(1,15)[\makeScore].asCompileString
TrackDef(\myseq).elAt(1,15).makeScore
TrackDef(\myseq).elAt(1,15).edit
TrackDef(\myseq).elAt(1,5).proxy
TrackDef(\myseq).elAt(1,5)[\editor].asCompileString
TrackDef(\myseq).elAt(1,5).parentTrack[\editor].source.asCompileString
TrackDef(\myseq).elAt(1,5).parentTrack[\editor]
TrackDef(\myseq).elAt(1).children
TrackDef(\myseq).elAt(1).children
TrackDef(\myseq).elAt(1).clearAllChannelParts
TrackDef(\myseq).clear


///////////////////// adapt track init code to builder

// dont forget to load CustomTrackList
// problem: no separation from parent score in the builder


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
}).build;

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
		//"there is a change! %: %".format(Param.lastTweaked.asLabel, Param.lastTweaked.stringGet).postln;

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


TrackDef(\myseq).clear

TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))

(
TrackDef(\myseq).elAt(1).initTrack = { arg self;
	self.builder = Builder(\drumscore).buildInit;
	self.proxy = self.builder.proxy;
	self.editor = self.builder.editor;
	self.initChild = { arg parent, child;
		child.name.debug("initChild!!!!");
		child.asView = { arg self;
			self.builder.editor.asView(self);
		};
		child.makeScore = { arg self;
			self.builder = Builder(child.name+++\builder, self.parentTrack.builder).buildInit;
			self.proxy = PlayerWrapper(self.builder.proxy);
			self.proxy.debug("makeScore proxy");
		}
	};
	self.childAt(self.activeIndex).initTrack; // compense early init of part 0
};
TrackDef(\myseq).elAt(1).initTrack;
)

TrackDef(\myseq).elAt(1,0).editor
TrackDef(\myseq).elAt(1,0).parentTrack.editor
TrackDef(\myseq).elAt(1).editor
Builder(\drumscore).proto
Builder(\drumscore).proto.editor
TrackDef(\myseq).elAt(1,0).isEmpty
TrackDef(\myseq).elAt(1,0).makeScore
TrackDef(\myseq).elAt(1,0).edit

(
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
				//VLayout (
					//Slider.new;
				//)
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
});
WindowDef(\PartView).front(TrackDef(\myseq).elAt(1));
)



/////////////////////////////////


// start again


(
Pbindef(\sampler1,
	\instrument, \sampler,
	\muter, Pif(\velamp > 0, {0}, {\rest}),
)
)

(
Pbindef(\score1,
	\velamp, PstepSeq(1!8,inf),
);
Pdef(\part1, Pdef(\sampler1) <> Pdef(\score1))
)
Pdef(\part1).play;

(
WindowDef(\scoreEditor, { arg def, trackproxy, partproxy, scoreproxy;
	VLayout (
		PlayerWrapper(partproxy),
		HLayout (
			WindowDef(\sampleEditor).asView(Param(trackproxy, \bufnum)),
			Param(scoreproxy, \velamp -> \stepseq, \unipolar).asView,
		)
	)
	
}).front(Pdef(\sampler1), Pdef(\part1), Pdef(\score1));
);


/// now use tracklist


TrackDef(\myseq).clear

TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))

(
TrackDef(\myseq).elAt(1).initTrack = { arg self;
	self.base = Pbindef(self.name+++\base,
		\instrument, \sampler,
		\muter, Pif(\velamp > 0, {0}, {\rest}),
	);
	self.editor = WindowDef(self.name, { arg def, child;
		[self.base, child, child.score].debug("editor call scoreEditor");
		VLayout (
			if(child.score.notNil) {
				WindowDef(\scoreEditor).asView(self.base, child, child.score);
			}
			//Slider.new,
		)
	});
	self.initChild = { arg parent, child;
		child.name.debug("initChild!!!!");
		child.makeScore = { arg self;
			self[\score] = Pbindef(self.name+++\seq, \velamp, PstepSeq(0!8,inf));
			self.proxy = PlayerWrapper(Pdef(self.name+++\part,
				self.parentTrack.base <>
				self.score
			));
			self.proxy.debug("makeScore proxy");
		}
	};
	self.childAt(self.activeIndex).initTrack; // compense early init of part 0
};
TrackDef(\myseq).elAt(1).initTrack;
)

WindowDef(\scoreEditor).asView(self.base, child, child.score);

TrackDef(\myseq).elAt(1,1).edit
TrackDef(\myseq).elAt(1,0).score
WindowDef(\PartView).front(TrackDef(\myseq).childAt(1))

//// use template

(
	TrackTemplateDef(\SeqTrack, (
		parent: TrackTemplateDef(\CustomInstrumentTrack),
		makeScore: { arg self;
			self.base = Pbindef(self.name+++\base,
				\instrument, \sampler,
				\muter, Pif(\velamp > 0, {0}, {\rest}),
			);
			self.trackEditor = WindowDef(self.name+++\trackeditor, { arg def, child;
				WindowDef(\sampleEditor).asView(Param(self.base, \bufnum))
			});
			self.editor = WindowDef(self.name, { arg def, child;
				[self.base, child, child.score].debug("editor call scoreEditor");
				VLayout (
					if(child.score.notNil) {
						//WindowDef(\scoreEditor).asView(self.base, child, child.score);
						Param(child.score, \velamp -> \stepseq, \unipolar).asMultiSlider;
					}
					//Slider.new,
				)
			});
			self.childAt(self.activeIndex).initTrack; // compense early init of part 0
			self.isEmpty = false;
		},
		initChild: { arg parent, child;
			child.name.debug("initChild!!!!");
			child.makeScore = { arg self;
				self[\score] = Pbindef(self.name+++\seq, \velamp, PstepSeq(0!8,inf));
				self.proxy = PlayerWrapper(Pdef(self.name+++\part,
					self.parentTrack.base <>
					self.score
				));
				self.proxy.debug("makeScore proxy");
			}
		},
	))
)

TrackDef(\myseq).clear

TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))
TrackDef(\myseq).childAt(0).trackTemplate = TrackTemplateDef(\SeqTrack)
TrackDef(\myseq).childAt(0).parent = TrackTemplateDef(\SeqTrack)
TrackDef(\myseq).childAt(1).parent = TrackTemplateDef(\SeqTrack)
TrackDef(\myseq).childAt(2).parent = TrackTemplateDef(\SeqTrack)
TrackDef(\myseq).childAt(3).parent = TrackTemplateDef(\SeqTrack)
(
TrackDef(\myseq).childAt(0)
TrackDef(\myseq).childAt(0).makeScore;
TrackDef(\myseq).childAt(1).makeScore;
TrackDef(\myseq).childAt(2).makeScore;
)
TrackDef(\myseq).childAt(0,0).edit
TrackDef(\myseq).childAt(2,1).clear
TrackDef(\myseq).childAt(2).children[1] = nil
WindowDef(\PartView).front(TrackDef(\myseq).childAt(0))
WindowDef(\PartView).front(TrackDef(\myseq).childAt(1))
(
WindowDef(\win, { arg def;
	VLayout (
		WindowDef(\PartView).asView(TrackDef(\myseq).childAt(0)),
		WindowDef(\PartView).asView(TrackDef(\myseq).childAt(1)),
	)
	
}).front;
);
Pdef.defaultQuant = 1

(
WindowDef(\CustomTrackListEditor, { arg def, tlist;
		var editView = View.new;
		var lineplayer = PlayerWrapperView.new;

		//track.instrumentId = [\TrackInstrument, (\BuilderTrack -> \BuilderTrack)];
		//track.instrument.source = Builder(\demo_builder);

		editView.followChange(tlist, \selectedPart, {
			lineplayer.model = PlayerWrapper(tlist.linePlayerAt(tlist.selectedPart));
			editView.removeAll;
			editView.layout = VLayout(*
				8.collect({ arg idx;
					var track = tlist.childAt(idx);
					var part = track.childAt(tlist.selectedPart);
					var cellplayer;
					cellplayer = PlayerWrapperView.new;
					if(track.isEmpty.not) {
						if(part.isEmpty.not) {
							cellplayer.model = PlayerWrapper(part);
							HLayout (
								VLayout (
									cellplayer,
									BasicButton.new.string_("Edit").action_({
										track.trackEditor.front(track);
									}),
									nil,
								),
								part.asView,
							)
						} {
							VLayout (
								BasicButton.new.string_("Create Part").action_({
									part.makeScore;
									tlist.changed(\selectedPart);
								})
							)
						};
					} {
						VLayout (
							BasicButton.new.string_("Create Track").action_({
								track.makeScore;
								tlist.changed(\selectedPart);
							})
						)
					}
				})
			)
		});

		VLayout (
			HLayout (
				lineplayer.asView.fixedWidth_(100),
				StaticText.new.string_("Part:"),
				Param(Message(tlist), \selectedPart, ControlSpec(0,16,\lin,1)).asNumberBox,
			),
			editView,
		)
	
}).front(TrackDef(\myseq));
);

WindowDef(\sampleEditor).front(Param(TrackDef(\myseq).elAt(0).base, \bufnum));
TrackDef(\myseq).elAt(0).trackEditor.front
WindowDef(\playergrid).front(TrackDef(\myseq))

(
WindowDef(\playergrid, (
	
	asView: { arg self, me, maintrack;
		var viewgrid;
		var mainview;
		var make_view;
		var playerviews;
		var map_players;
		var mixerviews;
		maintrack = maintrack ?? { TrackDef(\main) };

		// commented because at caller level
		//if(me.window.notNil) {
		//	me.window.bounds = Rect(144, 217, 1090, 438);
		//};

		mainview = View.new;
		mainview.onChange(maintrack, \gridOffset, { {map_players.()}.defer });

		playerviews = { { PlayerWrapperGridCellView.new } ! 8 } ! 9;
		//mixerviews = { WindowDef(\mixerView).asView } ! 9;
		mixerviews = 9.collect({ arg x;
			var boxview;
			var delayview;
			var child;
			var mixer;
			var mixerview;
			if(maintrack.isMixerEnabled == false) {
				if(maintrack.showTrackHeaders == true) {
					if(x != 8) {
						child = maintrack.childAtOffset(x);
						[child, child.source, x].debug("showTrackHeaders: child");
						PlayerWrapper(child).asView.addUniqueMethod(\model_, { arg me, val;
							// NOOP
						});
					} {
						"volume!!!".debug;
						nil;
					}
				} {
					nil
				}
			} {
				boxview = View.new;
				child = maintrack.childAtOffset(x);
				if(child.notNil) {
					mixer = child.mixer;
					delayview = TextField.new;
					if(mixer.notNil) {
						delayview.mapParam( Param(mixer.proxy, \postdelay, ControlSpec(0,0.1,\lin)) );
						boxview.layout = VLayout (
							PlayerWrapper(mixer.proxy).label_(mixer.key).asView.font_(Font.default.copy.size_(8)),
							mixerview = WindowDef(\mixerView).asView(child),
							HLayout(StaticText.new.string_("postdelay:"), delayview),
						);
						mixerview.slider.minWidth_(10);
						boxview.background = Color.gray;
						boxview.maxWidth_(260);
						boxview.addUniqueMethod(\model_, { arg me, val;
							if(val.isMixerEnabled) {
								mixerview.model = val;
							}
						});
					};
				} {
					boxview.addUniqueMethod(\model_, { arg me, val;
						// NOOP
					});
				};
				if(mixer.notNil) {
					boxview;
				} {
					nil // NOTE: return nil of no mixer defined, change if we want to dynamically load mixer
				}
			}
		});

		if(me.window.notNil) {
			me.window.name = "playergrid: " ++ maintrack.key;
		};

		map_players = {
			playerviews.do({ arg track, x;
				track.do { arg child, y;
					if(x == 8) {
						child.model = maintrack.linePlayerAt(y+maintrack.gridOffset.y);
					} {
						child.model = maintrack.childAtOffset(Point(x,y));
					}
				};
			});
			mixerviews.do({ arg child, x;
				if(child.notNil) {
					if(x == 8) {
						child.model = Server.default.volume;
					} {
						child.model = maintrack.childAtOffset(x);
					}
				}
			})

		};

		make_view = {
			mainview.removeAll;
			mainview.layout = VLayout(
				GridLayout.columns(*
					playerviews.collect({ arg track, idx;
						track.collect({ arg child;
							var view = child.asView;
							view.button.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
								//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
								if(buttonNumber == 1) {
									if(child.model.isKindOf(PlayerWrapper)) {
										child.model.target.edit;
									} {
										child.model.edit;
									}
								};
							});
							view.layout.margins_(1);
							view.button.fixedWidth_(20);
							//view.labelView.fixedWidth_(49);
							//view.fixedSize_(Point(300,20));
							view.labelView.font_(Font.default.size_(10));
							//child.model.target.debug("childmodeltarget");
							//if(child.model.target.isEmpty == true) {
							//child.color_deselected = Color.gray;
							//};
							child.selected = false;
							view.labelView.mouseDownAction_({ arg label, x, y, modifiers, buttonNumber, clickCount;
								//"DOWN".debug;
								//view.selected = true
								if(clickCount == 2) {
									child.model.selectSourceDialog;
								};
							});
							view;
						})
						++ [ mixerviews[idx] ]
					})
				).vSpacing_(1).hSpacing_(1),
				nil
			)
		};
		map_players.();
		make_view.();
	}
));
)
TagSpecDef(\TrackTemplate).addUnique(\SeqTrack -> TrackTemplateDef(\SeqTrack))
TagSpecDef(\TrackTemplate).addUnique(\playertrack -> TrackTemplateDef(\playertrack))
TagSpecDef(\TrackTemplate).list
(
WindowDef(\SelectTrackTemplate, { arg def, track;
	var default;	
	var parent;
	parent = track.parent;
	Param( Message(track), \trackTemplate, TagSpecDef(\TrackTemplate) ).asPopUpMenu
});
WindowDef(\SelectTrackParent).front(TrackDef(\myseq).elAt(0));
);

///////////////////////////////////////:

FileSystemProject.load("libdef/tracks.scd");

TrackDef(\myseq).clear
TrackDef(\myseq).changed(\gridOffset)
TrackDef(\myseq).childAt(0)[\updateChildren].asCompileString

TrackTemplateDef(\CustomInstrumentTrack)[\updateChildren].asCompileString

TrackTemplateDef(\CustomTrackList).clear
TrackTemplateDef(\CustomInstrumentTrack).clear
TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))
TrackDef(\myseq).childAt(0).trackTemplate = TrackTemplateDef(\SeqTrack)
TrackDef(\myseq).children[0] = nil

TrackDef(\myseq).clear;
TrackDef(\myseq).isMixerEnabled = false
TrackDef(\myseq).showTrackHeaders = true
TrackDef(\myseq).showTrackHeaders = true
TrackDef(\myseq, TrackTemplateDef(\playergrid))
WindowDef(\playergrid).front(TrackDef(\myseq))
WindowDef(\playergrid).simpleControllerDict
~child.model.target


(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1/4,
		\amp, 0.1,
	)
).play;
);

(
Pbindef(\sampler_mono, 
	\instrument, \sampler_mono,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\pan, Pwhite(-1,1.0,inf),
	\gain, 0.1,
).play;
);

TrackMixerDef(\aze).edit


////////////////// use track template and cell template

