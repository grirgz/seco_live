
(
	Veco.do { arg name, namex, index;
		Veco(name).lib.reset_tracks;
		~spawn_cliprow.(index,name);
		Tdef(name, {
			Veco.main.clip.update_display;
			{
				0.5.wait;
				Ndef(Veco(5).uname+++\fx).stop(fadeTime:8);
			}.fork;
			(16-0.12).wait;
			~spawnclip.(name, index+1);
			0.wait;
		});
	};
);

// END

Veco(Point(0,1))
Veco(0)
Veco.main.get_node_by_uname(0)

				Ndef(Veco(5).uname+++\fx).stop(fadeTime:8);
				Veco(6).stop_node(true);

