~t = 1.1; TempoClock.default.tempo = ~t;

(
Ndef(\texture1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	sig = SinOsc.ar(exprand(50.0,4000!num));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig.debug("sig") * 5;
}).play;
);

(
Ndef(\texture1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	sig = LFSaw.ar(exprand(0.001,1!num) * ( SinOsc.ar(exprand(0.001,100!num)).range(\minf.kr(40), \maxf.kr(3000)) ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig.debug("sig") * 4;
}).play;
);

Ndef(\zed).edit

(
Ndef(\texture1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	sig = Blip.ar(exprand(50.0,400!num), SinOsc.ar( SinOsc.ar(exprand(1/9,10!num)).range(1/3,10)/1000  ).range(1, SinOsc.ar(exprand(1/30,10!num)).exprange(1,200) ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig.debug("sig") * 15;
}).play;
);

(
Ndef(\texture1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0,
		0,0,-1,-1,
	].midiratio,inf));
	sig = Blip.ar(freq * exprand(0.98,1!num) * [0,3,7].midiratio, SinOsc.ar( SinOsc.ar(exprand(1/19,10!num)).range(1/3,10)/10  ).range(1, SinOsc.ar(exprand(1/30,10!num)).exprange(1,200) ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig.debug("sig") * 15;
}).play;
);

(
Ndef(\texture1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0,
		0,-1,-1,-1,
	].midiratio,inf));
	sig = Blip.ar(freq * Select.kr( LFNoise1.kr(1/1!num).exprange(0.1,1), [  exprand(0.98,1!num),1]) * [0,3,7].midiratio, SinOsc.ar( SinOsc.ar(exprand(1/19,10!num)).range(1/3,10)/10  ).range(1, SinOsc.ar(exprand(1/30,10!num)).exprange(1,200) ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig.debug("sig") * 15;
}).play;
);

(
Ndef(\texture1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0,
		0,-1,-1,-1,
	].midiratio,inf));
	sig = SinOsc.ar(freq * ( SinOsc.kr(exprand(0.01,1!num)) * 1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig.debug("sig") * 10;
}).play;
);

(
Ndef(\texture1, { arg freq=700, pan=0, amp=0.1;
	var sig;
	var num= 70;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0,
		0,-1,-1,-1,
	].midiratio,inf));
	sig = SinOsc.ar(freq * [0,3,7].midiratio * ( SinOsc.kr(exprand(0.0001,1!num)) * 0.01 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig.debug("sig") * 5;
}).play;
);

(
Ndef(\texture1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 17;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0,
		0,-1,-1,-1,
	].midiratio,inf));
	sig = SinOsc.ar(freq * [0,3,7].midiratio* LFPulse.kr([1,4,7]/8*~t).range(1,2) * ( LFSaw.ar(freq * exprand(0.4,1!num) ) * 0.04 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.01,1!num)), amp).mean;
	sig.debug("sig") * 5;
}).play;
);

(
Ndef(\fond1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(100) * 0.1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = BPF.ar(sig, 400, 0.1);
	sig.debug("sig") * 5;
}).play;
);

(
Ndef(\fond2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(1/~t, 0, Dseq([
		0,0,0,1,
	].midiratio,inf));
	lfo2 = Duty.kr(1/~t, 0, Dseq([
		1,1,1,1,
		1,1,1,4,
		1,1,1,1,
		1,1/2,1/2,16,
	],inf));
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.kr(100) * 0.1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = BPF.ar(sig, 800 * lfo1, 0.1) * LFPulse.kr(1*lfo2*~t);
	sig.debug("sig") * 5;
}).play;
);

(
Ndef(\xtreb1, { arg freq=900, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * ( SinOsc.kr(1) * 0.1 + 1 )) * 1 + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\xtreb1, { arg freq=900, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq * ( SinOsc.kr(1) * 0.1 + 1 )) * 1 + 1 ));
	sig = LPF.ar(sig, 100 * XLine.kr(1,10,10));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\treb1, { arg freq=900, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(Dwhite(0.1,2,inf)/~t, 0, Dseq([
		7,0,3,0,
		Dseq([
			7,0,3,0,
		],1)+12,
	],inf));
	lfo2 = LFPulse.kr(1*~t).range(1,10);
	sig = SinOsc.ar(freq * [lfo1,lfo1].midiratio * ( SinOsc.ar(freq * ( SinOsc.kr([1/3,1/2]*~t) * LFNoise1.kr(0.3!2).unipolar + 1 )) * 0.1 + 1 ));
	sig = sig.fold(0.1 * lfo2);
	sig = Pan2.ar(sig, [-1,1], amp).mean;
}).play;
);


