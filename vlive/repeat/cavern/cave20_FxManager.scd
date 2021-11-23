ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "4-JIHM-RN78", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.68243243243243,
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

ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-7JR9-S0UR", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.90729625207028,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.96204032710648,
	'shift', 0.12605042016807,
	'shift2', 0.0,
	'distamp', 1.821814698567,
	'pitchlag', 1.0,
	'pitchmix', 1.0,
	'prelpf', 17000,
	'prehpf', 20.0,
	'lpf', 17000,
	'hpf', 20.0,
	'fbdistamp', 0.5246435856376,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 797.75646390917,
	'wetamp', 0.32530026071068,
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

ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('deldefault', 'rdn3', "4-D51-QFDJ", BusDef('sendbus3'));
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




Ndef('fx1').source = 'passpers';
PlayerWrapper(Ndef('fx1')).outBus = 0;
Ndef('fx1').set('inbus', BusDef('sendbus1'));
Ndef('fx1').set('allpassf', 0.46218478340453);
Ndef('fx1').set('apdelay', 1.2153439601518);
Ndef('fx1').set('freqshift_noisefreq', 0.26295629016589);
Ndef('fx1').set('freqshift_fac', 0.60000002384186);
Ndef('fx1').set('freqshift', -16.501650165016);
Ndef('fx1').set('fb', 0.18305277961048);
Ndef('fx1').set('mix', 0.5);
Ndef('fx1').set('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx1').set('gain', 1.0);

Ndef('fx2').source = 'passpers';
PlayerWrapper(Ndef('fx2')).outBus = BusDef('fx3');
Ndef('fx2').set('inbus', BusDef('sendbus2'));
Ndef('fx2').set('allpassf', 0.32730843651531);
Ndef('fx2').set('apdelay', 4.6558234913659);
Ndef('fx2').set('freqshift_noisefreq', 0.53848864658026);
Ndef('fx2').set('freqshift_fac', 0.45986329782677);
Ndef('fx2').set('freqshift', 172.41379310345);
Ndef('fx2').set('fb', 0.11230928183337);
Ndef('fx2').set('mix', 0.5);
Ndef('fx2').set('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx2').set('gain', 1.0);

Ndef('fx3').source = 'fx_rlpfrhpf';
PlayerWrapper(Ndef('fx3')).outBus = 0;
Ndef('fx3').set('amp', 0.10000000149012);
Ndef('fx3').set('inbus', BusDef('fx3'));
Ndef('fx3').set('lpf', 20000.0);
Ndef('fx3').set('lrq', 1.0408050556222);
Ndef('fx3').set('hpf', 200.0);
Ndef('fx3').set('hrq', 1.0408050556222);
Ndef('fx3').set('mix', 1.0);
Ndef('fx3').set('gain', 1);

Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;
Ndef('fx4').set('inbus', 0);
Ndef('fx4').set('gain', 1);
