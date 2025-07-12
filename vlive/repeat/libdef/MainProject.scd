FileSystemProject.loadOnce("libdef/filedialog.scd");
FileSystemProject.loadOnce("libdef/filedialog_project.scd");
FileSystemProject.loadOnce("libdef/PlayerTracker.scd");
FileSystemProject.loadOnce("libdef/FxManager.scd");
FileSystemProject.loadOnce("libdef/simplemixer.scd");
FileSystemProject.loadOnce("libdef/tracks.scd");
FileSystemProject.loadOnce("libdef/tracklist.scd");
FileSystemProject.loadOnce("libdef/CustomTrackList.scd");
FileSystemProject.loadOnce("libdef/ParamSelectDialog.scd");
FileSystemProject.loadOnce("libdef/JackControl.scd");
FileSystemProject.loadOnce("libdef/mixerPreset.scd");

FileSystemProjectTemplate('MainProject', (
	parent: FileSystemProject.defaultProject,
	edit: { arg self;
		WindowDef(\MainProject).front(self);
	},

	dataPath: { arg self;
		self.projectPath +/+ "data";
	},

	saveProject: { arg self, path, onDoneAction;
		self.dataPath.mkdir;
		path = path ? (self.dataPath +/+ "project.scd");
		PlayerWrapper_Base.savePresetCompileStringHelper(path, onDoneAction, self.refCompileString, self.presetCompileString, false);
		self.resources.do { arg resource;
			Log(\Param).debug("Saving resource %".format(resource));
			resource.presetCompileStringSavePath = self.dataPath; // presetCompileStringProjectDataPath can be a file
			resource.presetCompileStringProjectDataPath = self.dataPath; // always the datapath
			resource.loadedFromPath = self.dataPath; // FIXME: this bypass the overwrite protection mecanism for debug
			resource.savePresetCompileString;
		}
	},

	newProjectDialog: { arg self;
		WindowDef(\filedialog_project_save).front(nil, { arg path, name;
			var proj, projlabel;
			[path, name].debug("new project");
			proj = FileSystemProject(path +/+ name, ProtoTemplateDef(\MainProject));
			//proj.projectPath = path +/+ name;
			FileSystemProject.current = proj;
			//projlabel.string_(FileSystemProject.unresolve(proj.key.asString));
		}).windowName_("Choose New Project File"); 
	},

	openProjectDialog: { arg self;
		WindowDef(\filedialog_project).front(nil, { arg path;
			var proj, projlabel;
			[path].debug("open project");
			proj = ProtoTemplateDef(\MainProject).loadProject(path);
			//projlabel.string_(FileSystemProject.unresolve(proj.key.asString));
		}).windowName_("Open Project File"); 
	},

	projectPath: { arg self;
		self.key.asString;
	},

	refCompileString: { arg self;
		"FileSystemProject(%)".format(FileSystemProject.unresolve(self.key.asString).asCompileString);
	},

	label: { arg self;
		FileSystemProject.unresolve(self.key.asString)
		//self.name;
	},

	isClockMeterEnabled_: { arg self, val;
		self[\isClockMeterEnabled] = val;
		self.changed(\isClockMeterEnabled);
	},

	presetCompileString: { arg self;
		[
			"FileSystemProject(%, \\MainProject);".format(FileSystemProject.unresolve(self.key.asString).asCompileString),
			"%.mainMixer; // create mixer".format(self.refCompileString),
			"%; // return project\n".format(self.refCompileString),
		].join("\n")
	},

	loadProject: { arg self, path;
		var projectfile;
		var proj;
		path = path ?? { self.path };
		path.debug("path");
		if(path.endsWith("data/project.scd")) {
			projectfile = path;
		} {
			projectfile = path +/+ "data/project.scd";
		};
		proj = FileSystemProject.load(projectfile);
		FileSystemProject.current = proj;
		PathName(proj.dataPath).files.do { arg file;
			if(file.extension == "scd" and: { file.fileName != "project.scd" }) {
				FileSystemProject.load(file.fullPath)
			}
		};
		// load first level of folders in data/ (for grids)
		PathName(proj.dataPath).folders.do { arg folder;
			folder.files.do { arg file;
				if(file.extension == "scd" and: { file.fileName != "project.scd" }) {
					FileSystemProject.load(file.fullPath)
				}
			};
		};
		Log(\Param).debug("changed project!! c %, p %, s %", FileSystemProject.current, proj, self);
		//FileSystemProject.changed(\project); // change should be central
		proj;
	},

	playerTracker: { arg self;
		self[\playerTracker] = ProtoDef("PlayerTracker_%".format(self.name).asSymbol, ProtoTemplateDef(\PlayerTracker));
		self[\playerTracker];
	},

	name: { arg self;
		PathName(self.key.asString).fileName
	},

	addResource: { arg self, resource;
		// the path is only set at save time, don't know why
		// maybe in case we added the wrong resource and want to remove it
		if(resource.notNil) { // prevent error when ProtoTemplateDef proto are not loaded and return nil
			var oldsize;
			if(self.resources.isNil) {
				self.resources = IdentitySet.new;
			};
			oldsize = self.resources.size;
			self.resources.add(resource);
			if(oldsize != self.resources.size) { 
				// this test is to avoid infinite loop, 
				// when refreshing project, GUI ask for mainTimeline which add itself to resources
				FileSystemProject.changed(\project);
			}
		}
	},

	removeResource: { arg self, resource;
		var oldsize;
		if(self.resources.isNil) {
			self.resources = IdentitySet.new;
		};
		oldsize = self.resources.size;
		self.resources = self.resources.remove(resource);
		if(oldsize != self.resources.size) { 
			// this test is to avoid infinite loop, 
			// when refreshing project, GUI ask for mainTimeline which add itself to resources
			FileSystemProject.changed(\project);
		}
	},

	mainTrackList: { arg self;
		var tracklistname = "%_mainTrackList".format(self.name).asSymbol; 
		if(TrackDef(tracklistname).isNil or: {
			TrackDef(tracklistname).name.isNil
		}) {
			TrackDef(tracklistname, TrackTemplateDef(\CustomTrackList));
			self.addResource(TrackDef(tracklistname));
		};
		TrackDef(tracklistname);
	},

	mainTrackGrid: { arg self;
		var tracklistname = "%_mainTrackGrid".format(self.name).asSymbol; 
		if(TrackDef(tracklistname).isNil or: {
			TrackDef(tracklistname).name.isNil
		}) {
			TrackDef(tracklistname, TrackTemplateDef(\playergrid));
			self.addResource(TrackDef(tracklistname));
		};
		TrackDef(tracklistname);
	},

	mainMixer: { arg self;
		if(self.mainMixer_value.isNil) {
			self.mainMixer_value = ProtoDef("%_mainMixer".format(self.name).asSymbol, ProtoTemplateDef(\simpleMixer)).init;

			self.addResource(self.mainMixer_value);
		};
		self.mainMixer_value;
	},

	mainTimeline: { arg self;
		if(self.mainTimeline_value.isNil) {
			self.mainTimeline_value = ClipTimeline("%_mainTimeline".format(self.name).asSymbol);
			self.addResource(self.mainTimeline_value);
		};
		self.mainTimeline_value;
	},

	fxManager: { arg self;
		if(self.fxManager_value.isNil) {
			self.fxManager_value = ProtoDef(\FxManager);
			self.addResource(self.fxManager_value);
		};
		self.fxManager_value;
	},

	/////////////

	play: { arg self;
		~master.();
		self.playerTracker.play;
		self.changed(\PlayerWrapper, \userPlayed);
		PlayerWrapper(self).doWithQuant {
			self.changed(\PlayerWrapper, \playing);
		};
	},

	stop: { arg self;
		self.playerTracker.stop;
		self.changed(\PlayerWrapper, \userStopped);
		PlayerWrapper(self).doWithQuant {
			self.changed(\PlayerWrapper, \stopped);
		};
	},

	isPlaying: { arg self;
		self.playerTracker.isPlaying;
	},
));
ProtoTemplateDef(\MainProject, FileSystemProjectTemplate(\MainProject)); // compat

