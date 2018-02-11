~t = 145/3/60; TempoClock.default.tempo = ~t; // dont know original
(
SynthDef(\playersec_fxpan, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var osig;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	osig = sig;
	sig = sig * SinOsc.ar(\amplfo.kr(8*~t)).range(env1,1);
	sig = sig + FreqShift.ar(sig, SinOsc.kr(\shiftlfo.kr(4*~t)).range(env2,1));
	sig = SelectX.ar(\mix.kr(0), [osig, sig]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\bizar3pan, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, tsustain=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env.kr(Env([2,1,1/2,2],[0.1,0.8,0.1].normalizeSum)), gate, timeScale:tsustain);
	sig = LFSaw.ar(freq * [1,1+\diff.kr(0.001)]).sum;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar([12,12.010]*100) * 1 )));
	sig = sig * ( LFSaw.ar(freq * \amdetune.kr(1.001) * [1,1+\diff.kr]) + 1 );
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, 1).sum;
	sig = sig * amp / 3;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\pandrums, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fxpan,
			\kitIndex, 0,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.31,
			\dur, 1/4,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fxpan,
			\mix, 1,
			\kitIndex, 4,
			//\pos, 0,
			\amplfo, 8*~t,
			\isRest, Pseq({[
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 1.0,
			\dur, 1/2,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \trabass,
			\degree, 0,
			\octave, 3,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.10,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \trabass,
			\octave, 3,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				0,1,0,1, 0,1,0,1,
				1,0,0,1, 0,0,1,0,
				1,1,0,0, 1,1,0,1,
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.05,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \trabass,
			\octave, 3,
			\isRest, Pseq([
				Pseq([
					1,0,1,1, 0,1,1,1,
					1,0,1,1, 0,1,1,0,
					1,0,1,1, 0,0,1,0,
					1,0,1,0, 1,0,1,0,
				],16),
				Pseq([
					1,0,0,1, 0,0,1,0,
				],16*4),
			],inf).coin.not,
			\lpfr, 1.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\rq, 0.1 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
			\sustain, 0.05,
			\dur, 1/8,
			\amp, 0.1
		),
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fxpan,
			\kitIndex, 4,
			\isRest, Pseq({[
				1,0.5,1,0.5,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2,
			\speed, Pseq([0.2,0.15,0.8,0.27],inf).stutter(1),
			\dur, 1/4,
			\gain, 1/2,
			\gain, 1/2 * Pswitch1(
				Pseg(Prand([0,0.5,0.2,0.8,1],inf),8) ! 4,
				Pseq([0,1,2,3],inf)
			),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fxpan,
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\instrument, \playersec_fxpan,
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\speed, Pseg(Prand((1..8)/19 + 1.3,inf),8),
			\dur, 1/16,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
			\amp, 0.1,
		)),
		//Pbind(
		//	\instrument, \bizar,
		//	\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),8),
		//	\fold, 1 * Pseg(Prand([3,1,2,1]/1.814,inf),8),
		//	\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		//	\dur, 1/8,
		//	\amp, 0.1
		//),
		//Ppar(
		//	{Pbind(
		//		\instrument, \bizar2,
		//		\freq, 200 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\diff, 0.001 * Pseg(Prand([100,3,1,2,1]/0.814,inf),16),
		//		\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
		//		\lpfr, 4 * Pseg(Prand([3,1,2,1]/0.814,inf),16),
		//		\rq, 1 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\amdetune, 0.01 * Pseg(Prand([0.01,0.5,0.2,0.81],inf),8),
		//		\isRest, Pseq([
		//			Pseq({[
		//			1,1,1,1, 1,1,1,1,
		//			1,0,1,0, 1,0,1,0,
		//			1,0,0,0, 1,0,0,0,
		//			0,0,1,0, 0,0,1,0,
		//			].clump(4).choose}.dup(8).flat,inf)
		//		],inf).coin.not,
		//		\dur, 1/[8,4,16,1,2].choose,
		//		\amp, 0.1/4,
		//	)} ! 4,
		//),
		//Pbind(
		//	\isRest, Pstep(Pseq([
		//		Prand([
		//			Pseq([ 1,0,1,0, ],1),
		//			Pseq([ 1,1,0,0, ],1),
		//			Pseq([ 0,0,1,1, ],1),
		//		],inf),
		//	],inf),1).coin.not,
		//) <>
		Pbind(
			\instrument, \bizar3pan,
			\tsustain, 4,
			//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
			\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
			\detune, Pseg(Pseq([0,1000],inf),8),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1/8,
			\amp, Pkey(\amp) * Pseg(Prand([0,0.5,0.2,0.81],inf),8),
		) ! 4,
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	//\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	\degree, Pwhite(-12,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 1,0,1,0, ],1),
		//	],inf),1).coin.not,
		//	\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
		//Pbind(
		//	\instrument, \bizar2,
		//	\tsustain, 4,
		//	\freq, Pwhite(100,1000.0,inf).stutter(Prand([8,4,2,16],inf)),
		//	//\degree, Pwhite(0,12,inf).stutter(Prand([8,4,2,16],inf)),
		//	\isRest, Pstep(Pseq([
		//			Pseq([ 0,1,0,1, ],1),
		//	],inf),1).coin.not,
		//	//\detune, Pseg(Pseq([0,1000],inf),8),
		//	\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
		//	\amp, 0.1/4,
		//),
		Pbind(
			\instrument, \noiser,
			\lpfenv, Pfunc({ arg ev;
				[ Env([1,1.0.rand,1.0.rand,1],[0.1,0.1,0.8]) ];
			}),
			\hpf, 200,
			\hpfenv, [ Env([1/2,74,42,81],[0.4,0.1,0.8]) ],
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\tsustain, 1/2/~t,
			\gain, 1 * Pseg(Prand([0,0.5,0.2,0.81],inf),16),
			\legato, 2,
			\dur, 1/8,
			\amp, 0.07,
		),
	].flat.collect({ arg pat, idx;
		Pbind(
			\pan, Pseg(Pseq(( [0] ++ ( [-1,1].choose ! ( 12*2 ) )).rotate(idx*2).debug("% array:".format(idx)) ,inf),8),
			\sayer, Pfunc({ arg ev; 
				var pan = ev.pan;
				if(pan.abs  < 1) {
					"this is % time! pan=%".format(idx, pan).debug;
				};
				1;
			}),
		) <> pat;
		
	}))
).play;
);

