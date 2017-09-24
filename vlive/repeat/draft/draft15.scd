(
// adapted from a post by Neil Cosgrove (other three are original)
SynthDef(\stick, { |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, noise1, noise2;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0.9, 0.9, 0.9, 0.7, 0, 0.7, 0],
            [0.001, 0.001, 0, 0.008, 0, 0.01, 0, 0.01],
            [0, 0, 0, 00, 0, -3, 0, -4]
        )
    );

    noise1 = WhiteNoise.ar(env1);
    noise1 = HPF.ar(noise1, 600);
    noise1 = LPF.ar(noise1, XLine.kr(7200, 7000, 0.03)/2);
    noise1 = BPF.ar(noise1, 1620, 3);

    // noise 2 - 1 longer single
    env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = LPF.ar(noise2, 7600);
    noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

    snd = noise1 + noise2;
    snd = snd * 2;
    snd = snd.softclip;

    Out.ar(out, Pan2.ar(snd,pan,amp));
}).add;
);


(
~t = 140/2/60; TempoClock.default.tempo = ~t;
r = \r;
Pdef(\fadrum, 
	Ppar([
		Pbind(
			\instrument, \stick,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,1,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,1,0,
			],inf).coin.not,
			\gain, Pseq([
				0.2,
			],inf),
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,1,0,1, 1,0,1,0,
				1,0,1, 1,0,1,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2,
			\pos, 0.07,
			\gain, 0.2,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\gain, 0.5,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\pos, 0.08,
			\gain, 0.5,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('heavy/kick1.flac'),
			\bufnum, BufDef.mono('heavy/kick1.flac'),
			\bufnum, BufDef(\amen),
			\isRest, Pseq([
				0,1, 1,1,
			],inf).coin.not,
			//\pos, ~pmodenv.(Pseq([ 0,0.4042,1.001,0.002]/10,inf)+0.04+0.38, Pseq([2].normalizeSum,inf)),
			\pos, 0.45,
			\grate, 100,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\lpmix, 1,
			\hpmix, 1,
			\lpf, 9300,
			\hpf, 4300,
			\isRest, Pseq([
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,0.41,1,0.41,
				1,0.41,1,0.41,
				1,0.41,1,0.41,
				1,0.61,1,0.61,

				1,0.41,1,0.41,
				1,0.81,1,0.81,
				1,0.41,1,0.81,
				1,0.41,1,0.41,
				//1,1,1,1,
			],inf).coin.not,
			//\grate, ~pmodenv.(Pseq([0,0.2,0.3,0.6],inf)*1317, 1/4),
			\speed, 1.2,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (-0.15 * Pseq([-1,1],inf))),
			\gain, 0.15,
			\adsr, Prand([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
				[ Env.adsr(0.1,0.1,0.8,0.01) ],
			],inf),
			\sustain, 0.11/1 * Pseq([
				0.5,
				0.5,
				1,
				0.5
			],inf).stutter(2),
			\gain, Pkey(\gain) * Pseq([
				0.1,
				0.1,
				0.8,
				0.1,
			],inf).stutter(2),
			\amp, 0.1,
		)),
		PmonoArtic(\tubass,
			\octave, 3,
			\dur, 1/8,
			\note, Pseq([
				0,0,12,0, 0,0,r,0,
				r,0,r,0, r,r,r,-3,
			],inf),
			\note, Pseq([
				0,0,12,0, 0,0,r,0,
				0,r,0,r, 0,0,r,-3,
			],inf),
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\isRest, Pseq([
				1,0.2,
			],inf).coin.not,
			\lpfr, ~pmodenv.(Pseq([1/2,1,2,4],inf), 8),
			\rq, ~pmodenv.(Pseq([1/2,1,2,4]/4,inf), 3),
			\legato, Pseq([
				Pser([
					0.5,Pwhite(0.1,0.8,2),
				],16),
				1,0.4,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
		//Pbind(
		//	\instrument, \drony,
		//	\freq, 200,
		//	\isRest, Pseq([
		//		1,0,0,0, 0,0,0,0,
		//	],inf).coin.not,
		//	\legato, 4,
		//	\dur, 4,
		//	\amp, 0.1
		//),
		//Pbind(
		//	\instrument, \drony,
		//	\freq, 200,
		//	\isRest, Pseq([
		//		1,0,0,1, 1,0,0,1,
		//	],inf).coin.not,
		//	\dur, 1/8,
		//	\amp, 0.1
		//),
		//PatKitDef(\sample1).asPattern(Pbind(
		//	\kitIndex, 0,
		//	\speed, 2.4 + Pwhite(0.1,0),
		//	\sustain, 0.1,
		//	\isRest, Pseq([
		//		1,0,1,0, 0,0.2,0.51,0,
		//	],inf).coin.not,
		//	\sustain, Pseq([
		//		0.2,0.1,
		//	],inf)/2,
		//	\dur, 1/8,
		//	\amp, 0.1,
		//)),
		//PatKitDef(\sample1).asPattern(Pbind(
		//	\kitIndex, 4,
		//	\isRest, Pseq({[
		//		0,0,0,0, 1,0,0,0,
		//	].clump(8).choose}.dup(8).flat,inf).coin.not,
		//	\sustain, 0.1,
		//	\dur, 1/8,
		//	\amp, 0.1,
		//))
	])
).play;
)




