
// play with FM

~t = 0.6; TempoClock.default.tempo = ~t;
(
SynthDef(\funfm1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var modEnv3 = EnvGen.kr(Env([1,0.3,0.1,0],[0.4,0.5,0.8], 2), 1);
	var modEnv2 = EnvGen.kr(Env([1,0.3,1,0],[0.1,3.1,0.8], -2), 1);
	var modEnv1 = EnvGen.kr(Env([0,0.3,1,0],[1.1,2.1,0.8], 2), 1);
	var mod3 = LFCub.ar(freq * [1,1.01] * \mratio3.kr( 4 )) * freq * \index3.kr(0.5) * ( modEnv3+0 );
	var mod2 = LFCub.ar(freq * \mratio2.kr( 1/2 ) + mod3) * freq * \index2.kr(2) * modEnv2;
	var mod = SinOsc.ar(freq * \mratio.kr( 1/2 ) + mod3) * freq * \index.kr(1) * modEnv1;
	sig = SinOsc.ar(freq * [1.01,1]* \cratio.kr(1) + mod + mod2);
	sig = sig + LFCub.ar(freq * \cratio2.kr(1/2) + mod3,mul:0.5);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				[0,4,7,12],
				[-3,0,4,7,12],
				[-5+12,-3,2+12,5],
				[-5+12,-1,2+12,5],
			],inf),
			\index, PmodEnv(Pseq([0.03,2],inf),8,\exp),
			//\index, 2,
			//\mratio2, 4,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\legato, 0.5,
			\mratio, 1/2,
			\octave, 5,
			\dur, 2/1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\funfm1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var modEnv3 = EnvGen.kr(Env([1,0.3,0.1,0],[0.4,0.5,8.8], 2), 1);
	var modEnv2 = EnvGen.kr(Env([1,0.3,1,0],[0.1,3.1,8.8], -2), 1);
	var modEnv1 = EnvGen.kr(Env([0,0.3,1,0],[1.1,2.1,8.8], 2), 1);
	var mod3 = LFCub.ar(freq * [1,1.01] * \mratio3.kr( 4 )) * freq * \index3.kr(0.5) * ( modEnv3+0 );
	var mod2 = LFCub.ar(freq * \mratio2.kr( 1/2 ) + mod3) * freq * \index2.kr(6) * modEnv2;
	var mod = SinOsc.ar(freq * \mratio.kr( 1/2 ) + mod3) * freq * \index.kr(1) * modEnv1;
	var bpenv;
	var osig;
	sig = SinOsc.ar(freq * [1.01,1]* \cratio.kr(1) + mod + mod2);
	sig = sig + LFCub.ar(freq * \cratio2.kr(1/2) + mod3,mul:0.5);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	osig = sig;
	4.do { arg idx;
		sig = BRF.ar(sig, freq*( idx+1 ) * LFNoise1.ar(0.1,mul:0.05,add:1),0.9 * XLine.kr(0.01,1,4));
	};
	sig = SelectX.ar(\brmix.kr(0.5), [osig, sig]);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \funfm1,
			\note, Pseq([
				[0,4,7,12],
				[-3,0,4,7,12],
				[-5+12,-3,2+12,5],
				[-5+12,-1,2+12,5],
			],inf),
			\index, PmodEnv(Pseq([0.03,2],inf),8,\exp),
			\index2, PmodEnv(Pseq([0.03,2,6],inf),8,\exp),
			\brmix, PmodEnv(Pseq([0.03,1],inf),32,\exp),
			//\index, 2,
			//\mratio2, 4,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1,1,[2,-2,-2]) ],
			],inf),
			\legato, 0.5,
			\mratio, 1/2,
			\octave, 5,
			\dur, 2/1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\chords,
	Pbind(
		\tempo, 0.6,
		\instrument, \funfm1,
		\note, Pseq([
			[-12,0,4,7,12],
			[-12,-3,0,4,7,12],
			[2-12,-5+12,-3,2+12,5],
			[2-12,-5+12,-1,2+12,5],
		],inf),
		\root, -2,
		\index, Pseg(Pseq([0.03,2],inf),8,\exp),
		\index2, Pseg(Pseq([0.03,2,6],inf),10,\exp),
		\brmix, Pseg(Pseq([0.03,1],inf),31,\exp),
		\adsr, Pseq([
			[ Env.adsr(1.4,0.1,0.8,2.5,1,[2,-2,-2]) ],
		],inf),
		\legato, 0.5,
		\mratio, 1/2,
		\octave, 5,
		\dur, 2/1,
		\amp, 0.1/2,
	)
).play;
);