ProtoTemplateDef(\SimpleProject, ( // this is like having no project
	parent: FileSystemProjectTemplate(\MainProject),

	mainTrackList: { arg self;
		var tracklistname = "%_mainTrackList".format(self.name).asSymbol; 
		if(TrackDef(tracklistname).isNil or: {
			TrackDef(tracklistname).name.isNil
		}) {
			TrackDef(tracklistname, TrackTemplateDef(\CustomTrackList));
			self.addResource(TrackDef(tracklistname));
		};
		TrackDef(tracklistname);
	},

	mainMixer: { arg self;
		ProtoDef(\simpleMixer)
	},

	mainTimeline: { arg self;
		ClipTimeline(\mainTimeline)
	},

	fxManager: { arg self;
		ProtoDef(\FxManager);
	},
));
FileSystemProject('repeat/simpleProject', ProtoTemplateDef(\SimpleProject)); // FIXME: hardcoded and fail when no directory manually created



///// GUI

(
WindowDef(\MainProject, { arg def, proj;
	var mainview;
	var meter = SimpleServerMeterView.new(nil, 0,2);
	var projlabel = StaticText.new;
	var rdnbuttons;
	var playerViewList;
	var otherResources, otherResourcesView;
	var isRefreshing = false;
	proj = proj ?? { FileSystemProject.current ?? { FileSystemProject('repeat/simpleProject') } };
	if(FileSystemProject.current.isNil) {
		FileSystemProject.current = proj;
	};
	projlabel.string_(FileSystemProject.unresolve(proj.key.asString));
	//var meter = ServerMeterView.new;
	proj.playerTracker.addPlayer(*[
		proj.mainMixer,
		proj.fxManager,
		proj.mainTimeline,
		proj.mainTrackList,
		proj.mainTrackGrid,
		Pdef(\main),
		Pdef(\part),
		Pdef(\part2),
		Pdef(\part3),
		Pdef(\part4),
	]);

	rdnbuttons = [\rdn, \rdn2, \rdn3, \rdn4].collect({ arg name;
		var pl = PlayerWrapper(ProtoDef(name));
		var butlayout = pl.asView;
		butlayout.button.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

			if(buttonNumber == 1) {
				pl.edit;
			}
		});
		butlayout;
	});

	playerViewList = PlayerWrapperView()!6;
	otherResourcesView = View.new;
	rdnbuttons[0].button.followChange(FileSystemProject, \project, { arg ...args;
		var defaultPlayers;
		Log(\Param).debug("received changed project %", args);
		if(isRefreshing == false) {
			isRefreshing = true;
			proj = FileSystemProject.current ?? { FileSystemProject('repeat/simpleProject') };
			defaultPlayers = [
				proj,
				proj.mainMixer,
				proj.fxManager,
				proj.mainTimeline,
				proj.mainTrackList,
				proj.mainTrackGrid,
			];
			defaultPlayers.collect({ arg player, idx;
				playerViewList[idx].model = player;
			});
			otherResources = proj.resources - IdentitySet.newFrom(defaultPlayers);
			otherResourcesView.removeAll;
			otherResourcesView.layout = HLayout (
				* otherResources.asArray.collect { arg player, idx;
					PlayerWrapper(player).asView.rightClickEditorEnabled_(true);
				}
			).margins_(0).spacing_(0);
			isRefreshing = false;
		} {
			Log(\Param).debug("MainProject: already refreshing project, skipped");
		}
	}, true);


	mainview = HLayout (
		meter.view.minWidth_(40),
		//GridLayout.rows (
			//[
				//StaticText.new.string_("quant:"),
				//Param(Message(Pdef), \defaultQuant).asTextField.fixedWidth_(50),
				//WindowDef(\CircleClockMeter).asView(Param(Message(Pdef), \defaultQuant)),
			//],
			//[
				//StaticText.new.string_("tempo:"),
				//Param(Message(TempoClock.default), \tempo).asTextField.fixedWidth_(50),
				//WindowDef(\CircleClockMeter).asView(Param(Message(TempoClock.default), \beatsPerBar)),
			//]
		//),
		[VLayout (
			HLayout (
				//projlabel,
				playerViewList.first,
				HLayout (
					StaticText.new.string_("quant:"),
					Param(Message(Pdef), \defaultQuant).asTextField.fixedWidth_(50),
					WindowDef(\CircleClockMeter).asView(proj, Param(Message(Pdef), \defaultQuant)),
					StaticText.new.string_("tempo:"),
					Param(Message(TempoClock.default), \tempo).asTextField.fixedWidth_(50),
					WindowDef(\CircleClockMeter).asView(proj, Param(Message(TempoClock.default), \beatsPerBar)),
				).margins_([30,0]),
				BasicButton.new.string_("...").mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
					[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
					
					// FIXME: can't put it near button because MainProject is always on top and overlay menu can't be over it for unknown reason
					//WindowDef(\MainProjectOverlayMenu).front(proj, view, x, y);
					//WindowDef(\MainProjectOverlayMenu).frontTop(proj, view, x-200, y);
					WindowDef(\MainProjectContextMenu).sourceValue(proj, view).front;
				}).maxWidth_(20)
			),
			HLayout (
				HLayout(
					*playerViewList.drop(1).collect({ arg pwv; 
						pwv.asView.button.minWidth_(80);
						pwv.asView.rightClickEditorEnabled_(true)
					})
				),
			),
			HLayout (
				//BasicButton.new.string_("Play master").action_({
					//~master.();
				//}),
				PlayerWrapper(Pdef(\main)).asView,
				PlayerWrapper(Pdef(\part)).asView,
				PlayerWrapper(Pdef(\part2)).asView,
				PlayerWrapper(Pdef(\part3)).asView,
				PlayerWrapper(Pdef(\part4)).asView,
				nil,
			),

			HLayout (
				* rdnbuttons
				++[BasicButton.new.string_("PANIC").action_({
					CmdPeriod.run;
				})],
			),
			otherResourcesView,
		), stretch:2],
	).margins_(3).spacing_(3);
	mainview;
});
);

