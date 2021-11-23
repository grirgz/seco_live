
///// experimentation pour projet aquaponie

(
Ndef(\module1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sensors = LFNoise1.kr( Rand(0.2,20!5) );
	sig = SinOsc.ar(freq * ( SinOsc.kr( sensors[0] ) * sensors[1] + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// use sound source
Ndef(\module1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sensors = LFNoise1.kr( Rand(0.2,2!5) );
	var speed =1, trigger=1, pos=0, bufnum=0, loop=1;
	bufnum = BufDef('voices/feynman.flac');
	speed = sensors[0].lag(10)*0.2 + 1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	sig = CombL.ar(sig, 4, sensors[1] * 0.3 + 1 / 10, sensors[2] * 0.3 + 1) + sig;
	sig = CombL.ar(sig, 4, sensors[2] * 0.3 + 1 / 1, sensors[3] * 0.3 + 1) + sig;
	//sig = SinOsc.ar(freq * ( SinOsc.kr( sensors[0] ) * sensors[1] + 1 ));
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

//////////////////////////////////
(
	// use sound source
	// connect feedback
Ndef(\module1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sensors = LFNoise1.kr( Rand(0.2,2!5) );
	var speed =1, trigger=1, pos=0, bufnum=0, loop=1;
	var in = InFeedback.ar(\inbus.kr(BusDef(\module1in, \audio)), 2); 
	bufnum = BufDef('voices/feynman.flac');
	speed = sensors[0].lag(5)*0.5 + 1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	in = ( in * \fb.kr(0.9) );
	//Amplitude.kr(in).poll;
	sig = ( sig * 1 ) + in;
	//sig = CombL.ar(sig, 4, sensors[1] * 0.3 + 1 / 10, sensors[2] * 0.3 + 1) + sig;
	//sig = CombL.ar(sig, 4, sensors[2] * 0.3 + 1 / 1, sensors[3] * 0.3 + 1) + sig;
	//sig = SinOsc.ar(freq * ( SinOsc.kr( sensors[0] ) * sensors[1] + 1 ));
	Out.ar( \fbout.kr(BusDef(\module2in, \audio, 2)), sig);
	sig;
}).play(BusDef(\null, \audio).index, 2);
);

(
	// use sound source
	// connect feedback
Ndef(\module2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sensors = LFNoise1.kr( Rand(0.2,2!5) );
	var speed =1, trigger=1, pos=0, bufnum=0, loop=1;
	var in = InFeedback.ar(\inbus.kr(BusDef(\module2in, \audio)), 2); 
	bufnum = BufDef('voices/feynman.flac');
	speed = sensors[0].lag(10)*0.2 + 1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	in = ( in * \fb.kr(0.5) );
	in = Compander.ar(in, in, \cpt.kr(0.01), \cpbelow.kr(1.001), \cpabove.kr(0.7), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * 0 + in;
	sig = DelayL.ar(sig, ( sensors[2].abs * 0.6 + 0.01 ).poll) + sig;
	sig = DelayL.ar(sig, ( sensors[3].abs * sensors[4].abs.lag(10) * 2 + 0.01 ).poll) + sig;
	sig = sig /2;
	//sig = CombL.ar(sig, 4, sensors[1] * 0.3 + 1 / 10, sensors[2] * 0.3 + 1) + sig;
	//sig = CombL.ar(sig, 4, sensors[2] * 0.3 + 1 / 1, sensors[3] * 0.3 + 1) + sig;
	//sig = SinOsc.ar(freq * ( SinOsc.kr( sensors[0] ) * sensors[1] + 1 ));
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar( \fbout.kr(BusDef(\module1in, \audio, 2)), sig);
	sig;
}).play;
);


//////////////////////////////////
(
	// use audio in
	// connect feedback
Ndef(\module1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sensors = LFNoise1.kr( Rand(0.2,2!5) );
	var speed =1, trigger=1, pos=0, bufnum=0, loop=1;
	var in = InFeedback.ar(\inbus.kr(BusDef(\module1in, \audio)), 2); 
	bufnum = BufDef('voices/feynman.flac');
	speed = sensors[0].lag(5)*0.5 + 1;
	//sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	sig = AudioIn.ar([1,2]);
	in = ( in * \fb.kr(0.9) );
	//Amplitude.kr(in).poll;
	sig = ( sig * 1 ) + in;
	//sig = CombL.ar(sig, 4, sensors[1] * 0.3 + 1 / 10, sensors[2] * 0.3 + 1) + sig;
	//sig = CombL.ar(sig, 4, sensors[2] * 0.3 + 1 / 1, sensors[3] * 0.3 + 1) + sig;
	//sig = SinOsc.ar(freq * ( SinOsc.kr( sensors[0] ) * sensors[1] + 1 ));
	Out.ar( \fbout.kr(BusDef(\module2in, \audio, 2)), sig);
	sig;
}).play(BusDef(\null, \audio).index, 2);
);

(
	// use sound source
	// connect feedback
Ndef(\module2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sensors = LFNoise1.kr( Rand(0.2,2!5) );
	var speed =1, trigger=1, pos=0, bufnum=0, loop=1;
	var in = InFeedback.ar(\inbus.kr(BusDef(\module2in, \audio)), 2); 
	bufnum = BufDef('voices/feynman.flac');
	speed = sensors[0].lag(10)*0.2 + 1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	in = ( in * \fb.kr(0.5) );
	in = Compander.ar(in, in, \cpt.kr(0.01), \cpbelow.kr(1.001), \cpabove.kr(0.7), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = sig * 0 + in;
	sig = DelayL.ar(sig, ( sensors[2].abs * 0.6 + 0.01 ).poll) + sig;
	sig = DelayL.ar(sig, ( sensors[3].abs * sensors[4].abs.lag(10) * 2 + 0.01 ).poll) + sig;
	sig = sig /2;
	//sig = CombL.ar(sig, 4, sensors[1] * 0.3 + 1 / 10, sensors[2] * 0.3 + 1) + sig;
	//sig = CombL.ar(sig, 4, sensors[2] * 0.3 + 1 / 1, sensors[3] * 0.3 + 1) + sig;
	//sig = SinOsc.ar(freq * ( SinOsc.kr( sensors[0] ) * sensors[1] + 1 ));
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar( \fbout.kr(BusDef(\module1in, \audio, 2)), sig);
	sig;
}).play;
);

Ndef(\module1).edit
Ndef(\module2).edit

//////////////////////////////////
(
	// use rdn
	// use audio in
	// connect feedback
Ndef(\module1, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sensors = LFNoise1.kr( Rand(0.2,2!5) );
	var speed =1, trigger=1, pos=0, bufnum=0, loop=1;
	var in = InFeedback.ar(\inbus.kr(BusDef(\module1in, \audio)), 2); 
	bufnum = BufDef('voices/feynman.flac');
	speed = sensors[0].lag(5)*0.5 + 1;
	//sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	sig = AudioIn.ar([1,2]) * \micgain.kr(1);
	in = ( in * \fb.kr(0.9) );
	//Amplitude.kr(in).poll;
	sig = ( sig * 1 ) + in;
	//sig = CombL.ar(sig, 4, sensors[1] * 0.3 + 1 / 10, sensors[2] * 0.3 + 1) + sig;
	//sig = CombL.ar(sig, 4, sensors[2] * 0.3 + 1 / 1, sensors[3] * 0.3 + 1) + sig;
	//sig = SinOsc.ar(freq * ( SinOsc.kr( sensors[0] ) * sensors[1] + 1 ));
	Out.ar( \fbout.kr(BusDef(\module2in, \audio, 2)), sig);
	sig;
}).play(BusDef(\null, \audio).index, 2);
);

(
	// use sound source
	// connect feedback
Ndef(\module2, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sensors = LFNoise1.kr( Rand(0.2,2!5) );
	var speed =1, trigger=1, pos=0, bufnum=0, loop=1;
	var in = InFeedback.ar(\inbus.kr(BusDef(\module2in, \audio)), 2); 
	bufnum = BufDef('voices/feynman.flac');
	speed = sensors[0].lag(10)*0.2 + 1;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:2, loop: loop);
	in = ( in * \genfb.kr(0.1) );
	sig = sig * 0 + in;
	//sig = DelayL.ar(sig, ( sensors[2].abs * 0.6 + 0.01 ).poll) + sig;
	//sig = DelayL.ar(sig, ( sensors[3].abs * sensors[4].abs.lag(10) * 2 + 0.01 ).poll) + sig;
	//sig = RandDelayNetwork(\deldefault).ar(sig, "5-16e0-fe32"); // generateur de notes
	sig = RandDelayNetwork(\deldefault).ar(sig, "5-16e0-fe32");
	sig = sig /4;
	sig = Compander.ar(sig, sig, \cpt.kr(0.01), \cpbelow.kr(1.001), \cpabove.kr(0.3), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = LeakDC.ar(sig);
	//sig = CombL.ar(sig, 4, sensors[1] * 0.3 + 1 / 10, sensors[2] * 0.3 + 1) + sig;
	//sig = CombL.ar(sig, 4, sensors[2] * 0.3 + 1 / 1, sensors[3] * 0.3 + 1) + sig;
	//sig = SinOsc.ar(freq * ( SinOsc.kr( sensors[0] ) * sensors[1] + 1 ));
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar( \fbout.kr(BusDef(\module1in, \audio, 2)), sig);
	sig = sig * \gain.kr(1);
	sig;
}).play;
);

Ndef(\module1).edit
Ndef(\module2).edit

warp

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SynthDef.wrap({ 
		SinOsc.ar(\ff.kr(100));
	},nil, );
	//sig = SinOsc.ar(freq);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = AudioIn.ar([1,2]);
	sig = sig * \gain.kr(1);
}).play(BusDef(\mixer0, \audio).index, 2);
);

