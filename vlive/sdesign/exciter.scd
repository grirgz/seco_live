
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var exc;
	var energy;
	var n = 16;

	exc = TDuty.kr(1/8/~t, 0, Dseq([
		Drand([
			Dseq([
				1,0,0,1, 0,0,1,0,
			],1),
			Dseq([
				0,0,0,0,0,
			],1),
			Dseq([
				0,0,0,0, 0,0,0,0,
			],1),
			Dseq([
				0,0,0,0,0, 0,0,0,0,
			],1),
			Dseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
			Dseq([
				0,0,0,1,0,0,0,0,1,0,0,
			],1),
		],1),
	],inf))/4;
	energy = Integrator.kr( exc, 0.9995 );
	energy.poll;

	freq = exprand(50.0,11000!n);
	//lfo1 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0))*0.1+1;}.dup(n);
	lfo1 = { IEnvGen.kr( Env([rrand(0.01,1),rrand(0.01,1)],[rrand(0.5,1.5)]), energy ) * 0.1 + 1}.dup(n);
	//lfo2 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	lfo2 = { IEnvGen.kr( Env([rrand(0.01,1),rrand(0.01,1)],[rrand(0.5,1.5)]), energy )}.dup(n);
	//lfo3 = {XLine.kr(exprand(1.0,15000),exprand(1.0,15000), rrand(10,100.0));}.dup(n);
	lfo3 = {IEnvGen.kr( Env([exprand(1.0,15000),exprand(1.0,15000)],[rrand(10,100.0)]), energy);}.dup(n);
	lfo4 = exprand(50.0,11000!n);
	//lfo5 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	lfo5 = {IEnvGen.kr( Env([rrand(0.01,1),rrand(0.01,1)], [rrand(0.5,1.5)]), energy);}.dup(n);
	//sig = LFSaw.ar(freq * ( SinOsc.ar(lfo4) * energy + lfo2 ));
	sig = LFSaw.ar(freq * ( SinOsc.kr(lfo1 * lfo4) * ( 0.1 * energy ) + 1 )) * energy;
	sig = DelayL.ar(sig, 0.1, lfo2 *0.01)+sig;
	sig = DelayL.ar(sig, 0.1, lfo5 *0.01)+sig;
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect(_.ar(sig, lfo3, 1));
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig[i], lfo3[i], 1)});
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig.scramble, lfo3.scramble, 1)});
	sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig.scramble, lfo3.scramble, energy.linlin(0,2,0.01,0.9).poll)});



	//sig2 = BPF.ar(sig, 4000, 0.1);
	//sig = SelectX.ar( energy, [sig2, sig]);


	sig = Splay.ar(sig, 1, amp, pan);
	sig;
}).play;
);

(
Ndef(\rezboy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var exc;
	var energy;
	var n = 16;

	exc = TDuty.kr(1/8/~t, 0, Dseq([
		Drand([
			Dseq([
				1,0,0,1, 0,0,1,0,
			],1),
			Dseq([
				0,0,0,0,0,
			],1),
			Dseq([
				0,0,0,0, 0,0,0,0,
			],1),
			Dseq([
				0,0,0,0,0, 0,0,0,0,
			],1),
			Dseq([
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
			Dseq([
				0,0,0,1,0,0,0,0,1,0,0,
			],1),
		],1),
	],inf))/4;
	exc = \exc.tr(1);
	energy = Integrator.kr( exc, 0.9995 );
	energy.poll;

	//freq = exprand(50.0,11000!n);
	//freq = freq * ( ( 2**((0..12)/12) ).collect( _.gauss(0.01) ));
	//lfo1 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0))*0.1+1;}.dup(n);
	lfo1 = { IEnvGen.kr( Env([rrand(0.01,1),rrand(0.01,1)],[rrand(0.5,1.5)]), energy ) * 0.1 + 1}.dup(n);
	//lfo2 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	lfo2 = { IEnvGen.kr( Env([rrand(0.01,1),rrand(0.01,1)],[rrand(0.5,1.5)]), energy )}.dup(n);
	lfo6 = { IEnvGen.kr( Env([0,0.31].reverse,[1]), energy) };
	freq = freq * ( [1/4,1/2,1,2,3,4,5,6].collect({ arg x,idx;  x.gauss(1 * lfo6 ).poll }));
	//lfo3 = {XLine.kr(exprand(1.0,15000),exprand(1.0,15000), rrand(10,100.0));}.dup(n);
	lfo3 = {IEnvGen.kr( Env([exprand(1.0,15000),exprand(1.0,15000)],[rrand(10,100.0)]), energy);}.dup(n);
	lfo4 = exprand(50.0,11000!n);
	//lfo5 = {XLine.kr(rrand(0.01,1),rrand(0.01,1), rrand(10,140.0));}.dup(n);
	lfo5 = {IEnvGen.kr( Env([rrand(0.01,1),rrand(0.01,1)], [rrand(0.5,1.5)]), energy);}.dup(n);
	//sig = LFSaw.ar(freq * ( SinOsc.ar(lfo4) * energy + lfo2 ));
	sig = LFSaw.ar(freq * ( SinOsc.kr(lfo1 + lfo4) * ( 0.3 * energy ) + 1 )) * energy;
	sig = DelayL.ar(sig, 0.1, lfo2 *0.01)+sig;
	sig = DelayL.ar(sig, 0.1, lfo5 *0.01)+sig;
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect(_.ar(sig, lfo3, 1));
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig[i], lfo3[i], 1)});
	//sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig.scramble, lfo3.scramble, 1)});
	sig = {[RLPF,RHPF,BPF].choose}.dup(16).collect({ arg u, i; u.ar(sig.scramble, lfo3.scramble, energy.linlin(0,2,0.01,0.9))});



	//sig2 = BPF.ar(sig, 4000, 0.1);
	//sig = SelectX.ar( energy, [sig2, sig]);


	sig = Splay.ar(sig, 1, amp, pan);
	sig;
}).play;

