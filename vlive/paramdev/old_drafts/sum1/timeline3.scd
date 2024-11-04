

(
ParamProto.init;
SynthDef(\doc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,1.001]);
	sig1 = RLPF.ar(sig1, \lpf.kr(1000) * SinOsc.kr(1/4).range(0,1), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);
	sig = HPF.ar(sig, 100);
	sig = BRF.ar(sig, 1500);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\miss, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,1.001]);
	sig1 = RLPF.ar(sig1, \lpf.kr(1000) * SinOsc.kr(1/4).range(0,1), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;


Pdef(\gris, Pbind(
	\instrument, \doc,
	\degree, Pseq([0,4,5, Prand([1,2,3,4])],inf),
	\dur, 1/8,
	\amp, 0.2
));

Pdef(\bleu, Pbind(
	\instrument, \miss,
	\degree, Pseq([0,4,5, Prand([1,2,3,4])],inf),
	\dur, 1/8,
	\amp, 0.2
));


Ndef(\bird, { arg freq=200, pan=0, amp=0.1;
	var sig;
	freq = freq * ( 1 + ( SinOsc.ar(freq * SinOsc.kr(1/4).range(2,1)) * 1 ));
	sig = SinOsc.ar(freq * [1,2,4]);
	sig = CombL.ar(sig, 0.1,0.01 * SinOsc.kr(1/4).exprange(1.01,1),1.1) + sig;
	sig = sig / 3;
	sig = Pan2.ar(sig, SinOsc.ar(1/4 * [1,2,3]) , amp).flop;
});

Ndef(\bird2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * ( 1 + ( SinOsc.ar(freq * SinOsc.kr(1/4).range(2,1)) * 1 ));
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,2,4]);
	//sig = SelectX.ar( XLine.kr(0.001,1.0,4).poll, [sig, sig1]);
	sig = SelectX.ar( SinOsc.kr(1/16).range(0,1), [sig, sig1]);
	sig = CombL.ar(sig, 0.1,0.01 * SinOsc.kr(1/4).exprange(1.01,1),1.1) + sig;
	sig = sig / 3;
	sig = Pan2.ar(sig, SinOsc.ar(1/4 * [1,2,3]) , amp).flop;
});
);



~noteTimeline.new(\ver).edit
~noteTimeline.new(\ver).eventPlay
~noteTimeline.new(\ver).xcl


~noteTimeline.new(\bass1).edit
~noteTimeline.new(\bass2, Param(Pdef(\bass1), \midinote))
~noteTimeline.new(\bass3, Param(Pdef(\bass1), \midinote))


(
	SynthDef(\fizz, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, rel=0.1;
		var sig;
		sig = SinOsc.ar(freq);
		sig = sig * LFSaw.ar(freq / 2);
		sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,rel),gate,doneAction:2);
		sig = Pan2.ar(sig, pan, amp);
		Out.ar(out, sig);
	}).add;

	Pdef(\fizz, Pdef(\fizz1)).play;
	Pdef(\fizz1, Pbind(
		\instrument, \fizz,
		\degree, Pseq([0,1,3,4],inf),
		\freq, Pwhite(0.0,1).linexp(0,1,100,5000),
		\rel, Pseg(Pseq([1,0],inf),8),
		//\legato, Pwhite(0.1,4),
		\sustain, Pwhite(0.1,0.4),
		\dur, Pseq([1,2,3,1/2],inf)/8,
		\amp, 0.1
	));
	~addfx.(Pdef(\fizz), Ndef(\fizz)).play;
	Ndef(\fizz)[1] = \filter -> { arg in;
		var sig;
		sig = CombL.ar(in, 0.1,0.1,1 * SinOsc.kr(1/4).range(0,4)) + in;
		sig = FreqShift.ar(sig, SinOsc.kr(1/7).range(0,10));
		sig
	};
)
Ndef(\fizz).fadeTime = 2
Ndef(\fizz).fadeTime = 0.1
Ndef.defaultQuant = 4
Pdef.defaultQuant = 4
Ndef.defaultQuant = 0;
Pdef.defaultQuant = 0;

	(
	Pdef(\fizz1, Pbind(
		\instrument, \fizz,
		\degree, Pseq([0,1,3,4],inf),
		//\freq, Pwhite(0.0,1).linexp(0,1,100,5000),
		\rel, Pseg(Pseq([1,0],inf),8),
		//\legato, Pwhite(0.1,4),
		\sustain, Pwhite(0.1,0.4),
		\dur, Pseq([1,2,3,1/2],inf)/8,
		\amp, 0.1
	));
	Ndef(\fizz)[1] = \filter -> { arg in;
		var sig;
		sig = CombL.ar(in, 0.4,0.4,1 * SinOsc.kr(1/4).range(0,4)) + in;
		sig = FreqShift.ar(sig, SinOsc.kr(1/7).range(0,10)) + sig;
		sig
	};
	)

	(
	Pdef(\fizz2, Pbind(
		\instrument, \fizz,
		\degree, Pseq([0,1,3,4],inf),
		//\freq, Pwhite(0.0,1).linexp(0,1,100,5000),
		\rel, Pseg(Pseq([1,0],inf),8),
		//\legato, Pwhite(0.1,4),
		\sustain, Pwhite(0.1,0.4),
		\dur, Pseq([1,3],inf)/8,
		\amp, 0.1
	));
	Ndef(\fizz)[1] = \filter -> { arg in;
		var sig;
		sig = CombL.ar(in, 0.1,0.1 * SinOsc.kr(1/8).range(0.1,1),1 * SinOsc.kr(1/4).range(0,4)) + in;
		sig = FreqShift.ar(sig, SinOsc.kr(1/7).range(0,10));
		sig
	};
	)

	(
	Pdef(\fizz).play;
	Ndef(\fizz).play;
	Pdef(\fizz1, Pbind(
		\instrument, \fizz,
		\degree, Pseq([0,1,3,4],inf),
		//\freq, Pwhite(0.0,1).linexp(0,1,100,5000),
		\rel, Pseg(Pseq([1,0],inf),8),
		//\legato, Pwhite(0.1,4),
		\sustain, Pwhite(0.1,0.4),
		\dur, Pseq([1,3],inf)/8,
		\amp, 0.1
	));
	~envTimeline.new(\fizz_hi, Param(BusDef(\fizz_hi, \control), \lev, ControlSpec(0,1,\lin)));
	Ndef(\fizz)[1] = \filter -> { arg in, lev;
		var sig;
		sig = CombL.ar(in, 0.1,0.1 * lev.linlin(0,1,4,0.01).lag(0.1),1 * lev.linlin(0,1,0.1,4)) + in;
		sig = FreqShift.ar(sig, lev.linlin(0,1,0,10));
		sig
	};
	Ndef(\fizz).set(\lev, BusDef(\fizz_hi).asMap);
	~envTimeline.new(\fizz_hi).eventPlay;
	)
	~envTimeline.new(\fizz_hi).edit;

