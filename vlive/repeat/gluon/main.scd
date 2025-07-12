
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("gluon/lib.scd"); };
)

// END
ParamProto.init

TrackDef(\solo1, \TrackList).edit
TrackDef(\solo1, \TrackList).savePresetCompileStringDialog
