
(
~molecular_box = { arg lenpat, quant=16, keep=3, pattern;

	Prout({ arg ev;
	
		var lenstr = lenpat.asStream;
		var patstr;
		var buf = Array.fill(quant,{List.new});
		var pat, len;
		var i;
		var basepat;

		patstr = pattern.asStream;

		len = lenstr.next;
		if(len.isNil) {
			nil.yield;
		};

		i = 0;
		inf.do {
			var n;
			buf[i] = buf[i].keep(0-keep);
			n = buf[i];

			if(n.size != 0) {
				// previous note found, change note length
				len = lenstr.next;
				if(len.isNil) {
					nil.yield;
				};
			};

			basepat = ev;
			basepat[\legato] = len;
			pat = patstr.next(basepat);
			if(pat.isNil) {
				nil.yield;
			};
			n.add(Pn(pat,1));

			n.size.debug("n SIZE!!!!!!!!!!!!!");

			if(len == 0) {
				len.debug("Warning: len should not be 0");
				len = 1;
			};
			len.do {
				var n = buf[i];

				if(n.size != 0) {
					ev = Ppar(n).embedInStream;
					ev.debug("EV1==========!!!!!!!!");
				} {
					var myev;
					myev = ev.deepCopy;
					myev[\isRest] = true;
					ev = Pn(myev,1).embedInStream;
					ev.debug("EV2==========!!!!!!!!");
				};
				i = (i+1) % quant;
			};
		}
	})
};

SynthDef(\simple, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq * [1,1.01,2.01,1.02,1/2] * (SinOsc.kr(3)*0.01+1));
	sig = sig + LFTri.ar(freq * [1,1/2,1.01]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	sig = LFSaw.ar(freq * [1,1.01,2.01,1.02]);
	sig = Pulse.ar(freq * [1,1.01,2,2.01,1.002]) + sig;
	env = EnvGen.ar(Env.adsr(0.4,0.3,0.31,0.1),gate,doneAction:0);
	sig = RLPF.ar(sig, \ffreq.kr(1000) * (env+0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\reverb, {arg out = 0, in=0;
    var sig = In.ar(in, 2);
    sig = FreeVerb.ar(sig,0.5,0.7);
    ReplaceOut.ar(out, sig);
}).add;
);

Synth.tail(1,\reverb); // if you want

~t = 2; TempoClock.default.tempo = ~t;
(

Pdef(\mol, 

	~molecular_box.(Pseq([4.5,8],inf), 16, 3,
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) / 2,
			),
			Pbind(
				\instrument, Pn(\saw,4),
				\ffreq, Pseq([5000,1000,200,2000],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
				\legato, Pkey(\legato) / 2,
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				Pseq((0..13)),
				Pseq((0..10)-4),
				Pseq((5..1)),
				Pseq((0..5)*2),
				Pseq((20..10)),
				Pseq((0..10)-10),
			],inf),
		);

	)
	<>
	Pbind(
		\dur, 1/4,
		\scale, Scale.minor,
	)

).play;

)

~t = 1; TempoClock.default.tempo = ~t;
(

Pdef(\mol, 

	~molecular_box.(Pseq([4.5,2,5,1],inf), 16, 3,
		Pbind(
			\legato, Pseq([
				Pfuncn({ arg ev; ev[\legato] },16),
				Pser([0.5],16)
			],inf)
		)
		<>
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) * Pseq([0.2,0.8,1.2],inf).stutter(3),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pseq([5000,1000,700],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pkey(\freq) * 4,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				Pseq((5..1)),
				Pseq((0..3)),
				Pseq((0..10)-4),
				Pseq((0..5)*3),
				Pseq((2..10)),
				Pseq((0..10)-10),
			],inf),
		);

	)
	<>
	Pbind(
		\dur, 1/4,
		\mtranspose, 2,
		\root, 4,
		\scale, Scale.aeolian,
	)

).play;
)

(

Pdef(\mol, 

	(

	~molecular_box.(Pseq([3,4],inf), 16, 3,
		Pbind(
			\legato, Pseq([
				Pfuncn({ arg ev; ev[\legato] },16),
				Pser([0.5],16)
			],inf)
		)
		<>
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) * Pseq([0.2,0.8,1.2],inf).stutter(3),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pseq([5000,1000,700],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pkey(\freq) * 4,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				//Pseq([1,2,3,2,1,4,5,7,8,5,4,1,2,3,4,5]),
				Pseq((0..8))
			],inf) + Pseq([0,4,8,12],inf).stutter(4),
		);

	)
	<>
	Pbind(
		\dur, 1/4,
		\octave, 4,
		\mtranspose, 2,
		\root, 4,
		\scale, Scale.aeolian,
	)

	).trace

).play;
)


///////////////////////

a = Ppar([
	Pbind(
		\degree, Pseq((1..16)),
	),
	Pbind(
		\degree, Pseq((17..26)),
	),
]).asStream;

a.next(Event.default)



