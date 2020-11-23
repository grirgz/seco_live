

(
ProtoTemplateDef(\filemanager_node, (
	playable_extensions: [
		"wav",
		"mp3",
		"flac",
		"ogg",
	],
	new: { arg self, name;
		self = self.copy;
		//[name, name.class].debug("new name");
		if(name.isKindOf(String)) {
			name = PathName(name);
		};
		self.pathName = name;
		self;
	},

	extension: { arg self;
		self.pathName.extension
	},
	className: { arg self;
		ProtoTemplateDef(\filemanager_node);
	},
	name: { arg self;
		var name = self.pathName.fullPath;
		if(File.type(name) == \directory) {
			if(name.endsWith("/")) {
				self.pathName.folderName ++ "/"
			} {
				self.pathName.fileName ++ "/"
			}
		} {
			if(name.endsWith("/")) {
				self.pathName.folderName
			} {
				self.pathName.fileName
			}
		}
	},
	label: { arg self;
		self.name;
	},
	fullPath: { arg self;
		var path = self.pathName.fullPath;
		if(path.beginsWith("//")) {
			path.keep(1 - path.size)
		} {
			path
		}
	},

	play: { arg self;
		if(self.isFile and: { self.playable_extensions.includesEqual(self.pathName.extension) }) {
			// FIXME: need to write custom code to load file into buffer and play it on a proxy
			// then free buffer
			SoundFile(self.fullPath).play;
		}
	},
	typeLabel: { arg self;
		File.type(self.pathName.fullPath).asString;
	},
	splitPath: { arg self;
		var parts = [ "/" ] ++ self.fullPath.split($/).select(_ != "");
		parts.collect { arg p, idx;
			self.new(parts.keep(idx+1).join("/"))
		}
	},
	isFile: { arg self;
		File.type(self.pathName.fullPath) != \directory
	},
	isFolder: { arg self;
		File.type(self.pathName.fullPath) == \directory
	},
	isChoosable: { arg self;
		self.isFile
	},
	parentNode: { arg self;
		self.new(self.pathName.parentPath)
	},
	selectedIndex: 0,
	children: { arg self;
		self.pathName.entries.collect({ arg p; self.new(p) });
	},

	asString: { arg self;
		self.pathName.fullPath;
	},

));

WindowDef(\filedialog_generic, { arg def, path, callback, nodeClass, isSaving=false;
	// callback(file_full_path_to_open)

	var fileview, changepath, select_file;
	var pathview = View.new;
	var quicklist = ListView.new;
	var node;
	var update_pathview;
	var preview = View.new;
	var proto = ProtoDef(\filemanager_player);
	var name_field;
	var nodelist;
	nodeClass = nodeClass ?? { ProtoTemplateDef(\filemanager_node) };

	name_field = TextField.new;

	if(path.isNil) {
		path = proto.cwd ? try { PathName(Document.current.path).pathOnly } ? "~"
	} {
		name_field.value = PathName(path).fileName;
		path = PathName(path).pathOnly;
	};

	if(def.window.notNil) {
		def.window.view.keyDownAction = { arg view, char, modifiers, u, k; 
			//[char, modifiers, u, k].debug("KEYBOARD INPUT");
			if( u == 27 ) { // Esc
				def.closeWindow
			};
		};
	};

	fileview = ListView.new;
	changepath = { arg view, path; // called with double click
		var newnode;
		path.debug("changepath: ");
		newnode = nodeClass.new(path);
		if(newnode.isFolder) {
			node = newnode;
			proto.disable_play = true;
			nodelist = node.children;
			view.items = nodelist.collect(_.label);
			view.items.debug("changepath items");
			{
				// hack because selectionAction is triggered even without valueAction_
				// and with a delay
				proto.disable_play = false;
			}.defer(1/4);
			debug("end disable play");

			proto.cwd = node.fullPath;
			update_pathview.()
		} {
			proto.chooseNode(newnode, true);
		}
	};

	select_file = { arg view, path;
		var filenode;
		path.debug("select_file: path:");
		if(path.notNil) {
			var selected;
			filenode = nodeClass.new(path);

			proto.disable_play = true;
			selected = view.items.indexOfEqual(filenode.label);
			if(selected.notNil) {
				view.value = selected;
			};
			proto.filenameview.string = filenode.fullPath.asString;
			{
				// hack because selectionAction is triggered even without valueAction_
				// and with a delay
				proto.disable_play = false;
			}.defer(1/4);
			Log(\Param).debug("end disable play file");
		}
	};

	fileview.enterKeyAction = { arg view;
		//[view.value, view.items].debug("select: ");
		if(view.items.size > 0) {
			changepath.(view, node.fullPath ++ view.items[view.value])
		}
	};
	fileview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		
		//[view.value, view.items].debug("double click select: ");
		if(clickCount == 2 and: {view.items.size > 0}) {
			changepath.(view, nodelist[view.value].fullPath)
		}
	});
	fileview.selectionAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		var path;
		var newnode;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("selectionAction");
		if(view.value.notNil) {
			path = nodelist[view.value].fullPath;
			newnode = nodeClass.new(path);
			//newnode.extension.dump;
			//proto.playable_extensions.debug("ext");
			//[proto.auto_mode, proto.auto_mode == 1, newnode.isFile, proto.playable_extensions.includesEqual(newnode.extension.debug("ext"))].debug("sel");
			if(newnode.isChoosable) {
				proto.chooseNode(nodelist[view.value], proto.auto_mode == true);
			};
		}
	});

	update_pathview = {
		pathview.removeAll;
		pathview.layout = HLayout.new.spacing_(0);
		node.splitPath.do({ arg p, idx;
			p.name.debug("update_pathview p");
			pathview.layout.add(
				BasicButton.new.string_(p.label).action_({
					changepath.(fileview, node.splitPath[idx].fullPath)

				})
			)
		});
		pathview.layout.add(nil)
	};

	quicklist.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		
		//[view.value, view.items].debug("double click select: ");
		if(clickCount == 2 and: {view.items.size > 0}) {
			changepath.(fileview, view.items[view.value])
		}
	});

	proto.update_quicklistview = { arg self;
		quicklist.items = proto.quicklist.select(_.notNil);	
	};
	proto.save_quicklist = { arg self;
		File.use(self.config_file, "w", { arg file;
			file.write(
				"ProtoDef(\\filemanager_player).quicklist = [\n%];\n".format(
					self.quicklist.collect(_.asCompileString).join(",\n")
				)
			)
		});
	};
	proto.load_quicklist = { arg self;
		if(self.config_file.notNil) {
			self.config_file.load;
		};
	};

	proto.check_name_field = { arg self, callback;
		var node = nodeClass.new(self.choosedNode.parentNode.fullPath +/+ name_field.string);
		if(node.isChoosable) {
			self.chooseNode(node);
			callback.();
		} {
			"Can't open: file doesn't exist: %".format(node.fullPath).error;
		}
	};

	proto.chooseNode = { arg self, node, alsoPlay=false;
		self.current_file = node.fullPath;
		self.choosedNode = node;
		name_field.string = node.name;
		self.filenameview.string = "[%] %".format(node.typeLabel, node.fullPath.asString);
		if(alsoPlay == true) {
			if(self.disable_play != true) {
				node.play;
			};
		}
	};

	//proto.play_file = { arg self, file, node;
		//self.current_file = file;
		//if(self.disable_play != true) {

			//file.debug("new source");
			//self.filenameview.string = "[%] %".format(node.typeLabel, file.asString);
			//nodeClass.new(file).play;
			//self.player.source_(
			////Pmono( \playersec,
			////\bufnum, BufDef(file.asSymbol),
			////\dur, 1/8,
			////\gain, 1,
			////\amp, 0.1,
			////),
			//Pbind(
			//\instrument, \playersec,
			//\bufnum, BufDef(file.asSymbol),
			//\dur, (BufDef(file.asSymbol).duration ? 1) * ~t * Pseq([1],1),
			//\amp, 0.1,
			//),
			//);
			//self.player.play;
		//}
	//};

	proto.init = { arg self;
		"wtf".debug;
		proto.load_quicklist;
		proto.quicklist = proto.quicklist ? [
			path, 
			"/", 
			"~", 
			"~/Musique/",
			"~/Musique/sc/samplekit/",
			"~/Musique/sc/reckit/",
			"~/Musique/sc/samplekit/com/",
			"~/code/sc/seco/vlive/",
			"~/code/sc/seco/vlive/repeat/",
			"~/code/sc/seco/vlive/repeat/capsule/",
		].select(_.notNil);
		proto.config_file = Platform.userConfigDir +/+ "filemanager_quicklist.sc";
		proto.update_quicklistview;
		self.player = self.player ? EventPatternProxy.new;
		self.player.quant = 0;
		proto.playerwrapper = PlayerWrapper(proto.player);
		proto.auto_mode = proto.auto_mode ?? 0;
		proto.auto_mode.debug("auto_modexx");
		changepath.(fileview, path);
		"wut".debug;
		select_file.(fileview, proto.current_file);
	};
	/////////////////////////////////////////////

	proto.filenameview = StaticText.new.string_("...");
	proto.init;

	preview.layout = HLayout (
		proto.playerwrapper.asView,
		Param(Message(proto), \auto_mode, XBoolSpec()).asButton("Auto"),
		[proto.filenameview, stretch:4],
			BasicButton.new.string_("Cancel").action_({
				def.closeWindow;
			}).maxWidth_(50),
			BasicButton.new.string_("OK").action_({
				if(isSaving) {
					var fpath = proto.cwd+/+name_field.value;
					if(File.exists(fpath)) { // FIXME: should use .exists from node proto to not break the API
						WindowDef(\ConfirmDialog).front("File already exists, are you sure you want to overwrite ?\n\n%".format(fpath), {
							callback.(proto.cwd, name_field.value);
							def.closeWindow;
						})
					} {
						callback.(proto.cwd, name_field.value);
						def.closeWindow;
					};
				} {
					proto.check_name_field {
						callback.(proto.current_file);
						def.closeWindow;
					};
				}
			}).maxWidth_(50),
	);

	VLayout (
		HLayout (
			BasicButton.new.string_("+").action_({
				if(proto.quicklist.includesEqual(node.fullPath).not) {
					proto.quicklist = proto.quicklist.add(node.fullPath);
					proto.update_quicklistview;
					proto.save_quicklist;
					PathName("//bin").fullPath
				}
			}).maxWidth_(30),
			BasicButton.new.string_("-").action_({
				proto.quicklist.removeAt(quicklist.value ? 0);
				proto.update_quicklistview;
				proto.save_quicklist;
			}).maxWidth_(30),
			BasicButton.new.string_("Up").action_({
				changepath.(fileview, node.parentNode.fullPath)
			}).maxWidth_(50),
			BasicButton.new.string_("Mkdir").action_({
				WindowDef(def.key+++\MkdirDialog, WindowDef(\RenameDialog)).front("What is the new folder name ?", "", { arg name;
					if(name != "") {
						(node.fullPath +/+ name).mkdir;
						(node.fullPath +/+ name).debug("folder created");
						changepath.(fileview, node.fullPath); // refresh
					} {
						name.debug("invalid name");
					}
				})
			}).maxWidth_(50),
			pathview,

		),
		name_field,
		HLayout (
			quicklist,
			fileview,
		),
		preview,
	);

});

