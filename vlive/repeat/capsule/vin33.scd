/// generate a random fm network synth
~t = 135/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\corniaud, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var randfm;
	freq = freq * [1,2**(4/12),1.01,2**(7/12)];
	randfm = { arg ifreq, in=0, amt=1;
		var fr = ifreq * ( in * amt + 1 );
		[
			{ SinOsc.ar(fr) },
			{ LFSaw.ar(fr) },
			{ LFPulse.ar(fr) },
			{ LFCub.ar(fr) },
		].choose.value * EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,1)), gate, doneAction:0);
	};
	sig = DC.ar(0);
	8.do {
		sig = randfm.(freq, sig, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig = sig * [1,0.4,0.4,0.4];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,1.7)), gate, doneAction:2);
	pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \corniaud,
			\fmamt, ~pmodenv.(Pseq([0,1,0,4],inf), 4),
			\note, Pseq([
				[0,3,7],
			],inf)+Pseq([0,3],inf).stutter(1),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

ProtoDef(\piano).startControl(Pdef(\melo, Pbind(\instrument, \corniaud)))
MKtl.find(\midi); // when was not connected

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \corniaud,
			\fmamt, ~pmodenv.(Pseq([0,1,0,4],inf), 1/4),
			//\fmant, Pseq([0.1,0.2],inf),
			\note, Pseq([
				[0,3,7],
			],inf)+Pseq([0,3],inf).stutter(1),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);
(
SynthDef(\corniaudouble, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var randfm;
	freq = freq * [1,2**(4/12),1.01,2**(7/12)];
	randfm = { arg ifreq, in=0, amt=1;
		var fr = ifreq * ( in * amt + 1 );
		[
			{ SinOsc.ar(fr) },
			{ LFSaw.ar(fr) },
			{ LFPulse.ar(fr) },
			{ LFCub.ar(fr) },
		].choose.value * EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)), gate, doneAction:0);
	};
	sig1 = DC.ar(0);
	8.do {
		sig1 = randfm.(freq, sig1, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig2 = DC.ar(0);
	8.do {
		sig2 = randfm.(freq, sig2, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig = [sig1, sig2].mean;
	sig = sig * [1,0.4,0.4,0.4];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.7)), gate, doneAction:2);
	pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \corniaudouble,
			\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\note, Pseq([
				[0,3,7],
			],inf)+Pseq([0,3],inf).stutter(1),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\corniaudouble2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// one fm per speaker
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var randfm;
	//freq = freq * [1,2**(4/12),1.01,2**(7/12)];
	randfm = { arg ifreq, in=0, amt=1;
		var fr = ifreq * ( in * amt + 1 );
		[
			{ SinOsc.ar(fr) },
			{ LFSaw.ar(fr) },
			{ LFPulse.ar(fr) },
			{ LFCub.ar(fr) },
		].choose.value * EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)), gate, doneAction:0);
	};
	sig1 = DC.ar(0);
	8.do {
		sig1 = randfm.(freq, sig1, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig2 = DC.ar(0);
	8.do {
		sig2 = randfm.(freq, sig2, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig = [sig1, sig2];
	sig = sig * [1,0.4,0.4,0.4];
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.7)), gate, doneAction:2);
	pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \corniaudouble2,
			\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\note, Pseq([
				[0,3,7],
			],inf)+Pseq([0,3],inf).stutter(1),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\corniaudouble3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// stereo with delta freq
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var sig;
	var randfm;
	freq = freq * [1,2**(4/12),2**(7/12),1/2,2] *.t [1,1.001];
	( [1,2**(4/12),2**(7/12),1/2,2] *.t [1,1.01] ).debug("fre");
	randfm = { arg ifreq, in=0, amt=1;
		var fr = ifreq * ( in * amt + 1 );
		[
			{ SinOsc.ar(fr) },
			{ LFSaw.ar(fr) },
			{ LFPulse.ar(fr) },
			{ LFCub.ar(fr) },
		].choose.value * EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)), gate, doneAction:0);
	};
	sig1 = DC.ar(0);
	8.do {
		sig1 = randfm.(freq, sig1, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig2 = DC.ar(0);
	8.do {
		sig2 = randfm.(freq, sig2, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig = [sig1, sig2].mean;
	sig = sig * [1,0.4,0.4,0.4,0.4];
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.7)), gate, doneAction:2);
	//pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
	sig = Pan2.ar(sig, [-1,1], amp).flop.mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \corniaudouble3,
			\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\note, Pseq([
				[0,3,7],
			],inf)+Pseq([0,3,4,7],inf).stutter(1),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\corniaudouble4, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// stereo with delta fm
	// add filters
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var siginit;
	var sig;
	var randfm;
	var ofreq;
	ofreq = freq;
	freq = freq * [1,2**(4/12),2**(7/12),1/2,2];
	( [1,2**(4/12),2**(7/12),1/2,2] *.t [1,1.01] ).debug("fre");
	randfm = { arg ifreq, in=0, amt=1;
		var fr = ifreq * ( in * amt + 1 );
		var filterenv = EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)), gate, doneAction:0);
		filterenv = [
			( 1-filterenv ) + 1,
			( filterenv ) + 1,
		].choose;
		[
			{ SinOsc.ar(fr) },
			{ LFSaw.ar(fr) },
			{ LFPulse.ar(fr) },
			{ LFCub.ar(fr) },
			{ RLPF.ar(LFSaw.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
			{ RLPF.ar(LFPulse.ar(fr), rrand(0.7,3) * ofreq * (filterenv), rrand(0.1,0.8)); },
			{ RLPF.ar(LFCub.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
		].choose.value * EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)), gate, doneAction:0);
	};
	siginit = [
		randfm.(freq, DC.ar(0),rrand(0.0,1) * \fmamt.kr(1)),
		randfm.(freq, DC.ar(0),rrand(0.0,1) * \fmamt.kr(1)),
	].flop;
	siginit.debug("sigini");
	sig1 = siginit;
	8.do {
		sig1 = randfm.(freq, sig1, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig2 = siginit;
	8.do {
		sig2 = randfm.(freq, sig2, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig1.debug("sig1");
	sig = [sig1, sig2].mean;
	sig = sig * [1,0.4,0.4,0.4,0.4];
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.7)), gate, doneAction:2);
	//pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
	sig = Pan2.ar(sig, [-1,1], amp).flop.mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \corniaudouble4,
			\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\note, Pseq([
				[0,3,7],
				[0,4,7],
			],inf)+Pseq([0,3,4,7],inf).stutter(1),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\corniaudouble5, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// stereo with delta fm that is 4 level deep, and only one fm chain
	// add filters
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var siginit;
	var sig;
	var randfm;
	var ofreq;
	ofreq = freq;
	freq = freq * [1,2**(4/12),2**(7/12),1/2,2];
	( [1,2**(4/12),2**(7/12),1/2,2] *.t [1,1.01] ).debug("fre");
	randfm = { arg ifreq, in=0, amt=1;
		var fr = ifreq * ( in * amt + 1 );
		var filterenv = EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)), gate, doneAction:0);
		filterenv = [
			( 1-filterenv ) + 1,
			( filterenv ) + 1,
		].choose;
		[
			{ SinOsc.ar(fr) },
			{ LFSaw.ar(fr) },
			{ LFPulse.ar(fr) },
			{ LFCub.ar(fr) },
			{ RLPF.ar(LFSaw.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
			{ RLPF.ar(LFPulse.ar(fr), rrand(0.7,3) * ofreq * (filterenv), rrand(0.1,0.8)); },
			{ RLPF.ar(LFCub.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
		].choose.value * EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2)), gate, doneAction:0);
	};
	siginit = 2.collect( { arg idx;
		var isig = DC.ar(0);
		4.do {
			isig = randfm.(freq, isig, rrand(0.0,1) * \fmamt.kr(1));
		};
	});
	siginit.debug("sigini");
	sig1 = siginit;
	8.do {
		sig1 = randfm.(freq, sig1, rrand(0.0,1) * \fmamt.kr(1));
	};
	sig1.debug("sig1");
	sig = sig1;
	sig = sig * [1,0.4,0.4,0.4,0.4];
	sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.7)), gate, doneAction:2);
	//pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
	sig = Pan2.ar(sig, [-1,1], amp).flop.mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \corniaudouble5,
			\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\note, Pseq([
				[0,3,7],
				[0,4,7],
			],inf)+Pseq([0,3,4,7],inf).stutter(1),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
