(
SynthDef(\simplebass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var in;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1.2,1],[0.1,1.8]), 1);
	sig = LFSaw.ar(freq * [1,1.0001,1.001]);
	sig = sig + LFPulse.ar(freq * [1,1.0001,1.001]);
	sig = sig / 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = BPF.ar(sig, freq * env1, 0.1).tanh + sig;

	in = InFeedback.ar(\inbus.kr(BusDef(\mixer0, \audio)), 2); 
	in = in + InFeedback.ar(\inbus2.kr(BusDef(\mixer1, \audio)), 2); 
	sig1 = 3.0 * Compander.ar(sig, in, \cpt.kr(0.01), \cpbelow.kr(1.001), \cpabove.kr(0.0009), \cpclamp.kr(0.01), \cprelax.kr(0.01));
	sig = SelectX.ar(\compmix.kr(1), [sig, sig1]);
	//sig = sig;
	sig = RLPF.ar(sig, \lpf.kr(100), \rq.kr(0.5));
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\rix, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fspread=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,2,1.7],[0.1,0.8]), 1).round(0.11);
	env3 = EnvGen.kr(Env([1,1,1.1],[0.8,0.8]), 1).round(0.1141);
	sig = LFSaw.ar(freq * env2 * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig + Pulse.ar(freq/2 * env3 * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig + SinOsc.ar(freq*2.12 * env2 * ((0..7)/7 - 0.5 * fspread + 1));
	sig = RHPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig.fold2(1.1 *env1);
	sig = sig /1.52;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\playersec_zix, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1;
	// pos in seconds
	var sig;
	var sig1;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	env2 = EnvGen.kr(Env([1,0.5,0],[0.1,0.8]), 1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufSampleRate.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = FreqShift.ar(LPF.ar(sig, 4000), 2300) + HPF.ar(sig, 4000);
	sig = HPF.ar(sig, 6000)*18;
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}).add;
SynthDef(\chordb, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = {arg x; 
		var isig;
		var ffac = 8;
		isig = LFSaw.ar( freq/2 * x + ExpRand(freq/64,2*freq/64));
		isig = isig + LFPulse.ar( freq/ffac * x + ExpRand(freq/64/ffac,2*freq/64/ffac));

		isig = RLPF.ar(isig, freq/2 * x + ExpRand(freq/64,2*freq/64)* LFNoise1.kr(1/4).range(1.1,1) * \lpffac.kr(2) , \rq.kr(0.5));
	}!5;
	sig = sig.scramble;
	sig = TScramble.ar(sig, Impulse.kr(4),1);
	//sig = FreqShift.ar(sig, 4 * SinOsc.kr(1/45).range(0,1)) + sig;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan) / 7;
	Out.ar(out, sig);
}).add;
SynthDef(\snaretuned, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var pop, popAmp, popFreq;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;

	popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
	popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
	pop = SinOsc.ar(popFreq * ( 1 + ( SinOsc.ar(410) * 0.4 ))) * popAmp;
	env1 = EnvGen.kr(Env([1840,2010,1831],[0.01,0.4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
	env2 = EnvGen.kr(Env([411,150,245],[0.01,0.7],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.9,1.1) );
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
SynthDef(\distbass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\distbasspoly, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\dischord, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = [0,1,2,3,4,5].midiratio * freq;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,1.1)),Trig.kr(\itrig.tr(1), \tsustain.kr(0.1)),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	//sig = Splay.ar(sig, spread, amp, pan);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\cloche, { arg out=0, gate=1, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = Dust.ar(10 * SinOsc.kr(1/8).range(10,1/2));
	sig1 = Ringz.ar(sig1, Rand(100,10000.0!8) * LFNoise0.kr(1/2).range(1/4,1), 1.1).mean/2;
	sig2 = Dust.ar(7);
	sig2 = Ringz.ar(sig2, Rand(100,10000.0!8), 1.1).mean/2;
	sig = sig1 + sig2;
	sig = sig * EnvGen.kr(Env([0,1,0],[0.1,2.8]), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\phyhat2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,200,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = HPF.ar(sig, 20000-env2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\phyhat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,200,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, [9400,17030,16410,8000.14,15000] * env3, 0.001).mean/10;
	env1 = EnvGen.kr(Env([8821,1810,251],[0.01,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([13820,15800,151],[0.01,0.8*\fac1.kr(1)],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = HPF.ar(sig, env1);
	sig = LPF.ar(sig, env2);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\phycymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fac1=1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig = WhiteNoise.ar;
	env1 = EnvGen.kr(Env([8210,4100,4051],[0.1,0.8]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([18210,200,451],[0.1,0.8],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = BPF.ar(sig, env1, LFNoise1.kr((1..8)/8).range(0.1,0.9));
	sig = HPF.ar(sig, 20000-env2);
	sig1 = sig;
	//sig = RLPF.ar(sig, env2, \rq.kr(0.5));
	sig = WhiteNoise.ar;
	env3 = EnvGen.kr(Env([1,0.9,1]*Rand(0.91,1.1),[0.01+Rand(0,0.1),0.8]), 1);
	sig = sig + Ringz.ar(sig, 0.2*[9400,17030,16410,8000.14,15000] * env3 * SinOsc.kr([1,2,3,4.2]/4).range(1.04,1), 0.001).mean/10;
	env1 = EnvGen.kr(Env([11821,78,4000,7251],[0.01,0.1,0.8*fac1],[4,-4]), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	env2 = EnvGen.kr(Env([8820,19800,17151],[0.07,0.8*fac1],-4), 1, levelScale:LFNoise1.kr((1..8)/8).range(0.7,1.1) );
	sig = HPF.ar(sig, env1);
	sig = LPF.ar(sig, env2);
	sig2 = sig*1.3;

	sig = sig1+sig2;

	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,1.8,1,-4) ),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\snapkick, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(Env([261, 60, 51], [0.035, 0.08], curve: \exp));
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
SynthDef(\snapkick2, { |out = 0, pan = 0, amp = 0.3|
	var body, bodyFreq, bodyAmp;
	var pop, popFreq, popAmp;
	var click, clickAmp;
	var snd;

	// body starts midrange, quickly drops down to low freqs, and trails off
	bodyFreq = EnvGen.ar(Env([561, 50, 51], [0.015, 0.08], curve: \exp));
	bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.1), doneAction: 2);
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
SynthDef(\cling, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1/2],[0.01,0.2],-3), 1);
	sig1 = ( 1 + ( SinOsc.ar(rrand(0.01,1000!4)) * rrand(0.1,10!4) ));
	sig = SinOsc.ar(rrand(100.0,1000!4) * env1 * ( 1 + ( SinOsc.ar(rrand(0.01,1000!4) * sig1) * rrand(0.01,10!4))));
	sig = sig * ( 1 + ( SinOsc.ar(rrand(100.0,1000!4)) * 1 ));
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = CombL.ar(sig, 0.01,1/rrand(100.0,1000!14)) + sig;
	sig = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,1.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean * 4;
	Out.ar(out, sig);
}).add;
);


(

		Pdef(\t1kick, Pdef(\kick) <> Pbind(
			\instrument, \snapkick,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,1,0,

				1,1,0,1, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		));
		Pdef(\t1kick2,Pdef(\kick) <> Pbind(
			\instrument, \snapkick2,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		));
		Pdef(\t1snare, Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\sustain, 0.1/2,
			\dur, 1/8,
			\amp, 0.1/1,
		));
		Pdef(\t1snare2, Pdef(\snare) <> Pbind(
			\instrument, \snaretuned,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,

				0,0,0,0, 1,0,0,1,
				0,1,0,0, 0,0,0,1,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\sustain, 0.011,
			\dur, 1/8,
			\amp, 0.04,
		));
		Pdef(\t1hat, Pdef(\hat) <> Pbind(
			\instrument, \phyhat,
			\isRest, Pseq([
				1,0,1,1, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,1,1,0,
				1,0,1,0, 1,0,1,0,

				1,0,1,1, 1,0,1,0,
				1,1,1,0, 1,0,1,1,
				1,1,1,0, 1,1,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\sustain, Pseq([0.08,0.02],inf),
			\fac1, Pseq([2,0.5,0.7,0.5]*0.5,inf),
			\pan, Pseq([0.2,0.1,0,-0.1],inf),
			\fac1, Pseq([
				0.5,Pser([
					0.04,
				],15),
				0.05,Pser([
					0.4,0.04,
				],15),
				
			],inf),
			\dur, 1/16,
			\dur, Pkey(\dur) * (1 + (-0.01 * Pseq([-1,1],inf))),
			\pan, 0,
			\amp, 0.05,
		));
		Pdef(\t1cym, Pdef(\hat) <> Pbind(
			\instrument, \phycymbal,
			\freq, 200,
			\isRest, Pseq([
				1,0,0,0,
			],inf).coin.not,
			\fac1, 8,
			\adsr, Pseq([
				[ Env.adsr(0.05,0.1,0.9,0.3,1,-4) ]
			],inf),
			\sustain, 0.2,
			\dur, 1,
			\amp, 0.05,
		));
		Pdef(\t1bass, Pdef(\bass)<>Pbind(
			\instrument, \simplebass,
			\freq, Pseq([
				85,86,87,70,
			],inf),
			\lpf, 200,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		));
		Pdef(\t1piano, Pdef(\piano) <> Pbind(
			\instrument, \rix,
			\freq, Pstep(Pseq([2200,2220,2240,1345],inf),1),
			\legato, Pstep(Pseq([
				1,0.4,
			],inf),1),
			\fspread, 4.0001,
			\dur, Pseq([1,1,1,1/2,1/2],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 0,1,1,1,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([
				1,1,1,1,
				1,1,1,2,
				1,1,1,1,
				1,1,1,4,
				1,1,1,1,
				1,1,1,2,
				1,1,16,16,
				4,1,1,2,
			],inf), 1),
			\amp, 0.1,
		));
		Pdef(\t1cling, Pdef(\pad) <> Pbind(\instrument, \cling,
			\degree, Pseq([0],inf),
			\legato, Pseq([
				0.1, 0.1, 0.7,0.1,
			],inf)/2,
			\dur, 2,
			\amp, 0.1,
		));
		Pdef(\t1voice, Pdef(\pad) <> Pbind(
			\instrument, Pseq([\playersec_zix],inf).stutter(8*4),
			\out, BusDef(\mixer5, \audio),
			\bufnum, BufDef('voices/feynman.flac'),
			\pos, Pseq([
				0,
				2,
			],inf).stutter(8),
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],4),
			],inf).coin.not,
			\speed, 1,
			\legato, Pseq([
				Pser([
					8.2,
				],8*2)*1,
			],inf),
			\gain, 0.6,
			\dur, 1/8,
			\amp, 0.1,
		));
);

(
	~master.();
Pdef(\part, Pdef(\t1_intro, 
	Ptpar([
		4, Pbind(
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,1,
			],inf).coin.not,
		) <> Pdef(\t1hat),
		0, Pbind(
			\dur,1,
		) <> Pdef(\t1piano),
		4, Pbind(
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur,1/8,
		) <> Pdef(\t1snare2),
		8, Pbind(
			\compmix, 0,
			\lpf, 3000,
			\isRest, Pseq([
				1,0,0,1,
			],inf).coin.not,
			\dur,1,
		) <> Pdef(\t1bass),
	])
)).play;
);

