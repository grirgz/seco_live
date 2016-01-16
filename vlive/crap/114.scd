
(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\vua, Pbind(
	\instrument, \dr_oscsampler,
	\degree, Pseq([0],inf),
	\bufnum, BufDef(\ukraine, "bruit1/07_ukraine.flac"),
	\timeScale, Pwhite(10,25),
	\posenv, Pseq([
		[ Env([0.1,0.2,0.1].rand,[0.1,0.8]) ]
	],inf),
	\pos, Pwhite(0,0.3),
	\dur, 8,
	\amp, 0.1
));
);

(
Pdef(\vua2, Pbind(
	\instrument, \default,
	\degree, Prand((1..8),inf),
	\octave, Prand((3..6),inf),
	\isRest, Pseq([
		1,0.4
	],inf).coin.not,
	\dur, 1/8,
	\amp, 0.1
));
);

(
Pdef(\kik, Pbind(
	\instrument, \dr_oscsampler,
	\degree, Pseq([0],inf),
	\bufnum, BufDef(\amen, "vipere/amenbreak.wav"),
	\timeScale, Pwhite(1,25),
	\posenv, Plazy({
		Pseq([
			[ Env([0.7,0.2,0.1].rand,[0.1,0.8]) ]
		],inf);
	}),
	\pos, Pwhite(0,0.3),
	\sustain, 0.1,
	\dur, 1/2,
	\amp, 0.1
));
);

Ndef(\echo)[1] = nil;
Ndef(\echo)[0] = nil;
(
Ndef(\echo)[0] = Pdef(\vua);
Ndef(\echo)[1] = Pdef(\kik);
Ndef(\echo).play;
)
Ndef(\echo).clear
(
Ndef(\echo2).put(10, \filter -> { arg in, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig = in;
	sig = 4.rand.collect({
		sig + DelayN.ar(sig, 0.4, exprand(0.0001,0.4));
	}).flop;
	4.rand.do({
		sig = sig + DelayN.ar(sig, 0.4, exprand(0.0001,0.4));
	});
	sig;
});
);
Ndef(\echo).fadeTime = 0.1;

(
Ndef(\echo2).put(10, \filter -> { arg in, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del, par, seq;
	
	del = { arg si;
		DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr(1));
	};
	seq = { arg si, c;
		c.do({
			si = si + del.(si);
		});
		si;
	};
	par = { arg si, c;
		c.collect({
			si + del.(si);
		}).mean;
	};
	sig = in;
	//sig = par.(seq.(sig, 2), 4);
	8.rand.do { arg x;
		sig = [par, seq].choose.(sig, rrand(1,4))
	};
	sig = sig.tanh / 4.2;
	sig = sig * \poamp.kr(1);

	sig;
});
);
Ndef(\echo).edit

(
Ndef(\echo2).put(10, \filter -> { arg in, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del, par, seq, shift;
	
	shift = { arg si;
		[
			{
				FreqShift.ar(si, 100.rand * [1,-1].choose) + si / 2;
			},
			//{
			//	FreqShift.ar(si, 100.rand * [1,-1].choose);
			//},
		].choose.value;
	};
	del = { arg si;
		DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr(1));
	};
	seq = { arg si, c;
		c.do({
			si = si + del.(si);
		});
		si;
	};
	par = { arg si, c;
		c.collect({
			si + del.(si);
		}).mean;
	};
	sig = in;
	//sig = par.(seq.(sig, 2), 4);
	14.do { arg x;
		sig = [par, seq, shift].choose.(sig, rrand(1,8))
	};
	sig = Limiter.ar(sig);
	sig = sig.softclip / 4.2;
	sig = sig * \poamp.kr(1);

	sig;
});
);

