TrackDef('tlist').childAt(1).instrument = ProtoTemplateDef('TrackInstrument').new([ 'TrackInstrument', ('KitTimelineTrack' -> 'KitTimelineTrack') ]);
TrackDef('tlist').childAt(1).label = "KitTimelineTrack TrackInstrument";

TrackDef('tlist').childAt(1).instrument.source = PatKitDef('tlist.1');
