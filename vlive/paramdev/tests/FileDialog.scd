
ParamProto.init
WindowDef(\filedialog).front(nil,{ arg ...args; args.debug("args") })
WindowDef(\filedialog_sample).front(nil,{ arg ...args; args.debug("args") })
SoundFile("/home/ggz/Musique/sc/reckit/smp/loureed.flac").info.numChannels
3.numChannels

PlayerWrapperView
PlayerWrapper
~m = (bla:true)
~m
(
WindowDef(\win, { arg def;
	Param(~m, \bla, ParamBoolSpec()).asCheckBox
	
}).front;
)

NoteTimeline(\bla).edit
