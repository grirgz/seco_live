(
SynthDef(\part2_bass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, predistamp=4, postdistamp=0.8;
	var sig;
	var sig0, sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = SinOsc.ar(freq, mul:\osc1amp.kr(1));
	sig = sig + SinOsc.ar(freq/2, mul:\osc2amp.kr(1)); 
	sig = sig + SinOsc.ar(freq*2 * [1,1+\deltafreq.kr(0.01)], mul:\osc3amp.kr(1)).mean; 
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig0= sig * predistamp;
	sig1 = sig0.tanh(1);
	sig2 = sig0.clip2(1);
	sig3 = sig0.distort(1);
	sig = SelectX.ar(\distmix.kr(0.5)*3, [sig, sig1 * postdistamp, sig2 * postdistamp, sig3 * postdistamp]);
	sig = sig * 2;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Spec.add(\distmix, \unipolar);
Spec.add(\deltafreq, ControlSpec(0.00001,0.1,\exp));
);

(
Pdef(\part2_bass, Pbind(
	\instrument, \part2_bass,
	\degree, Pseq([0],inf),
	\dur, 1,
	\amp, 0.1
));
);

// END

WindowDef(\PdefEditor).front(Pdef(\part2_bass));
