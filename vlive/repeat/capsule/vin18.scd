
~t = 135/4/60; TempoClock.default.tempo = ~t;
~swing = 0.43;


(
SynthDef(\bassco, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * ( LFSaw.ar(freq+1.01) * 0.1 + 1 ));
	sig = RLPF.ar(sig, \lpfr.kr(4.1) * freq, \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\sonar, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = WhiteNoise.ar(1!2);
	sig = BPF.ar(sig, freq, \rq.kr(0.1));
	sig = BPF.ar(sig, freq, \rq.kr);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\sonar2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1=  EnvGen.kr(\env.kr(Env([2,0.02,1.01,0.02],[0.01,0.08,0.1].normalizeSum)), gate, timeScale:1);
	env2 = EnvGen.kr(\adsrf.kr(Env.adsr(0.01,0.1,0.8,1.1)), gate, doneAction:0);
	env3 = EnvGen.kr(\adsrfrq.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	sig = WhiteNoise.ar(1!2);
	sig = CombL.ar(sig, 1/50, 1/freq,0.501 * env1);
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env2 * \feamt.kr(0.5) + 1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = sig * amp;
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
	// from vin16
SynthDef(\bouly, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	sig = SinOsc.ar(freq) * env1;
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env2 * 0.5 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bouly2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	sig1 = LFSaw.ar(freq);
	sig2 = LFPulse.ar(freq);
	sig3 = SinOsc.ar(freq);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3] * env1);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env2 * 0.5 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bouly2harm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freqs = freq * \harms.kr([1,11/8,13/16,17/16]);
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	sig1 = LFSaw.ar(freqs);
	sig2 = LFPulse.ar(freqs);
	sig3 = SinOsc.ar(freqs);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3].collect({ arg x; (x * \harmamp.kr([1,0.07,0.1,0.1])).mean }) * env1);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env2 * 0.5 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\bouly3, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freqs = freq * ((0..7)/7 - 0.5 * \fspread.kr(0.1) + 1);
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	sig1 = LFSaw.ar(freqs);
	sig2 = LFPulse.ar(freqs);
	sig3 = SinOsc.ar(freqs);
	sig = SelectX.ar(\oscmix.kr(0.5)*2, [sig1, sig2, sig3] * env1);
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env2 * 0.5 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	pan = pan + LFNoise1.kr(\panfreq.kr(1)!sig.size);
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;

SynthDef(\boulyharm, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fratio;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	fratio = freq/2 * [1,2,3,4,5,6];
	sig = (SinOsc.ar(fratio) * [0.51,1,0.2, 0.61,0.1,0.3] * 0.8).mean * env1;
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env2 * 0.5 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\boulyharm2, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var fratio;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env2 = EnvGen.ar(\env2.kr(Env([0,1,0],[1.001,1.08])), Impulse.ar(\imp2f.kr(1/4)));
	env1 = EnvGen.ar(\env1.kr(Env([0,1,0],[0.001,0.08])), Impulse.ar(\imp1f.kr(100) * env2));
	fratio = freq/2 * [1,2,3,4,5,6] * \harmtab.kr([1,1,1, 1,1,1]);
	sig = (SinOsc.ar(fratio) * LFNoise1.ar(Rand(0.3,4)!6).range(0,1) * 0.8).mean * env1;
	sig = RLPF.ar(sig, \lpfr.kr(5.1) * freq * (env2 * 0.5 +1), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, 1,
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);

(
//calm
Pdef(\part, Pdef(\break1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.04,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, 0.51,
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);

(

//calm
Pdef(\part, Pdef(\break1b, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin18_t0_200329_203022').buffer,
			\pos, 0/~t,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				4,0,0,0, 0,0,2,0,
				4,0,0,0, 0,0,0,0,
				3,0,0,1, 0,0,0,1,
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin18_t0_200329_203022').buffer,
			\pos, 1/~t,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 2,0,0,1,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 3,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.04,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, 0.51,
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly3,
			\fspread, ~pmodenv.(Pseq([0.001,0.02,0.01,0.1,0.004],inf), 4.3),
			\panfreq, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-3,3,0,0,1],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([5,6,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\isRest, Pstep(Pseq([0,0,0,0, 0,0,1,1],inf),1).coin.not,
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bouly3,
			\fspread, ~pmodenv.(Pseq([0.001,0.12,0.01,0.1,0.004],inf), 3),
			\panfreq, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-3,3,0,0,1],inf)),
			],inf),
			\legato, 1,
			\isRest, Pstep(Pseq([0,1,0,1, 0,1,0,1],inf),1).coin.not,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);

(
	// calm complex
Pdef(\part, Pdef(\break2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.04,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[705].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1/2,1/2,1/2,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,1,1,
			]/2,inf).coin.not,
			\sustain, 2,
			\lag, 0.04,
			\dur, 1/8,
			\gain, 0.11 * Pseg(Pseq([1,0],inf),1),
		),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
				[ Env.adsr(0.1,0.1,0.2,2.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\imp1f, Pwhite(100,0.0100,inf),
			\imp1f, Ptuple(Pwhite(0.01,140,inf)!4),
			\imp2f, Ptuple(Pwhite(1,40,inf)!4),
			\env2, Prand([
				[Env([0.1,1,0],[1.001,1.08])],
				[Env([0.1,1,0],[1.001,1.08]/5)],
				[Env([1,0.01,0],[1.001,1.08])],
				[Env([1,0.01,0],[1.001,1.08]/6)],
			],inf),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato,Ptuple(Pwhite(0.1,0.8)!4),
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bouly,
			\adsr, Prand([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
				[ Env.adsr(0.01,0.1,0.8,3.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			]/2.1,inf).coin.not,
			\octave, 7,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),

		
	])
)).play;
);

