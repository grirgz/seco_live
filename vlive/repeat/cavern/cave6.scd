// pachanga time

(
~t = 124/4/60; TempoClock.default.tempo = ~t;
~swing = 0.06;
~master = {
	ProtoDef(\FxManager).play;
};
~master.();
)

(
SynthDef(\organ_donorenv,{|out= 0 freq = 440 amp = 0.2 gate=1 lforate = 10 lfowidth= 0.0 cutoff= 100 rq=0.5 pan=0.0|

	//Simulation of transistor organ from Steal This Sound
	var vibrato, pulse, filter, env;
	var envcutoff;
	var filtermixenv;
	var vibratofilter;
	envcutoff = EnvGen.kr(\envcutoff.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	filtermixenv = EnvGen.kr(\filtermixenv.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);

	vibrato = SinOsc.ar(lforate,Rand(0,2.0));
	vibratofilter = SinOsc.ar(\lforatefilter.kr(16*~t),Rand(0,2.0));

	//up octave, detune by 4 cents
	//11.96.midiratio = 1.9953843530485
	//up octave and a half, detune up by 10 cents
	//19.10.midiratio = 3.0139733629359

	//Pulse version
	//pulse = Mix(Pulse.ar(([1,1.9953843530485,3.0139733629359]*freq)*(1.0+(lfowidth*vibrato)),Rand(0.4,0.6)!3,[1.0,0.7,0.3]))*0.5;

	//better alternative
	pulse = Mix(VarSaw.ar((
		[
			//1,1.9953843530485,3.0139733629359
			1,6.99.midiratio, 19.10.midiratio,
		]
		* freq)*(1.0+(lfowidth*vibrato)),Rand(0.0,1.0)!3,Rand(0.3,0.5)!3,[1.0,0.7,0.3]))*0.5;

	filter = MoogFF.ar(pulse,(vibratofilter *  \lfowidthfilter.kr(0.1) + 1) * \cutoffamt.kr(1.1) * freq * ( envcutoff * \envcutoffamt.kr(0.21) + 1 ) ,1/rq)*2;
	filter = SelectX.ar(\filtermix.kr(0.6) * ( filtermixenv * \filtermixenvamt.kr(0.7) + 1 ), [pulse, filter]);
	filter = filter * 1.7;

	//env = EnvGen.ar(Env.adsr(0.01,0.5,1.0,0.5),gate,doneAction:2);
	env = EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.5,0.8,0.5)), gate, doneAction:2);

	Out.ar(out,Pan2.ar(filter*env*amp,pan));

//By Nick Collins, from Mitchell Sigman (2011) Steal this Sound
//http://www.sussex.ac.uk/Users/nc81/index.html
}, metadata:(specs:(
	filtermixenv: ParamEnvSpec.new,
	envcutoff: ParamEnvSpec.new,
))).add;
)

(
SynthDef(\bilin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 50;
	freq = freq * [1,2,1/2] * (\bilintab.kr({ 1.0.bilinrand }!num) * \fspread.kr(0.01) + 1);
	sig = sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(( \oscmix.kr(0.5)*\oscmixtab.kr(1!num) ).wrap(0,1)*2, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}, metadata:(specs:(
	oscmix: \unipolar,
	fspread: ControlSpec(0.001,0.2,\exp),
))).add;
);

