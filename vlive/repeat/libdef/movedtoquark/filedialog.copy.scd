WindowDef(\filedialog_save, { arg def, path, callback, nodeClass;
	// callback(folderPath, new_filename)

	var fileview, changepath, select_file;
	var pathview = View.new;
	var quicklist = ListView.new;
	var node;
	var update_pathview;
	var preview = View.new;
	var proto = ProtoDef(\filemanager_player);
	var name_field;
	nodeClass = nodeClass ?? { ProtoTemplateDef(\filemanager_node) };

	path.debug("firstpath");
	name_field = TextField.new;
	if(path.isNil) {
		path = proto.cwd ? PathName(Document.current.path).pathOnly ? "~"
	} {
		name_field.value = PathName(path).fileName;
		path = PathName(path).pathOnly;
	};
	path.debug("endpath");
	name_field.value.debug("namefield");

	if(def.window.notNil) {
		def.window.view.keyDownAction = { arg view, char, modifiers, u, k; 
			//[char, modifiers, u, k].debug("KEYBOARD INPUT");
			if( u == 27 ) { // Esc
				def.closeWindow
			};
		};
	};

	fileview = ListView.new;
	changepath = { arg view, path;
		var newnode;
		path.debug("changepath: ");
		newnode = nodeClass.new(path);
		if(newnode.isFolder) {
			node = newnode;
			proto.disable_play = true;
			view.items = node.children.collect(_.label);
			{
				// hack because selectionAction is triggered even without valueAction_
				// and with a delay
				proto.disable_play = false;
			}.defer(1/4);
			debug("end disable play");

			proto.cwd = node.fullPath;
			update_pathview.()
		} {
			proto.play_file(path);
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
			debug("end disable play file");
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
			changepath.(view, node.fullPath +/+ view.items[view.value])
		}
	});
	fileview.selectionAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
		var path = node.fullPath +/+ view.items[view.value];
		var newnode = nodeClass.new(path);
		[view, x, y, modifiers, buttonNumber, clickCount].debug("selectionAction");
		//newnode.extension.dump;
		//proto.playable_extensions.debug("ext");
		//[proto.auto_mode, proto.auto_mode == 1, newnode.isFile, proto.playable_extensions.includesEqual(newnode.extension.debug("ext"))].debug("sel");
		if(newnode.isFile) {
			name_field.string = view.items[view.value];
		};
		if(proto.auto_mode == 1 and: {newnode.isFile and: { proto.playable_extensions.includesEqual(newnode.extension) }}) {
			proto.play_file(path)
		}
		
	});

	update_pathview = {
		pathview.removeAll;
		pathview.layout = HLayout.new.spacing_(0);
		node.splitPath.do({ arg p, idx;
			//p.name.debug("p");
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


	proto.play_file = { arg self, file;
		self.current_file = file;
		if(self.disable_play != true) {

			file.debug("new source");
			self.filenameview.string = file.asString;
			nodeClass.new(file).play;
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
		}
	};

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
		proto.playable_extensions = [
			"wav",
			"mp3",
			"flac",
			"ogg",
		];
		changepath.(fileview, path);
		"wut".debug;
		select_file.(fileview, proto.current_file);
	};

	proto.init;



	proto.filenameview = StaticText.new.string_("...");
	preview.layout = HLayout (
		proto.playerwrapper.asView,
		Param(Message(proto), \auto_mode, \unipolar).asButton("Auto"),
		[proto.filenameview, stretch:4],
			BasicButton.new.string_("Cancel").action_({
				def.closeWindow;
			}).maxWidth_(50),
			BasicButton.new.string_("OK").action_({
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
