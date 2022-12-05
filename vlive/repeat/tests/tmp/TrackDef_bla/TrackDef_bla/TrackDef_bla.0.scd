TrackDef('bla').childAt(0).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('bla').childAt(0).label = 'NoteTimelineTrack';


TrackDef('bla').childAt(0).source = Pdef('NoteTimelineTrack.0.instr');
TrackDef('bla').childAt(0).playerSynthDef = 'fmbass';
Pdef('NoteTimelineTrack.0.instr').setVal('adsr', Env([ 0.0, 0.97080290317535, 0.63503649635036, 0.0 ], [ 0.029205128550529, 0.082051279605963, 0.10743590944853 ], [ -1.0, -1.0, -1.0 ], 2.0));
