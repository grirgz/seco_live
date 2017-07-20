
(
	Pdef(\main, Ppar([
		12.collect({
			PatKitDef(\algokit).asPattern(
				Ppar([
					Pbind(
						\kitIndex, rrand(0,12),
						\freq, 200,
						\speed, rrand(1,1.2),
						[\legato, \isRest], Plazy({
							var rest, leg;

							rest = Pseq({ [
								7,0,0,0, 0,0,0,0,
								0,0,0,0, 4,0,0,0,
								1,0,4,0, 0,0,0,0,
								0,0,4,0, 0,0,0,0,
								1,1,1,3, 0,0,0,0,
								0,0,0,0, 1,1,0,1,
								1,0,1,0, 1,0,1,0, 
								1,0,0,0, 1,0,0,0, 
								0,0,1,0, 0,0,1,0, 
							].clump(8).choose }.dup(4).flat,4);
							leg = rest;
							Ptuple([leg.linlin(0,20,1,20), rest.coin.not]);
						}).loop,
						\dur, [1/2,1/1,1/4, 1/8].choose,
						\amp, 0.1,
					)
				])
			); 
		})
	].flat)).play;
)
{ SinOsc.ar(200) ! 2 * 0.1}.play;

	Pdef(\main, Pdef(\flow1)).play;
(
	Pdef(\flow1, Ppar([
		
			PatKitDef(\algokit).asPattern(
				Ppar([
					8.collect {

						Pbind(
							\kitIndex, rrand(0,19),
							\freq, 200,
							\speed, rrand(1,1.2),
							[\legato, \isRest], Plazy({
								var rest, leg;
								var rest2;

								rest = Pseq({ [
									1,1,0,0, 1,1,0,0,
									0,0,1,1, 0,0,1,1,
									1,1,1,1, 1,1,1,1,
									1,1,1,1, 0,0,0,0,
									0,0,0,0, 1,1,1,1,
									1,0,1,0, 1,0,1,0, 
									1,0,0,0, 1,0,0,0, 
									0,0,1,0, 0,0,1,0, 
								].clump(8).choose }.dup(4).flat,4);
								rest2 = Pseq({ [
									1,0,0,0, 0,0,0,0,
									1,0,1,0, 0,0,0,0,
								].clump(8).choose }.dup(4).flat,4);
								rest = Pseq([ Pfin(8*3*2, rest), Pfin(8*1*2,rest2) ],4);
								leg = rest;
								Ptuple([leg.linlin(0,20,0.1,20), rest.coin.not]);
							}).loop,
							\speed, Pseg(Pseq([1,1,1,1/8],inf),8.rrand(1)),
							\legato, rrand(0.1,0.8),
							\dur, 1/8,
							\amp, 0.1/2,
						)
					}
				].flat)
			); 
	].flat));
)

	Pdef(\main, Pdef(\flow1p2)).play;
(
	Pdef(\flow1p2, Ppar([
		
			PatKitDef(\algokit).asPattern(
				Ppar([
					8.collect {

						Pbind(
							\kitIndex, 9,
							\kitIndex, rrand(8,12),
							\freq, 200,
							[\legato, \isRest], Plazy({
								var rest, leg;
								var rest2;

								rest = Pseq({ [
									1,1,0,0, 1,1,0,0,
									0,0,1,1, 0,0,1,1,
									1,1,1,1, 1,1,1,1,
									1,1,1,1, 0,0,0,0,
									0,0,0,0, 1,1,1,1,
									1,0,1,0, 1,0,1,0, 
									1,0,0,0, 1,0,0,0, 
									0,0,1,0, 0,0,1,0, 
								].clump(8).choose }.dup(4).flat,4);
								rest2 = Pseq({ [
									1,0,0,0, 0,0,0,0,
									1,0,1,0, 0,0,0,0,
								].clump(8).choose }.dup(4).flat,4);
								rest = Pseq([ Pfin(8*3*2, rest), Pfin(8*1*2,rest2) ],4);
								leg = rest;
								Ptuple([leg.linlin(0,20,0.1,20), rest.coin.not]);
							}).loop,
							\speed, rrand(1/2,2.2),
							\speed, Pseg(Pseq([1,1,1,7/8, 1,1,1,9/8],inf),8.rrand(1)) * Pkey(\speed),
							\legato, rrand(0.051,0.8) * Pseg(Pseq([1,1,1,7/8, 1,1,1,9/8],inf),8.rrand(1)),
							\dur, PdurStutter(Pseq([
								Pseq({[
									3,1,4,1,
									4,8,8,8,
									4,4,4,4,
									3,3,3,3,
									2,2,2,2,
									8,8,8,8,
									8,8,8,8,
								].clump(4).choose}.dup(4).flat,inf)
							],inf), 1),
							\velamp, 1/8,
							\velamp, Pkey(\velamp) * Pseq([
								Pseq({[
									0.3,0.5,1,0.5,
									1,0.5,0.3,0.5,
									1,1,1,0.5,
									1,1,0.5,1,
									1,1,1,1,
								].clump(4).choose}.dup(8).flat,inf).stutter(rrand(1,4))
							],inf),
						)
					}
				].flat)
			); 
	].flat));
)

