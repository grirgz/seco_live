
~t = 185/4/60; TempoClock.default.tempo = ~t;

(
SynthDef(\basicpadfm, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpenv.kr(Env([1,2,1],[4.1,4.8])), 1);
	env2 = EnvGen.kr(\fmenv.kr(Env([0,2,1],[4.1,4.8])), 1);
	sig1 = SinOsc.ar(freq * [1,1+\det.kr(0.00001)] * ( SinOsc.ar(freq*[2,1/2,1+\det.kr]).sum * env2 + 1 ));
	sig2 = LFSaw.ar(freq * [1+\det2.kr(0),1+\det.kr]);
	sig2 = sig2 * EnvGen.kr(\sawenv.kr(Env([0,1,0],[1.1,1.8])), 1);
	sig2 = LPF.ar(sig2, \lpf.kr(8000) * env1);
	sig2 = sig2 * 1;
	sig = SelectX.ar(\oscmix.kr(0.5), [sig1, sig2]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, [1,-1], amp).mean;
	Out.ar(out, sig);
}, metadata:(specs:(
	lpenv: ParamEnvSpec(\lofreq),
	fmenv: ParamEnvSpec(\lofreq),
	sawenv: ParamEnvSpec(\lofreq),
	det: ControlSpec(0.000001,0.1,\exp),
	det2: ControlSpec(0.000001,0.1,\exp),
))).add;
);
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

	//sig = sig * EnvGen.ar(\adsEnv.adsr(0.01,0.1,0.8,0.4),gate,doneAction:2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\star, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env1;
	var fspread;
	env1 = EnvGen.kr(Env([1,2,1],[1.7,0.8]), 1);
	fspread = 0.0007 + Rand(0,0.007);
	sig = SinOsc.ar(freq * ((0..7)/7 - 0.5 * fspread + 1));
	sig = sig * ( sig/(sig+1.1)*50 * env1 ).clip(0.5);
	sig1 = sig * (sig.abs > Rand(0.1,0.7));
	sig = SelectX.ar( EnvGen.kr(Env([0,1,0],[0.1+Rand(0,2.0),0.1+Rand(0,2.0)]), 1), [sig, sig1]);
	sig = sig * 2;
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(1.01,0.1,1,1.1)),gate,doneAction:doneAction);
	sig = sig /10;
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\oscsmpcomp, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, bufnum;
	var sig;
	var osc;
	var phase;
	var posenv;
	osc = SinOsc.ar(freq) *  \oscrange.kr(1);
	posenv = EnvGen.kr(\posenv.kr(Env([0,1,1.1,0],[0.1,1,2.8])), 1, levelScale:\levelScale.kr(1));
	phase = \pos.kr(0) + posenv * BufSampleRate.kr(bufnum);
	sig = BufRd.ar(2, bufnum, phase + osc % BufFrames.kr(bufnum), 1);
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(0.01), \cpabove.kr(0.001), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	//sig = sig * \compgain.kr(1/0.1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

////////


(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[0,4,7],
				[0,4,7]+4,
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\lpf, 1000,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \basicpadfm,
		\adsr, Pseq([
			[ Env.adsr(0.1,0.1,0.8,0.1) ],
		],inf),
		\amp, 0.1/2,
	)
);
);


ProtoDef(\piano).startControl(Pdef(\melo))

Pdef(\melo).edit
Pdef(\melo).presetCompileString.editorInsert
Pdef(\melo).asParamGroup.getPbindCompileString.editorInsert
(

Pbind(
	'dur', 1.0,
	'legato', 0.8,
	'out', 0,
	'amp', 0.1,
	'pan', 0.0,
	'freq', 261.6255653006,
	'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
	'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
	'det', 0.0038771869866968,
	'det2', 0.02522980393744,
	'sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
	'lpf', 4828.420835145,
	'oscmix', 0.1,
	'adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000322858, 0.10000000322858, 0.49109944473646 ], [ -4.0, -4.0, -4.0 ], 2.0),
)

);

