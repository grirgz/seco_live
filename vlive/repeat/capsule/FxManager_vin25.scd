ProtoDef('rdn').inbus = BusDef(\sendbus1);
ProtoDef('rdn').outBus = 0;

ProtoDef('rdn').make('deldefault', 'rdn', "5-4EQ9-CP0E", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.1890756302521,
	'gain', 0.89075630252101,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 12.736262949269,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.55924758241628,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));
ProtoDef('rdn2').inbus = BusDef(\sendbus2);
ProtoDef('rdn2').outBus = 136;

ProtoDef('rdn2').make('deldefault', 'rdn2', "5-IQCN-FNBP", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.26470588235294,
	'fb', 0.0001,
	'delay', 0.47937156455582,
	'delay2', 0.0001416643274669,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 15.159059895148,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 8.7179279101121,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));
ProtoDef('rdn3').inbus = BusDef(\sendbus3);
ProtoDef('rdn3').outBus = 0;

ProtoDef('rdn3').make('deldefault', 'rdn3', "4-D51-QFDJ", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 1,
	'fb', 0.0001,
	'delay', 0.0001,
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
ProtoDef('rdn4').inbus = BusDef(\zero);
ProtoDef('rdn4').outBus = 0;

ProtoDef('rdn4').make('default', 'rdn4', "4-OPRS-D8TR", BusDef(\zero));
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



Ndef('fx1').set('inbus', 0);
Ndef('fx1').set('out', 154);
Ndef('fx1').source = nil;
Ndef('fx1').set('gain', 1);

Ndef('fx2').set('inbus', 0);
Ndef('fx2').set('out', 0);
Ndef('fx2').source = nil;
Ndef('fx2').set('gain', 1);

Ndef('fx3').set('inbus', 0);
Ndef('fx3').set('out', 0);
Ndef('fx3').source = nil;
Ndef('fx3').set('gain', 1);

Ndef('fx4').set('inbus', 0);
Ndef('fx4').set('out', 0);
Ndef('fx4').source = nil;
Ndef('fx4').set('gain', 1);
