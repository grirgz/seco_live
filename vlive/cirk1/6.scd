~name = \6;

Veco(~name).add_stop_node_hook(\macro, { 
	//topEnvironment[\tpercs].debug("add_stop_node_hook: tpercs");
	topEnvironment[\tpercs].do { arg track;
		Veco(track).stop_node;
	
	};
});

////////////////////////////////////////////////
~tpercs = ['a', 'z', 'e'];

Pdef(~name, 
	Pbind(
		\go, Pfunc{ arg ev; 
			ev.postln; ev[\track].do{ arg tr, x;
				var clip = ev[\clip];
				if(clip.class == Array) {
					clip = clip[x]
				};
				if(clip.isNil or: {clip.class == Symbol}) {

				} {
					Veco(tr).get_clip_by_index(clip).response_on;
				}
			}; 
			1;
		},
	) <>
	Pdef(~name+++\pre) <> Pbind(
	\isRest, true,
	\bla, Pfunc{ "kjkj".postln; },
	\track, ~tpercs,
	\dur, 4,
));
