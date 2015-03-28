
(
	Ndef.defaultQuant = 2;
	~t = 1;
Ndef(\plop).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = 710;
	//freq = freq * [1,2,3,4];
	freq = freq * Duty.kr(4/~t, 0, Dseq([
		[0,3,7,9],
		[0,3,7,9]+4,
	],inf)).midiratio;

	sig = SinOsc.ar(freq); 
	sig = HenonC.ar(freq) + sig;

	//sig = RLPF.ar(sig, \lpf.kr(7100), \rq.kr(0.5));
	
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
}).play
)


(
Ndef(\plop2).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = 70 ;
	//freq = freq * [1,2,3,4];
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,4,3,2,
	],inf)).midiratio;
	freq = freq * [1,2,1/2];

	sig = LFSaw.ar(freq); 
	//sig = HenonC.ar(freq, 2) + sig;


	sig = RLPF.ar(sig, \lpf.kr(400), \rq.kr(0.5));
	sig = sig + DelayL.ar(sig, 0.1,0.001 * SinOsc.kr(1/2 * (1..8)/8).range(1.1,1));
	sig = sig.tanh;
	sig = sig * 1/2;
	
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.01), amp, \pan.kr(0));
	sig = sig.mean;
	sig.debug("1");
	sig = Pan2.ar(sig, 0, 1);
	sig.debug("2");
	//sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
}).play
)
Ndef(\plop2).edit

(
Ndef(\plop3).put(0, { arg amp=0.1;
	var sig;
	var freq;
	freq = 1700 ;
	//freq = freq * [1,2,3,4];
	freq = freq * Duty.kr(1/4/~t, 0, Dseq([
		Dseq([
			0,12,2,14,
			0,0,0,0,
		],3),
		Dseq([
			0,12,2,14,
			12,0,24,-12,
		]+2,1),
	],inf)).midiratio.lag( Duty.kr(1/~t, 0, Dseq([
		1,0.2,0,0.3,
	],inf)));
	freq = freq * [1,2,1/2];

	sig = LFSaw.ar(freq); 
	sig = HenonC.ar(freq * 2, 2) * sig;


	sig = RLPF.ar(sig, \lpf.kr(7400), \rq.kr(0.5));
	sig = sig + DelayL.ar(sig, 0.1,0.001 * SinOsc.kr(1/9 * (1..8)/8).range(1.1,1));
	sig = sig * 2;
	sig = sig.tanh;
	
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.01), amp, \pan.kr(0));
	//sig = sig.mean;
	sig.debug("1");
	//sig = Pan2.ar(sig, 0, 1);
	sig.debug("2");
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)*0.2} ! sig.size, amp).sum;
	sig;
}).play
)

(
Ndef(\kick).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate = Impulse.kr(1*~t);
	env1 = EnvGen.ar( Env([4000,700,40,10],[0.01,0.03,0.8]),gate,doneAction:0);
	env2 = EnvGen.kr(\adsr.kr(Env.adsr(0.0001,0.1,0.8,0.4)), Trig.kr(gate,0.1));


	sig = SinOsc.ar(env1 * 1);
	sig = WhiteNoise.ar(1 * [1,2]) + sig;
	sig = RHPF.ar(sig, env1*1);
	sig = LPF.ar(sig, 500 * EnvGen.kr(Env([1,8,1],[0.001,0.1], -4), gate));
	sig = sig * env2;
	sig = sig /4;
	sig = CompanderD.ar(sig, 0.4,1,0.3);
	sig = sig.sum;
	sig = Pan2.ar(sig, 0, amp);
	sig;
}).play
)

(
Ndef(\kick2).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate = Impulse.kr(8*~t);
	env1 = EnvGen.ar( Env([4000,700,40,10],[0.01,0.03,0.8]),gate,doneAction:0);
	env2 = EnvGen.kr(\adsr.kr(Env.adsr(0.001,0.01,0.8,0.01)), Trig.kr(gate,0.021));


	sig = WhiteNoise.ar(1 * [1,1]);
	sig = RLPF.ar(sig, 5000 * LFSaw.kr(1*~t).range(2,1));
	sig = sig.sum;
	sig = sig * env2;
	sig = sig /2;
	sig = Pan2.ar(sig, 0, amp);
	sig;
}).play
)

Ndef(\kick2).gui
n = NdefMixer(s);

(
Ndef(\lfo1, { arg freq=2, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.kr(freq*~t).unipolar * amp;
}).play;
);



g = NdefParamGui.new(nil, 5);    // empty with 5 slots
g.object_(Ndef(\a));        // put in a nodeproxy
Ndef(\a, { |freq = 300, amp = 0.2| SinOsc.ar(freq) * amp  });
Ndef(\a).set(\freq, 2000);  



(
Pdef(\a, { |e| 100.do { |i| i.postln; 0.5.wait } });
Pdef(\b, { |e| 100.do { |i| Pdef(\a).set(\otto, 8.rand); exprand(0.1, 3.0).wait } });
t = PdefAllGui(8);
)


(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([[0,3,7], [2,6]],inf),
	\legato, 0.1,
	\dur, 1/4,
	\amp, 0.1
)).play;
);

Pdef(\plop).gui

g = EnvirGui.new(nil, 5);                // empty with 5 slots
g.object_((a: 1, b: \werty, freq: [500, 2000]));    // put some things in
g.envir.put(\karl, \otto1);                // one more
g.envir.putAll((b: -12, r: 1, s: 2, t: 3, u: 4, v: 5))

g.object_((x: 2));    // put something else in

g.envir.putAll((b: -12, r: 1, s: 2, t: 3, u: 4, v: 5))

g.envir.removeAt(\b)
g.envir.removeAt(\r)
g.envir.removeAt(\s)
g.envir.removeAt(\t)
g.envir.removeAt(\u)
g.envir.removeAt(\v)

g.parent.close;