WindowDef(\filedialog, { arg def, path, callback, nodeClass;
	WindowDef(\filedialog_generic).embedView(def, path, callback)
});

WindowDef(\filedialog_save, { arg def, path, callback, nodeClass;
	WindowDef(\filedialog_generic).embedView(def, path, callback,nil,true)
});


ProtoTemplateDef(\filemanager_node_sample, ProtoTemplateDef(\filemanager_node)).putAll((
	className: { arg self;
		ProtoTemplateDef(\filemanager_node_sample);
	},

	isChoosable: { arg self;
		self.playable_extensions.debug("playa").includesEqual(self.extension).debug("isChoosable");
	},

	children: { arg self;
		"12".debug;
		self.pathName.entries.collect({ arg p; 
			var entry = self.new(p);
			if(entry.isChoosable or: {entry.isFolder}) {
				entry;
			} {
				nil
			}
		}).select(_.notNil);
	},
));
WindowDef(\filedialog_sample, { arg def, path, callback;
	WindowDef(\filedialog_generic).embedView(def, path, callback, ProtoTemplateDef(\filemanager_node_sample))
});
WindowDef(\filedialog_insert_bufdef, { arg def, path;
	// FIXME: not recursive ?!
	//WindowDef(\filedialog_sample).embedView(def, nil,{ arg path ...args; 
		//BufDef(path).asCompileString.editorInsert(false)
	//});
	WindowDef(\filedialog_generic).embedView(def, path, { arg path ...args;
		BufDef(path).asCompileString.editorInsert(false)
	}, ProtoTemplateDef(\filemanager_node_sample))
});

);


