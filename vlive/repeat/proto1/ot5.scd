
FileSystemProject(\proto1).open;

TrackDef(\ot5).clear
(
	TrackDef(\ot5, TrackDef(\playergrid));
	TrackDef(\ot5).source = [
		[
			Pdef(\ot5kick),
		],
		[
			Pdef(\ot5snare),
		],
		[
			Pdef(\ot5hat),
		],
		[
			Ndef(\myrdn),
		],
		[
			Ndef(\rdneq),
		],
	];
);

TrackDef(\ot5).activate
TrackDef(\ot5).edit

(
SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0;
    var formant;
    formant = Formant.ar(XLine.kr(400,1000, 4), 2000, 800, 0.125) ! 2 * 0.1;
    RecordBuf.ar(formant, bufnum, doneAction: 2, loop: 0);
	Out.ar(out, formant);
}).play(s,[\out, 0, \bufnum, ~buf]);
)

(
SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0;
    var formant;
    formant = Formant.ar(XLine.kr(400,1000, 4), 2000, 800, 0.125)  * 0.1;
    RecordBuf.ar(formant, bufnum, doneAction: 2, loop: 0);
	Out.ar(out, formant);
}).play(s,[\out, 0, \bufnum, b]);
)


(
Ndef(\playbuf2, { arg amp=0.1, bufnum=0, speed=1, pos=0, doneAction=0, loop=1, trigger=1;
	var sig;
	bufnum = ~buf;
	trigger = Impulse.kr(4 * ~t);
	pos = Duty.kr(1/8/~t, 0, Dseq([
		1,0,1.10,0,
	],inf)) / 4 * SinOsc.kr(1/4*~t).range(2,1);
	speed = Duty.kr(1/8/~t, 0, Dseq([
		1,0,1.10,0,
	],inf)) / 1 * SinOsc.kr(1/4*~t).range(-1,1);
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	sig;
}).play;
);

(
Ndef(\playbuf2, { arg amp=0.1, bufnum=0, speed=1, pos=0, doneAction=0, loop=1, trigger=1;
	var sig;
	var phase;
	var fr;
	bufnum = ~buf;
	fr = BufFrames.kr(bufnum);
	trigger = Impulse.kr(1/4 * ~t);
	pos = Duty.kr(1/8/~t, 0, Dseq([
		0,0,0,0, 0,0,1,1,
	],inf)) / 4;
	speed = Duty.kr(1/8/~t, 0, Dseq([
		1,1,1,1, 1,1,1,1,
	],inf)) / 1;
	//sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	phase = Phasor.ar(1, 1,0,BufFrames.kr(bufnum));
	//phase = phase + Duty.kr(1/~t, 0, Dseq([
	//	0,0,0,0,
	//],inf)) / 16;
	//phase = phase + ( SinOsc.kr(1/16).range(0,1)* fr );
	phase = phase + ( Duty.kr(1/~t, 0, Dseq([
		0,0,0,8,
	],inf)) / 16 * fr );
	sig = BufRd.ar(2, bufnum, phase);
	sig;
}).play;
);

Ndef(\playbuf2).clear


(
SynthDef(\recordbuf, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	RecordBuf.ar(sig, \bufnum.kr(0), loop:\loop.kr(0), doneAction:2);
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, ( sig * 1000 ).tanh / 18);
}).add;
SynthDef(\playbuf2, { arg out=0, amp=0.1, gate=1, bufnum=0, speed=1, pos=0, doneAction=2, loop=0, trigger=1;
	var sig;
	sig = PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum) * speed, trigger, startPos: (pos*BufFrames.kr(bufnum)), doneAction:doneAction, loop: loop);
	//sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
~buf = ~buf ?? { Buffer.alloc(s, s.sampleRate / ~t * 4, 2 ) };
);
b
~buf = nil;

Synth(\recordbuf, [])
(instrument: \recordbuf, bufnum: ~buf, inbus: BusDef(\recbus, \audio, 2), loop:1).play

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0],inf),
	\out, BusDef(\recbus),
	\dur, 1,
	\amp, 0.1
)).play;
);

(
	Pdef(\main1,

		Ppar([
			Pdef(\ot5kick),
			Pdef(\ot5snare),
			Pdef(\ot5hat),
		])
	).play
)
(
	Ppar([
		Pbind(
			\instrument, \recordbuf,
			\inbus, BusDef(\recbus, \audio, 2),
			\bufnum, ~buf,
			\dur, Pn(4,1),
		),
		Ppar([
			Pdef(\ot5kick),
			Pdef(\ot5snare),
			Pdef(\ot5hat),
		].collect({ arg x;
			x.debug("x");
			Pbind(\out, BusDef(\recbus)) <> x;
		}))
	]).play
)

~buf.play
~buf.plot
(
Pdef(\playbuf, Pbind(
	\instrument, \playbuf2,
	\bufnum, ~buf,
	\freq, 200,
	\speed, -1,
	\pos, 0.999,
	\out, BusDef(\sendbus1, \audio, 2),
	\dur, 4,
	\amp, 0.1
)).play;
)

