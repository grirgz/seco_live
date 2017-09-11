

PatKitDef(\buzz).edit

MenuSpecDef(\patkitdef_synthdefs).addUnique(\granu);

(
SynthDef(\granu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pitch_stretch=1, pos=0, gdur=0.1, tsustain=1,
		grate= 1, gain=1;
	var sig;
	var clk;
	tsustain = tsustain * \timeScale.kr(1);
	pos = pos + EnvGen.kr(\posEnv.kr(Env([0,1,0,1],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:tsustain, levelScale:\posEnvScale.kr(1));
	grate = grate + EnvGen.kr(\grateEnv.kr(Env([0,1,0,1],[0.1,0.4,0.1].normalizeSum)), gate, timeScale:tsustain, levelScale:\grateEnvScale.kr(1));
	clk = Impulse.ar(grate);
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\granu2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, pitch_stretch=1, pos=0, gdur=0.1, tsustain=1,
		grate= 1, gain=1;
	var sig;
	var clk;
	tsustain = tsustain * \timeScale.kr(1);
	pos = pos + EnvGen.kr(\posEnv.kr(Env([0,1,0,1],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:tsustain, levelScale:\posEnvScale.kr(1));
	pos = pos + ( LFNoise1.ar(373) * 0.01 ); 
	grate = grate + EnvGen.kr(\grateEnv.kr(Env([0,1,0,1],[0.1,0.4,0.1].normalizeSum)), gate, timeScale:tsustain, levelScale:\grateEnvScale.kr(1));
	clk = Impulse.ar(grate);
	sig = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), gdur, pan, 1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
);


(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\plop, Pbind(
	\instrument, \default,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);
PatKitDef(\sample1).targets[0]

BufDef.mono(\amen, "vipere/amenbreak.wav");
BufDef(\amen, "vipere/amenbreak.wav").numChannels
(
	// orig
Pdef(\amen, Pbind(
	\instrument, \granu,
	\bufnum, BufDef.mono(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 2*~t/(137/60),
	\pos, Prand([1],inf)*( 137/60 )/2,
	\posEnv, Pseq([
		[ Env([1,1,2,1]/10,[0.1,0.3,0.8]) ]
	],inf),
	\grateEnv, Pseq([
		[ Env([10,1,2,1],[0.01,0.01,0.18]) ]
	],inf),
	\posEnvScale, 0.04*( 137/60 ),
	\gdur, 0.1,
	\grate, 10,
	\pitch_stretch, 2,
	\grateEnvScale, 100,
	\legato, 1,
	\legato, 0.8,
	\dur, 2,
	\tsustain, Pkey(\dur)/~t,
	\gain, 0.4,
	\amp, 0.1
)).play;
)

(
	// fast
Pdef(\amen, Pbind(
	\instrument, \granu,
	\bufnum, BufDef.mono(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 2*~t/(137/60),
	\pos, Prand([1],inf)*( 137/60 )/2,
	\posEnv, Pseq([
		[ Env([0,1,2,1]/2,[0.4,0.3,0.8]) ]
	],inf),
	\grateEnv, Pseq([
		[ Env([70,1,2,1],[0.4,0.01,0.18]) ]
	],inf),
	\posEnvScale, 0.04*( 137/60 ),
	\gdur, 0.1,
	\grate, 10,
	\pitch_stretch, 2,
	\grateEnvScale, 100,
	\legato, 1,
	\legato, 0.8,
	\dur, 1/4,
	\tsustain, Pkey(\dur)/~t,
	\gain, 0.4,
	\amp, 0.1
)).play;
)

(
Pdef(\amen, Pbind(
	\instrument, \granu2,
	\bufnum, BufDef.mono(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 2*~t/(137/60),
	\pos, Prand([1],inf)*( 137/60 )/2,
	\posEnv, Pseq([
		[ Env([0,0,0,0]/2,[0.4,0.3,0.8]) ]
	],inf),
	\grateEnv, Pseq([
		[ Env([0,1,0,0],[0.4,0.01,0.18]) ]
	],inf),
	\pos, ~pmodenv.(Pseq([0,0.1,0,0.2, 0,0.2,0.3,0.6],inf)+2, 1/4),
	\grate, 40,
	\grate, ~pmodenv.(Pseq([0,0.1,0,0.2, 0,0.2,0.3,0.6],inf)*1712, 1/4),
	\posEnvScale, 0.04*( 137/60 ),
	\isRest, Pseq([
		0,0,1,1, 0,1,1,1,
	],inf).coin.not,
	\gdur, 0.1,
	\pitch_stretch, 1,
	\grateEnvScale, 100,
	\legato, 1,
	\legato, 0.8,
	\dur, 1/2,
	\tsustain, Pkey(\dur)/~t,
	\gain, 0.4,
	\amp, 0.1
)).play;
)

(
Pdef(\fadrum, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			//\instrument, \playersec,
			\bufnum, BufDef.mono('heavy/kick1.flac'),
			\bufnum, BufDef('heavy/kick1.flac'),
			\bufnum, BufDef(\amen),
			\isRest, Pseq([
				0,1, 1,1,
			],inf).coin.not,
			\pos, ~pmodenv.(Pseq([ 0,0.0042,0.001,0.002]/10,inf)+0.04+1, Pseq([2].normalizeSum/1,inf)),
			\grate, 100,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			//\grate, ~pmodenv.(Pseq([0,0.2,0.3,0.6],inf)*1317, 1/4),
			\sustain, 0.71,
			\pitch_stretch, 1,
			\dur, 1/4,
			\gain, 0.2,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.071,
			\dur, 1/8,
			\amp, 0.1,
		))
	])
).play;
)
