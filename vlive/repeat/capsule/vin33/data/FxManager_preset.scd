ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = BusDef('mixer5');
ProtoDef('rdn').make('deldefault', 'rdn', "4-A8TI-1550", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.86193770992747,
	'gain', 0.79411764705882,
	'fb', 0.001902452197047,
	'delay', 0.42682721311638,
	'delay2', 0.00012613637220374,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.0495627369223,
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
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-4641-HHFU", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.84033613445378,
	'gain', 0.21848739495798,
	'fb', 0.0001,
	'delay', 0.39503780135666,
	'delay2', 0.31318310052438,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.36917041584555,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.070155594598956,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-7HOM-O61H", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.60466190090704,
	'delay2', 0.00017190722018586,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.821814698567,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 110.84790122088,
	'fbdistamp', 0.18881148226647,
	'fbdistmix', 0.92857142857143,
	'postlpf', 20000.0,
	'posthpf', 1555.2001812076,
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
ProtoDef('rdn4').make('default', 'rdn4', "5-ATJO-6ICH", BusDef('zero'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'fb', 0.0001,
	'delay', 0.39503780135666,
	'delay2', 0.00017190722018586,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 5.6506816471033,
	'pitchlag', 0.038746751204561,
	'pitchmix', 0.0,
	'prelpf', 20000.0,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 209.91254738447,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'wet20', 1.0,
	'mamp', 1,
	'indelay', 0.04,
	'gain', 0.27731092436975,
	'mix', 1.0,
).keep(1));




Ndef('fx1').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx1')).outBus = 0;
Ndef('fx1').set('inbus', BusDef('sendbus5'));
Ndef('fx1').set('verbmix', 1.0);
Ndef('fx1').set('room', 2.9683036911167);
Ndef('fx1').set('damp', 0.5);
Ndef('fx1').set('mix', 1.0);
Ndef('fx1').set('gain', 1.0);
Ndef('fx1').set('delay', 0.04);
Ndef('fx1').set('fb', 0);
Ndef('fx1').set('amp', 0.10000000149012);
Ndef('fx1').set('lpf', 20000.0);
Ndef('fx1').set('maxdelay', 0.20000000298023);
Ndef('fx1').set('modfreq', 0.1);
Ndef('fx1').set('modamp', 0);
Ndef('fx1').set('?', 3.0);
Ndef('fx1').set('hpf', 20.0);
Ndef('fx1').set('diff', 0.40009999275208);
Ndef('fx1').set('adsr', Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.0099999997764826, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));

Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;
Ndef('fx2').set('inbus', BusDef('fx2'));
Ndef('fx2').set('delay', 0.010099999606609);
Ndef('fx2').set('fb', 0.40000000596046);
Ndef('fx2').set('amp', 0.10000000149012);
Ndef('fx2').set('lpf', 15000.0);
Ndef('fx2').set('modfreq', 8.1000003814697);
Ndef('fx2').set('maxdelay', 0.20000000298023);
Ndef('fx2').set('modamp', 0.47999998927116);
Ndef('fx2').set('mix', 0.5);
Ndef('fx2').set('gain', 3);
Ndef('fx2').set('?', 3.0);
Ndef('fx2').set('hpf', 50.0);
Ndef('fx2').set('diff', 0.40009999275208);
Ndef('fx2').set('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;
Ndef('fx3').set('inbus', BusDef('fx3'));
Ndef('fx3').set('cpabove', 0.4967007867709);
Ndef('fx3').set('cprelax', 1.1069863656738);
Ndef('fx3').set('cpt', 0.073818746940912);
Ndef('fx3').set('cpclamp', 0.81335076230484);
Ndef('fx3').set('pregain', 1.0);
Ndef('fx3').set('sidemode', 1.0);
Ndef('fx3').set('mix', 1.0);
Ndef('fx3').set('gain', 0.68243243243243);
Ndef('fx3').set('sideinbus', BusDef('fx3'));
Ndef('fx3').set('cpbelow', 0.71900534768712);

Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;
Ndef('fx4').set('inbus', BusDef('sendbus5'));
Ndef('fx4').set('room', 0.63560362141631);
Ndef('fx4').set('mix', 0.53535353535354);
Ndef('fx4').set('verbmix', 1.0);
