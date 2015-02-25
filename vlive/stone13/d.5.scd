
// xTAGS: ndef, harsh, noise, drone, granular
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;

	
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	var gate;
	var pos;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var clk;
	var dur = 0.1;
	var pitch_stretch = [2, 1,1/2 ];
	var pan = 0;
	var env1, env2;
	var env3, env4;
	var range;
	var seq1, seq2, seq3;
	var mfreq = 8*~t;
	var bufnum = LocalBuf(s.sampleRate * 4,2);
	var bufgate, stuttrig, choosetrig, recordtrig;
	var attack=0.01, decay=0.01, stutter;
	var env;
	mfreq = Duty.kr(1/~t, 0, Dseq([
		1,4,8,16,
	],inf))*~t;

	env1 = XLine.kr(1,23,8/~t);
	env2 = XLine.kr(0.01,23,8/~t);
	seq1 = Duty.kr(1/4/~t, 0, Dseq([
		1,0,1,0,
	],inf)) + 0.01;
	seq2 = Duty.kr(1/6/~t, 0, Dseq([
		1,0,1,0,
	],inf)) + 0.01;
	env2 = LFSaw.kr(mfreq).exprange(0.01,23) * seq1;
	env3 = XLine.kr(0.1,8,8/~t);
	env1 = LFSaw.kr(mfreq).exprange(1,10);
	env1 = 1;
	env2 = 1;
	env3 = 1 ;
	env3 = LFSaw.kr(1/4*~t).exprange(1,15) * ( seq2 + 1 );

	freq = [100,200,500];
	freq = [1,2,5] * 1 * Duty.kr(1/16/~t, 0, Dseq([
		Drand([10,1480,500]),Dwhite(100,5000),
	],inf)); 

	sig = LFSaw.ar((Lorenz2DN.ar(4 * [1,2,3,14400], 1 * [1,10000], h:0.02)* env2+1)*freq * [1,1.00001,1/2])*0.4;
	//sig = SinOsc.ar(freq) ;
	sig = RLPF.ar(sig, (Lorenz2DN.ar(448 * env1 * [1,2,3,4], 4880, h:0.01).unipolar * 0.1 + 1) * ( 11100));

	


	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));

	////////// stutter

	bufnum.clear;

	bufgate = Duty.kr(1/4, 0, Dseq([
		0,1,1,1,
		1,1,1,1,
	],inf));
	choosetrig = bufgate > 0;
	stutter = DC.kr(1/4);
	stutter = Duty.kr(2/~t, 0, Dseq(1/[
		8,16,12,2,
		8,8,4,8,
	]*2,inf))*~t;
	stuttrig = TDuty.ar(stutter, choosetrig + Changed.kr(stutter), 1);
	recordtrig = Trig1.kr(choosetrig, 0.01);
	env = EnvGen.ar(Env([0,1,1,0],[attack, stutter-attack-decay, decay]), stuttrig);
	
	RecordBuf.ar(sig, bufnum, 0, 1, 0, run:1,loop:0,trigger: recordtrig,doneAction:0);
	sig1 = PlayBuf.ar(2, bufnum, rate:1/2, trigger:stuttrig,startPos:0, loop:0) * env;
	sig1 = sig1 * 1.2;
	sig = SelectX.ar( bufgate.lag(0.01), [sig, sig1]);

	// env

	sig = sig / 2;

	sig = sig * Duty.kr(1/8/~t, 0, Dseq([
		1,1,1,1, 0,0,0,0,
		0,0,0,0, 0,0,1,1,
		1,0,0,0, 0,0,0,1,
		0,0,0,0, 0,0,1,0,
	],inf));
	sig;
});

(
	Ndef(~name+++\fx).set(\ffreq, 1500);
	Ndef(~name+++\fx).set(\hpfreq, 500);
	
);


Ndef(~name+++\fx).put(50, \filter -> { arg in;
	var sig = in;
	//sig = AllpassL.ar(sig, 4, 1/2/~t,4) + sig;
	
	sig;
});

// END

(
{ Henon2DC.ar(
    2200 * [1,2], 8800,
    LFNoise2.kr(1, 0.2, 1.2),
    LFNoise2.kr(1, 0.15, 0.15)
) * 0.2 }.play(s);
)


{ SinOsc.ar(Henon2DC.ar(200, 400, MouseX.kr(1,1.4), MouseY.kr(0,0.3))*800+900)*0.01 ! 2 }.play(s)



{ Lorenz2DN.ar(11025, 44100)!2 }.play(s);

// randomly modulate params
(
{ Lorenz2DN.ar(
    11025, 44100,
    LFNoise0.kr(1, 2, 10),
    20,
    LFNoise0.kr(1, 1.5, 2),
    0.02
) * 0.2 ! 2 }.play(s);
)

// as a frequency control
{ SinOsc.ar(Lorenz2DN.ar(1480, 1180, h:0.02)*20+90)*0.01 ! 2 }.play(s);
