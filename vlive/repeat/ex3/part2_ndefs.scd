
(
Ndef(\part2_treb, { arg freq=800, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, 0,0,2,2,
		0,0,0,0, 0,0,2,2,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,2,0,2,
		0,0,0,0, 0,0,2,2,
		0,0,0,0, 0,0,2,2,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 2,0,0,2,
	],inf)).midiratio * freq;
	freq = freq * SinOsc.kr(16).range(1.02,1);
	freq = LagUD.kr(freq, 0,0);
	sig = LFSaw.ar(freq * [1,1.01,1/2]);
	sig = ( sig * 100 ).tanh / 2;
	sig = sig + HPF.ar(CuspN.ar(freq), 1000);
	"sig %".format(sig).postln;
	sig = sig * CuspN.ar([1,1,1], [1,1.01,1.02]);
	sig = sig * 0.3;
	sig = Pan2.ar(sig, pan, amp).mean;
	"sig2 %".format(sig).postln;
	sig;
});
);

(
Ndef(\part2_treb_b, { arg freq=800, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 2,2,2,2,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 2,0,2,2,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 2,2,0,2,
		0,0,0,0, -3,0,0,0,
		0,0,0,0, 2,2,2,2,
	],inf)).midiratio * freq;
	//freq = freq * SinOsc.kr(16).range(2,1);
	freq = LagUD.kr(freq, 1/~t,0);
	sig = LFSaw.ar(freq * [1,1.01,1/2]);
	sig = ( sig * 100 ).tanh / 2;
	sig = sig + HPF.ar(CuspN.ar(freq), 1000);
	"sig %".format(sig).postln;
	sig = sig * CuspN.ar([1,1,1], [1,1.01,1.02]);
	sig = sig * 0.3;
	sig = Pan2.ar(sig, pan, amp).mean;
	"sig2 %".format(sig).postln;
	sig;
});
);

(
Ndef(\part2_treb_c, { arg freq=800, pan=0, amp=0.1;
	var sig;
	freq = Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 2,2,2,2,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 2,0,2,2,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 2,2,0,2,
		0,0,0,0, -3,0,0,0,
		0,0,0,0, 2,2,2,2,
	],inf)).midiratio * freq;
	//freq = freq * SinOsc.kr(16).range(2,1);
	freq = LagUD.kr(freq, 1/~t,0);
	sig = LFSaw.ar(freq * [1,1.01,1/2]);
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		1,0,1,0, 1,0,1,0,
		1,0,0.5,0, 1,0,0.5,0,
		1,0,0,0.5, 0,0,0.5,0,
		1,0,0.5,0, 1,0,0.5,0,

		1,1,0,0, 0,0,0,0,
		1,1,0,0, 0,0,0,0,
		1,0,0,0, 0,0,1,0,
		1,1,0,0, 0,0,0,0,

		1,0,1,0, 1,0,1,0,
		1,0,0.5,0, 1,0,0.5,0,
		1,0,0,0.5, 0,0,0.5,0,
		1,0,0.5,0, 1,0,0.5,0,

		1,0,1,0, 1,0,1,0,
		1,0,0.5,0, 1,0,0.5,0,
		1,0,0,0.5, 0,0,0.5,0,
		1,0,0.5,0, 1,0,0.5,0,



		1,0,1,0, 1,0,1,0,
		1,0,0.5,0, 1,0,0.5,0,
		1,0,0,0.5, 0,0,0.5,0,
		1,0,0.5,0, 1,0,0.5,0,

		1,1,0,0, 0,0,0,0,
		1,1,0,0, 0,0,0,0,
		1,0,0,0, 0,0,1,0,
		1,1,0,0, 0,0,0,0,

		1,1,0,0, 0,0,0,0,
		1,1,0,0, 0,0,0,0,
		1,0,0,0, 0,0,1,0,
		1,1,0,0, 0,0,0,0,

		1,1,0,0, 0,0,0,0,
		1,1,0,0, 0,0,0,0,
		1,0,0,0, 0,0,1,0,
		1,1,0,0, 0,0,0,0,
	],inf));
	sig = ( sig * 100 ).tanh / 2;
	sig = sig + HPF.ar(CuspN.ar(freq), 1000);
	"sig %".format(sig).postln;
	sig = sig * CuspN.ar([1,1,1], [1,1.01,1.02]);
	sig = sig * 0.3;
	sig = Pan2.ar(sig, pan, amp).mean;
	"sig2 %".format(sig).postln;
	sig;
});
);


