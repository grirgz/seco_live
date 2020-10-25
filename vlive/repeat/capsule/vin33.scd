
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

			seed = seed ? rrand(1,10000000);
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
			}).mean;
			//sig = sig * [1,0.4,0.4,0.4,0.4];
			//sig = sig.mean;
			sig.debug("sig");
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.7)), gate, doneAction:2);
			//pan = pan + {randfm.(exprand(0.01,100), randfm.(exprand(0.01,200))) * rrand(0.01,1) }!freq.size;
			sig = Pan2.ar(sig, [-1,1] * \panspread.kr(1) + pan, amp).flop.mean;
			sig.debug("sig");
			Out.ar(out, sig);
		}).add;
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



		(
		Pdef(\melo, 
			Pbind(
				\instrument, \fmgen_oppress,
			)
		);
	)

ProtoDef(\piano).startControl(Pdef(\melo))
