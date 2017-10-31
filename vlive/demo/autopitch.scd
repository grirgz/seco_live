~t= 1
(
Ndef(\eyes, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
	],inf)).lag(0.11);
	sig = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq * 1.0 * env1) * 4.70 )));
	sig = RLPF.ar(sig, freq*4, 0.1);
	sig = Pan2.ar(sig, 0, amp);
}).play
);

(
Ndef(\eyes, { arg freq=483, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmfreq;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,1,0,
		1,0,0,0,
		1,0,0,0,
		1,0,0,0,
	],inf)).lag(0.01);
	fmfreq = freq * ( 1 + ( SinOsc.ar(freq * 4 * env1) * 1 ));
	sig = LFSaw.ar(fmfreq * [1,1.0001]);
	sig = RLPF.ar(sig, freq*2 * [1,2 * SinOsc.kr(1/8).range(2,1),1], 0.2 * SinOsc.kr(1/4).range(2,1));
	sig = Pan2.ar(sig, 0, amp).flop;
}).play
);

(
Ndef(\eyes, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fmfreq;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,1,1,
		1,0,0,1,
		1,0,0,0,
	],inf)).lag(0.01);
	fmfreq = freq * ( 1 + ( SinOsc.ar(freq * 1 * env1) * 2.2 ));
	sig = LFSaw.ar(fmfreq * [1,1.0001]);
	sig = RLPF.ar(sig, freq*2 * [1,2 * SinOsc.kr(1/8).range(2,1),1], 0.2 * SinOsc.kr(1/4).range(2,1));
	sig = Pan2.ar(sig, 0, amp).flop;
}).play
);

Ndef(\eyes).set(\freq, 90)
Ndef(\eyes).unset(\freq)

~t = 1
(
Ndef(\eyes, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,1,0,
	],inf)).lag(0.1);
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * env1) * 0.91 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 400, 800 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(1.1,1)] * 1.1 * Amplitude.kr(sig)**7.8 ) ).clip(5,18000));
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1), amp).flop;
}).play
);

// bit like jazzy bass (or just gamme)
{ arg freq = 74; SinOsc.ar(freq * [1,1.000001] * ( 1 + ( SinOsc.ar(freq  * LFPulse.kr(2,0, 1/8).range(0,1) * 1.50 )))) * 0.2; }.play

{ arg freq = 100; SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2 * LFPulse.kr(1/2,0,0.8).range(0,1),0, SinOsc.kr(1/8).range(0,1))) * 1.91 ))) ! 2 * 0.1; }.play
{ arg freq = 200; SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq * 1.0 * LFPulse.kr(8,0).range(0,1).clip2(1) * 1.91 )))) ! 2 * 0.1; }.play

{ arg freq = 74; SinOsc.ar(freq * [1,1.000001] * ( 1 + ( SinOsc.ar(freq  * LFPulse.kr(2,0, 1/8).range(0,1) * 1.20 )))) * 0.2; }.play
{ arg freq = 90; SinOsc.ar(freq * [1,1.000001] * ( 1 + ( SinOsc.ar(freq  * LFPulse.kr(4,0, 0.5).range(0,1) * 1.50 )))) * 0.2; }.play
{ arg freq = 74; SinOsc.ar(freq * [1,1.000001] * ( 1 + ( SinOsc.ar(freq  * LFPulse.kr(2,0, 1/8).range(0,1) * 1.50 )))) * 0.2; }.play
{ arg freq = 77; SinOsc.ar(freq * [1,1.000001] * ( 1 + ( SinOsc.ar(freq  * LFPulse.kr(4,0, 1/3).range(0,1) * 1.60 )))) * 0.2; }.play

{ arg freq = 77; SinOsc.ar(freq * [1,1.000001] * ( 1 + ( SinOsc.ar(freq  * LFPulse.kr(4,0, 1/3).range(0,2) * 1.3225 )))) * 0.2; }.play

