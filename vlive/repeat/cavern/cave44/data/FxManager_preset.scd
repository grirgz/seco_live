ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = BusDef('sendbus4');
ProtoDef('rdn').make('deldefault', 'rdn', "5-89OL-J86Q", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.86193770992747,
	'gain', 0.48739495798319,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.00018574090746386,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.17869024337358,
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
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-L2O6-RL8R", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77310924369748,
	'gain', 0.39495798319328,
	'fb', 0.0024866519548153,
	'delay', 0.0001,
	'delay2', 0.42682721311638,
	'shift', 0.12605042016807,
	'shift2', 0.16806722689076,
	'distamp', 0.29267562511568,
	'pitchlag', 0.70589400866187,
	'pitchmix', 0.084033613445378,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 8873.3746619572,
	'posthpf', 20.0,
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
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-QRHL-5ABG", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.90729625207028,
	'gain', 0.52521008403361,
	'fb', 0.0001,
	'delay', 1.0,
	'delay2', 0.36561601440852,
	'shift', -3.0252100840336,
	'shift2', -0.084033613445379,
	'distamp', 0.18936988889504,
	'pitchlag', 0.18042741251498,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 3608.5482502996,
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

ProtoDef('rdn4').inbus = BusDef('zero');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('default', 'rdn4', nil, BusDef('zero'));
Ndef('rdn4').put(100, \pset -> Pbind(
	
).keep(1));




Ndef('fx1').source = 'fx_greyhole';
PlayerWrapper(Ndef('fx1')).outBus = 0;
Ndef('fx1').set('inbus', BusDef('sendbus4'));
Ndef('fx1').set('delay', 0.013551260546659);
Ndef('fx1').set('damp', 0.82205065162166);
Ndef('fx1').set('size', 0.3452833479747);
Ndef('fx1').set('diff', 0.70700001716614);
Ndef('fx1').set('fb', 0.89999997615814);
Ndef('fx1').set('modDepth', 0.10000000149012);
Ndef('fx1').set('modFreq', 2.0);
Ndef('fx1').set('adsr', [ 0.0, 3.0, 2.0, -99.0, 1.0, 0.10000000149012, 5.0, -4.0, 0.80000001192093, 0.10000000149012, 5.0, -4.0, 0.0, 0.10000000149012, 5.0, -4.0 ]);
Ndef('fx1').set('mix', 0.31979695431472);
Ndef('fx1').set('gain', 1.0);

Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;


Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;

