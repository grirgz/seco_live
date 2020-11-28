
//// singleton mode
(
	FileSystemProject.load("libdef/SaverHelper.scd");
	ProtoDef(\test_singleton, (
		init: { arg self;
			ProtoTemplateDef(\SaverHelper).attachSaveMethods(self);
			self.initFromPresetCompileString("./testsave.scd")
		},
		isEmpty: { arg self;
			self.data.isNil
		},

		bark: { arg self;
			self.data = rrand(1,10);
			"bark %".format(self.data).postln;
			self.savePresetCompileString;
		},
		presetCompileString: { arg self;
			"ProtoDef(%).data = %;\n".format(self.key.asCompileString, self.data.asCompileString);
		},

	));
	ProtoDef(\test_singleton).init;
)

////// Test procedure

// when file is not existant

	// first remove file
	~pathtoremove = FileSystemProject.resolve(ProtoDef(\test_singleton).loadedFromFile).fullPath // verify correct path
	File.delete(~pathtoremove);

	// run definition
	File.exists(FileSystemProject.resolve(ProtoDef(\test_singleton).loadedFromFile).fullPath); // should not exist
	ProtoDef(\test_singleton).bark; // should save;
	// restart SClang
	// run again definition
	ProtoDef(\test_singleton).data; // data should be the save
// when file exists

	// run definition
	ProtoDef(\test_singleton).bark; // should save;
	// restart SClang
	// run again definition
	ProtoDef(\test_singleton).data; // data should be the save

///////////////// project mode


(
	FileSystemProject.load("libdef/SaverHelper.scd");
	FileSystemProject.load("libdef/MainProject.scd");
	ParamProto.init;
	ProtoDef(\test_projectpart, (
		init: { arg self;
			ProtoTemplateDef(\SaverHelper).attachSaveMethods(self);
		},
		isEmpty: { arg self;
			self.data.isNil
		},

		bark: { arg self;
			self.data = rrand(1,10);
			"bark %".format(self.data).postln;
			self.savePresetCompileString;
		},
		presetCompileString: { arg self, path;
			[
			"ProtoDef(%).presetCompileStringSavePath = %;".format(self.key.asCompileString, path.asCompileString),
			"ProtoDef(%).data = %;".format(self.key.asCompileString, self.data.asCompileString),
			].join("\n");

		},

	));
	ProtoDef(\test_projectpart).init;
	FileSystemProject("tests/tmp/testproj").addResource(ProtoDef(\test_projectpart));
)

//// test
// save only module

	FileSystemProject.resolve("tests/tmp/testproj"); // does project exists ?
	FileSystemProject("tests/tmp/testproj"); // does project exists ?

	// run definition
	~proj = ProtoTemplateDef(\MainProject).loadProject(FileSystemProject.resolve("tests/tmp/testproj").fullPath);
	ProtoDef(\test_projectpart).bark; // can't save because path is set at project save time
	~proj.saveProject;
	FileSystemProject("tests/tmp/testproj").saveProject

	////// load
	// restart sclang
	FileSystemProject.load("libdef/MainProject.scd");
	~proj = ProtoTemplateDef(\MainProject).loadProject("tests/tmp/testproj"); // load project
	// run definition
	ProtoDef(\test_projectpart).data; // should not be nil
	ProtoDef(\test_projectpart).bark; // should save
	// FIXME: resource is not added at load, this fail

//////// draft

// project creation code
~proj = FileSystemProject( FileSystemProject.resolve("./tmp/testproj").fullPath, ProtoTemplateDef(\MainProject));
~proj.saveProject;

FileSystemProject.resolve("tests/tmp")
FileSystemProject.resolve("./tests/tmp/testproj")
FileSystemProject.current.addResource(ProtoDef(\test_projectpart))


//////////////////////// not singleton, initFromPresetCompileString


(
	FileSystemProject.load("libdef/SaverHelper.scd");
	ProtoTemplateDef(\test_templateclass, (
		init: { arg self;
			ProtoTemplateDef(\SaverHelper).attachSaveMethods(self, true);
			self;
		},
		isEmpty: { arg self;
			self.data.isNil
		},

		bark: { arg self;
			self.data = rrand(1,10);
			"bark %".format(self.data).postln;
			self.savePresetCompileString;
		},
		presetCompileString: { arg self, path;
			"ProtoDef(%, %);\n".format(self.key.asCompileString, self.parent.asCompileString);
			"ProtoDef(%).loadedFromFile = %;\n".format(self.key.asCompileString, path.asCompileString);
			"ProtoDef(%).data = %;\n".format(self.key.asCompileString, self.data.asCompileString);
		},

	));
	ProtoDef(\test_templateinst, ProtoTemplateDef(\test_templateclass)).init;
)

// test savedialog

	ProtoDef(\test_templateinst).bark; // can't save, no filename
	ProtoDef(\test_templateinst).savePresetCompileStringDialog; // choose a file
	ProtoDef(\test_templateinst).initFromPresetCompileString("insert path"); // insert path
	// this will fail because instance is not empty
	// restart sclang
	// run again the line initFromPresetCompileString
	ProtoDef(\test_templateinst).initFromPresetCompileStringDialog; // check if instance is empty but can't check if it is the correct path
	ProtoDef(\test_templateinst).data; // should not be nil

// test code path;

	ProtoDef(\test_templateinst).bark; // can't save, no filename
	ProtoDef(\test_templateinst).savePresetCompileString("./tmp/myinst.scd"); // should delete this line just after in real projects to avoid overwriting by error
	ProtoDef(\test_templateinst).initFromPresetCompileString("./tmp/myinst.scd");
	// this will fail because instance is not empty
	// restart sclang
	ProtoDef(\test_templateinst).initFromPresetCompileString("./tmp/myinst.scd"); // run again the line initFromPresetCompileString
	ProtoDef(\test_templateinst).data; // should not be nil





