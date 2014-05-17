(

Pdef(~name+++\pre, Pbind(
	//\scale, Scale.mixolydian,
	\scale, Scale.mixolydian,
	\freq, Pseq([400,600,500],inf),
	\freq, Pwhite(40,100.0),
	\ffreq, 1900,
	\isRest, false,
	\xsustain, 0.1,
	\legato, 1.51,
	\dur, 1/3 / 2,
	\amp, 1.3 * Pkey(\amp),
));

Ndef(~name+++\fx, {  arg amp=1, pan=0;
	var in;
	var sig;
	in = InFeedback.ar(BusDef(~name+++\fx),2);
	sig = in;
	sig = CombL.ar(sig, 0.1,Array.series(5,0.03,0.013),0.4) + sig;
	sig = Disintegrator.ar(sig) + (sig & (sig >> 5));
	sig = sig /4;
	sig = Splay.ar(sig, 1, amp, pan);

	sig;

});
Ndef(~name+++\fx).fadeTime=0.4;

);

// END

Ndef(\ping)[10] = \filter -> { |in|
	var amp = LFNoise2.kr(0.1).range(0.001, 0.1);
	in * SinOsc.ar(LFNoise2.kr(0.1).range(60.midicps,61.midicps) / 4, 0, amp, 1-amp)
};

Ndef(\ping)[15] = \filter -> { |in| Compander.ar(in, in, 0.1, 1, 0.3) };

(

Pdef(~name+++\pre, Pbind(
	\scale, Scale.mixolydian,
	\n, Pwhite(1,4,inf),
	\n, 0,
	\octave, Pclump(Pkey(\n), Prand([6,7], inf)),
//	\degree, Pclump(Pkey(\n), Pwrand([0,2,3,4,5,6], [10,7,3,5,2,1].normalizeSum, inf)),
	\degree, Pclump(Pkey(\n), Place([[0,1,2,3,4], [2,3,4,5,6], [4,3,4,3,6,7], [0,2,1,2,1,4,3,3,5]], inf)),
	\attack, Pclump(Pkey(\n), Pwhite(0.0005, 0.001)),
	\sustain, Pfunc{ |e| e.octave / 4 } + Pwhite(0.01, 0.5, inf),
	\strum, Prand([0, 1/3, 1/4, 1/16, 1/32, 1, 2], inf),
	\strum, 0,
	\detune, Pclump(Pkey(\n), Pwhite(-2.0, 2.0, inf)),
	\ffreq, Pclump(Pkey(\n), Pwhite(200.0, 2000.0, inf)),
	\famt, Pclump(Pkey(\n), Pwhite(3,6, inf)),
	\hdur, Pclump(Pkey(\n), Pwhite(0.05, 0.3, inf)),
	\impdecay, Pclump(Pkey(\n), Pwhite(0.001, 0.01, inf)),
	\amp, Pclump(Pkey(\n), Pwhite(0.01, 0.1, inf)) * 0.1,
	\dur, Prand([1,2,4]/2, inf) + Pwhite(-0.1, 0.1, inf),
	\dur, 1/8,
));

);
