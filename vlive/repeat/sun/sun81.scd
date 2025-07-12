(
~t = 135/2/60; TempoClock.default.tempo = ~t;
FileSystemProject.loadOnce("capsule/draftsynth.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");

SynthDef(\angelchorddetune, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.00001) + 1) * ( LFNoise1.kr(1/2) * 0.2 + 1 )).mean;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq * ( LFNoise1.kr(1/4!4) * 0.8 + 1 ) ).clip(20,20000), \rq.kr(0.5)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(4.1,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
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

//////////////////////// acid
// a*s*y*s

(
Pdef(\part, Pdef(\drums1, 
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
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[991].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 0,0,0,0,
				],8*2 - 2),
				Pseq([
					1,
				],8*1),
				Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],8),
				Pseq([
					0,0,1,1, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[53].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
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
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.snare[1563].value,
			////\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\isRest, Pseq([
				//0,0,0,0, 1,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.11,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[991].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 0,0,0,0,
				],8*2 - 2),
				Pseq([
					1,
				],8*1),
				Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],8),
				Pseq([
					0,0,1,1, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[53].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, \r,5,1,4,
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			//\rq, 0.4,
			//\envamt, 2,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
			//\lag, -0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, \r,5,1,4,
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			//\rq, 0.4,
			//\envamt, 2,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				[1,-5,-5+12],
				[1,-4,-4+12],
			],inf).stutter(8),
			\fmf, Pseq([-5,-4],inf).stutter(8).midiratio * 60.midicps * 8,
			\fmf, Pseq([1],inf).stutter(8).midiratio * 60.midicps * 8,
			\lpf, 3000,
			\octave, 5,
			\fma, 0.1,
			\dur, 1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \fmsaw,
			\note, Pseq([
				Prand([ 1,-5,\r, ],8*4),
				Prand([ 1,-4,\r ],8*4),
			],inf),
			\fmf, Pseq([-5,-4],inf).stutter(8).midiratio * 60.midicps * 8,
			\fmf, Pseq([1],inf).stutter(8).midiratio * 60.midicps * 8,
			\lpf, PmodEnv(Pseq([100,2000,1000,400],1), 8).loop,
			\octave, 6,
			\fma, 0.1,
			\dur, 1/8,
			\amp, 0.1/2,
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
				],7),
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1619].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 1/4,
			\dur, 1/8,
			\gain, 0.0311 * Pseq([0.2,1,1,1],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1700].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, 1,2,1,4,
				1,1,5,1, 1,5,1,4,
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			//\rq, 0.4,
			//\envamt, 2,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
			\lag, -0.04,
			\out, BusDef(\pfx1, \audio),
		),

		Pmono(\rdn_terrorbass,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\gain, 0.8,
		) <> Pbind(
			'wet10', 1.0,
			'mix', 0.12521008403361,
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
				],7),
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\simpletrackmixer,
			\inbus, BusDef(\pfx1),
			\pregain, 1,
			\postgain, 1,
			\delay, 0,
			\send0, 0,
			\sendbus0, BusDef(\sendbus0, \audio, 2),
			\dur, 1,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 1/3/2/~t,
			\maxdelay, 1/4/~t,
			\lag, 0.0009,
			\dur, 1,
			\mix, 1,
			\gain, 0.5,
		),
		Pmono(\fx_delay,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\delay, 2/3/2/~t,
			\maxdelay, 1/4/~t,
			\lag, 0.0009,
			\dur, 1,
			\gain, 0.5,
			\mix, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2268].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
			],inf).coin.not,
			\dur, 1/6,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[169].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,0, 1,0,1,
				1,0,0, 1,0,0,
				1,0,0, 1,0,1,
				1,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/6,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			//\rq, 0.4,
			//\envamt, 2,
			\octave, 3,
		) <> Pfindur(2, Pbind(
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\dur, 1/6,
			\note, Pseq([
				1,1,1,1, 1,2,1,4,
				1,1,5,1, 1,5,1,4,
			],inf),
			\amp, 0.06 * Pkey(\accent),
			
		)).loop
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \simplefm,
		\fmf, 1000,
		\fma, 0.1,
		\amp,0.03,
	)
)
);
Pdef(\melo).edit
ProtoDef(\piano).startControl(Pdef(\melo))

