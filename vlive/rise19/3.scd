

~pdef_channel.();

(
if(Veco(~name).lib.buffer.notNil) {
	Veco(~name).lib.buffer.free;
};
Veco(~name).lib.buffer = Buffer.alloc(s, s.sampleRate * 8.0, 2);
~buffer1 = Veco(~name).lib.buffer;
);

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	RecordBuf.ar(sig, \bufnum.kr(0), \recLevel.kr(0.5), preLevel:\preLevel.kr(0.5));
	sig = PlayBuf.ar(2, \bufnum.kr(0));
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\shift2, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = PlayBuf.ar(2, \bufnum.kr(0), doneAction:2);
	sig = FreqShift.ar(sig, \freqshift.kr([-100,100]));
	//sig = Limiter.ar(sig, 0.5);
	RecordBuf.ar(sig, \bufnum.kr(0), recLevel:\recLevel.kr(0.5), preLevel:\preLevel.kr(0.5));
	//sig = PlayBuf.ar(2, \bufnum.kr(0));
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\shift, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = PlayBuf.ar(2, \bufnum.kr(0), doneAction:2);
	sig1 = sig;
	sig = FreqShift.ar(sig, \freqshift.kr([-100,100]));
	sig = SelectX.ar(\mix.kr(0.5), [sig1, sig]);
	sig = Limiter.ar(sig, 0.5);
	sig = sig * \postamp.kr(0.1);
	//RecordBuf.ar(sig, \bufnum.kr(0), recLevel:\recLevel.kr(0.5), preLevel:\preLevel.kr(0.0));
	RecordBuf.ar(sig, \bufnum.kr(0), recLevel:\recLevelx.kr(1.0), preLevel:\preLevelx.kr(0.0));
	//sig = PlayBuf.ar(2, \bufnum.kr(0));
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\echo, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = PlayBuf.ar(2, \bufnum.kr(0), doneAction:2);
	sig = CombL.ar(sig, \maxdelay.kr(1/2/~t), \delay.kr(1/2/~t), \decay.kr(2));
	sig = Limiter.ar(sig, 0.5);
	RecordBuf.ar(sig, \bufnum.kr(0), recLevel:\recLevel.kr(0.5), preLevel:\preLevel.kr(0.5));
	//sig = PlayBuf.ar(2, \bufnum.kr(0));
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\play, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = PlayBuf.ar(2, \bufnum.kr(0), doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\lower, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = PlayBuf.ar(2, \bufnum.kr(0), doneAction:2);
	sig = sig * \fac.kr(8/10);
	RecordBuf.ar(sig, \bufnum.kr(0), recLevel:\recLevel.kr(0.5), preLevel:\preLevel.kr(0.5));
	//sig = PlayBuf.ar(2, \bufnum.kr(0));
	Out.ar(out, sig);
}).add;

SynthDef(~name+++\limiter, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = PlayBuf.ar(2, \bufnum.kr(0), doneAction:2);
	sig = Limiter.ar(sig, \vol.kr(0.5));
	RecordBuf.ar(sig, \bufnum.kr(0), recLevel:\recLevel.kr(0.5), preLevel:\preLevel.kr(0.5));
	//sig = PlayBuf.ar(2, \bufnum.kr(0));
	Out.ar(out, sig);
}).add;
);

(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, 
	~dPdef.(~name+++\macro, 
		\preLevel, \unipolar,
		\recLevel, \unipolar,
	) <>
	
	Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\bufnum, Veco(~name).lib.buffer,
	\isRest, Veco(~name).isrest,
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

~macro1 = Pdef(~name+++\macro);

// END

~set_macro.(\k1, Pdef(~name+++\macro), \preLevel)
~set_macro.(\k2, Pdef(~name+++\macro), \recLevel)

Veco(~name).lib.buffer.clear