{ arg freq = 77; SinOsc.ar(freq * [1,1.000001] * ( 1 + ( Latch.ar(SinOsc.ar(freq), LFPulse.kr(4,0, 1/3)) * 1.60 ))) * 0.2; }.play
(
Ndef(\agro,{ arg freq = 200; 
	SinOsc.ar(freq * ( 1 + ( LFSaw.ar(freq * 1.0 * LFPulse.kr(2,0,0.8).range(2,0).clip2(1) * 1.91 )))) ! 2 * 0.1; 
}).play
)
Ndef.defaultQuant = 1

(
Ndef(\eyes, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/4/~t, 0, Dseq([
		1,0,0,0,
		0,0,1,0,
		1,1,0,0,
		1,0,0,0,
	],inf)).lag(0.31);
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * env1) * 1.91 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 4001, 8000 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(0.1,4)] * 1.1 * Amplitude.kr(sig)**1.8 ) ).clip(5,18000));
	sig = (sig * 40).tanh / 1;
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1) * 0.3, amp).mean;
}).play
);

(
Ndef(\eyes, { arg freq=180, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
		0,0,0,0,
		0,0,0,0,
	],inf)).lag(0.01);
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	in = LocalIn.ar(3);
	sig = sig + DelayL.ar( in * \fbfac.kr(1.49), 0.01,\del.kr(0.0001) * SinOsc.kr(1 * (1..3) * \delfm.kr(1)).range(\delfmmax.kr(2.10),1) );
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * env1) * LFPulse.kr([1/4,1/3,1]).range(0,2).sum )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( 
		[400, 401, 800 ] * \lpfac.kr(1) 
		* ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(1.1,1)] * 1.4 * Amplitude.kr(sig)**1.8 ) 
	).clip(5,18000), \lprq.kr(0.5));
	sig1 = (sig * 1).tanh / 1;
	sig = SelectX.ar(\mix.kr(0.5), [sig/4, sig1]);
	LocalOut.ar(sig);
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1) * 0.3, amp).flop;
}).play
);
Ndef(\eyes).edit
Ndef(\eyes).addSpec(\del, ControlSpec(0.0001,1,\exp))

(
Ndef(\cash, { arg freq=180, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in;
	var bprq = \bprq.kr(1);
	freq = [0,2,5].midiratio * freq;
	sig = WhiteNoise.ar(1);
	sig = LFNoise2.ar(8000);
	//sig = BPF.ar(sig, freq * SinOsc.ar(freq).range(1,2), bprq);
	//sig = sig + BPF.ar(sig, freq * ( 1 + ( SinOsc.ar(4 * [1,2,3]) * 4.1 ) ), bprq * 0.1);
	sig = BPF.ar(sig, freq + SinOsc.kr(1/4).range(0,100), bprq * 0.1);
	sig = BPF.ar(sig, freq, bprq * 0.1);
	sig = sig * 100;
	sig = sig.tanh;
	sig = Pan2.ar(sig, SinOsc.kr(1/7 * (1..3)).range(-1,1)*0.1, amp).flop;
}).play
);

(
Ndef(\cash, { arg freq=180, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in;
	var bprq = \bprq.kr(1);
	freq = [0,2,5].midiratio * freq;
	//sig = WhiteNoise.ar(1);
	sig = LFNoise2.ar(8000 * ( 1 + ( SinOsc.kr(1/28) * 1 )));
	//sig = BPF.ar(sig, freq * SinOsc.ar(freq).range(1,2), bprq);
	//sig = sig + BPF.ar(sig, freq * ( 1 + ( SinOsc.ar(4 * [1,2,3]) * 4.1 ) ), bprq * 0.1);
	sig = BPF.ar(sig, freq + SinOsc.kr(1/9 * ( 1 + ( SinOsc.kr(1/7) * 1 ))).range(0,1000), bprq * 1);
	sig = BPF.ar(sig, freq + SinOsc.kr(1/19 * ( 1 + ( SinOsc.kr(1/7) * 1 ))).range(0,1000), bprq * 1);
	sig = BPF.ar(sig, freq, bprq * SinOsc.kr(1/7 * ( 1 + ( SinOsc.kr(1/12) * 1 ))).range(0.1,1));
	sig = BPF.ar(sig, freq, bprq * 0.1);
	sig = sig * 100;
	sig = sig.tanh;
	sig = Pan2.ar(sig, SinOsc.kr(1/7 * (1..3)).range(-1,1)*0.1, amp).flop;
}).play
);