/////////////////


(
Pdef(\part, Pdef(\seq1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],6),
					0,0,0,0, 1,1,1,1, 
					0,0,0,0, 0,0,0,0,
				Pseq([
					Pseq([
						1,0,0,0, 1,0,0,0,
					],7),
					1,0,0,0, 1,0,0,1,
				],8),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,
				],8*8),
				Pseq([
					0,0,1,0,
				],2*2*8),
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[991].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					0,0,1,0, 0,0,0,0,
				],3),
				Pseq([
					1,
				],8*1),
				Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
					],7),
					0.3,0.2,1,0.3, 0.3,0.3,1,0.2,
				],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1730].value,
			//\bufnum, Pfunc({ ~buflib.hat[~buflib.hat.size.rand.debug("h")].value }),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[53].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, \r,5,1,4,
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			//\rq, 0.4,
			//\envamt, 2,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
			//\lag, -0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, \r,5,1,4,
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\lpf, Pseg(Pseq([150,600],1), 1).loop,
			\rq, 0.4,
			\envamt, 2,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
		),

	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				0,2,4,0,
			],inf),
			\octave, 3,
			\fmf, Pseg(Pseq([1,1,2],inf),8) * Pkey(\freq),
			\lpfr, Pseg(Pseq([1,8],inf),8),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\seq2, 
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
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.snare[1563].value,
			////\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\isRest, Pseq([
				//0,0,0,0, 1,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.11,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[991].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 0,0,0,0,
				],8*2 - 2),
				Pseq([
					1,
				],8*1),
				Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],8),
				Pseq([
					0,0,1,1, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[53].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, \r,5,1,4,
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			//\rq, 0.4,
			//\envamt, 2,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
			//\lag, -0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, \r,5,1,4,
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1.2,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 1,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				1,0,1,0, 1,1,0,1,
			],inf).coin.not,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
		),

	])
)).play;
);

(
// bass freeze on last bar
Pdef(\part, Pdef(\seq3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],3),
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],3),
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[991].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[53].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, 1,5,1,4,
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 2,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			//\legato, Pseq([
				//Pseq([
					//0.4
				//],8*7),
				//Pseq([0,0,0,0, 0,3,0,0],1) + 0.4
			//],inf),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				1,1,1,1, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
			//\lag, -0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, \r,5,1,4,
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1.2,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 1,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 1,0,0,1,
					1,0,1,0, 1,1,0,1,
				],3),
				1,0,1,0, 1,1,0,1,
				1,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				Pseq([
					1,1,1,1, 1,3,1,1,
				],1),
			],inf) * 0.8,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
		),

	])
)).play;
);

(
// silence on last half bar
Pdef(\part, Pdef(\seq4, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],3),
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],3),
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[991].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[53].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, 1,5,1,4,
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 2,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			//\legato, Pseq([
				//Pseq([
					//0.4
				//],8*7),
				//Pseq([0,0,0,0, 0,3,0,0],1) + 0.4
			//],inf),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				1,1,1,1, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
			//\lag, -0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, \r,5,1,4,
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1.2,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 1,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 1,0,0,1,
					1,0,1,0, 1,1,0,1,
				],3),
				1,0,1,0, 1,1,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				Pseq([
					1,1,1,1, 1,3,1,1,
				],1),
			],inf) * 0.8,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
		),

	])
)).play;
);

