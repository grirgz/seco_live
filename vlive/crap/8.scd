(

	Pdef(\bla, Pbind(
		\dur, Pwhite(0.1, 0.5, 10),
		\freq, Pwhite(40,100.0),
		\sustain, Prout({ arg in;
			var total = 20;
			
			while({total > 0}) {
				in = total.yield;
				total = total - in[\dur];
			};

		}).trace,
		\amp, 0.5,
	)).play

)
)
Pdiff



(
play {
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
	).tanh * 0.3
}
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

2**13
2**4
(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	//var t = PulseCount.ar(Impulse.ar(8e3 * SinOsc.kr(1).range(0.8,1.2)));
	var t = PulseCount.ar(Impulse.ar(2**13));
	var mod = LFSaw.kr(2**4).range(0.8,1.2);
	var amod = SinOsc.ar(9800);
	var arr;
	var sig1, sig2;
	var sig;
	mod = SinOsc.kr(1/2).range(0.1,1.2);
	sig1 = HPF.ar(
		(
			(t << [2,1,4]) & (t >> 8).fold2(t % 256 ) |
			((t << 4) & (t >> 8).fold2(t % [2,4,8,16] ))
			
		).fold2(256) / 256
		, 80 
	).distort * 1;

	sig2 =  sig1 | BPF.ar(
		(
			(t >> 1) & (t *8) |
			(t >> [1,2,4]) & (t << [4 *t,8])
		) & 256 
		, 4500, 0.8);
	sig2 = sig2 * 0.01;
	sig2;
	sig1;
	sig = sig2 | sig1 + sig1;
	sig = sig2;
	//sig = sig2;
	arr = [8000,700,50,1200];
	arr = SelectX.kr( LFTri.kr(1/4 * XLine.kr(1,100,10)).range(0,1) , [arr, arr.scramble] );
	sig = RLPF.ar(sig, arr * mod, 0.9);
	sig = sig * 2.1;
	Splay.ar(sig, spread, amp, pan);
}).play;
)
Ndef(\bits).quant = 1
Ndef(\bits).fadeTime = 0.5;

Pdef(\plop).quant = 1
Pdef(\plop).stop

(
Pdef(\plop, Pbind(
	\instrument, \default,
	\degree, Pseq([0,2,4,1,2,3],inf),
	\dur, 1,
	\legato, 0.1,
	\amp, 0.9
)).play;
);

TempoClock.default.tempo

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	//var t = PulseCount.ar(Impulse.ar(8e3 * SinOsc.kr(1).range(0.8,1.2)));
	var t = PulseCount.ar(Impulse.ar(2**13));
	var mod = LFSaw.kr(2**4).range(0.8,1.2);
	var amod = SinOsc.ar(9800);
	var arr;
	var sig1, sig2;
	var sig;
	sig2 = 0;
	mod = SinOsc.kr(1/2).range(0.1,1.2);
	//t = Phasor.ar(0,10,1,10e10);
	t = LPF.ar(t,1);
	sig1 = HPF.ar(
		(
			((t << 15) % (t / 45)) + (t*2)
		) % 256
		, 80 
	) * 0.01;

	sig2 = sig2 * 0.001;
	sig2;
	sig1;
	sig = sig2 | sig1 + sig1;
	sig = sig1;
	//sig = sig2;
	arr = [8000,700,50,1200];
	//arr = SelectX.kr( LFTri.kr(1/4 * XLine.kr(1,100,10)).range(0,1) , [arr, arr.scramble] );
	//sig = RLPF.ar(sig, arr * mod, 0.9);
	sig = sig * 0.4;
	Splay.ar(sig, spread, amp, pan);
}).play;
)



(
Ndef(\bits, {
	var t = PulseCount.ar(Impulse.ar(8e3));
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	HPF.ar(
		(
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
		) % 256
		, 20
	) * 0.002
}).play;
)

(
Ndef(\bits, {
	var t = PulseCount.ar(Impulse.ar(8e3));
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	t = LPF.ar(t, 1);
	HPF.ar(
		(
			((t * 15) & (t >> 5)) wrap2:
			((t * 5) + (t >> [3, 4])) fold2:
			((t * 2) & (t >> 9)) fold2:
			((t * 8) & (t >> 11))
		) % 256
		, 20
	) * 0.002
}).play;
)



