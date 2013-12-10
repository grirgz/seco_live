
// put this in a node to launch other clips

~name = \6;

Veco(~name).lib.tracks = ['a', 'z', 'e'];

Pdef(~name, 
	~clipspawner.() <>
	Pdef(~name+++\pre) <> Pbind(
		\isRest, true,
		\track, Veco(~name).lib.tracks,
		\dur, 4,
	)
);

///////////////////////////////////////////////////// clip

Pdef(~name+++\pre, Pbind(
	\clip, Pseq([0,1,0,2],inf),
	\dur, 4,
));

////////////

Pdef(~name+++\pre, Pbind(
	\clip, Pseq([0,0,0,0] + ~index,inf), // launch line at the same level
	\dur, 4,
));

////////////

Pdef(~name+++\pre, Pbind(
	\clip, Pseq([
		[0,1,0,2],
		[0,1,\r,1], // \r like \rest stop the track
		[0,2,2,\s], // \s like \skip, do nothing
	],inf),
	\dur, 4,
));

//////////// dont use pattern nor Pdef(name)

~spawnclips.([
	\a, 0,
	\1, 1, 
	\32, \r
]);


///////////////////////////////////////////////////////////////////////////////////////////////////////// 


// put this in a node to launch other clips

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

///////////////////////////////////////////////////// clip

Pdef(~name+++\pre, Pbind(
	\clip, Pseq([0,1,0,2],inf),
	\dur, 4,
));