(
// silence on last bar
Pdef(\part, Pdef(\seq4, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],3),
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,0,1,0,
				],3),
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[991].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[53].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, 1,5,1,4,
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 2,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			//\legato, Pseq([
				//Pseq([
					//0.4
				//],8*7),
				//Pseq([0,0,0,0, 0,3,0,0],1) + 0.4
			//],inf),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				1,1,1,1, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
			//\lag, -0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				1,1,1,1, \r,2,1,4,
				\r,1,5,1, \r,5,1,4,
			],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1.2,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 1,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 1,0,0,1,
					1,0,1,0, 1,1,0,1,
				],3),
				1,0,1,0, 1,1,0,1,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				Pseq([
					1,1,1,1, 1,3,1,1,
				],1),
			],inf) * 0.8,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pstep(
			//Pbind(\amp, Pseq([1,0],inf))
		//,1) <> 
		Pseq([
			Pbind(\type, \rest),

			Pbind(),
			//Pbind(\type, \rest),
		],1),
		Pseq([
			Pfindur(7,Pdef(\seq2)),
			Pbind(
				\instrument, \sh101,
				\note, Pseq([
					1,1,1,1, \r,2,1,4,
					\r,1,5,1, \r,5,1,4,
				],inf),
				\lpadsr, Pseq([
					[ Env.adsr(0.01,0.1,1.2,0.1) ],
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.01,1,0.01) ],
				],inf),
				//\kbamt, 0,
				////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
				//\lpf, Pseg(Pseq([150,600],1), 8).loop,
				\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
				\rq, 0.4,
				\envamt, 1,
				\accent, Pseq([
					0.4,1,1,1,
				],inf),
				\octave, 4,
				\dur, 1,
				\amp, 0.06 * Pkey(\accent),
			).keep(1),
		],inf),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[821].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1129].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/3,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				0,2,4,0,
			],inf),
			\octave, Pseg(Pseq([9,9,4,5],inf),8),
			\fmf, Pseg(Pseq([1,2],1),1/2).loop * Pkey(\freq),
			\lpfr, Pseg(Pseq([1,2,10],inf),8),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.3,0.5) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/3,
			\lag, -0.04,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\fx_eko,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				0,2,4,0,
			],inf),
			\octave, 5,
			\fmf, Pseg(Pseq([1,2],1),1/2).loop * Pkey(\freq),
			\lpfr, Pseg(Pseq([1,2,10],inf),8),
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.3,0.5) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/3 * Pseq([
				Pwhite(0.1,1,2),1,1, 0,0,Pwhite(0.1,1,2)
			],inf),
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				0,2,4,0,
			],inf),
			\octave, 3,
			\fmf, Pseg(Pseq([1,2],1),1/2).loop * Pkey(\freq),
			\lpfr, Pseg(Pseq([4,1],1),1/2).loop + Pseg(Pseq([1,2,10],inf),8),
			\dur, 1/8,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, 
	Ppar([
		Pseq([
			Pfindur(7.5,Pbind()),
			//Pfindur(1/2,Pbind(\type, \rest)),
		],4) 
		<> Pdef(\seq1),
		Pseq([
			Event.silent(7.5),
			Pfindur(1/2,Pbind(
				\instrument, \simplefm,
				\freq, PmodEnv(Pseq([100,300,2000],1), 4).loop,
				//\fmf, Pseg(Pseq([1,2],1),1/2).loop * Pkey(\freq),
				\fmf, 1000,
				\lpfr, PmodEnv(Pseq([2,4],1), 8).loop,
				\lag, 0.1,
				\dur, 1/2,
				\amp, 0.1,
			)),
		],4)
	]),
).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pseq([

			Event.silent(1),
			Pfindur(1,Pbind(
				\instrument, \default,
				\freq, PmodEnv(Pseq([100,2000],1), 8).loop,
				\dur, 1,
				\amp, 0.1,
			)),
		],2),
		
	])
)).play;
);

