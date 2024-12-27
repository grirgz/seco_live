
(
~t = ~t ?? { ~t = 1; TempoClock.default.tempo = ~t; ~t };
s.waitForBoot { FileSystemProject.load("sun/lib.scd"); };
)

ParamProto.init
// END


Document.current.path
(
[
"ddwCommon",
"wslib",
"crucial-library",
"Feedback",
"Modality-toolkit",
"Log",
"JITLibExtensions",
"WindowViewRecall",
"https://github.com/muellmusik/EQui",
].do { arg quark;
	Quarks.install(quark);
}
)


////////////////////////////////////////////////////////////////////
Array

(1..1000).join(", ").postln
(1..1000).postln

(
c = [0, 2, 1, 5, 4, 7, 9, 8, 0, 1, 3, 2, 4, 3, 1];
// c = { 20.rand }!300; // does not always find a pattern, so run several times
// we can image this being midinotes numbers. Now I want to find a 3-note pattern in the sequence
// with 3 or more occurrences
r = ();
d = c.differentiate;
~pats = ();
(d.size - 3).collect{|i|
	var pat = d[i + 1..i + 2];
	var key = pat.asSymbol;
	if (r[key].notNil)
	{ 
		i.debug("i");
		r[key].add(i);
		r.debug("r");
		if (r[key].size > 2) {  ~pats.add(key -> r[key]) }
	}
	{ r.add(key -> List.new) }
};
~pats.keysDo{|n| ~pats[n].collect{|i| c[i..i + 2 ] }.debug(\pattern) }; // finds the one pattern with 3 occurrences 
""
)

d
r

(
c = [0, 2, 1, 5, 4, 7, 9, 8, 0, 1, 3, 2, 4, 3, 1];
// c = { 20.rand }!300; // does not always find a pattern, so run several times
// we can image this being midinotes numbers. Now I want to find a 3-note pattern in the sequence
// with 3 or more occurrences
r = ();
d = c.differentiate;
~pats = ();
(d.size - 3).collect{|i|
	var pat = d[i + 1..i + 2];
	var key = pat.asSymbol;
	if (r[key].notNil)
	{ 
		i.debug("i");
		r[key].add(i);
		r.debug("r");
		if (r[key].size > 2) {  ~pats.add(key -> r[key]) }
	}
	{ r.add(key -> List.new) }
};
~pats.keysDo{|n| ~pats[n].collect{|i| c[i..i + 2 ] }.debug(\pattern) }; // finds the one pattern with 3 occurrences 
""
)


(
Routine.run {
s.boot;
s.bootSync;

// Global Stuff
~tempo = 128/60;
~loopBarCt = 8;
TempoClock.default.tempo = ~tempo;

// Busses and Routing

// allocate busses
~masterBus = Bus.audio(s, 2);
~drumBus = Bus.audio(s, 2);
~tonalBus = Bus.audio(s, 2);

// Define Bus Types
SynthDef(\bus2x2, {
  var sig;
  sig = In.ar(\in.kr(0), 2);
  Out.ar(\out.kr(0), sig);
}).add;
s.sync;

SynthDef(\bus2x2clip, {
  var sig;
  sig = In.ar(\in.kr(0), 2);
  sig = Limiter.ar(sig, 1.0);
  sig = Clip.ar(sig, -1.0, 1.0);
  Out.ar(\out.kr(0), sig);
}).add;
s.sync;

// Route Busses
~masterBusIns = Synth(\bus2x2clip, [in: ~masterBus, out: 0]);
~drumBusIns = Synth(\bus2x2, [in: ~drumBus, out: ~masterBus]);
~tonalBusIns = Synth(\bus2x2, [in: ~tonalBus, out: ~masterBus]);

// Modulation

// Instruments
SynthDef(\kick0, {
  var sig, pitchEnv, freqModHz, ampEnv, destFreq, amp;
  destFreq = 40;
  amp = \amp.kr(0.3);
  freqModHz = 120;
  pitchEnv = EnvGen.kr(Env.perc(0.01, 0.4, 1, -20), doneAction: 2);
  ampEnv = EnvGen.kr(Env.linen(0.01, 0.08, 0.08, \amp.kr()), doneAction: 2);
  sig = SinOsc.ar((freqModHz * pitchEnv) + destFreq);
  // use amp env to control the amplitude of the signal down to 0
  sig = sig * ampEnv;

  Out.ar(\out.kr(), sig ! 2);
}).add;
s.sync;

SynthDef(\sub, {
  var sig;
  sig = SinOsc.ar(\freq.kr()).dup * \amp.kr(0.1);
  sig = sig * EnvGen.kr(Env.linen(0.03, \dur.kr(1.0)/4, 0.21*\dur.kr(), 1.0), doneAction: 2);
  Out.ar(\out.kr(), sig);
}).add;
s.sync;

// saw wave synth
SynthDef(\saw, {
  var sig;
  sig = Saw.ar(\freq.kr()).dup * \amp.kr(0.1);
  sig = sig * EnvGen.kr(Env.linen(0.03, \dur.kr(1.0)/4, 0.21*\dur.kr(), 1.0), doneAction: 2);

  sig = BHiPass4.ar(sig, 80, 1);
  sig = BMoog.ar(sig, LFTri.kr(~tempo/3*4).range(100, 1000), 0.2, 0.0, 1.75);
  
  Out.ar(\out.kr(), sig);
}).add;
s.sync;
};
)

// Patterns
(
~kick0Loop = Pbind(
  \instrument, \kick0,
  \dur, 1.0,
  \amp, 1,
  \out, ~drumBus,
);

~subLoop = Pbind(
  \instrument, \sub,
  \dur, Pseq([0.5, 0.50*0.75, 0.50*0.25]*4, inf),
  \freq, Pseq(([28, 29, 40]-1).midicps, inf),
  \amp, 0.2,
  \out, ~tonalBus,
);

~sawLoop = Pbind(
  \instrument, \saw,
  \dur, 4.0,
  \freq, Pseq([28].midicps, inf),
  \amp, 0.1,
  \out, ~tonalBus,
);
)

~masterBusIns = Synth(\bus2x2clip, [in: ~masterBus, out: 0]);
~drumBusIns = Synth(\bus2x2, [in: ~drumBus, out: ~masterBus]);
~tonalBusIns = Synth(\bus2x2, [in: ~tonalBus, out: ~masterBus]);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\bus2x2clip,
			\in, ~masterBus,
			\out, 0,
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		Pmono(\bus2x2,
			\in, ~tonalBus,
			\out, ~masterBus,
			\addAction, \addToTail,
			\lag, 0.0008,
			\dur, 1,
		),
		Pmono(\bus2x2,
			\in, ~drumBus,
			\out, ~masterBus,
			\addAction, \addToTail,
			\lag, 0.0008,
			\dur, 1,
		),
		~kick0Loop = Pbind(
			\instrument, \kick0,
			\dur, 1.0/8,
			\amp, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\out, ~drumBus,
		),

		~subLoop = Pbind(
			\instrument, \sub,
			\dur, Pseq([0.5, 0.50*0.75, 0.50*0.25]*4, inf),
			\freq, Pseq(([28, 49, 60]-1).midicps, inf),
			\amp, 0.2,
			\out, ~tonalBus,
		),
		Pbind(
			\instrument, \default,
			\note, Pseq([
				12,
			],inf),
			\octave, 5,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),

		~sawLoop = Pbind(
			\instrument, \saw,
			\dur, 4.0,
			\freq, Pseq([28].midicps, inf),
			\amp, 0.1,
			\out, ~tonalBus,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Led Zeppelin - When The Levee Breaks.wav'),
			\legato, 1,
			\st, 71/2/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
				0, 1,
			]+0,1),2).loop / Pkey(\st),
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2302].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1795].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		~kick0Loop = Pbind(
			\instrument, \kick0,
			\dur, 1.0/8,
			\amp, 1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
			],inf).coin.not,
			\out, ~drumBus,
		),
		Pmono(\bus2x2,
			\inbus, ~drumBus,
			//\out, ~masterBus,
			\out, 0,
			\addAction, \addToTail,
			\lag, 0.0008,
			\dur, 1,
		),
	])
)).play;
);


