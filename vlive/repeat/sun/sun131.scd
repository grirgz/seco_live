// metal gear computer area

(
~t = 150/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("sndlib/synthbasic.scd")
)

(
SynthDef(\stringpadf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2));
	freq = freq * \ffac.kr(1);
	sig4 = LFSaw.ar(freq * LFNoise1.kr(0.1!4,mul:0.01,add:1),Rand(0,2));

	sig = LFSaw.ar(freq,0);
	sig2 = LFSaw.ar(freq * LFNoise1.kr(0.1!4,mul:0.012 * LFTri.kr(0.3,mul:0.3,add:1),add:1),1);
	sig1 = IEnvGen.ar(Env([0,1,-1,0],[0.5,0,0.5],[8,0,-8]), sig.unipolar);
	sig = SelectX.ar( LFTri.kr(0.3).unipolar, [sig1, sig2]);
	sig = LPF.ar(sig, ( freq*6 ).clip(20,20000));

	sig = sig4 + sig;
	//sig = sig;

	//sig = sig + ( LFSaw.ar(freq) * SinOsc.ar(freq*2+0.1) );
	sig = LeakDC.ar(sig);
	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.05,5,1.8,3.4,curve:-3)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(1720) * ( freq * \kbamt.kr(0.1) +1 ) * (env1 * \lpenvamt.kr(2.2) + 1)).clip(20,20000), \rq.kr(0.3) );
	//sig = LPF.ar(sig,4000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.45,5,1.2,0.8,0.8,curve:-3)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

////////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[820].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[186].value,
			\bufnum, ~buflib.hat[13].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 0,0,1,1,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 2000,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\string, \audio),
		),
		Pbind( // pre ramp
			\instrument, \sh101,
			\note, Pseq([
				4,6,
			],inf),
			\lpf, 2000,
			\rq, 0.9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\string, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\string, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\inbus, BusDef(\string, \audio),
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, 1000,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\octave, 3,
			\amp, 0.1,
			//\isRest, true,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[820].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,1, 1,0,1,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[186].value,
			\bufnum, ~buflib.hat[13].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,1, 1,0,1,1,
					1,0,1,1, 1,0,1,1,
					1,0,1,1, 1,0,1,1,
					1,0,0,0, 1,1,1,1,
				],8*2*3),
				0,0,1,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,1, 0,0,1,1,
					1,0,1,1, 1,0,1,1,
				],3),
				0,0,1,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 2000,
			\envamt, PmodEnv(Pseq([1,2,8],1), 32).loop,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\string, \audio),
		),
		Pbind( // pre ramp
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 4,6, ],16*4),
				Pser([ 2,9, ],16*4),
			],inf),
			\lpf, 2000,
			\rq, 0.9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,1,1,0,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8*4),
			],inf).coin.not,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\string, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\string, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\gain, 0.8,
			\dur, 1,
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 32,\exp).loop,
			\envamt, 4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],8*6),
				Pser([
					0,0,0,0, 1,1,0,0,
					0,1,0,1, 0,0,1,1,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\inbus, BusDef(\string, \audio),
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, 1000,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,0,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\octave, 3,
			\amp, 0.1,
			//\isRest, true,
		),
	])
)).play;
);


~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

SynthDef(\rdn_rumble, { arg out=0, gate=1;
	// code: 5-81EA-QELK
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 866996.0;
	si = sig;
	sig = { arg si, env;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					}.value(si, env);

				].mean;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			}.value(si, env);

		].mean;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.68243243243243,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.79279273894506,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 1.2492192141522,
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
)

		
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kick, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kick, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1000,24,20],1), 16,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\rdn_rumble,
			\inbus, BusDef(\hichain, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		)
		<> Pbind(
			'wet10', 1.0,
			'mix', 0.7436974789916,
			'gain', 0.48243243243243,
			'fb', 0.0001,
			'delay', 0.0001,
			'delay2', 0.00079279273894506,
			//'delay2', PmodEnv(Pseq([0.7,0.69,0.1,0.0001,0.00001],1), 8,\exp).loop,
			'delay2', PmodEnv(Pseq([0.0007,0.041,0.0007],1), Pseq([7.8,0.1,0.1]/8),\exp).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 1.2492192141522,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 10,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\out, BusDef(\hichain2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hichain2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, Pseq([
				0.2,0.2,2,1,
			],inf).stutter(8),
			\dur, 1,
			\out, BusDef(\hichain3, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hichain3, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			'hpf', PmodEnv(Pseq([7000,1000,2,2,2],1), 8,\exp),
			\gain, 0.4,
			\dur, 1,
		).loop,
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[186].value,
			\bufnum, ~buflib.hat[13].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,1, 
				],6),
				0,0,1,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 2000,
			\envamt, PmodEnv(Pseq([1,2,8],1), 32).loop,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\string, \audio),
		),
		Pbind( // pre ramp
			\instrument, \sh101,
			\note, Pseq([
				Pser([ 4,6, ],16*4),
				Pser([ 2,9, ],16*4),
			],inf),
			\lpf, 2000,
			\rq, 0.9,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,1,1,0,
				],8*4),
				Pser([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],8*4),
			],inf).coin.not,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\string, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\string, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\gain, 0.8,
			\dur, 1,
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, PmodEnv(Pseq([100,4000],1), 32,\exp).loop,
			\envamt, 4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],8*6),
				Pser([
					0,0,0,0, 1,1,0,0,
					0,1,0,1, 0,0,1,1,
				],8*2),
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hichain, \audio),
		),
	])
)).play;
);


(
// nice
Pdef(\part, Pdef(\partnice, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Ptpar([
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1753].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			24,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[186].value,
				\bufnum, ~buflib.hat[13].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,1, 0,0,1,1,
					1,0,1,1, 1,0,1,1,
					1,0,1,1, 1,0,1,1,
					1,1,1,1, 0,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11/2,
			),
		]),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400],1), 16,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
		Pbind( // double
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*4,1), 16,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
			\out, BusDef(\hic2, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\hic, \audio),
			\delay, 1/7/~t,
			\decay, 1.8,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hic2, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hic2, \audio),
			\delay, 1/~t,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hic3, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\hic3, \audio),
			\addAction, \addToTail,
			\hpf, 1000 * Pseq([1,1/2,1/3,2],inf),
			\lpf, Pseq([
				1000,4000,6000,3000,
			],inf),
			\hpf, PmodEnv(Pseq([5000,2000,10],1), 16,\exp),
			\lag, 0.0009,
			\dur, 4,
		).loop,
	])
)).play;
);