(
	// calm complex2
Pdef(\part, Pdef(\break2b, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.04,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[705].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,1/2,1/2,1/2,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,1,1,
			]/2,inf).coin.not,
			\sustain, 2,
			\lag, 0.04,
			\dur, 1/8,
			\gain, 0.11 * Pseg(Pseq([1,0],inf),1),
		),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
				[ Env.adsr(0.1,0.1,0.2,2.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\imp1f, Pwhite(100,0.0100,inf),
			\imp1f, Ptuple(Pwhite(0.01,140,inf)!4),
			\imp2f, Ptuple(Pwhite(1,40,inf)!4),
			\env2, Prand([
				[Env([0.1,1,0],[1.001,1.08])],
				[Env([0.1,1,0],[1.001,1.08]/5)],
				[Env([1,0.01,0],[1.001,1.08])],
				[Env([1,0.01,0],[1.001,1.08]/6)],
			],inf),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato,Ptuple(Pwhite(0.1,0.8)!4),
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bouly,
			\adsr, Prand([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
				[ Env.adsr(0.01,0.1,0.8,3.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\isRest, Pseq([
				1,1,1,1, 1,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			]/2.1,inf).coin.not,
			\octave, 7,
			\dur, 1/8,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly2,
			\adsr, Prand([
				[ Env.adsr(0.01,0.8,0.4,1.1) ],
				[ Env.adsr(0.1,0.8,0.8,0.1) ],
				[ Env.adsr(0.01,0.8,0.8,0.5) ],
			],inf),
			\env1, Prand([
				[ Env([0,1,0],[0.1,0.8]) ],
				[ Env([0,1,0],[0.1,0.08]) ],
				[ Env([0,1,0],[0.01,0.08]) ],
			],inf),
			\imp1f, Pwhite(0.01,140,inf),
			\imp2f, Pwhite(1,40,inf),
			\note, Pseq([
				//4,4,4,3,3,3,1,1,
				4,3,3,1,1,4,3,1,
			],inf),
			\isRest, Pseq([
				//1,0,0,1, 0,0,1,0,
				1,1,0,1, 0,1,1,1,
				1,1,0,1, 0,1,1,1,
				1,1,0,1, 0,1,1,1,
				1,1,0,1, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1 * Pswitch1( Pseg(Pwhite(0.01,1),Pwhite(1.0,7))!8, Pseq((0..7),inf) ),
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\lag, 0.04,
		) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[336].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[55].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[56].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,1,0, 0,1,0,1,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\bufnum, ~buflib.clap[67].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1094].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, 0.51,
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);


(
Pdef(\part, Pdef(\part2, 
	Ppar([
		Pbind(
			\lag, 0.04,
		) <>
		Ppar([
			Pbind(
				\instrument, \bassco,
				\note, Pseq([
					0,1,0,3,
				],inf).stutter(8),
				\legato, Pseq([
					1,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,0,1,
					1,0,0,2, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\distfac,100,
				\distmix, 1,
				\lpfr, 4.3,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[336].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[55].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[56].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					Pseq([
						1,1,0,1, 0,0,1,1,
					],1)/2,
					0,0,0,0, 0,0,0,0,
					0,1,1,0, 0,1,0,1,
				]/2,inf).coin.not,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\bufnum, ~buflib.clap[67].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1004].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					1,0,1,1, 0,0,1,0,
					1,1,1,0, 0,0,1,1,
					0,0,1,1, 1,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*Pseg(Pseq([1,0.1,2],inf),2) * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1094].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*0.5 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
		]),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.7) ],
				[ Env.adsr(0.1,0.1,0.8,2.7) ],
				[ Env.adsr(1.1,0.1,0.8,2.7) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, Pwhite(0.1,1,inf),
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\oscmix, ~pmodenv.(Pwhite(0.0,1,inf), Pwhite(0.1,7.0,inf)),
			\lpfr, ~pmodenv.(Pseq([1/3,1/4,2,1/4,1,1/2,4],inf), 4),
			\rq, ~pmodenv.(Pseq([1/3,1,1/2,1,1/4],inf), 3),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.5,0.5,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Pseq([
				1,3,1,1,
				1,2,1,6,
				1,1,3,4,
				1,2,1,6,
			],inf), 1/2),
			\amp, 0.1 * Pseg(Pwhite(0.0,1,inf),1),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \boulyharm,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\oscmix, ~pmodenv.(Pwhite(0.0,1,inf), Pwhite(0.1,7.0,inf)),
			\lpfr, ~pmodenv.(Pseq([1/4,2,1/4,1,1/2,4],inf), 4),
			\rq, ~pmodenv.(Pseq([1,1/2,1,1/4],inf), 3),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Pseq([
				2,2,1,2,
				1,3,1,1,
				1,2,1,6,
				1,1,3,4,
			],inf), 1/2),
			\amp, 0.1,
			\amp, 0.1 * Pseg(Pwhite(0.0,1,inf),1),
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\part3, 
	Ppar([
		Pbind(
			\lag, 0.04,
		) <>
		Ppar([
			Pbind(
				\instrument, \bassco,
				\note, Pseq([
					0,1,0,3,
				],inf).stutter(8),
				\legato, Pseq([
					0,0,0,0, 0,0,0,0,
					6.7,0,0,0, 0,0,0,1,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\distfac,100,
				\distmix, 1,
				\lpfr, 4.3,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[336].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[55].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0.5,0.5,0.5, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[56].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0.5,0,0,0.5,
				]/2,inf).coin.not,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\bufnum, ~buflib.clap[67].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1004].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					1,0,1,1, 0,0,1,0,
					1,1,1,0, 0,0,1,1,
					0,0,1,1, 1,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*Pseg(Pseq([1,0.1,2],inf),2) * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1094].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*0.5 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
		]),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.7) ],
				[ Env.adsr(0.01,0.1,0.8,0.07) ],
				[ Env.adsr(0.21,0.1,0.8,0.07) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						[0,3,7,13],
						[0,3,7-12,12]+6,
						[0,3-12,7,13],
						[0,3,7-12,3+12]+1,
					].collect(_.scramble),1);
				}).loop,
			],inf).stutter(4),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\strum, 0.3,
			\legato, Pkey(\legato) * Pwhite(0.9,1.1,inf),
			\dur, 1/8,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly2,
			\oscmix, ~pmodenv.(Pseq([0,1],inf), 4),
			\lpfr, ~pmodenv.(Pseq([0.8,2],inf), 4),
			\rq, ~pmodenv.(Pseq([1/3,1,1/2,1,1/4],inf), 0.2),
			\octave, Pwrand([6,5,4], [0.5,0.5,0.1],inf).stutter(Pwhite(1,7,inf)),
			\freq, ~pmodenv.(Pseq([100,2000],inf), 4),
			\dur, 1/16,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 8,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bouly2,
			\oscmix, ~pmodenv.(Pwhite(0.0,1,inf), Pwhite(0.1,7.0,inf)),
			\lpfr, ~pmodenv.(Pseq([1,1/2,2,1/4,1,1/2,4],inf), 1.4),
			\rq, ~pmodenv.(Pseq([1/3,1,1/2,1,1/4],inf), 3.2),
			\octave, Pwrand([6,5,4], [0.5,0.5,0.1],inf).stutter(Pwhite(1,7,inf)),
			\note, Pseq([
				1,3,4,6,
				6,4,3,6,
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \boulyharm,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\oscmix, ~pmodenv.(Pwhite(0.0,1,inf), Pwhite(0.1,7.0,inf)),
			\lpfr, ~pmodenv.(Pseq([1/4,2,1/4,1,1/2,4],inf), 4),
			\rq, ~pmodenv.(Pseq([1,1/2,1,1/4],inf), 3),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\isRest, Pstutter(
				Pseq([
					2,2,1,2,
					1,3,1,1,
					1,2,1,6,
					1,1,3,4,
				],inf),
				Pseq([
					0,0,0,1,
				],inf),
			).coin.not,
			\dur, PdurStutter(Pseq([
				2,2,1,2,
				1,3,1,1,
				1,2,1,6,
				1,1,3,4,
			],inf), 1/2),
			\amp, 0.1,
			\amp, 0.1 * Pseg(Pwhite(0.0,1,inf),1),
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\part4, 
	Ppar([
		Pbind(
			\lag, 0.04,
		) <>
		Ppar([
			Pbind(
				\instrument, \bassco,
				\note, Pseq([
					0,1,0,3,
				],inf).stutter(8),
				\legato, Pseq([

					6.7,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,0,0,
					0,0,2,0, 0,0,0,0,
					0,0,0,0, 0,0,2,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\distfac,100,
				\distmix, 1,
				\lpfr, 4.3,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[336].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,0,1, 0,0,1,0,
					0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[55].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0.5,0.5,0.5, 0,0,0,0,
				],inf).coin.not,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[56].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0.5,0,0,0.5,
				]/2,inf).coin.not,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\bufnum, ~buflib.clap[67].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1004].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					1,1,0,1, 1,0,1,1, 0,1,1,1, 1,1,0,1,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing*Pseg(Pseq([1,0.1,2],inf),2) * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1094].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*0.5 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
		]),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.7) ],
				[ Env.adsr(0.01,0.1,0.8,0.07) ],
				[ Env.adsr(0.21,0.1,0.8,0.07) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				Plazy({ arg ev;
					Pseq([
						[0,3,7,13],
						[0,3,7-12,12]+6,
						[0,3-12,7,13],
						[0,3,7-12,3+12]+1,
					].collect(_.scramble),1);
				}).loop,
			],inf).stutter(4),
			\legato, Pseq([
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			//\strum, 0.3,
			\legato, Pkey(\legato) * Pwhite(0.9,1.1,inf),
			\dur, 1/8,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind( // ramp
			\instrument, \bouly2,
			\oscmix, ~pmodenv.(Pseq([0,1],inf), 4),
			\lpfr, ~pmodenv.(Pseq([0.8,2],inf), 4),
			\rq, ~pmodenv.(Pseq([1/3,1,1/2,1,1/4],inf), 0.2),
			\octave, Pwrand([6,5,4], [0.5,0.5,0.1],inf).stutter(Pwhite(1,7,inf)),
			\freq, ~pmodenv.(Pseq([100,2000],inf), 4),
			\dur, 1/16,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				16,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \bouly2,
			\oscmix, ~pmodenv.(Pwhite(0.0,1,inf), Pwhite(0.1,7.0,inf)),
			\lpfr, ~pmodenv.(Pseq([1,1/2,2,1/4,1,1/2,4],inf), 1.4),
			\rq, ~pmodenv.(Pseq([1/3,1,1/2,1,1/4],inf), 3.2),
			\octave, Pwrand([6,5,4], [0.5,0.5,0.1],inf).stutter(Pwhite(1,7,inf)),
			\note, Pseq([
				1,3,4,6,
				6,4,3,6,
			],inf),
			\legato, Pseq([
				0,0,0,0, 0,0,2,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		),
		Pbind(
			\instrument, \boulyharm,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\oscmix, ~pmodenv.(Pwhite(0.0,1,inf), Pwhite(0.1,7.0,inf)),
			\lpfr, ~pmodenv.(Pseq([1/4,2,1/4,1,1/2,4],inf), 4),
			\rq, ~pmodenv.(Pseq([1,1/2,1,1/4],inf), 3),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\isRest, Pstutter(
				Pseq([
					2,2,1,2,
					1,3,1,1,
					1,2,1,6,
					1,1,3,4,
				],inf),
				Pseq([
					0,0,0,1,
				],inf),
			).coin.not,
			\dur, PdurStutter(Pseq([
				2,2,1,2,
				1,3,1,1,
				1,2,1,6,
				1,1,3,4,
			],inf), 1/2),
			\amp, 0.1,
			\amp, 0.1 * Pseg(Pwhite(0.0,1,inf),1),
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\part5, 
	Ppar([
		Pbind(
			\lag, 0.04,
		) <>
		Ppar([
			Pbind(
				\instrument, \bassco,
				\note, Pseq([
					0,1,0,3,
				],inf).stutter(8),
				\legato, Pseq([
					1,0,0,0, 0,0,0,0,
					4,0,0,0, 0,0,0,1,
					1,0,0,2, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\distfac,100,
				\distmix, 1,
				\lpfr, 4.3,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[336].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[55].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,1,0, 0,1,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[56].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					Pseq([
						1,1,0,1, 0,0,1,1,
					],1)/2,
					0,0,0,0, 0,0,0,0,
					0,1,1,0, 0,1,0,1,
				]/2,inf).coin.not,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[67].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1004].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					1,0,1,1, 0,0,1,0,
					1,1,1,0, 0,0,1,1,
					0,0,1,1, 1,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*Pseg(Pseq([1,0.1,2],inf),2) * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[1094].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*0.5 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
		]),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.7) ],
				[ Env.adsr(0.1,0.1,0.8,2.7) ],
				[ Env.adsr(1.1,0.1,0.8,2.7) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, Pwhite(0.1,1,inf),
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly2,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\oscmix, ~pmodenv.(Pwhite(0.0,1,inf), Pwhite(0.1,7.0,inf)),
			\lpfr, ~pmodenv.(Pseq([1/3,1/4,2,1/4,1,1/2,4],inf), 4),
			\rq, ~pmodenv.(Pseq([1/3,1,1/2,1,1/4],inf), 3),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.5,0.5,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Pseq([
				1,3,1,1,
				1,2,1,6,
				1,1,3,4,
				1,2,1,6,
			],inf), 1/2),
			\amp, 0.1 * Pseg(Pwhite(0.0,1,inf),1),
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \boulyharm,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\oscmix, ~pmodenv.(Pwhite(0.0,1,inf), Pwhite(0.1,7.0,inf)),
			\lpfr, ~pmodenv.(Pseq([1/4,2,1/4,1,1/2,4],inf), 4),
			\rq, ~pmodenv.(Pseq([1,1/2,1,1/4],inf), 3),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Pseq([
				2,2,1,2,
				1,3,1,1,
				1,2,1,6,
				1,1,3,4,
			],inf), 1/2),
			\amp, 0.1,
			\amp, 0.1 * Pseg(Pwhite(0.0,1,inf),1),
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);

(

// dust drums
Pdef(\part, Pdef(\part6, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin18_t0_200329_203022').buffer,
			\pos, 0/~t,
			\legato, Pseq([
				4,0,0,0, 0,0,2,0,
				4,0,0,0, 0,0,0,0,
				3,0,0,1, 0,0,0,1,
				4,0,0,0, 0,0,0,0,

				3,0,0,3, 0,0,3,0,
				0,0,0,0, 0,0,0,0,
				3,0,0,1, 0,0,0,1,
				4,0,0,0, 0,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, SampleTimeline('rec_vin18_t0_200329_203022').buffer,
			\pos, 1/~t,
			\legato, Pseq([
				0,0,0,0, 2,0,0,1,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 3,0,0,0,
				0,0,0,0, 4,0,0,0,

				0,0,0,0, 0,0,0,0,
				0,1,0,1, 2,0,2,0,
				0,0,0,0, 4,0,0,0,
				0,0,0,0, 4,0,0,0,
			],inf),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\gain, 1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,1,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.04,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\imp1f, ~pmodenv.(Pseq([441,2,1,44],inf), 1),
			\imp2f, 4.1,
			\env2, Prand([
				[Env([0.1,1,0],[1.001,1.08])],
				[Env([0.1,1,0],[1.001,1.08]/5)],
			],inf),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, 0.51,
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \boulyharm2,
			\fspread, ~pmodenv.(Pseq([0.001,0.02,0.01,0.1,0.004],inf), 4.3),
			\panfreq, 0.1,
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\imp1f, ~pmodenv.(Pseq([1,44,40,40],inf), 1),
			\imp2f, 40.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-3,3,0,0,1],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([5,6,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\isRest, Pstep(Pseq([
				0,1,0,0,
			],inf),1/2).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pbind(
			\instrument, \bouly3,
			\fspread, ~pmodenv.(Pseq([0.001,0.12,0.01,0.1,0.004],inf), 3),
			\panfreq, 0.1,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-3,3,0,0,1],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\isRest, Pstep(Pseq([0,0,0,1],inf),1/2).coin.not,
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\parttrans1, 
	Ppar([
		Pbind(
			\lag, 0.04,
		) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[336].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,0,1,0, 1,0,1,0,
					1,1,0,0, 0,0,0,1,
					1,0,0,1, 0,0,1,0,
					1,0,0,0, 0,0,0,0,
				],1).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, BufDef('~/Musique/sc/reckit/rev/clap1.wav'),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\pos, 0,
				\lag,0.1,
				\dur, 1,
				\gain, 1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1094].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,

					0,0,0,0, 0,0,0,0,
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
					1,0,0,0, 0,0,0,1,
				],1).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*0.5 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[55].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0,
				],1).coin.not,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\bufnum, ~buflib.clap[67].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
					0,0,0,0, 1,0,0,0,
				],1).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
		]),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Prand([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,0.7) ],
				[ Env.adsr(0.1,0.1,0.8,2.7) ],
				[ Env.adsr(1.1,0.1,0.8,2.7) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, Pseq([
				Pseq([
					8,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
				],2),
				8,0,0,0, 0,0,0,0,
				0,0,0,0, 4,0,0,0,
				4,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],1),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\dur, 1/8,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),

		
	])
)).play;
);