//////////

(
Ndef(\zedy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var changed;
	var env;
	var value, time;
	value = \value.kr(2);
	time = \time.kr(4);
	changed = Changed.kr(value) + Changed.kr(time);
	env = EnvGen.kr(Env([1,value],[time]), changed);
	sig = SinOsc.ar(freq * env);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

Ndef(\zedx).set(\value, 4)
Ndef(\zedx).set(\time, 3.4)
Ndef(\zedx).set(\time, 0.4)




(
// \degree and \ctranspose
// since we use ctranspose instead of mtranspose, every chord is major
// does not follow scale
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4,0],inf),
		\mtranspose, Pseq([0,2,4,5],inf).stutter(4),
		\dur, 1/4,
		\amp, 0.1,
	).trace
).play;
);
.gtranspose

(
// \degree and \ctranspose
// since we use ctranspose instead of mtranspose, every chord is major
// does not follow scale
Pdef(\zed, 
	Pbind(
		\instrument, \default,
		\degree, Pseq([0,2,4,0],inf),
		\ctranspose, Pseq([0,2],inf).stutter(4),
		\dur, 1/4,
		\amp, 0.1,
	).trace
).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))




(

s.waitForBoot({

	SynthDef(\farEnough, {
		arg pitch, freq=70, addFreq=17, attack=1, release = 12;
		var sig, sig1, saws, env, shapeEnv, local, local2;
		sig =
		Mix.new(
			Array.fill(8,
				{SinOsc.ar(freq + addFreq.rand, 0.95.rand, 0.03)}));

		env = EnvGen.kr(
			Env.perc(attack, release ),
			doneAction:2);
		sig1 = sig + (sig *
			Mix.new(
				Array.fill(8,
					{SinOsc.ar(0.02, 0.7.rand, LFNoise1.kr(0.02, 0.08))})));

		sig = sig * env;
		sig1 = sig1 * env;

		sig = PitchShift.ar(sig, 0.1, SinOsc.kr(pitch.rrand(0.1, 0.2), 3.2.rand, 0.9, 3));
		sig1 = PitchShift.ar(sig1, 0.1, SinOsc.kr(pitch.rrand(0.1, 9.2), 0, 0.9, 3));

		saws = Mix.new(
			Array.fill(8,
				{LFSaw.ar(\sawFreq.ir(4000) + addFreq.rand, 0.9.rand, 0.02)}));
		shapeEnv = EnvGen.kr(Env([0.1, 0.02, 0.8, 0.0], [1, 5, 3 , 2]));

		saws = saws * shapeEnv;
		saws = saws * env;

		local = LocalIn.ar(2) + [sig+sig1, sig1+sig];
		local = DelayN.ar(local, 0.8, [0.3, 0.33.rand]);
		local2 = LocalIn.ar(2) + [saws, saws];
		local2 = DelayN.ar(local2, 0.8, [0.02, 0.02.rand]);
		local = local + local2;

		local = Compander.ar(
			local, local,
			0.2, slopeBelow: 1.3,
			slopeAbove: 0.1,
			clampTime:0.1,
			relaxTime:0.01);
		local = local.tanh;
		local = HPF.ar(local, 70);
		//local = BRF.ar(local, 260);
		LocalOut.ar(local * 0.8);
		Out.ar(0, local);

	}).add;




	SynthDef(\impul, {
		arg freq = 1000;
		var sig, sig1, env;
		sig = Pan2.ar(
			Mix.ar(
				Array.fill(8,
					{Impulse.ar(freq + 130.rand, 0.7.rand,
						LFNoise1.kr(20, 0.2.rand))})), 0);
		4.do({ sig = AllpassN.ar(sig, 0.050, [0.050.rand, 0.050.rand], 1) });
		sig1 = sig * LFNoise1.ar(23, Dust2.kr(20));
		4.do({ sig1 = AllpassN.ar(sig, 0.050, [0.050.rand, 0.050.rand], 1) });
		env = EnvGen.kr(Env.perc(5, 20), doneAction:2);
		sig = (sig  + sig1)*env;


		Out.ar(0, sig);
	}).add;




	SynthDef(\f, {
		arg pitch, addFreq=200;
		var sig, sig1, env, local;
		sig =
		Mix.new(Array.fill(8,
			{SinOsc.ar(\freq.ir(300) + addFreq.rand, 0.45.rand, 0.02)}));

		env = EnvGen.kr(
			Env.perc(
				\attack.ir(0.1),
				\release.ir(10)),
			doneAction:2);

		sig1 = sig + (sig * SinOsc.ar(30, 0.7.rand));

		sig1 = sig1 * env;
		sig = sig * env;
		sig = PitchShift.ar(sig, 0.1, SinOsc.kr(pitch.rrand(0.1, 3.2), 0, 0.9, 3));

		local = LocalIn.ar(2) + [sig+sig1, sig1+sig];
		local = DelayN.ar(local, 0.8, [0.3, 0.33.rand]);
		LocalOut.ar(local * 0.8);
		Out.ar(0, local);
	}).add;


	SynthDef(\bur, {
		arg freq=232, gate=10, dauer = 20, amp=1;
		var sig, env, lastEnv;

		sig = SinOsc.ar(freq);
		env = EnvGen.kr(Env.perc, Impulse.kr(gate), doneAction:2);

		sig = sig * env;
		sig = Compander.ar(sig, sig, 0.2, 4.3, clampTime:0.1, relaxTime:0.001);
		lastEnv = EnvGen.kr(Env([0, 1, 1, 0], [0.01, dauer, 3, 0.02]), doneAction:2);
		sig = sig * lastEnv;
		sig = sig * amp;
		Out.ar(0, sig!2);
	}).add;


	s.sync;





	s.record("home", 0, 2); //RECORD

	fork{
		for(1, 100000){arg i;
			0.01.wait;
			i = i/100;

			i.postln;

			if(i ==1){Synth(\farEnough, [\addFreq, 4,\attack, 4, \release, 10])};
			if(i ==7){
				Synth(\farEnough, [\addFreq, 21, \release, 13]);
				Synth(\farEnough, [\addFreq, 20,\release, 10]);
			};

			if(i == 11){Synth(\farEnough, [\addFreq, 38,\release, 10])};
			if(i == 17.77){Synth(\farEnough, [\addFreq, 43,\release, 16])};
			if(i == 24){Synth(\farEnough, [\addFreq, 403,\attack, 6, \release, 16])};
			if(i == 26.2){Synth(\farEnough, [\addFreq, 803,\release, 9])};
			if(i == 29.6){Synth(\farEnough, [\addFreq, 2803,\release, 15])};

			if(i == 29.9){Synth(\impul)};
			if(i == 36.9){
				Synth(\impul, [\freq, 700]);
				Synth(\farEnough, [\addFreq, 12,\release, 12]);
				Synth(\farEnough, [\addFreq, 17,\release, 14]);
			};

			if(i == 44.3){Synth(\impul, [\freq, 964])};

			if(i == 47.2){Synth(\f)};
			if(i == 52){Synth(\farEnough, [\addFreq, 2400,\release, 20])};
			if(i == 61.3){
				Synth(\impul, [\freq, 2904]);
				Synth(\farEnough, [\addFreq, 240,\release, 20]);

			};

			if(i == 102.3){Synth(\f,
				[\freq, 400 + 500.rand,
					\attack, 6,
					\release, 20
			]);
			};

			if(i ==143){Synth(\farEnough, [
				\addFreq, 2.1,
				\attack, 14,
				\release, 30]
			)};



		};


	};

	//another routine

	fork{
		"hello".postln;
		62.wait;         ///////////after 62 SECs
		2.do({
			Synth(\f, [
				\freq, 30 + 5.rand,
				\addFreq, 3000.rand,
				\attack, 14,
				\release, 30
			]);
			10.wait;
		});
		10.wait;
		"click".postc();


		4.do({Synth(\bur, [
			\freq, 230 + 30.rand,
			\gate, [11, 2, 5, 9].choose,
		]);
		});
		11.wait;

		Synth(\f);
		4.wait;

		Synth(\f,
			[\freq, 400 + 50.rand,
				\attack, 6,
				\release, 20
			]
		);

		0.3.wait;



		3.do({Synth(\bur, [
			\freq, 230 + 30.rand,
			\gate, [11, 2, 9].choose,
			\dauer, 33,
			\amp, [0.1, 0.8, 0.03].choose,
		]);
		});

		14.wait;

		2.do({Synth(\bur, [
			\freq, 230 + 300.rand,
			\gate, [3, 5].choose,
			\dauer, 13,
			\amp, [0.1, 0.8, 0.03].choose,
		]);
		});



	};


	113.wait; //113 seconds later

	Synth(\f,
			[\freq, 400 + 50.rand,
				\attack, 16,
				\release, 23
			]
		);

	fork{
		p=[
			Pbind(\instrument, \bur,
				\freq, 200 + 30.rand,
				\dur, 0.09.rand,
				\amp, Pfunc({[0.04, 0.6].choose}),
				\dauer, 12
			).play,

			5.3.wait;

			Pbind(\instrument, \bur,
				\dur, 0.09,
				\amp, Pfunc({[0.1, 0.6].choose}),
				\dauer, 16
			).play,

			Pbind(\instrument, \bur,
				\dur, 0.1,
				\amp, Pfunc({[0.04, 0.6].choose}),
				\dauer, 16
			).play,

		];

		19.wait;
		p[0].stop;
		0.2.wait;
		p[1].stop;
		p[2].stop;



	};


	s.sync;
});
)
ProtoDef(\piano).startControl(Pdef(\melo))
(
Pdef(\melo, 
	Pbind(
		\instrument, \default,
	)
)
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
	])
)).play;
);

