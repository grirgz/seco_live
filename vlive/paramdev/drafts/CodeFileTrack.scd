
FileSystemProject.load("~/code/sc/seco/vlive/repeat/libdef/CodeFileTrack.scd");
TrackDef(\myseq).clear;
TrackDef(\myseq).clearTrack;
TrackDef(\myseq, TrackTemplateDef(\CodeFileGrid))
TrackDef(\myseq).edit
TrackDef(\myseq).initTrack

TrackDef('myseq.0').play
TrackDef('myseq.0').codeFileName
TrackDef('myseq.0').proxy
TrackDef('myseq').childAt(0).initTrack
TrackDef('myseq').childAt(0).play
TrackDef('myseq').childAt(0).proxy
TrackDef('myseq').childAt(0).executeCodeFile
TrackDef('myseq').childAt(0).quant

TrackDef(\myseq).childAt(0).isPlaying
TrackDef(\myseq).childAt(0).play
TrackDef(\myseq).childAt(0,0).codeFileName
TrackDef(\myseq).childAt(0).proxy = Pdef('myseq.0')
TrackDef(\myseq).childAt(0,0).isPlaying
TrackDef(\myseq).childAt(0,0).play
TrackDef(\myseq).childAt(0,0).proxy.target[\isPlaying].asCompileString
TrackDef(\myseq).childAt(0,0)[\play].asCompileString
TrackDef(\myseq).childAt(0)[\play].asCompileString


/////////////////////////////

TrackTemplateDef(\CodeFileTrackPart)[\play].asCompileString


TrackDef(\myctl, TrackTemplateDef(\CustomTrackList))
TrackDef(\myctl).edit


TrackDef(\bla, TrackTemplateDef(\CustomInstrumentTrack))
TrackDef(\bla).presetCompileStringSavePath = "~/code/sc/seco/vlive/repeat/tests/tmp/cfile/".standardizePath;
TrackDef(\bla).trackTemplate = TrackTemplateDef(\CodeFileTrack);
TrackDef(\bla).elAt(0).play
TrackDef(\bla).elAt(1).play
TrackDef(\bla).elAt(1).stop
TrackDef(\bla).play
TrackDef(\bla).stop

TrackDef(\myseq).clear;
TrackDef(\myseq, TrackTemplateDef(\CustomTrackList))
TrackDef(\myseq).edit
TrackDef(\myseq).isActive
TrackDef(\myseq).childAt(0).presetCompileStringSavePath = "~/code/sc/seco/vlive/repeat/tests/tmp/cfile/".standardizePath;
TrackDef(\myseq).childAt(0).presetCompileStringSavePath
TrackDef(\myseq).childAt(0).loadPresetCompileString
TrackDef(\myseq).childAt(0).proxy
TrackDef(\myseq).childAt(0).makeScore
TrackDef(\myseq).childAt(0).codeFilePrefix = "bla"




