

ParamProto.init(true);
(
ParamProto.init;
FileSystemProject.load("ex3/velocityview.scd");

SynthDef(\babass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = 0;
	sig = sig + SinOsc.ar(freq * [2,1,1/2]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

Pdef(\default, Pbind(
	\instrument, \babass,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, Pkeyd(\velocity, 64)/127 * 2 * 0.1
));

NoteTimeline(\bli, Param(Pdef(\default), \midinote));
);
~v = ~noteVelocityTimelinePanelView.new(NoteTimeline(\bli))
~v.velocityTimeline.param.spec
~v.velocityTimeline.gridPointToPixelPoint(Point(1,-1))
~v.param
~v.velocityTimeline.mapParam
"kjkjkk".debug

NoteTimeline(\bli).param
NoteTimeline(\bli).edit
NoteTimeline(\bli).param.target.asParamGroup
NoteTimeline(\bli).clear
NoteTimeline(\bli).eventList.print

Pdef(\default).asParamGroup.add(Param(Pdef(\xxx), \xxx))
Pdef(\default).asParamGroup.reject({ arg x; x.property == \legato })

(
Pdef(\bla,
Pbind(
	\amp, Pkeyd(\velocity, 64)/127 * 2 * 0.1
)<>NoteTimeline(\bli).asPattern
).play;
)
FileSystemProject.load("ex3/velocityview.scd");
~a = VelocityTimelineView.new
~a.view.fixedHeight = 10
~a.fixedHeight = 10

~v.velocityTimeline.nodes.do({ arg n; n.rect.height.debug("heih") })


KitTimeline(\bla, PatKitDef(\barlok1)).edit



KitTimeline(\blo).clear;
ParamProto.init(true);
KitTimeline(\blo, PatKitDef(\barlok1));
KitTimeline(\blo).edit;

FileSystemProject.load("ex3/barlokkit.scd");
PatKitDef(\barlok1).edit
PatKitDef(\barlok1).clear
(
	~set = Set.new;
	PatKitDef(\barlok1).source.reject(_.isNil).do({ arg pat; 
		pat.asParamGroup.do({ arg param;
			if(param.type == \scalar) {
				~set.add(param.property)
			}
		})
	});
	~target = Param(PatKitDef(\barlok1).source.reject(_.isNil)).first.target;	
	~group = ~set.as(List).collect({ arg key;
		Param(~target, key)
	});
	~group.size.debug("set");
	~group.do(_.postln);
)


/////////////////////
// move algo



