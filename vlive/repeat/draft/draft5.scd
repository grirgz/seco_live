
// INIT
(
SynthDef(\chordar, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([2.00,0.7,1,1.02],[0.01,0.08,3.4])), 1);
	env2 = EnvGen.kr(\env2.kr(Env([0.10,1.4,0.1,0.01],[0.01,0.48,3.4])), 1);
	env3 = EnvGen.kr(\env3.kr(Env([1.10,1.4,0.9,0.01],[0.01,0.48,3.4])), 1);
	sig = LFSaw.ar(freq * (env1) * [[1,1.0000001]] * [0.99999,1,2,1/2]).sum;
	sig = SinOsc.ar(freq* (env1) * [[1,1.0000001]] * [0.99999,1,2,1/2]).sum + sig ;
	sig.debug("sig");
	sig1 = RHPF.ar(sig, \hpfr.kr(3.4) * freq * env1, \hrq.kr(0.5) * env2);
	sig = SelectX.ar(\mixhpf.kr(0.5) * env3, [sig, sig1]);
	sig1 = RLPF.ar(sig, \lpfr.kr(3.4) * freq * env1, \lrq.kr(0.5) * env2);
	sig = SelectX.ar(\mixlpf.kr(0.5) * env3, [sig, sig1]);
	sig1 = sig.tanh;
	sig = SelectX.ar(\mixdist.kr(0.5) * env3, [sig, sig1]);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.9)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * 0.5;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;

SynthDef(\fmsaw, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq  * ( 1 + ( SinOsc.ar(\fmfreq.kr(8)) * \fmamt.kr(1) ));
	sig = SinOsc.ar(freq * [1,1.01,1.001] );
	sig = sig + LFSaw.ar(freq *  [1,1.0001], mul:1/2 * \sawmul.kr(1));
	sig = RLPF.ar(sig, \ffreq.kr(2000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.01,0.8,\release.kr(0.01)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\brownbass, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFPulse.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(16) * freq ).clip(20,20000), \rq.kr(0.6)) + ( sig / 5 );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\pluck, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, coef=0, decay=10;
	var sig;
	var ex;
	ex = WhiteNoise.ar(1);
	//ex = LFSaw.ar(freq);
	//freq = freq * ( 1 + ( SinOsc.ar(17006) * 1 ));
	sig = Pluck.ar(ex, DelayC.ar(gate, 0.1, [0.01,0.032,0.0123] * \dstrum.kr(1)), 20.reciprocal, 1/freq * [1,1/2.2142,1/3.52354], 1, coef:coef).sum;
	sig = sig * 2;
	//sig = sig/2 + FreqShift.ar(sig, [{ 600.0.rand }!5]).flop.mean * 3;
	//sig = RLPF.ar(sig, \lpfr.kr(4)*freq, \rq.kr(0.5)) * 1 + ( sig/4 );
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,[0.2,0.1],0.8,0.4,1,4)),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
SynthDef(\rise, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, time=4;
	var sig;
	var fspread = XLine.kr(\spstart.kr(0.01),\spend.kr(10),time);
	freq= freq* XLine.kr(\start.kr(1),\end.kr(2),time);
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * fspread + 1) * [ [1,1.01] ]);
	sig = sig.debug("sig").mean.debug("sig2");
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * (1+ fspread ) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

Ndef(\verb, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\sendbus1, \audio)), 2); 
	sig =in;
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(0.31), \damp.kr(0.4));
	sig;
});
)

(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\amen, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 4*~t/(137/60),
	\speed, 2*~t/(137/60),
	\pos, Pseq([0,0,0,2],inf)*( 137/60 ),
	\legato, 1,
	\dur, 2,
	\gain, 1/2,
	\amp, 0.1
));

