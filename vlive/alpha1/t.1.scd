
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq = \freq.kr(201);
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig;
	var fmfreq;

	trig = Impulse.kr(1 * ~t);
	trig = TDuty.kr(1/2/~t, 0, Dseq([
		1,0,0,0,
		1,1,0,0,
		0,0,0,0, 0,0,0,0,
	],inf));

	env1 = EnvGen.kr(Env([0,0,12],[0,2]), trig)+0.2;
	env2 = EnvGen.kr(Env([1,1,0,1],[0,0.1,0.4]), trig)+0.07;

	fmfreq = Duty.kr(1/~t, 0, Dseq([
		8,4,2,8,
	],inf));
	//fmfreq = Duty.kr(1/4/~t, 0, Dseq([
	//	1/16,
	//],inf));
	fmfreq = EnvGen.kr(Env([4, fmfreq,0.1],[0.1,0.8]), trig);

	sig = SinOsc.ar(freq * [1/2,1,2.0001] * ( 1 + ( SinOsc.ar( fmfreq ) )));
	sig1 = LFSaw.ar(freq * ( 1 + ( SinOsc.ar(fmfreq).squared * 10 )));
	sig1 = RLPF.ar(sig1, SinOsc.ar(fmfreq).range(100,400), env2);
	sig = sig + sig1;
	sig = sig + Fb { arg fb;
		var isig;
		isig = ( fb * \fb.kr(1) ) + sig;
	
		//isig = isig * env2;
		sig = sig.fold( SinOsc.ar(fmfreq).range(0.1,1) ) * SinOsc.ar(fmfreq).range(10,1);
		isig = isig * 4.9;
		//isig = RLPF.ar(isig, SinOsc.ar(fmfreq).range(20,4500) );
		//isig = isig.tanh;
		isig = Limiter.ar(isig);
		isig;
	};
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.0), amp, \pan.kr(0));
	sig;
})


// END

(
Ndef(\plop,
	Instr(\plop, { arg freq= 100;
		var sig;
		sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(4) * 1 ))) !2;
		sig = sig * 0.1;
		
	})
).play;
);

Instr(\plop).play