(
SynthDef(\bilinvib, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 50;
	freq = freq * [1,2,1/2] * (\bilintab.kr({ 1.0.bilinrand }!num) * \fspread.kr(0.01) + 1);
	sig = sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(( \oscmix.kr(0.5)*\oscmixtab.kr(1!num) ).wrap(0,1)*2, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	sig = sig.clump(2).mean;
	sig.debug("sig");
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.kr(\lplfofreq.kr(16*~t)) * \lplfofac.kr(0.11) + 1 ), \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp * \modamp.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	oscmix: \unipolar,
	fspread: ControlSpec(0.001,0.2,\exp),
))).add;
);
(
SynthDef(\bilinvibhi, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 50;
	//freq = freq * [1,2,1/2,4] * (\bilintab.kr({ 1.0.bilinrand }!num) * \fspread.kr(0.01) + 1);
	//sig = sig1 = LFSaw.ar(freq);
	//sig2 = LFPulse.ar(freq);
	//sig3 = SinOsc.ar(freq);
	//sig = SelectX.ar(( \oscmix.kr(0.5)*\oscmixtab.kr(1!num) ).wrap(0,1)*2, [sig1, sig2, sig3]);
	sig = LFPulse.ar(freq * [1,1.001,1.001,1/2,2,2.001,3,3.001].mirror1) * ( 1/[1,1.001,1.001,2,2,2.001,3,3.001].cubed.cubed ).mirror1;
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	//sig = sig.clump(2).mean;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig.debug("sig");
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.kr(\lplfofreq.kr(16*~t)) * \lplfofac.kr(0.11) + 1 ), \rq.kr(0.5));
	sig2 = BPF.ar(sig, freq * -5.midicps);
	sig = SelectX.ar(\lpmix.kr(1), [sig2, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp * \modamp.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	oscmix: \unipolar,
	fspread: ControlSpec(0.001,0.2,\exp),
))).add;
Pdef(\part).reset;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\note, -2,
		\octave, 3,
		\freqx, Pfunc({ arg ev;
			ev.use{~freq.value}
			

		}),
		\mtranspose, 5,
		\dur, 1,
		\amp, 0.1,
	).trace
).play;
);
34.midicps

(
SynthDef(\chordorg, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Psched (8,
			Pbind(
				\instrument, \chordorg,
				\instrument, \organ_donorenv,
				\lfowidth, 0.01,
				\envcutoffamt, 1.21,
				\envcutoff, Pseq([
					[ Env.adsr(0.1,1.7,0.4,0.1) ],
				],inf),
				\cutoffamt, 0.72,
				\lforate, 16*~t,
				\note, Pseq([
					[0],
					[-2],
					[-3],
					[-3],
				].collect({ arg x;
					//( x ++ [ ( x+12 ).choose ] ++ [ ( x-12 ).choose ] ).flat;
					x
				}),inf),
				\ctranspose, 5,
				\octave, 4,
				\oscmixtab, Plazy({
					Pseq([
						[ { 0.1.bilinrand+1 }!100 ],
						[ { 0.9.bilinrand+0.1 }!100 ],
					],1);
				}).loop,
				\fspread, 0.005,
				\adsr, Pseq([
					[ Env.adsr(0.09,0.1,0.8,1.1) ],
				],inf),
				\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1],inf), Pwhite(1,7.0)),
				\lpfr, 2.4,
				\legato, 1.0,
				\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
				\oscmix, ~pmodenv.(Pseq([0.1,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
				\out, 0,
			),
		),
		Pbind(
			\instrument, \chordorg,
			\instrument, \organ_tonewheel1,
			\instrument, \organ_donorenv,
			\sus, 2/~t-0.1,
			\lfowidth, 0.01,
			\envcutoffamt, 7.21,
			\filtermixenvamt, 0.1,
			\envcutoff, Pseq([
				[ Env.adsr(0.1,3.7,0.4,0.1) ],
			],inf),
			\cutoffamt, 1.12,
			\lforate, ~pmodenv.(Prand([16,16.2,15.8]*~t,inf), Pwhite(1.0,8)),
			\note, Pseq([
				[0,4,7],
				[-2+12,2,7],
				[-3+12,2,5],
				[-3+12,0,4],
			].collect({ arg x;
				//( x ++ [ ( x+12 ).choose ] ++ [ ( x-12 ).choose ] ).flat;
				x ++ [x[2]+12];
			}),inf).trace,
			\ctranspose, 5,
			\octave, 4,
			\filtermixenv, Pseq([
				[ Env.adsr(2.1,2.1,0.1,0.1) ],
			],inf),
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
					[ { 0.9.bilinrand+0.1 }!100 ],
				],1);
			}).loop,
			\fspread, 0.005,
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,1.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1],inf), Pwhite(1,7.0)),
			\lpfr, 2.4,
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.1,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, 2,
			\amp, 0.061,
			\amp, 0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Psched(0,Pmono(
			\bilinvibhi,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\degree, Prand([
					[0],
					[-2],
					[-3],
					[-3],
					[0],
					[-2],
					[-3],
					[-3],
				[0,4,7],
				[-2,2,7],
				[-3,2,5],
				[-3,0,4],
			].flat,inf),
			\ctranspose, 5,
			\octave, 5,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
					[ { 0.9.bilinrand+0.1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.05],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, ~pmodenv.(Pseq([1/2,1,2,1,4],inf), Pwhite(1.0,8)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.1,0.9,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, 0,
			\rq, 0.4,
			\lpmix, 0.8,
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1,2,4,6],[1,2,3,4,5,5].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		)),
	])
)).play;
);