(
SynthDef(\tubass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([4,1/2,4,3],[0.001,0.01,1.8]), 1);
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq * env1  /2 * [1/2,1,1.001]) * env1*0.3 )));
	sig = CombL.ar(sig, 4/~t, 1/freq * [1,1/2,1 * env1,1.01], 0.1).mean + sig;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.07));
	sig = ( sig * 4 * env1 * \dist.kr(1) ).tanh + sig /2;
	sig = LPF.ar(sig, 7000);
	//sig = sig * amp;
	sig = sig / 4;
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\tubass, Pbind(
	\instrument, \tubass,
	\degree, Pseq([0],inf),
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);

	(
	SynthDef(\drony, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = SinOsc.ar(exprand(80.0,18000!10) * ( 1 + ( SinOsc.ar(exprand(00.08,18000!4)) * 1 )));
		sig = sig.collect({ arg x; x.fold2( SinOsc.kr(1/rrand(1,10.0)).range(0.5,1) ) });
		sig = sig.mean;
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	)
	(
	SynthDef(\drony, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		sig = SinOsc.ar(exprand(80.0,18000!10) * ( 1 + ( SinOsc.ar(exprand(00.08,18000!4)) * 1 )));
		sig = sig.collect({ arg x; x.fold2( SinOsc.kr(1/rrand(1,10.0)).range(0.5,1) ) });
		sig = sig.mean;
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
	~ss.free;
	~ss = Synth(\drony);
	);


ProtoDef(\piano).startControl(Pdef(\piano))

(
Pdef(\piano, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
)).play;
);


(
SynthDef(\deldel, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(7.0) * freq, \rq.kr(0.1)) + sig;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig + DelayC.ar(sig, 0.1,EnvGen.kr(Env([1/freq/20,1/freq * \xfac.kr(1) * [1,1,1/2,1/4],1/4100],[0.1,0.8]*\timeScale.kr(1/2)), 1)) / 2;
	sig = LPF.ar(sig, 7000)/2;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\deldel, Pbind(
	\instrument, \deldel,
	\note, Pseq([0,1,2,3, Pwhite(12,24,32)],inf),
	\xfac, ~pmodenv.(Prand([1,2,4,16,2*16]/4,inf), 8),
	\rq, ~pmodenv.(Prand([1,2,4,16]/4,inf), 8),
	\lpfr, ~pmodenv.(Prand([1,2,4,16]/4,inf), 8),
	\timeScale, ~pmodenv.(Prand([1,2,4,16]/8,inf), 8),
	\octave, 5,
	\dur, 1/4 * Pstep(Pseq(1/(1..8),inf),8),
	\amp, 0.1
)).play;
);


