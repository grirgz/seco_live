(
~play_timeline.([
	0, {
		~spawnclips.([
			'u', 0,
		]);
	},
	8, {
		~spawnclips.([
			'i', 4,
		]);
	},
	30, {
		Ndef('umixer').stop(2);
	},
	32, {
		~spawnclips.([
			'q', 2,
			's', 2,
			'd', 2,
			'g', 3,
			//'h', 2,
			//'j', 1,
		]);
		~spawnclips.([
			'f', 38,
		]);
		[\g, \h, \j].do { arg name; ~patfx_unmute.(name+++'patfx'); };
	},
	32+16, {
		~spawnclips.([
			'h', 1,
		]);
	},
	32+16+8, {
		~spawnclips.([
			'h', \r,
			'j', 1,
		]);
	},
	64, {
		~spawnclips.([
			'i', \r,
			'h', 2,
			'j', 1,
		]);

	},
	64+16, [
		0, {
			~spawnclips.([
				'u', 5,
				//'q', 2,
				//'s', 2,
				//'d', 2,
				'g', 3,
				'h', 2,
				'j', 1,
			]);
			~spawnclips.([
				'f', 38,
			]);
			[\g, \h, \j].do { arg name; ~patfx_mute.(name+++'patfx'); };

			~launcher_lib.mid_pane;
			Veco.main.clip_offset = Point(15,0);
			Veco.main.pane_offset = Point(Veco.main.clip_offset.x,32);
			Veco.main.clip.render_state;
		}
	]
	
]);
);

// END

~timeline.isPlaying
(
~play_timeline.([
	0, { "plop1".postln; },
	1, { "bla1".postln; },
	2, [
		0, { "plop2".postln; },
		4, { "bla2".postln; }
	],
]);
);

(
~play_timeline.([
	0, { "plop1".postln; },
	4, { "bla1".postln; },
]);
);




~timeline = Task({
		~spawnclips.([
			'u', 0,
		]);
		"plop".postln;
	4.wait;
		~spawnclips.([
			'i', 4,
		]);
		"plop2".postln;
	4.wait;
		2.wait;
			Ndef('umixer').stop(4);
		2.wait;
			~spawnclips.([
				'q', 2,
				's', 2,
				'd', 2,
				'g', 3,
				//'h', 2,
				//'j', 1,
			]);
			~spawnclips.([
				'f', 38,
			]);
			[\g, \h, \j].do { arg name; ~patfx_unmute.(name+++'patfx'); };
	4.wait;
	~spawnclips.([
		'u', \r,
	]);
	"plop3".postln;

}).play(quant:4);