(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(7e3));
	var sig;
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	var u = PulseCount.ar(Impulse.ar(5e3));
	t = LPF.ar(t, 1);
	sig = HPF.ar(
		(
			((t * 1/2) | (tan(t/1000) * 100000)) & ( t >> 2 ) round: 0.11 | (u >> 2 | t)
		) % 256
		, 20
	) * 0.002;
	Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(7e3));
	var sig;
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	var u = PulseCount.ar(Impulse.ar(5e3));
	t = LPF.ar(t, 1);
	sig = HPF.ar(
		(
			(u * 4) << 4 & (t >> [4,2]) | ((t * [7,4]) & (t * [4,4]))
		) % 256
		, 20
	) * 0.002;
	Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(7e3));
	var sig;
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	var u = PulseCount.ar(Impulse.ar(5e3));
	t = LPF.ar(t, 1);
	sig = HPF.ar(
		(
			t * 9 | (t / 100) & ((t/50) | (t/15) | (t/485))
		) % 256
		, 20
	) * 0.002;
	Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(7e3));
	var sig;
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	var u = PulseCount.ar(Impulse.ar(5e3));
	t = LPF.ar(t, 1);
	sig = HPF.ar(
		(
			//(t * 9) & (t * 8.77).round(100*SinOsc.ar(1).range(0.1,1))
			(t * 9) & (t * 8.77).round(t.fold2(10000) >> 2) & t.clip(400.5)
		) % 256
		, 20
	) * 0.002;
	sig = Greyhole.ar(sig, 0.002, 0.5, 0.02);
	Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(7e3));
	var sig;
	//t = SelectX.ar( MouseX.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	var u = PulseCount.ar(Impulse.ar(5e3));
	t = LPF.ar(t, 1);
	sig = HPF.ar(
		(
			(t * 9) & (t * 8.77).round(100|SinOsc.ar([1.2,1]).range(0.1,1)) & (t >> 2) | (t >> 8)
			//(t * 9) & (u >> 4) & t.round([10,100]) & (t & MouseX.kr(0.1,148)) | (u * sqrt(t)) & (t & MouseX.kr(0.1,148))
		) % 256
		, 20
	) * 0.002;
	//sig = FreeVerb2.ar(sig[0], sig[1]);
	sig = Greyhole.ar(sig, 0.2, 0.5, 0.2);
	Splay.ar(sig, spread, amp, pan);
}).play;
)