// END

WindowDef(\filedialog_insert_bufdef).front;



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('/home/ggz/Musique/sc/reckit/loop/funky11_96bpm.flac'),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
);

WindowDef(\filedialog).front(nil, { arg view, path; view.window.close; path.debug("choosen path") });

/////////// old dialogs

//WindowDef(\filedialog, { arg def, path, callback, nodeClass;
	//// callback(file_full_path_to_open)

	//var fileview, changepath, select_file;
	//var pathview = View.new;
	//var quicklist = ListView.new;
	//var node;
	//var update_pathview;
	//var preview = View.new;
	//var proto = ProtoDef(\filemanager_player);
	//var nodelist;
	//nodeClass = nodeClass ?? { ProtoTemplateDef(\filemanager_node) };

	//if(path.isNil) {
		//path = proto.cwd ? "~"
	//};

	//if(def.window.notNil) {
		//def.window.view.keyDownAction = { arg view, char, modifiers, u, k; 
			////[char, modifiers, u, k].debug("KEYBOARD INPUT");
			//if( u == 27 ) { // Esc
				//def.closeWindow
			//};
		//};
	//};

	//fileview = ListView.new;
	//changepath = { arg view, path;
		//var newnode;
		//path.debug("changepath: ");
		//newnode = nodeClass.new(path);
		//if(newnode.isFolder) {
			//node = newnode;
			//proto.disable_play = true;
			//nodelist = node.children;
			//view.items = nodelist.collect(_.label);
			//view.items.debug("changepath items");
			//{
				//// hack because selectionAction is triggered even without valueAction_
				//// and with a delay
				//proto.disable_play = false;
			//}.defer(1/4);
			//debug("end disable play");

			//proto.cwd = node.fullPath;
			//update_pathview.()
		//} {
			//proto.play_file(path, newnode);
		//}
	//};

	//select_file = { arg view, path;
		//var filenode;
		//path.debug("select_file: path:");
		//if(path.notNil) {
			//var selected;
			//filenode = nodeClass.new(path);

			//proto.disable_play = true;
			//selected = view.items.indexOfEqual(filenode.label);
			//if(selected.notNil) {
				//view.value = selected;
			//};
			//proto.filenameview.string = filenode.fullPath.asString;
			//{
				//// hack because selectionAction is triggered even without valueAction_
				//// and with a delay
				//proto.disable_play = false;
			//}.defer(1/4);
			//debug("end disable play file");
		//}
	//};

	//fileview.enterKeyAction = { arg view;
		////[view.value, view.items].debug("select: ");
		//if(view.items.size > 0) {
			//changepath.(view, node.fullPath ++ view.items[view.value])
		//}
	//};
	//fileview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		
		////[view.value, view.items].debug("double click select: ");
		//if(clickCount == 2 and: {view.items.size > 0}) {
			//changepath.(view, nodelist[view.value].fullPath)
		//}
	//});
	//fileview.selectionAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//var path = node.fullPath +/+ view.items[view.value];
		//var newnode = nodeClass.new(path);
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("selectionAction");
		////newnode.extension.dump;
		////proto.playable_extensions.debug("ext");
		////[proto.auto_mode, proto.auto_mode == 1, newnode.isFile, proto.playable_extensions.includesEqual(newnode.extension.debug("ext"))].debug("sel");
		//if(proto.auto_mode == 1 and: {newnode.isFile and: { proto.playable_extensions.includesEqual(newnode.extension) }}) {
			//proto.play_file(path)
		//}
		
	//});

	//update_pathview = {
		//pathview.removeAll;
		//pathview.layout = HLayout.new.spacing_(0);
		//node.splitPath.do({ arg p, idx;
			//p.name.debug("update_pathview p");
			//pathview.layout.add(
				//BasicButton.new.string_(p.label).action_({
					//changepath.(fileview, node.splitPath[idx].fullPath)

				//})
			//)
		//});
		//pathview.layout.add(nil)
	//};

	//quicklist.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		
		////[view.value, view.items].debug("double click select: ");
		//if(clickCount == 2 and: {view.items.size > 0}) {
			//changepath.(fileview, view.items[view.value])
		//}
	//});

	//proto.update_quicklistview = { arg self;
		//quicklist.items = proto.quicklist.select(_.notNil);	
	//};
	//proto.save_quicklist = { arg self;
		//File.use(self.config_file, "w", { arg file;
			//file.write(
				//"ProtoDef(\\filemanager_player).quicklist = [\n%];\n".format(
					//self.quicklist.collect(_.asCompileString).join(",\n")
				//)
			//)
		//});
	//};
	//proto.load_quicklist = { arg self;
		//if(self.config_file.notNil) {
			//self.config_file.load;
		//};
	//};


	//proto.play_file = { arg self, file, node;
		//self.current_file = file;
		//if(self.disable_play != true) {

			//file.debug("new source");
			//self.filenameview.string = "[%] %".format(node.typeLabel, file.asString);
			//nodeClass.new(file).play;
			////self.player.source_(
			//////Pmono( \playersec,
			//////\bufnum, BufDef(file.asSymbol),
			//////\dur, 1/8,
			//////\gain, 1,
			//////\amp, 0.1,
			//////),
			////Pbind(
			////\instrument, \playersec,
			////\bufnum, BufDef(file.asSymbol),
			////\dur, (BufDef(file.asSymbol).duration ? 1) * ~t * Pseq([1],1),
			////\amp, 0.1,
			////),
			////);
			////self.player.play;
		//}
	//};

	//proto.init = { arg self;
		//"wtf".debug;
		//proto.load_quicklist;
		//proto.quicklist = proto.quicklist ? [
			//path, 
			//"/", 
			//"~", 
			//"~/Musique/",
			//"~/Musique/sc/samplekit/",
			//"~/Musique/sc/reckit/",
			//"~/Musique/sc/samplekit/com/",
			//"~/code/sc/seco/vlive/",
			//"~/code/sc/seco/vlive/repeat/",
			//"~/code/sc/seco/vlive/repeat/capsule/",
		//].select(_.notNil);
		//proto.config_file = Platform.userConfigDir +/+ "filemanager_quicklist.sc";
		//proto.update_quicklistview;
		//self.player = self.player ? EventPatternProxy.new;
		//self.player.quant = 0;
		//proto.playerwrapper = PlayerWrapper(proto.player);
		//proto.auto_mode = proto.auto_mode ?? 0;
		//proto.auto_mode.debug("auto_modexx");
		//proto.playable_extensions = [
			//"wav",
			//"mp3",
			//"flac",
			//"ogg",
		//];
		//changepath.(fileview, path);
		//"wut".debug;
		//select_file.(fileview, proto.current_file);
	//};

	//proto.filenameview = StaticText.new.string_("...");

	//proto.init;

	//preview.layout = HLayout (
		//proto.playerwrapper.asView,
		//Param(Message(proto), \auto_mode, \unipolar).asButton("Auto"),
		//[proto.filenameview, stretch:4],
			//BasicButton.new.string_("Cancel").action_({
				//def.closeWindow;
			//}).maxWidth_(50),
			//BasicButton.new.string_("OK").action_({
				//callback.(proto.current_file);
				//def.closeWindow;
			//}).maxWidth_(50),
	//);

	//VLayout (
		//HLayout (
			//BasicButton.new.string_("+").action_({
				//if(proto.quicklist.includesEqual(node.fullPath).not) {
					//proto.quicklist = proto.quicklist.add(node.fullPath);
					//proto.update_quicklistview;
					//proto.save_quicklist;
					//PathName("//bin").fullPath
				//}
			//}).maxWidth_(30),
			//BasicButton.new.string_("-").action_({
				//proto.quicklist.removeAt(quicklist.value ? 0);
				//proto.update_quicklistview;
				//proto.save_quicklist;
			//}).maxWidth_(30),
			//BasicButton.new.string_("Up").action_({
				//changepath.(fileview, node.parentNode.fullPath)
			//}).maxWidth_(50),
			//pathview,

		//),
		//HLayout (
			//quicklist,
			//fileview,
		//),
		//preview,
	//);