(
Pdef('melo').setVal('lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]));
Pdef('melo').setVal('fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]));
Pdef('melo').setVal('det', 0.0038771869866968);
Pdef('melo').setVal('det2', 0.02522980393744);
Pdef('melo').setVal('sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]));
Pdef('melo').setVal('lpf', 4828.420835145);
Pdef('melo').setVal('oscmix', 0.1);
Pdef('melo').setVal('adsr', Env([ 0.0, 1.0, 0.80000001192093, 0.0 ], [ 0.10000000322858, 0.10000000322858, 0.49109944473646 ], [ -4.0, -4.0, -4.0 ], 2.0));

);


(
Pdef(\demo, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\lpf, 1000,
			\octave, 4,
			\dur, 4,
			\amp, 0.1,
			\strum, 0.2,
	'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
	'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
	'det', 0.0038771869866968,
	'det2', 0.02522980393744,
	'sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
	'lpf', 4828.420835145,
	'oscmix', 0.1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\lpf, 1000,
			\octave, 4,
			\legato, 0.4,
			\dur, 4,
			\amp, 0.1/3,
			\strum, 0.2,
	'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
	'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
	'det', 0.0038771869866968,
	'det2', 0.02522980393744,
	'sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
	'lpf', 4828.420835145,
	'oscmix', 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf),
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8/2,
		),
		
	])
)).play;
)


Pbindef(\melo1instr).edit
Pbindef(\melo1instr).presetCompileString.editorInsert
(
Pdef(\melo1instr,
	Pbind(
		\instrument, \basicpadfm,
	),
);
Pdef('melo1instr').setVal('amp', 0.04);
Pdef('melo1instr').setVal('lpenv', Env([ 1.0000000686224, 0.1, 1.0000000686224 ], [ 0.66321243523316, 1.0 ], [ 0.0, 0.0 ]));
Pdef('melo1instr').setVal('fmenv', Env([ 0.1, 0.1, 1.0000000686224 ], [ 0.87046632124352, 1.0 ], [ 0.0, 0.0 ]));
Pdef('melo1instr').setVal('det', 0.00240409918351);
Pdef('melo1instr').setVal('sawenv', Env([ 1.0419745331918, 0.1, 0.1 ], [ 0.098445595854922, 1.0 ], [ 0.0, 0.0 ]));
Pdef('melo1instr').setVal('oscmix', 0.1);

);

NoteTimeline(\melo1, Pdef(\melo1instr))
NoteTimeline(\melo1).edit

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		NoteTimeline(\melo1).asPattern,
		Pbind(
			\instrument, \basicpadfm,
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				Pser([
					5,8,
				],8),
				Pser([
					7,10,
				],8),
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\lpf, 1000,
			\octave, 4,
			\legato, 0.4,
			\dur, 1/4,
			\amp, 0.1/3,
			\strum, 0.2,
	'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
	'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
	'det', 0.0038771869866968,
	'det2', 0.02522980393744,
	'sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
	'lpf', 4828.420835145,
	'oscmix', 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf),
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8/2,
		),
		
	])
)).play;
)
(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		NoteTimeline(\melo1).asPattern,
		Pbind(
			\instrument, \basicpadfm,
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				Pser([
					5,8,
				],8),
				Pser([
					7,10,
				],8),
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\lpf, 1000,
			\octave, 4,
			\legato, 0.4,
			\dur, 1/4,
			\amp, 0.1/3,
			\strum, 0.2,
	'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
	'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
	'det', 0.0038771869866968,
	'det2', 0.02522980393744,
	'sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
	'lpf', 4828.420835145,
	'oscmix', 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf),
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8/2,
			\lag, -0.04,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(\out, BusDef(\sendbus2, \audio)) <>
		NoteTimeline(\melo1).asPattern,
		Pbind(
			\instrument, \basicpadfm,
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				Pser([
					5,8,
				],8),
				Pser([
					7,10,
				],8),
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),
			\lpf, 1000,
			\octave, 4,
			\legato, 0.4,
			\dur, 1/4,
			\amp, 0.1/3,
			\strum, 0.2,
	'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
	'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
	'det', 0.0038771869866968,
	'det2', 0.02522980393744,
	'sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
	'lpf', 4828.420835145,
	'oscmix', 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf),
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8/2,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \basicpadfm,
			\note, Pseq([
				0,-2,-4,
			],inf),
			\octave, [4,6],
			\det, 0.02,
			\det2, 0.02,
			\oscmix, 0.2,
			\strum, Pseg(Pseq([0,0.2],inf),8*3),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.3,0.4,1.1) ],
			],inf),
			\dur, Pseq([1,0.75,0.25],inf)*2,
			\amp, 0.1/4,
		),
		
	])
)).play;
)

