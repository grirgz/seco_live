
(
	Veco.do { arg name, namex, index;
		Veco(name).lib.reset_tracks;
		(16..24).do { arg idx;
			Ndef(Veco.main.get_node_by_index(idx).uname+++\mixer).set(\amp, 0)
		};
		~spawn_cliprow.(index,name);
		Tdef(name, {
			Veco.main.clip.update_display;
			{
				[[18,19],16,21,17,20,22].do { arg idx;
					4.wait;
					if(idx.isSequenceableCollection.not) {
						idx = [idx];
					};
					idx.do { arg ii;
						Ndef(Veco.main.get_node_by_index(ii).uname+++\mixer).set(\amp, 1)
					}
				};

			}.fork;
			{
				32.wait;
				~spawnclip.(9, \r);
				~spawnclip.(6, \r);
			}.fork;
			((32+16)-0.12).wait;
			~spawnclip.(name, index+1);
			0.wait;
		});
	};
);

// END

Ndef(Veco.main.get_node_by_index(16).uname+++\mixer).set(\amp, 0)
Pdef.defaultQuant = 1
