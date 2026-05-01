(
~t = 183/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("capsule/draftsynth.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
)

/////// lib

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

//~protordn_to_fbstring.(ProtoDef(\rdn)).editorInsert
(

SynthDef(\rdn_darkhole, { arg out=0, gate=1;
	// code: 5-1JEH-BHCK
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
	thisThread.randSeed = 378260.0;
	si = sig;
	sig = { arg si, env;
		si = (si * 10.rand * \distamp.kr).tanh / 2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
		si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
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
	'mix', 0.20168067226891,
	'gain', 1.0,
	'fb', 0.0001,
	'delay', 0.00026312860738959,
	'delay2', 0.3012947724727,
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
	'posthpf', 20.0,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
)


);


(
Pdef(\part, Pdef(\scrash1, 
	Ppar([
		Pbind( // starting crash
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1730].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1,
			\gain, 0.11,
			\out, BusDef(\scrash, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\scrash, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0.51,
			\room, 3,
			\dur, 1,
			\gain, 2,
		),
		
	])
)).play;
);

//////////////////////////////////////////



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

//////////////////////////////////////////////

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
			\gain, 0.15,
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

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,1, 1,0,1,0,
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
				Pseq([
					0,0,1,0, 1,0,0,0,
					0,0,1,0, 0,0,1,0,
					1,0,1,0, 0,1,0,0.5,
					1,0,0,0, 0,0,0,0,
				],4),

				Pseq([
					0,0,1,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
					1,0,1,0, 0,1,0,0.5,
					1,0,0,0, 0,0,0,0,
				],3),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,1,0,
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 1,1,0,0.5,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pstep(Pseq([
				0,-5,-4,-7,-5,
			],inf),Pseq([
				1,1,1,1/2,1/2,
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			\lpfr, PmodEnv(Pseq([1,4,18,4,4,1,4,14,8],1), 1/4).loop,
			\legato, Pseq([
				1/2,1/2,1/2,1,
				1/2,1/2,1/2,1/2,
				1,1/2,1/2,1,
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
				Pseq([
					Pn(1/2,1),1/4,
					Pn(1/2,1),1/4,
					Pn(1/2,1),Pn(1/4,2),
					Pn(1/2,2),1/4,
					Pn(1/2,3),1/4,
				],2),
			],inf).stutter(1),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[336].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 1,1,1,1,
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

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
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
			\bufnum, ~buflib.hat[1837].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\legato, 1,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[658].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				0,-5,-4,-7,
			],inf),
			\note, Pstep(Pseq([
				3,-2,3,-12,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 5,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 3,
			\legato, Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,5,5-12,0,
				7+12,7, 7+12,7,
				3,5,5-12,0,
				7+12,7, 7-12,7,
				3,5,5-12,0,
				7-12,7, 7+12,7,
			],inf),
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
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
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1837].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\legato, 1,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[658].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				0,-5,-4,-7,
			],inf),
			\note, Pstep(Pseq([
				3,-2,3,-12,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 5,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 3,
			\legato, Pseq([
				1,
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
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
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1837].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\legato, 1,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[284].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\legato, 1,
			\dur, 1/8,
			\gain, 0.17 * Pseq([
				0.1,0.6,0.3,0.7,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[658].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				0,-5,-4,-7,
			],inf),
			\note, Pstep(Pseq([
				3,-2,3,-12,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 5,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,
				],inf),
				1,0,0,1, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.4,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \fmsaw,
	)
)
);
Pdef(\melo).edit
ProtoDef(\piano).startControl(Pdef(\melo))

PmodEnv.watchdogEnabled = true


////////////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	])
)).play;
);


/////



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.11,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[284].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.17 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[658].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\tinhat, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\tinhat, \audio),
			\out, BusDef(\tinhat1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_resonz,
			\inbus, BusDef(\tinhat1, \audio),
			\freq, PmodEnv(Pseq([100,4000,10000],1), 8,\exp).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				0,-5,-4,-7,
			],inf),
			\note, Pstep(Pseq([
				3,-2,3,-12,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 5,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
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
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.11,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[284].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.17 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[658].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\tinhat, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\tinhat, \audio),
			\out, BusDef(\tinhat1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_resonz,
			\inbus, BusDef(\tinhat1, \audio),
			\freq, PmodEnv(Pseq([100,4000,10000],1), 8,\exp).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				0,-5,-4,-7,
			],inf),
			\note, Pstep(Pseq([
				3,-2,3,-12,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 5,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pbind(
			\inbus, BusDef(\pad, \audio),
			\instrument, \fx_env,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, Psubdivide(Pseq([4,4,4,4, 4,4,3,2],inf), 1),
			\amp, 0.1,
			\out, BusDef(\pad1, \audio),
		),
		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pad1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			'wet10', 1.0,
			'mix', PmodEnv(Pseq([0,0,0.5,1,1],1), 8).loop,
			'gain', 0.43697478991597,
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
			'posthpf', 117,
			'wetamp', 0.26579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					1,1,0,1, 0,1,0,1,
					1,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0,  0,0,0,1/8/~t, 
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,[0,1/8/~t],

				0,0,0,0, 0,0,0,0,
				0,0,0,0,  0,0,0,0, 
				[0,1/8/~t],0,0,0, 0,0,0,0,
				0,0,0,0,  0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,1,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\speed, PmodEnv(Pseq([0.1,1,2],1), 8).loop,
			\dur, 1/8,
			\gain, 0.11,
			\lag, -0.04,
			\out, BusDef(\snare, \audio),
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1093].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11/2,
			),
		]),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\snare, \audio),
			\delay, Pseq([
				0,0,1/4/~t,0,
				0,0,Pwhite(0.1/~t,1/2/~t,1),0,
			],inf),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\snare1, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\snare1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1 + Pwhite(-0.1,0.1,inf),
			'wet10', 1.0,
			'mix', 0.20168067226891,
			'gain', 1.0,
			'fb', 0.0001,
			'delay', 0.00026312860738959,
			'delay2', Pseed(7327,Pseq([
				0.0001,
				Pwhite(0.3,0.6,1)
				//0.3012947724727,
			],inf).stutter(2)),
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
			'posthpf', 150.0,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					3,7,
				],8),
				Pser([
					5,8,
				],8),
			],inf),
			\octave, 5,
			\lpf, 400 * Pser([1,2,1.5,],16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
				[ Env.adsr(0.1,0.1,0.3,1.1) ],
			],inf),
			\envamt, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\mel1, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\mel1, \audio),
			\delay, Pseq([
				0,1/6,1/8,1/16,
			],inf).stutter(8)/~t,
			\hpf, 10000,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					1,1,0,1, 0,1,0,1,
					1,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0,  0,0,0,1/8/~t, 
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,[0,1/8/~t],

				0,0,0,0, 0,0,0,0,
				0,0,0,0,  0,0,0,0, 
				[0,1/8/~t],0,0,0, 0,0,0,0,
				0,0,0,0,  0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,1,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\speed, PmodEnv(Pseq([0.1,1,2],1), 8).loop,
			\dur, 1/8,
			\gain, 0.11,
			\lag, -0.04,
			\out, BusDef(\snare, \audio),
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1093].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\snare, \audio),
			\delay, Pseq([
				0,0,1/4/~t,0,
				0,0,Pwhite(0.1/~t,1/2/~t,1),0,
			],inf),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\snare1, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\snare1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1 + Pwhite(-0.1,0.1,inf),
			'wet10', 1.0,
			'mix', 0.20168067226891,
			'gain', 1.0,
			'fb', 0.0001,
			'delay', 0.00026312860738959,
			'delay2', Pseed(7327,Pseq([
				0.0001,
				Pwhite(0.3,0.6,1)
				//0.3012947724727,
			],inf).stutter(2)),
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
			'posthpf', 100.0,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					3,7,
				],8),
				Pser([
					5,8,
				],8),
			],inf),
			\octave, 5,
			\lpf, 400 * Pser([1,2,1.5,],16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
				[ Env.adsr(0.1,0.1,0.3,1.1) ],
			],inf),
			\envamt, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\mel1, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\mel1, \audio),
			\delay, Pseq([
				0,1/6,1/8,1/16,
			],inf).stutter(8)/~t,
			\hpf, 10000,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\note, Pseq([
				3,0,-2,-4,
				-2,\r,-2,-4,
				-5,\r,-2,-4,
				-2,\r,-2,-4,

				-5,\r,-2,3,
				-2,\r,-2,-4,
				-5,\r,3,0,
				-2,-5,-7,-4,
			],inf),
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1/4/~t,0,0,
			],inf),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.051,
		),
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
			\gain, 0.15,
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
				Pseq([
					0,0,1,0, 0,0,1,0,
				],4),
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\clap, \audio),
		),
		//Pmono(\fx_freeverb2,
			//\inbus, BusDef(\clap, \audio),
			//\addAction, \addToTail,
			//\lag, 0.0009,
			//\dur, 1,
		//),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\clap, \audio),
			\addAction, \addToTail,
			\delay2, Pseq([
				Pser([
					0.0004,
				],5),
				0.201,
				0.7,0.6005,
			],inf).stutter(2),
			\mix, PmodEnv(Pseq([0,0.2,0.4],1), 8).loop,
			\lag, 0.0009,
			\dur, 1,
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
			\gain, 0.11* Pseq([
				Pwhite(0,1,1),Pser([1],7)
			],inf),
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