(
Ndef(\eyes, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
		0,0,0,0,
		0,0,0,0,
	],inf)).lag(0.31);
	freq =  freq * Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
		4,4,4,4,
		5,5,5,5,
	],inf)).midiratio * ( 1 + ( SinOsc.kr(1/42 * [1,1.1]) * 0.01 ));
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + LFSaw.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 ) * 1.91 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 4001, 8000 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(0.1,4)] * 1.1 * Amplitude.kr(sig)**1.8 ) ).clip(5,18000));
	sig = (sig * 40).tanh / 2;
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1) * 0.3, amp).flop;
}).play
);

(
Ndef(\eyes, { arg freq=80, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,0,0,0,
		0,0,0,0,
		0,0,0,0,
	],inf)).lag(0.31);
	freq =  freq * Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
		4,4,4,4,
		5,5,5,5,
	],inf)).midiratio * ( 1 + ( SinOsc.kr(1/42 * [1,1.1]) * 0.01 ));
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = 0;
	sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*[1,2,4] * 1.0 ) * 1.91 )));
	//sig = sig + SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*2 * 1.0 * LFPulse.kr(2)) * 0.91 )));
	sig = RLPF.ar(sig, ( [4000, 4001, 8000 ] * ( [1.07,1,1.0001 * SinOsc.kr(1/8).range(0.1,4)] * 1.1 * Amplitude.kr(sig)**1.8 ) ).clip(5,18000));
	sig = (sig * 40).tanh / 2;
	sig = Pan2.ar(sig, SinOsc.kr([1,2,3]/10).range(-1,1) * 0.3, amp).flop;
}).play
);
Ndef(\eyes).edit


(
Ndef(\grat, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Dust.ar(freq*4);
	sig = Ringz.ar(sig, SinOsc.ar((1..10)) * freq, 0.001);
	sig = (sig + 0.05) * (SinOsc.ar(freq));
	//sig = BPF.ar(sig, freq * SinOsc.kr((1..10)).range(1,1.02));
	sig = sig * 1.7;
	sig = Pan2.ar(sig, SinOsc.kr((1..10)) * 0.1, amp).flop;
	sig = LeakDC.ar(sig);
}).play;
);

(
Ndef(\grat, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		1,0,0,0,
		4,4,3,3,
	],inf)).midiratio;
	in = LocalIn.ar(10);
	sig = Dust.ar(freq * \dustfac.kr(1));
	sig = Ringz.ar(sig, freq, \ringz.kr(0.1));
	//sig = (sig + 0.05) * (SinOsc.ar(freq));
	sig = sig + (in * \fbfac.kr(1.4));
	sig = LPF.ar(sig, freq * SinOsc.ar((1..10)*freq).range(1,8.02));
	//sig = sig * 0.7;
	sig = sig.tanh;
	sig = FreqShift.ar(sig, [0.01,0]) + sig;
	LocalOut.ar(sig);

	//sig = sig/ 4;
	sig = Pan2.ar(sig, SinOsc.kr((1..10)) * 0.1, amp).flop;
	sig = LeakDC.ar(sig);
}).play;
);
Ndef(\grat).edit


(
	Ndef(\bla, \setsrc -> Pbind(
		\dur, 8,
		\source, { arg freq= 100, pan=0, amp=0.1;

	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = 8.collect {
		var xfreq;
		freq = [
			freq,
			freq * ( 1 + ( SinOsc.ar(2**(10.0.rand)/4 + 50) * 1 ))
		].choose;
		sig2 = [
			SinOsc.ar(freq),
			LFSaw.ar(freq),
			LFPulse.ar(freq),
		].choose;

		sig2 = [
			(sig2 * 100.0.rand).tanh,
			(sig2 * 100.0.rand).clip2(0.891.rand),
			sig2,
		].choose;

		sig3 = [
			{ arg x; x + 100.0.rand },
			{ arg x; x * 2.0.rand },
			{ arg x; x * ( 1 + ( SinOsc.ar(sig2) * 1 )) },
			freq,
		].choose;

		sig2 = [
			LPF.ar(sig2, sig3.(freq)),
			RLPF.ar(sig2, sig3.(freq)),
			HPF.ar(sig2, sig3.(freq)),
			BPF.ar(sig2, sig3.(freq)),
		].choose;
	};
	//sig = sig / 4;
	sig = Normalizer.ar(sig);
	sig = LeakDC.ar(sig);
	Pan2.ar(sig, SinOsc.kr(1/17.0.rand*(1..3) * ( 1 + ( SinOsc.kr(1/14) * 1 ))) * 0.5 , amp).flop;
	
})).play
)

