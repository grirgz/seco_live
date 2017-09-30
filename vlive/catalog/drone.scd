

// ambiant is a lot of channel spread across whole spectrum
// technic 1: whitenoise > BPF, BRF
(
Ndef(\ambi, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(100.0,10000) }!20 * ( 1 + ( SinOsc.kr((1..4).rand(0.0)/18) * 1/41 )));
	sig = DelayC.ar(sig, {rrand(1/100,1/10000)}!4) + sig / 2;
	sig = DelayC.ar(sig, {rrand(1/100,1/10000)}!4) + sig / 2;
	sig = BRF.ar(sig, { ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,1);
	sig = LeakDC.ar(sig) * 5;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
	// filter random bands
Ndef(\ambi, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.kr((1..4).rand(0.0)/18) * 1/41 )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000)}!4) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000);
	sig = sig * 5 * 2;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
	// add some story with XLine
Ndef(\ambi, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.kr((1..4).rand(0.0)/18) * 1/41 )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000)}!4) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * XLine.kr(1,1/1000,14)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000 * XLine.kr(1/100,1,4));
	sig = sig * 5 * 3;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
);

(
Ndef(\fall, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.ar(rrand(1,4.0!4)/18 * XLine.kr(1,121200,80)) * 1/41 * XLine.kr(1,180,60) )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) }!4* ( 1 + ( SinOsc.ar(rrand(1,4.0!4)/12 * XLine.kr(0.001,121200,60)) * 1/41 * XLine.kr(1,180,60) ))) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * XLine.kr(1,1/1000,14)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000 * XLine.kr(1/100,1,4));
	sig = sig * 5 * 1/3;
	sig = sig.debug("sig1");
	sig = sig.flop.clump(2).mean;
	sig = sig.debug("sig");
	sig = sig * amp;
	sig;
}).play;
);



(
Ndef(\fall, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.ar((1..4).rand(0.0)/18 * XLine.kr(1,121200,80)) * 1/41 * XLine.kr(1,180,60) )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * ( 1 + ( SinOsc.ar((1..2).rand(0.0)/18 * XLine.kr(1,121200,60)) * 1/41 * XLine.kr(1,180,60) ))}!4) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * XLine.kr(1,1/1000,14)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000 * XLine.kr(1/100,1,4));
	sig = sig * 5 * 3;
	sig = sig.mean;
	sig = sig * amp;
	sig;
}).play;
);


////////////////////////////////////
// technic 2: whitenoise > Klank

(
Ndef(\drone, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!48), 0.001!8 ]), sig);
	sig = sig  / 1;
	sig = sig.debug("sig");
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
	// stereo
Ndef(\drone, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar;
	sig = Klank.ar(Ref([ exprand(20.0,10100!48!2), 0.001!8 ]), sig);
	//sig = sig * SinOsc.kr(4*~t).range(0,1);
	sig = sig * EnvGen.kr(\env.kr(Env([0,2,1,0],[0.1,0.8,0.1].normalizeSum)), Impulse.kr(2*~t), timeScale:1/2);
	sig = sig  / 4;
	sig = sig.debug("sig");
	sig = sig * amp;
}).play;
);

(
	/// cool !!!!
Ndef(\drone, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = WhiteNoise.ar;
	sig = 2.collect({
		DynKlank.ar(Ref([ rrand(0,1.0!48).round(SinOsc.kr(1/10).range(0.0001,1/80) ).linexp(0,1,20.0,15000) * [ [1,1.0 + SinOsc.kr(1/11).range(0,0.0051)] ], 0.001!8 ]), sig);
	});
	sig = sig.collect({ arg isig;
		isig * SinOsc.kr(rrand(0.1,1)).range(0,1)
	});

	sig = sig  / 1;
	sig = sig.debug("sig");
	sig = sig * amp;
}).play;
);


2321.round(1000)

////////////////////


x = { MarkovSynth.ar(SinOsc.ar(), 1, 2, 3) * 0.1 ! 2; }.play;
x.free;

// Table size of 10, on a periodic signal. Another probabilistic explosion...
// When the transitions of the sine curve is broken, it becomes much noisier
// than tableSize = 3, because there are more samples in the table to try out.
// if you wait enough, output may stabilize at some point again.
x = { MarkovSynth.ar(SinOsc.ar(), 1, 2, 10) * 0.1 ! 2; }.play;

// bruit d'ambiance
// marche pas trop

