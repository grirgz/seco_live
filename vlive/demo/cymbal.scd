

(

x = {

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var sig;
	locutoffenv = EnvGen.ar(Env.perc(0.5, 5)) * 20000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);
	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 3)) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25));
	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));
	freqs  = {exprand(300, 20000)}.dup(100);
	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;
	sig = ((res * 1) + (lodriver * 2) + thwack).dup;

	sig = sig / 10;

}.play;

)





	~freqs = {exprand(300, 14000)}.dup(100);
(
SynthDef(\cymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	locutoffenv = EnvGen.ar(Env.perc(0.1, 1)) * 18000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(0.1, 1)) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(0.01, 2, 0.25));

	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));
	freqs  = {exprand(300, 14000)}.dup(100);
	freqs = ~freqs;
	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;

	env1 = EnvGen.kr(Env([2200,70,50],[0.004,0.4]), 1);
	sig3 = LFCub.ar(env1) * 4;
	sig3 = AllpassL.ar(sig3, 0.1,0.001,0) + sig3;

	sig1 = ((res * 2) + (lodriver * 2) + ( thwack * 1 ) + (sig3)).dup;
	sig2 = lodriver + hidriver + thwack + sig3;
	sig = SelectX.ar( 0.5, [sig1, sig2]);

	//sig3 = WhiteNoise.ar + sig3;
	//sig3 = LPF.ar(sig3, env1);
	//sig = sig + sig3;

	sig = sig / 5;
	//sig = LPF.ar(sig,15000);
	sig = HPF.ar(sig, 500);
	sig = BRF.ar(sig, 700);
	sig = BRF.ar(sig, 2001);
	sig = sig * EnvGen.kr(Env([0,2,2,0],[0.3,0.18,0.09],3,1,3), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\cym, Pbind(
	\instrument, \cymbal,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\legato, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,6,0,
		12,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf)/2,
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\amp, 0.4
)).play;
);



///////////////////////////////////////



	~freqs = {exprand(300, 14000)}.dup(100);
(
SynthDef(\cymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, res, thwack;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	locutoffenv = EnvGen.ar(Env.perc(0.1, 1)) * 18000 + 10;
	lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	hicutoffenv = 10001 - (EnvGen.ar(Env.perc(0.1, 1)) * 10000);
	hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(0.01, 2, 0.25));

	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));
	freqs  = {exprand(300, 14000)}.dup(100);
	freqs = ~freqs;
	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;

	env1 = EnvGen.kr(Env([2200,70,50],[0.004,0.4]), 1);
	sig3 = LFCub.ar(env1) * 4;
	sig3 = AllpassL.ar(sig3, 0.1,0.001,0) + sig3;

	sig1 = ((res * 2) + (lodriver * 2) + ( thwack * 1 ) + (sig3)).dup;
	sig2 = lodriver + hidriver + thwack + sig3;
	sig = SelectX.ar( 0.5, [sig1, sig2]);

	//sig3 = WhiteNoise.ar + sig3;
	//sig3 = LPF.ar(sig3, env1);
	//sig = sig + sig3;

	sig = sig / 5;
	//sig = LPF.ar(sig,15000);
	sig = HPF.ar(sig, 500);
	sig = BRF.ar(sig, 700);
	sig = BRF.ar(sig, 2001);
	sig = sig * EnvGen.kr(Env([0,2,2,0],[0.3,0.18,0.09],3,1,3), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\cym, Pbind(
	\instrument, \cymbal,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\legato, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,6,0,
		12,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf)/2,
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\amp, 0.4
)).play;
);

(
SynthDef(\zcymbal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqs;
	var hpenv, lpenv;
	var ringenv;
	~seedrand = { arg seed, fun;
		r = Routine({
			fun.value.yield
		});
		r.randSeed = seed;
		r.next;
	};
	sig = WhiteNoise.ar;
	//sig = Array.series(1,10,1)
	freqs = Array.series(100,300,100);
	ringenv = EnvGen.kr(Env([1,0.7,0.5,0.1],[0.01,0.1,1.8],-4), 1);
	freqs = ~seedrand.(70014,{ {exprand(300, 20000)}.dup(100)  });
	sig = Ringz.ar(sig, freqs).mean*ringenv+ ( sig*3 );
	//freqs = ~seedrand.(11100,{ {exprand(4300, 8000)}.dup(50)  });
	//sig = Ringz.ar(sig, freqs).mean/2 + ( sig*3 ) / 3;

	lpenv = EnvGen.kr(Env([10,9,18],[0.01,1.0]), 1);
	sig = RLPF.ar(sig, \lpf.kr(1000)* lpenv, \rq.kr(0.5));
	hpenv = EnvGen.kr(Env([1.4,1.2,0.41],[0.01,4.0]), 1);
	sig = RHPF.ar(sig, \hpf.kr(4100) * hpenv, \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.01,0.6,\rel.kr(0.3),1.6,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\zcymbal2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqs;
	var hpenv, lpenv;
	~seedrand = { arg seed, fun;
		r = Routine({
			fun.value.yield
		});
		r.randSeed = seed;
		r.next;
	};
	sig = WhiteNoise.ar;
	//sig = Array.series(1,10,1)
	freqs = Array.series(100,300,100);
	freqs = ~seedrand.(11110,{ {exprand(300, 20000)}.dup(100)  });
	sig = Ringz.ar(sig, freqs).mean*Line.kr(1.1,0.01,1/4) + ( sig*3 );
	//freqs = ~seedrand.(11100,{ {exprand(4300, 8000)}.dup(50)  });
	//sig = Ringz.ar(sig, freqs).mean/2 + ( sig*3 ) / 3;

	lpenv = EnvGen.kr(Env([18,14,10],[0.01,1.0]), 1);
	sig = RLPF.ar(sig, \lpf.kr(1000)* lpenv, \rq.kr(0.5));
	hpenv = EnvGen.kr(Env([1.4,1.6,1.41],[0.01,1.0/2]), 1);
	sig = RHPF.ar(sig, \hpf.kr(4100) * hpenv, \rq.kr(0.5));
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.2,1,-4),gate,doneAction:2);
	sig = sig * EnvGen.ar(Env.adsr(0.001,0.4,0.6,\rel.kr(0.3),1.4,-6),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)
//{SinOsc.ar()}
{ SinOsc.ar(MouseX.kr(200,17000).poll) ! 2 * 0.1}.play;

(
Pdef(\zcymbal, Pbind(
	\instrument, \zcymbal,
	\degree, Pseq([0],inf),
	\rel, 0.1,
	\dur, 1/1,
	\legato, Pseq([
		//0.5,0.8,0.1,
		1.9,

	],inf),
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
	],inf).coin.not,
	//\out, BusDef(\fx1),
	\amp, 0.1
)).play;
);

(
~seedrand = { arg seed, fun;
	r = Routine({
		fun.value.yield
	});
	r.randSeed = seed;
	r.next;
};
~seedrand.(2588, { 100000.0.rand }).debug("rr");
~seedrand.(2587, { 100000.0.rand }).debug("rr0.5");
{ 100000.0.rand }.value.debug("rr2");
)