(
SynthDef(\fx_eko, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(Dseq([1,8,1],inf)*1/~t, 0, Dseq([
		1,1,-1,-1,
	],inf)).lag(1) * LFNoise1.kr(1/4).range(1,1.1);
	sig = in;
	sig = sig + Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.91) ) + sig;
	
		//isig = DelayL.ar(isig, 0.1,0.1 * SinOsc.ar(\delfmf.kr(1/4*~t)) );
		isig = DelayL.ar(isig, 0.1,0.1 * lfo1);
		isig = FreqShift.ar(isig, 4);
		isig = Limiter.ar(isig);
		isig;
	});
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
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],3),
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[896].value,
			\bufnum, ~buflib.snare[2365].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,0,1, 1,0,0,0,
				0,0,0,0, 1,0,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,0,0,
				0,0,0,0, 1,1,0,1,
				0,1,0,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08 * Pseq([
				1,1,1,1, 2,1,1,1,
			],inf)/2,
		),
		Pmono(\fx_eko,
			\inbus, BusDef(\pfx1, \audio),
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[887].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				1,1,1,1, 0,0,0,1,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				//0,3,0,2, 3,-1,3,3,
				//-1,-2,0,2, 3,2,-1,3,
				0,0,0,0, 3,3,-1,-1,
				0,0,-2,-2, 3,0,0,-1,
			],inf),
			\octave, 3,
			\fmf, Pseq([1,8,1/2],inf) * Pkey(\freq),
			//\fmf, PmodEnv(Pseq([1,2,1,4]*100,1), 1).loop,
			\fma, 0.8,
			\lpfr, Pseg(Pseq([10,3],inf),8),
			\rq, 0.2,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.3,0.5) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/3 * Pseq([
				//0.4,1,1,1,
				//0.4,0.1,1,0.1,
				Pwhite(0.1,0.4,1),Pwhite(0.1,1,3),
			],inf),
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				0,0,0,0, 3,3,-1,-1,
				0,0,-2,-2, 3,0,0,-1,
			],inf),
			\octave, 5,
			\fmf, Pseq([1,8,1/2],inf) * Pkey(\freq),
			//\fmf, PmodEnv(Pseq([1,2,1,4]*1000,1), 1).loop,
			\fma, 3.8,
			\lpfr, Pseg(Pseq([4,2,10],inf),8),
			\rq, 0.2,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],1),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.3,0.5) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/3 * Pseq([
				Pwhite(0.1,0.4,1),Pwhite(0.1,1,3),
			],inf) * 0.7,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 3,3,-1,-1,
				0,0,-2,-2, 3,0,0,-1,
			],inf),
			\octave, 7,
			//\fmf, Pseq([1,8,1/2],inf) * Pkey(\freq),
			//\fmf, PmodEnv(Pseq([1,2,1,4]*1000,1), 1).loop,
			//\fma, 3.8,
			//\lpfr, Pseg(Pseq([4,2,10],inf),8),
			\rq, 0.2,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],1),
			],inf).coin.not,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1.2,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			\lpf, Pseg(Pseq([3070,600],1), 8).loop,
			//\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 2,
			\dur, 1/8,
			\amp, 0.1/3 * Pseq([
				Pwhite(0.01,0.4,1),Pwhite(0.01,1,3),
			],inf) * 0.5,
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
				],7),
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[896].value,
			\bufnum, ~buflib.snare[2365].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,0,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				1,0,0,1, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08 * Pseq([
				1,1,1,1, 2,1,1,1,
			],inf)/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[887].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				//0,3,0,2, 3,-1,3,3,
				//-1,-2,0,2, 3,2,-1,3,
				0,0,0,0, 3,3,-1,-1,
				0,0,-2,-2, 3,0,0,-1,
			],inf),
			\octave, 3,
			\fmf, Pseq([1,8,1/2],inf) * Pkey(\freq),
			//\fmf, PmodEnv(Pseq([1,2,1,4]*100,1), 1).loop,
			\fma, 0.8,
			\lpfr, Pseg(Pseq([10,3],inf),8),
			\rq, 0.2,
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.3,0.5) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/3 * Pseq([
				//0.4,1,1,1,
				//0.4,0.1,1,0.1,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				Pwhite(0.1,0.4,1),Pwhite(0.1,1,3),
			],inf),
		),
		Pbind(
			\instrument, \simplefm,
			\note, Pseq([
				0,0,0,0, 3,3,-1,-1,
				0,0,-2,-2, 3,0,0,-1,
			],inf),
			\octave, 5,
			\fmf, Pseq([1,8,1/2],inf) * Pkey(\freq),
			//\fmf, PmodEnv(Pseq([1,2,1,4]*1000,1), 1).loop,
			\fma, 3.8,
			\lpfr, Pseg(Pseq([4,2,10],inf),8),
			\rq, 0.2,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],1),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.001,0.1,0.3,0.5) ],
			],inf),
			\dur, 1/8,
			\amp, 0.1/3 * Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				Pwhite(0.1,0.4,1),Pwhite(0.1,1,3),
				Pwhite(0.1,0.4,1),Pwhite(0.1,1,3),
			],inf) * 0.7,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,0,0,0, 3,3,-1,-1,
				0,0,-2,-2, 3,0,0,-1,
			],inf),
			\octave, 7,
			//\fmf, Pseq([1,8,1/2],inf) * Pkey(\freq),
			//\fmf, PmodEnv(Pseq([1,2,1,4]*1000,1), 1).loop,
			//\fma, 3.8,
			//\lpfr, Pseg(Pseq([4,2,10],inf),8),
			\rq, 0.2,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],1),
			],inf).coin.not,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1.2,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			\lpf, Pseg(Pseq([3070,600],1), 8).loop,
			//\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 2,
			\dur, 1/8,
			\amp, 0.1/3 * Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				Pwhite(0.01,0.4,1),Pwhite(0.01,1,3),
			],inf) * 0.5,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pstep(Pseq([
				[0,3,7],
				[-1,3,7],
			],inf),4),
			\octave, 5,
			//\fmf, Pseq([1,8,1/2],inf) * Pkey(\freq),
			//\fmf, PmodEnv(Pseq([1,2,1,4]*1000,1), 1).loop,
			//\fma, 3.8,
			//\lpfr, Pseg(Pseq([4,2,10],inf),8),
			\rq, 0.2,
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],1),
			],inf).coin.not,
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1.2,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,1.5,0.81,0.01) ],
			],inf),
			\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([3070,600],1), 8).loop,
			\lpf, PmodEnv(Pseq([12000,30,602,3000],1), Pseq([2,6],inf)).loop,
			//\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 2,
			\dur, 1/8,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\amp, 0.1/3 * Pseq([
				1,
				//Pwhite(0.01,0.4,1),Pwhite(0.01,1,3),
			],inf) * 0.5,
		),

		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				0,3,-1,0, -1,3,-5,0,
				0,3,-1,0, -1,3,-5,0,
				0,3,-1,0, -1,3,-5,0,
				0,3,-1,0, -1,3,-5,0,
				-1,3,-1,0, -1,3,-5,0,
				-1,3,-1,0, -1,3,-5,0,
				-1,3,-1,0, -1,3,-5,0,
				-1,3,-1,0, -1,3,-5,0,
			],inf),
			\octave, 3,
			\legato, Pseq([
				1,0,0,0, 0,0,0,0,
				4,0,0,0, 0,1,0,1,
				1,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, PmodEnv(Pseq([100,2000],1), 8).loop,
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
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[896].value,
			\bufnum, ~buflib.snare[2365].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,1,0,1, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,0,0,
				1,0,0,1, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08 * Pseq([
				1,1,1,1, 2,1,1,1,
			],inf)/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[887].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,

				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,0,0, 1,0,1,1,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11/3,
		),
		
		Pbind(
			\instrument, \bassfmenkor2,
			\note, Pstep(Pseq([
				[0,3,7, 7-12, 0+12],
				[-1,3,7, 7-12, -1+12],
			],inf),4),
			\fma, PmodEnv(Pseq([1,22,1,9],1), 2).loop,
			\fma2, PmodEnv(Pseq([1,2,1,4]/10,1), 8).loop,
			\fma3, 0.9,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.8,0.1) ],
			],inf),
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\dur, 1/8,
			\amp, 0.1/4,
		),
		//Pbind(
			//\instrument, \sh101,
			//\note, Pstep(Pseq([
				//[0,3,7, 7-12, 0+12],
				//[-1,3,7, 7-12, -1+12],
			//],inf),4),
			//\fmf, Pseq([-5,-4],inf).stutter(8).midiratio * 60.midicps * 8,
			//\fmf, Pseq([1],inf).stutter(8).midiratio * 60.midicps * 8,
			//\lpf, 3000,
			//\octave, 5,
			//\fma, 0.1,
			//\dur, 1/8,
			//\amp, 0.1/3,
		//),
	])
)).play;
);

