
(
~class_clip_preset_manager = (
	new: { arg self, project_root;
		self = self.deepCopy;
	
		self.clip_library = (
			//"/home/ggz/projects/blabla/1.1": ( tags: [\granular, \bass] ),
			//"/home/ggz/projects/ho/yo/t.41": ( tags: [\nappe, \ndef, \bass] ),
		);

		self.project_root = project_root ? Veco.user_path;
		if(self.project_root.last == $/) { self.project_root = self.project_root.drop(-1) }; // blame PathName
		self.project_root.debug("projroot");
		self.data_path = self.project_root +/+ "data/clip_preset_manager.scd".standardizePath;

		self.load_data;
		self.open_holder_project;
	
		self;
	},

	// node management

	open_holder_project: { arg self;
		self.project_path = "~/code/sc/seco/vlive/preset_holder".standardizePath;
		if(Veco.projects[self.project_path].isNil) {
			Veco.open_side_project(self.project_path)
		}
	},

	play_preset: { arg self, path;
		self.clip_do { arg node, clip;
			clip.response_on_play;
		}
	},

	copy_current_preset: { arg self, path;
		self.clip_do { arg node, clip;
			node.main.clipboard_mode = \clip;
			node.main.clipboard_clip = [clip];
		};
	},

	load_preset: { arg self, path, stop_it=true;
		if(stop_it) {
			self.stop_preset;
		};
		Veco.projects[self.project_path].use {
			var main;
			var uname;
			var node;
			var clip;
			var target_path;
			var target_uname;
			var target_clip_uname;
			var filename;
			target_uname = PathName(path).fileName;
			target_path = PathName(path).pathOnly;
			filename = target_uname.split($.);
			if(filename.size < 3) {
				// tags on node file
				debug("load_preset: NOT_IMPLEMENTED");
			} {
				// tags on clip file
				target_uname = filename[0].asSymbol;
				target_clip_uname = ( filename[0]++ "." ++ filename[1] ).asSymbol;
				main = Veco.main;

				//Veco.main.get_node_by_index(0).clips.debug("nn")
				//main.get_node_by_index(0).get_clip_by_index(0).debug("nn")
				//main.get_node_by_index(0).clips[0]

				uname = main.index_to_uname(0);

				node = ~class_shortcut_node.new(main, uname.asSymbol, target_path, target_uname);
				//node[\save_data] = nil; // prevent overwriting data file with wrong uname

				main.nodes[uname] = node;
				node.path.debug("path");
				"load data".debug;
				node.load_data;
				"exec".debug;
				node.execute;

				"create clip".debug;
				clip = ~class_shortcut_clip.new(main, ( uname++".1" ).asSymbol, node, target_path, target_clip_uname);
				//clip[\save_data] = nil; // prevent overwriting data file with wrong uname

				node.clips[0] = clip;
				[clip.uname,clip.path].debug("path");
				~buf.debug("buf");
				//~debugclip = clip;
				clip.load_data;


			};

		};
		self.copy_current_preset;
	},

	load_and_play_preset: { arg self, path;
		self.load_preset(path);
		self.play_preset(path);
	},

	stop_preset: { arg self;
		Veco.projects[self.project_path].use {
			//Veco('1.1').stop_node;
			Pdef(Veco('1').uname).clear;
			Ndef(Veco('1').uname+++\fx).clear;
		}
	},

	get_current_preset: { arg self;
		self.clip_listview_data[self.clip_listview.value]
	},

	clip_do: { arg self, fun;
		Veco.projects[self.project_path].use ({
			fun.( Veco('1'), Veco('1.1'))
		})
	},

	is_current_node_playing: { arg self;
		Veco.projects[self.project_path].use ({
			~veco_is_current_node_playing = Veco('1').is_playing;
			Veco('1.1').debug("kkkkkkkkkkkkk");
			~veco_is_current_node_playing.debug("is_PLAYING");
		});
		Veco.projects[self.project_path][\veco_is_current_node_playing].debug("is_PLAYINGkdjksl");
	},
 

	// lib management

	get_clips: { arg self;
		self.clip_library;
	},

	get_tags: { arg self;
		var tags = ();
		self.clip_library.keysValuesDo { arg key, val;
			val.tags.do { arg tag;
				tag = tag.asSymbol;
				tags[tag] = tags[tag].add(key);
			};
		};
		tags;
	},

	scan_tree: { arg self, path, save=true, reset=true;
		if(reset=true) {
			self.clip_library = ();
		};
		self.refresh_gui;
		self.wait_if_in_routine(0.1);
		//"befwaore".debug;
		//1.wait;
		//"xxxxxbefwaore".debug;
		self.scan_tree_recursive(path);
		if(save == true) {
			self.save_data;
		};
		self.refresh_gui;
		//"befwaore".debug;
		//0.1.wait;
		//"dddbefwaore".debug;
		//self.wait_if_in_routine(0.1);
	},

	wait_if_in_routine: { arg self, time=0.01;
		if(thisThread.isKindOf(Routine), { time.wait; }, {  });
	},

	scan_tree_recursive: { arg self, path;
		var pn;
		
		pn = PathName(path);
		pn.folders.do { arg dir;
			var tags;
			dir.fullPath.debug("class_clip_preset_manager: entering");
			self.scan_project(dir.fullPath);
			self.scan_tree_recursive(dir.fullPath);
		};
		
	},

	scan_project: { arg self, project_path;
		var pn;
		pn = PathName(project_path);
		pn.files.do { arg file;
			var tags;
			tags =  self.scan_file(file.fullPath);
			if(tags.notNil) {
				if(self.clip_library[file.fullPath].isNil) {
					self.clip_library[file.fullPath] = (tags:[]);
				};
				if(self.clip_library[file.fullPath][\tags].isNil) {
					self.clip_library[file.fullPath][\tags] = List.new;
				};
				self.clip_library[file.fullPath][\tags] = tags;
			};
			self.wait_if_in_routine;
		};
	},

	scan_file: { arg self, path;
		var code;
		var tagline_start, tagline_end, tagline;
		var magic;
		var tags = [];
		if(File.exists(path)) {
			var filename;
			filename = PathName(path).fileName;
			filename = filename.split($.);
			if(filename.size < 3) {
				// tags on node file
				//debug("load_preset: NOT_IMPLEMENTED for nodes");
			} {
				File.use(path, "r", { arg file;
					//"bed".debug;
					code = file.readAllString;
					//"afd".debug;
				});
				magic = "\n// TAGS:";
				tagline_start = code.find(magic);
				if(tagline_start.notNil) {
					tagline_end = code.find("\n", offset: tagline_start+1);
					if(tagline_end.isNil) {
						tagline_end = code.size;
					};
					tagline = code.copyRange(tagline_start+magic.size, tagline_end-1);
					tags = tagline.split($,).collect({ arg tag; 
						tag.stripWhiteSpace;
					});
				}
			};
			//[tagline_start, tagline_end, tagline,tags].debug("scan_file: tags");
		} {
			( "ERROR: file not found: "++ path ).postln;
		};
		tags
	},

	load_data: { arg self;
		self.clip_library = self.data_path.load;
	},

	save_data: { arg self;
		File.use(self.data_path, "w", { arg file;
			file.write(self.clip_library.asCompileString);
		});
	},


	// GUI

	refresh_button: { arg self;
		Task{
			1.wait;
			{
				self.play_button.states = if(self.is_current_node_playing) {
					[["Play", Color.white, Color.green]];
				} {
					[["Play", Color.white, Color.red]];
				};
			}.defer
		}.play;
	},

	edit: { arg self;
		self.window = Window.new("Preset Manager", Rect(300,300,900,400));
		self.tag_listview = ListView.new;
		self.clip_listview = ListView.new;
		self.tag_listview.action = {
			//self.refresh_gui;
			"action".debug;
			self.refresh_cliplist;
		};
		self.clip_listview.enterKeyAction = {
			self.load_and_play_preset(self.get_current_preset);
			self.refresh_button;
		};

		self.rescan_button = Button.new;
		self.rescan_button.states = [ ["Rescan"] ];
		self.rescan_button.action = {
		fork{
				self.scan_tree(self.project_root);
			}
		};

		self.play_button = Button.new;
		self.play_button.action = {
			//self.play_button.states = if(self.is_current_node_playing) {
			//	self.stop_preset(self.get_current_preset);
			//	[["Stopped", Color.white, Color.red]];
			//} {
			//	[["Playing", Color.white, Color.green]];
			//};
			self.load_and_play_preset(self.get_current_preset);
			self.refresh_button;
		};

		self.stop_button = Button.new;
		self.stop_button.states = [ ["Stop"] ];
		self.stop_button.action = {
			self.stop_preset;
			self.refresh_button;
		};

		self.edit_button = Button.new;
		self.edit_button.states = [ ["Edit"] ];
		self.edit_button.action = {
			self.load_preset(self.get_current_preset, false);
			self.clip_do { arg node, clip;
				[clip.path, clip.data_path, clip.uname, clip.target_uname].debug("edit: path");
				clip.open_in_editor
			};
			self.refresh_button;
		};

		self.load_project_button = Button.new;
		self.load_project_button.states = [ ["Open project"] ];
		self.load_project_button.action = {
			var ppath;
			self.load_preset(self.get_current_preset);
			debug("kkjkjjk");
			//Veco.projects[self.project_path].debug("1")[\veco].debug("2").get_node_by_index(0).debug("3").target_project_path.debug("4");
			ppath =  Veco.projects[self.project_path][\veco].get_node_by_index(0).target_project_path;
			Veco.open_project(ppath);
		};


		// TODO: volume fader
		//MIDIBoard.map(\s1, Ndef((uname++'mixer').asSymbol), mixer_key, self.level_spec);
					//cview = VecoLib.lib[\class_rack_control_scalar_knob_view].new(MIDIBoard.controls[\s1], self);
					//view.layout = cview.make_layout;

		self.refresh_button;
		//self.play_button.valueAction = 0;
		self.top_layout = HLayout.new(self.rescan_button, self.stop_button, self.play_button, self.edit_button, self.load_project_button);
		self.list_layout = HLayout.new(self.tag_listview, self.clip_listview);
		self.layout = VLayout.new(self.top_layout, self.list_layout);
		self.window.layout = self.layout;


		self.refresh_gui;


		self.window.front;
	},

	refresh_gui: { arg self;
		self.refresh_taglist;
		self.refresh_cliplist;
		
	},

	refresh_taglist: { arg self;
		var tags, taglib;
		taglib = self.get_tags;
		taglib.debug("ttaglib");
		tags = taglib.keys.asArray.sort;
		{
			self.tag_listview.items = tags;
		}.defer;
		
	},

	refresh_cliplist: { arg self;
		var tags, taglib;
		var cliplib;
		"refresh_cliplist".debug;
		taglib = self.get_tags;
		cliplib = self.get_clips;
		self.clip_listview_data = List.new; // used by get_current_preset to retrieve path
		
		//taglib.debug("taglib");
		tags = taglib.keys.asArray.sort;
		//tags.debug("tags");
		{
			self.tag_listview.value.debug("index");
			if(self.tag_listview.value.notNil) {
				var items;
				tags[self.tag_listview.value].asSymbol.debug("tag");

				items = taglib[tags[self.tag_listview.value].asSymbol].collect{ arg path;
					var pn;
					var res;
					pn = PathName(path);
					res = pn.asRelativePath(self.project_root);
					res = "% -- %".format(res, cliplib[path][\tags].sort.join(", "));
					[path,res];
				};
				items.debug("before");
				items = items.sort({ arg a, b; a[0] > b[0] });
				items.debug("after");
				self.clip_listview.items = items.collect { arg item;
					self.clip_listview_data.add(item[0]);
					item[1];
				};
				self.clip_listview_data.debug("data");
				self.clip_listview.items.debug("items XXX");

			} {
				self.clip_listview.items = [];
			}
		
		}.defer;
	},


);

);
