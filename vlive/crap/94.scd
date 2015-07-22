(

Pdef(\basic, { arg ton, tierce, quinte, dur=1;
                Pbind(
                        \degree, [ton, tierce, quinte],
                        \amp, Pseq(
                        ([1,0]!8).flat +++
                        ([1,1]!8).flat +++
                        ([0,0, 1, 0]!4).flat
                ),
                \dur, dur/8
                ).trace
});

Pbind(
        \type, \phrase,
        \instrument, \basic,
        \ton, 0,
		\legato, 1,
        \tierce, 2,
        \quinte, 4,
        \dur, 5
).play

)

(
	var synthdef;
	synthdef = { arg out=0, gate=1, freq=333, noise = 0, a, d, s, r, ctf, res, amt, lvl;
	    var sig, env;
	    sig = Pulse.ar(freq * [1, 0.99922149]);
	    sig = sig+WhiteNoise.ar(noise);
	    env = EnvGen.kr(Env.adsr(a, d, s, r), gate, doneAction: 2);
	    sig = sig * env;
	    sig = RLPF.ar(sig, (ctf*2000)+(env*amt*1000), res);
	    sig = sig * lvl;
	    Out.ar(0, sig!2);
	};

	NiceGui.folder = "/tmp/";
	NiceGui.new(\testdef, synthdef).gui;

)

{ Gate.kr(WhiteNoise.kr(1, 0), LFPulse.kr(1.333, 0.5)) }.scope(zoom: 20);
{ Gate.ar(WhiteNoise.ar(1, 0), LFPulse.ar(61.333, 0.5)) ! 2 }.play;

(
Ndef(\plop).put(0, { arg freq=200, rq=0.1, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = WhiteNoise.ar(1, 0);
	sig2 = LPF.ar(WhiteNoise.ar(1, 0),  SinOsc.kr(1/16 * [1,2,3,4]/2).range(100,9001));
	sig3 = LFSaw.ar(( freq* [1/2,1,2,1] ).clip(20,15000)) * [1,4,1/2,2];
	sig1 = SelectX.ar(\mixg.kr(0.5).lag(0.1)*2, [sig1, sig2, sig3]);
	sig = Gate.ar(sig1, LFPulse.ar( SinOsc.kr(1/8 * [1,2,3,4].reverse/2).range(30,100), 0.5));
	sig = Gate.ar(sig, LFPulse.ar( freq ));
	sig = RLPF.ar(sig, ( freq * SinOsc.kr([1,2,3,4]/4).range(1,4) ).clip(20,15000), rq * [1,2,3,4]);
	sig1 = LFPulse.ar(freq * [1,1/2]) * [1,1/2];
	sig = SelectX.ar(\mix.kr(0.8).lag(0.1)*2, [sig, sig1 * sig, sig1]);
	sig1 = BPF.ar(sig, ( freq*2 ).clip(20,15000), rq) * 5;
	sig2 = BPF.ar(sig, freq, rq) * 5;
	sig3 = BPF.ar(sig, freq/2, rq) * 5;
	sig = SelectX.ar(\mix2.kr(0.6).lag(0.1) * 3, [sig, sig1, sig2, sig3]);
	sig = Pan2.ar(sig, LFNoise1.kr(1/2 * [1,2,3,4]).range(-1.0,1.0) * 0.3, amp).mean;
}).play;

Spec.add(\mix, \unipolar);
Spec.add(\mix2, \unipolar);
Spec.add(\mixg, \unipolar);
);

Ndef(\plop).edit;

Ndef(\plop).unset(\freq);

(
	Ndef(\plop).put(1, \set -> Pbind(
		\degree, Pseq([
			0,3,2,3,
			4,2,2,3,
		],inf),
		\octave, 4,
		\dur, Pseq([1,2,4,1],inf)/4,
	)
);
)

Ndef(\plop).unset(\freq, \mix, \mixg, \mix2);
(
	Ndef(\plop).put(1, \set -> Pbind(
		\degree, Pseq([
			0,3,2,3,
			4,2,2,3,
		],inf),
		\octave, 4,
		\mix, Pseq([0,1],inf) * Pseq([1,2,4,2,3]/4,inf).stutter(8),
		\mixg, Pseq([0,0,1],inf),
		\mix2, Pseq([0,1/2,0,0,1],inf),
		\dur, Pseq([1,2,4,1],inf)/4,
	)
);
)