(
	//Pdef(\main, Pdef(\flow1p2)).play;
	Pdef(\flow1voc1, Ppar([
		
			PatKitDef(\algokit).asPattern(
				Ppar([
					4.collect {

						Pbind(
							\kitIndex, 9,
							\kitIndex, rrand(0,3)+16,
							\freq, 200,
							[\legato, \isRest], Plazy({
								var rest, leg;
								var rest2;

								rest = Pseq({ [
									1,1,0,0, 1,1,0,0,
									0,0,1,1, 0,0,1,1,
									1,1,1,1, 1,1,1,1,
									1,1,1,1, 0,0,0,0,
									0,0,0,0, 1,1,1,1,
									1,0,1,0, 1,0,1,0, 
									1,0,0,0, 1,0,0,0, 
									0,0,1,0, 0,0,1,0, 
								].clump(8).choose }.dup(4).flat,4);
								rest2 = Pseq({ [
									1,0,0,0, 0,0,0,0,
									1,0,1,0, 0,0,0,0,
								].clump(8).choose }.dup(4).flat,4);
								rest = Pseq([ Pfin(8*3*2, rest), Pfin(8*1*2,rest2) ],4);
								leg = rest;
								Ptuple([leg.linlin(0,20,0.01,20), rest.coin.not]);
							}).loop,
							\speed, rrand(1/2,2.2),
							\speed, Pseg(Pseq([1,1,1,7/8, 1,1,1,9/8],inf),8.rrand(1)) * Pkey(\speed),
							\legato, rrand(0.001,0.1) * Pseg(Pseq([1,1,1,7/8, 1,1,1,9/8],inf),8.rrand(1)),
							\dur, PdurStutter(Pseq([
								Pseq({[
									3,1,4,1,
									4,8,8,8,
									4,4,4,4,
									3,3,3,3,
									2,2,2,2,
									8,8,8,8,
									8,8,8,8,
								].clump(4).choose}.dup(4).flat,inf)
							],inf), rrand(1,4)),
							\velamp, 1/8,
							\velamp, Pkey(\velamp) * Pseq([
								Pseq({[
									0.3,0.5,1,0.5,
									1,0.5,0.3,0.5,
									1,1,1,0.5,
									1,1,0.5,1,
									1,1,1,1,
								].clump(4).choose}.dup(8).flat,inf).stutter(rrand(1,4))
							],inf),
						)
					}
				].flat)
			); 
	].flat));
)

Pdef(\drums, PatKitDef(\algokit).asPattern(Pdef(\algo2_p3)));
Pdef(\main).stop

KitTimeline(\flow1, PatKitDef(\algokit)).edit;

ProtoDef(\flowrdn).clear
ProtoDef(\flowrdn2).clear
ProtoDef(\flowrdn2).loadDefaultPreset
(
TrackDef(\flow1, TrackDef(\playergrid));
TrackDef(\flow1).source = [
	[
		ProtoDef(\flowrdn, ProtoTemplateDef(\rdn)),
	],
	[
		ProtoDef(\flowrdn2, ProtoTemplateDef(\rdn)),
	],
	[
		Pdef(\flow1),
		Pdef(\flow1p2),
	],
	[
		Pdef(\drums),
		KitTimeline(\flow1),
	],
	[
		Pdef(\flow1voc1),
	],
];
5.do{ arg idx; TrackDef(\flow1).mixer.play };
);

//TrackDef(\flow1).edit;
WindowDef(\multigrid).front;

////////////////////////////////////////////

