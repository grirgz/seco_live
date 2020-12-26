
(
~t = 190/4/60; TempoClock.default.tempo = ~t;
~master = {
	ProtoDef(\FxManager).play;
};
~master.();

BusDef(\bus0,\audio);
BusDef(\bus1,\audio);
BusDef(\bus2,\audio);
BusDef(\bus3,\audio);
);

(
SynthDef(\fmbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var freqenv = EnvGen.kr(Env([210,90,81],[0.051,0.1]), 1);
	var fmfreq = freq * ( SinOsc.ar(XLine.kr(1,freq,4)) * XLine.kr(0.01,1,2) + 1 );
	var fmampenv = EnvGen.kr(Env([0,0.1,1,0],[0.1,0.1,2.8]), 1) * \fmampenvamt.kr(1) + 1;
	sig = SinOsc.ar(freqenv * ( SinOsc.ar(fmfreq * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1409].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,1,0,
				0,0,1,0, 0,0,0,0,
				1,0,1,0, 0,0,1,0,
				0,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1817].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \bilin,
			\note, Pseq([
				Plazy({ arg ev;
					var tabs = { (0..19).scramble.keep(3) }!4;
					var tabs2 = { (0..19).scramble.keep(2) }!4;
					Pseq([
						tabs[0]++tabs2[0],
						tabs[0]++tabs2[1],
						tabs[1]++tabs2[0],
					],8)
				}).loop,
			],inf),
			\fspread, 0.002,
			\dur, Pseq([1/3,1/4,1/4,1/3,1/3,1/4,1/4],inf),
			\dur, Pseq([
				Pseq([1/3,2/4,( 2/4 )+( 2/3 )],1),
				Pseq([1/3,1/4,( 3/4 )+( 2/3 )],1),
			],inf),
			\amp, 0.1/6,
		),
		Pbind(
			\instrument, \fmbass,
			\note, Pstep(Pseq([
				0,0,0,11,
			],inf),1/2),
			\octave,4,
			\epsilon, ~pmodenv.(Pseq([0.0001,0.07],1), 8).loop,
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				2,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.1/2,
		),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[1409].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[5].value,
			\isRest, Pseq([
				1,0,1,0, 0,0,0,0,
				0,0,1,0, 0,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[657].value,
			\isRest, Pseq([
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				1,0.3,
				0.91,0.3,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1817].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\bufnum, ~buflib.snare[1017].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,1,
				0,1,0,1, 1,0,0,0,
				0,0,0,0, 1,0,0,1,
				0,1,0,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\velo, Pseq([
				1,1,1,1, 2,1,1,1,
			]/2,inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\sustain, 0.1 * Pkey(\velo),
			\gain, 0.41 * Pkey(\velo),
		),
		//Pdef(\fmbass2, Pbind(\instrument, \fmbass2)) <>
		Pbind(
			\instrument, \default,
			\freq, 200,
			\note, Pseq([
				[0,4,6,9],
			],inf),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\reverb, \audio),
		),
		Pbind(
			\instrument, \fmbass2,
			\note, Pstep(Pseq([
				0,0,0,1,
				4,3,2,1,
			],inf),1/2),
			\octave,4,
			\epsilon, ~pmodenv.(Pseq([0.0001,0.007],1), 8).loop,
			\legato, Pseq([
				14,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,1,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\fmampenvamt, 1,
			\wavemix, ~pmodenv.(Pwhite(0,0.0,inf), Pwhite(1.0,4)).loop,
			\wavemix, 0,
			\lpfr, ~pmodenv.(Pseq([1,2.4],1), 8).loop,
			\freqmix, ~pmodenv.(Pwhite(0,1.0,inf), Pwhite(1.0,4)).loop,
			\fmfreqmix, ~pmodenv.(Pwhite(0,1.0,inf), Pwhite(1.0,4)).loop,
			\amp, 0.1/2,
			\isRest, true,
		),
		
	])
)).play;
);
Splay

Pdef(\fmbass2).edit

(
SynthDef(\fmbass2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var freqenv = EnvGen.kr(Env([10,freq,freq],[0.001,0.1]), 1);
	var fmfreq;
	var fmampenv;
	var freqtab, fmfreqtab;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freqtab = [1/2,1,2];
	fmfreqtab = [1/2,1,2];
	fmfreq = EnvGen.kr(Env([freq,freq,freq],[0.051,4.1]), 1);
	fmampenv = EnvGen.kr(Env([0,2.1,1,0],[0.01,3.01,0.1]), 1) * \fmampenvamt.kr(4) + 1;
	sig1 = SinOsc.ar(freqenv * freqtab * ( SinOsc.ar(fmfreq * [ fmfreqtab ] * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig2 = LFPulse.ar(freqenv * freqtab * ( LFPulse.ar(fmfreq * [ fmfreqtab ] * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig2 = RLPF.ar(sig2, \lpfr.kr(1.1) * freq, \rq.kr(0.5)) * 1.4;
	sig3 = LFSaw.ar(freqenv * freqtab * ( LFSaw.ar(fmfreq * [ fmfreqtab ] * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 ));
	sig3 = RLPF.ar(sig3, \lpfr.kr(1.1) * freq, \rq.kr(0.5)) * 1.4;
	sig = SelectXFocus.ar(\wavemix.kr(0.0)*2, [sig1, sig2, sig3], \wavefocus.kr(1), true);
	sig = SelectXFocus.ar(\freqmix.kr(0.5)*2, sig, \freqfocus.kr(1), true);
	sig = SelectXFocus.ar(\fmfreqmix.kr(0.5)*2, sig, \fmfreqfocus.kr(1), true);
	sig.debug("sig");
	sig = sig * 2;
	//sig = sig + ( SinOsc.ar(freqenv * 1/2 * ( LFPulse.ar(fmfreq * 1/2 * [1,1+\epsilon.kr(0.01)]) * fmampenv * \fmamp.kr(1) + 1 )) * 0.5 );
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}, metadata:(specs:(
	wavemix: \unipolar,
	freqmix: \unipolar,
	fmfreqmix: \unipolar,
))).add;
);


(
SynthDef(\tump, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = FSinOsc.ar(freq* (1..8) * [ [1,3/2] ]) * (LFNoise1.kr(6!8!2) * ( 1/( (1..8)+1 ) ) * 0.8).max(0);
	sig = sig.mean;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.3,0.1,0.8,0.1)), gate, doneAction:2);
	//sig = Pan2.ar(sig, pan, amp).mean;
	sig = sig * amp;
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
Pdef(\demo, 
	Pbind(
		\instrument, \tump,
		\degree, Pseq([0],inf),
		\freq, 70,
		\legato,20,
		\dur, Pwhite(1.2,2),
		\amp, 1.8,
	)
).play;
);

(
Pdef(\zed, 
	Pbind(
		\instrument, \tump,
		\degree, Pseq([0],inf),
		\freq, 70,
		\legato,20,
		\dur, Pwhite(1.2,2)*10,
		\amp, 1.8,
	)
).play;
);
(
Pdef(\zed, 
	Pbind(
		\instrument, \Tumbling,
		\degree, Pseq([0],inf),
		\freq, 70,
		\legato,20,
		\dur, Pwhite(1.2,2)*10,
		\amp, 1.8,
	)
).play;
);
