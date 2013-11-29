
(
SynthDef(\lfofo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, ffreq= 500, mfreq=100, lfofreq=100,lfospread=0.1,
					rq= 0.3, spread=0.8, gate2=1;
	var sig;
	var mod;
	var size = 16;
	var fspread;
	var spread_range = 20;
	//var mfreq = 1;
	fspread = Array.series(size, 0,1)-(size/2);
	//mod = SinOsc.kr(mfreq) * (500 + (fspread*spread_range)) + 1100;
	//mod = SinOsc.kr(mfreq) * [500,150] + 1100;
	//mod = SinOsc.kr(fspread * 0.001 + XLine.kr(1,500,20));
	mod = LFSaw.kr(fspread * lfospread + lfofreq);
	sig = LFSaw.ar(mod * mfreq + freq );
	//sig = RLPF.ar(sig, 1000 + (fspread * 100) , 0.03);
	//sig = RLPF.ar(sig, 1000 + (mod * 100) * XLine.kr(0.1,10,20) , 0.3 + (mod * 0.1));
	sig = RLPF.ar(sig, ffreq , rq);
	//sig = sig.sum / 2;
	//sig = Pan2.ar(sig, pan, amp);
	//sig = SinOsc.ar(freq);
	//sig = Decimator.ar(sig, s.sampleRate,SinOsc.kr(1).range(8,31));
	sig = Decimator.ar(sig, s.sampleRate,2);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate2,doneAction:0);
	sig = sig * EnvGen.ar(Env.adsr(0.9,0.1,0.8,0.9),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

Sdef(~name, \mypreset2, \preset, \lfofo);

// END

Sdef(~name, \mypreset2).edit
Sdef(~name, \mypreset).reset(true)
Sdef(~name, \mypreset).rebuild
Sdef(~name, \mypreset2).rebuild
