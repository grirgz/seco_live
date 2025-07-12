TrackDef('solo1').childAt(4).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('solo1').childAt(4).label = 'NoteTimelineTrack';



TrackDef('solo1').childAt(4).isMixerEnabled = true;
TrackMixerDef('solo1.4').outBus = 0;
TrackMixerDef('solo1.4').insertFxAt(0).synthName = 'ifx_rhpf';
TrackMixerDef('solo1.4').insertFxAt(0).enabled = true;

TrackMixerDef('solo1.4').insertFxAt(1).synthName = nil;

TrackMixerDef('solo1.4').insertFxAt(2).synthName = nil;

TrackMixerDef('solo1.4').insertFxAt(3).synthName = nil;

TrackMixerDef('solo1.4').setVal('inbus', BusDef('trackMixerDef_solo1.4'));
TrackMixerDef('solo1.4').setVal('sendbus0', BusDef('sendbus0'));
TrackMixerDef('solo1.4').setVal('sendbus1', BusDef('sendbus1'));
TrackMixerDef('solo1.4').setVal('sendbus2', BusDef('sendbus2'));
TrackMixerDef('solo1.4').setVal('sendbus3', BusDef('sendbus3'));
TrackMixerDef('solo1.4').setVal('sendbus4', BusDef('sendbus4'));
TrackMixerDef('solo1.4').setVal('sendbus5', BusDef('sendbus5'));
TrackMixerDef('solo1.4').setVal('sendbus6', BusDef('sendbus6'));
TrackMixerDef('solo1.4').setVal('sendbus7', BusDef('sendbus7'));
TrackMixerDef('solo1.4').setVal('hpf3000', 3623.2183884008);
TrackMixerDef('solo1.4').setVal('gain3000', 3);
TrackMixerDef('solo1.4').setVal('wet3000', 1.0);



TrackDef('solo1').childAt(4).source = Pdef('solo1.4.instr');
Pbindef('solo1.4.instr',
	'instrument', 'basspad',
	'lpf', 'c2',
	'lpenvamt', 'c3',
	'lpenv', [ Env([ 0.0, 1.0, 0.30000002250432, 0.0 ], [ 0.21608145808261, 0.79391849769764, 1.0 ], [ -3.6, 3.0, -6.4 ], 2.0) ],
	'adsr', [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.050000002235174, 0.57591291332115, 0.64543541886561 ], [ -3.0, -3.0, 0.3 ], 2.0) ],
	'rq', 'c4',
);

