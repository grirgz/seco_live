
~toggle_fx.(~namex, ~john+++\fx, \filter -> { arg in;
	var sig;
	var lpfreq;
	var rq;
	var gate, rel;
	sig = in;
	gate = Duty.kr(1/8/~t, 0, Dseq([
		1,0,0,0,
		1,1,0,0,
		1,0,1,0,
		1,1,0,0,
	],inf));
	rel = Duty.kr(1/~t, 0, Dseq([
		0.1,
		0.01,
		0.41,
	],inf));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,rel),gate,doneAction:0);
	sig;

});
