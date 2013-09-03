( // 'random' sequences of rhythms, reverb,...
z = {
    var trig, seq;
    trig = Impulse.kr(6);
    seq = Drand([
        Dseq([4,0,0,1,Drand([1,4]),1,0,1]),
        Dseq([1,0,2,0,Drand([0,1,4]),0,1,1]),
        Dseq([4,0,0,2,Drand([1,2,4]),0,1,1]),
        Dseq([4,0,1,2,Drand([0,1,4]),1,2,0]),
        Dseq([1,1,4,1,Drand([1,4]),2,3,3]),
        Dseq([4,1,0,1,Drand([0,4]),1,0,1])
    ], inf);

	g = HenonN.ar(
		[120,120],
		LFNoise2.kr(1, 0.2, 1.2),
		LFNoise2.kr(1, 0.15, 0.15)
	)
	* 0.2
	+ SinOsc.ar([61,40], mul:0.7)

	// add lovely chaos noise (taken from documentation example)
	+ {
		LatoocarfianC.ar(
			SampleRate.ir/4,
			LFNoise2.kr(2,1.5,1.5),
			LFNoise2.kr(2,1.5,1.5),
			LFNoise2.kr(2,0.5,1.5),
			LFNoise2.kr(2,0.5,1.5)
		) * 0.1 // volume
	}
	+
	{ FBSineN.ar(
    LFNoise2.kr(1, 1e4, 1e4),
    LFNoise2.kr(1, 32, 33),
    LFNoise2.kr(1, 0.5),
    LFNoise2.kr(1, 0.05, 1.05),
    LFNoise2.kr(1, 0.3, 0.3)
	) * 0.2 * SinOsc.kr(0.01) }
	;

    trig = Demand.kr(trig, 0, seq * 0.2) * trig;
	{ MoogFF.ar(
		g,
		SinOsc.kr(0.1,0,1,1) * 1000 + 3000)}.dup
	* Decay.kr(trig, Demand.kr(trig,0,Drand([1,2,4,6], inf)*0.1)) // envelope
	;
};

{
	GVerb.ar(
		in: EnvGen.kr(Env.linen(20, 240, 40, 0.6, \sine)) * z * 0.9,
		roomsize: 30,
		revtime: 4, // SinOsc.kr(0.1,0,4,4.1),
		damping:0.4, // SinOsc.kr(0.12,0,0.4,0.5),
		inputbw:1,
		spread:15,
		drylevel:SinOsc.kr(0.02,0,0.5,0.5),
		earlyreflevel:SinOsc.kr(0.01,0,0.5,0.5),
		taillevel:SinOsc.kr(0.02,pi,0.05,0.05)
	);
}.play
)


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8, release=0.1, ffreq=200, rq=0.3, mix=0.5;
	var sig, sig2;
	sig = LFSaw.ar(freq*[1.01,1.02,1.03,1.04,0.999,1.0001]);
	sig2 = SinOsc.ar(freq*[1.01,1.02,1.03,1.04,0.999,1.0001]*2/3);
	sig = SelectX.ar(mix, [sig , sig2]);
	sig = RLPF.ar(sig, ffreq, rq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,release),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(

c=10;a=Array.fib(14,0,1);b=Array.fill(size:c,function:{arg i;a[i]%07*2});

p=1/(21-c);Pdef(\x,Pbind(\instrument, \plop, \dur,p,\degree,Pseq(b,1,0)));

r=Array.fill(c,{arg i;Pbindf(Pdef(\x),
	\release, b[i]/14 / 5, 
	\mix, (b[i]/10.30), 
	\ffreq, 
	Pseq([

		Pseq([(1-b[i]).abs * 10 , i * 200, i *10 + 300],2),
		Pseq([b[i] * 200, b[i] * 250],2),
		Pseq([b[i] ** 2 * 10],6),
		Pseq([b[i] * 150, b[i] * 170],1),
	],inf),
	\mtranspose, Pseq([
		Pseq([1-b[i], 1+b[i]/2],6),
		Pseq([1-b[i]],6),
		Pseq([1-b[i], 1+b[i]/3],3),
	],inf).asInteger
);});

Pseq(r,(1/p)).play;

)



SynthDef(\instr2, {|out = 0, whitelevel = 1 , pan1 = 0,freq1=40,env=5,dist=10,gate=1|
 var  env2,white, whiteOut, distortion, fx, echo;

	env2 = EnvGen.kr(Env.perc(0.6,env, 1, -3), gate, doneAction:2);


	white =Mix.ar(SinOsc.ar([50,freq1]));
	white.poll(1,"white");
    whiteOut = Pan2.ar(white,pan1,whitelevel);
	whiteOut.debug("lkjk");
	whiteOut.poll(1,"whiteout");
    distortion = (whiteOut*dist).tanh;



    fx = Compander.ar(distortion, distortion,1, 0, 1 ); // sustain

    whiteOut = Limiter.ar(fx);
	whiteOut = whiteOut + fx;
	whiteOut.debug("quoi");
	whiteOut = whiteOut * env2 * 0.04;


    Out.ar(out, whiteOut);
}).store;



Pdef(\bla ,Pbind(\instrument,\instr2, \dur, 4,\env, 0.7, \whiteLevel, Pseq([1,0],inf)));

Pdef(\bla).play 




SynthDef(\instr2, {|out = 0, whitelevel = 0 , pan1 = 0,freq1=40,env=5,dist=0,gate=1|
 var  env2,white, whiteOut, distortion, fx, echo;

 env2 = EnvGen.kr(Env.perc(0.6,env, 1, -3), gate, doneAction:2);


    white =Mix.ar(SinOsc.ar([50,freq1]));
    whiteOut = Pan2.ar(white,pan1,whitelevel);
    distortion = (whiteOut*dist).tanh;



    fx = Compander.ar(distortion, distortion,1, 0, 0.1 ); // sustain

    whiteOut =    Limiter.ar(LeakDC.ar(fx + whiteOut,1 )!2);

	//whiteOut = whiteOut.sum;
	whiteOut.debug("kj");
	whiteOut = whiteOut * env2;

    Out.ar(0, whiteOut/10);
}).store;

Pdef(\bla ,Pbind(\instrument,\instr2, \dur, 1,\env, 0.7, \whitelevel, Pseq([1,0],inf), \dist, 1));

Pdef(\bla).play 