(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(7e3));
	var sig;
	//t = SelectX.ar( 1, [t, Lag.ar(t,MouseY.kr(0.001,10))] );
	//t = Lag.ar(t, 1/1000);
	var u = PulseCount.ar(Impulse.ar(5e3));
	t = SelectX.ar( MouseY.kr(0,1), [t, LPF.ar(t,MouseY.kr(0.001,10))] );
	t = LPF.ar(t, 1);
	sig = HPF.ar(
		(
			(
				(t * 9) & (t * 8.77).round(100|SinOsc.ar([1.2,1]).range(0.1,1)) & (t >> 2) | (t >> 8)
				//(t * 9) & (u >> 4) & t.round([10,100]) & (t & MouseX.kr(0.1,148)) | (u * sqrt(t)) & (t & MouseX.kr(0.1,148))
			) + (

				(t * 9) & (u >> 4) & t.round([10,100]) & (t & MouseX.kr(0.1,148)) | (u * sqrt(t)) & (t & MouseX.kr(0.1,148))
			)
		) % 256
		, 20
	) * 0.002;
	//sig = FreeVerb2.ar(sig[0], sig[1]);
	sig = Greyhole.ar(sig, MouseY.kr(0.02,2), 0.5, MouseY.kr(0.02,2));
	Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, {
	var t = PulseCount.ar(Impulse.ar(8e3));
	var sig = HPF.ar(
		(
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2;
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	sig = Greyhole.ar(sig, sig, 0.5, sig);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3));
	var arr;
	var sig = HPF.ar(
		(
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2;
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//arr = ({ |x| var y; x=x+1.0; y = SinOsc.kr(x.rand).range(0.2,0.01); y }!10);
	arr = ({ |x| var y; x=x+1.0; y = XLine.kr(0.4, 0.1.rand + 0.001, x**3 / 50); y }!10);
	arr.postln;
	arr.do { arg val;
		sig = CombL.ar(sig, 0.4, val, 0.7);
	};
	//sig = CombL.ar(sig, 0.4, arr, 4.1);
	sig = Limiter.ar(sig, 1.0, 0.01);
	sig = sig * 1.1;
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3));
	var arr;
	var mx;
	var my;
	var sig2;
	var mix;
	var sig = HPF.ar(
		(
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2;
	sig2 = HPF.ar(
		(
			((t * 15) & (t >> 5)) 
		) % 140
		, 20
	) * 0.2;
	mx = MouseX.kr(0,1);
	my = MouseY.kr(0,1);
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//arr = ({ |x| var y; x=x+1.0; y = SinOsc.kr(x.rand).range(0.2,0.01); y }!10);
	//arr = ({ |x| var y; x=x+1.0; y = XLine.kr(0.4, 0.1.rand + 0.001, x**3 / 50); y }!10);
	arr = ({ |x| var y; x=x+1.0; y = CuspN.ar(4.4  , 0.1.rand + 0.001, x**3 / 50); y.abs/(mx*55+1) }!10);
	mix = ({ |x| var y; x=x+1.0; y = x; y.abs/(my*50+1) }!10);
	arr.postln;
	sig = sig | sig2;
	sig = CombL.ar(sig, 0.4, sig2.abs.lag(0.1),0.8) | sig;
	arr.do { arg val, x;
		//sig = sig + DelayC.ar(sig, 0.4, val);
		sig = SelectX.ar(mix, [sig, DelayC.ar(sig, 0.4, val)]);
		sig = SelectX.ar(mix, [FreqShift.ar(sig, x-4*10), sig]);
		//sig = sig | sig2 % (x+1);
		//sig = sig fold2: 0.5;
	};
	//sig = CombL.ar(sig, 0.4, arr, 4.1);
	sig = Limiter.ar(sig, 1.0, 0.01);
	sig = sig * 0.4;
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3));
	var arr;
	var mx;
	var my;
	var sig2;
	var mix;
	var size = 10;
	var sig = HPF.ar(
		(
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2;
	sig2 = HPF.ar(
		(
			((t * 15) & (t >> 5)) 
		) % 140
		, 20
	) * 0.2;
	mx = MouseX.kr(0,1);
	my = MouseY.kr(0,1);
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//arr = ({ |x| var y; x=x+1.0; y = SinOsc.kr(x.rand).range(0.2,0.01); y }!10);
	//arr = ({ |x| var y; x=x+1.0; y = XLine.kr(0.4, 0.1.rand + 0.001, x**3 / 50); y }!10);
	sig = sig | sig2;
	//sig = CombL.ar(sig, 0.4, sig2.abs.lag(0.1),0.8) | sig;
	size.do { arg x;
		var xx = x+1;
		var xs = x/size;
		sig = sig + DelayC.ar(sig, 0.4, xs*mx+0.001+ (CuspN.ar(1).abs/10));
		//sig = SelectX.ar(xs**(mx*4+0.001), [sig, DelayC.ar(sig, 0.4, x)]);
		//sig = SelectX.ar((1-xs)**(mx*4+0.001), [FreqShift.ar(sig, x-4*(my*1)), sig]);
		//sig = sig | sig2 % (x+1);
		//sig = sig fold2: 0.5;
	};
	//sig = CombL.ar(sig, 0.4, arr, 4.1);
	sig = Limiter.ar(sig, 1.0, 0.01);
	sig = sig * 0.4;
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
}).play;
)