WindowDef(\MainProject_old, { arg def, proj;
	var meter = SimpleServerMeterView.new(nil, 0,2);
	var projlabel = StaticText.new;
	var rdnbuttons;
	var playerViewList;
	var otherResources, otherResourcesView;
	var isRefreshing = false;
	proj = proj ?? { FileSystemProject.current ?? { FileSystemProject('repeat/simpleProject') } };
	projlabel.string_(FileSystemProject.unresolve(proj.key.asString));
	//var meter = ServerMeterView.new;
	proj.playerTracker.addPlayer(*[
		proj.mainMixer,
		proj.fxManager,
		proj.mainTimeline,
		proj.mainTrackList,
		proj.mainTrackGrid,
		Pdef(\main),
		Pdef(\part),
		Pdef(\part2),
		Pdef(\part3),
		Pdef(\part4),
	]);

	rdnbuttons = [\rdn, \rdn2, \rdn3, \rdn4].collect({ arg name;
		var pl = PlayerWrapper(ProtoDef(name));
		var butlayout = pl.asView;
		butlayout.button.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
			[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");

			if(buttonNumber == 1) {
				pl.edit;
			}
		});
		butlayout;
	});

	playerViewList = PlayerWrapperView()!6;
	otherResourcesView = View.new;
	rdnbuttons[0].button.followChange(FileSystemProject, \project, { arg ...args;
		var defaultPlayers;
		Log(\Param).debug("received changed project %", args);
		if(isRefreshing == false) {
			isRefreshing = true;
			proj = FileSystemProject.current ?? { FileSystemProject('repeat/simpleProject') };
			defaultPlayers = [
				proj,
				proj.mainMixer,
				proj.fxManager,
				proj.mainTimeline,
				proj.mainTrackList,
				proj.mainTrackGrid,
			];
			defaultPlayers.collect({ arg player, idx;
				playerViewList[idx].model = player;
			});
			otherResources = proj.resources - IdentitySet.newFrom(defaultPlayers);
			otherResourcesView.removeAll;
			otherResourcesView.layout = HLayout (
				* otherResources.asArray.collect { arg player, idx;
					PlayerWrapper(player).asView.rightClickEditorEnabled_(true);
				}
			).margins_(0).spacing_(0);
			isRefreshing = false;
		} {
			Log(\Param).debug("MainProject: already refreshing project, skipped");
		}
	});


	HLayout (
		meter.view.minWidth_(40),
		VLayout (
			HLayout (
				StaticText.new.string_("quant:"),
				Param(Message(Pdef), \defaultQuant).asTextField.fixedWidth_(50)
			),
			HLayout (
				StaticText.new.string_("tempo:"),
				Param(Message(TempoClock.default), \tempo).asTextField.fixedWidth_(50)
			),
			WindowDef(\TempoMeter).asView,
			nil,
		),
		[VLayout (
			HLayout (
				//projlabel,
				playerViewList.first,
				BasicButton.new.string_("New Project").action_({
					proj.newProjectDialog
				}),
				BasicButton.new.string_("Open Project").action_({
					proj.openProjectDialog
				}),
				BasicButton.new.string_("Save Project").action_({
					proj.saveProject;
				}),
				nil,
				BasicButton.new.string_("...").mouseUpAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
					[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
					
					// FIXME: can't put it near button because MainProject is always on top and overlay menu can't be over it for unknown reason
					//WindowDef(\MainProjectOverlayMenu).front(proj, view, x, y);
					//WindowDef(\MainProjectOverlayMenu).frontTop(proj, view, x-200, y);
					WindowDef(\MainProjectContextMenu).sourceValue(proj, view).front;
				}).maxWidth_(30)
			),
			HLayout (
				HLayout(
					*playerViewList.drop(1).collect({ arg pwv; 
						pwv.asView.button.minWidth_(80);
						pwv.asView.rightClickEditorEnabled_(true)
					})
				),
				//PlayerWrapper(proj.mainMixer).asView.rightClickEditorEnabled_(true),
				//PlayerWrapper(proj.fxManager).asView.rightClickEditorEnabled_(true),
				//PlayerWrapper(proj.mainTimeline).asView.rightClickEditorEnabled_(true),
				//BasicButton.new.string_("TrackList").action_({
					//proj.mainTrackList.debug("traclist").edit;
				//}),
					////TODO: show patterns as a grid
					////TrackDef(\mygrid, TrackTemplateDef(\TrackList)).edit;
				//{
					//var pv = PlayerWrapper(proj.mainTrackGrid).asView;
					//pv.button.maxWidth_(100);
					//pv.rightClickEditorEnabled_(true);
				//}.value,


				//BasicButton.new.string_("Mixer").action_({
					//proj.mainMixer.edit;
				//}),
				//BasicButton.new.string_("Fx").action_({
					//proj.fxManager.edit;
				//}),
				//BasicButton.new.string_("Timeline").action_({
					//proj.mainTimeline.edit;
				//}),
				//BasicButton.new.string_("TrackGrid").action_({
					//proj.mainTrackGrid.edit;
				//}),
			),
			HLayout (
				//BasicButton.new.string_("Play master").action_({
					//~master.();
				//}),
				PlayerWrapper(Pdef(\main)).asView,
				PlayerWrapper(Pdef(\part)).asView,
				PlayerWrapper(Pdef(\part2)).asView,
				PlayerWrapper(Pdef(\part3)).asView,
				PlayerWrapper(Pdef(\part4)).asView,
				nil,
			),

			HLayout (
				* rdnbuttons
				++[BasicButton.new.string_("PANIC").action_({
					CmdPeriod.run;
				})],
			),
			otherResourcesView,
		), stretch:2],
	).margins_(3).spacing_(3);
});
//WindowDef(\MainProject).front(FileSystemProject('ex6'));

