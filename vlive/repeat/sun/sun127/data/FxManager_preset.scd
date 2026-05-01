ProtoDef('rdn', \rdn);
ProtoDef('rdn').inbus = BusDef('zero');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('default', 'rdn', nil, BusDef('zero'));
Ndef('rdn').put(100, \pset -> Pbind(
	
).keep(1));

ProtoDef('rdn2', \rdn);
ProtoDef('rdn2').inbus = BusDef('zero');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('default', 'rdn2', nil, BusDef('zero'));
Ndef('rdn2').put(100, \pset -> Pbind(
	
).keep(1));

ProtoDef('rdn3', \rdn);
ProtoDef('rdn3').inbus = BusDef('zero');
ProtoDef('rdn3').outBus = 0;
ProtoDef('rdn3').make('default', 'rdn3', nil, BusDef('zero'));
Ndef('rdn3').put(100, \pset -> Pbind(
	
).keep(1));

ProtoDef('rdn4', \rdn);
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