(
Pdef(\part, Pdef(\partseq1, 
	Ppar([
		Pseq([
			Pfindur(8,Pdef(\break1b)),
			Pfindur(2,Pdef(\parttrans3)),
			Pfindur(3*8,Pdef(\part6)),
			Pfindur(3*8,Pdef(\part2)),
			Pfindur(8,Pdef(\parttrans1)),
			Pfindur(3*8,Pdef(\part3)),
		],2),
	])
)).play;
);

(
Pdef(\part, Pdef(\parttrans3, 
	Ppar([
			Pbind(
				\instrument, \playersec_looper,
				\bufnum, ~buflib.kick[336].value,
				\trigfreq, ~pmodenv.(Pseq([1,200,1,4],inf), 4),
				\legato, 2,
				\isRest, Pseq([
					1,1,1,1, 1,1,1,1,
					1,1,1,1, 1,1,1,1,
				],1).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
				\out, BusDef(\fxbus1, \audio),
			),
			Pmono(\fx_tapeslow,
				\addAction, \addToTail,
				\lag, 0.0005,
				\inbus, BusDef(\fxbus1, \audio),
				\mix, Pseq([0,1,1,1,1,1,1],inf),
				\env, Pseq([
					[ Env([1, 1,0.4,0.4,0.4], [0, 1,1,1]) ],
				],inf),
				\dur, 1/2,
			),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
				[ Env.adsr(0.1,0.1,0.8,2.1) ],
				[ Env.adsr(0.1,0.1,0.2,2.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2,1,4],inf), 8),
			\imp1f, ~pmodenv.(Pseq([1,2,1,44],inf), 1),
			\imp2f, 4.1,
			\env2, Prand([
				[Env([0.1,1,0],[1.001,1.08]/5)],
			],inf),
			\oscmix, ~pmodenv.(Pseq([0,1],inf), 4),
			\lpfr, ~pmodenv.(Pseq([0.8,2],inf), 4),
			\rq, ~pmodenv.(Pseq([1/3,1,1/2,1,1/4],inf), 0.2),
			\octave, Pwrand([6,5,4], [0.5,0.5,0.1],inf).stutter(Pwhite(1,7,inf)),
			\freq, ~pmodenv.(Pseq([100,2000],inf), 4),
			\dur, 1/16,
			\legato, Pseq([
				0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
				16,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0,
			],1),
			\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
			\out, BusDef(\sendbus2, \audio),
			\amp, 0.1,
		),
			Pbind(
				\instrument, \boulyharm2,
				\adsr, Prand([
					[ Env.adsr(0.1,0.1,0.8,0.1) ],
					[ Env.adsr(0.1,0.1,0.8,0.7) ],
					[ Env.adsr(0.1,0.1,0.8,2.7) ],
					[ Env.adsr(1.1,0.1,0.8,2.7) ],
				],inf),
				\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
				\lpfr, ~pmodenv.(Pseq([1/1.3,2,1,4],inf), 4),
				\note, Pseq([
					[0,3,7,13],
					[0,3,7-12,12]+6,
					//[0,3-12,7,13],
					//[0,3,7-12,3+12]+1,
				],inf),
				\legato, Pseq([
					32
				],1),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\dur, 1/8,
				\amp, 0.4,
				\out, BusDef(\sendbus1, \audio),
			),
		
	])
)).play;
);


