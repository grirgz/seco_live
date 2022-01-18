
// abstract morphing categorial noise

(
SynthDef(\piaf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\piaf_harm, 
	Ppar([
		Pbind(
			\instrument, \piaf,
			\degree, Prand((0..7),inf),
			\octave, 3,
			\dur, Pwhite(0.01,0.2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \piaf,
			\degree, Prand((0..7),inf),
			\octave, 4,
			\dur, Pwhite(0.01,0.2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \piaf,
			\degree, Prand((0..7),inf),
			\octave, 5,
			\dur, Pwhite(0.01,0.2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \piaf,
			\degree, Prand((0..7),inf),
			\octave, 6,
			\dur, Pwhite(0.01,0.2),
			\amp, 0.1,
		),
	]),
).play;
);

(
Pdef(\part, Pdef(\piaf_harm, 
	Pseq([
		Pbind(
			\freq, Pswitch1(
				[
				 (Prand(Scale.major.degrees,inf) + ( Pkey(\octave) * 12 )).midicps,
				 (Prand((0..7),inf) + ( Pkey(\octave) * 12 )).midicps,
				 Pwhite(50,15000),
				 Pexprand(50,15000),
				], 
				Pseq([
					Pstep(
						Pseq((0..3))
					,8),
				],inf)
			),
			\legato, Pseg(Pseq([0.1,1],inf),8),
		)
	],inf) <>
	Ppar([
		Pbind(
			\instrument, \piaf,
			\octave, 3,
			\dur, Pwhite(0.01,0.2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \piaf,
			\degree, Prand((0..7),inf),
			\octave, 4,
			\dur, Pwhite(0.01,0.2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \piaf,
			\degree, Prand((0..7),inf),
			\octave, 5,
			\dur, Pwhite(0.01,0.2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \piaf,
			\degree, Prand((0..7),inf),
			\octave, 6,
			\dur, Pwhite(0.01,0.2),
			\amp, 0.1,
		),
	].collect({ arg pat,idx;
		Pbind(
			\dur, Pseq([1/4,1,0.1],inf,idx),
			\out, BusDef(\sendbus1, \audio),
			
		)<> pat
   
	})),
)).play;
);

ProtoDef(\FxManager).presetCompileString.editorInsert
(
ProtoDef('rdn').inbus = BusDef('sendbus1');
ProtoDef('rdn').outBus = 0;
ProtoDef('rdn').make('deldefault', 'rdn', "4-HN09-C3A0", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5546218487395,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.49828635146473,
	'delay2', 0.00037275937203149,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.65967151453768,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
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

ProtoDef('rdn2').inbus = BusDef('zero');
ProtoDef('rdn2').outBus = 0;
ProtoDef('rdn2').make('default', 'rdn2', nil, BusDef('zero'));
Ndef('rdn2').put(100, \pset -> Pbind(
	
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




Ndef('fx1').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx1')).outBus = 0;
Ndef('fx1').set('inbus', BusDef('sendbus1'));
Ndef('fx1').set('verbmix', 1.0);
Ndef('fx1').set('room', 1.0408050556222);
Ndef('fx1').set('damp', 0.5);
Ndef('fx1').set('mix', 1.0);
Ndef('fx1').set('gain', 0.35353535353535);

Ndef('fx2').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx2')).outBus = 0;


Ndef('fx3').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = 'fx_freeverb2';
PlayerWrapper(Ndef('fx4')).outBus = 0;


);

