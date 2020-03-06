
ParamProto.init(true)
ClipTimeline(\vin14_p2).edit

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,1,2,3,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Ndef(\couicz2, { arg freq=900, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.kr(1) * 1 + 1 ));
	sig = CombL.ar(sig, 0.1,0.1 * ( SinOsc.kr(1.05) * 1 + 1 ),1 * ( SinOsc.kr(1) * 1 + 1 ));
	sig = HPF.ar(sig, 1000);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Ndef(\couicz, { arg freq=900, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.ar( ( SinOsc.kr(1/20) * 1 + 1 ) * 40 * [1.1,1]) * 1 + 1 ));
	sig = CombL.ar(sig, 0.4,0.4 * ( SinOsc.kr(4.05) * 1 + 1 ),1 * ( SinOsc.kr(4) * 1 + 1 ));
	//sig = HPF.ar(sig, 1000);
	//sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(1.101), \cpabove.kr(0.009), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = Pan2.ar(sig, pan, amp);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.59), \room.kr(1), \damp.kr(0.04)) * 0.1 * amp;
}).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[53].value,
			\isRest, Pseq([
				1,0,1,0, 
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \doublebell,
			\freq, 1200,
			\freqtab, Pseq([
				[
					( (0..29)+rrand(40,70) ).midicps 
				]
			],inf),
			\freqtab2, Pseq([
				[{exprand(140,10000) }.dup(30)  ]
			],inf),
			\res, Pseq([
				[{rrand(0.01,1.3)*3 }.dup(30)  ]
			],inf),
			\res2, Pseq([
				[{rrand(0.01,1.4)*3 }.dup(30)  ]
			],inf),
			\dur, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,3.1) ],
			],inf),
			\isRest, Pseq([
				0,1,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 1.6,
		),
		
	])
)).play;
);



(
Ndef(\grafem, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var freqdev = ( SinOsc.kr(1/3) * 0.1 + 1 ) * 100;
	sig = SinOsc.ar(freq);
	sig = GrainFM.ar(1, Impulse.kr([1,1.01]*8*2*~t), 0.1, 440 + freqdev * [4,1,1.1,2,3], 200 * [1,1.1], LFNoise1.kr(1/10).range(1, 10), pan);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	//sig = sig * amp;
	//sig = Pan2.ar(sig, pan, amp);
}).play;
);



(
SynthDef(\doublebell, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var tabsize = 30;
	sig = WhiteNoise.ar;
	sig = LFSaw.ar(freq * [0,4,7].midiratio).mean + sig;
	sig = sig * EnvGen.ar(Env.perc(0.001,0.01),gate);
	//sig = sig + ( BPF.ar(WhiteNoise.ar * EnvGen.kr(Env([1,1/2,0],[0.1,0.8],-1), 1), freq,0.4)  );
	sig = Ringz.ar(sig, \freqtab.kr({ exprand(0.99,1) }.dup(tabsize)), \res.kr(3.dup(tabsize))).mean;
	//sig2 = Ringz.ar(sig, \freqtab2.kr({exprand(0.99,1.02)  }.dup(tabsize)) * freq, \res2.kr(0.1.dup(tabsize))).mean;
	//sig = SelectX.ar(Line.kr(0.61,0.5,1/2), [sig1 , sig2]);
	//sig = HPF.ar(sig, EnvGen.kr(Env([1000,200,1000]+1000,[0.4,0.8]), 1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,1.5,1,-1)), gate, doneAction:2) * 0.1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		
	])
)).play;
);


(
SynthDef(\bilin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq * [1,2,1/2] * (\bilintab.kr({ 1.0.bilinrand }!10) * \fspread.kr(0.01) + 1);
	sig = sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3]);
	//sig = LFSaw.ar(freq * [1,2,1/2] * ({ 1.0.bilinrand }!100 * 0.01 + 1)).clump(2).mean;
	sig = sig.clump(2).mean;
	sig = sig * Duty.kr(1/16/~t, 0, Dseq([
		Drand([
			1,1,1,0,
		],1),
		Drand([
			1,0,1,1,	
		],1),
	],inf)).lag(0.01);
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\piapia, 
	Pbind(
		\instrument, \bilin,
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
);
);
ProtoDef(\piano).startControl(Pdef(\piapia))

(
Pdef(\demo, Pdef(\demox, 
	Ppar([
		Pbind(
			\instrument, \bilin,
			\note, Pseq([
				[0,3,7],
				[0,3,7]+4,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1010].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[2346].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\lag, Pwhite(0.1,0.2),
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2520].value, // stick
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 0,1,0,0,
				1,0,0,1, 0,0,1,0,
				1,0,0,1, 0,1,0,0,
			],inf).coin.not,
			//\lag, Pwhite(0.1,0.2),
			\dur, 1/8,
			\gain, 0.61,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.31,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pmono(
			\bilin,
			\note, Pseq([
				0,
			],inf),
			\bilintab, Pfunc({[{ 1.0.bilinrand }!100]}),
			\fspread, Pwhite(0.001,0.05),
			\oscmix, Pwhite(0,1.0),
			\octave, Prand([3,4,5,6],inf),
			\dur, 1/1,
			\amp, 0.1,
		),
		Pmono(
			\bilin,
			\note, Pseq([
				3,
			],inf),
			\octave, Prand([3,4,5,6],inf),
			\bilintab, Pfunc({[{ 1.0.bilinrand }!100]}),
			\fspread, Pwhite(0.001,0.05),
			\oscmix, Pwhite(0,1.0),
			\dur, 1/2,
			\amp, 0.1,
		),
		Pmono(
			\bilin,
			\note, Pseq([
				7,
			],inf),
			\octave, Prand([3,4,5,6],inf),
			\bilintab, Pfunc({[{ 1.0.bilinrand }!100]}),
			\fspread, Pwhite(0.001,0.05),
			\oscmix, Pwhite(0,1.0),
			\dur, 1/3,
			\amp, 0.1,
		),
		Pmono(
			\bilin,
			\note, Pseq([
				11,
			],inf),
			\octave, Prand([3,4,5,6],inf),
			\bilintab, Pfunc({[{ 1.0.bilinrand }!100]}),
			\fspread, Pwhite(0.001,0.05),
			\oscmix, Pwhite(0,1.0),
			\dur, 1/4,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bilin,
			\note, Pseq([
				[0,3,7],
			],inf),
			\fspread, Pwhite(0.001,0.05),
			\oscmix, Pwhite(0,1.0),
			\dur, 1,
			\amp, 0.1,
			\isRest, true,
		),
		
	])
)).play;
);