(
Pdef(\part, Pdef(\intro, 
	Ppar([
		Pbind(
			\instrument, \bouly2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,4.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,2],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[3+12]+1,
			],1),
			\legato, 1,
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\lpfr, ~pmodenv.(Pseq([1/4,1],inf), 8),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.1,
			\out, BusDef(\sendbus2, \audio),
		),
		Pseq([
			Event.silent(7),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1094].value,
				\isRest, Pseq([
					0,0,1,0, 1,1,0,1,
				],1).coin.not,
				\dur, 1/8,
				\gain, 0.31,
			),
		],inf),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\part1, 
	Ppar([
		Pbind(
			\lag, 0.04,
		) <>
		Ppar([
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[336].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[55].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					1,1,0,0, 1,0,1,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[56].value,
				\isRest, Pseq([
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,
					0,1,1,0, 0,1,0,1,
				],inf).coin.not,
				\dur, 1/16,
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\bufnum, ~buflib.clap[67].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1094].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\gain, 0.11,
			),



			Pbind(
				\instrument, \sonar,
				\note, Pseq([
					0,-11,13,-14,
				],inf).stutter(2),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\rq, Pseq([
					0.051
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,0,1,
					0,0,0,0, 0,0,1,0,
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,1,0,1,
				],inf).coin.not,
				\octave, 6,
				\legato, 0.1,
				\dur, 1/2,
				\amp, 10.1,
			),
			Pbind(
				\instrument, \sonar2,
				\note, Pseq([
					0,-11,13,-14,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\isRest, Pseq([
					0,0,0,0, 0,0,1,1,
					0,0,0,0, 0,1,0,1,
				],inf).coin.not,
				\rq, Pseq([
					0.051
				],inf),
				\legato, 0.1,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \bassco,
				\note, Pseq([
					0,1,0,3,
				],inf).stutter(8),
				\legato, Pseq([
					4,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,1,
					4,0,0,0, 0,0,0,0,
					0,0,0,0, 0,0,0,0,

					4,0,0,0, 0,0,2,0,
					0,0,0,0, 0,0,0,0,
					0,0,2,0, 0,0,0,1,
					1,0,0,2, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\distfac,100,
				\distmix, 1,
				\lpfr, 4.3,
				\dur, 1/8,
				\amp, 0.1,
			),
		]),
		Pbind(
			\instrument, \boulyharm2,
			\adsr, Pseq([
				[ Env.adsr(0.1,0.1,0.8,0.1) ],
			],inf),
			\harmtab, Ptuple(Ptuple([Ptuple( Pwhite(0,1)!6)])!8 ),
			\lpfr, ~pmodenv.(Pseq([1/3,1,1/4,2.1],inf), 8),
			\note, Pseq([
				[0,3,7,13],
				[0,3,7-12,12]+6,
				[0,3-12,7,13],
				[0,3,7-12,3+12]+1,
			],inf),
			\legato, 0.51,
			\dur, 1,
			\amp, 0.4,
			\out, BusDef(\sendbus1, \audio),
		),
		Pbind(
			\instrument, \bouly2harm,
			\oscmix, ~pmodenv.(Pwhite(0.0,1,inf), Pwhite(0.1,4)),
			\harmamp, Pseq([
				Pfunc({ arg ev;
					[[6,1.0.rand,1.0.rand,1.0.rand]/6]
				}),
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\note, Pseq([
				Pwalk([1,3,4,6,0,8,9,11], Prand([-1,1,0],inf)),
			],inf),
			\legato, 1,
			\octave, Pwrand([6,5,4], [0.9,0.1,0.1],inf).stutter(Pwhite(1,7,inf)),
			\dur, PdurStutter(Prand([1,4,2,8],inf), 1/2),
			\amp, 0.071 * Pseg(Pwhite(1,0.1,inf),3),
			\out, BusDef(\sendbus2, \audio),
		),

		
	])
)).play;
);


ProtoDef(\rdn).presetCompileString.editorInsert
(
ProtoDef('rdn').make('deldefault', 'rdn', "6-Q24A-PTN7", BusDef(\sendbus1));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.27891039806981,
	'gain', 0.76470588235294,
	'fb', 0.018178881063408,
	'delay', 0.0001,
	'delay2', 0.07776000906038,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.69909760632006,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17807.781882593,
	'hpf', 20.0,
	'fbdistamp', 7.6724448913961,
	'fbdistmix', 0.16806722689076,
	'postlpf', 17000,
	'posthpf', 157.03193377574,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.42682721311638,
	'distamp2', 3.9466141732283,
).keep(1));

);