(
~addfx = { arg pdef, ndef;
	var bus = BusDef("fx_%_%".format(pdef.key, ndef.key).asSymbol, \audio, 2);
	pdef.set(\out, bus);
	ndef[0] = { arg inbus;
		var sig = InFeedback.ar(inbus, 2);
		sig;
	};
	ndef.set(\inbus, bus);
	ndef;
}
)


///////////////////////


(
SynthDef(\bass1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq);
	sig1 = LFSaw.ar(freq * [1,1.001]);
	sig1 = RLPF.ar(sig1, \lpf.kr(1000) * [1,2,4] * SinOsc.kr(1/4, Rand(0,2pi)).range(0,1), \rq.kr(0.5));
	sig = SelectX.ar(\mix.kr(0.5), [sig, sig1]);

	sig = sig * 0.8;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

Pdef(\bass1, Pbind(
	\instrument, \bass1,
	\degree, Pseq([0,4,5, Prand([1,2,3,4])],inf),
	\dur, 1/8,
	\amp, 0.1
));



/////////////////

SynthDef(\bono, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Pdef(\bono, Pbind(
	\instrument, \bono,
	\degree, Pseq([0],inf),
	\dur, 1,
	\out, BusDef(\main1, \audio),
	\amp, 0.3
));

Pdef(\bono2, Pbind(
	\instrument, \bono,
	\degree, Pseq([0,12,-12],inf),
	\dur, 1/4,
	\out, BusDef(\main1, \audio),
	\amp, 0.3
));

Pdef(\bono3, Pbind(
	\instrument, \bono,
	\degree, Pseq([0,12,-12],inf).stutter(8),
	\dur, 1/8,
	\out, BusDef(\main1, \audio),
	\amp, 0.3
));

///////////////////////////

Ndef(\bono, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in;
	in = InFeedback.ar(BusDef(\main1, \audio), 2);
	//sig = LFSaw.ar(freq + ( in * 100 ));
	sig = in;
	sig = RLPF.ar(sig, \lpf.kr(1000), \rq.kr(0.5));
	sig = Pan2.ar(sig, pan, amp);
});

Ndef(\bono2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in;
	in = InFeedback.ar(BusDef(\main1, \audio), 2);
	//sig = LFSaw.ar(freq + ( in * 100 ));
	sig = in;
	sig = RLPF.ar(sig, 1000 * SinOsc.kr(2).range(0.1,5), \rq.kr(0.5));
	sig1 = FreqShift.ar(sig, SinOsc.kr(1/5).range(0,1000)) + sig;
	sig = SelectX.ar( SinOsc.kr(1/4).range(0,1), [sig, sig1]);
	sig = Pan2.ar(sig, pan, amp);
});
)

(
~noteTimeline.new(\bass1, Param(Pdef(\bass1), \midinote));
~noteTimeline.new(\bass2, Param(Pdef(\bass1), \midinote));
~noteTimeline.new(\bass3, Param(Pdef(\bass1), \midinote));
~noteTimeline.new(\bass4, Param(Pdef(\bass1), \midinote)).edit;
~modStepTimeline.new(\renard_perc).drumrack = DrumRack(\renard);
);
~noteTimeline.new(\bass4, Param(Pdef(\bass1), \midinote)).editor
/////////////////
~clipTimeline.new(\renard).edit
/////////////////


~w = Window.new;
~w.front
~w.addToOnClose({"bla".debug});
~w.addToOnClose({"bxxla".debug});
~w.onClose = ~w.onClose.addFunc({"bxxla".debug});
~w.onClose = ~w.onClose.addFunc({"bxxxeexxla".debug});
~w.onClose.add({"kk".debug})
~w.onClose = {"kkxx".debug}
~f = FunctionList.new
~f.addFunc({"ll".debug})
