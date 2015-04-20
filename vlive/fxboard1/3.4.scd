
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;
	var freq,freq2;
	var in;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var bufnum = LocalBuf(s.sampleRate * 4,2);
	var bufgate, stuttrig, choosetrig, recordtrig;
	var attack=0.01, decay=0.01, stutter;
	var env;

	bufnum.clear;
	in = InFeedback.ar(\inbus.kr(BusDef(\in1, \audio)), 2); 
	sig = in;
	in.debug("in");
	sig = sig * 1;
	//Amplitude.ar(sig).poll;
	//sig = SinOsc.ar(200);
	
	bufgate = Duty.kr(1/8, 0, Dseq([
		0,0,0,0,
		0,1,0,1,
		0,0,0,0,
		1,0,1,1,
	],inf));
	bufgate = \bufgate.kr(0);
	choosetrig = bufgate > 0;
	stutter = Duty.kr(1/4, 0, Dseq(1/[
		8,8,
		8,8,
		4,4,
		4,4,
		4,4,
		93/2,93/2,
	],inf));
	stutter = 1 / \stutter.kr(4);
	stuttrig = TDuty.ar(stutter, choosetrig + Changed.kr(stutter), 1);
	recordtrig = Trig1.kr(choosetrig, 0.01);
	env = EnvGen.ar(Env([0,1,1,0],[attack, stutter-attack-decay, decay]), stuttrig);
	
	RecordBuf.ar(sig, bufnum, 0, 1, 0, run:1,loop:0,trigger: recordtrig,doneAction:0);
	sig1 = PlayBuf.ar(2, bufnum, rate:\rate.kr(1), trigger:stuttrig,startPos:0, loop:0) * env;
	sig1 = sig1 * 1.2;
	sig = SelectX.ar( bufgate.lag(0.01), [sig, sig1]);
	

	//sig = sig * 4;
	sig.debug("sig");
	sig = sig * \xamp.kr(1);
	sig = SelectX.ar(\mix.kr(0),[in, sig]);
	amp = amp * \gain.kr(1);
	//sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).mean;
	sig;
});

// END

Ndef(~name+++\fx).set(\lpf, 100)

BusDef(\in1).getSynchronous
BusDef(\in1).set(0)

Ndef(~name+++\fx).get(\inbus)
~name