Ndef(\rezboy)[101] = \pset -> Pbind(
	\note, Pseq([
		0,2,1,5,
	],inf),
	\exc, Pseq([
		1,0,0,0,0,
	],inf)/4,
	\dur, Prand([1,1/4,1/3],inf),
)
)
Ndef(\rezboy).set(\freq, 223, \exc, 1)



(

// synthetic piano patch (James McCartney)

var n;

n = 6;	// number of keys playing

play({

	Mix.ar(Array.fill(n, {	// mix an array of notes

		var delayTime, pitch, detune, strike, hammerEnv, hammer;

	

		// calculate delay based on a random note

		pitch = (36 + 54.rand); 

		strike = Impulse.ar(0.1+0.4.rand, 2pi.rand, 0.1); // random period for each key

		hammerEnv = Decay2.ar(strike, 0.008, 0.04); // excitation envelope

		Pan2.ar(

			// array of 3 strings per note

			Mix.ar(Array.fill(3, { arg i;

				// detune strings, calculate delay time :

				detune = #[-0.05, 0, 0.04].at(i);

				delayTime = 1 / (pitch + detune).midicps;

				// each string gets own exciter :

				hammer = LFNoise2.ar(3000, hammerEnv); // 3000 Hz was chosen by ear..

				CombL.ar(hammer,		// used as a string resonator

					delayTime, 		// max delay time

					delayTime,			// actual delay time

					6) 				// decay time of string

			})),

			( (pitch - 36)/27 - 1 ) // pan position: lo notes left, hi notes right

		)

	}))

})

)

(
SynthDef(\jmcpiano, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var delayTime, detune, pitch;
	var strike = \strike.tr(1);
	//strike = K2A.ar(strike);
	strike = Trig.ar(strike, 1/Server.default.sampleRate)*0.1;
	//strike = Impulse.ar(0.1+0.4.rand, 2pi.rand, 0.1); // random period for each key
	env = Decay2.ar(strike, 0.008, 0.04);
	detune = [-0.05, 0, 0.04].midiratio;
	delayTime = 1 / ( freq * detune ).poll;
	sig = LFNoise2.ar(3000!detune.size, env);
	sig = CombL.ar(sig, delayTime, delayTime, \decay.kr(6));
	sig.debug("sig");
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 4*2*4*2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, 1/(0.1+0.4.rand),
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1
			)
		})
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(1.collect { arg idx;
			Pmono(
				\jmcpiano,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, 1/(0.1+0.4.rand),
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1
			)
		})
	])
)).play;
);

(
SynthDef(\jmcpiano2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env;
	var delayTime, detune, pitch;
	var strike = \strike.tr(1);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//strike = K2A.ar(strike);
	strike = Trig.ar(strike, 1/Server.default.sampleRate)*0.1;
	//strike = Impulse.ar(0.1+0.4.rand, 2pi.rand, 0.1); // random period for each key
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), strike);
	env = Decay2.ar(strike, 0.008, 0.04);
	detune = [-0.05, 0, 0.04].midiratio;
	delayTime = 1 / ( freq * detune );
	sig = LFNoise2.ar(\hamfreq.kr(3000)!detune.size, env);
	sig = CombL.ar(sig, delayTime, delayTime * ( SinOsc.ar(17 * env1) * 0.1 * env1 + 1 ), \decay.kr(6));
	sig = AllpassL.ar(sig, delayTime, delayTime * ( SinOsc.ar(17 * env1) * 0.1 * env1 + 1 ), \decay.kr(6));
	sig.debug("sig");
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * 4*2*4*2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano2,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, 1/(0.1+0.4.rand),
				\hamfreq, ~pmodenv.(Pseq([9,1,2,1,4]*500,1), 8).loop,
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1,
			)
		})
	])
)).play;
);