SynthDef(\corniaudouble6, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	// stereo with delta fm that is 4 level deep, and only one fm chain
	// add filters
	// now harmonic are chosen inside the fm loop
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var siginit;
	var sig;
	var randfm;
	var ofreq;
	ofreq = freq;
	//freq = freq * [1,2**(4/12),2**(7/12),1/2,2];
	randfm = { arg ifreq, in=0, amt=1;
		var fr = ifreq * [1,2**(4/12),2**(7/12),1/2,2].choose * ( in * amt + 1 );
		var filterenv = EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2) * \rel.kr(1)), gate, doneAction:0);
		filterenv = [
			( 1-filterenv ) + 1,
			( filterenv ) + 1,
		].choose;
		[
			{ SinOsc.ar(fr) },
			{ LFSaw.ar(fr) },
			{ LFPulse.ar(fr) },
			{ LFCub.ar(fr) },
			{ RLPF.ar(LFSaw.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
			{ RLPF.ar(LFPulse.ar(fr), rrand(0.7,3) * ofreq * (filterenv), rrand(0.1,0.8)); },
			{ RLPF.ar(LFCub.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
		].choose.value * EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2) * \rel.kr(1)), gate, doneAction:0);
	};
	siginit = 2.collect( { arg idx;
		var isig = DC.ar(0);
		4.do {
			isig = randfm.(freq, isig, rrand(0.0,1) * \fmamt.kr(1));
		};
	});
	siginit.debug("sigini");
	sig = 4.collect({
		var isig = siginit;
		4.do {
			isig = randfm.(freq, isig, rrand(0.0,1) * \fmamt.kr(1));
		};
		isig;
	}).mean;
	//sig = sig * [1,0.4,0.4,0.4,0.4];
	//sig = sig.mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.7)), gate, doneAction:2);
	//pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
	sig = Pan2.ar(sig, [-1,1], amp).flop.mean;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \corniaudouble6,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.001,1),
			\note, Pseq([
				[0,3,7],
				[0,4,7],
			],inf)+Pseq([0,3,4,7],inf).stutter(1),
			\rel, 4,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

////////////////////////////////////

(
	Builder(\fmgen, { arg name, seed, harmtab, onlyfiltered=true;
		harmtab = harmtab ?? [1,2**(4/12),2**(7/12),1/2,2];
		seed = seed ? rrand(1,10000000);

		name.debug("name");
		SynthDef(\fmgen_ +++ name, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
			// stereo with delta fm that is 4 level deep, and only one fm chain
			// add filters
			// now harmonic are chosen inside the fm loop
			var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
			var siginit;
			var sig;
			var randfm;
			var ofreq;

			thisThread.randSeed = seed;
			seed.debug("seed");

			ofreq = freq;
			//freq = freq * [1,2**(4/12),2**(7/12),1/2,2];
			randfm = { arg ifreq, in=0, amt=1;
				var notfiltered, filtered, alloscs;
				var fr = ifreq * harmtab.choose * ( in * amt + 1 );
				var filterenv = EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2) * \rel.kr(1),rrand(0.1,1), rrand(-2,2.0)), gate, timeScale:timeScale, doneAction:0);
				filterenv = [
					( 1-filterenv ) + 1,
					( filterenv ) + 1,
				].choose;
				filterenv = filterenv * \lpfac.kr(1);
				notfiltered = [
					{ LFSaw.ar(fr) },
					{ LFPulse.ar(fr) },
					{ LFCub.ar(fr) },
				];
				filtered = [
					{ SinOsc.ar(fr) },
					{ RLPF.ar(LFSaw.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
					{ RLPF.ar(LFPulse.ar(fr), rrand(0.7,3) * ofreq * (filterenv), rrand(0.1,0.8)); },
					{ RLPF.ar(LFCub.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
				];
				alloscs = if(onlyfiltered != true) { notfiltered } { [] };
				alloscs = alloscs ++ filtered;
				alloscs.choose.value * EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2) * \rel.kr(1),rrand(0.1,1), rrand(-2,2.0)), gate, timeScale:timeScale, doneAction:0);
			};
			siginit = 2.collect( { arg idx;
				var isig = DC.ar(0);
				4.do {
					isig = randfm.(freq, isig, rrand(0.0,1) * \fmamt.kr(1));
				};
			});
			siginit.debug("sigini");
			sig = 4.collect({
				var isig = siginit;
				4.do {
					isig = randfm.(freq, isig, rrand(0.0,1) * \fmamt.kr(1));
				};
				isig;
			});
			sig = sig * [\osc1gain.kr(1), \osc2gain.kr(1), \osc3gain.kr(1), \osc4gain.kr(1)];
			sig = sig.mean;
			//sig = sig * [1,0.4,0.4,0.4,0.4];
			//sig = sig.mean;
			sig.debug("sig");
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.7)), gate, doneAction:2);
			//pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
			sig = Pan2.ar(sig, [-1,1] * \panspread.kr(1) + pan, amp).flop.mean;
			sig.debug("sig");
			Out.ar(out, sig);
		}).add;
		SynthDesc(\fmgen_ +++ name).addHalo(\seed, seed);
	});
	Builder(\fmgen).set(\name, \bla, \seed, nil).build;
);
Builder(\fmgen).build;
Builder(\fmgen).set(\name, \oppress, \seed, 8412575);

Builder(\fmgen).set(\name, \bla, \seed, nil).build;


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmgen_bla,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.001,1).trace,
			\note, Pseq([
				[0,3,7],
				[0,4,7],
				[0,4,8],
			],inf)+Pseq([0,3,4,7],inf).stutter(1),
			\timeScale, rrand(0.3,3),
			\rel, 4,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

	(
	20.do { arg idx;
		Builder(\fmgen).set(\name, \rand+++idx, \seed, nil).build;
	};
	)
	Pdef(\part).clear;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Ppar(4.collect({ arg idx;
	   
		Pbind(
			\instrument, Pfunc({ \fmgen_rand +++ rrand(0,19) }),
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.001,1/2,inf).trace,
			\note, Pseq([
				[0,3,7,12],
				[0,4,7,12],
				[-1,4,7,12],
			].collect(_[idx]),inf)+Pseq([0,3,4,7],inf).stutter(3),
			\timeScale, rrand(0.3,3),
			\rel, 1,
			\legato, 1.0,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
			],inf),
			\dur, 4,
			\amp, 0.1,
			\octave, 4,	
			\out, BusDef(\sendbus1, \audio),
		);
		}))
		
	])
)).play;
);

(
~master = {
	ProtoDef(\simpleMixer).play;
	Ndef(\fx1).play;
};
~master.();
)

	Builder(\fmgen).set(\name, \bla, \seed, nil, \harmtab, [1,2,1/2] *.x [1,1.01,1.001]).build;
	Builder(\fmgen).set(\name, \bla0, \seed, nil, \harmtab, [1,2,1/2] *.x [1,1.01,1.001]).build;
	Builder(\fmgen).set(\name, \bla1, \seed, nil, \harmtab, [1,2,1/2] *.x [1,1.01,1.001]).build;
	Builder(\fmgen).set(\name, \bla2, \seed, nil, \harmtab, [1,2,1/2, 5/4, 3/4] *.x [1,1.01,1.001]).build;
	Builder(\fmgen).set(\name, \bla2, \seed, nil, \harmtab, [1,2,4] *.x [1,1.01,1.001]).build;
