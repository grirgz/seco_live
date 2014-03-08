~spawnclips.([
	'q', 2,
	's', 2,
	'd', 2,
	'g', 3,
	'h', 2,
	'j', 1,
]);
~spawnclips.([
	'f', 38,
]);
[\g, \h, \j].do { arg name; ~patfx_unmute.(name+++'patfx'); }
