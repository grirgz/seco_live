
(
Pdef.defaultQuant = 2;
//Ndef.defaultQuant = 1;
~t = 135/4/60; TempoClock.default.tempo = ~t;
s.waitForBoot {
	"lib.scd".loadRelative;
	//FileSystemProject.load("capsule/lib.scd");
	FileSystemProject.load("capsule/ile_lib.scd");
	0.1.wait;
	FileSystemProject.load("capsule/mainwindow.scd");
	FileSystemProject.load("capsule/track1.scd");
	FileSystemProject.load("capsule/draftsynth.scd");
	FileSystemProject.load("capsule/PatKitDef_ksh.scd");
	FileSystemProject.load("holis/synthdef.scd");

	0.1.wait;
	FileSystemProject.load("capsule/ile2_lib.scd");
	FileSystemProject.load("capsule/ile3_lib.scd");
	FileSystemProject.load("capsule/ile4_lib.scd");
	FileSystemProject.load("capsule/ile5_lib.scd");
	FileSystemProject.load("capsule/ile6_lib.scd");
	FileSystemProject.load("capsule/ile7_lib.scd");
	0.1.wait;
	ProtoDef(\rdn, ProtoTemplateDef(\rdn));
	ProtoDef(\rdn2, ProtoTemplateDef(\rdn));
	ProtoDef(\rdn3, ProtoTemplateDef(\rdn));
	ProtoDef(\rdn).loadFromPresetLib("default");
	ProtoDef(\rdn2).loadFromPresetLib("default");
	ProtoDef(\rdn3).loadFromPresetLib("default");
	ProtoDef(\rdn).inbus = BusDef(\sendbus1);
	ProtoDef(\rdn2).inbus = BusDef(\sendbus2);
	ProtoDef(\rdn3).inbus = BusDef(\sendbus3);
	"DONE <-------------- ".postln;
};
);


(
ProtoDef(\rdn).loadFromPresetLib("default");
ProtoDef(\rdn2).loadFromPresetLib("default");
ProtoDef(\rdn3).loadFromPresetLib("default");
ProtoDef(\rdn).inbus = BusDef(\sendbus1);
ProtoDef(\rdn2).inbus = BusDef(\sendbus2);
ProtoDef(\rdn3).inbus = BusDef(\sendbus3);
)

ProtoDef(\rdn).loadFromPresetLib("ile5_kick");
ProtoDef(\rdn).loadFromPresetLib("ile5_kickdist");
ProtoDef(\rdn2).loadFromPresetLib("ile5_snare");
ProtoDef(\rdn2).loadFromPresetLib("ile5_snaredist");




StageLimiter.activate
