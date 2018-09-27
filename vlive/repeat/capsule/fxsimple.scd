
// gain
// echo
// dubecho
// delay
// stutter - fx_stutter
// tape - fx_tapeslow, fx_tapestop
// flanger
// chorus
// reverb
// disto
// limiter
// ring

(
SynthDef(\fx_freeverb2, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreeVerb2.ar(sig[0],sig[1], \verbmix.kr(1), \room.kr(0.5), \damp.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0,1,0.01),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_gain, { arg out=0, amp=0.1, gate=1;
	var sig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = sig * EnvGen.ar(Env.adsr(0.1,0,1,0.1),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_bpf, { arg out=0, amp=0.1, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = BPF.ar(sig, \bpf.kr(2301), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_lpf, { arg out=0, amp=0.1, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = LPF.ar(sig, \lpf.kr(2301), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_hpf, { arg out=0, amp=0.1, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = HPF.ar(sig, \hpf.kr(2301), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_rlpf, { arg out=0, amp=0.1, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = RLPF.ar(sig, \lpf.kr(2301), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_rhpf, { arg out=0, amp=0.1, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = RHPF.ar(sig, \hpf.kr(2301), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_rlpfrhpf, { arg out=0, amp=0.1, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = RLPF.ar(sig, \lpf.kr(2301), \lrq.kr(0.5));
	sig = RHPF.ar(sig, \hpf.kr(2301), \hrq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;

SynthDef(\fx_reverb, { arg out=0, amp=0.1, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	sig1 = LPF.ar(sig, \lpf.kr(16000));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06) * \delayfac.kr(1), \decay.kr(3));
	};
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_reverb_lhpf, { arg out=0, amp=0.1, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	sig1 = LPF.ar(sig, \lpf.kr(16000));
	sig = SelectX.ar(\lpmix.kr(0), [sig, sig1]);
	sig1 = HPF.ar(sig, \hpf.kr(1600));
	sig = SelectX.ar(\hpmix.kr(0), [sig, sig1]);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06) * \delayfac.kr(1), \decay.kr(3));
	};
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_gatedreverb, { arg out=0, amp=0.1, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var gater; 
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	gater = ( Amplitude.kr(sig) > \gatelevel.kr(0.1) ).poll;
	//sig = sig * ( Amplitude.kr(sig) > \gatelevel.kr(0.1) ).poll;
	sig1 = LPF.ar(sig, \lpf.kr(16000));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06) * \delayfac.kr(1), \decay.kr(3) * gater);
	};
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_gatedreverblim, { arg out=0, amp=0.1, gate=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var gater; 
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.1);
	gater = ( Amplitude.kr(sig) > \gatelevel.kr(0.1) ).poll;
	//sig = sig * ( Amplitude.kr(sig) > \gatelevel.kr(0.1) ).poll;
	sig1 = LPF.ar(sig, \lpf.kr(16000));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);
	sig = sig + in;
	15.do {
		sig = AllpassL.ar(sig, 0.06, Rand(0.001,0.06) * \delayfac.kr(1), \decay.kr(3) * gater);
	};
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);
	sig = sig * EnvGen.ar(Env.adsr(0.1,0.1,0.8,0.1),gate,doneAction:2);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_tapestop, { arg out=0, gate=1, startrate=1, endrate=0.1, tapetime=1, mix=0;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var buf = LocalBuf(\bufsize.ir(2) * s.sampleRate, 2);
	var choosetrig = mix > 0;
	var rate;
	buf.clear;
	sig = in;
	// tape stop
	RecordBuf.ar(sig, buf, loop:1, trigger:choosetrig);
	rate = EnvGen.kr(Env([startrate,startrate,endrate],[0,tapetime]), choosetrig);
	sig = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_tapeslow, { arg out=0, gate=1, startrate=1, endrate=0.1, tapetime=1, mix=0;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var buf = LocalBuf(\bufsize.ir(2) * s.sampleRate, 2);
	var choosetrig = mix > 0;
	var rate;
	sig = in;
	buf.clear;
	// tape stop
	RecordBuf.ar(sig, buf, loop:1, trigger:choosetrig);
	rate = EnvGen.kr(\env.kr(Env([1, 1,1,1,1],[0,1,1,1])), choosetrig);
	sig = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_stutter, { arg out = 0, time= 0.1, mix=0, rate=1;
	var stutter = { arg sig, reset, time, rate = 1.0, maxdelay = 10;
		var phase, fragment, del;
		phase = Sweep.ar(reset);
		fragment = { |ph| (ph - Delay1.ar(ph)) < 0 + Impulse.ar(0) }.value(phase / time % 1);
		del = Latch.ar(phase, fragment) + ((time - Sweep.ar(fragment)) * (rate - 1));
		DelayC.ar(sig, maxdelay, del);
	};
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var reset;
	reset = Changed.kr(mix);
	sig = in;
	sig = stutter.(sig, reset, time, rate, \maxdelay.ir(10));
	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_chorus, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.ar(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_ring, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = [ sig ] * ( SinOsc.ar(\modfreq.kr(100) * ((0..7)/7 - 0.5 * \diff.kr(0.1) + 1)) * \modamp.kr(1) + 1 );
	sig = sig.mean;
	sig.debug("sig");
	//sig = LPF.ar(sig, \dif.kr(7500));
	LocalOut.ar(Limiter.ar(sig));

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(50));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_freqshift, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreqShift.ar(sig, \shift.kr(0));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_eqhi, { arg out=0, mix=1, gain=1, gate=1;
	var in, sig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2);
	sig = in;
	sig = BHiPass.ar(sig, \freq.kr(400), \rq.kr(1));
	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;
SynthDef(\fx_eqlow, { arg out=0, mix=1, gain=1, gate=1;
	var in, sig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2);
	sig = in;
	sig = BLowPass.ar(sig, \freq.kr(400), \rq.kr(1));
	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;

SynthDef(\fx_hishelf, { arg out=0, mix=1, gain=1, gate=1;
	var in, sig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2);
	sig = in;
	// rs = reciprocal of shelf boot/cut Slope
	sig = BHiShelf.ar(sig, \freq.kr(400), \rs.kr(1), \db.kr(0));
	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;

SynthDef(\fx_lowshelf, { arg out=0, mix=1, gain=1, gate=1;
	var in, sig;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2);
	sig = in;
	sig = BLowShelf.ar(sig, \freq.kr(400), \rs.kr(1), \db.kr(0));
	sig = SelectX.ar(mix, [in, sig]);
	sig = sig * EnvGen.ar(\asr.kr(Env.asr(0.01,1,0.01)),gate,doneAction:2);
	sig = sig * gain;
	Out.ar(out, sig);
}).add;

SynthDef(\fx_echo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//sig = LocalIn.ar(2) * \fb.kr(0.4);
	//sig = sig + in;
	sig = in;
	sig = CombC.ar(sig, 1, \delay.kr(1),\decay.kr(1));
	sig1 = sig;
	sig1 = LPF.ar(sig1, \lpf.kr(15000));
	sig1 = HPF.ar(sig1, \hpf.kr(50));
	sig = SelectX.ar(\pfmix.kr(0.5), [sig, sig1]);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
SynthDef(\fx_expecho, { arg out=0, gate=1,
		decayFactor = 0.75,
		lpfCutoff = 500,
		ioiScale = 0.8,
		ioiDecayFactor = 0.75;
    var trig, freq;
    var dry, snd, phase, iois;
    var cumulDelay;
	var buf = LocalBuf(SampleRate.ir*5);
    var 
	//	decayFactor, 
	//	lpfCutoff,
		numEchoes;
	//	ioiScale, 
	//	ioiDecayFactor;

    // play with these!
    //decayFactor = 0.75;
    //lpfCutoff = 500;
    //ioiScale = 0.8;
    //ioiDecayFactor = 0.75;

    numEchoes = 16;

	dry = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 

    phase = DelTapWr.ar(buf, dry);
    iois = Array.geom(numEchoes, ioiScale, ioiDecayFactor);
    cumulDelay = iois.sum;
    //(cumulDelay > buf.numFrames/SampleRate.ir).if {
        //Error("use a larger buffer").throw;
    //};
    snd = Silent.ar;
    iois.reverse.do { |ioi|
        snd = (snd + DelTapRd.ar(buf, phase, cumulDelay, interp: 4)) * decayFactor;
        // one-pole lowpass -- LPF was too aggressive
        snd = OnePole.ar(snd, lpfCutoff / SampleRate.ir);
        cumulDelay = cumulDelay - ioi;
    };
	snd = SelectX.ar(\mix.kr(0.5), [dry, snd]);
    
	snd = snd * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.ar(out, snd);
}).add;
);

(
SynthDef(\chorus, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.ar(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,0.1) ),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;

SynthDef(\chorusdist, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.ar(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,0.1) ),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\chorusdistlim, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = LocalIn.ar(2) * \fb.kr(0.4);
	sig = sig + in;
	sig = DelayC.ar(sig, \maxdelay.ir(0.2), \delay.kr(0.0101) * ((0..7)/7 - 0.5 * \diff.kr(0.4001) + 1) * ( SinOsc.kr(\modfreq.kr(8.1)) * \modamp.kr(0.48) + 1 )).mean;
	//sig = LPF.ar(sig, \dif.kr(7500));
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.5), [sig, sig1]);
	sig = Limiter.ar(sig);
	LocalOut.ar(sig);

	sig = LPF.ar(sig, \lpf.kr(15000));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * \wetgain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0,1,0.1) ),gate,doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\simplecomp, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	//var sidein = InFeedback.ar(\sideinbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * \pregain.kr(1);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\fx_compander, { arg out=0, gate=1, sidemode=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sidein = InFeedback.ar(\sideinbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * \pregain.kr(1);
	sidein = SelectX.ar(sidemode, [sig, sidein]);
	sig = Compander.ar(sig, sidein, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\fx_sidechain, { arg out=0, gate=1, sidemode=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var sidein = InFeedback.ar(\sideinbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = sig * \pregain.kr(1);
	sig = Compander.ar(sig, sidein, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
);

// END

LocalBuf(1000).size

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Ppar([
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				1,0,1,0, 0,0,0,1,
				1,0,0,1, 0,0,0,1,
			],inf).coin.not,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1,
			\gain, 0.3,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1,
			\gain, 0.4,
			\dur, 1/8,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
				0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
				0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\out, BusDef(\fx1, \audio),
			\sustain, 0.1,
			\gain, 0.2,
			\dur, 1/16,
			\amp, 0.1,
		)),
		PatKitDef(\ksh2b).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,1, 1,0,1,0,
			],inf).coin.not,
			\out, BusDef(\fx1, \audio),
			\gain, 0.8* Pseq([
				1,0.2,
			],inf),
			\sustain, 0.05,
			\dur, 1/16,
			\amp, 0.1,
		)),
		Pbind(
			\instrument, \riseflang,
			\note, Pseq([
				1,0,1,-5,
			],inf),
			\sustain, 1/~t,
			\dur, 2,
			\octave, 3,
			\amp, 0.4,
			\out, BusDef(\fx1, \audio),
		),
		Pbind(
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\mixer6, \audio),
		)<>
		Pseq([
			//Pmono(\fx_gain,
				//\freq, 200,
				//\mix, 1,
				//\dur, Pser([1],1),
				//\amp, 0.1,
			//),
			Pmono(\fx_ring,
				\freq, 200,
				\mix, 1,
				\modfreq, Pseg(Pseq([0,1],inf),8)*7000,
				\modamp, 1,
				\diff, 0.001,
				\fb, 0.9,
				\dur, Pser([1/4],8),
				\amp, 0.1,
			),
			Pmono(\fx_expecho,
				\freq, 200,
				\mix, 0.51,
				\decayFactor, 0.7,
				\fb, 0.9,
				\dur, Pser([1/2],4),
				\amp, 0.1,
			),
			Pmono(\fx_chorus,
				\freq, 200,
				\mix, 0.51,
				\delay, Pstep(Pseq([1/8,1/4],inf),1/2)/~t,
				\modamp, 0.401,
				\modfreq, 0.1,
				\fb, 0.1,
				\dur, Pser([1/2],4),
				\amp, 0.1,
			),
			Pmono(\fx_echo,
				\freq, 200,
				\mix, 0.51,
				\decay, 5,
				\delay, Pstep(Pseq([3/8,3/4],inf),1/2)/~t,
				\fb, 0.1,
				\dur, Pser([1/2],8),
				\amp, 0.1,
			),
			Pmono(\fx_stutter,
				\freq, 200,
				\mix, 1,
				\time, Pstep(Pseq([1/16,1/4,1/8,1/4],inf),1/4)/~t,
				\fb, 0.1,
				\dur, Pser([1/4],4),
				\amp, 0.1,
			),
			Pmono(\fx_reverb,
				\freq, 200,
				\mix, 0.5,
				\fb, 0.9,
				\dur, Pser([1],1),
				\amp, 0.1,
			),

		],inf),
	])
)).play;
)

///////// tape test

(
Pdef(\demo, Pdef(\demozed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 4,
			\gain, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_tapestop,
			\inbus, BusDef(\sendbus1),
			\mix, Pseq([0,0,1,1],inf),
			\time, 2,
			\dur, 1,
		),

	])
)).play;
)

