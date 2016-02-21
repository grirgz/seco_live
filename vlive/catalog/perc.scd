
SynthDef(\snare, { arg out=0,tu=1, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env = EnvGen.ar(Env.perc(0.01,1));
	var enf = EnvGen.ar(Env([600,177,230],[0.01,0.01],-4));
	sig = SinOsc.ar(tu*enf+127,0,0.5)*env;
	sig = [WhiteNoise.ar,sig];
	sig = RHPF.ar(sig, \hpf.kr(170)*tu, \hrq.kr(0.5));
	sig = sig + Mix.ar(BPF.ar(sig,[127]++( {10 + ExpRand(10,14443.0)}!48  ),[0.5,0.5])*0.4);
	sig = sig/2;
	sig = RLPF.ar(sig, \lpf.kr(11100)*tu , \lrq.kr(0.5));
	//sig = SelectX.ar(MouseX.kr(0,1), sig);
	sig[1] = sig[1]* EnvGen.ar(Env.perc(0.01,0.01,-4),gate,doneAction:0);
	sig = sig.mean;

	sig = sig * EnvGen.ar(Env.perc(0.01,\rel.kr(0.1)*2,-4),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