(
	~master.();
Pdef(\part, Pdef(\t1_outro, 
	Ppar([
		Pfindur(2,Pdef(\t1kick)),
		Pfindur(4,Pdef(\t1kick2)),
		Pfindur(2,Pdef(\t1snare)),
		Pfindur(4,Pdef(\t1snare2)),
		Pfindur(12,Pdef(\t1hat)),
		Pfindur(8,Pdef(\t1bass)),
		Pfindur(16,Pdef(\t1piano)),
	])
)).play;
);

(
	~master.();
Pdef(\part,Pdef(\t1_verse1, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1kick2),
		Pdef(\t1snare),
		Pdef(\t1snare2),
		Pdef(\t1hat),
		Pdef(\t1bass),
		Pdef(\t1piano),
	])
)).play;
);

(
Pdef(\part,Pdef(\t1_verse2, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1kick2),
		Pdef(\t1snare),
		Pdef(\t1snare2),
		Pdef(\t1hat),
		Pdef(\t1bass),
		Pdef(\t1piano),
	])
)).play;
);

(
Pdef(\part,Pdef(\t1_break, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1snare),
		Pdef(\t1hat),
		Pdef(\t1bass),
	])
)).play;
);

(
Pdef(\part,Pdef(\t1_chorus, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1kick2),
		Pdef(\t1snare),
		Pdef(\t1snare2),
		Pdef(\t1hat),
		Pdef(\t1bass),
		Pdef(\t1piano),
		Pdef(\t1cling),
	])
)).play;
);

