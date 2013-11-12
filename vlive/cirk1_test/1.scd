~name = '1';

(
SynthDef(~name, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig1 = LFSaw.ar(freq * 1 + (0.04 * [1,-1]));
	sig2 = LFSaw.ar(freq * 0.99 );
	sig3 = LFSaw.ar(freq * 1 );
	sig = sig1 + sig2 + sig3;
	sig = (sig*50).tanh;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

~newfx.(\fx);
Veco(~name).make_mixer;
~num_beats = 1;

//(
//Ndef(~name+++\fx).isource= { arg ffreq=300, rq=0.3, choose=1, freqshift=40, time=2;
//	var in = In.ar(BusDef(~name+++\fx),2);
//	var sig;
//	var sig1,sig2,sig3,sig4,sig5;
//	var ramp;
//	sig = in;
//	sig1 = RLPF.ar(sig, ffreq, rq);
//	ramp = Sweep.kr(Impulse.kr(1/time), 1/time * freqshift) * -1;
//	sig2 = FreqShift.ar(sig, ramp);
//	sig = SelectX.ar(choose, [sig1, sig2]);
//	sig;
//};
//);

Ndef(~name+++\fx).quant=4;

(
Ndef(~name+++\fx, { arg ffreq=300, rq=0.3, choose=1, freqshift=40, time=2, stutter=2;
	var in = In.ar(BusDef(~name+++\fx),2);
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
Ndef(~name+++\lfo1, { arg freq=4, base=2100, choose=0, loval=5, hival=1000, time=1; 
	Select.kr(choose, [
		SinOsc.kr(freq).range(5,base), 
		//Line.kr(loval, hival, time)
		Sweep.kr(Impulse.kr(1/time), 1/time) * base + 50,
		//EnvGen.kr(Env([0,1,0],[time,0]).circle, 1),
	])
});
);


(
if(Pdef(~name +++ \pre).source.isNil) { Pdef(~name +++ \pre, Pbind()) };
Pdef(~name, Pdef(~name +++ \pre) <> Pbind(
	\instrument, ~name,
	\degree, Pseq([0],inf),
	\isRest, Veco(~name).isrest,
	\out, BusDef(~name+++\fx),
	\dur, 1/4,
	\amp, 0.1 * Pkey(\amp),
) <> Veco(~name).mixer)
);

// END

Ndef(~name+++\fx).play
Ndef(~name+++\fx).quant