(
SynthDef(\whitenoise, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar(1);
	sig = HPF.ar(sig, (\hpf.kr(10) ).clip(1,20000));
	sig = LPF.ar(sig, ( \lpf.kr(20000) ).clip(1,20000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\whitenoiseam, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(\fmf.kr(1*~t)) * \fma.kr(1) + 1;
	sig = WhiteNoise.ar(1);
	sig = HPF.ar(sig, (\hpf.kr(10) ).clip(1,20000));
	sig = LPF.ar(sig, ( \lpf.kr(20000) * lfo1 ).clip(1,20000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\sonarcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	env1 = EnvGen.kr(Env([15000,10,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([1500,70,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\xcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([15000,1000,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([1500,70,1],[0.06,0.8]), 1);
	mod1 = LFSaw.ar(800, pi/2 * 0.4) * 3811; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(100));
	sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.8));
	env3 = EnvGen.kr(Env([1,2,1],[0.01,1.8]), 1);
	sig1 = DelayL.ar([ sig ], \maxdelay.kr(0.4), \delay.kr(0.01) * ((0..7)/7 - 0.5 * \dspread.kr(0.001) + 1) * env3).mean;
	sig1.debug("sig1");
	sig = SelectX.ar(\delmix.kr(0.5), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\xcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([15000,6000,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([4500,470,1],[0.06,0.1]), 1);
	env4 = EnvGen.kr(Env([11500,70,1],[0.06,0.1]), 1);
	mod1 = LFSaw.ar(990, pi/2 * 0.4) * env4; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(600));
	//sig = sig * EnvGen.kr(Env([0,1,0],[0.005,0.08]), 1);
	sig = Pan2.ar(sig, pan, amp);
	env3 = EnvGen.kr(Env([1,2,1],[0.01,1.8]), 1);
	//sig1 = CombL.ar(sig, 4/~t, 0.0051 * env3 * LFNoise1.ar(44,mul:0.2,add:1),0.2/~t);
	sig1 = CombL.ar(sig, 4/~t, 0.0051 * env3 * SinOsc.ar(44,mul:0.4,add:1),0.2/~t);
	sig1.debug("sig1");
	sig = SelectX.ar(\delmix.kr(0.5), [sig, sig1]);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(2), \damp.kr(0.8));
	sig = sig * 4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\xcrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([15000,6000,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([4500,470,1],[0.06,0.1]), 1);
	env4 = EnvGen.kr(Env([31500,70,1],[0.06,3.1]), 1);
	mod1 = LFSaw.ar(1990, pi/2 * 0.4) * env4; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(600));
	//sig = sig * EnvGen.kr(Env([0,1,0],[0.005,0.08]), 1);
	sig = Pan2.ar(sig, pan, amp);
	env3 = EnvGen.kr(Env([1,2,1],[0.01,1.8]), 1);
	//sig1 = CombL.ar(sig, 4/~t, 0.0051 * env3 * LFNoise1.ar(44,mul:0.2,add:1),0.2/~t);
	sig1 = CombL.ar(sig, 4/~t, 0.0051 * env3 * SinOsc.ar(1,mul:0.4,add:1),3.2/~t);
	sig1.debug("sig1");
	sig = SelectX.ar(\delmix.kr(0.5), [sig, sig1]);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(2), \damp.kr(0.8));
	sig = sig * 4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \xcrash,
			\freq, 200,
			\dur, 8,
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
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Ptpar([
			0, Pbind(
				\instrument, \sonarcrash,
				\freq, 200,
				\dur, 1,
				\legato, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					Pser([
						0
					],8*7),
				],inf).coin.not,
				\amp, 0.1,
			),
			0, Ppar([
				Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\hpf, PmodEnv(Pseq([20000,5000],1), 4,\exp),
					\dur, Pn(4.5,1),
					\amp, 0.1/2,
				),
			]),
			3, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1753].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\pos, 0.2,
					\speed, -1,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],1).coin.not,
					\legato, 2,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 0.11,
					\out, BusDef(\revsnare, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\revsnare, \audio),
					\addAction, \addToTail,
					\room, 2,
					\damp, 1,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.1,1,1) ],
					],inf),
					\lag, 0.0009,
					\dur, Pn(1/2,3),
				),
			]),
			4, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1753].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
			4, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[186].value,
					\bufnum, ~buflib.hat[13].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						0,0,1,1, 0,0,1,1,
						1,0,1,1, 1,0,1,1,
						1,0,1,1, 1,0,1,1,
						1,1,1,1, 0,1,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.11/2,
					\out, 
					Pstep(Pseq([
						BusDef(\hat, \audio),
						//Pn(0,inf)
					],inf),8),
				),
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hat, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\fb, 1/2,
					\delay,0.1,
					\mix, 
					Pseq([
						PmodEnv(Pseq([1,0.1,0],1), 4),
						Pn(0,inf),
					],1),
					\dur, 1,
					\out, BusDef(\hat2, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\hat2, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				)<>
				Pseq([
					Pbind(
						\hpf, PmodEnv(Pseq([10000,10,10000],1), 4,\exp),
						\mix, PmodEnv(Pseq([1,1,0.1],1), 4),
					),
					Pbind(
						\hpf, 10000,
						\mix, 0,
					),
				],1),
			]),
		]),
	])
)).play;
);

(
SynthDef(\cricrash, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([15000,6000,1],[0.005,0.8]), 1);
	env2 = EnvGen.kr(Env([4500,470,1],[0.06,0.1]), 1);
	env4 = EnvGen.kr(Env([31500,70,1],[0.06,3.1]), 1);
	mod1 = LFSaw.ar(1990, pi/2 * 0.4) * env4; 
	sig = SinOsc.ar(env1 + mod1);
	sig = RLPF.ar(sig, env2, \rq.kr(0.3));
	sig = sig * 1;
	sig = HPF.ar(sig, \hpf.kr(600));
	//sig = sig * EnvGen.kr(Env([0,1,0],[0.005,0.08]), 1);
	sig = Pan2.ar(sig, pan, amp);
	env3 = EnvGen.kr(Env([1,2,1],[0.01,1.8]), 1);
	//sig1 = CombL.ar(sig, 4/~t, 0.0051 * env3 * LFNoise1.ar(44,mul:0.2,add:1),0.2/~t);
	sig1 = CombL.ar(sig, 4/~t, 0.0051 * env3 * SinOsc.ar(1,mul:0.4,add:1),3.2/~t);
	sig1.debug("sig1");
	sig = SelectX.ar(\delmix.kr(0.5), [sig, sig1]);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(2), \damp.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.08,0.1,0.8,2.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// loop trans
Pdef(\part, Pdef(\transloop, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kicktrack, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10,12,1004,1000],1), Pseq([8,1,7])).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \deepbass,
			\note, Pseq([
				-3,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,7,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.2,
		),
		Ptpar([
			0, Pbind(
				\instrument, \sonarcrash,
				\dur, 1,
				\legato, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			0, Pbind(
				\instrument, \cricrash,
				\dur, 1,
				\legato, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\amp, 0.1/2,
			),
			0, Pseq([
				Psync(Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\hpf, PmodEnv(Pseq([20000,5000],1), 4,\exp),
					\dur, Pn(4.5,1),
					\amp, 0.1/2,
				),8).repeat(1),
				Event.silent(8),
				Psync(Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\hpf, PmodEnv(Pseq([20000,5000],1), 4,\exp),
					\dur, Pn(4.5,1),
					\amp, 0.1/2,
				),8).repeat(1),
				Psync(Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\lpf, PmodEnv(Pseq([7000,500],1), 2,\exp),
					\hpf, PmodEnv(Pseq([19000,1200,5000],1), 1,\exp),
					\dur, Pn(2,1),
					\amp, 0.1/2,
				),8).repeat(1),
			],inf),
			3, Psync(Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1753].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\pos, 0.2,
					\speed, -1,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],1).coin.not,
					\legato, 2,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 0.11,
					\out, BusDef(\revsnare, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\revsnare, \audio),
					\addAction, \addToTail,
					\room, 2,
					\damp, 1,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.1,1,1) ],
					],inf),
					\lag, 0.0009,
					\dur, Pn(1/2,3),
				),
			]),8).loop,
			4, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1753].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
			4, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[186].value,
					\bufnum, ~buflib.hat[13].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						0,0,1,1, 0,0,1,1,
						1,0,1,1, 1,0,1,1,
						1,0,1,1, 1,0,1,1,
						1,1,1,1, 0,1,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.11/2,
					\out, 
					Pstep(Pseq([
						BusDef(\hat, \audio),
						//Pn(0,inf)
					],inf),8),
				),
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hat, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\fb, 1/2,
					\delay,0.1,
					\mix, 
					Pseq([
						PmodEnv(Pseq([1,0.1,0],1), 4),
						Pn(0,8),
					],inf),
					\dur, 1,
					\out, BusDef(\hat2, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\hat2, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				)<>
				Pseq([
					Pbind(
						\hpf, PmodEnv(Pseq([10000,10,10000],1), 4,\exp),
						\mix, PmodEnv(Pseq([1,1,0.1],1), 4),
					),
					Pfindur(8,Pbind(
						\hpf, 10000,
						\mix, 0,
					)),
				],inf),
			]),
		]),
	])
)).play;
);

(
SynthDef(\deepbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = ( sig*\distamp.kr(1.2) ).tanh;
	sig = SelectX.ar(\distmix.kr(0.2), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\bassmodule, 
	Ppar([
		Ptpar([
			1, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1503].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,0, 0,0,0,0,
				],1).coin.not,
				\dur, 1/8,
				\gain, 0.1,
				//\out, BusDef(\kicktrack, \audio),
			),
			2, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1753].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,0,0,
				],1).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
			2.5,Pbind(
				\instrument, \deepbass,
				\note, Pseq([
					-3,
				],inf),
				\octave, 3,
				\dur, 1/8,
				\legato, Pseq([
					0,7,0,0,
					0,0,0,0,
					8,0,0,0, 0,0,0,0,
				],1),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\amp, 0.2,
			),
		]),

		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1753].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\pos, 0.2,
				\speed, -1,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],1).coin.not,
				\legato, 2,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
				\out, BusDef(\revsnare, \audio),
			),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\revsnare, \audio),
				\addAction, \addToTail,
				\room, 2,
				\damp, 1,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1,1,1) ],
				],inf),
				\lag, 0.0009,
				\dur, Pn(1/2,3),
			),
		]),
	])
)).play;
);

(
// seq
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(4, Pdef(\bassmodule)),
			Pfindur(28, Pdef(\transloop)),
		],4),
	])
)).play;
);

