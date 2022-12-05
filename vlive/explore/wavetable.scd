
////////////////////////////////

(
SynthDef(\waver3d, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive, wavetable2, consecutive2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = VOsc.ar(wavetable + ( \pos1.kr(0) + [0, \diff1.kr(0) ]*( consecutive-1 ) ).fold(0,consecutive-1), freq);
	sig2 = VOsc.ar(wavetable2 + ( \pos2.kr(0)+ [0, \diff2.kr(0) ]*( consecutive2-1 ) ).fold(0,consecutive2-1), freq);
	sig = SelectX.ar(\pos3.kr(0.5), [sig1, sig2]);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Balance2.ar(sig[0], sig[1], pan, amp);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\waver3_spread, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive, wavetable2, consecutive2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = VOsc.ar(wavetable + ( \pos1.kr(0) + ((0..7)/7 - 0.5 * \wspread1.kr(0.1) * consecutive-1)).fold(0,consecutive-1), freq);
	sig2 = VOsc.ar(wavetable2 + ( \pos2.kr(0) + ((0..7)/7 - 0.5 * \wspread2.kr(0.1) * consecutive2-1)).fold(0,consecutive2-1), freq);
	sig = SelectX.ar(\pos3.kr(0.5), [sig1, sig2]);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Balance2.ar(sig[0], sig[1], pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\waver3d_envspread, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive, wavetable2, consecutive2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([0,1,0],[0.1,0.8])), \t_trig.kr(1));
	env2 = EnvGen.kr(\env2.kr(Env([0,1,0],[0.1,0.8])), \t_trig.kr(1));
	sig1 = VOsc.ar(wavetable + env1 + ( \pos1.kr(0) + ((0..7)/7 - 0.5 * \wspread1.kr(0.1) * consecutive-1)).fold(0,consecutive-1), freq);
	sig2 = VOsc.ar(wavetable2 + env2 + ( \pos2.kr(0) + ((0..7)/7 - 0.5 * \wspread2.kr(0.1) * consecutive2-1)).fold(0,consecutive2-1), freq);
	sig = SelectX.ar(\pos3.kr(0.5), [sig1, sig2]);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Balance2.ar(sig[0], sig[1], pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);

(
WavetableDef(\multi, [
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Saw/Cos Saw.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Misc - Assymetrical/Asymmetrical 018.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine Power2.wav",
]);
WavetableDef(\multi2, [
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Saw/Cos Saw.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Misc - Assymetrical/Asymmetrical 018.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Classic - Sine/Sine Power2.wav",
]);
WavetableDef(\multi3, [
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/FM - Dual/FM Dual 1 9 2.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/AM - Simple NonSine/AM Squ07 Squ02.wav",
	"/home/ggz/Musique/sc/wavetable/archwavetable/Architecture Waveforms 2010 Wav24/Formants - Sine/Formant 09.wav",
]);
)

(
Pdef(\zed, 
	Pmono(
		 \waver3d_envspread,
		\wavetable, WavetableDef(\multi),
		\consecutive, WavetableDef(\multi).consecutive.size,
		\wavetable2, WavetableDef(\multi3),
		\consecutive2, WavetableDef(\multi3).consecutive.size,
		\degree, Pseq([0,4,-1,3],inf),
		\pos1, ~pmodenv.(Pseq([0,1],1), Pwhite(11,8.0,inf)).loop,
		\diff1, ~pmodenv.(Pseq([0,0.1,0.01],1), Pwhite(1,8.0,inf)).loop,
		\pos2, ~pmodenv.(Pseq([0,1],1), Pwhite(11,8.0,inf)).loop,
		\diff2, ~pmodenv.(Pseq([0,0.1,0.01],1), Pwhite(1,8.0,inf)).loop,
		\pos3, ~pmodenv.(Pseq([0,1],1), Pwhite(1/8,1.0,inf)).loop,
		\wspread1, ~pmodenv.(Pseq([0,1],1), 8).loop,
		\wspread2, ~pmodenv.(Pseq([0.3,0,1],1), 7).loop,
		\trig, 1,
		//\wspread1, Pseq([0,1],inf),
		\lpfr, 10,
		\rq, 0.9,
		\octave, [3,4,5],
		\dur, 1,
		//\out, BusDef(\sendbus1, \audio),
		\amp, 0.1/4 * [1,1/2,1/8],
	)
).play;
);
Pdef(\zed).clear;
WavetableDef(\multi).consecutive

(
Pdef(\zed, 
	Pbind(
		 \instrument, \waver3d_envspread,
		\wavetable, WavetableDef(\multi),
		\consecutive, WavetableDef(\multi).consecutive.size,
		\wavetable2, WavetableDef(\multi2),
		\consecutive2, WavetableDef(\multi2).consecutive.size,
		\pos1, Pseq([0,0.3],inf),
		\pos2, Pseq([1,0,0.3],inf),
		\pos3, Pseq([0,0.4,1],inf),
		\degree, Pseq([
			[ 0, 2,4 ],
			[ 0, 2,4s ],
		],inf) + Pstep(Pseq([0,5,1,2],inf),4),
		\dur, 1/4,
		\scale, Scale.minor,
		\amp, 0.1/8 ,
		\out, BusDef(\sendbus1, \audio),
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		 \instrument, \waver3d_envspread,
		\wavetable, WavetableDef(\multi),
		\consecutive, WavetableDef(\multi).consecutive.size,
		\wavetable2, WavetableDef(\multi2),
		\consecutive2, WavetableDef(\multi2).consecutive.size,
		\pos1, Pseq([0,0.3,1,0.5,0.7],inf),
		\pos2, Pseq([1,0,0.3,0.7],inf),
		\pos3, Pseq([0,0.4,1,Pwhite(0,1.0,2),0.1],inf),
		\degree, Pseq([
			[ 0, 2,4 ],
			[ 0, 2,4s ],
			Ptuple([ 0, 2, Prand([4s,4s,4s,4,4,4,4,5s,5b,4b,7,6,5],1) ]),
			//[ 0, 3s,4 ],
		],inf) + Pstep(Pseq([0,-1],inf),4),
		\dur, 1/4,
		\scale, Scale.minor,
		\amp, 0.1/8 ,
		\out, BusDef(\sendbus1, \audio),
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		 \instrument, \waver3d_envspread,
		\wavetable, WavetableDef(\multi),
		\consecutive, WavetableDef(\multi).consecutive.size,
		\wavetable2, WavetableDef(\multi2),
		\consecutive2, WavetableDef(\multi3).consecutive.size,
		\pos1, Pseq([0,0.3,1,0.5,0.7],inf),
		\pos2, Pseq([1,0,0.3,0.7],inf),
		\pos3, Pseq([0,0.4,1,Pwhite(0,1.0,2),0.1],inf),
		\degree, Pseq([
			[ 0, 2,4 ],
			[ 0, 2,4s ],
			Ptuple([ 0, 2, Prand([4s,4s,4s,4,4,4,4,5s,5b,4b,7,6,5],1) ]),
			//[ 0, 3s,4 ],
		],inf),
		\mtranspose, Pstep(Pseq([0,1,-1,-1],inf),2),
		\dur, 1/4,
		\scale, Scale.minor,
		\amp, 0.1/8 ,
		\out, BusDef(\sendbus1, \audio),
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		 \instrument, \waver3d_envspread,
		\wavetable, WavetableDef(\multi),
		\consecutive, WavetableDef(\multi).consecutive.size,
		\wavetable2, WavetableDef(\multi3),
		\consecutive2, WavetableDef(\multi3).consecutive.size,
		\pos1, Pseq([0,0.3,1,0.5,0.7],inf),
		\pos2, Pseq([1,0,0.3,0.7],inf),
		\pos3, Pseq([0,0.4,1,Pwhite(0,1.0,2),0.1],inf),
		\wspread2, Pseq([0,0.1,0.01],inf),
		\wspread1, Pseq([0,0.1,0.01,1],inf),
		\degree, Pseq([
			[ 0, 2,4 ],
			[ 0, 2,4s ],
			Ptuple([ 0, 2, Prand([4s,4s,4s,4,4,4,4,5s,5b,4b,7,6,5],1) ]),
			//[ 0, 3s,4 ],
		],inf),
		\mtranspose, Pstep(Pseq([0,1,-1,-1],inf),2),
		\dur, 1/8 * Pstep(Pseq([1,2,4],inf),8),
		\scale, Scale.minor,
		\legato, 0.1* Pseg(Pseq([1/4,5],inf),Prand([3,4,5],inf)),
		\amp, 0.1/2 ,
		\strum, 0.1 * Pseg(Pseq([1/4,5],inf),8),
		//\out, BusDef(\sendbus1, \audio),
	)
).play;
);

////// added freqdiff on vosc 2

(
SynthDef(\waver3d_adv, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive, wavetable2, consecutive2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	sig1 = VOsc.ar(wavetable + ( \pos1.kr(0) + [0, \diff1.kr(0) ]*( consecutive-1 ) ).fold(0,consecutive-1), freq);
	sig2 = VOsc.ar(wavetable2 + ( \pos2.kr(0)+ [0, \diff2.kr(0) ]*( consecutive2-1 ) ).fold(0,consecutive2-1), freq + \freqdiff.kr(0));
	sig = SelectX.ar(\pos3.kr(0.5), [sig1, sig2]);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Balance2.ar(sig[0], sig[1], pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	pos1: \unipolar,
	pos2: \unipolar,
	pos3: \unipolar,
	diff1: \unipolar,
	diff2: \unipolar,
	freqdiff: ControlSpec(0,10,\lin)
))).add;
Pdef(\part).reset;
);
WavetableDef(\multi).consecutive.size

