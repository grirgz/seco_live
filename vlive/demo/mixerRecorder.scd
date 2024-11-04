
(
ClipTimeline(\mixerRecorder).tracks = ProtoDef(\simpleMixer).tracks.collect({ arg track, idx;
	(
		index: idx,
		recordArmed: true,
		recordBus: track.inbus,
		muted: false,
	)
});
)
(
ClipTimeline(\mixerRecorder).tracks = 
ProtoDef(\simpleMixer).tracks.collect({ arg track, idx;
	(
		index: idx,
		recordArmed: true,
		recordBus: track.recbus,
		muted: false,
	)
}) ++ 
ProtoDef(\fxMixer).tracks.collect({ arg track, idx;
	(
		index: idx,
		recordArmed: true,
		recordBus: track.recbus,
		muted: false,
	)
});
)
ClipTimeline(\mixerRecorder).edit
ClipTimeline(\mixerRecorder).refresh
(
	~delete_blank = { arg timeline;

		var todelete = List.new;
		timeline.eventList.copy.do { arg event, idx;
			event.timeline !? { arg tl; tl.buffer !?  { arg buf;
				buf.loadToFloatArray(action: { arg col;
					if(col.every( _ == 0 )) {
						Log(\Param).debug("event to remove %", event);
						//todelete.add(event);
						timeline.eventList.remove(event);
						Log(\Param).debug("removed event %", event);
					}
				}).debug("bla");
			} }
		};
	};

	~delete_blank.(ClipTimeline(\mixerRecorder));
)
ProtoDef(\simpleMixer).tracks;

ClipTimeline(\mixerRecorder).eventList[2].timeline.buffer

ClipTimeline(\mixerRecorder).eventList[0].timeline !? { _.buffer }
