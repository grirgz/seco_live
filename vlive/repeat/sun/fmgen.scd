(
	// generate fmc
	~fmgen_ambientchords = { arg seed=10000, num=20;

		SynthDef(\fmgen_ambientchords_v+++seed+++\n+++num, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
			var sig;
			//var num=20;
			thisThread.randSeed = seed;
			sig = num.collect { arg idx;
				var isig;
				var oscgen = {
					[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
				};
				var harms = [1,2,4,1/2,1/4];
				var fenv;
				isig = oscgen.value.ar(oscgen.value.ar(freq * harms.choose) * freq * harms.choose + rrand(0.01,0.2));
				isig = isig * EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2)),gate,doneAction:0);
				fenv = EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.01,1),rrand(0.1,2)),gate,doneAction:0);
				fenv = fenv * rrand(0.1,8) + rrand(0.1,2);
				isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * fenv ).clip(20,20000), \rq.kr(0.5));
				isig;
			};
			sig = sig.clump(2).flop.mean;
			sig.debug("sig");
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
			//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
			sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
			Out.ar(out, sig);
		}).add;
	};
	~fmgen_ambientchords.();

	~fmgen_short = { arg seed=1000, num=10;

		SynthDef(\fmgen_short_v+++seed+++\n+++num, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
			var sig;
			//var num=10;
			thisThread.randSeed = seed;
			sig = num.collect { arg idx;
				var isig;
				var oscgen = {
					[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
				};
				isig = oscgen.value.ar(oscgen.value.ar(freq * [1,2,1/2,1/4].choose) * freq * [1,2,1/2,1/4].choose + rrand(0.001,0.1));
				isig;
			};
			sig = RLPF.ar(sig, ( \lpfr.kr(5.1) * freq ).clip(20,20000), \rq.kr(0.5));
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
			//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
			sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
			//sig = HPF.ar(sig, freq/4);
			sig = sig * \gain.kr(1);
			Out.ar(out, sig);
		}).add;
	};
	~fmgen_short.();
	~fmgen_cluster2 = { arg seed=10022, num=40;
		SynthDef(\fmgen_cluster2_v+++seed+++\n+++num, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
			var sig;
			//var num=40;
			thisThread.randSeed = seed;
			//thisThread.randSeed = 100000.rand.debug("seed");
			sig = num.collect { arg idx;
				var isig;
				var oscgen = {
					[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
				};
				var harms = [1,2,4,1/2,1/4];
				var fenv;
				isig = oscgen.value.ar(oscgen.value.ar(freq * harms.choose) * freq * harms.choose + rrand(0.01,0.2));
				isig = isig * EnvGen.ar(Env.dadsr(rrand(0,1.3),rrand(0.1,5),rrand(0.1,5),rrand(0.01,1),rrand(0.1,4)),gate,doneAction:0, timeScale:timeScale);
				fenv = EnvGen.ar(Env.adsr(rrand(0.1,5),rrand(0.1,5),rrand(0.01,1),rrand(0.1,5)),gate,doneAction:0, timeScale:timeScale);
				fenv = fenv * rrand(0.1,3) + rrand(0.1,2);
				isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * harms.choose * fenv ).clip(20,20000), \rq.kr(0.5));
				isig;
			};
			sig = sig.clump(4).flop.mean / 4;
			sig.debug("sig");
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
			//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
			sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
			Out.ar(out, sig);
		}).add;
	};
	~fmgen_cluster2.();
);

		(
		SynthDef(\fmc_ambientchords2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
			var sig;
			var num=20;
			//thisThread.randSeed = 100000.rand.debug("seed");
			//thisThread.randSeed = 10019;
			sig = num.collect { arg idx;
				var isig;
				var oscgen = {
					[SinOsc,LFSaw,LFPulse,LFCub].wchoose([1,0.1,0.1].normalizeSum)
				};
				var harms = [1,2,4,1/2,1/4];
				var fenv;
				var lfo1 = SinOsc.kr(rrand(0.01,1)).range(0,1) * 0.01 + 1;
				isig = oscgen.value.ar(oscgen.value.ar(freq * harms.choose) * freq * lfo1 * harms.choose + rrand(0.01,0.2));
				isig = isig * EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.1,1),rrand(0.1,2)),gate,doneAction:0);
				fenv = EnvGen.ar(Env.adsr(rrand(0.1,8),rrand(0.1,8),rrand(0.1,1),rrand(0.1,2)),gate,doneAction:0);
				fenv = fenv * rrand(0.1,8) + rrand(0.1,2);
				isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * fenv ).clip(20,20000), \rq.kr(0.5));
				isig;
			};
			sig = sig.clump(2).flop.mean;
			sig.debug("sig");
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
			//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
			sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
			Out.ar(out, sig);
		}).add;
		)

// END


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~fmgen_ambientchords.(88595,5),
			\note, Pseq([
				[0,4,7]
			],inf),
			\note, Pseq([
				[0,4,7,10],
				[0,4,7,9]+2,
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/2,2],1), 4).loop,
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Prout({ arg ev;
			// put a new instrument for each note in the chord
			// -- use a queue, work only if input pattern is infinite
			var queue = List.new;
			inf.do {
				ev[\note].collect { arg note, idx;
					var inev;
					var nev = ev.copy;
					nev[\note] = note;
					nev[\instrument] = ~fmgen_ambientchords.(88595.rand,5);
					if(idx != ( ev[\note].size - 1 )) {
						nev[\delta] = 0;
					};
					nev.debug("nev"++idx);
					inev = nev.yield;
					queue.insert(0, inev);
				};
				queue.size.debug("queue size");
				ev = queue.pop;
			};
			
		})<>
		Pbind(
			\instrument, ~fmgen_ambientchords.(88595,5),
			\note, Pseq([
				[0,4,7],
				[0,4,7]+5,
			],inf),
			\note, Pseq([
				[0,4,7,10],
				[0,4,7,9]+2,
			],inf),
			\lpfr, ~pmodenv.(Pseq([1/2,2],1), 4).loop,
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
	~sdbank = 100.collect { arg item, idx;
		~fmgen_ambientchords.(88595.rand,rrand(2,15))
	};
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Prout({ arg ev;
			var str;
			var sdbank = ~sdbank;
			str = Pseq([
				[0,4,7,10],
				[0,5,7,10]+1,
			],inf).do { arg chord, idx;
				ev = Ppar(chord.collect { arg note, idx;
					Pbind(
						\instrument, sdbank.choose,
						\note, note,
						\lpfr, ~pmodenv.(Pseq([1/2,2],1), 4).loop,
						\octave, 5,
						\dur, Pn(4,1),
						\adsr, Pseq([
							[ Env.adsr(4.1,0.1,0.8,4.1,1,3) ],
						],inf),
						\amp, 0.1,
					)
				}).embedInStream(ev);
			};
		}),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Prout({ arg ev;
			var str;
			var sdbank = ~sdbank;
			str = Pseq([
				[0,4,7,9],
				[-1,2,6,9],
			],inf).do { arg chord, idx;
				ev = Ppar(chord.collect { arg note, idx;
					Pbind(
						\instrument, sdbank.choose,
						\note, note,
						\lpfr, ~pmodenv.(Pseq([1/2,4],1), 4, -1).loop,
						\octave, 5,
						\legato, 1,
						\dur, Pconst(4,[1,1/2,1/3,2,4,1/4,1/5].choose),
						\adsr, Pseq([
							[ Env.adsr(0.1,0.1,0.8,0.1,1,3) ],
						],inf),
						\amp, 0.1,
					)
				}).embedInStream(ev);
			};
		}),
		
	])
)).play;
);

