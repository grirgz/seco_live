~t = 1; TempoClock.default.tempo = ~t;
(
Spec.add(\midside, \unipolar);
Spec.add(\det, \unipolar);
Spec.add(\spread, \unipolar);
Spec.add(\lpadsr, ParamEnvSpec.adsr);
SynthDef(\sh101, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq, vcfmod;
	freq = freq * ( \vcomod.kr(0) + 1 );
	sig = LFPulse.ar(freq,0,\pwidth.kr(0.5)) * \pulse.kr(0.5);
	sig = sig + (LFSaw.ar(freq) * \saw.kr(0.5));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.8)), gate, doneAction:0) * \envamt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	//sig = RLPF.ar(sig, ( \lpf.kr(130) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	vcfmod = \vcfmod.kr(0) + 1;
	sig = MoogFF.ar(sig, ( \lpf.kr(930) * lpenv * lpfreq * vcfmod ).clip(20,20000), 1/\rq.kr(0.8)) * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\sh101mod, { arg vcfout=0, vcoout=0, gate=1, freq=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.kr(freq);
	sig2 = LFTri.kr(freq);
	sig3 = LFSaw.kr(freq);
	sig4 = LFPulse.kr(freq);
	sig5 = LFNoise1.kr(freq);
	sig = SelectX.kr(\oscmix.kr(0)*4, [sig1, sig2, sig3, sig4, sig5]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.kr(vcoout, sig * \vco.kr(0));
	Out.kr(vcfout, sig * \vcf.kr(0));
}).add;

SynthDef(\sh101fx, { arg out=0, gate=1, crusher=0, reverb=0, delay=0;
	var sig, sig2;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = Decimator.ar(sig, crusher.linexp(0,1,Server.default.sampleRate,100), crusher.linlin(0,1,24,2));
	sig = SelectX.ar(crusher, [in, sig]);
	sig = FreeVerb2.ar(sig[0],sig[1], reverb.linlin(0,1,0,0.5), reverb.linlin(0,1,0.2,1), \damp.kr(0.1));
	//sig = DelayL.ar(sig, 1.0,\delay.kr(0.1),1) * \delayamp.kr(0) + sig;
	sig = CombL.ar(sig, 1, \delaytime.kr(0.1).lag(0.4), delay.lincurve(0,1,0,4,-2)) * delay + sig;
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}, metadata:(specs:(
	crusher: \unipolar,
	reverb: \unipolar,
	delay: \unipolar,
	delaytime: ControlSpec(0.001,1,\exp),
))).add;
);


/////// warm sustained bassline

(
Pdef(\warmbass, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0,3,2,-2],inf),
		\lpadsr, Pseq([
			[ Env.adsr(0.01,0.4,1.3,0.8) ],
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.01,1.0,0.9) ],
		],inf),
		\kbamt, 0,
		\lpf, 330,
		\rq, 0.7,
		\envamt, 1,
		\legato, 0.6,
		\octave, 3,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

/////// resonant 303 acid bassline

(
Pdef(\acidbass, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0,3,2,-2],inf),
		\lpadsr, Pseq([
			[ Env.adsr(0.01,0.1,1.2,0.1) ],
		],inf),
		\adsr, Pseq([
			[ Env.adsr(0.01,0.01,1,0.01) ],
		],inf),
		\kbamt, 0,
		//\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
		\lpf, Pseg(Pseq([150,600],1), 8).loop,
		\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
		\rq, 0.4,
		\envamt, 2,
		\octave, 4,
		\dur, 1/8,
		\amp, 0.06,
	)
).play;
);

/////// plucky lead sound

(
Pdef(\pluckylead, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\degree, Pseq([9,7,9,7,5,4],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.01,0.2,0.2,0.3) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.01,1,0.5) ],
			],inf),
			\kbamt, 0,
			\lpf, 700,
			\rq, 0.6,
			\envamt, 2,
			\octave, 5,
			\dur, 1/2,
			\amp, 0.03,
			\out, BusDef(\sh101fx, \audio),
		),
		Pmono(\sh101fx,
			\inbus, BusDef(\sh101fx, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\reverb, 0.8,
			\delay, 0.6,
			\delaytime, 0.14,
			\dur, 1,
		),
	]),
).play;
);