ProtoDef(\rdn2).presetCompileString.editorInsert
(
ProtoDef('rdn2').make('deldefault', 'rdn2', "5-4L3H-6Q5N", BusDef(\sendbus2));
Ndef('rdn2').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.77791010151461,
	'gain', 0.58783783783784,
	'fb', 0.0001,
	'delay', 1.0,
	'delay2', 0.00015910384392722,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 0.26059518472059,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.093517131107994,
	'fbdistmix', 0.29831932773109,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
	'distamp3', 3.9466141732283,
	'brfrqfac', 0.37940593233798,
	'brffac', 0.60195390291997,
	'shift3', -2.4789915966387,
	'shiftmix', 0.0,
	'stereo', 0.0,
	'delay3', 0.0001,
	'distamp2', 3.9466141732283,
).keep(1));

);



(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \sonar,
			\note, Pseq([
				0,-11,13,-14,
			],inf).stutter(2),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\rq, Pseq([
				0.051
			],inf),
			\octave, 6,
			\legato, 0.1,
			\dur, 1/2,
			\amp, 10.1,
		),
		Pbind(
			\instrument, \sonar2,
			\note, Pseq([
				0,-11,13,-14,
			],inf),
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,1.1) ],
			],inf),
			\rq, Pseq([
				0.051
			],inf),
			\legato, 0.1,
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \sihi,
			\note, Pseq([
				[0,7,13],
				[0,15,13],
				[0,7,11],
			],inf).stutter(4),
			\octave, 6,
			\legato, 0.1,
			\dur, 1/4,
			\amp, 0.1/1,
			\isRest, Pseq([
				1,0.5,0.5,0.51,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.3,0.1,0.8,1.3) ],
			],inf),
			\out, BusDef(\fxbus1, \audio),
		),
		Pmono(\allpassmod,
			\inbus, BusDef(\fxbus1, \audio),
			\decay, 8/2,
			\delay, 1/8,
			\wetgain, 1,
			\lfofreq, 0.001,
			\gain, 4,
			\mix, 0.5,
			\dur, 1,
		),
	])
)).play;
);