10.collect { arg x; (x/10)**4 }

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3));
	var arr;
	var mx;
	var my;
	var sig2;
	var mix;
	var size = 10;
	var sig = HPF.ar(
		(
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2;
	sig2 = HPF.ar(
		(
			((t * 15) & (t >> 5)) 
		) % 140
		, 20
	) * 0.2;
	mx = MouseX.kr(0,1);
	my = MouseY.kr(0,1);
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//arr = ({ |x| var y; x=x+1.0; y = SinOsc.kr(x.rand).range(0.2,0.01); y }!10);
	//arr = ({ |x| var y; x=x+1.0; y = XLine.kr(0.4, 0.1.rand + 0.001, x**3 / 50); y }!10);
	sig = sig | sig2;
	//sig = CombL.ar(sig, 0.4, sig2.abs.lag(0.1),0.8) | sig;
	size.do { arg x;
		var xx = x+1;
		var xs = x/size;
		var mod = SinOsc.kr(xs*mx).range(0,1) fold2: LFTri.kr(10.2*mx).range(0,1) round: LFSaw.kr(0.12).range(0.1,100);
		//sig = FreqShift.ar(sig, xs-0.5 * (mx*800)) + DelayC.ar(sig, 0.01,0.01);
		sig = sig+ DelayC.ar(sig, 0.01,xs-0.5  * mod *  (mx*10));
		//sig = sig + DelayC.ar(sig, 0.4, xs*mx+0.001+ (CuspN.ar(1).abs/10));
		//sig = SelectX.ar(xs**(mx*4+0.001), [sig, DelayC.ar(sig, 0.4, x)]);
		//sig = SelectX.ar((1-xs)**(mx*4+0.001), [FreqShift.ar(sig, x-4*(my*1)), sig]);
		//sig = sig | sig2 % (x+1);
		//sig = sig fold2: 0.5;
	};
	sig = CombL.ar(sig, 0.4, 0.04, 4.1) + sig;
	sig = Limiter.ar(sig, 1.0, 0.01);
	sig = sig * 0.4;
	sig = Splay.ar(sig, spread, amp, pan);
	sig;
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3 * MouseX.kr(0,2)+100));
	var sig = HPF.ar(
		(
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2;
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	sig = Greyhole.ar(sig, sig, 0.5, sig);
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3 * MouseX.kr(0,2)+100));
	var sig = HPF.ar(
		(
			((t * 15) & (t >> 5)) |
			((t * 5) & (t >> [3, 4])) |
			((t * 2) & (t >> 9)) |
			((t * 8) & (t >> 11))
			- 3 % 256
		) / 127-1 * 3
		, 20
	).distort * 0.2;
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//sig = Greyhole.ar(sig, sig, 0.5, sig);
	sig = RLPF.ar(sig, MouseY.kr(30,10000)*[1.1,1.2,1.3],0.3);
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3 ));
	var arr;
	var sig = HPF.ar(
		(
			((t * [4 << (t/1000 % 4),15]) & (t >> [2,5]))  & ( t * 14 )
		) % 427 / 100
		, 20
	) * 0.2;
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//sig = Greyhole.ar(sig, sig, 0.5, sig);
	arr = (-4..4)/8 + 0.5 * MouseX.kr(0,1);
	sig = RLPF.ar(sig, MouseY.kr(30,10000)*(arr+1)+100,0.3);
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
)
(-4..4)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3 ));
	var arr;
	var sig;
	t = t.lag(0.001);
	sig = HPF.ar(
		(
			((t * [4 << (t/1000 % 4),15]) & (t >> [2,5]))  & ( t * 14 )
			| ((t * 10) & (t >> [11,10]))
		) % 256 / 200
		, 20
	) * 0.2;
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//sig = Greyhole.ar(sig, sig, 0.5, sig);
	arr = (-4..4)/8 + 0.5 * MouseX.kr(0,1);
	sig = 10.collect({ arg x;
		var isig;
		var igate;
		var trig;
		trig = Impulse.kr(1);
		trig = DelayL.kr(trig, 0.4,x/10);
		igate = Trig1.kr(trig,0.1);
		isig = RLPF.ar(sig, TRand.kr(100,17000, trig),0.3);
		isig = isig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.41),igate,doneAction:0);
		isig = isig + DelayL.ar(isig, 0.001,0.001);
	});
	sig = sig * 0.5;
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3 ));
	var arr;
	var sig;
	t = t.lag(0.1);
	
	sig = HPF.ar(
		(
			t * 10 * CuspN.ar(2).abs | ( t << 4 * (SinOsc.kr([1,1.2]).abs % 0.2) )
		) % 256 / 200
		, 20
	) * 0.2;
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//sig = Greyhole.ar(sig, sig, 0.5, sig);
	arr = (-4..4)/8 + 0.5 * MouseX.kr(0,1);
	sig = 10.collect({ arg x;
		var isig;
		var igate;
		var trig;
		trig = Impulse.kr(1);
		trig = DelayL.kr(trig, 0.4,x/10);
		igate = Trig1.kr(trig,0.1);
		isig = RLPF.ar(sig, TRand.kr(100,17000, trig),0.3);
		isig = isig * EnvGen.ar(Env.adsr(0.1,0.1,1,0.41),igate,doneAction:0);
		isig = isig + DelayL.ar(isig, 0.001,0.001);
	});
	sig = sig * 0.5;
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3 ));
	var arr;
	var sig;
	var f;
	t = t.lag(0.1);
	f = 100;

	
	//sig = LFSaw.ar(f*[2,3,7] + ( SinOsc.kr([f/10,f*42])*f )) * SinOsc.ar(f/[100,200,150]);
	//sig = SinOsc.ar( SinOsc.ar(1)+1*100 % [f/12,40.2] + f);
	sig = LFSaw.ar( 
		f + 
		( SinOsc.ar([1.3,1])+1*100 round: [f/12,40.2,200] ).lag(0.1)
		+ ( SinOsc.ar([1,1.2,2.3,400])+1*400 wrap2: [f/12,40.2,200] )
		+ ( SinOsc.ar([400])+1*400 fold2: [200] )
		+ ( SinOsc.ar([310])+1*SinOsc.ar([100,0.1])*100 fold2: [10,200] )
		+ ( SinOsc.ar([140])+1%SinOsc.ar([140,0.1])%100 >> [10,2] )
	);
	sig = sig * SinOsc.ar( SinOsc.kr([0.1,0.2,0.3]).abs*2.4 * 
		f + 
		( SinOsc.ar([1.3,1])+1*100 round: [f/12,40.2,200] ).lag(0.1)
		+ ( SinOsc.ar([1,1.2,2.3,400])+1*400 wrap2: [f/12,40.2,200] )
		+ ( SinOsc.ar([400])+1*400 fold2: [200] )
		+ ( SinOsc.ar([310])+1*SinOsc.ar([100,0.1])*100 fold2: [10,200] )
		+ ( SinOsc.ar([140])+1%SinOsc.ar([140,0.1])%100 >> [10,2] )
	);
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//sig = Greyhole.ar(sig, sig, 0.5, sig);
	arr = (-4..4)/8 + 0.5 * MouseX.kr(0,1);
	sig = sig * 0.5;
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
)

