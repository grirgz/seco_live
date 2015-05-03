(
Ndef(~name+++\fx, { arg  soundBufnum=0;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig1 = sig * ( 1+
			LFSaw.ar(\freq.kr(100), mul:MouseX.kr(0,5))
	);
	sig1 = HPF.ar(sig1, \hpfreq.kr(700));
	sig1 = DelayL.ar(sig1!2, 0.5, {0.1.rand * LFNoise1.kr(8*1/2).range(0.0,2.0)}!8 * \del.kr(1)) + sig1;
	sig1 = sig1.mean;
	sig2 = sig1;
	sig2 = (sig2 * \distamp.kr(100)).tanh;
	sig1 = [ sig1 , sig2 ].flat.clump(2).mean / 4;
	sig1.debug("sig1");
	sig1 = RLPF.ar( 
		sig1,
		\lpfreq.kr(1000),
	);
	sig1 = Compander.ar(sig1, in, \compt.kr(0.4), \complo.kr(1.001), \comphi.kr(0.9));
	sig = SelectX.ar(\mix.kr(0), [sig, sig1]);
});
)

// END



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