Pdef(\pluck, Pbind(
	\instrument, \pluck,
	\degree, Pseq([
		[ 0,2,4 ] + 0,
		[ 0,2,4 ] + 1,
	],inf),
	\freq, Pseq([40,50,20,60],inf) * Pseg(Pseq([1,100],inf),8*8),
	\dstrum, Pseg(Pseq([0,10],inf),8*2),
	\decay, 0.04,
	\coef, Pseg(Pseq((1..10)/10,inf),1),
	\coef, 0.61,
	\out, BusDef(\sendbus1, \audio),
	\dur, 1/8,
	\amp, 0.1
));
	Pdef(\drums1, 
		Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,1,1,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/4,
			\speed, Pseq([1,0.9,0.8,0.9],inf),
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1/2.2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1,1,-4) ],
			],inf),
			\speed, 0.9,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 9,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\pos, 0.3,
			\dur, 1/8,
			\amp, 0.1,
		)),
			
		])
	);
);

////////// DRAFT
(
Pdef(\rise, Pbind(
	\instrument, \rise,
	\degree, Pseq([0],inf),
	\dur, 4,
	\amp, 0.1
)).play;
);
(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\plop, Pbind(
	\instrument, \playersec,
	\bufnum, BufDef(\amen),
	\degree, Pseq([0],inf),
	\speed, 1/2,
	\pos, 2*(137/60)*2,
	\legato, 0.81,
	\dur, 2,
	\amp, 0.1
)).play;
);

(
Pdef(\bass, PmonoArtic(
	\brownbass,
	\degree, Pseq([1b,-3b,-2b, -3b],inf),
	\legato, Pseq([
		1,1,1,1, 0.2,0,0,0,
	],inf)*0.9,
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\octave, 3,
	\dur, 1,
	\amp, 0.1
)).play;
);

(
Pdef(\bass, PmonoArtic(
	\brownbass,
	\degree, Pseq([1b,-3b,-2b, -3b],inf).stutter(2),
	\legato, Pseq([
		1,1,1,1,1,1,1,1, 0.2,0,0,0, 0,0,0.2,0.2,
	],inf),
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\octave, 3,
	\dur, 1/2,
	\amp, 0.1
)).play;
);

//////////// piano control

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	freq = freq  * ( 1 + ( SinOsc.ar(\fmfreq.kr(8)) * \fmamt.kr(1) ));
	sig = SinOsc.ar(freq * [1,1.01,1.001] );
	sig = sig + LFSaw.ar(freq *  [1,1.0001], mul:1/2 * \sawmul.kr(1));
	sig = RLPF.ar(sig, \ffreq.kr(2000), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.01,0.8,\release.kr(0.01)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;
Pdef(\plop, Pbind(
	\instrument, \plop,
	\degree, Pseq([0],inf),
));
~apro_device_id.postln;
~playergroup = ~seqPlayerGroup.new(Pdef(\plop));
MIDIdef.noteOn(\piano, { arg ... args;
	var midinote = args[1];
	"on".debug(args);
	~playergroup.elAt(midinote).play;
}, srcID:~apro_device_id);
MIDIdef.noteOff(\piano_off, { arg ... args;
	var midinote = args[1];
	"off".debug(args);
	~playergroup.elAt(midinote).stop;
}, srcID:~apro_device_id);

MIDIdef(\piano).permanent = true;
MIDIdef(\piano_off).permanent = true;
)


WindowDef(\PdefEditor).front(Pdef(\plop))

Ndef(\verb).edit

// control

ProtoDef(\rdn).genfx
ProtoDef(\rdn).loadDefaultPreset
ProtoDef(\rdn).play
ProtoDef(\rdn).edit
PatKitDef(\sample1).edit

///////////////////////////////////////////////////////////////
////////// SOUNDS

// mr brown