//});

//WindowDef(\filedialog_save, { arg def, path, callback, nodeClass;
	//// callback(folderPath, new_filename)

	//var fileview, changepath, select_file;
	//var pathview = View.new;
	//var quicklist = ListView.new;
	//var node;
	//var update_pathview;
	//var preview = View.new;
	//var proto = ProtoDef(\filemanager_player);
	//var name_field;
	//nodeClass = nodeClass ?? { ProtoTemplateDef(\filemanager_node) };

	//path.debug("firstpath");
	//name_field = TextField.new;
	//if(path.isNil) {
		//path = proto.cwd ? PathName(Document.current.path).pathOnly ? "~"
	//} {
		//name_field.value = PathName(path).fileName;
		//path = PathName(path).pathOnly;
	//};
	//path.debug("endpath");
	//name_field.value.debug("namefield");

	//if(def.window.notNil) {
		//def.window.view.keyDownAction = { arg view, char, modifiers, u, k; 
			////[char, modifiers, u, k].debug("KEYBOARD INPUT");
			//if( u == 27 ) { // Esc
				//def.closeWindow
			//};
		//};
	//};

	//fileview = ListView.new;
	//changepath = { arg view, path;
		//var newnode;
		//path.debug("changepath: ");
		//newnode = nodeClass.new(path);
		//if(newnode.isFolder) {
			//node = newnode;
			//proto.disable_play = true;
			//view.items = node.children.collect(_.label);
			//{
				//// hack because selectionAction is triggered even without valueAction_
				//// and with a delay
				//proto.disable_play = false;
			//}.defer(1/4);
			//debug("end disable play");

			//proto.cwd = node.fullPath;
			//update_pathview.()
		//} {
			//proto.play_file(path);
		//}
	//};

	//select_file = { arg view, path;
		//var filenode;
		//path.debug("select_file: path:");
		//if(path.notNil) {
			//var selected;
			//filenode = nodeClass.new(path);

			//proto.disable_play = true;
			//selected = view.items.indexOfEqual(filenode.label);
			//if(selected.notNil) {
				//view.value = selected;
			//};
			//proto.filenameview.string = filenode.fullPath.asString;
			//{
				//// hack because selectionAction is triggered even without valueAction_
				//// and with a delay
				//proto.disable_play = false;
			//}.defer(1/4);
			//debug("end disable play file");
		//}
	//};

	//fileview.enterKeyAction = { arg view;
		////[view.value, view.items].debug("select: ");
		//if(view.items.size > 0) {
			//changepath.(view, node.fullPath ++ view.items[view.value])
		//}
	//};
	//fileview.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		
		////[view.value, view.items].debug("double click select: ");
		//if(clickCount == 2 and: {view.items.size > 0}) {
			//changepath.(view, node.fullPath +/+ view.items[view.value])
		//}
	//});
	//fileview.selectionAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//var path = node.fullPath +/+ view.items[view.value];
		//var newnode = nodeClass.new(path);
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("selectionAction");
		////newnode.extension.dump;
		////proto.playable_extensions.debug("ext");
		////[proto.auto_mode, proto.auto_mode == 1, newnode.isFile, proto.playable_extensions.includesEqual(newnode.extension.debug("ext"))].debug("sel");
		//if(newnode.isFile) {
			//name_field.string = view.items[view.value];
		//};
		//if(proto.auto_mode == 1 and: {newnode.isFile and: { proto.playable_extensions.includesEqual(newnode.extension) }}) {
			//proto.play_file(path)
		//}
		
	//});

	//update_pathview = {
		//pathview.removeAll;
		//pathview.layout = HLayout.new.spacing_(0);
		//node.splitPath.do({ arg p, idx;
			////p.name.debug("p");
			//pathview.layout.add(
				//BasicButton.new.string_(p.label).action_({
					//changepath.(fileview, node.splitPath[idx].fullPath)

				//})
			//)
		//});
		//pathview.layout.add(nil)
	//};

	//quicklist.mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		//[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
		
		////[view.value, view.items].debug("double click select: ");
		//if(clickCount == 2 and: {view.items.size > 0}) {
			//changepath.(fileview, view.items[view.value])
		//}
	//});

	//proto.update_quicklistview = { arg self;
		//quicklist.items = proto.quicklist.select(_.notNil);	
	//};
	//proto.save_quicklist = { arg self;
		//File.use(self.config_file, "w", { arg file;
			//file.write(
				//"ProtoDef(\\filemanager_player).quicklist = [\n%];\n".format(
					//self.quicklist.collect(_.asCompileString).join(",\n")
				//)
			//)
		//});
	//};
	//proto.load_quicklist = { arg self;
		//if(self.config_file.notNil) {
			//self.config_file.load;
		//};
	//};


	//proto.play_file = { arg self, file;
		//self.current_file = file;
		//if(self.disable_play != true) {

			//file.debug("new source");
			//self.filenameview.string = file.asString;
			//nodeClass.new(file).play;
			////self.player.source_(
			//////Pmono( \playersec,
			//////\bufnum, BufDef(file.asSymbol),
			//////\dur, 1/8,
			//////\gain, 1,
			//////\amp, 0.1,
			//////),
			////Pbind(
			////\instrument, \playersec,
			////\bufnum, BufDef(file.asSymbol),
			////\dur, (BufDef(file.asSymbol).duration ? 1) * ~t * Pseq([1],1),
			////\amp, 0.1,
			////),
			////);
			////self.player.play;
		//}
	//};

	//proto.init = { arg self;
		//"wtf".debug;
		//proto.load_quicklist;
		//proto.quicklist = proto.quicklist ? [
			//path, 
			//"/", 
			//"~", 
			//"~/Musique/",
			//"~/Musique/sc/samplekit/",
			//"~/Musique/sc/reckit/",
			//"~/Musique/sc/samplekit/com/",
			//"~/code/sc/seco/vlive/",
			//"~/code/sc/seco/vlive/repeat/",
			//"~/code/sc/seco/vlive/repeat/capsule/",
		//].select(_.notNil);
		//proto.config_file = Platform.userConfigDir +/+ "filemanager_quicklist.sc";
		//proto.update_quicklistview;
		//self.player = self.player ? EventPatternProxy.new;
		//self.player.quant = 0;
		//proto.playerwrapper = PlayerWrapper(proto.player);
		//proto.auto_mode = proto.auto_mode ?? 0;
		//proto.auto_mode.debug("auto_modexx");
		//proto.playable_extensions = [
			//"wav",
			//"mp3",
			//"flac",
			//"ogg",
		//];
		//changepath.(fileview, path);
		//"wut".debug;
		//select_file.(fileview, proto.current_file);
	//};

	//proto.init;



	//proto.filenameview = StaticText.new.string_("...");
	//preview.layout = HLayout (
		//proto.playerwrapper.asView,
		//Param(Message(proto), \auto_mode, \unipolar).asButton("Auto"),
		//[proto.filenameview, stretch:4],
			//BasicButton.new.string_("Cancel").action_({
				//def.closeWindow;
			//}).maxWidth_(50),
			//BasicButton.new.string_("OK").action_({
				//var fpath = proto.cwd+/+name_field.value;
				//if(File.exists(fpath)) { // FIXME: should use .exists from node proto to not break the API
					//WindowDef(\ConfirmDialog).front("File already exists, are you sure you want to overwrite ?\n\n%".format(fpath), {
						//callback.(proto.cwd, name_field.value);
						//def.closeWindow;
					//})
				//} {
					//callback.(proto.cwd, name_field.value);
					//def.closeWindow;
				//};
			//}).maxWidth_(50),
	//);

	//VLayout (
		//HLayout (
			//BasicButton.new.string_("+").action_({
				//if(proto.quicklist.includesEqual(node.fullPath).not) {
					//proto.quicklist = proto.quicklist.add(node.fullPath);
					//proto.update_quicklistview;
					//proto.save_quicklist;
					//PathName("//bin").fullPath
				//}
			//}).maxWidth_(30),
			//BasicButton.new.string_("-").action_({
				//proto.quicklist.removeAt(quicklist.value ? 0);
				//proto.update_quicklistview;
				//proto.save_quicklist;
			//}).maxWidth_(30),
			//BasicButton.new.string_("Up").action_({
				//changepath.(fileview, node.parentNode.fullPath)
			//}).maxWidth_(50),
			//BasicButton.new.string_("Mkdir").action_({
				//WindowDef(def.key+++\MkdirDialog, WindowDef(\RenameDialog)).front("What is the new folder name ?", "", { arg name;
					//if(name != "") {
						//(node.fullPath +/+ name).mkdir;
						//(node.fullPath +/+ name).debug("folder created");
						//changepath.(fileview, node.fullPath); // refresh
					//} {
						//name.debug("invalid name");
					//}
				//})
			//}).maxWidth_(50),
			//pathview,

		//),
		//name_field,
		//HLayout (
			//quicklist,
			//fileview,
		//),
		//preview,
	//);