///// seq

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
			\gain, 0.15,
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
			\isRest, true,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),1),
			\octave, 5,
			\fmf, 4193.43,
			\fma, 1,
			\lpfr, PmodEnv(Pseq([1,4,18,4,4,1,4,14,8],1), 1/1).loop,
			\legato, 2,
			\dur, Psubdivide(Pseq([2,1,2,4],inf), 1/2),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),1),
			\octave, 6,
			\legato, 0.1,
			\isRest, Pseq([
				1,0,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\pintro, 
	Pfindur(16,Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],3),
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
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
			\isRest, true,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),1),
			\octave, 5,
			\fmf, 4193.43,
			\fma, 1,
			\lpfr, PmodEnv(Pseq([1,4,18,4,4,1,4,14,8],1), 4/1).loop,
			\legato, 2,
			\dur, Psubdivide(Pseq([2,1,2,4],inf), 4),
			\amp, 0.1,
			\out, BusDef(\nap, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),1),
			\octave, 6,
			\legato, 0.1,
			\isRest, Pseq([
				1,0,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\nap, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\nap, \audio),
			\addAction, \addToTail,
			\delay, 0.901,
			\delay2, 0.901,
			\mix, PmodEnv(Pseq([0,Pn(0.5,inf)],1), 8).loop,
			\delay2, PmodEnv(Pseq([0,0,0,0,Pn(0.9,inf)],1)+0.01, 2).loop,
			\delay, PmodEnv(Pseq([0,0,0,0,Pn(0.9,inf)],1), 2).loop,
			\distamp, PmodEnv(Pseq([0.1,0.1,2],1), 8).loop,
			\lag, 0.0009,
			\posthpf, PmodEnv(Pseq([10,10,15000,15000],1), Pseq([14,2,16])).loop,
			\gain, PmodEnv(Pseq([0.001,Pn(0.5,inf)],1), 4,\exp).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,8.1) ],
			],inf),
			\dur, 1,
		),
		Ptpar([
			12, Pbind(
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
		]),
	]))
)).play;
);

