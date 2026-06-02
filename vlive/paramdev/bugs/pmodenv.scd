
// don't know why error "message keys not understood" in PmodEnv
(
SynthDef(\rawbassfil, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var fenv;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fenvm;
	var menv;
	var spread = ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	sig2 = SinOsc.ar(freq *[1,2]* ( SinOsc.ar(freq * ( 3/2 )) * 1 + 1 )).sum;
	sig1 = LFPulse.ar(freq*[1,2]).sum;
	sig3 = LFSaw.ar(freq *1* ( SinOsc.ar(freq * ( 6/4 )) * 1 + 1 ));
	sig = LocalIn.ar(8) * \fb.kr(0.7);
	sig = SelectX.ar(sig.range(0,2) * \selectffac.kr(1) * spread, [sig1, sig2, sig3]) + sig /2;
	LocalOut.ar(sig);

	fenv = EnvGen.kr(Env([0,1,0],[0.1,0.1]), \itrig.tr(1));
	fenvm = fenv * \fenvamt.kr(1) + 1;
	//sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq * fenv ).clip(20,20000), \rq.kr(0.5));
	sig1 = MoogFF.ar(sig, ( \lpfr.kr(1.1) * freq * fenvm ).clip(20,20000), 1/\rq.kr(0.5))*2;
	menv = EnvGen.kr(Env([0,1,0],[0.8,0.1]), \itrig2.tr(1));
	sig = SelectX.ar(menv, [sig1, sig]);
	//sig = BPeakEQ.ar(sig,( \lpfr.kr(1.1) * freq * fenv ).clip(20,20000), 1/\rq.kr(0.5), -8 );

	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.2,0.4)),\itrig.tr(1),doneAction:0);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);


	pan = pan + LFNoise1.kr((1..8)/45);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
Pdef(\demo).reset;
);

(
Pdef(\demo, Pdef(\demomo, 
	Ppar([
		Pmono(\rawbassfil,
			\note, Pstep(Pseq([
				0,3,2,1,
			],inf),1/1),
			\octave, 3,
			\itrig, 1,
			\itrig2, Pseq([1,0,0,0, 0,0,0,0],inf),
			\dur, 1/8,
			\iadsr, PpatEnv.adsr(0.01,0.1,0.9, Pseg(Pseq([0.3,2.1,0.4,0.8,0.5],1),8).loop),
			\fenvamt, PmodEnv(Pseq([1,18,1,4],1), 8).loop,
			\rq, Pseg(Pseq([0.4,1],inf),16),
			\fb, Pseq([
				1,0.9, 1,0.5,
				1,1.1, 0.51,0.5,
			],inf),
			\fspread, ~pmodenv.(Pseq([0.000001,2,1/21,4],inf), 1),
			\selectffac, ~pmodenv.(Pseq([1,2,1,4,0.1],inf), 1/2),
			\selectffac, Pseq([
				1,2,2,2,
				1,1,1,2,
				1,2,2,2,
				5,45,4,5,
			],inf),
			\fspread, Pseq([
				1/11112,
				1/21112,
			],inf),
			\amp, 0.1,
		),
	])
)).play;
)
