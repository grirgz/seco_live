
// synthdefs listed in MenuSpecFuncDef(\patkitdef_synthdefs)
FileSystemProject.load("libdef/soundfileview.scd");
(
// ~sampler_synthdef_list = [\playersec, \playerbeat] // define custom sampler synthdefs
Spec.add(\adsr, XEnvSpec.adsr);

WindowDef(\sampler_new, { arg def, target, show_buttons=true;
	// new version not working so not used for the moment
	var pkey = \sampler;
	var anchor;
	var sndfileview = View.new;
	var layout;
	var updatebuffer;
	var buffer = Param(target, \bufnum, MenuSpec(
		BufDef.all.keys.as(Array).sort.collect({ arg x; x -> BufDef(x) })
	));
	var buffer_popup = PopUpMenu.new;
	var oldbuf;
	anchor = buffer_popup;
	buffer_popup.mapParam(buffer);
	layout = VLayout (*
		if(show_buttons == true) {
			[
				HLayout (
					PlayerWrapper(target).asView,
					Param(target, \out, MenuSpec(
						//[ \default -> nil, \0 -> 0 ] ++ BusDef.all.keys.as(Array).sort.collect({ arg x; x -> BusDef(x) })
						[ \0 -> 0 ] ++ BusDef.all.keys.as(Array).sort.collect({ arg x; x -> BusDef(x) })
					)).asPopUpMenu,
				),
			]
		} {
			[]
		}
		++
		[
			sndfileview,
			HLayout (
				//Param(target, \instrument, MenuSpec(
				//	~sampler_synthdef_list ? [\playersec]
				//)).asPopUpMenu,
				Param(target, \instrument, MenuSpecFuncDef(\patkitdef_synthdefs)).asPopUpMenu,
				buffer_popup,
				BasicButton.new.string_("load").action_({ arg view;
					Dialog.openPanel({ arg file;
						BufDef(file.asSymbol); // autoload it
						buffer.spec = MenuSpec(
							BufDef.all.keys.as(Array).sort.collect({ arg x; x -> BufDef(x) })
						);
						buffer.spec.labelList.debug("labellist");
						buffer_popup.items.debug("poplabellist");
						buffer.set(BufDef(file.asSymbol));
						//buffer_popup.refreshChange;
					});
				})
			),
			target.asParamGroup
				.add(Param(target, \sustain))
				.add(Param(target, \lag))
				.asView
		]
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

WindowDef(\sampler, { arg def, target, show_buttons=true, player;
	var pkey = \sampler;
	var anchor;
	var sndfileview = View.new;
	var layout;
	var updatebuffer;
	var buffer = Param(target, \bufnum, MenuSpec(
		BufDef.all.keys.as(Array).sort.collect({ arg x; x -> BufDef(x) })
	));
	var buffer_popup = PopUpMenu.new;
	var oldbuf;
	var paramgroup;
	var proxy;
	target.debug("target!!!!!");
	paramgroup  = ( target.asParamGroup ?? { ParamGroup([]) } )
		.add(Param(target, \sustain))
		.add(Param(target, \lag))
		.asView
	;
	proxy = player ?? { if(target.isKindOf(StepEvent)) {
		EventPatternProxy.new.source(target) // FIXME: not sure if working
	} {
		target
	}};
	anchor = buffer_popup;
	buffer_popup.mapParam(buffer);
	layout = VLayout (*
		if(show_buttons == true) {
			[
				HLayout (
					PlayerWrapper(proxy).asView,
					Param(target, \out, MenuSpec(
						//[ \default -> nil, \0 -> 0 ] ++ BusDef.all.keys.as(Array).sort.collect({ arg x; x -> BusDef(x) })
						[ \0 -> 0 ] ++ BusDef.all.keys.as(Array).sort.collect({ arg x; x -> BusDef(x) })
					)).asPopUpMenu,
				),
			]
		} {
			[]
		}
		++
		[
			sndfileview,
			HLayout (
				//Param(target, \instrument, MenuSpec(
				//	~sampler_synthdef_list ? [\playersec]
				//)).asPopUpMenu,
				Param(target, \instrument, MenuSpecFuncDef(\patkitdef_synthdefs)).asPopUpMenu,
				buffer_popup,
				BasicButton.new.string_("load").action_({ arg view;
					Dialog.openPanel({ arg file;
						BufDef(file.asSymbol); // autoload it
						buffer.spec = MenuSpec(
							BufDef.all.keys.as(Array).sort.collect({ arg x; x -> BufDef(x) })
						);
						//buffer.spec.labelList.debug("labellist");
						//buffer_popup.items.debug("poplabellist");
						buffer.set(BufDef(file.asSymbol));
						//buffer_popup.refreshChange;
					});
				})
			),
			paramgroup,
		]
	);
	//anchor.debug("anchor");
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
	var size = Point(4,8);
	var edit;
	var layout;
	var editlayout, kitlayout;
	var selector = List.new;
	var select, deselect;
	var selected = 0;
	var default_stepevent = { StepEvent.newFrom((instrument: \playersec)) };
	var make_saveas_button;
	var keyDownAction, keyUpAction;
	var padkeys;

	padkeys = "&X\"'azerqsdfwxcv(-X_tyuighjkbn,;".as(Array);
	padkeys[1] = -23.asAscii;
	padkeys[1+16] = -24.asAscii;

	keyDownAction = { arg me, key, modifiers, unicode, keycode;
		[me, key.asCompileString, modifiers, unicode, keycode].debug("samplekit keyDownAction");
		case
			{ modifiers.isCtrl and: { keycode == 99 } } { // ^c
				"copy!".debug;
				~windowdef_samplekit_clipboard = group.elAt(selected).target.copy;
			}
			{ modifiers.isCtrl and: { keycode == 118 } } { // ^v
				"paste!".debug;
				if(~windowdef_samplekit_clipboard.notNil) {
					group.elAt(selected).target = ~windowdef_samplekit_clipboard.copy;
					group.reboot;
					edit.(selected);
				};
			}
			{ modifiers == 0 and:{ padkeys.includes(key) }} {
				var idx = padkeys.indexOf(key);
				"play!".debug(idx);
				group.elAt(idx).play;
			}
		;
	};
	keyUpAction = { arg me, key, modifiers, unicode, keycode;
		[me, key.asCompileString, modifiers, unicode, keycode].debug("samplekit keyUpAction");
		case
			{ modifiers == 0 and:{ padkeys.includes(key) }} {
				var idx = padkeys.indexOf(key);
				"stop!".debug(idx);
				group.elAt(idx).stop;
			}
		;
		
	};

	if(def.window.notNil) {
		def.window.view.keyDownAction = keyDownAction;
		def.window.view.keyUpAction = keyUpAction;
	};

	"1".debug;
	make_saveas_button = { 
		var model = group;
		BasicButton.new
			.action_({ arg me;
				if(model.presetCompileStringSavePath.notNil) {
					var dialog;
					dialog = Window.new("Save").layout_(
						VLayout(
							StaticText.new.string_("Save this object to the file % ?".format(model.presetCompileStringSavePath.asCompileString)),
							HLayout(
								nil,
								BasicButton.new.string_("OK").action_({ 
									model.savePresetCompileString;
									me.refreshChange;
									dialog.close;
								}),
								BasicButton.new.string_("Cancel").action_({
									dialog.close;
								}),
							)
						)
					).setInnerExtent(600,140).front;
				} {
					model.savePresetCompileString(nil, {
						me.refreshChange;
					}, false);
				};
			})
			.mouseUpAction_({ arg me, x, y, mod, but;
				//[a,b,c,but].debug("but");
				if(but == 1) { // right click
					model.savePresetCompileString(nil, {
						me.refreshChange;
					}, true)
				}
			})
			.refreshChangeAction_({ arg me;
				if(model.presetCompileStringSavePath.notNil) {
					me.string = "Save"
				} {
					me.string = "Save as"
				};
			})
			.refreshChange
		;
	};


	select = { arg x;
		deselect.(selected);
		selected = x;
		selector[x].background_(ParamViewToolBox.color_dark);
		group.reboot;
	};
	deselect = { arg x;
		var tar;
		"x1".debug;
		tar = group.elAt(x).target;
		"x2".debug;
		selector[x].background = if(tar.isNil or: { tar == default_stepevent.() }) {
			Color.white
		} {
			ParamViewToolBox.color_ligth;
		};
		"x3".debug;
	};
	"2".debug;

	kitlayout = VLayout (*
		size.y.collect({ arg y;
			HLayout(*
				size.x.collect({ arg x;
					var idx = y*size.x+x;
					var button;
						"2.3".debug;
					button = BasicButton.new.string_(idx).fixedSize_(50@50)
					.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
						[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
						"3".debug;
						if(buttonNumber == 0) {
							group.elAt(idx).play;
						};
						if(buttonNumber == 1) {
							edit.(idx);
						};
					})
					//.keyDownAction_(keyDownAction)
					.action_({
						group.elAt(idx).stop;
					});
					"2.5".debug;
					selector.add(button);
					deselect.(idx);
					"2.6".debug;
					button;
				})
				++ [ nil ]
			)
		})
		++ [ nil ]
	);
	"4".debug;

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

						"5".debug;
	editlayout = View.new;
	edit.(0);

						"6".debug;
	layout = HLayout (
		VLayout (
			HLayout(
				BasicButton.new.string_("Recorder").action_({ ProtoDef(\recorder).edit }),
				make_saveas_button.(),
			),
			kitlayout,
		),
		editlayout,
		nil,
	);

	layout;
});

ParamProto.init;
	
// to be insered in lib
~parPlayerGroup[\presetCompileString] = { arg self, varname="~ppg";
	"%.targets = [\n%];".format(
		varname,
		self.targets.collect({ arg target, idx;
			var xtar = target.copy;
			var template_key = "Buffer.new";
			var bufnum_compilestring;
			var res;
			res = "\t%,\n".format(target.asCompileString);
			res;
		}).join
	)
};
~parPlayerGroup[\asPresetCompileString] = ~parPlayerGroup[\presetCompileString]; // backward compat
~parPlayerGroup[\edit] = { arg self;
	WindowDef(\samplekit_+++self.key, WindowDef(\samplekit)).front(self);
};
~parPlayerGroup[\startControl] = { arg self;
	var count = 0;

	MKtl(\lp, "novation-launchpad-s");
	MKtl(\lp).elAt(\pad).do({ arg el, i;
		var idx = count;

		[i, i%8 < 4, idx].debug("i, iii, idx");
		if(i%8 < 4) {

			el.elAt(0).action = {
				self.elAt(idx).play;
			};
			el.elAt(1).action = {
				self.elAt(idx).stop;
			};
			count = count + 1;
		}
	})
};

// update existing instances
PatKitDef.all.do({ arg inst;
	inst[\presetCompileString] = ~parPlayerGroup[\presetCompileString];
	inst[\asPresetCompileString] = ~parPlayerGroup[\asPresetCompileString];
	inst[\edit] = ~parPlayerGroup[\edit];
	inst[\startControl] = ~parPlayerGroup[\startControl];
});

);


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

Param(StepEvent.newFrom((instrument: 'playersec')), 'sustain')

Pdef(\rono).asParamGroup.asView

StepEvent.newFrom((instrument: 'playersec')).asParamGroup
