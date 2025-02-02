~t = 183/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("capsule/draftsynth.scd");

(
// unison of pulse modulated by pulse width
SynthDef(\superpw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=8;
	var lpenv;
	sig = LFPulse.ar(freq, 0, LFNoise1.kr(1.1!num, mul:1, add:0).unipolar);
	sig = sig + LFPulse.ar(freq*2, 0, LFNoise1.kr(1.1, mul:1, add:0).unipolar, mul:0.2);
	//lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.04,0.4,0.2,4.1,4)), \itrig.tr(1), doneAction:0) * \lpenvamt.kr(4) + 1;
	lpenv = EnvGen.kr(\lpadsr.kr(Env.perc(1.6,0.4,curve:4)), \itrig.tr(1), doneAction:0) * \lpenvamt.kr(4) + 1;
	sig = RLPF.ar(sig, \lpf.kr(400) * lpenv, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\fmsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv;
	var fmenv;
	lpenv = EnvGen.kr(Env([0,1,0],[0.01,0.4]), 1) * \lpenvamt.kr(2) + 1;
	fmenv = EnvGen.kr(Env([0,1,0],[0.01,0.8]), 1) * \fmenvamt.kr(3) + 1;
	sig = LFPulse.ar(freq + (LFSaw.ar(freq * 1 * [2,1,1/2,1.001,2], 1/2)*100 * fmenv + 1) );
	//sig = DFM1.ar(sig, \lpf.kr( 30 ) * lpenv, 1/\rq.kr(0.2));
	sig = MoogFF.ar(sig, \lpf.kr( 400 ) * lpenv, 1/\rq.kr(0.4));
	sig = DelayL.ar(sig, 0.1,0.0001 * ( SinOsc.kr(0.1) * 1 + 1 )) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\simplefm, { arg out=0, amp=0.1, gate=1, pan=0;
	var sig;
	sig = LFSaw.ar(\freq.ar(200) * ( 1 + ( SinOsc.ar(\fmf.kr(1) * [1,1+\fmfmul.kr(0.001)]) * \fma.kr(1) )));
	sig = RLPF.ar(sig, \lpfr.kr(1) * \freq.ar, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;

SynthDef(\rdn_terrorbass, { arg out=0, gate=1;
	// code: 5-AC2A-D7LV
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
	thisThread.randSeed = 433855.0;
	si = sig;
	sig = { arg si, env;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = [
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);

				].mean;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			}.value(si, env);
			,
			{ arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					}.value(si, env);

				].mean;
			}.value(si, env);

		].mean;
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
	'mix', 0.52521008403361,
	'gain', 0.43697478991597,
	'fb', 0.0001,
	'delay', 0.55962764453196,
	'delay2', 0.0001,
	'shift', 0.0,
	'shift2', 0.12605042016807,
	'distamp', 57.610839222447,
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
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[304].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \superpw,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 0.1,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pbind(
			\instrument, \fmsaw,
			\fmenvamt, PmodEnv(Pseq([1,2,1,4],1), 8).loop,
			\lpenvamt, PmodEnv(Pseq([1,2,1,4],1), 6).loop,
			\note, Pseq([
				Pseq([
					Pseq([
						\r
					],7),
					0,
				],3),
				0,
				Pseq([
					\r
				],6),
				0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),


		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> 
Pbind(
	'wet10', 1.0,
	'mix', 0.52521008403361,
	'gain', 0.13697478991597,
	'fb', 0.0001,
	'delay', 0.000002764453196,
	'delay2', 0.00001,
	'shift', 0.1,
	'shift2', 0.02605042016807,
	'distamp', 57.610839222447,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 5000,
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
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[304].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \superpw,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 0.1,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pbind(
			\instrument, \fmsaw,
			\fmenvamt, PmodEnv(Pseq([1,2,1,4],1), 8).loop,
			\lpenvamt, PmodEnv(Pseq([1,2,1,4],1), 6).loop,
			\note, Pseq([
				Pseq([
					Pseq([
						\r
					],7),
					0,
				],3),
				0,
				Pseq([
					\r
				],6),
				0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[79].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				1,0,0,0,
				0,0,0,0,
			],inf).coin.not,
			\speed, 0.4,
			\legato, 4,
			\dur, 1/1,
			\gain, 0.1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1730].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\gain, 0.11,
			\out, BusDef(\pfx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.51,
			\room, 3,
			\dur, 1,
			\gain, 2,
		),

		Pbind(
			\instrument, \saw,
			\note, Pseq([
				x = 8;
				Pseq([
					\r,
					[0,7],
				],x),
				Pseq([
					\r,
					[0,8],
				],x),
				Pseq([
					\r,
					[0,9],
				],x),
				Pseq([
					\r,
					[0,7],
				],x),
			],inf),
			\octave, 6,
			\dur, 1/2,
			\lpfr, PmodEnv(Pseq([1,2,1,4],1), 8).loop,
			//\lag, Pseg(Pwhite(-0.1,0.1),4),
			\lag, 0.03,
			\legato, Ptuple(Pwhite(0.1,0.3)!2),
			\amp, 0.1/2,
			//\isRest, true,
			\out, BusDef(\ptm1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\ptm1, \audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0.1,
			\sendbus0, BusDef(\pfx2, \audio, 2),
			\dur, 1,
		),

		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> 
		Pbind(
			'wet10', 1.0,
			'mix', 0.52521008403361,
			'gain', 0.13697478991597,
			'fb', 0.0001,
			'delay', 0.000002764453196,
			'delay2', 0.00001,
			'shift', 0.01,
			'shift2', 0.02605042016807,
			'distamp', 57.610839222447,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 500,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 300,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		)

	])
)).play;
);

FileSystemProject.load("paramdev/drafts/PianoCenter.scd");
ProtoDef(\PianoCenter).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[304].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,0,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \superpw,
			\note, Pseq([
				0,
			],inf),
			\octave, 3,
			\legato, 0.1,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pbind(
			\instrument, \fmsaw,
			\fmenvamt, PmodEnv(Pseq([1,2,1,4],1), 8).loop,
			\lpenvamt, PmodEnv(Pseq([1,2,1,4],1), 6).loop,
			\note, Pseq([
				Pseq([
					Pseq([
						\r
					],7),
					0,
				],3),
				0,
				Pseq([
					\r
				],6),
				0,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.foley1[79].value,
			//\bufnum, ~buflib.foley1[~buflib.foley1.size.rand.debug("f")].value,
			\isRest, Pseq([
				1,0,0,0,
				0,0,0,0,
			],inf).coin.not,
			\speed, 0.4,
			\legato, 4,
			\dur, 1/1,
			\gain, 0.1/2,
			//\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1730].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\gain, 0.11,
			\out, BusDef(\pfx2, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\pfx2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.51,
			\room, 3,
			\dur, 1,
			\gain, 2,
		),

		Pbind(
			\instrument, \saw,
			\note, Pseq([
				x = 8;
				Pseq([
					\r,
					[0,7],
				],x),
				Pseq([
					\r,
					[0,8],
				],x),
				Pseq([
					\r,
					[0,9],
				],x),
				Pseq([
					\r,
					[0,7],
				],x),
			],inf),
			\octave, 6,
			\dur, 1/2,
			\lpfr, PmodEnv(Pseq([1,2,1,4],1), 8).loop,
			//\lag, Pseg(Pwhite(-0.1,0.1),4),
			\lag, 0.03,
			\legato, Ptuple(Pwhite(0.1,0.3)!2),
			\amp, 0.1/2,
			//\isRest, true,
			\out, BusDef(\ptm1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\ptm1, \audio),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0.1,
			\sendbus0, BusDef(\pfx2, \audio, 2),
			\dur, 1,
		),

		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		) <> 
		Pbind(
			'wet10', 1.0,
			'mix', 0.52521008403361,
			'gain', 0.13697478991597,
			'fb', 0.0001,
			'delay', 0.000002764453196,
			'delay2', 0.00001,
			'shift', 0.01,
			'shift2', 0.02605042016807,
			'distamp', 57.610839222447,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 500,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 300,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		)

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[304].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,1, 1,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				0,-5,-4,-7,-5,
			],inf).stutter(4),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			\lpfr, PmodEnv(Pseq([1,4,18,4,4,1,4,14,8],1), 1/1).loop,
			\legato, 1/2,
			\dur, Pseq([
				1,1,1,1/2,1/2,
			],inf).stutter(4)/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[336].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1164].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.3,0.7,1,0.7,
			],inf),
		),
	])
)).play;
);

PmodEnv.watchdogEnabled = true


////////////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	])
)).play;
);


/////



