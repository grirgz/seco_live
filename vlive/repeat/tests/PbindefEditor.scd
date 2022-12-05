

PlayerWrapper(Pbindef(\tapme)).edit
WindowDef(\PbindefEditor).front(Pbindef(\tapme))
FileSystemProject.load("libdef/PbindefEditor.scd")


Pbindef(\bla, \instrument, \default)
Pbindef(\bla).edit
FileSystemProject.load("lib/synth.scd")

Pbindef(\tapme).presetCompileString
Pbindef(\tapme).asParamGroup.presetCompileString
Pbindef(\tapme).set(\rq, 1)
PlayerWrapper(Pbindef(\tapme)).getPbindCompileString
Pbindef(\tapme).getPbindCompileString
