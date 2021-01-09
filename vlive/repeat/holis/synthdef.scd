(

SynthDef(\snapkickx, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(\bodyfreqenv.kr(Env([261, 60, 51], [0.035, 0.08], curve: \exp)));
	bodyAmp = EnvGen.ar(\bodyenv.kr(Env.linen(0.005, 0.1, 0.3)), doneAction: 2);
	body = SinOsc.ar(bodyFreq) * bodyAmp;
	// pop sweeps over the midrange
	popFreq = XLine.kr(\popfstart.kr(750), \popfend.kr(261), \popfdur.kr(0.02));
	popAmp = EnvGen.ar(\popenv.kr(Env.linen(0.001, 0.02, 0.001))) * \popamp.kr(0.15);
	pop = SinOsc.ar(popFreq) * popAmp;
	// click is spectrally rich, covering the high-freq range
	// you can use Formant, FM, noise, whatever
	clickAmp = EnvGen.ar(Env.perc(\clickat.kr(0.001), \clickrel.kr(0.01))) * \clickamp.kr(0.15);
	click = LPF.ar(Formant.ar(\formfund.kr(910), \formfreq.kr(4760), \formbw.kr(2110)), \lpf.kr(3140)) * clickAmp;

	snd = body + pop + click;
	snd = snd * \distpreamp.kr(1);
	snd = snd.tanh;
	snd = snd * \distpostamp.kr(1);

	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

SynthDef(\phyhat3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,1100,2051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,200,7451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, [9400,17030,1410,8000.14,5000] * env3, 0.001).mean/10;
	env1 = EnvGen.kr(Env([8821,7810,251],[0.01,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([13820,15800,151],[0.01,0.8*\fac1.kr(1)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = HPF.ar(sig, env1);
	sig = LPF.ar(sig, env2);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.4,1,-4) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\fmbell, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 2.6706 + 0.13) * \fmamp.kr(2) + 1; 
	sig2 = SinOsc.ar(freq * 0.9998 * sig1);
	sig3 = SinOsc.ar(freq * 2.6629 * sig1 + 2.04);
	sig4 = LFCub.ar(freq * 0.9991 * sig1 + 2.14);
	sig5 = SinOsc.ar(freq * 2.6656 * sig1 - 2);
	sig6 = SinOsc.ar(freq * 1 * sig1 + 1.84);
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0,0.5,0.5, 0.5,0.5,0.5]);
	//sig.debug("sig");
	//sig = sig /34;
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,2.1,1,-1) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan + [ 0, -0.5, -0.5, 0.5, 0.5, 0], amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\fmbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq / 4;
	freq = freq * ((0..1)/1 - 0.5 * 0.0007 + 1);
	env1 = EnvGen.kr(Env([0,1,0.051,0],[0.001,0.01,0.8], [4,-8]), 1);
	env2 = EnvGen.kr(Env([0,1,0.051,0],[0.005,0.5,1.5], [0,-8], releaseNode:2), 1);
	env3 = EnvGen.kr(Env([0,1,1,0],[0.01,0.01,0.2], [0,0,-4], releaseNode:2), gate);
	env4 = EnvGen.kr(Env([0,1,0],[0.002,2.8], [0,-4]), 1);
	env5 = EnvGen.kr(Env([0,1,1,0],[0.001,0.1,0.8], [4,0,-4], releaseNode:2), gate);
	env6 = EnvGen.kr(Env([0,1,0],[0.001,3.0], [0,-4]), 1);
	//freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * 11 + 0) * env1; 
	sig2 = SinOsc.ar(freq * 6 * ( sig1 * 2.5 + 1 )) * env2;
	sig3 = SinOsc.ar(freq * 2 * 1 + 0) * env3;
	sig4 = SinOsc.ar(freq * 1 * ( sig3 * 2.5 + 1 ) + 0) * env4;
	sig5 = SinOsc.ar(freq * 1 * ( sig2 * 2.5 + 1 ) * (sig4 * 2.5 + 1)) * env5;
	sig6 = SinOsc.ar(freq * 2) * env6;
	//sig = sig2 + sig3 + sig4 + sig5 + sig6;
	sig = [sig1, sig2, sig3, sig4, sig5, sig6] * DC.ar([0.0, 0.0, 0.0,  0.0, 0.5, 0.5]);
	sig.debug("sig");
	sig = sig /2;
	sig = sig.flop.sum;
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.001,0,1,0.01, 1,-1) ),gate,doneAction:2);
	sig = sig * AmpComp.kr(freq);
	sig.debug("sigx");
	sig = Pan2.ar(sig, pan + [ 0, 0, 0, 0, 0, 0], amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\fmsaw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq  * ( 1 + ( SinOsc.ar(\fmfreq.kr(8)) * \fmamt.kr(1) ));
	sig = SinOsc.ar(freq * [1,1.01,1.001] );
	sig = sig + LFSaw.ar(freq *  [1,1.0001], mul:1/2 * \sawmul.kr(1));
	sig = RLPF.ar(sig, \ffreq.kr(2000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.01,0.8,\release.kr(0.01)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
SynthDef(\chordar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([2.00,0.7,1,1.02],[0.01,0.08,3.4])), 1);
	env2 = EnvGen.kr(\env2.kr(Env([0.10,1.4,0.1,0.01],[0.01,0.48,3.4])), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1.10,1.4,0.9,0.01],[0.01,0.48,3.4])), 1);
	sig = LFSaw.ar(freq * (env1) * [[1,1.0000001]] * [0.99999,1,2,1/2]).sum;
	sig = SinOsc.ar(freq* (env1) * [[1,1.0000001]] * [0.99999,1,2,1/2]).sum + sig ;
	sig.debug("sig");
	sig1 = RHPF.ar(sig, \hpfr.kr(3.4) * freq * env1, \hrq.kr(0.5) * env2);
	sig = SelectX.ar(\mixhpf.kr(0.5) * env3, [sig, sig1]);
	sig1 = RLPF.ar(sig, \lpfr.kr(3.4) * freq * env1, \lrq.kr(0.5) * env2);
	sig = SelectX.ar(\mixlpf.kr(0.5) * env3, [sig, sig1]);
	sig1 = sig.tanh;
	sig = SelectX.ar(\mixdist.kr(0.5) * env3, [sig, sig1]);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.9)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * 0.5;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;