(
Pdef(\demo, Pdef(\demozed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/feynman.flac'),
			\dur, 4,
			\gain, 1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\fx_tapeslow,
			\inbus, BusDef(\sendbus1),
			\mix, Pseq([0,1,1,1],inf),
			\env, Pseq([
				[ Env([1, 1,0.4,1.3,1], [0, 1,1,1]) ],
			],inf),
			\time, 2,
			\dur, 1,
		),

	])
)).play;
)
/////////////////////////////////////////
// TODO: put this crap elsewhere


(
SynthDef(\celeste, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * ((0..7)/7 - 0.5 * \diff.kr(0.01) + 1) * ( SinOsc.kr(freq * \fm.kr(1) * ((0..7)/7 - 0.5 * \fmdiff.kr(0.1) + 1)) * \fmamp.kr(1) + 1 );
	sig1 = SinOsc.ar(freq);
	sig2 = Saw.ar(freq);
	sig3 = Pulse.ar(freq);
	sig = SelectX.ar(\mix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\revkick, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(EnvGen.kr(\freqenv.kr(Env([400,65,60],[0.01,0.8])), 1););
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.1,0.8,0.01),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bitcodemono, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
    var t = PulseCount.ar(Impulse.ar(8e3));
    sig = HPF.ar(
        (  
            ((t * \fac1.kr(15)) & (t >> \shift1.kr(5))) |
            ((t * \fac2.kr(5)) & (t >> \shift2.kr([3, 4]))) |
            ((t * \fac3.kr(2)) & (t >> \shift3.kr(9))) |
            ((t * \fac4.kr(8)) & (t >> \shift4.kr(11)))
            - 3 % 256
        ) / 127-1 * 3
        , 20
    ).distort * 0.2; 
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
SynthDef(\bitcode, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
    var t = PulseCount.ar(Impulse.ar(8e3));
    sig = HPF.ar(
        (  
            ((t * 15) & (t >> 2)) |
            ((t * 5) & (t >> [3, 4])) |
            ((t * 2) & (t >> 9)) |
            ((t * 8) & (t >> 11))
            - 3 % 256
        ) / 127-1 * 3
        , 20
    ).distort * 0.2; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \revkick,
			\freq, 200,
			\dur, 1,
			\freqenv, Pseq([
				[ Env([400,55,60],[0.01,0.8]) ]
			],inf),
			\isRest, Pseq([
				1,0,0,0,
				0,0,0,0,
			],inf).coin.not,
			\sustain, 0.01,
			\amp, 0.1,
			\out, BusDef(\fxreverb, \audio),
		),
		Pbind(
			\instrument, \bitcode,
			\freq, 200,
			\sustain, 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.4,4.7) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0,
				1,0,0,0,
			],inf).coin.not,
			\dur, 1/2,
			\amp, 0.1/2,
			\out, BusDef(\fxreverb, \audio),
		),
		Pmono(\fx_reverb,
			\mix,0.5,
			\lpf, 1000,
			\lpmix, 0,
			\delayfac, ~pmodenv.(Pseq([1,1,1,1,0.9,1],inf), 2),
			\fb, 0.7,
			\gain, 4,
			\inbus, BusDef(\fxreverb, \audio),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \celeste,
			\fmamp, Pseg(Pseq([0,0.1,0.08],inf),3),
			\diff, Pseg(Pseq([0,0.01,0.1],inf),3),
			\fmdiff, Pseg(Pseq([0,0.01,0.1],inf),3),
			\fm, Pseg(Pseq([2,0.01,1],inf),3),
			\mix, Pseg(Pseq([0,1],inf),3),
			\note, Pseq([
				[0,4,7]
			],inf),
			\isRest, Pseq([
				0,0,0,0,
				0,0,0,0,
				0,0,0,0,
				1,1,1,1,
			],inf).coin.not,
			\sustain, 0.01,
			\dur, 1/16,
			\amp, 0.1,
			\out, BusDef(\fx1, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fxreverb, \audio),
			\mix, 1.01,
			\delay, 1/3/~t,
			\modamp, 0.001,
			\modfreq, 2.1,
			\fb, 0.1,
			\dur, Pser([1/2],inf),
			\amp, 0.1,
		),
		
	])
)).play;
)

