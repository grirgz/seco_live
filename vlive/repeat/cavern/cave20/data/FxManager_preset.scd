ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('del3full', 'rdn', "6-IJBL-8DO0", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.34873949579832,
	'gain', 0.5,
	'fb', 0.0031282524205628,
	'delay', 0.39503780135666,
	'delay2', 0.016538167833957,
	'delay3', 0.0085659021536855,
	'distamp', 0.1,
	'distamp2', 23.428684237322,
	'distamp3', 0.1,
	'shift', -0.63025210084034,
	'shift2', -0.67226890756302,
	'shift3', -0.7563025210084,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.43315678728535,
	'fbdistmix', 0.38235294117647,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
).keep(1));

ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('del3full', 'rdn2', "6-8QT4-B95O", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.27731092436975,
	'gain', 0.72689075630252,
	'fb', 0.0001,
	'delay', 0.011674193588235,
	'delay2', 0.015910384392722,
	'delay3', 0.00017869024337358,
	'distamp', 1.4030037231906,
	'distamp2', 0.15013107289082,
	'distamp3', 2.6568665917992,
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
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
).keep(1));

ProtoDef('rdn3').inbus = BusDef('zero');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('default', 'rdn3', nil, BusDef('zero'));
Ndef('rdn3').put(100, \pset -> Pbind(
	
).keep(1));

ProtoDef('rdn4').inbus = BusDef('zero');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('default', 'rdn4', nil, BusDef('zero'));
Ndef('rdn4').put(100, \pset -> Pbind(
	
).keep(1));




Ndef('fx1').source = nil;
PlayerWrapper(Ndef('fx1')).outBus = 0;


Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;


Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;