(
SynthDef(\funfm1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var modEnv3 = EnvGen.kr(Env([1,0.3,0.1,0],[0.4,0.5,8.8], 2), 1) * 0 + 1;
	var modEnv2 = EnvGen.kr(Env([1,0.3,1,0],[0.1,3.1,8.8], -2), 1);
	var modEnv1 = EnvGen.kr(Env([0,0.3,1,0],[1.1,2.1,8.8], 2), 1);
	var mod3 = SinOsc.ar(freq * [1,1.01] * \mratio3.kr( 1 ) + 8) * freq * \index3.kr(0.1) * ( modEnv3*1 );
	var mod2 = SinOsc.ar(freq * \mratio2.kr( 1 ) + mod3) * freq * \index2.kr(1.00) * modEnv2;
	var mod = SinOscFB.ar(freq * \mratio.kr( 1 ) * 0.midiratio + mod3, 8.9) * freq * \index.kr(0.20) * modEnv1;
	var bpenv;
	var osig;
	sig = LFPulse.ar(freq * [1.0001,1]* \cratio.kr(1) + mod + mod2).bipolar;
	sig = sig + SinOsc.ar(freq * [1.0001,1]* \cratio.kr(1) + mod + mod2, mul:0.3);
	//sig = LFSaw.ar(freq * [1.0001,1]* \cratio.kr(1));
	sig = sig + (1.3 * sig.clip(0.3).tanh) * 0.5;
	//sig = sig + LFCub.ar(freq * \cratio2.kr(1/2) + mod3,mul:0.5);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	osig = sig;
	4.do { arg idx;
		sig = BRF.ar(sig, freq*( idx+1 ) * LFNoise1.ar(0.1,mul:0.05,add:1),0.9 * XLine.kr(0.01,1,4));
	};
	sig = SelectX.ar(\brmix.kr(0), [osig, sig]);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\chords,
	Pbind(
		\tempo, 0.6,
		\instrument, \funfm1,
		\note, Pseq([
			[-12,0,4,7,12],
			[-12,-3,0,4,7,12],
			[2-12,-5+12,-3,2+12,5],
			[2-12,-5+12,-1,2+12,5],
		],inf),
		\root, -2,
		//\index, Pseg(Pseq([0.03,2],inf),8,\exp),
		//\index2, Pseg(Pseq([0.03,2,6],inf),10,\exp),
		//\brmix, Pseg(Pseq([0.03,1],inf),31,\exp),
		\adsr, Pseq([
			[ Env.adsr(1.4,0.1,0.8,2.5,1,[2,-2,-2]) ],
		],inf),
		\legato, 0.5,
		\octave, 5,
		\dur, 2/1,
		\amp, 0.1/2,
	)
).play;
);

//////////////////

