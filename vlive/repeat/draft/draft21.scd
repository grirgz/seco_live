~t = 96/2/60; TempoClock.default.tempo = ~t; // funky drummer bpm
(
SynthDef(\stickfight, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fac1=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8410*fac1,100,1451],[0.1,0.2]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	//env2 = EnvGen.kr(Env([18210,2100,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([110,12100,451],[0.1,0.2],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = HPF.ar(sig, env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)
(
SynthDef(\snaretuned, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(4810) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,845],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq

	// tonal component
	sig2 = SinOsc.ar([180, 330]*1.2).sum;
	sig3 = LFTri.ar(111);
	sig3 = FreqShift.ar(sig3, [175, 224]*1.3).sum;
	sig4 = sig2 + sig3 / 48;

	sig = sig + sig4 / 1.2;
	sig = HPF.ar(sig, env2);


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\snarebpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([2261, 310, 210], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	//sig1 = CombL.ar(sig, 0.1,1/popFreq/[2.2,3.1],1/2)/4;
	sig1 = FreqShift.ar(sig, [200,400]);
	sig1 = Ringz.ar(sig1, popFreq*[2,3,4,8], 0.4, mul:0.03 * [2,3,2,1]).mean + sig / 2;
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), 11300);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq
	sig = HPF.ar(sig, env2);
	sig2 = SinOsc.ar([180, 330]).sum;
	sig3 = LFTri.ar(111);
	sig3 = FreqShift.ar(sig3, [175, 224]).sum;
	sig4 = sig2 + sig3 / 18;
	//sig = sig + sig4 / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
)

(
Pdef(\drumz, 
	Ppar([
		Pbind(
			\instrument, \sossnare,
			\instrument, \snarebpf,
			\freq, 200,
			\sustain, 0.1/2,
			\dur, 1,
			\amp, 0.1
		);
		
	])
).play;
)

