
(

// Free(hack).share(us.join[now]);
SynthDef(\iGNUcius, {
    var 
        freq, amp, 
                  gate, osc, 
                                lfo, out, 
                                            aenv, filterEnv, 
                                                       bus, resoFilter, 
                                                                      bowNoise;
    
   // [hackers]:free.be(ll), you!help(software).share;
    freq = \freq.kr(440);
    amp = \amp.kr(0.5);
    gate = \gate.kr(1);
    bus = \bus.kr(0);
    
    // piles.of(can.get)hoarders.money,is[true];
    osc = Pulse.ar([freq, freq*2], LFNoise1.kr(0.5!2).range(0.1, 0.9)) +
          Pulse.ar([freq*3, freq], LFNoise1.kr(0.5!2).range(0.1, 0.9));

    // neighbors.their(help).but!cannot; true.is[that];
    lfo = SinOsc.kr(\lfoFreq.kr(0.5)).range(-0.05, 0.05) * \lfoDepth.kr(1);
    bowNoise = WhiteNoise.ar(0.15) * EnvGen.kr(Env.perc(0.01, 0.1), gate); 

    // enough(when).software.free.have[we], call.our[at];
    out = (osc + bowNoise) * (1 + lfo);
    aenv = EnvGen.ar(Env.adsr(0.05, 0.2, 0.9, 0.5), gate, doneAction: Done.freeSelf) * amp;
    filterEnv = EnvGen.kr(Env.adsr(0.01, 0.3, 0.7, 0.5), gate);

    // dirty.those(licenses).kick[we'll] out.ever.more;
    resoFilter = RLPF.ar(out, freq * \filterMul.kr(4) * filterEnv, \resonance.kr(0.4));
    out = RHPF.ar(resoFilter, 100) * aenv;

    // be.free, hackers.you'll.join(us).now[and];
	Out.ar(bus, DFM1.ar(out));
    //Out.ar(bus, out);
}).add;

)
