ProtoDef('rdn', \rdn);
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "5-I1LH-KDC0", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.83613445378151,
	'fb', 0.0001,
	'delay', 0.066608462908092,
	'delay2', 0.00027351099530412,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.47937156455582,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 20.0,
	'lpf', 17000,
	'hpf', 20.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn2', \rdn);
ProtoDef('rdn2').inbus = BusDef('sendbus2');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('deldefault', 'rdn2', "4-J136-3KJH", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.63865546218487,
	'fb', 0.0044139963348665,
	'delay', 0.42682721311638,
	'delay2', 0.46117477677083,
	'shift', 0.0,
	'shift2', -0.084033613445379,
	'distamp', 27.087761019788,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 16803.499738589,
	'prehpf', 25.227274440749,
	'lpf', 20000.0,
	'hpf', 20.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 7900.7560271333,
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn3', \rdn);
ProtoDef('rdn3').inbus = BusDef('sendbus3');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('deldefault', 'rdn3', "5-4PS7-C5UA", BusDef('sendbus3'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.71428571428571,
	'gain', 0.16386554621849,
	'fb', 0.0014008706567206,
	'delay', 0.00033190087959147,
	'delay2', 0.0001,
	'shift', 0.12605042016807,
	'shift2', 0.084033613445378,
	'distamp', 3.6561601440852,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.97478991596639,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

ProtoDef('rdn4', \rdn);
ProtoDef('rdn4').inbus = BusDef('sendbus4');
ProtoDef('rdn4').outBus = 0;
ProtoDef('rdn4').make('deldefault', 'rdn4', "5-QV1D-FHAP", BusDef('sendbus4'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.44117647058824,
	'fb', 0.087248945270498,
	'delay', 0.00011674193588235,
	'delay2', 0.0001,
	'shift', 0.33613445378151,
	'shift2', 0.42016806722689,
	'distamp', 0.1,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 20.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.97478991596639,
	'postlpf', 17000,
	'posthpf', 459.59419380939,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));




Ndef('fx1').source = 'fx_greyhole';
PlayerWrapper(Ndef('fx1')).outBus = BusDef('fxmixer0');
Ndef('fx1').setVal('inbus', BusDef('sendbus5'));
Ndef('fx1').setVal('delay', 0.34375);
Ndef('fx1').setVal('damp', 0.1);
Ndef('fx1').setVal('size', 1.5679430814821);
Ndef('fx1').setVal('diff', 1.1625271046084);
Ndef('fx1').setVal('fb', 0.214246453173);
Ndef('fx1').setVal('modDepth', 0.10000000149012);
Ndef('fx1').setVal('modFreq', 2.0);
Ndef('fx1').setVal('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx1').setVal('mix', 1.0);
Ndef('fx1').setVal('gain', 1.0);

Ndef('fx2').source = 'fx_greyhole';
PlayerWrapper(Ndef('fx2')).outBus = BusDef('fxmixer1');
Ndef('fx2').setVal('inbus', BusDef('sendbus6'));
Ndef('fx2').setVal('delay', 0.171875);
Ndef('fx2').setVal('damp', 0.37297498522064);
Ndef('fx2').setVal('size', 0.1);
Ndef('fx2').setVal('diff', 3.0280995303199);
Ndef('fx2').setVal('fb', 0.71998724194777);
Ndef('fx2').setVal('modDepth', 44.721359549996);
Ndef('fx2').setVal('modFreq', 4.8871275633347);
Ndef('fx2').setVal('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0));
Ndef('fx2').setVal('mix', 0.71078431372549);
Ndef('fx2').setVal('gain', 0.0);

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;
Ndef('fx3').setVal('inbus', 0);
Ndef('fx3').setVal('gain', 1);

Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;
Ndef('fx4').setVal('inbus', 0);
Ndef('fx4').setVal('gain', 1);
