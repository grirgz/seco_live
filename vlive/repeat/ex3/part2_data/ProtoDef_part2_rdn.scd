PlayerWrapper(ProtoDef('part2_rdn')).presetCompileStringSavePath = "ex3/part2_data/ProtoDef_part2_rdn.scd";

RandDelayNetwork('deldefault').make('part2_rdn', "4-PPHM-4BC5");
Ndef('part2_rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.29156160276546,
	'fb', 0.00017084508946544,
	'delay', 0.00018574090746386,
	'delay2', 0.00015306431405564,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 64.036508523962,
	'pitchlag', 0.3416751906158,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.7436974789916,
	'postlpf', 10872.367240308,
	'posthpf', 235.75372695872,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));
