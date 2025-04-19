ProtoDef('rdn', \rdn);
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = BusDef('mixer0');
ProtoDef('rdn').make('deldefault', 'rdn', "5-QBGD-FN8U", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.60504201680672,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.92552159097914,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.9875557887935,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 90.467414895442,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn2', \rdn);
ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('deldefault', 'rdn2', "4-7Q01-SRF1", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.21428571428571,
	'fb', 0.0001,
	'delay', 0.85659021536855,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2492192141522,
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
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn3', \rdn);
ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = BusDef('mixer0');
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-LES2-6BOS", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.94957983193277,
	'gain', 0.25210084033613,
	'fb', 0.0001,
	'delay', 0.0026826957952797,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.67909850299557,
	'pitchlag', 0.001,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 20.0,
	'lpf', 17000,
	'hpf', 98.697762354238,
	'fbdistamp', 0.61547970526916,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn4', \rdn);
ProtoDef('rdn4').inbus = BusDef('zero');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('default', 'rdn4', "4-OPRS-D8TR", BusDef('zero'));
Ndef('rdn4').put(100, \pset -> Pbind(
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
Ndef('fx1').setVal('inbus', 0);
Ndef('fx1').setVal('gain', 1);

Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;
Ndef('fx2').setVal('inbus', 0);
Ndef('fx2').setVal('gain', 1);

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;
Ndef('fx3').setVal('inbus', 0);
Ndef('fx3').setVal('gain', 1);

Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;
Ndef('fx4').setVal('inbus', 0);
Ndef('fx4').setVal('gain', 1);
