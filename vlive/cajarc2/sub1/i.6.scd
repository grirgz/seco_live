
~timeline_do.(4, { { 
	TempoClock.default.beats.debug("WHATTTT");
	3.5.wait;
	TempoClock.default.beats.debug("WHATTTT 2");
	~spawnclips.([1: \rr, 2: \rr, 3:\rr, 8:\rr]);
}.fork });

// END


Veco.do { arg name, namex, index;
	Veco(name).lib.reset_tracks;
	~spawn_cliprow.(index);
	Tdef(name, {
		Veco.main.clip.update_display;
		4.wait;
		~spawnclip.(name, index+1);
		0.wait;
	});
};
