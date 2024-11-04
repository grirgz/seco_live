
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