(
Pdef(\part, Pdef(\ppart1, 
	Pfindur(32,Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],30),
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pfindur(30,Ptpar([
			4, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1563].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			0, Pbind(
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
			0,Pfindur(30,Pbind( // bass
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
			)),
			8, Pfindur(32-8-2,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			)),
			16,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[658].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		])),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,5,5-12,0,
				7+12,7, 7+12,7,
				3,5,5-12,0,
				7+12,7, 7-12,7,
				3,5,5-12,0,
				7-12,7, 7+12,7,
			],inf),
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,100,500,4000,5000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, PmodEnv(Pseq([0,0,1,0.91],1) * 0.05, Pseq([4,4,24])).loop,
		),
		Pbind(
			\instrument, \iron,
			\fmr, 4.0,
			\diff, 1.0,
			\fmamp, 1.0,
			\foldfreq, 1.0*~t,
			\foldlevel, 1.0,
			\foldbias, 1.0,
			\env1, [ Env([ 1.0099999904633, 0.0099999997764826, 1.0099999904633 ], [ 0.10000000149012, 0.80000001192093 ], [ 0.0, 0.0 ]) ],
			\trigenv, 1.0,
			\lpfr, PmodEnv(Pseq([1,4,8,8,8],1), 8).loop,
			\rq, 0.5,
			\panfreq, 1.0,
			\panwidth, 1.0,
			\hpf, 10.0,
			\gain, 4.0,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\octave, 5,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.011,
		),

	]))
)).play;
);

(
Pdef(\part, Pdef(\ppart2, 
	Pfindur(32,Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],30),
					1,0,0,0, 1,0,0,0,
					0,0,1,0, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pfindur(30,Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1563].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pser([
						0,0,0,0, 1,0,0,0,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			0, Pbind(
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
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11 * Pseq([
					0.3,0.7,1,0.7,
				],inf),
			),
			//0,Pfindur(30,Pbind( // bass
				//\instrument, \simplefm,
				//\note, Pseq([
					//0,-5,-4,-7,-5,
				//],inf).stutter(4),
				//\octave, 3,
				//\fmf, 4193.43,
				//\fma, 1,
				//\lpfr, PmodEnv(Pseq([1,4,18,4,4,1,4,14,8],1), 1/1).loop,
				//\legato, 1/2,
				//\dur, Pseq([
					//1,1,1,1/2,1/2,
				//],inf).stutter(4)/4,
				//\amp, 0.1,
			//)),
			0, Pbind( // bass
				\instrument, \sh101,
				\note, Pstep(Pseq([
					0,-5,-4,-7,
				],inf),Pseq([
					1,1,1
				],inf)),
				\octave, 3,
				\fmf, 4193.43,
				\fma, 1,
				//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
				\lpfr, 5,
				\legato, Pseq([
					0.71,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.5,0.01) ],
				],inf),
				\isRest, Pseq([
					Pser([
						0,1,0,1, 0,1,0,1,
						0,1,0,1, 0,1,0,1,
						0,1,0,1, 0,1,0,1,
						0,1,0,1, 0,1,1,1,
					],7*8),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\lag, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,[0,1/8/~t],
					0,0,0,0, 0,0,0,0,
					0,[0,1/8/~t],0,0, 0,0,0,0, 
				],inf),
				\dur, Pseq([
					Pseq([
						1/4,
					],8*6),
				],inf).stutter(1),
				\amp, 0.2,
			),
			0, Pfindur(32-8-2,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						0,0,1,0, 0,0,1,0,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			)),
			0,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[658].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,0, 1,0,1,0,

					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			0, Pbind(
				\instrument, \Piano_rhodeySC,
				\note, Pseq([
					3,0,-2,-4,
					-2,\r,-2,-4,
					-5,\r,-2,-4,
					-2,\r,-2,-4,

					-5,\r,-2,3,
					-2,\r,-2,-4,
					-5,\r,3,0,
					-2,-5,-7,-4,
				],inf),
				\lag, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1/4/~t,0,0,
				],inf),
				\octave, 5,
				\dur, 1/2,
				\amp, 0.051,
				\out, BusDef(\rhodey, \audio),
			),
			0, Pmono(\fx_greyhole,
				\inbus, BusDef(\rhodey, \audio),
				\addAction, \addToTail,
				\mix, PmodEnv(Pseq([1,1,0,0.1,0.1],1), Pseq([8,2,6,16])).loop,
				\delay, 0.001,
				\gain, PmodEnv(Pseq([0,0.1,1,1],1), Pseq([8+4,4,16])).loop,
				\lag, 0.0009,
				\dur, 1,
			),
		])),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				3,5,5-12,0,
				7+12,7, 7+12,7,
				3,5,5-12,0,
				7+12,7, 7-12,7,
				3,5,5-12,0,
				7-12,7, 7+12,7,
			],inf),
			\octave, 5,
			\legato, 0.8,
			\adsr, Pseq([
				PpatEnv.adsr(Pseg(Pseq([0.1,0.01,0.01],1),8).loop,0.1,Pseg(Pseq([0.8,0.3,0.3],1),8).loop,0.1),
			],inf),
			\lpf, PmodEnv(Pseq([5000,500,100],1), 8,\exp).loop,
			\envamt, PmodEnv(Pseq([1,10,20],1), 8).loop,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, PmodEnv(Pseq([0.91,0.9],1) * 0.05, Pseq([4,4,24])).loop,
		),
		Pbind(
			\instrument, \iron,
			\fmr, 4.0,
			\diff, 1.0,
			\fmamp, 1.0,
			\foldfreq, 1.0*~t,
			\foldlevel, 1.0,
			\foldbias, 1.0,
			\env1, [ Env([ 1.0099999904633, 0.0099999997764826, 1.0099999904633 ], [ 0.10000000149012, 0.80000001192093 ], [ 0.0, 0.0 ]) ],
			\trigenv, 1.0,
			\lpfr, PmodEnv(Pseq([8,8],1), 8).loop,
			\rq, 0.5,
			\panfreq, 1.0,
			\panwidth, 1.0,
			\hpf, 10.0,
			\gain, 4.0,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\octave, 5,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.011,
		),

	]))
)).play;
);

