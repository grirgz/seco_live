
~tdef_channel.();

Veco(~name).lib.tracks = [1,2,3,4,5,6,7];
Tdef(~name).quant = Pdef.defaultQuant

(
Veco.do { arg name;
	Veco(name).lib[\reset_tracks] = {
		Ndef(~tfx1).put(60, nil);
		Veco(name).lib.tracks.do { arg tr;
			Ndef(Veco(tr).uname+++\mixer).set(\amp, 1);
			Ndef(Veco(tr).uname+++\mixer).set(\send1, 0);
		};
		Veco(~tnfx1).play_node;
	};
	Veco(name).lib.reset_tracks;
};
)

// END

~tnfx1
