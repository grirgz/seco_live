



~c = TempoClock.default
~c.beats % 4
~c.tempo = 1/2
~c.beatsPerBar

(
w = Window.new.front;
w.view.background_(Color.white);
w.drawFunc = {
    Pen.translate(100, 100);
    10.do{
        // set the Color
        Pen.color = Color.blue(rrand(0.0, 1), rrand(0.0, 0.5));
        Pen.addWedge((100.rand)@(100.rand), rrand(10, 100), 2pi.rand, 2pi.rand);
        Pen.perform([\stroke, \fill].choose);
    }
};
w.refresh;
)

/////////:

ClipTimeline(\bla2).edit
ClipTimeline(\bla4).edit
ClipTimeline(\bla1).clipList.clipList
ClipTimeline(\bla4).clipList.clipList
ClipTimeline(\bla4).clipList.clipIdToTarget(ClipTimeline(\bla4).clipList.brushClipId)
Ndef(\terer)
ProtoDef(\GlobalLibrary).clipFactories
ProtoDef(\GlobalLibrary).init_default_clip_factories
ParamProto.init(true)
Pbindef(\fdf).source
Pbindef(\fdf).set(\freq, nil)
FileSystemProject.load("libdef/PbindefEditor.scd")
FileSystemProject.load("capsule/PatKitDef_comkit.scd");
FileSystemProject.load("holis/synthdef.scd");
FileSystemProject.load("libdef/ModulatorRack.scd");
