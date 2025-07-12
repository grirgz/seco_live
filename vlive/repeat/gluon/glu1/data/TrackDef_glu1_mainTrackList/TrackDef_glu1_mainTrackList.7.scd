TrackDef('glu1_mainTrackList').childAt(7).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('glu1_mainTrackList').childAt(7).label = 'NoteTimelineTrack';



TrackDef('glu1_mainTrackList').childAt(7).isMixerEnabled = true;
TrackMixerDef('glu1_mainTrackList.7').outBus = 0;
TrackMixerDef('glu1_mainTrackList.7').insertFxAt(0).synthName = 'ifx_greyhole';
TrackMixerDef('glu1_mainTrackList.7').insertFxAt(0).enabled = true;

TrackMixerDef('glu1_mainTrackList.7').insertFxAt(1).synthName = nil;

TrackMixerDef('glu1_mainTrackList.7').insertFxAt(2).synthName = nil;

TrackMixerDef('glu1_mainTrackList.7').insertFxAt(3).synthName = nil;

TrackMixerDef('glu1_mainTrackList.7').setVal('inbus', BusDef('trackMixerDef_glu1_mainTrackList.7'));
TrackMixerDef('glu1_mainTrackList.7').setVal('sendbus0', BusDef('sendbus0'));
TrackMixerDef('glu1_mainTrackList.7').setVal('sendbus1', BusDef('sendbus1'));
TrackMixerDef('glu1_mainTrackList.7').setVal('sendbus2', BusDef('sendbus2'));
TrackMixerDef('glu1_mainTrackList.7').setVal('sendbus3', BusDef('sendbus3'));
TrackMixerDef('glu1_mainTrackList.7').setVal('sendbus4', BusDef('sendbus4'));
TrackMixerDef('glu1_mainTrackList.7').setVal('sendbus5', BusDef('sendbus5'));
TrackMixerDef('glu1_mainTrackList.7').setVal('sendbus6', BusDef('sendbus6'));
TrackMixerDef('glu1_mainTrackList.7').setVal('sendbus7', BusDef('sendbus7'));
TrackMixerDef('glu1_mainTrackList.7').setVal('delay3000', 0.20587777568216);
TrackMixerDef('glu1_mainTrackList.7').setVal('wet3000', 0.13609467455621);
TrackMixerDef('glu1_mainTrackList.7').setVal('room3000', 1.2844350729449);



TrackDef('glu1_mainTrackList').childAt(7).source = Pdef('glu1_mainTrackList.7.instr');
Pbindef('glu1_mainTrackList.7.instr',
	'instrument', 'default',
);