///////////////////////////// first version
// note this is not the original molecular algo because dur is fixed

(
	TempoClock.default.tempo = 1;
	
	Pbind(
		\index, Pseq((0..15),inf),
		\dur, 1/4,
		\octave, 4,
		\do, Prout({ arg ev;
			var degstr = Pseq((0..24)).asStream; // degrees
			var lenstr = Pseq([4,3],inf).asStream; // note length
			var buf = Array.fill(16,{List.new}); // record loop buffer
			var deg, len;

			len = lenstr.next;

			inf.do { 

				var i = ev[\index];
				var n = buf[i];

				if(n.size != 0) {
					// previous note found, change note length
					len = lenstr.next;
				};

				deg = degstr.next;
				n.add([deg, len]);

				len.do {
					var i = ev[\index];
					var n = buf[i];

					if(n.size != 0) {
						ev[\degree] = n.flop[0];
						ev[\legato] = n.flop[1];
					} {
						ev[\isRest] = true;
					};
					ev = deg.yield;
				};
			}
		}),
	).trace.play
)

(
// change the rules a bit
	
Pdef(\mol,
	Pbind(
		\index, Pseq((0..15),inf),
		\dur, 1/4,
		//\root, Pseq([2,0],inf),
		\mtranspose, Pseq([0,3,4,3],inf).stutter(8),
		\octave, 4,
		\scale, Scale.dorian,
		\do, Prout({ arg ev;
			var degstr = Pseq((0..13),inf).asStream;
			var lenstr = Pseq([3,8,2],inf).asStream;
			var buf = Array.fill(16,{List.new});
			var keep = 3; // max note per chord
			var deg, len;

			len = lenstr.next;

			inf.do { 

				var i = ev[\index];
				var n;
				buf[i] = buf[i].keep(0-keep);
				n = buf[i];

				if(n.size != 0) {
					// previous note found, change note length
					len = lenstr.next;
				};

				deg = degstr.next;
				n.add([deg, len]);

				len.do {
					var i = ev[\index];
					var n = buf[i];

					if(n.size != 0) {
						ev[\degree] = n.flop[0];
						ev[\legato] = n.flop[1]/2;
						//ev[\legato] = 1;
					} {
						ev[\isRest] = true;
					};
					ev = deg.yield;
				};
			}
		}),
	).trace
).play;
)


////////////////////: xp

(
	
Pdef(\mol,
	Pbind(
		\index, Pseq((0..11),inf),
		\dur, 1/4,
		//\root, Pseq([2,0],inf),
		//\mtranspose, Pseq([0,3,4,3],inf).stutter(8),
		\octave, 4,
		//\scale, Scale.dorian,
		\do, Prout({ arg ev;
			var degstr = Pseq((0..11),inf).asStream;
			var lenstr = Pseq([10,1],inf).asStream;
			var buf = Array.fill(16,{List.new});
			var keep = 1; // max note per chord
			var deg, len;

			len = lenstr.next;

			inf.do { 

				var i = ev[\index];
				var n;
				buf[i] = buf[i].keep(0-keep);
				n = buf[i];

				if(n.size != 0) {
					// previous note found, change note length
					len = lenstr.next;
				};

				deg = degstr.next;
				n.add([deg, len]);

				len.do {
					var i = ev[\index];
					var n = buf[i];

					if(n.size != 0) {
						ev[\degree] = n.flop[0];
						ev[\legato] = n.flop[1]/2;
						//ev[\legato] = 1;
					} {
						ev[\isRest] = true;
					};
					ev = deg.yield;
				};
			}
		}),
	).trace
).play;
)


/////// real molecular music box