(
SynthDef(\bassfmenkor2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(0.01*(1..10)/10) * 100; 
	//lfo1 = Duty.kr(1/8/~t, 0, Dseq([
		//1,2,4,2,
	//],inf));
	sig = SinOsc.ar(freq  * ( SinOsc.ar(freq * \fmfr.kr(1/4) * ( LFNoise1.ar(0.1) * (1..10)*100*1 + 1 ))  * \fma.kr(10)*lfo1 + 1 ));
	sig = SinOsc.ar(freq * ( sig * \fma2.kr(24) + 1 ));
	sig = SinOsc.ar(freq * ( sig * \fma3.kr(0.2) + 1 ));
	//sig = sig * SinOsc.ar((1..10)*0.03).clip(0,1); 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);


///////////////////



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \reese,
			\note, Pseq([
				0,0,0,1,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \mellowpad,
			\note, Pstep(Pseq([
				[0,3+12,6,9],
				[0,3+12,7,10],
			],inf),4),
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,1000,900],8), 4).loop,
			\lpenvamt,3,
			\fspread, Pseg(Pseq([0.001,0.005],inf),8*4),
			\fspread2, Pseg(Pseq([0.01,0.005],inf),8*4),
			\adsr, Pseq([
				[ Env.adsr(0.3,0.1,0.8,1.1) ],
			],inf),
			\lpenv, [ Env.asr(0.3,1,1) ],
			\rq, 0.6,
			\dur, Prand([1/2,1/4,1,1.5],inf)*2,
			\legato, 0.3,
			\amp, 0.1/8,
		),
		Pbind(
			\instrument, \brasspad,
			\note, Pseq([
				0,4,3,3,
			],inf),
			\perc, Ptuple(Env.perc(0.01,Pseg(Pseq([0.1,1,4]),8)).asArray).collect({ arg x; [x] }).loop,
			\lpf, PmodEnv(Pseq([100,9000],1), 4).loop,
			\octave, 5,
			\dur, 1/2,
			\amp, 0.1/4,
		),

	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbind(
			\instrument, \reese,
			\note, Pseq([
				Pseq([
					0,\r,0,1,
				],inf)+1,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \mellowpad,
			\note, Pstep(Pseq([
				[0,3+12,6,9],
				[0,3+12,7,10],
			],inf),4),
			\octave, 5,
			\lpf, PmodEnv(Pseq([100,1000,900],8), 4).loop,
			\lpenvamt,3,
			\fspread, Pseg(Pseq([0.001,0.005],inf),8*4),
			\fspread2, Pseg(Pseq([0.01,0.005],inf),8*4),
			\adsr, Pseq([
				[ Env.adsr(0.3,0.1,0.8,1.1) ],
			],inf),
			\lpenv, [ Env.asr(0.3,1,1) ],
			\rq, 0.6,
			\dur, Prand([1],inf)*2,
			\legato, 0.3,
			\amp, 0.1/8,
		),
		Pbind(
			\instrument, \brasspad,
			\note, Pseq([
				0,4,3,3,
			],inf),
			\perc, Ptuple(Env.perc(0.01,Pseg(Pseq([0.1,1,4]),8)).asArray).collect({ arg x; [x] }).loop,
			\lpf, PmodEnv(Pseq([100,9000],1), 4).loop,
			\octave, 5,
			\dur, 1/2,
			\amp, 0.1/4,
		),

	])
)).play;
);