2**250
2**125

1 / 25

proba de tout rater
( 1-0.77 )**25
1-( ( 1-0.77 )**25 )
1-( ( 1-0.73 )**25 )
0.77**1.2
250/12
(1-)20.83
1-( ( 1-0.77 )**1.9 )
1-( ( 1-0.77 )**2 )

250/6

( 1-0.77 )**2

1-( ( 1-0.77 )**2 )

NoteTimeline(\bla).edit


{ SinOsc.ar(5).unipolar.bipolar}.plot(1);


(
{ |out=0, freq, mul=512, vsweep=0.5, hold=0.25, release=0.25, amp=0.5, pan=0|
    var p0, p1, p, freq0, freq1, freqEnv, sig;
    p0 = 0.006699687;
    p1 = 0.00001884606;
    p = (1-vsweep)*p0 + (vsweep*p1);
    freq1 = freq;
    freq0 = freq1 * mul;
    freqEnv = EnvGen.ar(Env([0,1], [1.0], [0]));
    freqEnv = freq1 + ((freq0-freq1)/(1.0 + (freqEnv/p)));
    sig = SinOsc.ar(freqEnv);
    sig = sig * EnvGen.ar(Env([1,1,0], [hold,release], [0,0]), doneAction: Done.freeSelf) * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}.play(args: [freq: 25.midicps, vsweep: 0.914, hold: 0.18, release: 0.02]);
)

(
{ |out=0, freq, mul=512, vsweep=0.5, hold=0.25, release=0.25, amp=0.5, pan=0|
    var p0, p1, p, freq0, freq1, freqEnv, sig;
	vsweep = 0.914; hold = 0.18; release = 0.02; freq=25.midicps;
    p0 = 0.006699687;
    p1 = 0.00001884606;
    p = (1-vsweep)*p0 + (vsweep*p1);
    freq1 = freq;
    freq0 = freq1 * mul;
	release.poll;
    freqEnv = EnvGen.ar(Env([0,1], [1.0], [0]), 1);
    //freqEnv = freq1 + ((freq0-freq1)/(1.0 + (freqEnv/p)));

	[freqEnv, freqEnv/p, (1.0 + (freqEnv/p)), (freq0-freq1),((freq0-freq1)/(1.0 + (freqEnv/p))) ];
}.plot(0.2,args: [freq: 25.midicps, vsweep: 0.914, hold: 0.18, release: 0.02]);
)

(
{ |out=0, freq, mul=512, vsweep=0.5, hold=0.25, release=0.25, amp=0.5, pan=0|
    var p0, p1, p, freq0, freq1, freqEnv, sig;
	vsweep = 0.914; hold = 0.18; release = 0.02; freq=25.midicps; mul=2;
    p0 = 0.006699687;
    p1 = 0.00001884606;
    p = (1-vsweep)*p0 + (vsweep*p1);
    freq1 = freq;
    freq0 = freq1 * mul;
	release.poll;
    freqEnv = EnvGen.ar(Env([0,1], [1.0], [0]), 1);
    //freqEnv = freq1 + ((freq0-freq1)/(1.0 + (freqEnv/p)));

	[freqEnv, freqEnv/p, (1.0 + (freqEnv/p)), (freq0-freq1),((freq0-freq1)/(1.0 + (freqEnv/p))) ];
}.plot(0.2,args: [freq: 25.midicps, vsweep: 0.914, hold: 0.18, release: 0.02]);
)

(
{ |out=0, freq, mul=512, vsweep=0.5, hold=0.25, release=0.25, amp=0.5, pan=0|
    var p0, p1, p, freq0, freq1, freqEnv, sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	vsweep = 0.914; hold = 0.18; release = 0.02; freq=25.midicps;
    p0 = 0.006699687;
    p1 = 0.00001884606;
    p = (1-vsweep)*p0 + (vsweep*p1);
    freq1 = freq;
    freq0 = freq1 * mul;
	release.poll;
    freqEnv = EnvGen.ar(Env([0,1], [1.0], [0]), 1);
    sig1 = freq1 + ((freq0-freq1)/(1.0 + (freqEnv/p)));

    p0 = 0.096699687;
    p1 = 0.00000084606;
    p = (1-vsweep)*p0 + (vsweep*p1);
    freq1 = freq;
    freq0 = freq1 * mul;
	release.poll;
    freqEnv = EnvGen.ar(Env([0,1], [1.0], [0]), 1);
    sig2 = freq1 + ((freq0-freq1)/(1.0 + (freqEnv/p)));

    p0 = 0.000699687;
    p1 = 0.01111884606;
    p = (1-vsweep)*p0 + (vsweep*p1);
    freq1 = freq;
    freq0 = freq1 * mul;
	release.poll;
    freqEnv = EnvGen.ar(Env([0,1], [1.0], [0]), 1);
    sig3 = freq1 + ((freq0-freq1)/(1.0 + (freqEnv/p)));
	[sig1, sig2, sig3];
}.plot(0.2,args: [freq: 25.midicps, vsweep: 0.914, hold: 0.18, release: 0.02]);
)


