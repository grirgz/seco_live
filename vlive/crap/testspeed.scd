
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \oscsampler3,
			\pos, 1.417,
			\freq, 187,
			\range, 0.001,
			\posenv, Pseq([
				[ Env([0.00,0.04001,0.36].integrate.postln,[0.047,8.1]) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.31,0.2,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8/2,
			\fshift, Pseg(Pwhite(0.4,100.3,inf),1/3),
			\lpmix, Pseq([1,0,0.4],inf),
			\rq, 0.4,
			\hpmix, Pseq([1,0.2,0.4, 0.2,1,0.3],inf),
			\hpfreq, 400 * Pwhite(0.5,3),
			\ffreq, Pseq([
				//3000,
				1020,5240,450,700,
			],inf) * Pwhite(0.4,1.3),
			\amp, 0.1*7 * Pseq([
				Pser([
					1,0.1,0.1,
					1,0.1,0.4,
				],16),
			],inf),
			\bufnum, BufDef('voices/feynman.flac'),
			\bufnum, BufDef('loop/pigs.flac'),

		),
	])
)).play;
);

(
Pbindef(\tapme, 
	\instrument, \oscsampler3,
			\pos, 1.417,
			\freq, 187,
			\range, 0.001,
			\posenv, Pseq([
				[ Env([0.00,0.04001,0.36].integrate.postln,[0.047,8.1]) ],
			],inf),
			\finepos, 1/400,
			\legato, Pseq([
				1,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.31,0.2,0.1) ],
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8/2,
			\fshift, Pseg(Pwhite(0.4,100.3,inf),1/3),
			\lpmix, Pseq([1,0,0.4],inf),
			\rq, 0.4,
			\hpmix, Pseq([1,0.2,0.4, 0.2,1,0.3],inf),
			\hpfreq, 400 * Pwhite(0.5,3),
			\ffreq, Pseq([
				//3000,
				1020,5240,450,700,
			],inf) * Pwhite(0.4,1.3),
			\ampcoef, 0.7,
			\amp, Pkey(\ampcoef) * Pseq([
				Pser([
					1,0.1,0.1,
					1,0.1,0.4,
				],16),
			],inf),
			\bufnum, BufDef('loop/pigs.flac'),

))
)
Pbindef(\tapme).clear


(
Pbindef('djembe1',
	'instrument', 'oscsampler3',
	'pos', 0.28918918918919,
	'range', 8.8649e-06,
	'finepos', 0.001,
	'adsr', Pseq([ [ Env([ 0.0, 1.0, 0.2, 0.0 ], [ 0.01, 0.31, 0.1 ], -4.0, 2) ] ], inf),
	'isRest', Pfunc({ arg ev; ev[\legato] <= 0 }),
	'dur', 0.0625,
	'fshift', PstepSeq([ -516.12901687622, -161.2902879715, -364.51625823975, -580.64520359039, 516.12901687622, 193.54844093323, 193.54844093323, 580.6450843811 ], inf),
	'lpmix', PstepSeq([ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ], inf),
	'rq', 1.1603923963353,
	'hpmix', PstepSeq([ 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1 ], inf),
	'hpfreq', (400 * Pwhite(0.5, 3)),
	'ffreq', PstepSeq([ 0.1, 0.1, 20000.0, 20000.0, 20000.0, 20000.0, 20000.0, 20000.0 ], inf),
	'ampcoef', 0.1999259968021,
	'amp', (Pkey('ampcoef') * Pseq([ Pser([ 1, 0.1, 0.1, 1, 0.1, 0.4 ], 16) ], inf)),
	'bufnum', BufDef('loop/pigs.flac'),
	'posenv', Env([ 0.0, 1.0, 0.57575762271881, 0.30303031206131, 0.0 ], [ 0.024815754358558, 0.025798531855555, 0.053316917270422, 0.12334154546261 ], [ 0.0, 0.0, 0.0, 0.0 ]),
	'levelScale', 0.1,
	'timeScale', 19.603666039143,
	'framerange', 0.1,
	'fineposlag', 0.57456177454204,
	'ffreqtab', [ [ 16.711387612484, 18.041087865931, 578.12423463119, 263.03845811919, 857.08184458813, 1295.9058677944, 263.03845811919, 7.6034481298368 ] ],
).play;
)


PlayerWrapper(Pbindef(\tapme)).edit
WindowDef(\PbindefEditor).front(Pbindef(\tapme))
FileSystemProject.load("libdef/PbindefEditor.scd")
PlayerWrapper(Pbindef(\tapme)).asParamGroup.getPbindCompileString.editorInsert

Pbindef(\tapme).asParamGroup.getParamCompileString
Pbindef(\tapme).edit
Pbindef(\tapme).prese
~self.presetCompileString.editorInsert

(

~self.pbindefKeysParamList.collect({ arg param; 
	if(param.spec.isKindOf(ParamBufferSpec)) {
		"%, %,\n".format(
			param.propertyRoot.asCompileString,
			"BufDef(%)".format(param.spec.tagSpec.unmapKey(param.at(\source).get).asCompileString)
		)
	} {
		"%, %,\n".format(
			param.propertyRoot.asCompileString,
			param.at(\source).getRaw.asCompileString,
		)
	}
}).join
)

Param(Pbindef(\tapme), \bufnum).spec.tagSpec.unmapKey( 12 )
Param(Pbindef(\tapme), \bufnum).spec.tagSpec.keyList
Param(Pbindef(\tapme), \bufnum -> \source).get
Param(Pbindef(\tapme), \instrument -> \source).get
Param(Pbindef(\tapme), \ffreqtab -> \source).getRaw
~self.instrumentParam.at(\source).get
~self.instrumentParam.at(\source)
~self.instrumentParam.at(\source).at(\source).get
PdefParam.associationToArray(~self.instrumentParam.propertyPath)
Pbindef(\tapme).get(\bufnum)
Pbindef(\tapme).set(\bufnum, nil)
Pbindef(\tapme).get(\instrument)
Pbindef(\tapme).source.pairs[1].source
Param()
TagSpecDef
