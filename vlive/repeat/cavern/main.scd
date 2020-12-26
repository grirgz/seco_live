
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
FileSystemProject.load("cavern/lib.scd");
)

// END
FileSystemProject.load("capsule/fxheavy.scd");

FileSystemProject(\simpleProject).mainTimeline
WindowDef(\Mai)
ParamProto.init(true)


ExpandView
