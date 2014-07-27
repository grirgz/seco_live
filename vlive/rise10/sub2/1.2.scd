Veco.do { arg name, namex, index;
	~spawn_cliprow.(index);
	Tdef(name, {
		Veco.main.clip.update_display;
		4.wait;
		~spawnclip.('1', index+1);
		0.wait;
	});
};

// END
		~spawnclip.('1', 1);
