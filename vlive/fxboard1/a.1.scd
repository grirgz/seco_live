(
Ndef(~name+++\fx, { arg  soundBufnum=0;
    var inA, chainA, inB, chainB, chain;
	var sig;
	var chainC, inC;
	var chain1, chain2, chain3;
	soundBufnum = c;
	inA = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
    //inB = LFSaw.ar(100, 0, 0.2);
	inB = DelayL.ar(inA, 0.1,0.001 * SinOsc.kr(2).range(0,1)) + inA;
	inB = (inB*5).tanh / 2;
    chain1 = FFT(LocalBuf(2048), inA);
    chain2 = FFT(LocalBuf(2048), inB);
    //chain = PV_MagDiv(chainA, chainB);
	chain = chain1;
    //chain = PV_MagMul(chainB, chainA);
	//chain = PV_MagShift(chain, MouseX.kr(0.25, 4, \exponential), MouseY.kr(-128,128));
	//chain = PV_RandWipe(chain, chain2, MouseX.kr(0.25, 4, \exponential), MouseY.kr(-128,128));
	chain = PV_Morph(chain, chain2, MouseY.kr(0,1));
	//chain = PV_MagLog(chain);
	sig = 0.1 * IFFT(chain);
	sig = LeakDC.ar(sig);
	//sig = sig ! 2 + ( inB / 143 );
	sig = sig ! 2;
    //Out.ar(out,  sig);
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
