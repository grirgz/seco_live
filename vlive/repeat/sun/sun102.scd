
// remix draft18

(
~t = 185/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("algokit/kits/PatKitDef_sample1.scd");
FileSystemProject.loadOnce("holis/synthdef.scd");
FileSystemProject.loadOnce("sndlib/mysynthdefault.scd");
FileSystemProject.loadOnce("sndlib/synthbasic.scd");
FileSystemProject.loadOnce("sndlib/synthdesign.scd");
)

// bass loop: 4 beats, last beat is lower pitch

(
SynthDef(\drony, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(100.0,10000) }!20 * ( 1 + ( SinOsc.kr((1..4).rand(0.0)/18) * 1/41 )));
	sig = DelayC.ar(sig, {rrand(1/100,1/10000)}!4) + sig / 2;
	sig = DelayC.ar(sig, {rrand(1/100,1/10000)}!4) + sig / 2;
	sig = BRF.ar(sig, { ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,1);
	sig = LPF.ar(sig, \lpf.kr(10000).lag(1));
	sig = HPF.ar(sig, \hpf.kr(10000).lag(1));
	sig = LeakDC.ar(sig) * 5;
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\sibass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\leadz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.02);
	sig = LFSaw.ar(freq * [1,1.001,2,1/2] * ( 1 + ( SinOsc.ar(freq * [1,2,3]) * 1 ))).mean*2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 400);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\leadz2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq.lag(0.02) * 4;
	sig = LFPulse.ar(freq * [1,1.001,2,1/2] * ( 1 + ( SinOsc.ar(freq * 1/[1,2,3]) * 1 ))).mean*2;
	sig = BPF.ar(sig, freq*1,0.1) + sig;
	sig = HPF.ar(sig, freq*1/4);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\stick, { |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, noise1, noise2;

    // noise 1 - 4 short repeats
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0.0, 0.9, 0.9, 0.7, 0, 0.7, 0],
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
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = SinOsc.ar(freq * [1,1.0001]);
	sig = sig.tanh;
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
	SynthDef(\rdnfx, { arg out=0, gate=1;
		var sig;
		var si, env = ();
		var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 


		sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
		si = sig;

		sig = { arg si, env;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr * LFSaw.kr(0.4).range(1,2)) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr * Amplitude.kr(si)/10) + si;
			//si = AllpassC.ar(si, 0.8, rrand(0.01,0.8) * \delay2.kr, 0.01) + si;

			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay.kr) + si;
			//si = BRF.ar(si, 7000 * SinOsc.kr(2*~t).range(2,1), 0.4) + ( si / 4 );
			//si = BPF.ar(si, exprand(100,16000), 0.5.rand + 0.01) + ( si / 4 );
			//si = FreqShift.ar(si, 0.001) + sig;
			////si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			////si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)* \delay2.kr) + si;
			//si = (si * 10.rand * \distamp.kr).tanh / 2;
			//si = [
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
					//si = (si * 10.rand * \distamp.kr).tanh / 2;
				//}.value(si, env);
				//,
				//{ arg si, env;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8)  * \delay2.kr) + si;
					//si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr) + si;
				//}.value(si, env);

			//].mean;
			si = DelayL.ar(si, 0.8,  \delay1.kr) + si;
			si = DelayL.ar(si, 0.8,  \delay2.kr) + si;
			si = [
				{ arg si, env;
					si = DelayL.ar(si, 0.8,  \delay3.kr) + si;
					si = DelayL.ar(si, 0.8, \delay4.kr) + si;
					si = (si * 1 * \distamp.kr).tanh / 2;
				}.value(si, env);
				,
				{ arg si, env;
					si = DelayL.ar(si, 0.8,   \delay5.kr) + si;
					si = DelayL.ar(si, 0.8,   \delay6.kr) + si;
					si = FreqShift.ar(si, 1) + si;
				}.value(si, env);

			].mean;
			si = DelayL.ar(si, 0.8,  \delay7.kr) + si;
			si = DelayL.ar(si, 0.8,  \delay8.kr) + si;
			si = LeakDC.ar(si);
			si = MidEQ.ar(si, \eqmid1.kr(12000), \eqrq1.kr(1), \eqdb1.kr(1));
			si = MidEQ.ar(si, \eqmid2.kr(7000), \eqrq2.kr(1), \eqdb2.kr(1));
		}.value(si, env);
		sig = Limiter.ar(sig);
		LocalOut.ar(sig);

		sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(1));
		sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(1));
		sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
		sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
		sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
		sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
		sig = sig * \gain.kr(1);
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
		sig;
		Out.ar(out, sig);

	}).add;

);

(
Pdef(\calmdrumz, 
	Ppar([
		Pmono( \rdnfx,
			\inbus, BusDef(\fx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*1.1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)* Pseq([0.001,100],inf),
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.10001,
			\distamp, 0.1,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.6,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.001,
			\shift, 100,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				1, 1, 1, 1,
				0.01, 1, 0.01, 1,
				0.01, 0.01, 1, 1,
			],inf),
			\distamp, 2/1,
			\dur, 1/8,
			//\mix, 0,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.4,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.1/4 * Pseq([1,2],inf),
			\gain, 0.8,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 0.1/2,
			\speed, 0.99,
			\gain, 0.4,
			\dur, 1/8,
			\amp, 0.1,
		)),
		Pbind(
			\out, BusDef(\fx1, \audio),
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		))
		
	])
);
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\calmdrumz)
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drumz)
	])
)).play;
);

(
// base
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
	])
)).play;
);



////////// trying to eq/comp
// sendbus5

ProtoDef(\FxManager).presetCompileString.editorInsert

(

Ndef('fx1').source = 'fx_equi';
PlayerWrapper(Ndef('fx1')).outBus = BusDef('sendbus6');
Ndef('fx1').setVal('inbus', BusDef('sendbus5'));
Ndef('fx1').setVal('loShelfFreq', 93.0);
Ndef('fx1').setVal('loShelfRs', 1.0);
Ndef('fx1').setVal('loShelfGain', 10.75);
Ndef('fx1').setVal('loPeakFreq', 567.0);
Ndef('fx1').setVal('loPeakRq', 1.0);
Ndef('fx1').setVal('loPeakGain', 13.5);
Ndef('fx1').setVal('midPeakFreq', 1000.0);
Ndef('fx1').setVal('midPeakRq', 1.0);
Ndef('fx1').setVal('midPeakGain', 0.0);
Ndef('fx1').setVal('hiPeakFreq', 3500.0);
Ndef('fx1').setVal('hiPeakRq', 1.0);
Ndef('fx1').setVal('hiPeakGain', 0.0);
Ndef('fx1').setVal('hiShelfFreq', 6000.0);
Ndef('fx1').setVal('hiShelfRs', 1.0);
Ndef('fx1').setVal('hiShelfGain', 0.0);

Ndef('fx2').source = 'simplecomp';
PlayerWrapper(Ndef('fx2')).outBus = 0;
Ndef('fx2').setVal('inbus', BusDef('sendbus6'));
Ndef('fx2').setVal('cpt', 0.087871184734249);
Ndef('fx2').setVal('cpabove', 0.1);
Ndef('fx2').setVal('gain', 1.0);

Ndef('fx3').source = nil;
PlayerWrapper(Ndef('fx3')).outBus = 0;


Ndef('fx4').source = nil;
PlayerWrapper(Ndef('fx4')).outBus = 0;

);

(
Ndef(\fx1).play;
Ndef(\fx2).play;
Pdef(\part, Pdef(\zedpart, 
	Pbind(\out, BusDef(\sendbus5, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
	])
)).play;
);

/////////////////

(
// add arp bass
Pdef(\part, Pdef(\zedpart, 
	//Pbind(\out, BusDef(\sendbus1, \audio)) <>
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.12,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				Pseq([
					Pseq([
						0,3,7,0,
					],6),
					Pseq([
						-1,3,7,-5,
					],2),
				],inf),
				0,12,0,-1,
				0,12,0,-1,
				0,12,0,-1,
				-1,11,-1,-2,
			],inf),1/8),
			\adsr, Pseq([
				[ Env.adsr(0.5,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.8,
			\octave, 5 + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,1,1,
				0,-1,-1,0,
				0,0,1,1,
				0,-1,-1,0,
				0,0,0,-1,
				1,0,0,0,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
					0,0,0,0,
					0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
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
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
	])
)).play;
);

