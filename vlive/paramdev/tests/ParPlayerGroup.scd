(
Pdef(\bla, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,3,2,1],inf),
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);

ProtoDef(\myg, ProtoTemplateDef(\ParPlayerGroup).new([Pdef(\bla)]))
ProtoDef(\myg).childAt(0).play
ProtoDef(\myg).childAt(0).stop

~pg = PlayerWrapperGroup.new([Pdef(\bla)])
~pg.childAt(0)
~pg[0].play
~pg[0].stop
~pg[0].target

~con = SimpleController(~pg[0].target)
~con.put(\playing, { arg ... args; args.debug("con listener") })

~pg[0].makeListener({ arg ... args; args.debug("ind listener") })
~rec = ProtoTemplateDef(\PlayerGroupRecorder).new(~pg)
~rec.isRecording
~rec.startRecording
~rec.stopRecording
~pg.makeListener({ arg ...args; args.debug("group listener!!!!") })

~a = TestDependant()
Pdef(\bla).addDependant(~a)
Pdef(\bla, Pbind()).play
Pdef(\bla).play
Pdef(\bla).stop

~pg = PlayerWrapperGroup.new(TrackDef(\tlist).children)
~pg.childAt(0)
~pg[0].play
~pg[0].stop
~pg[0].target

~a = TestDependant()
TrackDef(\tlist).childAt(0).addDependant(~a)
~pg.addDependant(~a)
