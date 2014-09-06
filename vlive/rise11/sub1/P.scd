~name = 'sub1-P';

~tdef_channel.();

Veco(~name).lib.tracks = (0..30);
Tdef(~name).quant = Pdef.defaultQuant;
//Tdef(~name).quant = [1/2,0]

(
Veco.do { arg name;
	Veco(name).lib[\reset_tracks] = {
		//Ndef(~tfx1).put(60, nil);
		//Veco(name).lib.tracks.do { arg tr;
		//	Ndef(Veco(tr).uname+++\mixer).set(\amp, 1);
		//	Ndef(Veco(tr).uname+++\mixer).set(\send1, 0);
		//};
		//Veco(~tnfx1).play_node;
	};
	Veco(name).lib.reset_tracks;
};
);

(
~timeline_do = { arg time, quantnow_fun, after_fun;
	Veco.do { arg name, namex, index;
		Veco(name).lib.reset_tracks;
		~spawn_cliprow.(index, name);
		Tdef(name, {
			Veco.main.clip.update_display;
			quantnow_fun.(name, namex, index);
			(time-0.12).wait;
			after_fun.(name, namex, index);
			~spawnclip.(name, index+1);
			0.wait;
		});
	};
};
);

// END

Pdef.defaultQuant
[Pdef.defaultQuant, 0-Pdef.defaultQuant/4]
Tdef(~name).quant


