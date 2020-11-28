
(
ProtoTemplateDef(\SaverHelper, (
	saveMethods: (
		savePresetCompileStringDialog: { arg self;
			WindowDef(\filedialog_save).front(nil,{ arg path, file;
				var fp = path +/+ file;
				File.use(fp, "w") { arg file;
					file.write(self.presetCompileString)
				};
				Log(\Param).debug("preset written to %", fp);
			})
			
		},
		savePresetCompileString: { arg self, path;
			path = path ?? { self.loadedFromFile ?? { self.presetCompileStringSaveFile } };

			path = path !? { FileSystemProject.resolve(path).fullPath; };
			if(path.notNil) {
				Log(\Param).debug("preset will be %", path);
				File.use(path, "w") { arg file;
					file.write(self.presetCompileString(path))
				};

				// FIXME: this is always a file, maybe should use a always-file variable ?
				// note sure if i should overwrite presetCompileStringSaveFile
				self.presetCompileStringSavePath = path; 

				Log(\Param).debug("preset written to %", path);
			} {
				Log(\Param).debug("no path to write");
			};
		},
		loadPresetCompileString: { arg self, path, force=false;
			path = FileSystemProject.resolve(path).fullPath;
			FileSystemProject.load(path);
			self.loadedFromFile = path;
		},

		initFromPresetCompileString: { arg self, path;
			// FIXME: method name is not quite right
			if(path.notNil) {
				if(self.isEmpty == true) {
					self.loadPresetCompileString(path)
				} {
					path = path !? { FileSystemProject.resolve(path).fullPath; };

					if(File.exists(path)) {
						Log(\Param).debug("Can't set save file path, file already exists and current object is not empty: %", path);
					} {
						self.loadedFromFile = FileSystemProject.resolve(path).fullPath;
					}
				};
			} {
				Log(\Param).error("no path provided for initFromPresetCompileString");
			}
		},

		presetCompileStringProjectFile: { arg self;
			// maybe deprecated
			// presetCompileStringSaveFile is not linked to project and more generic
			if(self.presetCompileStringProjectDataPath.notNil) {
				self.presetCompileStringProjectDataPath +/+ self.presetCompileStringFilename;
			}
		},

		// added by FileSystemProject
		//presetCompileStringProjectDataPath: { arg self;
			//if(self.presetCompileStringSavePath.notNil) {
				//self.presetCompileStringSavePath +/+ self.presetCompileStringFilename;
			//}
		//},

		presetCompileStringSaveFile: { arg self;
			if(self.presetCompileStringSavePath.notNil) {
				if( self.presetCompileStringSavePath.isFolder) {
					self.presetCompileStringSavePath +/+ self.presetCompileStringFilename
				} {
					self.presetCompileStringSavePath
				}
			} {
				if( self.presetCompileStringProjectDataPath.notNil) {
					self.presetCompileStringProjectDataPath +/+ self.presetCompileStringFilename
				};
			}
		},

		presetCompileStringFilename: { arg self;
			"ProtoDef_%.scd".format(self.key)
		},

		//isEmpty: { arg self;
			//if
			
		//},

		// TODO: code from MainProject for WIP
			//load
	//FileSystemProject.current
				//resource.presetCompileStringSavePath = self.dataPath;
				//resource.loadedFromPath = self.dataPath; // bypass the overwrite protection mecanism for debug
				//resource.savePresetCompileString;

		loadPresetCompileStringIfEmpty: { arg self, path;
			// maybe deprecated by initFromPresetCompileString
			if(self.isEmpty) {
				self.loadPresetCompileString(path)
			} {
				Log(\Param).debug("Can't load file, protection to not overwrite");
				self.loadedFromFile = path;
			};
		},

	),
	attachSaveMethods: { arg self, target, force=false;
		self.saveMethods.keys.do { arg key;
			if(force or: {target[key].isNil}) {
				target[key] = self.saveMethods[key]
			}
		};
	},

))
)
