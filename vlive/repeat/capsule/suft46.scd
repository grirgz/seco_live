(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.2,1.4]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([1,1,0,0],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	//sig = sig * ( SinOsc.ar(freq) + 1  );
	sig1 = ( SinOsc.ar(freq) + 1  );
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig * sig1;
	sig = LPF.ar(sig, \lpfr.kr(8.1) * freq);

	sig1 = SinOsc.ar(2*~t).exprange(0.1,1);
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig/4 + LPF.ar(sig.fold2( sig1 ), 10000);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

(
~t = 185/4/60; TempoClock.default.tempo = ~t;
ProtoDef(\rdn).outBus = 0;
)

ProtoDef(\rdn).edit
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
	])
)).play;
)

~rdn_to_fbstring.(RandDelayNetwork(ProtoDef(\rdn).fxdef)).editorInsert
(

		SynthDef(\himaster, { arg out=0, gate=1;
			var sig;
			var sig2;
			var si, env = ();
			var si2;
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 972536;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
si = SelectX.ar(\shiftmix.kr, [
si,
FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
]);
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
si = SelectX.ar(\shiftmix.kr, [
si,
FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2,
]);
si = [
			{ arg si, env;
		si = (si * 10.0.rand * \distamp.kr).tanh / 2;
}.value(si, env);
,
			{ arg si, env;
		si = (si * 10.0.rand * \distamp2.kr).tanh / 2;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay.kr) + si;
}.value(si, env);
,
			{ arg si, env;
		si = (si * 10.0.rand * \distamp.kr).tanh / 2;
}.value(si, env);
,
			{ arg si, env;
		si = (si * 10.0.rand * \distamp3.kr).tanh / 2;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay3.kr) + si;
}.value(si, env);

].mean;
si = (si * 10.0.rand * \distamp2.kr).tanh / 2;
si = (si * 10.0.rand * \distamp.kr).tanh / 2;
}.value(si, env);

			sig2 = HPF.ar(sig, \hpf.kr(14), \hprq.kr(0.1));
			sig2 = LPF.ar(sig2, \lpf.kr(19900), \lprq.kr(1));
			sig = SelectX.ar(\pfmix.kr(0.0), [sig, sig2]);
			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			sig2 = HPF.ar(sig, \posthpf.kr(14), \posthprq.kr(0.1));
			sig2 = LPF.ar(sig2, \postlpf.kr(19900), \postlprq.kr(1));
			sig = SelectX.ar(\postpfmix.kr(0.0), [sig, sig2]);

			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * \modgain.kr(1).lag(\modgainlag.kr(0));
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

		
Pbind(
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.16221239391292,
	'delay3', 0.0001,
	'distamp', 3.5515682761809,
	'distamp2', 0.69909760632006,
	'distamp3', 1.1787686347936,
	'shift', -5.0,
	'shift2', -1.1344537815126,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 222.45823289167,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.11080171195222,
	'brffac', 0.1,
	'stereo', 0.0,
)

		
);