(
Pdef(\part, Pdef(\ppart3, 
	Ppar([
		Ptpar([
			16,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1505].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					Pseq([
						1,0,0,0, 1,0,0,0,
					],14),
					1,0,0,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.15,
			),
			0, Ppar([
				Pbind(
					\instrument, \Piano_rhodeySC,
					\note, Pseq([
						3,0,-2,-4,
						-2,\r,-2,-4,
						-5,\r,-2,-4,
						-2,\r,-2,-4,

						-5,\r,-2,3,
						-2,\r,-2,-4,
						-5,\r,3,0,
						-2,-5,-7,-4,
					],inf),
					\lag, Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,

						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,1/4/~t,0,0,
					],inf),
					\octave, 5,
					\dur, 1/2,
					\amp, 0.051,
					\out, BusDef(\rhodey, \audio),
				),
				Pmono(\fx_greyhole,
					\inbus, BusDef(\rhodey, \audio),
					\addAction, \addToTail,
					\mix, 0.5,
					\delay, 1/2,
					\gain, 1,
					\lag, 0.0009,
					\dur, 1,
					\out, BusDef(\rhodey1, \audio),
				),
				Pmono(\fx_hpf,
					\inbus, BusDef(\rhodey1, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([100,200,400,100],1), 8).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
			4, Ppar([
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
					\out, BusDef(\hat, \audio),
				),
				Pmono(\rdn_darkhole,
					\inbus, BusDef(\hat, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
					'wet10', 1.0,
					'mix', 0.52521008403361,
					'gain', 0.43697478991597,
					'fb', 0.0001,
					'delay', 0.55962764453196,
					'delay2', PmodEnv(Pseq([0.001,0.4],1), 16,\exp).loop,
					'shift', 0.0,
					'shift2', 0.12605042016807,
					'distamp', 0.610839222447,
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
				),
			]),
			8, Pbind(
				\instrument, \simplefm,
				\note, Pstep(Pseq([
					0,-5,-4,-7,
				],inf),Pseq([
					1,1,1
				],inf)),
				\octave, 3,
				\fmf, 4193.43,
				\fma, 1,
				//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
				\lpfr, 3,
				\legato, Pseq([
					1,
				],inf),
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,1,0,0, 1,0,0,1,
				],inf).coin.not,
				\dur, Pseq([
					Pseq([
						1/4,
					],8*6),
				],inf).stutter(1),
				\amp, 0.1,
			),
			8,Ppar([
				Pbind(
					\instrument, \sh101,
					\note, Pseq([
						Pser([
							3,7,
						],8),
						Pser([
							5,8,
						],8),
					],inf),
					\octave, 5,
					\lpf, 400 * Pser([1,2,1.5,],16).loop,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.3,1.1) ],
						[ Env.adsr(0.1,0.1,0.3,1.1) ],
					],inf),
					\envamt, PmodEnv(Pseq([1,2,4],1), 8).loop,
					\dur, 1/4,
					\amp, 0.1,
					\out, BusDef(\mel1, \audio),
				),
				Pmono(\rdn_darkhole,
					\inbus, BusDef(\mel1, \audio),
					\hpf, 10000,
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
					'wet10', 1.0,
					'mix', 0.52521008403361,
					'gain', PmodEnv(Pseq([0,1,1],1)*0.4, Pseq([2,30],inf)).loop,
					'fb', 0.0001,
					'delay2', 0.55962764453196,
					'delay', PmodEnv(Pseq([0.001,0.4],1), 16,\exp).loop,
					'shift', 0.0,
					'shift2', 0.12605042016807,
					'distamp', 0.610839222447,
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
				),
			]),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\ppart4, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					1,1,0,1, 0,1,0,1,
					1,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0,  0,0,0,1/8/~t, 
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,[0,1/8/~t],

				0,0,0,0, 0,0,0,0,
				0,0,0,0,  0,0,0,0, 
				[0,1/8/~t],0,0,0, 0,0,0,0,
				0,0,0,0,  0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 1,0,1,0,
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,1,0,1, 0,0,1,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\speed, PmodEnv(Pseq([1,1,1,2,1],1), Pseq([8,2,6,16])).loop,
			\dur, 1/8,
			\gain, 0.11,
			\lag, -0.04,
			\out, BusDef(\snare, \audio),
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1093].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\snare, \audio),
			\delay, Pseq([
				0,0,1/4/~t,0,
				0,0,Pwhite(0.1/~t,1/2/~t,1),0,
			],inf),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\sendbus1, \audio),
			\out, BusDef(\snare1, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\snare1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1 + Pwhite(-0.1,0.1,inf),
			'wet10', 1.0,
			'mix', 0.70168067226891,
			'gain', 0.9,
			'fb', 0.0001,
			'delay', 0.00026312860738959,
			'delay2', Pseed(7327,Pseq([
				0.0001,
				Pwhite(0.3,0.9,1)
				//0.3012947724727,
			],inf).stutter(Pseq([12,4+16],inf))),
			//'delay2', Pseed(7331,Pseq([
				//0.0001,
				//Pwhite(0.3,0.9,1)
				////0.3012947724727,
			//],inf)),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', Pseq([
				Pseq([
					0.1,
				],12),
				Pseq([
					1.2,
				],4+16),
			],inf),
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 100.0,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\out, BusDef(\snare2, \audio),
		),
		Pmono(\fx_limiter,
			\inbus, 20.0,
			\level, 0.1,
			\limdur, 0.0099999997764826,
			\mix, 1.0,
			\gain, 1.0,
			\inbus, BusDef(\snare2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					3,7,
				],8),
				Pser([
					5,8,
				],8),
			],4*2),
			\octave, 5,
			\lpf, 400 * Pser([1,2,1.5,],16).loop,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.3,1.1) ],
				[ Env.adsr(0.1,0.1,0.3,1.1) ],
			],inf),
			\envamt, PmodEnv(Pseq([1,2,4],1), 8).loop,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\mel1, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\mel1, \audio),
			\delay, Pseq([
				0,1/6,1/8,1/16,
			],inf).stutter(8)/~t,
			\hpf, 1000,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\mel2, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\mel2, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([100,1200,5000],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \Piano_rhodeySC,
			\note, Pseq([
				3,0,-2,-4,
				-2,\r,-2,-4,
				-5,\r,-2,-4,
				-2,\r,-2,-4,

				-5,\r,-2,3,
				-2,\r,-2,-4,
				-5,\r,3,0,
				-2,-5,-7,-4,
			],1),
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1/4/~t,0,0,
			],inf),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.051,
		),
		Ptpar([
			8, Ppar([
				Pbind(
					\instrument, \snappad,
					\note, Pseq([
						[0,3,7],
						[0,5,8],
					],inf),
					\legato, 1,
					\adsr, Pseq([
						[ Env.adsr(0.01,6/~t,0.3,1.1) ],
					],inf),
					\octave, 6,
					\dur, 8,
					\amp, 0.1,
					\out, BusDef(\pad, \audio),
				),
				Pbind(
					\inbus, BusDef(\pad, \audio),
					\instrument, \fx_env,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.8,0.01) ],
					],inf),
					\isRest, Pseq([
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,0,1,0,
					],inf).coin.not,
					\dur, Psubdivide(Pseq([4,4,4,4, 4,4,3,2],inf), 1),
					\amp, 0.1,
					\out, BusDef(\pad1, \audio),
				),
				Pmono(\rdn_terrorbass,
					\inbus, BusDef(\pad1, \audio),
					\addAction, \addToTail,
					\lag, 0.0009,
					\dur, 1,
					'wet10', 1.0,
					'mix', PmodEnv(Pseq([0,0,0.5,1,1],1), 8).loop,
					'gain', 0.4,
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
					'posthpf', 117,
					'wetamp', 0.26579739809918,
					'indelay', 0.04,
					'wet20', 1.0,
					'mamp', 1,
				),
			]),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\ppart6, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.11,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[284].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.17 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[658].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\tinhat, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\tinhat, \audio),
			\out, BusDef(\tinhat1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_resonz,
			\inbus, BusDef(\tinhat1, \audio),
			\freq, PmodEnv(Pseq([100,4000,10000],1), 8,\exp).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				0,-5,-4,-7,
			],inf),
			\note, Pstep(Pseq([
				3,-2,3,-12,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 5,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,0,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/4,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pbind(
			\inbus, BusDef(\pad, \audio),
			\instrument, \fx_env,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, Psubdivide(Pseq([4,4,4,4, 4,4,3,2],inf), 1),
			\amp, 0.1,
			\out, BusDef(\pad1, \audio),
		),
		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pad1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			'wet10', 1.0,
			'mix', PmodEnv(Pseq([0,0,0.5,1,1],1), 8).loop,
			'gain', 0.43697478991597,
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
			'posthpf', 117,
			'wetamp', 0.26579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
		Pbind( // starting crash
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1730].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
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
	])
)).play;
);

