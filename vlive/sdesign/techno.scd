(
SynthDef(\tsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	sig = LFSaw.ar(freq * [1,1.003,1/2,2], Rand(0,2));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.1,0.8,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = HPF.ar(sig,\hpf.kr(490));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.4), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\massdel, { arg out=0, gate=1;
	var sig;
	var osig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.9) + in;
	osig = sig;
	sig = DelayL.ar(sig, 1/~t, \delay.kr(1/8/~t)).reverse;
	sig = HPF.ar(sig, \hpf.kr(4000));
	LocalOut.ar(sig);
	sig = sig + osig;
	sig = GVerb.ar(sig,80,3.1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(

Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tsaw,
			\lpf, PmodEnv(Pseq([Pn(100,3),100,2000,400,124,Pwhite(100.0,340,5)],1), 2).loop,
			\lpadsramt, 4,
			\note, Pseq([
				Pn(0,8*14),Pn(2,8),Pn(1,8),
			],inf),
			\rq, 0.4,
			\legato, 0.5,
			\octave, 4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\massdel,
			\inbus, BusDef(\pfx1, \audio),
			\out, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\gain, 1/3,
			\dur, 1,
		),
		Pmono(\massdel,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\delay, 0.224,
			\lag, 0.0009,
			\gain, 1/3,
			\dur, 1,
			//\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\pfx3, \audio),
		),
		ProtoDef(\pequi, \Equi).proxy <> Pbind(\inbus, BusDef(\pfx3, \audio)),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1238].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\lag, -0.04,
			//\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[673].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,Pwhite(0.2,1,1)
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1608].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.07,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

Pdef(\pequi).edit
ProtoDef(\pequi, \Equi).edit