SynthDef(\brownbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(16) * freq ).clip(20,20000), \rq.kr(0.6)) + ( sig / 5 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\pluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=1;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
	//freq = freq * ( 1 + ( SinOsc.ar(17006) * 1 ));
	sig = Pluck.ar(ex, DelayC.ar(gate, 0.1, [0.01,0.032,0.0123] * \dstrum.kr(1)), 20.reciprocal, 1/freq * [1,1/2.2142,1/3.52354], decay, coef:coef).sum;
	sig = sig * 2;
	//sig = sig/2 + FreqShift.ar(sig, [{ 600.0.rand }!5]).flop.mean * 3;
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.5)) * 1 + ( sig/4 );
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,[0.2,0.1],0.8,0.4,1,4)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp * 0.7;
	Out.ar(out, sig);
}).add;

SynthDef(\rise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, time=4;
	var sig;
	var fspread = XLine.kr(\spstart.kr(0.01),\spend.kr(10),time);
	freq= freq* XLine.kr(\start.kr(1),\end.kr(2),time);
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * [ [1,1.01] ]);
	sig = sig.debug("sig").mean.debug("sig2");
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * (1+ fspread ) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\sibass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq, \rq.kr(0.5));
	sig = HPF.ar(sig, 70);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\vlip, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,0.002,0.3],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * SinOsc.ar((1..8)/10, mul:\fmamp.kr(2.001) * env1, add:1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\hech, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([10,12000,182],[4,0.1]/~t,[1,1]),1);
	env2 = EnvGen.kr(Env([10,1000,152],[4,0.1]/~t,[1,1]), 1);
	env3 = EnvGen.kr(Env([10,7100,1000],[4,0.1]/~t,[1,1]), 1);
	env4 = EnvGen.kr(Env([0.1,2,0.1],[4.0,0.08]/~t), 1);
	sig = WhiteNoise.ar;
	sig = Ringz.ar(sig, rrand(70.0!8,1000),0.01).mean;
	sig = sig * ( SinOsc.ar(1700) * env4 + 1 );
	//sig = RLPF.ar(sig, env2, \rq2.kr(0.8));
	sig = RLPF.ar(sig,  [env3, env2, env1 ], \rq.kr(0.5));
	sig = HPF.ar(sig, 1000);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = Pan2.ar(sig, [-1,0,1]*0.1, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\dronebleu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.01,0.8]), 1);
	env2 = EnvGen.kr(Env([1,1,0.2,1],[1,0.01,0.8]), 1);
	env2 = Duty.kr(\seqdur.kr(1/12/~t), 0, Dseq(\seqtab.kr([
		1,1,1, 1,1,0,  1,1,1, 0,1,1,
		0,1,1, 0,1,1,  0,1,1, 0,1,1,
	]),inf)).lag(0.1)+0.2;
	sig = SinOsc.ar(freq * env1 * [1,1.00001].mirror2.clump(2)).mean;
	sig = sig.fold2(0.9 * env2 * SinOsc.kr(1/(1..8)/~t).unipolar);
	sig.postln;
	sig = HPF.ar(sig, 100);
	sig = sig.mean;
	sig = sig * 2.0;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + LFNoise1.kr(1), amp);
	Out.ar(out, sig);
}).add;
SynthDef(\dronebleuhi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.8,1,0.1],[0.01,0.8,1]), 1);
	env2 = EnvGen.kr(Env([1,1,0.2,1],[1,0.01,0.8]), 1);
	env2 = Duty.kr(\seqdur.kr(1/12/~t), 0, Dseq(\seqtab.kr([
		1,1,0, 1,0,1,
	]),inf)).lag(0.1)+0.1;
	freq = freq * [1,1/2,1/4];
	sig = SinOsc.ar(freq * env1 * [1,1.00001].mirror2.clump(2)).mean;
	sig = sig.fold2(0.9 * env2 * SinOsc.kr(1/(1..8)/~t).unipolar);
	sig.postln;
	sig = HPF.ar(sig, 100);
	sig = RLPF.ar(sig, 8000);
	sig = FreqShift.ar(sig, env2*10) + sig / 2;
	sig = sig.mean;
	sig = sig * 1.5;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + LFNoise1.kr(1), amp);
	Out.ar(out, sig);
}).add;
SynthDef(\nidi, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0.1,10,40,1],[4,4.1,0.8]), 1);
	sig = SinOsc.ar([234,234.43] * ( SinOsc.ar(freq) * env1 + 1 )).mean;
	sig1 = ( sig*\distamp.kr(1)*env1 ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\mix.kr(1), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(2.01,0.1,0.8,0.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\cracklemono, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,0.1],[0.01,0.1,0.1]), \xtrig.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.01,0.1]), \xtrig.tr);
	sig = Crackle.ar(\chaos.kr(1));
	sig = LFSaw.ar(freq * ( sig* 10.1 * env1 + 1 )); 
	sig = sig * env2;
	//sig = Formlet.ar(sig, freq,\format.kr(0.21),\formdec.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 50);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\crackledec, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,0.1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([0,1,0],[0.01,0.1]), \xtrig.tr(1));
	sig = Crackle.ar(\chaos.kr(1));
	sig = LFSaw.ar(freq * ( sig* 10.1 * env1 + 1 )); 
	sig = sig * env2;
	//sig = Formlet.ar(sig, freq,\format.kr(0.21),\formdec.kr(0.1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = HPF.ar(sig, 50);
	sig = Limiter.ar(sig);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\dubdrone3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!48!2), 0.001!8 ]), sig);
	//sig = sig * SinOsc.kr(4*~t).range(0,1);
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.01,0.8,0.01].normalizeSum)), Impulse.kr(4*1.5*~t), timeScale:1/8);
	//sig = sig  / 4;
	sig = sig * 15*2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,1.1,0.2,0.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig.debug("sig");
	Out.ar(out, sig);
}).add;

