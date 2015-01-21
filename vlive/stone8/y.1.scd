
(
Ndef(~name+++\fx).put(0, { arg amp=0.1, pan=0, release=0.26, fratio=1.5, freqpan=0.01, spread=0.8, timeScale=1;
	var son1, son2, son3, son4;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var env1, env2, env3, env4;
	var distlim = 1;
	var trig;
	var lfo1, lfo2, lfo3;
	var freq;
	var fspread = 0.001;

	trig = Impulse.kr(1/32*~t);

	env2 = EnvGen.kr(Env([0,0,1,1],[12.1,0.1,4.8], [1,-4]), trig);
	env1 = EnvGen.kr(Env([0,1,1,0],[12.1,4,0.8], [1,-4]), trig);

	freq = 200 * [0,3*env2,7,11 * env2].midiratio *.t [1,1.0001,1.00001];
	freq = freq.flat;
	sig = SinOsc.ar(freq);
	//env1 = XLine.kr(0.001,1,10);
	sig = sig.collect({ arg isig, x;
		var isig1, isig2;
		isig1 = ( isig * LFPulse.ar(200+x * env1, SinOsc.kr(1/2+x).range(0,1)) );
		isig1 = isig1 * env1*2;
		isig = isig + (isig1);
	});

	sig = sig * env1;
	
	amp = amp * \gain.kr(1);
	sig = sig * amp;

	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;
	sig;
});

)

// END

Ndef(~name+++\fx).fadeTime = 1
