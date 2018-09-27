

(
ProtoTemplateDef(\filemanager_node, (
	supported_extensions: [
		"wav",
		"flac",
	],
	new: { arg self, name;
		self = self.copy;
		if(name.isKindOf(String)) {
			// PathName is sensible to end slash regarding fileName
			if(name.size > 1 and: {name.endsWith("/")}) {
				name = name[0..name.size-1];
			};
			name = PathName(name);
		};
		self.pathName = name;
		self;
	},
	className: { arg self;
		ProtoTemplateDef(\filemanager_node);
	},
	name: { arg self;
		if(self.pathName.isFolder) {
			self.pathName.folderName ++ "/"
		} {
			self.pathName.fileName
		}
	},
	fullPath: { arg self;
		self.pathName.fullPath
	},
	play: { arg self;
		if(self.isFile and: { self.supported_extensions.includesEqual(self.pathName.extension) }) {
			SoundFile(self.fullPath).play;
		}
	},
	splitPath: { arg self;
		[ self.new("/") ] ++ self.fullPath.split($/).select(_ != "").debug("split").collect({ arg p; self.new(p) })
	},
	isFile: { arg self;
		self.pathName.isFile;
	},
	isFolder: { arg self;
		self.pathName.isFolder;
	},
	selectedIndex: 0,
	children: { arg self;
		self.pathName.entries.collect({ arg p; self.new(p) });
	},

));


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
)

// END

///////////////////////////////// DRAFT

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

