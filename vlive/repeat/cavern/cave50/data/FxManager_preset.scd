ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = BusDef('fxmixer1');
ProtoDef('rdn').make('deldefault', 'rdn', "5-986T-E7LM", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.33193277310924,
	'fb', 0.0012489775883775,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 5.6506816471033,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 257.20161612211,
	'lpf', 20000.0,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = BusDef('fxmixer2');
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-QVNG-8A29", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.34033613445378,
	'fb', 0.0098567948815672,
	'delay', 0.00011674193588235,
	'delay2', 0.066608462908092,
	'shift', 0.63025210084034,
	'shift2', -0.29411764705882,
	'distamp', 0.26826957952797,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 20.0,
	'fbdistmix', 0.3109243697479,
	'postlpf', 20000.0,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 2,
).keep(1));

ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = BusDef('fxmixer3');
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

ProtoDef('rdn4').inbus = BusDef('sendbus4');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('deldefault', 'rdn4', "5-F3K9-7GPG", BusDef('sendbus4'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.89495798319328,
	'gain', 1.0,
	'fb', 0.00011653539627239,
	'delay', 0.44366873309786,
	'delay2', 0.00012134827677491,
	'shift', 0.042016806722689,
	'shift2', -0.042016806722689,
	'distamp', 0.5080218046913,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.55924758241628,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 774.93502409123,
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




Ndef('fx1').source = 'fx_greyhole';
PlayerWrapper(Ndef('fx1')).outBus = 0;
Ndef('fx1').set('inbus', BusDef('sendbus4'));
Ndef('fx1').set('delay', 0.00521664525186);
Ndef('fx1').set('damp', 0.0);
Ndef('fx1').set('size', 1.0);
Ndef('fx1').set('diff', 0.70700001716614);
Ndef('fx1').set('fb', 0.89999997615814);
Ndef('fx1').set('modDepth', 0.42337261010139);
Ndef('fx1').set('modFreq', 2.0);
Ndef('fx1').set('adsr', [ 0.0, 3.0, 2.0, -99.0, 1.0, 0.10000000149012, 5.0, -4.0, 0.80000001192093, 0.10000000149012, 5.0, -4.0, 0.0, 0.10000000149012, 5.0, -4.0 ]);
Ndef('fx1').set('mix', 1.0);
Ndef('fx1').set('gain', 1);

Ndef('fx2').source = nil;
PlayerWrapper(Ndef('fx2')).outBus = 0;
Ndef('fx2').set('inbus', 0);
Ndef('fx2').set('gain', 1);

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;
Ndef('fx3').set('inbus', 0);
Ndef('fx3').set('gain', 1);

Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;
Ndef('fx4').set('inbus', 0);
Ndef('fx4').set('gain', 1);