(
Ndef(\bits, { arg pan = 0, spread=0.8, amp=0.3;
	var t = PulseCount.ar(Impulse.ar(8e3 ));
	var arr;
	var sig;
	var f;
	t = t.lag(0.1);
	f = 100;

	
	//sig = LFSaw.ar(f*[2,3,7] + ( SinOsc.kr([f/10,f*42])*f )) * SinOsc.ar(f/[100,200,150]);
	//sig = SinOsc.ar( SinOsc.ar(1)+1*100 % [f/12,40.2] + f);
	sig = LFSaw.ar( 
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]).sum.abs* 100 ).round(100) |
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]/0.57).sum.abs* 140 ).round(150) +
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]*2.57).sum.abs* 14 ).round(150) |
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]/[0.74,1.57]).sum.abs* [41,40,54] ) 
		//( LFSaw.kr(0.3).abs* 270 ) +
	);
	sig = sig + LFTri.ar( 0.9878 *
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]).sum.abs* 100 ).round(100) +
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]/0.57).sum.abs* 140 ).round(150) +
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]*2.57).sum.abs* 14 ).round(150) |
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]/[0.74,1.57]).sum.abs* [41,40,54] ) 
		//( LFSaw.kr(0.3).abs* 270 ) +
	);
	sig = sig * SinOsc.ar( 1.0078 *
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]).sum.abs* 100 ).round(110) +
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]/0.57).sum.abs* 140 ).round(150) +
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]*2.57).sum.abs* 14 ).round(150) |
		( LFSaw.kr([0.1,0.2,0.3,0.14,0.1546]/[0.74,1.57]).sum.abs* [41,40,54] ) 
		//( LFSaw.kr(0.3).abs* 270 ) +
	);
	//sig = SinOsc.ar(t/10 % 1000 + 50) ! 2;
	//sig = Greyhole.ar(sig, (t/1000) % 1, 0.5, (t/100) % 1);
	//sig = Greyhole.ar(sig, sig, 0.5, sig);
	arr = (-4..4)/8 + 0.5 * MouseX.kr(0,1);
	sig = Limiter.ar(sig, 1.0, 0.1);
	sig = sig * 0.5;
	sig = Splay.ar(sig, spread, amp, pan);
}).play;
)
