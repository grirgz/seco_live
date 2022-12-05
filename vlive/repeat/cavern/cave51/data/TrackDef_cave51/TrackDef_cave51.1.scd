TrackDef('cave51').childAt(1).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('cave51').childAt(1).label = 'NoteTimelineTrack';


TrackDef('cave51').childAt(1).source = Pdef('NoteTimelineTrack.1.instr');
Pdef('NoteTimelineTrack.1.instr').setVal('out', BusDef('sendbus1'));
Pdef('NoteTimelineTrack.1.instr').setVal('env1', Env([ 0.1, 3.2757884532109, 0.11049395562977, 0.1 ], [ 0.35649024578396, 0.65100278765181, 0.86250697878318 ], [ 0.0, 0.0, 0.0 ]));
Pdef('NoteTimelineTrack.1.instr').setVal('env2', Env([ 2.4709112279856, 0.30348892740949, 0.92105529060162 ], [ 0.57353758811951, 0.33203345537186 ], [ 0.0, 0.0 ]));
Pdef('NoteTimelineTrack.1.instr').setVal('env3', Env([ 3.1622776601684, 0.34333201192545, 0.78137088319053 ], [ 0.3228412270546, 0.5437325835228 ], [ 0.0, 0.0 ]));
Pdef('NoteTimelineTrack.1.instr').setVal('lpf', 568.99916400934);
Pdef('NoteTimelineTrack.1.instr').setVal('rq2', 2.7129499675592);
Pdef('NoteTimelineTrack.1.instr').setVal('bpf3', 3087.7906902725);
Pdef('NoteTimelineTrack.1.instr').setVal('rq3', 0.39356237339846);
Pdef('NoteTimelineTrack.1.instr').setVal('fmfac4', 0.50489126433682);
Pdef('NoteTimelineTrack.1.instr').setVal('hpf4', 50.653229585728);
Pdef('NoteTimelineTrack.1.instr').setVal('hpf4env', Env([ 0.1, 17.782794100389, 0.1 ], [ 0.4203342795372, 0.54902505193912 ], [ 4.6, -0.5 ]));
Pdef('NoteTimelineTrack.1.instr').setVal('rq4', 0.39356237339846);
Pdef('NoteTimelineTrack.1.instr').setVal('sig4ampenv', Env([ 0.1, 3.1622776601684, 0.1 ], [ 0.80167134512781, 0.29832865636231 ], [ -8.9, -4.8 ]));