(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \fmgen_bla2,
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41).trace,
			\lpfac, 3,
			\note, Plazy({
				Pseq([
					[0,4,7],
					[0,4,8],
					[0,4,7-12],
					[0,4,7-12],
				].collect({ arg x;
					Pseq([ \r,\r, x.choose, x.choose ].scramble,1) + Prand([-12,0,12],inf)
				}),1)
			}).loop+Pseq([0,0,5,7],inf).stutter(2),
			\octave, 4,
			\timeScale, rrand(0.3,1),
			\rel, 1,
			\legato, 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/2,
			\amp, 0.4,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41).trace,
			\lpfac, 3,
			\note, Pseq([
				[0,4,7],
				[0,4,8],
				[0,4,7-12],
				[0,4,7-12],
			],inf)+Pseq([0,0,5,7],inf).stutter(1),
			\octave, 4,
			\timeScale, rrand(0.3,3),
			\rel, 4,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 2,
			\amp, 0.4,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\note, Pseq([
				4,0,5,5,
			],inf),
			\isRest, Plazy({ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
			].scramble,1)}).loop.coin.not,
			\panspread, Pseq([0,1],inf).stutter(8),
			\timeScale, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2/8,
			\amp, 0.5,
			\out, BusDef(\mixer1, \audio),
		),
		
	])
)).play;
);

(
	~chords = [
		[0,3,7],
		[0,3,7]+5,
		[0-2,4,7]+7,
		[0,3,7],
	];
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			\instrument, \fmgen_bla2,
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41).trace,
			\lpfac, 3,
			\note, Plazy({
				Pseq(~chords.collect({ arg x;
					Pseq([ \r,\r, \r, \r, x.choose, x.choose, x.choose, x.choose ].scramble,1) + Prand([-12,0,12],inf)
				}),1)
			}).loop,
			\octave, 5,
			\timeScale, Pwhite(0.3,1,inf),
			\rel, 1,
			\legato, 0.8,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\amp, 0.7,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41),
			\lpfac, 3,
			\note, Pseq(
				~chords
			,inf),
			\octave, 4,
			\timeScale, Pwhite(0.3,3),
			\rel, 4,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\dur, 2,
			\amp, 0.4,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\note, Pseq([
				4,0,5,5,
			],inf),
			\isRest, Plazy({ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
			].scramble,1)}).loop.coin.not,
			\panspread, Pseq([0,1],inf).stutter(8),
			\timeScale, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2/8,
			\amp, 0.5,
			\isRest, true,
		),
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1466].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					1,0,0,1, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					0,0,0,0, 0,1,0,0,
				],inf).coin.not,
				\hasGate, false,
				\dur, 1/16,
				\sustain, 0.1,
				\gain, 0.3/3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[228].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1568].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[334].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.31/3,
			),
		]),
		
	])
)).play;
);

(
	~chords = [
		[0,3,7],
		[0,3,7]+5,
		[0-2,4,7]+7,
		[0,3,7],
	];
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			\instrument, \fmgen_bla2,
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41).trace,
			\lpfac, 3,
			\note, Plazy({
				Pseq(~chords.collect({ arg x;
					Pseq([ \r,\r, \r, \r, x.choose, x.choose, x.choose, x.choose ].scramble,1) + Prand([-12,0,12],inf)
				}),1)
			}).loop,
			\octave, 5,
			\timeScale, Pwhite(0.3,1,inf),
			\rel, 1,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\amp, 0.7,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41),
			\lpfac, 3,
			\note, Pseq(
				~chords
			,inf),
			\octave, 4,
			\timeScale, Pwhite(0.3,3),
			\rel, 4,
			\legato, Pseq([0.7,0.1,0.3,0.2],inf),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 2,
			\amp, 0.4,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\note, Pseq([
				4,0,5,5,
			],inf),
			\isRest, Plazy({ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
			].scramble,1)}).loop.coin.not,
			\panspread, Pseq([0,1],inf).stutter(8),
			\timeScale, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2/8,
			\amp, 0.5,
			\isRest, true,
		),
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1466].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,0,1, 1,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,1,0,
					1,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\hasGate, false,
				\dur, 1/16,
				\sustain, 0.1,
				\gain, 0.3/3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[228].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1568].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[334].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\speed, Pseq([
					1,0.7,0.9,0.6;
				],inf),
				\dur, 1/8,
				\gain, 0.31/3,
			),
		]),
		
	])
)).play;
);

(
	~chords = [
		[0,3,7],
		[0,3,7]+5,
		[0-2,4,7]+7,
		[0,3,7],
	];
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			\instrument, \fmgen_bla2,
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41).trace,
			\lpfac, 3,
			\note, Plazy({
				Pseq(~chords.collect({ arg x;
					Pseq([ \r,\r, \r, \r, x.choose, x.choose, x.choose, x.choose ].scramble,1) + Prand([-12,0,12],inf)
				}),1)
			}).loop,
			\octave, 5,
			\timeScale, Pwhite(0.3,1,inf),
			\rel, 1,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/4,
			\amp, 0.7,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41),
			\lpfac, 3,
			\note, Pseq(
				~chords
			,inf),
			\octave, 4,
			\timeScale, Pwhite(0.3,3),
			\rel, 4,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 2,
			\amp, 0.4,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\note, Pseq([
				4,0,5,5,
			],inf),
			\isRest, Plazy({ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
			].scramble,1)}).loop.coin.not,
			\panspread, Pseq([0,1],inf).stutter(8),
			\timeScale, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2/8,
			\amp, 0.5,
			\isRest, true,
		),
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1466].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1).coin.not,
				\hasGate, false,
				\dur, 1/16,
				\sustain, 0.1,
				\gain, 0.3/3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[228].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1568].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[334].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\speed, Pseq([
					1,0.7,0.9,0.6;
				],inf),
				\dur, 1/8,
				\gain, 0.31/3,
			),
		]),
		
	])
)).play;
);

(
	~chords = [
		[0,3,7],
		[0,3,7]+5,
		[0-2,4,7]+7,
		[0,3,7],
	];
	~master.();
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			\instrument, \fmgen_bla2,
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41).trace,
			\lpfac, 3,
			\note, Plazy({
				Pseq(~chords.collect({ arg x;
					Pstep(Pseq([ x.choose, x.choose, x.choose, x.choose ].scramble,inf),2) + Prand([-12,0,12],inf)
				}),1)
			}).loop,
			\isRest, Plazy({
				var pat = [
					Pseq([
						1,1,1,1, 1,1,1,0,
						1,1,1,1, 1,1,1,0,
					].scramble,1),
					Pseq([
						1,1,1,1, 0,0,0,0,
						1,1,1,1, 0,0,0,0,
					].scramble,1),
					Pseq([
						1,1,1,1, 0,0,0,0,
						1,1,1,1, 0,0,0,0,
					].scramble,1),
				];
				Pseq([
					pat[0], pat[1], pat[0], pat[1],
				])
			}).loop.coin.not,
			\octave, 5,
			\timeScale, Pwhite(0.3,1,inf),
			\rel, 1,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, Pseg(Pseq([1/4,1/16,1/32],inf),16),
			\amp, 0.7,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\instrument, Pfunc({ \fmgen_bla +++ rrand(0,1) }),
			//\instrument, \default,
			//\fmamt, ~pmodenv.(Pseq([0,1,0,2],inf), 4),
			\fmamt, Pwhite(0.01,0.41),
			\lpfac, 3,
			\note, Pseq(
				~chords
			,inf),
			\octave, 4,
			\timeScale, Pwhite(0.3,3),
			\rel, 4,
			\legato, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\dur, 2,
			\amp, 0.4,
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \fmgen_bla,
			\note, Pseq([
				4,0,5,5,
			],inf),
			\isRest, Plazy({ Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				1,0,0,0, 0,0,0,0,
			].scramble,1)}).loop.coin.not,
			\panspread, Pseq([0,1],inf).stutter(8),
			\timeScale, 1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 2/8,
			\amp, 0.5,
			\isRest, true,
		),
		Pbind(\out, BusDef(\mixer3, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1466].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],1).coin.not,
				\hasGate, false,
				\dur, 1/16,
				\sustain, 0.1,
				\gain, 0.3/3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[228].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1568].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61/4,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[334].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
				\speed, Pseq([
					1,0.7,0.9,0.6;
				],inf),
				\dur, 1/8,
				\gain, 0.31/3,
			),
		]),
		
	])
)).play;
);

