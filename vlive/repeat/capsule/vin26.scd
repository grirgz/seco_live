
~t = 150/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\trbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([0,1,0],[0.1,0.8])), 1);
	env2 = EnvGen.kr(\lpenv2.kr(Env([0,1,0],[0.1,0.8])), 1);
	env3 = EnvGen.kr(Env([0,1,0],[0.01,0.01]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) 
		* (
			( env1 * \lpenvamt.kr(1)  ) 
			+ ( env2 * \lpenv2amt.kr(1) ) 
			+ 1
		)
		* freq ).clip(20,20000), \rq.kr(0.5));
	sig2 = SinOsc.ar(EnvGen.kr(Env([7000,130,1132],[0.01,0.08]), 1)) * env3; 
	sig2 = HPF.ar(sig2, 100) * 2; 
	sig = [sig, sig2].sum;
	//sig = sig2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\padbroke, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,4.8])), 1);
	env2 = EnvGen.kr(\fmenv.kr(Env([0,2,1],[4.1,4.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)] * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(4000) * env1);
	sig2 = sig2 * 1;

	sig3 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)]/2 * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));
	sig3 = sig3 + SinOsc.ar(freq * [1,1+\det.kr(0.00001)]/4 * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));

	lfo1 = SinOsc.ar(0.1 * ( LFNoise1.kr(0.1 * env2).unipolar * 10 + 1 )).unipolar;
	sig = SelectX.ar(\oscmix.kr(0.9) * lfo1 , [sig1, sig2]);
	sig = sig + (sig3 * LFNoise1.kr(1).unipolar);

	sig5 = sig.fold2(0.1)*4;
	sig = SelectX.ar(\foldmix.kr(0.3) * lfo1, [sig, sig5]);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[6].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[266].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.13,
			\gain, Pkey(\gain) * Pseq([
				1,Pwhite(0.0,0.4,1),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,

			\bufnum, ~buflib.hat[1905].value,
			\bufnum, ~buflib.hat[907].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
			\gain, Pkey(\gain) * Pseq([
				Pwhite(0.0,0.8,1),
				Pwhite(0.8,0.4,1),
			],inf),
		),
		Pbind(
			\instrument, \basicclick,
			\freq, 200,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\clickenv, ~pEnv.([ Pseg(Pwhite(6000,12000,inf),Pwhite(1,14,inf)),130,6100],[0.01,0.01], 1),
			\hpf, ~pmodenv.(Pseq([1,2,1,4],inf)*1500, 8),
			\sustain, 0.001,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \trbass,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\lpenvamt, ~pmodenv.(Pseq([4,1/2,5,1,4],inf), 3.3),
			\lpenv2amt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
			\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\isRest, Pseq([
				1,0,1,0,1,0, 
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1/2.4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1885].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\lag, 0.032,
			\dur, 1/8,
			\gain, 0.1/3 * Pseq([
				Pwhite(0.0,0.7,1),Pwhite(0.4,0.9,1),
			],inf),
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[7,12, 12+7],
				[4,12, 12+7],
				[4,12, 12+7],
				[7,0, 12+7],

				[0+12,4, 12+4],
				[0,4, 12+4],
				[0,4, 12+4],
				[4, 12+4,11+24],
			],inf).stutter(2),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,2.1) ],
				],14),
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.5) ],
				],2),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\legato, 0.1,
			\ctranspose, Pseq([
				0,0,-5,-5,-3,-3,-1,-1, 0,0,0,-5,0,0,0,0,
			],inf).stutter(1),
			\dur, 1/2,
			\amp, 0.1/1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		
		Pbind(

			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\isRest, Pseq([
				1,0,1,0,1,0, 
			],inf).coin.not,
			\dur, 1/16,
			\isRest, true,
		)
		<>
		Pdef(\ze_chordo),
		Pbind(

			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\isRest, Pseq([
				1,0,1,0,1,0, 
			],inf).coin.not,
			\dur, 1/16,
		)
		<>
		~ze_list_synth.choose.postln,
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1/3,
			\gain, 1/2,
			\dur, 2,
		),
		
	])
)).play;
);

