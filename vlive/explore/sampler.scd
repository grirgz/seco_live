
(
BufDef(\amen, "vipere/amenbreak.wav");
~t = TempoClock.default.tempo;
SynthDef(\skat, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum=0;
	var sig;
	var phase;
	phase = Phasor.ar(1, 1,BufFrames.kr(bufnum) *\start.kr(0),BufFrames.kr(bufnum) * \end.kr(1));
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.01),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\skatsec, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum=0;
	var sig;
	var phase;
	phase = Phasor.ar(1, 1 * \rate.kr(1),BufFrames.kr(bufnum) * \start.kr(0)/BufDur.kr(bufnum),BufFrames.kr(bufnum) * \end.kr(1));
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.01),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\skatsecm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum=0;
	var sig;
	var phase;
	phase = Phasor.ar(1, 1,BufFrames.kr(bufnum) * ( (1..4)/14 + 1 ) * \start.kr(0)/BufDur.kr(bufnum),BufFrames.kr(bufnum) * \end.kr(1));
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig.mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.01),gate,doneAction:2);
	//sig = Pan2.ar(sig, [-1,1,0,0], amp).flop;
	//sig.sum
	sig.debug("sig");
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\skatex, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum=0;
	var sig;
	var phase;
	//phase = Phasor.ar(1, 1,BufFrames.kr(bufnum) * ( (1..4)/14 + 1 ) * \start.kr(0)/BufDur.kr(bufnum),BufFrames.kr(bufnum) * \end.kr(1));
	phase = \phase.ar(0);
	phase.poll;
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig.mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.01),gate,doneAction:2);
	//sig = Pan2.ar(sig, [-1,1,0,0], amp).flop;
	//sig.sum
	sig.debug("sig");
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\skatexag, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum=0;
	var sig;
	var phase;
	//phase = Phasor.ar(1, 1,\phase.kr(0),BufFrames.kr(bufnum) * \end.kr(1));
	phase = \phase.ar(0);
	phase.poll;
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig.mean;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,1,0.01),gate,doneAction:2);
	//sig = Pan2.ar(sig, [-1,1,0,0], amp).flop;
	//sig.sum
	sig.debug("sig");
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
BufDef(\moeten, "voices/02_moeten.flac");
);

(
Pdef(\skat, Pbind(
	\instrument, \skat,
	\bufnum, BufDef(\moeten),
	\degree, Pseq([0],inf),
	\start, Ndef(\skatlfo1, { SinOsc.kr(1/145).range(0,0.8100)  }),
	\sustain, 0.27,
	\dur, 1/8,
	\amp, 0.1
)).play;
);

(
Pdef(\skat2, 
	Pbind(
	\instrument, \skat,
	\bufnum, BufDef(\moeten),
	\degree, Pseq([0],inf),
	\start, Ndef(\skatlfo1, { SinOsc.kr(1/145).range(0,0.8100)  }),
	\sustain, 4.27,
	\dur, 4/1,
	\amp, 0.2
)
).play;
);

Pdef(\skat).stop
Pdef(\skat2).stop
(

Pdef(\p1, Pseq([
	~shift = 2;
	Pbind(
		\instrument, \skatsecm,
		\bufnum, BufDef(\moeten),
		\degree, Pseq([0],inf),
		\start, 0,
		\dur, Pn(~shift,1),
		\legato, 1,
		\amp, 0.1
	),
	Pbind(
		\instrument, \skatsec,
		\bufnum, BufDef(\moeten),
		\degree, Pseq([0],inf),
		\start, ~shift / ~t,
		\legato, 1,
		\dur, PdurStutter(Pseq([2,4,8,8]/4), Pseq([1/2],inf)),
		\amp, 0.1
	),
	Pbind(
		\instrument, \skatsecm,
		\bufnum, BufDef(\moeten),
		\degree, Pseq([0],inf),
		\start, 0,
		\dur, Pn(~shift,1),
		\legato, 1,
		\amp, 0.1
	),
],inf)).play;
)

	(
	Pbind(
		\instrument, \skatex,
		\bufnum, BufDef(\moeten),
		\degree, Pseq([0],inf),
		\start, 0,
		\phasor, Ndef(\phasor).asMap,
		\dur, Pn(~shift,1),
		\legato, 1,
		\amp, 0.1
	).play
	)