(
	~master.();
Pdef(\part,Pdef(\t1_bridgeprep, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1kick2),
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
		) <> Pdef(\t1snare2),
		//Pdef(\t1snare2),
		Pbind(
			\isRest, Pseq([
				Pseq([
					0,0,0,0, 0,0,0,0,
				],4),
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
		) <> Pdef(\t1hat),
		Pseq([
			Rest(4),
			Pbind(
				\sustain, 12/~t, 
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					Pseq([
						0
					],inf),
				],1).coin.not,
			) <> Pdef(\t1voice),
		],1),
	])
)).play;
);

(
	~master.();
Pdef(\part,Pdef(\t1_bridge, 
	Ppar([
		Pdef(\t1kick),
		Pdef(\t1snare),
		Pdef(\t1snare2),
		Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
		) <> Pdef(\t1snare2),
		//Pdef(\t1snare2),
		Pbind(
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],inf),
			],inf).coin.not,
		) <> Pdef(\t1hat),
		Pseq([
			Pbind(
				\pos, Pseq([0.1,0.7],inf).stutter(Pseq([1,2,4],inf).stutter(2)),
				\legato, Pseq([
					4,0,0,0, 0,1,0,0,
					1,0,1,0, 0,0,0,1,
					4,0,0,0, 0,1,0,0,
					1,0,1,0, 0,0,0,1,

					2,0,0,0, 0,1,0,0,
					1,0,2,0, 1/2,1/2,0,1,
					1,0,1,1, 1,0,1,1,
					2,0,2,0, 1,1,1,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/16,
			) <> Pdef(\t1voice),
		],1),
	])
)).play;
);

