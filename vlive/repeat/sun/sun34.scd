
~t = 140/4/60; TempoClock.default.tempo = ~t;
///////////////////////////:
/// experiment with portedplugins ugens


(
Ndef(\yo, { 
    VosimOsc.ar(
        freq: SinOsc.kr(SinOsc.kr(0.01)).exprange(10,800), 
        form1freq: SinOsc.kr([0.5,0.1]).exprange(100,1000), 
        form2freq: SinOsc.kr(0.39).exprange(100,1000), 
        shape: SinOsc.kr(10)
    ) * 0.1
}).play;
)


(
SynthDef(\anabadrum, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;

    sig = AnalogBassDrum.ar(
        1, 
        infsustain: \infsustain.kr(1.002), 
        accent: \accent.kr(0.05), 
        freq: freq,
        tone: \tone.kr(0.11),
        decay: \decay.kr(3.05), 
		attackfm: \attackfm.kr(0.0001),
        selffm:\selffm.kr(0.1)
    );
	sig = sig * 10 * 12 * 3;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\vosim, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = VosimOsc.ar(freq, \form1freq.kr(0),\form2freq.kr(0), \shape.kr(0));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\vosim2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = VosimOsc.ar(freq, freq*\form1freq.kr(1),freq*\form2freq.kr(1), \shape.kr(0));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \anabadrum,
			\note, Pseq([
				0,-1,-1,-1,
			],inf)-2,
			\octave, 3,
			\legato, 0.6,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,0,0,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1625].value,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[911].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 1,1,0,1,
				0,1,1,1, 0,1,0,1,
				0,1,0,1, 1,1,1,0,

				0,1,0,1, 0,1,0,1,
				0,1,0,1, 1,1,1,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		
		PmonoArtic( \vosim2,
			\note, Pseq([
				//7,10,
				7,7,7,7,
				7,7,7,7,
				7,7,7,7,
				7,7, 14,14,
				7,7,7,7,
				7,7,7,7,
				7,7,7,7,
				10,10,10,10,
			],inf).stutter(2),
			\ctranspose, Pstep(Pseq([
				3-12,
			],inf),2),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.51,
			],inf),
			\legato, Pseq([
				Prand([
					1,1,0.1,0.5
				],1),
			],inf),
			//\form1freq, ~pmodenv.(Pseq([3,2,1,4]/2,1), 7).loop,
			//\form2freq, ~pmodenv.(Pseq([1,2,1,4]/2,1), 8).loop,
			\form2freq, Pseq([
				1/10.02,
				10.02,
			],inf).stutter(2),
			\form1freq, Pseq([7,7,13.3]/10,inf),
			\shape, ~pmodenv.(Pseq([0.4,1]* -1,1), 7).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.6,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \anabadrum,
			\note, Pseq([
				0,-1,-1,-1,
			],inf)-2,
			\octave, 3,
			\legato, 0.6,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,1,0,0,
				1,0,0,1, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/16,
			\amp, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1625].value,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11/3,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[911].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 1,1,0,1,
				0,1,1,1, 0,1,0,1,
				0,1,0,1, 1,1,1,0,

				0,1,0,1, 0,1,0,1,
				0,1,0,1, 1,1,1,1,
				0,1,0,1, 0,1,0,1,
				0,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.06,
		),
		
		PmonoArtic( \vosim2,
			\note, Pseq([
				Plazy({ arg ev;
					var rr = [14,13,10].scramble;
					
					Pseq([
						7,7,7,7,
						7,7,7,7,
						7,7,7,7,
						7,7, rr[0],rr[0],
						7,7,7,7,
						7,7,7,7,
						7,7,7,7,
						rr[1],rr[1],rr[1]
					],1).stutter(2)
				}).loop,
			],inf),
			\ctranspose, Pstep(Pseq([
				3-12,
			],inf),2),
			\legato, Pseq([
				1,1,1,1, 1,1,1,1,
				1,1,1,1, 1,1,1,0.51,
			],inf),
			\legato, Pseq([
				Prand([
					1,1,0.1,0.5
				],1),
			],inf),
			//\form1freq, ~pmodenv.(Pseq([3,2,1,4]/2,1), 7).loop,
			//\form2freq, ~pmodenv.(Pseq([1,2,1,4]/2,1), 8).loop,
			\form2freq, Pseq([
				1/10.02,
				10.02,
			],inf).stutter(2),
			\form1freq, Pseq([7,7,13.3]/10,inf),
			\shape, ~pmodenv.(Pseq([0.4,1]* -1,1), 7).loop,
			\octave, 3,
			\dur, 1/8,
			\amp, 0.2,
			\lag, -0.04,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 0.4,
			\st, 85/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					(0..3), (0..3),
					(0..3), (0..3),
					(0..3), (0..3),
					(0..3), (0..3),
				].flatten+6,1),
			].flatten/8+0.62,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4 * Pseq([
				1,1,1,1,
				1,1,1,1,
			],inf),
			\lag, -0.04,
			\lag,0.13,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, BufDef.stereo('vbreaks/Barry White I\'m Gonna Love You Just A Little Bit More Baby.wav'),
			\legato, 1,
			\st, 85/2/60,
			\speed, 1 * ~t / Pkey(\st),
			\pos, Pseg(Pseq([
				0, 4,
			]+0.6,1),4).loop / Pkey(\st),
			\pos, Pseq([
				Pseq([
					(0..3)+4,
				].flatten+6,1),
			].flatten/8+0.6,inf) / Pkey(\st),
			\dur, 1/8,
			\gain, 1/4 * Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, Pseq([ 1,1,1,1, ]/10,1),
			],inf),
			\isRest, Pfunc({ arg ev;
				ev[\gain] == 0;
			}),
			\lag, -0.04,
			\lag,0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \anabadrum,
			\note, Pseq([
				0,-1,-1,-1,
			],inf)-2,
			\octave, 3,
			\legato, 0.2,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1625].value,
			\legato, 0.5,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.2) ],
			],inf),
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[911].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.08,
		),
		
		
	])
)).play;
);

(
Pdef(\melo, 
		Pbind(
			\instrument, \vosim2,
			\form1freq, 1,
			\form2freq, 1,
			\shape, 0.6,
			//\shape, ~pmodenv.(Pseq([-1,1],1), 4).loop,
			\octave, 4,
			\dur, 1/4,
			\amp, 0.3,
		),
);
);

ProtoDef(\piano).startControl(Pdef(\melo))


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \anabadrum,
			\freq, 80,
			\dur, 1,
			\amp, 9.1,
		),
		 
	])
)).play;
);