///////////////

(
Pdef(\part, Pdef(\seq2, 
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
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1505].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
			\isRest, true,
		),
		//Pbind(
			//\instrument, \playersec,
			//\bufnum, ~buflib.snare[1563].value,
			////\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\isRest, Pseq([
				//0,0,0,0, 1,0,0,0,
			//],inf).coin.not,
			//\dur, 1/8,
			//\gain, 0.11,
		//),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1435].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, 1,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[991].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				Pseq([
					0,0,1,0, 0,0,0,0,
				],8*2 - 2),
				Pseq([
					1,
				],8*1),
				Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],8),
				Pseq([
					0,0,1,1, 0,0,0,1,
					0,0,1,0, 0,0,1,0,
				],8),
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[53].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pser([
					1,\r
				],8*7),
				Pser([
					0,\r,
				],8),
			],inf),
			//\lpadsr, Pseq([
				//[ Env.adsr(0.01,0.1,1.2,0.1) ],
			//],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\lpf, PmodEnv(Pseq([40,80],1), 8).loop,
			//\rq, 0.4,
			\rq, 0.4,
			//\envamt, 2,
			\legato, 1.8,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.06 * Pkey(\accent),
			//\lag, -0.04,
			//\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				//1,1,1,1, 1,1,1,-2, 
				//0,0,0,0, 0,0,0,1,
				1,1,1,1, 1,1,1,1,
			],inf) + Pstep(Pseq([
				-5,-5,-5,-5,
			],inf),2),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.1,1.2,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.01) ],
			],inf),
			//\kbamt, 0,
			////\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
			//\lpf, Pseg(Pseq([150,600],1), 8).loop,
			\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
			\rq, 0.4,
			\envamt, 1,
			\accent, Pseq([
				0.4,1,1,1,
			],inf),
			
			\isRest, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\octave, 4,
			\dur, 1/8,
			\legato, 1,
			\amp, 0.06 * Pkey(\accent),
		),
		Pbind(
			\instrument, \mellowpad,
			\note, Pseq([
				-1, 1,
				5, 1,
			],inf),
			\octave, 5,
			\dur, 1,
			\amp, 0.1/8,
			\isRest, true,
		),

	])
)).play;
);

