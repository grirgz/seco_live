
:w
gtgt
FileSystemProject.load("")
ParamProto.init(true)
TrackDef(\ar, \AutomationRack).edit

(
Pdef(\aaa, 
	Pbind(
		\instrument, \sh101,
	)
);
);
Pdef(\aaa).edit
Pdef(\aaa).asStream.next.asCompileString
Pdef(\aaa).get(\freq).asCompileString
Pdef(\aaa).set(\freq, Param(Pdef(\aaa), \freq).getCombinator.asMap)
Pdef(\aaa).set(\freq, Param(Pdef(\aaa), \freq).getCombinator.get)
Param(Pdef(\aaa), \freq).getCombinator.asMap
Param(Pdef(\aaa), \freq).get

~s = \amp.asSpec
~s.default = 1
WindowDef(\ParamSpecEditor).front(~s)
Param(Message(~s), \default).edit
Param(Message(~s), \minval).edit
Param.trace = true
