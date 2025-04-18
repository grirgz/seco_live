ProtoDef('rdn', \rdn);
ProtoDef('rdn').inbus = BusDef('zero');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('default', 'rdn', "4-9231-CDRB", BusDef('zero'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.01,
	'delay', 1,
	'delay2', 1,
	'shift', 1,
	'shift2', 1,
	'distamp', 1,
	'pitchlag', 0.125,
	'pitchmix', 0.5,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));




Ndef('fx1').source = nil;
PlayerWrapper(Ndef('fx1')).outBus = 0;


Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;


Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;

