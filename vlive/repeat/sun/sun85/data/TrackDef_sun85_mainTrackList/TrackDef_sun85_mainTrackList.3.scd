TrackDef('sun85_mainTrackList').childAt(3).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('sun85_mainTrackList').childAt(3).label = "bass";



TrackDef('sun85_mainTrackList').childAt(3).isMixerEnabled = true;
TrackMixerDef('sun85_mainTrackList.3').outBus = 0;
TrackMixerDef('sun85_mainTrackList.3').insertFxAt(0).synthName = 'equi';
TrackMixerDef('sun85_mainTrackList.3').insertFxAt(0).enabled = true;

TrackMixerDef('sun85_mainTrackList.3').insertFxAt(1).synthName = nil;

TrackMixerDef('sun85_mainTrackList.3').insertFxAt(2).synthName = nil;

TrackMixerDef('sun85_mainTrackList.3').insertFxAt(3).synthName = nil;

TrackMixerDef('sun85_mainTrackList.3').setVal('inbus', BusDef('trackMixerDef_sun85_mainTrackList.3'));
TrackMixerDef('sun85_mainTrackList.3').setVal('sendbus0', BusDef('sendbus0'));
TrackMixerDef('sun85_mainTrackList.3').setVal('sendbus1', BusDef('sendbus1'));
TrackMixerDef('sun85_mainTrackList.3').setVal('sendbus2', BusDef('sendbus2'));
TrackMixerDef('sun85_mainTrackList.3').setVal('sendbus3', BusDef('sendbus3'));
TrackMixerDef('sun85_mainTrackList.3').setVal('sendbus4', BusDef('sendbus4'));
TrackMixerDef('sun85_mainTrackList.3').setVal('sendbus5', BusDef('sendbus5'));
TrackMixerDef('sun85_mainTrackList.3').setVal('sendbus6', BusDef('sendbus6'));
TrackMixerDef('sun85_mainTrackList.3').setVal('sendbus7', BusDef('sendbus7'));
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000loShelfFreq', 124.0);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000loShelfRs', 1);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000loShelfGain', 0.25);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000loPeakFreq', 79.0);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000loPeakRq', 1);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000loPeakGain', 9.75);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000midPeakFreq', 1000);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000midPeakRq', 1);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000midPeakGain', 0);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000hiPeakFreq', 3633.0);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000hiPeakRq', 1);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000hiPeakGain', -5.5);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000hiShelfFreq', 6000);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000hiShelfRs', 1);
TrackMixerDef('sun85_mainTrackList.3').setVal('i3000hiShelfGain', 0);



TrackDef('sun85_mainTrackList').childAt(3).source = Pdef('sun85_mainTrackList.3.instr');
Pbindef('sun85_mainTrackList.3.instr',
	'instrument', 'warmbass',
	'lpadsr', [ Env([ 0.0, 1.0, 0.40000000596046, 0.0 ], [ 0.20567991083864, 0.60432008614272, 0.80000002663698 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
	'envamt', 4.7933991193833,
	'lpf', 20.0,
	'rq', 0.30899018635949,
);

