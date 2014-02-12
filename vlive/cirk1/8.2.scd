//Pdef(~name)
Pdef(~name +++ \pre, Pbind(
	\freq, 100,
	//\isRest, Pseq([Veco(~name).isrest(16,1),Pn(true,4),Pn(false,4)],inf) ,
	\start, Pseq([0.5,0.55],inf)+Pwhite(0,0.5),
	\speed, Pseq([
		0.1,0.2,0.3,0.1,
		0.4,0.02,0.3,0.1,
		0.1,0.2,0.3,0.1,
		0.4,0.52,0.3,0.1,
	],inf)+Pwhite(0,0.01),
	\end, Pkey(\start)+ Pseq([0.16,0.1,0.05,0.2]/4,inf),
)); 

Ndef(~name+++\fx, {
	var in = InFeedback.ar(BusDef(~name+++\fx), 2);
	var freq;
	var sig;
	freq = LFNoise0.ar(8.2).range(50,[1000,2000,500]*LFNoise0.ar(0.2).abs).lag(0.5);
	sig = in * SinOsc.ar(freq);
	sig = Splay.ar(sig);

}).play;

// END

Buffer
	BufDef(\camion).numFrames /