(
SynthDef(\sossnare, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.4,-6),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\snapkick, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(Env([261, 80, 61], [0.035, 0.08], curve: \exp));
	bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(750, 261, 0.02);
	popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

	snd = body + pop + click;
	snd = snd.tanh;

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

(
Pdef(\funkydrummer, 
	Ppar([
		Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaretuned,
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snaretuned,
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \phycymbal,
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	])
).play;
)


(
SynthDef(\rez, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var pop;
	pop = SinOsc.ar(EnvGen.kr(Env([2100,73,30],[0.01,0.08]), 1)) * EnvGen.kr(Env([0,1,0],[0.01,0.01]), 1); 
	pop = WhiteNoise.ar * EnvGen.kr(Env([0,1,0],[0.001,0.01]), 1);
	pop = LPF.ar(pop, 10000);
	sig = pop + SinOsc.ar(freq);
	sig1 = WhiteNoise.ar;
	sig1 = HPF.ar(sig1, 7000 * EnvGen.kr(Env([1,1.2,1/2,1/2,1],[0.01,0.01,0.1,1],-3), 1));
	sig = pop + sig1;

	//sig = HPF.ar(sig, EnvGen.kr(Env([1100,2000,3001],[1.7,0.8]), 1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4, 1,-3),gate,doneAction:2);
	sig = HPF.ar(sig, 1000);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	Pdef(\drumy, 
		Ppar([
			Pbind(
				\instrument, \rez,
				\freq, Pseq([600],inf),
				\sustain, 0.1,
				\dur, 1/2,
				\amp, 0.1
			)
		])
	).play;
)


ProtoDef(\rdn).edit
ProtoDef(\rdn).presetCompileString.editorInsert
(
RandDelayNetwork('deldefault').make('rdn', "4-PK2H-ORTJ");
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.5,
	'gain', 0.81015160133764,
	'fb', 0.0001,
	'delay', 0.00013111339374216,
	'delay2', 0.00015306431405564,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.21582339958846,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 82.923391195936,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.18504562572587,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

ProtoDef(\rdn).loadDefaultPreset
Pdef(\funkydrummer).set(\out, BusDef(\sendbus0, \audio))
Pdef(\funkydrummer)

ProtoDef(\rdn).proxy.end
RandDelayNetwork.codeToSeeds(RandDelayNetwork(\deldefault).code)
	~rdn_to_fbstring.(RandDelayNetwork(\deldefault)).editorInsert;
	(

		SynthDef(\drumfx, { arg out=0, gate=1;
			var sig;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 815027;

			thisThread.randSeed = 701027;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
				si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
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
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = (si * 10.rand * \distamp.kr).tanh / 2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = (si * 10.rand * \distamp.kr).tanh / 2;
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = [
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);
							,
							{ arg si, env;
								si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
							}.value(si, env);

						].mean;
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = BRF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
					}.value(si, env);
					,
					{ arg si, env;
						si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
						si = [
							{ arg si, env;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
							}.value(si, env);
							,
							{ arg si, env;
								si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
							}.value(si, env);

						].mean;
					}.value(si, env);

				].mean;
			}.value(si, env);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

	);

~t = 126/60; TempoClock.default.tempo = ~t; // test fast tempo
~t = 93/60; TempoClock.default.tempo = ~t; // test normal tempo
(
Pdef(\fxpatdrummer, 
	Ppar([
		Pmono(\drumfx,
			\inbus, BusDef(\fx1, \audio),
			\dur, 1/4,
			'wet10', 1.0,
			'mix', 0.4,
			\eqdb2b, 8,
			\eqdb2a, 8,
			'gain', 0.41015160133764,
			'fb', Pseq([
				0,0,0,0.0001,
				0,0,0,0.00001,
				0,0.08,0,0.00001,
				0,0,0,0.00001,
			],inf),
			'delay2', 0.00013111339374216,
			'delay', Pseq([
				Pser([
					0,0,0,0.008,
					0,0,0.00001,0.00008,
					0,0,0,0.008,
					0,0,0,0.8,
				],8*4),

				Pser([
					0,0,0,0.6,
					0.001,0,0,0.008,
					0,0.009,0.40001,0.00008,
					0,0,0,0.08,
				],8*4),
			],inf) + 0.000001,
			'delay2', Pseq([
				Pseq([
					0.00010306431405564,
					0.00000306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00010306431405564,
					0.00100306431405564,
					0.0001010306431405564,
				],2),
				Pseq([
					0.00000306431405564,
					0.00110306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00100306431405564,
					0.00010306431405564,
					0.0001010306431405564,
				],2),
			],inf),
			'distamp', Pseq([
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,10.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,

				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				100,0.1,1,1,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 92.923391195936,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.41176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \snapkick,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaretuned,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snaretuned,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \stickfight,
			\out, BusDef(\fx1, \audio),
			\fac1, Pseq([1,0.8]*1.1,inf),
			\sustain, Pseq([0.1,0.05],inf),
			\isRest, Pseq([
				Pseq({[
					1,0,1,1, 1,1,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,1, 1,0,1,0, 
					1,0,0,0, 1,0,0,0,
					1,1,0,1, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf)
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8 * (1 + (0.01 * Pseq([-1,1],inf))),
			\amp, 0.1 * Pseq([1,0.4],inf) * 0.3 * Pseq([
				1
			],inf),
		),
		Pbind(
			\instrument, \phycymbal,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	].collect({ arg x; Pbind(\dur, Pkey(\dur)*2) <> x }))
).play;
)

(
Pdef(\fxpatdrummer, 
	Ppar([
		Pmono(\drumfx,
			\inbus, BusDef(\fx1, \audio),
			\dur, 1/4,
			'wet10', 1.0,
			'mix', 0.4,
			\eqdb2b, 8,
			\eqdb2a, 8,
			'gain', 0.41015160133764,
			'fb', Pseq([
				0,0,0,0.0001,
				0,0,0,0.00001,
				0,0.08,0,0.00001,
				0,0,0,0.00001,
			],inf),
			'delay2', 0.00013111339374216,
			'delay', Pseq([
				Pser([
					0,0,0,0.008,
					0,0,0.00001,0.00008,
					0,0,0,0.008,
					0,0,0,0.8,
				],8*4),

				Pser([
					0,0,0,0.6,
					0.001,0,0,0.008,
					0,0.009,0.40001,0.00008,
					0,0,0,0.08,
				],8*4),
			],inf) + 0.000001,
			'delay2', Pseq([
				Pseq([
					0.00010306431405564,
					0.00000306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00010306431405564,
					0.00100306431405564,
					0.0001010306431405564,
				],2),
				Pseq([
					0.00000306431405564,
					0.00110306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00100306431405564,
					0.00010306431405564,
					0.0001010306431405564,
				],2),
			],inf),
			'distamp', Pseq([
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,10.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,

				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				100,0.1,1,1,
			],inf),
			\distamp, Pseq([
				Pser([
					1,100,0.1,10,
				],8*3),
				Pser([
					100,
				],8*1),
			],inf),
			\delay, 0.0000000001,
			\delay2, Pseq([
				Pser([
					0.000001,
				],8*3),
				Pser([
					0.000010001,
					0.000123000001,
				],8*1),
			],inf),
			\fb, 
			Pseq([
				Pser([
					0.00001,
				],8*3),
				Pser([
					0.001,
				],8*1),
				
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 92.923391195936,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.41176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \snapkick,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaretuned,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snaretuned,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \stickfight,
			\out, BusDef(\fx1, \audio),
			\fac1, Pseq([1,0.8]*1.1,inf),
			\sustain, Pseq([0.1,0.05],inf),
			\isRest, Pseq([
				Pseq({[
					1,0,1,1, 1,1,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,1, 1,0,1,0, 
					1,0,0,0, 1,0,0,0,
					1,1,0,1, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf)
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8 * (1 + (0.01 * Pseq([-1,1],inf))),
			\amp, 0.1 * Pseq([1,0.4],inf) * 0.3 * Pseq([
				1
			],inf),
		),
		Pbind(
			\instrument, \phycymbal,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	].collect({ arg x; Pbind(\dur, Pkey(\dur)*2) <> x }))
).play;
)

ProtoDef(\rdn).loadDefaultPreset
ProtoDef(\rdn).edit
Pdef(\fxpatdrummer).set(\out, BusDef(\sendbus0, \audio))
Pdef(\fxpatdrummer).set(\out, nil);

	~rdn_to_fbstring.(RandDelayNetwork(\deldefault)).editorInsert;
	(

		SynthDef(\rdnreverb, { arg out=0, gate=1;
			var sig;
			var si, env = ();
			var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 

			thisThread.randSeed = 895034;

			sig = LocalIn.ar(2) * \fb.kr(0.1) + in;
			si = sig;
			sig = { arg si, env;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
				si = [
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
						si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
					}.value(si, env);
					,
					{ arg si, env;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
						si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay2.kr) + si;
					}.value(si, env);

				].mean;
				si = FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift2.kr) + si / 1.2;
				si = BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
				si = DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * SinOsc.kr(0.5.rand).range(1,1.1) * \delay2.kr) + si;
			}.value(si, env);

			sig = Limiter.ar(sig);
			LocalOut.ar(sig);

			sig = MidEQ.ar(sig, \eqmid1b.kr(12000), \eqrq1b.kr(1), \eqdb1b.kr(0));
			sig = MidEQ.ar(sig, \eqmid2b.kr(7000), \eqrq2b.kr(1), \eqdb2b.kr(0));
			//sig = HPF.ar(sig, \ehpf.kr(140), \ehprq.kr(1));
			//sig = LPF.ar(sig, \elpf.kr(10000), \elprq.kr(1));
			sig = SelectX.ar(\mix.kr(0.5), [DelayC.ar(in,0.04,0.04), sig]);
			sig = Splay.ar(sig, \spread.kr(1), 1, \pan.kr(0));
			sig = sig * \gain.kr(1);
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
			Out.ar(out, sig);

		}).add;

	);


~t = 96/2/60; TempoClock.default.tempo = ~t;
(
Pdef(\fxpatdrummer, 
	Ppar([
		Pmono(\rdnreverb,
			\inbus, BusDef(\fx1, \audio),
			\dur, 1/4,
			'wet10', 1.0,
			'mix', 0.4,
			//\eqdb2b, 8,
			//\eqdb2a, 8,
			'gain', 0.41015160133764,
			'fb', Pseq([
				0,0,0,0.0001,
				0,0,0,0.00001,
				0,0.08,0,0.00001,
				0,0,0,0.00001,
			],inf),
			'delay2', 0.00013111339374216,
			'delay', Pseq([
				Pser([
					0,0,0,0.008,
					0,0,0.00001,0.00008,
					0,0,0,0.008,
					0,0,0,0.8,
				],8*4),

				Pser([
					0,0,0,0.6,
					0.001,0,0,0.008,
					0,0.009,0.40001,0.00008,
					0,0,0,0.08,
				],8*4),
			],inf) + 0.000001,
			'delay2', Pseq([
				Pseq([
					0.00010306431405564,
					0.00000306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00010306431405564,
					0.00100306431405564,
					0.0001010306431405564,
				],2),
				Pseq([
					0.00000306431405564,
					0.00110306431405564,
					0.00000306431405564,
					0.0000010306431405564,
				],6),
				Pseq([
					0.00000006431405564,
					0.00100306431405564,
					0.00010306431405564,
					0.0001010306431405564,
				],2),
			],inf),
			'distamp', Pseq([
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,10.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,

				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				0.1,0.1, 0.1,0.1,
				100,0.1,1,1,
			],inf),
			'shift', 0.0,
			'shift2', 0.0,
			'pitchlag', 1.0,
			'pitchmix', 0.0,
			'prelpf', 17000,
			'prehpf', 92.923391195936,
			'lpf', 17000,
			'hpf', 17,
			'fbdistamp', 0.47619047619048,
			'fbdistmix', 0.41176470588235,
			'postlpf', 17000,
			'posthpf', 17,
			'wetamp', 0.18504562572587,
			'indelay', 0.04,
			'wet20', 1.0,
			'mamp', 1,
		),
		Pbind(
			\instrument, \snapkick,
			\out, BusDef(\fx1, \audio),
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.1/2,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaretuned,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1/2,
			\adsr, Pseq([
				 [ Env.adsr(0.1/3,0.1,0.8,0.2,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \snaretuned,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.04,
			\adsr, Pseq([
				 [ Env.adsr(0.1/2,0.1,0.8,0.1,1,-6) ]
			],inf),
			\isRest, Pseq([
				0,0,0,0, 0,0,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\pan, 0.1/2,
			\amp, 0.1/3,
		),
		Pbind(
			\instrument, \stickfight,
			\out, BusDef(\fx1, \audio),
			\fac1, Pseq([1,0.8]*1.1,inf),
			\sustain, Pseq([0.1,0.05],inf),
			\isRest, Pseq([
				Pseq({[
					1,0,1,1, 1,1,1,0,
					1,0,1,0, 1,0,1,0, 
					1,0,1,1, 1,0,1,0, 
					1,0,0,0, 1,0,0,0,
					1,1,0,1, 0,0,0,0,
					0,0,0,0, 1,1,1,1,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 0,0,0,0,
				].clump(8).choose}.dup(8).flat,inf)
			],inf).coin.not,
			\isRest, Pseq([
				0,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8 * (1 + (0.01 * Pseq([-1,1],inf))),
			\amp, 0.1 * Pseq([1,0.4],inf) * 0.3 * Pseq([
				1
			],inf),
		),
		Pbind(
			\instrument, \phycymbal,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1/3,
			\adsr, Pseq([
				 [ Env.adsr(0.001,0.1,1.8,0.07,1,-3) ],
				 [ Env.adsr(0.002,0.1,0.8,0.04,1,-3) ],
			],inf).stutter(2),
			\pan, -0.1,
			\isRest, Pseq([
				1,1,1,1, 
			],inf).coin.not,
			\rel, Pseq([
				1,1,1,1, 1,1,8,1,
			],inf)*0.1,
			\dur, 1/8,
			\sustain, Pseq([
				0.05, 0.02, 0.05, 0.02,
				0.05, 0.02, 1/6/~t, 0.02,
			],inf)/2,
			\amp, 0.1/2,
			\amp, Pkey(\amp) * Pseq([
				1, 0.7, 0.9, 0.5,
				Plazy({ Pseq([
					1, 0.7, 0.9, 0.5,
				].scramble,1) }),
			],inf),
		),

		
	])
).play;
)