(
// loop trans2
Pdef(\part, Pdef(\transloop2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack0, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kicktrack0, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10,12,1004,1000],1), Pseq([8,1,7])).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \deepbass,
			\note, Pseq([
				-3,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,7,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.2,
		),
		Ptpar([
			0, Pbind(
				\instrument, \sonarcrash,
				\dur, 1,
				\legato, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			0, Pbind(
				\instrument, \cricrash,
				\dur, 1,
				\legato, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\amp, 0.1/2,
			),
			0, Pseq([
				Psync(Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\hpf, PmodEnv(Pseq([20000,5000],1), 4,\exp),
					\dur, Pn(4.5,1),
					\amp, 0.1/2,
				),8).repeat(1),
				Event.silent(8),
				Psync(Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\hpf, PmodEnv(Pseq([20000,5000],1), 4,\exp),
					\dur, Pn(4.5,1),
					\amp, 0.1/2,
				),8).repeat(1),
				Psync(Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\lpf, PmodEnv(Pseq([7000,500],1), 2,\exp),
					\hpf, PmodEnv(Pseq([19000,1200,5000],1), 1,\exp),
					\dur, Pn(2,1),
					\amp, 0.1/2,
				),8).repeat(1),
			],inf),
			3, Psync(Ppar([ // revsnare
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1753].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\pos, 0.2,
					\speed, -1,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],1).coin.not,
					\legato, 2,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 0.11,
					\out, BusDef(\revsnare, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\revsnare, \audio),
					\addAction, \addToTail,
					\room, 2,
					\damp, 1,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.1,1,1) ],
					],inf),
					\lag, 0.0009,
					\dur, Pn(1/2,3),
				),
			]),8).loop,
			4, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1753].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 0.11,
					\out, BusDef(\snare, \audio),
				),
				Pmono(\simpletrackmixer,
					\inbus, BusDef(\snare),
					\pregain, 1,
					\postgain, 1,
					\delay, 0,
					\send0, Pseq([
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 1,1,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
					\sendbus0, BusDef(\snare1, \audio, 2),
					\dur, 1,
				),
				Pmono(\fx_greyhole,
					\inbus, BusDef(\snare1, \audio),
					\delay, 3/4/~t,
					\addAction, \addToTail,
					\mix, 1,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			4, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[186].value,
					\bufnum, ~buflib.hat[13].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						0,0,1,1, 0,0,1,1,
						1,0,1,1, 1,0,1,1,
						1,0,1,1, 1,0,1,1,
						1,1,1,1, 0,1,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.11/2,
					\out, 
					Pstep(Pseq([
						BusDef(\hat, \audio),
						//Pn(0,inf)
					],inf),8),
				),
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hat, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\fb, 1/2,
					\delay,0.1,
					\mix, 
					Pseq([
						PmodEnv(Pseq([1,0.1,0],1), 4),
						Pn(0,8),
					],inf),
					\dur, 1,
					\out, BusDef(\hat2, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\hat2, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				)<>
				Pseq([
					Pbind(
						\hpf, PmodEnv(Pseq([10000,10,10000],1), 4,\exp),
						\mix, PmodEnv(Pseq([1,1,0.1],1), 4),
					),
					Pfindur(8,Pbind(
						\hpf, 10000,
						\mix, 0,
					)),
				],inf),
			]),
		]),
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
	])
)).play;
);

(
// loop trans3
Pdef(\part, Pdef(\transloop3, 
	Pfindur(16,Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack0, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kicktrack0, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10,12,1004,1000],1), Pseq([8,1,7])).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \deepbass,
			\note, Pseq([
				-3,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\legato, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,7,0,0, 0,0,0,0,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.2,
		),
		Ptpar([
			0, Pbind(
				\instrument, \sonarcrash,
				\dur, 1,
				\legato, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			0, Pbind(
				\instrument, \cricrash,
				\dur, 1,
				\legato, 4,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\amp, 0.1/2,
			),
			0, Pseq([
				Psync(Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\hpf, PmodEnv(Pseq([20000,5000],1), 4,\exp),
					\dur, Pn(4.5,1),
					\amp, 0.1/2,
				),8).repeat(1),
				Event.silent(8),
				Psync(Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\hpf, PmodEnv(Pseq([20000,5000],1), 4,\exp),
					\dur, Pn(4.5,1),
					\amp, 0.1/2,
				),8).repeat(1),
				Psync(Pbind(
					\instrument, \whitenoise,
					\lpf, 9000,
					\lpf, PmodEnv(Pseq([7000,500],1), 2,\exp),
					\hpf, PmodEnv(Pseq([19000,1200,5000],1), 1,\exp),
					\dur, Pn(2,1),
					\amp, 0.1/2,
				),8).repeat(1),
			],inf),
			3, Psync(Ppar([ // revsnare
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1753].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\pos, 0.2,
					\speed, -1,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],1).coin.not,
					\legato, 2,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 0.11,
					\out, BusDef(\revsnare, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\revsnare, \audio),
					\addAction, \addToTail,
					\room, 2,
					\damp, 1,
					\adsr, Pseq([
						[ Env.adsr(0.1,0.1,0.8,0.1,1,1) ],
					],inf),
					\lag, 0.0009,
					\dur, Pn(1/2,3),
				),
			]),8).loop,
			4, Ppar([ // snare
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1753].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 0.11,
					\out, BusDef(\snare, \audio),
				),
				Pmono(\simpletrackmixer,
					\inbus, BusDef(\snare),
					\pregain, 1,
					\postgain, 1,
					\delay, 0,
					\send0, Pseq([
						0,0,0,0, 0,0,1,0,
						0,0,0,0, 0,0,0,0,
						0,0,1,0, 1,1,0,0,
						0,0,0,0, 0,0,0,0,
					],inf),
					\sendbus0, BusDef(\snare1, \audio, 2),
					\dur, 1,
				),
				Pmono(\fx_greyhole,
					\inbus, BusDef(\snare1, \audio),
					\delay, 3/4/~t,
					\addAction, \addToTail,
					\mix, 1,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			4, Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[186].value,
					\bufnum, ~buflib.hat[13].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						0,0,1,1, 0,0,1,1,
						1,0,1,1, 1,0,1,1,
						1,0,1,1, 1,0,1,1,
						1,1,1,1, 0,1,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.11/2,
					\out, 
					Pstep(Pseq([
						BusDef(\hat, \audio),
						//Pn(0,inf)
					],inf),8),
				),
				Pmono(\fx_greyhole,
					\inbus, BusDef(\hat, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\fb, 1/2,
					\delay,0.1,
					\mix, 
					Pseq([
						PmodEnv(Pseq([1,0.1,0],1), 4),
						Pn(0,8),
					],inf),
					\dur, 1,
					\out, BusDef(\hat2, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\hat2, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				)<>
				Pseq([
					Pbind(
						\hpf, PmodEnv(Pseq([10000,10,10000],1), 4,\exp),
						\mix, PmodEnv(Pseq([1,1,0.1],1), 4),
					),
					Pfindur(8,Pbind(
						\hpf, 10000,
						\mix, 0,
					)),
				],inf),
			]),
			32, Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					Pseq([
						Pser([ 4, 11, ],8),
						Pser([ 7, 14, ],8),
					],2),
					Pseq([
						Pser([ 0, 7, ],8),
						Pser([ -1, 6, ],8),
					],2),
				],inf).stutter(2),
				\lpf, PmodEnv(Pseq([100,200,400],1), 16,\exp).loop,
				\envamt, 4,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.1,0.3,1.1) ],
				],inf),
				\isRest, Pseq([
					Pser([
						1,1,1,1,
					],8*7),
					Pser([
						0,0,1,1, 0,0,1,0,
					],8),

				],inf).coin.not,
				\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
				\octave, 3,
				\amp, 0.1 * Pseq([
					1,0.5,1,0.9,
				],inf),
				//\isRest, true,
				\out, BusDef(\basstrack, \audio),
			),
		]),
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
	]))
)).play;
);

(
Pdef(\part, Pdef(\apart1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kicktrack, \audio),
		),
		Ptpar([
			0, Pbind(
				\instrument, \sonarcrash,
				\dur, 1,
				\legato, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\amp, 0.1,
			),
			14, Psync(Pbind(
				\instrument, \whitenoise,
				\lpf, 9000,
				\hpf, PmodEnv(Pseq([20000,5000],1), 4,\exp),
				\dur, Pn(2,1),
				\amp, 0.1/2,
			),8).repeat(1),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1753].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			24,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[186].value,
				\bufnum, ~buflib.hat[13].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,1, 0,0,1,1,
					1,0,1,1, 1,0,1,1,
					1,0,1,1, 1,0,1,1,
					1,1,1,1, 0,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11/2,
			),
			0, Pbind( // ramp
				\instrument, \stringpad,
				\note, Pseq([
					Pseq([ 4,7, ],2),
					Pseq([ 0,-1, ],2),
				],inf),
				\lpf, 2000,
				\rq, 0.9,
				\vcomod, Pseq([
					PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 0.5,
				\octave, 5,
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\string, \audio),
			),
			32, Pbind( // trill
				\instrument, \sh101,
				\note, Pseq([
					Pseq([
						Pser([ 4, 11, ],16),
						Pser([ 7, 14, ],16),
					],2),
					Pseq([
						Pser([ 0, 7, ],16),
						Pser([ -1, 6, ],16),
					],2),
				],inf),
				\lpf, 2000,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\amp, 0.07 * Pseg(Pseq([0,1,1,1,1],inf),8),
				\inbus, BusDef(\string, \audio),
			),
		]),
		Pmono(\fx_hpf,
			\inbus, BusDef(\string, \audio),
			\addAction, \addToTail,
			\hpf, 400,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400],1), 16,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
		Pbind( // double
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*4,1), 16,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
			\out, BusDef(\hic2, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\hic, \audio),
			\delay, 1/7/~t,
			\decay, 1.8,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hic2, \audio),
		),
		Pmono(\fx_greyhole,
			\inbus, BusDef(\hic2, \audio),
			\delay, 1/~t,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hic3, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\hic3, \audio),
			\addAction, \addToTail,
			\hpf, 1000 * Pseq([1,1/2,1/3,2],inf),
			\lpf, Pseq([
				1000,4000,6000,3000,
			],inf),
			\hpf, PmodEnv(Pseq([5000,2000,10],1), 16,\exp),
			\lag, 0.0009,
			\dur, 4,
		).loop,
	])
)).play;
);
(
// seq
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(16, Pdef(\transloop2)),
			Pfindur(32, Pdef(\apart1)),
		],4),
	])
)).play;
);

