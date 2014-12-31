(
~buf ? { ~buf = Buffer.alloc(s, s.sampleRate * 4,2); };

Ndef(\pelufx).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;
	var bufnum = LocalBuf(s.sampleRate * 4,2);
	//var bufnum = ~buf.bufnum;
	var bufgate, stuttrig, choosetrig, recordtrig;
	var attack, decay, stutter;
	var env;
	bufnum.clear;
	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;
	sig = SinOsc.ar(freq);
	sig = sig.flat;
	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);
	sig = Limiter.ar(sig, (-1).dbamp);

	sig1 = sig * sig.clip2(0.1);
	sig = SelectX.ar(SinOsc.kr(0.1/(1..sig.size)+0.001+(pi/14)).range(0.5,1) , [sig, sig1]);
	sig = sig * SinOsc.kr(1/(1..sig.size)+(pi/100)).range(0,1);
	//sig = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr((1..sig.size).normalizeSum).range(1,1111), mass: 17.05501);



	sig.debug("sig");
	amp = amp * \gain.kr(1);
	//sig = Splay.ar(sig, \spread.kr(0.8)+ LFNoise1.kr(1/12,mul:0.2), amp, \pan.kr(0)+ LFNoise1.kr(1/17,mul:0.1));
	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;

	bufgate = Duty.kr(1/2, 0, Dseq([
		0,0,0,0, 0,0,0,1,
		0,1,0,0, 0,0,0,0,
		0,0,0,1, 0,0,0,1,
		0,1,1,1, 0,0,1,0,
		1,
	],inf));
	choosetrig = bufgate > 0;
	stutter = DC.kr(1/4);
	stutter = Duty.kr(1, 0, Dseq(1/[
		2,16,4,8,6
	],inf));
	//stuttrig = TDuty.ar(stutter * SinOsc.kr(1/4).range(1,4), choosetrig + Changed.kr(stutter), 1);
	stuttrig = TDuty.ar(stutter , choosetrig + Changed.kr(stutter), 1);
	//stuttrig = Impulse.kr( SinOsc.kr(1).range(4,12) );
	//stuttrig = TDuty.ar(1/4, choosetrig, 1);
	recordtrig = Trig1.kr(choosetrig, 0.01);

	sig = sig.flop.sum;
	sig.debug("plop");
	attack = 0.01;
	decay = 0.01;
	env = EnvGen.ar(Env([0,1,1,0],[attack, stutter-attack-decay, decay]), stuttrig);
	//env.poll;
	RecordBuf.ar(sig, bufnum, 0, 1, 0, run:1,loop:1,trigger: recordtrig,doneAction:0);
	sig1 = PlayBuf.ar(2, bufnum, rate:1/2, trigger:stuttrig,startPos:0, loop:1) * env;
	sig1 = sig1 * 1.2;
	sig = SelectX.ar( bufgate.lag(0.01)/1.2, [sig, sig1]);

	sig1 = sig.round(0.1 * SinOsc.kr(1/7).range(0,1));
	freq.debug("freq");
	sig1 = BPF.ar(sig1 ! freq.flat.size, freq.flat, 0.1).sum;
	sig1.debug("sig1");
	sig = SelectX.ar( Duty.kr(1, 0, Dseq([
		0,1,0,0, 1,1,0,0,
		1,0,1,0, 0,0,1,0,
		1
	],inf)).lag(0.41)/1.2, [sig, sig1]);


	sig;
}).play;
)