// add more instr
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[6].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[266].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.13,
			\gain, Pkey(\gain) * Pseq([
				1,Pwhite(0.0,0.4,1),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,

			\bufnum, ~buflib.hat[1905].value,
			\bufnum, ~buflib.hat[907].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
			\gain, Pkey(\gain) * Pseq([
				Pwhite(0.0,0.8,1),
				Pwhite(0.8,0.4,1),
			],inf),
		),
		Pbind(
			\instrument, \basicclick,
			\freq, 200,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\clickenv, ~pEnv.([ Pseg(Pwhite(6000,12000,inf),Pwhite(1,14,inf)),130,6100],[0.01,0.01], 1),
			\hpf, ~pmodenv.(Pseq([1,2,1,4],inf)*1500, 8),
			\sustain, 0.001,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \trbass,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\lpenvamt, ~pmodenv.(Pseq([4,1/2,5,1,4],inf), 3.3),
			\lpenv2amt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
			\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\isRest, Pseq([
				1,0,1,0,1,0, 
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1/2.4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1885].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\lag, 0.032,
			\dur, 1/8,
			\gain, 0.1/3 * Pseq([
				Pwhite(0.0,0.7,1),Pwhite(0.4,0.9,1),
			],inf),
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[7,12, 12+7],
				[4,12, 12+7],
				[4,12, 12+7],
				[7,0, 12+7],

				[0+12,4, 12+4],
				[0,4, 12+4],
				[0,4, 12+4],
				[4, 12+4,11+24],
			],inf).stutter(2),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,2.1) ],
				],14),
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.5) ],
				],2),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\legato, 0.1,
			\ctranspose, Pseq([
				0,0,-5,-5,-3,-3,-1,-1, 0,0,0,-5,0,0,0,0,
			],inf).stutter(1),
			\dur, 1/2,
			\amp, 0.1/1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		
		Pbind(

			\instrument, \kalimba,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0,
				1,0,0.5,0,
			],inf).coin.not,
			\legato, 2,
			\amp, 0.1,
			\dur, 1/16,
			\out, BusDef(\fxchorus, \audio),
		),
		Pbind(

			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\fxchorus, \audio),
		)
		<>
		Pbind(
			\instrument, \hipasslp,
			\octave, 4,
			\fmf1, Pexprand(1,333.0).stutter(16),
			\fmf2, Pexprand(1,9.0).stutter(6),
			\lpf, ~pmodenv.(Prand([4,2,8,5]*1000,inf), 8),
			\hpf, ~pmodenv.(Prand([8,6,7,5]*1000,inf), 8),
			\dur, 1,
			\amp, 0.1,
		),
		//~ze_list_synth.choose.postln,
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1/3,
			\gain, 1/2,
			\dur, 2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[6].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[266].value,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.13,
			\gain, Pkey(\gain) * Pseq([
				1,Pwhite(0.0,0.4,1),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,

			\bufnum, ~buflib.hat[1905].value,
			\bufnum, ~buflib.hat[907].value,
			\isRest, Pseq([
				0,0,1,1,
				0,1,0,1,
				0,0,1,1,
				1,1,0,0,
				1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
			\gain, Pkey(\gain) * Pseq([
				Pwhite(0.0,0.8,1),
				Pwhite(0.8,0.4,1),
			],inf),
		),
		Pbind(
			\instrument, \basicclick,
			\freq, 200,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\clickenv, ~pEnv.([ Pseg(Pwhite(6000,12000,inf),Pwhite(1,14,inf)),130,6100],[0.01,0.01], 1),
			\hpf, ~pmodenv.(Pseq([1,2,1,4],inf)*1500, 8),
			\sustain, 0.001,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \trbass,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\lpenvamt, ~pmodenv.(Pseq([4,1/2,5,1,4],inf), 3.3),
			\lpenv2amt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
			\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\isRest, Pseq([
				1,0,1,0,1,0, 
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1/2.4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1885].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\lag, 0.032,
			\dur, 1/8,
			\gain, 0.1/3 * Pseq([
				Pwhite(0.0,0.7,1),Pwhite(0.4,0.9,1),
			],inf),
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[7,12, 12+7],
				[4,12, 12+7],
				[4,12, 12+7],
				[7,0, 12+7],

				[0+12,4, 12+4],
				[0,4, 12+4],
				[0,4, 12+4],
				[4, 12+4,11+24],
			],inf).stutter(2),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,2.1) ],
				],14),
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.5) ],
				],2),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\legato, 0.1,
			\ctranspose, Pseq([
				0,0,-5,-5,-3,-3,-1,-1, 0,0,0,-5,0,0,0,0,
			],inf).stutter(1),
			\dur, 1/2,
			\amp, 0.1/1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
		),
		
		Pbind(

			\instrument, \kalimba,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0,
				1,0,0.5,0,
			],inf).coin.not,
			\legato, 2,
			\amp, 0.1,
			\dur, 1/16,
			\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \chordlock1,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 5,
			\legato, Pseq([
				16,
				16,
				16,
				16,

				16,
				1/2,
				16,
				1/2,
			],inf).stutter(16),
			\isRest, Pseq([
				Pseq([ 1,Pn(0,15), ],5),
				Pser([ 1,1, ],16),
				Pseq([ 1,Pn(0,15), ],1),
				Pser([ 1,1, ],16),
			],inf).coin.not,
			\dur, 1/16,
			\amp,0.1,
			//\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \stepchord1,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 6,
			\legato, Pseq([
				16,
				16,
				16,
				16,

				16,
				1/2,
				16,
				1/2,
			],inf).stutter(16),
			\amp, 0.1,
			\isRest, Pseq([
				Pseq([ 1,Pn(0,15), ],5),
				Pser([ 1,1, ],16),
				Pseq([ 1,Pn(0,15), ],1),
				Pser([ 1,1, ],16),
			],inf).coin.not,
			\dur, 1/16,
			//\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \stepchord2,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 6,
			\legato, Pseq([
				16,
				16,
				16,
				16,

				16,
				1/2,
				16,
				1/2,
			],inf).stutter(16),
			\amp, 0.1,
			\isRest, Pseq([
				Pseq([ 1,Pn(0,15), ],5),
				Pser([ 1,1, ],16),
				Pseq([ 1,Pn(0,15), ],1),
				Pser([ 1,1, ],16),
			],inf).coin.not,
			\dur, 1/16,
			//\out, BusDef(\fxchorus, \audio),
		),
		Pbind(

			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/16,
			//\out, BusDef(\fxchorus, \audio),
			\isRest, true,
		)
		<>
		~ze_list_synth.choose.postln,
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1/3,
			\gain, 1/2,
			\dur, 2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[6].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[266].value,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.13,
			\gain, Pkey(\gain) * Pseq([
				1,Pwhite(0.0,0.4,1),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,

			\bufnum, ~buflib.hat[1905].value,
			\bufnum, ~buflib.hat[907].value,
			\isRest, Pseq([
				0,0,1,1,
				0,1,0,1,
				0,0,1,1,
				1,1,0,0,
				1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.05,
			\gain, Pkey(\gain) * Pseq([
				Pwhite(0.0,0.8,1),
				Pwhite(0.8,0.4,1),
			],inf),
		),
		Pbind(
			\instrument, \basicclick,
			\freq, 200,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\clickenv, ~pEnv.([ Pseg(Pwhite(6000,12000,inf),Pwhite(1,14,inf)),130,6100],[0.01,0.01], 1),
			\hpf, ~pmodenv.(Pseq([1,2,1,4],inf)*1500, 8),
			\sustain, 0.001,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \trbass,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\lpenvamt, ~pmodenv.(Pseq([4,1/2,5,1,4],inf), 3.3),
			\lpenv2amt, ~pmodenv.(Pseq([1/2,2,1,4],inf), 8),
			\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
			\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*1.7,inf), 10.9),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\isRest, Pseq([
				1,0,1,0,1,0, 
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1/2.4,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1885].value,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\lag, 0.032,
			\dur, 1/8,
			\gain, 0.1/3 * Pseq([
				Pwhite(0.0,0.7,1),Pwhite(0.4,0.9,1),
			],inf),
		),
		Pbind(
			\instrument, \padbroke,
			\note, Pseq([
				[7,12, 12+7],
				[4,12, 12+7],
				[4,12, 12+7],
				[7,0, 12+7],

				[0+12,4, 12+4],
				[0,4, 12+4],
				[0,4, 12+4],
				[4, 12+4,11+24],
			],inf).stutter(2),
			\adsr, Pseq([
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,2.1) ],
				],14),
				Pseq([
					[ Env.adsr(1.1,0.1,0.8,0.5) ],
				],2),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\legato, 0.1,
			\ctranspose, Pseq([
				0,0,-5,-5,-3,-3,-1,-1, 0,0,0,-5,0,0,0,0,
			],inf).stutter(1),
			\dur, 1/2,
			\amp, 0.1/1,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\addAction, \addToTail,
			\lag, 0.0006,
			\mix, 0.5,
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1/6,
			\gain,2,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\fxverb,\audio),
			\isRest, true,
		),
		
		Pbind(

			\instrument, \kalimba,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0,
				1,0,0.5,0,
			],inf).coin.not,
			\legato, 2,
			\amp, 0.1,
			\dur, 1/16,
			\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \chordlock1,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 5,
			\legato, Pseq([
				16,
				16,
				16,
				16,

				16,
				1/2,
				16,
				1/2,
			],inf).stutter(16),
			\isRest, Pseq([
				Pseq([ 1,Pn(0,15), ],5),
				Pser([ 1,1, ],16),
				Pseq([ 1,Pn(0,15), ],1),
				Pser([ 1,1, ],16),
			],inf).coin.not,
			\dur, 1/16,
			\amp,0.1,
			//\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \stepchord1,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 6,
			\legato, Pseq([
				16,
				16,
				16,
				16,

				16,
				1/2,
				16,
				1/2,
			],inf).stutter(16),
			\amp, 0.1,
			\isRest, Pseq([
				Pseq([ 1,Pn(0,15), ],5),
				Pser([ 1,1, ],16),
				Pseq([ 1,Pn(0,15), ],1),
				Pser([ 1,1, ],16),
			],inf).coin.not,
			\dur, 1/16,
			//\out, BusDef(\fxchorus, \audio),
		),
		Pbind(
			\instrument, \stepchord2,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 6,
			\legato, Pseq([
				16,
				16,
				16,
				16,

				16,
				1/2,
				16,
				1/2,
			],inf).stutter(16),
			\amp, 0.1,
			\isRest, Pseq([
				Pseq([ 1,Pn(0,15), ],5),
				Pser([ 1,1, ],16),
				Pseq([ 1,Pn(0,15), ],1),
				Pser([ 1,1, ],16),
			],inf).coin.not,
			\dur, 1/16,
			//\out, BusDef(\fxchorus, \audio),
		),
		Pbind(

			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/16,
			//\out, BusDef(\fxchorus, \audio),
			\isRest, true,
		)
		<>
		~ze_list_synth.choose.postln,
		Pmono(\fx_freeverb2,
			\addAction, \addToTail,
			\lag, 0.0005,
			\inbus, BusDef(\fxverb, \audio),
			\verbmix, 0.6,
			\room, 1.9,
			\damp, 0.7,
			\mix, 1/3,
			\gain, 1/2,
			\dur, 2,
		),
		
	])
)).play;
);