(
// add organ_tonewheel0
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 300,
			\envamt, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
// change chord
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\note, Pstep(Pseq([
				-7,-4,-7,0,-4,5,-1,-1,
			],inf),1/2),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 300,
			\envamt, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\note, Pstep(Pseq([
				//0,0,0,-1,
				-7,-7,-4,-1,
				//Pseq([-7],3),3
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			//\lpf, 1500,
			\lpfr, 5,
			\dur, 1/1,
			\amp, 0.15,
		),
		Pbind(
			\instrument, \sh101,
			\note, Pseq([
				Pseq([
					5,5,8,7,
				],3*2),
				Pseq([
					0,0,11,7,
				],1*2),
			],inf).stutter(2) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,-12,-12,
				0,0,0,0, 0,12,0,0,
				12,0,0,0,
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,1,1,0, 1,1,1,1,
				1,0,1,1, 0,0,1,1,
				1,1,0,1, 1,0,1,0,
				1,1,0,1, 1,1,0,1,
			],inf).coin.not,
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1) ],
				],6*8),
				Pseq([
					[ Env.adsr(0.11,0.1,0.8,0.5) ],
				],2*8),
				//[ Env.adsr(0.01,0.1,0.8,1.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.01) ],
				//[ Env.adsr(0.21,0.1,0.8,0.01) ],

				//[ Env.adsr(0.11,0.1,0.8,0.11) ],
				//[ Env.adsr(0.01,0.1,0.8,0.01) ],
				//[ Env.adsr(0.01,0.1,0.8,0.21) ],
				//[ Env.adsr(0.01,0.1,0.8,0.31) ],

				//[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, Pseq([
				1,0.31,1,0.31, 1,1,1,1,
				1,1,1,1, 0.3,0.5,0.3,1,
				1,1,0.5,0.3, 1,1,1,1,
			],inf)*0.8,
			//\lpf, PmodEnv(Pseq([1000,200],1), 8).loop,
			\envamt, PmodEnv(Pseq([1,8],1), 8).loop,
			\rq, 0.4,
			\lpf, 200,
			\isRest, Pseq([
				1,0, 1,0, 1,1, 0,1,
				1,0, 1,0, 1,0, 1,0,
				1,1, 0,1, 1,0, 1,0,
			],inf).coin.not,
			\dur, 1/8/2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono( \rdnfx,
			\inbus, BusDef(\ifx1, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.70017010472041281, 0.90017933153253039 ]
			],inf).stutter(8)*1.1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)* Pseq([0.001,100],inf),
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*10.10001,
			\distamp, 0.1,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.6,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.001,
			\shift, 100,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				1, 1, 1, 1,
				0.01, 1, 0.01, 1,
				0.01, 0.01, 1, 1,
			],inf),
			\distamp, 2/1,
			\dur, 1/8,
			\mix, 0.1,
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\note, Pstep(Pseq([
				-7,-7,-7,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf) + 12,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\note, Pstep(Pseq([
				7,7,7,4,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf) + 12,
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
	])
)).play;
);

(
// organ_tonewheel0 variation
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[184].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1395].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0, 
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\legato, 2 * Pseq([
				Pseq([
					0.3,
				],8),
				1,1,0.4,
				0.21,0.71,1,0.4,
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 300,
			\envamt, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\bass, 1.0,
			\quint, 1.0,
			\mod, Pseq([
				Pseq([
					0,0,0,0, 0,4,4,4,
				],8),
				Pser([
					1,1,0,
					4,4,0,
				],8*8),
			],inf),
			\fundamental, Pkey(\mod),
			\oct, Pkey(\mod),
			\nazard, Pkey(\mod),
			\blockFlute, 1.0,
			\tierce, 1.0,
			\larigot, 1.0,
			\sifflute, 1.0,
			\vrate, 3.0,
			\vdepth, 0.0080000003799796,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);

(
SynthDef(\fxbandpasser, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig * SinOsc.ar(1300);
	sig = ( sig*\distamp.kr(40) ).tanh * \distpostamp.kr(1/2);
	//sig = BPF.ar(sig, ( \ffreq.kr(1000)*0.7 ).clip(20,20000));
	sig = Resonz.ar(sig, \ffreq.kr(1000) * [ [1,1.5,0.7] ], \rq.kr(0.1)).flop.mean;
	//sig.debug("sig");
	sig = FreeVerb2.ar(sig[0], sig[1], mix:0.2, room:1.0, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.04), \cpbelow.kr(1.001), \cpabove.kr(0.09), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fxbandpasser, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig * SinOsc.ar(1300);
	sig = ( sig*\distamp.kr(40) ).tanh * \distpostamp.kr(1/2);
	//sig = BPF.ar(sig, ( \ffreq.kr(1000)*0.7 ).clip(20,20000));
	sig = Resonz.ar(sig, \ffreq.kr(1000) * [ [1,1.5,0.7,2.1,3.2] ], \rq.kr(0.1));
	sig = Splay.ar(sig.flat, \spread.kr(0.8), 1, \pan.kr(0));
	sig.debug("sig");
	sig = FreeVerb2.ar(sig[0], sig[1], mix:0.15, room:1.0, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.04), \cpbelow.kr(1.001), \cpabove.kr(0.09), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fxrezon, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig * SinOsc.ar(1300);
	sig = ( sig*\distamp.kr(40) ).tanh * \distpostamp.kr(1/2);
	//sig = BPF.ar(sig, ( \ffreq.kr(1000)*0.7 ).clip(20,20000));
	sig = Resonz.ar(sig, \ffreq.kr(1000) , \rq.kr(0.1));
	//sig.debug("sig");
	sig = FreeVerb.ar(sig, mix:0.2, room:1.0, damp:0.5);
	sig = Compander.ar(sig, sig, \cpt.kr(0.04), \cpbelow.kr(1.001), \cpabove.kr(0.09), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
// bandpasser
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[184].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1395].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0, 
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,0,1, 1,0,1,0,
			],inf).coin.not,
			\legato, 2 * Pseq([
				Pseq([
					0.3,
				],8),
				1,1,0.4,
				0.21,0.71,1,0.4,
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 300,
			\envamt, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\bass, 1.0,
			\quint, 1.0,
			\mod, Pseq([
				Pseq([
					0,0,0,0, 0,4,4,4,
				],8),
				Pser([
					1,1,0,
					4,4,0,
				],8*8),
			],inf),
			\fundamental, Pkey(\mod),
			\oct, Pkey(\mod),
			\nazard, Pkey(\mod),
			\blockFlute, 1.0,
			\tierce, 1.0,
			\larigot, 1.0,
			\sifflute, 1.0,
			\vrate, 3.0,
			\vdepth, 0.0080000003799796,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxbandpasser,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\ffreq, PmodEnv(Pseq([16100,220,],10), 2).loop,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);


(
// cut bass and organ on fxbandpasser
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				1,1,1,1, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[184].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1395].value,
			\isRest, Pseq([
				0,0,1,0, 1,1,0,1, 
			],inf).coin.not,
			\legato, 2 * Pseq([
				Pseq([
					0.3,
				],8),
				1,1,0.4,
				0.21,0.71,1,0.4,
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,1,1,1, 0,0,0,0,
				0,0,1,1, 0,0,0,1,
				1,0,0,0, 1,1,0,0,
				0,0,1,0, 0,1,0,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 300,
			\envamt, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([
				0.1
			],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\bass, 1.0,
			\quint, 1.0,
			\mod, Pseq([
				Pseq([
					0,0,0,0, 0,4,4,4,
				],8),
				Pser([
					1,1,0,
					4,4,0,
				],8*8),
			],inf),
			\fundamental, Pkey(\mod),
			\oct, Pkey(\mod),
			\nazard, Pkey(\mod),
			\blockFlute, 1.0,
			\tierce, 1.0,
			\larigot, 1.0,
			\sifflute, 1.0,
			\vrate, 3.0,
			\vdepth, 0.0080000003799796,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxbandpasser,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\ffreq, PmodEnv(Pseq([16100,220,],10), 2).loop,
			\lag, 0.0009,
			\dur, 1,
			\out, BusDef(\ifx2, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\ifx2, \audio),
			\addAction, \addToTail,
			\hpfmix, 1,
			\hpf, PmodEnv(Pseq([10,4000,10000],1), 8).loop,
			\lag, 0.00091,
			\dur, 1,
		),
	])
)).play;
);

(
// add nosepad and fsinharm and some perc
// background harmony
Pdef(\part, Pdef(\backfsinbase, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
			\isRest, true,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \drony,
			\lpf, Pseq([
				7000,
				7000,
				1000,
			],inf).stutter(3),
			\hpf, Pseq([
				1300,
				100,
			],inf).stutter(4),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, Pseq([
				0.2,0.1,0.3,0.1,
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],9),
				1,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),9*2),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,1,100],inf),10*2),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),11*2),
			\combdecay2, Pseg(Pseq([0,10],inf),12*2),
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf),
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fsinharm,
			\chord, Pseq([
				[ [ 1.0, 2 ] ],
				[ [ 2.0, 1 ] ],
			],inf),
			\harm, 1/2.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.30000001192093, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8),
			\octave, 3,
			\dur, 1/8,
			\amp, 1.7,
		),
		Pbind(
			\instrument, \fsinharm,
			\chord, Pseq([
				[ [ 2.0, 1 ] ],
				[ [ 1.0, 2 ] ],
				[ [ 1/2, 1 ] ],
			],inf),
			\harm, Pseg(Pseq([1/2,4],inf),8),
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.30000001192093, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8),
			\noisefreq, 8*~t,
			\octave, 5,
			\dur, 1/8,
			\amp, 1.7,
		),
	])
)).play;
);
(
// add nosepad and variation of theme
// chord swing
Pdef(\part, Pdef(\swingnosebase, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\legato, Pseq([
				Pseq([
					0,0.0,0,0,
				],8),
				0,0.0,0,0,
				0,0,0.4,0,
				0,0,0.4,0.4,
				0,0,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3 * Pseg(Pseq([0,Pn(1,inf)],inf),8),
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
				0,0,0,0,
				0.2,0.8,0.1,0.31,
				0,0,0.3,0.3,
				0,0.8,0.1,1,
				0,0,0.3,0,
				0.2,0.2,0.7,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3 * Pseg(Pseq([0,Pn(1,inf)],inf),8),
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),8),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,1,100],inf),8),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),8),
			\combdecay2, Pseg(Pseq([0,10],inf),8),
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf).stutter(2),
			\syncope, Pseq([
				0.7,0.8,0.5,0.7,
			],inf).stutter(2),
			\legato, Pseq([
				Ppatlace([1, Pseq([1,0.5,0.1],inf)],inf)
			],inf),
			\dur, 1/4 * (1 + (Pkey(\syncope) * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
	])
)).play;
);