(
Pdef(\part, Pdef(\ppart5, 
	Ppar([
		
		Pbind( // starting crash
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1730].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snare, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\snare, \audio),
			\addAction, \addToTail,
			\delay, 0.8,
			\delay2, 0.8,
			\mix, Pseq([
				PmodEnv(Pseq([0,0,1,1,0,0],1), Pseq([8,1,7,1,7+8])).loop,
			],inf),
			\lag, 0.0009,
			\dur, 1,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.11,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[284].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.17 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[658].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\tinhat, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\tinhat, \audio),
			\out, BusDef(\tinhat1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_resonz,
			\inbus, BusDef(\tinhat1, \audio),
			\freq, PmodEnv(Pseq([100,4000,10000],1), 8,\exp).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],1),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pser([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],8*4),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pbind(
			\inbus, BusDef(\pad, \audio),
			\instrument, \fx_env,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, Psubdivide(Pseq([4,4,4,4, 4,4,3,2],inf), 1),
			\amp, 0.1,
			\out, BusDef(\pad1, \audio),
		),
		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pad1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			'wet10', 1.0,
			'mix', PmodEnv(Pseq([0,0,0.5,1,1],1), 8).loop,
			'gain', 0.43697478991597,
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
			'posthpf', 117,
			'wetamp', 0.26579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
	])
)).play;
);

(
///// seq1
Pdef(\part, Pdef(\seq1, 
	Pseq([
		Pdef(\pintro),
		Pfindur(32,Pdef(\ppart1)),
		Pfindur(32,Pdef(\ppart2)),
		Pfindur(32,Pdef(\ppart3)),
		Pfindur(32,Pdef(\ppart5)),
		Pfindur(16,Pdef(\xpart2)),
		Pfindur(16,Pdef(\xpart3)),
		Pfindur(32,Pdef(\ppart6)),
		Pfindur(32,Pdef(\ppart4)),
		
	])
)).play;
);


/////////////////