(
Ndef(\part2_zip, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(Env([4,4,2,1,3],[0,0.1,0.8,0.3]), Impulse.kr(1/2*~t));
	sig = LFSaw.ar(freq * env1 * [1,1.01]).mean;
	sig = HPF.ar(sig, SinOsc.kr(1/2*~t).range(2,1) * freq);
	sig = LPF.ar(sig, SinOsc.kr(1/4*~t / [1,1.01],1).range(2,1) * freq * 4);
	sig1 = LFSaw.ar(freq * [1/2,2] * env1) * SinOsc.kr(1/12 * ( 1 + ( SinOsc.kr(1/2) * 1 ))).range(0,1) / 2;
	sig = sig + sig1;
	sig = sig /10 ;
	sig = BRF.ar(sig, freq * env1, 0.01);
	sig = ( sig * 480 ).tanh / 12;
	sig = Pan2.ar(sig, SinOsc.kr([1,1.01]/8) * 0.4 + pan, amp).mean;
});
);

// END

(
Ndef(\part2_trip, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1/2,1,2];
	sig1 = SinOsc.ar(freq); 
	sig2 = LFSaw.ar(freq);
	env1 = Duty.kr( SinOsc.kr(1/2).range(0.01,1), 0, Dseq([
		1,0,Drand([1,0]),1,0,
	],inf));
	env1 = LFPulse.ar(1/2 * SinOsc.kr(1/2).range(0.01,100)).range(0,1);
	sig = SelectX.ar(env1, [sig1, sig2]);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.1,0.8]), Impulse.kr(1*~t));
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\part2_trip, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var ttrig;
	ttrig = Impulse.kr(1/2*~t);
	freq = freq * EnvGen.kr(Env([1,1.2,1,0.3],[0.4,0.8,1]), ttrig);
	freq = freq * [1/2,1,2];
	sig1 = SinOsc.ar(freq); 
	sig2 = LFSaw.ar(freq);
	env1 = LFPulse.ar(1/2 * EnvGen.kr(Env([1,0.1,50,1],[0,0.3,0.8]), ttrig)).range(0,1);
	sig = SelectX.ar(env1, [sig1, sig2]);
	sig = sig * EnvGen.kr(Env([0,1,0],[0.1,0.8]), ttrig);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
SynthDef(\dustman, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env3 = EnvGen.kr(\difadsr.kr(Env.adsr(0.4,1.4,0.08,0.7)), gate);
	sig = LFSaw.ar(freq * [1/2,1,2] *.t ( 1 + ((1..10)/10 / \diff.kr(200) *  env3 ) ) ).mean;
	env1 = EnvGen.kr(\lpfadsr.kr(Env.adsr(0.1,0.1,4.8,0.7)), gate);
	env2 = EnvGen.kr(\rqadsr.kr(Env.adsr(0.1,0.1,0.18,0.7)), gate);
	sig = RLPF.ar(sig, freq * env1, \rq.kr(1) * env2);
	sig = sig.tanh;
	sig = sig * 3;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.7),gate,doneAction:2);
	sig = Pan2.ar(sig, (1..10)/10-0.5, amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	difadsr: XEnvSpec.adsr,
	lpfadsr: XEnvSpec.adsr,
	rqadsr: XEnvSpec.adsr,
	diff: \widefreq,
))).add;
);

NoteTimeline(\dust, Param(Pdef(\dust), \midinote)).edit;

WindowDef(\PdefEditor).front(Pdef(\dust));
Pdef(\dust).asParamGroup

(
Pdef(\dust, Pbind(
	\instrument, \dustman,
	\degree, Pseq([Pwhite(-2,2)],inf) * Pseq((1..10),inf).stutter(12) + Pseq((1..10),inf).stutter(10),
	\octave, 4,
	\isRest, Pseq([
		1,1,1,1, 1,1,1,1,
		//1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\legato, Pwhite(2,0.1),
	\dur, Pwhite(1,0.1),
	\amp, 0.1
)).play;
);