/////////////////////////////////////////
(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \bitcodemono,
				\fac1, Pseq([
					8,8,
					18,8,
					8,8,
					1,50,
				],inf),
				\shift1, 1,
				\sustain, 0.3 * Pseq([
					1,0.7,
				],inf),
				\dur, 1/4,
				\amp, 0.1,
				\isRest, true,
			),
			
			Pmono(\bitcodemono,
				\fac1, Pseq([
					(1..8)*3
				].flat,inf),
				\freq, 200,
				\dur, 1,
				\amp, 0.2,
				\pan, -0.3,
				\out, BusDef(\fx1, \audio),
			),
			Pmono(\bitcodemono,
				\fac1, Pseq([
					(1..8)*3
				].flat,inf),
				\fac2, 1,
				\fac3, 10,
				\fac4, 1,
				\shift1, Pseq([
					1,10,
				],inf),
				\shift2, Pseq([
					[[10,10]],
					[[4,10]],
					
				],inf),
				\shift3, 10,
				\shift4,14,
				\freq, 200,
				\dur, 1,
				\amp, 0.2,
				\pan, -0.3,
				\out, BusDef(\fx2, \audio),
			),
			
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx1, \audio),
			\lpf, ~pmodenv.(Pseq([19000,2000,1000,40],inf), 2),
			\dur, 1,
			\rq, 0.1,
			\out, BusDef(\fxchorus, \audio),
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\amp, 0.1,
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx2, \audio),
			\lpf, ~pmodenv.(Pseq([100,19000,2000,10000],inf), 2),
			\rq, 0.1,
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\out, BusDef(\fxchorus, \audio),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\mix, Pseq([
				1,0
			],inf),
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.001,
			\modfreq, 0.1,
			\modamp, 1,
			\gain,2,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, \bitcodemono,
				\fac1, Pseq([
					8,8,
					18,8,
					8,8,
					1,50,
				],inf),
				\shift1, 1,
				\sustain, 0.3 * Pseq([
					1,0.7,
				],inf),
				\dur, 1/4,
				\amp, 0.1,
				\isRest, true,
			),
			
			Pmono(\bitcodemono,
				\fac1, Pseq([
					(1..8)*3
				].flat,inf),
				\freq, 200,
				\dur, 1,
				\amp, 0.2,
				\pan, -0.3,
				\out, BusDef(\fx1, \audio),
			),
			Pmono(\bitcodemono,
				\fac1, Pseq([
					(1..8)*3
				].flat,inf),
				\fac2, 1,
				\fac3, 10,
				\fac4, 1,
				\shift1, Pseq([
					1,10,
				],inf),
				\shift2, Pseq([
					[[10,10]],
					[[4,10]],
					
				],inf),
				\shift3, 10,
				\shift4,14,
				\freq, 200,
				\dur, 1,
				\amp, 0.2,
				\pan, -0.3,
				\out, BusDef(\fx2, \audio),
			),
			
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx1, \audio),
			\lpf, ~pmodenv.(Pseq([19000,2000,1000,40],inf), 2),
			\dur, 1,
			\rq, 0.1,
			\out, BusDef(\fxchorus, \audio),
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\amp, 0.1,
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx2, \audio),
			\lpf, ~pmodenv.(Pseq([100,19000,2000,10000],inf), 2),
			\rq, 0.1,
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\out, BusDef(\fxchorus, \audio),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\mix, Pseq([
				1,0
			],inf),
			\fb, 1.9,
			\delay, 0.01,
			\diff, 0.00001,
			\modfreq, 00.1,
			\modamp, 3,
			\gain,2,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\patient, 
	Ppar([
			Pbind(
				\instrument, \bitcodemono,
				\fac1, Pseq([
					8,8,
					18,8,
					8,8,
					1,50,
				],inf),
				\shift1, 1,
				\sustain, 0.3 * Pseq([
					1,0.7,
				],inf),
				\dur, 1/4,
				\amp, 0.1,
				\isRest, true,
			),
			
			Pmono(\bitcodemono,
				\fac1, Pseq([
					(1..8)*3
				].flat,inf),
				\freq, 200,
				\dur, 1,
				\amp, 0.2,
				\pan, -0.3,
				\out, BusDef(\fx1, \audio),
			),
			Pmono(\bitcodemono,
				\fac1, Pseq([
					(1..8)*3
				].flat,inf),
				\fac2, 1,
				\fac3, 10,
				\fac4, 1,
				\shift1, Pseq([
					1,10,
				],inf),
				\shift2, Pseq([
					[[10,10]],
					[[4,10]],
					
				],inf),
				\shift3, 10,
				\shift4,14,
				\freq, 200,
				\dur, 1,
				\amp, 0.2,
				\pan, -0.3,
				\out, BusDef(\fx2, \audio),
			),
			
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx1, \audio),
			\lpf, ~pmodenv.(Pseq([19000,2000,1000,40],inf), 2),
			\dur, 1,
			\rq, 0.1,
			\out, BusDef(\fxchorus, \audio),
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\amp, 0.1,
		),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fx2, \audio),
			\lpf, ~pmodenv.(Pseq([100,19000,2000,10000],inf), 2),
			\rq, 0.1,
			//\timingOffset, 0.1,
			//\addAction, \addToTail,
			\out, BusDef(\fxchorus, \audio),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\mix, Pseq([
				1,0
			],inf),
			\fb, 0.9,
			\delay, 0.1,
			\diff, 0.1,
			\modfreq, 0.01,
			\modamp, 1,
			\gain,2,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
)