(
Pdef(\part, Pdef(\xpart1, 
	Ppar([
		
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],8*4),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snare, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\snare, \audio),
			\addAction, \addToTail,
			\delay, 0.8,
			\delay2, 0.8,
			\mix, Pseq([
				PmodEnv(Pseq([0,0,1,1,0,0],1), Pseq([8,1,3,1,4+7+8])).loop,
			],inf),
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\xpart2, 
	Ppar([
		
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],8*4),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snare, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\snare, \audio),
			\addAction, \addToTail,
			\delay, 0.8,
			\delay2, 0.8,
			\mix, Pseq([
				PmodEnv(Pseq([0,0,1,1,0,0],1), Pseq([8,1,3,1,4+7+8])).loop,
			],inf),
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1730].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
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
		Ptpar([
			
			12, Pfindur(32-8-2,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 0,0,1,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			)),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\xpart3, 
	Ppar([
		
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],8*4),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snare, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\snare, \audio),
			\addAction, \addToTail,
			\delay, 0.8,
			\delay2, 0.8,
			\mix, Pseq([
				PmodEnv(Pseq([0,0,1,1,0,0],1), Pseq([8,1,3,1,4+7+8])).loop,
			],inf),
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // starting crash
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1730].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
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
		Ptpar([
			
			0, Pfindur(32-8-2,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],4),
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,1,1,0,
					1,0,1,0, 1,1,1,0,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],4),
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			)),
			0,Pbind(
				\instrument, \sh101,
				\legato, 0.2,
				\note, Pseq([
					3,5,5-12,0,
					0,0,0,0,
				],inf),
				\isRest, Pseq([
					1,1,1,1,
					0,0,0,0,
				],inf).coin.not,
				\octave, 5,
				\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
				\envamt, 2,
				//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
				\rq, 0.5,
				\dur, 1/4,
				\amp, 0.071,
			),
			0,Pbind(
				\instrument, \snappad,
				\note, Pseq([
					[0,3,7],
					[0,5,8],
				],inf),
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(0.01,6/~t,0.3,1.1) ],
				],inf),
				\octave, 6,
				\dur, 8,
				\amp, 0.1,
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\xpart4, 
	Ppar([
		
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],8*4),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snare, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\snare, \audio),
			\addAction, \addToTail,
			\delay, 0.8,
			\delay2, 0.8,
			\mix, Pseq([
				PmodEnv(Pseq([0,0,1,1,0,0],1), Pseq([8,1,3,1,4+7+8])).loop,
			],inf),
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // starting crash
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1730].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
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
		Ptpar([
			
			0, Pfindur(32-8-2,Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],4),
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,0,1,0,
					0,0,1,0, 0,1,1,0,
					1,0,1,0, 1,1,1,0,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],4),
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			)),
			0,Pbind(
				\instrument, \sh101,
				\legato, 0.2,
				\note, Pseq([
					3,5,5-12,0,
					0,0,0,0,
				],inf),
				\isRest, Pseq([
					1,1,1,1,
					0,0,0,0,
				],inf).coin.not,
				\octave, 5,
				\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
				\envamt, 2,
				//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
				\rq, 0.5,
				\dur, 1/4,
				\amp, 0.071,
			),
			0,Pbind(
				\instrument, \snappad,
				\note, Pseq([
					[0,3,7],
					[0,5,8],
				],inf),
				\legato, 1,
				\adsr, Pseq([
					[ Env.adsr(0.01,6/~t,0.3,1.1) ],
				],inf),
				\octave, 6,
				\dur, 8,
				\amp, 0.1,
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\xpart5, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
			\out, BusDef(\kick, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\kick, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1 + Pwhite(-0.1,0.1,inf),
			'wet10', 1.0,
			'mix', 0.20168067226891,
			'mix', PmodEnv(Pseq([0.3,0.3,0],1), 8).loop,
			'gain', 1.0,
			'fb', 0.0101,
			'delay', 0.10026312860738959,
			'delay2', Pseed(7327,Pseq([
				0.0001,
				//0.3012947724727,
			],inf).stutter(2)),
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 471.2492192141522,
			//'distamp', PmodEnv(Pseq([501,0.2,0.2],1), 8).loop,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 100.0,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\out, BusDef(\kick1, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\kick1, \audio),
			\addAction, \addToTail,
			\hpf, PmodEnv(Pseq([6000,Pn(10,4)],1), 8,\exp).loop,
			\lag, 0.0009,
			\dur, 1,
		),
		Ptpar([
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			),
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[284].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,0,1,0,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.17 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
			12, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1563].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			0, Ppar([
					Pbind( // bass
						\instrument, \sh101,
						\note, Pstep(Pseq([
							0,-5,-4,-7,
						],inf),Pseq([
							1,1,1
						],inf)),
						\octave, 3,
						\fmf, 4193.43,
						\fma, 1,
						//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
						\lpfr, 5,
						\legato, Pseq([
							0.71,
						],inf),
						\adsr, Pseq([
							[ Env.adsr(0.01,0.1,0.5,0.01) ],
						],inf),
						\isRest, Pseq([
							Pser([
								1,1,1,1, 1,1,1,1,
								1,0,1,1, 1,1,1,1,
				
							],8*8),
							Pseq([
								0,0,0,0, 0,0,0,0,
							],4),
							Pser([
								1,1,1,1, 1,1,1,1,
								0,0,0,0, 0,0,0,0,
							],8*4),
						],inf).coin.not,
						\lag, Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,0, 0,0,0,[0,1/8/~t],
							0,0,0,0, 0,0,0,0,
							0,[0,1/8/~t],0,0, 0,0,0,0, 
						],inf),
						\dur, Pseq([
							Pseq([
								1/4,
							],8*6),
						],inf).stutter(1),
						\amp, 0.2,
						\out, BusDef(\bass, \audio),
					),
				Pmono(\fx_hpf,
					\inbus, BusDef(\bass, \audio),
					\addAction, \addToTail,
					\hpf, PmodEnv(Pseq([6000,100,10],1), 8,\exp).loop,
					\lag, 0.0009,
					\dur, 1,
				),
			]),
		]),
		
	])
)).play;
);

