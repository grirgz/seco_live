
~t = 154/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[139].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[255].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1852].value,
			//\bufnum, ~buflib.snare[1832].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
SynthDef(\formant, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1) * \fenvamt.kr(9) + 1;
	env2 = EnvGen.kr(Env([0,1,0],[0.4,0.8]), 1) * \fenvamt2.kr(1) + 1;
	sig = Formant.ar(freq, 70 * env1,freq * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \formant,
			\note, Pseq([
				0,1,-3,-6,
			],inf).stutter(4),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				4,0,0,0, 1,1,2,0,
			],inf)*0.5,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\formant, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fenv.kr(Env([0,1,0],[0.1,0.8])), 1) * \fenvamt.kr(1) + 1;
	env2 = EnvGen.kr(\bwenv.kr(Env([0,1,0],[0.1,0.8])), 1) * \bwenvamt.kr(1) + 1;
	sig = Formant.ar(freq, \formfreq.kr(120) * env1, \bwfreq.kr(195) * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \formant,
			\note, Pseq([
				0,1,-3,-6,
			],inf).stutter(4),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\formfreq, PmodEnv(Pseq([10,800],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\formant2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1) * \fenvamt.kr(1) + 1;
	env2 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1) * \bwenvamt.kr(1) + 1;
	freq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1);
	sig = Formant.ar(freq, \formfreq.kr(120) * env1, \bwfreq.kr(195) * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \formant2,
			\note, Pseq([
				0,1,-3,-6,
			],inf).stutter(4),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\formfreq, 300,
			\formfreq, PmodEnv(Pseq([1040,180],1), 8).loop,
			\fspread, PmodEnv(Pseq([0.0051,0.04],1), 8).loop,
			\bwfreq, PmodEnv(Pseq([400,502],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\formant3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.01,0.8]), 1) * \fenvamt.kr(2) + 1;
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.8]), 1) * \bwenvamt.kr(2) + 1;
	env3 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1) * \fenvamt2.kr(1) + 1;
	env4 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1) * \bwenvamt2.kr(1) + 1;
	env5 = EnvGen.kr(Env([0,1,0],[0.1,0.8]), 1) * \lpenvamt.kr(4) + 1;
	//freq = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1);
	sig = Formant.ar(freq, \formfreq.kr(120) * env1, \bwfreq.kr(195) * env2);
	sig = ( sig*\distamp.kr(8) ).tanh * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, ( \lpfr.kr(0.7) * freq * env5 ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \formant,
			\note, Pseq([
				//0,1,-3,-6,
				[0,4,7,0+12],
				[0,4,7-12,0+12]+5,
				[1,4,7-12,1+12]+5,
				[0,4,7-12,0+12]+7,
			],inf).stutter(8*2),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\formfreq, PmodEnv(Pseq([100,400],1), 8).loop,
			\bwfreq, PmodEnv(Pseq([100,800],1), 8).loop,
			\fenvamt, 1.1,
			\fenv, [
				Env([0,0,1],[0.1,7.08])
			],
			\bwenv, [
				Env([0,0,1],[0.1,7.08])
			],
			//\formfreq, PmodEnv(Pseq([140,780],1), 8).loop,
			//\fspread, PmodEnv(Pseq([0.0051,0.04],1), 8).loop,
			//\bwfreq, PmodEnv(Pseq([1400,152],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.5) ],
			],inf),
			\octave, 4,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pdef(\drums1),
	])
)).play;
);

(
SynthDef(\grainbuf, { arg out=0, gate=1;
	var sig;
	var gdur, trig;
	var phase;
	trig = Impulse.kr(9);
	gdur= 0.2;
	phase = Phasor.kr(1,1/s.sampleRate) + LFNoise0.kr(1);
	sig = GrainBuf.ar(2, trig, gdur, \mbufnum.kr(0), rate: LFNoise1.kr(1), pos:phase);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

BufDef(\amen, "vipere/amenbreak.wav");
BufDef(\moeten, "voices/02_moeten.flac")
BufDef(\crepe, "field/crepe.flac");
BufDef(\oeuf, "field/oeuf.flac");
BufDef(\ukraine, "bruit1/07_ukraine.flac");
BufDef(\table, "field/table.flac");
BufDef(\scream, "vipere/scream.flac");
BufDef(\rocksteady, "vipere/rocksteady.flac");
BufDef(\metal, "vipere/metal.flac");
BufDef(\bomb, "vipere/bomb.flac");
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \grainbuf,
			\mbufnum, BufDef.mono(\amen),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\grandelay, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * SinOsc.ar(300);
	GrainBuf
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
var winenv;

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef(\buf_grain_test, { |out, gate = 1, amp = 1, sndbuf, envbuf|
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: Done.freeSelf);
    Out.ar(out,
        GrainBuf.ar(2, Impulse.kr(10), 0.1, sndbuf, LFNoise1.kr.range(0.5, 2),
            LFNoise2.kr(0.1).range(0, 1), 2, pan, envbuf) * env)
}).add;
)

// use built-in env
x = Synth(\buf_grain_test, [\sndbuf, b, \envbuf, -1])

// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);