/////// long atmospheric drone

(
Pdef(\atmodrone, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\degree, Pseq([0],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.3,1.2,1.2,0.3) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(1,0.01,1,1.5) ],
			],inf),
			\vcfmod, BusDef(\vcf_2, \control).asMap,
			\vcomod, BusDef(\vco_2, \control).asMap,
			\kbamt, 0,
			\lpf, 400,
			\rq, 0.4,
			\envamt, 1,
			\octave, 3,
			\legato, 1.2,
			\dur, 4,
			\amp, 0.04,
			\out, BusDef(\sh101fx_2, \audio),
		),
		Pmono(\sh101mod,
			\freq, 0.2,
			\vcf, 0.5,
			\vca, 0.2,
			\vcoout, BusDef(\vco_2, \control),
			\vcfout, BusDef(\vcf_2, \control),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\sh101fx,
			\inbus, BusDef(\sh101fx_2, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\reverb, 0.8,
			\damp, 0.9,
			\crusher, 0.5,
			\delay, 0.7,
			\delaytime, 0.8,
			\dur, 1,
		),
	]),
).play;
);

/////// supersaw

(
SynthDef(\supersaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq, vcfmod;
	freq = freq * ( \vcomod.kr(0) + 1 );
	// rand phase is important
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2!8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0), amp, pan);
	sig = RLPF.ar(sig, ( \lpf.kr(10.1)  ).clip(20,20000), \rq.kr(0.5));
	Out.ar(out, sig);
}).add;
)

(
Pdef(\supersaw, 
	Pbind(
		\instrument, \supersaw,
		\degree, Pseq([
			[ 0,4,7 ],
			[ 0,4,7 ]+2,
		],inf),
		\octave, 4,
		\lpf, PmodEnv(Pseq([200,8000],1), 8).loop,
		\spread, PmodEnv(Pwhite(0.0,1,10), 4).loop,
		\dur, 2,
		\amp, 0.1,
	)
).play;
);

Pdef(\supersaw).edit
Pdef(\supersaw).envir.clear


///
(
SynthDef(\rolandsupersaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, det=0.75, midside=0;
	var detuneCurve = { |x|
		(10028.7312891634*x.pow(11)) -
		(50818.8652045924*x.pow(10)) +
		(111363.4808729368*x.pow(9)) -
		(138150.6761080548*x.pow(8)) +
		(106649.6679158292*x.pow(7)) -
		(53046.9642751875*x.pow(6)) +
		(17019.9518580080*x.pow(5)) -
		(3425.0836591318*x.pow(4)) +
		(404.2703938388*x.pow(3)) -
		(24.1878824391*x.pow(2)) +
		(0.6717417634*x) +
		0.0030115596
	};
	var mix = midside;
	var detune = det;
	var centerGain = { |x| (-0.55366 * x) + 0.99785 };
	var sideGain = { |x| (-0.73764 * x.pow(2)) + (1.2841 * x) + 0.044372 };

	var center = LFSaw.ar(freq, Rand());
	var detuneFactor = freq * detuneCurve.(detune);
	var freqs = [
		(freq - (detuneFactor * 0.11002313)),
		(freq - (detuneFactor * 0.06288439)),
		(freq - (detuneFactor * 0.01952356)),
		// (freq + (detuneFactor * 0)),
		(freq + (detuneFactor * 0.01991221)),
		(freq + (detuneFactor * 0.06216538)),
		(freq + (detuneFactor * 0.10745242))
	];
	var side = Mix.fill(6, { |n|
		LFSaw.ar(freqs[n], Rand(0, 2))
	});

	var sig = (center * centerGain.(mix)) + (side * sideGain.(mix));

	sig = LPF.ar(sig, \lpf.kr(100));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
Pdef(\supersaw, 
	Pbind(
		\instrument, \rolandsupersaw,
		\degree, Pseq([
			[ 0,4,7 ],
			[ 0,4,7 ]+2,
		],inf),
		\midside, 0.51,
		\midside, PmodEnv(Pseq([0,1],1), 16).loop,
		\adsr, Pseq([
			[ Env.adsr(0.4,0.1,0.8,1.1) ],
		],inf),
		\octave, 4,
		\lpf, 5400,
		\det, PmodEnv(Pseq([0,0.81],1), 8).loop,
		\dur, 2,
		\amp, 0.1,
	)
).play;
);

////// reese bass

(
SynthDef(\reese, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	freq = freq.lag(0.08);
	sig = LFSaw.ar(freq * ((0..5)/5 - 0.5 * \fspread.kr(0.024) + 1), 0, Rand(0,2!6));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000).poll, \rq.kr(0.8));
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\reese).reset;
);