///////////////////////////////////////
(
Pdef(\part, Pdef(\patient, 
	Ppar([
			PmonoArtic(\bitcodemono,
				\fac1, 12,
				\fac2, 100,
				\fac3, 10,
				\fac4, 20,
				\shift1, Pseq([
					10,10,
				],inf),
				\fac2, Pseq([
					1,1,
					 ~pmodenv.(Pseq([1,10,10],1/2), 1),
				],inf),
				\shift2, Pseq([
					[[1,1]],
					
				],inf),
				\shift3, 1,
				\shift4,10,
				\freq, 200,
				\dur, 1/2,
				\amp, 0.2 * Pseq([
					1,1,1,0,
				],inf),
				\legato, Pseq([
						1,1,1,0.91,
				],inf),
				\pan, -0.3,
				\out, BusDef(\fxchorus, \audio),
			),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\mix, Pseq([
				1,1,1,0
			],inf),
			\fb, 0.9,
			\delay, 0.001,
			\diff, 0.01,
			\modfreq, 1.01,
			\modamp, 0.1,
			\gain,2,
			\dur, 1/2,
			\amp, 0.1,
		),
		
	])
)).play;
)


/////////////////////////////

(
SynthDef(\seg_perc, { arg out=0, amp=0.1, t_gate=1, pan=0, freq=200;
	var sig;
	sig = EnvGen.kr(Env( [0,1,0],[0.01,0.8].normalizeSum ), t_gate, levelScale:\scale.kr(1),levelBias:\bias.kr(0), timeScale:\time.kr(1),doneAction:2);
	Out.kr(out, sig);
}).add;
SynthDef(\seg_at, { arg out=0, amp=0.1, t_gate=1, pan=0, freq=200;
	var sig;
	sig = EnvGen.kr(Env( [0,1,0],[0.8,0.08].normalizeSum ), t_gate, levelScale:\scale.kr(1),levelBias:\bias.kr(0), timeScale:\time.kr(1),doneAction:2);
	Out.kr(out, sig);
}).add;
SynthDef(\seg_step, { arg out=0, amp=0.1, t_gate=1, pan=0, freq=200;
	var sig;
	sig = EnvGen.kr(Env( [1,1,1],[0.8,0.08].normalizeSum ), t_gate, levelScale:\scale.kr(1),levelBias:\bias.kr(0), timeScale:\time.kr(1),doneAction:2);
	Out.kr(out, sig);
}).add;
SynthDef(\simple, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq.poll);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pdef(\part).clear
(
Pdef(\part, Pdef(\plop, 
	Ppar([
			Pbind(
				\instrument, Pseq([
					\seg_step,
					\seg_step,
					\seg_step,
					\seg_step,
					\seg_perc,
					\seg_at,
				],inf),
				\freq, 200,
				\legato, 1,
				\scale, Pseq([
					100,30,300,
				],inf),
				\bias, Pseq([
					300,500,
				],inf),
				\dur, 1/8,
				\time, Pkey(\dur)/~t,
				\amp, 0.1,
				\addAction, \addToHead,
				\out, BusDef(\seqbus1),
			),
		Pbind(
			\instrument, \simple,
				\addAction, \addToTail,
			\freq, BusDef(\seqbus1, \control, 1).asMap,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
)

ProtoDef(\piano).startControl(Pdef(\bla, Pbind()))
ProtoDef(\piano).startControl

////////////////////////

(
	~master.();
Pdef(\part, Pdef(\plop, 
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		8.collect {
			[
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,0,
					1,0,
					1,0,
					1,1,
				],inf).coin.not,
				\sustain, rrand(0.01,0.4),
				\speed, rrand(0.1,2),
				\lag, rrand(0,0.05),
				\gain, rrand(0.5,0.7) * Pseg(Pseq([0,1.0.rand,1.0.rand,0,1].scramble,inf),rrand(1.0,8)),
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,1, 1,0,
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,1, 0,1, 1,0,
				],inf).coin.not,
				\speed, rrand(0.1,2),
				\sustain, rrand(0.01,0.4),
				\lag, rrand(0,0.05),
				\gain, rrand(0.5,0.7) * Pseg(Pseq([0,1.0.rand,1.0.rand,0,1].scramble,inf),rrand(1.0,8)),
				\dur, 1/8,
				\amp, 0.1,
			)),
			]
		}
		
	].flat)
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\war1, 
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		16.collect {
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, [0,1,4,5].choose,
				\isRest, Pseq([
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,0, 1,1, 1,0,
					1,0, 1,0, 1,0, 1,0,
					1,0, 1,1, 0,1, 1,0,
				]++
				[
					[ ],
					[ ],
					[0,1].scramble,
					[1,0,0,1].scramble,
					[0,1].choose,
				].choose
				,inf).coin.not,
				\speed, rrand(0.1,2),
				\sustain, rrand(0.01,0.4),
				\lag, rrand(0,0.05),
				\gain, rrand(0.5,0.7) * Pseg(Pseq([0,1.0.rand,1.0.rand,0,1].scramble,inf),rrand(1.0,8)),
				\dur, 1/8,
				\amp, 0.1,
			));
		},
		4.collect {
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, [8,9].choose,
				\isRest, Pseq([
					1,0, 0,0, 0,0, 0,0,
					1,0, 1,1, 1,0, 1,0,
					1,0, 1,0, 1,1, 1,0,
					1,0, 1,1, 0,1, 1,0,
				]++
				[
					[ ],
					[ ],
					[0,1].scramble,
					[1,0,0,1].scramble,
					[0,1].choose,
				].choose
				,inf).coin.not,
				\speed, rrand(0.9,2),
				//\sustain, rrand(0.01,0.4),
				\lag, rrand(0,0.05),
				\gain, rrand(0.5,0.7) * Pseg(Pseq([0,1.0.rand,1.0.rand,0,1].scramble,inf),rrand(1.0,8)),
				\dur, 1/16,
				\amp, 0.1,
			));
		}
		
	].flat)
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\warend, 
	Pbind(\out, BusDef(\mixer6))<>
	Ppar([
		16.collect {
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, [0,1,4,5].choose,
				\isRest, Pseq([
					1,0, 0,0, 
				]++
				[
					[ ],
					[ ],
					[0,1].scramble,
					[1,0,0,1].scramble,
					[0,1].choose,
				].choose
				,inf).coin.not,
				\speed, rrand(0.1,2),
				\sustain, rrand(0.01,0.4),
				\lag, rrand(0,0.05),
				//\gain, rrand(0.5,0.7) * Pseg(Pseq([0,1.0.rand,1.0.rand,0,1].scramble,inf),rrand(1.0,8)),
				\dur, 1/8,
				\amp, 0.1,
			));
		},
		4.collect {
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, [8,9].choose,
				\isRest, Pseq([
					0,0,1,0,
				]++
				[
					[ ],
					[ ],
					[0,1].scramble,
					[1,0,0,1].scramble,
					[0,1].choose,
				].choose
				,inf).coin.not,
				\speed, rrand(0.9,2),
				//\sustain, rrand(0.01,0.4),
				\lag, rrand(0,0.05),
				\gain, rrand(0.5,0.7) * Pseg(Pseq([0,1.0.rand,1.0.rand,0,1].scramble,inf),rrand(1.0,8)),
				\dur, 1/16,
				\amp, 0.1,
			));
		}
		
	].flat)
)).play;
)