SynthDef(\dubdrone4, { arg out=0, gate=1, amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
						 
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = Duty.kr(1/8/~t, 0, Dseq([
		[0,4,7,12],
		[0,4,7,10],
		[0,7,10,-12],
		[0,3,7,10],
	].midiratio,inf));
	time_stretch = 0;
	trate = 100;
	pos = SinOsc.kr(1/16*~t,pi).range(0,1) * 0.0004 * [1,1.1] + 0.3;
	//pos = EnvGen.ar(Env([0,0.4,0.2],[0.4,0.2]),LFPulse.kr(1/1*~t),doneAction:0);
	//pos = pos + EnvGen.ar(Env([0,0.2,0.4],[0.4,0.1]),LFPulse.kr(1*~t).poll,doneAction:0).poll;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou = Pan2.ar(ou, SinOsc.kr(1/48,[0,pi]).unipolar).flop;
	ou = [
		[300,350] * SinOsc.kr(1/8*~t).range(1,1.2),
		[1300,1350],
		[7300,7350],
	].collect { arg x, idx;
		ou1 = RHPF.ar(ou, x[0],0.3);
		ou2 = RLPF.ar(ou1, x[1],0.3);
		ou2 = ou2 * SinOsc.kr(1/(1+x)).unipolar;
		ou2;
	};
	ou = ou /8;
	ou = Splay.ar(ou, 1, amp);
	ou = ou * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, ou);
}).add;

SynthDef(\dubdrone4x, { arg out=0, gate=1, amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
						 
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = Duty.kr(1/8/~t, 0, Dseq([
		[0,4,7,12],
		[0,4,7,10],
		[0,7,10,-12],
		[0,3,7,10],
	].midiratio,inf)) * pitch_stretch;
	//time_stretch = 0;
	//trate = 100;
	pos = SinOsc.kr(1/16*~t,pi).range(0,1) * 0.0004 * [1,1.1] + pos;
	//pos = EnvGen.ar(Env([0,0.4,0.2],[0.4,0.2]),LFPulse.kr(1/1*~t),doneAction:0);
	//pos = pos + EnvGen.ar(Env([0,0.2,0.4],[0.4,0.1]),LFPulse.kr(1*~t).poll,doneAction:0).poll;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou = Pan2.ar(ou, SinOsc.kr(1/48,[0,pi]).unipolar).flop;
	ou = [
		[300,350] * SinOsc.kr(1/8*~t).range(1,1.2),
		[1300,1350],
		[7300,7350],
	].collect { arg x, idx;
		ou1 = RHPF.ar(ou, x[0],0.3);
		ou2 = RLPF.ar(ou1, x[1],0.3);
		ou2 = ou2 * SinOsc.kr(1/(1+x)).unipolar;
		ou2;
	};
	ou = ou /8;
	ou = Splay.ar(ou, 1, amp);
	ou = ou * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, ou);
}).add;

