
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Ndef(\koi, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var xfreq;
	var deg;
	xfreq = freq * [0,4,7].midiratio *.x [1, 1.001];
	xfreq = xfreq * Duty.kr(1/~t, 0, Dseq([
		//0,5,0,7,
		//0,5,0,3,
		0,5,7,8,
	],inf)).midiratio;
	deg = Duty.kr(1/~t, 0, Dseq([
		0,3,5,3,
	],inf));
	xfreq = DegreeToKey.ar(Scale.major.as(LocalBuf), [0,2,4] + deg ).midiratio * freq;
	sig = SinOsc.ar(xfreq);
	sig1 = SinOsc.ar(00.1)*1;
	sig = sig.collect({ arg x, i; 
		x.debug("x");
		x = x.fold2( SinOsc.kr(i+1/10).range(0.3,1) );
		x.debug("xx");
		x = BRF.ar(x, freq * SinOsc.kr(i+1/12).range(0,1));
		x.debug("xxx");
		x
	});
	sig.debug("sig");
	sig = LeakDC.ar(sig);
	sig = Pan2.ar(sig, SinOsc.ar((1..sig.size)/13) * 0.4 , amp).mean;
}).play;
);