/////////// draft

(
// lfo on whitenoise
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \whitenoiseam,
			\lpf, PmodEnv(Pseq([500,14000],1), 8,\exp).loop,
			\fmf, 2*~t,
			\fma, PmodEnv(Pseq([0,0.2,0.8],1), 4).loop,
			\hpf, 150,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(2/~t,0,1,0.01,1,1) ],
			],inf),
			\isRest, Pseq([
				1,
			],1).coin.not,
			\dur, 8,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
// delay mod
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind( // double
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*4,1), 16,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			\out, BusDef(\hh, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hh, \audio),
			\out, BusDef(\hh2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\hh2, \audio),
			\addAction, \addToTail,
			\decay, 4,
			\delay, PmodEnv(Pseq([0.01,0.2,0.301],1), Pseq([7,1]),\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \whitenoiseam,
			\lpf, PmodEnv(Pseq([500,14000],1), 8,\exp).loop,
			\fmf, 2*~t,
			\fma, PmodEnv(Pseq([0,0.2,0.8],1), 4).loop,
			\hpf, 150,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(2/~t,0,1,0.01,1,1) ],
			],inf),
			\isRest, Pseq([
				1,
			],1).coin.not,
			\dur, 8,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\partx, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snareverb, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\snareverb),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\snareverb2, \audio, 2),
			\dur, 1,
		),
		//Pmono(\fx_greyhole,
			//\inbus, BusDef(\snareverb2, \audio),
			//\addAction, \addToTail,
			//\size, 2,
			//\diff, 0.1,
			//\delay, 1/4/~t,
			//\mix, 1,
			//\room, 2,
			//\lag, 0.0009,
			//\dur, 1,
			//\out, BusDef(\snareverb3, \audio),
		//),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\snareverb2, \audio),
			\out, BusDef(\snareverb3, \audio),
			\diffadd, Pseg(Pseq([0,0.1],inf),8),
			\delay, 1/4/~t,
			\mix, 1,
			\decay, 4/~t * Pseg(Pseq([0,1],inf),16),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\snareverb2, \audio),
			\out, BusDef(\snareverbfil, \audio),
			\diffadd, Pseg(Pseq([0,0.1],inf),8),
			\delay, 1/8/~t,
			\mix, 1,
			\decay, 4/~t * Pseg(Pseq([1,0.5,1],inf),16),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\snareverbfil, \audio),
			\hpf, 10000,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\snareverb3, \audio),
			\out, BusDef(\snareverb4, \audio),
			\room, PmodEnv(Pseq([0,0.1,4],1), 8).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\snareverb4, \audio),
			\hpf, 5000,
			\hpf, PmodEnv(Pseq([10000,40],1), 16,\exp),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		).loop,
		Ptpar([
			8, Pfindur(8,Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[803].value,
					\bufnum, ~buflib.hat[731].value,
					\bufnum, ~buflib.hat[784].value,
					\bufnum, ~buflib.hat[125].value,
					\speed, PmodEnv(Pseq([0.5,4.2],1), 16).loop,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.11 * Pseg(Pseq([0.01,Pn(1,inf)],inf),4,\exp),
					\out, BusDef(\hatf, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\hatf, \audio),
					\addAction, \addToTail,
					\hpf, 1000,
					\lag, 0.0009,
					\dur, 1,
				),
			])),
		]).loop,
		//Ptpar([
			//0.5, Pmono(\fx_lpfhpf,
				//\inbus, BusDef(\snareverb4, \audio),
				////\hpf, PmodEnv(Pseq([10000,40],1), 1,\exp),
				//\hpf, 5000,
				//\addAction, \addToTail,
				//\lag, 0.0009,
				//\dur, 1,
			//).loop,
		//]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\partx, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snareverb, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\snareverb),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\snareverb2, \audio, 2),
			\dur, 1,
		),
		//Pmono(\fx_greyhole,
			//\inbus, BusDef(\snareverb2, \audio),
			//\addAction, \addToTail,
			//\size, 2,
			//\diff, 0.1,
			//\delay, 1/4/~t,
			//\mix, 1,
			//\room, 2,
			//\lag, 0.0009,
			//\dur, 1,
			//\out, BusDef(\snareverb3, \audio),
		//),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\snareverb2, \audio),
			\out, BusDef(\snareverb3, \audio),
			\diffadd, Pseg(Pseq([0,0.1],inf),8),
			\delay, 1/4/~t,
			\mix, 1,
			\decay, 4/~t * Pseg(Pseq([0,1],inf),16),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\snareverb2, \audio),
			\out, BusDef(\snareverbfil, \audio),
			\diffadd, Pseg(Pseq([0,0.1],inf),8),
			\delay, 1/8/~t,
			\mix, 1,
			\decay, 4/~t * Pseg(Pseq([1,0.5,1],inf),16),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\snareverbfil, \audio),
			\hpf, 10000,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\snareverb3, \audio),
			\out, BusDef(\snareverb4, \audio),
			\room, PmodEnv(Pseq([0,0.1,4],1), 8).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\snareverb4, \audio),
			\hpf, 5000,
			\hpf, PmodEnv(Pseq([10000,40],1), 16,\exp),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		).loop,
		Ptpar([
			8, Pfindur(8,Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[784].value,
					\bufnum, ~buflib.hat[731].value,
					\bufnum, ~buflib.hat[803].value,
					\speed, PmodEnv(Pseq([0.8,2.2],1), 16).loop,
					\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\dur, 1/8,
					\gain, 0.11,
					\out, BusDef(\hatf, \audio),
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\hatf, \audio),
					\addAction, \addToTail,
					\hpf, 10000,
					\lag, 0.0009,
					\dur, 1,
				),
			])),
		]).loop,
		Pbind( // ramp
			\instrument, \stringpadf,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 7000,
			\rq, 0.9,
			\ffac, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\mix, 1,
			\hpf, 400,
			\gain, 1/2,
			\lag, 0.0009,
			\dur, 1,
		),
		//Ptpar([
			//0.5, Pmono(\fx_lpfhpf,
				//\inbus, BusDef(\snareverb4, \audio),
				////\hpf, PmodEnv(Pseq([10000,40],1), 1,\exp),
				//\hpf, 5000,
				//\addAction, \addToTail,
				//\lag, 0.0009,
				//\dur, 1,
			//).loop,
		//]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\partx, 
	Ppar([
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1503].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
				//\out, BusDef(\kicktrack, \audio),
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickf, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\kickf, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\hpf, PmodEnv(Pseq([500,82],1), 8),
			\dur, 1,
		),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.2,1,0.5,
			],inf),
			//\isRest, true,
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
			\gain, PmodEnv(Pseq([0,0,0,1,Pn(1,5)],1), 8).loop,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ramp
			\instrument, \stringpadf,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 7000,
			\rq, 0.9,
			\ffac, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,0,1, 
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1, 
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hic2, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\mix, Pseq([
				Pn(0.5,8),
				Pn(0.1,inf),
			],inf),
			\dur, 1,
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\mix, 1,
			\lpf, PmodEnv(Pseq([700,Pn(20000,4)],1), 8,\exp).loop,
			\hpf, 400,
			\gain, 1/2,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hic2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[186].value,
			\bufnum, ~buflib.hat[13].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,1, 0,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/4 * Pseq([
				1,0.5,0.9,0.8,
			],inf),
			\out, BusDef(\hat, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hat, \audio),
			\out, BusDef(\hat2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([
				Pn(0.8,8),
				Pn(0,inf),
			],1),
			\dur, 1,
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\hat2, \audio),
			\addAction, \addToTail,
			\lpf, 20000,
			\hpf, PmodEnv(Pseq([2e4,10000,24],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[784].value,
			\bufnum, ~buflib.hat[731].value,
			\bufnum, ~buflib.hat[803].value,
			\bufnum, ~buflib.hat[1564].value,
			//\speed, PmodEnv(Pseq([0.8,2.2],1), 16).loop,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pn(0,8*8),
				Pseq([
					0,0,1,0, 
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
			//\out, BusDef(\hatf, \audio),
		),
		//Ptpar([
		//0.5, Pmono(\fx_lpfhpf,
		//\inbus, BusDef(\snareverb4, \audio),
		////\hpf, PmodEnv(Pseq([10000,40],1), 1,\exp),
		//\hpf, 5000,
		//\addAction, \addToTail,
		//\lag, 0.0009,
		//\dur, 1,
		//).loop,
		//]),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind( // bass intro
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\rq, 0.7,
			\lpf, 100,
			\envamt, 4,
			\dur, 4,
			\adsr, Pseq([
				[ Env.adsr(4/~t,0.1,0.8,0.1,1,1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\octave, 3,
			\legato, 1,
			\amp, 0.1 * Pseq([
				1,
			],1),
			//\isRest, true,
			//\out, BusDef(\basstrack, \audio),
		),
		Ptpar([
			4, Pbind( // bass
				\instrument, \sh101,
				\note, Pseq([
					Pseq([
						Pser([ 4, 11, ],8),
						Pser([ 7, 14, ],8),
					],2),
					Pseq([
						Pser([ 0, 7, ],8),
						Pser([ -1, 6, ],8),
					],2),
				],inf).stutter(2),
				\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
				\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
				\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.1,0.3,1.1) ],
				],inf),
				\isRest, Pseq([
					Pser([
						1,1,1,1,
					],8*7),
					Pser([
						0,0,1,1, 0,0,1,0,
					],8),

				],inf).coin.not,
				\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
				\octave, 3,
				\amp, 0.1 * Pseq([
					1,0.2,1,0.5,
				],inf),
				//\out, BusDef(\basstrack, \audio),
			),
			4, Ppar([
				Pbind( // double
					\instrument, \sh101,
					\note, Pseq([
						Pseq([
							Pser([ 4, 11, ],8),
							Pser([ 7, 14, ],8),
						],2),
						Pseq([
							Pser([ 0, 7, ],8),
							Pser([ -1, 6, ],8),
						],2),
					],inf).stutter(2),
					\lpf, PmodEnv(Pseq([200,600,700]*4,1), 16,\exp).loop,
					\rq, PmodEnv(Pseq([1,0.3,0.4],1), 8).loop,
					\envamt, 4,
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\lpadsr, Pseq([
						[ Env.adsr(0.01,0.3,0.3,1.1) ],
					],inf),
					\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
					\octave, 5,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\amp, 0.1 * Pseq([
						0.1,0.3,1,0.3,
					],inf),
					\out, BusDef(\hic, \audio),
				),
				Pmono(\simpletrackmixer,
					\inbus, BusDef(\hic),
					\pregain, 1,
					\postgain, 1,
					\delay, 0,
					\send0, 1,
					\sendbus0, BusDef(\hicf, \audio, 2),
					\dur, 1,
				),
				Pmono(\fx_lpfhpf,
					\inbus, BusDef(\hicf, \audio),
					\addAction, \addToTail,
					\hpf, 1000,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\hicf2, \audio),
				),
				Pmono(\fx_echo,
					\inbus, BusDef(\hicf2, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.2,1,0.5,
			],inf),
			\out, BusDef(\main, \audio),
		),
		Ppar([
			Pbind( // double
				\instrument, \sh101,
				\note, Pseq([
					Pseq([
						Pser([ 4, 11, ],8),
						Pser([ 7, 14, ],8),
					],2),
					Pseq([
						Pser([ 0, 7, ],8),
						Pser([ -1, 6, ],8),
					],2),
				],inf).stutter(2),
				\lpf, PmodEnv(Pseq([200,600,700]*4,1), 16,\exp).loop,
				\rq, PmodEnv(Pseq([1,0.3,0.4],1), 8).loop,
				\envamt, 4,
				\dur, 1/8,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.3,0.3,1.1) ],
				],inf),
				\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
				\octave, 5,
				\isRest, Pseq([
					1,1,
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					0.1,0.3,1,0.3,
				],inf),
				\out, BusDef(\hic, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\hic),
				\out, BusDef(\main, \audio),
				\pregain, 1,
				\postgain, 1,
				\delay, 0,
				\send0, 1,
				\sendbus0, BusDef(\hicf, \audio, 2),
				\dur, 1,
			),
			Pmono(\fx_lpfhpf,
				\inbus, BusDef(\hicf, \audio),
				\addAction, \addToTail,
				\hpf, PmodEnv(Pseq([19000,200,1000,4,4],1), 8,\exp),
				\lag, 0.0009,
				\dur, 1,
				\out, BusDef(\hicf2, \audio),
			).loop,
			Pmono(\fx_echodiff,
				\inbus, BusDef(\hicf2, \audio),
				\addAction, \addToTail,
				\delay, 1/8/~t,
				\diffmul, 1.01,
				\mix, 1,
				\lag, 0.0009,
				\dur, 1,
				\out, BusDef(\hicf3, \audio),
			),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\hicf3, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\gain, 1/1.5,
				\dur, 1,
				\out, BusDef(\hicf4, \audio),
			),
			Pmono(\fx_resonz,
				\inbus, BusDef(\hicf4, \audio),
				\freq, PmodEnv(Pseq([1000,12000],1), 32,\exp).loop,
				\bwr, 1.0,
				\mix, 0.51,
				\gain, 1.0,
				\addAction, \addToTail,

				\lag, 0.0009,
				\dur, 1,
				\out, BusDef(\main, \audio),
			),
		]),
		Pmono(\fx_hpf,
			\inbus, BusDef(\main, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([1,100,5000,13000],1), Pseq([8,14,2]),\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Ptpar([
			8,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1503].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1 * Pseg(Pseq([0,0.5,1,Pn(1,inf)],inf),8),
				//\out, BusDef(\kicktrack, \audio),
			),
			20,Pbind(
				\instrument, \whitenoise,
				\lpf, 13000,
				\hpf, PmodEnv(Pseq([15000,4000],1), 4).loop,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(2/~t,0.1,0.8,0.01,1,1) ],
				],inf),
				\isRest, Pseq([
					1,
				],1).coin.not,
				\dur, 4,
				\amp, 0.1/2,
			),
			32,Ppar([
				Pbind( // ramp
					\instrument, \stringpadf,
					\note, Pseq([
						Pseq([ 4,7, ],2),
						Pseq([ 0,-1, ],2),
					],inf),
					\lpf, 7000,
					\rq, 0.9,
					//\ffac, Pseq([
					//PmodEnv(Pseq([0,0,7].midiratio,1), Pseq([6/8,2/8])).loop,
					//],inf),
					\adsr, Pseq([
						[ Env.adsr(2.01,0.1,0.8,0.1,1,1) ],
					],inf),
					\legato, 0.5,
					\octave, 6,
					\dur, 2,
					\amp, 0.1,
					\out, BusDef(\hic, \audio),
				),
				Pmono(\fx_freeverb2,
					\inbus, BusDef(\hic, \audio),
					\damp, 1,
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
			]),

			24, Pbind(
				\instrument, \sonarcrash,
				\dur, 1,
				\legato, 4,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],13),
				],inf).coin.not,
				\amp, 0.1,
			),
		]),
	])
)).play;
);