(
// add drums
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0,0,0,
				0,0,0.4,0, 0,0.1,0.1,0,
				8,0,0,0, 0,0,0,0,
				0.3,0,0,0.4, 0,0.1,0,0.3,
				4,0,0,0, 0,3,0,0,
				0,0,0.2,0.1, 0,0,0.4,0,
				6,0,0,0, 0,0,0,1,
				0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],5),
				Pseq([
					1,0,1,0, 0,0,1,1,
					0,1,0,0, 0,0,1,1,
					1,1,1,0, 1,1,0,1,
				],6),
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([
					0,0,1,0, 0,1,0,1,
					0,1,0,0, 1,0,0,1,
					1,1,0,1, 0,1,0,1,
				],7),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],7),
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),8),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,1,100],inf),8),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),8),
			\combdecay2, Pseg(Pseq([0,10],inf),8),
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf).stutter(2),
			\syncope, Pseq([
				0.7,0.8,0.5,0.7,
			],inf).stutter(2),
			\legato, Pseq([
				Ppatlace([1, Pseq([1,0.5,0.1],inf)],inf)
			],inf),
			\dur, 1/4 * (1 + (Pkey(\syncope) * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
	])
)).play;
);

(
// add drums
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1748].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0.1,0.1,0.7,0, 0,0,0.1,0.1,
				0,0,0,0.5, 1,0,0,0.1,
				0.4,0.1,0.1,0, 0,0,0,0,
				0,0.4,0,0, 7,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1510].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0.1,0,0, 0.1,0,0,0.1,
				0,0,2,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0.1,0.1,0.1,
				0,0,0.1,0, 0,0.1,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.11,
		),

		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),8),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,1,100],inf),8),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),8),
			\combdecay2, Pseg(Pseq([0,10],inf),8),
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf).stutter(2),
			\syncope, Pseq([
				0.7,0.8,0.5,0.7,
			],inf).stutter(2),
			\legato, Pseq([
				Ppatlace([1, Pseq([1,0.5,0.1],inf)],inf)
			],inf),
			\dur, 1/4 * (1 + (Pkey(\syncope) * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \drumoid,
			\note, Pseq([
				0,10,
				0,20,
				10,30,
			],inf),
			\octave, 6,
			\legato, Pseq([
				0,0.7,1.1,0.5, 0,0,0,0,
				0,0,0.5,0.5, 0,0,0.4,0,
				1,1,0.5,0.5, 0,0,0,1,
			],inf),
			\legato, Pseq([
				1,1,1,1, 1,0.5,0.5,1,
				1,1,1,1, 1,1,1,1,
				1,0.1,1,0.1, 1,1,1,0.5,
				1,1,1,0.5, 1,1,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\att, Pseq([
				1.1,0.02,
				//0.01
			],inf),
			\freq2, Pseg(Pseq([10,10000],inf),8),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\fma, Pseg(Pseq([0,10],inf),8),
			\fma2, Pseg(Pseq([100,0],inf),9),
			\hpf, Pseq([1000,4000,6000],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
	])
)).play;
);


(
SynthDef(\drumoid, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2.2,1],[\att.kr(0.01),1.1]), 1);
	sig = SinOsc.ar(freq* [12/43,42/55,1.06*3] * ( LFSaw.ar(freq*[34/43,55/50, 1.5 ] * ( SinOsc.ar(\freq2.kr(100) * ( SinOsc.ar(324) * 4 + 1 )) * \fma2.kr(4) + 1 )) * env1 * \fma.kr(13) + 1 )).mean;
	sig = HPF.ar(sig, \hpf.kr(3070));
	//sig = LPF.ar(sig, 12070);
	sig = sig * 0.7;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
