
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var seq1, seq2, seq3, seq4, seq5, seq6, seq7, seq8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	env1 = EnvGen.kr(Env([1/16,2,0.9,1,1/4],[0.1,1.8,0.1,2]), 1);
	env2 = EnvGen.kr(Env([1/16,2,0.9,1,1/4],[0.1,0.8,0.1,2]), 1);
	env3 = EnvGen.kr(Env([1/16,2,0.9,1,1/4],[1.1,0.8,0.1,2]), 1);
	env4 = EnvGen.kr(Env([1/16,2,0.9,1,1/4],[0.4,0.8,1.1,2]), 1);
	lfo1 = ( LFPulse.ar(12 * env1.clip(1,2)) * 0.95 + 1 );
	lfo1 = lfo1 * ( LFPulse.ar(12.13 * env1.clip(1,2)) * 0.95 + 1 );
	lfo2 = ( LFSaw.ar(9 * env1) * 0.05 + 1 );
	sig1 = LFSaw.ar(freq * lfo1 * env1 * ( SinOsc.ar(env2 * freq * (1..8) * [1,1.00001].flop) * 1 + 1 )).mean;
	sig1.debug("sig");
	sig1 = RLPF.ar(sig1, \lpfr.kr(1.1) * freq * lfo2 * env3, \rq.kr(0.5));


	sig2 = LFSaw.ar(freq * env4) * 0.1;
	sig2 = CombL.ar(sig2, 0.1, env4.range(0.00001,0.001), 0.1) + sig2;
	sig = [sig1, sig2]/4;


	sig = Pan2.ar(sig, [1,-1], amp).mean;
}).play;
);


(
	// saw alarm
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*5, 2), Impulse.kr(1/4));
	sig = LFSaw.ar(freq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig, 0.1, 0.0001 * LFNoise1.kr(1/19).range(0.1,100) * env1, 0.1) + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,2.8]), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,1.8]*6), Impulse.kr(1/8));
	env3 = EnvGen.kr(Env([0.1,0.1,0.2,0.01],[0.1,0.1,2.8]*3), Impulse.kr(1/4.3));
	freq = freq * LFPulse.ar(9*[1,1.01] * env2, mul: env3, add:1).sum;
	sig = LFSaw.ar(freq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig.flop, 0.5, 0.0101 * env2 * ((0..7)/7 - 0.5 * 0.1 + 1) * env1, 0.1).mean + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig.debug("sig");
	sig = sig * amp;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,2.8]), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,1.8]*6), Impulse.kr(1/8));
	env3 = EnvGen.kr(Env([0.1,0.1,0.2,0.01],[0.1,0.1,2.8]*3), Impulse.kr(1/4.3));
	env4 = EnvGen.kr(Env([1,1,14,0.05],[0.1,1.1,1.8]*6), Impulse.kr(1/8));
	freq = freq * LFPulse.ar(9*[1,1.01] * env2, mul: env3, add:1).sum;
	sig = LFSaw.ar(freq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig.flop, 1.0, 0.051 * env4 * ((0..7)/7 - 0.5 * env3+ 1) * env1, 0.3).mean + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig.debug("sig");
	sig = sig * amp;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var xfreq;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,2.8]), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,1.8]*6), Impulse.kr(1/8));
	env3 = EnvGen.kr(Env([0.1,0.1,0.2,0.01],[0.1,0.1,2.8]*3), Impulse.kr(1/4.3));
	env4 = EnvGen.kr(Env([1,1,14,0.05],[0.1,1.1,1.8]*6), Impulse.kr(1/8));
	xfreq = freq * LFPulse.ar(9*[1,1.01] * env2, mul: env3, add:1).sum;
	sig = LFSaw.ar(xfreq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig.flop, 1.0, SinOsc.ar(freq/8) * 0.03 + 0.1, 0.3).mean + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig.debug("sig");
	sig = sig * amp;
}).play;
);
