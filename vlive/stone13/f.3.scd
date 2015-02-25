
// xTAGS: ndef, harsh, noise, drone, granular
Ndef(~name+++\fx).put(0, { arg amp=0.1;
	var sig;

	
	var ou, ou2;
	var osc;
	var bufsig;
	var phase;
	var ffreqtab;
	var gate;
	var bufnum;
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
	var r;
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
	env3 = LFSaw.kr(mfreq).exprange(0.1,8) * ( seq2 + 1 );
	env1 = LFSaw.kr(mfreq).exprange(1,10);
	env1 = 1;
	env2 = 4;
	env3 = 1;

	freq = 200 * Duty.kr(1/~t, 0, Dseq([
		[0,3,7],
		[0,3,7]+(12*2),
	],inf)).midiratio;

	sig = SinOsc.ar(freq); 


	sig = sig / 4;

	r = Dwrand([1,0],[0.5,0.5]);
	sig = sig * Duty.kr(1/4/~t, 0, Dseq([
		0,0,0,0, r,1,r,0,
		0,1,r,1, 1,1,r,0,
	],inf));

	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
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