(
SynthDef(\flowtreb, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([2,1,1.0091],[0.01,0.8]), 1);
	env2 = EnvGen.kr(Env([2,1,0.6991],[0.01,0.8],-4), 1);
	env3 = EnvGen.kr(Env([1/2,1,1.0091],[0.01,0.8]), 1);
	sig = LFSaw.ar(freq * env1 * ((0..7)/7 - 0.5 * LFNoise1.kr((0..7)/17+( 1/10 ),mul:0.1, add:1) * \fspread.kr(0.00001) + 1) *.x [1,2,4]).mean;
	sig = SinOsc.ar(freq * env3)/2 + sig;
	sig = sig * 2;
	sig = RLPF.ar(sig, \lpfr.kr(1) * freq * env2, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.0001,4.1,1.0,0.35),gate,doneAction:2);
	pan = pan + SinOsc.ar(4128/freq, mul:0.4 * SinOsc.ar(1/freq, freq).unipolar ); 
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\treb, Pbind(
	\instrument, \flowtreb,
	\legato, Pseq([
		Pser([
			12,0,0,0, 0,0,0,0,
			0,0,0,0, 2,0,2,0,
			12,0,0,0, 0,0,0,0,
			0,0,0,0, 1,1,2,0,
		],3*16),
		Plazy({
			Pseq({[
				1,1,0,1, 0,0,0,0,
				1,2,0,4, 0,0,0,0,
				1,0,1,0, 0,0,0,0,
				1,0,0,0, 2,0,0,0,
				1,0,0,0, 0,0,2,0,
				0,0,0,0, 0,0,2,0,
				0,0,0,0, 1,1,1,1,
				4,0,0,0, 2,0,0,0,
				0,0,0,0, 2,0,2,0,
				0,0,0,0, 0,0,1,1,
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 2,0,2,0,
				1,0,1,0, 1,0,2,0,
			].clump(8).choose}.dup(2).flat,1)
		}),
	],inf) * 0.8,
	\note, Pseq([ 
		[3,7,9]-(2*12)-1, 
		[3,7,9]-(2*12), 
		[3,7,9]-(2*12), 
		[3,7,9]-(2*12), 
		[0,3,7], 
		[0,3,7]-[3,3,4]-1,
		[0,3,7]-1, 
		[0,3,7]-[3,3,4],
	],inf).stutter(2),
	\lpfr, 2,
	\octave, [6,5],
	\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
	\dur, 1/8,
	\lag, 0.04,
	\out, BusDef(\sendbus1),
	\amp, 0.1/4
)).play;
)

(
Pdef(\piano, Pbind(
	\instrument, \flowtreb,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		1,0,1,0, 1,0,1,0,
	],inf).coin.not,
	\degree, Pseq((1..18),inf),
	\dur, 1/8,
	\out, BusDef(\sendbus1),
	\amp, 0.1
)).play;
);

(
Pdef(\piano, Pbind(
	\instrument, \flowtreb,
	\isRest, Pseq([
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		0,0,0,0, 0,0,0,0,
		Plazy({ arg ev;
			Pseq({[
				1,0,0,0, 0,0,0,0,
				1,1,1,1, 1,1,1,1,
				1,0,1,1, 1,0,0,1,
				1,0,1,0, 1,0,1,0,
				0,0,1,0, 0,1,1,0,
				0,0,1,1, 1,1,0,0,
			].clump(4).choose}.dup(2).flat,1)
		}),
	],inf).coin.not,
	\note, Pseq((1..8).mirror,inf),
	\scale, Scale.minor,
	\dur, 1/8,
	//\out, BusDef(\sendbus1),
	\amp, 0.1
)).play;
)

(
// basic binary pattern
Pdef(\piano, 
	Ppar([
		4.collect({
			Pbind(
				\instrument, \flowtreb,
				\isRest, Pseq([
					 [
						1,0,0,1,
						1,1,0,0,
					].clump(2).debug("kj").choose
				].flat,inf).coin.not,
				\note, Pseq([ (1..8).choose ],inf),
				\scale, Scale.minor,
				\dur, 1/8,
				//\out, BusDef(\sendbus1),
				\amp, 0.1
			)
		})
	].flat),
).play;
);

(
// articulation: rand 16
Pdef(\piano, 
	Ppar([
		4.collect({
			Pbind(
				\instrument, \flowtreb,
				\isRest, Pseq([
					{ 2.rand }!16
				].flat,inf).coin.not,
				\note, Pseq([ (1..8).choose ],inf),
				\scale, Scale.minor,
				\dur, 1/8,
				//\out, BusDef(\sendbus1),
				\amp, 0.1
			)
		})
	].flat),
).play;
);