//////////// instr progression
(
// drum prog
Pdef(\part, Pdef(\drumprog1, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,

				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,

				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,1,0,

				0,0,0,1, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				0,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 1,1,0,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 1,1,0,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

				Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,1,0,
					0,1,0,1, 0,0,1,1,
				],3),
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // long bass
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
			\isRest, true,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0.5,0,
				0,0,0,0, 0,0,0,0,
				0,0.1,0,0, 0.2,0,0,0.5,

				0,0,0,0, 0,0,0.4,0, 
				0,0.1,0.1,0, 8,0,0,0,
			   	0,0,0,0, 0.3,0,0,0.4,
			   	0,0.1,0,0.3, 4,0,0,0, 

				0,3,0,0, 0,0,0.2,0.1,
			   	0,0,0.4,0, 6,0,0,0,
			   	0.4,0.3,0,1, 0,0,0,0,
			   	0,0.1,0,0.3, 4,0,0,0, 
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],7),
				0,0,0,0.4, 0,0,0.4,0, 

					1,0,1,0, 0,0,0,0,
					0,1,0,0, 0,0,1,0,
					0,0,1,0, 1,0,0,1,
					0,1,1,0, 0,0,0,1,
				Pseq([
					1,0,1,0, 0,0,1,1,
					0,1,0,0, 0,0,1,1,
					1,1,1,0, 1,1,0,1,
					0,1,1,0, 1,1,0,1,
				],1),
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],11),
				0,0.4,0,0, 0,0,0.4,0, 
				Pseq([
					0,0,1,0, 0,1,0,1,
					0,1,0,0, 1,0,0,1,
					1,1,0,1, 0,1,0,1,
					1,1,0,1, 0,1,0,1,
				],1),
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
// drum prog
// less breakbeat 1
Pdef(\part, Pdef(\drumsteady1, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 1,1,0,1,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // long bass
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
			\isRest, true,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],11),
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
// drum prog
// less breakbeat 2
Pdef(\part, Pdef(\drumsteady2, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,1,1,0, 1,1,0,1,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // long bass
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
			\isRest, true,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],11),
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
// drum prog
// less breakbeat 3
Pdef(\part, Pdef(\drumsteady3, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // long bass
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
			\isRest, true,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,1,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
// drum prog
// less breakbeat 4
Pdef(\part, Pdef(\drumsteady4, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // long bass
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				0,0,0,0,
				0,0,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,1,
				0,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedseq, 
	Pseq([
		Pfindur(4, Pdef(\drumsteady1)),
		Pfindur(4, Pdef(\drumsteady2)),
		Pfindur(4, Pdef(\drumsteady3)),
		Pfindur(4, Pdef(\drumsteady4)),
		
	])
)).play;
);
////
// another drum prog

// todo
(
// drum prog 2
Pdef(\part, Pdef(\drumprog2, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,0,0,

			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // long bass
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				0,0,0,0,
				0,0,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,1,0,1,
				0,0,0,0, 0,1,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

//// drums pour chaque partie


(
// drum part calm
Pdef(\part, Pdef(\drumprog2calm, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // long bass
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
// drum part mid
Pdef(\part, Pdef(\drumprog2mid, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,1,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // long bass
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0.1,
				0.3,0,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,700,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0.4, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
				0,0.4,0,0, 0,0.3,1,0,
				4,0,0.3,0.3, 0,1,0,0.6,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0,

				0,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,1, 0,1,0,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
// drum part busy
Pdef(\part, Pdef(\drumprog2busy, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,1,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,0,1,1,
				1,0,1,1, 0,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,1,
				1,1,1,1, 1,1,0,1,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,

			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind( // long bass
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0.1,
				0.3,0,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,700,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0.6,
				0,0.4,0,0.3, 0.3,0.3,1,0,
				4,0,0,0, 0,0,0,0,
				0,0.4,0,0, 0,0.3,1,0,
				4,0,0.3,0.3, 0,1,0,0.6,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,1,1,0, 0,1,0,1,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 0,1,0,1,

				0,0,1,0, 0,1,0,1,
				0,1,1,0, 0,1,0,1,
				0,0,1,0, 0,1,0,1,
				1,0,1,1, 0,1,0,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedseq, 
	Pseq([
		Pfindur(8, Pdef(\drumprog2calm)),
		Pfindur(8, Pdef(\drumprog2mid)),
		Pfindur(8, Pdef(\drumprog2busy)),
		
	])
)).play;
);

/// same drumprog2 without bass
(
// drum part calm
Pdef(\part, Pdef(\xdrumprog2calm, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,

				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
// drum part mid
Pdef(\part, Pdef(\xdrumprog2mid, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,1,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 0,1,1,1,

				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0.4, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
				0,0.4,0,0, 0,0.3,1,0,
				4,0,0.3,0.3, 0,1,0,0.6,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					
					0,1,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					0,0,1,0, 0,0,0,0,
					0,0,1,0, 0,1,0,1,
					1,0,1,1, 0,1,0,1,
				],inf),
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);

(
// drum part busy
Pdef(\part, Pdef(\xdrumprog2busy, 
	Ppar([
		Pbind( // kick
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,1,0,1,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,1,0,1,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind( // snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // ghost snare
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind( // hat
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,0,1,1,
				1,0,1,1, 0,1,1,1,

				1,1,1,1, 1,1,1,1,
				1,1,1,1, 0,0,1,1,
				1,1,1,1, 1,1,0,1,
				1,0,1,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),

		// more drums
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1584].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pseq([
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0,
				0,0.4,0,0, 0,0,1,0,
				4,0,0,0, 0,0,0,0.6,
				0,0.4,0,0.3, 0.3,0.3,1,0,
				4,0,0,0, 0,0,0,0,
				0,0.4,0,0, 0,0.3,1,0,
				4,0,0.3,0.3, 0,1,0,0.6,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1679].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\legato, Pseq([
				0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,1,0, 0,1,0,1,
				0,1,1,0, 0,1,0,1,
				0,0,1,0, 0,1,0,1,
				1,0,1,0, 0,1,0,1,

				0,0,1,0, 0,1,0,1,
				0,1,1,0, 0,1,0,1,
				0,0,1,0, 0,1,0,1,
				1,0,1,1, 0,1,0,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
	])
)).play;
);
//// meme chose pour les notes

(
// drum base
Pdef(\part, Pdef(\drumbase, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);
(
// note base
Pdef(\part, Pdef(\notebase, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
	])
)).play;
);


(
// noteprog2 calm
Pdef(\part, Pdef(\noteprog2calm, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.3,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				0,0,0.1,0,
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
	])
)).play;
);

(
// noteprog2 mid
Pdef(\part, Pdef(\noteprog2mid, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
	])
)).play;
);

(
// noteprog2 busy
Pdef(\part, Pdef(\noteprog2busy, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),9*2),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,1,100],inf),10*2),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),11*2),
			\combdecay2, Pseg(Pseq([0,10],inf),12*2),
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf),
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);

/// deuxieme tentative pour les notes

(
// noteprog3 calm
Pdef(\part, Pdef(\noteprog3calm, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.3,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\leadzlpf, \audio),
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				0,0,0.1,0,
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\leadzlpf, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\leadzlpf, \audio),
			\addAction, \addToTail,
			\hpmix, 1,
			\lpmix, 1,
			\lpf, PmodEnv(Pseq([15000,9000,1900],1), 8).loop,
			\hpf, PmodEnv(Pseq([10,300,20,1420,4000],1), 4).loop,
			\lag, 0.00091,
			\gain, 0.85,
			\dur, 1,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,5000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\bass, 1.0,
			\quint, 1.0,
			\mod, Pseq([
				Pseq([
					0,0,0,0, 0,4,4,4,
				],8),
				Pser([
					1,1,0,
					4,4,0,
				],8*8),
			],inf),
			\fundamental, Pkey(\mod),
			\oct, Pkey(\mod),
			\nazard, Pkey(\mod),
			\blockFlute, 1.0,
			\tierce, 1.0,
			\larigot, 1.0,
			\sifflute, 1.0,
			\vrate, 3.0,
			\vdepth, 0.0080000003799796,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,0,1, 0,1,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,1,1,
				1,1,1,1, 0,1,0,1,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\bass, 1.0,
			\quint, 1.0,
			\mod, Pseq([
				Pseq([
					0,
				],inf),
				Pseq([
					0,0,0,0, 0,4,4,4,
				],8),
				Pser([
					1,1,0,
					4,4,0,
				],8*8),
			],inf),
			\fundamental, Pkey(\mod),
			\oct, Pkey(\mod),
			\nazard, Pkey(\mod),
			\blockFlute, 1.0,
			\tierce, 1.0,
			\larigot, 1.0,
			\sifflute, 1.0,
			\vrate, 3.0,
			\vdepth, 0.0080000003799796,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8*2) + Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,-12,0,0, -12,0,-12,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,-12,-12,0, 0,0,-12,0,
				//Pseq([
					//0,0,0,0, 0,0,0,0,
				//],7),
				//0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\octave, 6,
			\dur, 1/8/2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxemerge,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\lpf, PmodEnv(Pseq([1000,20],1), 8).loop,
			\freqshift, PmodEnv(Pseq([-50,430],1), 8).loop,
			\freqshiftmix, 0.5,
			\gain, 2 * Pseg(Pseq([1,0],inf),8),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[112].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifxverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifxverb, \audio),
			\addAction, \addToTail,
			\room, 4,
			\mix, 0.7,
			\gain, 0.7,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

(
// noteprog3 mid
Pdef(\part, Pdef(\noteprog3mid, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.3,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\leadzlpf, \audio),
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				0,0,0.1,0,
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\leadzlpf, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\leadzlpf, \audio),
			\addAction, \addToTail,
			\hpmix, 1,
			\lpmix, 1,
			\lpf, PmodEnv(Pseq([500,9000,19000],1), 8).loop,
			\hpf, PmodEnv(Pseq([1100,300,20,1420,4000],1), 4).loop,
			\lag, 0.00091,
			\gain, 0.85,
			\dur, 1,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0,0.1,0,0,
				0.1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,2000,3000,700,
			],inf),
			\hpf, Pseq([
				1300,700,2000,400,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\bass, 1.0,
			\quint, 1.0,
			\mod, Pseq([
				Pseq([
					0,0,0,0, 0,4,4,4,
				],8),
				Pser([
					1,1,0,
					4,4,0,
				],8*8),
			],inf),
			\fundamental, Pkey(\mod),
			\oct, Pkey(\mod),
			\nazard, Pkey(\mod),
			\blockFlute, 1.0,
			\tierce, 1.0,
			\larigot, 1.0,
			\sifflute, 1.0,
			\vrate, 3.0,
			\vdepth, 0.0080000003799796,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\isRest, Pseq([
				0,0,1,1, 1,1,0,1,
				1,1,1,1, 0,0,0,0,
				0,0,1,1, 1,1,0,1,
				1,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),9*2),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,20,100],inf),4),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),11*2),
			\combdecay2, Pseg(Pseq([0,10],inf),12*2),
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 2.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pseq([
			Event.silent(8),
			Pfindur(8, Pdef(\progsec1)),
		],1),
	])
)).play;
);

(
// noteprog3 busy
Pdef(\part, Pdef(\noteprog3busy, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.3,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				0,0,0.1,0,
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,1,0,0,
				1,0,1,0.4,
			],inf),
			\lpf, Pseq([
				4300,4000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,3500,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\bass, 1.0,
			\quint, 1.0,
			\mod, Pseq([
				Pseq([
					0,0,0,0, 0,4,4,4,
				],8),
				Pser([
					1,1,0,
					4,4,0,
				],8*8),
			],inf),
			\fundamental, Pkey(\mod),
			\oct, Pkey(\mod),
			\nazard, Pkey(\mod),
			\blockFlute, 1.0,
			\tierce, 1.0,
			\larigot, 1.0,
			\sifflute, 1.0,
			\vrate, 3.0,
			\vdepth, 0.0080000003799796,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8) + Pseq([
				0,0,0,0, 0,0,0,0,
				0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\isRest, Pseq([
				0,0,1,1, 1,1,0,1,
				1,1,1,1, 0,0,0,0,
				0,0,1,1, 1,1,0,1,
				1,1,0,1, 0,1,0,0,
			],inf).coin.not,
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),9*2),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,20,100],inf),8),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),11*2),
			\combdecay2, Pseg(Pseq([0,10],inf),12*2),
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf),
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		),
	])
)).play;
);

////// other parts

