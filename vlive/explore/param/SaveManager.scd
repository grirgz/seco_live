
ProtoClassDef(\SaveManager, (
	// Plan:
	//	- only keep in savable classes:
	//		- presetCompileString
   	//		- refCompileString
	//		- presetCompileStringSavePath: redirect to local SaveManager
	//		- savePresetCompileString: private, only used by SaveManager
	//		- loadPresetCompileString: private, only used by SaveManager
	//	- SaveManager handle:
	//		- save: when target have a path, don't need to ask anything to save
	//		- save: when no path, can't save on existing, can only create new (or else ask if sure)
	//		- saveAs: can choose another new (or ask if sure)
	//		- open: can only load something if project is empty or already saved 
	//			but since we don't know if saved, should forbid
	//		- read: used by parent class to load a file
	//		- write: used by parent class to write presetCompileString to a file
	//			maybe only give filename as parameter and SaveManager handle the path
	//		
	//		can do the same at code level without GUI
	//		can trigger GUI automatically when saving and not path at code level too
	//		could have global options to customize ?
	new: { arg self, savable;
		self = self.deepCopy;
	
		self.savable = savable;
		self.fileSet = Set.new;
	
		self;
	},

	//// redirect funcs

	presetCompileString: { arg self;
		self.savable.presetCompileString;
	},

	refCompileString: { arg self;
		self.savable.presetCompileString;
	},

	//// tools funcs

	write: { arg self, mypath, contentfun, overwrite=false, writePath=false, action;
		var myfolderpath = PathName(mypath.value).pathOnly;
		var myfolderpathname;
		myfolderpathname = FileSystemProject.resolve(myfolderpath);
		if(myfolderpathname.notNil) {
			mypath = myfolderpathname.fullPath ++ PathName(mypath).fileName;
			Log(\Param).info("Trying to write preset to file %", mypath.asCompileString);
			block { arg break;
				if(overwrite==false) {
					if(PathName(mypath).exists) {
						Log(\Param).error("ERROR: file already exists!");
						break.value;
					};
				};
				File.use(mypath, "w", { arg file;
					var relpath = FileSystemProject.unresolve(mypath);
					var preset;
					if(writePath==true) {
						self.presetCompileStringSavePath = relpath;
						file.write("%.presetCompileStringSavePath = %;\n\n".format(self.refCompileString, relpath.asCompileString));
					};
	
					preset = contentfun.value;
					if(preset.isNil) {
						"ERROR: no preset found for this object".postln;
					} {
						file.write(preset);
						"Preset written: %".format(mypath).postln;
					};
				});
				action.()
			}
		} {
			"ERROR: savePresetCompileString: Can't resolve file %".format(mypath).postln;
		};
	},

	doWithOptions: { arg self, fun, overwriting;
		self.overwriting = overwriting;
		
	},

	////// savable funcs

	addFile: { arg self, filename, func;
		func = func ? {self.presetCompileString};
		self.fileSet.add(filename -> func);
	},

	saveFileSet: { arg self, path, overwrite=false;
		self.fileSet.do { arg asso;
			self.write(asso.key, asso.value, overwrite)
		}
	},

	loadFileSet: { arg self;
		self.fileSet.do { arg asso;
			self.read(asso.key)
		}
	},

	////// user funcs

	save: { arg self, path;
		var save_it = ;
		if(path.notNil) {
			// code given path
			if(self.presetCompileStringSavePath.notNil and: { self.presetCompileStringSavePath == path }) {
				self.saveFileSet(true);
				self.savable.savePresetCompileString;
			} {
				// prevent overwriting
				self.saveFileSet(false);
				self.savable.savePresetCompileString;
			}
		} {
			if(self.presetCompileStringSavePath.notNil and: { force_dialog==false }) {
				// save in its file
				save_it.(self.presetCompileStringSavePath)
				self.savable.savePresetCompileString;
			} {
				// GUI given path
				Dialog.savePanel({ arg mypath;
					//path.postln;
					save_it.(mypath)
				},{
					//"cancelled".postln;
				});
			}

		};
	},

	saveAs: { arg self, path;
		
	},

	open: { arg self, path;
		
	},

	load: { arg self;
		
	},

))