(
SynthDef(\sawploc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\melo, Pbind(
	\instrument, \sawploc,
	\dur, 1,
	\amp, 0.1,
));
)

////////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \default,
			\note, Pseq([
				0,-4,
			],inf),
			\octave, 3,
			\legato, 0.1,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54,
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
		)
		
	])
)).play;
);
 

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\lpf, 1000,
			\octave, 4,
			\dur, 4,
			\strum, 0.2,
			'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
			'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
			'det', 0.0038771869866968,
			'det2', 0.02522980393744,
			'sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
			'lpf', 4828.420835145,
			'oscmix', 0.1,
			\oscmix, ~pmodenv.(Pseq([0.1,0.1,0.1,0,1,0.51,0.74],inf), 8),
			\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),

			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \noisybass,
			\note, Pstep(Pseq([
				5,8,
				7,10,
			],inf),2)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54,
			\legato, 0.23,
			\speed, Pwhite(0.9,1,inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
		)
		
	])
)).play;
)

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			//\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\lpf, 1000,
			\octave, 4,
			\dur, 4,
			\strum, 0.2,
			'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
			'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
			'det', 0.0038771869866968,
			'det2', 0.02522980393744,
			'sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
			'lpf', 4828.420835145,
			'oscmix', 0.1,
			\legato, 0.1,
			//\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),

			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \noisybass,
			\note, Pstep(Pseq([
				5,8,
				7,10,
			],inf),2)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\legato, 0.1,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54,
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.24,
			\legato, 0.3,
			\speed, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			//\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\lpf, 1000,
			\octave, 4,
			\dur, 4,
			\strum, 0.2,
			'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
			'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
			'det', 0.0038771869866968,
			'det2', 0.02522980393744,
			'sawenv', Env([ 0.92105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
			'lpf', 4828.420835145,
			'oscmix', 0.1,
			\legato, 0.1,
			//\oscmix, ~pmodenv.(Pseq([0,1,0.51,0.74],inf), 8),

			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \noisybass,
			\note, Pstep(Pseq([
				1,5,3,13,
				7,10,10,3,
			],inf),1)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,1],inf),8),
			\legato, 0.1,
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,1,1,0, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf),
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.24,
			\legato, 0.3,
			\speed, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1 * Ppatlace([
				1,Pwhite(0.1,0.7),
			],inf),
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			//\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\lpf, 1000,
			\octave, 4,
			\dur, 4,
			\strum, 0.2,
			\strum, Pseq([
				0.2,0,
			],inf).stutter(4),
			'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
			'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
			'det', 0.0038771869866968,
			'det2', 0.02522980393744,
			'sawenv', Env([ 0.02105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
			'lpf', 4828.420835145,
			'oscmix', 0.1,
			\legato, 0.8,
			\oscmix, ~pmodenv.(Pseq([0,0,1,0.51,0.74],inf), 8),

			\amp, 0.1/2,
		),
		PmonoArtic( \noisybass,
			\note, Pstep(Pseq([
				1,5,3,13,
				7,10,10,3,
			],inf),1)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,0.5,0.1,1,1.1],inf),1.1),
			\legato, Prand([1,0.1,0.4],inf),
			\legato, 1,
			\trigx, Pseq([0,0,1,0, 0,1,0,1],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,1,1,0, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf),
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.24,
			\legato, 0.3,
			\speed, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1 * Ppatlace([
				1,Pwhite(0.1,0.7),
			],inf),
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			//\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\lpf, 1000,
			\octave, 4,
			\dur, 4,
			\strum, 0.2,
			\strum, Pseq([
				0.2,0,
			],inf).stutter(4),
			'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
			'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
			'det', 0.0038771869866968,
			'det2', 0.02522980393744,
			'sawenv', Env([ 0.02105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
			'lpf', 4828.420835145,
			'oscmix', 0.1,
			\legato, 0.8,
			\oscmix, ~pmodenv.(Pseq([0,0,1,0.51,0.74],inf), 8),

			\amp, 0.1/2,
			\isRest, true,
		),
		Pbind(
			\instrument, \star,
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\dur, 4,
			\octave, 4,
			\legato, 0.1,
			\strum, 0.3,
			\amp, 0.1,
		),
		PmonoArtic( \noisybass,
			\note, Pstep(Pseq([
				1,5,3,13,
				7,10,10,3,
			],inf),1)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,0.5,0.1,1,1.1],inf),1.1),
			\legato, Prand([1,0.1,0.4],inf),
			//\legato, 1,
			\trigx, Pseq([0,0,1,0, 0,1,0,1],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,1,1,0, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf),
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.24,
			\legato, 0.3,
			\speed, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1 * Ppatlace([
				1,Pwhite(0.1,0.7),
			],inf),
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			//\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\lpf, 1000,
			\octave, 4,
			\dur, 4,
			\strum, 0.2,
			\strum, Pseq([
				0.2,0,
			],inf).stutter(4),
			'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
			'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
			'det', 0.0038771869866968,
			'det2', 0.02522980393744,
			'sawenv', Env([ 0.02105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
			'lpf', 4828.420835145,
			'oscmix', 0.1,
			\legato, Pstep(Pseq([0.8,0.4,0.1],inf),8),
			\oscmix, ~pmodenv.(Pseq([0,0,1,0.51,0.74],inf), 8),

			\amp, 0.1/4,
			//\isRest, true,
		),
		Pbind(
			\instrument, \star,
			\note, Pseq([
				[5,8,13,15,17].mirror,
				[7,10,13,15,17].mirror,
			],inf).stutter(2),
			\dur, 2,
			\octave, 5,
			\legato, 0.1,
			\strum, 0.3,
			\amp, 0.2,
		),
		PmonoArtic( \noisybass,
			\note, Pstep(Pseq([
				1,5,3,13,
				7,10,10,3,
			],inf),1)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,0.5,0.1,1,1.1],inf),1.1),
			\legato, Prand([1,0.1,0.4],inf),
			//\legato, 1,
			\trigx, Pseq([0,0,1,0, 0,1,0,1],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 0,1,0,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf),
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.24,
			\legato, 0.3,
			\speed, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				0,0,1,0,0,1,1,1,
				0,0,1,0,1,0,0,1,
				0,1,1,0,1,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 2 * Ppatlace([
				1,Pwhite(0.1,0.7),
			],inf),
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \oscsmpcomp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef('vfoley/box1.flac'),
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pseg(Pwhite(0,20.0),8),
			\pos, 0.43,
			\note, Pseq([
				0,4,7,4,
			],inf),
			\levelScale, ~pmodenv.(Pseq([0.01,0.02],1), 8).loop,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,1,5.8]) ],
				[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 3,
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.2,0.4) ],
			],inf),
			\oscrange, 160,
			\note, Pseq([
				[5,8,13,15,17].mirror,
				[7,10,13,15,17].mirror,
			],inf).stutter(2),
			\dur, 2,
			\octave, Pseq([4,5],inf),
			\legato, Pseg(Pseq([0.1,0.1,1],inf),8*2),
			\strum, Pseg(Pseq([0.1,0.51],inf),8*3),
			\dur, 1,
			\amp, 0.2,
		),
		PmonoArtic( \noisybass,
			\note, Pstep(Pseq([
				1,5,3,13,
				7,10,10,3,
			],inf),1)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,0.5,0.1,1,1.1],inf),1.1),
			\legato, Prand([1,0.1,0.4],inf),
			//\legato, 1,
			\trigx, Pseq([0,0,1,0, 0,1,0,1],inf),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0
				],8*4),
				Pseq([
					1,0,0,0, 0,1,0,1,
					1,0.4,0.4,0.4, 0,1,0,1,
					1,0,0,0, 0,1,0,1,
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\amp, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \oscsmpcomp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef('vfoley/box1.flac'),
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pseg(Pwhite(0,20.0),8),
			\pos, 0.43,
			\note, Pseq([
				0,4,7,4,
			],inf),
			\levelScale, ~pmodenv.(Pseq([0.01,0.02],1), 8).loop,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,1,5.8]) ],
				[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 3,
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.2,0.4) ],
			],inf),
			\oscrange, 160,
			\note, Pseq([
				[5,8,13,15,17].mirror,
				[7,10,13,15,17].mirror,
			],inf).stutter(2),
			\dur, 2,
			\octave, Pseq([4,5],inf),
			\legato, Pseg(Pseq([0.1,0.1,1],inf),8*2),
			\strum, Pseg(Pseq([0.1,0.51],inf),8*3),
			\amp, 0.2,
		),
		Pbind(
			\instrument, \oscsmpcomp,
			//\bufnum, TrackDef(\smp).elAt(0,1).source.buffer,
			\bufnum, BufDef('vfoley/box1.flac'),
			//\pos, ~pmodenv.(Pseq([0,8,15,4]/1+1,1), 8).loop,
			\pos, Pseg(Pwhite(0,20.0),8),
			\pos, 0.40,
			\note, Pseq([
				0,4,7,4,
			],inf),
			\levelScale, ~pmodenv.(Pseq([0.01,0.02],1), 8).loop,
			\posenv, Pseq([
				[ Env([0,0.51,0.1,0.1].integrate,[0.02,1,5.8]) ],
				[ Env([0,0.51,0.1,1.1].integrate,[0.02,1,5.8]) ]
			],inf),
			\octave, 3,
			//\oscrange, ~pmodenv.(Pseq([100,20000],1), 8).loop,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.2,0.4) ],
			],inf),
			\oscrange, 160,
			\note, Pseq([
				Pseq([
					Rest(1),Rest(1),
				],4*4),
				Pseq([
					[5,13],[7,15]
				],inf),
			],inf),
			\dur, 1/2,
			\octave, Pseq([4,5],inf),
			\legato, Pseg(Pseq([0.1,0.1,1],inf),8*2),
			\strum, Pseg(Pseq([0.1,0.51],inf),8*3),
			\amp, 0.2,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_echo,
			\inbus, BusDef(\ifx1, \audio),
			\delay, 1/Prand([1,2,4,8,16],inf)/~t,
			\addAction, \addToTail,
			\mix, 0.2,
			\lag, 0.0009,
			\dur, 1,
		),
		PmonoArtic( \noisybass,
			\note, Pstep(Pseq([
				1,5,3,13,
				7,10,10,3,
			],inf),1)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,0.5,0.1,1,1.1],inf),1.1),
			\legato, Prand([1,0.1,0.4],inf),
			//\legato, 1,
			\trigx, Pseq([0,0,1,0, 0,1,0,1],inf),
			\dur, 1/8,
			\isRest, Pseq([
				Pseq([
					0
				],8*4),
				Pseq([
					1,0,0,0, 0,1,0,1,
					1,0.4,0.4,0.4, 0,1,0,1,
					1,0,0,0, 0,1,0,1,
					1,1,1,1, 1,1,1,1,
				],inf),
			],inf).coin.not,
			\amp, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
		),
	])
)).play;
);



