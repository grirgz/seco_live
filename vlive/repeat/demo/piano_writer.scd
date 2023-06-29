
(
MIDIdef.noteOn(\vim_writer, { arg velocity, noteNum, channel, deviceId;
	var note;
	[ velocity, noteNum, channel, deviceId ].debug;
	note = noteNum - 60;
	note.debug("note");
	"%, ".format(note).editorInsert(false);
	
});
)