// Menus

(
WindowDef(\CircleClockMeter, { arg def, proj, totalParam;
	var canvas = UserView.new;
	var task;
	var clockratio = 0;
	//var clockratio_long = 0;
	var servertreefun;
	totalParam = totalParam ?? {Param(Message(Pdef), \defaultQuant)};
	proj.debug("PROJJJJJJJJJJJJJJJJJ");
	canvas.drawFunc = {
		//Pen.strokeColor = Color.blue(1.2);
		//Pen.fillColor = Color.blue(1.5);
		Pen.strokeColor = ParamViewToolBox.color_ligth;
		Pen.fillColor = ParamViewToolBox.color_pale;
		Pen.addWedge(10@10, 8, 3/4*2pi, ( clockratio )*2pi);
		Pen.draw(3);
		//Pen.strokeColor = ParamViewToolBox.color_dark;
		//Pen.fillColor = ParamViewToolBox.color_dark;
		//Pen.addWedge(10@10, 3, 3/4*2pi, ( clockratio_long )*2pi);
		//Pen.moveTo(0@0);

		//Pen.stroke;
		//Pen.fill;
		Pen.draw(3);
	};
	task = Task({
		var clock = TempoClock.default;
		inf.do {
			var total = totalParam.get;
			if(total < 0.01) {
				Log(\Param).debug("CircleClockMeter: total too small, changing it %", total);
				total = 1;
			};
			clockratio = clock.beats % total / total;
			//clockratio_long = ( clock.beats % ( total * 4 ) / ( total * 4 ) ).trunc(1/4);
			defer {
				//clockratio.debug("clock");
				canvas.refresh;
			};
			( total/8 ).wait;
		}

	});
	servertreefun = {
		proj.debug("PROJJJJJJJJJJJJJJJJJXXXXXXXXX");
		if(proj.isClockMeterEnabled == true) {
			task.play;
		} {
			clockratio = 0;
			//clockratio_long = 0;
			canvas.refresh;
			task.stop;
		};
	};
	ServerTree.add(servertreefun);
	servertreefun.();
	canvas.onClose_({
		task.stop;
		ServerTree.remove(servertreefun);
	});
	canvas.followChange(proj, \isClockMeterEnabled, {
		servertreefun.();
	});
	canvas.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		proj.isClockMeterEnabled = ( proj.isClockMeterEnabled ?? { false } ).not;
	});
	canvas.fixedSize_(20@20);
	canvas;
	//canvas.background_(Color.grey);
});
);