Ndef(\noise, { MarkovSynth.ar( LFPulse.ar(500 * ( 1 + ( SinOsc.ar(1) * 0.71 ))) * 0.1, 1,0,3  ) * 0.4 ! 2 }).play;


/////////////////////////////////////////////////




(
Ndef(\drone, { arg amp=0.8, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;
	var baseffreq = 1000;

	freq = Duty.ar(8,0,Dseq([120,125],inf)).lag(8) * [1,1.3];

	ou = LFPulse.ar(freq * (1/(1..8))) | SinOsc.ar(SinOsc.ar(freq * (1..8))+1*300,0,[10,SinOsc.kr(1/45).range(1,20)]);
	ou = ou | SinOsc.ar(SinOsc.ar(freq * 1.3 * (1..4))+1*300,0,[SinOsc.kr(1/45).range(1,20),10]);
	ou = ou.sum;
	ou = BRF.ar(ou, 150 * (SinOsc.kr(1/(1..8)).unipolar *8));
	ou = ou * -25.dbamp;
	ou = FreqShift.ar(ou, -200 * SinOsc.ar(447).range(0,1)) + ou;
	ou = ou / 6/8;
	ou = ou.collect({ arg sig,x;
		Pan2.ar(sig, SinOsc.kr((x+1*200)), amp);
	}).sum;
});

Ndef(\drone).set(\mbufnum, BufDef.mono(\bomb));
Ndef(\drone).set(\pos, 0.1);
Ndef(\drone).set(\amp, 0.2);
Ndef(\drone).set(\time_stretch, 0);
Ndef(\drone).set(\pitch_stretch, 2);
Ndef(\drone).play;
)

///////////////////////////////////////



(
Ndef(\drone, { arg amp=0.5, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;

	bufnum = BufDef.mono(\rocksteady, "vipere/rocksteady.flac");
	pitch_stretch = Duty.kr(8/~t, 0, Dseq([
		[0,4,7,12],
		[0,4,7,10],
		[0,7,10,-12],
		[0,3,7,10],
	].midiratio,inf));
	time_stretch = 0;
	trate = 100;
	pos = SinOsc.kr(1/16*~t,pi).range(0,1) * 0.0004 * [1,1.1] + 0.3;
	//pos = EnvGen.ar(Env([0,0.4,0.2],[0.4,0.2]),LFPulse.kr(1/1*~t),doneAction:0);
	//pos = pos + EnvGen.ar(Env([0,0.2,0.4],[0.4,0.1]),LFPulse.kr(1*~t).poll,doneAction:0).poll;
	clk = Impulse.kr(trate);
	randclk = Impulse.kr(randrate * trate);
	dur = 0.1;
	pan = (WhiteNoise.kr(0.6) + pan).clip(-1,1);
	sr = SampleRate.ir;
	phasor = Phasor.ar(0, time_stretch.abs / sr / BufDur.kr(bufnum), 0, 1);
	phasor = Select.ar(time_stretch.sign + 1 /2, [
		pos - phasor,
		phasor + pos,
	]);

	pos = phasor * BufDur.kr(bufnum) + finepos ;
	ou = TGrains.ar(2, clk, bufnum, pitch_stretch, pos % BufDur.kr(bufnum), dur, pan, 1);
	ou = Pan2.ar(ou, SinOsc.kr(1/48,[0,pi]).unipolar).flop;
	ou = [
		[300,350] * SinOsc.kr(1/8*~t).range(1,1.2),
		[1300,1350],
		[7300,7350],
	].collect { arg x, idx;
		ou1 = RHPF.ar(ou, x[0],0.3);
		ou2 = RLPF.ar(ou1, x[1],0.3);
		ou2 = ou2 * SinOsc.kr(1/(1+x)).unipolar;
		ou2;
	};
	ou = ou /8;
	ou = Splay.ar(ou, 1, amp);
}).play;
);

//////////////////////////////////////////////

(
Ndef(\drone).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig;
	var lpfenv;

	trig = Dust.ar(14);

	sig = Decay2.ar(trig, 0.01, 0.2);
	//sig = Ringz.ar(sig, TRand.kr(200,4700,trig),0.1);
	sig = Ringz.ar(sig, 
		LFNoise1.kr(1/9).range(0.8,1.2) * 
		Demand.ar(trig, 0, Drand([
			100,120,130,440,
		]*3,inf)),0.1);
	sig = sig * (CuspN.ar(1/24)+0.2);
	sig = sig * 0.1;


	//sig = sig * EnvGen.ar(Env.adsr(0.1,0.4,0.4,0.1),Trig.kr(trig,0.5),doneAction:0);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play;

);