(
Ndef(\echo2).put(10, \filter -> { arg in, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del, par, seq, shift;
	var grow;
	var grownum;
	
	shift = { arg si;
		[
			{
				"shift".debug;
				FreqShift.ar(si, 100.rand * [1,-1].choose) + si / 2;
			},
			{
				"bpf".debug;
				BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01);
			},
			//{
			//	FreqShift.ar(si, 100.rand * [1,-1].choose);
			//},
		].choose.value;
	};
	del = { arg si;
		DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr(1));
	};
	seq = { arg si, c;
		"seq".debug;
		1.do({
			si = si + del.(si);
		});
		si;
	};
	par = { arg si, c;
		"par".debug;
		c.collect({
			si + del.(si);
		});
	};
	grow = { arg si, count, parent="";
		parent.debug("NOW");
		if(count <= 0) {
			si;
		} {
			if(si.isSequenceableCollection) {
				si.collect({ arg isi, idx;
					isi = [par, seq, shift].choose.(isi, 2);
					grow.(isi, count-1, "%[%]:%".format(parent, idx, count));
				})
			} {
				si = [par, seq, shift].choose.(si, 2);
				grow.(si, count-1, "%:%".format(parent, count));
			}
		}
	};
	sig = in;
	//sig = par.(seq.(sig, 2), 4);
	grownum = 6;
	//sig = [ grow.(sig[0] + ( sig[1] * 0.1 ), grownum, "left"), grow.(sig[1] + ( sig[0] * 0.1 ), grownum, "right") ];
	sig = grow.(sig, 4);
	sig.debug("end sig");
	sig = Limiter.ar(sig) * 2;
	sig = sig.softclip / 4.2;
	sig = sig * \poamp.kr(1);

	sig;
});
);
Ndef(\echo).edit
Ndef(\echo).play
Ndef(\echo)[10].value.draw
Ndef(\echo).nameDef
Ndef(\echo).objects[10].synthDef.draw
Ndef.defaultQuant = 2;
NodeProxy

{SinOsc.ar()}.draw;
Ndef(\echo).fadeTime = 4;
Ndef(\echo).fadeTime = 0.2;


(
Pdef(\kik, Pdef(\drkik,Pbind(
	\instrument, \dr_kick,
	\freq, 200,
	\amp, 0.5,
	\dur, 1,
)))
)
(
Pdef(\drkik2,Pbind(
	\instrument, \dr_kick,
	\freq, 200,
	\amp, 0.5,
	\dur, 1/2,
))
)
(
Pdef(\drkik3,Pbind(
	\instrument, \dr_oscsampler,
	\freq, 200,
	\sustain, 0.01,
	\amp, 0.5,
	\timeScale, 5,
	\pos, 0.3,
	\isRest, Pseq([
		Pseq([1,0.6],6),
		Prand([
			Pseq([0,0]),
			Pseq([1,1]),
			Pseq([0.91,0.31]),
		],2)
	],inf).coin.not,
	\dur, 1/8,
))
)
Pdef(\drkik).asParamGroup.edit
Pdef(\drkik2).asParamGroup.edit
Ndef(\echo).unset(\amp)

Ndef(\echo2).edit
(
Ndef(\echo2).play;
Ndef(\echo2).put(0, Pdef(\drkik2));
Ndef(\echo2).put(1, Pdef(\drkik3));
)
(
Ndef(\echo2).put(10, \filter -> { arg in, freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var del, par, seq, shift;
	var grow;
	var grownum;
	
	shift = { arg si;
		[
			{
				"shift".debug;
				FreqShift.ar(si, 100.rand * [1,-1].choose) + si / 2;
			},
			{
				"bpf".debug;
				BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01);
			},
			//{
			//	FreqShift.ar(si, 100.rand * [1,-1].choose);
			//},
		].choose.value;
	};
	del = { arg si;
		DelayL.ar(si, 0.8, rrand(0.01,0.8) * \delay.kr(1));
	};
	seq = { arg si, c;
		"seq".debug;
		1.do({
			si = si + del.(si);
		});
		si;
	};
	par = { arg si, c;
		"par".debug;
		c.collect({
			si + del.(si);
		});
	};
	grow = { arg si, count, parent="";
		parent.debug("NOW");
		if(count <= 0) {
			si;
		} {
			if(si.isSequenceableCollection) {
				si.collect({ arg isi, idx;
					isi = [par, seq, shift].choose.(isi, 2);
					grow.(isi, count-1, "%[%]:%".format(parent, idx, count));
				})
			} {
				si = [par, seq, shift].choose.(si, 2);
				grow.(si, count-1, "%:%".format(parent, count));
			}
		}
	};
	sig = in;
	//sig = par.(seq.(sig, 2), 4);
	grownum = 6;
	sig = [ grow.(sig[0] + ( sig[1] * 0.1 ), grownum, "left"), grow.(sig[1] + ( sig[0] * 0.1 ), grownum, "right") ];
	sig.debug("end sig");
	sig = Limiter.ar(sig) * 2;
	sig = sig.softclip / 4.2;
	sig = sig * \poamp.kr(1);

	sig;
});
);


(
[
	[
		['a1','a2'], 
		['b1', 'b2']
	],
	['c1', 'c2']
].flopDeep
)

(
	[\delay, \delay, [\delay,]]
)

(
	~a = Pseq([\delay, [\delay, Pseq([\delay, \bpf]), \delay], \delay]).asStream;
	~a.next;
)