(
Pdef(\part2, Pdef(\zedpart2, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 34.midicps, 34.midicps/2], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				Pseq([
					1,0,1,0, 1,0,1,0,
				],8+4),
				Pseq([
					1,0,1,0, 1,0,1,1,
				],32),
				Pseq([
					0,0,0,0, 0,0,0,0,
				],8),
				//1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
			\out, BusDef(\filter1, \audio),
		),
		Pmono(\fx_hpf,
			\inbus, BusDef(\filter1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\hpf, ~pmodenv.(Pseq([10000,400,200,Pn(2,inf)],inf), 1),
			\mix, 1,
			\gain, 3,
			\dur, 1,
		),
		Psched(8+8+4,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			//\bufnum, ~buflib.hat[60].value,
			\bufnum, ~buflib.hat[799].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([1,0.95],inf),
			\dur, 1/16,
			\gain, 0.1 * Pseq([
				1,Pexprand(0.6,0.9,1),
				1,Pexprand(0.6,0.9,1),
				1,Pexprand(0.1,0.5,1),
				1,Pexprand(0.6,0.9,1),
			],inf),
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
		)),
		Psched(4+8,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\bufnum, ~buflib.snare[2407].value,
			\bufnum, ~buflib.snare[1652].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\speed, Pseq([0.95,1],inf).stutter(4),
			\dur, 1/8,
			\gain, 0.1,
		)),
		Psched(8+8,Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.drum[56].value,
			//\bufnum, ~buflib.drum[~buflib.drum.size.rand.debug("d")].value,
			\bufnum, 
			Pseq([
				Pser([
					~buflib.drum[55].value,
				],inf),
				Pser([
					~buflib.drum[56].value,
				],1),
				Pser([
					~buflib.drum[55].value,
					~buflib.drum[56].value,
				],4),
				Pser([
					~buflib.drum[56].value,
				],4),
			],inf),
			\isRest, Pseq([
				0,1,1,0, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
			\isRest, Pseq([
				//0,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,1,1,
				0,0.71,1,1, 1,0.71,1,0, 0,0,0,0.51, 1,0,1,1,
			],inf).coin.not,
			\speed, Pseq([
				Pser([
					1,0.9778,
					1,
				],8),
				Pser([1],8),
			],inf),
			\legato, 1.2,
			\dur, 1/16,
			\gain, 0.3 * Pseq([
				Pser([
					Pexprand(0.6,0.9,1),
					Pexprand(0.2,0.9,1),
				],12),
				Pexprand(0.6,0.9,4),
			],inf),
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\out, BusDef(\movefil, \audio),
		)),
		Pmono(\fx_rlpfrhpf,
			\inbus, BusDef(\movefil, \audio),
			\addAction, \addToTail,
			\lpf, ~pmodenv.(Pexprand(1000,17000,inf), Pwhite(5.0,18)),
			\hpf, ~pmodenv.(Pexprand(100,10000,inf), Pwhite(5.0,18)),
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\parteze, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 34.midicps, 34.midicps/2], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				//1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[60].value,
			//\bufnum, ~buflib.hat[799].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([1,0.95],inf),
			\dur, 1/16,
			\gain, 0.1 * Pseq([
				1,Pexprand(0.6,0.9,1),
				1,Pexprand(0.6,0.9,1),
				1,Pexprand(0.1,0.5,1),
				1,Pexprand(0.6,0.9,1),
			],inf),
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\bufnum, ~buflib.snare[2407].value,
			\bufnum, ~buflib.snare[1652].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\speed, Pseq([0.95,1],inf).stutter(4),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \bilin,
			\note, Pseq([
				2,0,
			],inf),
			\ctranspose, 5,
			\octave, 6,
			\dur, 4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bilinvib,
			\note, Pseq([
				[0,4,7],
				[-2,2,7],
				[-3,2,5],
				[-3,0,4],
			].collect({ arg x;
				( x ++ [ ( x+12 ).choose ] ++ [ ( x-12 ).choose ] ).flat;
			}),inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
					[ { 0.9.bilinrand+0.1 }!100 ],
				],1);
			}).loop,
			\fspread, 0.005,
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,1.1) ],
			],inf),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\lpfr, 2.4,
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0.1,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\parteze, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 34.midicps, 34.midicps/2], [0.035, 0.08], curve: \exp) ],
			\bodyenv, [ Env.linen(0.005, 0.1, 0.3) ],
		
			\popfstart, 750,
			\popfend, 261,
			\popfdur, 0.02,
			\popenv, [ Env.linen(0.001, 0.02, 0.001) ],
			\popamp, 0.15,
		
			\formfund, 910,
			\formfreq, 4760,
			\formbw, 2110,
			\lpf, 3140,
			\clickat, 0.001,
			\clickrel, 0.01,
			\clickamp, 0.15,
		
			\distpreamp, 1,
			\distpostamp, 1,
		
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				//1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[60].value,
			//\bufnum, ~buflib.hat[799].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\speed, Pseq([1,0.95],inf),
			\dur, 1/16,
			\gain, 0.1 * Pseq([
				1,Pexprand(0.6,0.9,1),
				1,Pexprand(0.6,0.9,1),
				1,Pexprand(0.1,0.5,1),
				1,Pexprand(0.6,0.9,1),
			],inf),
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			//\bufnum, ~buflib.snare[2407].value,
			\bufnum, ~buflib.snare[1652].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\speed, Pseq([0.95,1],inf).stutter(4),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \bilin,
			\note, Pseq([
				[0,4,7],
				[-2+12,2,7],
				[-3+12,2,5],
				[-3+12,0,4],
			].collect({ arg x;
				( x ++ [ ( x+12 ).choose ] ++ [ ( x-12 ).choose ] ).flat;
			}),inf),
			\ctranspose, 5,
			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
					[ { 0.02.bilinrand+1 }!100 ],
				],1);
			}).loop,
			\fspread, 0.005,
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,1.1) ],
			],inf),
			\legato, 1.0,
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\oscmix, ~pmodenv.(Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
			\dur, 2,
			\amp, 0.1,
		),
		
	])
)).play;
);
1.0.bilinrand

