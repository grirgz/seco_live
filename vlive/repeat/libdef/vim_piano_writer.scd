
(
~start_vim_writer = {

	MIDIdef.noteOn(\vim_writer, { arg velocity, noteNum, channel, deviceId;
		var note;
		[ velocity, noteNum, channel, deviceId ].debug;
		note = noteNum - 60 + ( ~vim_writer_transpose ? 0 );
		note.debug("vim writer note");
		"%, ".format(note).editorInsert(false);

	});
}
);