(
SynthDef(\funfmbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	var lpenv, lpfreq;
	mod = SinOsc.ar(freq * \mratio.kr(1)*[1/2,1,2],mul:[\harmLoAmp.kr(0.7),\harmMidAmp.kr(1),\harmHiAmp.kr(0.3)]).mean*440;
	sig = LFPulse.ar(freq * \cratio.kr(1) + mod).bipolar;
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = HPF.ar(sig, XLine.kr(10,100,1));
	sig = RLPF.ar(sig, ( \lpf.kr(830) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\funfmpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var modEnv3 = EnvGen.kr(Env([1,0.3,0.1,0],[0.4,0.5,8.8], 2), 1) * 0 + 1;
	var modEnv2 = EnvGen.kr(Env([1,0.3,1,0],[0.1,3.1,8.8], -2), 1);
	var modEnv1 = EnvGen.kr(Env([0,0.3,1,0],[1.1,2.1,8.8], 2), 1);
	var mod3 = SinOsc.ar(freq * [1,1.01] * \mratio3.kr( 1 ) + 8) * freq * \index3.kr(0.1) * ( modEnv3*1 );
	var mod2 = SinOsc.ar(freq * \mratio2.kr( 1 ) + mod3) * freq * \index2.kr(1.00) * modEnv2;
	var mod = SinOscFB.ar(freq * \mratio.kr( 1 ) * 0.midiratio + mod3, 8.9) * freq * \index.kr(0.20) * modEnv1;
	var bpenv;
	var osig;
	sig = LFPulse.ar(freq * [1.0001,1]* \cratio.kr(1) + mod + mod2).bipolar;
	sig = sig + SinOsc.ar(freq * [1.0001,1]* \cratio.kr(1) + mod + mod2, mul:0.3);
	//sig = LFSaw.ar(freq * [1.0001,1]* \cratio.kr(1));
	sig = sig + (1.3 * sig.clip(0.3).tanh) * 0.5;
	//sig = sig + LFCub.ar(freq * \cratio2.kr(1/2) + mod3,mul:0.5);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	osig = sig;
	4.do { arg idx;
		sig = BRF.ar(sig, freq*( idx+1 ) * LFNoise1.ar(0.1,mul:0.05,add:1),0.9);
	};
	sig = SelectX.ar(\brmix.kr(0), [osig, sig]);
	sig = LPF.ar(sig, \lpf.kr(7000));
	sig = HPF.ar(sig, \hpf.kr(200));
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\funfmpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod;
	var modEnv = EnvGen.kr(Env([0,1,0],[0.05,0.8],-2), 1);
	mod = SinOsc.ar(freq * 1 * ((0..7)/7 - 0.5 * \fspread.kr(0.002) + 1)) * freq * \index.kr(0.2) * modEnv;
	//mod = mod.clip(0.3);
	sig = SinOsc.ar(freq * [1,1.001] + mod);
	sig = sig * 0.5;
	sig = HPF.ar(sig, \hpf.kr(200));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.05,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\apart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[316].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2137].value,
			\bufnum, ~buflib.snare[2179].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11* Pseq([
				1,1,1/2,1, 
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1340].value,
			\bufnum, ~buflib.hat[981].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 1,0,1,0,
				1,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.07 * Pseq([
				1/4,1,1,1/2, 1/2,1,1,1/2,
				
			],inf),
		),
		Pbind(
			\instrument, \funfmbass,
			\note, Pseq([
				Pseq([
					0,7,0,7,
				],7),
				0,7,0,7,
			],inf) + Pstep(Pseq([0,3,-2,0],inf),1),
			\harmLoAmp, Pseg(Pseq([0,1],inf),8),
			\harmHiAmp, Pseg(Pseq([0.4,0,1],inf),7),
			\lpadsramt, PmodEnv(Pseq([0.1,8],1), 8*4).loop,
			\lpf, 200,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],24),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\lag, Pseq([
				Pseq([
					0,0,0,0,
				],3),
				[0,1/16/~t],0, 0,0,
				Pseq([
					0,0,0,0,
				],4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.2) ],
			],inf),
			\legato, 0.6,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.111,
		),
		Pbind(
			\instrument, \funfmpad,
			\note, Pstep(Pseq([
				[ 0,3,7,12 ],
				[ 0,3,7,12 ]+3,
				[ 0,4,7,12 ]-2,
				[ 0,4,7,12 ],
			],inf),1),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\brmix, PmodEnv(Pseq([0.51,0],1), 8).loop,
			\index2, PmodEnv(Pseq([0,1,2],1), 8).loop,
			\lpf, PmodEnv(Pseq([5000,7000,20000],1), 8*2,\exp).loop,
			\dur, 1,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \funfmpiano,
			\note, Pseq([
				12,0,3,0,3,0,0,0,
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\index, PmodEnv(Pseq([0.1,4],1), 8*2,\exp).loop,
			\sustain, 0.05,
			\dur, 1/8/2,
			\amp, 0.1/2,
			\out, BusDef(\piano, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\piano, \audio),
			\diffmul, 1.5,
			\addAction, \addToTail,
			\delay, 1/4/~t,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\apart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[316].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.2,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2137].value,
			\bufnum, ~buflib.snare[2179].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11* Pseq([
				1,1,1/2,1, 
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1340].value,
			\bufnum, ~buflib.hat[981].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 1,0,1,0,
				1,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.07 * Pseq([
				1/4,1,1,1/2, 1/2,1,1,1/2,
				
			],inf),
		),
		Pbind(
			\instrument, \funfmbass,
			\note, Pseq([
				Pseq([
					0,0,-7,0,
				],7)+7,
			],inf) + Pstep(Pseq([0,3,-2,0],inf),1),
			\harmLoAmp, Pseg(Pseq([0,1],inf),8),
			\harmLoAmp, 0,
			\harmHiAmp, 1,
			\harmHiAmp, 0,
			\lpadsramt, Pseg(Pseq([0.5,8],1), 8*4).loop,
			\lpf, 200,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],24),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\lag, Pseq([
				Pseq([
					0,0,0,0,
				],3),
				[0,1/16/~t],0, 0,0,
				Pseq([
					0,0,0,0,
				],4),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.05) ],
			],inf),
			\legato, 0.6,
			\octave, 3,
			\dur, 1/8/2,
			\amp, 0.111,
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.031,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		Pbind(
			\instrument, \funfmpad,
			\note, Pstep(Pseq([
				[ 0,3+12,7,12 ],
				[ 0,3,7,12 ]+3,
				[ 0,4,7,12 ]-2,
				[ 0,4,7,12 ],
			],inf),1),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\brmix, PmodEnv(Pseq([0.51,0],1), 8).loop,
			\index2, PmodEnv(Pseq([0,1,2],1), 8).loop,
			\lpf, PmodEnv(Pseq([5000,7000,20000],1), 8*2,\exp).loop,
			\dur, 1,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \funfmpiano,
			\note, Pseq([
				12,0,3,0,3,0,0,0,
				0,0,7,0,3,0,3,0,
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\index, PmodEnv(Pseq([0.1,4],1), 8*2,\exp).loop,
			\sustain, 0.05,
			\dur, 1/8/2,
			\amp, 0.1/2,
			\out, BusDef(\piano, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\piano, \audio),
			\diffmul, 1.5,
			\addAction, \addToTail,
			\delay, 1/4/~t,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pfindur(32, Pdef(\apart1)),
		Pfindur(32, Pdef(\apart2)),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[316].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.2 * Pseq([
				1,1/2,1/2,1/2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[268].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2137].value,
			\bufnum, ~buflib.snare[2179].value,
			\bufnum, ~buflib.snare[1892].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11* Pseq([
				1,1,1/2,1, 
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1340].value,
			\bufnum, ~buflib.hat[981].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 0,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.07 * Pseq([
				1/4,1/2,1,1/2, 1/2,1/2,1,1/2,
				
			],inf),
		),
		Pbind(
			\instrument, \funfmpad,
			\note, Pstep(Pseq([
				Pseq([
					[ 0,3+12,7,12 ],
					[ 0,3,7,12 ]+3,
					[ 0,4,7,12 ]-2,
					[ 0,4,7,12 ],
				],inf),
			],inf),1),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,1.1) ],
			],inf),
			\lag, 1/2/~t,
			\brmix, PmodEnv(Pseq([0.51,0],1), 8).loop,
			\index2, PmodEnv(Pseq([0,1,2],1), 8).loop,
			\lpf, PmodEnv(Pseq([5000,7000,20000],1), 8*2,\exp).loop,
			\dur, 1,
			\amp, 0.1/4,
		),
		Pbind(
			\instrument, \funfmbass,
			\note, Pseq([
				Pseq([
					0,0,-7,0,
				],7)+7,
			],inf) + Pstep(Pseq([0,3,-2,0],inf),1),
			\harmLoAmp, Pseg(Pseq([0,1],inf),8),
			\harmLoAmp, 0,
			\harmHiAmp, 1,
			\harmHiAmp, 0,
			\lpadsramt, Pseg(Pseq([0.5,8],1), 8*4).loop,
			\lpf, 200,
			\isRest, Pseq([
				Pseq([
					1,1,0,0, 0,0,1,0,
					0,0,1,0, 0,1,0,1,
				   	1,1,1,1, 0,1,1,1,
					1,0,1,0, 0,0,1,0,
					   //1,0,0,1, 1,0,0,1,
					   //1,0,0,1, 1,0,0,1,
					   //1,0,0,1, 1,0,0,1,
				],24),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.05) ],
			],inf),
			\legato, 0.6,
			\octave, 3,
			\dur, 1/8/2,
			\amp, 0.111,
		),
	])
)).play;
);


