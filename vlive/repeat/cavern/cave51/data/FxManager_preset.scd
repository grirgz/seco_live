ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "4-47SH-G41", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.56302521008403,
	'fb', 0.057279745279053,
	'delay', 0.41062499172443,
	'delay2', 0.00012134827677491,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.12613637220374,
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
ProtoDef('rdn2').make('deldefault', 'rdn2', "4-LHSN-C51G", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 0.46638655462185,
	'fb', 0.0037876872401491,
	'delay', 0.60466190090704,
	'delay2', 0.0053838436220335,
	'shift', 0.0,
	'shift2', 0.50420168067227,
	'distamp', 0.49348881177119,
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

ProtoDef('rdn3').inbus = BusDef('sendbus2');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('deldefault', 'rdn3', "4-5B84-IUFN", BusDef('sendbus2'));
Ndef('rdn3').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.86554621848739,
	'gain', 0.32773109243697,
	'fb', 0.053060599115601,
	'delay', 0.00012134827677491,
	'delay2', 0.51794746792312,
	'shift', -0.16806722689076,
	'shift2', 0.0,
	'distamp', 52.806705745826,
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
ProtoDef('rdn4').make('deldefault', 'rdn4', "4-H3VR-F9BF", BusDef('sendbus4'));
Ndef('rdn4').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.45378151260504,
	'gain', 0.72268907563025,
	'fb', 0.0021338168782668,
	'delay', 0.0001123104501833,
	'delay2', 0.0001,
	'shift', 0.12605042016807,
	'shift2', 0.084033613445378,
	'distamp', 13.894954943731,
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