(
Pdef(\reese, 
	Pmono(
		 \reese,
		\degree, Pseq([0,-2],inf),
		//\lpadsramt, 2,
		\itrig, 1,
		//\lpf, 800,
		//\rq, 0.8,
		\octave, 3,
		\dur, 2,
		//\amp, 0.1,
	)
).play;
);

Pdef(\reese).edit
notch
Spec.add(\fspread, ControlSpec(0.001,1,\exp))
Pdef(\reese).envir.clear


//////////////////////////////// draft
///////////////:
(
SynthDef(\warmbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	sig = LFSaw.ar(freq);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.8,0.4,0.8)), gate, doneAction:0) * \envamt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(1);
	sig = RLPF.ar(sig, ( \lpf.kr(50) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \warmbass,
		\degree, Pseq([0,3,2,-2],inf),
		\octave, 3,
		\dur, 1,
		\amp, 0.1,
	)
).play;
);

(
Pdef(\atmodrone, 
	Ppar([
		Pbind(
			\instrument, \sh101,
			\degree, Pseq([0,1,-1],inf),
			\lpadsr, Pseq([
				[ Env.adsr(0.3,1.2,1.2,0.3) ],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(1,0.01,1,1.5) ],
			],inf),
			\vcfmod, BusDef(\vcf, \control).asMap,
			\vcomod, BusDef(\vco, \control).asMap,
			\kbamt, 0,
			\lpf, 300,
			\rq, 0.6,
			\envamt, 1,
			\octave, 3,
			\dur, 2,
			\amp, 0.07,
			\out, BusDef(\sh101fx, \audio),
		),
		Pmono(\sh101mod,
			\freq, 2,
			\vcf, 2,
			\vcoout, BusDef(\vco, \control),
			\vcfout, BusDef(\vcf, \control),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\sh101fx,
			\inbus, BusDef(\sh101fx, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\reverb, 0,
			\delay, 0,
			\delaytime, 0.14,
			\dur, 1,
		),
	]),
).play;
);


(
Pdef(\acidbass, 
	Pbind(
		\instrument, \sh101,
		\degree, Pseq([0,3,2,-2],inf),
		\lpadsr, Pseq([
			PpatEnv.adsr(0.01,Pbrown(0.01,1,0.001),1.2,Pbrown(0.01,1,0.001))
		],inf),
		\adsr, Pseq([
			PpatEnv.adsr(Pbrown(0.01,0.1,0.0001),Pbrown(0.01,1,0.001),1,Pbrown(0.01,0.3,0.001))
		],inf),
		//\kbamt, PmodEnv(Pseq([0.01,0.1],4), 8).loop,
		//\lpf, PmodEnv(Pseq([150,400],1), 8).loop,
		//\lpf, Pseg(Pseq([150,600],1), 8).loop,
		\lpf, PmodEnv(( Pser([150,400,Pwhite(100.0,1000,6)],16) * Pseg(Pseq([0.2,4],1),8).loop ), 1/2).loop,
		\rq, PmodEnv(Pser([0.31,0.47],9), Pwhite(0.1,8)).loop,
		//\envamt, PmodEnv(Pseq([2,1,4],1), 8).loop,
		\octave, 4,
		\dur, 1/8,
		\amp, 0.06,
	)
).play;
);

