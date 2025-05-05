
FileSystemProject.load("libdef/default_specs.scd");

FileSystemProject.load("libdef/MainProject.scd");

// resources


FileSystemProject.load("libdef/pmodenv.scd");
FileSystemProject.load("sndlib/buflib.scd"); // ~buflib
FileSystemProject.load("libdef/synthplayrec.scd"); // playersec
FileSystemProject.load("sndlib/synthbasic.scd"); // playersec
FileSystemProject.load("capsule/fxsimple.scd"); // fx
FileSystemProject.load("cavern/ifxsimple.scd"); // fx
//FileSystemProject.load("capsule/draftsynth.scd");
//FileSystemProject.load("holis/synthdef.scd"); 

FileSystemProject.load("libdef/equalizer.scd");

// tools

FileSystemProject.load("libdef/controllers.scd"); 
FileSystemProject.load("paramdev/drafts/PianoCenter.scd"); 
FileSystemProject.load("capsule/sample_manager.scd"); // TODO move to libdef
FileSystemProject.load("libdef/bufEditor.scd"); 
//FileSystemProject.load("libdef/PbindefEditor.scd"); // in quark
FileSystemProject.load("libdef/ModulatorRack.scd"); 
FileSystemProject.load("libdef/ParamTimelineRack.scd"); 
FileSystemProject.load("libdef/WorkspaceView.scd"); 
FileSystemProject.load("paramdev/drafts/DrumTrack.scd"); 

// controller

FileSystemProject.load("libdef/piano.scd");


// rdn
FileSystemProject.load("libdef/multifbdel.scd");
FileSystemProject.load("libdef/rdngui.scd");
FileSystemProject.load("libdef/rdnstring.scd");

// editor

FileSystemProject.load("libdef/inline_editor.scd");