Ndef(\phasor).asMap
Ndef(\phasor).clear
Pdef(\p1).clear
(
Ndef(\phasor, { 
	var bufnum = BufDef(\moeten);
	var ph = Phasor.ar(\ttrig.tr(1), 1,BufFrames.kr(bufnum) * \start.kr(0)/BufDur.kr(bufnum),BufFrames.kr(bufnum) * \end.kr(1));
	ph.poll;
});

Pdef(\p1, Pseq([
	~shift = 2;
	Plazy({
		Ndef(\phasor).set(\ttrig, 1);
		Pbind(
			\instrument, \skatex,
			\bufnum, BufDef(\moeten),
			\degree, Pseq([0],inf),
			\start, 0,
			\phase, Ndef(\phasor),
			\dur, Pn(~shift,1),
			\legato, 1,
			\amp, 0.1
		);
	}),
	Pbind(
		\instrument, \skatex,
		\bufnum, BufDef(\moeten),
		\degree, Pseq([0],inf),
		\start, ~shift / ~t,
		\phase, Ndef(\phasor),
		\legato, 1/2,
		\dur, PdurStutter(Pseq([2,4,8,8]/4), Pseq([1/2],inf)),
		\amp, 0.1
	),
],inf)).play;
)


(

Pdef(\p1, Pseq([
	Pseq([
		Pfindur(1,
		Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\moeten),
			\degree, Pseq([0],inf),
			\start, Pkey(\sshift),
			\rate, Ndef(\ratelfo1, { SinOsc.kr(1/34).range(0,2)  }),
			\dur, Pn(8,1),
			\xx, Pfunc({ arg ev;
				ev[\timy].debug("timu");
			}),
			\legato, 1,
			\amp, 0.1
		)
		),
		Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\moeten),
			\degree, Pseq([0],inf),
			\start, Pkey(\timy).stutter(168) + Pkey(\sshift),
			\rate, Ndef(\ratelfo1, { SinOsc.kr(1/34).range(0,2)  }),
			\xx, Pfunc({ arg ev;
				ev[\timy].debug("timu");
			
			}),
			\legato, 1,
			\dur, PdurStutter(Pseq([
				Prand([2,8,4,1,16],4),
				Pser([1],1),
			]/4), Pseq([
				Pser([1/4],4),
				Pser([1/2],1),
			],inf)) * 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\moeten),
			\degree, Pseq([0],inf),
			\start, Pkey(\timy).stutter(168) + Pkey(\sshift),
			\rate, Ndef(\ratelfo1, { SinOsc.kr(1/34).range(0,2)  }),
			\xx, Pfunc({ arg ev;
				ev[\timy].debug("timu");
			
			}),
			\legato, 1,
			\dur, PdurStutter(Pseq([
				Prand([2,8,4,1,16],4),
				Prand([2,8,4,1,16],4),
				Pser([1],1),
			]/4), Pseq([
				Pser([1/4],4),
				Pser([1],1),
			],inf)) * 2,
			\amp, 0.1,
		),
		//Rest(1)
	],1)
	<>
	Pbind(
		\timy, Ptime(),
		\sshift, Pseq([1,2],inf)
	) 
],inf)).play;
)

Pseq([
])


(
Pdef(\kick2, Pbind(
	\instrument, \dr_kick,
	\env1, Pseq([
		[ Env.new([80, 30, 29], [0.075, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.1,0], [0.075, 0.09,0.1], [-4, -5]) ],
	],inf),
	\timeScale, 1,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
	],inf).coin.not,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		1,0,1,0, 0,0,0,0,
		1,0,0,0, 0,0,0,0,
		1,0,0,1, 0,0,1,0,
	],inf).coin.not,
	\fratio, 1,
	\degree, Pseq([0],inf),
	\dur, 1/4,
	\amp, 0.4
)).play;
);

(
Pdef(\snare, 

	Pbind(
		\instrument, \snare,
		\degree, Pseq([0],inf),
		\dur, 1/4,
		\isRest, Pseq([
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,1,0,0, 1,0,0,0,
		],inf).coin.not,
		\amp, 0.1/4
	)
	<>
	Pbind(
		\env, Pseq([
			[ Env.perc(0.01,0.1) ],
				//[ Env.perc(0.02,0.4) ]
		],inf),
		\env1scale, Pseq([1,1,2,0.2],inf),
		\env2scale, Pseq([1,0.4,0.8],inf),
		//\lag, Pseq([0, Ptuple([0,Pwhite(0.01,0.071,1)])],inf),
	).stutter(8)

).play;
);