WindowDef(\MainProjectContextMenu, { arg def, model, view;
	Menu(


		MenuAction("New project", {
			model.newProjectDialog
		}),
		MenuAction("Open project", {
			model.openProjectDialog
		}),
		MenuAction("Save project", {
			model.saveProject;
		}),

		MenuAction.separator,
		MenuAction("New object", {
			WindowDef(\MainProject_newObject).front(model);
		}),
		MenuAction.separator,
		MenuAction("MixerPresetGrid", {
			if(model.mixerPresetGrid.isNil) {
				model.mixerPresetGrid = TrackDef("%_mixerPresetGrid".format(model.name).asSymbol, TrackTemplateDef(\MixerPresetGrid));
				model.addResource(model.mixerPresetGrid);
			};
			model.mixerPresetGrid.edit;
		}),

		MenuAction.separator,
		// misc tools
		MenuAction("InputManager", {
			WindowDef(\InputManager).front;
		}),
		MenuAction("Workspace", {
			WindowDef(\WorkspaceView).front;
		}),
		MenuAction("Sample Manager", {
			WindowDef(\SampleTimelineManager).front
		}),
		MenuAction("Piano Center", {
			FileSystemProject.loadOnce("paramdev/drafts/PianoCenter.scd");
			ProtoDef(\PianoCenter).edit;
		}),


		MenuAction.separator,
		// access to default objects instead of project's ones
		MenuAction("mainTimeline", {
			ClipTimeline(\mainTimeline).edit
		}),
		MenuAction("simpleMixer", {
			ProtoDef(\simpleMixer).edit
		}),
		MenuAction("Fx mixer", {
			ProtoDef(\fxMixer).edit
		}),
		MenuAction("Fx manager", {
			WindowDef(\FxManager).front
		}),
		MenuAction("Main window", {
			WindowDef(\main).front;
		}),

		MenuAction.separator,
		// basic tools
		MenuAction("Scope", {
			s.scope
		}),
		MenuAction("FreqScope", {
			s.freqscope
		}),
		MenuAction("Nodes", {
			s.plotTree
		}),
		MenuAction("Meter", {
			s.meter
		}),
	)
});

