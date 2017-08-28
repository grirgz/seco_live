{42.do({{SinOsc.ar([MouseX,MouseY].choose.kr(ExpRand(220,6000.0) + [0,0.001.rand], ExpRand(220,6000.0) + [0,0.001.rand]),1,0.05)}.play; 0.1.wait;})}.fork;

(
Ndef(\gg, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lines;
	lines = 20.collect({
		var hi = 10.0.rand;
		var lo = 10.0.rand;
		var time = 40.0.rand;
		EnvGen.kr(Env([hi,hi,lo],[0,time]),1)
	});
	sig = SinOsc.ar(freq * lines/2);
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);