(
SynthDef(\looper, { arg out=0, gate=1, bufnum;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	RecordBuf.ar(sig, bufnum: bufnum, offset: 0, recLevel: 1, preLevel: 1, run: 1, loop: 1, trigger: 1, doneAction: 0);
	sig = PlayBuf.ar(2, bufnum: bufnum, rate: 1, trigger: DelayL.kr(Impulse.kr(0), 0.0001,0.0001), startPos: 0, loop: 1, doneAction: 0);
	//sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

~t = 1; TempoClock.default.tempo = ~t;
BufDef(\loop, 4/~t * s.sampleRate, 2)

(
	// 4E3
			~loopdur = 4;
BufDef(\loop).zero;
Pdef(\realmol, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq((0..11*3))+2, // E
			\octave, 3,
			\time, Ptime().trace,
			\mol, Prout({ arg ev;
				var timebuf = Set.new;
				var durstr = Pseq([4,3]/4,inf).asStream; // 4,3
				var modtime;
				var dur = durstr.next;
				100.do { arg idx;
					modtime = ev[\time].debug("time") % ~loopdur;
					modtime.debug("modtime");
					if(timebuf.includes(modtime)) {
						dur = durstr.next;
						"match, %".format(dur).debug;
					};
					ev[\dur] = dur;
					timebuf.add(modtime);
					ev = 1.yield;
				}
			}),
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\loopdur, 4/~t,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
)


/////////////////


(
	// 4E3
			~loopdur = 4;
BufDef(\loop).zero;
Pdef(\realmol, 
	Ppar([
		Pbind(
			\instrument, \default,
			\degree, Pseq((0..11*3).reverse)+2, // E
			\octave, 3,
			\time, Ptime().trace,
			\mol, Prout({ arg ev;
				var timebuf = Set.new;
				var durstr = Pseq([4,2.0,1]/4,inf).asStream; // 4,3
				var modtime;
				var dur = durstr.next;
				100.do { arg idx;
					modtime = ev[\time].debug("time") % ~loopdur;
					modtime.debug("modtime");
					if(timebuf.includes(modtime)) {
						dur = durstr.next;
						"match, %".format(dur).debug;
					};
					ev[\dur] = dur;
					timebuf.add(modtime);
					ev = 1.yield;
				}
			}),
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\loopdur, 4/~t,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
)

gcd(3,4)
lcm(4,3)


(
			~loopdur = 4;
BufDef(\loop).zero;
Pdef(\realmol, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([2000,1000,100,40],inf), Pseq([4,3,1/2],inf)),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.15714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				~pmodenv.(Pseq([1,2,1,4,1000],inf), 7),
			],inf).stutter(1),
			'delay2', 0.210000543560101,
			'distamp', 1.361836201538,
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
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
)

(
			~loopdur = 4;
BufDef(\loop).zero;
Pdef(\realmol, 
	Ppar([
		Pbind(
			\instrument, \default,
			\freq, ~pmodenv.(Pseq([2000,1000,100,40],inf), Pseq([4,3,1/2],inf)),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', 0.000600001231 * Pseq([
				~pmodenv.(Pseq([1,2,1,4,1000],inf), 7),
			],inf).stutter(1),
			'delay2', 0.000000543560101,
			'distamp', 1.361836201538,
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
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
)


(
SynthDef(\simplesaw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1/2,1],[0.1,0.8]), 1);
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * env1 * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
			~loopdur = 4;
BufDef(\loop).zero;
Pdef(\realmol, 
	Ppar([
		Pbind(
			\instrument, \simplesaw,
			\freq, ~pmodenv.(Pseq([2000,1000,100,40],inf), Pseq([4,3,1/2],inf)),
			\dur, Pseq([1,2,1/2,1.5]/4,inf).stutter(4),
			\lpfr, 1/2,
			\sustain, 0.1/6,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono( \rdncleandist_fulllight,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\addAction, \addToTail,
			'mix', 0.5714285714286,
			'gain', 0.7344889782792,
			'fb', 0.0002099467303085,
			'delay', Pseq([
				~pmodenv.(Pseq(0.00100061234*[1,2,1,4,1000],inf), 7),
			],inf),
			'delay2', 0.000000543560101,
			'distamp', 11.361836201538,
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
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
)

(
			~loopdur = 4;
BufDef(\loop).zero;
Pdef(\realmol, 
	Ppar([
		Pbind(
			\instrument, \simplesaw,
			\freq, ~pmodenv.(Pseq([200,8000,100,40],inf), Pseq([4,3,1/2],inf)),
			\dur, Pseq([4,2,1/2,1.5]/4,inf).stutter(4),
			\lpfr, 1/2,
			\sustain, 0.1/6,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.41,
			'gain', 2/8,
			'fb', 0.000000031,
			'delay', 0.00000001,
			'delay2', 0.100001001,
			'delay3', 0.0000080,
			'distamp', 4.604,
			'distamp2', 4.23,
			'distamp3', 45.89,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
)

(
			~loopdur = 4;
BufDef(\loop).zero;
Pdef(\realmol, 
	Ppar([
		Pbind(
			\out, BusDef(\sendbus1, \audio),
			\instrument, \snapkickx,
			\bodyfreqenv, [ Env([261, 54, 21], [0.035, 0.08], curve: \exp) ],
			\dur, 1/8+0.1,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
		Pmono(\rdnroom,
			\inbus, BusDef(\sendbus1, \audio, 2),
			\out, BusDef(\sendbus2, \audio, 2),
			\dur, 1/8,
			'wet10', 1.0,
			'mix', 0.41,
			'gain', 2/8,
			'fb', 0.000000031,
			'delay', 0.00001001,
			'delay2', 0.000001001,
			'delay3', 0.0001080,
			'distamp', 0.604,
			'distamp2', 0.23,
			'distamp3', 0.49,
			'shift', -5.0,
			'shiftmix', 0.0,
			'stereo', 1.0,
			'indelay', 0.04,
		),
		Pmono(\looper,
			\inbus, BusDef(\sendbus2, \audio, 2),
			\loopdur, 4/~t,
			\bufnum, BufDef(\loop),
			\dur, 1,
			\amp, 0.1,
		),
	]),
).play;
)
