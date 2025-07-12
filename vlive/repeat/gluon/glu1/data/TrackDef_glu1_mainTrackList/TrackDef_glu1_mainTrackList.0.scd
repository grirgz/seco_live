TrackDef('glu1_mainTrackList').childAt(0).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('glu1_mainTrackList').childAt(0).label = "base melo";



TrackDef('glu1_mainTrackList').childAt(0).isMixerEnabled = true;
TrackMixerDef('glu1_mainTrackList.0').outBus = 0;
TrackMixerDef('glu1_mainTrackList.0').insertFxAt(0).synthName = 'ifx_chorus';
TrackMixerDef('glu1_mainTrackList.0').insertFxAt(0).enabled = true;

TrackMixerDef('glu1_mainTrackList.0').insertFxAt(1).synthName = 'ifx_freeverb2';
TrackMixerDef('glu1_mainTrackList.0').insertFxAt(1).enabled = true;

TrackMixerDef('glu1_mainTrackList.0').insertFxAt(2).synthName = nil;

TrackMixerDef('glu1_mainTrackList.0').insertFxAt(3).synthName = nil;

TrackMixerDef('glu1_mainTrackList.0').setVal('inbus', BusDef('trackMixerDef_glu1_mainTrackList.0'));
TrackMixerDef('glu1_mainTrackList.0').setVal('sendbus0', BusDef('sendbus0'));
TrackMixerDef('glu1_mainTrackList.0').setVal('sendbus1', BusDef('sendbus1'));
TrackMixerDef('glu1_mainTrackList.0').setVal('sendbus2', BusDef('sendbus2'));
TrackMixerDef('glu1_mainTrackList.0').setVal('sendbus3', BusDef('sendbus3'));
TrackMixerDef('glu1_mainTrackList.0').setVal('sendbus4', BusDef('sendbus4'));
TrackMixerDef('glu1_mainTrackList.0').setVal('sendbus5', BusDef('sendbus5'));
TrackMixerDef('glu1_mainTrackList.0').setVal('sendbus6', BusDef('sendbus6'));
TrackMixerDef('glu1_mainTrackList.0').setVal('sendbus7', BusDef('sendbus7'));
TrackMixerDef('glu1_mainTrackList.0').setVal('delay3000', 0.090666491134128);
TrackMixerDef('glu1_mainTrackList.0').setVal('diff3000', 0.13835180843885);
TrackMixerDef('glu1_mainTrackList.0').setVal('modfreq3000', 0.1);
TrackMixerDef('glu1_mainTrackList.0').setVal('modamp3000', 0.10670799703869);
TrackMixerDef('glu1_mainTrackList.0').setVal('hpf3000', 326.43442571265);
TrackMixerDef('glu1_mainTrackList.0').setVal('mix3000', 0.25);
TrackMixerDef('glu1_mainTrackList.0').setVal('wet3000', 1.0);
TrackMixerDef('glu1_mainTrackList.0').setVal('room3001', 0.34667276295977);
TrackMixerDef('glu1_mainTrackList.0').setVal('wet3001', 1.0);
TrackMixerDef('glu1_mainTrackList.0').setVal('gain3001', 0.62962962962963);
TrackMixerDef('glu1_mainTrackList.0').setVal('decay3000', 0.44517448547965);



TrackDef('glu1_mainTrackList').childAt(0).source = Pdef('glu1_mainTrackList.0.instr');
Pbindef('glu1_mainTrackList.0.instr',
	'instrument', 'sh101am',
	'envamt', 2.9317423132369,
	'adsr', [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000298023, 0.10000000298023, 0.8000000089407 ], [ 0.0, -4.0, -4.0 ], 2.0) ],
	'lpadsr', [ Env([ 0.0, 1.0, 0.84242424391436, 0.0 ], [ 0.0099999997268377, 0.41872621250308, 0.78127380542795 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
	'lpf', 355.12173525914,
);

