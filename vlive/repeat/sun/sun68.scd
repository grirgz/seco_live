~t = 127/2/60; TempoClock.default.tempo = ~t;

(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				Pseq([
					1,0,0,0, 1,0,0,0,
				],7),
				1,0,0,0, 1,0,0,1,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[258].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\hats1, 
	Ppar([
		
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1122].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,1,
				0,1,0,1, 0,1,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.02,
		),
	])
)).play;
);

//////////////////////////////////////////////////


(
Pdef(\part, Pdef(\zedpart, 
	Pfindur(4,Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[673].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[195].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1/2,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[751].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[60].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				Pwhite(0.9,1,1),
				0,
				Pwhite(0.1,1,3),
				0,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[927].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,1,
			],inf).coin.not,
			\dur, 1/8,
			\sustain, 0.04,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\gain, 0.11/2 * Pseq([
				0,
				Pwhite(0.7,1,1),
				0,
				Pwhite(0.1,1,3),
				
			],inf),
		),
		
	]))
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[258].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
		Pmono(
			\bassjump,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\fmf, Pstep(Pseq([
				1/2,2,4,1.05,
			],inf),1),
			\octave, 3,
			\dur, 1,
			\amp, 0.2,
		),
		Pmono(\lili,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
SynthDef(\bassjump, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, fmf=4;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1*~t,2/3 * pi); 
	lfo2 = SinOsc.ar(4*~t,2/8 * pi).unipolar * XLine.kr(0.001,1,8/~t); 
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq*fmf.poll) * lfo2 + 1 ));
	sig = ( sig*\distamp.kr(2)*lfo1 ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\lili, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * SinOsc.ar(8*~t).unipolar; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[258].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
		Pmono(
			\bassjump,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\fmf, Pstep(Pseq([
				1/2,2,4,1.05,
			],inf),1),
			\octave, 3,
			\dur, 1,
			\amp, 0.2,
		),
		Pmono(\lili,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
SynthDef(\bassjump, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, fmf=4;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1*~t,2/3 * pi); 
	lfo2 = SinOsc.ar(4*~t,2/8 * pi).unipolar * XLine.kr(0.001,1,8/~t); 
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq*fmf.poll) * lfo2 + 1 ));
	sig = ( sig*\distamp.kr(2)*lfo1 ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\lili, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo2 = Duty.kr(1/~t, 0, Dseq([
		1,0,0.3,0,
	],inf));
	lfo1 = SinOsc.ar(freq) + 1 * SinOsc.ar(4*~t).unipolar * lfo2 ;
	sig = SinOsc.ar(freq);
	sig = FreqShift.ar(sig, freq * lfo1);
	sig = sig * SinOsc.ar(8*~t).unipolar; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[258].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1122].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,1,
				0,1,0,1, 0,1,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.02,
		),
		
		Pmono(
			\bassjump,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\fmf, Pstep(Pseq([
				1/2,2,4,1.05,
			],inf),1),
			\octave, 3,
			\dur, 1,
			\amp, 0.2,
		),
		Pmono(\lili,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \plane,
			\note, Pseq([
				9,10,12,14,
				16,17,19,19,
			],inf),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,5.1) ],
			],inf),
			//\fmr, Ptuple(Pwhite(0.9,1.1)!3),
			\fmamp, 0.3,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8*2).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,4,8,6,6,6,6],1), 8*2).loop,
			//\lpfr, 5,
			//\rq, ~pmodenv.(Pseq([0.51,0.2,0.1,0.7],1), 8).loop,
			\delfac, ~pmodenv.(Pseq([0.1,1,200,2000],1), 8*4).loop,
			\rq, 0.5,
			\legato, 0.5,
			\dur, Pseq([2,4,6],inf),
			\amp, 0.1/8/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \plane,
			\note, Pseq([
				[0,7,12,12+7,7-12],
				[0,6,12,12+6,7-12],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,5.1) ],
			],inf),
			//\fmr, Ptuple(Pwhite(0.9,1.1)!3),
			\fmamp, 0.3,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8*2).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,4,8,6,6,6,6],1), 8*2).loop,
			//\lpfr, 5,
			//\rq, ~pmodenv.(Pseq([0.51,0.2,0.1,0.7],1), 8).loop,
			\delfac, ~pmodenv.(Pseq([0.1,1,200,2000],1), 8*4).loop,
			\rq, 0.5,
			\legato, 0.5,
			\dur, 2,
			\amp, 0.1/8,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\verbmix, 1.0,
			\damp, 0.5,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 1/2,
			\lag, 0.0005,
			\dur, 1,
			\gain, 0.5,
			//\out, BusDef(\ifx2, \audio),
		),
		
	])
)).play;
SynthDef(\bassjump, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, fmf=4;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1*~t,2/3 * pi); 
	lfo2 = SinOsc.ar(4*~t,2/8 * pi).unipolar * XLine.kr(0.001,1,8/~t); 
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq*fmf) * lfo2 + 1 ));
	sig = ( sig*\distamp.kr(2)*lfo1 ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\lili, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo2 = Duty.kr(1/2/~t, 0, Dseq([
		1,0,0.3,0,
		0.5,0,0.3,0.1,
		0.5,0,0.3,0.1,
		0.5,0,0.3,0.1,
	],inf));
	lfo1 = SinOsc.ar(freq) + 1 * SinOsc.ar(4*~t).unipolar * lfo2 ;
	sig = SinOsc.ar(freq);
	sig = FreqShift.ar(sig, freq * lfo1);
	sig = sig * SinOsc.ar(8*~t).unipolar; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\plane, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num= 10;
	sig = LFSaw.ar(freq * LFNoise1.ar(0.1,mul:0.009,add:1!num)* ( SinOsc.ar(freq  * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ));
	sig = sig.mean;
	sig = sig + DelayL.ar(sig, 0.3, \delfac.kr(1) * 0.0001 * SinOsc.kr(1/4).range(1/2,1));
	//sig = HPF.ar(sig, 500);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	//sig = sig.softclip(0.1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\chorusdel, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig + DelayL.ar(sig, 0.3, 0.00001);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

Pdef(\part).source.source.list

(
WindowDef(\playline, { arg def, pdef;
	var li;
	if(pdef.source.isKindOf(Pdef)) {
		pdef = pdef.source;
	};
	if(pdef.source.isKindOf(Ppar)) {
		li = pdef.source.list;
	};
	VLayout(*li.collect { arg item, idx;
		PlayerWrapper(Pdef((\playline++idx).asSymbol, item)).asView
	} ++ [nil]);
	
}).front(Pdef(\part));
)
Pdef(\playline5).clear;

(
Pdef(\melo, 
	Pbind(
		\instrument, \violin2,
		\adsr, Pseq([
			[ Env.adsr(0.8,0.1,0.8,1.4) ],
		],inf),
	)
)
);

ProtoDef(\piano).startControl(Pdef(\melo))

(
SynthDef(\violin, {
	| midinote=60, gate=1, amp=0.8 |
	var env = EnvGen.kr(Env.asr(0.1, 1, 0.1), gate, doneAction:2);
	var sig = VarSaw.ar(
		midinote.midicps,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8))*0.25;
	sig = sig * env * amp;
	Out.ar(0, sig!2);
//It is also used for simulating Farfisa organ and flutes
//by nicolaariutti
//http://sccode.org/1-5as
}).add;
SynthDef(\violin2, {
	| midinote=60, gate=1, amp=0.8 |
	var env = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.8)), gate, doneAction:2);
	var sig = VarSaw.ar(
		midinote.midicps,
		width:LFNoise2.kr(1).range(0.2, 0.8)*SinOsc.kr(5, Rand(0.0, 1.0)).range(0.7,0.8))*0.25;
	sig = sig * env * amp;
	Out.ar(0, sig!2);
//It is also used for simulating Farfisa organ and flutes
//by nicolaariutti
//http://sccode.org/1-5as
}).add;
)

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[258].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1122].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,1,
				0,1,0,1, 0,1,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.02,
		),
		
		Pmono(
			\bassjump,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\fmf, Pstep(Pseq([
				1/2,2,4,1.05,
			],inf),1),
			\octave, 3,
			\dur, 1,
			\amp, 0.2,
		),
		Pmono(\lili,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \plane,
			\note, Pseq([
				9,10,12,14,
				16,17,19,19,
			],inf),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,5.1) ],
			],inf),
			//\fmr, Ptuple(Pwhite(0.9,1.1)!3),
			\fmamp, 0.3,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8*2).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,4,8,6,6,6,6],1), 8*2).loop,
			//\lpfr, 5,
			//\rq, ~pmodenv.(Pseq([0.51,0.2,0.1,0.7],1), 8).loop,
			\delfac, ~pmodenv.(Pseq([0.1,1,200,2000],1), 8*4).loop,
			\rq, 0.5,
			\legato, 0.5,
			\dur, Pseq([2,4,6],inf),
			\amp, 0.1/8/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \plane,
			\note, Pseq([
				[0,7,12,12+7,7-12],
				[0,6,12,12+6,7-12],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,5.1) ],
			],inf),
			//\fmr, Ptuple(Pwhite(0.9,1.1)!3),
			\fmamp, 0.3,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8*2).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,4,8,6,6,6,6],1), 8*2).loop,
			//\lpfr, 5,
			//\rq, ~pmodenv.(Pseq([0.51,0.2,0.1,0.7],1), 8).loop,
			\delfac, ~pmodenv.(Pseq([0.1,1,200,2000],1), 8*4).loop,
			\rq, 0.5,
			\legato, 0.5,
			\dur, 2,
			\amp, 0.1/8,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\verbmix, 1.0,
			\damp, 0.5,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 1/2,
			\lag, 0.0005,
			\dur, 1,
			\gain, 0.5,
			//\out, BusDef(\ifx2, \audio),
		),
		
	])
)).play;
SynthDef(\bassjump, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, fmf=4;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1*~t,2/3 * pi); 
	lfo2 = SinOsc.ar(4*~t,2/8 * pi).unipolar * XLine.kr(0.001,1,8/~t); 
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq*fmf) * lfo2 + 1 ));
	sig = ( sig*\distamp.kr(2)*lfo1 ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\lili, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo2 = Duty.kr(1/2/~t, 0, Dseq([
		Dseq([
			1,0,0.3,0,
			0.5,0,0.3,0.1,
			0.5,0,0.3,0.1,
			0.5,0,0.3,0.1,
		],4),
		Dseq([
			1,0,0,0,
			0.5,0,0,0,
			0.5,0,0,0,
			0.5,0,0,0,
		],2),
		Dseq([
			1,0,0.3,0,
			0.5,0,0.3,0.1,
			0.5,0,0.3,0.1,
			0.5,0,0.3,0.1,
		],4),
		Dseq([
			0,0,0.3,0,
			0,0,0.3,0.1,
			0,0,0.3,0.1,
			0,0,0.3,0.1,
		],2),
	],inf));
	lfo3 = Duty.kr(1/~t, 0, Dseq([
		Dseq([4],3),
		4,4,4,1/4,
	],inf));
	lfo1 = SinOsc.ar(freq) + 1 * SinOsc.ar(lfo3*~t).unipolar * lfo2 ;
	sig = SinOsc.ar(freq);
	sig = FreqShift.ar(sig, freq * lfo1);
	sig = sig * SinOsc.ar(8*~t).unipolar; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\plane, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num= 10;
	sig = LFSaw.ar(freq * LFNoise1.ar(0.1,mul:0.009,add:1!num)* ( SinOsc.ar(freq  * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ));
	sig = sig.mean;
	sig = sig + DelayL.ar(sig, 0.3, \delfac.kr(1) * 0.0001 * SinOsc.kr(1/4).range(1/2,1));
	//sig = HPF.ar(sig, 500);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	//sig = sig.softclip(0.1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\chorusdel, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig + DelayL.ar(sig, 0.3, 0.00001);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,1,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,1,0, 1,0,0,0,

				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[258].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,

				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1122].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,1,
				0,0,1,0, 0,0,1,1,
				0,1,0,1, 0,1,0,1,
				1,1,1,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.02,
		),
		
		Pmono(
			\bassjump,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\fmf, Pstep(Pseq([
				1/2,2,4,1.05,
			],inf),1),
			\octave, 3,
			\dur, 1,
			\amp, 0.2,
		),
		Pmono(\lili,
			\note, Pstep(Pseq([
				0,4,5,0,
			],inf),4),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \plane,
			\note, Pseq([
				9,10,12,14,
				16,17,19,19,
			],inf),
			\octave, 6,
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,5.1) ],
			],inf),
			//\fmr, Ptuple(Pwhite(0.9,1.1)!3),
			\fmamp, 0.3,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8*2).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,4,8,6,6,6,6],1), 8*2).loop,
			//\lpfr, 5,
			//\rq, ~pmodenv.(Pseq([0.51,0.2,0.1,0.7],1), 8).loop,
			\delfac, ~pmodenv.(Pseq([0.1,1,200,2000],1), 8*4).loop,
			\rq, 0.5,
			\legato, 0.5,
			\dur, Pseq([2,4,6],inf),
			\amp, 0.1/8/2,
			\out, BusDef(\ifx1, \audio),
		),
		Pbind(
			\instrument, \plane,
			\note, Pseq([
				[0,7,12,12+7,7-12],
				[0,6,12,12+6,7-12],
			],inf),
			\adsr, Pseq([
				[ Env.adsr(3.1,0.1,0.8,5.1) ],
			],inf),
			//\fmr, Ptuple(Pwhite(0.9,1.1)!3),
			\fmamp, 0.3,
			//\lpfr, ~pmodenv.(Pseq([1,2,1,4],1), 8*2).loop,
			\lpfr, ~pmodenv.(Pseq([1,2,4,8,6,6,6,6],1), 8*2).loop,
			//\lpfr, 5,
			//\rq, ~pmodenv.(Pseq([0.51,0.2,0.1,0.7],1), 8).loop,
			\delfac, ~pmodenv.(Pseq([0.1,1,200,2000],1), 8*4).loop,
			\rq, 0.5,
			\legato, 0.5,
			\dur, 2,
			\amp, 0.1/8,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_freeverb2,
			\verbmix, 1.0,
			\damp, 0.5,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\mix, 0.5,
			\room, 1/2,
			\lag, 0.0005,
			\dur, 1,
			\gain, 0.5,
			//\out, BusDef(\ifx2, \audio),
		),
		
	])
)).play;
SynthDef(\bassjump, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, fmf=4;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(1*~t,2/3 * pi); 
	lfo2 = SinOsc.ar(4*~t,2/8 * pi).unipolar * XLine.kr(0.001,1,8/~t); 
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq*fmf) * lfo2 + 1 ));
	sig = ( sig*\distamp.kr(2)*lfo1 ).tanh * \distpostamp.kr(1/2);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\lili, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo2 = Duty.kr(1/2/~t, 0, Dseq([
		Dseq([
			1,0,0.3,0,
			0.5,0,0.3,0.1,
			0.5,0,0.3,0.1,
			0.5,0,0.3,0.1,
		],4),
		Dseq([
			1,0,0,0,
			0.5,0,0,0,
			0.5,0,0,0,
			0.5,0,0,0,
		],2),
		Dseq([
			1,0,0.3,0,
			0.5,0,0.3,0.1,
			0.5,0,0.3,0.1,
			0.5,0,0.3,0.1,
		],4),
		Dseq([
			0,0,0.3,0,
			0,0,0.3,0.1,
			0,0,0.3,0.1,
			0,0,0.3,0.1,
		],2),
	],inf));
	lfo3 = Duty.kr(1/~t, 0, Dseq([
		Dseq([4],3),
		4,4,4,1/4,
	],inf));
	lfo4 = Duty.kr(1/~t, 0, Dseq([
		8,8,1,1,
	],inf));
	lfo5 = Duty.kr(1/8/~t, 0, Dseq([
		Dseq([
			1,2,1/2,3/4,
			2,1/2,2,4,
		],3),
		Dseq([
			1,2,1/2,3/4,
			1,1,1/2,1/4,
		],1),
	],inf)).lag(0.1) * SinOsc.ar(0.1/2,mul:0.7,add:1) ;
	lfo6 = Duty.kr(1/8/~t, 0, Dseq([
		1,8,1,2,
	],inf)).lag(0.2);
	lfo1 = SinOsc.ar(freq) + 1 * SinOsc.ar(lfo3*~t).unipolar * lfo2 ;
	sig = LFSaw.ar(freq);
	sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * lfo5 * freq ).clip(20,20000), \rq.kr(0.1) * lfo6);
	sig = FreqShift.ar(sig, freq * lfo1);
	sig = sig * 1/2;
	sig = sig * SinOsc.ar(lfo4*~t).unipolar; 
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\plane, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num= 10;
	sig = LFSaw.ar(freq * LFNoise1.ar(0.1,mul:0.009,add:1!num)* ( SinOsc.ar(freq  * \fmr.kr(1)) * \fmamp.kr(0.5) + 1 ));
	sig = sig.mean;
	sig = sig + DelayL.ar(sig, 0.3, \delfac.kr(1) * 0.0001 * SinOsc.kr(1/4).range(1/2,1));
	//sig = HPF.ar(sig, 500);
	sig = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.5));
	//sig = sig.softclip(0.1);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\chorusdel, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	//sig = sig + DelayL.ar(sig, 0.3, 0.00001);
	sig = SelectX.ar(\mix.kr(1), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
);



