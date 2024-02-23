
~t = 132/2/60; TempoClock.default.tempo = ~t;

// electroclash

(
SynthDef(\movebass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.02,1.03]).mean;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\movehi, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.02,1.03]).mean;
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
	// aka silead
SynthDef(\simpleacid, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,2,1],[0.01,0.8])), 1);
	sig = LFSaw.ar(freq + [ [0,0.0001] ] * [1,1/2,2]).sum;
	sig.debug("sig");
	sig = RLPF.ar(sig, \lpfr.kr(2.1) * freq * env1, \rq.kr(0.5));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
);

////////////////////////////// lib

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[742].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2109].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.13,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2029].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1144].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,0,
				0,0,0,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1339].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pstep(Pseq([
				1,0.4,0.1,0.5,0.9,1.4,
			],inf),16),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				2, 6,
			]+0,1),4).loop / Pkey(\st),
			\isRest, Pseq([

				Pseq([
					0,0,0,0,
				],16),
				Pseq([
					1,1,1,1,
				],16),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85/2/60,
			\speed, 1.3 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0.6,1),1/2).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					0,0,0,0,
				],8),
				Pseq([
					1,0,1,0,
				],8),
				1,0,1,0,
				1,0,1,1,
				1,0,1,0,
				1,0,1,0,

				1,0,1,0,
				1,1,1,1,
				1,0,1,0,
				1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[742].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,


				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,1,0, 1,0,1,0,

				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,

				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 1,0,1,0,
				1,1,1,1, 1,0,0,1,
			],inf).coin.not,
			\dur, PdurStutter(Pseq([
				1,1,1,1,
				1,1,1,1,
				2,2,2,2,
				8,8,8,8,
				8,8,8,8,
			],inf), 1/8),
			\dur, 1/16,
			\legato, 2,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2109].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.13,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2029].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1144].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,0,
				0,0,0,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1339].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pstep(Pseq([
				1,0.4,0.1,0.5,0.9,1.4,
			],inf),16),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				2, 6,
			]+0,1),4).loop / Pkey(\st),
			\isRest, Pseq([

				Pseq([
					0,0,0,0,
				],16),
				Pseq([
					1,1,1,1,
				],16),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85/2/60,
			\speed, 1.3 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0.6,1),1/2).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					0,0,0,0,
				],8),
				Pseq([
					1,0,1,0,
				],8),
				1,0,1,0,
				1,0,1,1,
				1,0,1,0,
				1,0,1,0,

				1,0,1,0,
				1,1,1,1,
				1,0,1,0,
				1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
	])
)).play;
);

