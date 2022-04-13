TrackDef('cave37rec').childAt(1).trackTemplate = TrackTemplateDef('NoteTimelineTrack');
TrackDef('cave37rec').childAt(1).label = 'NoteTimelineTrack';


TrackDef('cave37rec').childAt(1).source = Pdef('NoteTimelineTrack.1.instr');
Pdef('NoteTimelineTrack.1.instr').set('dur', 1.0);
Pdef('NoteTimelineTrack.1.instr').set('legato', 0.8);
Pdef('NoteTimelineTrack.1.instr').set('out', 0);
Pdef('NoteTimelineTrack.1.instr').set('amp', #{ ~db.dbamp });
Pdef('NoteTimelineTrack.1.instr').set('pan', 0.0);
Pdef('NoteTimelineTrack.1.instr').set('freq', #{
					(~midinote.value + ~ctranspose).midicps * ~harmonic;
				});
Pdef('NoteTimelineTrack.1.instr').set('fmamt', 0.11856809996019);
Pdef('NoteTimelineTrack.1.instr').set('adsr', nil);
