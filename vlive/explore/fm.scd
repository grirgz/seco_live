
(
SynthDef(\fm_sparkle, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = SinOsc.ar(freq * 3 * ( SinOsc.ar(9*freq) * 1 + 1 ));
	sig1 = sig1 * EnvGen.kr(\env1.kr(Env([0,1,0,0.71,0],[0.1,0.2,0.3,0.4],2,3,1)), gate);
	sig2 = SinOsc.ar(freq * 2 * ( SinOsc.ar(6*freq) * 1 + 1 ));
	sig2 = sig2 * EnvGen.kr(\env2.kr(Env([0,1,0,0.71,0],[0.1,0.2,0.33,0.4],2,3,1)), gate);
	sig3 = SinOsc.ar(freq * 1 * ( SinOsc.ar(4*freq) * 1 + 1 ));
	sig3 = sig3 * EnvGen.kr(\env3.kr(Env([0,1,0,0.71,0],[0.1,0.2,0.13,0.4],2,3,1)), gate);
	sig = [sig1, sig2, sig3] * \amptab.kr([1, 1, 1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + [-0.1,0.12,0], amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \fm_sparkle,
		\env1, Pfunc({
			[ Env([0,1,0,0.71,0],[0.1 + 0.8.rand,0.2,0.13 + 0.8.rand,0.4],1,3,1) ]
		}),
		\env2, Pfunc({
			[ Env([0,1,0,0.71,0],[0.1 + 0.8.rand,0.2,0.13 + 0.8.rand,0.4],1,3,1) ]
		}),
		\env3, Pfunc({
			[ Env([0,1,0,0.71,0],[0.1 + 0.8.rand,0.2,0.13 + 0.8.rand,0.4],1,3,1) ]
		}),
		\out, BusDef(\sendbus0, \audio),
	)
);
);

FileSystemProject.load("libdef/piano.scd");
ProtoDef(\piano).startControl(Pdef(\melo))
ProtoDef(\piano).startControl(Pdef(\melonil))

(
Pdef(\zed, 
	Pbind(
		\instrument, \fm_sparkle,
		\env1, Pfunc({
			[ Env([0,1,0,0.71,0],[0.1,0.2,0.13 + 0.2.rand,0.4],2,3,1) ]
		}),
		\env2, Pfunc({
			[ Env([0,1,0,0.71,0],[0.1,0.2,0.13 + 0.2.rand,0.4],2,3,1) ]
		}),
		\env3, Pfunc({
			[ Env([0,1,0,0.71,0],[0.1,0.2,0.13 + 0.2.rand,0.4],2,3,1) ]
		}),
		\degree, Pseq([0, 2, 4],inf) + [0,2,4],
		\dur, 4,
		\amp, 0.1,
	)
).play;
);

//////////////////////////



(
SynthDef(\fm_sparkle2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(2 * ( SinOsc.kr(0.2) * 10 + 1 )).unipolar;
	sig1 = SinOsc.ar(freq * 3 * ( SinOsc.ar(9*freq) * 1  + 1 ));
	sig1 = sig1 * EnvGen.kr(\env1.kr(Env([0,1,0,0.71,0],[0.1,0.2,0.3,0.4],2,3,1)), gate);
	sig2 = SinOsc.ar(freq * 2 * ( SinOsc.ar(6*freq) * 1 + 1 ));
	sig2 = sig2 * EnvGen.kr(\env2.kr(Env([0,1,0,0.71,0],[0.1,0.2,0.33,0.4],2,3,1)), gate);
	sig3 = SinOsc.ar(freq * 1 * ( SinOsc.ar(4*freq) * 1 + 1 ));
	sig3 = sig3 * EnvGen.kr(\env3.kr(Env([0,1,0,0.71,0],[0.1,0.2,0.13,0.4],2,3,1)), gate);
	sig4 = SinOsc.ar(freq * [3,4,5,6,7,8] * ( SinOsc.ar(1/2*freq) * 1 * lfo1 + 1 )).mean;
	sig4 = sig4 * EnvGen.kr(\env4.kr(Env([0,1,0,0.71,0],[0.1,0.2,0.3,0.4],2,3,1)), gate);
	sig = [sig1, sig2, sig3, sig4] * \amptab.kr([1, 1, 1, 1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + [-0.1,0.12,0, -0.02], amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \fm_sparkle2,
		\env1, Pfunc({
			[ Env([0,1,0,0.71,0],[0.1 + 0.8.rand,0.2,0.13 + 0.8.rand,0.4],1,3,1) ]
		}),
		\env2, Pfunc({
			[ Env([0,1,0,0.71,0],[0.1 + 0.8.rand,0.2,0.13 + 0.8.rand,0.4],1,3,1) ]
		}),
		\env3, Pfunc({
			[ Env([0,1,0,0.71,0],[0.1 + 0.8.rand,0.2,0.13 + 0.8.rand,0.4],1,3,1) ]
		}),
		\out, BusDef(\sendbus0, \audio),
	)
);
);

///////////

MIDIKeyboardWindow.new.front