///////////


(
// guitar
SynthDef(\funfmbass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod, mod2;
	var lpenv, lpfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.051,0.1],-2), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.2],-4), 1);
	mod = SinOsc.ar(freq * \mratio.kr(1)*[1/2,1,2],mul:[\harmLoAmp.kr(0.7),\harmMidAmp.kr(1),\harmHiAmp.kr(0.3)]).mean*\modAmp.kr(441);
	mod2 = LPF.ar(LFPulse.ar(freq * \mratio2.kr(4) + mod).bipolar, \fmlpf.kr(4500)) * \modAmp2.kr(55) * env2;
	sig = SinOsc.ar(freq + mod2 + mod);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = HPF.ar(sig, XLine.kr(10,100,1));
	//sig = RLPF.ar(sig, ( \lpf.kr(830) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\funfmbassBase, 
	Ppar([
		
		Pbind(
			\instrument, \funfmbass2,
			\note, Pseq([
				Pseq([
					0,0,-7,0,
				],7)+7,
			],inf) + Pstep(Pseq([0,3,-2,0],inf),1),
			\harmLoAmp, 0.3,
			\harmHiAmp, 1,
			\harmHiAmp, 0.3,
			\lpadsramt, 2,
			\lpf, 200,
			\isRest, Pseq([
				Pser([
					1,0,0,1, 0,0,1,0,
					1,0,1,1, 0,0,1,1,
				],31*8),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.4,0.05) ],
			],inf),
			\legato, 1.0,
			\octave, 3,
			\dur, 1/8/2,
			\amp, 0.111,
		),
	])
)).play;
);


(
// tuba
SynthDef(\funfmbass3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod, mod2;
	var lpenv, lpfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.05,0.11],-2), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.4],-4), 1);
	mod = SinOsc.ar(freq * \mratio.kr(2)*[1/2,1,2],mul:[\harmLoAmp.kr(0.7),\harmMidAmp.kr(1),\harmHiAmp.kr(0.3)]).mean*\modAmp.kr(441) * env1;
	mod2 = LPF.ar(LFPulse.ar(freq * \mratio2.kr(4) + mod).bipolar, \fmlpf.kr(1500)) * \modAmp2.kr(55) * env2;
	sig = SinOsc.ar(freq + mod2 + mod);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(830) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	//sig = HPF.ar(sig, XLine.kr(10,100,1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\instrument, \funfmbass3) <> Pdef(\funfmbassBase)
	])
)).play;
);

(
// xylophone
SynthDef(\funfmbass4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod, mod2;
	var lpenv, lpfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.03,0.05],-2), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.4],-4), 1);
	mod = SinOsc.ar(freq * \mratio.kr(4)*[1/2,1,2],mul:[\harmLoAmp.kr(0.7),\harmMidAmp.kr(1),\harmHiAmp.kr(0.3)]).mean*\modAmp.kr(41) * env1;
	mod2 = LPF.ar(LFPulse.ar(freq * \mratio2.kr(4) + mod).bipolar, \fmlpf.kr(1500)) * \modAmp2.kr(55) * env2;
	sig = SinOsc.ar(freq + mod2 + mod);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(830) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	//sig = HPF.ar(sig, XLine.kr(10,100,1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\instrument, \funfmbass4) <> Pdef(\funfmbassBase)
	])
)).play;
);