//});

///////////////////////////////// DRAFT

PathName("vla/dir/file").fileName
PathName("vla/dir/file").folderName
PathName("vla/dir/file").fullPath
PathName("vla/dir/").fileName
PathName("vla/dir/").folderName
PathName("vla/dir/").fullPath
PathName("vla/dir").fileName
PathName("vla/dir").folderName
PathName("vla/dir").fullPath

PathName("/bin/").entries
PathName("/bin").entries


ProtoTemplateDef(\filemanager_node).new("//bin").splitPath.collect(_.name)


ProtoTemplateDef(\filemanager_node).new("~/Musique/sc/samplekit/").splitPath
PathName("~/Musique/sc/samplekit/").fullPath.split($/)
PathName("~/Musique/sc/samplekit").isFolder
PathName("~/Musique").isFolder
PathName("~/Musique/").fileName
String

ProtoTemplateDef(\filemanager_node).new("~/Musique/sc/samplekit/").children.collect(_.name)
ProtoTemplateDef(\filemanager_node).new("~/Musique/sc/samplekit/").splitPath.collect(_.name)
ProtoTemplateDef(\filemanager_node).new("~/Musique/sc/samplekit/").splitPath.collect(_.name)
ProtoTemplateDef(\filemanager_node).new("~/Musique/").name