TrackDef(\bla).clear
TrackDef(\bla, TrackTemplateDef(\CodeFileTrack))
TrackDef(\bla).makeScore
TrackDef(\bla).initTrack
TrackDef(\bla).trackKey
TrackDef(\bla).presetCompileStringSavePath
TrackDef(\bla).proxy
TrackDef(\bla).refCompileString
TrackDef(\bla).presetCompileStringSavePath = "~/code/sc/seco/vlive/paramdev/tests/tmp/cfile/".standardizePath;
TrackDef(\bla).presetCompileStringSavePath
TrackDef(\bla).loadPresetCompileString
TrackDef(\bla).proxy.play
TrackDef(\bla).activeIndex
TrackDef(\bla).play
TrackDef(\bla).proxy.isPlaying = true
TrackDef(\bla).elAt(1)[\refCompileString].asCompileString
TrackDef(\bla).elAt(1).makeScore
TrackDef(\bla).elAt(1).play
TrackDef(\bla).elAt(1).proxy
TrackDef(\bla).elAt(1).parentTrack.activeIndex
TrackDef(\bla).elAt(1).parentTrack.activeChild
TrackDef(\bla).elAt(1).index
TrackDef(\bla).elAt(1)[\play].asCompileString
TrackDef(\bla).elAt(1)[\play] = nil
TrackDef(\bla).elAt(1).isEmpty
TrackDef(\bla).elAt(2).isEmpty
TrackDef(\bla).elAt(1).proxy.isPlaying = true
TrackDef(\bla).elAt(1).proxy.play
TrackDef(\bla).elAt(0).proxy.play
TrackDef(\bla).elAt(0).makeScore
TrackDef(\bla).elAt(1).makeScore
TrackDef(\bla).elAt(0).play
TrackDef(\bla).elAt(1).play
TrackDef(\bla).elAt(1).stop
TrackDef(\bla).elAt(1).stopInternal
TrackDef(\bla).elAt(0).presetCompileStringSavePath
TrackDef(\bla).elAt(1).proxy.target[\isPlaying_].asCompileString
TrackDef(\bla).elAt(1).proxy.target.isPlaying = true
TrackDef(\bla).elAt(1).proxy.target.trackPart.parentTrack.proxy.play
TrackDef(\bla).elAt(1).presetCompileStringSavePath
TrackDef(\bla).elAt(1).loadPresetCompileString
Tr
TrackTemplateDef(\CodeFileTrackPart)
(
Pdef(\bla_base, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);
TrackDef(\bla).presetCompileStringSavePath = "/tmp/bla/"
TrackDef(\bla).presetCompileStringSavePath
TrackDef(\bla).savePresetCompileString


(
~bla = ProtoClass((
	isPlaying_: { arg self, val;
		Log(\Param).debug("sdkfjsdkfjskdfj %", val);
		
	},
))
)
~bla.isPlaying = 4

(
Pdef(\zed, 
    Pbind(
        \instrument, \default,
        \degree, Prout({ arg ev;
            Pseq([3,2,6,1,1,8]).do { arg x;
                Pser([2,5,1,6,4,2,2,0],x).embedInStream;
            };
        }).repeat(2),
        \dur, 1/8,
        \amp, 0.1,
    ).trace
).play;
);

(
Pdef(\bla_post, 
	Pbind(
		\degree, Pseq([6,2,1,0],inf),
		\dur, 1/6,
	)
);
)

(
Pdef(\bla_post, 
	Pbind(
		\degree, Pseq([2,3,5,0],inf),
	)
);
)

////////////

ProtoDef(\bla, (new: { "hello" }))
ProtoDef(\bla).new


TrackDef(\orig, \playergrid)
TrackDef(\orig).childAt(0).childProxy.source.bla
TrackDef(\orig).childAt(0).childAt(0).asPattern
nil.source

(
    Pspawner({| sp |

        a = sp.par(
            Pdef(\p1,
                Pbind(\dur, 1)
            )
        );

        sp.wait(4);
        
        //Pbindef(\p1).quant = 0.0;
        Pbindef(\p1, \dur, 0.5);
        
        sp.wait(4);
        sp.suspend(a);

    }).play(t);
)

Pdef(\p1).quant = 4

///////////////// utils

(
~color_test = { arg offset=0;
	var count = 0 + offset;
	8.do { arg ix;
		5.do { arg iy, idx;
			var cur = count;
			[ count, Point(ix, iy) ].debug("color");
			ProtoDef(\apc40).ktl.elAt(\bt, \clip, iy, ix,\on).value = count/127;
			ProtoDef(\apc40).ktl.elAt(\bt, \clip, iy, ix,\on).action = { cur.debug("color") };
			//ProtoDef(\apc40).ktl.elAt(\bt, \clip, iy, ix,\on).value = 59/127;
			count = count + 1;
		};
	};
};
~color_test.(40*0);
)


/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////// demo test
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////


(
FileSystemProject.load("libdef/CodeFileTrack.scd");
TrackDef(\codedemo, \CodeFileGrid).presetCompileStringSavePath = "~/code/sc/seco/vlive/paramdev/tests/codedemo/".standardizePath;
TrackDef(\codedemo).initTrack;
TrackDef(\codedemo).edit;
ProtoDef(\apc40).startControl(TrackDef(\codedemo));
)
TrackDef(\codedemo).savePresetCompileString
TrackDef(\codedemo).presetCompileStringSavePath
TrackDef(\codedemo).dataPath
TrackDef(\codedemo).loadedFromPath
TrackDef(\codedemo).loadedFromPath = TrackDef(\codedemo).presetCompileStringSavePath
TrackDef(\codedemo).codeFilePath
{ SinOsc.ar(500) ! 2 * 0.1}.play;
TrackDef(\codedemo).elAt(0).initTrack
TrackDef(\codedemo).elAt(0).trackTemplate
TrackDef(\codedemo).elAt(0).trackTemplate
TrackDef(\codedemo).elAt(0).isEmpty
TrackDef(\codedemo).elAt(0).play
TrackDef(\codedemo).elAt(0)[\play].asCompileString
TrackDef(\codedemo).elAt(0,0)[\play].asCompileString
TrackDef(\codedemo).elAt(0,1).isrest.asStream.nextN(10)
TrackDef(\codedemo).elAt(0,1).data
TrackDef(\codedemo).gridOffset = Point(0,0)
TrackDef(\codedemo).gridOffset
Pdef('codedemo.0pre').source
Pdef('codedemo.0pre').asStream.nextN(5,())
(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0],inf),
		\isRest, TrackDef(\codedemo).elAt(0,1).isrest,
		\dur, 1/8,
		\amp, 0.1,
	)
).play;
);
TrackDef(\codedemo).elAt(0,1).data.stepSeq = nil
TrackDef(\codedemo).elAt(0).mixer.play
TrackDef(\codedemo).elAt(0).outBus
TrackDef(\codedemo).elAt(7,0)
TrackDef(\codedemo).startControl
TrackDef(\codedemo).childAtOffset(0)
ProtoDef(\apc40).layerTemplate
ProtoDef(\apc40).ktl.gui
ProtoDef(\apc40).layerName
ProtoDef(\apc40).displayMode
ProtoDef(\apc40)[\displayMode]
ProtoDef(\apc40).displayMode_apc40_layer_main
ProtoDef(\apc40).keys
k
~name
TrackDef(~name).isEmpty
TrackDef(~name).play
TrackDef(~name).source
TrackDef(~name).source
TrackDef(~name).trackTemplate
TrackDef(~name).elAt(0)
TrackDef(~name).elAt(7)
~name
~currentTrack.initTrack
~currentTrack.elAt()

///// test copy

~g = TrackDef(\codedemo);
~tsrc = ~g.elAt(2);
~tsrc.cloneHeader(~tsrc.parentTrack, 5);
~g.elAt(4).proxy
~g.elAt(4).
~g.elAt(4).codeFileName
~currentPart.isrest.asStream.nextN(10)
~currentPart.data

~tsrc.clone(~tsrc.parentTrack, 4);

~tsrc.cloneHeader(~tsrc.parentTrack, 5);
~psrc = ~tsrc.elAt(1)
~tdst = ~g.elAt(5);
~psrc.clone(~tdst,0)
~tdst.elAt(0).data
~psrc.score

~tsrc.cloneHeader(~g, 10);
~psrc.clone(~g.elAt(10), 0)

~g.sectionAt(0).clone(~g, 4)
~g.sectionAt(0)[\clone].asCompileString
~g.se

///// BUGS
// - need to call initTrack to be able to do TrackDef(~name) but not called on creation

~a = (ho:4);
~a.hook = { arg self; self.ho.debug("1") }
~a.hook.value(~a)
~a.hook = ~a[\hook].addFunc({  arg self; self.ho.debug("2")  })