////////////////////////////////////////////////////////

(
	Builder(\fmgen2, { arg name, seed;

		name.debug("name");
		SynthDef(\fmgen2_ +++ name, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
			// stereo with delta fm that is 4 level deep, and only one fm chain
			// add filters
			// now harmonic are chosen inside the fm loop
			var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
			var siginit;
			var sig;
			var randfm;
			var ofreq;
			var makelevel;

			seed = seed ? rrand(1,10000000);
			thisThread.randSeed = seed;
			seed.debug("seed");

			ofreq = freq;
			//freq = freq * [1,2**(4/12),2**(7/12),1/2,2];
			randfm = { arg ifreq, in=0, amt=1;
				var fr = ifreq * [1,2**(4/12),2**(7/12),1/2,2].choose * ( in * amt + 1 );
				var filterenv = EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2) * \rel.kr(1),rrand(0.1,1), rrand(-2,2.0)), gate, timeScale:timeScale, doneAction:0);
				filterenv = filterenv * \lpfac.kr(1);
				filterenv = [
					( 1-filterenv ) + 1,
					( filterenv ) + 1,
				].choose;
				[
					{ SinOsc.ar(fr) },
					{ LFSaw.ar(fr) },
					{ LFPulse.ar(fr) },
					{ LFCub.ar(fr) },
					{ RLPF.ar(LFSaw.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
					{ RLPF.ar(LFPulse.ar(fr), rrand(0.7,3) * ofreq * (filterenv), rrand(0.1,0.8)); },
					{ RLPF.ar(LFCub.ar(fr), rrand(0.7,3) * ofreq * ( filterenv ), rrand(0.1,0.8)); },
				].choose.value * EnvGen.kr(Env.adsr(rrand(0.01,3),rrand(0.01,1),rrand(0.1,1),rrand(0.01,2) * \rel.kr(1),rrand(0.1,1), rrand(-2,2.0)), gate, timeScale:timeScale, doneAction:0);
			};


			// levels

			makelevel = {
				var inputs; outputs;
				//inputs = [freq, freq*2, freq/2];
				inputs = DC.ar(0)!3;
				5.do { arg level;
					var ins, outs;
					ins = inputs;
					ins.size.collect({
						randfm.(freq, ins.choose)
					})
					// TODO: comment rassembler deux branches une fois separées ???


				};

			};
			sig = makelevel.();



			siginit = 2.collect( { arg idx;
				var isig = DC.ar(0);
				4.do {
					isig = randfm.(freq, isig, rrand(0.0,1) * \fmamt.kr(1));
				};
			});
			siginit.debug("sigini");
			sig = 4.collect({
				var isig = siginit;
				4.do {
					isig = randfm.(freq, isig, rrand(0.0,1) * \fmamt.kr(1));
				};
				isig;
			}).mean;
			//sig = sig * [1,0.4,0.4,0.4,0.4];
			//sig = sig.mean;
			sig.debug("sig");
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.7)), gate, doneAction:2);
			//pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
			sig = Pan2.ar(sig, [-1,1], amp).flop.mean;
			sig.debug("sig");
			Out.ar(out, sig);
		}).add;
	});
	Builder(\fmgen).set(\name, \bla, \seed, nil).build;
);


/////////////////////////////////


Builder(\fmgen).set(\name, \piano, \seed, rrand(1,1000000));
SynthDesc(\fmgen_piano).getHalo(\seed)
// 3

(
	Pdef(\melo, 
		Pbind(
			\instrument, \fmgen_piano,
		)
	);
)
(
	Pbindef(\melo, 
			\instrument, \fmgen_piano,
	);
)

Pdef(\melo).addHalo(\instrument, \fmgen_piano)
	PlayerWrapper(Pdef(\melo)).edit

ProtoDef(\piano).startControl(Pdef(\melo))

Builder(\fmgen).set(\name, \cry, \seed, 352476); // good with reverb
Builder(\fmgen).set(\name, \flute, \seed, 823708); // good with reverb
Builder(\fmgen).set(\name, \beau, \seed, 239984); // good with reverb
Builder(\fmgen).set(\name, \beau2, \seed, 802890); // good with reverb
Builder(\fmgen).set(\name, \scie, \seed, 666243); // good with reverb
Builder(\fmgen).set(\name, \bois, \seed, 474727); // good with reverb
Builder(\fmgen).set(\name, \loup, \seed, 979144); // good with reverb
Builder(\fmgen).set(\name, \hesite, \seed, 545369); // good with reverb
Builder(\fmgen).set(\name, \clar, \seed, 540112); // good with reverb
(
Pdef(\zed, 
	Pbind(
		\instrument, \fmgen_cry,
		\degree, Pseq([0],inf),
		\dur, 4,
		\amp, 0.1,
	)
).play;
);


(
	Pdef(\part, Pdef(\chill, 
		Ppar([
			Pbind(
				\instrument, \basicbass,
				\note, Pstep(Pseq([
					7,6,
				],inf),2),
				\legato, Pseq([
					3,0,0,0, 0,0,0,1,
					3,0,0,0, 0,0,0,0,
					0,0,0,0, 3,0,0,1,
					3,0,0,0, 0,0,2,0,
					0,0,0,0, 0,0,2,0,
					2,0,0,2, 0,0,2,0,
					0,2,0,0, 2,0,0,2,
				]/2,inf),
				\octave, 3,
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \fmgen_hesite,
				\note, Pseq([
					7,6
				],inf),
				\timeScale, 1.62,
				\octave, 4,
				\dur, 2,
				\amp, 0.2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[1083].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 0.2,
				\dur, 1/16,
				\gain, 0.1/1.52,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[1086].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					Prand([
						0,0,0,1, 1,1,0,0,
						0,0,1,1, 0,0,1,1,
						0,0,0,1, 0,0,1,0,
						0,0,0,1, 0,0,0,1,
					].clump(8).collect(Pseq(_)))
				]/8,inf).coin.not,
				\sustain, 0.2,
				\dur, 1/16,
				\gain, 0.1/1.52,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[980].value,
				\isRest, Pseq([
					1,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.11/4 * Pseq([
					Prand([
						//Pseq([
						//1,Pwhite(0.7,1,2),
						//],1),
						//Pseq([
						//1,Pwhite(0.7,1,1),
						//],1),
						Pseq([
							Pwhite(0.7,1,2),1
						],1),
						Pseq([
							Pwhite(0.7,1,1),1
						],1),
					],1).stutter(2),
				],inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1090].value,
				\isRest, Pseq([
					Pseq({[
						1,0,0,1, 0,0,1,0,
						1,0,1,0, 0,1,0,0,
						1,0,0,1, 0,1,0,0,
					].clump(8).choose}.dup(8).collect(Pseq(_)))
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.11/2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1965].value,
				\bufnum, ~buflib.snare[2125].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,1/4,0,
					0,0,0,0, 0,0,0,1/4,
					1,0,0,0, 0,0,1/4,0,
					0,1/4,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.11 * Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					4,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				]/4,inf),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[1534].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1015].value,
				\bufnum, ~buflib.snare[2134].value,
				\isRest, Pseq([
					1,1/2,0,0, 0,1/2,1,1/2,
					0,0,0,1/2, 1,1/2,0,1/2,
				].rotate(12)/4,inf).coin.not,
				\dur, 1/16,
				\gain, 0.21,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				\bufnum, ~buflib.snare[87].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1676].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
				].rotate(14)/4,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/16,
				\gain, 0.11/1.2,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[2553].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,1,0,
					0,0,0,0, 1,0,0,0,
				].rotate(10)/4,inf).coin.not,
				\sustain, 0.1,
				\dur, 1/16,
				\gain, 0.11/1.2,
			),

		])
	)).play;
);

