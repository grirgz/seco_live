(
Ndef(~name+++\fx, { arg  soundBufnum=0;
	var sig;
	var amp = 1;
	var in;
	in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 

	sig = in;

	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	sig = sig + CombL.ar(sig, 1, 1/8/8 * (1..8) * LFNoise1.kr(1/8 * (1..8)/8).range(0.8,2.0), 1, mul:0.1);
	sig = (sig*23* LFNoise1.kr(1/8 * (1..8)).range(0,1)).tanh;
	sig = LPF.ar(sig, 1000 * LFNoise1.kr(1/4* (1..8)/8).range(0.1,2.0));

	//sig = sig * EnvGen.kr(\iadsr2.kr(Env.adsr(0.1,0.1,0.8,0.1)), Trig.kr(\itrig2.tr(1),\isustain2.kr(1)), doneAction:0);

	sig = BPF.ar(sig, 1000 * LFNoise1.kr(1/2 * (1..8)/16).range(0.0,4.0),0.11);
	sig = sig *  1;
	sig = LeakDC.ar(sig);
	sig = SelectX.ar(\mix.kr(0), [in, sig]);
	amp = amp * \gain.kr(1);
	sig = sig * amp;
});
)

// END

Ndef(~name+++\fx).sources



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
