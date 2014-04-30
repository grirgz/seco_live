
~t = t;
Ndef(~name+++\fx, { arg ffreq = 200, freqfac=15, freq=8000, amp=0.1, pan=0, spread=0.8, shift=1, toffset=0, sigmix=0.5;
	//var t = PulseCount.ar(Impulse.ar(2**13), Impulse.kr(1/(512)));
	var t = PulseCount.ar(Impulse.ar(2**13 * ~t), Impulse.kr(1/(64) * ~t));
	var sig;
	var sig1, sig2;
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	//t = LPF.ar(t, 1);
	t = t + toffset;
	//t = t + (2**28);
	sig1 = HPF.ar(
		(
			//t & (t>>19 | (t>>2)) | (t>>8) | (t *8)

				//(sin(log(t)*2) * 18) )
				//( ( (t * [1,2,3,4,5] ) | ( t >> [4,5,6,7,8,9,10] ) ) fold2: ( 70 * [1,1.012,1.25]) )
				//| ( ( (t * [5,2,3,4,1] ) & ( t >> 12 ) ) fold2: ( [4,4.012,4.15]) )
				//& ( ( (t * [5,2,3,4,1] ) | ( t >> 12 ) ))
				//t * ( [11,15,5,21] * SinOsc.kr(1/1).range(0.1,2) )
				//t * 4 | ( t * 18 ) | (t >> 8)
				//| ( t * 9 | ( t * 8 ) | (t >> 4) )
				t * 10 & (t >> 4)
				//( t * [16,8] ) & ( t *5 >> 2 )
				//| ( t *2 >> [2,3,4] )
				//| (LFSaw.ar(4.8).abs * 10000000)
				//& (LFSaw.ar(0.8).abs * 10000000 >> 10)

				//& ((t >> 8) << 4)
				//& ((t * 4) & (t >> (19)))
		) % 256
		, 20
	) * 0.01;
	sig2 = HPF.ar(
		(
			//t & (t>>19 | (t>>2)) | (t>>8) | (t *8)

			t *8
				& (t >> 2)
				| (t >> 4)
				| (t >> 8)
				| (t >> 1)
				//& ((t >> 8) << 4)
				//& ((t * 4) & (t >> (19)))
		) % 256
		, 20
	) * 0.01;
	//sigmix = 0;
	sig = SelectX.ar(sigmix, [sig1, sig2]);
	sig = RLPF.ar(sig, log(ffreq).round(1/2).exp,0.5);
	sig = sig * 0.5;
	sig = Splay.ar(sig, spread, amp, pan);

});
Ndef(~name+++\fx).quant = Pdef.defaultQuant;

// END
Ndef(~name+++\fx).play(0,2);
Ndef(~name+++\fx).stop;
Ndef(~name+++\fx2).play;
Ndef.clear

1031 >> 2
Ndef(~)

log(100).exp
(
MIDIBoard.map(\k1, Ndef(~name+++\fx), \freq, \freq.asSpec);
MIDIBoard.map(\k2, Ndef(~name+++\fx), \freqfac, ControlSpec(0.01,20,\lin, 0,15));
MIDIBoard.map(\k3, Ndef(~name+++\fx), \ffreq, \freq.asSpec);
MIDIBoard.map(\k4, Ndef(~name+++\fx), \shift, ControlSpec(0.01,5,\lin, 0,1));
MIDIBoard.map(\k5, Ndef(~name+++\fx), \sigmix, \unipolar.asSpec);
)
t
Ndef(~name).edit
			((t * freqfac) & (t >> (7*shift)))  |
			((t * freqfac/2) & (t >> (4*shift))) |
			((t * freqfac/4) | (t >> (3*shift))) |


			((t * 4*freqfac) | (t >> (2*shift))) |
			((t * freqfac/2) & (t / (4*shift))) &
			(
				((t * 2) | (t >> (2*shift))) &
				((t * 4) & (t >> (4*shift))) 
			)

			t *2
				& (t >> 4)
				& (t >> 4)
				| (
					(t * 2)
						& (t >> 4)
						& (t >> 18)
				)
				& (
					(t * 4)
						//& (t >> 2)
						| (t >> 1)
				)
				& (
					(t * 2)
						//& (t >> 2)
						& (t >> 1)
				)