(
BufDef(\amen, "vipere/amenbreak.wav");
Pdef(\chords, 
	Ppar([
		
		
		Ptpar([
			8, 	Pbind(
			   		// chords
			   		\instrument, \chordar,
			   		\adsr, Pseq([
			   			[ Env.adsr(0.1,0.1,0.8,0.1) ],
			   			[ Env.adsr(0.01,0.1,0.8,0.1) ],
			   			[ Env.adsr(0.01,0.1,0.8,0.1) ],
			   			[ Env.adsr(0.01,0.1,0.8,0.1) ],
			   		],inf),
			   		\note, Pseq([
			   			[1,5,8],
			   			[1,6,10],
			   			[3,8,12, 0],
			   			[1,6,10, -2],
			   		],inf).stutter(8),
			   		\isRest, Pseq([
			   			0,1,0,0,
			   			0,0,1,0,
			   			1,0,1,0,
			   			0,0,1,1,
			   		],inf).coin.not,
			   		\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2),
			   		\legato, 1.7,
			   		\legato, Pseq([

			   				0,0,0,0, 3,0,0,0,
			   				0,0,0,0, 3,0,0,0,
			   				0,0,0,0, 3,0,0,0,
			   				0,0,0,0, 3,0,0,0,
			   
			   				0.5,0,0,0, 1,0,0.5,0,
			   				0,0,0,0, 3,0,0,0,
			   				0,0,0,0, 3,0,0,0,
			   				0,0,0,0, 3,0,0,0,
			   
			   				0,0,0,0, 3,0,0,0,
			   				0,0.5,0,0, 3,0,0,0,
			   				0,0,0,0, 3,0,0,0,
			   				0,0,0,0, 2,0,0,0.5,

			   				0,0,0,0, 1,0,0,0,
			   				0,0,0,0, 1,0,0,0,
			   				0,0,0,0, 1,0,0,0,
			   				0,0,0,0, 1,0,0,0,

			   				0,0,0,0, 1,0,0.5,0,
			   				0,0,0,0, 0.5,0,0,0.5,
			   				0,0,0.5,0, 1,0,0,0,
			   				0,0,0,0, 1,0,0,0,

			   		],inf),
			   		\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			   		\dur, 1/8,
			   		\mixhpf, 0,
			   		\mixlpf, 1,
			   		\amp, 0.1/8,
			   	),
			   
			   12,Pbind(
			   	// scratching!
			   	\instrument, \fmsaw,
			   	\adsr, Pseq([
			   		[ Env.adsr(0.1,0.1,0.8,0.1) ],
			   	],inf),
			   	\note, Pseq([
			   		[1,5,8],
			   		[1,6,10],
			   		[3,8,12, 0],
			   		[1,6,10, -2],
			   	],inf).stutter(8).collect({ arg x; x.choose }) + Pseq([0,1],inf),
			   	\isRest, Pseq([
			   		00.32,0,1,0.2, 0.51,0,0.51,0,
			   		0,1,0.2,1, 0.51,0,0.51,0,
			   	],inf).coin.not,
			   	\isRest, Pseq([
			   		1,1,0.9,1,
			   		1,1,1,0.9,
			   	],inf).coin.not,
			   	\octave, Pseq([4,4,4,Prand([5,3],1)],inf).stutter(2) + Prand([0,1,0],inf).stutter(8),
			   	\legato, Pseq([0.9,0.9,0.9,0.4],inf).stutter(2) * 0.4,
			   	//\legato, 0.7,
			   	\dur, PdurStutter(Pseq([2,2,2,Prand([1,4],1)],inf),Pseq([1/4],inf)).trace,
			   	//\dur, 1/8,
			   	\mixhpf, 0,
			   	\mixlpf, 1,
			   	\amp, 0.1/6,
			   ),
		4,Pbind(
			\instrument, \playersec,
			\bufnum, BufDef(\amen),
			\degree, Pseq([0],inf),
			\speed, 4*~t/(137/60),
			\speed, 2*~t/(137/60),
			\pos, Pseq([0,0,0,2],inf)*( 137/60 ),
			\legato, 1,
			\gain, 1/5,
			\dur, 2,
			\amp, 0.1
		),
		]),
PmonoArtic(
	\brownbass,
	\degree, Pseq([1b,-3b,-2b, -3b],inf),
	\legato, Pseq([
		1,1,1,1, 0.2,0,0,0,
	],inf)*0.9,
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\octave, 3,
	\dur, 1,
	\amp, 0.1
),
		//PatKitDef(\sample1).asPattern(Pbind(
		//	\kitIndex, 0,
		//	\isRest, Pseq([
		//		0,0,0,0, 0,0,1,1,
		//		0,1,1,0, 0,0,0,0,
		//	],inf).coin.not,
		//	\isRest, Pseq({[
		//		1,0,0,0, 0,0,0,1,
		//		0,0,0,0, 0,0,0,1,
		//		0,0,0,0, 0,0,1,1,
		//		0,1,1,0, 0,0,0,0,
		//		0,0,1,0, 0,0,0,0,
		//	].clump(8).choose}.dup(8).flat,inf).coin.not,
		//	\sustain, 0.1,
		//	\dur, 1/8,
		//	\amp, 0.1,
		//)),
		//PatKitDef(\sample1).asPattern(Pbind(
		//	\kitIndex, 4,
		//	\isRest, Pseq({[
		//		0,0,0,0, 1,0,0,0,
		//	].clump(8).choose}.dup(8).flat,inf).coin.not,
		//	\sustain, 0.1/1.2,
		//	\dur, 1/8,
		//	\amp, 0.1,
		//)),
		//PatKitDef(\sample1).asPattern(Pbind(
		//	\kitIndex, 8,
		//	\isRest, Pseq({[
		//		1,0,0,0, 0,0,0,1,
		//		1,1,0,0, 0,0,1,1,
		//		1,0,1,1, 0,0,1,1,
		//		1,0,0,0, 1,0,1,1,
		//		0,1,1,0, 0,0,0,0,
		//		0,0,1,0, 0,1,0,0,
		//		0,0,1,0, 1,0,1,0,
		//	].clump(8).choose}.dup(8).flat,inf).coin.not,
		//	\speed, 1.5,
		//	\sustain, 0.1/3,
		//	\pos, 0.18,
		//	\dur, 1/8,
		//	\gain, 1.2,
		//))
	])
).play;
)