////////////////////////::


(
Ndef(\blip, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.kr(Env([0,1,0],[8.1,8.8]), 1);
	sig = 10.collect({
		var env1 = EnvGen.kr(Env([1,2,1/2].rand,[1.1,1.8].rand), Impulse.kr(1/(10.0.rand+1)));
		sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq * env1) * 1 * env2 )));
	});
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\blip, { arg freq=200, pan=0, amp=0.1;
	var sig;
    var pop, popAmp, popFreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var trig = Impulse.kr(1);
	env1 = EnvGen.kr(Env([0,0,0.51,4],[0.01,0.7,0.1]), trig);
	env2 = EnvGen.kr(Env([4,4,1.7,1/2],[0.01,0.4]), trig);
    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp), trig);
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11), trig) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
	freq = freq * env2;
	sig = 10.collect({
		var enva = EnvGen.kr(Env([1,2,1/2].rand,[1.1,1.8].rand), Impulse.kr(1/(10.0.rand+1)));
		sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq * enva) * 1 * env1 )));
	});
	sig = sig + pop;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


Pdef(\mymod, { arg mfreq;
	Pbind(
		\instrument, \sinmod,
		\freq, mfreq,
	)
	
});




Pbind(
	\instrument, \mybass,
	\lpfr, PmodSynth({ SinOsc.ar(10) }),
	\hpfr, PmodSynth({ SinOsc.ar(fmfreq) }),
)


// il me faut une syntaxe qui:
- permet de sequencer (patterns)
- permet d'interconnecter les synths (bus dans les patterns ou Ndef)
	- fx insert/send
	- modulation control/audio

quand on ecrit des patterns, les synthdefs sont loin et c'est chiant a modifier, c'est tellement plus facile de s'exprimer en ecrivant directement des ugens, en meme temps c'est tellement compliqué de tout sequencer sans utiliser de pattern, j'arrive jamais a reconcilier ces deux mondes

d'un autre coté je me demande si c'est vraiment pratiquable de sequencer et connecter en meme temps, peut etre que c'est pas le langage le probleme, mais juste que c'est quelquechose de super compliqué! suffit de voir comme c'est simple de mettre les instru dans des channels avec des insertfx et sendfx et du pmodenv sur certains parametres, c'est reglé
	surtout quand on pense que beaucoup d'effets sont fait pour etre partagés par plusieurs pistes