WindowDef(\MainProject_newObject, { arg def, model, view;
	WindowDef(\ClipList_NewClip).embedView(def, {
		// selected hook

	}, { arg idef, asso, label;
		// ok hook
		var obj = asso.value.value(label);
		model.addResource(obj);
		PlayerWrapper(obj).edit;
	}, TagSpecDef(\MainProject_newObject))
});

WindowDef(\MainProjectOverlayMenu, { arg def, model, view, x=600, y=600;
	WindowDef(\OverlayMenu).embedView(def, view, x, y, {
		var inview, layout;
		layout = VLayout (
			// misc project tools
			BasicButton.new.string_("MixerPresetGrid").action_({
				if(model.mixerPresetGrid.isNil) {
					model.mixerPresetGrid = TrackDef("%_mixerPresetGrid".format(model.name).asSymbol, TrackTemplateDef(\MixerPresetGrid));
					model.addResource(model.mixerPresetGrid);
				};
				model.mixerPresetGrid.edit;
			}),

			StaticText.new,
			// misc tools
			BasicButton.new.string_("InputManager").action_({
				WindowDef(\InputManager).front;
			}),
			BasicButton.new.string_("Workspace").action_({
				WindowDef(\WorkspaceView).front;
			}),
			BasicButton.new.string_("Sample Manager").action_({
				WindowDef(\SampleTimelineManager).front
			}),

			StaticText.new,
			// access to default objects instead of project's ones
			BasicButton.new.string_("mainTimeline").action_({
				ClipTimeline(\mainTimeline).edit
			}),
			HLayout (
				BasicButton.new.string_("simpleMixer").action_({
					ProtoDef(\simpleMixer).edit
				}),
				PlayerWrapperView(ProtoDef(\fxMixer)).rightClickEditorEnabled_(true)
			),
			BasicButton.new.string_("Fx").action_({
				WindowDef(\FxManager).front
			}),
			BasicButton.new.string_("Main window").action_({
				WindowDef(\main).front;
			}),
			StaticText.new,
			// basic tools
			BasicButton.new.string_("Scope").action_({
				s.scope
			}),
			BasicButton.new.string_("FreqScope").action_({
				s.freqscope
			}),
			BasicButton.new.string_("Nodes").action_({
				s.plotTree
			}),
			BasicButton.new.string_("Meter").action_({
				s.meter
			}),
			nil
		);
		//def.windowDo { arg win;
		//win.setInnerExtent(view.bounds.extent.min(20));
		//};
		layout;
	})
	
}).border_(false);

