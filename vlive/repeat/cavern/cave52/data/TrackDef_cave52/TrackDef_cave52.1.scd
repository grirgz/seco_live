TrackDef('cave52').childAt(1).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('cave52').childAt(1).label = 'NoteTimelineTrack';



TrackDef('cave52').childAt(1).isMixerEnabled = true;
TrackMixerDef('cave52.1').setVal('inbus', BusDef('trackMixerDef_cave52.1'));
TrackMixerDef('cave52.1').setVal('wet1', 1.0);
TrackMixerDef('cave52.1').setVal('mute', 0);
TrackMixerDef('cave52.1').setVal('solo', 0);
TrackMixerDef('cave52.1').setVal('wet1000', 1.0);
TrackMixerDef('cave52.1').setVal('prefader', 0);
TrackMixerDef('cave52.1').setVal('wet2100', 1.0);
TrackMixerDef('cave52.1').setVal('sendbus0', BusDef('sendbus0'));
TrackMixerDef('cave52.1').setVal('send0', 0);
TrackMixerDef('cave52.1').setVal('wet2101', 1.0);
TrackMixerDef('cave52.1').setVal('sendbus1', BusDef('sendbus1'));
TrackMixerDef('cave52.1').setVal('send1', 0);
TrackMixerDef('cave52.1').setVal('wet2102', 1.0);
TrackMixerDef('cave52.1').setVal('sendbus2', BusDef('sendbus2'));
TrackMixerDef('cave52.1').setVal('send2', 0.0);
TrackMixerDef('cave52.1').setVal('wet2103', 1.0);
TrackMixerDef('cave52.1').setVal('sendbus3', BusDef('sendbus3'));
TrackMixerDef('cave52.1').setVal('send3', 0.0);
TrackMixerDef('cave52.1').setVal('wet2104', 1.0);
TrackMixerDef('cave52.1').setVal('sendbus4', BusDef('sendbus4'));
TrackMixerDef('cave52.1').setVal('send4', 0.0);
TrackMixerDef('cave52.1').setVal('wet2105', 1.0);
TrackMixerDef('cave52.1').setVal('sendbus5', BusDef('sendbus5'));
TrackMixerDef('cave52.1').setVal('send5', 0.0);
TrackMixerDef('cave52.1').setVal('wet2106', 1.0);
TrackMixerDef('cave52.1').setVal('sendbus6', BusDef('sendbus6'));
TrackMixerDef('cave52.1').setVal('send6', 0.0);
TrackMixerDef('cave52.1').setVal('wet2107', 1.0);
TrackMixerDef('cave52.1').setVal('sendbus7', BusDef('sendbus7'));
TrackMixerDef('cave52.1').setVal('send7', 0);
TrackMixerDef('cave52.1').setVal('wet3001', 1.0);
TrackMixerDef('cave52.1').setVal('postdelay', 0);
TrackMixerDef('cave52.1').setVal('wet4000', 1.0);
TrackMixerDef('cave52.1').setVal('postfader', -inf);
TrackMixerDef('cave52.1').setVal('wet5000', 1.0);
TrackMixerDef('cave52.1').setVal('recbus', BusDef('trackMixerDef_record_cave52.1'));
TrackMixerDef('cave52.1').outBus = 0;


TrackDef('cave52').childAt(1).source = Pdef('NoteTimelineTrack.1.instr');
TrackDef('cave52').childAt(1).playerSynthDef = 'freecorde';
Pdef('NoteTimelineTrack.1.instr').setVal('out', 0);
Pdef('NoteTimelineTrack.1.instr').setVal('amp', 0.014437233339343);
Pdef('NoteTimelineTrack.1.instr').setVal('adsr', Env([ 0.0, 1.0, 0.85123205184937, 0.0 ], [ 0.029776675626636, 0.17717121727765, 0.20319704655288 ], [ 1.5, -4.5, -4.0 ], 2.0));
