TrackDef('hey').childAt(3).trackTemplate = TrackTemplateDef('PdefCodeFileTrack');
TrackDef('hey').childAt(3).label = 'PdefCodeFileTrack';



TrackDef('hey').childAt(3).isMixerEnabled = true;
TrackMixerDef('hey.3').outBus = 0;

TrackMixerDef('hey.3').setVal('inbus', BusDef('trackMixerDef_hey.3'));
TrackMixerDef('hey.3').setVal('sendbus0', BusDef('sendbus0'));
TrackMixerDef('hey.3').setVal('sendbus1', BusDef('sendbus1'));
TrackMixerDef('hey.3').setVal('sendbus2', BusDef('sendbus2'));
TrackMixerDef('hey.3').setVal('sendbus3', BusDef('sendbus3'));
TrackMixerDef('hey.3').setVal('sendbus4', BusDef('sendbus4'));
TrackMixerDef('hey.3').setVal('sendbus5', BusDef('sendbus5'));
TrackMixerDef('hey.3').setVal('sendbus6', BusDef('sendbus6'));
TrackMixerDef('hey.3').setVal('sendbus7', BusDef('sendbus7'));
TrackMixerDef('hey.3').setVal('postfader', 0.0);



