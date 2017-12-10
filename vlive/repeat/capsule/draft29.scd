
// unite the basses
(
SynthDef(\basicbassglitch4, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, glitch=1, lpffac=1;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.04,1.8]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);

	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1, mul: EnvGen.kr(Env([0,1,0,10],[0.02,0.2,0.2]), 1)).tanh * 0.5 + sig;

	//sig = sig;
	sig = RLPF.ar(sig, ( \lpf.kr(100) *lpffac ).clip(20,20000), \rq.kr(0.5));

	sig1 = sig;
	//sig1 = CombL.ar(sig1, 1/freq * Pulse.ar(1).range(2,1),1) + sig1;
	sig1 = FreqShift.ar(sig1, \shift.kr(0) * ( SinOsc.ar(freq*10 * Duty.kr(1/16/~t * lpffac, 0, Dseq([
		1,0,3,0,
	],inf))) * 0.8 + 1 )) + sig1;
	//sig1 = DelayC.ar(sig, 1, \delay.kr(0.1) )+sig1;
	sig = SelectX.ar( EnvGen.kr(Env([0*glitch,0.7*glitch,0,0.7],[0.1,0.01,4.2],-1), 1), [sig, sig1]);
	sig.debug("basicbas");
	sig = TScramble.ar(sig, Impulse.kr(2),0.01);
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,\lpf.kr(7000),0],[0.01,0.4,0.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)


(
	~master.();
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(\out, BusDef(\mixer6))<>
		Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,1,0, 0,0,0,1,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			
				],inf).coin.not,
				\sustain, 0.021,
				\speed, 1+Pseg(Pseq([0,1.1],inf),8),
				\lag, 0.00,
				\gain, 0.4,
				\dur, 1/32,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			Pbind(\pos, Pkey(\pos)+0.01)<>
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.071,
				\dur, 1/16,
				\gain, 0.1,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					1,0,0,
					1,0,0,
					1,0,0,
					1,0,0,
				],inf).coin.not,
				\sustain, 0.05 * Pseq([1,1/2],inf),
				\gain, 0.4*Pseq([
					1,
				],inf),
				\dur, 1/24,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq([
					0,0,0,
					0,0,0,
					0,0,1,
					0,0,0,
				],inf).coin.not,
				\sustain, 0.02 * Pseq([1,1/2],inf),
				\gain, 0.2,
				\dur, 1/24,
				\amp, 0.1,
			)),
		]),
	])
)).play;
)


(
	~master.();
Pdef(\part, Pdef(\bassfile, 
	Ppar([
		Pdef(\drums1),
		Pbind(\out, BusDef(\mixer3))<>
		Pseq([
PmonoArtic(\noisybass,
	\degree, Pstep(Pseq([0,0,0,-4],1),1),
	\scale, Scale.minor,
	\trigx, 1,
	\lpf, 2000,
	\lpfr, 1,
				\lpfr, Pseq([
					~pmodenv.(Pseq([1/2,4],1), 2),
				],inf),
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\detune, Prand([1,0,3],inf),
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1,
),
			Pbind(
				\instrument, \basicbassglitch4,
				\note, Pseq([
					0,0,0,-1,
				],inf).stutter(4),
				\legato, Pseq([
						4,0,0,0,
						2,0,2,0,
				],2)*0.8,
				\shift, Pseq([
					~pmodenv.(Pseq([0.0001,100.1],1), 1),
					~pmodenv.(Pseq([101,100.1],1), 1),
					~pmodenv.(Pseq([-401,10.1],1), 1),
				],inf),
				\lpffac, Pseq([
					~pmodenv.(Pseq([1,4],1), 2),
				],inf),
				\Lpf, Pseq([
					400
				],inf),
				\rq, ~pmodenv.(Pseq([0.5,0.1,0.9],inf), 8),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\glitch, Pseq([0,1],inf).stutter(4),
				\glitch, Pseq([
					1
				],inf),
				\octave, 3,
				\dur, 1/8,
				\amp, 0.07,
			),
		Pbind(
			\instrument, \basicbass,
			\freq, Pseq([
				85,86,87,70,
			],1),
			\lpf, 200,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		],inf),
		
	])
)).play;
)


//////////////:

(

	w = Window.new;
	m = PopUpMenu(w).items_(["kj","kjkkjj"]);
	b = Button(m)
	.states_([
		["kjk"],
		["aakjk"],
	])
	.action_({|v|
		if(v.value.asBoolean.debug("aaa"))
		{v.parent.enabled = false; v.parent.enabled.debug("kj")}
		{v.parent.enabled = true; v.parent.enabled.debug("kj")}
	});
	w.front;
)
