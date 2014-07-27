
Veco.do { arg name, namex, index;
	//Veco(name).lib.reset_tracks;
	~spawn_cliprow.(index);
	Tdef(name, {
		Veco.main.clip.update_display;
		Veco(~name).lib.tracks.do { arg tr;
			Ndef(Veco(tr).uname+++\mixer).set(\amp, 1);
			Ndef(Veco(tr).uname+++\mixer).set(\send1, 1);
		};
		Ndef(~tfx1).put(60, \set -> Pbind(
			\wet50, Pseq([0,1],inf),
			\dur, 1/2,
		));
		32.wait;
		Ndef(~tfx1).put(60, nil);
		~spawnclip.('1', index+1);
		0.wait;
	});
};


// END


(

			Veco(~name).lib.tracks.do { arg tr;
				Ndef(Veco(tr).uname+++\mixer).set(\amp, 0);
				Ndef(Veco(tr).uname+++\mixer).set(\send1, 1);
			};
)
		Ndef(~tfx1).put(51, \set -> Pbind(
			\wet50, Pseq([0,1],inf),
			\dur, 1/2,
		));