(
	~master.();
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(12, Pdef(\war1)),
		Pfindur(4, Pdef(\warend)),
		
	],inf)
)).play;
)


//////////////////


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		4.collect({ arg idx;
			Pbind(
				\instrument, \default,
				\note, Pseq([
					{[1,2,4,5].choose }.dup(4),
					{[1,2,4,5].choose }.dup(4),
				].flat,inf),
				\sustain, 0.051,
				\octave, Prand([3,4,5],inf).stutter(4),
				\isRest, Pseq([
					1,0,0,0,
					0.51,0,0,0,
					0.81,0,0,0,
					0.21,0,0,0,
				],inf,idx).coin.not,
				\dur, 1/16,
				\amp, 0.1,
			);
		})
	].flat)
)).play;
)


(
Pdef(\part, Pdef(\plop, 
	Ppar([
		16.collect({ arg idx;
			Plazy({ arg ev;
				Pfindur(rrand(1,8)*4,Pbind(
					\instrument, \default,
					\note, Pseq([
						{[1,2,4,5].choose }.dup(4),
						{[1,2,4,5].choose }.dup(4),
					].flat,inf),
					\sustain, 0.051,
					\octave, [3,4,5].choose,
					\isRest, Pseq([
						 [
							[ 1,1,1,0, 0,0,0,0, ],
							[ 1,1,0,0, 0,0,0,0, ],
							[ 1,0,1,1, 0,0,0,0, ],
							[ 1,0,0,1, 0,0,0,0, ],
						].choose,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					].flat,inf).coin.not,
					\lag, rrand(1,8)/4/~t,
					\dur, 1/16,
					\amp, 0.1/2,
				));
			}).loop;
		}),
	].flat)
)).play;
)


////////////////////////////////


(
SynthDef(\fmbell2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * EnvGen.kr(Env([1,1.002,0.998,1],[0.1,0.8]), 1);
	sig1 = SinOsc.ar(freq * \freq1.kr(2.6706) + 0.13) * \fmamp.kr(2) + 1; 
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
)


Pdef(\part).clear
(
Pdef(\part, Pdef(\plop, 
	Ppar([
		16.collect({ arg idx;
			Plazy({ arg ev;
				Pfindur(inf,Pbind(
					\instrument, \bitcodemono,
					\fac1, Pseq([
						{(1..16).choose }.dup(4),
					].flat,inf),
					\fac2, Pkey(\fac1),
					\fac3, Pkey(\fac1),
					\shift1, Pseq([
						{[1,2,4,5].choose }.dup(4),
						{[1,2,4,5].choose }.dup(4),
					].flat,inf)*2,
					\shift3, (1..10).choose,
					\sustain, rrand(0.01,0.1),
					\isRest, Pseq([
						 [
							[ 1,1,1,0, 0,0,0,0, ],
							[ 1,1,0,0, 0,0,0,0, ],
							[ 1,0,1,1, 0,0,0,0, ],
							[ 1,0,0,1, 0,0,0,0, ],
						].choose,
						Pseq([
							0,0,0,0, 0,0,0,0,
						],2**( idx%4+1 )-1),
					].flat,rrand(1,8)).coin.not,
					\lag, rrand(1,8)/4/~t,
					\dur, 1/16,
					\amp, 0.1/4,
					\out, BusDef(\fxchorus, \audio),
				));
			}).loop;
		}),
		16.collect({ arg idx;
			Plazy({ arg ev;
				Pfindur(inf,Pbind(
					\instrument, \fmbell2,
					\freq1, rrand(0.1,8),
					\adsr, Pseq([
						 [
							[ Env.adsr(0.1,0.1,0.8,0.1) ],
							[ Env.adsr(0.1,0.1,0.8,0.4) ],
							[ Env.adsr(0.01,0.1,0.8,0.1) ],
							[ Env.adsr(0.1,0.1,0.8,0.01) ],
						].choose
					],inf),
					\note, Pseq([
						{[1,2,4,5].choose }.dup(4),
						{[1,2,4,5].choose }.dup(4),
					].flat,inf),
					\sustain, 0.051,
					\octave, [4,5,6].choose,
					\isRest, Pseq([
						 [
							[ 1,1,1,0, 0,0,0,0, ],
							[ 1,1,0,0, 0,0,0,0, ],
							[ 1,0,1,1, 0,0,0,0, ],
							[ 1,0,0,1, 0,0,0,0, ],
						].choose,
						Pseq([
							0,0,0,0, 0,0,0,0,
						],2**( idx%4+1 )-1),
					].flat,rrand(1,8)).coin.not,
					\lag, rrand(1,8)/4/~t,
					\dur, 1/16,
					\amp, 0.1/8,
					\out, BusDef(\fxchorus, \audio),
				));
			}).loop;
		}),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\mix, Pseq([
				0.5
			],inf),
			\fb, 0.9,
			\delay, 0.001,
			\diff, 0.01,
			\modfreq, 0.01,
			\modamp, 1,
			\gain,1,
			\dur, 1/2,
			\amp, 0.1,
		),
	].flat)
)).play;
)


