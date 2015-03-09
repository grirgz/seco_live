
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfreq.kr(100), \rq.kr(0.3));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	rq: ControlSpec(0.001,4,\lin, 0, 1),
	lpfreq: \freq,
	freq: \freq,
))).add;

BusDef(\fx1, \audio);

Pdef(\plop, Pbind(
	\instrument, \default,
	\out, BusDef(\fx1),
	\legato, 0.1,
	\dur, 1,
	\amp, 0.1
));

Ndef(\echo, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del = 0.2;
	sig = InFeedback.ar(BusDef(\fx1),2);
	sig1 = DelayL.ar(sig, 1,del);
	sig1 = FreqShift.ar(sig1, \shift1.kr(100));
	sig2 = DelayL.ar(sig1, 1,del);
	sig2 = FreqShift.ar(sig2, \shift2.kr(300));
	sig = [sig, sig1, sig2].mean;
});

Spec.add(\shift, ControlSpec(-800,800,\lin,0,1));
Ndef(\echo).addSpec(\shift1, \shift.asSpec);
Ndef(\echo).addSpec(\shift2, \shift.asSpec);

~list = [
	[Pdef(\plop), \freq],
	[Pdef(\plop), \lpfreq],
	[Pdef(\plop), \rq],
	[Ndef(\echo), \shift1],
	[Ndef(\echo), \shift2],
];

);


(
~makegui = { arg fun;
	var win;
	var widget;
	win = Window.new;
	win.layout = HLayout.new(*~list.collect(_.asParam).collect(_.asView));
	win.alwaysOnTop = true;
	win.front;
};
~makegui.();
Pdef(\plop).play;
Ndef(\echo).play;
)


/// Example two



(
~makegui = { arg fun;
	var win;
	var widget;
	win = Window.new;
	win.layout = HLayout.new(*ParamGroup(~list).collect(_.asView));
	win.alwaysOnTop = true;
	win.front;
};
~makegui.();
Pdef(\plop).play;
Ndef(\echo).play;
)