(
// nosepad swing
Pdef(\part, Pfindur(32, Pdef(\swingnose, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\legato, Pseq([
				Pseq([
					0,0.0,0,0,
				],8),
				0,0.0,0,0,
				0,0,0.4,0,
				1,1,0.4,0.4,
				0,0,0.1,1,
				0,0.0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/3 * Pseg(Pseq([0,Pn(1,inf)],inf),8),
			\amp, 0.1/3,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([

				Pseq([
					0,0,0,0,
					1,0.8,0.1,1,
					0,0,0,0,
					0.2,0.8,0.1,0.31,
					0,0,0.3,0.3,
					0,0.8,0.1,1,
					0,0,0.3,0,
					0.2,0.2,0.7,0.1,
				],3),

					0,0,0,0,
					1,0.8,0.1,1,
					0,0,0,0,
					0,0.8,0,0.4,
					0,0,0.3,0.3,
					0,0.8,0.1,1,
					0,0,0.3,0,
					0.2,0,0.7,0.1,
					
					0,0,0,0,
					1,0.8,0.1,1,
					0,0.1,1,0,
					0.2,0.8,0,0.31,
					0,0,0.3,0.3,
					1,0,0.1,1,
					0,0.3,0.3,0,
					0.2,0.2,0.7,0.1,

					0,0,0,0,
					1,0.8,0.1,1,
					0,0,0,0,
					0,0.8,0,0.4,
					0,0,0.3,0.3,
					0,0.8,0.1,1,
					0,0,0.3,0,
					0.2,0,0.7,0.1,

					0,0,0,0,
					0,0.8,0.1,1,
					0,0,0,0,
					0,0.8,0,0.4,
					1,0,0,1,
					0,0.8,0,1,
					0,0,0.3,0,
					0.2,0,0.7,0.1,

					0.2,0.2,0.7,0.1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1/3 * Pseg(Pseq([0,Pn(1,inf)],inf),8),
			\amp, 0.1/3,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0.1,0,0.1, 0.1,0,0,0.1,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0.1,0,0.1, 0.1,0,0,0.1,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0.1, 0.1,0,0.1,0.1,
				0,0.1,0,0.1, 0.1,0,0,0.1,
				0,0.1,0,0.1, 0,0.1,0.1,0.1,

				0,0.1,0,0, 0,0,0,0,
				0,0,0,0.1, 0.1,0,0.1,0.1,
				0,0.3,0,0.3, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\lpf, Pseq([
				1300,3000,1000,3500,
			],inf),
			\hpf, Pseq([
				1300,400,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,1,0,0.4,

				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,0,0,0,
				0.1,0,0.1,0,
				0,1,0,0.4,
			],inf),
			\lpf, Pseq([
				1300,4000,2000,1200,
			],inf),
			\hpf, Pseq([
				1300,1100,100,1000,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),8),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,1,100],inf),8),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),8),
			\combdecay2, Pseg(Pseq([0,10],inf),8),
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf).stutter(2),
			\syncope, Pseq([
				0.7,0.8,0.5,0.7,
			],inf).stutter(2),
			\legato, Pseq([
				Ppatlace([1, Pseq([1,0.5,0.1],inf)],inf)
			],inf),
			\dur, 1/4 * (1 + (Pkey(\syncope) * Pseq([1,-1],inf))),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[115].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				0,0,0,0, 1,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],6),
				1,0,0,0, 0,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],10),
				0,0,0,0, 1,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],34),
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.21,
			\out, BusDef(\ifxverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifxverb, \audio),
			\out, BusDef(\ifxverbhpf, \audio),
			\addAction, \addToTail,
			\room, 2,
			\mix, 0.7,
			\gain, 0.5,
			\damp, 0.9,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\ifxverbhpf, \audio),
			\addAction, \addToTail,
			\hpmix, 1,
			\lpmix, 0,
			\hpf, 3000,
			\lag, 0.00091,
			\dur, 1,
		),
	])
))).play;
);

(
// base
Pdef(\part, Pdef(\basetheme, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\legato, Pseq([
				Pser([
					1,1,1,0.1,
					0.9,0.9,0.9,0.9,
					0.1,1,0.1,0.1,
					1,0.8,0.1,1,
				],8*12),


					1,1,1,0.1,
					0.9,0.9,0.9,0.9,
					0.9,0.9,0.9,0.9,
					0,0,0,1, 1,0,0,0,

					1,1,1,0.1,
					0.9,0.9,0.9,0.9,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				Pser([
					1,1,1,0.1,
					0.9,0.9,0.9,0.9,
					0.1,1,0.1,0.1,
					1,0.8,0.1,1,

					1,1,0.1,0.1,
					0.9,0.9,0.9,0.9,
					0.1,1,0.1,0.1,
					1,0.8,0.1,1,

					1,0,1,0.1,
					0.9,0.9,0.9,0.1,
					0.1,1,0.1,0.1,
					0.1,0.8,0.1,1,

					1,0.1,0.1,0.1,
					0.9,0.9,0.9,0.9,
					0.1,1,0.1,0.1,
					1,0.8,0.1,1,
				],8*32),
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\leadzlpf, \audio),
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				Pser([
					0,0,0,0,
					1,0.8,0.1,1,
				],8*12),

				0,0,0,0,
				1,0,0.8,1,
				0,0.8,0,0.1,
				1,0,0.1,1,

				1,0.8,0.1,1,
				1,0.8,0.1,1,
				0.1,0.1,0,0.1,
				1,0,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\leadzlpf, \audio),
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\leadzlpf, \audio),
			\addAction, \addToTail,
			\hpmix, 1,
			\lpmix, 1,
			\lpf, PmodEnv(Pseq([5100,12000],1), 16).loop,
			\hpf, PmodEnv(Pseq([4100,300,20,1420,4000],1), 4).loop,
			\lag, 0.00091,
			\gain, 0.85,
			\dur, 1,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0,0,0.1,0.1,
				1,0,0,1,
			],inf),
			\lpf, Pseq([
				1300,4000,1000,2200,
			],inf),
			\hpf, Pseq([
				1300,2100,100,1200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[125].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				Pseq([ 0,0,0,0, 0,0,0,0, ],8),

				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,1, 0,1,0,1,

				0,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
				1,0,1,1, 0,1,0,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,0.1,0.3,0.2,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[114].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.21,
			\out, BusDef(\ifxverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifxverb, \audio),
			\out, BusDef(\ifxverbhpf, \audio),
			\addAction, \addToTail,
			\room, 2,
			\mix, 0.7,
			\gain, 0.5,
			\damp, 0.9,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\ifxverbhpf, \audio),
			\addAction, \addToTail,
			\hpmix, 1,
			\lpmix, 0,
			\hpf, 1000,
			\lag, 0.00091,
			\dur, 1,
		),
	])
)).play;
);

(
// add nosepad and fsinharm and some perc
// background harmony
Pdef(\part, Pdef(\backfsin, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,1,0,0, 0,0,1,0,
				1,0,0,1, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
			\isRest, true,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0,0,0.1,0,
				0.1,1,0,0.4,
			],inf),
			\lpf, Pseq([
				1300,2000,2000,400,
			],inf),
			\hpf, Pseq([
				1300,100,1000,20,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \drony,
			\lpf, Pseq([
				7000,
				7000,
				1000,
			],inf).stutter(3),
			\hpf, Pseq([
				1300,
				100,
			],inf).stutter(4),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, Pseq([
				0.2,0.1,0.3,0.1,
			],inf),
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],9),
				1,0,0,0, 0,0,0,0,
				1,0,1,1, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),9*2),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,1,100],inf),10*2),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),11*2),
			\combdecay2, Pseg(Pseq([0,10],inf),12*2),
			\gain, 1.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf),
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fsinharm,
			\chord, Pseq([
				[ [ 1.0, 2 ] ],
				[ [ 2.0, 1 ] ],
			],inf),
			\harm, 1/2.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.30000001192093, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8),
			\octave, 3,
			\dur, 1/8,
			\amp, 1.7,
		),
		Pbind(
			\instrument, \fsinharm,
			\chord, Pseq([
				[ [ 2.0, 1 ] ],
				[ [ 1.0, 2 ] ],
				[ [ 1/2, 1 ] ],
			],inf),
			\harm, Pseg(Pseq([1/2,4],inf),8),
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.30000001192093, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8),
			\noisefreq, 8*~t,
			\octave, 5,
			\dur, 1/8,
			\amp, 1.7,
		),
	])
)).play;
);

(
// add nosepad and fsinharm and some perc
// background harmony
Pdef(\part, Pfindur(12.5,Pdef(\backfsinoutro, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],inf),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
				1,0,0,0, 0,0,0,0,
			],1).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],1),1),
			\legato, Pseq([0.9,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \nosepad,
			\rampstartfac, 1.011,
			\rampendfac, 1,
			\ramptime, 0.52,
			\decaystart, 0.10000000149012,
			\decayend, 1.0,
			\decaytime, 0.1,
			\fmfreqfac2, 1/2.0,
			\fma2, Pseg(Pseq([0,1,100],inf),9*2),
			\fmfreqfac, Pseq([1,2,4,8],inf),
			\fma, Pseg(Pseq([0,1,100],inf),10*2),
			\maxdelay, 0.10000000149012,
			\combdecay, Pseg(Pseq([0,10],inf),11*2),
			\combdecay2, Pseg(Pseq([0,10],inf),12*2),
			\gain, 1.0 * Pseg(Pseq([1,0,0],inf),10),
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\spread, 0.80000001192093,
			\note, Pseq([
				[0,7,3],
				[0,7,3,11],
				[0,7,3,10],
				[0,7,3,9],
				[0,7,4,10],
				[0,7,3,10],
				[-1,6,3,9],
				[-1,6,3,8],
			],inf),
			\legato, 1,
			\dur, 1/2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fsinharm,
			\chord, Pseq([
				[ [ 1.0, 2 ] ],
				[ [ 2.0, 1 ] ],
			],inf),
			\harm, 1/2.0,
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.30000001192093, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\note, Pseq([
				0,0,0,-1,
			],2).stutter(8),
			\octave, 3,
			\dur, 1/8,
			\amp, 1.7,
		),
		Pbind(
			\instrument, \fsinharm,
			\chord, Pseq([
				[ [ 2.0, 1 ] ],
				[ [ 1.0, 2 ] ],
				[ [ 1/2, 1 ] ],
			],inf),
			\harm, Pseg(Pseq([1/2,4],inf),8),
			\adsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.30000001192093, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8),
			\noisefreq, 8*~t,
			\octave, 5,
			\dur, 1/8,
			\amp, 1.7,
		),
	])
))).play;
);