(
SynthDef(\funfmbass5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod, mod2, mod3;
	var lpenv, lpfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[0.05,0.75],-2), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.01],-4), 1);
	env3 = EnvGen.kr(Env([0,1,0],[0.02,1.01],-4), 1);
	mod = SinOsc.ar(freq * \mratio.kr(2)*[1/2,1,2],mul:[\harmLoAmp.kr(0.3),\harmMidAmp.kr(1),\harmHiAmp.kr(0.3)]).mean*\modAmp.kr(1841) * env1;
	mod2 = LPF.ar(LFPulse.ar(freq * \mratio2.kr(1) + mod).bipolar, \fmlpf.kr(4500)) * \modAmp2.kr(25) * env2;
	//mod3 = LPF.ar(LFSaw.ar(freq * \mratio3.kr(1/2) + mod).bipolar, \fmlpf3.kr(4500)) * \modAmp3.kr(105) *env3;
	mod3 = SinOsc.ar(freq * \mratio3.kr(1)*[1/2,1,2],mul:[\harmLoAmp3.kr(1.3),\harmMidAmp3.kr(0.31),\harmHiAmp3.kr(0.3)]).mean*\modAmp3.kr(8) * freq * env3;
	sig = SinOsc.ar(freq * \cratio.kr(4) + mod2 + mod);
	sig = BPF.ar(sig, freq) + ( sig*0.2 );
	sig = sig + SinOsc.ar(freq * \cratio2.kr(1) + mod3 );
	sig = sig / 2;
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(830) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	//sig = HPF.ar(sig, XLine.kr(10,100,1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(\instrument, \funfmbass5) <> Pdef(\funfmbassBase)
	])
)).play;
);


(
SynthDef(\funfmbass6, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod, mod2, mod3;
	var lpenv, lpfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	mod = SinOsc.ar(freq) *( \modAmp.kr(70) * ((0..5)/5 - 0.5 * \fspread.kr(1.22) + 1).squared ).poll(label:"ds");
	sig = SinOsc.ar(freq + mod);
	sig = sig * (1..6)/6;
	//sig = sig / 3;
	//sig = [SinOsc.ar(freq), sig].mean; 

	//sig = RLPF.ar(sig, \lpf.kr(8700), \rq.kr(0.5)) * 2.4;
	sig = HPF.ar(sig, 50);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.0), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\fspread, Pseg(Pseq([0.01,40],inf),8,\exp).trace,
			//\fspread, Pseg(Pseq([1,0.01,40],inf),8,\exp).trace,
			//\fspread, 0.101,
			\modAmp, Pseg(Pseq([1,48001],inf),8,\exp),
			\modAmp, 128*1.2 * Pkey(\freq),
			\amp, 0.1/2,
		) <>
		Pbind(\instrument, \funfmbass6) <> Pdef(\funfmbassBase)
	])
)).play;
);

///////////////////


(
SynthDef(\funfmpiano2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var xenv1;
	env3 = EnvGen.kr(Env([0,1,0],[0.01,0.1], -4), 1);
	mod3 = SinOsc.ar(freq * 1) * freq*2 * env3;
	mod2 = SinOsc.ar(freq * 2 * [1,1.01] + mod3) * 2;
	mod1 = SinOsc.ar(freq, mod2) * 1;
	sig = SinOsc.ar(freq, mod1 % 2pi);

	// attack
	xenv1 = SinOsc.ar(freq*1/2) + 1;
	xenv1 = EnvGen.kr(Env([0,1,0],[0.01,0.2], -3), 1) + 0.2;
	sig = sig + ( LFSaw.ar(freq + ( mod1 * \modAmp.kr(33) )) * xenv1 * 0.8 );


	sig = sig * 0.3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\funfmpianoBase, 
	Ppar([
		Pbind(
			\instrument, \funfmpiano2,
			\note, Pseq([
				0,4,7,4,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,3,
			],inf),2),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \funfmpiano2,
			\note, Pseq([
				10,0,4,7
			],inf),
			\ctranspose, Pstep(Pseq([
				0,3,
			],inf),2),
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \funfmpiano2,
		\amp, 0.07,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,1.1) ],
		],inf),
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))


(
SynthDef(\funfmpiano3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var xenv1;

	xenv1 = EnvGen.kr(Env([0,1,0],[0.01,0.1], -4), 1);
	mod2 = SinOsc.ar(freq * 1/2) * 0.51 * EnvGen.kr(Env([0,1,0],[0.4,1.1]), 1);
	mod1 = SinOsc.ar(freq) * 0.2;
	sig = SinOsc.ar(freq, mod1 + mod2); 
	//sig = mod1 * 10;
	sig1 = SinOsc.ar(freq * XLine.ar(2,1,0.002)) * xenv1; 
	sig = [ sig1 * 6, sig ].mean;
	sig = sig.tanh;

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \funfmpiano3,
			\note, Pseq([
				9,12,16,
				7,12,16,
				5,12,16,
				7,12,16,
			].clump(3).collect({ arg x; x.dup }).flat.debug("quoi"),inf),
			\dur, 1/6,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,1.1) ],
			],inf),
		) 
	])
)).play;
);

ProtoDef(\piano).startControl(\funfmbass2)

