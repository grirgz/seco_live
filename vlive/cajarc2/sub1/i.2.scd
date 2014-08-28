
~timeline_do.(4);

// END

Veco.do { arg name, namex, index;
	Veco(name).lib.reset_tracks;
	~spawn_cliprow.(index);
	Tdef(name, {
		Veco.main.clip.update_display;
		4.wait;
		//(4-0.5).wait;
		~spawnclip.(name, index+1);
		0.wait;
	});
};