(
SynthDef(\sihi, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var freqtab;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\env1.kr(Env([1,0,40]*1.11,[0.01,1.8])), 1);
	env2 = EnvGen.kr(\env2.kr(Env([1,0,4.0],[0.01,1.8])), 1);
	freqtab = freq * [1,2,3,4,5,6]/2;
	sig = SinOsc.ar(freqtab);
	sig1 = SinOsc.ar(freqtab+env1);
	sig = SelectX.ar( SinOsc.ar(freq * env2) , ([sig, sig1].flop * \harmamptab.kr([1,1,1, 1,1,1])).mean.debug("x"));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.3,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\allpass, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	sig = in;
	sig = AllpassL.ar(sig, \maxdelay.ir(4/~t), \delay.kr(1/256/~t),\decay.kr(1/~t));
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
SynthDef(\allpassmod, { arg out=0, gate=1;
	var sig;
	var in = InFeedback.ar(\inbus.kr(BusDef(\zero, \audio)), 2); 
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	lfo1 = SinOsc.ar(\lfofreq.kr(0.07) + ([1,2,3,4,5] *\lfoharmamt.kr(0.1)+1)).mean * \lfoamt.kr(0.01) + 1; 
	sig = in;
	sig = AllpassL.ar(sig, \maxdelay.ir(4/~t), \delay.kr(1/256/~t) * lfo1,\decay.kr(1/~t));
	sig = sig * \wetgain.kr(1);
	sig = SelectX.ar(\mix.kr(0.5), [in, sig]);
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.01)), gate, doneAction:2);
	sig = sig * \gain.kr(1);
	Out.ar(out, sig);
}).add;
Pdef(\part).reset;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\lag, 0.04,
		) <>
		Ppar([
			Pbind(
				\instrument, \sonar,
				\note, Pseq([
					0,-11,13,-14,
				],inf).stutter(2),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\rq, Pseq([
					0.051
				],inf),
				\isRest, Pseq([
					1,0,1,0, 0,1,0,0,
					1,0,0,1, 0,1,0,1,
				],inf).coin.not,
				\octave, 6,
				\legato, 0.1,
				\dur, 1/2,
				\amp, 10.1,
			),
			Pbind(
				\instrument, \sonar2,
				\note, Pseq([
					0,-11,13,-14,
				],inf),
				\adsr, Pseq([
					[ Env.adsr(0.01,0.1,0.8,1.1) ],
				],inf),
				\isRest, Pseq([
					0,0,1,1, 0,1,0,1,
				],inf).coin.not,
				\rq, Pseq([
					0.051
				],inf),
				\legato, 0.1,
				\dur, 1,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \bassco,
				\note, Pseq([
					0,1,0,3,
				],inf).stutter(8),
				\legato, Pseq([
					4,0,0,0, 0,0,2,0,
					0,0,2,0, 0,0,0,1,
					1,0,0,2, 0,0,0,0,
				],inf),
				\isRest, Pfunc({ arg ev; ev[\legato] <= 0 }),
				\octave, 3,
				\distfac,100,
				\distmix, 1,
				\lpfr, 4.3,
				\dur, 1/8,
				\amp, 0.1,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
				\bufnum, ~buflib.kick[336].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
					1,0,0,1, 0,0,0,0,
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.3,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[55].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,1,1,1,
					],1)/2,
				],inf).coin.not,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.drum[56].value,
				\isRest, Pseq([
					Pseq([
						0,0,0,0, 0,0,0,0,
						0,1,1,1, 1,0,0,0,
					],1)/2,
				]/2,inf).coin.not,
				\dur, 1/16,
				\dur, Pkey(\dur) * (1 + (~swing * Pseq([0,1,0,-1],inf))),
				\gain, 0.61,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
				\bufnum, ~buflib.clap[67].value,
				\isRest, Pseq([
					0,0,0,0, 1,0,0,0,
				],inf).coin.not,
				\dur, 1/8,
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1004].value,
				\isRest, Pseq([
					1,0,0,1, 0,0,1,0,
					1,0,1,1, 0,0,1,0,
					1,1,1,0, 0,0,1,1,
					0,0,1,1, 1,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*Pseg(Pseq([1,0.1,2],inf),2) * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
			Pbind(
				\instrument, \playersec,
				\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
				\bufnum, ~buflib.hat[1094].value,
				\isRest, Pseq([
					1,0,0,0, 0,0,0,1,
				],inf).coin.not,
				\sustain, 2,
				\lag, 0.04,
				\dur, 1/8,
				\dur, Pkey(\dur) * (1 + (~swing*0.5 * Pseq([1,-1],inf))),
				\gain, 0.11,
			),
		]),
	])
)).play;
);


