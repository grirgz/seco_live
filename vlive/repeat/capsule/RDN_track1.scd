
(
RandDelayNetwork('del3').make('rdn', "4-JIHM-RN78");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'delay3', 0.0001,
	'distamp', 1.5846456692913,
	'distamp2', 3.9466141732283,
	'distamp3', 3.9466141732283,
	'shift', -5.0,
	'shift2', -1.1344537815126,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'brffac', 0.60195390291997,
	'brfrqfac', 0.37940593233798,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

// END

ProtoDef(\rdn).presetCompileString.editorInsert
