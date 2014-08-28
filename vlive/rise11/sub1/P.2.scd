
	Veco.do { arg name, namex, index;
		Veco(name).lib.reset_tracks;
		~spawnclip.(0,index);
		Tdef(name, {
			Veco.main.clip.update_display;
			{
				4.wait;
				~spawnclip.(1,index);
				4.wait;
				~spawnclip.(2,index);
			}.fork;
			(16-0.12).wait;
			~spawnclip.(name, index+2);
			0.wait;
		});
	};
