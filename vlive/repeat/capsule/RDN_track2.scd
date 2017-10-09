
(
RandDelayNetwork('del3').make('rdn', "4-CG1I-AA2M");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.88007666162239,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'delay3', 0.0001,
	'distamp', 1.4370779141994,
	'distamp2', 10.752168531899,
	'distamp3', 15.734407502856,
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
	'stereo', 0.0,
	'fbdistamp', 1.7102110294535,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
).keep(1));

);

// END

ProtoDef(\rdn).presetCompileString.editorInsert
