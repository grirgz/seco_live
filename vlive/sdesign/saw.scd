// the comb make a special noise when given a LFSaw and the cut frequency is lfoed
(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2));
	sig = LFSaw.ar(freq) * 0.2;
	sig = CombL.ar(sig, 0.1, 0.01 * env1, 0.01) + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig!2 * amp;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2));
	sig = LFSaw.ar(freq) * 0.12;
	sig = CombL.ar(sig, 0.1, 0.0005 * env1, 0.1) + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig!2 * amp;
}).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,5,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,5,1],[0.1,1.1,0.8]*3), Impulse.kr(1/3));
	sig = LFSaw.ar(freq) * 0.12;
	sig = CombL.ar(sig, 0.1, SinOsc.kr(1/23).exprange(0.00001,0.1) * env1, 0.1 * env2) + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig!2 * amp;
}).play;
);

(
// swing also the osc freq
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2));
	sig = LFSaw.ar(freq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig, 0.1, 0.0001 * LFNoise1.kr(1/19).range(0.1,100) * env1, 0.1) + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

(
// desync env
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3.01), Impulse.kr(1/2));
	sig = LFSaw.ar(freq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig, 0.1, 0.0001 * LFNoise1.kr(1/19).range(0.1,100) * env2, 0.1) + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

(
// desync env 2
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2 + 0.01));
	sig = LFSaw.ar(freq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig, 0.1, 0.0001 * LFNoise1.kr(1/19).range(0.1,100) * env2, 0.1) + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

(
// desync env4
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2)) + LFNoise1.kr(1/2).range(0.0,1);
	sig = LFSaw.ar(freq * env1* [1,1.0001].flop * [1,2]).mean * 0.1;
	sig = CombL.ar(sig, 0.1, 0.0001 * LFNoise1.kr(1/19).range(0.1,100) * env2, 0.1) + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);
/////////////////


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,1,1.02,1],[0.1,0.1,1.8]*3), Impulse.kr(1/2));
	env2 = EnvGen.kr(Env([1,1,2,1],[0.1,0.1,0.8]*3), Impulse.kr(1/2));
	sig = LFSaw.ar(freq * env1 * [1.00001,1]);
	sig = CombL.ar(sig.flop, 0.1, 0.0001 * LFNoise1.kr(1/19!2).range(0.1,100) * env2, 0.1).mean + sig;
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp * 0.2;
}).play;
);