(
Ndef(\combline, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
	sig = in;
	sig = FreqShift.ar(sig, \shift.kr(10) * ( SinOsc.ar(\fmf.kr(1)) * \fma.kr(1) + 1 ));
	sig = sig * \gain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig;
}).play;
);
Ndef(\combline).edit

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, 1/(0.1+0.4.rand),
				\hamfreq, ~pmodenv.(Pseq([9,1,2,1,4]*500.rand,1), 8.0.rand + 1).loop,
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1,
				\out, BusDef(\mixer0, \audio),
			)
		})
	])
)).play;
);

(
Ndef(\combline, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
	sig = in;
	sig = FreqShift.ar(sig, \shift.kr(10) * ( SinOsc.ar(\fmf.kr(1)) * \fma.kr(1) + 1 ));
	sig = CombL.ar(sig, 4/~t, 0.1 * ( SinOsc.kr([ 0.1,0.2 ]) * 0.1 + 1 ),1/~t) + sig;
	sig = sig * \gain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig;
}).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, (0.8+0.1.rand) * Pseq([2,1],inf).stutter(16*2),
				\hamfreq, ~pmodenv.(Pseq([9,1,2,1,4]*500.rand,1), 8.0.rand + 1).loop,
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1,
				\out, BusDef(\mixer0, \audio),
			)
		})
	])
)).play;
);



~protordn_to_fbstring.(ProtoDef(\rdn2)).editorInsert
(

	SynthDef(\rdndrown, { arg out=0, gate=1;
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
		thisThread.randSeed = 17679.0;
		si = sig;
		sig = { arg si, env;
			si = (si * 10.rand * \distamp.kr).tanh / 2;
			si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
			si = FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				}.value(si, env);

			].mean;
			si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(0.9,1) * \delay2.kr) + si;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(0.9,1) * \delay2.kr) + si;
					si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(0.9,1) * \delay2.kr) + si;
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
		'mix', 0.77791010151461,
		'gain', 0.52100840336134,
		'fb', 0.0001,
		'delay', 0.00014725404276241,
		'delay2', 0.51794746792312,
		'shift', 0.0,
		'shift2', 0.0,
		'distamp', 2.8985772146511,
		'pitchlag', 1.0,
		'pitchmix', 0.0,
		'prelpf', 17000,
		'prehpf', 17,
		'lpf', 17000,
		'hpf', 17,
		'fbdistamp', 0.7696669794067,
		'fbdistmix', 0.23529411764706,
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
		Ppar(6.collect { arg idx;
			Pmono(
				\jmcpiano,
				\pitch, (36 + 54.rand),
				\freq, Pkey(\pitch).midicps,
				\strike, 1,
				\dur, (0.8+0.1.rand) * Pseq([2,1],inf).stutter(16*2),
				\hamfreq, ~pmodenv.(Pseq([9,1,2,1,4]*500.rand,1), 8.0.rand + 1).loop,
				\amp, 0.1,
				\pan, (Pkey(\pitch) - 36)/27 - 1,
				\out, BusDef(\mixer0, \audio),
			)
		}),
		Pmono(\rdndrown,
			\inbus, BusDef(\sendbus2, \audio),
			'mix', 0.77791010151461,
			'gain', 0.22100840336134,
			'fb', 0.0001,
			'delay', 0.725404276241,
			'delay2', 0.51794746792312,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 2.8985772146511,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.7696669794067,
			'fbdistmix', 0.03529411764706,
			'postlpf', 17000,
			'posthpf', 57,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer0, \audio),
		),
		Pmono(\rdndrown,
			\inbus, BusDef(\sendbus2, \audio),
			'mix', 0.77791010151461,
			'gain', 0.52100840336134,
			'fb', 0.0001,
			'delay', 0.00014725404276241,
			'delay2', 0.51794746792312,
			'shift', 0.0,
			'shift2', 0.0,
			'distamp', 2.8985772146511,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.7696669794067,
			'fbdistmix', 0.23529411764706,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.46579739809918,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
	])
)).play;
);