Pdef(\part_drum).clear
(
	~master.();
Pdef(\part_drum, Pdef(\drumsplop, 
	Ppar([
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 1,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,1,
					1,0,0,1, 0,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\speed, 0.9,
				\dur, 1/8,
				\gain, 1,
				\gain, 0.81,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\dur, 1/8,
				\gain, 1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 5,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0,
					0,0,0,1, 0,0,1,0, 0,0,0,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,1,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\sustain, 0.1,
				\gain, 0.2,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\ksh2b).asPattern(Pbind(
				\kitIndex, 8,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,1,
					1,0,1,0, 1,0,1,0,
					1,0,1,0, 1,0,1,0,
					1,0,1,1, 1,0,1,0,
				],inf).coin.not,
				\out, BusDef(\fx1, \audio),
				\gain, 0.8* Pseq([
					1,0.2,
				],inf),
				\sustain, 0.05,
				\dur, 1/16,
				\amp, 0.1,
			)),
			Pseq([
				
				//Pmono(\gain,
					//\inbus, BusDef(\fx1, \audio),
					//\freq, 200,
					////\out, BusDef(\mixer6, \audio),
					//\distamp, 50,
					//\delay, 0.0001,
					//\gain, 0.2,
					//\dur, Pseq([1],3),
					//\amp, 0.1,
				//),
				Pmono(\fxknife3,
					\inbus, BusDef(\fx1, \audio),
					\freq, 200,
					\mix, Pseq([
						Pser([
							0
						],1),
						~pmodenv.(Pseq([1,0]*0.5,1), 1/2,1,1),
					],inf),
					//\out, BusDef(\mixer6, \audio),
					\distamp, 50,
					\delay, 0.0001,
					\gain, 0.2,
					\dur, Pseq([1/2],inf),
					\amp, 0.1,
				),
			],inf),
	])
)).play;
)

//////////////////////////////////////////

(
SynthDef(\melsap, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * EnvGen.kr(Env([1,  2, 1.1, 0.9, 1,  1/2],[0.1,0.1, 1.1, 0.1,0.1,0.8 ]), 1);
	freq = freq * [1,2,1/2,1.0001];
	sig = SinOsc.ar(freq);
	env3 = EnvGen.kr(Env([0,2.2,1,0.7],[1.4,1.8,2]), 1);
	sig = sig + ( LFSaw.ar(freq) * env3 );
	env2 = EnvGen.kr(Env([1,0.2,1,0.7],[0.4,1.8,2]), 1);
	sig = sig.fold(env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\melsap2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	freq = freq * EnvGen.kr(Env([1,  2, 1.1, 0.9, 1,  1/2],[0.1,0.1, 1.1, 0.1,0.1,0.8 ]), 1);
	freq = freq * [1,2,1/2,1.0001];
	sig = Pulse.ar(freq) + SinOsc.ar(freq);
	env3 = EnvGen.kr(Env([0,2.2,1,0.7],[1.4,1.8,2]), 1);
	sig = sig + ( LFSaw.ar(freq) * env3 );
	env2 = EnvGen.kr(Env([1,0.2,1,0.7],[0.4,1.8,2]), 1);
	sig = sig.fold(env2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

Ndef(\test, \melsap2).edit

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \melsap2,
			\note, Pseq([
				0,3,7,-4,
			],inf),
			\octave, 4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\legato, Pseq([
				6,0,0,0, 0,0,2,0,
				7,0,0,0, 0,0,0,1,
				3,0,0,6, 0,0,0,0,
				0,7,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\out, BusDef(\fxchorus, \audio),
			\dur, 1/8,
			\amp, 0.2,
		),
		8.collect({ arg idx;
			Plazy({ arg ev;
				Pfindur(rrand(1,8)*2,Pbind(
					\instrument, \fmbell2,
					\freq1, rrand(0.1,8),
					\adsr, Pseq([
						 [
							[ Env.adsr(0.1,0.1,0.8,0.1) ],
							[ Env.adsr(0.1,0.1,0.8,0.4) ],
							[ Env.adsr(0.01,0.1,0.8,0.1) ],
							[ Env.adsr(0.1,0.1,0.8,0.01) ],
						].choose
					],inf),
					\note, Pseq([
						{[1,2,4,5].choose }.dup(4),
						{[1,2,4,5].choose }.dup(4),
					].flat,inf),
					\sustain, 0.051,
					\octave, [4,5,6].choose,
					\isRest, Pseq([
						 [
							[ 1,1,1,0, 0,0,0,0, ],
							[ 1,1,0,0, 0,0,0,0, ],
							[ 1,0,1,1, 0,0,0,0, ],
							[ 1,0,0,1, 0,0,0,0, ],
						].choose,
						Pseq([
							0,0,0,0, 0,0,0,0,
						],3),
					].flat,inf).coin.not,
					\lag, rrand(1,8)/4/~t,
					\dur, 1/16,
					\amp, 0.1/8,
					\out, BusDef(\fxchorus, \audio),
				));
			}).loop;
		}),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\mix, Pseq([
				0.5
			],inf),
			\fb, 0.9,
			\delay, 0.001,
			\diff, 0.01,
			\modfreq, 0.01,
			\modamp, 1,
			\gain,1,
			\dur, 1/2,
			\amp, 0.1,
		),
	].flat)
)).play;
)

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			Pmono(\melsap2,
				\freq, ~pmodenv.(Pseq([40,600],inf), 1),
				\dur, Pseq([1],1),
				\amp, 0.1,
			),
			Pmono(\melsap2,
				\freq, Pseq([
					Plazy({ arg ev;
						var xx = 16.rand;
						Pseq([
							Pser([
								200
							],xx),
							Pfin(16-xx,
								Pexprand(60.0,5400,1).stutter(Pwhite(1,4)),
							),
						],1);
					}),
				],15),
				\dur, 1/16,
				\amp, 0.1,
			),
		],inf),
		8.collect({ arg idx;
			Plazy({ arg ev;
				Pfindur(rrand(1,8)*2,Pbind(
					\instrument, \fmbell2,
					\freq1, rrand(0.1,8),
					\adsr, Pseq([
						 [
							[ Env.adsr(0.1,0.1,0.8,0.1) ],
							[ Env.adsr(0.1,0.1,0.8,0.4) ],
							[ Env.adsr(0.01,0.1,0.8,0.1) ],
							[ Env.adsr(0.1,0.1,0.8,0.01) ],
						].choose
					],inf),
					\note, Pseq([
						{[1,2,4,5].choose }.dup(4),
						{[1,2,4,5].choose }.dup(4),
					].flat,inf),
					\sustain, 0.051,
					\octave, [4,5,6].choose,
					\isRest, Pseq([
						 [
							[ 1,1,1,0, 0,0,0,0, ],
							[ 1,1,0,0, 0,0,0,0, ],
							[ 1,0,1,1, 0,0,0,0, ],
							[ 1,0,0,1, 0,0,0,0, ],
						].choose,
						Pseq([
							0,0,0,0, 0,0,0,0,
						],3),
					].flat,inf).coin.not,
					\lag, rrand(1,8)/4/~t,
					\dur, 1/16,
					\amp, 0.1/8,
					\out, BusDef(\fxchorus, \audio),
				));
			}).loop;
		}),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\mix, Pseq([
				0.5
			],inf),
			\fb, 0.9,
			\delay, 0.001,
			\diff, 0.01,
			\modfreq, 0.01,
			\modamp, 1,
			\gain,1,
			\dur, 1/2,
			\amp, 0.1,
		),
	].flat)
)).play;
)
Pdef(\part).clear

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pseq([
			//Pmono(\melsap2,
				//\freq, ~pmodenv.(Pseq([40,600],inf), 1),
				//\dur, Pseq([1],1),
				//\amp, 0.1,
			//),
			PmonoArtic(\fmbass,
				\note, Pseq([
					Plazy({ arg ev;
						var xx = 16.rand;
						Pseq([
							Pser([
								0,
							],xx),
							Pfin(16-xx,
								Prand([0,3,7,5,10],inf).stutter(Pwhite(1,4)),
							),
						],1);
					}),
				],15),
				\legato, Pseq([
						1,1,1,0.8,
						1,1,1,1,
						1,1,1,1,
						1,1,1,0.8,
				],inf),
				\octave, 5,
				\dur, 1/16,
				\amp, 0.061,
			),
		],inf),
		Pbind(
			\instrument, \fmbell2,
			\freq1, 1,
			\adsr, Pseq([
				[
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
				].choose
			],inf),
			\note, Pseq([
				[0,3,7,7-12],
				[0,5,7,5-12],
				[0,4,7,10],
				[0,3,7,10],
			],inf).stutter(16),
			\octave, 6,
			\sustain, Ptuple(Pwhite(0.5,1)!4),
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1/8,
			\out, BusDef(\fxchorus, \audio),
		),
		Pmono(\fx_chorus,
			\inbus, BusDef(\fxchorus, \audio),
			\mix, Pseq([
				0.5
			],inf),
			\fb, 0.9,
			\delay, 0.001,
			\diff, 0.01,
			\modfreq, 0.01,
			\modamp, 1,
			\gain,0.81,
			\dur, 1/2,
			\amp, 0.1,
		),
	].flat)
)).play;
)