ProtoDef(\piano).startControl(Pdef(\melo))
(
Pdef(\melo, 
	Pbind(
		\instrument, \mellowpad,
		\lpf, 1000,
			\amp, 0.1/8,
	)
)
);

////////

(
SynthDef(\harmonizer, {
    arg in = 0, out = 0, trnsp = 0, maxdel = 0.04, delay=0.04;
    var sig, phs, sawrate;
	var insig;
	var of = delay/\atf.kr(2);
	of.poll;
    sawrate = (trnsp.midiratio - 1).neg;
    sig = insig = In.ar(in, 2);
    phs = LFSaw.ar(sawrate / delay).unipolar(1);
    sig = DelayL.ar(sig, maxdel, phs * delay);
	sig = sig * EnvGen.ar(Env([0,1,1,0],[of,delay/sawrate - (of*2),of]), phs -0.01);
	sig = SelectX.ar(\mix.kr(1), [insig, sig]);
    sig = sig * \gain.kr(1);
    Out.ar(out, sig);
}).add;
Pdef(\part).reset;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \default,
			\note, Pseq([
				//3,
				0,3,7,0,
				//Pseq((0..12)),
			],inf),
			\dur, 1/1,
			\legato, 0.3,
			\amp, 0.1,
			\out, BusDef(\pfx1, \audio),
		),
		Pmono(\harmonizer,
			\in, BusDef(\pfx1, \audio),
			//\instrument, \harmonizer,
			\trnsp, [0,4,7]-12,
			//\trnsp, 7,
			\mix, [0,1,1],
			\gain, [0.3,1,1],
			\maxdel, 0.2,
			\atf, 4,
			\delay, PmodEnv(Pseq([0.001,0.2],1), 8*2).loop,
			\delay, 1/2/2/~t,
			\dur, 1,
		)
	])
)).play;
);

{CrossoverDistortion.ar(SinOsc.ar([400, 404], 0, 0.2), MouseX.kr(0, 1), MouseY.kr(0, 1))}.play

{CrossoverDistortion.ar(SoundIn.ar, MouseX.kr(0, 1), MouseY.kr(0, 1))}.play
x = {InsideOut.ar(AudioIn.ar([1,2]).mean, 0.01).dup(2) }.scope;


