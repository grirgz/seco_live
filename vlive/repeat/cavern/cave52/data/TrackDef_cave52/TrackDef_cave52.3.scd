TrackDef('cave52').childAt(3).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('cave52').childAt(3).label = "Bass";



TrackDef('cave52').childAt(3).isMixerEnabled = true;
TrackMixerDef('cave52.3').setVal('inbus', BusDef('trackMixerDef_cave52.3'));
TrackMixerDef('cave52.3').setVal('wet1', 1.0);
TrackMixerDef('cave52.3').setVal('mute', 0);
TrackMixerDef('cave52.3').setVal('solo', 0);
TrackMixerDef('cave52.3').setVal('wet1000', 1.0);
TrackMixerDef('cave52.3').setVal('prefader', 0);
TrackMixerDef('cave52.3').setVal('wet2100', 1.0);
TrackMixerDef('cave52.3').setVal('sendbus0', BusDef('sendbus0'));
TrackMixerDef('cave52.3').setVal('send0', 0);
TrackMixerDef('cave52.3').setVal('wet2101', 1.0);
TrackMixerDef('cave52.3').setVal('sendbus1', BusDef('sendbus1'));
TrackMixerDef('cave52.3').setVal('send1', 0);
TrackMixerDef('cave52.3').setVal('wet2102', 1.0);
TrackMixerDef('cave52.3').setVal('sendbus2', BusDef('sendbus2'));
TrackMixerDef('cave52.3').setVal('send2', 0.0);
TrackMixerDef('cave52.3').setVal('wet2103', 1.0);
TrackMixerDef('cave52.3').setVal('sendbus3', BusDef('sendbus3'));
TrackMixerDef('cave52.3').setVal('send3', 1.0);
TrackMixerDef('cave52.3').setVal('wet2104', 1.0);
TrackMixerDef('cave52.3').setVal('sendbus4', BusDef('sendbus4'));
TrackMixerDef('cave52.3').setVal('send4', 0.0);
TrackMixerDef('cave52.3').setVal('wet2105', 1.0);
TrackMixerDef('cave52.3').setVal('sendbus5', BusDef('sendbus5'));
TrackMixerDef('cave52.3').setVal('send5', 0);
TrackMixerDef('cave52.3').setVal('wet2106', 1.0);
TrackMixerDef('cave52.3').setVal('sendbus6', BusDef('sendbus6'));
TrackMixerDef('cave52.3').setVal('send6', 0);
TrackMixerDef('cave52.3').setVal('wet2107', 1.0);
TrackMixerDef('cave52.3').setVal('sendbus7', BusDef('sendbus7'));
TrackMixerDef('cave52.3').setVal('send7', 0);
TrackMixerDef('cave52.3').setVal('wet3001', 1.0);
TrackMixerDef('cave52.3').setVal('postdelay', 0);
TrackMixerDef('cave52.3').setVal('wet4000', 1.0);
TrackMixerDef('cave52.3').setVal('postfader', -inf);
TrackMixerDef('cave52.3').setVal('wet5000', 1.0);
TrackMixerDef('cave52.3').setVal('recbus', BusDef('trackMixerDef_record_cave52.3'));
TrackMixerDef('cave52.3').outBus = 0;


TrackDef('cave52').childAt(3).source = Pdef('NoteTimelineTrack.3.instr');
TrackDef('cave52').childAt(3).playerSynthDef = 'somebass2';
Pdef('NoteTimelineTrack.3.instr').setVal('env1', Env([ 1.9999999287058, 1.9999999287058, 3.4941262816476, 6.6287031618264 ], [ 0.070000000084865, 0.99999996339534, 0.46750000305474 ], [ 0.0, 0.0, 0.0 ]));
Pdef('NoteTimelineTrack.3.instr').setVal('env2', Env([ 1.0000000686224, 0.12499999942874, 6.6287023820366 ], [ 0.10000000149012, 0.82808991387654 ], [ 0.0, 0.0 ]));
Pdef('NoteTimelineTrack.3.instr').setVal('lpf', 450.15450614149);
Pdef('NoteTimelineTrack.3.instr').setVal('bpf3', 92.550651323465);
Pdef('NoteTimelineTrack.3.instr').setVal('fmfac4', 0.51775987792262);
Pdef('NoteTimelineTrack.3.instr').setVal('hpf4', 6014.0486796177);
Pdef('NoteTimelineTrack.3.instr').setVal('hpf4env', Env([ 1.0000000686224, 0.40234761186296, 3.0000002681943 ], [ 0.42303371195043, 0.47696632381236 ], [ 0.0, 0.0 ]));