Pdef(\part_drum2).clear
(
Pdef(\part_drum2, Pdef(\petitdrum, 
	Ppar([
		Pbind(\out, BusDef(\fxlp))<>
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([

					 [
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
						1,0,1,1, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
					].clump(8).collect({ arg xx; 
						 [
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
						] ++ xx
					})
				].flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/16,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/16,
				\amp, 0.1,
			)),
		]),
		Pmono(\fx_rlpf,
			\inbus, BusDef(\fxlp, \audio),
			\out, BusDef(\fxhp, \audio),
			\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
			\dur, 1,
			\amp, 0.1,
		),
		Pmono(\fx_rhpf,
			\inbus, BusDef(\fxhp, \audio),
			\hpf, 1000 + Pseg(Pseq([0,4000],inf),8),
			\dur, 1,
			\amp, 0.1,
		),

		
	])
)).play;
)

(
	// gated reverb
Pdef(\part_drum2, Pdef(\petitdrum, 
	Ppar([
		Pbind(\out, BusDef(\fx1))<>
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([

					 [
						1,0,1,0, 0,0,0,1,
						1,0,1,0, 0,0,0,0,
						1,0,1,1, 0,0,0,0,
						1,0,1,0, 0,0,1,0,
					].clump(8).collect({ arg xx; 
						 [
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
							1,0,1,0, 0,0,0,0,
						] ++ xx
					})
				].flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		]),
		Pseq([
			Pmono(\fx_gatedreverblim,
				\inbus, BusDef(\fx1, \audio),
				//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
				\gatelevel, Pseq([
					0.02,
				],inf),
				\fb, 0.5,
				\delayfac, 0.1,
				\mix, 0.21,
				\decay, 4.01,
				\dur, Pseq([1/4],4*4),
				\gain, 0.6,
				\amp, 0.1,
			),
			Pmono(\fx_gatedreverblim,
				\inbus, BusDef(\fx1, \audio),
				//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
				\gatelevel, Pseq([
					0.7,
				],inf),
				\fb, 0.9,
				\delayfac, 0.00001,
				\mix, 0.21,
				\decay, 0.1,
				\dur, Pseq([1/4],4*4),
				\gain, 0.6,
				\amp, 0.1,
			),
			Pmono(\fx_gatedreverblim,
				\inbus, BusDef(\fx1, \audio),
				//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
				\gatelevel, Pseq([
					0.01,
				],inf),
				\fb, 0.9,
				\delayfac, 0.10001,
				\mix, 0.21,
				\decay, 0.1,
				\dur, Pseq([1/4],4*4),
				\gain, 0.6,
				\amp, 0.1,
			),
			Pmono(\fx_gatedreverblim,
				\inbus, BusDef(\fx1, \audio),
				//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
				\gatelevel, Pseq([
					0.1,
				],inf),
				\fb, 0.9,
				\delayfac, 0.00001,
				\mix, 0.21,
				\decay, 0.9,
				\dur, Pseq([1/4],4*4),
				\gain, 0.6,
				\amp, 0.1,
			),
			Pmono(\fx_gatedreverblim,
				\inbus, BusDef(\fx1, \audio),
				//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
				\gatelevel, Pseq([
					0.01,
				],inf),
				\fb, 0.1,
				\delayfac, 0.4,
				\mix, 0.31,
				\decay, 0.9,
				\dur, Pseq([1/4],4*2),
				\gain, 0.6,
				\amp, 0.1,
			),
			Pmono(\fx_gatedreverblim,
				\inbus, BusDef(\fx1, \audio),
				//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
				\gatelevel, Pseq([
					0.01,
				],inf),
				\fb, 0.6,
				\delayfac, 0.4,
				\mix, 0.31,
				\decay, 0.02,
				\dur, Pseq([1/4],4*2),
				\gain, 0.6,
				\amp, 0.1,
			),
			Pmono(\fx_gatedreverblim,
				\inbus, BusDef(\fx1, \audio),
				//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
				\gatelevel, Pseq([
					0.1,0.01,1,
				],inf),
				\fb, 0.6,
				\delayfac, 0.1,
				\mix, 0.31,
				\decay, 0.2,
				\dur, Pseq([1/4],4),
				\gain, 0.6,
				\amp, 0.1,
			),
			Pmono(\fx_gatedreverb,
				\inbus, BusDef(\fx1, \audio),
				//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
				\gatelevel, 0.0009,
				\fb, 0.2,
				\delayfac, 0.1,
				\mix, 0.31,
				\decay, 0.2,
				\dur, Pseq([2],1),
				\gain, 0.8,
				\amp, 0.1,
			),
		],inf),

		
	])
)).play;
)

