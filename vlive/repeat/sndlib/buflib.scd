
(
~buflib = (
	kick: {
		"/home/ggz/Musique/sc/samplekit/com/Kick/*".pathMatch.collect({ arg path;
			{ BufDef.stereo(path); }
		})
	}.value,

	snare: {
		"/home/ggz/Musique/sc/samplekit/com/Snare/*".pathMatch.collect({ arg path;
			{ BufDef.stereo(path); }
		})
	}.value,

	hat: {
		"/home/ggz/Musique/sc/samplekit/com/HiHat/*".pathMatch.collect({ arg path;
			{ BufDef.stereo(path); }
		})
	}.value,

	drum: {
		"/home/ggz/Musique/sc/samplekit/com/Hand Drum/*".pathMatch.collect({ arg path;
			{ BufDef.stereo(path); }
		})
	}.value,

	clap: {
		"/home/ggz/Musique/sc/samplekit/com/Clap/*".pathMatch.collect({ arg path;
			{ BufDef.stereo(path); }
		})
	}.value,
);


);
