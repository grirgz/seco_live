

s = (5+)
(
~fun = Routine({ 
	var x=1;
	inf.do { arg idx;
		x = (x+5)*(-0.8)*(x/2.5);
		x.yield;
	};
})
)

~fun.next
~fun.reset
~fun.nextN(1000).plot
~fun.nextN(12000).histo(100,-5,2).plot

(
~fun = Routine({ 
	var x=1;
	inf.do { arg idx;
		x = (x+6)*(-0.8)*(x/2.5);
		x.yield;
	};
})
)


///////////////:

(
SynthDef(\chaosman, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * \freqfac.kr(1).lag(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);


(
Pdef(\zed, 
	Pmono( \chaosman,
		\degree, Pseq([0],inf),
		\freqfac, ~fun,
		\dur, 1/16,
		\amp, 0.1,
	)
).play;
);

(
~chaos = { arg x;
	x = (x+5)*(-0.8)*(x/2.5);
};
)

(
~chaos = { arg x;
	x = (x+6)*(-0.8)*(x/2.5);
};
)

(
~chaos = { arg x;
	x = (x+5.2)*(-0.8)*(x/2.5);
};
)

(
SynthDef(\chaosanimal, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = ~chaos.(freqfac);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * freqfac.poll);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, 
	Pmono( \chaosanimal,
		\degree, Pseq([0,10,-19],inf),
		\dur, 1/16,
		\amp, 0.1,
	)
).play;
);

/// chaoscustom

(
SynthDef(\chaoscustom, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = (freqfac+\chaosbias.kr(5.2))*(\chaosfac.kr(-0.8))*(freqfac/\chaosdiv.kr(2.5));
	freqfac = LeakDC.kr(freqfac);
	freqfac = freqfac * ( CheckBadValues.kr(freqfac) <= 0 ).poll(label:"check");
	//freqfac = freqfac.clip2(100.1);
	//freqfac = freqfac.fold2(100.1);
	freqfac = freqfac.wrap2(100.1);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * freqfac.poll);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, 
	Pdef(\chaoscustom,
		Pmono( \chaoscustom,
			\degree, Pseq([0],inf),
			\dur, 1/16,
			\amp, 0.1,
		)
	)
).play;
);

Pdef(\chaoscustom).clear
Pdef(\chaoscustom).envir = ()
(
Pdef(\part, 
	Pdef(\chaoscustom,
		Pmono( \chaoscustom,
			\degree, Pseq([0],inf),
			\dur, 1/16,
			\chaosbias, Pseq([5,5.2],inf),
			\chaosfac, Pseq([-0.8],inf),
			\chaosdiv, Pseq([2.5],inf),
			\amp, 0.1,
		)
	)
).play;
);

Pdef(\chaoscustom).edit