(
SynthDef(\horn, {
    arg pitch = 40, readerVoices=3, crewVoices=5, readerComplexity=0.1, crewComplexity=0.2, gate=1;
    var maxReaders=8, maxCrews=6;
    var snd, intensity, freq, fb, wet;
    var melodies;

    var scale = Scale.hexAeolian.degrees.as(LocalBuf);
    var chordAmpScalar = Select.kr(readerVoices,  8.collect{ arg i; (i+1).reciprocal });
    var melodyAmpScalar = Select.kr(crewVoices,  8.collect{ arg i; (i+1).reciprocal });

    freq = DegreeToKey.kr(scale, LFNoise2.kr(LFNoise0.kr(1/20!maxReaders).range(1/20,1/2) * (1 + (readerComplexity * 3))).unipolar(1 + (readerComplexity * 2))) + pitch;
    freq = freq;

    intensity = LFNoise2.kr(1/3).range(0.3, 0.8);

    snd = freq.collect { |degree, idx|
        var amp, snd;
        snd = Saw.ar(freq.midicps);
        snd = snd *  ToggleFF.kr(CoinGate.kr(readerComplexity, LFClipNoise.kr(2))).lag(0.02);
        snd = snd * (idx < readerVoices);
        snd = LeakDC.ar(snd);
    };
    snd = Splay.ar(snd.sum) * chordAmpScalar;
    snd = snd * intensity;
    snd = DelayC.ar(snd, 0.06, 0.06);
    snd = AllpassC.ar(snd, 0.2, [0.03, 0.05] * (LFNoise2.kr(3 ! 2) * 0.7).midiratio, 0.4);
    snd = AllpassC.ar(snd, 0.04, [0.04, 0.03], 0.002);
    snd = AllpassC.ar(snd, 0.04, [0.024, 0.004], 0.05);
    snd = snd * -2.dbamp;
    snd = LPF.ar(snd, 4000);
    snd = HPF.ar(snd, 100);

    snd = LPF.ar(snd, 120 + (700 * (LFNoise2.kr(LFNoise0.kr(1/20).range(1/10,2)).unipolar(0.2 + (readerComplexity * 1.6)))));
    snd = snd * -14.dbamp;

    melodies = LFNoise0.kr(1/10 + SinOsc.kr(1/20).unipolar( 1/4 + (crewComplexity * 4))).bipolar(1/8 + (crewComplexity * 3));
    melodies = DegreeToKey.kr(scale, melodies + LFNoise2.kr((1/20 + LFNoise0.kr(1/20).unipolar(2)) ! maxCrews).unipolar( 3 + (crewComplexity * 2 ))) + (pitch + 12);
    melodies = melodies.collect{ |degree, idx|
        var amp, osc;
        osc = Saw.ar(degree.midicps.lag(0.02));
        osc = osc *  ToggleFF.kr(CoinGate.kr(crewComplexity, LFClipNoise.kr(2))).lag(0.02);
        osc = osc * (idx < crewVoices);
        osc = BPF.ar(osc, 180 + (1000 * LFNoise2.kr(1/3).unipolar(4.0 * crewComplexity)), 1.7);
        osc = BHiShelf.ar(osc, 3000, 1, -20);
        osc = LeakDC.ar(osc);
        osc = Pan2.ar(osc, LFNoise2.ar(1/3).range(-1,1));
    };
    melodies = Splay.ar(melodies) * melodyAmpScalar;

	snd = FreeVerb.ar([snd, melodies].sum, 0.3, 1.3);
	snd = snd * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
    Out.ar(0, snd);
}).add; 
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(\horn,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);



Synth(\default); Bus(\audio, 0).plot(5);

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, 200,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).plot(5);
);


PathName()


// Default test Pbind
Ndef(\test, Pbind(*[
  instrument: \default,
  dur: 2,
]));
// Trying to hard pan to the left
(
Ndef(\test)[100] = \filterIn -> {
  arg in;
  Pan2.ar(in, 0)
  //Balance2.ar(in[0],in[1], -1)
};
)
Ndef(\test).play;
// Nope
Ndef(\test).scope;


Pbind(\degree, Pseries(0, 1, inf), \dur, Pseq([2, [1, 1, 2, Rest(1), 1, -1], 2].convertRhythm)).play;
Pbind(\degree, Pseries(0, 1, inf), \dur, Pseq([2, [1, 1, 1, 1], 1].convertRhythm.postln)).play;
s.quit
s.start
dentityDictionary(know: true);
Pbind(\degree, Pseries(0, 1, inf), \dur, Pseq([2, [1, [1, [2, 1, 1, -1]]], 2].convertRhythm)).play;
~factory = IdentityDictionary(know: true);
~factory.perc = { arg x, y, z; [x, y, z].postln; }
~factory.perc(1,2,3)
~factory.perc


(
SynthDef(\lfo1, { arg out=0, gate=1, amp=0.1, freq=2;
	var sig;
	sig = SinOsc.kr(freq) * amp + \add.kr(200);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	Out.kr(out, sig);
}).add;
);

(
SynthDef(\bpfbank, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = BPF.ar(sig, [\bpf1.kr(100), \bpf2.kr(100), \bpf3.kr(100)]).mean;
	sig = SinOsc.ar([\bpf1.kr(100), \bpf2.kr(100), \bpf3.kr(100)]).mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

~bus1 = BusDef(\bus1,\control);
~bus2 = BusDef(\bus2,\control);
~bus3 = BusDef(\bus3,\control);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Ppar(3.collect { arg x;
			Pmono(\lfo1,
				\freq, x+1,
				\amp, 90.3,
				\out, [~bus1, ~bus2, ~bus3][x],
			)
		}),
		Pbind(
			\instrument, \bpfbank,
			\freq, 100,
			\bpf1, ~bus1.asMap,
			\bpf2, ~bus2.asMap,
			\bpf3, ~bus3.asMap,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

Ppar(3.collect { arg x;
	Pmono(\lfo1,
		\freq, x+1,
		\amp, 90.3,
		\out, [~bus1, ~bus2, ~bus3][x],
	)
})


(
TempoClock.default.sched(2,{
	s.makeBundle(s.latency, {
		3.do { arg x;
			Synth(\lfosin, [\lfofreq, x+1])
		};
	})
})
)

s.makeBundle(2, {
	3.do { arg x;
		Synth(\lfosin, [\lfofreq, x+1])
	};
})

(
SynthDef(\lfosin, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( SinOsc.kr(\lfofreq.kr(2)) * 1 + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar([200 * SinOsc.ar(1), 500 * SinOsc.ar(0.1)  ]);
	pan = Line.kr(-1,1,10);
	sig = Pan2.ar(sig, [pan,0-pan].poll, amp).sum;
}).play;
);
Ndef(\zed).clear


(
	s.bind{
		SynthDef(\beep, {
			var sig, env, gate;
			gate = Impulse.ar(1);
			env = EnvGen.kr(Env.asr(0.005,1,0.5),gate:gate.lag(0.0001).poll);
			sig = SinOsc.ar(220, mul: \amp.kr(0.5));
			sig = sig *env;
			Out.ar(0, sig);

		}).add;

		s.sync;
		x = Synth(\beep, [\amp, 0.05])
	}
)


 (modifié)

(
	s.bind{
		SynthDef(\beep, {
			var sig, env, gate;
			gate = Impulse.kr(1);
			env = EnvGen.kr(Env.asr,gate:gate);
			sig = SinOsc.ar(220, mul: \amp.kr(0.5));
			sig = sig *env;
			Out.ar(0, sig);

		}).add;

		s.sync;
		x = Synth(\beep, [\amp, 0.05])
	}
)
(
	s.bind{
		SynthDef(\beep, {
			var sig, env, gate;
			gate = Trig1.ar(Impulse.ar(1), 0.1);
			env = EnvGen.kr(Env.asr,gate:gate.poll);
			sig = SinOsc.ar(220, mul: \amp.kr(0.5));
			sig = sig *env;
			Out.ar(0, sig);

		}).add;

		s.sync;
		x = Synth(\beep, [\amp, 0.05])
	}
)
(
	s.bind{
		SynthDef(\beep, {
			var sig, env, gate;
			gate = Impulse.ar(1);
			env = EnvGen.kr(Env.linen(0.1,0.1,0.1),gate:gate.poll);
			sig = SinOsc.ar(220, mul: \amp.kr(0.5));
			sig = sig *env;
			Out.ar(0, sig);

		}).add;

		s.sync;
		x = Synth(\beep, [\amp, 0.05])
	}
)


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		 Pbind(\dur, Pseq([1,1/4],inf)) <>
		Ppar([
			Pbind(
				\freq, 200,
			),
			Pbind(
				\freq, 450,
			),
		])
		
	])
)).play;
);


