

(
SynthDef(\ringchord, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freqs;
	//env1 = EnvGen.kr(Env([1,200,400],[0.1,1.8]), 1);
	sig = 1;
	freqs = ( freq * \chordtab.kr([0,4,7,7-12]).midiratio );
	freqs.do { arg cfreq, idx;
		sig = sig * ( SinOsc.ar(cfreq + ( [1,-1] * \fspread.kr(0.081) ) * ( SinOsc.ar(cfreq * \fmr.kr(1) + ( [1,-1] * \fmfspread.kr(0.081))) * \fma.kr(0.7) + 1 )) * \ama.kr(3.1) + 1 );
	};

	sig1 = Ringz.ar(sig, freqs, \ringzdecay.kr(0.21)).mean * \ringzgain.kr(1/10);
	sig = SelectX.ar(\ringzmix.kr(1.0), [sig, sig1]);

	sig1 = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.1));
	sig = SelectX.ar(\lpmix.kr(0.5), [sig, sig1]);

	sig = sig * \gain.kr(1);

	sig = Limiter.ar(sig);

	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,1,0.61)), gate, doneAction:2);
	sig.debug("sig");
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);

(
SynthDef(\ringbass, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num = 7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var freqs;
	//env1 = EnvGen.kr(Env([1,200,400],[0.1,1.8]), 1);
	sig = 1;
	freqs = ( freq * ((0..7)/7 - 0.5 * \fspread.kr(0.0052) + 1));
	freqs.do { arg cfreq, idx;
		sig = sig * ( SinOsc.ar(cfreq * ( SinOsc.ar(cfreq * \fmr.kr(1)) * \fma.kr(0.3) + 1 )) * \ama.kr(0.7) + 1 );
	};

	//sig1 = Ringz.ar(sig, freq * \ringzfratio.kr(1), \ringzdecay.kr(0.04)) * \ringzgain.kr(1);
	sig1 = Resonz.ar(sig, freq * \ringzfratio.kr(1), 0.9) * \ringzgain.kr(1);
	sig = SelectX.ar(\ringzmix.kr(0), [sig, sig1]);

	sig1 = RLPF.ar(sig, ( \lpfr.kr(4.1) * freq ).clip(20,20000), \rq.kr(0.1));
	sig = SelectX.ar(\lpmix.kr(1), [sig, sig1]);

	sig = HPF.ar(sig, \hpf.kr(30));

	sig = sig * \gain.kr(1);

	sig = Limiter.ar(sig, dur:0.01);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.5)), gate, doneAction:2);
	sig.debug("sig");
	//sig = Pan2.ar(sig, pan, amp);
	sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig.debug("sig");
	Out.ar(out, sig);
}).add;
);


(
SynthDef(\ringdraft, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var num = 7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(Env([1,200,400],[0.1,1.8]), 1);
	//sig = ( SinOsc.ar(freq) * 1 + 1 );
	//sig = sig * ( SinOsc.ar(freq+1) * 1 + 1 );
	sig = 1;
	//num.do { arg idx;
		//sig = sig * ( SinOsc.ar(freq+(idx*env1)) * 0.51 + 1 ) / 1.1 ;
	//};
	( freq * \chordtab.kr([0,4,7,7-12]).midiratio ).do { arg cfreq, idx;
		sig = sig * ( SinOsc.ar(cfreq) * 0.5 + 1 );
	};
	//sig = sig / 2 ;
	sig = sig * 10;
	sig = Limiter.ar(sig);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq, \rq.kr(0.1));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,1,0.01)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \ringbass,
			\fmr, 1.01,
			\fma, ~pmodenv.(Pseq([2,0,1],1), 8).loop,
			\ama, ~pmodenv.(Pseq([1,0.5,1],1), 3).loop,
			\ringzgain, 1/1,
			\ringzdecay, 0.11,
			\lpmix, 1,
			\lpfr, 4,
			\octave, 3,
			\note, Pseq([
				0,3,2,1,
			],inf),
			\dur, 2,
			\amp, 0.2,
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \ringbass,
			\fmr, 2.01,
			\fma, ~pmodenv.(Pseq([2,0,1],1), 8).loop,
			\ama, ~pmodenv.(Pseq([1,0.5,1],1), 3).loop,
			\ringzgain, 1/1,
			\ringzdecay, 0.11,
			\lpmix, 1,
			\lpfr, 4,
			\octave, 3,
			\note, Pstep(Pseq([
				4,3,
			],inf),4),
			\dur, 4,
			\amp, 0.1,
		),
		
		Pbind(
			\instrument, \ringchord,
			\dur, 1/2,
			\legato, 7,
			\ama, Pstep( Pseq([
				3,0.7,
			],inf), 4),
			\fma, Pstep( Pseq([
				1,0.3,
			],inf), 4),
			\fmr, Pseq([
				1,2,1/2,
			],inf),
			\chordtab, Pstep(Pseq([
				[ [0,4,7,7-12] ],
				[ [0,3,7,7-12] ],
				[ [0,4,7,0+12] ],
				[ [0,3,7,3-12] ],
			],inf), 4),
			\octave, 5,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\amp, 0.1,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \whitenoise,
			\dur, 1/2,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\amp, 0.3,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		
		Pbind(
			\instrument, \whitenoise,
			\dur, 1/2,
			\note, Pseq([
				0,10,4,3,
			],inf),
			\amp, 0.1,
		),
	])
)).play;
);
