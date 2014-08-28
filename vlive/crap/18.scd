
(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var comp;
	comp = MouseButton.kr(0,1);
	sig = Integrator.kr(comp / s.sampleRate * s.options.blockSize);
	sig.poll;
	sig = DC.ar(0);
}).play;
);
s.blockSize
s.options.blockSize

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var comp;
	comp = MouseButton.kr(0,1);
	sig = Integrator.kr(comp / s.sampleRate * s.options.blockSize, 1-Impulse.kr(1/8)) % 10;
	sig.poll;
	sig = DC.ar(0);
}).play;
);