(
	// with mixer
	~master.();
	Pdef(\part, Pdef(\chill, 
		Ppar([
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \basicbass,
					\note, Pstep(Pseq([
						7,6,
					],inf),2),
					\legato, Pseq([
						3,0,0,0, 0,0,0,1,
						3,0,0,0, 0,0,0,0,
						0,0,0,0, 3,0,0,1,
						3,0,0,0, 0,0,2,0,
						0,0,0,0, 0,0,2,0,
						2,0,0,2, 0,0,2,0,
						0,2,0,0, 2,0,0,2,
					]/2,inf),
					\octave, 3,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1,
				),
				Pbind(
					\instrument, \fmgen_hesite,
					\note, Pseq([
						7,6
					],inf),
					\timeScale, 1.62,
					\octave, 4,
					\dur, 2,
					\amp, 0.2,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1010].value,
					\bufnum, ~buflib.kick[1083].value,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.2,
					\dur, 1/16,
					\gain, 0.1/1.52,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1010].value,
					\bufnum, ~buflib.kick[1086].value,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\isRest, Pseq([
						Prand([
							0,0,0,1, 1,1,0,0,
							0,0,1,1, 0,0,1,1,
							0,0,0,1, 0,0,1,0,
							0,0,0,1, 0,0,0,1,
						].clump(8).collect(Pseq(_)))
					]/8,inf).coin.not,
					\sustain, 0.2,
					\dur, 1/16,
					\gain, 0.1/1.52,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[1064].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[980].value,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.11/4 * Pseq([
						Prand([
							//Pseq([
							//1,Pwhite(0.7,1,2),
							//],1),
							//Pseq([
							//1,Pwhite(0.7,1,1),
							//],1),
							Pseq([
								Pwhite(0.7,1,2),1
							],1),
							Pseq([
								Pwhite(0.7,1,1),1
							],1),
						],1).stutter(2),
					],inf),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[1064].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[1090].value,
					\isRest, Pseq([
						Pseq({[
							1,0,0,1, 0,0,1,0,
							1,0,1,0, 0,1,0,0,
							1,0,0,1, 0,1,0,0,
						].clump(8).choose}.dup(8).collect(Pseq(_)))
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.11/2,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1719].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1965].value,
					\bufnum, ~buflib.snare[2125].value,
					\isRest, Pseq([
						0,0,0,0, 0,0,1/4,0,
						0,0,0,0, 0,0,0,1/4,
						1,0,0,0, 0,0,1/4,0,
						0,1/4,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.11 * Pseq([
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						4,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					]/4,inf),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1719].value,
					\bufnum, ~buflib.snare[1534].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1015].value,
					\bufnum, ~buflib.snare[2134].value,
					\isRest, Pseq([
						1,1/2,0,0, 0,1/2,1,1/2,
						0,0,0,1/2, 1,1/2,0,1/2,
					].rotate(12)/4,inf).coin.not,
					\dur, 1/16,
					\gain, 0.21,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1719].value,
					\bufnum, ~buflib.snare[87].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1676].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,0,0, 1,0,0,0,
					].rotate(14)/4,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/16,
					\gain, 0.11/1.2,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1719].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[2553].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,0,0, 1,0,0,0,
					].rotate(10)/4,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/16,
					\gain, 0.11/1.2,
				),
			]),

		])
	)).play;
);

(
	// with mixer
	// break note
	~master.();
	Pdef(\part, Pdef(\chill, 
		Ppar([
			Pbind(\out, BusDef(\mixer0, \audio)) <>
			Ppar([
				Pbind(
					\instrument, \basicbass,
					\note, Pstep(Pseq([
						7,6,
					],inf),2),
					\legato, Pseq([
						3,0,0,0, 0,0,0,1,
						3,0,0,0, 0,0,0,0,
						0,0,0,0, 3,0,0,1,
						3,0,0,0, 0,0,2,0,
						0,0,0,0, 0,0,2,0,
						2,0,0,2, 0,0,2,0,
						0,2,0,0, 2,0,0,2,
					]/2,inf),
					\octave, 3,
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\dur, 1/8,
					\amp, 0.1,
					\isRest, true,
				),
				Pbind(
					\instrument, \fmgen_hesite,
					\note, Pstep(Pseq([
						7,6
					],inf),2),
					\timeScale, 1.62,
					\legato, Pseq([
						7,0,0,0, 0,0,0,1,
						1,0,0,0, 3,0,0,1,
						1,0,0,0, 3,0,0,1,
						8,0,0,0, 0,0,0,0,
						0,0,1,0, 1,0,0,1,
						8,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,1,0,
					],inf),
					\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
					\octave, Prand([3,4],inf),
					\dur, 1/8,
					\amp, 0.2,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1010].value,
					\bufnum, ~buflib.kick[1083].value,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
					\sustain, 0.2,
					\dur, 1/16,
					\gain, 0.1/1.52,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.kick[1010].value,
					\bufnum, ~buflib.kick[1086].value,
					//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
					\isRest, Pseq([
						Prand([
							0,0,0,1, 1,1,0,0,
							0,0,1,1, 0,0,1,1,
							0,0,0,1, 0,0,1,0,
							0,0,0,1, 0,0,0,1,
						].clump(8).collect(Pseq(_)))
					]/8,inf).coin.not,
					\sustain, 0.2,
					\dur, 1/16,
					\gain, 0.1/1.52,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[1064].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[980].value,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.11/4 * Pseq([
						Prand([
							//Pseq([
							//1,Pwhite(0.7,1,2),
							//],1),
							//Pseq([
							//1,Pwhite(0.7,1,1),
							//],1),
							Pseq([
								Pwhite(0.7,1,2),1
							],1),
							Pseq([
								Pwhite(0.7,1,1),1
							],1),
						],1).stutter(2),
					],inf),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.hat[1064].value,
					//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
					\bufnum, ~buflib.hat[1090].value,
					\isRest, Pseq([
						Pseq({[
							1,0,0,1, 0,0,1,0,
							1,0,1,0, 0,1,0,0,
							1,0,0,1, 0,1,0,0,
						].clump(8).choose}.dup(8).collect(Pseq(_)))
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.11/2,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1719].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1965].value,
					\bufnum, ~buflib.snare[2125].value,
					\isRest, Pseq([
						0,0,0,0, 0,0,1/4,0,
						0,0,0,0, 0,0,0,1/4,
						1,0,0,0, 0,0,1/4,0,
						0,1/4,0,0, 0,0,0,0,
					],inf).coin.not,
					\dur, 1/16,
					\gain, 0.11 * Pseq([
						1,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
						4,1,1,1, 1,1,1,1,
						1,1,1,1, 1,1,1,1,
					]/4,inf),
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1719].value,
					\bufnum, ~buflib.snare[1534].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1015].value,
					\bufnum, ~buflib.snare[2134].value,
					\isRest, Pseq([
						1,1/2,0,0, 0,1/2,1,1/2,
						0,0,0,1/2, 1,1/2,0,1/2,
					].rotate(12)/4,inf).coin.not,
					\dur, 1/16,
					\gain, 0.21,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1719].value,
					\bufnum, ~buflib.snare[87].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[1676].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,0,0, 1,0,0,0,
					].rotate(14)/4,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/16,
					\gain, 0.11/1.2,
				),
				Pbind(
					\instrument, \playersec,
					\bufnum, ~buflib.snare[1719].value,
					//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
					\bufnum, ~buflib.snare[2553].value,
					\isRest, Pseq([
						1,0,0,0, 0,0,1,0,
						0,0,0,0, 1,0,0,0,
					].rotate(10)/4,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/16,
					\gain, 0.11/1.2,
				),
			]),

		])
	)).play;
);

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					0,0,1,0, 1,0,0,1,
				],inf).coin.not,
			\isRest, Pseq([
				Pseq({[
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,1,0,0,
				].clump(8).choose}.dup(8).collect(Pseq(_)))
			],inf).coin.not,
				\dur, 1/16,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
				],inf).coin.not,
			\isRest, Pseq([
				Pseq({[
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,1,0,0,
				].clump(8).choose}.dup(8).collect(Pseq(_)))
			],inf).coin.not,
				\dur, 1/16,
				\gain, 0.31,
			),
		]),

		
	])
)).play;
);