Pdef(\chord, Pbind(\instrument, \bilin))
ProtoDef(\piano).startControl(Pdef(\chord))
Pdef(\chord).edit

(
SynthDef(\bilinvibrond, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 50;
	//freq = freq * [1,2,1/2,4] * (\bilintab.kr({ 1.0.bilinrand }!num) * \fspread.kr(0.01) + 1);
	//sig = sig1 = LFSaw.ar(freq);
	//sig2 = LFPulse.ar(freq);
	//sig3 = SinOsc.ar(freq);
	//sig = SelectX.ar(( \oscmix.kr(0.5)*\oscmixtab.kr(1!num) ).wrap(0,1)*2, [sig1, sig2, sig3]);
	sig = LFPulse.ar(freq * [1,1.001,1.001,1/2,2,2.001,3,3.001].mirror1) * ( 1/[1,1.001,1.001,2,2,2.001,3,3.001].cubed.cubed ).mirror1;
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	//sig = sig.clump(2).mean;
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig.debug("sig");
	sig1 = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( SinOsc.kr(\lplfofreq.kr(16*~t)) * \lplfofac.kr(0.11) + 1 ), \rq.kr(0.5));
	sig2 = BPF.ar(sig, freq * -5.midicps);
	sig = SelectX.ar(\lpmix.kr(1), [sig2, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp * \modamp.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	oscmix: \unipolar,
	fspread: ControlSpec(0.001,0.2,\exp),
))).add;
Pdef(\part).reset;
);
(
// calme
~master.();
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Psched (8,
			Pbind(
				\instrument, \chordorg,
				\instrument, \organ_donorenv,
				\lfowidth, 0.01,
				\envcutoffamt, 1.21,
				\envcutoff, Pseq([
					[ Env.adsr(0.1,1.7,0.4,0.1) ],
				],inf),
				\cutoffamt, 0.72,
				\lforate, 16*~t,
				\note, Pseq([
					[0],
					[-2],
					[-3],
					[-3],
				].collect({ arg x;
					//( x ++ [ ( x+12 ).choose ] ++ [ ( x-12 ).choose ] ).flat;
					x
				}),inf),
				\ctranspose, 5,
				\octave, 4,
				\oscmixtab, Plazy({
					Pseq([
						[ { 0.1.bilinrand+1 }!100 ],
						[ { 0.9.bilinrand+0.1 }!100 ],
					],1);
				}).loop,
				\fspread, 0.005,
				\adsr, Pseq([
					[ Env.adsr(0.09,0.1,0.8,1.1) ],
				],inf),
				\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1],inf), Pwhite(1,7.0)),
				\lpfr, 2.4,
				\legato, 1.0,
				\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
				\oscmix, ~pmodenv.(Pseq([0.1,1/2,0.6,Pwhite(0,1.0,1)],inf), Pwhite(0.5,7)),
				\dur, 2,
				\amp, 0.1,
				\out, BusDef(\sendbus1, \audio),
				\out, 0,
			),
		),
		Pdef(\organ_donorenv, 
			Pbind(
				\instrument, \organ_donorenv,
			)
		) <>
		Pbind(
			\instrument, \organ_donorenv,
			\sus, 2/~t-0.1,
			\lfowidth, 0.01,
			\envcutoffamt, 3.21,
			\envcutoff, Pseq([
				[ Env.adsr(0.1,3.7,0.7,0.1) ],
			],inf),
			\cutoffamt, 1.02,
			\lforate, ~pmodenv.(Prand([16,16.2,15.8]*~t,inf), Pwhite(1.0,8)),
			\note, Pseq([
				[0,4,7],
				[-2+12,2,7],
				[-3+12,2,5],
				[-3+12,0,4],
			].collect({ arg x;
				//( x ++ [ ( x+12 ).choose ] ++ [ ( x-12 ).choose ] ).flat;
				x ++ [x[2]+12];
			}),inf).trace,
			\ctranspose, 5,
			\octave, 4,
			\filermix, 1,
			\filtermixenvamt, 0.1,
			\filtermixenv, Pseq([
				[ Env.adsr(0.1,1.7,0.4,0.1) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.09,0.1,0.8,1.1) ],
			],inf),
			\legato, 1.0,
			\dur, 2,
			\amp, 0.061,
			\amp, 0.10,
			\out, BusDef(\sendbus1, \audio),
		),
		Psched(8+8,Pmono(
			\bilinvibrond,
			//\note, Pseq([
				//2,0,
			//],inf),
			\degree, Pstep(Pwhite(0,7),Prand([Pseq([1/8],8),1,2,4],inf)),
			\degree, Prand([0,2,4],inf),

			\degree, Prand([
					[0],
					[-2],
					[-3],
					[-3],
					[0],
					[-2],
					[-3],
					[-3],
				[0,4,7],
				[-2,2,7],
				[-3,2,5],
				[-3,0,4],
			].flat,inf),
			\ctranspose, 5,
			\octave, 5,
			//\dur, PdurStutter(Pseq([1,4],inf), 4),

			\oscmixtab, Plazy({
				Pseq([
					[ { 0.1.bilinrand+1 }!100 ],
					[ { 0.9.bilinrand+0.1 }!100 ],
				],1);
			}).loop,
			\fspread, ~pmodenv.(Pseq([0.005,0.05],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([1/2,1,2,1,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\adsr, Pseq([
				[ Env.adsr(1.4,0.1,0.8,2.1) ],
			],inf),
			\dur, Pwrand([1/8,1/4,1,2,4,6],[1,2,3,4,5,5].cubed.normalizeSum,inf),
			\amp, 0.1/2,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		)),
	])
)).play;
);

Pdef(\organ_donorenv).edit
