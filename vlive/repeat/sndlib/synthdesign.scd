
// oscm_lpadsr_oscfmadsr
(
SynthDef(\oscfmpad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var fm, fmenv;
	var fspread = ((0..7)/7 - 0.5 * \fspread.kr(0.001) + 1);
	var xfreq, fmfreq;

	fmenv = EnvGen.kr(\fmadsr.kr(Env.adsr(1.1,0.1,0.8,1.1)), gate) * \fmadsramt.kr(1) + 1;
	fmfreq = freq * \fmf.kr(1/2);
	sig1 = LFSaw.ar(fmfreq);
	sig2 = Pulse.ar(fmfreq);
	sig3 = SinOsc.ar(fmfreq);
	fm = SelectX.ar(\fmoscmix.kr(0.5)*2, [sig1, sig2, sig3]) * fmenv * \fma.kr(1) + 1;

	xfreq = freq * fspread * fm;
	sig1 = LFSaw.ar(xfreq);
	sig2 = LFPulse.ar(xfreq).bipolar;
	sig3 = SinOsc.ar(xfreq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	sig.debug("sig");

	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(1.1,0.1,0.8,1.1)), gate) * \lpadsramt.kr(1) + 1;
	sig = RLPF.ar(sig, ( \lpf.kr(700) * env1 ).clip(20,20000), \rq.kr(0.5));
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(1.1,0.1,0.8,1.1)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\nosepad, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
    var sig;
    var env1, env2, env3, env4, env5, env6, env7, env8;
    env1 = XLine.kr(1/freq * \rampstartfac.kr(1),1/freq * \rampendfac.kr(1),\ramptime.kr(8));
    env2 = XLine.kr(\decaystart.kr(0.1),\decayend.kr(10),\decaytime.kr(1));
    sig = SinOsc.ar(freq * [ [1,2,1/2] ] * ( SinOsc.ar( ( SinOsc.ar( (1..8) * \fmfreqfac2.kr(1) ) * \fma2.kr(1) + 1 ) * freq * \fmfreqfac.kr(1) ) * \fma.kr(1) + 1 ));
    sig = sig.flop.mean;
    sig.debug("sig");
    sig = CombL.ar(sig, \maxdelay.kr(0.1), env1, \combdecay.kr(10)*env2) + sig;
    sig = AllpassL.ar(sig, \maxdelay.kr, env1, \combdecay2.kr(10)*env2) + sig;
    sig = Limiter.ar(sig,1,0.01);
    sig = sig * \gain.kr(1) * 1/4;
    sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
    sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
    Out.ar(out, sig);
}).add;

SynthDef(\fsinharm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = FSinOsc.ar(freq* (1..8) * [ \chord.kr([1,3/2]) ]) * (LFNoise1.kr(\noisefreq.kr(6)!2!8) * ( 1/( (1..8)**(\harm.kr(1))+1 ) ) * 0.8).max(0);
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.3,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * amp;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
)