///////////////////////// MAIN

(
	~master.();
Pdef(\main,Pdef(\track1, 
	Pseq([
		Pfindur(16,Pdef(\t1_intro)),
		Pfindur(16,Pdef(\t1_verse1)), // focus:rix&perc
		Pfindur(16,Pdef(\t1_break)), // focus:bass&perc
		Pfindur(16,Pdef(\t1_chorus)),
		Pfindur(16,Pdef(\t1_bridgeprep)),
		Pfindur(16,Pdef(\t1_bridge)),
		Pfindur(16,Pdef(\t1_verse2)),
		Pfindur(16,Pdef(\t1_outro)),
		Ptask({ "ZE_END".debug }),
	])
)).play;
);

8*16 / (135/4/60) / 60

//////////////////// DRAFT

(
	~master.();
Pdef(\test, 
	Ppar([
		Pdef(\piano) <> Pbind(
			\instrument, \rix,
			\freq, Pstep(Pseq([2200,2220,2240,1345],inf),1),
			\legato, Pstep(Pseq([
				1,0.4,
			],inf),1),
			\fspread, 4.0001,
			\dur, Pseq([1,1,1,1/2,1/2],inf),
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 0,1,1,1,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([
				1,1,1,1,
				1,1,1,2,
				1,1,1,1,
				1,1,1,4,
				1,1,1,1,
				1,1,1,2,
				1,1,16,16,
				4,1,1,2,
			],inf), 1),
			\amp, 0.1,
		),
		
	])
).play;
)


(
)
