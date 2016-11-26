
(
	s.waitForBoot({

~t = 80/60;
TempoClock.default.tempo = ~t;
Ndef.defaultQuant = 4;
Pdef.defaultQuant = 4;
FileSystemProject.load("radient1/lib.scd");
FileSystemProject.load("proto1/tracks.scd");
FileSystemProject.load("ex1/lib.scd");
FileSystemProject.load("ex1/multifbdel.scd");
FileSystemProject.load("ex2/soundfileview.scd");
FileSystemProject.load("ex2/drumkit.scd");
FileSystemProject.load("ex2/recordgui.scd");
FileSystemProject.load("ex2/basicrecorder.scd");
FileSystemProject.load("ex2/metronome.scd");
FileSystemProject.load("lib/piano.scd");
ParamProto.init;

ParamViewToolBox.color_dark = Color.new255(16, 78, 9);
ParamViewToolBox.color_ligth = Color.new255(32, 156, 17);

Ndef(\fx1).addSpec(\deltran1, ControlSpec(-1,5,\lin, 0,1));
Ndef(\fx1).addSpec(\deltran2, ControlSpec(-1,5,\lin,0,0));
Ndef(\fx1).addSpec(\deltran3, ControlSpec(-1,5,\lin,0,0));
Spec.add(\distamp, ControlSpec(0.01,30,\exp));
Spec.add(\deltran1, ControlSpec(0.01,30,\exp));
Spec.add(\deltran2, ControlSpec(0.01,30,\exp));
Spec.add(\deltran3, ControlSpec(0.01,30,\exp));

Spec.add(\verbmix, \unipolar);
Spec.add(\adsr, XEnvSpec.adsr);

	});
)

// END

(
~t = 90/60;
TempoClock.default.tempo = ~t;
)

(
~t = 173/60;
TempoClock.default.tempo = ~t;
)
