TrackDef('cave51').childAt(0).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('cave51').childAt(0).label = 'NoteTimelineTrack';


TrackDef('cave51').childAt(0).source = Pdef('NoteTimelineTrack.0.instr');
Pdef('NoteTimelineTrack.0.instr').setVal('out', BusDef('sendbus2'));
Pdef('NoteTimelineTrack.0.instr').setVal('amp', 0.021891920033319);
Pdef('NoteTimelineTrack.0.instr').setVal('fmr', 1.0016238152164);
Pdef('NoteTimelineTrack.0.instr').setVal('fmamp', 0.88432621454712);
Pdef('NoteTimelineTrack.0.instr').setVal('amr', 1.0016238152164);
Pdef('NoteTimelineTrack.0.instr').setVal('amamp', 0.83093380504949);
Pdef('NoteTimelineTrack.0.instr').setVal('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.010000000253555, 0.10000000046801, 0.15873684169035 ], [ -4.0, -4.0, -4.0 ], 2.0));