(
SynthDef(\bassdel, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, delay=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	sig = SinOsc.ar(freq);

	lfo1 = LFSaw.ar(1/delay);
	sig = DelayL.ar(sig, \maxdelay.kr(0.1), lfo1 * delay * SinOsc.ar(\lfof.kr(2), mul:\lfoa.kr(0.1), add:1)) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\bassdelf, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, delay=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var lpenv;
	sig = SinOsc.ar(freq);

	lfo1 = LFSaw.ar(1/delay);
	sig = DelayL.ar(sig, \maxdelay.kr(0.1), lfo1 * delay * SinOsc.ar(\lfof.kr(2), mul:\lfoa.kr(0.1), add:1)) + sig;
	lpenv = EnvGen.kr(\lpenv.kr(Env([1,2,1],[0.04,0.2])), 1) * \lpenva.kr(2.7) + 1;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bassdelf2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var lpenv;
	var delay;
	sig = SinOsc.ar(freq);

	delay = 1/freq * \delfac.kr(1);
	lfo1 = LFSaw.ar(1/delay);
	sig = DelayL.ar(sig, \maxdelay.kr(0.1), lfo1 * delay * SinOsc.ar(\lfof.kr(2), mul:\lfoa.kr(0.1), add:1)) + sig;
	lpenv = EnvGen.kr(\lpenv.kr(Env([1,2,1],[0.04,0.2])), 1) * \lpenva.kr(2.7) + 1;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq * lpenv ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \bassdel,
			\note, Pseq([

				5,5,8,8, 2,0,2,0,
				3,3,3,3, 2,0,2,0,
				//1,1,1,1, 1,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//1,1,1,1, 1,1,1,1,
				//0,3,2,1
			],inf),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				0,0,0,0, 0,0,0,0,
				//7,0,0,0, 0,0,0,0,
				//4,0,0,0, 0,0,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],7),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\delay, 1/Pkey(\freq)*Pseq([2,4],inf),
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \bassdel,
			\note, Pseq([

				5,5,8,8, 2,0,2,0,
				3,3,3,3, 2,0,2,0,
				//1,1,1,1, 1,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//1,1,1,1, 1,1,1,1,
				//0,3,2,1
			],inf),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],7),
				0,0,0,0, 0,0,0,0,
				//7,0,0,0, 0,0,0,0,
				//4,0,0,0, 0,0,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
				Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
				],7),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\delay, 1/Pkey(\freq)*Pseq([1/2,1],inf),
			\octave, 2,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums1),
		Pbind(
			\instrument, \bassdelf,
			\note, Pseq([

				5,5,8,8, 2,0,2,0,
				3,3,3,3, 2,0,2,0,
				//1,1,1,1, 1,0,0,1,
				//0,0,0,0, 0,0,0,0,
				//1,1,1,1, 1,1,1,1,
				//0,3,2,1
			],inf),
			\legato, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,1,
				],5),
				0,0,0,0, 0,0,0,0,
				7,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,1,1,
			],inf)*0.9,
			\lpfr, PmodEnv(Pseq([1,2],1), 4).loop,
			\lpenv, [ Env([0,1,0],[0.01,0.2]) ],
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.31) ],
			],inf),
			\lfof, 0.1,
			\lpenva, 2,
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\delay, 1/Pkey(\freq)*Pseq([1/2],inf),
			\octave, Pseq([3],inf),
			\dur, 1/8,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
Pbindef(\bassline1, 
	\instrument, \bassdelf2,
).edit;
);
Spec.add(\lpenv, ParamEnvSpec())

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pdef(\drums1),
		Pbindef(\bassline1),
		Pmono(
			 \angelchorddetune,
			\degree, Pseq([
				[  -3, 0, 2, 4, 7, 9 ]
			],inf),
			\scale, Scale.minor,
			\dur, 4,
			\octave, 6,
			\amp, 0.1/6/2,
			\out, BusDef(\fxreverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\fxreverb, \audio),
			\addAction, \addToTail,
			\room, 2,
			\damp, 1,
			\mix, 1,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\fxdist, \audio),
		),
		Pmono(\fxcrossdist,
			\inbus, BusDef(\fxdist, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\gain, 0.1,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\fxcrossdist, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = CrossoverDistortion.ar(sig, 1, \smooth.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);
