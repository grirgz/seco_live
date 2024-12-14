
// synthdefs listed in MenuSpecFuncDef(\patkitdef_synthdefs)
FileSystemProject.load("libdef/soundfileview.scd");
FileSystemProject.load("libdef/filedialog.scd");
(
// ~sampler_synthdef_list = [\playersec, \playerbeat] // define custom sampler synthdefs
Spec.add(\adsr, XEnvSpec.adsr);

WindowDef(\sampler, { arg def, child, show_buttons=true, player;
	// FIXME: no support for \mbufnum
	var pkey = \sampler;
	var anchor;
	var sndfileview;
	var layout;
	var updatebuffer;
	var buffer_popup = PopUpMenu.new;
	var buffer;
	var oldbuf;
	var paramgroup;
	var proxy;
	var isBufferTarget = true;
	var pgview;
	var refresh_pgview;
	var instrumentParam;
	var loadbutton;
	var bufcontroller;

	child.targetData.debug("targetData!!!!!");

	if(child.isEmpty) {
		//child.targetData.addHalo(\instrument, \playersec);
	};

	proxy = child.targetDataProxy;

	player = player ?? { 
		Pdef(\PatKitDef_test_player, child.pattern)
	};

	anchor = buffer_popup;

	sndfileview = View.new;
	sndfileview.fixedHeight = 100;

	// param group view
	pgview = View.new;
	refresh_pgview = {
		var bufnumname;
		pgview.removeAll;
		paramgroup  = ( child.asParamGroup ?? { ParamGroup([]) } )
		.add(Param(proxy, \sustain))
		.add(Param(proxy, \lag))
		;

		paramgroup.do { arg param, idx;
			if(param.property == \bufnum) {
				bufnumname = \bufnum;
			};
			if(param.property == \mbufnum) {
				bufnumname = \mbufnum;
			};
		};
		paramgroup = paramgroup.rejectByKey([\out, \bufnum]);
		pgview.layout = paramgroup.asView;

		if(bufnumname.isNil) {
			sndfileview.removeAll;
			buffer_popup.enabled = false;
			loadbutton.enabled = false;
		} {
			buffer = Param(proxy, bufnumname, TagSpec(
				BufDef.all.keys.as(Array).sort.collect({ arg x; x -> BufDef(x) })
			));
			oldbuf = nil;
			updatebuffer.();
			buffer_popup.enabled = true;
			loadbutton.enabled = true;
			buffer_popup.mapParam(buffer);
			bufcontroller.remove;
			bufcontroller = buffer.onChange(updatebuffer, anchor);
		};
	};
	instrumentParam = Param(Message(child), \instrument, TagSpecDef(\SynthDef_keys));

	//

	layout = VLayout (*
		if(show_buttons == true) {
			[
				HLayout (
					PlayerWrapper(player).asView,
					Param(proxy, \out, TagSpecDef(\BusDef_object)).asPopUpMenu,
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
				//Param(proxy, \instrument, TagSpecDef(\patkitdef_synthdefs)).asPopUpMenu,
				instrumentParam.asPopUpMenu,
				buffer_popup.addAction({
					// workaround because proxy doesnt update for buffer
					player.reset;
				}),
				loadbutton = BasicButton.new.string_("load").fixedWidth_(50).action_({ arg view;
					//Dialog.openPanel({ arg file;})
					WindowDef(\filedialog).front("./", { arg file;
						BufDef.stereo(file.asSymbol); // autoload it
						buffer.spec = MenuSpec(
							BufDef.all.keys.as(Array).sort.collect({ arg x; x -> BufDef(x) })
						);
						//buffer.spec.labelList.debug("labellist");
						//buffer_popup.items.debug("poplabellist");
						buffer.set(BufDef.stereo(file.asSymbol));
						player.reset;
						//buffer_popup.refreshChange;
					});
				})
			),
			pgview,
		]
	);
	//anchor.debug("anchor");
	updatebuffer = {
		var buf;
		if(buffer.isNil) {
			buf = nil
		} {
			buf = buffer.get;
		};
		if(buf.isKindOf(Integer)) {
			var path;
			path = TagSpecDef(\BufDef).unmapKey(buf);
			if(path.notNil) {
				buf = BufDef(path)
			}
		};
		buf.debug("buf");
		if(buf != 0 and: buf.notNil and: {oldbuf != buf}) {
			sndfileview.removeAll;
			sndfileview.layout = VLayout(WindowDef(\soundfileview).asView(
				buf,
				Param(proxy, \pos),
				Param(proxy, \sustain),
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
	instrumentParam.onChange({
		refresh_pgview.();
	}, pgview);
	refresh_pgview.();
	layout;
});

WindowDef(\PatKitDefEditor, (
	asView: { arg self, def, group, selectidx=0;
		var size = self.kitsize;
		var layout;
		var selector = List.new;
		var select, deselect;

		//"3".debug;
		self.def = def;
		self.pgroup = group;
		self.selector = List.new;
		//group.defaultTarget = self.default_stepevent;
		self.editlayout = View.new;
		self.makeKitLayout;
		//"4".debug;
		self.editCell(selectidx);
		self.defineBindings;

		def.windowName = "%: %".format("PatKitDefEditor", self.pgroup.key);

		//"6".debug;
		layout = HLayout (
			[VLayout (
				HLayout(
					self.make_saveas_button,
					self.make_loadfrom_button,
					self.make_main_menu_button,
				),
				self.kitlayout,
			), stretch:0],
			[self.editlayout, stretch:10],
			nil,
		);

		layout;
	},

	make_saveas_button: { arg self, def;
		var model = self.pgroup;
		BasicButton.new.fixedWidth_(100)
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
				model.savePresetCompileStringDialog(nil, {
					me.refreshChange;
				}, false);
			};
		})
		.mouseUpAction_({ arg me, x, y, mod, but;
			//[a,b,c,but].debug("but");
			if(but == 1) { // right click to force save as
				model.savePresetCompileStringDialog(nil, {
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
	},

	make_loadfrom_button: { arg self;
		BasicButton.new.string_("Load preset").action_({
			WindowDef(\GlobalLibrary_select).front(nil, { arg libid;
				self.pgroup.loadFrom(libid.last.value);
				self.refreshCells;
			}, \Kit)
		})
		
	},

	make_main_menu_button: { arg self;
		BasicButton.new.string_("...").fixedWidth_(20).action_({
			Menu(
				MenuAction("Clear all cells", {
					self.pgroup.clearChildren;
				}),
				MenuAction("Basic Recorder", {
					FileSystemProject.loadOnce("libdef/basicrecorder.scd");
					ProtoDef(\basicrecorder).edit;
				}),
				MenuAction("Record factory", {
					FileSystemProject.loadOnce("libdef/wip/RecordFactory.scd");
					ProtoDef(\RecordFactory).edit;
				}),
				Param(
					Message(self.pgroup),
					\controller, 
					ControllerDef.getTagSpec(\drumpad),
					//TagSpecDef(\NoteTimeline_controller),
				).asMenu("Controller"),
				//MenuAction("Recorder", {
					//ProtoDef(\recorder).edit // seems broken, in ex2/recordgui.scd
				//}),
			).front
		})
		
	},

	defineBindings: { arg self;
		var padkeys;
		var keyDownAction, keyUpAction;
		var def = self.def;
		padkeys = "&X\"'azerqsdfwxcv(-X_tyuighjkbn,;".as(Array);
		padkeys[1] = -23.asAscii;
		padkeys[1+16] = -24.asAscii;

		keyDownAction = { arg me, key, modifiers, unicode, keycode;
			var group = self.pgroup;
			var selected = self.selected;
			[me, key.asCompileString, modifiers, unicode, keycode].debug("samplekit keyDownAction");
			case
			{ modifiers.isCtrl and: { keycode == 99 } } { // ^c
				"copy!".debug;
				ParamViewToolBox.clipboard.windowdef_samplekit = group.elAt(selected).copy;
			}
			{ modifiers.isCtrl and: { keycode == 118 } } { // ^v
				"paste!".debug;
				if(ParamViewToolBox.clipboard.windowdef_samplekit.notNil) {
					group.pasteChild(selected, ParamViewToolBox.clipboard.windowdef_samplekit);
					//group.reboot;
					self.editCell(selected);
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
			var group = self.pgroup;
			[me, key.asCompileString, modifiers, unicode, keycode].debug("samplekit keyUpAction");
			case
			{ modifiers == 0 and:{ padkeys.includes(key) }} {
				var idx = padkeys.indexOf(key);
				"stop!".debug(idx);
				group.elAt(idx).stop;
			}
			;

		};

		if(self.def.window.notNil) {
			def.window.view.keyDownAction = keyDownAction;
			def.window.view.keyUpAction = keyUpAction;
		};
		
	},

	editCell: { arg self, idx;
		var drum = self.pgroup.elAt(idx);
		"ed1".debug;
		self.selectCell(idx);
		"ed2".debug;
		self.editlayout.removeAll;
		self.editlayout.layout = VLayout(
			//WindowDef(\vertical_paramgroup).asView(drum.target.asParamGroup)
			WindowDef(\sampler).asView(drum)
		);

	},

	refreshCells: { arg self;
		self.selector.do { arg cell, idx;
			if(self.selected == idx) {
				self.selectCell(idx)
			} {
				self.deselectCell(idx)
			};
		};
		
	},

	selectCell: { arg self, x;
		self.deselectCell(self.selected);
		self.selected = x;
		self.selector[x].background_(ParamViewToolBox.color_dark);
		//self.pgroup.reboot;
	},

	deselectCell: { arg self, x;
		var tar;
		//"x1".debug;
		//tar = group.elAt(x).target;
		//"x2".debug;
		self.selector[x].background = if(self.pgroup.elAt(x).isEmpty) {
			Color.white
		} {
			ParamViewToolBox.color_ligth;
		};
		//"x3".debug;
	},

	//default_stepevent: { StepEvent.newFrom((instrument: \playersec)) },
	selected: 0,
	kitsize: Point(4,8),

	makeKitLayout: { arg self;
		self.kitlayout = VLayout (*
			self.kitsize.y.collect({ arg y;
				HLayout(*
					self.kitsize.x.collect({ arg x;
						var idx = y*self.kitsize.x+x;
						var button;
						//"2.3".debug;
						button = BasicButton.new.string_(idx).fixedSize_(50@50)
						.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
							[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
							//"3".debug;
							if(buttonNumber == 0) {
								self.pgroup.elAt(idx).play;
							};
							if(buttonNumber == 1) {
								self.editCell(idx);
							};
						})
						//.keyDownAction_(keyDownAction)
						.action_({
							self.pgroup.elAt(idx).stop;
						});
						//"2.5".debug;
						self.selector.add(button);
						self.deselectCell(idx);
						//"2.6".debug;
						button;
					})
					++ [ nil ]
				)
			})
			++ [ nil ]
		);
		
	},

));
WindowDef(\samplekit, WindowDef(\PatKitDefEditor));

// add popup menu to choose patkitdef
// used in KitTimeline
// deprecated: drumkit can load preset, and menu allow to change source
WindowDef(\KitTimeline_PatKitDefEditor, (
	parent: WindowDef(\samplekit).proto,
	makeFollower: { arg self;
		Log(\Param).debug("timeline: %", self.timeline);
		self.editlayout.followChange(self.timeline, \wrapper, {
			Log(\Param).debug("KitTimeline_PatKitDefEditor: wrapper");
			//self.pgroup.defaultTarget = self.default_stepevent;
			self.selector.do { arg item, idx;
				self.deselectCell(idx);
			};
		});
	},
	pgroup: { arg self;
		self.timeline.wrapper;
	},
	asView: { arg self, def, timeline, selectidx=0;
		var size = self.kitsize;
		var layout;
		var selector = List.new;
		var select, deselect;
		var group = timeline.wrapper;

		self.timeline = timeline;
		"3".debug;
		self.def = def;
		//self.pgroup = group;
		self.selector = List.new;
		self.editlayout = View.new;
		self.makeFollower;
		"3.5".debug;
		self.makeKitLayout;
		"4".debug;
		self.editCell(selectidx);
		self.defineBindings;

		"6".debug;
		layout = VLayout (
			HLayout(
				Param(Message(self.timeline), \wrapper, TagSpecDef(\PatKitDef)).asPopUpMenu,
				BasicButton.new.string_("Recorder").action_({ ProtoDef(\recorder).edit }),
				self.make_saveas_button,
			),
			HLayout (
				self.kitlayout,
				self.editlayout,
			),
			nil,
		);

		layout;
	},
));

ParamProto.init;
	
// to be insered in lib
//ProtoTemplateDef(\ParPlayerGroup)[\presetCompileString] = { arg self, varname="~ppg";
	//var str;
	//str = "%.targetsData = [\n%];".format(
		//self.refCompileString,
		//self.targets.collect({ arg target, idx;
			//var res;
			//if(target.isKindOf(StepEvent)) {
				//res = "\t%,\n".format(target.asCompileString);
			//} {
				//res = "\t%,\n".format(target.presetCompileString.stripWhiteSpace)
			//};
			//res;
		//}).join
	//);
	//str;
//};
//ProtoTemplateDef(\ParPlayerGroup)[\asPresetCompileString] = ~parPlayerGroup[\presetCompileString]; // backward compat
//ProtoTemplateDef(\ParPlayerGroup)[\edit] = { arg self, idx=0;
	//WindowDef(\samplekit_+++self.key, WindowDef(\samplekit)).front(self, idx);
//};
//ProtoTemplateDef(\ParPlayerGroup)[\startControl] = { arg self;
	//var count = 0;

	//MKtl(\lp, "novation-launchpad-s");
	//MKtl(\lp).elAt(\pad).do({ arg el, i;
		//var idx = count;

		//[i, i%8 < 4, idx].debug("i, iii, idx");
		//if(i%8 < 4) {

			//el.elAt(0).action = {
				//self.elAt(idx).play;
			//};
			//el.elAt(1).action = {
				//self.elAt(idx).stop;
			//};
			//count = count + 1;
		//}
	//})
//};

// update existing instances
//PatKitDef.all.do({ arg inst;
	//inst[\presetCompileString] = ~parPlayerGroup[\presetCompileString];
	//inst[\asPresetCompileString] = ~parPlayerGroup[\asPresetCompileString];
	//inst[\edit] = ~parPlayerGroup[\edit];
	//inst[\startControl] = ~parPlayerGroup[\startControl];
//});

);


// END


WindowDef(\samplekit_monolithic, { arg def, group, selectidx=0; // deprecated, broken
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

	group.defaultTarget = default_stepevent;

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
					model.savePresetCompileStringDialog(nil, {
						me.refreshChange;
					}, false);
				};
			})
			.mouseUpAction_({ arg me, x, y, mod, but;
				//[a,b,c,but].debug("but");
				if(but == 1) { // right click to force save as
					model.savePresetCompileStringDialog(nil, {
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
		//"x1".debug;
		//tar = group.elAt(x).target;
		//"x2".debug;
		selector[x].background = if(group.elAt(x).isEmpty) {
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
	edit.(selectidx);

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



//////////////////////////////



WindowDef(\samplekit2).front(PatKitDef(\ksh2))
WindowDef(\KitTimeline_PatKitDefEditor).front(KitTimeline(\test3))
KitTimeline(\test3).edit
KitTimeline(\test3).changed(\wrapper)
KitTimeline(\test).kit.elAt(2)

KitTimeline(\test4).edit


WindowDef(\samplekit2).front
WindowDef(\samplekit3, WindowDef(\samplekit2)).front

(
WindowDef(\samplekit_child, (
	parent: WindowDef(\samplekit3).proto,
)).front;
)

WindowDef(\samplekit).front(PatKitDef(\ksh2))
PatKitDef.all
FileSystemProject.load("repeat/capsule/PatKitDef_ksh.scd")
FileSystemProject.load("repeat/capsule/PatKitDef_rim.scd")
ParamProto.init(true)