(
	// funk
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\speed, 1 * (~t/( 92.15/4/60 )),
			\dur, 1,
			\gain, 1,
			\out, BusDef(\mixer3, \audio),
		)
		
	])
)).play;
);

(
	// big kick
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[730].value,
			\isRest, Pseq([
				Pseq([
					Pseq([ 1,0,0,0, 1,0,0,0, ],7),
					1,0,0,0, 1,0,0,1, 
					Pseq([ 1,0,0,0, 1,0,0,0, ],7),
					1,0,0,1/2, 0,0,1/2,0, 
					Pseq([ 1,0,0,0, 1,0,0,0, ],7),
					1,0,0,1/2, 1,0,1/2,1/2, 
				],inf),
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 0,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\sustain, Pseq([0.12,0.05],inf),
			\dur, 1/16 * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.3,
			\out, BusDef(\mixer0, \audio),
		),
		
	])
)).play;
);

(
	// funk
Pdef(\part3, Pdef(\zed3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[730].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1019].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.31,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1424].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/16,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\legato, 0.7* Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,3,0,
				1,0,1,0, 6,0,0,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,3,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,5,0,0,
				1,0,1,0, 1,0,1,0,
			],inf) * Pseq([
				1,Pwhite(0.7,1,1)
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\gain, 0.31 * Pseq([
				1,Pwhite(0.7,1,1)
			],inf),
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs_full.flac'),
			\legato, 0.85,
			\legato, 1,
			\sampleTempo, ( 92.15/4/60 ),
			\loop, 1,
			\pos, Pseq([
				1, 1/8+2, 3/8, 7/8,
				2/8,1/8+1, 5/8, 6/8,
				1, 1/8, 1/8, 7/8,
				2/8,1/8, 1/8, 6/8,

				//Pseq((0..7)/8)+Pseq([0,0,11,0],inf),
				//Pseq((0..7)/8)+Pseq([0,0,12,7],inf),
				//Pseq((0..3)/4,inf)+7
				//8
				//Pseq((0..3)/4,inf) + Prand([0,4,8],inf)
			],inf) / Pkey(\sampleTempo),
			\pos, Pif(Pkey(\pos)>4, Pkey(\pos)-0.15,Pkey(\pos)),
			\speed, 1 * ~t / Pkey(\sampleTempo),
			\dur, 1/8,
			\gain, 1,
			//\out, BusDef(\mixer3, \audio),
		)
		
	])
)).play;
);

(
	// slow
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\speed, 1/2 * (~t/( 92.15/4/60 )),
			\dur, 2,
			\gain, 1,
			\out, BusDef(\mixer3, \audio),
		)
		
	])
)).play;
);
(
	// breakbeat
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\division, 2,
			\targetSpeed, 1,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8 + (1/2)),
				Pseq((0..7)/8),
				Pseq((0..7)/4),
				0, 1, 2, 3,
				Pseq((0..3)/4+3),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/Pkey(\targetSpeed)/8,
			\out, BusDef(\mixer3, \audio),
			\gain, 1,
		)
		
	])
)).play;
);

(
	// breakbeat
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([1,1,1,2],inf),
			\division, 2,
			\tempoRatio, ~t/( 92.20/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8 + (1/2)),
				Pseq((0..7)/8),
				Pseq((0..7)/4),
				0, 1, 2, 3,
				Pseq((0..3)/4+3),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\mixer3, \audio),
			\gain, 1,
		)
		
	])
)).play;
);

(
	// random variations
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1.3,
			\sampleTempo, 92.15/4/60,
			//\speed, Pseg(Pseq([1,2,1/2],inf),Pseq([1,4,2,1/2],inf)),
			//\speed, Ndef(\lfo1, { SinOsc.kr(1/8 * ( SinOsc.kr(0.3) * 1 + 1 )).range(1/2,2) }),

			\freeze, Pseq([
				0,0,0,0, 0,0,0,0,
				1,1,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,

				Prand(
					[
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,1,1,0,
					1,1,1,0, 0,0,0,0,
					0,0,0,0, 1,1,1,0,
					].clump(8).collect(Pseq(_))
				,1),
			],inf),
			\pos, Pseq([
						Prout({ arg ev;
							var str = Pseq([
								Pser((0..63)/16,8),
								Pser((0..63)+48/16,8),
								Pser((0..63)/16,8),
								Pser((0..63),4)+Pwhite(0,16,inf)+8/16,
								Pser((0..63),4)+12/16,
							],inf).asStream;
							var memory;
							inf.do {
								var val = str.next;
								if(ev[\freeze] == 1) {
									if(memory.isNil) {
										memory = val;
									};
									ev = memory.yield(ev);
								} {
									ev = val.yield(ev);
									memory = nil;
								}
							}
						})
			],inf) / Pkey(\sampleTempo),
			\dur, 1/16,
			\out, BusDef(\mixer3, \audio),
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part4, Pdef(\zed4, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([1/2,1],inf),
			\division, 2,
			\tempoRatio, ~t/( 92.15/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8+0),
				Pser((0..7),6)/8+1, Pser((0..7),2)+Pwhite(-4,4,inf)+6/8+1,
				Pseq((0..7)/8+2),
				Pser((0..7),6)/8+3, Pser((0..7),2)+Pwhite(-4,4,inf)+6/8+3,
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\out, BusDef(\mixer4, \audio),
			\gain, 1,
		),
		
	])
)).play;
);

(
Pdef(\part4, Pdef(\zed4, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([1/2,1],inf),
			\division, 2,
			\tempoRatio, ~t/( 92.15/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8+0),
				Pseq((0..7)/8+1),
				Pseq((0..7)/8+2),
				Pser((0..7),4)+Pwhite(-4,4,inf)/8+3, Pser((0..7)+4/8+3,4),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\out, BusDef(\mixer4, \audio),
			\gain, 1,
		),
		
	])
)).play;
);