Pdef(\fadrum, 
	Pseq([
		Pfindur(6,
			Ppar([
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\gain, 1/2,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\gain, 1/2,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,1,0,1, 0,1,1,0,
					],inf).coin.not,
					\gain, Pseq([
						0.2,
					],inf),
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq({[
						0,1,0,1, 1,0,1,0,
						1,0,1, 1,0,1,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1/2,
					\pos, 0.07,
					\gain, 0.2,
					\dur, 1/4,
					\amp, 0.1,
				)),
		PmonoArtic(\tubass,
			\octave, 3,
			\dur, 1/4,
			\note, Pseq([
				0,0,12,0, 0,0,r,0,
				r,0,r,0, r,r,r,-3,
			],inf),
			\note, Pseq([
				0,0,12,0, 0,0,r,0,
				0,r,0,r, 0,0,r,-3,
			],inf),
			\note, Pseq([
				12,0,
			],inf),
			\isRest, Pseq([
				1,0.2,
			],inf).coin.not,
			\lpfr, ~pmodenv.(Pseq([1/2,1,2,4],inf), 8),
			\rq, ~pmodenv.(Pseq([1/2,1,2,4]/4,inf), 3),
			\legato, Pseq([
				Pser([
					0.5,Pwhite(0.1,0.8,2),
				],16),
				1,0.4,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
		
			])
		),
		Pfindur(2,
			Ppar([
				Rest(2),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						1,0,0,1, 0,0,1,0,
					],inf).coin.not,
					\sustain, 0.4,
					\dur, 1/8,
					\gain, 1/2,
					\amp, 0.1,
				)),
		PmonoArtic(\tubass,
			\octave, 3,
			\dur, 4/1,
			\note, Pseq([
				0,0,12,0, 0,0,r,0,
				r,0,r,0, r,r,r,-3,
			],inf),
			\note, Pseq([
				0,0,12,0, 0,0,r,0,
				0,r,0,r, 0,0,r,-3,
			],inf),
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\isRest, Pseq([
				1,0.2,
			],inf).coin.not,
			\lpfr, ~pmodenv.(Pseq([1/2,1,2,4],inf), 8),
			\rq, ~pmodenv.(Pseq([1/2,1,2,4]/4,inf), 3),
			\legato, Pseq([
				Pser([
					0.5,Pwhite(0.1,0.8,2),
				],16),
				1,0.4,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
		
			])
		),
	],inf),
).play;


(
Pdef(\fadrum, 
	Pseq([
		Pfindur(6,
			Ppar([
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\gain, 1/2,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 5,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\gain, 1/2,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						0,1,0,1, 0,1,1,0,
					],inf).coin.not,
					\gain, Pseq([
						0.2,
					],inf),
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
				)),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq({[
						0,1,0,1, 1,0,1,0,
						1,0,1, 1,0,1,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1/2,
					\pos, 0.07,
					\gain, 0.2,
					\dur, 1/4,
					\amp, 0.1,
				)),
		PmonoArtic(\tubass,
			\degree, Pseq([
				0,
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/2,1,2,4]/2,inf), 2),
			\rq, ~pmodenv.(Pseq([1/2,1,2,4].reverse,inf), 2),
			\dur, 1/4,
		),
		
			])
		),
		Pfindur(2,
			Ppar([
				Rest(2),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 4,
					\isRest, Pseq([
						1,0,0,1, 0,0,1,0,
					],inf).coin.not,
					\sustain, 0.4,
					\dur, 1/8,
					\gain, 1/2,
					\amp, 0.1,
				)),
		PmonoArtic(\tubass,
			\octave, 3,
			\dur, 4/1,
			\note, Pseq([
				0,0,12,0, 0,0,r,0,
				r,0,r,0, r,r,r,-3,
			],inf),
			\note, Pseq([
				0,0,12,0, 0,0,r,0,
				0,r,0,r, 0,0,r,-3,
			],inf),
			\note, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
			],inf),
			\isRest, Pseq([
				1,0.2,
			],inf).coin.not,
			\lpfr, ~pmodenv.(Pseq([1/2,1,2,4],inf), 8),
			\rq, ~pmodenv.(Pseq([1/2,1,2,4]/4,inf), 3),
			\legato, Pseq([
				Pser([
					0.5,Pwhite(0.1,0.8,2),
				],16),
				1,0.4,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1,
		),
		
			])
		),
	],inf),
).play;
)


//////////////////

(
Ndef(\x, {
        var rate = 0.02;
        var n = 60;
        var cut = MouseX.kr(1, n);
        (1..n).sum { |i|
                var freq = 10000 / i;
                SinOsc.ar(freq) * Trig.kr(Impulse.kr(rate * i, 30 / freq), 0.03).max(0)
                *
                (i < cut)
        } * 0.02

}).play
)


(
Ndef(\x).reset;
Ndef(\x, {
var rate = 0.02;
var n = 60;
var cut = MouseX.kr(1, n);
var audio = ((1..n).sum { |i|
var freq = 10000 / i;
SinOsc.ar(freq) * 
Trig.kr(Impulse.kr(rate * i, 30 / freq), 0.03).max(0)
* (i < cut)
} * 0.02);
CombC.ar(audio, 0.2, Lag.ar(LFNoise0.ar(0.05),2).exprange(0.001, 0.2), LFNoise1.kr(0.075).curverange(0.01, 10, 5); )
}).play
)


(
Ndef(\x).reset;
Ndef(\x, {
	var rate = 0.02;
	var n = 60;
	var cut = MouseX.kr(1, n);
	var audio = ((1..n).sum { |i|
		var freq = 10000 / i;
		SinOsc.ar(freq) * 
		Trig.kr(Impulse.kr(rate * i, 30 / freq), 0.03).max(0)
		* (i < cut)
	} * 0.02);
	var comb= CombC.ar(audio, 0.2, Lag.ar(LFNoise0.ar(0.05),2).exprange(0.001, 0.2), LFNoise1.kr(0.075).curverange(0.01, 10, 5); );
	var in= (comb/(n+1-cut))+((SinOsc.ar(ZeroCrossing.ar(audio)*0.1)-SinOsc.ar(ZeroCrossing.ar(comb)*0.1))/cut.dbamp);
	Compander.ar(in,in,-12.dbamp,1,0);
}).play
)


b = Buffer.read(s, Platform.resourceDir +/+ "sounds/ar1.wav");
b = BufDef.mono(\amen)
b = BufDef(\amen)


(
{
var trate, dur, rate;
trate = MouseY.kr(2,200,1);
dur = 4 / trate;
rate = Dseq([10, 1, 1, 0.5, 0.5, 0.2, 0.1], inf);
TGrains.ar(2, Impulse.ar(trate), b, rate, MouseX.kr(0,BufDur.kr(b)), dur, 0, 0.1, 2);
}.scope(zoom: 4);
)