Spec.add(\wavetable, ParamWavetableSpec())
Spec.add(\wavetable2, ParamWavetableSpec())

Pdef(\waver3d).edit
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
			Pbind(
				//\consecutive, Pkey(\wavetable).consecutive.size,
				\consecutive, Pkey(\wavetable).collect({arg x; x.consecutive.size}),
				\consecutive2, Pkey(\wavetable2).collect({arg x; x.consecutive.size}),
			)<>
		Pdef(\waver3d, Pbind( \instrument, \waver3d_adv,))<>
		Pbind(
			\instrument, \waver3d_adv,
			\wavetable, WavetableDef(\multi),
			\wavetable2, WavetableDef(\multi3),
			//\pos1, 0.41,
			\note, Pseq([
				0,6,5,4,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);

////// added freqdiff on top level + ringmod
(
SynthDef(\waver3d_adv, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive, wavetable2, consecutive2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq + [ [0, \freqdiff.kr(0)] ];
	sig1 = VOsc.ar(wavetable + ( \pos1.kr(0) + [0, \diff1.kr(0) ]*( consecutive-1 ) ).fold(0,consecutive-1), freq);
	sig1.debug("sig1");
	sig2 = VOsc.ar(wavetable2 + ( \pos2.kr(0)+ [0, \diff2.kr(0) ]*( consecutive2-1 ) ).fold(0,consecutive2-1), freq + \freq2diff.kr(0));
	sig = SelectX.ar(\pos3.kr(0.5) * 2, [sig1, sig2, sig1 * ( sig2 + 1 )]);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Balance2.ar(sig[0], sig[1], pan, amp).sum;
	sig.debug("sig");
	Out.ar(out, sig);
}, metadata:(specs:(
	pos1: \unipolar,
	pos2: \unipolar,
	pos3: \unipolar,
	diff1: \unipolar,
	diff2: \unipolar,
	freqdiff: ControlSpec(0,10,\lin),
	freq2diff: ControlSpec(0,10,\lin),
))).add;
Pdef(\part).reset;
);

Pdef(\waver3d).edit
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
			Pbind(
				//\consecutive, Pkey(\wavetable).consecutive.size,
				\consecutive, Pkey(\wavetable).collect({arg x; x.consecutive.size}),
				\consecutive2, Pkey(\wavetable2).collect({arg x; x.consecutive.size}),
			)<>
		Pdef(\waver3d, Pbind( \instrument, \waver3d_adv,))<>
		Pbind(
			\instrument, \waver3d_adv,
			\wavetable, WavetableDef(\multi),
			\wavetable2, WavetableDef(\multi3),
			//\pos1, 0.41,
			\note, Pseq([
				0,6,5,4,
			],inf),
			\octave, 3,
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);



////// sum earlier to save cpu
// added fm
(
SynthDef(\waver3d_adv, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, wavetable, consecutive, wavetable2, consecutive2;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq + [ [0, \freqdiff.kr(0)] ];
	sig1 = VOsc.ar(wavetable + ( \pos1.kr(0) + [0, \diff1.kr(0) ]*( consecutive-1 ) ).fold(0,consecutive-1), freq);
	sig1 = sig1.flop.mean;
	sig1.debug("sig1");
	sig2 = VOsc.ar(wavetable2 + ( \pos2.kr(0)+ [0, \diff2.kr(0) ]*( consecutive2-1 ) ).fold(0,consecutive2-1), freq + \freq2diff.kr(0) * ( sig1 * \fmamp.kr(0.1) + 1 ));
	sig2 = sig2.flop.mean;
	sig = SelectX.ar(\pos3.kr(0.5) * 2, [sig1, sig2, sig1 * ( sig2 + 1 )]);

	sig1 = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = SelectX.ar(\lpmix.kr(1), [sig, sig1]);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Balance2.ar(sig[0], sig[1], pan, amp);
	sig.debug("sig");
	Out.ar(out, sig);
}, metadata:(specs:(
	pos1: \unipolar,
	pos2: \unipolar,
	pos3: \unipolar,
	diff1: \unipolar,
	diff2: \unipolar,
	freqdiff: ControlSpec(0,10,\lin),
	freq2diff: ControlSpec(0,10,\lin),
	fmamp: ControlSpec(0,10,\lin),
))).add;
Pdef(\part).reset;
);

Spec.add(\lpmix, \unipolar);
Pdef(\waver3d).edit
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
			Pbind(
				//\consecutive, Pkey(\wavetable).consecutive.size,
				\consecutive, Pkey(\wavetable).collect({arg x; x.consecutive.size}),
				\consecutive2, Pkey(\wavetable2).collect({arg x; x.consecutive.size}),
			)<>
		Pdef(\waver3d, Pbind( \instrument, \waver3d_adv,))<>
		Pbind(
			\instrument, \waver3d_adv,
			\wavetable, WavetableDef(\multi),
			\wavetable2, WavetableDef(\multi3),
			//\pos1, 0.41,
			\note, Pseq([
				0,6,5,4,
			],inf),
			\octave, [3,4],
			\dur, 1/4,
			\amp, 0.1,
		),
		
	])
)).play;
);