/////////////////////////////
// study: remove
// - kick & bass
// - hat & snare
// - treb & nap


(
// all
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1093].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
						1,1,1,1,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.10 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\gain, 0.5,
			\dur, 1,
		),
		
	])
)).play;
);

(
// remove kick & bass
Pdef(\part, Pdef(\rempart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1093].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
						1,1,1,1,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.10 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

				],1),
				Pser([
					0,0,0,0, 0,0,0,0,

				],8*4),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\gain, 0.5,
			\dur, 1,
		),
		
	])
)).play;
);

(
// remove hat & snare
Pdef(\part, Pdef(\rempart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1563].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 1,0,0,0,
					],7),
					0,0,1,0, 0,0,0,0,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],8),
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
					Pseq([
						0,0,0,0, 0,0,0,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[284].value,
				\bufnum, ~buflib.hat[1093].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
						1,1,1,1,
					],8*8),
					Pser([
						0,
					],8*8),
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.10 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\gain, 0.5,
			\dur, 1,
		),
		
	])
)).play;
);

(
// remove treb & nap
Pdef(\part, Pdef(\rempart3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1093].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
						1,1,1,1,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.10 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],1),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				Pser([
					1,1,1,1,
					0,0,0,0,
				],8*4),
				Pser([
					0,0,0,0,
				],8*4),
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				\r,
				//[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\gain, 0.5,
			\dur, 1,
		),
		
	])
)).play;
);


(
// rempart seq
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pfindur(16, Pdef(\rempart1)),
		Pfindur(16, Pdef(\rempart2)),
		Pfindur(16, Pdef(\rempart3)),
		
	])
)).play;
);

////// shorter


(
// remove kick & bass & hat & snare after 4 beat
Pdef(\part, Pdef(\remshortpart1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],3),
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],2),
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],4),
					Pseq([
						0,0,0,0, 0,0,0,0,
					],4),
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1093].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
						1,1,1,1,
					],8*4),
					Pser([
						0,0,0,0, 0,0,0,0,
					],8*4),
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.10 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,

				],1),
				Pser([
					0,0,0,0, 0,0,0,0,

				],8*2),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\gain, 0.5,
			\dur, 1,
		),
		
	])
)).play;
);

(
// remove kick & bass & hat & snare after 4 beat
// and replace by some sound
Pdef(\part, Pdef(\remshortpart2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],3),
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],2),
				0,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Ptpar([
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],4),
					Pseq([
						0,0,0,0, 0,0,0,0,
					],4),
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.07,
			),
			0, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1093].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
						1,1,1,1,
					],8*4),
					Pser([
						0,0,0,0, 0,0,0,0,
					],8*4),
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.10 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,

				],1),
				Pser([
					0,0,0,0, 0,0,0,0,

				],8*2),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pmono(\fx_echodiff,
			\inbus, BusDef(\pad, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\gain, 0.5,
			\dur, 1,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],1),
			\octave, 6,
			\lpf, 10000,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\lifter, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,
			],inf),
			\octave, 5,
			\lpf, PmodEnv(Pseq([10,100,12000],1), 4,\exp).loop,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\lifter, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\lifter, \audio),
			\addAction, \addToTail,
			\room, 4,
			\mix, 0.8,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\lifter2, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\lifter2, \audio),
			\addAction, \addToTail,
			\hpf, 1000,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
// rempart seq
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pfindur(8, Pdef(\remshortpart2)),
		Pfindur(32, Pdef(\ppart6)),
		
	])
)).play;
);
//////
(
	// orig
Pdef(\part, Pdef(\ppart5, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1563].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 1,0,0,0,
				],14),
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\snare, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\snare, \audio),
			\addAction, \addToTail,
			\delay, 0.8,
			\delay2, 0.8,
			\mix, Pseq([
				PmodEnv(Pseq([0,0,1,1,0,0],1), Pseq([8,1,7,1,7+8])).loop,
			],inf),
			\lag, 0.0009,
			\dur, 1,
		),
		Ptpar([
			8, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1837].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pseq([
						0,0,1,0, 0,0,1,0,
					],7),
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.11,
			),
			16, Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[284].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					Pser([
						1,1,1,1,
					],8*14),
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\legato, 1,
				\dur, 1/8,
				\gain, 0.17 * Pseq([
					0.1,0.6,0.3,0.7,
				],inf),
			),
		]),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[658].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\tinhat, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\tinhat, \audio),
			\out, BusDef(\tinhat1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_resonz,
			\inbus, BusDef(\tinhat1, \audio),
			\freq, PmodEnv(Pseq([100,4000,10000],1), 8,\exp).loop,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				0,-5,-4,-7,
			],inf),Pseq([
				1,1,1
			],inf)),
			\octave, 3,
			\fmf, 4193.43,
			\fma, 1,
			//\lpfr, PmodEnv(Pseq([1,18],1), 4).loop,
			\lpfr, 5,
			\legato, Pseq([
				0.71,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.5,0.01) ],
			],inf),
			\isRest, Pseq([
				Pseq([
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,1,1,

					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,1,0,1, 0,1,0,1,
					0,0,0,0, 0,0,0,0,
				],1),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pser([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],8*4),
			],inf).coin.not,
			\lag, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,[0,1/8/~t],
				0,0,0,0, 0,0,0,0,
				0,[0,1/8/~t],0,0, 0,0,0,0, 
			],inf),
			\dur, Pseq([
				Pseq([
					1/4,
				],8*6),
			],inf).stutter(1),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \snappad,
			\note, Pseq([
				[0,3,7],
				[0,5,8],
			],inf),
			\legato, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,6/~t,0.3,1.1) ],
			],inf),
			\octave, 6,
			\dur, 8,
			\amp, 0.1,
			\out, BusDef(\pad, \audio),
		),
		Pbind(
			\inbus, BusDef(\pad, \audio),
			\instrument, \fx_env,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\dur, Psubdivide(Pseq([4,4,4,4, 4,4,3,2],inf), 1),
			\amp, 0.1,
			\out, BusDef(\pad1, \audio),
		),
		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pad1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			'wet10', 1.0,
			'mix', PmodEnv(Pseq([0,0,0.5,1,1],1), 8).loop,
			'gain', 0.43697478991597,
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
			'posthpf', 117,
			'wetamp', 0.26579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				1,1,1,1,
				0,0,0,0,
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
	])
)).play;
);

