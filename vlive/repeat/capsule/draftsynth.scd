(
SynthDef(\bass_drum_batter_click, { arg out=0, gate=1;
	var adsr_freq, adsr_amp, osc, vca, filter;
	var osc2, osc3;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	adsr_freq = EnvGen.kr(\adsr_freq.kr( Env.adsr(0.001,0.01,0.1,0.1) ), gate, doneAction:0);
	adsr_amp = EnvGen.kr(\adsr_amp.kr( Env.adsr(0.01,0.01,0.8,1.3) ), gate, doneAction:2);
	osc = SinOsc.ar(adsr_freq * \freq.kr(500));
	vca = osc * adsr_amp;
	filter = LPF.ar(vca) ! 2;
	sig1 = filter;
	sig1 = sig1 * \gain_body.kr(1);

	sig2 = SinOsc.ar(\freqtab.kr([1000, 1234, 4321,   3123.23, 2134, 2234]+0.123/1) *\freqfac.kr(1)) * \amptab.kr(1!6);
	sig2 = sig2.sum;
	sig2 = sig2 * EnvGen.kr(\adsr_click.kr(Env.adsr(0.1,0.1,0.8,1.1)), gate, doneAction:0);
	sig2 = LPF.ar(sig2, \lpf_click.kr(2000));
	sig2 = HPF.ar(sig2, \hpf_click.kr(2000));
	sig2 = sig2 * \gain_click.kr(1);

	
	sig = sig1 + sig2;
	sig = sig / 8;
	
	Out.ar(out, sig);
}, metadata:(specs:(
	amptab: XArraySpec(\amp),
	freqtab: XArraySpec(\freq),
	adsr_freq: XEnvSpec.adsr,
	adsr_amp: XEnvSpec.adsr,
	adsr_click: XEnvSpec.adsr,
))).add;
);

(
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
);

(
SynthDef(\snaretuned3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
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


	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.1,0.8,0.4,1,-6)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\snapclap, { |out = 0, amp = 0.5, pan = 0, dur = 1|
	var env1, env2, snd, noise1, noise2;

	// noise 1 - 4 short repeats
	env1 = EnvGen.ar(
		Env.new(
			[0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
			[0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
			[0, -3, 0, -3, 0, -3, 0, -4]
		)
	);

	noise1 = WhiteNoise.ar(env1);
	noise1 = HPF.ar(noise1, 600);
	noise1 = LPF.ar(noise1, XLine.kr(7200, 4000, 0.03));
	noise1 = BPF.ar(noise1, 1620, 3);

	// noise 2 - 1 longer single
	env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

	noise2 = WhiteNoise.ar(env2);
	noise2 = HPF.ar(noise2, 1000);
	noise2 = LPF.ar(noise2, 7600);
	noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

	snd = noise1 + noise2;
	snd = snd * 2;
	snd = snd.softclip;

	Out.ar(out, Pan2.ar(snd,pan,amp));
}).add;
);

(
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

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4,1,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).sum;
	Out.ar(out, sig);
}).add;
SynthDef(\snapsnare, { |out = 0, pan = 0, amp = 0.3|
    var pop, popAmp, popFreq;
    var noise, noiseAmp;
    var snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    pop = SinOsc.ar(popFreq) * popAmp;
    // bandpass-filtered white noise
    noiseAmp = EnvGen.ar(Env.perc(0.001, \rel.kr(0.15)), doneAction: 2);
    noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

    snd = (pop + noise) * 1.3;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
);
