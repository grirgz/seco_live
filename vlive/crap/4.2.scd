
Ndef(\plop2, { arg bla=1; SinOsc.ar(Rand(50,500*bla))!2 * 0.5 });
Ndef(\plop2).quant = 1;
Ndef(\plop2).play;
Ndef(\plop2).set(\bla, 0.9);

Ndef(\plop2).quant = nil;
Ndef(\plop3).stop;



a = NodeProxy.new;
(

a.play;

Task({
	8.do {
		a.source = { arg bla=1; SinOsc.ar(Rand(50,500*bla))!2 * 0.5 };
		a.play;
		0.001.wait;
	}
}).play;
)
a.play;
a.rebuild
a.release
s.plotTree