(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = SinOsc.ar(freq)* SinOsc.ar(1/4,mul:0.2);
	sig = Compander.ar(sig, sig, \cpt.kr(0.1), \cpbelow.kr(0.001), \cpabove.kr(0.1), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig = Pan2.ar(sig, pan, amp);
	Amplitude.ar(sig[0]).poll;
	sig;
}).play;
);


(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			//\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\lpf, 1000,
			\octave, 4,
			\dur, 4,
			\strum, 0.2,
			\strum, Pseq([
				0.2,0,
			],inf).stutter(4),
			'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
			'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
			'det', 0.0038771869866968,
			'det2', 0.02522980393744,
			'sawenv', Env([ 0.02105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
			'lpf', 4828.420835145,
			'oscmix', 0.1,
			\legato, 0.8,
			\oscmix, ~pmodenv.(Pseq([0,0,1,0.51,0.74],inf), 8),

			\amp, 0.1/2,
		),
		PmonoArtic( \noisybass,
			\note, Pstep(Pseq([
				1,5,3,13,
				7,10,10,3,
			],inf),1)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,0.5,0.1,1,1.1],inf),1.1),
			\legato, Prand([1,0.1,0.4],inf),
			\legato, 1,
			\trigx, Pseq([0,0,1,0, 0,1,0,1],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,1,1,0, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf) + 0.03,
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23*8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.24,
			\legato, 0.3,
			\speed, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1 * Ppatlace([
				1,Pwhite(0.1,0.7),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[919].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,1,0,
				1,0,0,0, 0,0,0,1,
				0,0,1,1, 0,1,1,0,

				1,0,0,0, 0,0,1,0,
				0,0,0,1, 0,1,0,0,
				1,0,0,0, 0,1,1,1,
				0,1,1,0, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[276].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,1,1, 1,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,1,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[747].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
)

(
Pdef(\part, Pdef(\xdemo, 
	Ppar([
		Pbind(
			\instrument, \basicpadfm,
			//\det, ~pmodenv.(Pseq([0.00001,0.02,0.0001,0.04],inf), 8),
			\note, Pseq([
				[5,8,13,15,17],
				[7,10,13,15,17],
			],inf),
			\lpf, 1000,
			\octave, 4,
			\dur, 4,
			\strum, 0.2,
			\strum, Pseq([
				0.2,0,
			],inf).stutter(4),
			'lpenv', Env([ 0.29126321695058, 1.6966857859051, 0.6628703096844 ], [ 0.32311338926905, 0.76231450831602 ], [ 0.0, 0.0 ]),
			'fmenv', Env([ 1.5085906198661, 0.80941798435932, 0.66287044614763 ], [ 0.0926509675801, 0.9802363177649 ], [ 0.0, 0.0 ]),
			'det', 0.0038771869866968,
			'det2', 0.02522980393744,
			'sawenv', Env([ 0.02105529060162, 0.92105532333279, 0.84834296477586 ], [ 0.10449275499315, 0.97870122524122 ], [ 0.0, 0.0 ]),
			'lpf', 4828.420835145,
			'oscmix', 0.1,
			\legato, 0.8,
			\oscmix, ~pmodenv.(Pseq([0,0,1,0.51,0.74],inf), 8),

			\amp, 0.1/2,
		),
		PmonoArtic( \noisybass,
			\note, Pstep(Pseq([
				1,5,3,13,
				7,10,10,3,
			],inf),1)-12,
			\octave, 3,
			\legato, Pseg(Pseq([0.1,0.5,0.1,1,1.1],inf),1.1),
			\legato, Prand([1,0.1,0.4],inf),
			\legato, 1,
			\trigx, Pseq([0,0,1,0, 0,1,0,1],inf),
			\dur, 1/8,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,1,1,0, 1,0,1,1,
				1,0,1,1, 1,0,1,1,
			],inf).coin.not,
			\amp, 0.1 * Pseq([1,0.5,0.5,0.5],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.54 + Pseq([0.1,0],inf) + 0.03,
			\speed, Pwhite(0.9,1,inf),
			\legato, 0.23*8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\dur, 1,
			\gain, 1/8,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\isRest, true,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef('vfoley/box1.flac'),
			\pos, 0.04,
			\legato, 0.3,
			\speed, 2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.01) ],
			],inf),
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1 * Ppatlace([
				1,Pwhite(0.1,0.7,1),
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[919].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.2 * Pseq([
				1,1,
				Pwhite(0.2,1,1),1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[276].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 0,0,1,0,
				1,0,1,1, 1,0,0,0,
				0,0,0,0, 1,1,1,1,
				0,1,0,1, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.21,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[747].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
)