///// tranceoid

(
	Ndef(\verb).play;
	ProtoDef(\rdn).play;
	Pdef(\gomain, 
		Pseq([
			Pbind(
				\instrument, \rise,
				\degree, Pseq([0],1),
				\legato, 1,
				\time, 2/~t,
				\dur, 2,
				\amp, 0.1
			),
			// part 1
			Pfindur(6, Pdef(\drums1)),
			Pfindur(2, 
				Ppar([
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],1),
						\start, 2, \end, 1,
						\legato, 1,
						\time, 2/~t,
						\dur, 2,
						\amp, 0.1,
					),
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\isRest, Pseq([
							1,0,0,0, 1,0,0,0,
							1,0,1,0, 1,0,1,0,
						],inf).coin.not,
						//\gain, 1 * Pseg(Pseq([0,1],inf),2),
						\amp, 0.1,
					))
				]),
			),
			Pfindur(6, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 2,
						\spstart, 7.01, \spend, 8.1,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 1,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 1/2, \end, 1,
						\octave, 3,
						\spstart, 0.01, \spend, 1.001,
						\legato, 1,
						\time, 0.1/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 1/4,
						\amp, 0.1,
					),
					Pdef(\drums1),
				])

			),
			Pfindur(2, 
				Ppar([
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],1),
						\start, 2, \end, 1,
						\legato, 1,
						\time, 1/~t,
						\dur, 2,
						\amp, 0.1,
					),
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\isRest, Pseq([
							1,1,1,1, 1,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						//\gain, 1 * Pseg(Pseq([0,1],inf),2),
						\amp, 0.1,
					))
				]),
			),

			// part 3
			Pfindur(6, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 2,
						\spstart, 7.01, \spend, 8.1,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 1,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 1/2, \end, 1,
						\octave, 3,
						\spstart, 0.01, \spend, 1.001,
						\legato, 1,
						\time, 0.1/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 1/4,
						\amp, 0.1,
					),
					Pdef(\pluck),
					Pdef(\drums1),
				])

			),

			Pfindur(2, 
				Ppar([
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],1),
						\start, 2, \end, 1,
						\legato, 1,
						\time, 1/~t,
						\dur, 2,
						\amp, 0.1,
					),
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\isRest, Pseq([
							1,1,1,1, 1,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						//\gain, 1 * Pseg(Pseq([0,1],inf),2),
						\amp, 0.1,
					))
				]),
			),
			// part 4
			Pfindur(6, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 2,
						\spstart, 7.01, \spend, 8.1,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 1,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 1/2, \end, 1,
						\octave, 3,
						\spstart, 0.01, \spend, 1.001,
						\legato, 1,
						\time, 0.1/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 1/4,
						\amp, 0.1,
					),
					Pdef(\pluck),
					Pdef(\drums1),
				])

			),
			Pfindur(2, 
				Ppar([
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],1),
						\spstart, 10.01, \spend, 1.001,
						\start, 1, \end, 2,
						\legato, 1,
						\time, 1/~t,
						\dur, 2,
						\amp, 0.1,
					),
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\isRest, Pseq([
							1,1,1,1, 1,0,0,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						//\gain, 1 * Pseg(Pseq([0,1],inf),2),
						\amp, 0.1,
					))
				]),
			),

			// part 5
			Pfindur(6, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 1,
						\spstart, 0.01, \spend, 10.01,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 1,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 1,
						\spstart, 7.01, \spend, 1.01,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							0,1,
						],inf).coin.not,
						\dur, 1,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 1/2, \end, 1,
						\octave, 3,
						\spstart, 0.01, \spend, 1.001,
						\legato, 1,
						\time, 0.1/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 1/4,
						\amp, 0.1,
					),
					Pdef(\pluck),
					Pdef(\drums1),
				])

			),
			Pfindur(2, 
				Ppar([
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],2),
						\start, 2, \end, 1,
						\legato, 1,
						\time, 1/~t,
						\dur, 1/4,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],2),
						\start, 2, \end, 1,
						\legato, 1,
						\time, 1/~t,
						\dur, 1/2,
						\amp, 0.1,
					),
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\isRest, Pseq([
							1,0,0,1, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						//\gain, 1 * Pseg(Pseq([0,1],inf),2),
						\amp, 0.1,
					))
				]),
			),
			// part 6
			Pfindur(30, Pdef(\acid)),
			Pfindur(2, 
				Ppar([
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],2),
						\start, 2, \end, 1,
						\legato, 1,
						\time, 1/~t,
						\dur, 1/4,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],2),
						\start, 2, \end, 1,
						\legato, 1,
						\time, 1/~t,
						\dur, 1/2,
						\amp, 0.1,
					),
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\isRest, Pseq([
							1,0,0,1, 0,0,1,0,
							0,0,0,0, 0,0,0,0,
						],inf).coin.not,
						//\gain, 1 * Pseg(Pseq([0,1],inf),2),
						\amp, 0.1,
					))
				]),
			),
			// part 7
			Ptpar([
				0, Pfindur(32,Pdef(\acid2)),
				16, Pfindur(14, Pdef(\pluck)),
			]),
			// part 8
			Pfindur(8,Pdef(\risepart1)),
			Pfindur(32, Pdef(\acid)),
			Pfindur(8, Pdef(\pxpart1)),


		],inf)
	).play;
)