SynthDef(\bassgrise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([0,1,0],[2.1,0.8]), 1);
	sig = SinOsc.ar(freq * [1,1 + ( env1 * \det.kr(0.1) )] * ( SinOsc.ar(freq * 1 + \fmdet.kr(0.01)) * 0.1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\chovar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.01,1.3]), 1);
	sig = LFSaw.ar(freq * [1,1 + \det.kr(0.0001)]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\organ, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Pulse.ar(freq * [1,1.0001, 2/3],mul: [1,1,1/3]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\wavechord, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	lfo1 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	lfo2 = Duty.kr(1/8/~t * LFNoise1.kr(1/3).range(0.001,4), 0, Dseq([
		1,0,1.5,0.5,0,2,
	],inf)).lag(0.251);
	env1 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	env2 = EnvGen.kr(Env([1,2,0.71],[Rand(0.1,0.7),Rand(0.4,1.7)]), 1);
	sig1 = SinOsc.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/7!3).range(0,1);
	sig1 = sig1.mean;
	sig2 = LFSaw.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/8!3).range(0,1);
	sig2 = sig2.mean;
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig3 = LFPulse.ar(freq * [1/2,1,2]) * LFNoise1.kr(1/9!3).range(0,1);
	sig3 = sig3.mean;
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * env2 * freq, \rq.kr(0.5));
	sig = SelectX.ar( lfo1, [sig1, sig2, sig3] ) * 1;
	sig = [sig, SelectX.ar( lfo2, [sig1, sig2, sig3] ) * 1];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.4)), gate, doneAction:2);
	sig = sig * amp * 2;

	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\grancru, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, mbufnum, gdur=0.1, gfreq=8, pos=0, pitch_stretch=1;
	var sig;
	var clk = Impulse.ar(gfreq);
	pos = pos + LFNoise1.ar(gfreq,mul:0.01);
	//pitch_stretch = pitch_stretch + LFNoise1.ar(10, mul:0.1);
	sig = TGrains.ar(2, clk, mbufnum, pitch_stretch, pos % BufDur.kr(mbufnum), gdur, pan, 1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\simpleacid, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1],[0.01,0.8])), 1);
	sig = LFSaw.ar(freq + [ [0,0.0001] ] * [1,1/2,2]).sum;
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq * env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\stepchord1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(\lfo1dur.kr(1/4/~t), 0, Dseq(\lfo1seq.kr([
		1,2,4,3/2,
	]),inf));
	lfo2 = Duty.kr(\lfo2dur.kr(1/3/~t), 0, Dseq(\lfo2seq.kr([
		1,2,4,3/2,
	]),inf));
	freq = freq * [1/2,1,lfo2, lfo1];
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig2 = BPF.ar(sig2, freq * SinOsc.kr(\bp1fmf.kr(1/2),mul:\bp1amp.kr(1/2), add:1), 0.5 * SinOsc.kr(1/13).range(1.4,1/4));
	sig3 = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	sig3 = BPF.ar(sig3, freq * SinOsc.kr(\bp2fmf.kr(1/3),mul:\bp2amp.kr(1/2), add:1), 0.5 * SinOsc.kr(1/7).range(1.4,1/4));

	sig = [sig1,sig2, sig3].mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\stepchord2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.ar(1 / \lfofreq1.kr(1/4/~t), 0, Dseq([
		1,2,4,3/2,
	],inf));
	lfo2 = Duty.ar(1 / \lfofreq2.kr(1/4/~t), 0, Dseq([
		1/2,1,2,4,3/2,
	],inf));
	freq = freq * [2,1,lfo2, lfo1];
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig2 = BPF.ar(sig2, freq * SinOsc.kr(1/2).range(0.5,2), 0.5 * SinOsc.kr(1/13).range(1.4,1/4));
	sig3 = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 1 ));
	sig3 = BPF.ar(sig3, freq * SinOsc.kr(1/3).range(0.5,2), 0.5 * SinOsc.kr(1/7).range(1.4,1/4));
	sig4 = SinOsc.ar(freq).fold2( EnvGen.kr(Env([0,0.1,1,0.01],[Rand(0.01,0.4), Rand(0.01,0.4), Rand(0.21,2)]), 1) )*0.7;

	sig = ( [sig1,sig2, sig3, sig4] * LFNoise1.kr([1/17,1/13,1/16, 1/20]).range(0.0,1) ).mean * 3;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,8.1,0.2,2.1,1,-1)), gate, doneAction:2);
	pan = pan + LFNoise1.ar(1/2!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;


SynthDef(\chordlock1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	sig = SinOsc.ar(freq * ( Gendy1.ar(freq * [1,1.01,1.001] * Gendy2.ar(1)) * 0.1 * env1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\chordlock2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1],[0.1,3.8])), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1,1/20,1],[0.1,3.8])), 1);
	env2 =  ( Gendy1.ar(freq * [1,1.01,1.001] * env3 * Gendy2.ar(1)) * \fmamp.kr(0.1) * env1 + 1 );
	sig1 = SinOsc.ar(freq * env2);
	sig2 = LFSaw.ar(freq * env2);
	sig3 = SinOsc.ar(freq * ( sig1 * 0.1 + 1 ));
	sig = SelectX.ar(\mix.kr(0.7)*2, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig + BPF.ar(sig, \bpfr.kr(3.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\chordlock3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1],[0.1,3.8])), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1,1/20,1],[0.1,3.8])), 1);
	env2 =  ( Gendy1.ar(freq * [1,1.01,1.001] * env3 * Gendy2.ar(1)) * \fmamp.kr(0.1) * env1 + 1 );
	env4 = EnvGen.kr(\env4.kr(Env([0,0.3,1],[0.5,8.8])), 1);
	sig1 = SinOsc.ar(freq * env2);
	sig2 = LFSaw.ar(freq * env2);
	sig3 = SinOsc.ar(freq * ( sig1 * 0.1 + 1 ));
	sig = SelectX.ar( env4, [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig + BPF.ar(sig, \bpfr.kr(3.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\basslok, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Pulse.ar(freq * [1,1.00001]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.9)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\tassbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq) * LFSaw.ar(freq+0.1) ;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\chordo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// TODO: cleanup tempo ref and add parameters
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.1,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,4,7].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 4.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 7.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [3/4,5/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,4,7,7-12,4-24].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,4,7,7-12].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = RLPF.ar(sig, env2 * 1000, 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
	SynthDef(\perctone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
		var sig;
		var pop, popFreq, popAmp;
		var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
		var env1, env2, env3, env4, env5, env6, env7, env8;
		env1 = EnvGen.kr(Env([2,1,1/4],[0.13,0.04],-1), 1);
		sig = LFPulse.ar(freq) + LFSaw.ar(freq+[0,10.101*env1]).mean /2;
		sig = sig + SinOsc.ar(freq * [1,2,1/2], mul:env1.lag(1)).mean / 2; 
		sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * env1, \rq.kr(0.5));
		sig = ( sig * env1 ).distort;

		popFreq = XLine.kr(350, 61, 0.02);
		popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
		pop = SinOsc.ar(popFreq) * popAmp;
		sig = sig + pop;

		sig1 = SinOsc.ar(freq*2);
		sig1 = LPF.ar(sig1, freq * EnvGen.kr(Env([1,1/2,1/4],[0.01,0.8]), 1));
		sig = sig + sig1;

		sig1 = WhiteNoise.ar;
		sig1 = LPF.ar(sig1, EnvGen.kr(Env([10000,710,100],[0.01,0.8], -4), 1));
		sig1 = HPF.ar(sig1, Rand(700,800.0));
		sig1 = Ringz.ar(sig1, freq, 0.1)/6;
		sig = sig + sig1;

		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.1)), gate, doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;
