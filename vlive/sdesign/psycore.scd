
(
	// high pitched sounds
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,2.8]), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,1.8]*6), Impulse.kr(1/8));
	env3 = EnvGen.kr(Env([0.1,0.1,2,0.01],[0.1,0.1,2.8]*3), Impulse.kr(1/4.3));
	freq = freq * LFPulse.ar(9 * env2, mul: env3, add:1);
	sig = LFSaw.ar(freq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig, 0.1, 0.0001 * env2  * env1, 0.1) + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

(
	// spread comb
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,2.8]), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,1.8]*6), Impulse.kr(1/8));
	env3 = EnvGen.kr(Env([0.1,0.1,2,0.01],[0.1,0.1,2.8]*3), Impulse.kr(1/4.3));
	freq = freq * LFPulse.ar(9 * env2, mul: env3, add:1);
	sig = LFSaw.ar(freq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig.flop, 0.5, 0.0101 * env2 * ((0..7)/7 - 0.5 * 0.1 + 1) * env1, 0.1).mean + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig.debug("sig");
	sig = sig * amp;
}).play;
);