Pdef(\gomain).clear
	ProtoDef(\rdn).edit;
	(
	ProtoDef(\rdn).play;
	)

	ProtoDef(\simpleMixer).edit
(
	ProtoDef(\rdn).play;
Pdef(\acid, 
	Pseq([
			Pfindur(16, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 1,
						\spstart, 7.01, \spend, 1.01,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							0,0,0,1,
						],inf).coin.not,
						\dur, 1/2,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 1/2,
						\spstart, 7.01, \spend, 1.01,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 2,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \brownbass,
						\degree, 0,
						\octave, 3,
						\rq, Pseg(Pseq([0.4,0.05,1],inf),8),
						\lpfr, Pseg(Pseq([16,4,32,8],inf),4),
						\isRest, Pseq([
							1
						],inf).coin.not,
						\dur, 1/8,
						\amp, 0.3,
						\amp, Pkey(\amp) * Pseq([
							0.3,0.5,1,0.5,
						],inf),
					),
					Ptpar([
						6,Pbind(
							\instrument, \rise,
							\degree, Pseq([0],1),
							\start, 8, \end, 2,
							\spstart, 10.01, \spend, 0.01,
							\legato, 3/4,
							\time, 0.8/~t,
							\isRest, Pseq([
								1,0,
							],inf).coin.not,
							\dur, 2,
							\amp, 0.1,
						),
						8, Pdef(\pluck),
						8+6, Pbind(
							\instrument, \rise,
							\degree, Pseq([0],1),
							\start, 8, \end, 2,
							\spstart, 10.01, \spend, 0.02,
							\legato, 1,
							\time, 1.4/~t,
							\isRest, Pseq([
								1,0,
							],inf).coin.not,
							\dur, 2,
							\amp, 0.1,
						),
					]),
					Pdef(\drums1),
				])

			),
		
	],inf)
).play;
)