(
Ndef(\drone).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig;
	var lpfenv;
	var parafil;

	trig = Dust.ar(84);
	trig = Impulse.ar(14 * LFNoise1.kr(1/2).exprange(0.8,8.0));
	trig = trig + Dust.ar(40 * LFNoise1.kr(1/2).range(0.8,2.0));

	sig = Decay2.ar(trig, 0.01, 0.2);
	//sig = Ringz.ar(sig, TRand.kr(200,4700,trig),0.1);
	//sig = BPF.ar(sig, 
	//	LFNoise1.kr(1/9).range(0.8,1.2) * 
	//	Demand.ar(trig, 0, Drand([
	//		100,120,130,440,
	//	]*3,inf)),0.7);
	parafil = LFNoise1.kr(1/8).range(0.0,1.0);
	sig1 = Ringz.ar(sig, TRand.ar(200.0,4700,trig).lag(0.1),0.01) / 10;
	sig2 = SelectX.ar(parafil, [sig1, sig]);
	sig2 = BPF.ar(sig2, 
		LFNoise1.kr(1/2).range(0.8,3.2) * 400
		, 0.2 * LFNoise1.kr(1/2).range(0.8,2.0));
	//sig = SelectX.ar( LFNoise1.kr(1/7).range(0.0,1.0), [sig1, sig2]);
	sig = SelectX.ar( parafil, [sig2, sig1 + sig2]);

	sig = sig * (CuspN.ar(1/24).unipolar/2+0.2);
	sig = sig * 50;


	//sig = sig * EnvGen.ar(Env.adsr(0.1,0.4,0.4,0.1),Trig.kr(trig,0.5),doneAction:0);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));
	sig;
}).play;

);

(
Ndef(\dronefx).put(0, { arg amp=0.1;
	var sig;
	var freq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var trig;
	var lpfenv;
	var parafil;

	trig = Dust.ar(84);
	trig = Impulse.ar(14 * LFNoise1.kr(1/2).exprange(0.8,8.0));
	trig = trig + Dust.ar(40 * LFNoise1.kr(1/2).range(0.8,2.0));

	sig = Decay2.ar(trig, 0.01, 0.2);
	//sig = Ringz.ar(sig, TRand.kr(200,4700,trig),0.1);
	//sig = BPF.ar(sig, 
	//	LFNoise1.kr(1/9).range(0.8,1.2) * 
	//	Demand.ar(trig, 0, Drand([
	//		100,120,130,440,
	//	]*3,inf)),0.7);
	parafil = LFNoise1.kr(1/8).range(0.0,1.0);
	sig1 = Ringz.ar(sig, TRand.ar(200.0,4700,trig).lag(0.1),0.01) / 10;
	sig2 = SelectX.ar(parafil, [sig1, sig]);
	sig2 = BPF.ar(sig2, 
		LFNoise1.kr(1/2).range(300,14000)
		, 0.2 * LFNoise1.kr(1/2).range(0.8,2.0));
	//sig = SelectX.ar( LFNoise1.kr(1/7).range(0.0,1.0), [sig1, sig2]);
	sig = SelectX.ar( parafil, [sig2, sig1 + sig2]);

	//sig = sig * (CuspN.ar(1/24).unipolar/3+0.2);
	sig = sig * 40*4;


	//sig = sig * EnvGen.ar(Env.adsr(0.1,0.4,0.4,0.1),Trig.kr(trig,0.5),doneAction:0);
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, \pan.kr(0));

	sig = sig * Duty.kr(1/~t, 0, Dseq([
		0,0,0,0, 0,0,0,0,
		1,1,1,1, 1,1,1,1,
	],inf)).lag(0.1);
	sig;
});

Ndef(\dronefx).put(50, \filter -> { arg in;
	var sig = in;
	//sig = AllpassL.ar(sig, 4, 1/8/~t * SinOsc.kr(1/45).range(0.9,1.1),14) + sig;
	//sig = AllpassL.ar(sig, 4, 1/4/~t * SinOsc.kr(1/25).range(0.9,1.1),8) + sig;
	//sig = AllpassL.ar(sig, 4, SinOsc.kr(1/45).unipolar(0.3) + 1 * 1/2/~t ,18) + sig;
	
	sig;
}).play;

);