(

		SynthDef(\feedmaster, { arg out=0, gate=1;
			var sig;
			var sig2;
			var si, env = ();
			var si2;
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 905402;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay3.kr) + si;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay.kr) + si;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
si = (si * 10.rand * \distamp3.kr).tanh / 2;
si = SelectX.ar(\shiftmix.kr, [
si,
FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift2.kr) + si / 1.2,
]);
si = SelectX.ar(\shiftmix.kr, [
si,
FreqShift.ar(si, 1.0.rand * [1,-1].choose * \shift.kr) + si / 1.2,
]);
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay.kr) + si;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay.kr) + si;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
si = DelayC.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+(\stereo.kr*0.01.rand)] * \delay2.kr) + si;
			si2 = HPF.ar(si, \ihpf.kr(1), \ihprq.kr(0.1));
			si2 = LPF.ar(si2, \ilpf.kr(19000), \ilprq.kr(1));
			si = SelectX.ar(\ipfmix.kr(0.0), [si, si2]);
}.value(si, env);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			//sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			//sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
			sig2 = HPF.ar(sig, \ehpf.kr(1), \ehprq.kr(0.1));
			sig2 = LPF.ar(sig2, \elpf.kr(19000), \elprq.kr(1));
			sig = SelectX.ar(\epfmix.kr(0.0), [sig, sig2]);
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

		
Pbind(
	'mix', 1.0,
	'gain', 1.0052997797722,
	'fb', 0.0022170302067215,
	'delay', 0.002297970969047,
	'delay2', 0.00013111339374216,
	'delay3', 0.00074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'ilpf', 19900,
	'ihpf', 17,
	'ipfmix', 0,
	'elpf', 19900,
	'ehpf', 17,
	'epfmix', 0,
	'indelay', 0.04,
)

		
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
		)),
		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, 1,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8,
	'fb', 0.0022170302067215,
	'delay', 0.002297970969047,
	'delay2', 0.00013111339374216,
	'delay3', 0.30074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,1,0,0,
				1,1,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 0,0,
				0,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, PdurStutter(Pseq([1,4,2,8],inf).stutter(4), 1),
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8/2,
	'fb', 0.0022170302067215,
	'delay', 0.002297970969047,
	\delay, ~pmodenv.(Pseq([
		0.000001,0.0002
	],inf), 1/1),
	'delay2', 0.00013111339374216 * Pseq([
		1,1/8,1,1/8, 8,1,1,
	],inf),
	'delay3', 0.00074808264552251 * Pseq([
		1,100,10,100,
	],inf),
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),

		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, 1,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8,
	'fb', 0.0022170302067215,
	'delay', 0.000002297970969047,
	'delay2', 0.0000023111339374216,
	'delay3', 0.0000074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 2.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'ilpf', 19900,
	'ihpf', 470,
	\ipfmix, 1,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	\epfmix, 1,
	\ehpf, 400,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),
	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([761, 54, 21], [0.015, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,1,0,0,
				1,1,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\fx1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,0, 1,0, 1,0, 0,0,
				0,0, 1,0, 1,0, 1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, PdurStutter(Pseq([1,4,2,8],inf).stutter(4), 1),
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8/2,
	'fb', 0.0022170302067215,
	'delay', 0.002297970969047,
	\delay, ~pmodenv.(Pseq([
		0.000001,0.0002
	],inf), 1/1),
	'delay2', 0.00013111339374216 * Pseq([
		1,1/8,1,1/8, 8,1,1,
	],inf),
	'delay3', 0.00074808264552251 * Pseq([
		1,100,10,100,
	],inf),
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),

		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, 1,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1.0052997797722/8,
			'fb', 0.0022170302067215,
			'delay', 0.000002297970969047,
			'delay2', 0.0000023111339374216,
			'delay3', 0.0000074808264552251,
			'distamp', 3.3512751331888,
			'distamp2', 1.0195378685327,
			'distamp3', 2.2271768755705,
			'shift', 0.0,
			'shift2', 0.0,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'ilpf', 19900,
			'ihpf', 470,
			\ipfmix, 1,
			'stereo', 0.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			\epfmix, 1,
			\ehpf, 400,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
		),
	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.08], curve: \exp) ],
			\dur, 1/16,
			\isRest, Pseq([
				1,0, 0,0, 0,0, 0,0,
			],inf).coin.not,
			\amp, 0.1,
			\legato, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\fx1, \audio),
			\isRest, true,
		),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0, 0,0, 0,0, 0,0,
				0,0, 1,0, 0,0, 1,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\out, BusDef(\fx2, \audio),
		)),

		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, 1,
			'wet10', 1.0,
			'mix', 1.0,
			'gain', 1.0052997797722/8,
			'fb', 0.0000170302067215,
			'delay', 0.00000297970969047,
			'delay2', 0.0000013111339374216,
			'delay3', 0.0000074808264552251,
			'distamp', 0.3512751331888,
			'distamp2', 0.0195378685327,
			'distamp3', 0.2271768755705,
			'shift', 0.0,
			'shift2', 0.0,
			'shift3', -2.4789915966387,
			'shiftmix', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 17,
			'lpf', 17000,
			'hpf', 17,
			'stereo', 0.0,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.91176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
			'brfrqfac', 0.37940593233798,
			'brffac', 0.60195390291997,
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\fx2),
			\dur, 1,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8,
	'fb', 0.0022170302067215,
	'delay', 0.002297970969047,
	'delay2', 0.00013111339374216,
	'delay3', 0.00074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),

	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, 1,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8,
	'fb', 0.0022170302067215,
	'delay', 0.002297970969047,
	'delay2', 0.00013111339374216,
	'delay3', 0.30074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),



		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\hibus1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\hibus1, \audio),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\hibus1),
			\dur, 1,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8,
	'fb', 0.00022170302067215,
	'delay', 0.10002297970969047,
	'delay2', 0.000013111339374216,
	'delay3', 0.000074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'ilpf', 19900,
	'ihpf', 717,
	\ipfmix, 1,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),

	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, 1,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8,
	'fb', 0.0022170302067215,
	'delay', 0.002297970969047,
	'delay2', 0.00013111339374216,
	'delay3', 0.10074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),



		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,1,0,1,

			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\hibus1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\hibus1, \audio),
		),
		Pmono(
			 \cymbalsimple,
			\freq, 200,
			\dur, 1/8,
			\trig1, Pseq([
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			],inf),
			\trig2, Pkey(\trig1),
			\amp, 0.1,
			\out, BusDef(\hibus1, \audio),
		),
	Pbind(
		\instrument, \iron,
		\note, Pstep(Pseq([
			0,0,0,-1,
		],inf),1/2) + [0,3,7],
		\octave, 9,
		\hpf, 30,
		\env1, Pseq([
			[ Env([1,1.5,1],[0.1,0.8]) ]
		],inf),
		\diff, 1.1,
		\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
		\lpfr,2,
		\adsr, Pseq([
			[ Env.adsr(0.051,0.01,0.8,0.2) ],
			[ Env.adsr(0.051,0.01,0.8,0.1) ],
		],inf).stutter(2),
		\legato, Pseq([
			1,0,0,0, 
			0,0,0,0, 
			1,0,1,0, 
		],inf)/10,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/16,
		\panwidth, 0.2,
		\gain, 5,
		\amp,0.05,
			\out, BusDef(\hibus1, \audio),
	),
		Pmono(\feedmaster,
			\inbus, BusDef(\hibus1),
			\dur, 1,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8,
	'fb', 0.00022170302067215,
	'delay', 0.10002297970969047,
	'delay2', 0.000013111339374216,
	'delay3', 0.000074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'ilpf', 19900,
	'ihpf', 717,
	\ipfmix, 1,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),

	])
)).play;
)

	(
	SynthDef(\cymbalsimple, { | out = 0, pan = 0.0, amp=0.1 |
		var sig, env;
		env = EnvGen.ar(Env.perc(0.01, 2, curve: -4), doneAction: 2);
		sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), {exprand(1000, 20000)}.dup(100)).mean, 4000);
		sig = sig * amp;
		Out.ar(out, Pan2.ar(sig * env, pan));
	}).add;
	)