(
	ProtoDef(\rdn).play;
Pdef(\acid2, 
	Pseq([
			Pfindur(6, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 1,
						\spstart, 7.01, \spend, 1.01,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							0,0,0,1,
						],inf).coin.not,
						\dur, 1/2,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 1/2,
						\spstart, 7.01, \spend, 1.01,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 2,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \brownbass,
						\degree, 0,
						\octave, 3,
						\rq, Pseg(Pseq([0.4,0.05,1],inf),8),
						\lpfr, Pseg(Pseq([16,4,32,8],inf),4),
						\isRest, Pseq([
							1
						],inf).coin.not,
						\dur, 1/8,
						\amp, 0.3,
						\amp, Pkey(\amp) * Pseq([
							0.3,0.5,1,0.5,
						],inf),
					),
					Ptpar([
						0,Pbind(
							\instrument, \rise,
							\degree, Pseq([0],1),
							\start, 8, \end, 2,
							\spstart, 10.01, \spend, 0.01,
							\legato, 4,
							\time, 16/~t,
							\isRest, Pseq([
								1,0,
							],inf).coin.not,
							\dur, 6,
							\amp, 0.1,
						),
						8, Pdef(\pluck),
						8+6, Pbind(
							\instrument, \rise,
							\degree, Pseq([0],1),
							\start, 8, \end, 2,
							\spstart, 10.01, \spend, 0.02,
							\legato, 1,
							\time, 1.4/~t,
							\isRest, Pseq([
								1,0,
							],inf).coin.not,
							\dur, 2,
							\amp, 0.1,
						),
					]),
					Pdef(\drums1),
				])

			),
			Pfindur(2, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \brownbass,
						\degree, 0,
						\octave, 3,
						\rq, Pseg(Pseq([0.84],inf),8),
						\lpfr, Pseg(Pseq([4],inf),4),
						\isRest, Pseq([
							1
						],inf).coin.not,
						\legato, 0.8,
						\dur, 1/8,
						\amp, 0.3,
						\amp, Pkey(\amp) * Pseq([
							0.3,0.5,1,0.5,
						],inf),
					),
				])

			),
			Pfindur(6, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1*4,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 1,
						\spstart, 7.01, \spend, 1.01,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							0,0,0,1,
						],inf).coin.not,
						\dur, 1/2,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 2, \end, 1/2,
						\spstart, 7.01, \spend, 1.01,
						\legato, 1,
						\time, 0.2/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 2,
						\amp, 0.1,
					),
					Pbind(
						\instrument, \brownbass,
						\degree, 0,
						\octave, 3,
						\rq, Pseg(Pseq([0.4,0.05,1],inf),8),
						\lpfr, Pseg(Pseq([16,4,32,8],inf),4),
						\isRest, Pseq([
							1
						],inf).coin.not,
						\dur, 1/8,
						\amp, 0.3,
						\amp, Pkey(\amp) * Pseq([
							0.3,0.5,1,0.5,
						],inf),
					),
					Ptpar([
						0,Pbind(
							\instrument, \rise,
							\degree, Pseq([0],1),
							\start, 8, \end, 2,
							\spstart, 10.01, \spend, 0.01,
							\legato, 4,
							\time, 16/~t,
							\isRest, Pseq([
								1,0,
							],inf).coin.not,
							\dur, 6,
							\amp, 0.1,
						),
						8, Pdef(\pluck),
						8+6, Pbind(
							\instrument, \rise,
							\degree, Pseq([0],1),
							\start, 8, \end, 2,
							\spstart, 10.01, \spend, 0.02,
							\legato, 1,
							\time, 1.4/~t,
							\isRest, Pseq([
								1,0,
							],inf).coin.not,
							\dur, 2,
							\amp, 0.1,
						),
					]),
					Pdef(\drums1),
				])

			),
			Pfindur(2, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							0,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \brownbass,
						\degree, 0,
						\octave, 3,
						\rq, Pseg(Pseq([0.84],inf),8),
						\lpfr, Pseg(Pseq([4],inf),4),
						\isRest, Pseq([
							1
						],inf).coin.not,
						\legato, 0.8,
						\dur, 1/8,
						\amp, 0.3,
						\amp, Pkey(\amp) * Pseq([
							0.3,0.5,1,0.5,
						],inf),
					),
				])

			),
		
	],inf)
).play;
)

