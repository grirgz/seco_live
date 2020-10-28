ProtoDef('rdn').inbus = BusDef(\zero);
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('default', 'rdn', "4-JIHM-RN78", BusDef(\zero));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', -5.0,
	'shift2', -1.1344537815126,
	'distamp', 1.5846456692913,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'indelay', 0.04,
	'brffac', 0.60195390291997,
	'gain', 1,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'mix', 1.0,
	'distamp2', 3.9466141732283,
).keep(1));




Ndef('fx1').source = nil;
PlayerWrapper(Ndef('fx1')).outBus = 0;


Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;


Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;