(
// richer set, more voices, more silence
Pdef(\piano, 
	Ppar([
		8.collect({
			Pbind(
				\instrument, \flowtreb,
				\isRest, Pseq([
					{ [0,0,0.1,1].choose }!32
				].flat,inf).coin.not,
				\degree, Pseq([ (1..8).choose ],inf),
				\scale, Scale.minor,
				\legato, rrand(0.01,1),
				\dur, 1/8,
				//\out, BusDef(\sendbus1),
				\amp, 0.1
			)
		})
	].flat),
).play;
);

(
// 
Pdef(\piano, 
	Ppar([
		8.collect({
			Pbind(
				\instrument, [ \flowtreb, \lead, \criz ].choose,
				\isRest, Pseq([
					Pser([
						{ [0,0,0.1,1].choose }!32
					].flat,4*3),
					Pser([
						{ [0,1].choose }.dup(4).dup(4)
					].flat,4*1),
				].flat,inf).coin.not,
				\degree, Pseq([ (0..18).choose ],inf) + Pseq([
					[0,2,4,7,9,0,0,0].scramble.collect{arg x;
						x.dup(rrand(1,10))
					}
				].flat,inf),
				\octave, 4,
				\scale, Scale.minor,
				\legato, rrand(0.01,1.2),
				\dur, [1/4,1/16,1/8,1/8,1/8,1/2].choose,
				//\out, BusDef(\sendbus1),
				\amp, 0.1
			)
		})
	].flat),
).play;
);
Pdef(\piano).clear

(
	~repeater = { arg pat, count, rep;
		Prout({
			pat.clump(2).do({ arg x; Pseq(x.debug("x"),rep).embedInStream })
		})
	};
	~recaller = { arg pat, count, seq;
		Prout({
			var dic = SparseArray.new;
			var unrolled = 0;
			var str = pat.asStream;
			var countstr = count.loop.asStream;
			dic[0] = str.nextN(countstr.next,());
			seq.asStream.do { arg part;
				if( part > unrolled ) {
					(part-unrolled).do { arg idx;
						dic[part+idx] = str.nextN(countstr.next,());
					};
					unrolled = part;
				};
				Pseq(dic[part],1).embedInStream;
			}
		})
	};
	~repeater.(Pwhite(1,9), 2, 3).asStream.nextN(16,());
	~recaller.(Pwhite(1,9), Pseq([2,3]), Pseq([0,0,1,1,0,0,2,2],1)).asStream.nextN(32,());
)

(
// 
Pdef(\piano, 
	Ppar([
		6.collect({
			var ddur = 2;
			Pseq([
				Pfindur(3*ddur,
					Pseq([
						Pseq([
							Plazy({ Pfindur([0,0,0,1/2,1,2].choose, Pbind(\isRest, true)) }),
							Pbind()
						],1)
						<>
						Pbind(
							\instrument, [ \flowtreb, \lead, \criz ].choose,
							\isRest, Pseq([
								{ [0,0,0.1,1].choose }!32
							].flat,inf).coin.not,
							\degree, Pseq([ (0..18).choose ],inf) + Pseq([
								[1, 0,0,0,0,0,0,0,0,0,0,2,4,7,9,0,0,0].scramble.collect{arg x;
									x.dup(rrand(1,10))
								}
							].flat,inf),
							\pan, rrand(-1.00,1),
							\octave, 4,
							\scale, Scale.minor,
							\legato, rrand(0.01,1.2),
							\dur, [1/4,1/16,1/8,1/8,1/8,1/2,1].choose,
							//\out, BusDef(\sendbus1),
							\amp, 0.1
						),
					],1),
				),
				Pfindur(1*ddur,
					Pbind(
						\instrument, [ \flowtreb, \lead, \criz ].choose,
						\isRest, Pseq([
								{ [0,1].choose }.dup(4).dup(4)
						].flat,inf).coin.not,
						\degree, Pseq([ (0..18).choose ],inf) + Pseq([
							[1, 0,0,0,0,0,0,0,0,0,0,2,4,7,9,0,0,0].scramble.collect{arg x;
								x.dup(rrand(1,10))
							}
						].flat,inf),
						\pan, rrand(-1.00,1),
						\octave, 4,
						\scale, Scale.minor,
						\legato, rrand(0.01,1.2),
						\dur, [1/4,1/16,1/8,1/8,1/8,1/2,1].choose,
						//\out, BusDef(\sendbus1),
						\amp, 0.1
					)

				)
			])
		})
	].flat,inf),
).play;
);




/////////////////////////////////////////////////////////////////////:


(
Ndef(\layers, { arg freq=300, pan=0, amp=0.1;
	var sig;
	sig = [0,4,7].collect({ arg note, idx;
		var isig;
		var fre;
		var seq1, seq2, seq3, seq4;
		fre = freq * Duty.kr([1/4,1/2,1/8].choose/~t, 0, Dseq([
			{[
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,1,1,
				1,1,1,1, 1,1,1,1,
				0,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
			].clump(8).choose}.dup(4) * 4
		].flat,inf)).midiratio;
		fre = freq * note.midiratio;
		seq1 = Duty.kr([1/4,1/2,1/8].choose/~t, 0, Dseq([
			{[
				//0.2,0.4,0.6,0.3,
				1,1,1/2,1/2,
				1,0,0,0,
				1,0,1,0,
				0,0,1,0,
				0,1,0,1,
				1,0,1,1,
				1,1,0,0,
			].clump(4).choose}.dup(4).linlin(0,1,1/2,2) * freq
		].flat,inf));
		seq2 = Duty.kr([1/4,1/2,1/8].choose/~t, 0, Dseq([
			{[
				0.2,0.4,0.6,0.3,
				1,1,1/2,1/2,
				1,0,0,0,
				1,0,1,0,
				0,0,1,0,
				0,1,0,1,
				1,0,1,1,
				1,1,0,0,
			].clump(4).choose}.dup(4).linlin(0,1,0.3,1)
		].flat,inf)).lag(0.1);
		seq3 = Duty.ar([1/4,1/2,1/8,1/16,1/32,1/64,1/128].choose/~t, 0, Dseq([
			{[
				0.2,0.4,0.6,0.3,
				1,1,1/2,1/2,
				1,0,0,0,
				1,0,1,0,
				0,0,1,0,
				0,1,0,1,
				1,0,1,1,
				1,1,0,0,
			].clump(4).choose}.dup(4).linlin(0,1,0,1/2)
		].flat,inf)).lag(0.1);
		isig = SinOsc.ar(fre * ( 1 + ( SinOsc.ar(seq1) * seq3 ))) ;
		isig = isig + LFSaw.ar(fre);
		isig = RLPF.ar(isig, rrand(1.0,4) * fre * ( seq3 + 1 ), 0.5);
		isig = isig.fold(seq2);
		isig;
	});
	sig = sig * 4;
	pan = LFNoise1.ar(sig.collect({ arg ss, x; tanh(x).debug("d")/30 }), mul:0.6) + pan;
	sig = Pan2.ar(sig, pan, amp).mean;
}).play;
Ndef(\layers).put(10, \set -> Pbind(
	\degree, Pseq([0,2,0,4, -12,-11,-10,-9],inf),
	\dur, 1,
))
);


(
	Ndef(\custom_pulse, { arg freq=400, pan=0, amp=0.1;
		var sig;
		var lp;
		lp = MouseY.kr(50,10000);
		freq = MouseX.kr(50,1000);
		sig = Duty.ar(1/freq, 0, Dseq([
			Dswitch1([
				Dseq([
					-1,1,0,-0.2,
				],1),
				Dwhite(-1,1,1),
				Dseq((1..100)-1/100-0.5,1),

			], Dseq([0,1,2],inf))
			//Dseq((1..8)-1/8-0.5,1),
		],inf)).lag(1/lp);
		sig = Pan2.ar(sig, pan, amp);
	}).stop;
);


(
Pdef(\nap1, 
	Pseq([
		Pfindur(2, Pbind(
			\degree, Prand([0,2,4,7,9],inf) + Prand([-7,0,7],inf),
		)),
		Pfindur(2, Pbind(
			\degree, Prand([0,2,4]+4,inf) + Prand([-7,0,7],inf),
		)),
	],inf) <>
	
	Pbind(
	\instrument, Prand([\blik2, \criz],inf),
	
	\fold, 0.8,
	\clean, 5,
	\foldspread, 1,
	\octave, 5,
	\rq, 0.1,
	\lpfr, 1/2,
	\adsr, Pseq([
		[ Env.adsr(0.7,0.4,0.8,0.7) ],
	],inf),
	\dur, Pwhite(1/8,1),
	\sustain, Pwhite(1/4,4),
	\amp, 0.1/2,
)).play;
);


ProtoDef(\rdn).presetCompileString
ProtoDef(\flowrdn).presetCompileString.editorInsert
ProtoDef(\flowrdn).clear
RandDelayNetwork(\deldefault).code
