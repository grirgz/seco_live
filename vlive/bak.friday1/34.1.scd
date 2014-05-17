(
Ndef(~name+++\fx).put(0, {
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(~name+++\fx), 2);
	sigin;
});
Ndef(~name+++\freqlfo, { arg fmfreq=8, fbase=7500, range=0.8;
	SinOsc.ar(fmfreq) * range * fbase + fbase;
});
Ndef(~name+++\freqlfo).quant = 2;
Ndef(~name+++\fx).map(\ffreq, Ndef(~name+++\freqlfo));
//Ndef(~name+++\fx).put(100, \filter -> { arg in, maxdelaytime=(t), delaytime=(t/2), decaytime=0.1;
Ndef(~name+++\fx).put(100, \filter -> { arg in, ffreq=300, rq=0.3;
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	sig = in;
	sig1 = RLPF.ar(sig, ffreq, rq);
	//sig1 = RLPF.ar(sig, 7000, rq);

	sig1;
});
);

Veco(~name).lib.macros = ~ndef_to_macros.(~name+++\fx) ++ [ 
	[Ndef(~name+++\freqlfo), \fmfreq, \lofreq.asSpec],
	[Ndef(~name+++\freqlfo), \fbase, \freq.asSpec],
	[Ndef(~name+++\freqlfo), \range, \unipolar.asSpec],

]; 

// END

	\lofreq.asSpec
Ndef(~name+++\fx).clear

(
Ndef(~name+++\fx, { arg mix=0.5; 
	var sigin, sig;
	sigin = InFeedback.ar(BusDef(~name+++\fx), 2);
	sigin;
});
Ndef(~name+++\fx).put(100, \filter -> { arg in, maxdelaytime=(t), delaytime=(t/2), decaytime=0.1;
	CombN.ar(in, maxdelaytime, delaytime, decaytime) + in;
});
)

Library.put(~name+++\fx, { arg ffreq=300, rq=0.3, choose=0, freqshift=40, time=2, stutter=2;
	var in = In.ar(BusDef(name+++\fx),2);
	var sig;
	var sig1,sig2,sig3,sig4,sig5;
	var ramp;
	var buf = LocalBuf(2*s.sampleRate, 2);
	var buf2 = LocalBuf(2*s.sampleRate, 2);
	var rate;
	var choosetrig, choosetrig2;
	var env;
	var stuttrig;
	var recordtrig;
	sig = in;
	sig1 = RLPF.ar(sig, ffreq, rq);
	ramp = Sweep.kr(Impulse.kr(1/time), 1/time * freqshift) * -1;
	//sig2 = FreqShift.ar(sig, ramp);
	stuttrig = Impulse.kr(stutter);
	choosetrig = choose > 0;
	//choosetrig2 = Trig1.kr(choose > 0);

	//recordtrig = choosetrig + stuttrig;
	recordtrig = Impulse.kr(2);
	//recordtrig = Select.kr(choose, [0, choosetrig, recordtrig + Trig1.kr(choosetrig)]);
	recordtrig = recordtrig + Trig1.kr(choosetrig);
	//RecordBuf.ar(sig, buf, loop:1, trigger:recordtrig);
	RecordBuf.ar(sig, buf, loop:1, trigger:choosetrig);
	RecordBuf.ar(sig, buf2, loop:1, trigger:recordtrig);
	//rate = 1-Sweep.kr(Impulse.kr(1/time), 1/time * 0.1); 
	//choosetrig = Impulse.kr(1/time);
	rate = EnvGen.kr(Env([1,1,0.7],[0,time]), choosetrig);
	sig2 = PlayBuf.ar(2, buf, rate, choosetrig, loop:1);

	env = EnvGen.kr(Env([0,1,1,0],[0.001, 1/stutter, 0.001]), stuttrig);
	sig3 = PlayBuf.ar(2, buf2, 1, stuttrig, 0, loop:1) * env;

	sig = Select.ar(choose, [sig1, sig2, sig3]);
	//sig = sig2;
	sig;
});