(
// with ramp2
Pdef(\part, Pdef(\partx, 
	Ppar([
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1503].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
				//\out, BusDef(\kicktrack, \audio),
			),
			32, Pbind( // ramp 2
				\instrument, \stringpadf,
				\note, Pstep(Pseq([
					Pseq([ 0,-1, ],2),
					Pseq([ 4,7, ],2),
				],inf),2),
				\lpf, 7000,
				\rq, 0.9,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\legato, 0.5,
				\octave, 6,
				\dur, 1/8,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 1,0,0,1,
						0,0,0,0, 0,0,0,0,
					],8),
					Pseq([
						0,0.3,1,0, 1,0,0.3,1,
						0,0,0,0, 0,0,0,0,
					],8),
				],inf).coin.not,
				\amp, 0.1 * Pseq([
					1,0.41,1,1, 1,1,0.41,1,
				],inf),
				\out, BusDef(\hic, \audio),
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\kickf, \audio),
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\kickf, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\hpf, PmodEnv(Pseq([500,82],1), 8),
			\dur, 1,
		),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.2,1,0.5,
			],inf),
			//\isRest, true,
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
			\gain, PmodEnv(Pseq([0,0,0,1,Pn(1,5)],1), 8).loop,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1753].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ramp
			\instrument, \stringpadf,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 7000,
			\rq, 0.9,
			\ffac, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,1, 0,1,0,1, 
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 1,0,1,1, 
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hic2, \audio),
			\addAction, \addToTail,
			\room, 2,
			\lag, 0.0009,
			\mix, Pseq([
				Pn(0.5,8),
				Pn(0.1,inf),
			],inf),
			\dur, 1,
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\mix, 1,
			\lpf, PmodEnv(Pseq([700,Pn(20000,4)],1), 8,\exp).loop,
			\hpf, 400,
			\gain, 1/2,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\hic2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[186].value,
			\bufnum, ~buflib.hat[13].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,1, 0,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/4 * Pseq([
				1,0.5,0.9,0.8,
			],inf),
			\out, BusDef(\hat, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hat, \audio),
			\out, BusDef(\hat2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, Pseq([
				Pn(0.8,8),
				Pn(0,inf),
			],1),
			\dur, 1,
		),
		Pmono(\fx_lpfhpf,
			\inbus, BusDef(\hat2, \audio),
			\addAction, \addToTail,
			\lpf, 20000,
			\hpf, PmodEnv(Pseq([2e4,10000,24],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[784].value,
			\bufnum, ~buflib.hat[731].value,
			\bufnum, ~buflib.hat[803].value,
			\bufnum, ~buflib.hat[1564].value,
			//\speed, PmodEnv(Pseq([0.8,2.2],1), 16).loop,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pn(0,8*8),
				Pseq([
					0,0,1,0, 
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2,
			//\out, BusDef(\hatf, \audio),
		),
		//Ptpar([
		//0.5, Pmono(\fx_lpfhpf,
		//\inbus, BusDef(\snareverb4, \audio),
		////\hpf, PmodEnv(Pseq([10000,40],1), 1,\exp),
		//\hpf, 5000,
		//\addAction, \addToTail,
		//\lag, 0.0009,
		//\dur, 1,
		//).loop,
		//]),

	])
)).play;
);