(
Ndef(\sandlizard).fadeTime = 0.2;
Ndef(\sandlizard).quant = 1;
Ndef(\sandlizard).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freq = 170;
	var size;
	var time;
	var env1, env2, env3;
	var env0;
	var osig;
	var chords;
	var bufnum = LocalBuf(s.sampleRate * 4,2);
	var bufgate, stuttrig, choosetrig, recordtrig;
	var attack, decay, stutter;
	var env;
	bufnum.clear;
	chords = Duty.kr(4, 0, Dseq([
		Dseq([
			[0,4,7],
			[0,3,6],
		],1),
		[0,5,8,3+24],
		[2,5,8],


		Dseq([
			[0,4,7],
			[0,3,6],
		],2),
		[1,4,8,14],
		[0,9,6],
		[0,5,8,3+24],
		[2,5,8],
	],inf)).lag(0.4).midiratio ;
	freq = freq * [1/2,1/4,1/8,1,2,3,4];
	freq = freq *.t chords;


	// gen

	sig = SinOsc.ar(freq);
	sig = sig.flat;

	// stage1

	sig1 = Friction.ar(sig, friction: 0.41322e-7 * SinOsc.kr(0.01/(1..sig.size)).range(1,11111), mass: 1.05501 * SinOsc.kr(0.1/(1..sig.size)+0.01).range(1,41));
	sig = SelectX.ar(SinOsc.kr(1/(1..sig.size)+0.01).range(0.5,1) , [sig, sig1]);

	sig = Limiter.ar(sig, (-1).dbamp);

	// stage2

	sig1 = sig * sig.clip2(0.1);
	sig = SelectX.ar(SinOsc.kr(0.1/(1..sig.size)+0.001+(pi/14)).range(0.5,1) , [sig, sig1]);
	sig = sig * SinOsc.kr(1/(1..sig.size)+(pi/100)).range(0,1);

	// panning

	sig = Pan2.ar(sig, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! sig.size, amp).flop;

	// fx1

	bufgate = Duty.kr(1/2, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,1,
		0,1,0,0, 0,0,0,0,
		0,0,0,1, 0,0,0,1,
		0,1,1,1, 0,0,1,0,
		1,
	],inf));
	choosetrig = bufgate > 0;
	stutter = Duty.kr(1, 0, Dseq(1/[
		2,16,4,8,
		4,8,3,10,
		8,8,2,12,
		6,2,8,16,
		4
	],inf));
	stuttrig = TDuty.ar(stutter , choosetrig + Changed.kr(stutter), 1);
	recordtrig = Trig1.kr(choosetrig, 0.01);


	sig = sig.flop.sum;
	attack = 0.01;
	decay = 0.01;
	env = EnvGen.ar(Env([0,1,1,0],[attack, stutter-attack-decay, decay]), stuttrig);
	RecordBuf.ar(sig, bufnum, 0, 1, 0, run:1,loop:1,trigger: recordtrig,doneAction:0);
	sig1 = PlayBuf.ar(2, bufnum, rate:1/2, trigger:stuttrig,startPos:0, loop:1) * env;
	sig1 = sig1 * 1.2;
	sig = SelectX.ar( bufgate.lag(0.01)/1.2, [sig, sig1]);

	// fx2

	sig1 = sig.round(0.1 * SinOsc.kr(1/7).range(0,1));
	sig1 = BPF.ar(sig1 ! freq.flat.size, freq.flat, 0.1).sum;
	sig = SelectX.ar( Duty.kr(1, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,1,0, 0,0,0,0,
		0,1,0,0, 1,1,0,0,
		1,0,1,0, 0,0,1,0,
		1
	],inf)).lag(0.41)/1.2, [sig, sig1]);

	// fadein

	sig = sig * Line.ar(0.001,1,20).explin(0.001,1,0,1);

	sig;
}).play;


)

// END

// Compare:

{ WhiteNoise.ar(0.25)  }.play;

{ HPZ1.ar(WhiteNoise.ar(0.25))  }.play;

// HPZ1 is useful to detect changes in a signal:
// see also HPZ2
(
	{
		    var changingSignal = LFNoise0.ar(1000);
			    var hpz1 = HPZ1.ar(changingSignal);
				    [changingSignal, hpz1, hpz1 > 0, hpz1.abs > 0]

	}.plot

);

	var bufnum = LocalBuf(s.sampleRate * 4,2);
	var bufgate, stuttrig, choosetrig, recordtrig;
	var attack=0.01, decay=0.01, stutter;
	var env;
	bufnum.clear;
	bufgate = Duty.kr(1/4, 0, Dseq([
		0,0,0,0, 1,1,0,0,
		0,1,0,1, 0,1,0,0,
	],inf));
	choosetrig = bufgate > 0;
	stutter = DC.kr(1/4);
	stutter = Duty.kr(1/4, 0, Dseq(1/[
		1,2,4,8,
	],inf));
	stuttrig = TDuty.ar(stutter, choosetrig + Changed.kr(stutter), 1);
	recordtrig = Trig1.kr(choosetrig, 0.01);
	env = EnvGen.ar(Env([0,1,1,0],[attack, stutter-attack-decay, decay]), stuttrig);
	RecordBuf.ar(sig, bufnum, 0, 1, 0, run:1,loop:0,trigger: recordtrig,doneAction:0);
	sig1 = PlayBuf.ar(2, bufnum, rate:1/2, trigger:stuttrig,startPos:0, loop:0) * env;
	sig1 = sig1 * 1.2;
	sig = SelectX.ar( bufgate.lag(0.01), [sig, sig1]);