(
	// test hibus to rdn
	ProtoDef(\rdn).play;
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, 1,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8,
	'fb', 0.0022170302067215,
	'delay', 0.002297970969047,
	'delay2', 0.00013111339374216,
	'delay3', 0.10074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),



		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,1,0,1,

			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\hibus1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\hibus1, \audio),
		),
		Pbind(
			\instrument, \cymbalsimple,
			\freq, 200,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\hibus1, \audio),
		),
	Pbind(
		\instrument, \iron,
		\note, Pstep(Pseq([
			0,0,0,-1,
		],inf),1/2) + [0,3,7],
		\octave, 9,
		\hpf, 30,
		\env1, Pseq([
			[ Env([1,1.5,1],[0.1,0.8]) ]
		],inf),
		\diff, 1.1,
		\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
		\lpfr,2,
		\adsr, Pseq([
			[ Env.adsr(0.051,0.01,0.8,0.2) ],
			[ Env.adsr(0.051,0.01,0.8,0.1) ],
		],inf).stutter(2),
		\legato, Pseq([
			1,0,0,0, 
			0,0,0,0, 
			1,0,1,0, 
		],inf)/10,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/16,
		\panwidth, 0.2,
		\gain, 5,
		\amp,0.05,
			\out, BusDef(\hibus1, \audio),
	),

	])
)).play;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.055, 0.08], curve: \exp) ],
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
				0,0,1,1, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\instrument, \noisybass,
			\note, Pseq([
				0,0,-4,1,
			],inf),
			\lpfr, Pseq([
				7,5,1,2,
				7,5,1,2,
				7,5,4,2,
				7,5,1,2,
			],inf),
			\octave, 3,
			\legato, Pseq([
				4,0,0,0, 0,0,1,0,
				0,0,2,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\feedmaster,
			\inbus, BusDef(\fx1),
			\dur, 1,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1.0052997797722/8/3,
	'fb', 0.0022170302067215,
	'delay', 0.002297970969047,
	'delay2', 0.00013111339374216,
	'delay3', 0.10074808264552251,
	'distamp', 3.3512751331888,
	'distamp2', 1.0195378685327,
	'distamp3', 4.2271768755705,
	'shift', 0.0,
	'shift2', 0.0,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'stereo', 0.0,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
		),



		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,0,1,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,1,0,1,

			],inf).coin.not,
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/8,
			\out, BusDef(\hibus1, \audio),
		)),
		Pbind(
			\instrument, \phyhat3,
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\sustain, 0.05,
			\fac1,0.1,
			\dur, 1/8,
			\amp, 0.01 * Pseq([1,0.7],inf),
			\out, BusDef(\hibus1, \audio),
		),
		Pmono(
			 \cymbalsimple,
			\freq, 200,
			\dur, 1/8,
			\trig1, Pseq([
			1,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,0,0, 0,0,0,0,
			],inf),
			\trig2, Pkey(\trig1),
			\amp, 0.1,
			\out, BusDef(\hibus1, \audio),
		),
	Pbind(
		\instrument, \iron,
		\note, Pstep(Pseq([
			0,0,0,-1,
		],inf),1/2) + [0,3,7],
		\octave, 9,
		\hpf, 30,
		\env1, Pseq([
			[ Env([1,1.5,1],[0.1,0.8]) ]
		],inf),
		\diff, 1.1,
		\fmr, 1/4 * Pseq([1,0.1],inf).stutter(2),
		\lpfr,2,
		\adsr, Pseq([
			[ Env.adsr(0.051,0.01,0.8,0.2) ],
			[ Env.adsr(0.051,0.01,0.8,0.1) ],
		],inf).stutter(2),
		\legato, Pseq([
			1,0,0,0, 
			0,0,0,0, 
			1,0,1,0, 
		],inf)/10,
		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
		\dur, 1/16,
		\panwidth, 0.2,
		\gain, 5,
		\amp,0.05,
			\out, BusDef(\hibus1, \audio),
	),
	Pmono(\himaster,
		\inbus, BusDef(\hibus1),
		\dur, 1/8,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1/5/3/3,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.10221239391292 * Pseq([
		1,1,1,1,
		1,3,1/2,
		1/2,1/2,
	],inf).stutter(4),
	'delay3', 0.0001,
	'distamp', 3.5515682761809,
	'distamp2', 1.69909760632006,
	'distamp3', 1.1787686347936,
	'shift', -5.0,
	'shift2', -1.1344537815126,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 222.45823289167,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.11080171195222,
	'brffac', 0.1,
	'stereo', 0.0,
	\modgain, Pseq([
		1,1,1,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
	],inf),
	),
	Pmono(\himaster,
		\inbus, BusDef(\hibus1),
		\dur, 1/8,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1/5/2/3,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.00221239391292,
	'delay3', 0.0001,
	'distamp', 3.5515682761809,
	'distamp2', 0.69909760632006,
	'distamp3', 1.1787686347936,
	'shift', -5.0,
	'shift2', -1.1344537815126,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 222.45823289167,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.11080171195222,
	'brffac', 0.1,
	'stereo', 0.0,
	\modgain, Pseq([
		0,0,0,1, 0,0,0,0,
		0,1,0, 0,1,1,0,1,
	],inf),
	),
	Pmono(\himaster,
		\inbus, BusDef(\hibus1),
		\dur, 1/8,
		'wet10', 1.0,
		'mix', 1.0,
		'gain', 1/3.1,
		'fb', 0.0001,
		'delay', 0.400001,
		'delay2', 0.0800001239391292,
		'delay3', 0.000001,
		'distamp', 8.5515682761809,
		'distamp2', 1.69909760632006,
		'distamp3', 4.1787686347936,
		'shift', -5.0,
		'shift2', -1.1344537815126,
		'shift3', -2.4789915966387,
		'shiftmix', 0.0,
		'pitchlag', 1.0,
		'pitchmix', 0.0,
		'lpf', 8990,
		'hpf', 17,
		\pfmix, 1,
		'lpf', 20000.0,
		'hpf', 222.45823289167,
		'fbdistamp', 4.47619047619048,
		'fbdistmix', 0.91176470588235,
		'postlpf', 20000.0,
		'posthpf', 17,
		'wetamp', 0.18504562572587,
		'indelay', 0.04,
		'wet20', 1.0,
		'mamp', 1,
		'brfrqfac', 0.11080171195222,
		'brffac', 0.1,
		'stereo', 0.0,
		\modgain, Pseq([
			0,0,0,0, 0,0,1,1,
		],inf),
	),

	PmonoArtic(\tredrone,
		\legato, 1,
		\cus3, { rrand(0.01,10) }.dup(3),
		\fma, 0.01,
		\cus2, [1,2,3]*10,
		\cusfreq, [1,2,3]/3,
		\lpfr, 2,
		\lagf, Pseq([1,0,0,1]/2,inf).stutter(8),
		\octave, 6,
		\degree, Pseq([
			[0,2,4],
			[0,2,4]+2,
			[0,2,4],
			[0,2,4]+2-12,
			[0,2,4],
			[0,2,4]+2,
			[0,2,4],
			[-20,-20,-20],
		],inf).stutter(8),
		\dur, 1,
		\amp, 0.4,
		\out, BusDef(\napbus1, \audio),
	),
	Pmono( \rdncleandist_fulllight,
		\inbus, BusDef(\napbus1, \audio, 2),
		\addAction, \addToTail,
		'mix', 0.45714285714286,
		'gain', 0.7344889782792/2,
		'fb', 0.0012099467303085,
		'delay', 0.100600001231 * Pseq([
			1,
		],inf).stutter(1),
		'delay2', 0.810000543560101,
		'distamp', 11.361836201538,
		'distamp', ~pmodenv.(Pwhite(1.0,14,inf), Pwhite(1.0,4,inf)),
		'prelpf', 19900,
		'prehpf', 17,
		'lpf', 19900,
		'hpf', 17,
		'fbdistamp', 4.5388371966577,
		'fbdistmix', 0.98176470588235,
		'postlpf', 19900,
		'posthpf', ~pmodenv.(Pwhite(100,10000.0,inf), Pwhite(100,10000.0,inf)),
		\bpmix, 0,
		'wetamp', 0.20503372119697,
		'indelay', 0.04,
		\dur, 1,
	),

	])
)).play;
)


(
Pdef(\part, Pdef(\zed, 
	Ppar([
	Pmono(\himaster,
		\inbus, BusDef(\hibus1),
		\dur, 1/8,
	'wet10', 1.0,
	'mix', 1.0,
	'gain', 1/5/3,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.10221239391292 * Pseq([
		1,1,1,1,
		1,3,1/2,
		1/2,1/2,
	],inf).stutter(4),
	'delay3', 0.0001,
	'distamp', 3.5515682761809,
	'distamp2', 1.69909760632006,
	'distamp3', 1.1787686347936,
	'shift', -5.0,
	'shift2', -1.1344537815126,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 20000.0,
	'hpf', 222.45823289167,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 20000.0,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'brfrqfac', 0.11080171195222,
	'brffac', 0.1,
	'stereo', 0.0,
	\modgain, Pseq([
		1,1,1,0, 1,1,0,0,
		0,0,0,0, 0,0,0,0,
	],inf),
	),
	])
)).play;
)
