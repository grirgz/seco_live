TrackDef('tlist').childAt(0).instrument = ProtoTemplateDef('TrackInstrument').new([ 'TrackInstrument', ('NoteTimelineTrack' -> 'NoteTimelineTrack') ]);
TrackDef('tlist').childAt(0).label = "NoteTimelineTrack TrackInstrument";

TrackDef('tlist').childAt(0).instrument.source = Pdef('tlist.0.instr');