(
	ProtoDef(\rdn).play;
Pdef(\risepart1, 
	Pseq([
		Pfindur(6, 

			Ppar([
						Pbind(
							\instrument, \rise,
							\degree, Pseq([0],inf),
							\start, 1/4, \end, 8,
							\spstart, 5.02, \spend, 1.01,
							\legato, 1,
							\time, 16/~t,
							\isRest, Pseq([
								1,
							],inf).coin.not,
							\dur, 8,
							\amp, 0.1,
						),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,0,0,
						0,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1*4,
					\speed, Pseq([1],inf),
					\dur, 1/8,
					\gain, 1,
					\amp, 0.1,
				)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					1,1,1,1,
				],inf).coin.not,
				\sustain, 0.1/2,
				\speed, Pseq([1,0.9,0.8,0.9],inf),
				\dur, 1/4,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,1,0,0, 
				],inf).coin.not,
				\sustain, 0.04,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1,1,-4) ],
				],inf),
				\speed, 0.9,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq({[
					1,1,1,1, 1,1,1,1,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\pos, 0.3 + Pseq([0,Prand([0,0.1,0.05],1)],inf),
				\amp, Pkey(\amp) * Pseq([
					0.3,0.5,1,0.5,
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
			]),

		),
			Pfindur(2, 

				Ppar([
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 0,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \brownbass,
						\degree, 0,
						\octave, 3,
						\rq, Pseg(Pseq([0.84],inf),8),
						\lpfr, Pseg(Pseq([4],inf),4),
						\isRest, Pseq([
							1
						],inf).coin.not,
						\legato, 0.8,
						\dur, 1/8,
						\amp, 0.3,
						\amp, Pkey(\amp) * Pseq([
							0.3,0.5,1,0.5,
						],inf),
					),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.04,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1,1,-4) ],
				],inf),
				\speed, 0.9,
				\dur, 1/8,
				\amp, 0.1,
			)),
				])

			),
		
	],inf)
).play;
)

