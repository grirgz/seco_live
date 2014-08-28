
(
	Veco.do { arg name, namex, index;
		Veco(name).lib.reset_tracks;
		~spawn_cliprow.(index,name);
		Tdef(name, {
			Veco.main.clip.update_display;
			{
				8.wait;
				~spawnclip.(9, \r);
				[17,18,19].do { arg idx;
					Pdef(Veco.main.get_node_by_index(idx).uname).player.xstop(8)
				};
				~spawnclip.(0, index+1);
			}.fork;
			(16-0.12).wait;
			~spawnclip.(name, index+1);
			0.wait;
		});
	};
);