Pdef(\playbuf).stop

(
Pdef(\playbuf, Pbind(
	\instrument, \playbuf2,
	\bufnum, ~buf,
	\freq, 200,
	\speed, 1,
	//\pos, 0.999,
	\out, BusDef(\sendbus1, \audio, 2),
	\dur, 4,
	\amp, 0.1
)).play;
)

RandDelayNetwork(\default).make(\rdn1, "4--", BusDef(\sendbus1, \audio, 2))
Ndef(\rdn1).set(\inu)
Ndef(\rdn1).play
Ndef(\rdn1).edit

(
Pdef(\ot5kick, Pbind(
	\instrument, \zkick,
	\env1, Pseq([
		[ Env.new([80, 35, 35], [0.055, 0.29], [-4, -5]) ],
	],inf),
	\env0, Pseq([
		[ Env.new([0, 1, 0.8,0], [0.015, 0.09,0.1], [-4, -5]) ],
	],inf),
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,1,0,
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,0,0,

		1,0,0,0, 0,0,0,0,
		0,0,1,0, 0,0,0,1,
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,1,0,

		1,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,1,0,
		1,0,0,0, 0,0,0,0,
		0,0,0,0, 1,0,0,0,

		1,0,0,0, 0,0,0,0,
		0,0,1,0, 0,0,0,1,
		1,0,0,0, 0,0,1,0,
		0,0,1,0, 1,0,1,0,
	],inf).coin.not,
	\amp, 0.15,
	\amp, Pkey(\amp) * Pseq([
		1,0.5,0.61,0.5,
		0.7,0.5,0.6,0.5,
	],inf),
));

Pdef(\ot5hat, Pbind(
	\instrument, \zhat,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pser([
			0,0,1,0, 1,0,1,0,
			0,1,1,0, 1,0.5,1,0,
			0,0,1,1, 1,1,1,0,
		],16 * 3),
		Pser([
			1,0,
		],16),
		Pser([
			0,0,1,0, 1,0,1,0,
		],16 * 3),
		Pser([
			1,0,
		],16),
	],inf).coin.not,
	\ampm, Ndef(\hat_lfo_ampm, { SinOsc.kr(2.1*~t).range(0.6,1) }),
	\hpf, Ndef(\hat_lfo_lpf, { SinOsc.kr(2.05*~t).range(1500,7000) }),
	\rel, Pseq([0.01,0.1,0.1,0.2],inf).stutter(Prand([1,1,1,2,3,4,1,1,1,1,1,1,1,1],inf)),
	\rel, Pseq([
		Pser([0.1],16),
		Pser([0.07],16),
		Pser([0.04],16),
		Pser([
			Pseq([
				0.04,
			],4),
			0.2,
			Pseq([
				0.01,
			],3),
		],16),
	],inf),
	\amp, 0.1/8,
	\amp, Pkey(\amp) * Pseq([
		0.3,0.5,1,0.5,
		0.3,0.15,1,0.5,
		0.1,0.55,0.41,0.8,
	],inf),
));

Pdef(\ot5snare, Pbind(
	\instrument, \zsnare,
	\degree, Pseq([0],inf),
	\dur, 1/8,
	\isRest, Pseq([
		Pseq([
			0,0,0,0, 0,0,0,0,
			1,0,0,0, 0,0,0,0,
		],1),
	],inf).coin.not,
	\amp, 0.2
));

)


///////////////////////////////////////



// Execute the following in order
(
// allocate a Buffer
s = Server.local;
b = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer
)

// record for four seconds
(
SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0;
    var formant;
    formant = Formant.ar(XLine.kr(400,1000, 4), 2000, 800, 0.125);
    RecordBuf.ar(formant, bufnum, doneAction: 2, loop: 0);
}).play(s,[\out, 0, \bufnum, b]);
)

b.plot
// play it back
(
SynthDef(\help_RecordBuf_playback, { arg out = 0, bufnum = 0;
    var playbuf;
    playbuf = PlayBuf.ar(1,bufnum);
    FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
    Out.ar(out, playbuf);
}).play(s, [\out, 0, \bufnum, b]);
)

// overdub
(
SynthDef(\help_RecordBuf_overdub, { arg out=0, bufnum=0;
    var formant;
    formant = Formant.ar(XLine.kr(200, 1000, 4), 2000, 800, 0.125);
    // mixes equally with existing data
    RecordBuf.ar(formant, bufnum, 0, 0.3, 0.5, doneAction: 2, loop: 0);
}).play(s, [\out, 0, \bufnum, b]);
)

// play back the overdubbed version
Synth.new(\help_RecordBuf_playback, [\out, 0, \bufnum, b], s);

// write the contents of the buffer to a file (see Buffer for more options)
(
b.write(sampleFormat: 'int16');
thisProcess.platform.recordingsDir +/+ "SC_" ++ Date.localtime.stamp ++ ".aiff"; // generated path
)

b.close; b.free; // cleanup