(
Ndef(\bits, {
	var t = PulseCount.ar(Impulse.ar(8e3));
	HPF.ar(
		(
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2
}).play;
)

(
Ndef(~name, { arg ffreq = 200, freqfac=15, freq=8000, amp=0.1, pan=0, spread=0.8, shift=1, toffset=0, sigmix=0.5;
	var t = PulseCount.ar(Impulse.ar(8e3));
	var sig;
	sig = HPF.ar(
		(
			//((t * [14,15]) & (t >> 2)) | (t >> [4,8])
			//| ((t * [10,11]) & (t >> 3)) | (t >> [4,8])
			( t * 10 ) & (t >> 4)
			//((t * 5) & (t >> [3, 4])) |
			//((t * 2) & (t >> 9)) |
			//((t * 8) & (t >> 11))
			//- 3 % 256
		) & 256
		, 20
	).distort * 2.8;
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
}).play;
)

(
Pdef(~name, Pbind(
	\instrument, \default,
	\time, Ptime(),
	\degree, Pseq([Ptime()*2 % 10],inf),
	\degree, Pfunc({ arg ev;
		var x = ev[\time];
		var res;
		var mul = 1024;
		//x = x.asFloat+1;
		x = (x*mul);
		x = x.asInteger;
		x.debug("x");
		res = (
			//(x * [10,20]) | (x >> 2) & (x >> 4)
			//(x * [10,20]) | (x >> 2) & (x >> [4,1]) | (x << [1,8])
			(x * [4,6]) & (x >> [1,6])
			//& ((x * [9,24]) | (x >> 2) & (x >> 4))
		);
		res = res / mul;
		res = res % 48;
		res.postln;
	}),
	\isRest, Pseq([
		Pseq([0.5,0.8,0.3,0.7].collect(_.coin))
		
	],inf),
	\lag, [0,0.05],
	\dur, 1/8,
	\amp, 0.1
).trace).play;
);

0.0 bitAnd: 4
4 | 8
4 & 8
4 >> 2

(
Pdef(~name, Pbind(
	\instrument, \default,
	\time, Ptime(),
	\degree, Pseq([Ptime()*2 % 10],inf),
	\degree, Pfunc({ arg ev;
		var x = ev[\time];
		var res;
		var mul = 1024;
		//x = x.asFloat+1;
		x = (x*mul);
		x = x.asInteger;
		x.debug("x");
		res = (
			//(x * [10,20]) | (x >> 2) & (x >> 4)
			//(x * [10,20]) | (x >> 2) & (x >> [4,1]) | (x << [1,8])
			(x * [4,6]) & (x >> [1,6]) & (x >> [1,2])
			//& ((x * [9,24]) | (x >> 2) & (x >> 4))
		);
		res = res / mul;
		res = res % 48;
		res.postln;
	}),
	//\mtranspose, Pseq([0,2],inf).stutter(16),
	\legato, Pwhite(0.2,0.9),
	\isRest, Plazy({
		Pseq([0.02,0.2,0.1,0.2].collect(_.coin))
	}).loop,
	\lag, Ptuple([0,0.05 + Pwhite(0,0.01)]),
	\dur, 1/8,
	\amp, 0.1
).trace).play;
);

(
Pdef(~name, Pbind(
	\instrument, \default,
	\time, Ptime(),
	\degree, Pseq([Ptime()*2 % 10],inf),
	\degree, Pfunc({ arg ev;
		var x = ev[\time];
		var res;
		var mul = 1024 * 2;
		x = (x*mul);
		x = x.asInteger;
		x.debug("x");
		res = (
			//(x * [10,20]) | (x >> 2) & (x >> 4)
			//(x * [10,20]) | (x >> 2) & (x >> [4,1]) | (x << [1,8])
			(x * [4,6]) & (x >> [1,6]) & (x >> [1,2])
			//& ((x * [1,4]) | (x >> 1) | (x >> 4))
		);
		res = res / mul;
		res = res % 48;
		res.postln;
	}),
	//\mtranspose, Pseq([0,1,0,0,4,4,3,3,0,5,Pwhite(0,5) + Pseq([0,0,1,1]),Pwhite(0,5) + [[0,2],[-3,-1]]],inf).stutter(16),
	//\mtranspose, Pseq([Pwhite(0,5) + Pseq([0,0,1,1]),Pwhite(0,5) + Pseq([0,0,-3,-1])],inf).stutter(16),
	\scale, Scale.minor,
	\octave, 3,
	\legato, Pwhite(0.2,0.9),
	\isRest, Plazy({
		Pseq([0.02,0.2,0.1,0.2].collect(_.coin))
	}).loop,
	//\lag, Ptuple([0,0.05 + Pwhite(0,0.01)]),
	\lag, Prand([[0,1/8], [1/8,0], [0,0]],inf) + Ptuple([Pwhite(0,0.01),Pwhite(0,0.01)]),
	\dur, 1/4,
	\amp, 0.1
).trace).play;
);

(
Pdef(~name, Pbind(
	\instrument, \default,
	\time, Ptime(),
	\degree, Pseq([Ptime()*2 % 10],inf),
	\degree, Pfunc({ arg ev;
		var x = ev[\time];
		var res;
		var mul = 1024 * 1024;
		x = (x*mul);
		x = x.asInteger;
		x.debug("x");
		res = (
			//(x * [10,20]) | (x >> 2) & (x >> 4)
			//(x * [10,20]) | (x >> 2) & (x >> [4,1]) | (x << [1,8])
			//( (x * [4,6]) & (x >> [1,6]) ) & (x >> [1,2])
			//| ((x * [1,4]) | (x >> 1) | (x >> 4))
			//((x * 4) | ((1 << 30) - x)) | ( (x *5) & (x >> 8) )
			//((x * 4) & ((1 << 10) - x)) | ( (x *5) & (x >> 8) )
			//((x * 4) & ((1 << 10) - x)) 
			//( ((x * 4) & (x >> 6)) | (( x * 10  ) & (x >> 1)))
			( ((x * 4) & (x >> [2,6])) | (( x * 10  ) & (x >> 4)))
			//| ( ((x * 1) & (x >> 2)) | (( x * 10  ) & (x >> 7)))
			//& ((x * 4) | ((1 << 30) - x)) | ( (x *5) & (x >> 8) )
	
		);
		res = res / mul;
		res = res % (24+12);
		res.postln;
	}),
	\mtranspose, Pseq([0,1,0,0,4,4,2,2,0,5,Pwhite(0,5) + Pseq([0,0,1,1]),Pwhite(0,5) + [[0,2],[-3,-1]]],inf).stutter(16),
	//\mtranspose, Pseq([Pwhite(0,5) + Pseq([0,0,1,1]),Pwhite(0,5) + Pseq([0,0,-3,-1])],inf).stutter(16),
	\scale, Scale.minor,
	\legato, Pwhite(0.2,0.9),
	\octave, 3,
	\octave, Pseq([[3,4],[4,3],[4,4],[3,3],[4,5],[5,4]],inf),
	\isRest, Plazy({
		Pseq([0.02,0.2,0.1,0.2].collect(_.coin))
	}).loop,
	//\lag, Ptuple([0,0.05 + Pwhite(0,0.01)]),
	\lag, Prand([[0,1/8], [1/8,0], [0,0]],inf) + Ptuple([Pwhite(0,0.01),Pwhite(0,0.01)]),
	\dur, 1/4,
	\amp, 0.1
).trace).play;
);

/////////////////////////////////////////////////////////////////

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
	Ndef(\xbus, { arg xbus;
		var x = PulseCount.ar(Impulse.ar(8e3));
		Out.ar(xbus, x);
	});
)
Ndef(\xbus).set(\xbus, BusDef(\xbus, \audio))

(
SynthDef(~name, { arg out=0, gate=1, ffreq = 200, freqfac=15, freq=8000, amp=0.1, pan=0, spread=0.8, shift=1, toffset=0, sigmix=0.5, xbus;
	//var t = PulseCount.ar(Impulse.ar(8e3));
	var t = InFeedback.ar(xbus, 1);
	var sig;
	sig = HPF.ar(
		(
			//((t * [14,15]) & (t >> 2)) | (t >> [4,8])
			//| ((t * [10,11]) & (t >> 3)) | (t >> [4,8])
			//(( t * log(freq) * 8 ) | (t >> 4)) | (t >> 2)
			(t * (freq%[70,79])) & (t >> [4,8,12]) | (t *4)
			//| ( (t * [10,9]) & (t >> [8,9]) )
			//( t * 10 ) & (t >> 2)
			//((t * 5) & (t >> [3, 4])) |
			//((t * 2) & (t >> 9)) |
			//((t * 8) & (t >> 11))
			//- 3 % 256
		) & 256
		, 20
	) * 0.01;
	sig = sig * SinOsc.ar(freq);
	sig = sig * EnvGen.kr(Env.adsr(0.41,0.1,1,1.4),gate,doneAction:2);
	sig = RLPF.ar(sig, ffreq, 0.3);
	sig = Splay.ar(sig, spread, amp, pan);
	//sig = SinOsc.ar(100);

	Out.ar(out, sig);
}).add;
)
BusDef(\xbus)
(
	Ndef(\xbus, { arg xbus;
		var x = PulseCount.ar(Impulse.ar(8e3));
		Out.ar(xbus, x);
	});
Ndef(\xbus).set(\xbus, BusDef(\xbus, \audio));
Pdef(~name, Pbind(
	\instrument, ~name,
	\time, Ptime(),
	\xbus, BusDef(\xbus),
	\degree, Pseq([Ptime()*2 % 10],inf),
	\ffreq, Ptuple([Pwhite(200,15000),Pwhite(200,15000)]),
	\degree, Pfunc({ arg ev;
		var x = ev[\time];
		var res;
		var mul = 1024;
		//x = x.asFloat+1;
		x = (x*mul);
		x = x.asInteger;
		x.debug("x");
		res = (
			//(x * [10,20]) | (x >> 2) & (x >> 4)
			//(x * [10,20]) | (x >> 2) & (x >> [4,1]) | (x << [1,8])
			//( (x * [1,6]) | (x >> [1,2]) ) | (x*2) | (x & 848) | ((t >> [2,4]) & (t << 10))
			(x * [4,6]) & (x >> [1,6]) //| [0, x*8]
			//& ((x * [9,24]) | (x >> 2) & (x >> 4))
		);
		res = res / mul;
		res = res % 48;
		res.postln;
	}),
	//\degree, 40,
	\isRest, Plazy({
		Pseq([0.051,0.1,0.1,0.1].collect(_.coin))
	}).loop,
	\legato, 0.8,
	\isRest, false,
	\scale, Scale.minor,
	\octave, 3,
	\lag, Ptuple([0,0.01 + Pwhite(0,0.01)]),
	\lag, Ptuple([Prand([0,0.125,0.15,0.125,0.01,0.25],inf),Prand([0,0.125,0.15,0.125,0.01,0.25],inf)]),
	\lag, Prand([[0,1/8], [1/8,0], [0,0]],inf),
	\dur, 1/4,
	\amp, 0.1
).trace).play;
);


///////////////////////////////////


(
SynthDef(~name, { arg out=0, gate=1, ffreq = 200, freqfac=15, freq=8000, amp=0.1, pan=0, spread=0.8, shift=1, toffset=0, sigmix=0.5, xbus;
	//var t = PulseCount.ar(Impulse.ar(8e3));
	var t = InFeedback.ar(xbus, 1);
	var sig;
	sig = HPF.ar(
		(
			//((t * [14,15]) & (t >> 2)) | (t >> [4,8])
			//| ((t * [10,11]) & (t >> 3)) | (t >> [4,8])
			//(( t * log(freq) * 8 ) | (t >> 4)) | (t >> 2)
			(t * (freq%[70,79])) & (t >> [4,8,12]) | (t * (freq % 4))
			//| ( (t * [10,9]) & (t >> [8,9]) )
			//( t * 10 ) & (t >> 2)
			//((t * 5) & (t >> [3, 4])) |
			//((t * 2) & (t >> 9)) |
			//((t * 8) & (t >> 11))
			//- 3 % 256
		) & 256
		, 20
	) * 0.01;
	sig = sig * SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.41,0.1,1,1.4)),gate,doneAction:2);
	sig = RLPF.ar(sig, ffreq, 0.3);
	sig = Splay.ar(sig, spread, amp, pan);
	//sig = SinOsc.ar(100);

	Out.ar(out, sig);
}).add;
)
BusDef(\xbus)
(
	Ndef(\xbus, { arg xbus;
		var x = PulseCount.ar(Impulse.ar(8e3));
		Out.ar(xbus, x);
	});
Ndef(\xbus).set(\xbus, BusDef(\xbus, \audio));
Pdef(~name, Pbind(
	\instrument, ~name,
	\time, Ptime(),
	\xbus, BusDef(\xbus),
	\degree, Pseq([Ptime()*2 % 10],inf),
	\adsr, {Prand([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.4,0.1,0.8,0.4) ],
	],inf)} ! 2,
	\pan, Ptuple([Pwhite(-0.5,0.5),Pwhite(-0.5,0.5)]),
	\ffreq, Ptuple([Pwhite(200,15000),Pwhite(200,15000)]),
	\degree, Pfunc({ arg ev;
		var x = ev[\time];
		var res;
		var mul = 1024;
		//x = x.asFloat+1;
		x = (x*mul);
		x = x.asInteger;
		x.debug("x");
		res = (
			//(x * [10,20]) | (x >> 2) & (x >> 4)
			//(x * [10,20]) | (x >> 2) & (x >> [4,1]) | (x << [1,8])
			//( (x * [1,6]) | (x >> [1,2]) ) | (x*2) | (x & 848) | ((t >> [2,4]) & (t << 10))
			(x * [4,6]) & (x >> [1,6]) //| [0, x*8]
			//(1 << 30) - x
			//& ((x * [9,24]) | (x >> 2) & (x >> 4))
		);
		res = res / mul;
		res = res % 48;
		res.postln;
	}),
	//\degree, 40,
	\isRest, Plazy({
		Pseq([0.051,0.1,0.1,0.1].collect(_.coin))
	}).loop,
	\legato, 0.8,
	\isRest, false,
	\scale, Scale.minor,
	\octave, 3,
	\lag, Ptuple([0,0.01 + Pwhite(0,0.01)]),
	\lag, Ptuple([Prand([0,0.125,0.15,0.125,0.01,0.25],inf),Prand([0,0.125,0.15,0.125,0.01,0.25],inf)]),
	\lag, Prand([[0,1/8], [1/8,0], [0,0]],inf),
	\dur, 1/4,
	\amp, 0.1
).trace).play;
);