//////////////////////

(
SynthDef(\tower, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = (1..8).reverse.linexp(1,8,0.1,8) * ( LFNoise1.ar(0.1) * 0.1 + 1 ); 
	lfo1 = ( SinOsc.ar(\lfof.kr(2),(1..8)/4 * pi).range(0,1) ); 
	sig = SinOsc.ar(freq * ( 2 ** ( (1..8)*1.0052 ) )) * lfo1;
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\tower, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = (1..8).reverse.linexp(1,8,0.1,8) * ( LFNoise1.ar(0.1) * 0.1 + 1 ); 
	lfo1 = ( SinOsc.ar(\lfof.kr(2),(1..8)/4 * pi).range(0,1) ); 
	sig = LFSaw.ar(freq * ( 2 ** ( (1..8)*1.0052 ) )) * lfo1;
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
45 * ( 2 ** (1..8) )
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \tower,
			\note, Pseq([
				0,3,2,-5,
			],inf) + Pseq([
				[0,3,7],
				[0,4,7],
			],inf),
			\lfof, ~pmodenv.(Pseq([1,0.18],1), 8).loop,
			\octave, 3,
			\dur, 1,
			\amp, 0.1/2,
		),
		
	])
)).play;
);

(
SynthDef(\towerenv, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = (1..8).reverse.linexp(1,8,0.1,8) * ( LFNoise1.ar(0.1) * 0.1 + 1 ); 
	lfo1 = ( SinOsc.ar(\lfof.kr(2),(1..8)/4 * pi).range(0,1) ); 
	lfo1 = 8.collect({ arg idx;
		//EnvGen.kr(Env([0,1,0],[0.1 * idx,0.8]), 1)
		EnvGen.kr(Env.adsr(0.3 * ( idx+1 ),0.1,0.8,2.3), gate, doneAction:0);
	});
	sig = LFSaw.ar(freq * ( 2 ** ( (1..8)*1.0052 ) )) * lfo1;
	sig = RLPF.ar(sig, ( \lpfr.kr(5.1) * freq ).clip(20,20000), \rq.kr(0.2));
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([

		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[434].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,1, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \towerenv,
			\note, Pseq([
				0,3,2,-5,
			],inf) + Pseq([
				[0,3,7],
				[0,4,7],
			],inf),
			\lpfr, ~pmodenv.(Pseq([2,4,8,16],8), 1/8).loop,
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\ifx1, \audio),
		),
		Pmono(\fx_greyhole,
			\delay, 0.2,
			\damp, 0.0,
			\size, 0.2,
			\diff, 0.70700001716614,
			\fb, 0.89999997615814,
			\modDepth, 0.10000000149012,
			\modFreq, 2.0,
			\mix, 0.3,
			\gain, 1.0,
			\inbus, BusDef(\ifx1, \audio),
			\addAction, \addToTail,
			\lag, 0.0009,
			\dur, 1,
		),
		
	])
)).play;
);