Ndef(\bla).edit
Ndef(\bla).fadeTime = 4


(
SynthDef(\blo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq*[1,1.001]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\raid, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = RLPF.ar(sig, freq*2);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\raid2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1 = EnvGen.kr(Env([1,2,1],[0.01,0.8]), 1);
	sig = LFSaw.ar(freq * [1,1.001, 1 + Rand(0,0.0001)]);
	sig = RLPF.ar(sig, freq*env1 * [1,1 + Rand(0,0.1),2,1.01]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\raid3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var xfreq;
	var env1 = EnvGen.kr(Env([1,2,1],[0.01,0.8]), 1);
	xfreq = freq * ( 1 + ( SinOsc.ar(Rand(1,500)) * Rand(0.1,3) ));
	sig = LFSaw.ar(xfreq * [1,1.001, 1 + Rand(0,0.0001)]);
	sig = RLPF.ar(sig, freq*env1 * [1,1 + Rand(0,0.1),2,1.01]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = sig * 0.5;
	Out.ar(out, sig);
}).add;
);

(
	Pdef(\cri, 
		Ppar(
			5.collect({
				Plazy({
					var x = [
						14.rand,
						14.rand,
						14.rand,
						14.rand,
					];

					Pfindur(8.rand+1,
						Pbind(
							\instrument, [
								\blo,
								\raid,
								\raid2,
								\raid3,
								\default,
							].choose,
							\legato, 1.0.rand + 0.1,
							\adsr, Pseq([
								[
									[ Env.adsr(0.1,0.1,0.8,0.1) ],
									[ Env.adsr(0.2,0.1,0.8,0.1) ],
									[ Env.adsr(0.02,0.1,0.8,0.3) ],
									[ Env.adsr(0.02,0.1,0.6,0.7) ],
								].choose
							],inf),
							\degree, 
							[
								Pseq(x.keep(2),inf),
								Pseq(x[[1,0,1,2]],inf),
								Pseq(x,inf),
								Pseq(x.mirror,inf),
								Pseq({x.choose}!4,inf),
								Pseq({x.choose}!1,inf),
							].choose,
							\octave, [3,4,5,6].choose,
							\dur, [
								Pseq([2**8.rand/8, 1/4],inf),
								//Pseq([2**8.rand/8],inf),
							].choose,
							\amp, 0.1/4
						)
					)
				}).loop
			})
		)

	).play;
);

(
	Pdef(\cri, 
		Ppar(
			5.collect({
				Plazy({
					var x = [
						14.rand,
						14.rand,
						14.rand,
						14.rand,
					];

					Pfindur(8.rand+1,
						Pbind(
							\instrument, [
								\blo,
								\raid,
								\raid2,
								\raid3,
								\default,
							].choose,
							\legato, 1.0.rand + 0.1,
							\adsr, Pseq([
								[
									[ Env.adsr(0.1,0.1,0.8,0.1) ],
									[ Env.adsr(0.2,0.1,0.8,0.1) ],
									[ Env.adsr(0.02,0.1,0.8,0.3) ],
									[ Env.adsr(0.02,0.1,0.6,0.7) ],
								].choose
							],inf),
							\degree, 
							[
								Pseq({x.choose}!2,inf),
								Pseq({x.choose}!1,inf),
								Pseq({x.choose}!4,inf),
								Pseq({x.choose}!3,inf),
							].choose,
							\octave, [3,4,5,6].choose,
							\lag, [0,1/4,1/8,0].choose / 2,
							\lag, 1.0.rand / 16,
							\isRest, Pseq([1,0,0.5,0.3],inf).coin.not,
							\dur, [
								Pseq([2**2.rand/8, 1/4],inf),
								Pseq([2**4.rand/8, 1/8],inf),
								//Pseq([2**8.rand/8],inf),
							].choose,
							\amp, 0.1/4
						)
					)
				}).loop
			})
		)

	).play;
);


(
	Pdef(\cri, 
		Ppar(
			5.collect({
				Plazy({
					var x = [
						14.rand,
						14.rand,
						14.rand,
						14.rand,
					];

					Pfindur(8.rand+1,
						Pbind(
							\instrument, [
								\blo,
								\raid,
								\raid2,
								\raid3,
								\default,
							].choose,
							\legato, 1.0.rand + 0.1,
							\adsr, Pseq([
								[
									[ Env.adsr(0.1,0.1,0.8,0.1) ],
									[ Env.adsr(0.2,0.1,0.8,0.1) ],
									[ Env.adsr(0.02,0.1,0.8,0.3) ],
									[ Env.adsr(0.02,0.1,0.6,0.7) ],
								].choose
							],inf),
							\degree, 
							[
								Pseq([x.choose],inf),
							].choose,
							\octave, [3,4,5,6].choose,
							//\lag, [0,1/4,1/8,0].choose / 2,
							//\lag, 1.0.rand / 16,
							\isRest, [
								Pseq([0.51,0.51,0.50,0.50].coin.asInteger.scramble,inf).coin.not,
								//Pseq([0.51].coin.asInteger.scramble,inf).coin.not,
								false,
							].choose,
							\dur, [
								Pseq([2**2.rand/8, 1/4],inf),
								1/8,
								//Pseq([2**4.rand/8, 1/8],inf),
								//Pseq([2**8.rand/8],inf),
							].choose,
							\amp, 0.1/4
						)
					)
				}).loop
			})
		)

	).play;
);


ParamProto.init
~modStepTimeline.new(\my).edit
~modStepTimeline.new(\my).drumrack = DrumRack(\my)

(
Ndef(\plik, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1, SinOsc.kr(1/4).range(1.010,1)]);
	sig = SelectX.ar( SinOsc.kr(1/2*~t).range(0,1), [sig, sig1]);
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		1,0,0,0,
		0,1,0,0,
		1,1,0,0,
		0,1,1,0,
		1,0,0,0,
		0,1,0,0,
		1,1,1,1,
		0,1,1,0,
	],inf)).lag(0.01);
	sig = RLPF.ar(sig, freq*1 * SinOsc.kr([1,1.2]/2).range(8,1));
	//sig = DelayL.ar(sig, 0.1,0.1);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\plik).edit
