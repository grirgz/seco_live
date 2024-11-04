TrackDef('tlist').childAt(2).instrument = ProtoTemplateDef('TrackInstrument').new([ 'TrackInstrument', ('ParamTimelineTrack' -> 'ParamTimelineTrack') ]);
TrackDef('tlist').childAt(2).label = "ParamTimelineTrack TrackInstrument";

TrackDef('tlist').childAt(2).instrument.source = Param(Ndef('rdn'), 'distamp');