Pdef(\part).clear;

///////////////////////////////////////////////////
// draft

SynthDef(\hipasslp, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, lpenvamt=0.3;
	var sig;
	var lpenv;
	lpenv = EnvGen.kr(\lpenv.kr(Env.adsr(0.2,0.1,0.4,0.1)), gate, doneAction:0);
	sig = LFSaw.ar(freq * ( SinOsc.ar(\fmf1.kr(3) * ( SinOsc.ar(\fmf2.kr(4)) * 1 + 1 )) * 1 + 1 ));
	sig = HPF.ar(sig, \hpf.kr(7000));
	sig = RLPF.ar(sig, \lpf.kr(13001.1) * ( lpenv * lpenvamt + 1 ), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

ProtoDef(\piano).startControl()

(
Pdef(\zedxxx, 
		Pbind(
			\instrument, \default,
			\degree, Pseq((1..50),inf),
			\octave, 4,
			\dur, 1/4,
			\amp, 0.1,
		),
).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
		Pbind(
			\instrument, \trbass,
			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\octave, 5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.02) ],
			],inf),
			\sustain, 0.05,
			\lpenvamt, ~pmodenv.(Pseq([4,1/2,5,1,4]*0.01,inf), 3.3),
			\lpenv2amt, ~pmodenv.(Pseq([1/2,2,1,4]*0.01,inf), 8),
			\rq, ~pmodenv.(Pseq([0.71,0.2,0.1,0.4],inf), 5.8),
			\lpfr, ~pmodenv.(Pseq([2,1/2,1,4]*0.7,inf), 10.9),
			\lpenv, Pseq([
				[ Env([0,1,0],[0.01,0.18]) ]
			],inf),
			\lpenv2, Pseq([
				[ Env([0,1,0],[0.004,0.18], [1,1]) ]
			],inf),
			\isRest, Pseq([
				1,0,1,0,1,0, 
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1/2.4,
		),
	])
)).play;
);