////////////////////////////////////////////////

(
	SynthDef(\cymbal, { | out = 0, pan = 0.0 |
		var sig, env;
		env = EnvGen.ar(Env.perc(0.01, 2, curve: -4), doneAction: 2);
		sig = HPF.ar(Ringz.ar(WhiteNoise.ar(0.1), {exprand(1000, 20000)}.dup(100)).mean, 1000);
		sig = sig * 0.3;
		Out.ar(out, Pan2.ar(sig * env, pan));
	}).add;
)
"azertyuiop".at(0).hash/100000

(
Pdef(\part, Pdef(\plop, 
	Ppar([
		Pbind(
			\instrument, \cymbal,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		);
	])
)).play;
)


////////////////////////////////////


(
SynthDef(\fx_multitap, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fbr=1, delayr=1, lpfr=1, hpfr=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var tap = { arg idx;
		var fbnode = FbNode(2);
		var sig;

		//sig = fbnode.delay((\delay+++idx).kr(0.25/~t)) * (\fb+++idx).kr(0.3) + in;
		sig = fbnode * (\fb+++idx).kr(1) * fbr + in;
		sig1 = sig;
		sig1 = LPF.ar(sig1, ( \lpf+++idx ).kr(15000) * lpfr);
		sig1 = HPF.ar(sig1, ( \hpf+++idx ).kr(50) * hpfr);
		//sig = fbnode.delay((\delay+++idx).kr(0.25/~t));
		sig = SelectX.ar(\pfmix.kr(1), [sig, sig1]);
		sig = DelayC.ar(sig, 1.1, ( \delay+++idx ).kr(0.1) * delayr);

		fbnode.write(sig);
		sig;
		
	};
	sig = 4.collect(tap).sum;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\fx_multitapbpf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, fbr=1, delayr=1, bpfr=1, rqr=1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var tap = { arg idx;
		var fbnode = FbNode(2);
		var sig;

		//sig = fbnode.delay((\delay+++idx).kr(0.25/~t)) * (\fb+++idx).kr(0.3) + in;
		sig = fbnode * (\fb+++idx).kr(1) * fbr + in;
		sig1 = sig;
		sig1 = BPF.ar(sig1, ( \bpf+++idx ).kr(50) * bpfr, ( \rq+++idx ).kr(0.5) * rqr);
		//sig = fbnode.delay((\delay+++idx).kr(0.25/~t));
		sig = SelectX.ar(\pfmix.kr(1), [sig, sig1]);
		sig = DelayC.ar(sig, 1.1, ( \delay+++idx ).kr(0.1) * delayr);

		fbnode.write(sig);
		sig;
		
	};
	sig = 4.collect(tap).sum;
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.ar(\adsr.kr( Env.adsr(0.01,0.1,0.8,0.1) ),gate,doneAction:2);
	Out.ar(out, sig);
}).add;
)


(
	// multitap
Pdef(\part_drum2, Pdef(\petitdrum, 
	Ppar([
		Pbind(\out, BusDef(\fx1))<>
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				].flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		]),
		Pmono(\fx_multitapbpf,
			\inbus, BusDef(\fx1, \audio),
			\delay0, 1/2/~t,
			\delay1, 1/8/~t,
			\delay2, 3/8/~t,
			\delay3, 6/8/~t,
			\rqr, ~pmodenv.(Pseq(1/[1,2,1,4],inf), 2),
			\bpf0, 1000,
			\bpf1, 400,
			\bpf2, 4400,
			\bpf3, 10400,
			\delayr, 1,
			\hpfr, 1,
			\lpfr, 1,
			\fbr, 0.9,
			\mix, 0.5,
			\dur, 1,
			\amp, 0.1,
		),

		
	])
)).play;
)


Pdef(\part_drum2).clear;
(
Pdef(\part_drum2, Pdef(\petitdrum, 
	Ppar([
		Pbind(\out, BusDef(\fx1))<>
		Ppar([
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
					1,0,1,0, 0,0,0,0,
				].flat,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,

					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,1,0,0, 1,0,0,0,
				],inf).coin.not,
				\sustain, 0.1,
				\dur, 1/8,
				\amp, 0.1,
			)),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('voices/kaspi.flac'),
			\pos, Pseq([
				4,2
			],inf).stutter(2),
			\isRest, Pseq([
				Pseq([
					0,0,
					0,0,
					0,0,
					1,0,
				],inf),
			],inf).coin.not,
			\legato, 2,
			\dur, 1,
			\out, BusDef(\fx, \audio),
			\gain, 1/2,
			\amp, 0.1,
		),
		]),
		Pmono(\fx_multitapbpf,
			\inbus, BusDef(\fx1, \audio),
			\out, BusDef(\fx2, \audio),
			\delay0, 1/2/~t,
			\delay1, 1/8/~t,
			\delay2, 3/8/~t,
			\delay3, 6/8/~t,
			\rqr, ~pmodenv.(Pseq(1/[1,2,1,4],inf), 2),
			\bpf0, 1000,
			\bpf1, 400,
			\bpf2, 4400,
			\bpf3, 10400,
			\delayr, 1,
			\hpfr, 1,
			\lpfr, 1,
			\fbr, 0.9,
			\mix, 0.5,
			\dur, 1,
			\amp, 0.1,
		),
			Pmono(\fx_gatedreverblim,
				\inbus, BusDef(\fx2, \audio),
				\out, BusDef(\fx3, \audio),
				//\lpf, 7000 + Pseg(Pseq([0,4000],inf),8),
				\gatelevel, Pseq([
					0.1,0.01,1,
				],inf),
				\fb, 0.6,
				\delayfac, 0.1,
				\mix, 0.11,
				\decay, 0.2,
				\dur, Pseq([1/4],inf),
				\gain, 1.0,
				\amp, 0.1,
			),
			Pmono(\fx_stutter,
				\inbus, BusDef(\fx3, \audio),
				\freq, 200,
				\mix, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,1, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,1,1,
					0,0,0,0, 0,0,1,0,
				],inf),
				\time, Pstep(Pseq([1/16,1/12],inf),1/4)/~t,
				\fb, 0.1,
				\dur, Pser([1/8],inf),
			),

		
	])
)).play;
)
