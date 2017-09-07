
//////////// simple pulse bass
// stereo by detune
// mono synth with octave jump, glissando and legato
(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	sig = Pulse.ar(freq * [1,1.0001]);
	sig = LPF.ar(sig, \lpfr.kr(8.1) * freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);


////////// add cutoff env, much better!

(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);

////////////// change waveform with env

(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.4,0.8]), \trigx.tr(1));
	sig = Saw.ar(freq * [1,1.0001]);
	sig1 = Pulse.ar(freq* [1,1.0001]);
	sig = SelectX.ar(env2, [sig1, sig]);
	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);

////////////// add high frequencies with a distorted BPF, adjust high freq with LPF, add env to dynamize
// the BPF is multichannel with offset from pitch

(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([0,1,0,1],[0.01,0.18,0.18]), \trigx.tr(1));
	sig = Saw.ar(freq * [1,1.0001]);
	sig1 = Pulse.ar(freq* [1,1.0001]);
	sig = SelectX.ar(env2, [sig1, sig]);

	sig1 = sig;
	sig1 = BPF.ar(sig1, freq+( [100,300,200]/8 * env3 )*2 * [ [1,1.001] ],0.1).sum;
	sig1 = ( sig1 * 100 ).clip2(1)/2;
	sig1 = LPF.ar(sig1, 7000);


	sig = LPF.ar(sig, \lpfr.kr(4.1) * freq + env1);
	sig = sig + sig1 / 2;


	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);

/////////////////////////////////////////////////////// start again
////////////// AM applied by env
(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.4,1.1]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([1,1,2,2],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	//sig = sig * ( SinOsc.ar(freq) + 1  );
	sig1 = ( SinOsc.ar(freq) + 1  );
	sig = sig * SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = LPF.ar(sig, \lpfr.kr(8.1) * freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);

/////////////////////////////////////////////////////// 
//////////////  lfo folding with env
(
SynthDef(\noisybass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = freq.lag(0.4);
	env1 = EnvGen.kr(Env([0,0,7000,0],[0.01,0.4,0.8]), \trigx.tr(1));
	env2 = EnvGen.kr(Env([0,0,1,0],[0.01,0.2,1.4]), \trigx.tr(1));
	env3 = EnvGen.kr(Env([1,1,0,0],[0.01,0.4,1.8]), \trigx.tr(1));
	sig = Pulse.ar(freq * [1,1.0001]);
	//sig = sig * ( SinOsc.ar(freq) + 1  );
	sig1 = ( SinOsc.ar(freq) + 1  );
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig * sig1;
	sig = LPF.ar(sig, \lpfr.kr(8.1) * freq);

	sig1 = SinOsc.ar(2*~t).exprange(0.1,1);
	sig1 = SelectX.ar(env2, [DC.ar(1), sig1]);
	sig = sig/4 + LPF.ar(sig.fold2( sig1 ), 10000);

	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, PmonoArtic(\noisybass,
	\degree, Pseq([0,2+12,4,6, 8,4,2,-4],inf),
	\scale, Scale.minor,
	\trigx, 1,
	\legato, Pseq([1,1,1,0.8,0.1,1,1,0.9],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	//\legato, 0.7,
	\octave, 3,
	\dur, 1/2,
	\dur, PdurStutter(Pseq([1,2,2,4],inf), 1/2),
	\amp, 0.1
)).play;
);