////////// seq
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pdef(\drumbase),
		//Pdef(\notebase),
		Pdef(\drumprog2calm),
		Pdef(\noteprog2calm),
		
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		//Pdef(\drumbase),
		Pseq([
			Pfindur(8, Pdef(\xdrumprog2calm)),
			Pfindur(8, Pdef(\xdrumprog2mid)),
			Pfindur(8, Pdef(\xdrumprog2busy)),
		]),
		Pseq([
			Pfindur(8, Pdef(\noteprog2calm)),
			Pfindur(8, Pdef(\noteprog2mid)),
			Pfindur(8, Pdef(\noteprog2busy)),
		]),
		Pfindur(16, Pdef(\swingnose)),
		Pfindur(16, Pdef(\backfsin)),
		
	])
)).play;
);

(
////////////
/// main ///
Pdef(\part, Pdef(\zedpart, 
	Pseq([
		Pfindur(16, Pdef(\prog)),
		Pfindur(32, Pdef(\basetheme)),
		Ppar([
			Pseq([
				Pfindur(8, Pdef(\xdrumprog2calm)),
				Pfindur(10, Pdef(\xdrumprog2mid)),
				Event.silent(2),
				Pfindur(4, Pdef(\xdrumprog2mid)),
				Pfindur(12, Pdef(\xdrumprog2busy)),
				Event.silent(4),
			]),
			Pseq([
				Pfindur(8, Pdef(\noteprog3calm)),
				Ppar([
					Pfindur(16, Pdef(\noteprog3mid)),
				]),
				Pfindur(16, Pdef(\noteprog3busy)),
			]),
		
		]),
		Pfindur(32, Pdef(\swingnose)),
		Ppar([
			Pfindur(8, Pdef(\progsec2)),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('reckit/ramp/clap.flac'),
				\pos, 0,
				\legato, 1,
				\dur, 1,
				\isRest, Pseq([
					0,0,0,0,
					0,0,0,1,
				],1).coin.not,
				\adsr, Pseq([
					[ Env.adsr(4.1,0.1,0.8,0.01) ],
				],inf),
				\gain, 1,
			),
		]),
		Pfindur(16, Pdef(\backfsin)),
		Pfindur(12.5, Pdef(\backfsinoutro)),
	],1),
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('reckit/ramp/clap.flac'),
			\pos, 0,
			\legato, 1,
			\dur, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
			],1).coin.not,
			\adsr, Pseq([
				[ Env.adsr(4.1,0.1,0.8,0.01) ],
			],inf),
			\gain, 1,
		)
		
	])
)).play;
);

////
(
// note prog
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,1,
				1,0,0,1, 0,0,1,0,

				1,0,0,1, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,1,1,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.02,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.251) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
				[ Env.adsr(0.01,0.1,0.8,0.051) ],
			],inf),
			\speed, Pseq([1,0.95],inf),
			\dur, 1/8,
			\gain, 0.05,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq({[
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 4,
			\dur, 1/8,
			\amp, 0.1,
			\isRest, true,
		),
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sibass,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\legato, Pseq([0.2,0.5],inf),
			\octave, 3,
			\dur, 1/1,
			\amp, 0.1
		),
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				0,0,0.2,0.2,
				0,0,0,0,
				0,0,0,0,

				0,0,0,0,
				0,1,0,0,
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
		),
		PmonoArtic(\drony,
			//\out, BusDef(\fx3, \audio),
			\legato, Pseq([
				Pseq([
						0,0,0,0,
					   	0,0,0,0,
				],3),
				0.1,0,0,0,
				1,1,1,0.4,
			],inf),
			\lpf, Pseq([
				1300,7000,1000,200,
			],inf),
			\hpf, Pseq([
				1300,100,1000,200,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 5,
			\dur, 1/2,
			\amp, 0.2,
		),
	])
)).play;
);

////////////////////////////////////////
(
SynthDef(\rise1, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.kr(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.02) + 1)) * \fma.kr(1) + 1 ));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = FreeVerb2.ar(sig[0], sig[1], \verbmix.kr(0.8), \room.kr(1), \damp.kr(0.4));
	sig = HPF.ar(sig, \hpf.kr(10));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
