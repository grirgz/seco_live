
~t = 171/4/60; TempoClock.default.tempo = ~t;
FileSystemProject.load("libdef/macros.scd");

(
SynthDef(\bignoisebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\lpadsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	sig = LFSaw.ar(freq * ((0..7)/7 - 0.5 * \fspread.kr(0.01) + 1) * ( SinOsc.ar(\fmratio.kr(1) * freq * ((0..7)/7 - 0.5 * \fmfspread.kr(0.01) + 1)) * \fmamp.kr(1) + 1 ));
	sig = RLPF.ar(sig, ( 
		\lpfr.kr(1.1) * freq 
		* ((0..7)/7 - 0.5 * \lpfspread.kr(0.1) + 1) 
		* ( SinOsc.ar(\lpfmf.kr(1)) * \lpfmamp.kr(1) + 1 ) 
		* ( env1 * \lpenvamt.kr(0) + 1 )
	).clip(20,20000), \rq.kr(0.5));
	sig1 = ( sig*\distamp.kr(10) ).tanh * \distpostamp.kr(1/2);
	sig = SelectX.ar(\distmix.kr(0.0), [sig, sig1]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan + ((0..7)/7 - 0.5 * \panspread.kr(0)) , amp).mean;
	sig.debug("sig");
	Out.ar(out, sig);
}, metadata:(specs:(
	lpadsr: ParamEnvSpec.adsr,
))).add;
);

Pdef(\bignoisebass).edit
Pdef(\bignoisebass).presetCompileString.editorInsert

(
Pdef('bignoisebass').setVal('out', BusDef('mixer0'));
Pdef('bignoisebass').setVal('amp', 0.2828305785124);
Pdef('bignoisebass').setVal('fspread', 0.01);
Pdef('bignoisebass').setVal('fmratio', 2);
Pdef('bignoisebass').setVal('fmfspread', 0.18409902980026);
Pdef('bignoisebass').setVal('fmamp', 0.37869902008128);
Pdef('bignoisebass').setVal('lpfr', 3.6830991285914);
Pdef('bignoisebass').setVal('lpfspread', 0.1);
Pdef('bignoisebass').setVal('lpfmf', 0.22984436634612);
Pdef('bignoisebass').setVal('lpfmamp', 0.17416300479961);
Pdef('bignoisebass').setVal('lpenvamt', 0.77899893316176);
Pdef('bignoisebass').setVal('rq', 0.28891348632569);
Pdef('bignoisebass').setVal('panspread', 0.9971139260073);

);