(
	ProtoDef(\rdn).play;
Pdef(\pxpart1, 
	Pseq([
		Pfindur(6, 

			Ppar([
					Pbind(
						\instrument, \rise,
						\degree, Pseq([0],inf),
						\start, 1/2, \end, 1,
						\octave, 6,
						\spstart, 0.01, \spend, 1.001,
						\out, BusDef(\sendbus1, \audio),
						\legato, 1,
						\time, 6/~t,
						\isRest, Pseq([
							1,0,
						],inf).coin.not,
						\dur, 8,
						\amp, 0.1,
					),
				Pbind(
					\instrument, \pluck,
					\freq, 2770,
					\decay, 110.1,
					\coef, 0.091,
					\isRest, Pseq([
						0,1,
					],inf).coin.not,
					\legato, 1,
					\dur, 1/4,
					\amp, 0.1
				),
				Pbind(
					\instrument, \pluck,
					\freq, Pseq([500,1000],inf),
					\decay, 110.1,
					\coef, 0.091,
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
					\legato, 1,
					\lag, 0.01,
					\dur, 1/8,
					\amp, 0.1/4,
					\amp, Pkey(\amp) * Pseq([
						0.3,0.5,1,0.5,
					],inf).stutter(2),
				),
				PatKitDef(\sample1).asPattern(Pbind(
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,0,0,
						1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1*4,
					\speed, Pseq([1],inf),
					\dur, 1/8,
					\gain, 1,
					\amp, 0.1,
				)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 0,
				\isRest, Pseq([
					0,1,1,1,
				],inf).coin.not,
				\sustain, 0.1/1,
				\pos, 0.1,
				\speed, Pseq([1,0.9,0.8,0.9]*1.2,inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,1,0, 1,0,1,0, 
				],inf).coin.not,
				\sustain, 0.04,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1,1,-4) ],
				],inf),
				\speed, 0.9,
				\dur, 1/8,
				\amp, 0.1,
			)),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 9,
				\isRest, Pseq({[
					1,1,1,1, 1,1,1,1,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\sustain, 0.1,
				\pos, 0.3 + Pseq([0,Prand([0,0.1,0.05],1)],inf),
				\amp, Pkey(\amp) * Pseq([
					0.3,0.5,1,0.5,
				],inf),
				\dur, 1/8,
				\amp, 0.1,
			)),
			]),

		),
			Pfindur(2, 

				Ppar([
				Pbind(
					\instrument, \pluck,
					\freq, Pseq([500,1000],inf),
					\decay, 110.1,
					\coef, 0.091,
					\isRest, Pseq([
						0,0,1,1, 0,1,1,1,
					],inf).coin.not,
					\legato, 1,
					\lag, 0.01,
					\dur, 1/8,
					\amp, 0.1/2,
					\amp, Pkey(\amp) * Pseq([
						0.3,0.5,1,0.5,
					],inf).stutter(2),
				),
					PatKitDef(\sample1).asPattern(Pbind(
						\kitIndex, 4,
						\isRest, Pseq({[
							1,0,1,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, 0.1,
						\speed, Pseq([1],inf),
						\dur, 1/8,
						\gain, 1,
						\amp, 0.1,
					)),
					Pbind(
						\instrument, \default,
						\degree, 0,
						\octave, 3,
						\rq, Pseg(Pseq([0.84],inf),8),
						\lpfr, Pseg(Pseq([4],inf),4),
						\isRest, Pseq([
							1
						],inf).coin.not,
						\legato, 0.8,
						\dur, 1/8,
						\amp, 0.3,
						\amp, Pkey(\amp) * Pseq([
							0.3,0.5,1,0.5,
						],inf),
					),
			PatKitDef(\sample1).asPattern(Pbind(
				\kitIndex, 4,
				\isRest, Pseq({[
					0,0,0,0, 1,0,0,0,
				].clump(8).choose}.dup(8).flat,inf).coin.not,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,1,
					0,0,1,0, 1,0,1,0,
				],inf).coin.not,
				\sustain, 0.04,
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,0.1,1,-4) ],
				],inf),
				\speed, 0.9,
				\dur, 1/8,
				\amp, 0.1,
			)),
				])

			),
		
	],inf)
).play;
)

//////// DRAFT