SynthDef(\fxemerge, { arg out=0, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = LPF.ar(sig, \lpf.kr(10));
	sig1 = FreqShift.ar(sig, \freqshift.kr(100));
	sig = SelectX.ar(\freqshiftmix.kr(0.2), [sig, sig1]);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(
Pdef(\part, Pdef(\progsec1, 
	Ppar([

		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pmono(\rise1,
			\freq, PmodEnv(Pseq([100,1000],1), 8).loop,
			\dur, 1,
			\amp, 0.1,
			\spread, PmodEnv(Pseq([0,1],1), 8).loop,
			\fspread, PmodEnv(Pseq([0,2],1), 8).loop,
			\hpf, PmodEnv(Pseq([4140,1000],1), 8).loop,
		),
		Pbind(
			\instrument, \organ_tonewheel0,
			\bass, 1.0,
			\quint, 1.0,
			\mod, Pseq([
				Pseq([
					0,
				],inf),
				Pseq([
					0,0,0,0, 0,4,4,4,
				],8),
				Pser([
					1,1,0,
					4,4,0,
				],8*8),
			],inf),
			\fundamental, Pkey(\mod),
			\oct, Pkey(\mod),
			\nazard, Pkey(\mod),
			\blockFlute, 1.0,
			\tierce, 1.0,
			\larigot, 1.0,
			\sifflute, 1.0,
			\vrate, 3.0,
			\vdepth, 0.0080000003799796,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8*2) + Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,-12,0,0, -12,0,-12,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,-12,-12,0, 0,0,-12,0,
				//Pseq([
					//0,0,0,0, 0,0,0,0,
				//],7),
				//0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\octave, 6,
			\dur, 1/8/2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxemerge,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\lpf, PmodEnv(Pseq([10,1000],1), 8).loop,
			\freqshift, PmodEnv(Pseq([0,-50],1), 8).loop,
			\freqshiftmix, 0.5,
			\gain, 2,
		),
		Pbind(
			\instrument, \oscfmpad,
			\fspread, 0.0010000000474975,
			\fmadsr, [ [ 0.0, 3.0, 2.0, -99.0, 1.0, 1.1000000238419, 5.0, -4.0, 0.80000001192093, 0.10000000149012, 5.0, -4.0, 0.0, 1.1000000238419, 5.0, -4.0 ] ],
			\fmadsramt, 1.0,
			\fmf, 0.5,
			\fmoscmix, 0.5,
			\fma, 1.0,
			\oscmix, 0.5,
			\lpadsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 1.1000000238419, 0.10000000149012, 1.1000000238419 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\lpadsramt, 0.0,
			\lpf, 200.0,
			\rq, 0.5,
			\adsr, Pseq([
				[ Env.adsr(6.1/~t,0.1,0.8,0.1,1,2) ],
			],inf),
			\legato, 1,
			\note, Pseq([
				[0,3,7] +.x [0,12],
			],inf),
			\dur, 8,
			\octave, 6,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\progsec2, 
	Ppar([

		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				2,0,4,0, 0,0,0,1,
				6,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\rdnfx, \audio),
		),
		Pmono( \rdnfx,
			\inbus, BusDef(\rdnfx, \audio),
			[\delay1, \delay2, \delay3, \delay4], Pseq([
[ 4.2054940775634e-05, 0.0000401416398709, 0.00017010472041281, 0.00017933153253039 ]
			],inf).stutter(8)*1.1,
			[\delay5, \delay6, \delay7, \delay8], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 4.8482431998069e-05, 0.00010166249094134, 1.7451137945053e-06, 1.7451137945053e-06 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(1)* Pseq([0.001,100],inf),
			[\delay9, \delay10, \delay11, \delay12], Pseq([
				//exprand(0.000001,0.0008!4).asCompileString.editorInsert(false)
[ 3.5200899395597e-05, 7.9485703540149e-06, 0.00033602499155682, 4.2689018169048e-05 ],
[ 0.00011741029821307, 2.1275770924054e-06, 0.00010846401909779, 8.2502364984778e-05 ],
//				[ 1.4776361881311e-05, 0.00021369755079883, 0.0021610913869225, 0.00065371045821454 ]
				//rrand(0.01,0.08!4).asCompileString.editorInsert
			],inf).stutter(2)*0.10001,
			\distamp, 0.1,
			\eqmid1, 1400,
			\eqdb1, -2,
			\eqmid2, 400,
			\eqdb2, 2,
			\elpf, 19900,
			\shift1, Pseq([
				Pseq([
					0,0,2,0,
				],4),
				Pseq([
					2,0,-2,0,
				],4),
			],inf)/100,
			\ehpf, 150,
			\gain, 0.6,
			\fb, Pseq([
				Pseq([
					0.1, 0.001, 0.1, 0.001,
				],3),
				0.1, 0.1, 0.2, 0.1,
			],inf)/10,
			\fb, 0.001,
			\shift, 100,
			\distamp2, Pseq([
				0.01, 0.01, 0.01, 0.01,
				1, 1, 1, 1,
				0.01, 1, 0.01, 1,
				0.01, 0.01, 1, 1,
			],inf),
			\distamp, 2/1,
			\dur, 1/8,
			\gain, 0.4,
		),

		Pbind(
			\instrument, \organ_tonewheel0,
			\bass, 1.0,
			\quint, 1.0,
			\mod, Pseq([
				Pseq([
					0,
				],inf),
				Pseq([
					0,0,0,0, 0,4,4,4,
				],8),
				Pser([
					1,1,0,
					4,4,0,
				],8*8),
			],inf),
			\fundamental, Pkey(\mod),
			\oct, Pkey(\mod),
			\nazard, Pkey(\mod),
			\blockFlute, 1.0,
			\tierce, 1.0,
			\larigot, 1.0,
			\sifflute, 1.0,
			\vrate, 3.0,
			\vdepth, 0.0080000003799796,
			\note, Pseq([
				0,0,0,-1,
			],inf).stutter(8*2) + Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,-12,0,0, -12,0,-12,0,
				Pseq([
					0,0,0,0, 0,0,0,0,
				],7),
				0,-12,-12,0, 0,0,-12,0,
				//Pseq([
					//0,0,0,0, 0,0,0,0,
				//],7),
				//0,12,0,0, -12,0,12,0,
			],inf),
			\legato, Pseq([
				Pseq([ 1,1,1,0.7, 1,1,1,1, ],1)*0.7,
				0.5,0.7,0.2,1,
				1,1,1,1,
				1,0.5,0.3,1,
			],inf),
			\octave, 6,
			\dur, 1/8/2,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxemerge,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
			\lpf, PmodEnv(Pseq([1000,2000],1), 8).loop,
			\freqshift, PmodEnv(Pseq([-50,-130],1), 8).loop,
			\freqshiftmix, 0.5,
			\gain, 2,
		),
		Pbind(
			\instrument, \oscfmpad,
			\fspread, 0.0010000000474975,
			\fmadsr, [ [ 0.0, 3.0, 2.0, -99.0, 1.0, 1.1000000238419, 5.0, -4.0, 0.80000001192093, 0.10000000149012, 5.0, -4.0, 0.0, 1.1000000238419, 5.0, -4.0 ] ],
			\fmadsramt, 1.0,
			\fmf, 0.5,
			\fmoscmix, 0.5,
			\fma, 1.0,
			\oscmix, 0.5,
			\lpadsr, [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 1.1000000238419, 0.10000000149012, 1.1000000238419 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
			\lpadsramt, 0.0,
			\lpf, 200.0,
			\rq, 0.5,
			\adsr, Pseq([
				[ Env.adsr(6.1/~t,0.1,0.8,0.1,1,2) ],
			],inf),
			\legato, 1,
			\note, Pseq([
				[0,3,7] +.x [0,12],
			],inf),
			\dur, 8,
			\octave, 6,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[112].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],1).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifxverb, \audio),
		),
		Pmono(\fx_freeverb2,
			\inbus, BusDef(\ifxverb, \audio),
			\addAction, \addToTail,
			\room, 4,
			\mix, 0.7,
			\gain, 0.7,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\prog, 
	Pseq([
		Pfindur(8, Pdef(\progsec1)),
		Pfindur(8, Pdef(\progsec2)),
		
	])
)).play;
);

///// study shift echo fx
(
SynthDef(\fxshiftecho, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Fb({ arg fb;
		var isig;
		isig = ( fb * \fb.kr(0.71) ) + sig;
	
		isig = DelayL.ar(isig, \maxdelay.kr(0.5), \delay.kr(0.3));
		isig = FreqShift.ar(isig, \freqshift.kr(10));
		//isig = Limiter.ar(isig);
		isig;
	});
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// test echo on bass
// nice
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0,
			\dur, 1,
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\delay, 0.123,
			\delay, 3/8/~t,
			\freqshift, PmodEnv(Pseq([1,400,-400],1), 8*2).loop,
			\mix, 1,
			\dur, 1,
			\gain, 0.5,
		),
		//Pmono(\fxshiftecho,
			//\inbus, BusDef(\ifx1, \audio),
			//\addAction, \addToTail,
			//\lag, 0.0009,
			//\delay, 0.323,
			//\mix, 1,
			//\dur, 1,
		//),
		//Pmono(\fxshiftecho,
			//\inbus, BusDef(\ifx1, \audio),
			//\addAction, \addToTail,
			//\freqshift, 300,
			//\delay, 0.123,
			//\lag, 0.0009,
			//\mix, 1,
			//\dur, 1,
		//),
		//Pmono(\fxshiftecho,
			//\inbus, BusDef(\ifx1, \audio),
			//\addAction, \addToTail,
			//\freqshift, -300,
			//\delay, 0.423,
			//\fb, 0.90,
			//\lag, 0.0009,
			//\mix, 1,
			//\dur, 1,
		//),
		
	])
)).play;
);

(
// test echo on bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0,
			\dur, 1,
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\delay, 0.123,
			\delay, 3/8/~t,
			\freqshift, PmodEnv(Pseq([1,40],1), 8*2).loop,
			\mix, 1,
			\dur, 1,
			\gain, 0.5,
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\delay, 0.123,
			\delay, 3/8/~t,
			\maxdelay, 3/4/~t,
			\freqshift, PmodEnv(Pseq([341,1140],1), 8*2).loop,
			\mix, 1,
			\dur, 1,
			\gain, 0.5,
		),
		
	])
)).play;
);

(
// test echo on hat
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0,
			\dur, 1,
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\delay, 1/16/~t,
			\fb, 1.09,
			\fb, 0.95,
			\maxdelay, 5/4/~t,
			//\freqshift, PmodEnv(Pseq([4001,440],1), 8*2).loop,
			\freqshift, 400,
			\mix, 1,
			\dur, 1,
			\gain, 1.5,
		),
		
	])
)).play;
);
(
// test echo on snare
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,1,0,1, 0,0,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1307].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1638].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1017].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pmono(\fxshiftecho, // bypass
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0,
			\dur, 1,
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\fb, 1.09,
			\fb, 0.95,
			//\delay, Pwhite(0.1,1,inf)/~t,
			\delay, PmodEnv(Pseq([1,0.02]/~t,1), 8*2).loop,
			\maxdelay, 1/~t,
			//\freqshift, PmodEnv(Pseq([4001,440],1), 8*2).loop,
			\freqshift, 0.4,
			\mix, 1,
			\dur, 1,
			\gain, 1.5,
		),
		
	])
)).play;
);

(
// hi leadz
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		PmonoArtic(\leadz,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,-1,
				0,12,12,0,
			],inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, Pseq([
				1,1,1,0.1,
				0.9,0.9,0.9,0.9,
				0.1,1,0.1,0.1,
				1,0.8,0.1,1,
			],inf),
			\octave, 5,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		PmonoArtic(\leadz2,
			//\out, BusDef(\fx1, \audio),
			\degree, Pstep(Pseq([
				0,0,0,-1,
				0,0,0,-1,
			],inf),1) + Pseq([
				0,-12,0,0,
				0,0,0,-1,
			],inf),
			\legato, Pseq([
				0,0,0,0,
				1,0.8,0.1,1,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\octave, 6,
			\dur, 1/8,
			\amp, 0.1/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxshiftecho, // bypass
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0,
			\dur, 1,
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\fb, 1.09,
			\fb, 0.45,
			//\delay, Pwhite(0.1,1,inf)/~t,
			//\delay, PmodEnv(Pseq([1,0.02]/~t,1), 8*2).loop,
			\delay, 0.621,
			\maxdelay, 1/~t,
			//\freqshift, PmodEnv(Pseq([4001,440],1), 8*2).loop,
			\freqshift, -60.midicps,
			\mix, 1,
			\dur, 1,
			\gain, 0.5,
		),
	])
)).play;
);

(
// voice
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pmono(
			 \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pn(1,8),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxshiftecho, // bypass
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\mix, 0,
			\dur, 1,
			\isRest, true,
		),
		Pmono(\fxshiftecho,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\fb, 1.09,
			\fb, 0.85,
			//\delay, Pwhite(0.1,1,inf)/~t,
			//\delay, PmodEnv(Pseq([1,0.02]/~t,1), 8*2).loop,
			\delay, 0.121,
			\maxdelay, 1/~t,
			//\freqshift, PmodEnv(Pseq([4001,440],1), 8*2).loop,
			\freqshift, 400,
			\mix, 1,
			\dur, 1,
			\gain, 0.5,
		),
	])
)).play;
);