(
SynthDef(\funfmpiano4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var xenv1;
	env3 = EnvGen.kr(Env([0,1,0],[0.01,0.1], -4), 1);
	env4 = EnvGen.kr(Env([0,1,0],[0.3,1.3], -4), 1);
	env2 = EnvGen.kr(Env([0.1,4,5],[1.1,0.8],-2), 1);
	mod4 = SinOsc.ar(freq * 1) * freq*4 * ( env4 * 0.5 + 1 );
	mod3 = SinOsc.ar(freq * 1) * freq*2 * env3;
	mod2 = SinOsc.ar(freq * 1 * [0.99,1,1.01] + mod3) * env2;
	mod1 = SinOsc.ar(freq, mod2) * 1* \modAmp.kr(33);
	sig = SinOsc.ar(freq* [1.001,2,1], mod1 % 2pi);
	sig = sig + SinOsc.ar(freq*2+ mod4,mul:env3*0.5); 

	// attack
	xenv1 = SinOsc.ar(freq*1/2) + 1;
	xenv1 = EnvGen.kr(Env([0,1,0],[0.01,0.2], -3), 1) + 0.2;
	sig = sig + ( LFSaw.ar(freq + ( mod1 * 33 )) * xenv1 * 0.8 );

	sig = sig + DelayC.ar(sig, 0.1,0.01);

	sig = sig * 0.7;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \funfmpiano4,
			\note, Pseq([
				9,12,16,
				7,12,16,
				5,12,16,
				7,12,16,
			].clump(3).collect({ arg x; x.dup }).flat.debug("quoi"),inf),
			\dur, 1/6,
			\adsr, Pseq([
				[ Env.adsr(0.051,0.1,0.8,1.1) ],
			],inf),
		) 
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \funfmpiano4,
			\note, Pseq([
				0, 1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \funfmpiano4,
			\note, Pseq([
				[0,7,12,12+5],
				[0,7,12,12+4],
				[-1,7,11,12+4],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,2.1) ],
			],inf),
			\octave, 4,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


///////////////////////

(
SynthDef(\acidline, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	sig = LFSaw.ar(freq * [1,1 + \diff.kr(0.001)]);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), Trig1.kr(\itrig.tr, \tdur.kr(1/8)), doneAction:0) * \lpadsramt.kr(1) + 1;
	freq = freq.lag(\freqlag.kr(0.1));
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1).lag(\gainlag.kr(0.01));
	sig = Splay.ar(sig, \spread.kr(0.2), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\acidline,
			\note, Pseq([
				rrand(0,12!8),
			].flat,inf),
			\lpf, PmodEnv(Pseq([100,800,9444],1), 8).loop,
			\lpadsramt, Pwhite(0.7,8).stutter(8*8),
			\octave, Pseq([
				Plazy({ arg ev;
					Pseq([
						Pseq(8.collect { arg item, idx;
							[3,4,4,4,4,5].choose
						},6),
						Pseq(16.collect { arg item, idx;
							[3,4,4,4,4,5].choose
						})
					],1)
				}).loop,
			],inf),
			\itrig, 1,
			\tdur, 1/16/~t,
			\dur, 1/8,
			\amp, 0.1 * Pseq([
				Plazy({ arg ev;
					Pseq(8.collect { arg item, idx;
						[1,0.5,2,1.25,0.75, 1,1,1,1,1,1,1,1,1,1,1,1,1].choose;
					},8)
				}).loop,
			],inf),
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[316].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.2,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2137].value,
			\bufnum, ~buflib.snare[2179].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11* Pseq([
				1,1,1/2,1, 
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1340].value,
			\bufnum, ~buflib.hat[981].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 1,0,1,0,
				1,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.07 * Pseq([
				1/4,1,1,1/2, 1/2,1,1,1/2,
				
			],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\acidline,
			\note, Pseq([
				0,0,0,3,
				5,5,5,4,
			].flat,inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,800,9444],1), 8).loop,
			\lpadsramt, Pwhite(0.7,8).stutter(8*8),
			\octave, Pseq([
				Plazy({ arg ev;
					Pseq([
						Pseq(8.collect { arg item, idx;
							[3,5,4].choose([ 4,0.1,0.1 ].normalizeSum)
						},6),
						Pseq(16.collect { arg item, idx;
							[3,4,4,4,4,5].choose
						})
					],1)
				}).loop,
			],inf),
			\itrig, 1,
			\tdur, 1/16/~t,
			\dur, 1/8/2 * (1 + (0.06 * Pseq([1,-1],inf))),
			\isRest, Pseq([
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,1, 1,1,
				1,0, 1,0, 1,0, 1,0,
				1,0, 1,0, 1,1, 0,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				Plazy({ arg ev;
					Pseq(8.collect { arg item, idx;
						[1,0.5,2,1.25,0.75, 1,1,1,1,1,1,1,1,1,1,1,1,1].choose;
					},8)
				}).loop,
			],inf),
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[316].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.2,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2137].value,
			\bufnum, ~buflib.snare[2179].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11* Pseq([
				1,1,1/2,1, 
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1340].value,
			\bufnum, ~buflib.hat[981].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 1,0,1,0,
				1,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.07 * Pseq([
				1/4,1,1,1/2, 1/2,1,1,1/2,
				
			],inf),
		),
		Pbind(
			\instrument, \funfmpiano,
			\note, Pseq([
				0,0,0,0,
				0,5,0,5,
			],inf),
			\index, PmodEnv(Pseq([0.1,2],1), 8).loop,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\acidline,
			\note, Pseq([
				0,0,1,0,
				2,1,-1,0,
			].flat,inf).stutter(2),
			\lpf, PmodEnv(Pseq([1,2,4]*100,1), 8).loop,
			\lpadsramt, 17,
			\octave, Pseq([
				3
			],inf),
			\itrig, 1,
			\tdur, 1/16/~t,
			\dur, 1/8/2 * (1 + (0.06 * Pseq([1,-1],inf))),
			\gain, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
					1,1,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,1,1,1, 1,0,1,0,
				],inf),
				Pseq([
					Ppatlace([
							[
							Pseg(Prand([1,0],inf),Pwhite(1,5,inf)*2),
							Pseg(Prand([1,0],inf),Pwhite(1,5,inf)*2),
							].dup(4)
					].flat)
				],inf),
				Pseq([
					Ppatlace([
							[
							Pseg(Pwhite(0.6,1,inf),Pwhite(1,5,inf)*2),
							Pseg(Pwhite(0.0,0.41,inf),Pwhite(1,5,inf)*2),
							].dup(4)
					].flat)
				],inf),
				Pseq([
					1,0,1,1, 1,0,1,1,
					1,0.2,1,1, 1,0.2,1,1,
				],inf),


				1,0,0,1, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,1,1, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				1,0,0,1, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,0,1,1,
			],inf),
			\amp, 0.1 * Pseq([
				Pseq([
					0.5,
					1
				],1).stutter(2),
				//Plazy({ arg ev;
					//Pseq(8.collect { arg item, idx;
						//[1,0.5,2,1.25,0.75, 1,1,1,1,1,1,1,1,1,1,1,1,1].choose;
					//},8)
				//}).loop,
			],inf),
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[316].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.2,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2137].value,
			\bufnum, ~buflib.snare[2179].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11* Pseq([
				1,1,1/2,1, 
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1340].value,
			\bufnum, ~buflib.hat[981].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 1,0,1,0,
				1,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.07 * Pseq([
				1/4,1,1,1/2, 1/2,1,1,1/2,
				
			],inf),
		),
		Pbind(
			\instrument, \funfmpiano2,
			\note, Pseq([
				[0,-4],
				[0,2],
				[-1,-3],
			],inf).stutter(4),
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\acidline,
			\note, Pseq([
				0,0,1,0,
				2,1,-1,0,
			].flat,inf).stutter(2),
			\lpf, PmodEnv(Pseq([1,2,4]*100,1), 8).loop,
			\lpadsramt, 17,
			\octave, Pseq([
				3
			],inf),
			\itrig, 1,
			\tdur, 1/16/~t,
			\dur, 1/8/2 * (1 + (0.06 * Pseq([1,-1],inf))),
			\gain, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
					1,1,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,1,
					1,1,1,1, 1,0,1,0,
				],inf),
			],inf),
			\amp, 0.1 * Pseq([
				Pseq([
					0.5,
					1
				],1).stutter(2),
				//Plazy({ arg ev;
					//Pseq(8.collect { arg item, idx;
						//[1,0.5,2,1.25,0.75, 1,1,1,1,1,1,1,1,1,1,1,1,1].choose;
					//},8)
				//}).loop,
			],inf),
			\out, BusDef(\basstrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.051,
			\pregain, 1,
			\cpabove, 0.01,
			\cpbelow, 1,
			\cpclamp, 0.01,
			\cprelax, 0.1,
			\gain, 1,
			\dur, 1,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[316].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,1,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.2,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2137].value,
			\bufnum, ~buflib.snare[2179].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.11* Pseq([
				1,1,1/2,1, 
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1340].value,
			\bufnum, ~buflib.hat[981].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 1,0,1,0,
				1,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8/2,
			\gain, 0.07 * Pseq([
				1/4,1,1,1/2, 1/2,1,1,1/2,
				
			],inf),
		),
		Pbind(
			\instrument, \funfmpiano3,
			\spread, 0.20000001192093,
			\note, Pseq([
				Pser([ 3,7, ],8*4),
				Pser([ 3,6, ],8*4),
				Pser([ 0,5, ],8*4),
				Pser([ 0,3, ],8*4),
			],inf).stutter(1),
			\modAmp, PmodEnv(Pseq([1,40],1), 8*2).loop,
			\legato, Pseg(Pseq([0.1,1],inf),8*2),
			\dur, 1/8,
			\amp, 0.1/2,
			\octave, 6,
			\out, BusDef(\piano, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\piano, \audio),
			\diffmul, 1.1,
			\decay,1,
			\delay, 1/8/~t,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \funfmpiano4,
			\modAmp, Pseg(Pseq([3,10],1), 8*2).loop,
			\note, Pseq([
				//7,6,5,4,
				12,11,10,9, 8,7,6,5,
			].flat,inf).stutter(1),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				//1,1,1,1, 1,1,1,1,
				//1,0,1,1, 1,1,1,0,
				1, Pseq([0.6],7),
			],inf).coin.not,
			\freq, PmodEnv(Pseq([60.midicps,55.midicps]*4,1), 1).loop,
			\dur, 1/8,
			\octave, Pseq([
				Plazy({ arg ev;
					Pseq(4.collect({ arg x; [5,4].choose }))
				})
			],inf),
			\octave, 5,
			\amp, 0.1/4,
		),
	])
)).play;
);