Pdef(\zedxxx).quant = nil
Pdef(\zedxxx).stop



(
SynthDef(\basicclick, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig2 = SinOsc.ar(EnvGen.kr(\clickenv.kr(Env([11000,130,6132],[0.01,0.01]), 1))); 
	sig2 = HPF.ar(sig2, \hpf.kr(100)) * 2; 
	sig = sig2;
	//sig = sig2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicclick,
			\freq, 200,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\hpf, 5000,
			\sustain, 0.001,
			\dur, 1/4,
			\amp, 0.1,
		),
		
		Pbind(

			\note, Pseq([
				Pser([ 0, ],16),
				Pser([ -5, ],16),
				Pser([ -3, ],16),
				Pser([ -1, ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0,  -5,0,-5,0,-5,-5,-5,-5 ],16),
				Pser([ 0, ],16),
				Pser([ 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,-5,-5,-5, ],16),
			],inf),
			\isRest, Pseq([
				1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		)
		<>
		Pdef(\ze_kalimba)
		//~ze_list_synth.choose.postln,
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \basicclick,
			\freq, 200,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\clickenv, ~pEnv.([ Pseg(Pwhite(6000,12000,inf),Pwhite(1,14,inf)),130,6100],[0.01,0.01], 1),
			\hpf, ~pmodenv.(Pseq([1,2,1,4],inf)*1500, 8),
			\sustain, 0.001,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);