Ndef(\zed).stop;

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0-36,7-24,3-12,0,3,7],
			],inf) + Pseq([0,6],inf),
			\dur, 4,
			\out, BusDef(\mixer0, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \iron,
			\note, Prout({ arg ev;
				var pat = Pseq([
				[0-36,7-24,3-12,0,3,7],
			],inf) + Pstep(Pseq([0,6],inf),4);
				var str = pat.asStream;
				inf.do {
					ev = str.next(ev).choose.yield
				};
			}),
			\dur, 1/4,
			\out, BusDef(\mixer1, \audio),
			\amp, 0.1/2,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
	// add friture after kicks
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0-36,7-24,3-12,0,3,7],
			],inf) + Pseq([0,6],inf),
			\dur, 4,
			\legato, 1,
			//\out, BusDef(\mixer0, \audio),
			//\amp, ~pmodenv.(Pseq([0,0,1,1]*0.1,1), Pseq([1,0,1]/8)).loop,
			\out, BusDef(\fx_env, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\fx_env, \audio),
			\dur, 1,
			\legato, 1,
			\out, BusDef(\mixer0, \audio),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \iron,
			\note, Prout({ arg ev;
				var pat = Pseq([
				[0-36,7-24,3-12,0,3,7],
			],inf) + Pstep(Pseq([0,6],inf),4);
				var str = pat.asStream;
				inf.do {
					ev = str.next(ev).choose.yield
				};
			}),
			\dur, 1/4,
			\out, BusDef(\mixer1, \audio),
			\amp, 0.1/2,
		),

		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1337].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,1,1,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,1, 0,0,0,0,
				1,1,1,0, 1,1,0,1,
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			],1),4).loop / Pkey(\st),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0.2,0.3,
			],inf).coin.not,
			\gain, 1,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, 0.71 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0.5, 1,
			]+1,1),1/2).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.5,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 1/2,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1245].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1120].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer4, \audio),
		),
		
	])
)).play;
);

