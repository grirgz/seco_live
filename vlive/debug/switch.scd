
(
	// strange bug with switch nil
	
	switch(nil,
		nil, {
			"hello".debug;
		},
		15, {
			"hi".debug;
		},
		{
			"nope".debug;
		}
	
	)
)


(
	// strange bug with switch nil
	~hello = { arg clap;

	
		switch(clap,
			nil, {
				"hello".debug;
			},
			15, {
				"hi".debug;
			},
			{
				"nope".debug;
			}
		
		)
	};
)

~hello.('a',14)

(
~hello = { arg node_uname, clip_index;
	// accept node indexes too
	var tr = node_uname;
	[node_uname, clip_index].debug("spawnclip: node_uname, clip_index");
	if(tr.class != Symbol) {
		tr = Veco.main.get_node_by_index(tr).uname;
	};
	tr.debug("hian1");
	if(clip_index.isNil) {
		clip_index = \nil;
	};
	switch(clip_index,
		\nil, {
			// NOOP
	[node_uname, clip_index].debug("spawnclip: hian2: WTF: node_uname, clip_index");
	tr.debug("hian2");
		},
		\r, {
			Veco(tr).stop_node(true);
	tr.debug("hian3");
		}, 
		\rr, {
			Veco(tr).stop_node(false);
	tr.debug("hian3");
		}, 
		\p, {
			Veco(tr).play_node;
	tr.debug("hian4");
		}, 
		{
			if(clip_index.class == Symbol) {
				// NOOP
	tr.debug("hian5");
			} {
				if(Veco(tr).is_playing.not or: { Veco(tr).active_clip_index != clip_index }) {
					var clip = Veco(tr).get_clip_by_index(clip_index);
	tr.debug("hian6");
	[node_uname, clip_index, clip.uname].debug("hian6: clip_index");
					if(clip.is_present.not) {
						// TODO: make a mode where non existing clip continue playing
						Veco(tr).stop_node(true);
					} {
						if(clip.response_mode == \exec) {
							clip.response_on;
		tr.debug("hian7");
						} {
							clip.response_on_play;
		tr.debug("hian8");
						}
					}
				} {
	tr.debug("hian9");
					"already playing"
				}
			};
		}
	);
};
)
