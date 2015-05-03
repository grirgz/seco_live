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
		sig = ( fb * \fb.kr(1) ) + in;
		sig = FreqShift.ar(sig, \shift.kr(100) * ((0..7)/7 - 0.5 * fspread + 1));
		sig = DelayL.ar(sig, 0.2,\delay.kr(0.01)) + sig;
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
Ndef(~name+++\fx).map(\shift, Ndef(~name+++\lfo1, { Duty.kr(1/2/~t, 0, Dseq([
	1,0,-70,40,
],inf)) }))
)

(
Ndef(~name+++\fx).map(\shift, Ndef(~name+++\lfo1, { Duty.kr(1/2/~t, 0, Dseq([
	1,0,-70,40,
	-581,0,0,740,
	-281,-200,-100,140,
],inf)) }))
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