(
Pdef(\part, Pdef(\kick1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1009].value,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.1,
		),
		
	])
)).play;
);
SampleTimeline(\bla).edit

(
Pdef(\part, Pdef(\kicktest, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1009].value,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,1,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\out, BusDef(\sendbus2, \audio),
			\gain, 0.1,
		),
		
	])
)).play;
);

200 * 3.midiratio
(
Ndef(\chord1, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var num= 70;
	freq = 200 * ( 3+12 ).midiratio;
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0,
		0,-1,-1,-1,
	].midiratio,inf));
	sig = SinOsc.ar(freq * [0,3,7].midiratio * ( SinOsc.kr(exprand(0.0001,1!num)) * 0.01 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig.debug("sig") * 2;
}).play;
);

(
Ndef(\chord2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([0.01,1/2,1],[10.1,10.8]), 1);
	lfo2 = EnvGen.kr(Env([0.4,0.01,1/2,1],[4,10.1,10.8]), 1);
	lfo3 = EnvGen.kr(Env([0.001,0.01,1/2,1],[0.4,4.1,30.8]), 1);
	freq = freq * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0,
		0,-1,-1,-1,
	].midiratio,inf));
	sig = Blip.ar(
		freq 
			* Select.kr( LFNoise1.kr(1/1!num).exprange(0.1,1), [  exprand(0.98,1!num),1]) 
			* [0,3,7].midiratio,
		SinOsc.ar( SinOsc.ar(exprand(1/19,10!num)).range(1/3,10)/10  ).range(1, SinOsc.ar(exprand(1/30,10!num)).exprange(1,200) )
	);
	sig1 = sig;
	sig1 = LPF.ar(sig1, 800);
	sig1 = HPF.ar(sig1, 400);

	sig2 = sig;
	sig2 = RLPF.ar(sig2, 1200 * ( SinOsc.kr([ 1/2,1/3,1/5 ]) * 0.1 + 1 ), 0.1);
	sig2 = HPF.ar(sig2, 900);
	sig = ( sig1 * lfo2 ) + ( sig * lfo3 ) + ( sig2 * lfo1 );
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig.debug("sig") * 5;
}).play;
);

(
Ndef(\fond1p2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num= 70;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = EnvGen.kr(Env([0.01,2,0.01],[0.1,0.8]*10), 1);
	sig = SinOsc.ar(exprand(50.0,4000!num)  * ( SinOsc.ar(exprand(50.0,4000!num)) * lfo1 + 1 ));
	sig = Pan2.ar(sig, SinOsc.kr(exprand(0.1,1!num)), amp).mean;
	sig = HPF.ar(sig, 400);
	sig = LPF.ar(sig, 2400);

	sig1 = SinOsc.ar(exprand(40.0,100!12));
	lfo2 = EnvGen.kr(Env([0.1,2,1],[4.1,0.8]), 1);
	sig1 = Pan2.ar(sig1, pan, amp).mean * lfo2;
	sig = sig + sig1;


	sig.debug("sig") * 5;
}).play;
);

(
Ndef(\treb2, { arg freq=900, pan=0, amp=0.1;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = Duty.kr(Dwhite(0.1,2,inf)/~t, 0, Dseq([
		7,0,3,0,
		Dseq([
			7,0,3,0,
		],1)+12,
	],inf));
	lfo2 = Duty.kr(1/~t, 0, Dseq([
		1,3,5,9,
	],inf));
	lfo2 = LFPulse.kr(lfo2*~t).range(1,10);
	sig = SinOsc.ar(freq * [lfo1,lfo1].midiratio * ( SinOsc.ar(freq * ( SinOsc.kr([1/3,1/2]*~t) * LFNoise1.kr(0.3!2).unipolar + 1 )) * 0.1 + 1 ));
	sig = sig.fold(0.1 * lfo2);
	sig = Pan2.ar(sig, [-1,1], amp).mean;
}).play(BusDef(\sendbus3).index,2);
);


FileSystemProject.current.resources
FileSystemProject.current.addResource(SampleTimeline(\bla))
