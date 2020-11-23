ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "5-A46J-DN28", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.1890756302521,
	'gain', 0.67647058823529,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.45233707447721,
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
	'mamp', 2,
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
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-EFJT-DEJC", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.21428571428571,
	'gain', 0.32352941176471,
	'fb', 0.0011569796408558,
	'delay', 0.01123104501833,
	'delay2', 0.00010804718223181,
	'shift', 0.16806722689076,
	'shift2', 0.0,
	'distamp', 41.8647728829,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 922.34955354165,
	'posthpf', 98.697762354238,
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

ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = BusDef('mixer6');
ProtoDef('rdn3').make('deldefault', 'rdn3', "4-BKID-T0OV", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.071428571428571,
	'fb', 0.00010389974084947,
	'delay', 0.00012134827677491,
	'delay2', 0.0001,
	'shift', 0.084033613445378,
	'shift2', -0.16806722689076,
	'distamp', 84.017498692943,
	'pitchlag', 0.125,
	'pitchmix', 0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.5,
	'fbdistmix', 1,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 1,
	'indelay', 0,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn4').inbus = BusDef('sendbus4');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('deldefault', 'rdn4', "4-1RBP-FRAM", BusDef('sendbus4'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77731092436975,
	'gain', 0.22268907563025,
	'fb', 0.00011216139262679,
	'delay', 0.011674193588235,
	'delay2', 0.0065332014595938,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 10.097216787475,
	'pitchlag', 0.97139297410877,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 20.0,
	'fbdistamp', 0.5246435856376,
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
	'delay3', 0.00027351099530412,
	'distamp2', 3.9466141732283,
).keep(1));




Ndef('fx1').source = 'fx_chorus';
PlayerWrapper(Ndef('fx1')).outBus = BusDef('mixer5');
Ndef('fx1').set('amp', 0.23289027499319);
Ndef('fx1').set('inbus', BusDef('sendbus5'));
Ndef('fx1').set('fb', 0.40000000596046);
Ndef('fx1').set('maxdelay', 0.20000000298023);
Ndef('fx1').set('delay', 0.053255952820757);
Ndef('fx1').set('diff', 0.18354089097777);
Ndef('fx1').set('modfreq', 0.38037523907546);
Ndef('fx1').set('modamp', 0.35796367227615);
Ndef('fx1').set('lpf', 15000.0);
Ndef('fx1').set('hpf', 50.0);
Ndef('fx1').set('mix', 1.0);
Ndef('fx1').set('gain', 2);
Ndef('fx1').set('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx1').set('?', 3.0);

Ndef('fx2').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx2')).outBus = BusDef('mixer7');
Ndef('fx2').set('inbus', BusDef('sendbus6'));
Ndef('fx2').set('verbmix', 1.0);
Ndef('fx2').set('room', 1.6759318326784);
Ndef('fx2').set('damp', 0.5);
Ndef('fx2').set('mix', 0.22401847575058);
Ndef('fx2').set('gain', 1.0);

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;

