PlayerWrapper(ProtoDef('part2_rdn2')).presetCompileStringSavePath = "ex3/part2_data/ProtoDef_part2_rdn2.scd";

RandDelayNetwork('deldefault').make('part2_rdn2', "4-6F4D-503D");
Ndef('part2_rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.82773109243697,
	'gain', 0.76002267045911,
	'fb', 0.0001,
	'delay', 0.00015910384392722,
	'delay2', 0.00015306431405564,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.0514412603848,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.82352941176471,
	'postlpf', 14961.65291045,
	'posthpf', 69.67015911419,
	'wetamp', 1,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));
