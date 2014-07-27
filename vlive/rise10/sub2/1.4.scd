Veco.do { arg name, namex, index;
	~spawn_cliprow.(index);
	Tdef(name, {
		Veco.main.clip.update_display;
		{
			Veco(name).lib.tracks.do { arg tr;
				Ndef(Veco(tr).uname+++\mixer).set(\amp, 0);
				Ndef(Veco(tr).uname+++\mixer).set(\send1, 1);
			};
			8.wait;
			Veco(name).lib.tracks.do { arg tr;
				Ndef(Veco(tr).uname+++\mixer).set(\amp, 1);
				Ndef(Veco(tr).uname+++\mixer).set(\send1, 0.51);
			};
		}.fork;
		16.wait;
		~spawnclip.('1', index+1);
		0.wait;
	});
};