(
Library.put(\synthlib, \rolandsupersaw, { arg freq=200, det=0.75, midside=0.5;
	var detuneCurve = { |x|
		(10028.7312891634*x.pow(11)) -
		(50818.8652045924*x.pow(10)) +
		(111363.4808729368*x.pow(9)) -
		(138150.6761080548*x.pow(8)) +
		(106649.6679158292*x.pow(7)) -
		(53046.9642751875*x.pow(6)) +
		(17019.9518580080*x.pow(5)) -
		(3425.0836591318*x.pow(4)) +
		(404.2703938388*x.pow(3)) -
		(24.1878824391*x.pow(2)) +
		(0.6717417634*x) +
		0.0030115596
	};
	var mix = midside;
	var detune = det;
	var centerGain = { |x| (-0.55366 * x) + 0.99785 };
	var sideGain = { |x| (-0.73764 * x.pow(2)) + (1.2841 * x) + 0.044372 };

	var center = LFSaw.ar(freq, Rand());
	var detuneFactor = freq * detuneCurve.(detune);
	var freqs = [
		(freq - (detuneFactor * 0.11002313)),
		(freq - (detuneFactor * 0.06288439)),
		(freq - (detuneFactor * 0.01952356)),
		// (freq + (detuneFactor * 0)),
		(freq + (detuneFactor * 0.01991221)),
		(freq + (detuneFactor * 0.06216538)),
		(freq + (detuneFactor * 0.10745242))
	];
	var side = Mix.fill(6, { |n|
		LFSaw.ar(freqs[n], Rand(0, 2))
	});

	var sig = (center * centerGain.(mix)) + (side * sideGain.(mix));
	sig;
});
	 
)
Library.at(\synthlib, \rolandsupersaw)
Library.put(\synthlib, nil)
(
SynthDef(\reese, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	freq = freq.lag(0.08,);
	//sig = LFSaw.ar(freq * ((0..5)/5 - 0.5 * \fspread.kr(0.024) + 1), 0, Rand(0,2!6));
	sig = Library.at(\synthlib, \rolandsupersaw).(freq, \det.kr(0.01), \midside.kr(0.71));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	//sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000).poll, \rq.kr(0.8));
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
Pdef(\reese).reset;
);

(
Pdef(\reese, 
	Pmono(
		 \reese,
		\degree, Pseq([0,-2],inf),
		//\lpadsramt, 2,
		\itrig, 1,
		//\lpf, 800,
		//\rq, 0.8,
		\octave, 3,
		\dur, 2,
		//\amp, 0.1,
	)
).play;
);

Pdef(\reese).edit
Pdef(\reese).asParamGroup.getPbindCompileString.editorInsert

ParamGroup

(
SynthDef(\reese, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	freq = freq.lag(0.08,);
	sig = LFSaw.ar(freq * LFNoise1.kr(0.31!3,mul:\det.kr(0.1),add:1));
	sig = sig + SinOsc.ar(freq/2); 
	//sig = Library.at(\synthlib, \rolandsupersaw).(freq, \det.kr(0.01), \midside.kr(0.71));
	
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	//sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000).poll, \rq.kr(0.8));
	//sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	//sig = sig.tanh;
	sig = MoogFF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), 1/\rq.kr(0.8));
	sig = BPeakEQ.ar(sig, \peakf.kr(200), \peakrq.kr(1), \peakboost.kr(-1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}, metadata:(specs:(
	peakboost: ControlSpec(-30,30,\lin, 0, 0, "db")
))).add;
Pdef(\reese).reset;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \reese,
		\degree, Pseq([0,2,4,-1],inf),
		\dur, 1,
		\amp, 0.1/2,
		'det', 0.010650406504065,
		'lpadsr', [ Env([ 0.0, 1.0, 0.70000000149012, 0.0 ], [ 0.99999997764826, 0.40000000596046, 0.80000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
		'lpadsramt', 2.0299079577523,
		'kbamt', 0.051,
		'distamp', 0.91920977520277,
		'distpostamp', 0.93261116187045,
		'lpf', 36.068456413524,
		'rq', 0.6024824032852,
		'peakf', 980.7062015945,
		'peakrq', 0.815764317177,
		'peakboost', 10.975609756098,
		'adsr', [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.50000000149012, 0.10000000149012, 0.80149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))

(
Pdef(\zed, 
	Pbind(
		\instrument, \reese,
		\degree, Pseq([0,2,4,-1],inf),
		\dur, 1,
		\amp, 0.1,
		'det', 0.040650406504065,
		'lpadsr', [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.0099999997764826, 0.40000000596046, 0.20000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
		'lpadsramt', 1.0299079577523,
		'kbamt', 0.1,
		'distamp', 0.91920977520277,
		'distpostamp', 0.93261116187045,
		'lpf', 36.068456413524,
		'rq', 0.26024824032852,
		'peakf', 2040.7062015945,
		'peakrq', 0.12815764317177,
		'peakboost', 10.975609756098,
		'adsr', [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
	)
).play;
);
(

Pbind(
	'dur', 1.0,
	'legato', 0.8,
	'out', 0,
	'amp', 0.27498512790006,
	'pan', 0.0,
	'freq', 261.6255653006,
	'det', 0.040650406504065,
	'lpadsr', [ Env([ 0.0, 1.0, 0.10000000149012, 0.0 ], [ 0.0099999997764826, 0.40000000596046, 0.20000000298023 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
	'lpadsramt', 1.0299079577523,
	'kbamt', 0.1,
	'distamp', 0.91920977520277,
	'distpostamp', 0.93261116187045,
	'lpf', 36.068456413524,
	'rq', 0.26024824032852,
	'peakf', 2040.7062015945,
	'peakrq', 0.12815764317177,
	'peakboost', 10.975609756098,
	'adsr', [ Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000149012, 0.10000000149012, 0.10000000149012 ], [ -4.0, -4.0, -4.0 ], 2.0) ],
	'spread', 1.0,
)

);



//////////////////////////////////////////
////////////////////// 5 essential pads
////// mellow pad

(
SynthDef(\mellowpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0012) + 1), Rand(0,2));
	sig = sig + LFSaw.ar(freq * 2 * ((0..9)/9 - 0.5 * \fspread2.kr(0.002) + 1), Rand(0,2), mul:0.5);
	env1 = EnvGen.kr(\lpenv.kr(Env.asr(0.1,1,1.1)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(120) * ( freq * \kbamt.kr(0) +1 ) * (env1 * \lpenvamt.kr(1.2) + 1)).clip(20,20000), \rq.kr(0.3) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.5,0.1,0.8,1.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \mellowpad,
			\note, Pseq([
				[ 0,5-12,7 ],
				[ 2,5,7-12 ],
			],inf),
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);


////// brass pad



(
SynthDef(\brasspad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2));
	sig = LFSaw.ar(freq * LFNoise1.kr(0.1!10,mul:0.02,add:1),Rand(0,2));
	env1 = EnvGen.kr(\lpenv.kr(Env.perc(0.05,3,curve:-3)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(820) * ( freq * \kbamt.kr(0) +1 ) * (env1 * \lpenvamt.kr(3.2) + 1)).clip(20,20000), \rq.kr(0.5) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.perc(0.18,3,curve:-2)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \brasspad,
			\note, Pseq([
				[ 0,5-12,7 ],
				[ 2,5,7-12 ],
			],inf),
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

////// flute pad


(
SynthDef(\flutepad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = LFCub.ar(freq * LFNoise1.kr(0.1!4,mul:0.01,add:1),Rand(0,2));
	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.05,5,1.8,3.4,curve:-3)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(2320) * ( freq * \kbamt.kr(0) +1 ) * (env1 * \lpenvamt.kr(2.2) + 1)).clip(20,20000), \rq.kr(0.3) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.45,5,1.2,0.8,0.8,curve:-3)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \flutepad,
			\note, Pseq([
				2+12,12,
				[ 0,5+12,7 ],
				[ 2,5,7+12 ],
			],inf),
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

////// string pad


(
SynthDef(\stringpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2));
	sig4 = LFSaw.ar(freq * LFNoise1.kr(0.1!4,mul:0.01,add:1),Rand(0,2));

	sig = LFSaw.ar(freq,0);
	sig2 = LFSaw.ar(freq * LFNoise1.kr(0.1!4,mul:0.012 * LFTri.kr(0.3,mul:0.3,add:1),add:1),1);
	sig1 = IEnvGen.ar(Env([0,1,-1,0],[0.5,0,0.5],[8,0,-8]), sig.unipolar);
	sig = SelectX.ar( LFTri.kr(0.3).unipolar, [sig1, sig2]);
	sig = LPF.ar(sig, ( freq*6 ).clip(20,20000));

	sig = sig4 + sig;
	//sig = sig;

	//sig = sig + ( LFSaw.ar(freq) * SinOsc.ar(freq*2+0.1) );
	sig = LeakDC.ar(sig);
	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.05,5,1.8,3.4,curve:-3)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(1720) * ( freq * \kbamt.kr(0.1) +1 ) * (env1 * \lpenvamt.kr(2.2) + 1)).clip(20,20000), \rq.kr(0.3) );
	//sig = LPF.ar(sig,4000);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.45,5,1.2,0.8,0.8,curve:-3)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \stringpad,
			\note, Pseq([
				2+12,12,
				[ 0,5+12,7 ],
				[ 2,5,7+12 ],
			],inf),
			\octave, 5,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);
////// bass pad



(
SynthDef(\basspad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2));
	sig = LFPulse.ar(freq / 2 * LFNoise1.kr(0.1!4,mul:0.001 * Line.kr(1,10,4) ,add:1),Rand(0,2));
	sig = sig + LFSaw.ar(freq  * LFNoise1.kr(0.1!8,mul:0.001,add:1),Rand(0,2),mul:0.5);

	env1 = EnvGen.kr(\lpenv.kr(Env.adsr(0.01,4,0.3,4.4,curve:3)), gate);
	sig = RLPF.ar(sig, ( ( \lpf.kr(1) + ( freq * \kbamt.kr(1.9) ) + 1 ) * (env1 * \lpenvamt.kr(1.2) + 1)).clip(20,20000), \rq.kr(0.3) );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.05,5,0.8,0.6,curve:-3)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \basspad,
			\note, Pseq([
				0,4,3,1,
				//[ 0,5+12,7 ],
				//[ 2,5,7+12 ],
			],inf),
			\octave, 4,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);



/////////////////////////////////////

/// test osc shape
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	//sig = LFSaw.ar(freq).lagud(0,0.03);
	sig = LFSaw.ar(freq) * SinOsc.ar(freq/2+0.1);
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	//sig = LFSaw.ar(freq).lagud(0,0.03);
	//sig = SelectX.ar(MouseX.kr(0,1), [LFSaw.ar(freq, 1), Decay.Impulse.ar(freq)]);
	sig = LFSaw.ar(freq,0);
	sig2 = LFSaw.ar(freq,1);
	sig1 = IEnvGen.ar(Env([0,1,-1,0],[0.5,0,0.5],[8,0,-8]), sig.unipolar);
	sig = SelectX.ar(MouseX.kr(0,1), [sig1, sig2]);
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

////////////////////////////
(
Pdef(\melo, 
	Pbind(
		\instrument, \basspad,
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melo))
