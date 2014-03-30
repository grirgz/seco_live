
(
Ndef(\stutter).quant = 1;
//~bus = BusDef(\stutter, \audio);
~bus = Bus.audio(s, 2);
);

(
~bufsize = 2; // in seconds
Ndef(\stutter, { arg choose=0, time=2, tapetime=2, stutter=4, attack=0.001, decay=0.001, tapelevel=0.7;
	var in = InFeedback.ar(~bus,2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var buf = LocalBuf(~bufsize * s.sampleRate, 2);
	var buf2 = LocalBuf(~bufsize * s.sampleRate, 2);
	var rate;
	var choosetrig, choosetrig2;
	var env;
	var stuttrig;
	var recordtrig;
	sig = in;
	sig1 = sig;
	stuttrig = Impulse.ar(stutter);
	choosetrig = choose > 0;

	recordtrig = Impulse.kr(1/time);
	recordtrig = recordtrig + Trig1.kr(choosetrig);

	RecordBuf.ar(sig, buf, loop:1, trigger:choosetrig);
	RecordBuf.ar(sig, buf2, loop:1, trigger:recordtrig);

	// tape stop
	rate = EnvGen.kr(Env([1,1,tapelevel],[0,tapetime]), choosetrig);
	sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

	// stutter
	env = EnvGen.ar(Env([0,1,1,0],[attack, 1/stutter, decay]), stuttrig);
	sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, 0, loop:1) * env;

	sig = Select.ar(choose, [sig1, sig2, sig3]);
	sig;
}).play;
);

(
Pdef(\stutter, Pbind(
	\instrument, \default,
	\freq, Pseq([
		Pseq([
			Pser([
				100,300,200,500,
			],32),
			Pser([
				100,300,200,500,
				400,350,300,250,
			],16),
			Pser([
				400,50,70,90,
			],16),
		],2),
		800,
	],inf) + Pwhite(0.0,20) * Pseq([1,2,1.5,0.5],inf).stutter(8) * Pseq([
		1,
		[1,0.5,0.3],
		1,
		[3/7,1,2/5],
		1,
		[1/9,1/2,2/11],
	],inf).stutter(16),
	\legato, Pseq([1,0.5,2.1,0.052],inf).stutter(32),
	\out, ~bus,
	\dur, 1/8,
)).play
);


Ndef(\stutter).set(\stutter, 20); // repeat rate
Ndef(\stutter).set(\stutter, 180); // repeat rate
Ndef(\stutter).set(\stutter, 8);
Ndef(\stutter).set(\time, 1/16); // repeat size in seconds
Ndef(\stutter).set(\time, 2); // repeat size
Ndef(\stutter).set(\choose, 2); // stutter
Ndef(\stutter).set(\choose, 1); // tapestop
Ndef(\stutter).set(\choose, 0); // normal
Ndef(\stutter).set(\tapetime, 2); // tape slowdown factor
Ndef(\stutter).set(\tapetime, 1/8); // tape slowdown factor

Ndef(\stutter).set(\tapelevel, 0.7); // end rate of tape
Ndef(\stutter).set(\tapelevel, 0.1);  


(
Ndef(\stutter).unset(\choose); 
Ndef(\stutter).unset(\stutter); 
Ndef(\stutter).put(1, \set -> Pbind(
	\choose, Pseq([
		Pser([
			0,0,2,2, 0,0,2,1,
		],16),
		Pser([2],16),
	],inf),
	\stutter, Pseq([
		Pser([8,4],16),
		Pser([2,78,20,120, 40,20,160,40],16),
	],inf),
	\dur, 1/2,
	
));
)