WindowDef(\MainProjectOverlayMenu_old, { arg def, model, view, x=600, y=600;
	var inview, layout;
	[x, y].debug("xy");
	def.windowDo { arg win;
		var ab = view !? {view.absoluteBounds} ? Rect(0,0,600,600);
		win.bounds = Rect(x+ab.origin.x, Window.screenBounds.height - ab.top - y, 200,100);
		win.endFrontAction = { win.close };
	};
	inview = View.new;


	layout = VLayout (
		// misc project tools
		BasicButton.new.string_("MixerPresetGrid").action_({
			if(model.mixerPresetGrid.isNil) {
				model.mixerPresetGrid = TrackDef("%_mixerPresetGrid".format(model.name).asSymbol, TrackTemplateDef(\MixerPresetGrid));
				model.addResource(model.mixerPresetGrid);
			};
			model.mixerPresetGrid.edit;
		}),

		StaticText.new,
		// misc tools
		BasicButton.new.string_("Workspace").action_({
			WindowDef(\WorkspaceView).front;
		}),
		BasicButton.new.string_("Sample Manager").action_({
			WindowDef(\SampleTimelineManager).front
		}),

		StaticText.new,
		// access to default objects instead of project's ones
		BasicButton.new.string_("mainTimeline").action_({
			ClipTimeline(\mainTimeline).edit
		}),
		BasicButton.new.string_("simpleMixer").action_({
			ProtoDef(\simpleMixer).edit
		}),
		BasicButton.new.string_("Fx").action_({
			WindowDef(\FxManager).front
		}),
		BasicButton.new.string_("Main window").action_({
			WindowDef(\main).front;
		}),
		StaticText.new,
		// basic tools
		BasicButton.new.string_("Scope").action_({
			s.scope
		}),
		BasicButton.new.string_("FreqScope").action_({
			s.freqscope
		}),
		BasicButton.new.string_("Nodes").action_({
			s.plotTree
		}),
		BasicButton.new.string_("Meter").action_({
			s.meter
		}),
		nil
	);
	//def.windowDo { arg win;
		//win.setInnerExtent(view.bounds.extent.min(20));
	//};
	inview.layout_(layout);
	
}).border_(false);