(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\out, BusDef(\sendbus1, \audio),
			\gain, 0.3,
		),
		
	])
)).play;
);





////////////////////////////////////
	/////////////////
	// MAIN

(
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8,Pdef(\intro)),
		Pfindur(16,Pdef(\part1)),
		Pfindur(16,Pdef(\break1)),
		Pfindur(4*4,Pdef(\part2)),
			Pfindur(8,Pdef(\break1b)),
			Pfindur(2,Pdef(\parttrans3)),
		Pfindur(4*4,Pdef(\part3)),
		Pfindur(4*4,Pdef(\break2)),
		Pfindur(4*2,Pdef(\break2b)),
		Pfindur(4*4,Pdef(\part4)),
			Pfindur(8,Pdef(\parttrans1)),
		Pfindur(4*4,Pdef(\part5)),
			Pfindur(8,Pdef(\parttrans1)),
		Pfindur(4*4,Pdef(\part6)),
		Pfindur(4*2,Pdef(\intro)),
		
			//Pfindur(8,Pdef(\break1b)),
			//Pfindur(2,Pdef(\parttrans3)),
			//Pfindur(3*8,Pdef(\part6)),
			//Pfindur(3*8,Pdef(\part2)),
			//Pfindur(8,Pdef(\parttrans1)),
			//Pfindur(3*8,Pdef(\part3)),
	])
)).play;
)

