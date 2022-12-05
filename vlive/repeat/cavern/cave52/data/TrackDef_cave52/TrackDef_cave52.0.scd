TrackDef('cave52').childAt(0).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('cave52').childAt(0).label = 'NoteTimelineTrack';



TrackDef('cave52').childAt(0).isMixerEnabled = true;
TrackMixerDef('cave52.0').setVal('inbus', BusDef('trackMixerDef_cave52.0'));
TrackMixerDef('cave52.0').setVal('wet1', 1.0);
TrackMixerDef('cave52.0').setVal('mute', 0);
TrackMixerDef('cave52.0').setVal('solo', 0);
TrackMixerDef('cave52.0').setVal('wet1000', 1.0);
TrackMixerDef('cave52.0').setVal('prefader', 0);
TrackMixerDef('cave52.0').setVal('wet2100', 1.0);
TrackMixerDef('cave52.0').setVal('sendbus0', BusDef('sendbus0'));
TrackMixerDef('cave52.0').setVal('send0', 0);
TrackMixerDef('cave52.0').setVal('wet2101', 1.0);
TrackMixerDef('cave52.0').setVal('sendbus1', BusDef('sendbus1'));
TrackMixerDef('cave52.0').setVal('send1', 0.0);
TrackMixerDef('cave52.0').setVal('wet2102', 1.0);
TrackMixerDef('cave52.0').setVal('sendbus2', BusDef('sendbus2'));
TrackMixerDef('cave52.0').setVal('send2', 0.0);
TrackMixerDef('cave52.0').setVal('wet2103', 1.0);
TrackMixerDef('cave52.0').setVal('sendbus3', BusDef('sendbus3'));
TrackMixerDef('cave52.0').setVal('send3', 0.0);
TrackMixerDef('cave52.0').setVal('wet2104', 1.0);
TrackMixerDef('cave52.0').setVal('sendbus4', BusDef('sendbus4'));
TrackMixerDef('cave52.0').setVal('send4', 0.0);
TrackMixerDef('cave52.0').setVal('wet2105', 1.0);
TrackMixerDef('cave52.0').setVal('sendbus5', BusDef('sendbus5'));
TrackMixerDef('cave52.0').setVal('send5', 0.0);
TrackMixerDef('cave52.0').setVal('wet2106', 1.0);
TrackMixerDef('cave52.0').setVal('sendbus6', BusDef('sendbus6'));
TrackMixerDef('cave52.0').setVal('send6', 0);
TrackMixerDef('cave52.0').setVal('wet2107', 1.0);
TrackMixerDef('cave52.0').setVal('sendbus7', BusDef('sendbus7'));
TrackMixerDef('cave52.0').setVal('send7', 0);
TrackMixerDef('cave52.0').setVal('wet3001', 1.0);
TrackMixerDef('cave52.0').setVal('postdelay', 0);
TrackMixerDef('cave52.0').setVal('wet4000', 1.0);
TrackMixerDef('cave52.0').setVal('postfader', -inf);
TrackMixerDef('cave52.0').setVal('wet5000', 1.0);
TrackMixerDef('cave52.0').setVal('recbus', BusDef('trackMixerDef_record_cave52.0'));
TrackMixerDef('cave52.0').outBus = 0;


TrackDef('cave52').childAt(0).source = Pdef('NoteTimelineTrack.0.instr');
TrackDef('cave52').childAt(0).playerSynthDef = 'somebass2';
Pdef('NoteTimelineTrack.0.instr').setVal('out', 0);
Pdef('NoteTimelineTrack.0.instr').setVal('amp', 0.093759389459768);