/////////////////////////////////

// old not working
WindowDef(\filemanager, { arg def, path, callback;
	var panes;
	var size = 4;
	var cwds = ""!size;
	var nodes = nil!size;
	var layout;
	var quickpane = ListView.new;
	var pathlabel = StaticText.new;
	var bindPane = { arg idx, node;
		nodes[idx] = node;
		panes[idx].items = node.children.collect({ arg child; child.name })
	};
	var flags = 0!size;

	var changePath = { arg path;
		var parts;
		path.debug("path");
		if(path.notNil) {
			path.play;
			parts = path.splitPath.keep(-4);
			parts.collect(_.name).debug("parts");
			size.do { arg idx;
				var cur = parts[idx];
				if(cur.notNil) {
					panes[idx].selectionAction = nil;
					[cur.name, cur.fullPath, cur.children].debug("cur");
					panes[idx].items = cur.children.collect({ arg child; child.name });
					panes[idx].selectionAction_({ arg view;
						changePath.(cur.children[view.value])
					});
					panes[idx].keyDownAction_({ arg view, key, modifiers, unicode, keycode;
						var curnode, selectedNode;
						curnode = cur;
						if(curnode.notNil) {

							selectedNode = curnode.children[view.value];
							[view, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
							if(key == $ ) {
								selectedNode.play;
							};
							if(key == 27.asAscii) {
								def.window.close;
							};
							if(key == $\r) {
								callback.(selectedNode.fullPath);
								def.window.close;
							}
						}
					});
				} {
					panes[idx].selectionAction = nil;
					panes[idx].keyDownAction = nil;
					panes[idx].items = []
				}
			};
		}
   	};
	layout = VLayout (
		pathlabel,
		HLayout (
			quickpane,
			* panes = size.collect({
				ListView.new;
			})
		)
	);

	quickpane.items = [
		path, 
		"/", 
		"~", 
		"~/Musique/",
		"~/Musique/sc/samplekit/",
		"~/Musique/sc/reckit/",
		"~/Musique/sc/samplekit/com/",
	].select(_.notNil);
	quickpane.selectionAction = { arg view;
		changePath.(
			ProtoTemplateDef(\filemanager_node).new(view.items[view.value]);
		);
	};
	layout;

}).front("~/bin", { arg view, path; view.window.close; path.debug("choosen path") });
(
	// old
WindowDef(\filemanager, { arg def, path, callback;
	var panes;
	var size = 4;
	var cwds = ""!size;
	var layout;
	var supported_extensions = [
		"wav",
		"flac",
	];
	var playfile = { arg curpathname;
		if(curpathname.isFile and: { supported_extensions.includesEqual(curpathname.extension.debug("e")) }) {
			SoundFile(curpathname.fullPath).play;
		}
	};
	layout = HLayout (*
		panes = size.collect({
			ListView.new;
		})
	);

	panes[0].items = [path, "/", "~", "~/Musique/sc/samplekit/com"].select(_.notNil);
	size.do { arg idx;
		var curpath, curpathname;
		panes[idx].selectionAction = { arg view;
			if(idx==0) {
				curpath = view.items[view.value];
			} {
				curpath = cwds[idx] +/+ view.items[view.value];
			};
			curpathname = PathName(curpath);
			playfile.(curpathname);
			panes[idx+1].items = curpathname.entries.collect({ arg path;
				if(path.isFolder) {
					path.folderName ++ "/"
				} {
					path.fileName
				}
			});

			cwds[idx+1] = curpath;
		};
		panes[idx].keyDownAction_({ arg view, key, modifiers, unicode, keycode;
			[view, key.asCompileString, modifiers, unicode, keycode].debug("keyDownAction");
			if(key == $ ) {
				playfile.(curpathname);
			};
			if(key == 27.asAscii) {
				def.window.close;
			};
			if(key == $\r) {
				callback.(view, curpathname.fullPath)
			}
		});
	};
	layout;

}).front("~/bin", { arg view, path; view.window.close; path.debug("choosen path") });
)

(
WindowDef(\bla, {

Param(Message(ProtoDef(\filemanager_player)), \auto_mode, \unipolar).asButton.states_([[ "Auto"],[ "Auto", Color.black, Color.green  ]])
}).front
)

(
WindowDef(\bla, {

Param(Message(ProtoDef(\filemanager_player)), \auto_mode, \unipolar).asToggleButton
}).front
)


(

p = Patch({ arg freq=440; SinOsc.ar(freq,mul: 0.1) });
g = p.gui;
g.keyDownAction =  {
    "you touched me".postln;
};

)
