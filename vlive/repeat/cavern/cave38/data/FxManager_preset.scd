ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = BusDef('fxmixer0');
ProtoDef('rdn').make('deldefault', 'rdn', "5-LHMI-82S9", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.3781512605042,
	'gain', 1.0,
	'fb', [ "c0", "c1" ],
	'delay', 0.00027351099530412,
	'delay2', 0.027351099530412,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 2.046088289466,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 20000.0,
	'prehpf', 20.0,
	'lpf', 20000.0,
	'hpf', 20.0,
	'fbdistamp', 0.54166932430961,
	'fbdistmix', 0.98319327731092,
	'postlpf', 774.93502409123,
	'posthpf', 20.0,
	'wetamp', 0.86193770992747,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1.0,
	'distamp3', 2.297970969047,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = BusDef('fxmixer0');
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-AT8B-8T9O", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5546218487395,
	'gain', 0.85714285714286,
	'fb', [ "c3", "c4" ],
	'delay', 0.00012613637220374,
	'delay2', 0.10195378685327,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 3.4310975906799,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 20.0,
	'lpf', 17000,
	'hpf', 20.0,
	'fbdistamp', 0.74547482329271,
	'fbdistmix', 0.9453781512605,
	'postlpf', 20000.0,
	'posthpf', 333.97893177422,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.2494587155918,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.00031910749729236,
	'distamp2', 3.9466141732283,
).keep(1));

ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = BusDef('fxmixer0');
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-DCQN-9V04", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.41176470588235,
	'gain', 0.57563025210084,
	'fb', 0.0001,
	'delay', 0.51794746792312,
	'delay2', 0.23886430789846,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.80828221925227,
	'pitchlag', 0.001,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 203.90757370655,
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

ProtoDef('rdn4').inbus = BusDef('zero');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('default', 'rdn4', nil, BusDef('zero'));
Ndef('rdn4').put(100, \pset -> Pbind(
	
).keep(1));




Ndef('fx1').source = 'simplecomp';
PlayerWrapper(Ndef('fx1')).outBus = BusDef('fxmixer0');
Ndef('fx1').set('inbus', BusDef('fx1'));
Ndef('fx1').set('pregain', 2.6239924106353);
Ndef('fx1').set('cpt', 0.095555715554142);
Ndef('fx1').set('cpbelow', 1.00100004673);
Ndef('fx1').set('cpabove', 0.1);
Ndef('fx1').set('cpclamp', 0.0099999997764826);
Ndef('fx1').set('cprelax', 0.10000000149012);
Ndef('fx1').set('mix', 0.0);
Ndef('fx1').set('gain', 1.0);

Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;


Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;