(
// with rdn_trill
Pdef(\part, Pdef(\partx, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
		
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 8000,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hic),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 1,
			\sendbus0, BusDef(\hicrdn, \audio, 2),
			\send1, PmodEnv(Pseq([1,0],1), 32).loop,
			\sendbus1, BusDef(\hicot, \audio, 2),
			\send2, 1,
			\sendbus2, BusDef(\hicrdndist, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdn_trill,
			\inbus, BusDef(\hicrdn, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.28571428571429,
			'fb', 0.0001,
			'delay', 0.40009236664026787,
			'delay2', 0.00087332616238284,
			\delay2, PmodEnv(Pseq([0.0005,0.00001],1), 16,\exp).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.2006878167665,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 15402.265930714,
			'posthpf', 1409.91254738447,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 3.9466141732283,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.0001,
			'distamp2', 3.9466141732283,
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\hicot, \audio),
			\addAction, \addToTail,
			\room, PmodEnv(Pseq([0.1,2,2],1), 16).loop,
			\mix, PmodEnv(Pseq([0.31,1,1],1), 16).loop,
			\lpf, 20000,
			\hpf, PmodEnv(Pseq([110,2000,12000],1), 16).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\rdn_trill,
			\inbus, BusDef(\hicrdndist, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.14571428571429,
			'fb', 0.0001,
			'delay', 0.00049236664026787,
			'delay2', 0.000087332616238284,
			'shift', 0.01,
			'shift2', 0.001,
			'distamp', 34.2006878167665,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 19402.265930714,
			'posthpf', 189.91254738447,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 3.9466141732283,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.0001,
			'distamp2', 3.9466141732283,
		),

	])
)).play;
);

(
// with rdn_trill
Pdef(\part, Pdef(\partx, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
		
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 8000,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hic),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\hicrdn, \audio, 2),
			\send1, 0,
			\sendbus1, BusDef(\hicot, \audio, 2),
			\send2, 1,
			\sendbus2, BusDef(\hicrdndist, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdn_trill,
			\inbus, BusDef(\hicrdn, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.28571428571429,
			'fb', 0.0001,
			'delay', 0.40009236664026787,
			'delay2', 0.00087332616238284,
			\delay2, PmodEnv(Pseq([0.0005,0.00001],1), 16,\exp).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.2006878167665,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 15402.265930714,
			'posthpf', 1409.91254738447,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 3.9466141732283,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.0001,
			'distamp2', 3.9466141732283,
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\hicot, \audio),
			\addAction, \addToTail,
			\room, PmodEnv(Pseq([0.1,2,2],1), 16).loop,
			\mix, PmodEnv(Pseq([0.31,1,1],1), 16).loop,
			\lpf, 20000,
			\hpf, PmodEnv(Pseq([110,2000,12000],1), 16).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\rdn_trill,
			\inbus, BusDef(\hicrdndist, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.24571428571429,
			'fb', 0.0001,
			'delay', 0.00009236664026787,
			'delay', PmodEnv(Pseq([0.00001,0.002],1), 32, \exp).loop,
			'delay2', 0.031087332616238284,
			'delay2', PmodEnv(Pseq([0.21,0.42]*0.1,1), 32,\exp).loop,
			'shift', 0.01,
			'shift2', 0.001,
			'distamp', 78.8006878167665,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 8.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 19402.265930714,
			'posthpf', 109.91254738447,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 3.9466141732283,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.0001,
			'distamp2', 3.9466141732283,
		),

	])
)).play;
);

(
// with rdn_softdist
Pdef(\part, Pdef(\partx, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
		
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 8000,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hic),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\hicrdn, \audio, 2),
			\send1, 0,
			\sendbus1, BusDef(\hicot, \audio, 2),
			\send2, 1,
			\sendbus2, BusDef(\hicrdndist, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdn_trill,
			\inbus, BusDef(\hicrdn, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.28571428571429,
			'fb', 0.0001,
			'delay', 0.40009236664026787,
			'delay2', 0.00087332616238284,
			\delay2, PmodEnv(Pseq([0.0005,0.00001],1), 16,\exp).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.2006878167665,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 15402.265930714,
			'posthpf', 1409.91254738447,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 3.9466141732283,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.0001,
			'distamp2', 3.9466141732283,
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\hicot, \audio),
			\addAction, \addToTail,
			\room, PmodEnv(Pseq([0.1,2,2],1), 16).loop,
			\mix, PmodEnv(Pseq([0.31,1,1],1), 16).loop,
			\lpf, 20000,
			\hpf, PmodEnv(Pseq([110,2000,12000],1), 16).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		Pmono(\rdn_softdist,
			\inbus, BusDef(\hicrdndist, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.86554621848739,
			'gain', 0.28571428571429,
			'fb', 0.0035086914797844,
			'delay', 0.0018936988889504,
			\delay, PmodEnv(Pseq([0.0001,0.001,0.002],1), 16,\exp).loop,
			'delay2', 0.10001,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 6.3463059962866,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', 110.84790122088,
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
		)
	])
)).play;
);
//////////////// intro drop outro

