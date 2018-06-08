Veco.load_lib("main.scd");
Veco.load_lib("synth.scd");
Veco.load_lib("synth.scd");

Veco.main.board_size = Point(32,64);
//~set_default_quant.(4);
Pdef.defaultQuant = 4;
~set_project_tempo.(185/4/60);
~load_standard_quickpad.();

ParamProto.init;

FileSystemProject.load("libdef/drumkit.scd");
FileSystemProject.load("algokit/kits/PatKitDef_sample1.scd");

FileSystemProject.load("libdef/tracks.scd");
FileSystemProject.load("libdef/piano.scd");
FileSystemProject.load("libdef/synthplayrec.scd");
FileSystemProject.load("libdef/multifbdel.scd");
FileSystemProject.load("libdef/basicrecorder.scd");
FileSystemProject.load("libdef/rdngui.scd");
FileSystemProject.load("libdef/simplemixer.scd");
FileSystemProject.load("libdef/pmodenv.scd");
FileSystemProject.load("capsule/RDN_track1.scd");
FileSystemProject.load("capsule/RDN_track1.scd");
FileSystemProject.load("capsule/PatKitDef_ksh.scd");
FileSystemProject.load("capsule/fxsimple.scd");
FileSystemProject.load("capsule/fxheavy.scd");

// END

Veco.main.fadeout_time = 16;