(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pdef(\bignoisebass, Pbind(\instrument, \bignoisebass)) <>
		Pmono(
			 \bignoisebass,
			\octave, 3,
			\lpfr, 2,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[63].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer5, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[827].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer6, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1036].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.05,
			\dur, 1/8,
			\gain, 0.08,
			\out, BusDef(\mixer7, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pdef(\bignoisebass, Pbind(\instrument, \bignoisebass)) <>
		Pmono(
			 \bignoisebass,
			\octave, 3,
			\lpfr, 2,
			\note, Pseq([
				0,0,0,-1,
			],inf),
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[63].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,1,
				1,0,0,0, 0,0,0,1,
				0,0,1,0, 0,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\mixer5, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[827].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\mixer6, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1036].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				0,0,0,0, 1,0,1,0,
				1,1,1,1, 1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.05,
			\dur, 1/8,
			\gain, 0.08,
			\out, BusDef(\mixer7, \audio),
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bignoisebass,
			\distmix, 0.4,
			//\note, Pseq([
				//Pseq([
					//0,0,0,3, 0,0,0,-2,
				//],1),
				//Pseq([
					//0,0,0,3, 0,0,0,-2,
				//]+4,1),
			//],inf),
			\fmamp, ~pmodenv.(Pseq([1,0,4,2]/4,1), 8).loop,
			\lpenvamt, ~pmodenv.(Pseq([12,0,8,4]*3,1), 10).loop,
			\lpadsr, Pseq([
				[ Env.adsr(0.11,0.04,1.1,0.1,0.1) ],
				[ Env.adsr(0.01,0.01,1.1,0.1,0.1) ],
			],inf),
			\adsr, Pseq([
				~pEnvadsr.(Pseg(Pseq([0.01,0.3],inf),10),0.1,0.8,Pseg(Pseq([0.01,0.3],inf),7)),
			],inf),
			\fmratio, 1/2 * Pseq([1,2,4,3],inf),
			\fmratio, Pwhite(0.01,10),
			\panspread, Pseq([
				10,0,0,1, 0,1,0,0,
			],inf),
			\degree, Pseq([
				0,0,0,1, 0,0,0,-1,
			],inf),
			\mtranspose, Pstep(Pseq([
				0,-1,0,-2,
			],inf),1),
			\octave, 3,
			\root, -1,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1068].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1671].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[857].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/16,
			\gain, 0.07 * Pseq([
				1,0.1,0.4,1,
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \bignoisebass,
			\fmratio, 3/2,
			\fmamp, ~pmodenv.(Pseq([0,2,1,4]/6,1), 13).loop,
			\fspread, ~pmodenv.(Pseq([0.001,0.0004,0.00001,0.004],1), 8).loop,
			\lpenvamt, ~pmodenv.(Pseq([0,0.2,1,0.7],1), 10).loop,
			\lpfr, 10,
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						Pseq(12.collect { arg idx;
							Pseq([
								0,idx,idx-2,4,
								Pseq([
									idx,idx,idx-1,idx-2,
									0,idx,idx-2,4,
								],8),
							],4) ;
						},1) % Pseq((1..100),inf).stutter(11) + Pseq((1..4),inf).stutter(29) - Pseq((1..60).mirror,1).stutter(8*8) ,
						Pseq(12.collect { arg idx;
							Pseq([
								0,idx,idx-2,4,
							],4) + Pseq((1..4),inf).stutter(2) - Pseq((1..6).mirror,1).stutter(8) ;
						},1),
						Pseq(12.collect { arg idx;
							Pseq([
								0,idx,idx-2,4,
							],4) ;
						},1) % Pseq((1..10),inf).stutter(11) + Pseq((1..4),inf).stutter(29) - Pseq((1..60).mirror,1).stutter(8*8) ,
					],inf);
				}).loop,
			],inf),
			\legato, 2,
			\dur, 1/64,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pfindur(8,Pbind(
			\instrument, \bignoisebass,
			\fmratio, 3/2,
			\fmamp, ~pmodenv.(Pseq([0,2,1,4]/6,1), 13).loop,
			\fspread, ~pmodenv.(Pseq([0.001,0.0004,0.00001,0.004],1), 8).loop,
			\lpenvamt, ~pmodenv.(Pseq([0,0.2,1,0.7],1), 10).loop,
			\lpfr, 10,
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						Pseq(12.collect { arg idx;
							Pseq([
								0,idx,idx-2,4,
								Pseq([
									idx,idx,idx-1,idx-2,
									0,idx,idx-2,4,
								],8),
							],4) ;
						},1) % Pseq((1..100),inf).stutter(11) + Pseq((1..4),inf).stutter(29) - Pseq((1..60).mirror,1).stutter(8*8) ,
						Pseq(12.collect { arg idx;
							Pseq([
								0,idx,idx-2,4,
							],4) + Pseq((1..4),inf).stutter(2) - Pseq((1..6).mirror,1).stutter(8) ;
						},1),
						Pseq(12.collect { arg idx;
							Pseq([
								0,idx,idx-2,4,
							],4) ;
						},1) % Pseq((1..10),inf).stutter(11) + Pseq((1..4),inf).stutter(29) - Pseq((1..60).mirror,1).stutter(8*8) ,
					],inf);
				}).loop,
			],inf),
			\legato, 2,
			\dur, 1/64,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		)).loop,
		
	])
)).play;
);

Pdef(\part2, Pdef(\drums1))
Pdef(\part2, Pdef(\drums2))