Ndef(\plik).stop
Ndef(\plik).quant
Ndef.defaultQuant = 4
Pdef.defaultQuant = 4

(
Ndef(\azer, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1, SinOsc.kr(1/4).range(1.010,1)]);
	sig = SelectX.ar( SinOsc.kr(1/2*~t).range(0,1), [sig, sig1]);
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		0,0,1,0,
		1,0,1,1,
		0,1,1,0,
		1,1,1,0,
	],inf)).lag(0.01);
	sig1 = (sig * 100).tanh;
	sig = SelectX.ar( SinOsc.kr(1/7 / [1,2,3]).range(0,1), [sig, sig1]);
	sig = RLPF.ar(sig, freq*1 * SinOsc.kr([1,1.2,1/3]/6).range(8,1));
	sig1 = CombL.ar(sig, 4/~t, 1/8/~t/8, SinOsc.kr(1/13).range(0,1)/~t) + sig;
	sig = SelectX.ar( SinOsc.kr(1/9 / [1,1.2,2.3]).range(0,1), [sig, sig1]);
	//sig = DelayL.ar(sig, 0.1,0.1);
	sig = Pan2.ar(sig, SinOsc.ar(1/7) * 0.3 , amp).flop;
}).play;
);


(
Ndef(\bono)[0] = { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Impulse.ar( SinOsc.kr(1/8).range(40,4)).lag(0.01);

	sig = DynKlank.ar(Ref([\ktab.kr({1400.0.rand}!8), 1, SinOsc.kr(1/7).exprange(0.001,8)]),sig) * 1;
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
};
Ndef(\bono).play;

Ndef(\bono)[1] = \set -> Pbind(
	\ktab, Plazy({ [{1400.0.rand}!8 ] }).loop,
	\ktab, Plazy({ [Array.series(8,100,100.0.rand) ] }).loop,
	\dur, 1,
);
);

