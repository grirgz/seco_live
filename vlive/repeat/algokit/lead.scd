(
SynthDef(\bruit, { arg out=0, freq=200, pan=0, amp=0.1, bufnum=0, gate=1;
	var sig;
	var phase;
	//bufnum = BufDef(\bruit);
	phase = Phasor.ar(Impulse.kr(\trigrate.kr(1/2*~t)), \rate.kr(1),\start.kr(0),\end.kr(1)*BufFrames.kr(bufnum)).lag(\phaselag.kr(0.4));
	sig = BufRd.ar(2, bufnum, phase*\sign.kr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1) * \trigrate.kr * SinOsc.ar(1 * [ [1,1/2,1/4,1/14] ]).range(1/2,4) , \rq.kr(0.5)).flop.mean;
	sig.debug("sig");
	sig = sig * \gain.kr(1);
	sig = sig * EnvGen.kr(\asr.kr(Env.asr(0.01,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\fbfx1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreqShift.ar(sig, \shift.kr(0)) + sig;
	sig = RLPF.ar(sig, \lpf.kr(14000), \rq.kr(0.5) );
	sig = sig * EnvGen.kr(\asr.kr(Env.asr(0.01,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\fbfx2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = FreqShift.ar(sig, \shift.kr(0)) + sig;
	sig = RLPF.ar(sig, \lpf.kr(14000), \rq.kr(0.5) );
	sig = sig.tanh;
	sig = Limiter.ar(sig);
	Out.ar(\inbus.kr, sig * \fb.kr(0.6));
	sig = SelectX.ar(\mix.kr(0.5), [ DelayC.ar(in, 0.04, \indelay.kr(0.04)), sig]);
	sig = sig * EnvGen.kr(\asr.kr(Env.asr(0.01,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\fbfx3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = DelayC.ar(sig, 1/2, \delay.kr(1/2/~t)) + sig;
	sig = RLPF.ar(sig, \lpf.kr(14000), \rq.kr(0.5) );
	sig = sig.tanh;
	sig = Limiter.ar(sig);
	Out.ar(\inbus.kr, sig * \fb.kr(0.6));
	sig = SelectX.ar(\mix.kr(0.5), [ DelayC.ar(in, 0.04, \indelay.kr(0.04)), sig]);
	sig = sig * EnvGen.kr(\asr.kr(Env.asr(0.01,1,0.01)), gate, doneAction:2);
	Out.ar(out, sig);
}).add;

SynthDef(\leader1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), \itrig.tr(1));
	env2 = EnvGen.kr(Env([1,2,1]/2,[0.1,0.8]), \itrig.tr);
	env3 = EnvGen.kr(Env([1,2,1,2,1]-1,[0.1,0.8,0.1,0.2]), \itrig.tr);
	env4 = EnvGen.kr(Env([1,2,[1,2]]*2,[0.1,0.8]), \itrig.tr);
	env5 = EnvGen.kr(\envamp.kr(Env([1,1,2,1,1],[0.1,0.3,0.8,0.3])), \itrig.tr);
	freq = freq + env4;
	sig = LFSaw.ar(freq.lag(0.4));
	sig1 = LFSaw.ar(freq.lag(0.5) * ( 1 + ( SinOsc.kr(freq*1/2) * 1 )));
	sig = SelectX.ar(env3, [sig, sig1]);
	sig = RLPF.ar(sig, \lpfr.kr(2) * [1,1.01] * env1 * freq.lag(0.3), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * env2 * env5;
	pan = pan + sig.collect({ SinOsc.ar(1/12) * 0.1  });
	sig = sig / 1;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\leader2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,2,1],[0.1,0.8]), \itrig.tr(1));
	env2 = EnvGen.kr(Env([1,2,1]/2,[0.1,0.8]), \itrig.tr);
	env3 = EnvGen.kr(Env([1,2,1,2,1]-1,[0.1,0.8,0.1,0.2]), \itrig.tr);
	env4 = EnvGen.kr(Env([1,2,[1,2]]*2,[0.1,0.8]), \itrig.tr);
	env5 = EnvGen.kr(\envamp.kr(Env([1,1,2,1,1],[0.1,0.3,0.8,0.3])), \itrig.tr);
	freq = freq + env4;
	sig = LFSaw.ar(freq.lag(0.4));
	sig1 = LFSaw.ar(freq.lag(0.5) * ( 1 + ( SinOsc.kr(freq*1/2) * 1 )));
	sig = SelectX.ar(env3, [sig, sig1]);
	sig = RLPF.ar(sig, \lpfr.kr(2) * [1,1.01] * env1 * freq.lag(0.3), \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = sig * env2 * env5;
	//pan = pan + sig.collect({ SinOsc.ar(1/12) * 0.1  });
	sig.debug("sig");
	sig = sig / 8 / 2;
	//sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

///////////////////// INIT
BufDef(\bruit, "heavy/kick1.flac");
BufDef(\bruit2, "heavy/kick1.flac");
BufDef(\bruit3, "heavy/kick2.flac");

)

(
Pdef(\lead, PmonoArtic(\leader1,
	\note, Pseq([5,1,0,0],inf),
	\legato, 1,
	\itrig, 1,
	\dur, 1,
	\amp, 0.1
)).play;
);

Pdef(\lead).set(\out, BusDef(\sendbus0))
Pdef(\lead).set(\out, 0)
ProtoDef(\rdn).edit
ProtoDef(\rdn).play

(
Pdef(\lead, PmonoArtic(\leader1,
	\note, Pseq([5,1,0,0],inf),
	\legato, 0.5,
	\itrig, 1,
	\dur, 1,
	\amp, 0.1
)).play;
)
(
Pdef(\lead, PmonoArtic(\leader1,
	\note, Pseq([5,1,0,0],inf),
	\legato, 1,
	\itrig, 1,
	\dur, 1,
	\amp, 0.1
)).play;
)

(
Pdef(\lead, PmonoArtic(\leader1,
	\note, Pseq([5,1,0,0],inf).stutter(2),
	\legato, 1,
	\envamp, Pseq([
		[ Env([0, 0,0,1,0],[0, 0.3,1.1,1.8]) ],
		[ Env([0, 0,0,0,0],[0, 0.3,0.1,1.8]) ],
		[ Env([0, 0,1,0,0],[0, 0.3,1.1,1.8]) ],
		[ Env([0, 1,0,0,0],[0, 1.3,0.1,1.8]) ],
	],inf),
	\itrig, 1,
	\dur, 1/2,
	\amp, 0.1
)).play;
)

(
Pdef(\lead, PmonoArtic(\leader1,
	\note, Pseq([5,1,0,0],inf).stutter(2),
	\legato, 1,
	\envamp, Pseq([
		 {
			  [
			 	[ Env([0, 0,exprand(0.001,1),exprand(0.001,1),exprand(0.001,1)],[0, {rrand(0.01,1)}.dup(3)].flat) ];
			 	[ Env([0, 0,0,exprand(0.1,1),0],[0, {rrand(0.01,1)}.dup(3)].flat) ],
			 ].choose;
		}.dup(8)
	].flatten,inf),
	\itrig, 1,
	\dur, 1/2,
	\amp, 0.1
)).play;
)


(
Pdef(\lead, PmonoArtic(\leader2,
	\note, Pstep(Pseq([5,1,0,0],inf),1/8),
	\legato, Pseg(Pseq([1,1,0,1],inf),8),
	\lpfr, ~pmodenv.(Pseq([1,0.1,2,2],inf),4),
	\rq, ~pmodenv.(Pseq([0.41,0.1,0.2,0.2],inf),4),
	\itrig, 1,
	\dur, PdurStutter(Pseq([
		Pseq({[
			16,8,8,4, 16,4,16,8,
			8,8,8,8, 8,8,8,8,
			2,2,2,2, 2,2,2,2,
			1,1,1,1, 4,4,4,4,
			1,1,4,8, 4,4,2,2,
		].clump(4).choose}.dup(8).flat,inf)
	],inf), 1),
	\amp, 0.1
)).play;
)

(
Pdef(\lead2, PmonoArtic(\leader2,
	\note, Pstep(Pseq([5,1,0,0],inf),1/8),
	\legato, Pseg(Pseq([1,1,0,1],inf),8),
	\lpfr, ~pmodenv.(Pseq([1,0.1,2,2],inf),4),
	\rq, ~pmodenv.(Pseq([0.41,0.1,0.2,0.2],inf),4),
	\octave, 4,
	\itrig, 1,
	\dur, PdurStutter(Pseq([
		Pseq({[
			16,8,8,4, 16,4,16,8,
			8,8,8,8, 8,8,8,8,
			2,2,2,2, 2,2,2,2,
			1,1,1,1, 4,4,4,4,
			1,1,4,8, 4,4,2,2,
		].clump(4).choose}.dup(8).flat,inf)
	],inf), 1),
	\amp, 0.1
)).play;
)
////////////////////////////////////// DRAFT

Pdef(\main, Pdef(\drums));
Pdef(\drums).stop;




BufDef.loadDialog(\bruit)
BufDef(\bruit).path
BufDef.clear(\bruit)
(
Ndef(\bruit, { arg freq=200, pan=0, amp=0.1, bufnum=0;
	var sig;
	var phase;
	bufnum = BufDef(\bruit);
	phase = Phasor.ar(Impulse.kr(2*~t), 1/2,0.8,BufFrames.kr(bufnum));
	phase = Phasor.ar(Impulse.kr(1/2*~t), 1/8,BufFrames.kr(bufnum),0);
	sig = BufRd.ar(2, bufnum, phase);
}).play;
);

(
Ndef(\scapy, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001] *.t [0,4,7,9,11].midiratio);
	sig = sig.flop.collect({ arg isig;
		isig.collect({ arg iisig, xx;
			iisig = iisig* LFPulse.ar(xx+1 * 1/4).range(1,114.1);
			iisig = iisig* SinOsc.ar(xx+1 * 1/14).range(0,114.1);
			iisig.tanh  /2;
		})
	}).flop;
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(3) * freq * SinOsc.ar(sig.collect({arg xx; 1/14*( 1+xx ) })).range(1/2,2) , \rq.kr(0.5)* LFNoise1.ar(sig.collect({arg xx; 1/15*( 1+xx ) })).range(0.05,0.9));
	sig = sig * amp;
	sig = sig.flop.mean;
}).play;
Ndef(\scapy).play(BusDef(\sendbus0,\audio).index, 2)
);


(
)

//////////////////////////////////////////////////////////////// DRUMS

(
	~master_init.();
Pdef(\drums, 
	Pseq([
		Plazy({

			var patlist = (
				kick: PatKitDef(\sample1).asPattern(Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,1,
						1,0,0,1, 1,0,1,0,
						1,0,0,1, 0,0,1,0,
						1,0,1,1, 0,0,1,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
					\out, BusDef(\sendbus1,\audio),
				)),
				snare: PatKitDef(\sample1).asPattern(Pbind( // snare 1
					\kitIndex, 4,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, Pseq([0.1,0.1,0.2,0.1],inf).stutter(8),
					\dur, 1/8,
					\amp, 0.1,
					\out, BusDef(\sendbus1,\audio),
				)),
				hats: 2.collect({ arg idx;
					PatKitDef(\sample1).asPattern(Pbind( // hat
						\kitIndex, 8 + idx,
						\isRest, Pseq({[
							1,1,1,1, 0,0,0,0,
							0,0,0,0, 1,1,1,1,
							1,0,1,0, 1,0,1,0, 
							1,0,0,0, 1,0,0,0,
							0,0,0,0, 1,0,0,0,
						].clump(8).choose}.dup(8).flat,inf).coin.not,
						\sustain, Pseq([0.1,0.1,0.2,0.1],inf).stutter(8)/4,
						//\speed, rrand(0.99,1.1),
						\dur, 1/8,
						\amp, 0.1,
						\out, BusDef(\sendbus1,\audio),
					));
				}),
				kickdec: PatKitDef(\sample1).asPattern(Pbind( // kick 1
					\kitIndex, 1,
					\isRest, Pseq({[
						1,0,1,0, 1,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\lag, Pseg(Pseq([0,0.1,0,0.11,0.001],inf),8),
					\speed, Pseq([1/2,0.91],inf) * Pseg(Pseq([1,1.1,0.91],inf),8),
					\freq, 200,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
					\out, BusDef(\sendbus1,\audio),
				)),
				fx: PmonoArtic(\fbfx2,
					\legato, 1,
					\inbus, BusDef(\sendbus1),
					\shift, ~pmodenv.(Pseq([0,0,0,100],inf), 2),
					\fb, ~pmodenv.(Pseq([0,0,0,0.54],inf),2),
					\lpf, ~pmodenv.(Pseq([
						18000,70,150,70,
						1200, 1200, 4800, 4800,
					],inf), 4),
					\lpf, 10000,
				),
				fx2: PmonoArtic(\fbfx2,
					\legato, 1,
					\inbus, BusDef(\sendbus1),
					\shift, ~pmodenv.(Pseq([0,0,0,100],inf), 2),
					\fb, ~pmodenv.(Pseq([0.1,0.54,0.8,0.2],inf),2),
					\lpf, ~pmodenv.(Pseq([
						18000,70,150,70,
						1200, 1200, 4800, 4800,
					],inf), 4),
					\lpf, 10000,
				),
				lead: PmonoArtic(\leader2,
					\note, Pstep(Pseq([5,1,0,0],inf),1/8),
					\legato, Pseg(Pseq([1,1,0,1],inf),8),
					\lpfr, ~pmodenv.(Pseq([1,0.1,2,2],inf),4),
					\rq, ~pmodenv.(Pseq([0.41,0.1,0.2,0.2],inf),4),
					\itrig, 1,
					\dur, PdurStutter(Pseq([
						Pseq({[
							16,8,8,4, 16,4,16,8,
							8,8,8,8, 8,8,8,8,
							2,2,2,2, 2,2,2,2,
							1,1,1,1, 4,4,4,4,
							1,1,4,8, 4,4,2,2,
						].clump(4).choose}.dup(8).flat,inf)
					],inf), 1),
					\amp, 0.1
				),
				
			);
			var distkit1 = ~kitlib.lcd.distkit.collect(_.value);
			Pseq([
				Pfindur(6+8,
					Ptpar([
						0,patlist.kick,
						0,patlist.snare,
						0,patlist.fx,
						2,patlist.kickdec,
						4,Ppar(patlist.hats),
				
					].flat)
				),
				Pfindur(2,
					Ppar([
						Pbind(
							\dur, Pkey(\dur)/2, 
							\gain, Pkey(\amp) * Pseq([
								0.3,0.5,1,0.5,
							],inf).stutter(2),
							\isRest, Pseq([
								1,0,1,0, 1,0,1,0,
								1,0,1,0, 1,0,1,1,
								1,0,1,1, 1,0,1,0,
								1,1,1,0, 1,0,1,1,
							],inf).coin.not,

					
					) <> distkit1.kick,
						Pbind(\dur, Pkey(\dur)/2) <> distkit1.snare2,
						Pbind(\dur, Pkey(\dur)/2) <> distkit1.snare,
						Pbind(\fb, 0.4) <> patlist.fx,
					]),
				),
				Pfindur(6+8,
					Ptpar([
						0,patlist.kick,
						0,patlist.snare,
						0,patlist.fx2,
						2,patlist.kickdec,
						4,Ppar(patlist.hats),
				
					].flat)
				),
				Pfindur(2,
					Ppar([
						Pbind(
							\dur, Pkey(\dur)/2, 
							\gain, Pkey(\amp) * Pseq([
								0.3,0.5,1,0.5,
							],inf).stutter(2),
							\isRest, Pseq([
								1,0,1,0, 1,0,1,0,
								1,0,1,0, 1,0,1,1,
								1,0,1,1, 1,0,1,0,
								1,1,1,0, 1,0,1,1,
							],inf).coin.not,

					
					) <> distkit1.kick,
						Pbind(\dur, Pkey(\dur)/2) <> distkit1.snare2,
						Pbind(\fb, 0.4) <> patlist.fx,
					]),
				),
				Pfindur(6+8,
					Ptpar([
						0,patlist.lead,
						0,patlist.kick,
						0,patlist.snare,
						0,patlist.fx2,
						2,patlist.kickdec,
						4,Ppar(patlist.hats),
				
					].flat)
				),
				Pfindur(2,
					Ppar([
						Pbind(
							\dur, Pkey(\dur)/2, 
							\gain, Pkey(\amp) * Pseq([
								0.3,0.5,1,0.5,
							],inf).stutter(2),
							\isRest, Pseq([
								1,0,1,0, 1,0,1,0,
								1,0,1,0, 1,0,1,1,
								1,0,1,1, 1,0,1,0,
								1,1,1,0, 1,0,1,1,
							],inf).coin.not,

					
					) <> distkit1.kick,
						Pbind(\dur, Pkey(\dur)/2) <> distkit1.snare2,
						Pbind(\fb, 0.4) <> patlist.fx,
					]),
				),
			],4);
		})
	])
).play;
)

(
Pdef(\main, 
	Pseq([
		Pfindur(16,
			Ptpar([
				0,Pmono( \bruit,
					\bufnum, BufDef(\bruit),
					\rate, 1,
					\start, 0.0,
					\end, 1,
					\lpfr, 4002,
					\sign, 1,
					\phaselag, 0.00001,
					\trigrate, 1*~t,
					\dur, 1,
					\out, BusDef(\sendbus1,\audio),
					\amp, 0.1
				),
				4, Pbind(\out, BusDef(\sendbus1)) <> ~kitlib.lcd.part1,
				0,PmonoArtic(\fbfx2,
					\legato, 1,
					\inbus, BusDef(\sendbus1),
					\shift, ~pmodenv.(Pseq([
						1,0.001,0,0.001,
						0,0,0,100,
					],inf), 2),
					\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
					\lpf, ~pmodenv.(Pseq([
						18000,7000,1500,7000,
						18000,70,150,70,
						1200, 1200, 4800, 4800,
					],inf), 4),
					\timingOffset, 0.01,
					\group, GroupDef(\fx, nil, \addAfter),
					\lpf, 10000,
				),
				
			]),
		),
		Pfindur(16,
			Ptpar([
				0,Pmono( \bruit,
					\bufnum, BufDef(\bruit),
					\rate, 1,
					\start, 0.0,
					\end, 0.401,
					\lpfr, 2,
					\sign, -1,
					\phaselag, 0.00001,
					\trigrate, Pseq([40,50,60,40]+20,inf),
					\dur, 1,
					\out, BusDef(\sendbus1,\audio),
					\amp, 0.1
				),
				4,PatKitDef(\sample1).asPattern(Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,1,
						1,0,0,1, 1,0,1,0,
						1,0,0,1, 0,0,1,0,
						1,0,1,1, 0,0,1,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
					\out, BusDef(\sendbus1,\audio),
				)),
				8,Pmono( \bruit,
					\bufnum, BufDef(\bruit),
					\rate, 1,
					\start, 0.0,
					\end, 1,
					\lpfr, 4002,
					\sign, 1,
					\phaselag, 0.00001,
					\trigrate, 1*~t,
					\dur, 1,
					\out, BusDef(\sendbus1,\audio),
					\amp, 0.1
				),
				0,PmonoArtic(\fbfx2,
					\legato, 1,
					\inbus, BusDef(\sendbus1),
					\shift, ~pmodenv.(Pseq([0,0,0,100],inf), 2),
					\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
					\lpf, ~pmodenv.(Pseq([
						18000,7000,1500,7000,
						18000,70,150,70,
						1200, 1200, 4800, 4800,
					],inf), 4),
					\lpf, 10000,
				),
				
			]),
		),
		Pfindur(8,
			Ppar([
				Pmono( \bruit,
					\bufnum, BufDef(\bruit),
					\rate, 1,
					\start, 0.0,
					\end, 0.401,
					\lpfr, 2,
					\sign, -1,
					\phaselag, 0.00001,
					\trigrate, Pseq([40,50,60,40]+20,inf),
					\dur, 1,
					\out, BusDef(\sendbus1,\audio),
					\amp, 0.1
				),
				PmonoArtic(\fbfx2,
					\legato, 1,
					\inbus, BusDef(\sendbus1),
					\shift, ~pmodenv.(Pseq([0,0,0,100],inf), 2),
					\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
					\lpf, ~pmodenv.(Pseq([
						18000,7000,1500,7000,
						18000,70,150,70,
						1200, 1200, 4800, 4800,
					],inf), 4),
					\lpf, 10000,
				),
				
			]),
		),
		Pfindur(8,
			Ppar([
				Pmono( \bruit,
					\bufnum, BufDef(\bruit),
					\rate, 1,
					\start, 0.0,
					\end, 0.401,
					\lpfr, 2,
					\sign, -1,
					\phaselag, 0.00001,
					\trigrate, Pseq([40,50,60,40]+20,inf),
					\dur, 1,
					\out, BusDef(\sendbus1,\audio),
					\amp, 0.1
				),
				PatKitDef(\sample1).asPattern(Pbind( // kick 1
					\kitIndex, 0,
					\isRest, Pseq({[
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 1,0,1,1,
						1,0,0,1, 1,0,1,0,
						1,0,0,1, 0,0,1,0,
						1,0,1,1, 0,0,1,1,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\sustain, 0.1,
					\dur, 1/8,
					\amp, 0.1,
					\out, BusDef(\sendbus1,\audio),
				)),
				PmonoArtic(\fbfx2,
					\legato, 1,
					\inbus, BusDef(\sendbus1),
					\shift, ~pmodenv.(Pseq([0,0,0,100],inf), 2),
					\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
					\lpf, ~pmodenv.(Pseq([
						18000,7000,1500,7000,
						18000,70,150,70,
						1200, 1200, 4800, 4800,
					],inf), 4),
					\lpf, 10000,
				),
				
			]),
		),
		Pfindur(16,
			Ptpar([
				0,Pmono( \bruit,
					\bufnum, BufDef(\bruit),
					\rate, 1,
					\start, 0.0,
					\end, 0.401,
					\lpfr, 2,
					\sign, -1,
					\phaselag, 0.00001,
					\trigrate, Pseq([40,50,60,40]+20,inf),
					\dur, 1,
					\out, BusDef(\sendbus1,\audio),
					\amp, 0.1
				),
				4, Pbind(\out, BusDef(\sendbus1)) <> ~kitlib.lcd.part1,
				0,PmonoArtic(\fbfx2,
					\legato, 1,
					\inbus, BusDef(\sendbus1),
					\shift, ~pmodenv.(Pseq([0,0,0,100],inf), 2),
					\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
					\lpf, ~pmodenv.(Pseq([
						18000,7000,1500,7000,
						18000,70,150,70,
						1200, 1200, 4800, 4800,
					],inf), 4),
					\lpf, 10000,
				),
				
			]),
		),
	],2)
).play;
)

(
	~master_init.();
Pdef(\main,
	Ptpar([
		0,Pmono( \bruit,
			\bufnum, BufDef(\bruit3),
			\rate, 1,
			\start, 0.0,
			\end, 1,
			\lpfr, 4002,
			\sign, 1,
			\phaselag, 0.00001,
			\trigrate, 1*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		),
		0,Pmono( \bruit,
			\bufnum, BufDef(\bruit3),
			\rate, 1,
			\start, 0.4,
			\end, 1,
			\lpfr, 1002,
			\sign, 1,
			\phaselag, Pseq([1,0.1,10,0.3],inf),
			\trigrate, Pseq([4,2,6,8],inf)*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		),
		4, Pbind(\out, BusDef(\sendbus1)) <> Ppar(~kitlib.lcd.distkit.collect({ arg val; val.value })),
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\delay, ~pmodenv.(Pseq([0.0001,0,0.03],inf), 4),
			\inbus, BusDef(\sendbus1),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,100,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),

	]),
).play;
)
BufDef(\bruit3, "heavy/kick2.flac")

~distkit1
(
	~distkit1 = ~kitlib.lcd.distkit.collect(_.value);
Pdef(\main,
	Ptpar([
		0,Pmono( \bruit,
			\bufnum, BufDef(\bruit3),
			\rate, 2,
			\start, 0.0,
			\end, 1,
			\lpfr, 4002,
			\sign, 1,
			\phaselag, 0.00001,
			\trigrate, 1*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		),
		0,Pmono( \bruit,
			\bufnum, BufDef(\bruit3),
			\rate, 1/2,
			\start, 0.4,
			\end, 1,
			\lpfr, 1002,
			\sign, 1,
			\phaselag, Pseq([1,0.1,10,0.3],inf),
			\trigrate, Pseq([4,2,6,8],inf)*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		),
		4, Pbind(\out, BusDef(\sendbus1)) <> Ppar([
			~distkit1.hat1,
			~distkit1.kick,
			~distkit1.snare,
			~distkit1.hat2,
		].collect({ arg pp;
			Pbind(\out, BusDef(\sendbus1)) <> pp
			//pp
		})),
		8, Pbind(\out, BusDef(\sendbus2,\audio)) <> ~kitlib.lcd.part1,
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\delay, ~pmodenv.(Pseq([0,0.0001,0,0.3],inf), 4),
			\inbus, BusDef(\sendbus1),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,100,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),
		0,PmonoArtic(\fbfx2,
			\legato, 1,
			\inbus, BusDef(\sendbus2, \audio),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,1,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),

	]),
).play;
)

(
	~distkit1 = ~kitlib.lcd.distkit.collect(_.value);
Pdef(\main,
	Ptpar([
		0,Pmono( \bruit,
			\bufnum, BufDef(\bruit3),
			\rate, 1,
			\start, 0.0,
			\end, 1,
			\lpfr, 4002,
			\sign, 1,
			\phaselag, 1.00001,
			\trigrate, 2*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		),
		0,Pmono( \bruit,
			\bufnum, BufDef(\bruit3),
			\rate, 1/2,
			\start, 0.4,
			\end, 1,
			\lpfr, 1002,
			\sign, 1,
			\phaselag, Pseq([1,0.1,10,0.3],inf),
			\trigrate, Pseq([4,2,6,8],inf)*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		),
		4, Pbind(\out, BusDef(\sendbus1)) <> Ppar([
			~distkit1.hat1,
			~distkit1.kick,
			~distkit1.snare,
			~distkit1.hat2,
		].collect({ arg pp;
			Pbind(\out, BusDef(\sendbus1)) <> pp
			//pp
		})),
		8, Pbind(\out, BusDef(\sendbus2,\audio)) <> ~kitlib.lcd.slow_ksh,
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\delay, ~pmodenv.(Pseq([0.0001,0,0.3],inf), 4),
			\inbus, BusDef(\sendbus1),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,100,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),
		0,PmonoArtic(\fbfx2,
			\legato, 1,
			\inbus, BusDef(\sendbus2, \audio),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,1,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),

	]),
).play;
)

(
	~distkit1 = ~kitlib.lcd.distkit.collect(_.value);
Pdef(\main,
	Ptpar([
		0,Pfindur(8,Pmono( \bruit,
			\bufnum, BufDef('heavy/snare1.flac'),
			\rate, ~pmodenv.(Pseq([1/4,2],2), 8),
			\start, 0.0,
			\end, 1,
			\lpfr, 4002,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, 1/2*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		8,Pfindur(128,Pmono( \bruit,
			\bufnum, BufDef('heavy/snare1.flac'),
			\rate, 1,
			\start, 0.0,
			\end, 1,
			\lpfr, 4002,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, 1/2*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		0,Pmono( \bruit,
			\bufnum, BufDef(\bruit3),
			\rate, 1/2,
			\start, 0.4,
			\end, 1,
			\lpfr, 1002,
			\sign, 1,
			\phaselag, Pseq([1,0.1,10,0.3],inf),
			\trigrate, Pseq([4,2,6,8],inf)*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		),
		4, Pbind(\out, BusDef(\sendbus1)) <> Ppar([
			~distkit1.hat1,
			~distkit1.kick,
			~distkit1.snare,
			~distkit1.hat2,
		].collect({ arg pp;
			Pbind(\out, BusDef(\sendbus1)) <> pp
			//pp
		})),
		8, Pbind(\out, BusDef(\sendbus2,\audio)) <> ~kitlib.lcd.part1,
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\delay, ~pmodenv.(Pseq([0.0001,0,0.3],inf), 4),
			\inbus, BusDef(\sendbus1),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,100,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),
		0,PmonoArtic(\fbfx2,
			\legato, 1,
			\inbus, BusDef(\sendbus2, \audio),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,1,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),

	]),
).play;
)

(
	~distkit1 = ~kitlib.lcd.distkit.collect(_.value);
Pdef(\main,
	Ptpar([
		0,Pfindur(8,Pmono( \bruit,
			\bufnum, BufDef('voices/03_camion.flac'),
			\rate, ~pmodenv.(Pseq([1/4,2],2), 8),
			\start, 0.0,
			\end, 1,
			\lpfr, 4002,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, 1/2*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		8,Pfindur(32-10,Pmono( \bruit,
			\bufnum, BufDef('heavy/snare1.flac'),
			\rate, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,3/4,
				],1),
				Pseq([
					1,2,1,2, 1,2,1,3,
				],1),
				Pseq([
					1,2,1,1/2, 1,2,1,1/3,
				],1),
				Pseq([
					2,3/4,1,1/2, 1,2/5,1.6,0.9,
				],1),
			],inf),
			\start, 0.0,
			\end, 1,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, Pseq([1,1,1,1, 2,2,3,4, 1,8,1,8, 8,8,16,16],inf).stutter(8)/2*~t,
			\lpfr,  18002*0.6 / Pkey(\trigrate),
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		64+16, Pdef(\lead),
		64+32, Pdef(\lead2),
		32,Pfindur(64,Pmono( \bruit,
			\bufnum, BufDef('heavy/snare1.flac'),
			\rate, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,3/4,
				],1),
				Pseq([
					1,2,1,2, 1,2,1,3,
				],1),
				Pseq([
					1,2,1,1/2, 1,2,1,1/3,
				],1),
				Pseq([
					2,3/4,1,1/2, 1,2/5,1.6,0.9,
				],1),
			],inf),
			\start, 0.0,
			\end, 1,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, Pseq([1,1,1,1, 2,2,3,4, 1,8,1,8, 8,8,16,16],inf).stutter(8)/2*~t,
			\lpfr,  18002*0.6 / Pkey(\trigrate),
			\dur, PdurStutter(Pseq([1,2, 4,4,8,8],inf), 1).stutter(8),
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		0,Pmono( \bruit,
			\bufnum, BufDef(\bruit3),
			\rate, 1/2,
			\start, 0.4,
			\end, 1,
			\lpfr, 1002,
			\sign, 1,
			\phaselag, Pseq([1,0.1,10,0.3],inf),
			\trigrate, Pseq([4,2,6,8],inf)*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		),
		4, Pbind(\out, BusDef(\sendbus1)) <> Ppar([
			~distkit1.hat1,
			~distkit1.kick,
			~distkit1.snare,
			~distkit1.hat2,
		].collect({ arg pp;
			Pbind(\out, BusDef(\sendbus1)) <> pp
			//pp
		})),
		8, Pbind(\out, BusDef(\sendbus2,\audio)) <> ~kitlib.lcd.part1,
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\delay, ~pmodenv.(Pseq([0.0001,0,0.3],inf), 4),
			\inbus, BusDef(\sendbus1),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,100,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),
		0,PmonoArtic(\fbfx2,
			\legato, 1,
			\inbus, BusDef(\sendbus2, \audio),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,1,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),

	]),
).play;
)

(
	~distkit1 = ~kitlib.lcd.distkit.collect(_.value);
Pdef(\main,
	Ptpar([
		0,Pfindur(8,Pmono( \bruit,
			\bufnum, BufDef('voices/03_camion.flac'),
			\rate, ~pmodenv.(Pseq([1/4,2],2), 8),
			\start, 0.0,
			\end, 1,
			\lpfr, 4002,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, 1/2*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		8,Pfindur(32-10,Pmono( \bruit,
			\bufnum, BufDef('heavy/snare1.flac'),
			\rate, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,3/4,
				],1),
				Pseq([
					1,2,1,2, 1,2,1,3,
				],1),
				Pseq([
					1,2,1,1/2, 1,2,1,1/3,
				],1),
				Pseq([
					2,3/4,1,1/2, 1,2/5,1.6,0.9,
				],1),
			],inf),
			\start, 0.0,
			\end, 1,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, Pseq([1,1,1,1, 2,2,3,4, 1,8,1,8, 8,8,16,16],inf).stutter(8)/2*~t,
			\lpfr,  18002*0.6 / Pkey(\trigrate),
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\delay, ~pmodenv.(Pseq([0.0001,0,0.3],inf), 4),
			\inbus, BusDef(\sendbus1),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,100,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),
		0,PmonoArtic(\fbfx2,
			\legato, 1,
			\inbus, BusDef(\sendbus2, \audio),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,1,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),

	]),
).play;
)

(
	~distkit1 = ~kitlib.lcd.distkit.collect(_.value);
Pdef(\main,
	Ptpar([
		0,Pfindur(8,Pmono( \bruit,
			\bufnum, BufDef('voices/01_fear.flac'),
			\rate, ~pmodenv.(Pseq([1/4,1,1/2,1]/2,2), 1),
			\start, 0.0,
			\end, 1,
			\lpfr, 4002,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, 1/2*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		8,Pfindur(32-10,Pmono( \bruit,
			\bufnum, BufDef('heavy/snare1.flac'),
			\rate, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,3/4,
				],1),
				Pseq([
					1,2,1,2, 1,2,1,3,
				],1),
				Pseq([
					1,2,1,1/2, 1,2,1,1/3,
				],1),
				Pseq([
					2,3/4,1,1/2, 1,2/5,1.6,0.9,
				],1),
			],inf),
			\start, 0.0,
			\end, 1,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, Pseq([1,1,1,1, 2,2,3,4, 1,8,1,8, 8,8,16,16],inf).stutter(8)/2*~t,
			\lpfr,  18002*0.6 / Pkey(\trigrate),
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		16, Pbind(\out, BusDef(\sendbus2,\audio)) <> ~kitlib.lcd.slow_ksh,
		0, Pbind(\out, BusDef(\sendbus0,\audio)) <> ~kitlib.lcd.distkit.hat.value,
		16+4, Pbind(\out, BusDef(\sendbus2,\audio)) <> ~kitlib.lcd.distkit.hat.value,
		16+8, Pbind(\out, BusDef(\sendbus2,\audio)) <> ~kitlib.lcd.distkit.hat2.value,
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\delay, ~pmodenv.(Pseq([0.0001,0,0.3],inf), 4),
			\inbus, BusDef(\sendbus1),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,100,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),
		0,PmonoArtic(\fbfx2,
			\legato, 1,
			\inbus, BusDef(\sendbus2, \audio),
			\shift, ~pmodenv.(Pseq([
				100,0.001
			],inf), 1/2),
			\fb, ~pmodenv.(Pseq([0,0.4],inf),1/8),
			//\fb, 0.5,
			\mix,0.51,
			\lpf, ~pmodenv.(Pseq([
				18000,700,1500,70,
			],inf), 1/2),
			\timingOffset, 0.01,
			//\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),

	]),
).play;
)

(
	~distkit1 = ~kitlib.lcd.distkit.collect(_.value);
Pdef(\main,
	Ptpar([
		0,Pfindur(8,Pmono( \bruit,
			\bufnum, BufDef('voices/snare2.flac'),
			\rate, ~pmodenv.(Pseq([1/4,1,1/2,1]/2,2), 1),
			\start, 0.0,
			\end, 1,
			\lpfr, 4002,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, 1/2*~t,
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		8,Pfindur(32-10,Pmono( \bruit,
			\bufnum, BufDef('heavy/snare1.flac'),
			\rate, Pseq([
				Pseq([
					1,1,1,1, 1,1,1,3/4,
				],1),
				Pseq([
					1,2,1,2, 1,2,1,3,
				],1),
				Pseq([
					1,2,1,1/2, 1,2,1,1/3,
				],1),
				Pseq([
					2,3/4,1,1/2, 1,2/5,1.6,0.9,
				],1),
			],inf),
			\start, 0.0,
			\end, 1,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 1.00001,
			\trigrate, Pseq([1,1,1,1, 2,2,3,4, 1,8,1,8, 8,8,16,16],inf).stutter(8)/2*~t,
			\lpfr,  18002*0.6 / Pkey(\trigrate),
			\dur, 1,
			\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),
		0, Pbind(\out, BusDef(\sendbus0,\audio)) <> ~kitlib.lcd.part1,
		0, Pbind(\out, BusDef(\sendbus2,\audio)) <> ~kitlib.lcd.slow_ksh,
		0, Pbind(\out, BusDef(\sendbus2,\audio)) <> ~kitlib.lcd.distkit.hat.value,
		4, Pbind(\out, BusDef(\sendbus1,\audio)) <> ~kitlib.lcd.distkit.hat.value,
		8, Pbind(\out, BusDef(\sendbus0,\audio)) <> ~kitlib.lcd.distkit.hat2.value,
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\delay, ~pmodenv.(Pseq([0.0001,0,0.3],inf), 4),
			\inbus, BusDef(\sendbus1),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,100,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\inbus, BusDef(\sendbus2, \audio),
			\shift, ~pmodenv.(Pseq([
				100,0.001
			],inf), 1/2),
			\delay, 0.00001,
			\fb, ~pmodenv.(Pseq([0.1,0.415],inf),1),
			//\fb, 0.5,
			\mix,1.0,
			\lpf, ~pmodenv.(Pseq([
				18000,700,1500,70,
			],inf), 1),
			\timingOffset, 0.01,
			//\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),

	]),
).play;
~master_init.();
)

(
	~distkit1 = ~kitlib.lcd.distkit.collect(_.value);
Pdef(\main,
	Ptpar([
		0,Pfindur(32,Pmono( \bruit3,
			\bufnum, BufDef('bruit1/07_ukraine.flac'),
			\bufnum, BufDef('voices/02_moeten.flac'),
			//\bufnum, BufDef('heavy/snare1.flac').path.debug("kj"),
			//\rate, 2,
			\rate, ~pmodenv.(Pseq([1,0.8,2,1/2],inf)*140,4),
			\start, ~pmodenv.(Pseq([0.1,0.109,0],inf),4),
			\end, 0.11,
			\lpf, 18002,
			\sign, 1,
			\gain, 1/4,
			\phaselag, 0.1,
			\trigrate, ~pmodenv.(Pseq([1/10,1,200,15000],inf),8),
			\trigrate, 4*~t,
			\dur, 1,
			//\out, BusDef(\sendbus1,\audio),
			\amp, 0.1
		)),

	]),
).play;
~master_init.();
)

(
~master_init.();
	~distkit1 = ~kitlib.lcd.distkit.collect(_.value);
Pdef(\main,
	Ptpar([
		0,Pfindur(32,PmonoArtic( \bruit3,
			\bufnum, BufDef('fix1/kick.flac'),
			\rate, Pseq([
				Pseq([
					1,1/2,
				],1),
			],inf) * 1,
			\start, ~pmodenv.(Pseq([0,0.5],inf), 8),
			\start, 0.2,
			\range, 10,
			\legato, Pseq([1,1,1,0.7],inf),
			\end, 1,
			\sign, 1,
			\gain, 1/1,
			\phaselag, 0.10001,
			\trigrate, Pseq([1,8,12,4],inf).stutter(8)/2*~t,
			\lpfr,  18002,
			\dur, 1/4,
			\out, BusDef(\sendbus0,\audio),
			\amp, 0.1
		)),
		0, Pbind(
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			],inf).coin.not,
			\out, BusDef(\sendbus0,\audio),
		) <> ~kitlib.lcd.hiphop.kick.value,
		0, Pbind(
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\out, BusDef(\sendbus0,\audio),
		) <> ~kitlib.lcd.hiphop.snare.value,
		0,PmonoArtic(\fbfx3,
			\legato, 1,
			\delay, ~pmodenv.(Pseq([0.0001,0,0.3],inf), 4),
			\inbus, BusDef(\sendbus1),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,100,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),
		0,PmonoArtic(\fbfx2,
			\legato, 1,
			\inbus, BusDef(\sendbus2, \audio),
			\shift, ~pmodenv.(Pseq([
				1,0.001,0,0.001,
				0,0,0,1,
			],inf), 2),
			\fb, ~pmodenv.(Pseq([0,0,0,0, 0.1,0.54,0.8,0.2],inf),2),
			\fb, 0.4,
			\lpf, ~pmodenv.(Pseq([
				18000,7000,1500,7000,
				18000,70,150,70,
				1200, 1200, 4800, 4800,
			],inf), 4),
			\timingOffset, 0.01,
			\group, GroupDef(\fx, nil, \addAfter),
			\lpf, 10000,
		),

	]),
).play;
)