//////////
// try funk bass


~t = 185/4/60; TempoClock.default.tempo = ~t;
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \funfmbass2,
			\note, Pseq([
				5,\r,\r,8, \r,9,\r,10,
				\r,\r,\r,\r, \r,\r,\r,\r,
			],inf),
			\octave, 3,
			\sustain, 0.1 * Pseq([2,1,1,1,],inf),
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[22].value,
			\bufnum, ~buflib.kick[370].value,
			//\bufnum, ~buflib.kick[875].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				1,1,0,0, 0,0,0,0,
				0,1,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[289].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1096].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,1,0,1,1,0,
				0,1,1,0,1,0,1,1,
			],inf).coin.not,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.11 * Pseq([
				1,1,1,1/2, 1/2,1,1/2,1,
				1,1/2,1,1/2, 1,1,1/2,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2190].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				1,0,0,1, 0,0,1,1,
			],inf).coin.not,
			\sustain, 0.1/2 * Pser([1,1,2],16).loop,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2138].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[410].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.04,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
			\pos, 2.38 + Pseq([0,0.01,0.2],inf),
			\sustain, 0.05,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				0.5,0.5,1
			],inf),
			\hpf, 7000,
			\hpmix, 1,
		),
		Pbind(
			\instrument, \funfmpiano3,
			\note, Pseq([
				[5,13]+.x[0,12]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0.1,0.1, 1,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\sustain, 1/8/~t * Pseq([
				1,1,1,1, 1,1,1,1,
				1,1/4,1/4,1/4, Pwhite(0.01,2,1),1,1,1,
				
			],inf),
			\dur, 1/8,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\amp, 0.1/2,
		),
	])
)).play;
);


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
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Bernard Purdie - Funky Donkey (part3).wav'),
			\legato, 1,
			\st, 177/4/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					4,0,
					//3,5,
					//6,7,
					//8,1,
				],inf)/8+0,
				
			],inf) / Pkey(\st),
			\isRest, Pseq([
				1,1,1,1, 1,1,0,1,
				0,0,1,0, 0,1,0,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1/2,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[258].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1243].value,
			\bufnum, ~buflib.kick[1044].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1 * Pseq([
				1,1,1,1, 1,1,1,1/2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[135].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,1,0,0, 1,0,0,1,
				0,1,0,1, 1,0,0,1,
				0,1,0,0, 1,0,1,0,
				0,1,0,0, 1,0,0,1,
				//0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11 * Pseq([
				1,1,1,1/2, 1,1,1,1,
			],inf),
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[4].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[316].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,0,1,
				0,0,0,1, 0,0,0,0,

				0,1,0,1, 0,1,0,1,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
				0,1,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\isRest, Pseq([
				//0,0,0,0, 1,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.11,
			//\isRest, true,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[12].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[888].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,0.4,0.6,0.9,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1299].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8/2,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1355].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \funfmbass3,
			\mratio, 2.0,
			\harmLoAmp, 0.69999998807907,
			\harmMidAmp, 1.0,
			\harmHiAmp, 0.30000001192093,
			\modAmp, 441.0 * Pseg(Pseq([0.1,1],inf),8),
			\mratio2, 4.0,
			\fmlpf, 1500.0,
			\modAmp2, 55.0 * Pseg(Pseq([4,2],inf),8),
			\lpadsramt, 1.0,
			\note, Pseq([
				0,2,2,2, 2,2,2,2,
				2,2,2,2, 2,2,2,2,
			],inf) + Pstep(Pseq([0,0,5,-5],inf),2),
			\isRest, Pseq([

				1,0.1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,0.1,0.1,
				//1,1,1,0, 0,1,1,1,
			],inf).coin.not,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.05,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1485].value,
			\bufnum, ~buflib.snare[2095].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				//0,0,1,0, 0,0,1,0,
				//1,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \funfmbass3,
			\mratio, 2.0,
			\harmLoAmp, 0.69999998807907,
			\harmMidAmp, 1.0,
			\harmHiAmp, 0.30000001192093,
			\modAmp, 441.0 * Pseg(Pseq([0.1,1],inf),8),
			\mratio2, 4.0,
			\fmlpf, 1500.0,
			\modAmp2, 55.0 * Pseg(Pseq([4,2],inf),8),
			\lpadsramt, 1.0,
			\note, Pseq([
				0,2,2,2, 0,2,2,2,
				0,2,2,2, 7,2,6,5,
			],inf),
			\isRest, Pseq([

				1,0.51,1,1, 1,1,1,1,
				1,1,1,0.1, 1,0,1,0,
				//1,1,1,0, 0,1,1,1,
			],inf).coin.not,
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.05,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);