////////////////////:
// idea: take a centered chord and extract to make it wide stereo


(
SynthDef(\fxhall, { arg out=0, gate=1, pan=0;
	var sig;
	var num=8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = AllpassL.ar(sig, \apmaxdelay.kr(0.3),\apdelay.kr(0.3),\apdecay.kr(4)) + sig;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.3) * ( LFNoise1.kr(\noisefreq.kr(1/12)!num) * \noiseamp.kr(0.9) + 1 ));
	sig = sig.clump(2).flop.flat; // apply num/2 delay on each channel and keep order
	sig.debug("sig");
	sig = FreqShift.ar(sig, LFNoise1.kr(\fsfreq.kr(1/8)!num) * \freqshift.kr(3.5));
	sig = Splay.ar(sig, \spread.kr(0.8), 1, pan);
	sig = \wetgain.kr(1) * sig;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fxhalldist, { arg out=0, gate=1, pan=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = AllpassL.ar(sig, \apmaxdelay.kr(0.3),\apdelay.kr(0.3),\apdecay.kr(4)) + sig;
	sig = DelayL.ar(sig, \maxdelay.kr(0.4), \delay.kr(0.3) * ( LFNoise1.kr(\noisefreq.kr(1/12)!num) * \noiseamp.kr(0.9) + 1 ));
	sig = sig.clump(2).flop.flat; // apply num/2 delay on each channel and keep order
	sig.debug("sig");
	sig = FreqShift.ar(sig, LFNoise1.kr(\fsfreq.kr(1/8)!num) * \freqshift.kr(3.5));
	sig = ( sig*\distamp.kr(80) * ( LFNoise1.kr(0.1!num) * 0.9 + 1 ) ).tanh * \distpostamp.kr(1/2);
	sig1 = BPF.ar(sig, ( \bpf.kr(10000*1.2)*( LFNoise1.kr(1/8!num) * \bpflfoamp.kr(0.9) + 1 ) ).clip(10,20000),0.9);
	sig = SelectX.ar(\bpfmix.kr(0.7), [sig, sig1]);
	sig = Splay.ar(sig, \spread.kr(0.8), 1, pan);
	sig = \wetgain.kr(1) * sig;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);


(
// test chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscfmpad,
			\note, Pseq([
				[0,4+12,7,12],
				[0,4+12,8,12],
				[0,5+12,9,12],
				[0,5+12,9,12]+2,
			],inf),
			\octave, 5,
			\lpadsr, Pseq([
				[ Env.adsr(5.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsr, Pseq([
				[ Env.adsr(2.1,5.1,0.1,0.1) ],
			],inf),
			\fma, 0.02,
			\dur, 2,
			\amp, 0.1/6,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhall,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);

(
// test voice
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, 0,
			\legato, 1,
			\dur, Pn(1,8),
			\gain, 1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhall,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\apdelay, PmodEnv(Pseq([0.01,1],1), 8*2).loop,
			\apmaxdelay, 1.01,
			\apdecay, 4.7,
			\wetgain,0.5,
			\delay, 0.51,
			//\delay, PmodEnv(Pseq([1,0.01],1), 8*2).loop,
			\noiseamp, 1,
			\noisefreq, 0.01,
			\mix, 0.7,
			\freqshift, 1,
			\dur, 1,
		),
	])
)).play;
);

(
// test chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \oscfmpad,
			\note, Pseq([
				[0,4+12,7,12,7+12,24],
				[0,4+12,8,12,8+12],
				[0,5+12,9,12,9+12],
				[0,5+12,9,12,9+12,24]+2,
			],inf),
			\octave, 5,
			\lpadsr, Pseq([
				[ Env.adsr(5.1,0.1,0.8,0.1) ],
			],inf),
			\fmadsr, Pseq([
				[ Env.adsr(2.1,5.1,0.1,0.1) ],
			],inf),
			\fma, 0.02,
			\dur, 2,
			\amp, 0.1/6,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhall,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			//\apdelay, PmodEnv(Pseq([0.01,1],1), 8*2).loop,
			\apmaxdelay, 1.01,
			\apdecay, 4.7,
			\wetgain,0.5,
			\delay, 0.51,
			//\delay, PmodEnv(Pseq([1,0.01],1), 8*2).loop,
			\noiseamp, 1,
			\noisefreq, 0.01,
			\mix, 0.7,
			\freqshift, 1,
			\dur, 1,
		),
	])
)).play;
);

(
// bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,0,0,0, 1,1,0,0,
				0,1,1,0, 1,1,1,1,
			],inf).coin.not,
			\legato, 0.3,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhall,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			//\apdelay, PmodEnv(Pseq([0.01,1],1), 8*2).loop,
			\apmaxdelay, 1.01,
			\apdecay, 4.7,
			\wetgain,0.5,
			\delay, 0.51,
			//\delay, PmodEnv(Pseq([1,0.01],1), 8*2).loop,
			\noiseamp, 1,
			\noisefreq, 0.01,
			\mix, 0.7,
			\freqshift, 1,
			\dur, 1,
			\gain, 4,
		),
	])
)).play;
);

(
// test notes
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,4,6,2
			],inf).stutter(8),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhalldist,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			//\apdelay, PmodEnv(Pseq([0.01,1],1), 8*2).loop,
			\apmaxdelay, 1.01,
			\apdecay, 4.7,
			\wetgain,0.5,
			\delay, 0.51,
			//\delay, PmodEnv(Pseq([1,0.01],1), 8*2).loop,
			\noiseamp, 1,
			\noisefreq, 0.01,
			\mix, 0.5,
			\freqshift, 1,
			\dur, 1,
		),
	])
)).play;
);

////////////////////:
(
SynthDef(\fxhardbass, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = ( sig*\distamp.kr(80) ).tanh * \distpostamp.kr(1/15);
	sig = Fb({ arg fb;
		var isig;
		var lfo = {
			LFNoise1.ar(0.1) * 0.8 + 1;
		};
		isig = ( fb * \fb.kr(0.91) ) + sig;
	
		isig = DelayL.ar(isig,0.2,0.2.rand * lfo.()) + isig  / 2;
		isig = DelayL.ar(isig,0.2,0.02.rand * lfo.()) + isig  / 2;
		isig = DelayL.ar(isig,0.9,0.9.rand * lfo.()) + isig  / 2;
		isig = DelayL.ar(isig,0.9,( 0.9!4 ).rand).mean + isig;
		isig = Limiter.ar(isig);
		isig = isig * 1.8;
		isig = HPF.ar(isig, 30);
		isig;
	});
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 30);
	sig = SelectX.ar(\mix.kr(0.9), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
SynthDef(\fxhardbass, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = ( sig*\distamp.kr(80) ).tanh * \distpostamp.kr(1/15);
	sig = Fb({ arg fb;
		var isig;
		var lfo = {
			LFNoise1.ar(0.1) * 0.8 + 1;
		};
		isig = ( fb * \fb.kr(0.91) ) + sig;
		4.do { arg item, idx;
			
			isig = 4.collect({ 
				DelayL.ar(isig,0.2,0.02.rand * lfo.()) + isig  / 1.4;
			}).mean
		};
	
		//isig = isig * 1.8;
		isig = HPF.ar(isig, 30);
		isig = Limiter.ar(isig);
		isig;
	});
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, 30);
	sig = Limiter.ar(sig, 0.2);
	sig = SelectX.ar(\mix.kr(0.9), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0,1,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind( // bass
			\instrument, \sh101,
			\degree, Pstep(Pseq([
				0,0,0,-1,
			],inf),1),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\legato, 1 * Pseq([
				1,0.4,0.6,0.4,
			],inf),
			\lpf, 400,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fxhardbass,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
	])
)).play;
);

////////////////////////

(
SynthDef(\thickpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=4;
	sig = LFSaw.ar(freq * LFNoise1.kr(1/3!num,mul:0.01 * LFNoise1.kr(0.1!num,mul:10,add:1),add:1) * [3,1,2,4]/2 * ( LFSaw.ar(freq * [4,3,2,1]/2* LFNoise1.kr(1/3!num,mul:0.01,add:1)) * 4 + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(7.1) * freq * LFNoise1.kr(1/3!num,mul:0.7,add:1) ).clip(20,20000), \rq.kr(0.5));
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	//sig = AllpassL.ar(sig, 4/~t, 1/( freq+10 ),1/~t) + sig;
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
// test bass
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\thickpad,
			\note, Pseq([
				0,-4
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);
(
// test chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\thickpad,
			\note, Pseq([
				[0,3,7,7+12],
				[0,3,6,6+12],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);
(
// test chords
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \thickpad,
			\note, Pseq([
				[0,3-12,7,7+12],
				[0-12,3,6,6+12],
			],inf),
			\rq, 0.5,
			\lpfr, 3,
			\octave, 6,
			\dur, 4,
			\amp, 0.1/2,
		),
	])
)).play;
);
