
(
~buflib_paths = (
	kick: "/home/ggz/Musique/sc/samplekit/com/Kick/",
	snare: "/home/ggz/Musique/sc/samplekit/com/Snare/",
	hat: "/home/ggz/Musique/sc/samplekit/com/HiHat/",
	drum: "/home/ggz/Musique/sc/samplekit/com/Hand Drum/",
	clap: "/home/ggz/Musique/sc/samplekit/com/Clap/",
	foley1: "/home/ggz/Musique/sc/samplekit/cfoley/Blastwave FX Foley Vol. 1/",
);

~buflib = ~buflib_paths.collect { arg path, idx;
	( path +/+ "*" ).pathMatch.collect { arg fpath;
		{ BufDef.stereo(path); }
	};
};

TagSpecDef(\RandomBufferLibrary, {
	~buflib_paths.keys.collect { arg key, idx;
		var path = ~buflib_paths[key] +/+ "*";
		key -> path.pathMatch
	};
});

);

// END


TagSpecDef(\RandomBufferLibrary).list