(
	~grow = { arg in, count;
		var block, algo;
		
		block = [
			\delay, \bpf
		].choose;
		algo = [
			\par, \seq
		].choose;
		if(j)
		if(count > 0) {
			
		if(algo == \par) {
			2.collect({
				~grow.(block)
			})
		} {
			\seq -> [ block, ~grow.(count-1) ]
			
		}
	} {
			")
			a":call SendToSC("Quarks.gui;")
	}
	
	}
)

(
	~transform = { 
		var block, algo;
		block = [
			\delay, \delay, \delay, \bpf, \shift
		].choose;
		algo = [
			\par, \seq
		].choose;
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> (block ! [1,4].choose) ++ [\end ]
		}
	};

	~seqcollect = { arg in, fun;
		if(in.isKindOf(Association)) {
			in.key -> in.value.collect(fun)
		} {
			in;
		}
	};

	~transcollect = { arg in;

		~seqcollect.(in, { arg el;
			if(el == \end) {
				~transform.()
			} {
				~transcollect.(el)
			}
		})
	};

	~interpret = { arg sig, in, dict;
		if(in.isKindOf(Association)) {
			switch(in.key, 
				\par, {
					in.value.collect({ arg el;
						~interpret.(sig, el, dict)
					}).mean
				},
				\seq, {
					in.value.do({ arg el;
						sig = ~interpret.(sig, el, dict)
					});
					sig;
				}
			)
		} {
			dict[in].value(sig)
		}
	};

	~gentree = { arg count, trans;
		var acc, ini;
		ini = \seq -> [\end];
		acc = ini;
		count.do {
			acc = ~transcollect.(acc, trans);
		};
		acc;
	}


)
(

	~dict = IdentityDictionary.newFrom([
		\delay, { arg si;
			DelayL.ar(si, 0.8, rrand(0.01,0.8) * [1, 1+0.01.rand] * \delay.kr) + si;
		},
		\shift, { arg si;
			FreqShift.ar(si, 100.0.rand * [1, 1+0.01.rand] * [1,-1].choose * \shift.kr) + si / 1.2;
		},
		\bpf, { arg si;
			BPF.ar(si, exprand(100,10000), 0.5.rand + 0.01) + ( si / 4 );
		},
		\end, { arg si;
			si;
		}
	]);
	~transform = { 
		var block, algo;
		block = [
			\delay, \delay, \delay,
			\delay, \delay, \delay,
			\delay, \delay, \delay, \bpf, \shift,
		].choose;
		algo = [
			\par, \seq
		].choose;
		if(algo == \par) {
			\par -> [2,4].choose.collect({
				\seq -> [ block, \end ]
			})
		} {
			\seq -> ([block] ++ (\end ! [1,2].choose))
		}
	};
	~tree = ~gentree.(3, ~transform);
	~tree.debug("TREE");
	Ndef(\echo2).put(10, \filter -> { arg in;
		var sig;
		var del, shi;
		sig = in;
		del = \delay.kr;
		shi = \shift.kr;

		//sig = HPF.ar(sig, 700);
		sig = LPF.ar(sig, \lpf.kr(17000));
		sig = HPF.ar(sig, \hpf.kr(17));
		sig = ~interpret.(sig, ~tree, ~dict);
		sig = Limiter.ar(sig) * 2;
		sig = sig.softclip / 4.1;
		sig = sig * \poamp.kr(1);
		sig.debug("end sig");
		sig;
	});
)
(
Spec.add(\lpf, \freq.asSpec);
Spec.add(\hpf, \freq.asSpec);
Ndef(\echo2)[0] = Pdef(\drkik2);
Ndef(\echo2)[1] = Pdef(\drkik);
Ndef(\echo2)[0] = Pdef(\vua2);
Ndef(\echo2)[0] = Pdef(\vua);
Ndef(\echo2)[1] = nil;
Ndef(\echo2).put(20, \filter -> { arg in;
	in * \mamp.kr(1)
});
Ndef(\echo2).play;
)

(
Ndef(\echo2).unset(\delay);
Ndef(\echo2).put(30, \set -> Pbind(
	\delay, Pseq([Pexprand(0.0001,0.1,1),Pexprand(0.1,1,1), 0.01,Pexprand(0.0001,1,1)],inf).trace,
	\dur, 1,
	
));
)

Ndef(\echo)[10].value.draw
~x = Ndef(\echo2).objects[10].synthDef.draw
~x
Ndef(\echo)[10].

Ndef(\echo2).play
Ndef(\echo2).fadeTime = 1
Ndef(\echo).stop
Ndef(\echo2).edit
~dict[\bla]
