
Veco(~name).lib.fxquant = 1/2;
Ndef(~name+++\fx).quant = Veco(~name).lib.fxquant;

Ndef(~name+++\fx, { arg ffreq=300, rq=0.3, choose=0, freqshift=40, time=2, stutter=2;
	var name = ~name;
	var in = InFeedback.ar(BusDef(name+++\fx),2);
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
	//sig1 = RLPF.ar(sig, ffreq, rq);
	sig1 = sig;
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

