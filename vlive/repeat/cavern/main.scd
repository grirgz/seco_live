
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
{arg base=400, amount=0.5; base * (SinOsc.kr(1) * amount + 1) }.plot(1);