(
Pdef(\zed2, Pbind(
	\instrument, \default,
	\note, Pseq((0..7),inf),
	\dur, 1,
	\amp, 0.1,
)).play;
)
Pdef(\zed2).count(8)
Pbindef(\zed2, \octave, 3)
Pbindef(\zed2, \octave, 4)
Pbindef(\zed2, \detune, 140)
Pbindef(\zed2, \detune, 0)
Pbindef(\zed2).source.at(\octave).quant
Pbindef(\zed2).source.at(\octave).count(8)
Pbindef(\zed2).count(8)
Pbindef(\zed2).play
Pbindef(\zed).quant = 8
Pbindef(\zed).play
Pdef(\zed).clear
Pdef(\zed2).clear
Pdef(\zed).quant


t = TempoClock(80/60).permanent_(true);
q = 1/4;

t.tempo * 8*
(
Routine({
	var fxGroup = Group.new;
	loop {
		#[ 8, 8, 8, 8, 8, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
		   16, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0,
		   8, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
		   8, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0 ].do { |v|
			if (v > 0) {
				v.do {
					s.bind {
						Synth('sonic-pi-sc808_closed_hihat', [ amp: rrand(0.01, 0.02)*3/sqrt(v+2), decay: q/2 ], fxGroup);
					};
					(q/v).wait;
				};
			} {
				q.wait;
			};
		};
	};
	fxGroup.free;
}).play(t, quant: q);
)
sqrt(8)
sqrt(1)
log(8+1)
log(1+1)

(
Routine({
	var fxGroup = Group.new;
	loop {
		#[ 8, 8, 8, 8, 8, 8, 8, 8, 8, 0, 1, 1, 1, 0, 1, 1,
		   16, 16, 16, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0,
		   8, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
		   8, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0 ].do { |v|
			if (v > 0) {
				v.do {
					s.bind {
						Synth('sonic-pi-sc808_closed_hihat', [ amp: 0.02, decay: 0.0001 ], fxGroup);
					};
					(q/v).wait;
				};
			} {
				q.wait;
			};
		};
	};
	fxGroup.free;
}).play(t, quant: q);
)

(
SynthDef('sonic-pi-sc808_closed_hihat', {|
    amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
    pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
    hpf = 121.25219487074914, hpf_slide = 0, hpf_slide_shape = 1, hpf_slide_curve = 1,
    lpf = 121.05875888638981, lpf_slide = 0, lpf_slide_shape = 1, lpf_slide_curve = 1,

    decay=0.42,
    decay_curve = 0,
    out_bus = 0|

    var sig, sighi,siglow, sum, env, osc1, osc2, osc3, osc4, osc5, osc6;

    hpf = hpf.midicps;
    lpf = lpf.midicps;
    amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
    pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);

    hpf = hpf.varlag(hpf_slide, hpf_slide_curve, hpf_slide_shape);
    lpf = lpf.varlag(lpf_slide, lpf_slide_curve, lpf_slide_shape);

    //env = EnvGen.kr(Env.perc(0.005, decay, 1, decay_curve),doneAction:2);
    env = EnvGen.kr(Env.perc(0.001, 0.0001, 1, 0),doneAction:2);
    osc1 = LFPulse.ar(203.52);
    osc2 = LFPulse.ar(366.31);
    osc3 = LFPulse.ar(301.77);
    osc4 = LFPulse.ar(518.19);
    osc5 = LFPulse.ar(811.16);
    osc6 = LFPulse.ar(538.75);
    sighi = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    siglow = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    sighi = BPF.ar(sighi, lpf, 1);
    sighi = HPF.ar(sighi, hpf);
    siglow = BBandPass.ar(siglow, 8900, 0.8);
    siglow = BHiPass.ar(siglow, 9000, 0.3);
    sig = BPeakEQ.ar((siglow+sighi), 9700, 0.8, 0.7);
    sig = sig * env * amp * 12;
    //DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(out_bus, Pan2.ar(sig, pan));

}).add
)


(
t = TempoClock(80/60).permanent_(true);
q = 1/4;

Routine({
	var fxGroup = Group.new;
	#[ 8, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
	   3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0,
	   1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
	   3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0 ].do { |v|
		if (v > 0) {
			v.do {
				s.bind {
					Synth('sonic-pi-sc808_closed_hihat', [ amp: rrand(0.01, 0.02), decay: q/2 ], fxGroup);
				};
				(q/v).wait;
			};
		} {
			q.wait;
		};
	};
	fxGroup.free;
}).play(t, quant: q);
)

(
t = TempoClock(80/60).permanent_(true);
q = 1/4;

Routine({
	var fxGroup = Group.new;
	#[ 8, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
	   3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0,
	   1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
	   3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0 ].do { |v|
		if (v > 0) {
			v.do {
				s.bind {
					Synth('sonic-pi-sc808_closed_hihat', [ amp: rrand(0.01, 0.02) * 2/sqrt(v+3), decay: q/2 ], fxGroup);
				};
				(q/v).wait;
			};
		} {
			q.wait;
		};
	};
	fxGroup.free;
}).play(t, quant: q);
)



(
SynthDef('sonic-pi-sc808_closed_hihat', {|
    amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
    pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
    hpf = 121.25219487074914, hpf_slide = 0, hpf_slide_shape = 1, hpf_slide_curve = 1,
    lpf = 121.05875888638981, lpf_slide = 0, lpf_slide_shape = 1, lpf_slide_curve = 1,

    decay=0.42,
    decay_curve = -30,
    out_bus = 0|

    var sig, sighi,siglow, sum, env, osc1, osc2, osc3, osc4, osc5, osc6;

    hpf = hpf.midicps;
    lpf = lpf.midicps;
    amp = amp.varlag(amp_slide, amp_slide_curve, amp_slide_shape);
    pan = pan.varlag(pan_slide, pan_slide_curve, pan_slide_shape);

    hpf = hpf.varlag(hpf_slide, hpf_slide_curve, hpf_slide_shape);
    lpf = lpf.varlag(lpf_slide, lpf_slide_curve, lpf_slide_shape);

    env = EnvGen.kr(Env.perc(0.005, decay, 1, decay_curve),doneAction:2);
    osc1 = LFPulse.ar(203.52);
    osc2 = LFPulse.ar(366.31);
    osc3 = LFPulse.ar(301.77);
    osc4 = LFPulse.ar(518.19);
    osc5 = LFPulse.ar(811.16);
    osc6 = LFPulse.ar(538.75);
    sighi = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    siglow = (osc1 + osc2 + osc3 + osc4 + osc5 + osc6);
    sighi = BPF.ar(sighi, lpf, 1);
    sighi = HPF.ar(sighi, hpf);
    siglow = BBandPass.ar(siglow, 8900, 0.8);
    siglow = BHiPass.ar(siglow, 9000, 0.3);
    sig = BPeakEQ.ar((siglow+sighi), 9700, 0.8, 0.7);
    sig = sig * env * amp * 12;
    DetectSilence.ar(sig, doneAction: Done.freeSelf);
    Out.ar(out_bus, Pan2.ar(sig, pan));

}).add
)

(
Pdef(\pat, 
	Pbind(
		\instrument, 'sonic-pi-sc808_closed_hihat',
		\degree, Pseq([0],inf),
		\score, Pseq([
			8, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
			3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0,
			1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
			3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0 
		],1),
		\dur, Plazy({ arg ev;
			if(ev[\score] == 0) { Rest(1) } { 1/ev[\score] }
		}),
		\amp, 0.01,
	)
).play;
);


(
	t = TempoClock(80/60).permanent_(true);
	q = 1/4;
	Pdef(\pat, 
		Pbind(
			\instrument, 'sonic-pi-sc808_closed_hihat',
			\decay, q/2,
			\dur , PdurStutter(Pseq([
				8, 8, 8, 8, 1, -1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
				3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0,
				1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
				3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0 
			].collect { arg item, idx;
				//if(item == 0) { Rest(1) } { item }
				item
			},1), q).trace,
			\amp, Pwhite(0.01,0.02,inf) * 2 / sqrt(( 1/( Pkey(\dur)/q ) )+3),
		)
	).play(t);
);

