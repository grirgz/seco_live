
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
	var freqr;

	trig = Impulse.kr(1/8*~t);
	trig = 1;

	env1 = EnvGen.kr(Env([1,0,1,0],[1.1,4,0.08], [0,-4]), trig);
	env2 = EnvGen.kr(Env([1,0,1,0],[14.1,1,0.08], [0,-4]), trig);


	freq = 400;
	freqr = [1,1/2,2/3,3/4,4/5,5/6];
	freqr = [1,2/1,3/2,4/3,5/4,6/5];
	freqr = Duty.kr(8/~t, 0, Dseq([
		[0,4,7,10,14,17],
		[0,3,7,9,13,17],
	],inf)).midiratio;

	sig = freqr.collect { arg val, x;
		var isig;
		isig = LFSaw.ar(freq * val * [1,2,1/2]);
		//isig = isig + isig.fold(0.4);
		//isig = isig + ( (LFCub.ar(freq/2 * val * [1,1.0001]) * 1000).tanh/3 * XLine.ar(0.01,1,10+x));
		//isig = (isig*10000).tanh;
		//isig = Decimator.ar(isig,1000 * [1,20,4],20);
		isig = Disintegrator.ar(isig,0.90 * LFNoise1.kr(1/2+x/5).range(0.0,1.0),-0.2);
		isig = BPF.ar(isig, ( x+1 ** 2 * 200 ).debug("bfreq"), 0.6 * SinOsc.kr(1/44+( x/63 )).range(0.1,1));
	};
	//sig = sig.mean * [1,1] * 4;
	//sig = sig.flat;
	sig = sig.flop.mean * 14;
	
	amp = amp * \gain.kr(1);
	sig = sig * amp;

	sig = Pan2.ar(sig, {LFNoise1.kr(1/42).range(-1.0,1.0)} ! sig.size, amp).flop;
	//sig = Pan2.ar(sig, pan, amp);
	sig;
});

)

// END

[1,1/2,2/3,3/4,4/5,5/6]
[1,2/1,3/2,4/3,5/4,6/5]