SynthDef(\longf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.1,1);
	env3 = EnvGen.kr(\freqenv.kr(Env([1,1,1/2,1,1/2],[1/8/~t,0.01,2.0/3 - ( 1/8 )/~t,0.01], [0,0,2,0,0])), 1);
	freq = freq * env3;
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,4,7].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 4.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 7.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [3/4,5/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,4,7,7-12,4-24].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,4,7,7-12].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	//sig = RLPF.ar(sig, env2 * 1000, 0.5 / (1+ env2 ));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\conga, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3, sig4, sig5;
	sig1 = LFTri.ar(111);
	sig1 = FreqShift.ar(sig1, 175);
	sig1 = sig1 + FreqShift.ar(sig1, [224 * \harm2.kr(1),224 * \harm1.kr(1)]);
	sig1 = sig1 * EnvGen.ar(Env.perc(0.0001,0.22), gate);

	sig2 = SinOsc.ar(330) + SinOsc.ar(180);
	sig2 = sig2 * EnvGen.ar(Env.perc(0.0001,0.151), gate);

	sig3 = PinkNoise.ar(1);
	sig3 = BRF.ar(sig3, [100,800,300,400]*2).sum;
	sig3 = LPF.ar(sig3, [5000,6000,100,10000]*1);
	sig3 = sig3 * EnvGen.ar(Env.perc(0.0001,0.201, 1, \sqr), gate);

	sig4 = WhiteNoise.ar(1);
	sig4 = BRF.ar(sig4, [100,900,300,400]*4).sum;
	sig4 = LPF.ar(sig4, [500,4000,100,1000]*2*XLine.kr(1,0.100,0.01));
	sig4 = sig4 * EnvGen.ar(Env.perc(0.0001,0.251, 1, \cub), gate);

	sig5 = PinkNoise.ar(1) * sig2;
	//sig5 = BRF.ar(sig5, [100,800,300,400]*2).sum;
	sig5 = LPF.ar(sig5, [500,600,100,1000]*0.21);
	sig5 = sig5 * EnvGen.ar(Env.perc(0.0001,0.111, 1, \sqr), gate) * 4;

	sig = sig1 + sig3 + sig4 + sig5;
	//sig = (HPF.ar(sig,100)*14).distort + LPF.ar(sig, 100);
	sig = sig * 2;




	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.0001,0.1,0.8,2.4)),gate,doneAction:doneAction);
	//sig = DetectSilence.ar(sig, doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\aigu, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\fzion, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,1.2]), 1);
	env2 = EnvGen.kr(Env([1,1.5,3/4],[0.1,1.2]), 1);
	freq = freq * [1,2,2.001];
	sig = LFPulse.ar(freq  * ( SinOsc.ar(freq * env2) * 0.9 + 1 ));
	sig = RHPF.ar(sig, 4000 ,0.3);
	sig = RLPF.ar(sig, 2400* env1,0.3);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/10, mul:0.1);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\fzion2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1.9,2,1],[0.1,1.4]), 1);
	env2 = EnvGen.kr(Env([1.2,1.1,3/4],[0.1,1.4]), 1);
	freq = freq * [1,1.01];
	sig1 = LFCub.ar(freq*2 * env2 * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(4.5) + 1 ));
	//sig = sig.fold2(env2 * 0.5)+( sig * 0.1 );
	sig1 = CombL.ar(sig1, 0.2,1/2100 / env2,0.1)+sig1;
	sig1 = sig1/4;
	sig1 = RHPF.ar(sig1, 800 * env1 ,0.7);
	sig1 = RLPF.ar(sig1, 1440,0.8);
	sig2 = LFCub.ar(freq * env2);
	sig2 = RHPF.ar(sig2, 300 ,0.9);
	sig2 = sig2.tanh;
	sig = [sig1, sig2].sum;
	//sig = sig1;
	sig = sig /1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/10, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\fzion3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1.9,2,1],[1.1,1.4]), 1);
	env2 = EnvGen.kr(Env([0.2,4.1,3/4],[0.1,1.4]), 1);
	freq = freq * [1,1.21,5/8];
	sig1 = LFCub.ar(freq * env2 * ( SinOsc.ar(freq * \fmr.kr(1)) * \fmamp.kr(4.5) + 1 )) *  SinOsc.kr([1,2,3]).range(0.2,1);
	//sig = sig.fold2(env2 * 0.5)+( sig * 0.1 );
	//sig1 = CombL.ar(sig1, 0.2,1/2100 / env2,0.1)+sig1;
	sig1 = sig1/8;
	sig1 = RHPF.ar(sig1, 800 * env1 ,0.7);
	sig1 = RLPF.ar(sig1, 9440,0.8);
	sig2 = LFCub.ar(freq * env2);
	sig2 = RHPF.ar(sig2, 300 ,0.9);
	sig2 = sig2.tanh * 0.1;
	sig = [sig1, sig2].sum;
	sig = sig / 80;
	//sig = sig1;
	//sig = sig /1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/10, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	sig = Limiter.ar(sig, 0.2);
	Out.ar(out, sig);
}).add;
SynthDef(\fzion4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1.9,2,1],[1.1,1.4]), 1);
	env2 = EnvGen.kr(Env([0.2,4.1,3/4],[0.1,1.4]), 1);
	sig1 = SinOsc.ar(freq * [1,1+( env2/8 )] * ( SinOsc.ar(72 * env2) * 0.1 + 1 )); 
	sig2 = LFSaw.ar(freq); 
	sig2 = RLPF.ar(sig2, \lpfr.kr(3.1) * freq, \rq.kr(0.5));
	sig = [sig1, sig2].sum;
	sig = sig / 5;
	//sig = sig1;
	//sig = sig /1;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + SinOsc.ar((1..sig.size)/2, 0.5, mul:0.3);
	sig = Pan2.ar(sig, pan, amp).mean;
	//sig = Limiter.ar(sig, 0.2);
	Out.ar(out, sig);
}).add;
SynthDef(\stringsx, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
//From SC Examples Folder
// some small pieces
// Julian Rohrhuber, 2007
					var env, in, delay, f1, f2;
					f1 = freq.lag(freqLag);
					f2 = freq.lag(freqLag * 0.5);
					delay = 0.25 / f2;
					env = \adsr.kr(Env.adsr(0.1,0.1,0.8,0.1));
					in = WhiteNoise.ar(180);
					in = CombL.ar(in, delay, delay, 1);
					in = Resonz.ar(in, f1, 0.001).abs;
					in = in * EnvGen.kr(env, gate, doneAction:2);
					Out.ar(out, Pan2.ar(in, pan, amp));

}).add;
SynthDef(\stringsx3, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var env, in, delay, f1, f2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	f1 = freq.lag(freqLag);
	f2 = freq.lag(freqLag * 0.5);
	env1 = EnvGen.kr(Env([1,1/2,2,1/2],[0.051,0.4,1]), 1);
	delay = 0.25 / f2;
	env = \adsr.kr(Env.adsr(0.1,0.1,0.8,0.1));
	sig = WhiteNoise.ar(18);
	sig = CombL.ar(sig, delay, delay, 1);
	sig = Resonz.ar(sig, f1, 0.001).abs;
	sig2 = BPF.ar(sig, f2*env1, 0.1,mul:1)*2;
	sig2 = Normalizer.ar(sig2, 0.4,0.0001);
	sig2 = HPF.ar(sig, 300)*8;
	//sig = sig + sig2;
	sig = sig2;
	sig = sig * EnvGen.kr(env, gate, doneAction:2);
	Out.ar(out, Pan2.ar(sig, pan, amp));

}).add;
SynthDef(\stringsx2, { arg out, freq=440, amp=0.8, gate=1, pan, freqLag=0.2;
//From SC Examples Folder
// some small pieces
// Julian Rohrhuber, 2007
					var env, in, delay, f1, f2;
					var env1, env2, env3, env4, env5, env6, env7, env8;
					f1 = freq.lag(freqLag);
					f2 = freq.lag(freqLag * 0.5);

					env1 = EnvGen.kr(Env([1,1.12,1],[0.051,0.8]), 1);
					delay = 0.25 / f2;
					env = \adsr.kr(Env.adsr(0.1,0.1,0.8,0.1));
					in = WhiteNoise.ar(180);
					in = CombL.ar(in, delay, delay * SinOsc.kr([1,2]).range(0.1,1) , 1);
					in = Resonz.ar(in, f1 * env1, 0.001).abs;
					in = in * EnvGen.kr(env, gate, doneAction:2);
					Out.ar(out, Pan2.ar(in, pan, amp).mean);

}).add;
SynthDef(\hihat_electro, {
    |out = 0, pan = 0, amp = 0.3|
    var click, clickAmp;
    var noise, noiseAmp;
    var snd;

    // noise -> resonance -> expodec envelope
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.3, curve: -8), doneAction: 2);
    noise = Mix(BPF.ar(ClipNoise.ar, [4010, 4151], [0.15, 0.56], [1.0, 0.6])) * 0.7 * noiseAmp;

    snd = noise;

    Out.ar(out, Pan2.ar(snd, pan, amp));