(
Pdef(\part, Pdef(\oldmain, 
	Pseq([
		Pfindur(4*2,Pdef(\intro)),
		Pfindur(4*4,Pdef(\part1)),
		Pfindur(4*4,Pdef(\break1)),
		Pfindur(4*4,Pdef(\part2)),
		Pfindur(4*4,Pdef(\break2)),
		Pfindur(4*2,Pdef(\break2b)),
		Pfindur(4*4,Pdef(\part2)),
		Pfindur(4*4,Pdef(\break2)),
		Pfindur(4*2,Pdef(\break2b)),
		Pfindur(4*4,Pdef(\part2)),
		Pfindur(4*2,Pdef(\intro)),
		
	])
)).play;
)

(
	
Pdef(\part, Pdef(\main, 
	Pseq([
		Pfindur(8, Pdef(\island_break1)),
		Pfindur(4, Pdef(\island_break2)),
		Pfindur(32, Pdef(\island_verse1)),
		Pfindur(16, Pdef(\island_break2)),
		Pfindur(4, Pdef(\island_break2)),
		Pfindur(16, Pdef(\island_verse2)),
		Pfindur(2, Pdef(\island_break1)),
		Pfindur(8, Pdef(\island_verse3)),
		Pfindur(32, Pdef(\island_verse4)),
		Pfindur(16, Pdef(\island_verse4outro)),
	])
)).play;
)

////////////////////////////// samples

ClipTimeline(\vin18).edit

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[67].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[336].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.3,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[67].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[336].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.3,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[67].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.041,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.11,
		),
	])
)).play;
);

(
Pdef(\part, Pdef(\zed, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[336].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,1,0,
				0,0,1,0, 1,0,0,1,
			],inf).coin.not,
			\dur, 1/8,
			//\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.3,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[67].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[91].value,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,1,1, 1,1,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 0,0,1,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,1,0,1,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,1,0,0, 1,0,0,1,
			]/2,inf).coin.not,
			\dur, 1/16,
			\gain, 0.11,
			\out, BusDef(\sendbus3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				1,0,0,0, 1,0,0,1,
				1,0,0,0, 1,0,1,1,
				0,0,1,0, 0,0,1,0,
				0,1,0,0, 1,0,0,1,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 2,
			//\lag, 0.041,
			\dur, 1/16,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1094].value,
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\sustain, 2,
			\lag, 0.041,
			\dur, 1/8,
			\out, BusDef(\sendbus3, \audio),
			\gain, 0.11,
			\isRest, true,
		),
	])
)).play;
);


//////////


//One "main" thread
(
	a = 0;
fork {
	//10 parallel threads within it
	10.do { arg idx;
		fork {
			//Concurrent access and increment to 'a' between threads
			while({a < 5}, {
				idx.debug("incr %".format(a));
				a = a + 1;
			});
		}
	}
};
)
