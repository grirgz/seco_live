ProtoDef('rdn', \rdn);
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "5-BL6D-T6LK", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.37837837837838,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.080828221925227,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.4443214647273,
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

ProtoDef('rdn2', \rdn);
ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-IJ42-M87T", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.52027027027027,
	'fb', 0.0015712360374779,
	'delay', 0.33838551534282,
	'delay2', 0.0001123104501833,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 4.6117477677083,
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
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-M364-R4AH", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.21428571428571,
	'gain', 0.49579831932773,
	'fb', 0.0004279072496055,
	'delay', 0.42682721311638,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.27616998133438,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 1.4578080138273,
	'fbdistmix', 0.33193277310924,
	'postlpf', 17000,
	'posthpf', 845.43537511411,
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
