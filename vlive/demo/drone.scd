
~t = 1;
(
// cuisson ou montagne
Ndef(\plop2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LinCongL.ar(4400, 1.1 * SinOsc.kr(40).range(0,1), 1.52 * SinOsc.kr(80).range(0,1), 1.1 * SinOsc.kr(10).range(0,1),1/4);
	sig = SinOsc.ar(sig*47 * ( SinOsc.kr(1) * 9 + 1 ) + 1 * 700);
	sig = RLPF.ar(sig, 400);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\plop).fadeOut


(
	// hurlement de chevres mort vivantes
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate;
	lfreq = 400;

	gate = Duty.kr(2/~t, 0, Dseq([
		1,0,
	],inf));
	env1 = EnvGen.kr(Env.adsr(0.2,0.7,0.8,0.7), gate, doneAction:0);
	env2 = EnvGen.kr(Env.adsr(0.2,0.7,1.8,0.04), gate, doneAction:0) + 1;

	freq = Duty.kr(4/~t, 0, Dseq([
		0
		//1,0,3,0,
	],inf)).midiratio * 70 * env2;
	sig = LinCongL.ar(freq * (1..8), 1.1 * SinOsc.kr(1/4).range(0,1), 1.02 * SinOsc.kr(8).range(0,1), 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	sig = RLPF.ar(sig, 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1),( ( 1-env1 ) * 0.5 + 0.1 ));

	sig = sig.tanh;
	sig = sig * 4;
	sig = sig * env1;
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);

(

Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate;
	lfreq = 400;

	gate = Duty.kr(4/1/~t, 0, Dseq([
		1,0,
	],inf));
	env1 = EnvGen.kr(Env.adsr(0.2,0.7,0.8,0.7), gate, doneAction:0);
	env2 = EnvGen.kr(Env.adsr(0.2,0.7,-0.0,0.04), gate, doneAction:0) + 1;
	env2 = EnvGen.kr(Env([1.1,1.2,1,1,1.2],[1.1,1,1.2,1]), gate, doneAction:0) + 1;

	freq = Duty.kr(4/~t, 0, Dseq([
		0
		//1,0,3,0,
	],inf)).midiratio * 70 * env2;
	sig = LinCongL.ar(freq * (1..8), 1.1 * SinOsc.kr(1/4).range(0,1), 1.02 * SinOsc.kr(1/8).range(0,1), 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	//sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	sig = RLPF.ar(sig, 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1),( ( 1-env1 ) * 0.5 + 0.1 ));

	sig = sig.tanh;
	sig = sig * 4;
	sig = sig * ( env1 + 1 );
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
}).play;
);

(

Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var lfreq;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var gate;
	lfreq = 400;

	gate = Duty.kr(2/~t, 0, Dseq([
		1,0,0,0,
		1,1,0,1,
		1,0,1,0,
	],inf));
	env1 = EnvGen.kr(Env.adsr(0.2,0.7,0.8,4.7), gate, doneAction:0) * 0.41 + 0.01;
	env2 = EnvGen.kr(Env.adsr(0.1,0.7,0.1,0.04), gate, doneAction:0) * [0.1,0.4,0.9]  + 1;

	freq = Duty.kr(4/~t, 0, Dseq([
		0
		//1,0,3,0,
	],inf)).midiratio * 70 * env2;
	sig = LinCongL.ar(freq *.t (1..8), 1.1 * SinOsc.kr(1/4).range(0,1), 1.02 * SinOsc.kr(8).range(0,1), 1.1 * SinOsc.kr(1).range(0,1),8/4);
	sig.debug("ssig");
	sig.shape.debug("sshape");
	//sig = 1;
	sig = LFSaw.ar(sig*0.11 + 1 * freq) * (1+(1/8* sig ));
	sig.shape.debug("sawshape");
	//sig = 1;
	sig = sig * SinOsc.ar(freq*1);
	//sig = LFSaw.ar( freq!2);
	//sig = RLPF.ar([ sig ], 400 * (1..8) * LFNoise1.kr((1..8)/24).range(1/2,1),( ( 1-env1 ) * 0.5 + 0.1 )).mean;
	//sig = BPF.ar([sig], 400 * ( (1..8)/8 ) * [ env2 ], 0.1) / 4 + ([ sig ]/34);
	//sig = LPF.ar(sig, 99);
	sig.shape.debug("filshape");

	sig = sig.tanh;
	sig = sig * 4;
	sig = sig * env1;

	sig = sig.collect({ arg x; x.sum });
	sig.shape.debug("ishape");
	//sig = PanAz.ar(sig.size, sig, {LFNoise1.kr(( 1/2 ).rand).range(0,2.0)} ! sig.size).flop.sum;
	sig.shape.debug("shape");
	sig = Pan2.ar(sig, {LFNoise1.kr(( 1/2 ).rand).range(-1.0,1.0)} ! sig.size, amp).sum;
	sig.shape.debug("eshape");
	//sig = sig.mean;
	//sig = sig* 2;
	sig = sig/ 2;
	sig.shape.debug("e2shape");
	sig.debug("esig");
}).play;
);


log([ [1,2], [3,4] ])
log(3,0.3)
rrand([1.0,2.0],[1,2])
rrand([[1.0,2.0], [2.0,3.0]],[2,3])
rrand([[100.0,2.0], [2.0,3.0]],[2,3,122])
rrand([[1.0,2.0], [2.0,3.0]],[2,3].flop) // flop the argument and the arg apply to other direction of the matrix
[["j","s"], ["a", "b"]].join([ "-" ])

[[1,2], [3,4]] * [5,6]
[1,2,3] * [1,2] == [1*1, 2*2, 3*1]
[[1,2], [3,4]] * [5,6] == [[1*5, 2*5], [3*6,4*6]]
[[1,2], [3,4]] * [[5,6]] == [[1*5, 2*6], [3*5,4*6]]
\a ++ \b

(
Ndef(\pan, { arg freq=400, pan=0, amp=0.1;
	var sig;
	//sig = SinOsc.ar(freq * (1..4) *.t ( 1 + ( SinOsc.kr(freq/2 * (1..4)) * 0.1 )));
	sig = SinOsc.ar(freq * (1..3) * ( 1 + ( SinOsc.kr(freq/2) * 0.1 )));
	//sig = SinOsc.ar(freq).fold2([0.6,0.7,0.8]);
	// expand to 4 channel
	sig.shape.debug("1shape");
	sig = PanAz.ar(4, sig, LFSaw.kr(1/1).range(-1,1.0));
	sig = sig.collect({ arg is, x;
		BPF.ar(is, 1000 * ( x+1 ),0.1) + ( is/2 );
	});
	sig.rate.debug("rate");
	//sig.poll;
	//sig = sig.sum;
	//sig = PanAz.ar(4, sig)
	//sig = PanAz.ar(4, sig, {LFNoise1.kr(( 1/2 ).rand).range(0,2.0)} ! sig.size);
	sig.shape.debug("shape");
	//sig = sig.flop;
	sig = Pan2.ar(sig, sig.collect{ arg a, x; SinOsc.kr(1/8 * (x+1)) }, 0.1).flop.mean;
	//sig = Pan2.ar(sig, SinOsc.ar(1/4) , 1);
	sig.shape.debug("eshape");
	sig = sig * 4.1;
	sig
}).play;
);

{SinOsc.ar()}.draw;

Ndef(\pan)[0].draw