(

BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\p1, Pseq([
	Pbind(\out, BusDef(\fx2), \bufnum, BufDef(\amen)) <>
	Pseq([
		Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\moeten),
			\degree, Pseq([0],inf),
			\start, Pkey(\sshift),
			\dur, Pn(2,1),
			\xx, Pfunc({ arg ev;
				ev[\timy].debug("timu");
			}),
			\legato, 1,
			\amp, 0.1
		),
		Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\moeten),
			\degree, Pseq([0],inf),
			\start, Pkey(\timy).stutter(168) + Pkey(\sshift),
			\rate, Pseq([2,1,4,2,1,1],inf)/2,
			\xx, Pfunc({ arg ev;
				ev[\timy].debug("timu");
			
			}),
			\legato, 1,
			\dur, PdurStutter(Pseq([
				Prand([2,8,4,1,16],4),
				Pser([1],1),
			]/8), Pseq([
				Pser([1/4],4),
				Pser([1/2],1),
			],inf)) * 2,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\moeten),
			\degree, Pseq([0],inf),
			\start, Pkey(\timy).stutter(168) + Pkey(\sshift),
			//\rate, Ndef(\ratelfo1, { SinOsc.kr(1/34).range(0,2)  }),
			\rate, Prand([2,1,4,2,1,1],inf)/2,
			\xx, Pfunc({ arg ev;
				ev[\timy].debug("timu");
			
			}),
			\legato, 1,
			\dur, PdurStutter(Pseq([
				Prand([2,8,4,1,16],4),
				Prand([2,8,4,1,16],4),
				Pser([1],1),
			]/8), Pseq([
				Pser([1/4],4),
				Pser([1],1),
			],inf)) * 2,
			\amp, 0.1,
		),
		//Rest(1)
	],1)
	<>
	Pbind(
		\timy, Ptime(),
		\sshift, Pseq([1,2],inf)
	) 
],inf)).play;
)

Pseq([
])


~t
~amen_ar
"~/code/sc/seco/vlive/lib/samples_slices.scd".standardizePath.load
~amen_ar = ~amen_slices.keys.asArray.sort.collect({ arg k; ~amen_slices[k][0] })
		(
		Pdef(\kkk, Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\start,  Pstep(Pseq([
				3,3,4,1,
				3,2,5,2,
				2,3,4,1,
				2,2,5,0,
			].collect({ arg x;~amen_ar[x]}),inf),1/4),
			\rate, Pstep(Pseq([
				Pseq([
					1,0.9,
					1,1.9,
					1,1.9,
					1/2,1/1.9,
					//1.1,1,
				],1),
			],inf),1/2),
			\rate, Pstep(Pseq([
				Pseq([
					1,
					//1.1,1,
				],1),
			],inf),1/2),
			\dur, PdurStutter(Pseq([
				Pser([4,2,8,4],4),
				Pser([2,1,4,2],4),
				Pser([4,2,8,2],4),
				Pser([2,8,4,2],4),
			],inf)/2, Pseq([
				Pser([1/2],4),
			],inf)) * 2,
			\sustain, Pstep(Pseq([
				Pseq([2],1) * 4 * Pkey(\dur),
			],inf)/4, 1/2) / ~t,
			//\out, BusDef(\fx1),
			\amp, 0.3,
		)).play
		)


		(
		Pdef(\kkk, Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\start,  Pstep(Pseq([
				2,0,1,0, 5,0,1,0,
				2,2,5,0, 4,0,1,0,
			].collect({ arg x;~amen_ar[x]}),inf),1/2),
			\rate, Pstep(Pseq([
				Pseq([
					1,0.9,
					1,1.9,
					1,1.9,
					1/2,1/1.9,
					//1.1,1,
				],1),
			],inf),1/2),
			\rate, Pstep(Pseq([
				Pseq([
					1, 1, 1, 0.9,
					0.71, 1, 1, 0.9,
					//1.1,1,
				],1),
			],inf),1/2),
			\dur, PdurStutter(Pseq([
				Pseq([4,1,1,1]),
				Pseq([2,1,4,1]),
			],inf)/2, Pseq([
				Pser([1/2],4),
			],inf)) * 2,
			\sustain, Pstep(Pseq([
				Pseq([
					2,2,2,2, 2,2,4,2,
					2,1,1,2, 2,2,4,2,
				],1) * 4 * Pkey(\dur),
			],inf)/4, 1/2) / ~t,
			\out, BusDef(\fx1),
			\amp, 0.3,
		)).play
		)

		(
		Pdef(\kkk, Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\start,  Pstep(Pseq([
				3,0,3,0, 5,0,1,0,
				2,2,0,0, 4,0,1,0,
			].collect({ arg x;~amen_ar[x]}),inf),1/2),
			\rate, Pstep(Pseq([
				Pseq([
					2,0.9,
					1,1.9,
					1,1.9,
					1/2,1/1.9,
					//1.1,1,
				],1),
			],inf),1/2),
			\rate, Pstep(Pseq([
				Pseq([
					1.2, 1, 1, 0.9,
					0.71, 1, 1, 0.9,
					//1.1,1,
				],1),
			],inf),1/2),
			\dur, PdurStutter(Pseq([
				Pseq([8,1,8,1]),
				Pseq([8,1,1,1]),
				Pseq([1,1,1,1]),
				Pseq([1,4,1,1]),
			],inf)/2, Pseq([
				Pser([1/2],4),
			],inf)) * 2,
			\sustain, Pstep(Pseq([
				Pseq([
					1,1,1,2, 2,2,4,2,
					2,1,1,2, 2,2,4,2,
				],1) * 4 * Pkey(\dur),
			],inf)/4, 1/2) / ~t,
			\out, BusDef(\fx1),
			\amp, 0.3,
		)).play
		)

		(
		Pdef(\kkk, Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\start,  Pstep(Pseq([
				3,0,3,0, 5,0,1,0,
				2,2,0,0, 4,0,1,0,
			].collect({ arg x;~amen_ar[x]}),inf),1/2),
			\rate, Pstep(Pseq([
				Pseq([
					2,0.9,
					1,1.9,
					1,1.9,
					1/2,1/1.9,
					//1.1,1,
				],1),
			],inf),1/2),
			\rate, Pstep(Pseq([
				Pseq([
					1.2, 1, 1, 0.9,
					0.71, 1, 1, 0.9,
					//1.1,1,
				],1),
			],inf),1/2),
			\isRest, Pseq([
				1,1,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,0,0, 1,1,1,1,
				1,0,1,0, 1,0,0,0,
			],inf).coin.not,
			//\stut, 
			\dur, PdurStutter(Pseq([
				Pseq([8,1,8,1]),
				Pseq([8,1,1,1]),
				Pseq([1,1,1,1]),
				Pseq([1,4,1,1]),
			],inf)/1, Pseq([
				Pser([1/1],4),
			],inf)) * 2,
			\sustain, Pstep(Pseq([
				Pseq([
					1,1,1,2, 2,2,4,2,
					2,1,1,2, 2,2,4,2,
				],1) * 4 * Pkey(\dur),
			],inf)/4, 1/2) / ~t,
			\out, BusDef(\fx1),
			\amp, 0.2,
		)).play
		)


