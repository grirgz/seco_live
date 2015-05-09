(
Ndef(~name+++\fx, { arg  soundBufnum=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in;
	var fspread;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	fspread = \sspread.kr(1);
	sig = Fb { arg fb;
		var sig;
		var tab;
		var sigo;
		var delayx = { arg sigin, del, dfact;
			DelayL.ar(sigin, 1,1/\dfreq.kr(0.1) * dfact * SinOsc.ar(dfact*8*8).range(1,1.01)) + sigin;
		};
		var dfac;
		sig = ( fb * \fb.kr(1) ) + in;
		sigo = sig;
		sig1 = sig;
		in.debug("in");
		dfac = 8;
		sig = SelectX.ar(\dmix.kr(0.1), [
			4.do { arg x;
				sig1 = delayx.(sig1, 1, (x+1)/4 * dfac );
			}; sig1.debug("sig1"),
			4.collect { arg x;
				delayx.(in, 1, (x+1)/4 * dfac );
			}.sum.debug("sum"),
		]);
		sig2 = sig;
		sig = LPF.ar(sig2, \lpf.kr(1000));
		sig = sig+BPF.ar(sig2, \hpf.kr(2800), \rq.kr(0.1));
		//sig = sig + Disintegrator.ar(sig,0.3, -0.1);
		sig = (sig*\distamp.kr(1)).fold2(0.8 * SinOsc.ar(\dfreq.kr).range(4,1));
		sig.debug("sigmmm");
		//sig = FreqShift.ar(sig, SinOsc.ar(4) * 784) * sig + sig;
		//sig = SinOsc.ar(100);
		sig = Limiter.ar(sig);
		sig = SelectX.ar(\mix.kr(0), [in, sig]);
	};
	sig = LeakDC.ar(sig);
	sig = sig / 2;
	sig.debug("sig");
	sig = Splay.ar(sig, \spread.kr(0.5), \gain.kr(1), \pan.kr(0));
});
)

// END

(
Ndef(~name+++\fx).map(\distamp, Ndef(~name+++\lfo1, { Duty.kr(1/~t, 0, Dseq([
	5,2,1,2,
	5,1,4,1,
],inf)) }))
)

(
Ndef(~name+++\fx).map(\distamp, Ndef(~name+++\lfo1, { Duty.kr(1/~t, 0, Dseq([
	1,0,7,10,
	1,2,1,4,
],inf)) }))
)

(
Ndef(~name+++\fx).map(\dfreq, Ndef(~name+++\lfo2, { Duty.kr(1/2/~t, 0, Dseq([
	17000,5140,5400,50,
	5000,5140,5400,18050,
	50,70,67,60,
	1450,70,67,60,
],inf)) }))
)
(
Ndef(~name+++\fx).map(\dfreq, Ndef(~name+++\lfo2, { 100/10 * Duty.kr(1/2/~t, 0, Dseq([
	40,40,40,40,
	40,40,41,39,
].midiratio,inf)) }))
)
(
Ndef(~name+++\fx).map(\dfreq, Ndef(~name+++\lfo2, { 100/10 * Duty.kr(1/2/~t, 0, Dseq([
	Dseq([
		32,32,32,28,
	],1)+1,
].midiratio,inf)) }))
)
(
Ndef(~name+++\fx).map(\dfreq, Ndef(~name+++\lfo2, { 100/10 * Duty.kr(1/~t, 0, Dseq([
	Dseq([
		42,32
	],1)+1,
].midiratio,inf)) }))
)


(
SynthDef("help-magMul", { arg out=0;
    var inA, chainA, inB, chainB, chain;
    inA = WhiteNoise.ar(0.2);
    inB = LFSaw.ar(100, 0, 0.2);
    chainA = FFT(LocalBuf(2048), inA);
    chainB = FFT(LocalBuf(2048), inB);
    chain = PV_MagDiv(chainA, chainB);
    Out.ar(out, 0.5 * IFFT(chain).dup);
}).play;
)


c = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
Ndef("help-magMul2", { arg  soundBufnum=0;
    var inA, chainA, inB, chainB, chain;
	var sig;
	var chainC, inC;
	soundBufnum = c;
    inC = LFSaw.ar([100, 1850] * ( 1 + ( SinOsc.kr(401) * 10 )), 0, 0.2);
    inA = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum)*1.01, loop: 1);
    inB = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
    chainA = FFT(LocalBuf(2048), inA);
    chainB = FFT(LocalBuf(2048), inB);
    chainC = FFT(LocalBuf(2048), inC);
    //chain = PV_MagDiv(chainA, chainB);
	chain = chainA;
    //chain = PV_MagMul(chainB, chainA);
	chain = PV_MagShift(chain, MouseX.kr(0.25, 4, \exponential), MouseY.kr(-128,128));
	chain = PV_MagLog(chain);
	sig = 0.1 * IFFT(chain);
	sig = LeakDC.ar(sig);
	//sig = sig ! 2 + ( inB / 143 );
	sig = sig ! 2;
    //Out.ar(out,  sig);
}).play;
)

c.free;