//////// chaoscustomfm
(

SynthDef(\chaoscustomfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = (freqfac+\chaosbias.kr(5.2))*(\chaosfac.kr(-0.8))*(freqfac/\chaosdiv.kr(2.5));
	freqfac = LeakDC.kr(freqfac);
	freqfac = freqfac * ( CheckBadValues.kr(freqfac) <= 0 ).poll(label:"check");
	//freqfac = freqfac.clip2(100.1);
	//freqfac = freqfac.fold2(100.1);
	freqfac = freqfac.wrap2(100.1);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * ( freqfac.poll * \fmamp.kr(0.1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(

	// test with lpf over chaos
SynthDef(\chaoscustomfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = (freqfac+\chaosbias.kr(5.2))*(\chaosfac.kr(-0.8))*(freqfac/\chaosdiv.kr(2.5));
	freqfac = LeakDC.kr(freqfac);
	freqfac = freqfac * ( CheckBadValues.kr(freqfac) <= 0 ).poll(label:"check");
	//freqfac = freqfac.clip2(100.1);
	//freqfac = freqfac.fold2(100.1);
	freqfac = freqfac.wrap2(100.1);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * ( LPF.kr(freqfac.poll,180) * \fmamp.kr(0.1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);
(

	// test with latch over chaos
SynthDef(\chaoscustomfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = (freqfac+\chaosbias.kr(5.2))*(\chaosfac.kr(-0.8))*(freqfac/\chaosdiv.kr(2.5));
	freqfac = LeakDC.kr(freqfac);
	freqfac = freqfac * ( CheckBadValues.kr(freqfac) <= 0 ).poll(label:"check");
	//freqfac = freqfac.clip2(100.1);
	//freqfac = freqfac.fold2(100.1);
	freqfac = freqfac.wrap2(100.1);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * ( Latch.ar(freqfac.poll,Impulse.ar(freq)) * \fmamp.kr(0.1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
/// test with delay
SynthDef(\chaoscustomfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = (freqfac+\chaosbias.kr(5.2))*(\chaosfac.kr(-0.8))*(freqfac/\chaosdiv.kr(2.5));
	freqfac = LeakDC.kr(freqfac);
	freqfac = freqfac * ( CheckBadValues.kr(freqfac) <= 0 ).poll(label:"check");
	//freqfac = freqfac.clip2(100.1);
	//freqfac = freqfac.fold2(100.1);
	freqfac = freqfac.wrap2(100.1);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * ( freqfac.poll * \fmamp.kr(0.1) + 1 ));
	sig = DelayL.ar(sig , 0.1 , LPF.kr(freqfac,10) * \delayfac.kr(0.00001)) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
/// test with delay and lpf
SynthDef(\chaoscustomfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = (freqfac+\chaosbias.kr(5.2))*(\chaosfac.kr(-0.8))*(freqfac/\chaosdiv.kr(2.5));
	freqfac = LeakDC.kr(freqfac);
	freqfac = freqfac * ( CheckBadValues.kr(freqfac) <= 0 ).poll(label:"check");
	//freqfac = freqfac.clip2(100.1);
	//freqfac = freqfac.fold2(100.1);
	freqfac = freqfac.wrap2(100.1);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * ( LPF.kr(freqfac.poll,100) * \fmamp.kr(0.1) + 1 ));
	sig = DelayL.ar(sig , 0.1 , LPF.kr(freqfac,10) * \delayfac.kr(0.00001)) + sig;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, 
	Pdef(\chaoscustomfm,
		Pmono( \chaoscustomfm,
			\degree, Pseq([0,3],inf),
			\dur, 1/2,
			\fb, 0.7,
			\chaosbias, Pseq([5,5.2,10.1],inf),
			\chaosfac, Pseq([-0.8,-12],inf),
			\chaosdiv, Pseq([2.5,7],inf),
			\fmamp, 0.003,
			\amp, 0.1,
		)
	)
).play;
);

(
Pdef(\part, 
	Pdef(\chaoscustomfm,
		Pmono( \chaoscustomfm,
			\degree, Pseq([0,3],inf),
			\dur, 1/2,
			\fb, 0.7,
			\chaosbias, Pseq([5,5.2,10.1],inf),
			\chaosfac, Pseq([-0.8,-12],inf),
			\chaosdiv, Pseq([2.5,7],inf),
			\fmamp, 0.3,
			\amp, 0.1,
		)
	)
).play;
);

//////// chaosfm
(
SynthDef(\chaosfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = ~chaos.(freqfac);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * [1,1] * ( freqfac.poll * \fmamp.kr(0.1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
	}, metadata:(specs:(
		fb: ControlSpec(0.001,4,\lin, 0, 1)
	))).add;
Pdef(\part).reset;
);

(
SynthDef(\chaosfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = ~chaos.(freqfac);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * ( freqfac* [1,1+\diff.kr(0.001)]  * \fmamp.kr(0.1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + [-1,1], amp).flop.mean;
	sig.debug("kj");
	Out.ar(out, sig);
	}, metadata:(specs:(
		fb: ControlSpec(0.001,4,\lin, 0, 1),
		diff: ControlSpec(0.0001,0.04,\lin, 0, 1),
	))).add;
Pdef(\part).reset;
);


(
Pdef(\part, 
	Pdef(\chaosfm,
	Pmono( \chaosfm,
		\degree, Pseq([0],inf),
		\dur, 1/16,
		\amp, 0.1,
	))
).play;
);

WindowDef(\PdefEditor).front(Pdef(\chaosfm))
FileSystemProject.load("repeat/cavern/lib.scd")

Pdef(\chaosfm).addHalo(\instrument, \chaosfm)
Pdef(\chaosfm).addSpec(\fb, ControlSpec(0.4,1.4,\lin))
Param(Pdef(\chaosfm), \fb).spec
Param(Pdef(\chaosfm), \fb).spec
Pdef(\chaosfm).getSpec(\fb)
Pdef(\chaosfm).getHalo(\Spec)
Halo
Log(\Param).level = \info
SynthDesc(\chaosfm).addSpec(\fb)
SynthDesc(\chaosfm).addSpec(\fb, ControlSpec(0.4,1.4,\lin))
Pdef(\chaosfm).addSpec(\xxv, ControlSpec(0.4,1.4,\lin))
Pdef(\chaosfm).getSpec

/////////////////////

(
SynthDef(\chaosfm2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var freqfac;
	freqfac = LocalIn.kr(1) * \fb.kr(1.01);
	freqfac = freqfac + Impulse.kr(0);
	freqfac = ~chaos.(freqfac);
	LocalOut.kr(freqfac);
	sig = SinOsc.ar(freq * \modfreq.kr(1) * [ [1,2,1/2, 3/2] ] * ( freqfac* [1,1+\diff.kr(0.001)]  * \fmamp.kr(0.1) + 1 )).flop.mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + [-1,1], amp).flop.mean;
	sig.debug("kj");
	Out.ar(out, sig);
	}, metadata:(specs:(
		fb: ControlSpec(0.001,4,\lin, 0, 1),
		diff: ControlSpec(0.0001,0.04,\lin, 0, 1),
	))).add;
Pdef(\part).reset;
);

FileSystemProject.load("repeat/capsule/fxheavy.scd")
(
Pdef(\part, 
	Ppar([
		Pdef(\chaosfm,
		Pmono( \chaosfm2,
			\degree, Pseq([0,-1],inf),
			\fmamp, Pseq([0.2,0.8],inf),
			//\modfreq, ~pmodenv.(Pseq([1,1.2,1,0.94],inf), 1),
			\octave, 4,
			\diff, Pwhite(0.01009,0.00001),
			\fb, Pwhite(0.76,0.75)/1.3,
			\dur, 1/1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 6.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
	]),
).play;
);

(
Pdef(\part, 
	Ppar([
		Pdef(\chaosfm,
		Pmono( \chaosfm2,
			\degree, Pseq([0,-1],inf),
			\fmamp, Pseq([0.2,0.8],inf),
			//\modfreq, ~pmodenv.(Pseq([1,1.2,1,0.94],inf), 1),
			\octave, 4,
			\diff, Pwhite(0.01009,0.00001),
			\fb, Pwhite(0.76,0.75)/1.4,
			\dur, 1/1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.100600001231 * Pseq([
				1,
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 6.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
	]),
).play;
);

(
Pdef(\part, 
	Ppar([
		Pdef(\chaosfm,
		Pmono( \chaosfm2,
			\degree, Pstep(Pseq([0,-1],inf),1),
			\fmamp, Pseq([0.2,0.3,0.6,0.8],inf).stutter(1),
			//\modfreq, ~pmodenv.(Pseq([1,1.2,1,0.94],inf), 1),
			\octave, Pseq([
				Pn(4,12),
				Pser([3,4,5],12),
				Pser([3,4,5,6,7],8),
			],inf),
			\diff, Pwhite(0.01009,0.00001),
			\fb, Pwhite(0.76,0.75)/1.4,
			\dur, 1/4,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		)),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.100600001231 * Pseq([
				1,1/1000
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 6.361836201538,
			'prelpf', 19900,
			'prehpf', 17,
			'lpf', 19900,
			'hpf', 17,
			'fbdistamp', 4.5388371966577,
			'fbdistmix', 0.98176470588235,
			'postlpf', 19900,
			'posthpf', 17,
			\bpmix, 0,
			'wetamp', 0.20503372119697,
			'indelay', 0.04,
			\dur, 1,
		),
	]),
).play;
);