(
	// breakbeat
Pdef(\part3, Pdef(\zed3, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([1/2,1],inf),
			\division, 2,
			\tempoRatio, ~t/( 92.15/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8+0),
				Pseq((0..7)/8+1),
				Pseq((0..7)/8+2),
				Pseq((0..7)/8+3),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/4,
			\out, BusDef(\mixer4, \audio),
			\gain, 1,
		),

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\targetSpeed, Pseq([1,1,1,2],inf),
			\division, 2,
			\tempoRatio, ~t/( 92.15/4/60 ),
			\speed, Pkey(\targetSpeed) * Pkey(\tempoRatio),
			\pos, Pseq([
				Pseq((0..7)/8 + (1/2)),
				Pseq((0..7)/8),
				Pseq((0..7)/4),
				0, 1, 2, 3,
				Pseq((0..3)/4+3),
			],inf) / ~t * Pkey(\tempoRatio),
			//\legato, Pseq([
				//3,0,0,1,
			//],inf),
			//\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\mixer3, \audio),
			\gain, 1,
		)
		
	])
)).play;
);

(
Pdef(\part2, Pdef(\zed2, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,1,
			],inf),
			\ctranspose, Pseq([0,1],inf).stutter(8),
			\octave, 6,
			\dur, 1/16,
			\amp, 0.1,
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \fmgen_rise,
			\freq, ~pmodenv.(Pseq([1,2.4]*400,1), 4).loop,
			\dur, 4,
			\timeScale, 2,
			\out, BusDef(\mixer1, \audio),
			\octave, 5,
			\amp, 0.3,
		),
		
	])
)).play;
);
Builder(\fmgen).set(\name, \rise, \seed, rrand(1,1000000));

///////////////////////////////////////////

(
	// hip hop sample fire
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1570].value,
			\bufnum, ~buflib.kick[684].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[684].value,
			\bufnum, ~buflib.kick[1570].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,1,0,
			]/2,inf).coin.not,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[82].value,
			\bufnum, ~buflib.hat[931].value,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
			],inf).coin.not,
			\legato, Pseq([
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,3,0,1,
					].scramble,1);
				}).loop,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16 * (1 + (0.16 * Pseq([1,0,-1,0],inf))),
			\gain, 0.11,
			\gain, 0.04 * Pseq([
				1,Pwhite(0.1,1/2,3)

			],inf).stutter(1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[82].value,
			\speed, 1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,1,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/16,
			\gain, 0.04 * Pseq([
				1,Pwhite(0.1,1/2,3)

			],inf).stutter(1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1711].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/fire.flac'),
			\legato, 0.95,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\speed, -1 * ~t / ( 90/60 / 2 ) * Pseg(Pseq([1,2],inf),1).loop,
			\pos, Pstep(Pseq([
				Pseq([
					Pseq([
						0
					],7),
					3,
				],inf) + 1,
			],inf) / ( 90/60 / 2 ),1/2),
			\isRest, Pseq([
				0,1,0,0, 0,1,0,1,
				0,1,0,0, 0,0,1,1,
				0,0,0,0, 0,0,1,1,
				Pseq([
					0,1,0,0, 0,1/2,1/2,1,
				]/2,7),
			],inf).coin.not,
			\dur, 1/2,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\speed, 1/2 * (~t/( 92.15/4/60 )),
			\pos, Pseq([
				//0,1,2,3,
				Pseq([
					0,3,
					0,3,
					0,1,3,
					0,3,
					0,3,
					0,3,
					0,1,3,
				],1) + Pseq((0..7)/4,1),
			],inf)/ ( 92.15/4/60 ) ,
			\isRest, Pseq([
				1
				//1,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\hpf, 100,
			\lpf, 4000,
			\lpmix,0,
			\hpmix,0,
			\dur, 1/2,
			\gain, 0.641,
			//\out, BusDef(\mixer3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/fire.flac'),
			\legato, 0.95,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\speed, 1 * ~t / ( 90/60 / 2 ) * Pseq([
				Pseg(Pser([1,2],3),1).repeat(2),
				Pseg(Pser([1/2,2],3),1).repeat(2),
				Pseg(Pser([1,2],3),1).repeat(2),
				Pseg(Pseq([1,2],1),2).repeat(2),
			],inf),
			\pos, Pstep(Pseq([
				Pseq([
					Pseq([
						0
					],7),
					3,
				],inf) + 0,
			],inf) / ( 90/60 / 2 ),1/2),
			\isRest, Pseq([
				1,0,1,1, 1,0,0,0,
				1,0,1,1, 1,0,0,0,
				1,0,1,1, 1,0,0,0,
				1,1/2,1/2,1/2, 1/2,1/2,1/2,1/2,
				Pseq([
					2,1/2,1,1, 1,1/2,1/2,1/2,
				],4)/2,
			],inf).coin.not,
			\dur, 1/2,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/fire.flac'),
			\legato, 0.95 * Pseq([
				1,1,2,1/2, 1/2,1,1,1/2
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\speed, 1 * ~t / ( 90/60 / 2 ) * Pseq([
				2
			],inf),
			\pos, Pstep(Pseq([
				Pseq([
					Pseq([
						0
					],7),
					3,
				],inf) + 0 + (2/8) + 0.05,
			],inf) / ( 90/60 / 2 ),1/2),
			\isRest, Pseq([
				Prand(  [
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 0,1,0,1,
					0,1,0,0, 1,0,0,1,
				].clump(8).collect(Pseq(_)) )
			]/2,inf).coin.not,
			\dur, 1/8,
			\gain, 2,
		)
		
	])
)).play;
);

(
	// hip hop sample fire
	// dark version
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1570].value,
			\bufnum, ~buflib.kick[684].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[684].value,
			\bufnum, ~buflib.kick[1570].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,1,0,
				0,1,0,0, 0,1,0,1,
				0,0,0,0, 0,0,0,1,
				0,0,0,1, 0,0,1,0,
			]/2,inf).coin.not,
			\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[82].value,
			\bufnum, ~buflib.hat[931].value,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
			],inf).coin.not,
			\legato, Pseq([
				Plazy({ arg ev;
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,0,0,1, 0,3,0,1,
					].scramble,1);
				}).loop,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/16 * (1 + (0.16 * Pseq([1,0,-1,0],inf))),
			\gain, 0.11,
			\gain, 0.04 * Pseq([
				1,Pwhite(0.1,1/2,3)

			],inf).stutter(1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[931].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[82].value,
			\speed, 1,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,0,0,
				1,1,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,

			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/16,
			\gain, 0.04 * Pseq([
				1,Pwhite(0.1,1/2,3)

			],inf).stutter(1),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1711].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\legato, 0.4,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/fire.flac'),
			\legato, 0.95,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\speed, -1/2 * ~t / ( 90/60 / 2 ) * Pseg(Pseq([1,2],inf),1).loop,
			\pos, Pstep(Pseq([
				Pseq([
					Pseq([
						0
					],7),
					3,
				],inf) + 1,
			],inf) / ( 90/60 / 2 ),1/2),
			\isRest, Pseq([
				0,1,0,0, 0,1,0,1,
				0,1,0,0, 0,0,1,1,
				0,0,0,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/2,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec_hlpf,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\speed, 1/2 * (~t/( 92.15/4/60 )),
			\pos, Pseq([
				//0,1,2,3,
				Pseq([
					0,3,
					0,3,
					0,1,3,
					0,3,
					0,3,
					0,3,
					0,1,3,
				],1) + Pseq((0..7)/4,1),
			],inf)/ ( 92.15/4/60 ) ,
			\isRest, Pseq([
				1
				//1,1,0,1, 0,0,1,0,
			],inf).coin.not,
			\hpf, 100,
			\lpf, 4000,
			\lpmix,0,
			\hpmix,0,
			\dur, 1/2,
			\gain, 0.641,
			//\out, BusDef(\mixer3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/fire.flac'),
			\legato, 0.95,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\speed, 1/2 * ~t / ( 90/60 / 2 ) * Pseg(Pseq([1,2],inf),2).loop,
			\pos, Pstep(Pseq([
				Pseq([
					Pseq([
						0
					],7),
					3,
				],inf) + 0,
			],inf) / ( 90/60 / 2 ),1/2),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
				1,1,0,1, 0,1,0,1,
				1,0,1,1, 1,0,0,0,
				1,1/2,1/2,1/2, 1/2,1/2,1/2,1/2,
				1,0,1,1, 1,0,0,0,
				1,0,1,1, 1,0,0,0,
				1,0,1,1, 1,0,0,0,
				1,1/2,1/2,1/2, 1/2,1/2,1/2,1/2,
			],inf).coin.not,
			\dur, 1/2,
			\gain, 1,
		)
		
	])
)).play;
);