WindowDef(\TempoMeter, { arg def, clock;
	var view = View.new;
	var task;
	var leds, leds2, leds3, allLeds;
	var subdiv = 4;
	var surdiv = 8;
	var offColor = Color.white;
	clock = clock ? TempoClock.default;

	leds = surdiv.collect({ arg beat;
		StaticText.new.background_(offColor).minHeight_(6)
	});
	leds2 = clock.beatsPerBar.asInteger.collect({ arg beat;
		StaticText.new.background_(offColor).minHeight_(6)
	});
	leds3 = subdiv.collect({ arg beat;
		StaticText.new.background_(offColor).minHeight_(6)
	});
	allLeds = leds ++ leds2 ++ leds3;
	~allLeds = allLeds;
	~view = view;

	task = Tdef(\TempoMeter, {
		var last = 1;
		var last2 = 1;
		var last3 = 1;
		var count1 = 0;
		var idx = clock.beats;
		block { arg break;
			defer {
				allLeds.do { arg led;
					led.background_(offColor);
				};
			};
			{
				leds[last].background_(offColor);
				last = (idx / clock.beatsPerBar % surdiv).asInteger;
				leds[last].background_(ParamViewToolBox.color_ligth);
			}.defer;
			inf.do { arg loopidx;
				idx = clock.beats;
				//[idx, idx % clock.beatsPerBar.asInteger, (idx / clock.beatsPerBar % surdiv).asInteger , clock.beats].debug("iteration");
				if(idx % clock.beatsPerBar.asInteger == 0) {
					{
						leds[last].background_(offColor);
						last = (idx / clock.beatsPerBar % surdiv).asInteger;
						leds[last].background_(ParamViewToolBox.color_ligth);
					}.defer;

				};
				{
					leds2[last2].background_(offColor);
					last2 = clock.beatInBar.asInteger;
					leds2[last2].background_(ParamViewToolBox.color_ligth);
					view.toolTip = "%/% (%)".format(( clock.beats % ( clock.beatsPerBar * surdiv ) ).asInteger, ( clock.beatsPerBar * surdiv ).asInteger, clock.beats.round(0.01));
				}.defer;
				subdiv.do { arg subidx;
					{
						leds3[last3].background_(offColor);
						last3 = subidx;
						leds3[last3].background_(ParamViewToolBox.color_ligth);
					}.defer;

					subdiv.reciprocal.wait;

					if(view.isClosed) {
						Tdef(\TempoMeter).stop;
						break.value;
					};
				};
			}
		};
	}).quant_(1);

	view.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		if(buttonNumber == 1) {
			if(task.isPlaying) {
				Log(\Param).debug("stoping TempoMeter task");
				defer {
					allLeds.do { arg led;
						led.background_(offColor);
					};
				};
				task.stop;
			} {
				Log(\Param).debug("starting TempoMeter task");
				task.play;
			};
		};
	});
	//view.minSize_(Point(100,100));

	view.layout_(
		VLayout (
			HLayout(* leds),
			HLayout(* leds2),
			HLayout(* leds3),
		)
	);
});


// END

1+1

~view.isClosed
~allLeds[0].isClosed

ClipTimeline(\bla).edit
SampleTimeline(\bla).edit
