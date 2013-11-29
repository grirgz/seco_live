
(
Ndef(~name+++\lfo1, { arg val=100, vlag=0.1; val.lag(vlag) });
Ndef(~name+++\lfo1).put(1, \set -> Pbind(
	\val, Pseq([
		700,1300,500,5000,
		1300,500,5000,700,
		500,5000,700,1300,
		5000,700,1300,500,
	],inf),
	\val, Pseq([
		400,900,1000,600, 500,
		700,1300,500,1200,
		1300,500,2000,700,
		500,1000,700,1300,
		500,700,1300,500,
	],inf),
	\vlag, Pseq([
		0.1,0.01,1,0.5,0.3,
	],inf),
	\vlag, 0.0501,
	\dur, PdurStutter(Pseq([1,2,4,2],inf), 1/2),
));
Ndef(~name+++\gate2, { arg gate2=1; gate2 });
Ndef(~name+++\gate2).put(1, \set -> Pbind(
	\gate2, Pseq([1,0,1,1,0],inf),
	\gate2, Pseq([1,0],inf),
	\dur, PdurStutter(Pseq([
		1/2,
		1,
		2,
		4,
	],inf), 1/2),
	\dur, PdurStutter(Pseq([
		2,2,4,2,
		4,8,2,2,
		16,
	],inf), 1/2),
	\dur, 1/8,
	\dur, PdurStutter(Pseq([
		Pser([8],8),
		Pser([8,4],8),
		Pser([8],8),
		Pser([4,2],8),
	],inf), 1/2),
	//\dur, 1/4,
));
Ndef(~name+++\lfo1).quant=Pdef.defaultQuant;
Pdef(~name, 
	Pbind(
		\degree, Pseq([
			[-7,2+7,4],
			[7,2,4],
			[0,2,4-7],
			[0,2,4],
			[0,2-7,4],
			
		],inf),
		\mtranspose, Pseq([0,3,2,1],inf),
		\scale, Scale.minor,
		//\note, PdegreeToKey(Pseq([0,2,4],inf), Scale.major, 12),
		\ffreq, Ndef(~name+++\lfo1),
		\octave, 5,
		\gate2, Ndef(~name+++\gate2),
		
	)
	<> Pfunc({ arg ev; ev[\freq] = nil })
	<> Sdef(~name, \mypreset2).pdef <>
	
	Pbind(
	\instrument, \lfofo,
	\legato, 1,
	\degree, Pseq([0,2,3,1],inf),
	//\freq, Pseq([500,300,200,250],inf),
	\ffreq, Pseq([200,300,250,350],inf),
	\ffreq, Pkey(\freq) * Pseq([1,0.5,0.1,2],inf),
	\mfreq, Pkey(\freq) * 0.9,
	\lfofreq, 0.1,
	\dur, 2,
	\amp, 0.1
)).play;
);

// END

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod;
	var size = 8;
	var fspread;
	var spread_range = 20;
	var mfreq = 1;
	fspread = Array.series(size, 0,1)-(size/2);
	mod = SinOsc.kr(mfreq) * (500 + (fspread*spread_range)) + 1100;
	//mod = SinOsc.kr(mfreq) * [500,150] + 1100;
	sig = LFSaw.ar(mod);
	sig = sig.sum;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
	var fspread;
	var size = 8;
	fspread = Array.series(size, 0,1)-(size/2);
	1 * (500 + (fspread * 20)) + 1100;
)

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod;
	var size = 16;
	var fspread;
	var spread_range = 20;
	var mfreq = 1;
	fspread = Array.series(size, 0,1)-(size/2);
	//mod = SinOsc.kr(mfreq) * (500 + (fspread*spread_range)) + 1100;
	//mod = SinOsc.kr(mfreq) * [500,150] + 1100;
	//mod = SinOsc.kr(fspread * 0.001 + XLine.kr(1,500,20));
	mod = LFSaw.kr(fspread * 0.1 + 500);
	sig = LFSaw.ar(mod * 100 + 300 );
	//sig = RLPF.ar(sig, 1000 + (fspread * 100) , 0.03);
	//sig = RLPF.ar(sig, 1000 + (mod * 100) * XLine.kr(0.1,10,20) , 0.3 + (mod * 0.1));
	sig = RLPF.ar(sig, 1000 * XLine.kr(0.1,10,20) , 0.3 * XLine.kr(10,0.1,20));
	//sig = sig.sum / 2;
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, 0.788, amp, pan);
}).play;
);

(
Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var mod;
	var size = 16;
	var fspread;
	var spread_range = 20;
	var mfreq = 1;
	fspread = Array.series(size, 0,1)-(size/2);
	//mod = SinOsc.kr(mfreq) * (500 + (fspread*spread_range)) + 1100;
	//mod = SinOsc.kr(mfreq) * [500,150] + 1100;
	//mod = SinOsc.kr(fspread * 0.001 + XLine.kr(1,500,20));
	mod = LFSaw.kr(fspread * 0.1 + 500);
	sig = LFSaw.ar(mod * 100 + 300 );
	//sig = RLPF.ar(sig, 1000 + (fspread * 100) , 0.03);
	//sig = RLPF.ar(sig, 1000 + (mod * 100) * XLine.kr(0.1,10,20) , 0.3 + (mod * 0.1));
	sig = RLPF.ar(sig, 1000 , 0.3);
	//sig = sig.sum / 2;
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, 0.788, amp, pan);
}).play;
);