(
	t = TempoClock(80/60).permanent_(true);
	q = 1/4;
	Pdef(\pat, 
		Pbind(
			\instrument, 'sonic-pi-sc808_closed_hihat',
			\decay, q/2,
			\dur, Prout({ arg ev;
				var fxGroup = Group.new;
				#[ 
					8, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
					3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0,
					1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1,
					3, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0 
				].do { |v|
					if (v > 0) {
						v.do { ( q/v ).yield }
					} {
						Rest(q).yield;
					};
				};
				fxGroup.free;
			}).trace,
			\amp, Pwhite(0.01,0.02,inf) * 2 / sqrt(( 1/( Pkey(\dur)/q ) )+3),
		)
	).play(t);
);


t = TempoClock(80/60).permanent_(true);
q = 1/4;

(
Routine({
	var fxGroup = Group.new;

	var fxReverbBus = Bus.audio(s, 2);
	var fxReverb = Synth('sonic-pi-fx_reverb', [ room: 1, in_bus: fxReverbBus, out_bus: 0 ], fxGroup);

	var args = [ amp: 0.08, out_bus: fxReverbBus ];

	var dur = { |ticks|
		(60 / 80) * ticks * q;
	};

	var play = { |note, ticks|
		s.bind {
			Synth('sonic-pi-beep', args ++ [
				note: note,
				attack: dur.(0.1 * ticks),
				sustain: dur.(0.8 * ticks),
				release: dur.(0.1 * ticks),
			], fxGroup);
		};
		(q * ticks).wait;
	};

	play.(57, 2);
	play.(60, 2);
	play.(62, 4);
	play.(69, 4);
	play.(65, 4);

	play.(64, 4);
	play.(62, 4);
	play.(57, 8);

	play.(60, 2);
	play.(57, 2);
	play.(62, 4);
	play.(67, 4);
	play.(65, 4);

	play.(69, 4);
	play.(67, 4);
	play.(64, 4);
	play.(65, 4);

	fxReverb.free;
	fxReverbBus.free;
	fxGroup.free;
}).play(t, quant: q);
)
{ SinOsc.ar(500) ! 2 * 0.1}.play;


Syt

SynthDesc(\default).class
SynthDesc(\xxaze).controls
s.quit
{ SinOsc.ar(500) ! 2 * 0.1}.play;

