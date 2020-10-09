ProtoDef('rdn').inbus = BusDef(\sendbus1);
ProtoDef('rdn').outBus = 0;

ProtoDef('rdn').make('deldefault', 'rdn', "5-PASL-TIKE", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.21621621621622,
	'fb', 0.0001,
	'delay', 0.00094360431014789,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 38.373694474524,
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
ProtoDef('rdn2').inbus = BusDef(\sendbus2);
ProtoDef('rdn2').outBus = 0;

ProtoDef('rdn2').make('deldefault', 'rdn2', "4-7Q01-SRF1", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.31081081081081,
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
ProtoDef('rdn3').inbus = BusDef(\sendbus3);
ProtoDef('rdn3').outBus = 0;

ProtoDef('rdn3').make('deldefault', 'rdn3', "4-OIDF-JAE1", BusDef(\sendbus3));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.92436974789916,
	'gain', 0.79831932773109,
	'fb', 0.0001,
	'delay', 1.0,
	'delay2', 0.00016538167833957,
	'shift', 0.71428571428571,
	'shift2', 0.67226890756302,
	'distamp', 1.7696979983161,
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
ProtoDef('rdn4').inbus = BusDef(\sendbus4);
ProtoDef('rdn4').outBus = 34;

ProtoDef('rdn4').make('del3full', 'rdn4', "5-K7FO-SU43", BusDef(\sendbus4));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.60924369747899,
	'gain', 0.20168067226891,
	'fb', 0.0001,
	'delay', 0.0005080218046913,
	'delay2', 0.00021683753109874,
	'delay3', 0.0005080218046913,
	'distamp', 27.885481717263,
	'distamp2', 1.0195378685327,
	'distamp3', 20.263883924964,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 20.0,
	'stereo', 0.0,
	'fbdistamp', 11.62096354568,
	'fbdistmix', 0.97899159663866,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1.0,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
).keep(1));



Ndef('fx1').set('inbus', BusDef(\fx1));
Ndef('fx1').set('out', BusDef(\fx2));
Ndef('fx1').source = 'fx_chorus';
Ndef('fx1').set('gain', 4);

Ndef('fx2').set('inbus', BusDef(\fx2));
Ndef('fx2').set('out', BusDef(\sendbus3));
Ndef('fx2').source = 'fx_freeverb2';
Ndef('fx2').set('gain', 0.72394366197183);

Ndef('fx3').set('inbus', BusDef(\fx3));
Ndef('fx3').set('out', 142);
Ndef('fx3').source = 'fx_compander';
Ndef('fx3').set('gain', 1);

Ndef('fx4').set('inbus', 0);
Ndef('fx4').set('out', 0);
Ndef('fx4').source = nil;
Ndef('fx4').set('gain', 1);