//////////////////////////



(
Ndef(\drone).put(0, { arg amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	var freq;
	var lpspread;

	freq = 140 * [0,3,5].midiratio;
	freq = freq *.t [1,4,1.01,1/2,4.01,1.001,2];

	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(SinOsc.kr(0.5*(1..11)/12).unipolar*2, [sig1, sig2, sig3]);
	//sig = SelectX.ar(0.3, [sig1, sig2, sig3]);

	sig = sig.fold2( SinOsc.kr(1/4/(1..11)).range(0.1,2));
	sig = sig.wrap2( SinOsc.kr(1/4/(1..11).reverse).range(0.1,2));
	lpspread = SinOsc.kr(1/5*(1..11)/9)*1.5;
	//lpspread = 0;
	sig = RLPF.ar(sig, \lpf.kr(400) * ((0..11)/11 - 0.5 * lpspread + 1), \rq.kr(0.5));
	sig = HPF.ar(sig, 700);

	sig = sig / 5;
	
	amp = amp * \gain.kr(1);
	sig = Splay.ar(sig, \spread.kr(0.2), amp, \pan.kr(0));
	sig;
}).play;

)

////////////////////////////////////////


(
Ndef(\drone, { arg amp=0.8, pan=0, freq=200, mbufnum,
						gdur=12, trate=100, time_stretch=1, pos=0, pitch_stretch = 1, 
						randframes=0.01, randrate=1, doneAction=2, finepos=0,
						release=0.2;
	var ou;
	var ou1, ou2;
	var dur, clk;
	var bufnum = mbufnum;
	var randclk;
	var pitch;
	var sr, phasor;
	var baseffreq = 1000;

	freq = Duty.ar(8,0,Dseq([40,60,400,800,20,50,30,20],inf));

	ou = LFPulse.ar(freq * (1/(1..8))) | SinOsc.ar(SinOsc.ar(freq * (1..8))+1*200,0,10);
	//ou = Splay.ar(ou, 1, amp);
	ou = ou.sum;
	ou = BRF.ar(ou, 50 * (SinOsc.kr(1/(1..8)).unipolar *8));
	ou = ou * -25.dbamp;
	ou = ou.sum;
	ou = [ou, ou.tanh];
	ou = ou / 6;
	ou = ou.collect({ arg sig,x;
		Pan2.ar(sig, SinOsc.kr((x+1*200)), amp);
	}).sum;
});
)

//////////////////////////////



(
	Ndef(\drone, { arg in, pan=0, amp=1;
		in = SinOsc.ar(80 * [1,1.00001].mirror2.clump(2)).mean;
		in = in.fold2(0.9 * SinOsc.kr(1/(1..8)/~t).unipolar);
		in.postln;
		in = Pan2.ar(in, pan + LFNoise1.kr(1), amp);
		in = in.mean;
		in = in * 1.8;
		in.debug("hihi");


	}).play;
)


(
	Ndef(\drone, { arg in, pan=0, amp=1;
		var s1;
		s1 = SinOsc.ar(700*1/(1..7)) * LFNoise1.kr((1..8)).unipolar;
		in = SinOsc.ar(80 * [1,1.00001].mirror2.clump(2), s1).mean;
		in = in.fold2(0.9 * SinOsc.kr(1/(1..8)/~t).unipolar);
		in.postln;
		in = Pan2.ar(in, pan + LFNoise1.kr(10)/2, amp);
		in = in.mean;
		in = in * 0.8;
		in.debug("hihi");


	}).play;
)


(
	Ndef(\drone).set(\bufnum, BufDef(\ukraine));
	Ndef(\drone, { arg in, pan=0, bufnum=0, amp=1;
		var s1;
		var pos;
		bufnum.debug("kjk");
		//in = BufRd.ar(2, bufnum, SinOsc.ar(100).unipolar * 0.1 + 0.1 * BufFrames.kr(bufnum));
		pos = 0.1  + LFNoise0.kr(20).unipolar(0.014) * BufFrames.kr(bufnum);
		in = PlayBuf.ar(2, bufnum, 1/8 * [1,2,4,3], Impulse.ar(78 * [1,1/2,1/4]), pos);
		in = Pan2.ar(in, pan + LFNoise1.kr(10)/2, amp).mean.sum;
		in = in * 8.8;
		in.debug("hihi");


	}).play;
)