(
SynthDef(\agrbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var mod1, mod2, mod3, mod4, mod5, mod6, mod7, mod8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	mod2 = LFSaw.ar(freq/2) * \fma2.kr(77);
	mod1 = LFSaw.ar(freq+mod2) * \fma1.kr(113);
	sig = LFSaw.ar(freq + mod1);
	sig1 = LPF.ar(sig, \lpf.kr(19300));
	sig1 = HPF.ar(sig1, \hpf.kr(30));
	sig= SelectX.ar(\fmix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],15),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // double
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*4,1), 16,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			\out, BusDef(\hic, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\dur, 1,
			\out, BusDef(\hic2, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hic2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10000,400,4],1), 8,\exp),
			\lag, 0.0009,
			\dur, 1,
		).loop,
		Pbind(
			\instrument, \whitenoise,
			\lpf, 13000,
			\hpf, PmodEnv(Pseq([15000,4000],1), 4).loop,
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(2/~t,0.1,0.8,0.01,1,1) ],
			],inf),
			\isRest, Pseq([
				0,1,
			],1).coin.not,
			\dur, 4,
			\amp, 0.1/2,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[186].value,
				\bufnum, ~buflib.hat[13].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					0,0,1,1, 0,0,1,1,
					1,0,1,1, 1,0,1,1,
					1,0,1,1, 1,0,1,1,
					1,1,1,1, 0,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11/4 * Pseq([
					1,0.5,0.9,0.8,
				],inf),
			),
			8,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1503].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
				//\out, BusDef(\kicktrack, \audio),
			),
			8,Ppar([
				Pbind( // bass
					\instrument, \agrbass,
					\note, Pseq([
						Pseq([
							Pser([ 4, 11, ],8),
							Pser([ 7, 14, ],8),
						],2),
						Pseq([
							Pser([ 0, 7, ],8),
							Pser([ -1, 6, ],8),
						],2),
					],inf).stutter(2),
					\lpf, 1000,
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\isRest, Pseq([
						1,0,1,1,
					],inf).coin.not,
					\octave, 3,
					\lpf, 3900,
					\hpf, PmodEnv(Pseq([17000,700,700,300],1), 8,\exp).loop,
					\amp, 0.1,
					//\isRest, true,
				),
			]),
		]),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\part1, 
	Ppar([

		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],15),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[186].value,
			\bufnum, ~buflib.hat[13].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,1, 0,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/4 * Pseq([
				1,0.5,0.9,0.8,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind( // bass
			\instrument, \agrbass,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, 4000,
			\hpf, PmodEnv(Pseq([300,20,1,4,4],1), 8).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\octave, 3,
			\amp, 0.1,
			\fmix, 1,
		),
		Pbind( // double
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*4,1), 16,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			\out, BusDef(\hic, \audio),
			\isRest, true,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.1,
			\dur, 1,
			\out, BusDef(\hic2, \audio),
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\hic2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, PmodEnv(Pseq([0,0.1,0.4,0.5,0.6],1), 8).loop,
			\dur, 1,
			\out, BusDef(\hic3, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hic3, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10000,400,Pn(333,3)],1), 8,\exp),
			\lag, 0.0009,
			\gain, 1/3,
			\dur, 1,
		).loop,
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 2000,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Ptpar([ // snare
			8, Pfindur(8,Ppar([
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1753].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
					],inf).coin.not,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.1) ],
					],inf),
					\dur, 1/8,
					\gain, 0.11 * Pseg(Pseq([0.01,1],inf),8,\exp),
					\out, BusDef(\presnare, \audio),
				),
				Pmono(\fx_bpf,
					\inbus, BusDef(\presnare, \audio),
					\bpf, PmodEnv(Pseq([100,8000],1), 8,\exp).loop,
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
				),
			])),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1753].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\break, 
	Ppar([
		
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \cricrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind( // bass
			\instrument, \agrbass,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, 4000,
			\hpf, PmodEnv(Pseq([1300,120,40,4,4],1), 8,\exp).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,1,
			],inf).coin.not,
			\octave, 3,
			\amp, 0.1,
			\fmix, 1,
		),
		Pbind( // double
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*4,1), 16,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			\out, BusDef(\hic, \audio),
			\isRest, true,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.1,
			\dur, 1,
			\out, BusDef(\hic2, \audio),
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\hic2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, PmodEnv(Pseq([0,0.1,0.4,0.5,0.6],1), 8).loop,
			\dur, 1,
			\out, BusDef(\hic3, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hic3, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10000,400,Pn(333,3)],1), 8,\exp),
			\lag, 0.0009,
			\gain, 1/3,
			\dur, 1,
		).loop,
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 2000,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Ppar([ // snare
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1753].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
				\out, BusDef(\snare, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\snare),
				\pregain, 1,
				\postgain, Pseq([
					Pser([
						0
					],16),
				],1),
				\delay, 0,
				\send0, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],inf),
				],inf),
				\sendbus0, BusDef(\snare1, \audio, 2),
				\dur, 1,
			),
			Pmono(\fx_greyhole,
				\damp, 0.8,
				\size, 2.0,
				\diff, 0.2090700001716614,
				\fb, 0.99999997615814 * Pseg(Pseq([1,1,8.2,1.2,1.2],1),8).loop,
				\modDepth, 0.10100000149012,
				\modFreq, 2.0,
				\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				\mix, 1.0,
				\gain, 2.8,
				\inbus, BusDef(\snare1, \audio),
				\delay, 1/8/~t,
				\addAction, \addToTail,
				\mix, 1,
				\lag, 0.0009,
				\dur, Pn(1,inf),
				\out, BusDef(\snare2, \audio),
			),
			Pmono(\fx_lpfhpf,
				\inbus, BusDef(\snare2, \audio),
				\addAction, \addToTail,
				\hpf, 1000,
				\lag, 0.0009,
				\dur, 1,
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\build, 
	Pfindur(16,Ppar([
		
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \cricrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1/2,
		),
		Pbind( // bass
			\instrument, \agrbass,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, 4000,
			\lpf, PmodEnv(Pseq([100,400,Pn(14000,3)],1), 8).loop,
			\hpf, PmodEnv(Pseq([4300,120,40,4,4],1), 8,\exp).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,0,1,1,
				],8*8),
			],inf).coin.not,
			\octave, 3,
			\amp, 0.1,
			\fmix, 1,
		),
		Pbind( // double
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*4,1), 16,\exp).loop,
			\envamt, 4,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1],inf),8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			\out, BusDef(\hic, \audio),
			\isRest, true,
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\hic, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\room, 2,
			\mix, 0.1,
			\dur, 1,
			\out, BusDef(\hic2, \audio),
		),
		Pmono(\fx_tanh,
			\inbus, BusDef(\hic2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, PmodEnv(Pseq([0,0.1,0.4,0.5,0.6],1), 8).loop,
			\dur, 1,
			\out, BusDef(\hic3, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\hic3, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([10000,400,Pn(333,3)],1), 8,\exp),
			\lag, 0.0009,
			\gain, 1/3,
			\dur, 1,
		).loop,
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 2000,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.1,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Ppar([ // snare
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1753].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
				\out, BusDef(\snare, \audio),
			),
			Pmono(\simpletrackmixer,
				\inbus, BusDef(\snare),
				\pregain, 1,
				\postgain, Pseq([
					Pser([
						0
					],16),
				],1),
				\delay, 0,
				\send0, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],inf),
				],inf),
				\sendbus0, BusDef(\snare1, \audio, 2),
				\dur, 1,
			),
			Pmono(\fx_freeverb2,
				\inbus, BusDef(\snare1, \audio),
				\out, BusDef(\snare2, \audio),
				\addAction, \addToTail,
				\lag, 0.0009,
				\dur, 1,
			),
			Pmono(\fx_echo,
				\inbus, BusDef(\snare2, \audio),
				\addAction, \addToTail,
				\decay, 4,
				\delay, PmodEnv(Pseq([0.01,0.051,0.01],1), Pseq([7,1]*2),\exp).loop,
				\gain, PmodEnv(Pseq([0,0.8,1,1,1],1), 8).loop,
				\lag, 0.0009,
				\dur, 1,
			),
			Ptpar([
				8, Pbind(
					\instrument, \whitenoiseam,
					\lpf, PmodEnv(Pseq([500,14000],1), 8,\exp).loop,
					\fmf, 2*~t,
					\fma, PmodEnv(Pseq([0,0.2,0.8],1), 4).loop,
					\hpf, 750,
					\legato, 1,
					\adsr, Pseq([
						[ Env.adsr(2/~t,0,1,0.01,1,1) ],
					],inf),
					\isRest, Pseq([
						1,
					],1).coin.not,
					\dur, 8,
					\amp, 0.1/2,
				),
			]),
			//Pmono(\fx_greyhole,
				//\inbus, BusDef(\snare1, \audio),
				//\damp, 0.8,
				//\size, 2.0,
				//\diff, 0.0090700001716614,
				//\fb, 0.99999997615814 * Pseg(Pseq([1,1,8.2,1.2,1.2],1),8).loop,
				//\modDepth, 0.10100000149012,
				//\modFreq, 2.0,
				//\adsr, [ Env([ 0.0, 1.0, 1.0, 0.0 ], [ 0.10000000149012, 0.0, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
				//\mix, 1.0,
				//\gain, 2.8,
				//\delay, 1/8/~t,
				//\addAction, \addToTail,
				//\mix, 1,
				//\lag, 0.0009,
				//\dur, Pn(1,inf),
				//\out, BusDef(\snare2, \audio),
			//),
			//Pmono(\fx_lpfhpf,
				//\inbus, BusDef(\snare2, \audio),
				//\addAction, \addToTail,
				//\hpf, 1000,
				//\lag, 0.0009,
				//\dur, 1,
			//),
		]),
	]))
)).play;
);

(
Pdef(\part, Pdef(\part2old, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
		
	])
)).play;
);

(
// with rdn_softdist
Pdef(\part, Pdef(\part2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[186].value,
				\bufnum, ~buflib.hat[13].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],inf),
				\isRest, Pseq([
					Pseq([
						0,0,1,1, 0,0,1,1,
						1,0,1,1, 1,0,1,1,
					],2),
					1,0,1,1, 1,0,1,1,
					1,0,1,1, 1,0,1,1,
					1,1,1,1, 0,1,1,1,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11/4 * Pseq([
					1,0.5,0.9,0.8,
				],inf) * Pseg(Pseq([0,0.7,1],1),4),
			),
			12, Pbind(
				\instrument, \whitenoiseam,
				\lpf, PmodEnv(Pseq([500,14000],1), 8,\exp).loop,
				\fmf, 1*~t,
				\fma, PmodEnv(Pseq([0,0.2,0.8],1), 4).loop,
				\hpf, 1750,
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(2/~t,0,1,0.01,1,1) ],
				],inf),
				\isRest, Pseq([
					1,
				],1).coin.not,
				\dur, 4,
				\amp, 0.1/2,
			),
		]),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,19002]*2,1), Pseq([14,2]),\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
		
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 8000,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hic),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\hicrdn, \audio, 2),
			\send1, 0,
			\sendbus1, BusDef(\hicot, \audio, 2),
			\send2, 1,
			\sendbus2, BusDef(\hicrdndist, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdn_trill,
			\inbus, BusDef(\hicrdn, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.28571428571429,
			'fb', 0.0001,
			'delay', 0.40009236664026787,
			'delay2', 0.00087332616238284,
			\delay2, PmodEnv(Pseq([0.0005,0.00001],1), 16,\exp).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.2006878167665,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 15402.265930714,
			'posthpf', 1409.91254738447,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 3.9466141732283,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.0001,
			'distamp2', 3.9466141732283,
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\hicot, \audio),
			\addAction, \addToTail,
			\room, PmodEnv(Pseq([0.1,2,2],1), 16).loop,
			\mix, PmodEnv(Pseq([0.31,1,1],1), 16).loop,
			\lpf, 20000,
			\hpf, PmodEnv(Pseq([110,2000,12000],1), 16).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		Pmono(\rdn_softdist,
			\inbus, BusDef(\hicrdndist, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.86554621848739,
			'gain', 0.28571428571429 * Pstep(Pseq([1,0],inf),14),
			'fb', 0.0035086914797844,
			'delay', 0.0018936988889504,
			\delay, PmodEnv(Pseq([0.7001,0.001,0.002],1), 16,\exp).loop,
			'delay2', 0.10001,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 6.3463059962866,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 10000.0,
			'posthpf', 110.84790122088,
			\posthpf, PmodEnv(Pseq([10000,2000,100,84,88],1), 8).loop,
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
		)
	])
)).play;
);

