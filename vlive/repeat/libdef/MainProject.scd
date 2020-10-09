
ProtoTemplateDef('MainProject', (
	//parent: FileSystemProject.defaultParent,
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
			resource.presetCompileStringSavePath = self.dataPath;
			resource.loadedFromPath = self.dataPath; // bypass the overwrite protection mecanism for debug
			resource.savePresetCompileString;
		}
	},

	projectPath: { arg self;
		self.key.asString;
	},

	refCompileString: { arg self;
		"FileSystemProject(%)".format(self.key.asCompileString);
	},

	presetCompileString: { arg self;
		[
			"FileSystemProject(%, ProtoTemplateDef(\\MainProject));".format(self.key.asCompileString),
			"%.mainMixer; // create mixer".format(self.refCompileString),
			"%; // return project\n".format(self.refCompileString),
		].join("\n")
	},

	loadProject: { arg self, path;
		var projectfile;
		var proj;
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
		proj;
	},

	name: { arg self;
		PathName(self.key.asString).fileName
	},

	addResource: { arg self, resource;
		if(self.resources.isNil) {
			self.resources = IdentitySet.new;
		};
		self.resources.add(resource);
	},

	mainTrackList: { arg self;
		var tracklistname = "%_mainTrackList".format(self.name).asSymbol; 
		if(TrackDef(tracklistname).isNil or: {
			TrackDef(tracklistname).name.isNil
		}) {
			TrackDef(tracklistname, TrackTemplateDef(\TrackList));
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
));

ProtoTemplateDef(\SimpleProject, ( // this is like having no project
	parent: ProtoTemplateDef(\MainProject),

	mainTrackList: { arg self;
		var tracklistname = "%_mainTrackList".format(self.name).asSymbol; 
		if(TrackDef(tracklistname).isNil or: {
			TrackDef(tracklistname).name.isNil
		}) {
			TrackDef(tracklistname, TrackTemplateDef(\TrackList));
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

WindowDef(\MainProject, { arg def, proj;
	var meter = SimpleServerMeterView.new(nil, 0,2);
	var projlabel = StaticText.new;
	var rdnbuttons;
	proj = proj ?? { FileSystemProject.current ?? { FileSystemProject('repeat/simpleProject') } };
	projlabel.string_(FileSystemProject.unresolve(proj.key.asString));
	//var meter = ServerMeterView.new;
	def.windowDo { arg win;
		win.autoRememberPosition(\SimpleMainPanel);
	};

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

	HLayout (
		meter.view,
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
				projlabel,
				BasicButton.new.string_("New Project").action_({
					WindowDef(\filedialog_save).front(nil, { arg path, name;
						[path, name].debug("new project");
						proj = FileSystemProject(path +/+ name, ProtoTemplateDef(\MainProject));
						//proj.projectPath = path +/+ name;
						FileSystemProject.current = proj;
						projlabel.string_(FileSystemProject.unresolve(proj.key.asString));
					}); 
				}),
				BasicButton.new.string_("Open Project").action_({
					WindowDef(\filedialog).front(nil, { arg path;
						[path].debug("open project");
						proj = ProtoTemplateDef(\MainProject).loadProject(path);
						projlabel.string_(FileSystemProject.unresolve(proj.key.asString));
					}); 
				}),
				BasicButton.new.string_("Save Project").action_({
					proj.saveProject;
				}),
				nil,
				BasicButton.new.string_("...").action_({
					WindowDef(\MainProjectOverlayMenu).front(proj)
				}).maxWidth_(30)
			),
			HLayout (
				BasicButton.new.string_("Mixer").action_({
					proj.mainMixer.edit;
				}),
				BasicButton.new.string_("Fx").action_({
					proj.fxManager.edit;
				}),
				BasicButton.new.string_("Timeline").action_({
					proj.mainTimeline.edit;
				}),
				BasicButton.new.string_("TrackList").action_({
					proj.mainTrackList.debug("traclist").edit;
				}),
				BasicButton.new.string_("TrackGrid").action_({
					proj.mainTrackGrid.edit;
					//TODO: show patterns as a grid
					//TrackDef(\mygrid, TrackTemplateDef(\TrackList)).edit;
				}),
			),
			HLayout (
				BasicButton.new.string_("Play master").action_({
					~master.();
				}),
				PlayerWrapper(Pdef(\main)).asView,
				PlayerWrapper(Pdef(\part)).asView,
				PlayerWrapper(Pdef(\part2)).asView,
				PlayerWrapper(Pdef(\part3)).asView,
				PlayerWrapper(Pdef(\part4)).asView,
				nil,
			),

			HLayout (
				*[PlayerWrapper(ProtoDef(\simpleMixer)).label_("mixer").asView]
				++rdnbuttons
				++[BasicButton.new.string_("PANIC").action_({
					CmdPeriod.run;
				})],
			),
		), stretch:2],
	).margins_(5).spacing_(5);

});
//WindowDef(\MainProject).front(FileSystemProject('ex6'));

WindowDef(\MainProjectOverlayMenu, { arg def, model, view, x=600, y=600;
	var inview, layout;
	[x, y].debug("xy");
	def.windowDo { arg win;
		var ab = view !? {view.absoluteBounds} ? Rect(0,0,600,600);
		win.bounds = Rect(x+ab.origin.x, Window.screenBounds.height - ab.top - y, 200,100);
		win.endFrontAction = { win.close };
	};
	inview = View.new;


	layout = VLayout (
		// access to default objects instead of project's ones
		BasicButton.new.string_("mainTimeline").action_({
			ClipTimeline(\mainTimeline).edit
		}),
		BasicButton.new.string_("Workspace").action_({
			WindowDef(\WorkspaceView).front;
		}),
		BasicButton.new.string_("Sample Manager").action_({
			WindowDef(\SampleTimelineManager).front
		}),
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
		BasicButton.new.string_("simpleMixer").action_({
			ProtoDef(\simpleMixer).edit
		}),
		BasicButton.new.string_("Fx").action_({
			WindowDef(\FxManager).front
		}),
		BasicButton.new.string_("Main window").action_({
			WindowDef(\main).front;
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
		StaticText.new.background_(offColor)
	});
	leds2 = clock.beatsPerBar.asInteger.collect({ arg beat;
		StaticText.new.background_(offColor)
	});
	leds3 = subdiv.collect({ arg beat;
		StaticText.new.background_(offColor)
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
		}
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