(
Ndef(\bono)[0] = { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = Impulse.ar( \impfreq.kr(40) * [1,1/3,1/4,1]).lag(\implag.kr(0.1));

	sig = DynKlank.ar(Ref([\ktab.kr({1400.0.rand}!8).lag(\ktablag.kr(0.5)), 1, \kreztab.kr((1!8))]),sig) * 1;
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, SinOsc.ar(1/8 * (1..4)) * 0.1, amp).flop;
};
Ndef(\bono)[1] = \set -> Pbind(
	\degree, Pseq([1,2,3,4],inf),
	\step, Pwhite(100,200.0,inf),
	\impfreq, Ndef(\yep, { SinOsc.kr(1/4).range(400,1) }),
	\step, Pseq([100,20,200,300],inf),
	\freq, Pseq([100,200,300,400],inf),
	\ktablag, 0.1,
	\ktab, Plazy({ arg ev; [Array.series(8,ev.use(ev.freq).debug("greq"),ev[\step]) ] }).loop,
	\dur, 1/4,
);
Ndef(\bono).play;
)
Ndef(\bono).edit
Ndef(\bono).addSpec(\kreztab, XArraySpec( ControlSpec(0,8,\lin)!8 ))
Ndef(\bono).addSpec(\implag, ControlSpec(0.001,1,\exp))
Ndef(\bono).asParamGroup.edit
Ndef(\bono).unset(\ktab)
Ndef(\bono).unset( \impfreq)

~se[\step] = nil;
~se.edit

(
ParamProto.init;
EnvInit(\se, StepEvent.new);
~pg = ParamGroup([
	Param(~se, \step, \freq),
	Param(~se, \freq, \freq),
	] ++ Ndef(\bono).asParamGroup
);
~stepEventView.new(~se, ~pg).makeWindow;
)

(
	Ndef(\bono)[1] = \set -> (
		Pbind(
			\ktab, Plazy({ arg ev; [Array.series(8,ev.use(ev.freq).debug("greq"),ev[\step]) ] }).loop,
			\dur, 1/4,
			//\impfreq, Ndef(\yep, { SinOsc.kr(1/8).range(40,1) }),
		)
		<> 
		~se.asPattern.loop 
	);
)

(
WindowLayout({
	var sel;
	var views;
	var map_button = XSimpleButton.new;
	var pgroup = ~pg;
	sel = ~view_selector.new(~pg.size, { arg x;
		var txt;
		var me = sel;
		var param = pgroup[me.selected_index];
		"heeeeeeeeeeeeeeeee".debug;
		if(param.target.nodeMap[param.property].isNil) {
			txt = "";
			map_button.enabled = false;
		} {
			txt = "Unmap";
			map_button.enabled = true;
			map_button.action_({
				param.target.unset(param.property);
				sel.action.(x)
			});
		};
		map_button.label_(param.asLabel ++ " " ++ txt )
	});
	VLayout (
		HLayout(
			map_button,
		),
		VLayout (
			* views = pgroup.collect({ arg param, i;
				ParamViewToolBox.horizontal_slider(param). mouseDownAction_({ arg view, x, y, modifiers, buttonNumber, clickCount;
					[view, x, y, modifiers, buttonNumber, clickCount].debug("mouseDownAction");
					//view.background_(Color.red)
					sel.select_item(i, views);
					sel.action.(i);
		
				}).background_(sel.deselected_color)
			})
			++ [nil]
		).spacing_(0)
	)
})
)

Ndef(\bono).get(\pan)
Ndef(\bono).unset(\pan)
Ndef(\bono).nodeMap