//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;
SynthDef(\snare_electro, {
    |out = 0, pan = 0, amp = 0.3|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    // bandpass-filtered white noise
    noiseAmp = EnvGen.ar(Env.perc(0.001, 0.15), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

    snd = (pop + noise) * 1.3;

    Out.ar(out, Pan2.ar(snd, pan, amp));
//By Nathan Ho aka Snappizz
//http://sccode.org/1-523
}).add;
SynthDef(\basicpadfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,4.8])), 1);
	env2 = EnvGen.kr(\fmenv.kr(Env([0,2,1],[4.1,4.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)] * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));
	sig2 = LFSaw.ar(freq * [1,1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(8000) * env1);
	sig2 = sig2 * 1;
	sig = SelectX.ar(\oscmix.kr(0.5), [sig1, sig2]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\dubdrone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( 1 + ( SinOsc.ar(freq*1.123) * 1 ))) * LFSaw.ar(freq*4/3 * SinOsc.kr(1/12).range(1.1,1)) ;
	sig = RLPF.ar(sig, 3000 * LFNoise1.ar(1/13!4).range(1/4,4), \rq.kr(0.5) * LFNoise1.ar(1/13!4).range(1/4,2)).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\chordo2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.2,1],[0.1,0.8]), 1);
	env2 = SinOsc.ar(8/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.1,1);
	env2 = SinOsc.ar(1/1.5*~t * ( SinOsc.kr(1*~t,Rand(0,2)) * 1 + 1 )).range(0.9,1);
	sig1 = SinOsc.ar(freq* [1,1.0001,1/2,1/4] * [0,4,7].midiratio/4)* EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig2 = SinOsc.ar(freq/2 * [1,2,1/2] * 4.midiratio).fold(env1) * 0.4;
	sig3 = LFSaw.ar(freq * [1,1.01,1.006,1/2,1/4] * 7.midiratio) * EnvGen.kr(Env([0,0.51,0],[1.1,2.8], 4), 1);
	sig3 = RLPF.ar(sig3, \lpfr.kr(2.1) * EnvGen.kr(Env([1,1/2,2,1],[2,2.1,2.8]), 1) * freq, \rq.kr(0.5));
	sig4 = SinOsc.ar(freq * [3/4,5/4]) * EnvGen.kr(Env([0,0.41,0],[0.01,0.2]), 1);
	sig5 = SinOsc.ar(freq+0.1 * [0+12,4,7,7-12,4-24].midiratio/2 * ( LFSaw.ar(freq/2) * 0.4 + 1 )) * EnvGen.kr(Env([0,0.41,0],[0.1,1.5]), 1);
	sig6 = SinOsc.ar(freq*1.001 * [1,1/2,2,1/8]  * ( SinOsc.ar(freq* [0+12,4,7,7-12].midiratio/2) * 1.4 + 1 )) * EnvGen.kr(Env([0,0,0.41,0],[0.3,0.8,6.5]), 1);
	sig6 = HPF.ar(sig6, 1000 * EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1)) + BPF.ar(sig6, 70);
	sig = sig1 + sig2 + sig3 + sig4 + sig5 + sig6;
	sig = RLPF.ar(sig, env2 * 1000, 0.5 / (1+ env2 )) + ( sig/1.72 );
	sig = HPF.ar(sig, env1 * \hpf.kr(1000));
	sig = AllpassL.ar(sig, 0.4,0.01 * [1,0.6,0.7,1.1],4.5) + ( sig * 2 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,5.8)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\hipass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( SinOsc.ar(\fmf1.kr(3) * ( SinOsc.ar(\fmf2.kr(4)) * 1 + 1 )) * 1 + 1 ));
	sig = HPF.ar(sig, \hpf.kr(7000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\hipasswide, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001] * ( SinOsc.ar(\fmf1.kr(3) * ( SinOsc.ar(\fmf2.kr(4)) * 1 + 1 )) * 1 + 1 ));
	sig = HPF.ar(sig, \hpf.kr(7000));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1] * \stereo.kr(1), amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\plouc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,6/4],[0.01,0.08]), 1);
	sig = SinOsc.ar(freq * env1);
	sig = sig.fold(0.2);
	sig = DelayL.ar(sig, 0.1,\delay.kr(0.01))+sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\chordodo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[4.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * [1,1.00001]);
	sig2 = LFSaw.ar(freq * [1,1.00001]);
	sig2 = sig2 * EnvGen.kr(Env([0,1,0],[1.1,1.8]), 1);
	sig2 = HPF.ar(sig2, \hpf.kr(8000) * env1);
	sig = [sig1, sig2].sum / 2;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\snaretuned2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,1010,1831,1000],[0.01,0.04,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env3 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	sig = pop + ( sig/2 );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.01,0.9)) + LPF.ar(WhiteNoise.ar(0.1), env3);
	sig = ( pop/2 ) + ( sig );
	sig = BPF.ar(sig, [130,220], 0.1).mean + sig; // eq

	// tonal component
	sig2 = SinOsc.ar([180, 330]*1.2).sum;
	sig3 = LFTri.ar(111);
	sig3 = FreqShift.ar(sig3, [175, 224]*1.3).sum;
	sig4 = sig2 + sig3 / 48;

	sig = sig + sig4 / 1.2;
	sig = HPF.ar(sig, env2);
	sig = sig * SinOsc.ar(1000); 



	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\organ, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = Pulse.ar(freq * [1,1.0001, 2/3],mul: [1,1,1/3]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\basicbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = BPF.ar(sig, freq * env1, 0.1).tanh + sig;

	//sig = sig;
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig.debug("basicbas");
	sig = Splay.ar(sig, spread, amp, pan);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	Out.ar(out, sig);
}).add;
SynthDef(\kalimba, {
	//Kalimba based on bank of ressonators
    |out = 0, freq = 440, amp = 0.1, mix = 0.1, relMin = 2.5, relMax = 3.5|
    var snd;
    // Basic tone is a SinOsc
    snd = SinOsc.ar(freq) * EnvGen.ar(Env.perc(0.005, Rand(relMin, relMax), 1, -8), doneAction: 2);
    // The "clicking" sounds are modeled with a bank of resonators excited by enveloped pink noise
    snd = (snd * (1 - mix)) + (DynKlank.ar(`[
        // the resonant frequencies are randomized a little to add variation
        // there are two high resonant freqs and one quiet "bass" freq to give it some depth
        [240*ExpRand(0.9, 1.1), 2020*ExpRand(0.9, 1.1), 3151*ExpRand(0.9, 1.1)],
        [-7, 0, 3].dbamp,
        [0.8, 0.05, 0.07]
    ], PinkNoise.ar * EnvGen.ar(Env.perc(0.001, 0.01))) * mix);
    Out.ar(out, Pan2.ar(snd, 0, amp));
//By Nathan Ho aka Snappiz
//http://sccode.org/1-51l
}).add;
SynthDef(\iron, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	// cpu light
	// freq clipped
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq * ( LFSaw.ar(( freq * \fmr.kr(4) * ((0..7)/7 - 0.5 * \diff.kr(1) + 1) ).clip(20,19000)) * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = sig.fold( SinOsc.ar( (1..8)/8 * \foldfreq.kr(1), (1..8) ) * \foldlevel.kr(1) + \foldbias.kr(1) ).flop.mean;
	sig.debug("sig");
	env1 = EnvGen.kr(\env1.kr(Env(2.01-[1,2,1],[0.1,0.8])), \trigenv.tr(1));
	sig = RLPF.ar(sig, ( \lpfr.kr(1.7) * env1 * freq ).clip(20,19000), \rq.kr(0.5));
	pan = pan + (sig.collect({ arg x;
		SinOsc.kr(1/( x+1 ) * \panfreq.kr(1));
	}) * \panwidth.kr(1));
	sig = LeakDC.ar(sig);
	sig = HPF.ar(sig, \hpf.kr(10));
	sig = sig * \gain.kr(18);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	env1: XEnvSpec(),
))).add;
SynthDef(\phyhat4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,1100,2051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,4200,7451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, [900,1030,1410,8000.14,5000] * env3, 0.001).mean/10;
	env1 = EnvGen.kr(Env([881,7810,251],[0.01,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18000,14800,1001],[0.01,0.8*\fac1.kr(1)],[1,-1]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = HPF.ar(sig, env1);
	sig = LPF.ar(sig, env2);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.4,1,-4) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;

SynthDef(\organ_tonewheel0, {
	//additive tonewheel organ with few CPU usage

	arg out=0,freq = 440, amp = 0.7, atk = 0.001, sus = 0.2, rel = 0.01, pan = 0,
	bass = 1, quint = 1, fundamental = 1, oct = 1, nazard = 1, blockFlute = 1, tierce = 1, larigot = 1, sifflute = 1, //organ voices (drawbars) amplitudes
    vrate = 3, vdepth = 0.008; //vibrato arguments
	var sig, env, vibrato;

	vibrato = SinOsc.kr(DC.kr(vrate)).range(1 - DC.kr(vdepth), 1+ DC.kr(vdepth));
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction: Done.freeSelf);
	sig = DynKlang.ar(`[[1/12,  1/7, 1, 12, 19, 24, 28, 31, 36].midiratio, ([DC.ar(bass) , DC.ar(quint), DC.ar(fundamental), DC.ar(oct), DC.ar(nazard), DC.ar(blockFlute), DC.ar(tierce), DC.ar(larigot), DC.ar(sifflute)].normalizeSum), nil], vibrato * freq);

	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
//By Zé Craum
}).add;

SynthDef(\organ_tonewheel1, {
	//additive tonewheel organ with more CPU usage

	arg out=0,freq = 440, amp = 0.7, atk = 0.001, sus = 0.2, rel = 0.01, pan = 0,
	bass = 1, quint = 1, fundamental = 1, oct = 1, nazard = 1, blockFlute = 1, tierce = 1, larigot = 1, sifflute = 1, //organ voices (drawbars) amplitudes
    vrate = 3, vdepth = 0.008, vdelay = 0.1, vonset = 0, vrateVariation = 0.1, vdepthVariation = 0.1; //vibrato arguments
	var sig, env, vibrato;

	vibrato = Vibrato.kr(DC.kr(freq), DC.kr(vrate), DC.kr(vdepth), DC.kr(vdelay), DC.kr(vonset), DC.kr(vrateVariation), DC.kr(vdepthVariation));
	env = EnvGen.ar(Env.linen(atk, sus, rel), doneAction: Done.freeSelf);
	sig = DynKlang.ar(`[[1/12,  1/7, 1, 12, 19, 24, 28, 31, 36].midiratio, ([DC.ar(bass) , DC.ar(quint), DC.ar(fundamental), DC.ar(oct), DC.ar(nazard), DC.ar(blockFlute), DC.ar(tierce), DC.ar(larigot), DC.ar(sifflute)].normalizeSum), nil], vibrato);

	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
//By Zé Craum
}).add;


SynthDef(\organ_tonewheel2, {
	//subtractive tonewheel organ with cheap CPU usage
	arg out=0,freq = 440, amp = 0.9, atk = 0.001, sus = 0.4, rel = 0.1, tune = 0.29, tuneRate = 6.0, rq = 1;
	var sig, env, vibrato;
	env = EnvGen.ar(Env.linen(atk, sus, rel, 0.5), doneAction: Done.freeSelf);
	vibrato = SinOsc.ar(tuneRate).range(freq, freq * (tune.midiratio));
	sig = LFPulse.ar(freq, 0, 0.5, 0.2) + LFPulse.ar(freq + vibrato, 0, 0.18);
	sig = RLPF.ar(sig /*+ PinkNoise.ar(20/freq) */, ((28.midiratio) * (freq)) , rq) ;

	sig = sig * env;
	sig = sig * amp;
	sig = LeakDC.ar(sig);
	Out.ar(out, sig!2);
//By Zé Craum
}).add;



SynthDef(\organ_tonewheel3, {
	//subtractive tonewheel organ with more CPU usage
	arg out=0,freq = 440, amp = 0.9, atk = 0.001, sus = 0.4, rel = 0.1, vrate = 6, vdepth = 0.02, vdelay = 0.1, vonset = 0, vrateVariation = 0.1, vdepthVariation = 0.1, rq =1;
	var sig, env, vibrato;
	env = EnvGen.ar(Env.linen(atk, sus, rel, 0.5), doneAction: Done.freeSelf);
	vibrato = Vibrato.kr(DC.kr(freq), DC.kr(vrate), DC.kr(vdepth), DC.kr(vdelay), DC.kr(vonset), DC.kr(vrateVariation), DC.kr(vdepthVariation));
	sig = LFPulse.ar(freq, 0, 0.5, 0.2) + LFPulse.ar(freq + vibrato, 0, 0.18);
	sig = BLowPass4.ar(sig, ((28.midiratio) * (freq)) , rq) ;

	sig = sig * env;
	sig = sig * amp;
	sig = LeakDC.ar(sig);
	Out.ar(out, sig!2);

//By Zé Craum
}).add;


SynthDef(\organ_tonewheel4,{|out= 0 freq = 440 amp = 0.1 gate=1 lforate = 4.85 lfowidth= 0.1 cutoff= 5000 rq=0.25 pan = 0.0|
//Subtractive tonewheel organ from Steal this Sound example
	var lfo, pulse, filter, env;

	lfo = LFTri.kr(lforate*[1,1.01],Rand(0,2.0)!2);

	pulse = Pulse.ar( (((freq*[1,3]).cpsmidi) + (lfo*lfowidth)).midicps,[0.5,0.51],[0.4,0.6]);

	env = EnvGen.ar(Env.adsr(0.0,0.0,1.0,0.1),gate,doneAction:2);

	filter = BLowPass4.ar(pulse,cutoff,rq);

	filter= BPeakEQ.ar(filter,500,1.0,3);

	Out.ar(out,Pan2.ar(Mix(filter)*env*amp,pan));

//By Nick Collins, from Mitchell Sigman (2011) Steal this Sound
//http://www.sussex.ac.uk/Users/nc81/index.html
}).add;
	SynthDef(\cymbalsimple, { | out = 0, pan = 0.0, amp=0.1 |
		var sig, env;
		var env1, env2, env3, env4, env5, env6, env7, env8;
		env1 = EnvGen.kr(Env([1,0.02,1],[0.01,1.8]), 1);
		env = EnvGen.ar(Env.perc(0.001, 2, curve: -4), doneAction: 2);
		sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), {exprand(1000, 20000)}.dup(100), env1).mean, 4000);
		sig = BPF.ar(WhiteNoise.ar(1), 1900, 0.4) + sig;
		sig = sig * amp;
		Out.ar(out, Pan2.ar(sig * env, pan));
	}).add;

SynthDef(\oneone, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, timeScale=(1/~t);
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var diff;
	env1 = EnvGen.kr(Env([0,1,10],[0.81,0.09]*2), 1, timeScale:timeScale);
	env2 = EnvGen.kr(Env([0,0.0,1],[1,0.09]), 1, timeScale:timeScale);
	env3 = EnvGen.kr(Env([0.4,1.2,0.71],[1,0.99]), 1, timeScale:timeScale);
	diff= [1+env2,1-env2];
	sig = LFSaw.ar(freq * ( SinOsc.ar(freq * 4/5 * diff) * env1 + 1 )) * SinOsc.ar(\lfo.kr(8*~t)).range(0,1) ;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env3 * freq, \rq.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\oneone2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, timeScale=(1/~t);
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var diff;
	env1 = EnvGen.kr(Env([0,1,0],[0.81,0.09]*2), 1, timeScale:timeScale);
	env2 = EnvGen.kr(Env([0,0.0,1],[1,0.09]), 1, timeScale:timeScale);
	diff= [1+env2,1-env2];
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * 4/5 * diff) * env1 + 1 )) * SinOsc.ar(\lfo.kr(8*~t)).range(0,1) ;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);
