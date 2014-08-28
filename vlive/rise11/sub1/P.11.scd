
(
	Veco.do { arg name, namex, index;
		Veco(name).lib.reset_tracks;
		~spawn_cliprow.(index,name, [0,5]);
		Tdef(name, {
			Veco.main.clip.update_display;
			{
				4.wait;
				~spawnclip.(2, index);
				4.wait;
				~spawnclip.(1, index);
			}.fork;
			(16-0.12).wait;
			~spawnclip.(name, index+1);
			0.wait;
		});
	};
);

