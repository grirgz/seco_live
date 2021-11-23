ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = BusDef('fxmixer0');
ProtoDef('rdn').make('deldefault', 'rdn', "5-E170-620R", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.83613445378151,
	'gain', 0.70588235294118,
	'fb', 0.00012107997472492,
	'delay', 0.0001416643274669,
	'delay2', 0.0002006878167665,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.69909760632006,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
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
ProtoDef('rdn2').outBus = BusDef('fxmixer1');
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-5O88-70T9", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.84033613445378,
	'gain', 0.69327731092437,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.29267562511568,
	'pitchlag', 1.0,
	'pitchmix', 1.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.55924758241628,
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
ProtoDef('rdn3').outBus = BusDef('fxmixer2');
ProtoDef('rdn3').make('deldefault', 'rdn3', "4-9VJH-95GR", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.52941176470588,
	'fb', 0.0001,
	'delay', 0.55962764453196,
	'delay2', 1.0,
	'shift', -0.42016806722689,
	'shift2', 0.084033613445378,
	'distamp', 0.55423950610442,
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
ProtoDef('rdn4').outBus = BusDef('fxmixer3');
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
	'gain', 1.0,
).keep(1));




Ndef('fx1').source = 'fx_echo';
PlayerWrapper(Ndef('fx1')).outBus = BusDef('fxmixer4');
Ndef('fx1').set('amp', 0.10000000149012);
Ndef('fx1').set('inbus', BusDef('sendbus5'));
Ndef('fx1').set('delay', 0.59078379115879);
Ndef('fx1').set('decay', 2.6528042145168);
Ndef('fx1').set('lpf', 20000.0);
Ndef('fx1').set('hpf', 3254.307350153);
Ndef('fx1').set('pfmix', 0.5);
Ndef('fx1').set('mix', 0.5);
Ndef('fx1').set('gain', 1);
Ndef('fx1').set('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx1').set('ioiDecayFactor', 1.2316791766772);
Ndef('fx1').set('decayFactor', 0.10722390010564);

Ndef('fx2').source = 'fx_echo';
PlayerWrapper(Ndef('fx2')).outBus = BusDef('fxmixer5');
Ndef('fx2').set('amp', 0.10000000149012);
Ndef('fx2').set('inbus', BusDef('sendbus6'));
Ndef('fx2').set('delay', 0.15625);
Ndef('fx2').set('decay', 2);
Ndef('fx2').set('lpf', 15000.0);
Ndef('fx2').set('hpf', 50.0);
Ndef('fx2').set('pfmix', 0.5);
Ndef('fx2').set('mix', 0.5);
Ndef('fx2').set('gain', 1);
Ndef('fx2').set('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));

Ndef('fx3').source = 'fx_greyhole';
PlayerWrapper(Ndef('fx3')).outBus = BusDef('fxmixer6');
Ndef('fx3').set('inbus', BusDef('sendbus7'));
Ndef('fx3').set('delay', 0.013773281798599);
Ndef('fx3').set('damp', 1.8864657705248);
Ndef('fx3').set('size', 3.6041932223155);
Ndef('fx3').set('diff', 9.0363912243803);
Ndef('fx3').set('fb', 0.9);
Ndef('fx3').set('modDepth', 0.42717497111857);
Ndef('fx3').set('modFreq', 0.15742159635571);
Ndef('fx3').set('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx3').set('gain', 1.0);

Ndef('fx4').source = 'fx_freqshift';
PlayerWrapper(Ndef('fx4')).outBus = BusDef('fxmixer7');
Ndef('fx4').set('amp', 0.10000000149012);
Ndef('fx4').set('inbus', BusDef('sendbus4'));
Ndef('fx4').set('shift', -0.024390243902439);
Ndef('fx4').set('mix', 0.46190476190476);
Ndef('fx4').set('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.0099999997764826, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx4').set('delay', 0.21706278248931);
Ndef('fx4').set('decay', 0.1);
Ndef('fx4').set('fb', 0.9);
Ndef('fx4').set('lfomul', 0.001);
Ndef('fx4').set('gain', 1);
Ndef('fx4').set('maxdelay', 0.30172896261887);
Ndef('fx4').set('flangefreq', 1.1069863656738);
Ndef('fx4').set('modfreq', 0.25344749297326);
Ndef('fx4').set('diff', 0.76472449133173);
