~t = ~t ? 1;

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
}, metadata:(specs:(
	lpadsr: ParamEnvSpec.adsr,
))).add;

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

SynthDef(\reese, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	freq = freq.lag(0.08);
	sig = LFSaw.ar(freq * ((0..5)/5 - 0.5 * \fspread.kr(0.024) + 1), 0, Rand(0,2!6));
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.4,0.1,0.2)), gate, doneAction:0) * \lpadsramt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(0) + 1;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = RLPF.ar(sig, ( \lpf.kr(330) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.8));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\warmbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv, lpfreq;
	sig = LFSaw.ar(freq);
	lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.01,0.8,0.4,0.8)), gate, doneAction:0) * \envamt.kr(1) + 1;
	lpfreq = freq * \kbamt.kr(1) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(50) * lpenv * lpfreq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;


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

SynthDef(\rolandreese, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
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


SynthDef(\reese2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
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

SynthDef(\brasspad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	//sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.022) + 1), Rand(0,2));
	sig = LFSaw.ar(freq * LFNoise1.kr(0.1!10,mul:0.02,add:1),Rand(0,2));
	env1 = EnvGen.kr(\lpenv.kr(Env.perc(0.05,3,curve:-3)), gate);
	sig = RLPF.ar(sig, ( \lpf.kr(820) * ( freq * \kbamt.kr(0) +1 ) * (env1 * \lpenvamt.kr(3.2) + 1)).clip(20,20000), \rq.kr(0.5) );
	sig = sig * EnvGen.kr(\perc.kr(Env.perc(0.18,3,curve:-2)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

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
	sig = sig / 3;
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\snappad, {
	var snd, freq;
	freq = \freq.kr(440);
	// Four pulse waves (two one octave down) with randomly modulated pitches and pulse widths
	snd = Pulse.ar(
		freq * ({ LFNoise2.kr(3).range(-0.05, 0.05).midiratio }.dup(4)) * [1, 1/2, 1/2, 1],
		{ LFNoise2.kr(3).range(0.3, 0.7) }.dup(4)
	);
	// Spread across stereo field
	snd = Splay.ar(snd);
	// Sharp hi cut made by cascading three lowpass filters
	3.do { snd = LPF.ar(snd, \ffreq.kr(1500)); };
	snd = snd * Env.asr(\at.kr(3), \sustainlevel.kr(1), \rel.kr(3), -4).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(0.1)));
}).add;
SynthDef(\snapsigh, {
	var snd, freq;
	freq = \freq.kr(440, 0.3) * LFNoise2.kr(6).range(-0.1, 0.1).midiratio;
	snd = Pulse.ar(freq, LFNoise2.kr(6).range(0.3, 0.7));
	snd = RLPF.ar(snd, LFNoise2.kr(3).exprange(500, 1000), 0.2);
	snd = LPF.ar(snd, \lpf.kr(1000));
	snd = snd * Env.asr(0.1, 1, 3).ar(Done.freeSelf, \gate.kr(1));
	Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
SynthDef(\snapbow, {
	var snd, freq;
	freq = \freq.kr(440, 0.3);
	snd = CombC.ar(LeakDC.ar({ PinkNoise.ar }.dup(2)), freq.reciprocal, freq.reciprocal, 5);
	snd = LeakDC.ar(snd);
	snd = RLPF.ar(snd, Duty.kr(\bowdur.kr(1/4/~t), 0, Dseq([
		\bowhi.kr(1000),\bowlo.kr(100),
	],inf)) * \lpfr.kr(1), 0.3);
	snd = snd * EnvGen.kr(\perc.kr(Env.perc(4, 1, 1, 4)), 1, doneAction:Done.freeSelf);
	Out.ar(\out.kr(0), Balance2.ar(snd[0], snd[1], \pan.kr(0), \amp.kr(0.1)));
}).add;
);

//////////////////


(
// unison of pulse modulated by pulse width
SynthDef(\superpw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=8;
	var lpenv;
	sig = LFPulse.ar(freq, 0, LFNoise1.kr(1.1!num, mul:1, add:0).unipolar);
	sig = sig + LFPulse.ar(freq*2, 0, LFNoise1.kr(1.1, mul:1, add:0).unipolar, mul:0.2);
	//lpenv = EnvGen.kr(\lpadsr.kr(Env.adsr(0.04,0.4,0.2,4.1,4)), \itrig.tr(1), doneAction:0) * \lpenvamt.kr(4) + 1;
	lpenv = EnvGen.kr(\lpadsr.kr(Env.perc(1.6,0.4,curve:4)), \itrig.tr(1), doneAction:0) * \lpenvamt.kr(4) + 1;
	sig = RLPF.ar(sig, \lpf.kr(400) * lpenv, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\fmsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lpenv;
	var fmenv;
	lpenv = EnvGen.kr(Env([0,1,0],[0.01,0.4]), 1) * \lpenvamt.kr(2) + 1;
	fmenv = EnvGen.kr(Env([0,1,0],[0.01,0.8]), 1) * \fmenvamt.kr(3) + 1;
	sig = LFPulse.ar(freq + (LFSaw.ar(freq * 1 * [2,1,1/2,1.001,2], 1/2)*100 * fmenv + 1) );
	//sig = DFM1.ar(sig, \lpf.kr( 30 ) * lpenv, 1/\rq.kr(0.2));
	sig = MoogFF.ar(sig, \lpf.kr( 400 ) * lpenv, 1/\rq.kr(0.4));
	sig = DelayL.ar(sig, 0.1,0.0001 * ( SinOsc.kr(0.1) * 1 + 1 )) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\simplefm, { arg out=0, amp=0.1, gate=1, pan=0;
	var sig;
	sig = LFSaw.ar(\freq.ar(200) * ( 1 + ( SinOsc.ar(\fmf.kr(1) * [1,1+\fmfmul.kr(0.001)]) * \fma.kr(1) )));
	sig = RLPF.ar(sig, ( \lpfr.kr(1) * \freq.ar ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
 	 
/////////////////

SynthDef(\formant, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\fenv.kr(Env([0,1,0],[0.1,0.8])), 1) * \fenvamt.kr(1) + 1;
	env2 = EnvGen.kr(\bwenv.kr(Env([0,1,0],[0.1,0.8])), 1) * \bwenvamt.kr(1) + 1;
	sig = Formant.ar(freq, \formfreq.kr(120) * env1, \bwfreq.kr(195) * env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	fenv: ParamEnvSpec(\unipolar),
	bwenv: ParamEnvSpec(\unipolar),
))).add;

);