(
	// add friture after kicks
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				[0-36,7-24,3-12,0,3,7],
			],inf) + Pseq([0,6],inf),
			\dur, 4,
			\legato, 1,
			//\out, BusDef(\mixer0, \audio),
			//\amp, ~pmodenv.(Pseq([0,0,1,1]*0.1,1), Pseq([1,0,1]/8)).loop,
			\out, BusDef(\fx_env, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \fx_env,
			\inbus, BusDef(\fx_env, \audio),
			\dur, 1,
			\legato, 1,
			\out, BusDef(\mixer0, \audio),
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
		),
		Pbind(
			\instrument, \iron,
			\note, Prout({ arg ev;
				var pat = Pseq([
				[0-36,7-24,3-12,0,3,7],
			],inf) + Pstep(Pseq([0,6],inf),4);
				var str = pat.asStream;
				inf.do {
					ev = str.next(ev).choose.yield
				};
			}),
			\dur, 1/4,
			\out, BusDef(\mixer1, \audio),
			\amp, 0.1/2,
		),

		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1337].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.1,
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\st, 92.10/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 1,
			],1),4).loop / Pkey(\st),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0.2,0.3,
			],inf).coin.not,
			\gain, 1,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1/2,
			\st, 92.10/4/60,
			\speed, 0.71 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0.5, 1,
			]+1,1),1/2).loop / Pkey(\st),
			\isRest, Pseq([
				1,0.5,
			],inf).coin.not,
			\dur, 1/4,
			\gain, 1/2,
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1245].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,0,1, 0,0,1,0,
				1,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.11 * Pseq([
				Pwhite(0.7,0.9,1),
				Pwhite(0.1,0.9,1),
				Pwhite(0.5,0.9,1),
				Pwhite(0.1,0.7,1),
			],inf),
			\out, BusDef(\mixer4, \audio),
		),
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1120].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer4, \audio),
		),
		
	])
)).play;
);


(
Ndef(\rdn2)[101] = \filter -> { arg in;
	var sig;
	var igate;
	sig = in;
	igate = Duty.kr(1/~t, 0, Dseq([
		0,1,
	],inf));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,1.9,0.5,0.1)), igate, doneAction:0);
	sig;

};
)
Ndef(\rdn2).quant=2

(
Ndef(\soundin, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SoundIn.ar([0,1]);
	sig = sig * \gain.kr(1);
	//sig = sig * ( LFSaw.kr( LFNoise0.kr(1).unipolar * 5600 ) * 1 + 1 );
}).play(BusDef(\soundin, \audio, 2).index, 2);
);
Ndef(\soundin).play(0,2)
Ndef(\soundin).edit;