////////////////////////////////

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[742].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2109].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.13,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2029].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1144].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,1,1,0,
				0,0,0,0, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1339].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\legato, Pstep(Pseq([
				1,0.4,0.1,0.5,0.9,1.4,
			],inf),16),
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.07,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Average White Band - Got The Love.wav'),
			\legato, 1,
			\st, 176/4/60,
			\speed, 1/2 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				2, 6,
			]+0,1),4).loop / Pkey(\st),
			\isRest, Pseq([

				Pseq([
					0,0,0,0,
				],16),
				Pseq([
					1,1,1,1,
				],16),
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85/2/60,
			\speed, 1.3 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 2,
			]+0.6,1),1/2).loop / Pkey(\st),
			\isRest, Pseq([
				Pseq([
					0,0,0,0,
				],8),
				Pseq([
					1,0,1,0,
				],8),
				1,0,1,0,
				1,0,1,1,
				1,0,1,0,
				1,0,1,0,

				1,0,1,0,
				1,1,1,1,
				1,0,1,0,
				1,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 1/8,
		),
		Pbind(
			\instrument, \movebass,
			\note, Pseq([
				0,0,3,3,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,4,-1
			],inf),4),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \movehi,
			\note, Pseq([
				0,3,7,
			],inf) + Pseq([12,0,-12,0],inf).stutter(4),
			\legato, Pseg(Pseq([0.1,1],inf),16),
			\ctranspose, Pstep(Pseq([
				0,4,-1
			],inf),4),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \movehi,
			\note, Pseq([
				0,3,7,
			],inf) + Pseq([12,0,-12,0,24].rotate(3),inf).stutter(1),
			\lpfr, Pseg(Pseq([1,8],inf),32),
			\legato, Pseg(Pseq([2,0.1,1],inf),16),
			\ctranspose, Pstep(Pseq([
				0,4,-1
			],inf),4),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \movehi,
			\note, Pseq([
				0,3,7,0,
				0,3,7,Prand((0..12),1),
			],inf) + Pseq([24,12,0].rotate(3),inf).stutter(3),
			\lpfr, Pseg(Pseq([2,1,8],inf),16),
			\legato, Pseg(Pseq([1,1.3,0.1],inf),8),
			\ctranspose, Pstep(Pseq([
				0,4,-1
			],inf),4),
			\dur, 1/8,
			\amp, 0.1,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		
	])
)).play;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[742].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2109].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.13,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2029].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,0,1, 1,0,0,0,
				1,0,1,0, 1,0,0,0,
				0,0,0,0, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		Pbind(
			\instrument, \movebass,
			\note, Pseq([
				0,-1,0,0,
			],inf).stutter(4),
			\ctranspose, Pstep(Pseq([
				0,0,4,4,-1,-1,0,3,
				4,4,3,4,-1,0,-1,-2,

			],inf),2),
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				1,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,

				1,0,1,0, 0,0,1,0,
				0,0,1,0, 1,0,1,0,

				1,0,1,0, 0,0,1,0,
				0,0,1,0, 1,0,0,0,
			],inf).coin.not,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \simpleacid,
			//\out, BusDef(\fx2),
			\env1, Pseq([
				Pseq([
					[ Env([2,1,1],[0.21,0.8]) ],
					[ Env([2,1,1/2],[0.21,0.8]) ],
				],8),
			],inf),
			\lpfr, 4,
			\rq, Pseq([
				Pseg(Pseq([0.5,0.1],inf),8),
			],inf),
			\note, Pseq([
				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,

				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,
				0,0,7-12,7-12,

				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,

				0,2,0,-1,
				0,7-12,3-12,-1,
				0,3-12,3,-1,
				0,0,7-12,7-12,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,0,4,4,-1,-1,0,3,
				4,4,3,4,-1,0,-1,-2,

			],inf),2),
			\octave, Ptuple([
				Pseq([
					6,5,4,
				],inf).stutter(4),
				Pseq([
					3,6,5,4,
				],inf).stutter(8),
			]),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\legato, Pseq([
				0.7,
			],inf),
			\lag, Ptuple([
				Pseq([
					0,1/4,1/8,
					1/16,1/8,1/8,
				]/~t,inf).stutter(32),
				0
			]),
			\dur, 1/4,
			\amp, 0.011/2,
		),
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pdef(\drums2),
		Pbind(
			\instrument, \simpleacid,
			//\out, BusDef(\fx2),
			\env1, Pseq([
				Pseq([
					[ Env([2,1,1],[0.21,0.8]) ],
					[ Env([2,1,1/2],[0.21,0.8]) ],
				],8),
			],inf),
			\lpfr, 4,
			\rq, Pseq([
				Pseg(Pseq([0.5,0.1],inf),8),
			],inf),
			\note, Pseq([
				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,

				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,
				0,0,7-12,7-12,

				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,

				0,2,0,-1,
				0,7-12,3-12,-1,
				0,3-12,3,-1,
				0,0,7-12,7-12,
			],inf),
			\ctranspose, Pstep(Pseq([
				0,0,4,4,-1,-1,0,3,
				4,4,3,4,-1,0,-1,-2,

			],inf),2),
			\octave, Ptuple([
				3,4,
			]),
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\legato, Pseq([
				0.7,
			],inf),
			\lag, Ptuple([
				Pseq([
					0,1/4,1/8,
					1/16,1/8,1/8,
				]/~t,inf).stutter(32),
				0
			]),
			\dur, 1/8,
			\amp, 0.009,
			\lag, -0.04,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(  \simpleacid,
			//\out, BusDef(\fx2),
			\env1, Pseq([
				Pseq([
					[ Env([2,1,1],[0.21,0.8]) ],
					[ Env([2,1,1/2],[0.21,0.8]) ],
				],8),
			],inf),
			\lpfr, 2,
			\rq, Pseq([
				Pseg(Pseq([0.5,0.1],inf),8),
			],inf),
			\note, Pseq([
				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,

				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,
				0,0,7-12,7-12,

				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,
				0,2,3,-1,

				0,2,0,-1,
				0,7-12,3-12,-1,
				0,3-12,3,-1,
				0,0,7-12,7-12,
			],inf).stutter(8),
			\note, Pseq([
				0,-1,
			],inf).stutter(8),
			\octave, 3,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.4) ],
			],inf),
			\legato, Pseq([
				0.7,
			],inf),
			\dur, 1/4,
			\amp, 0.011*3,
			\lag, -0.04,
			\out, BusDef(\ifx2, \audio),
		),

		Pmono(\fx_crossfade,
			\inbus, BusDef(\ifx1, \audio),
			\inbus2, BusDef(\ifx2, \audio),
			\mix, Pseq([
				1,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,

				1,1,1,1, 1,1,1,0,
				1,1,1,1, 1,1,0,0,

				1,1,1,1, 1,1,1,1,
				1,1,0,1, 1,1,0,0,


			],inf),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(\instrument, \fx_env,
			\inbus, BusDef(\sendbus1back, \audio),
			\addAction, \addToTail,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.3,1,-4) ],
			],inf),
			\legato, Pseg(Pseq([0.6,0.1,1],inf),8),

			\lag, 0.0009,
			\dur, PdurStutter(Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,4,1,1,1,2,
				1,1,1,1, 1,1,1,1,
				1,1,1,8, 1,4,2,8,
			],inf), 1/2),
		),
		
	])
)).play;
);