//////////////


(
SynthDef(\fmc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(SinOsc.ar(freq) * freq * 1 + 1 );
	sig = SinOsc.ar(freq * ( SinOsc.ar(freq) * 1 + 0.1 ) );
	//sig = SinOsc.ar(( freq * ( SinOsc.ar(freq) * 0.1 + 1 )  ).poll);
	//sig = SinOsc.ar(( freq * ( SinOsc.ar(1) * 1 + 0.1 )  ).poll);
	sig = SinOsc.ar(( freq * ( SinOsc.ar(freq) * 4 + 0.3 )  ).poll);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fmc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(SinOsc.ar(freq*[[1,1/2,2]] + [0,0.0007]) * freq * LFNoise1.kr(0.021).range(1,10) + LFNoise1.kr(0.02).exprange(0.01,1) );
	sig = sig.flop.mean.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(2.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\fmc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env1 = EnvGen.kr(\fmaadsr.kr(Env.adsr(2.1,0.1,0.8,1.3)), gate, doneAction:0)*1;
	//env1 = 1;
	env2 = EnvGen.kr(\fmcadsr.kr(Env.adsr(2.1,0.1,0.8,1.3)), gate, doneAction:0)*1;
	env3 = EnvGen.kr(\fmaadsr2.kr(Env.adsr(4.1,0.1,0.8,1.3)), gate, doneAction:0)*4 +1;
	sig = SinOsc.ar(SinOsc.ar(freq*[[1/4,2]] + [0,0.02]) * freq * env1 * LFNoise1.kr(0.021).range(1,1.01) + (LFNoise1.kr(0.02).exprange(0.001,0.01) + env2 ));
	sig2 = LFPulse.ar(SinOsc.ar(freq*[[1,2]] + [0,0.02]) * freq * 1 * env3 * LFNoise1.kr(0.021).range(1,1.01) + (LFNoise1.kr(0.02).exprange(0.001,0.31) + env2 + 0.1 ));
	sig = [sig, sig2 * 0.2].sum;
	sig = sig.flop.mean.debug("sig");
	sig = LeakDC.ar(sig);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmc,
			\note, Pseq([
				0,1,2,3,
			],inf),
			\note, Pseq([
				[0,3,7],
				[0,3,7]+3,
				[0,4,7]+4,
				[0,9,7]+4,
				//[-1,4,7,9]+4,
			],inf),
			\legato, 0.6,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmc,
			\note, Pseq([
				0,1,2,3,
			],inf),
			\note, Pseq([
				[0,3,7],
				[0,3,7]+3,
				[0,3,7]+2,
				[0,9,7]+1,
				//[-1,4,7,9]+4,
			],inf),
			\legato, 0.6,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);

(
	// generate fmc
SynthDef(\fmc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=10;
	sig = num.collect { arg idx;
		var isig;
		var oscgen = {
			[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
		};
		isig = oscgen.value.ar(oscgen.value.ar(freq * [1,2,1/2,1/4].choose) * freq * [1,2,1/2,1/4].choose + rrand(0.001,0.1));
		isig;
	};
	sig = RLPF.ar(sig, ( \lpfr.kr(5.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
	// add atonal frequencies, bof non ?
SynthDef(\fmc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=10;
	sig = num.collect { arg idx;
		var isig;
		var oscgen = {
			[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
		};
		isig = oscgen.value.ar(oscgen.value.ar(freq * [1,2,4,1/2,1/4].choose) * [freq,exprand(200.0,1000)].choose * [1,2,4,1/2,1/4].choose + rrand(0.001,0.1));
		isig;
	};
	sig = RLPF.ar(sig, ( \lpfr.kr(5.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\fmc, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=2;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	sig = num.collect { arg idx;
		var isig;
		var oscgen = {
			[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
		};
		isig = oscgen.value.ar(oscgen.value.ar(freq * [1,2,1/2,1/4].choose) * freq * [1,2,1/2,1/4].choose + rrand(0.001,0.1));
		isig;
	};
	//sig = RLPF.ar(sig, ( \lpfr.kr(1.1) * freq ).clip(20,20000), \rq.kr(0.5));
	//sig = SinOsc.ar(freq * ( sig * 0.7 + 1 ));
	//sig = SinOsc.ar(sig * 0.1 + 1 * freq);
	//sig = sig * LFPulse.ar(freq);
	env1 = EnvGen.ar(Env.dadsr(0.1,0.1,1.1,0.1,4.1),gate,doneAction:0) * 0.3;
	sig = SinOsc.ar(freq * ( sig * env1 + 1 ));
	sig = RLPF.ar(sig, ( \lpfr.kr(5.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = LeakDC.ar(sig);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\melo, 
	Pbind(
		\instrument, \fmc,
	)
)
);
ProtoDef(\piano).startControl(Pdef(\melo))
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmc,
			\note, Pseq([
				0,1,2,3,
			],inf),
			\note, Pseq([
				[0,3,7],
				[0,3,7]+3,
				[0,4,7]+4,
				[0,9,7]+4,
				//[-1,4,7,9]+4,
			],inf),
			\legato, 0.6,
			\dur, 2,
			\amp, 0.1,
		),
	])
)).play;
);



(
	// generate fmc
SynthDef(\fmclustergen, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=20;
	sig = num.collect { arg idx;
		var isig;
		var oscgen = {
			[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
		};
		var harms = [1,2,4,1/2,1/4];
		isig = oscgen.value.ar(oscgen.value.ar(freq * harms.choose) * freq * harms.choose + rrand(0.01,0.2));
		isig = isig * EnvGen.ar(Env.adsr(rrand(0.1,5),rrand(0.1,5),rrand(0.01,1),rrand(0.1,1)),gate,doneAction:0);
		isig;
	};
	sig = sig.clump(2).flop.sum;
	sig.debug("sig");
	sig = RLPF.ar(sig, ( \lpfr.kr(5.1) * freq ).clip(20,20000), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
	// generate fmc
SynthDef(\fmclustergen, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num=20;
	sig = num.collect { arg idx;
		var isig;
		var oscgen = {
			[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
		};
		var harms = [1,2,4,1/2,1/4];
		var fenv;
		isig = oscgen.value.ar(oscgen.value.ar(freq * harms.choose) * freq * harms.choose + rrand(0.01,0.2));
		isig = isig * EnvGen.ar(Env.adsr(rrand(0.1,5),rrand(0.1,5),rrand(0.01,1),rrand(0.1,1)),gate,doneAction:0);
		fenv = EnvGen.ar(Env.adsr(rrand(0.1,5),rrand(0.1,5),rrand(0.01,1),rrand(0.1,1)),gate,doneAction:0);
		fenv = fenv * rrand(0.1,8) + rrand(0.1,2);
		isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * fenv ).clip(20,20000), \rq.kr(0.5));
		isig;
	};
	sig = sig.clump(2).flop.mean;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
	// generate fmc
SynthDef(\fmclustergen2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
	var sig;
	var num=40;
			//thisThread.randSeed = 10021;
			//thisThread.randSeed = 100000.rand.debug("seed");
	sig = num.collect { arg idx;
		var isig;
		var oscgen = {
			[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
		};
		var harms = [1,2,4,1/2,1/4];
		var fenv;
		isig = oscgen.value.ar(oscgen.value.ar(freq * harms.choose) * freq * harms.choose + rrand(0.01,0.2));
		isig = isig * EnvGen.ar(Env.dadsr(rrand(0,1.3),rrand(0.1,5),rrand(0.1,5),rrand(0.01,1),rrand(0.1,4)),gate,doneAction:0, timeScale:timeScale);
		fenv = EnvGen.ar(Env.adsr(rrand(0.1,5),rrand(0.1,5),rrand(0.01,1),rrand(0.1,5)),gate,doneAction:0, timeScale:timeScale);
		fenv = fenv * rrand(0.1,3) + rrand(0.1,2);
		isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * harms.choose * fenv ).clip(20,20000), \rq.kr(0.5));
		isig;
	};
	sig = sig.clump(4).flop.mean / 4;
	sig.debug("sig");
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
	sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
	Out.ar(out, sig);
}).add;
);
(
// generate fmc
~gen_fmclustergen2 = { arg seed=10022;
	SynthDef(\fmclustergen2v_+++seed, { arg out=0, gate=1, amp=0.1, pan=0, freq=200, timeScale=1;
		var sig;
		var num=40;
		thisThread.randSeed = seed;
		//thisThread.randSeed = 100000.rand.debug("seed");
		sig = num.collect { arg idx;
			var isig;
			var oscgen = {
				[SinOsc,LFSaw,LFPulse].wchoose([1,0.1,0.1].normalizeSum)
			};
			var harms = [1,2,4,1/2,1/4];
			var fenv;
			isig = oscgen.value.ar(oscgen.value.ar(freq * harms.choose) * freq * harms.choose + rrand(0.01,0.2));
			isig = isig * EnvGen.ar(Env.dadsr(rrand(0,1.3),rrand(0.1,5),rrand(0.1,5),rrand(0.01,1),rrand(0.1,4)),gate,doneAction:0, timeScale:timeScale);
			fenv = EnvGen.ar(Env.adsr(rrand(0.1,5),rrand(0.1,5),rrand(0.01,1),rrand(0.1,5)),gate,doneAction:0, timeScale:timeScale);
			fenv = fenv * rrand(0.1,3) + rrand(0.1,2);
			isig = RLPF.ar(isig, ( \lpfr.kr(1.1) * freq * harms.choose * fenv ).clip(20,20000), \rq.kr(0.5));
			isig;
		};
		sig = sig.clump(4).flop.mean / 4;
		sig.debug("sig");
		sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
		//sig = Pan2.ar(sig, pan, amp); // pan is transparent here 
		sig = Splay.ar(sig, \spread.kr(0.1), amp, pan);
		Out.ar(out, sig);
	}).add;
}
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \fmclustergen2,
			\note, Pseq([
				[0,3,7],
				[0,3,7]+3,
				[0,3,7]+2,
				[0,9,7]+1,
				//[-1,4,7,9]+4,
			],inf),
			\octave, 5,
			\legato, 0.9,
			\dur, 4,
			\amp, 0.1,
		),
	])
)).play;
);
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, ~gen_fmclustergen2.(12303),
			\note, Pseq([
				0,1,2,3,
			],inf),
			\timeScale, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 5,
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_fmclustergen2.(1236),
			\note, Pseq([
				10,9,8,7,
			],inf)-1,
			\timeScale, 1/2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 6,
			\legato, 1/2,
			\lag, 0.2,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, ~gen_fmclustergen2.(4240),
			\note, Pseq([
				0,7,
			],inf) + [0,12],
			\timeScale, 1/8,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\octave, 6,
			\legato, 1/2,
			\lag, 0.2,
			\dur, 1/4,
			\amp, 0.1,
		),
		Pdef(\drums1)
	])
)).play;
);
(
Pdef(\melo, 
	Pbind(
		\instrument, \fmclustergen2,
		\instrument, \fmc,
		\amp, 0.05,
	)
)
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		
	])
)).play;
);

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var num = 10;
	sig = SinOsc.ar(freq);
	num.do { arg idx;
		sig = SinOsc.ar(freq * ( sig * rrand(0.01,1) + 1 )) 
	};
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
SynthDef(\pilefm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 10;
	sig = SinOsc.ar(freq);
	num.do { arg idx;
		sig = SinOsc.ar(freq * ( sig * rrand(0.01,1) + 1 )) 
	};
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\pilefm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 10;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;

	sig = LFSaw.ar(freq);
	num.do { arg idx;
		sig = LFSaw.ar(freq + ( sig * freq * rrand(0.01,1/2) + 1 )) 
	};
	sig = RLPF.ar(sig, ( \lpfr.kr(3.1) * freq ).clip(20,20000), \rq.kr(0.5));

	sig2 = LFSaw.ar(freq);
	num.do { arg idx;
		sig2 = SinOsc.ar(freq + ( sig2 * freq * rrand(0.01,1/2) + 1 )) 
	};

	sig3 = LFSaw.ar(freq*2);
	num.do { arg idx;
		sig3 = LFPulse.ar(freq + ( sig3 * freq * rrand(0.01,1/2) + 1 )) 
	};
	sig3 = RLPF.ar(sig3, ( \sig3lpfr.kr(3.1) * freq ).clip(20,20000), \sig3rq.kr(0.5));

	sig = sig * EnvGen.kr(Env([0,1,0],[0.01,0.3]), 1);
	sig2 = sig2 * EnvGen.kr(\sig2adsr.kr(Env.dadsr(0.1,1.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig3 = sig3 * EnvGen.kr(\sig3adsr.kr(Env.dadsr(0.3,4.1,0.1,0.8,4.1,1,-1)), gate, doneAction:2);
	//sig2 = 0;
	sig = [sig, sig2, sig3].sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);
(
SynthDef(\pilefm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 10;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;

	sig = LFSaw.ar(freq);
	num.do { arg idx;
		sig = LFSaw.ar(freq + ( sig * freq * rrand(0.01,1/2) )) 
	};
	sig = RLPF.ar(sig, ( \lpfr.kr(3.1) * freq ).clip(20,20000), \rq.kr(0.5));

	sig2 = LFSaw.ar(freq);
	num.do { arg idx;
		sig2 = SinOsc.ar(freq + ( sig2 * freq * rrand(0.01,1/2) )) 
	};

	sig3 = LFSaw.ar(freq);
	num.do { arg idx;
		sig3 = LFSaw.ar(freq + ( sig3 * freq  * rrand(0.01,1/2) )) 
	};
	env3 = EnvGen.kr(Env([1,4,1],[3.1,3.8]), 1);
	sig3 = RLPF.ar(sig3, ( \sig3lpfr.kr(1.1) * freq * env3 ).clip(20,20000), \sig3rq.kr(0.5));

	sig = sig * EnvGen.kr(Env([0,1,0],[1.01,0.3]), 1);
	sig2 = sig2 * EnvGen.kr(\sig2adsr.kr(Env.dadsr(0.1,1.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig3 = sig3 * EnvGen.kr(\sig3adsr.kr(Env.dadsr(0.3,4.1,0.1,0.8,4.1,1,-1)), gate, doneAction:2);
	//sig2 = 0;
	sig = [sig, sig2, sig3].sum;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,2.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \pilefm,
			\note, Pseq([
				[0,3,7],
				[0,3,7]+3,
				[0,3,7]+2,
				[0,3,7]+1,
			],inf),
			\octave, 5,
			\dur, 4,
			\amp, 0.1,
		),
		
	])
)).play;
);