(
	// hip hop sample fire
	// dark version
	// with mixer
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(\out, BusDef(\mixer0, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[1570].value,
				\bufnum, ~buflib.kick[684].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,0,
					0,0,1,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[1010].value,
				//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[684].value,
				\bufnum, ~buflib.kick[1570].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,1,0,
					0,1,0,0, 0,1,0,1,
					0,0,0,0, 0,0,0,1,
					0,0,0,1, 0,0,1,0,
				]/2,inf).coin.not,
				\dur, 1/8 * (1 + (0.16 * Pseq([1,-1],inf))),
				\gain, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[82].value,
				\bufnum, ~buflib.hat[931].value,
				\isRest, Pseq([
					0,1,0,1, 0,1,0,1,
				],inf).coin.not,
				\legato, Pseq([
					Plazy({ arg ev;
						Pseq([
							0,0,0,0, 0,0,0,0,
							0,0,0,1, 0,3,0,1,
						].scramble,1);
					}).loop,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/16 * (1 + (0.16 * Pseq([1,0,-1,0],inf))),
				\gain, 0.11,
				\gain, 0.04 * Pseq([
					1,Pwhite(0.1,1/2,3)
			
				],inf).stutter(1),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1064].value,
				\bufnum, ~buflib.hat[931].value,
				//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[82].value,
				\speed, 1,
				\isRest, Pseq([
					1,0,0,0, 1,0,0,0,
					1,0,0,1, 1,0,0,0,
					1,1,0,0, 1,0,0,0,
					1,0,0,0, 1,0,0,1,
			
				],inf).coin.not,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/16,
				\gain, 0.04 * Pseq([
					1,Pwhite(0.1,1/2,3)
			
				],inf).stutter(1),
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.snare[1719].value,
				//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
				\bufnum, ~buflib.snare[1711].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\legato, 0.4,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.2) ],
				],inf),
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
			Pbind(
				\instrument, \playersec_hlpf,
				\bufnum, BufDef('loop/pigs.flac'),
				\legato, 1,
				\speed, 1/2 * (~t/( 92.15/4/60 )),
				\pos, Pseq([
					//0,1,2,3,
					Pseq([
						0,3,
						0,3,
						0,1,3,
						0,3,
						0,3,
						0,3,
						0,1,3,
					],1) + Pseq((0..7)/4,1),
				],inf)/ ( 92.15/4/60 ) ,
				\isRest, Pseq([
					1
					//1,1,0,1, 0,0,1,0,
				],inf).coin.not,
				\hpf, 100,
				\lpf, 4000,
				\lpmix,0,
				\hpmix,0,
				\dur, 1/2,
				\gain, 0.641,
				\out, BusDef(\mixer3, \audio),
			),
		Pbind(\out, BusDef(\mixer1, \audio)) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/fire.flac'),
				\legato, 0.95,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
				],inf),
				\speed, -1/2 * ~t / ( 90/60 / 2 ) * Pseg(Pseq([1,2],inf),1).loop,
				\pos, Pstep(Pseq([
					Pseq([
						Pseq([
							0
						],7),
						3,
					],inf) + 1,
				],inf) / ( 90/60 / 2 ),1/2),
				\isRest, Pseq([
					0,1,0,0, 0,1,0,1,
					0,1,0,0, 0,0,1,1,
					0,0,0,0, 0,0,1,1,
				],inf).coin.not,
				\dur, 1/2,
				\gain, 1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('loop/fire.flac'),
				\legato, 0.95,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
				],inf),
				\speed, 1/2 * ~t / ( 90/60 / 2 ) * Pseg(Pseq([1,2],inf),2).loop,
				\pos, Pstep(Pseq([
					Pseq([
						Pseq([
							0
						],7),
						3,
					],inf) + 0,
				],inf) / ( 90/60 / 2 ),1/2),
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					1,1,0,1, 0,1,0,1,
					1,0,1,1, 1,0,0,0,
					1,1/2,1/2,1/2, 1/2,1/2,1/2,1/2,
					1,0,1,1, 1,0,0,0,
					1,0,1,1, 1,0,0,0,
					1,0,1,1, 1,0,0,0,
					1,1/2,1/2,1/2, 1/2,1/2,1/2,1/2,
				],inf).coin.not,
				\dur, 1/2,
				\gain, 1,
			)
		]),
		
	])
)).play;
);


///////////////////////////////////////////



(
Pdef(\clar, 
	Pbind(
		\instrument, \fmgen_clar,
	)
);
);


NoteTimeline(\vin33_melo1, Pdef(\clar)).edit
NoteTimeline(\vin33_melo1).clear

NoteTimeline(\vin33_melo2, Pdef(\melo2)).edit
(
Pdef(\melo2, 
	Pbind(
		\instrument, \fmgen_piano,
	)
);
);

Builder(\fmgen).set(\name, \piano, \seed, rrand(1,1000000));
ProtoDef(\piano).startControl(Pdef(\melo2))
SynthDesc(\fmgen_piano).getHalo(\seed)




ProtoDef(\rdn2).presetCompileString.editorInsert
(
	// cool screech reverb
	// amp is unbound
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-4641-HHFU", BusDef('sendbus2'));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.84033613445378,
	'gain', 0.21848739495798,
	'fb', 0.0001,
	'delay', 0.39503780135666,
	'delay2', 0.00016538167833957,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.36917041584555,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.18287676377481,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);


//////////////


(
SynthDef(\curvescratcher, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, bufnum, speed=1, pos=0, doneAction=2, loop=0, trigger=1, velamp=1, timeScale=1, levelScale=1, levelBias=1;
	// pos in seconds
	var sig;
	var sig1;
	var phase;
	phase = Phasor.ar(1, speed,0,BufFrames.kr(bufnum)) * EnvGen.kr(\curve.kr(
		Env([ 0, 0, 1.43933, 0.723851, 0, 0  ], [ 0.0975, 0.146479, 0.105, 0.091303, 0.979718  ], [ 1, 1, 1, 1  ], -1, nil)	
	), levelScale: levelScale, timeScale: timeScale, levelBias: levelBias, gate:1);
	sig = BufRd.ar(2, bufnum, phase);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.001,0,1,0.01)),gate,doneAction:doneAction);
	//sig = Pan2.ar(sig, pan, 1).sum;
	Out.ar(out, sig * \gain.kr(1) * velamp);
}, metadata:(specs:(
	curve: XEnvSpec( ControlSpec(-3,3,\lin,0,0) ),
))).add;
)

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pdef(\curvescratcher, 
			Pbind(
				\instrument, \curvescratcher,
				\bufnum, BufDef('voices/feynman.flac'),
				\bufnum, BufDef('loop/pigs_full.flac'),
				\levelScale, 1,
				\legato, 1,
				\speed, 1 * ~t / ( 92.10/4/60 ),
				\dur, 1,
				\gain, 1,
			)
		),
	])
)).play;
);

PlayerWrapper(Pdef(\curvescratcher)).edit
(
Pdef(\part3, Pdef(\zed3, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('loop/pigs.flac'),
			\legato, 1,
			\speed, 1 * (~t/( 92.15/4/60 )),
			\dur, 1,
			\gain, 1,
		)
		
	])
)).play;
)
