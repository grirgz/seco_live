ProtoDef('rdn', \rdn);
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "5-FMDN-4OLL", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.3109243697479,
	'fb', 0.00051810998966843,
	'delay', 0.2297970969047,
	'delay2', 0.0001,
	'shift', -0.042016806722689,
	'shift2', 0.0,
	'distamp', 10.394574653723,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.98319327731092,
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

ProtoDef('rdn2', \rdn);
ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-GL8H-RG9F", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.079831932773109,
	'fb', 0.0001,
	'delay', 0.41062499172443,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 19.684194472866,
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
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-G8A8-U7LM", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.29831932773109,
	'fb', 0.0001,
	'delay', 0.14443214647273,
	'delay2', 0.0038004229563659,
	'shift', -0.042016806722689,
	'shift2', 0.0,
	'distamp', 0.76269858590234,
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