//////////
// breakbeat


(
Pdef(\part, Pdef(\bbpart1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],14),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],6),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 84/2/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),4).loop / Pkey(\st),
			\dur, 1/4,
			\gain, 1/8,
			\lag, -0.04,
			\out, BusDef(\vbreak, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\vbreak, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1 + Pwhite(-0.1,0.1,inf),
			'wet10', 1.0,
			'mix', 0.20168067226891,
			'gain', 1.0,
			'fb', 0.0001,
			'delay', 0.00026312860738959,
			'delay2', Pseed(7327,Pseq([
				0.0001,
				Pwhite(0.3,0.6,1)
				//0.3012947724727,
			],inf).stutter(2)),
			\delay2, 0.0001,
			'shift', -0.1,
			'shift2', 0.0,
			'distamp', 100.2492192141522,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', PmodEnv(Pseq([1000,200,1400],1), 8).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[732].value,
			\bufnum, ~buflib.hat[1609].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				Pseq([
					1,1,1,1,
					0,0,0,0,
				],2),
				Pseq([
					1,1,1,1,
					1,1,1,1,
				],6),
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\bbpart2, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],11),
				1,0,0,0, 1,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.15,
			\out, BusDef(\kicktrack, \audio),
		),
		Pmono(\fx_sidechain,
			\inbus, BusDef(\basstrack, \audio),
			\sideinbus, BusDef(\kicktrack, \audio),
			\addAction, \addToTail,
			\lag, 0.00093,
			\sideout, 0,
			\sidegain, 1,
			\cpt, 0.011,
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
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 84/2/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),4).loop / Pkey(\st),
			\dur, 1/4,
			\gain, 1/8,
			\lag, -0.04,
			\out, BusDef(\vbreak, \audio),
		),
		Pmono(\rdn_darkhole,
			\inbus, BusDef(\vbreak, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1 + Pwhite(-0.1,0.1,inf),
			'wet10', 1.0,
			'mix', 0.50168067226891,
			'gain', 1.0,
			'fb', 0.001,
			'delay', 0.00026312860738959,
			\delay2, 0.7001,
			'shift', -0.1,
			'shift2', 0.0,
			'distamp', 100.2492192141522,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 1700,
			'posthpf', PmodEnv(Pseq([1500,200,1400],1), 8).loop,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\out, BusDef(\vbreak2, \audio),
		),
		Pmono(\tracksummer,
			\inbus, BusDef(\vbreak2, \audio),
			\inbus2, BusDef(\bass, \audio),
			\addAction, \addToTail,
			\lag, 0.00092,
			\dur, 1,
			\out, BusDef(\basstrack, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[732].value,
			\bufnum, ~buflib.hat[1609].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \sh101,
			\legato, 0.2,
			\note, Pseq([
				3,5,5-12,0,
				0,0,0,0,
			],inf),
			\isRest, Pseq([
				Pseq([
					1,1,1,1,
					1,1,1,1,
				],6),
			],inf).coin.not,
			\octave, 5,
			\lpf, PmodEnv(Pseq([4000,500,4000],1), 8,\exp).loop,
			\envamt, 2,
			//\envamt, PmodEnv(Pseq([0.1,2,8],1), 8).loop,
			\rq, 0.5,
			\dur, 1/4,
			\amp, 0.071,
		),
		Ptpar([
			16, Pbind(
			   	\instrument, \simplefm,
			   	\note, Pstep(Pseq([
			   		0,-5,-4,-7,-5,
			   	],inf),Pseq([
			   		1,1,1,1/2,1/2,
			   	],inf)),
			   	\octave, 3,
			   	\fmf, 4193.43,
			   	\fma, 1,
			   	\lpfr, PmodEnv(Pseq([1,4,18,4,4,1,4,14,8],1), 1/4).loop,
			   	\legato, Pseq([
			   		1/2,1/2,1/2,1,
			   		1/2,1/2,1/2,1/2,
			   		1,1/2,1/2,1,
			   	],inf),
			   	\dur, Pseq([
			   		Pseq([
			   			1/4,
			   		],8*6),
			   		Pseq([
			   			Pn(1/2,1),1/4,
			   			Pn(1/2,1),1/4,
			   			Pn(1/2,1),Pn(1/4,2),
			   			Pn(1/2,2),1/4,
			   			Pn(1/2,3),1/4,
			   		],2),
			   	],inf).stutter(1),
			   	\amp, 0.1,
				\out, BusDef(\bass, \audio),
			),
		]),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pfindur(16, Pdef(\bbpart1)),
		Pfindur(32, Pdef(\bbpart2)),
		
	])
)).play;
);