(
SynthDef(\xxaze, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
~patch = {
		Out.ar(\out.kr, SoundIn.ar(\in.kr, \atten.kr(1)))

};
)

~sd = SynthDef(\bla, ~patch)
~sd.allControlNames
~sd.children; // last is Out ugen
~sd.children.last.inputs // Out inputs


(
SynthDef(\sss, { arg out=0, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr( Env([0,1,0],[0.1,\sustainsec.kr(0.8)]), 1, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pbind(
	\instrument, \sss,
	\dur, 0.4,
	\legato, 0.2,
	\freq, Pseq([300,100],inf),
	\sustainsec, Pkey(\sustain) * TempoClock.default.tempo,
	\amp, 0.1,
).play;
)



RecordBuf
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav"); // remember to free the buffer later.
~r1 = Buffer.alloc(s, s.sampleRate * 0.5, numChannels: 1); 


(
	{
		arg recL=1, preL=0.5;
		var snd;

		snd = PlayBuf.ar(1, b, BufRateScale.kr(b), 0, startPos: (0*BufFrames.kr(b)), doneAction:0, loop: 0);
		RecordBuf.ar(snd, ~r1, recLevel: 1, preLevel: 0);
		snd


	}.play;

)

~r1.play

Pbind(\dur, 1)


(
Pdef(\zed, 
	Pbind(
		\note, Pseq([0,1,4,5],inf),
		\dur, 1/8,
	) <> Pstep(Pbind(\octave, Pseq([6,5],inf), \legato, Pseq([1,0.1],inf)), Pseq([1,1,1/2,1/2],inf))
).play;
);

{ SinOsc.ar(500) ! 2 * 0.1}.play;

(
Pdef(\zed, 
	Pbind(
		\note, Pseq([0,1,4,5],inf),
		\dur, 1/8,
	) <> Pseg(Pbind(\octave, Pseq([6,5],inf), \legato, Pseq([1,0.1],inf)), Pseq([1,1,1/2,1/2],inf))
).play;
);

(
Pdef(\zed, 
	Pbind(
		\note, Pseq([0,1,4,5],inf),
		\dur, 1/8,
	) <> Pbind(\dur, 1, \octave, Pseq([6,5],inf), \legato, Pseq([1,0.1],inf))
).play;
);


88.cpsmidi
1318.cpsmidi
~makeharm = { arg freq; freq*rrand(1,freq.cpsmidi/2).round.debug("r") }; ~makeharm.(88)
~makeharm.(2088)
(1..20)
0.ibeta(1,0.2)

~makeharm = { arg freq; (128 - freq.cpsmidi)/20 }; ~makeharm.(88)
~makeharm = { arg freq; Array.series(20,freq.cpsmidi,(128 - freq.cpsmidi)/20) }; ~makeharm.(88)
20000.cpsmidi
(1..20).ratiomidi

(2000.collect { (1..20).wchoose(( (1..20)**(1/2) ).normalizeSum) }).plotHisto
(
~makeharm = { arg freq; 
	var weights = ( (1..20)**(1/freq.cpsmidi.midiratio.debug("f")) ).normalizeSum.debug("h");
	(2000.collect { (1..20).wchoose(weights) }).plotHisto;
}
)
(
~makeharm = { arg freq; 
	var weights = ( (1..20)/freq.cpsmidi.midiratio.debug("f") ).normalizeSum.debug("h");
	(2000.collect { (1..20).wchoose(weights) }).plotHisto;
}
)
(
~makeharm = { arg freq; 
	var weights = ( (1..20)**(1/freq.debug("f")) ).normalizeSum.debug("h");
	(2000.collect { (1..20).wchoose(weights) }).plotHisto;
}
)
~makeharm.(88)
~makeharm.(2088)
2088.cpsmidi.midiratio
(1..20)**(1/2)
(1..20).normalizeSum
(1..20).size
(
~makeharm = { arg freq; 
	var xfade = { arg i,a,b; b*i + ( a*(1-i) ) };
	var cur = freq.explin(60,10000, 0, 1);
	var weights = xfade.(cur.debug("c"), 1!20, (1..20));
	weights.debug("w");
	weights = weights.reverse.normalizeSum;
	(2000.collect { (1..20).wchoose(weights) }).plotHisto;
}
)


(
var checkCall, plotSpecs;
// make sure z isn't a negative integer
checkCall = { |selector, z|
    if ((z <= 0) nand: { (z % 1) == 0 }) { z.perform(selector) }
};

plotSpecs = [
    [   { |z| checkCall.(\tgamma, z) },
        (-4, -3.95 .. 6),
        "tgamma(z)\n\"True\" gamma function",
        -125, 125
    ],
    [   { |dz| checkCall.(\tgamma1pm1, dz) },
        (-4, -3.95 .. 6),
        "tgamma1pm1(dz)\ngamma(dz + 1) - 1",
        -125, 125
    ],
    [   { |z| checkCall.(\lgamma, z) },
        (-4, -3.95 .. 10),
        "lgamma(z)\nLog gamma",
        -2.5, 12.5
    ],
    [   { |z| checkCall.(\digamma, z) },
        (-3, -2.95 .. 10),
        "digamma(z)\nDigamma",
        -2.5, 12.5
    ],
    [   { |z| checkCall.(\trigamma, z) },
        (-3.99, -3.94 .. 10),
        "trigamma(z)\nTrigamma",
        0, 30
    ],
    [   // make sure z isn't a negative integer
        { |n, z| if ( z <= 0 nand: { (z % 1) == 0 }) { polygamma(n, z) } },
        [[2,3], (-6, -5.95 .. 5)],
        "polygamma(z)\nPolygamma\nn=",
        -50, 400
    ]
];

~layOutPlots.( plotSpecs.collect{ |data| ~multiPlot.(*data) }, "Gamma Functions", 2 );
)

(
var genCol, getPlotLay, multiPlot, layOutPlots, plotSpecs;

// generate colors for each plot
genCol = { |num, offset=(rrand(0,1.0)), range=(rrand(0.15,1.3))|
    num.collect { |i|
        Color.hsv(((i/(max(num,1.0001)-1)) * range + offset).wrap(0,1), 0.6, 1, 1)
    }
};
// generate a vertical layout for the plot and its text
getPlotLay = { |plot, text|
    VLayout(plot, StaticText().string_(text).maxHeight_(50).align_(\center), 10)
};

~multiPlot = { |func, data, txt, min, max|
    var res, params, samps, clumped, pltr;
    var gridcol = Color.gray.alpha_(0.2);

    if(data.shape.size == 1) {
        samps = data;
        clumped = data.asList.flop;
    }{
        #params, samps = data;
        if (params.size > 6) {
            txt = txt ++ format("( % .. % )", params.first, params.last);
        } {
            txt = txt ++ params.asString;
        };
        clumped = params.collect{ |param, i|
            samps.collect([param, _, i])
        }
    };

    res = clumped.collect({ |bundle, i|
        bundle.collect(func.applyTo(*_)).select(_.notNil)
    });

    pltr = res.plot( txt, minval: min, maxval: max)
    .superpose_(true)
    .domainSpecs_([samps.minItem, samps.maxItem].asSpec)
    .plotColor_(
        genCol.(params !? params.size ?? 1, rrand(0,1.0))
    )
    ;

    pltr.plots[0]
    .gridColorX_(gridcol)
    .gridColorY_(gridcol)
    ;

    pltr
};

~layOutPlots = { |plotters, title="", numCols|
    var cols, hl, plotlay, colbut, plots, wscl;
    var vl = VLayout();
    var sb = Window.screenBounds;

    cols = numCols ?? { plotters.size.sqrt.ceil.asInteger };
    wscl = cols.linlin(1, 4, 0.5, 0.9);
    w = Window(title,
        Rect().width_(sb.width*wscl).height_(sb.height).center_(sb.center)
    ).view.layout_(vl).front;

    colbut = Button().states_([["Light Plots"], ["Dark Plots"]]).maxSize_(Size(80,15));
    vl.add(HLayout(nil, colbut));

    plotters.do { |pltr, i|
        var plot = pltr.parent.view.children[0];
        if(i % cols == 0) {
            vl.add(hl = HLayout())
        };
        plotlay = getPlotLay.(plot, pltr.name.asString);
        hl.add(plotlay);
        pltr.parent.close;
    };

    if((plotters.size) % cols > 0) {
        ((cols-(plotters.size)%cols)).do{hl.add(StaticText().string_(""))}
    };

    colbut.action_({ |but|
        var switch = but.value.asBoolean;
        plotters.do{ |pltr|
            pltr.plots[0]
            .backgroundColor_(
                switch.if({Color.white.alpha_(1)}, {Color(*0.1.dup(3)).alpha_(0.95)})
            )
            .fontColor_(
                switch.if({Color.gray},{Color.red});
            );
        };
        w.refresh;
    });
    colbut.value_(0).doAction; // start with dark plots
};
)

(
var plotSpecs = [
    [   \gammaP,
        [ (0.1, 0.3 .. 8), (0.01, 0.05 .. 20) ],
        "gammaP(a, z)\nLower incomplete gamma function (normalized)\na=",
    ],
    [   \gammaQ,
        [ (0.1, 0.3 .. 8), (0.01, 0.05 .. 20) ],
        "gammaQ(a, z)\nUpper incomplete gamma function (normalized)\na=",
    ],
    [   \tgammaLower,
        [ (0.1, 0.3 .. 8), (0.01, 0.05 .. 6) ],
        "tgammaLower(a, z)\nLower incomplete gamma function (non-normalized)\na=",
        0, 3
    ],
    [   \tgammaUpper,
        [ (0.1, 0.3 .. 8), (0.01, 0.05 .. 6) ],
        "tgammaUpper(a, z)\nUpper incomplete gamma function (non-normalized)\na=",
        0, 3
    ],
    [   { |delta, z| if(z.neg != delta) { tgammaDeltaRatio(z, delta) } },
        [ (-0.5, -0.45  .. 1), (0.0001, 0.1 .. 40)],
        "tgammaDeltaRatio(z, delta)\nGamma Delta Ratio\ndelta=",
        0, 7
    ]
];

~layOutPlots.( plotSpecs.collect { |data| ~multiPlot.(*data) }, "Gamma Functions (cont'd)", 2 );
)

(
var as = [9,7,5,2,1];
var bs = [1,2,5,7,9];
var xs = (0, 0.005 .. 1);
var plotSpecs = [
    [   { |a, b| log(beta(a, b)) }, // NOTE: using log for plot as in boost doc
        [[0.5, 1.0, 5.0, 10.0], (0.001, 0.005 .. 5)],
        "log(beta(a, b))\nBeta function\nas=",
        -10, 10
    ],
    [   { |a, x, i| ibetaDerivative(a, bs[i], x) },
        [as, xs],
        "ibetaDerivative(a, b, x)\nDerivative of the Incomplete Beta function (norm)\nbs=[1,2,5,7,9]  as=",
        0, 6
    ],
    [   { |a, x, i| ibeta(a, bs[i], x) },
        [as, xs],
        "ibeta(a, b, x)\nIncomplete Beta function (norm)\nbs=[1,2,5,7,9]  as=",
        0, 1
    ],
    [   { |a, x, i| ibetaC(a, bs[i], x) },
        [as, xs],
        "ibetaC(a, b, x)\nComplement of Incomplete Beta function (norm)\nbs=[1,2,5,7,9]  as=",
        0, 1
    ],
    [   { |a, x, i| betaFull(a, bs[i], x) },
        [as, xs],
        "betaFull(a, b, x)\nIncomplete Beta function (non-norm)\nbs=[1,2,5,7,9]  as=",
        0, 0.125
    ],
    [   { |a, x, i| betaFullC(a, bs[i], x) },
        [as, xs],
        "betaFullC(a, b, x)\nComplement of the Incomplete Beta function (non-norm)\nbs=[1,2,5,7,9]  as=",
        0, 0.125
    ]
];

~layOutPlots.( plotSpecs.collect{ |data| ~multiPlot.(*data) }, "Beta Functions, Incomplete and Derivative", 2);
)

beta(0.1,0.2)




(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fenv;
	sig = WhiteNoise.ar;
	sig = LFSaw.ar(3340);
	fenv = EnvGen.kr(Env([7000,60,10],[0.01,0.8]), 1);
	sig = RLPF.ar(sig, fenv, \rq.kr(0.5)) * 1;
	sig = HPF.ar(sig, 30);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \zed,
			\sustain, 0.1,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\additive13, {
    arg out=0;
    var partialAmps, ratios, pitch, partialNum = 320, amp = 0.2, sigArray, freqsArray, amps, levels;

    partialAmps=\partialamps.kr(0.5!320, 1/30, fixedLag: true);
    pitch=\pitch.kr(36!13, 1/30, fixedLag: true);
    levels=\levels.kr(1!13, 1/30, fixedLag: true);
    ratios=\ratios.kr(Array.fill(partialNum, { |j| (j + 1) }), 1/30, fixedLag: true);

    sigArray = Array.fill(pitch.size, { |i|

        var baseFreq = pitch[i].midicps;
        freqsArray = Array.fill(partialNum, { |j| baseFreq * ratios[j] });
        amps = partialAmps[0 .. (partialNum - 1)];

        Mix(SinOsc.ar(freqsArray, 0, amps)) * amp
    });

    Out.ar(out, sigArray*levels * 0.01)
}).add;
)

Synth(\additive13);

(
SynthDef(\additive13, {
    arg out=0;
    var partialAmps, ratios, pitch, partialNum = 320, amp = 0.2, sigArray, freqsArray, amps, levels;
	var baseFreq;

    partialAmps=\partialamps.kr(0.5!320, 1/30, fixedLag: true);
    pitch=\pitch.kr(36, 1/30, fixedLag: true);
    levels=\levels.kr(1, 1/30, fixedLag: true);
    ratios=\ratios.kr(Array.fill(partialNum, { |j| (j + 1) }), 1/30, fixedLag: true);

	baseFreq = pitch.midicps;
	freqsArray = Array.fill(partialNum, { |j| baseFreq * ratios[j] });
	amps = partialAmps[0 .. (partialNum - 1)];

	sigArray = Mix(SinOsc.ar(freqsArray, 0, amps)) * amp;

    Out.ar(out, sigArray*levels * 0.1)
}).add;
)

Synth(\additive13);

(
SynthDef(\additive13, {
    arg out=0;
    var partialAmps, ratios, pitch, partialNum = 320, amp = 0.2, sigArray, freqsArray, amps, levels;

    partialAmps=\partialamps.kr(0.5!320, 1/30, fixedLag: true);
    pitch=\pitch.kr(36!2, 1/30, fixedLag: true);
    levels=\levels.kr(1!1, 1/30, fixedLag: true);
    ratios=\ratios.kr(Array.fill(partialNum, { |j| (j + 1) }), 1/30, fixedLag: true);

	pitch.debug("p");
    sigArray = Array.fill(pitch.size.debug("pitch"), { |i|

        var baseFreq = pitch[i].midicps;
        freqsArray = Array.fill(partialNum, { |j| baseFreq * ratios[j] });
        amps = partialAmps[0 .. (partialNum - 1)];

        Mix(SinOsc.ar(freqsArray, 0, amps)).debug("mix") * amp
    });
	sigArray.debug("sa");

    Out.ar(out, sigArray*levels * 0.01)
}).add;
)

Array.fill(1, { arg x; x.debug("bla") })

/////////

(
    Pdef(\a
        Pbind(
        \instrument, \whateverA
        \param1a, 0.5,
        \param2a, 2,
        \param3a, 3,
        )
    );

    Pdef(\b
        Pbind(
        \instrument, \whateverB
        \param1B, 0.5,
        \param2B, 2,
        \param3B, 4,
        )
    );

    Pdef(\p1
        Pbind(
            \dur, 1,
            \choose, Prand([1, 2], inf)
        )
    );
)


~a = Pswitch1( Prand([1, 2]), [Pdef(\a), Pdef(\b)] )
~s = ~a.asStream
~s.next(())

(\bla: \blo)


b = c.par(                // now start a pattern in spawner
    Pbind(*[degree: Pseq((0..6) ++ (7..1), inf), dur: 0.2])
);


// example 5: Spawner can be used directly in the manner of Pspawner.
// This allows external code to access to the spawner whether or not it has run
(
c = Spawner({ |sp|
    100.do{ sp.wait(1) }
});
b = c.par(                // now start a pattern in spawner
    Pbind(*[degree: Pseq((0..6) ++ (7..1), inf), dur: 0.2])
);
c.play;                    // in this case, c is always valid
)
c.suspend(b)                // we can suspend and resume the stream
c.par(b)
c.suspend(b)
(
b = c.par(                // or just start up a new pattern
    Pbind(*[degree: Pseq((0..6) ++ (7..1), inf), dur: 0.2])
);
)

c.par(Pbindef(\bla, Pbind(\note, Pseq((0..5)*2,inf))))
c.par(Pbind(\note, Pseq((0..5)*2,inf)))

c = Spawner({})
Pbindef(\xxx, \note, 10)
c.par(Pdef(\xxx))
c.play; 
Pbindef(\xxx, \note, 4)
c.par(Pbind(\note,4))
c.par(Pbind(\note,5))
(
Pdef(\xxxx, 

	Pbind(\note, 7)
).play;
);

(
SynthDef(\zed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

p = ProxySpace();
p.push

(
~sig = Pbind(
	\instrument, \zed,
	\rel,0.5,
	\dist, 0.5,
	\ringTime, 10,
	\amp, 0.5,
	\dur, Pseq([
		Pseq([1/2],6),
		Pseq([1/8],8)
	],inf)
	
	
);
)

~sig.play; // This works fine
~sig.clock = t
~sig.clock
~sig.stop;
~sig.end;
~sig.clear

t = TempoClock.default
t = TempoClock().tempo_(2)
t.tempo = 1/2
t.tempo = 2
p.clock = t

~sig.play(t); // This works without sound
~sig.stop;

Pdef(\arze, Pdef(\modpat) <> Pdef(\ddd))
Pdef(\ddd, Pbind())
Pdef(\arze).play
Pdef(\modpat, Pbind())
Pbindef(\modpat, \freq, 1000)
Pbindef(\modpat, \freq, nil)

NoteTimeline

c = Array2D.new(rows: 4, cols: 2)
c.rowsDo(_.postln)

//this will take a second
//make 100 different buffers
(
    {
        ~bufs = List.newClear;
        100.do{|i|
            var env=Env([0]++ Array.rand(10,-1.0,1.0).normalize(-1,1)++[0],Array.rand(11,0.01,1),Array.rand(11,-4.0,4.0));
            var wt=env.discretize(2.pow(12)).asWavetable;
            i.postln;
            ~bufs.add(Buffer.loadCollection(s, wt));
            s.sync;
        };
        "I'm done".postln;
    }.fork
)

//make the synth
(
a = {|buf|
    var left = Mix(Osc.ar(buf, 200*[0.125, 0.25, 0.5, 2, 3/2, 4/3, 5/4, 6/5, 7/6, 8/7, 9/8, 11/10], 0, 0.04));
    var right = Mix(Osc.ar(buf, 201*[0.125, 0.25, 0.5, 2, 3/2, 4/3, 5/4, 6/5, 7/6, 8/7, 9/8, 11/10], 0, 0.04));
    Out.ar(0, [left, right])
}.play(s, args:[\buf, ~bufs[0]]);
)

//change the buffer every second
(
Routine({
	inf.do{
		a.set(\buf, ~bufs.choose);
		1.wait;
	}
}).play

)

(
a = {|buf|
    var left = Mix(Osc.ar(buf, 200, 0, 0.04));
    var right = Mix(Osc.ar(buf, 201, 0, 0.04));
    Out.ar(0, [left, right])
}.play(s, args:[\buf, ~bufs[0]]);
)

SynthDef(\bla)
SynthDescLib()


\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),

Pbind(\callback, { ~id.postln }).play
Pbind(\callback, { 1/8.wait; Synth.basicNew(\default, s, ~id).set(200); }).play
Pbind(\callback, { r{1/4.wait; Synth.basicNew(\default, s, ~id).set(800);}.play }).play
Pbind(\instrument, \saw, \callback, { "a".postln; Task{( 1/8 ).wait;"b".postln; (\type: \set, \id: ~id, \freq: 800).postln.play;}.play }).play
Pbind(\callback, { Task({ ( 1/8 ).wait; (\type: \set, \id: ~id, \freq: 800).play; }).play; }).play
Pbind(\callback, { ( 1/8 ).wait; (\type: \set, \id: ~id, \freq: 800).play; }).play
(
Pbind(
	\callback, {
		{
			( 1/8 ).wait; 
			(\type: \set, \id: ~id, \freq: 800).play;
		}.fork
	}
).play
)

defer

(
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200,  doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = LFSaw.ar(freq * [1.01,1,0.99]);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan)/2;
	Out.ar(out, sig);
}).add;
);

~s = Synth(\saw)
~s.nodeID
~ss = Synth.basicNew(\saw, s, ~s.nodeID)
~ss.set(\freq, 200)
~s.set(\freq, 400)
(\type: \set, \id: ~s.nodeID, \freq: 800).play

Buffer.read(s, "~/tmp/attrition.wav".standardizePath)


/////////
a = (-1000,-999.99..1000).collect{|item| item.cylBesselJ(1000)};
b = Buffer.loadCollection(s, a);
a.size

{(PlayBuf.ar(1,b, 0.2, 1, 0)*5).softclip.dup*Env.perc(0.001, 3).kr(2)}.play;


{ true.postln } || {false.postln}
(Constraint({ true.postln }) or: Constraint({false.postln})).value