//////////////////////////////////////:



		(
		Pdef(\kkk, Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\start,  Pseq([
				2,0,4,1,
			].collect({ arg x;~amen_ar[x]}),inf),
			\sustain, 0.3,
			\amp, 0.3,
		)).play
		)

		(
		Pdef(\kkk, Pbind(
			\instrument, \skatsec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\start,  Pseq([
				0,1,2,3,
			].collect({ arg x;~amen_ar[x]}),inf),
			\sustain, 0.3,
			\dur, 1/4,
			\amp, 0.3,
		)).play
		)



		b = Buffer.alloc(s,1024,1); //for sampling rates 44100 and 48000

(
SynthDef(\help_beattrack2,{
var trackb,trackh,trackq,tempo;
var source;
var bsound,hsound,qsound;
var bufnum = BufDef(\amen);
var pos = 0, trigger=1, speed=1;

source= PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: 0);

#trackb,trackh,trackq,tempo=BeatTrack.kr(FFT(b, source));

bsound= Pan2.ar(LPF.ar(WhiteNoise.ar*(Decay.kr(trackb,0.05)),1000),0.0);

hsound= Pan2.ar(BPF.ar(WhiteNoise.ar*(Decay.kr(trackh,0.05)),3000,0.66),-0.5);

qsound= Pan2.ar(HPF.ar(WhiteNoise.ar*(Decay.kr(trackq,0.05)),5000),0.5);

Out.ar(0, bsound+hsound+qsound);
}).play;
)


(
a= SynthDef(\help_beattrack,{arg vol=1.0, beepvol=1.0, lock=0;
var in, fft, resample;
var trackb,trackh,trackq,tempo;
var bsound,hsound,qsound, beep;
var bufnum = BufDef(\amen);

in= PlayBuf.ar(2,bufnum,BufRateScale.kr(bufnum),1,0,1)[0];
//in = SoundIn.ar(0);

fft = FFT(b, in);

#trackb,trackh,trackq,tempo=BeatTrack.kr(fft, lock);
tempo.poll;

bsound= Pan2.ar(LPF.ar(WhiteNoise.ar*(Decay.kr(trackb,0.05)),1000),0.0) * 2;

hsound= Pan2.ar(BPF.ar(WhiteNoise.ar*(Decay.kr(trackh,0.05)),3000,0.66),-0.5);

qsound= Pan2.ar(HPF.ar(WhiteNoise.ar*(Decay.kr(trackq,0.05)),5000),0.5);

//Out.ar(0, bsound+hsound+qsound + ( in * 1/2 ));
Out.ar(0, bsound + ( in * 1/2 ));
}).play
)