si on imagine un Pbind comme ca :

Pbind(
	\instrument, \mybass,
	\lpfr, PmodSynth({ SinOsc.ar(10) }),
	\hpfr, PmodSynth({ arg fmfreq; SinOsc.ar(fmfreq) }, Pbind(
		\fmfreq, Pseq([10, 1, 2]),
		\dur, 1,
	)),
	\dur, 1/8,
)


/////////////////////////////////////////


(
SynthDef(\grind, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[2.1,4.8]), 1);
	sig = Pulse.ar(freq * ( 1 + ( SinOsc.ar(freq +[1,1.01]) * env1 )));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\grindfx, { arg out=0, delfac=1, gate=1, decayfac=1, chorfreq=1, chorModAmp=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	sig = in;
	sig = sig + Fb { arg fb;
		var isig, isig1;
		isig = ( fb * \fb.kr(1) ) + sig;
		isig = AllpassC.ar(sig, 1,delfac * 11*\deltab.kr([1,1,1,1, 1,1,1,1]) * 0.01 * SinOsc.ar(1/2 * chorfreq).range(0,chorModAmp), decayfac).sum + isig;
		isig = AllpassC.ar(sig, 1,delfac * 11*0.01 * SinOsc.ar(1/2 * chorfreq).range(0,chorModAmp), decayfac) + isig;
		isig = AllpassC.ar(sig, 1,delfac *13*0.001 * SinOsc.ar(1/3* chorfreq).range(0,chorModAmp), decayfac) + isig;
		isig = AllpassC.ar(sig, 1,delfac *17*0.1 * SinOsc.ar(1/5* chorfreq).range(0,chorModAmp), decayfac) + isig;

		isig1 = ( isig*\distamp.kr(10) ).softclip * \distpostamp.kr(1/2);
		isig = SelectX.ar(\distmix.kr(0.5), [isig, isig1]);
		isig = RLPF.ar(isig, \lpf.kr(1000), \rq.kr(0.1)) + isig / 2;
		isig = RLPF.ar(isig, \lpf2.kr(1000), \rq2.kr(0.1)) + isig / 2;
	
		isig = LeakDC.ar(isig);
		isig = Limiter.ar(isig);
		isig;
	};
	//sig = sig * 0.1;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:1);
	Out.ar(out, sig);
}).add;


	Pdef(\grind, 
		Ppar([
			Pbind(
				\instrument, \grind,
				\out, BusDef(\fx1, \audio),
				\freq, 200,
				\dur, 1,
				\amp, 0.1
			),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\out, BusDef(\fx1, \audio),
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\out, BusDef(\fx1, \audio),
				\isRest, Pseq({[
					1,0,1,0, 0,0,0,0,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,1,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pdef(\grindfx, Pbind(\instrument, \grindfx)) <>
			Pmono(\grindfx,
				\inbus, BusDef(\fx1, \audio),
				\fb, 0.5,
				\freq, 200,
				\dur, 1,
				\amp, 0.1
			),
			Pmono( \siren,
				\out, BusDef(\fx1, \audio),
				\freq, 800,
				\fm, 4*~t,
				\legato, 1,
				\dur, 1,
				\amp, 0.1/3,
			),
		])
	).play;
)


(
	WindowDef(\gui, {
		VLayout (
			ParamGroup([
				Param(Pdef(\grindfx), \fb, ControlSpec(0,2,\lin)).setBusMode,
				Param(Pdef(\grindfx), \delfac, \delay).setBusMode,
			]).asView,
			Pdef(\grindfx).asParamGroup.asView,
		)
		
	}).front;
)

Pdef(\grindfx).setBusMode(\fb, \lpf, \lpf2, \rq, \rq2)

(
SynthDef(\siren, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq* EnvGen.kr(Env([1,2,1]/10+1,[0.1,0.8]), Impulse.kr(1/10));
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(\fm.kr(4*~t) * [1/2,1,1.04]) * 0.71 )));
	sig = FreqShift.ar(sig, SinOsc.kr(1/13).range(0,100));
	sig = sig * SinOsc.kr(1/14 * [1,1.1]).range(0,1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);
