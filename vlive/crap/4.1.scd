
Ndef(\plop2, { SinOsc.ar(Rand(50,500))!2 * 0.5 });
Ndef(\plop2).quant = 1;
Ndef(\plop2).play;
Ndef(\plop2).set(\bla, 1.1);