bitNot(4) >> 32
1 << 30




(
SynthDef(~name, { arg out=0, gate=1, ffreq = 200, freqfac=15, freq=8000, amp=0.1, pan=0, spread=0.8, shift=1, toffset=0, sigmix=0.5, xbus;
	//var t = PulseCount.ar(Impulse.ar(8e3));
	var t = InFeedback.ar(xbus, 1);
	var sig;
	sig = HPF.ar(
		(
			//((t * [14,15]) & (t >> 2)) | (t >> [4,8])
			//| ((t * [10,11]) & (t >> 3)) | (t >> [4,8])
			//(( t * log(freq) * 8 ) | (t >> 4)) | (t >> 2)
			(t * (freq%[70,79])) & (t >> [4,8,12]) | (t * (freq % 4))
			//| ( (t * [10,9]) & (t >> [8,9]) )
			//( t * 10 ) & (t >> 2)
			//((t * 5) & (t >> [3, 4])) |
			//((t * 2) & (t >> 9)) |
			//((t * 8) & (t >> 11))
			//- 3 % 256
		) & 256
		, 20
	) * 0.01;
	sig = sig * SinOsc.ar(freq);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.41,0.1,1,1.4)),gate,doneAction:2);
	sig = RLPF.ar(sig, ffreq, 0.3);
	sig = Splay.ar(sig, spread, amp, pan);
	//sig = SinOsc.ar(100);

	Out.ar(out, sig);
}).add;
)
BusDef(\xbus)
(
	Ndef(\xbus, { arg xbus;
		var x = PulseCount.ar(Impulse.ar(8e3));
		Out.ar(xbus, x);
	});
Ndef(\xbus).set(\xbus, BusDef(\xbus, \audio));
Pdef(~name, Pbind(
	\instrument, ~name,
	\time, Ptime(),
	\xbus, BusDef(\xbus),
	\degree, Pseq([Ptime()*2 % 10],inf),
	\adsr, {Prand([
		[ Env.adsr(0.1,0.1,0.8,0.1) ],
		[ Env.adsr(0.4,0.1,0.8,0.4) ],
	],inf)} ! 2,
	\pan, Ptuple([Pwhite(-0.5,0.5),Pwhite(-0.5,0.5)]),
	\ffreq, Ptuple([Pwhite(200,15000),Pwhite(200,15000)]),
	\degree, Pfunc({ arg ev;
		var x = ev[\time];
		var res;
		var mul = 1024 * 1024;
		//x = x.asFloat+1;
		x = (x*mul);
		x = x.asInteger;
		x.debug("x");
		res = (
			//(x * [10,20]) | (x >> 2) & (x >> 4)
			//(x * [10,20]) | (x >> 2) & (x >> [4,1]) | (x << [1,8])
			//( (x * [1,6]) | (x >> [1,2]) ) | (x*2) | (x & 848) | ((t >> [2,4]) & (t << 10))
			(x * [4,6]) & (x >> [1,6]) //| [0, x*8]
			//(1 << 30) - x
			//& ((x * [9,24]) | (x >> 2) & (x >> 4))
		);
		res = res / mul;
		res = res % 48;
		res.postln;
	}),
	//\degree, 40,
	\isRest, Plazy({
		Pseq([0.051,0.1,0.1,0.1].collect(_.coin))
	}).loop,
	\legato, 0.8,
	\isRest, false,
	\scale, Scale.minor,
	\octave, 3,
	\lag, Ptuple([0,0.01 + Pwhite(0,0.01)]),
	\lag, Ptuple([Prand([0,0.125,0.15,0.125,0.01,0.25],inf),Prand([0,0.125,0.15,0.125,0.01,0.25],inf)]),
	\lag, Prand([[0,1/8], [1/8,0], [0,0]],inf),
	\dur, 1/4,
	\amp, 0.05
).trace).play;
);

bitNot(4) >> 32
1 << 30
Pdef(~name).xstop(10)
Pdef(~name).stop
