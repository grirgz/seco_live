ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = BusDef('fx1');
ProtoDef('rdn').make('del3full', 'rdn', "6-RRIE-Q2HL", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.84033613445378,
	'gain', 0.28151260504202,
	'fb', 0.0001,
	'delay', 0.047018514892999,
	'delay2', 0.0001,
	'delay3', 0.0001416643274669,
	'distamp', 0.45233707447721,
	'distamp2', 0.40275599798503,
	'distamp3', 0.76269858590234,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.55924758241628,
	'fbdistmix', 0.26890756302521,
	'postlpf', 2403.5985228214,
	'posthpf', 37.873977779007,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1.0,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
).keep(1));

ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('deldefault', 'rdn2', "6-L2UP-188T", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.3781512605042,
	'fb', 0.00031508949906906,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.0804718223181,
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

ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('deldefault', 'rdn3', "6-TCU5-BJ21", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.58823529411765,
	'gain', 0.98319327731092,
	'fb', 0.0001,
	'delay', 0.00013111339374216,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.1122911644584,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.55924758241628,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 181.55707983875,
	'wetamp', 0.37940593233798,
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




Ndef('fx1').source = 'fx_compander';
PlayerWrapper(Ndef('fx1')).outBus = BusDef('mixer4');
Ndef('fx1').set('sidemode', 1.0);
Ndef('fx1').set('inbus', BusDef('fx1'));
Ndef('fx1').set('sideinbus', BusDef('mixer0'));
Ndef('fx1').set('pregain', 1.0);
Ndef('fx1').set('cpt', 0.12369344039899);
Ndef('fx1').set('cpbelow', 1.3318671525419);
Ndef('fx1').set('cpabove', 0.89999997615814);
Ndef('fx1').set('cpclamp', 0.0099999997764826);
Ndef('fx1').set('cprelax', 0.38815334473564);
Ndef('fx1').set('mix', 1.0);
Ndef('fx1').set('gain', 1.0);

Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;


Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;