(
// seq
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([
			Pfindur(16, Pdef(\intro)),
			Pfindur(32, Pdef(\part1)),
			Pfindur(16, Pdef(\break)),
			Pfindur(16, Pdef(\build)),
			Pfindur(16, Pdef(\part2)),
			Pfindur(32, Pdef(\part3)),
		],4),
	])
)).play;
);

(
// with rdn_softdist
Pdef(\part, Pdef(\part3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1503].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			//\out, BusDef(\kicktrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[186].value,
			\bufnum, ~buflib.hat[13].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,1, 0,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
				1,1,1,1, 0,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/4 * Pseq([
				1,0.5,0.9,0.8,
			],inf),
		),
		Pbind(
			\instrument, \sonarcrash,
			\dur, 1,
			\legato, 4,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],13),
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],8),
					Pser([ 7, 14, ],8),
				],2),
				Pseq([
					Pser([ 0, 7, ],8),
					Pser([ -1, 6, ],8),
				],2),
			],inf).stutter(2),
			\lpf, PmodEnv(Pseq([100,200,400]*2,1), 16,\exp).loop,
			\envamt, Pseg(Pseq([2,4,11,11,11],inf),8),
			\rq, PmodEnv(Pseq([1,0.3],1), 32).loop,
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
				],8*7),
				Pser([
					0,0,1,1, 0,0,1,0,
				],8),

			],inf).coin.not,
			\legato, 1 * Pseg(Pseq([0.2,1,1,1,1],inf),8),
			\octave, 3,
			\amp, 0.1 * Pseq([
				1,0.5,1,0.9,
			],inf),
			//\isRest, true,
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
		
		Pbind( // ramp
			\instrument, \sh101,
			\note, Pseq([
				Pseq([ 4,7, ],2),
				Pseq([ 0,-1, ],2),
			],inf),
			\lpf, 8000,
			\rq, 0.9,
			\vcomod, Pseq([
				PmodEnv(Pseq([0,0,7].midiratio -1,1), Pseq([6/8,2/8])).loop,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\octave, 4,
			\dur, 2,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pbind( // trill
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					Pser([ 4, 11, ],16),
					Pser([ 7, 14, ],16),
				],2),
				Pseq([
					Pser([ 0, 7, ],16),
					Pser([ -1, 6, ],16),
				],2),
			],inf),
			\lpf, 2000,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.07,
			\out, BusDef(\hic, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\hic),
			\pregain, 1,
			\postgain, 0,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\hicrdn, \audio, 2),
			\send1, 0,
			\sendbus1, BusDef(\hicot, \audio, 2),
			\send2, 1,
			\sendbus2, BusDef(\hicrdndist, \audio, 2),
			\dur, 1,
		),
		Pmono(\rdn_trill,
			\inbus, BusDef(\hicrdn, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 1,
			'gain', 0.28571428571429,
			'fb', 0.0001,
			'delay', 0.40009236664026787,
			'delay2', 0.00087332616238284,
			\delay2, PmodEnv(Pseq([0.0005,0.00001],1), 16,\exp).loop,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 0.2006878167665,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 15402.265930714,
			'posthpf', 1409.91254738447,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'distamp3', 3.9466141732283,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
			'shiftmix', 0.0,
			'stereo', 0.0,
			'delay3', 0.0001,
			'distamp2', 3.9466141732283,
		),
		Pmono(\fx_freeverb2fil,
			\inbus, BusDef(\hicot, \audio),
			\addAction, \addToTail,
			\room, PmodEnv(Pseq([0.1,2,2],1), 16).loop,
			\mix, PmodEnv(Pseq([0.31,1,1],1), 16).loop,
			\lpf, 20000,
			\hpf, PmodEnv(Pseq([110,2000,12000],1), 16).loop,
			\lag, 0.0009,
			\dur, 1,
		),

		Pmono(\rdn_softdist,
			\inbus, BusDef(\hicrdndist, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.86554621848739,
			'gain', 0.28571428571429,
			'fb', 0.0035086914797844,
			'delay', 0.0018936988889504,
			\delay, PmodEnv(Pseq([0.0001,0.001,0.002],1), 16,\exp).loop,
			'delay2', 0.10001,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 6.3463059962866,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 20000.0,
			'posthpf', 110.84790122088,
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
		)
	])
)).play;
);

/////////////////////
////////////// other chords



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1078].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[820].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[186].value,
			\bufnum, ~buflib.hat[13].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,1, 0,0,1,1,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[2,6,9], // D
				[0,4,7], // C
				[2,6,9], // D
				[3,7,10], // Eb
				[6,9,12], // F#dim
				[7,10,14], // Gm
				[6,9,12], // F#dim
				[4,7,10], // Edim
			],inf).stutter(1),
			//\strum, 1/4,
			//\note, [6,9,12],
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\chord, Pstep(Pseq([
				[2,6,9], // D
				[0,4,7], // C
				[2,6,9], // D
				[3,7,10], // Eb
				[6,9,12], // F#dim
				[7,10,14], // Gm
				[6,9,12], // F#dim
				[4,7,10], // Edim
			],inf),4),
			\note, Plazy({ arg ev;
				Pindex(Pkey(\chord), Pseq((0..7),1));
			}).loop.trace,
			\note, Plazy({ arg ev;
				Pindex(Pkey(\chord), Pseq([3,3,2,1,0,0,0,0],1));
			}).loop.trace,
			\lpf, 300,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\envamt, 8,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);


(

SynthDef(\rdn_trill, { arg out=0, gate=1;
	// code: 5-AE8P-GJ11
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 543777.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = (si * 10.rand * \distamp.kr).tanh / 2;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
						si = [
							{ arg si, env;
								si = (si * 10.rand * \distamp.kr).tanh / 2;
							}.value(si, env);
							,
							{ arg si, env;
								si = (si * 10.rand * \distamp.kr).tanh / 2;
							}.value(si, env);
							,
							{ arg si, env;
								si = (si * 10.rand * \distamp.kr).tanh / 2;
							}.value(si, env);
							,
							{ arg si, env;
								si = (si * 10.rand * \distamp.kr).tanh / 2;
							}.value(si, env);

						].mean;
					}.value(si, env);

				].mean;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			}.value(si, env);

		].mean;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.86554621848739,
	'gain', 0.28571428571429,
	'fb', 0.0001,
	'delay', 0.069236664026787,
	'delay2', 0.00087332616238284,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.2006878167665,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 15402.265930714,
	'posthpf', 209.91254738447,
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
)

		
);


~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

SynthDef(\rdn_softdist, { arg out=0, gate=1;
	// code: 5-MD4-14G0
	var si, env = ();
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	var code, rdnkey;

	var sig;
	var sigin;
	var del, shi;
	var del2, shi2;
	var distamp;
	var hasFreq, afreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pitchlag;
	var pitchmix;
	var fb, fb1, fb2;
	var gain;
	var mix;
	var indelay;
	//"default_make_graph".debug("!!!");
	rdnkey = rdnkey ? \default;
	code = code ? "4--";
	sig = in;
	mix = \mix.kr(0.5);
	gain = \gain.kr(1);
	fb = \fb.kr(0.001);
	del = \delay.kr(0.001,0.1);
	del2 = \delay2.kr(0.001,0.1);
	shi = \shift.kr(0);
	shi2 = \shift2.kr(0);
	distamp = \distamp.kr(1);
	pitchlag = \pitchlag.kr(1/8) / TempoClock.default.tempo;
	pitchmix = \pitchmix.kr(0);

	sig = LPF.ar(sig, \prelpf.kr(17000));
	sig = HPF.ar(sig, \prehpf.kr(17));

	sig = sig + (LocalIn.ar(2) * fb);

	sig = LPF.ar(sig, \lpf.kr(17000));
	sig = HPF.ar(sig, \hpf.kr(17));
	thisThread.randSeed = 37376.0;
	si = sig;
	sig = { arg si, env;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
	}.value(si, env);


	sig1 = sig.tanh * \fbdistamp.kr(1/2);
	sig = SelectX.ar(\fbdistmix.kr(1), [sig, sig1]);

	sig = Limiter.ar(sig);

	sig1 = sig;
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	#afreq, hasFreq = Pitch.kr(sig1).flop;
	sig1 = BRF.ar(sig1, afreq.lag(pitchlag));
	sig = SelectX.ar(pitchmix, [sig, sig1]);

	LocalOut.ar(sig);
	sig = LPF.ar(sig, \postlpf.kr(17000));
	sig = HPF.ar(sig, \posthpf.kr(17));
	sig = Limiter.ar(sig);
	sig = sig * \wetamp.kr(1);

	indelay = \indelay.kr(0);
	sigin = DelayL.ar(in, 0.2, indelay);
	sig = SelectX.ar(mix, [sigin, sig]);
	sig = sig * gain;
	//sig.debug("end sig");
	sig;


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0,1,0.001)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 0.86554621848739,
	'gain', 0.28571428571429,
	'fb', 0.0035086914797844,
	'delay', 0.18936988889504,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 6.3463059962866,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 110.84790122088,
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
)

		
);
