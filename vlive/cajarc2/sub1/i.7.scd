
~timeline_do.(8);

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
