
(
SynthDef(\spreadosc, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( (1..8)/8 * \fspread.kr(0.01) + 1 ));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\spreadosc2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ( (1..8)/8 * \fspread.kr(0.01) * XLine.kr(\fstart.kr(1.0), \fend.kr(10.1), \ftime.kr(0.1)) + 1 ) );
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\spreadosc3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( (1..8)/8 * \fspread.kr(0.01) * XLine.kr(\fstart.kr(1.0), \fend.kr(10.1), \ftime.kr(0.1)) + 1 ) );
	sig = RLPF.ar(sig, \lpfr.kr(2) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\spreadosc4, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( (1..8)/8 * \fspread.kr(0.01) * XLine.kr(\fstart.kr(1.0), \fend.kr(10.1), \ftime.kr(0.1)) + 1 ) );
	sig = RLPF.ar(sig, \lpfr.kr(2) * freq, \rq.kr(0.5));
	sig = CombL.ar(sig, 1/20, freq) / 2;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);
{ SinOsc.ar(200) ! 2 * 0.1}.play;
Pdef(\pitchdup1).clear

(
	Pdef(\pitchdup1, 
		Plazy({
			var pats = 16.collect({
				2.collect({ arg idx;

					Pbind(
						\instrument, [\default, \spreadosc,\spreadosc2].choose,
						\fstart, rrand(0.01,10),
						\fend, rrand(0.01,10),
						\ftime, rrand(0.01,10),
						\fspread, rrand(0.00001,0.08),
						\isRest, Pseq({[
							1,1,0,0, 1,1,0,0,
							0,0,1,1, 0,0,1,1,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							1,0,1,0, 1,0,1,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
							1,1,1,1, 0,0,0,0,
							0,0,0,0, 1,1,1,1,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\degree, (0..7*4).choose,
						\legato, rrand(0.01,1),
						\octave, 3,
						\dur, [1/8,1/8,1/4,1/8,1/16,1/3,1/6,1/12].choose,
						\amp, 0.1
					)
				})
			});

			Pseq([
				[0,1,0,2].collect({ arg x;
					Pfindur(4,Ptpar([
						0, Ppar(pats[0]),
						0, Pfindur(4, Ppar(pats[x+1])),
					].flat))
				}),
				[0,3,0,4].collect({ arg x;
					Pbind(\scale, Scale.minor) <>
					Pfindur(4,Ptpar([
						0, Ppar(pats[0]),
						0, Pfindur(4, Ppar(pats[x+1])),
					].flat))
				}),
				[0,1,0,2].collect({ arg x;
					Pfindur(4,Ptpar([
						0, Ppar(pats[x]),
						2, Pfindur(2, Ppar(pats[x+4])),
					].flat))
				}),
			].flat,2);
		})
	).play;
);

(
	Pdef(\pitchdup2, 
		Plazy({
			var pats = 16.collect({
				8.collect({ arg idx;

					Pbind(
						\instrument, [\spreadosc,\spreadosc2, \spreadosc3, \spreadosc4].choose,
						\lpfr, rrand(0.8,3),
						\rq, rrand(0.01,1),
						\fstart, rrand(0.01,10),
						\fend, rrand(0.01,10),
						\ftime, rrand(0.01,10),
						\fspread, rrand(0.00001,0.08),
						\isRest, Pseq({[
							//1,1,0,0, 1,1,0,0,
							//0,0,1,1, 0,0,1,1,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							1,0,1,0, 1,0,1,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
							1,1,1,1, 1,1,1,1,
							//1,1,1,1, 0,0,0,0,
							//0,0,0,0, 1,1,1,1,
						].clump(8).choose}.dup(4).flat,inf).coin.not,
						\degree, (0..7*4).choose,
						\legato, rrand(0.01,3),
						\octave, 3,
						\dur, [1/8,1/8,1/4,1/8,1/16,1/3,1/6,1/12].choose,
						\dur, [1/8,1/4,1/8,1/16].choose,
						\amp, Pseg(Pseq([0,1,0.1,rrand(0.1,1)],inf),rrand(1,32)) * 0.4,
					)
				})
			});

			Pseq([
				4.collect({ arg bx;
					bx = bx+1 * 2;
					Pseq([
						//[0,1,0,2].collect({ arg x;
						//	Pfindur(4,Ptpar([
						//		0, Ppar(pats[0].keep(bx)),
						//		0, Pfindur(4, Ppar(pats[x+1].keep(bx))),
						//	].flat))
						//}),
						//[0,3,0,4].collect({ arg x;
						//	Pbind(\scale, Scale.minor) <>
						//	Pfindur(4,Ptpar([
						//		0, Ppar(pats[0].keep(bx)),
						//		0, Pfindur(4, Ppar(pats[x+1].keep(bx))),
						//	].flat))
						//}),
						[0,1,0,2].collect({ arg x, idx;
							Pfindur(idx.odd.if(2,6),Ptpar([
								0, Ppar(pats[x].keep(bx)),
								2, Pfindur(2, Ppar(pats[x+4].keep(bx))),
							].flat))
						}),
					].flat,1);
				})
			].flat,2);
		})
	);
);

Pdef(\main, Pdef(\pitchdup2)).play;
Pdef(\main, Pdef(\pitchdup3)).play;
(
	Pdef(\pitchdup3, 
		Plazy({
			var pats = 16.collect({
				8.collect({ arg idx;

					Pbind(
						\instrument, [\trump, \tigrain, \tigrain2, \chordscape, \lead, \criz].choose, // see synthdefs.scd
						\fmf, exprand(1/100,4),
						\lpfr, rrand(0.8,3),
						\rq, rrand(0.1,1),
						\fstart, rrand(0.01,10),
						\fend, rrand(0.01,10),
						\ftime, rrand(0.01,10),
						\fspread, rrand(0.00001,0.08),
						\isRest, Pseq({[
							//1,1,0,0, 1,1,0,0,
							//0,0,1,1, 0,0,1,1,
							1,0,0,0, 0,0,0,0,
							1,0,0,0, 1,0,0,0,
							1,0,1,0, 1,0,1,0,
							0,0,1,0, 0,0,1,0,
							0,1,0,1, 0,1,0,1,
							1,1,1,1, 1,1,1,1,
							//1,1,1,1, 0,0,0,0,
							//0,0,0,0, 1,1,1,1,
						].clump(8).choose.dup(4)}.dup(4).flat,inf).coin.not,
						\degree, Pseq([{ (0..7*4).choose }.dup(rrand(1,4))].flat,inf).stutter(rrand(1,8)),
						\legato, rrand(0.01,3),
						\octave, 3,
						\scale, Scale.minor,
						\dur, [1/8,1/4,1/8,1/16].choose,
						//\dur, [1/8,1/8,1/4,1/8,1/16,1/3,1/6,1/12].choose,
						\amp, [
							0.1,
							rrand(0.1/4,0.1*2),
							Pseg(Pseq([0,1,0.1,rrand(0.1,1)],inf),rrand(1,32)) * 0.2,
						].choose,
					)
				})
			});

			Pseq([
				4.collect({ arg bx;
					bx = bx+1 * 2;
					Pseq([
						//[0,1,0,2].collect({ arg x;
						//	Pfindur(4,Ptpar([
						//		0, Ppar(pats[0].keep(bx)),
						//		0, Pfindur(4, Ppar(pats[x+1].keep(bx))),
						//	].flat))
						//}),
						//[0,3,0,4].collect({ arg x;
						//	Pbind(\scale, Scale.minor) <>
						//	Pfindur(4,Ptpar([
						//		0, Ppar(pats[0].keep(bx)),
						//		0, Pfindur(4, Ppar(pats[x+1].keep(bx))),
						//	].flat))
						//}),
						[0,1,0,2].collect({ arg x, idx;
							Pfindur(idx.odd.if(2,6),Ptpar([
								0, Ppar(pats[x].keep(bx)),
								2, Pfindur(2, Ppar(pats[x+4].keep(bx))),
							].flat))
						}),
					].flat,1);
				})
			].flat,2);
		})
	);
);

Pdef(\pitchdup3).play;
Pdef(\pitchdup4).clear
(
	Pdef(\pitchdup4, 
		Plazy({
			var pats = 16.collect({
				8.collect({ arg idx;

					Pbind(
						\instrument, [\trump, \tigrain, \tigrain2, \chordscape, \lead, \criz].choose, // see scape4.scd
						\fmf, exprand(1/100,4),
						\lpfr, rrand(0.8,3),
						\rq, rrand(0.1,1),
						\fstart, rrand(0.01,10),
						\fend, rrand(0.01,10),
						\ftime, rrand(0.01,10),
						\fspread, rrand(0.00001,0.08),
						\isRest, Pseq({[
							1,0,
							0,1,
						].clump(2).choose.dup(4)}.dup(4).flat,inf).coin.not,
						\note, Pseq([{ (0..7*4).choose }.dup(rrand(1,2))].flat,inf).stutter(rrand(1,8)),
						\legato, [1/2,1.2,1].choose,
						\octave, 3,
						\scale, Scale.minor,
						\dur, [1,2,1/2,1/4,1/8,1/16].choose,
						//\dur, [1/8,1/8,1/4,1/8,1/16,1/3,1/6,1/12].choose,
						\amp, [
							0.1,
							rrand(0.1/4,0.1*2),
							Pseg(Pseq([0,1,0.1,rrand(0.1,1)],inf),rrand(1,32)) * 0.2,
						].choose,
					)
				})
			});

			Pseq([
				1.collect({ arg bx;
					bx = 4;
					Pseq([
						//[0,1,0,2].collect({ arg x;
						//	Pfindur(4,Ptpar([
						//		0, Ppar(pats[0].keep(bx)),
						//		0, Pfindur(4, Ppar(pats[x+1].keep(bx))),
						//	].flat))
						//}),
						//[0,3,0,4].collect({ arg x;
						//	Pbind(\scale, Scale.minor) <>
						//	Pfindur(4,Ptpar([
						//		0, Ppar(pats[0].keep(bx)),
						//		0, Pfindur(4, Ppar(pats[x+1].keep(bx))),
						//	].flat))
						//}),
						Pseq([
							Pseq([
								( 8.partition(2) * 1 ).collect({ arg time;
									Pfindur(time,Ppar({ pats[bx].keep(4).choose }.dup(2).flat ));
								}),
							].flat,1),
							Pseq([
								( 8.partition(2) * 1 ).collect({ arg time;
									Pfindur(time,Ppar({ pats[bx].keep(6).choose }.dup(4).flat ));
								}),
							].flat),
							Pseq([
								( 8.partition(2) * 1 ).collect({ arg time;
									Pfindur(time,Ppar({ pats[bx].keep(8).choose }.dup(4).flat ));
								}),
							].flat),
						].flat),
					].flat,1);
				})
			].flat,2);
		})
	).play;
);

[0,1,2].dup(4)
Pdef(\drums, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p3), 1, key:\kitIndex)).stop;
Pdef(\drums, PdrumStep(PatKitDef(\algokit).targets, Pdef(\algo2_p5), 1, key:\kitIndex));
(
Pdef(\drums2, Plazy({
	Pseq([
		Pfindur(6,Ppar([
			3.collect {Pbind(\dur, ( Pkey(\dur) * 2 ).clip(1/4,8)) <> ~kitlib.hiphop.kick.value},
			3.collect { arg x; Pbind(\dur, Pkey(\dur) * ( x+1 )) <> ~kitlib.hiphop.hat.value},
			1.collect {Pbind(\dur, ( Pkey(\dur) * 2 ).clip(1/4,8)) <> ~kitlib.hiphop.snare.value},
		].flat)),
		Pfindur(2,Ppar([
			1.collect {Pbind(\dur, ( Pkey(\dur) * 2 ).clip(1/8,8)) <> ~kitlib.tek.kick.value},
			3.collect { arg x; Pbind(\dur, Pkey(\dur) * ( x+1/[1,2,4].choose )) <> ~kitlib.tek.hat.value},
			1.collect {Pbind(\dur, ( Pkey(\dur) * 2 ).clip(1/8,8)) <> ~kitlib.tek.snare.value},
		].flat)),
	],1);

}));
)
Pdef(\pitches, Pdef(\pitchdup4));
Pdef(\pitches, Pdef(\pitchdup2));
Pdef(\pitches, Pdef(\pitchdup3));

(
Pdef(\main, 
	Pseq([
		Ppar([
			Pdef(\pitches).loop,
			Pseq([
				Pfindur(8, Pdef(\drums)),
				Pfindur(8, Pdef(\drums2)),
			],inf),
		]),
	])
).play;
ProtoDef(\rdn).play;
4.do { arg x; TrackDef(\grid1).childAt(x).mixer.play };
)

(
TrackDef(\grid1, TrackDef(\playergrid));
TrackDef(\grid1).source = [
	[
		ProtoDef(\rdn),
	],
	[
		Pdef(\drums),
		Pdef(\drums2),
	],
	[
		Pdef(\pitches)
	],
	[
		ProtoDef(\rdn2, ProtoTemplateDef(\rdn)),
	],
];
3.do { arg x; TrackDef(\grid1).childAt(x).mixer.play };
);

//TrackDef(\grid1).edit;
WindowDef(\multigrid).front;
