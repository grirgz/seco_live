
(
~t = 191/4/60; TempoClock.default.tempo = ~t;
~swing = 1/6;
)

(
SynthDef(\latchsaw, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1* LFNoise1.ar(0.1,mul:0.01,add:1),1/2 * LFNoise1.ar(0.1,mul:0.01,add:1),LFNoise1.ar(0.1,mul:0.01,add:1) ]).mean;
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * ( 
		Latch.ar( SinOsc.ar(\fmf.kr(1000.2)).unipolar, Impulse.ar(\latchfreq.kr(10))).lag(\latchlag.kr(0.01)) * \latchamt.kr(0.1) + 1 
	), \rq.kr(0.5));
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\clavbell, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var tabsize = 30;
	sig = WhiteNoise.ar * EnvGen.kr(Env([0,1,0.6,0],[0.01,0.01,0.1]), 1);
	sig = LFSaw.ar(freq * [1,2,3,5,7], mul:[1,1/2,1/3,1/4]).mean + sig;
	sig = sig * EnvGen.ar(\perc.kr(Env.perc(0.01,0.401)),gate);
	//sig = sig + ( BPF.ar(WhiteNoise.ar * EnvGen.kr(Env([1,1/2,0],[0.1,0.8],-1), 1), freq,0.4)  );
	sig = Ringz.ar(sig, \freqtab.kr({ exprand(0.99,1) }.dup(tabsize)), \res.kr(3.dup(tabsize))).mean;
	//sig2 = Ringz.ar(sig, \freqtab2.kr({exprand(0.99,1.02)  }.dup(tabsize)) * freq, \res2.kr(0.1.dup(tabsize))).mean;
	//sig = SelectX.ar(Line.kr(0.61,0.5,1/2), [sig1 , sig2]);
	sig = HPF.ar(sig, EnvGen.kr(Env([100,200,1000]+100,[0.4,0.8]), 1));
	//sig = SinOsc.ar(freq) *4;
	sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.5,1,-1)), gate, doneAction:2) * 0.1;
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
SynthDef(\plucky, { arg out=0, gate=1, amp=0.1, pan=0, freq=200;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	env1 = EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:0);
	//sig = Decay.ar(WhiteNoise.ar, 0.1);
	sig = Pluck.ar(WhiteNoise.ar, 1, 100.reciprocal, freq.reciprocal, \decay.kr(1));
	sig = sig + (sig.tanh * \distamp.kr(1));
	sig = RLPF.ar(sig, \lpfr.kr(1.1) * freq * (env1 * \envfamt.kr(1) + 1), \rq.kr(0.5));
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
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[9].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[197].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[206].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[642].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \clavbell,
			\note, Pseq([
				0,3,0,5,
			],inf),
			\perc, [ Env.perc(0.01,0.4) ],
			\dur, 1,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \clavbell,
			\root, Pseq([
				0,3,0,5,
			],inf).stutter(8),
			\note, Pseq([
				Pseq([0,1s,0,-1b],1),
				Pseq([0,7,8,0],1),
			],inf),
			\octave, 6,
			\isRest, Pseq([
				0,0,0,0, 0,0,0,0,
				0,0,1,1, 1,1,0,0,
				1,0,0.3,0.5, 0.5,0.4,1,0.5,
				0,0,1,1, 0,1,0,1,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
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
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[9].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[197].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[206].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[642].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \plucky,
			\note, Pseq([
				12,
			],inf),
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \plucky,
			\note, Pseq([
				7,
			],inf),
			\isRest, Pseq([
				0,1,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
		),
		Pbind(
			\instrument, \plucky,
			\note, Pseq([
				0,
			],inf),
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\amp, 0.1,
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
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[9].value,
			\isRest, Pseq([
				1,0,0,1, 0,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[197].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[206].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
				0,0,0,0, 1,1,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[642].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
				1,1,1,1, 1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		Pbind(
			\instrument, \clavbell,
			\note, Pseq([
				Pseq([ 5,9,14, ],2),
				Pseq([ 5,10,14, ],2),
				Pseq([ 5,8,14, ],2),
				Pseq([ 5,9,14, ],2),

				Pseq([ 5,9,14, ],2),
				Pseq([ 5,8,14, ],2),
				Pseq([ 4,7,14, ],2),
				Pseq([ 4,7,13, ],2),
			],inf).stutter(2),
			\isRest, Pseq([

				1,0,1, 0,1,0, 1,0,0, 0,0,0,  
				1,0,1, 0,1,0, 1,0,0, 0,0,1,  
				1,0,1, 0,1,0, 1,0,0, 0,0,0,  
				1,0,1, 0,1,0, 1,0,0, 1,0,0,  

				1,0,1, 0,1,0, 1,0,0, 0,0,0,  
				1,0,1, 0,1,0, 1,0,0, 0,0,1,  
				1,0,1, 0,1,0, 1,0,0, 0,0,0,  
				1,0,1, 0,1,0, 1,0,1, 1,0,1,  
				//1,0, 1,0, 0,1,
				//1,0, 0,1, 1,0,
				//1,0, 1,0, 0,1,
			],inf).coin.not,
			\octave, 4,
			\dur, 1/12,
			\amp, 0.1,
		),
		Psched(8,Pbind(
			\instrument, \plucky,
			\note, Pseq([
				Pseq([ 5,9,14, ],2),
				Pseq([ 5,10,14, ],2),
				Pseq([ 5,8,14, ],2),
				Pseq([ 5,9,14, ],2),

				Pseq([ 5,9,14, ],2),
				Pseq([ 5,8,14, ],2),
				Pseq([ 4,7,14, ],2),
				Pseq([ 4,7,13, ],2),
			],inf).stutter(2),
			\isRest, Pseq([
				1,0, 0,1, 0,1,
				//1,0, 1,0, 0,1,
				//1,0, 0,1, 1,0,
				//1,0, 1,0, 0,1,
			],inf).coin.not,
			\dur, 1/12,
			\amp, 0.1,
		)),
		Psched(16,Pmono(
			 \latchsaw,
			 \latchamt, Pseg(Pseq([0,3.71],inf),8),
			 \latchlag, Pseg(Pseq([0,0.01,1],inf),9),
			 \fmf, Pseq([
			 	[1000.2,1000.1,2000,1002],
			 	[1000.2,1000.1,2000,102]/2.23,
			 ],inf),
			 \lpfr, 0.8,
			 \latchfreq, 16*~t,
			\note, Pseq([
				Pseq([ 5,9,14, ],2),
				Pseq([ 5,10,14, ],2),
				Pseq([ 5,8,14, ],2),
				Pseq([ 5,9,14, ],2),

				Pseq([ 5,9,14, ],2),
				Pseq([ 5,8,14, ],2),
				Pseq([ 4,7,14, ],2),
				Pseq([ 4,7,13, ],2),
			],inf).clump(3).stutter(2) + [12,0,0],
			\dur, 1/12*3,
			\amp, 0.1/2,
		)),
		
	])
)).play;
);



Pdef(\melo, Pbind(
	\instrument, \clavbell,
	\instrument, \plucky,
	\dur, 1,
	\amp, 0.1,
));
ProtoDef(\piano).startControl(Pdef(\melo))


NoteTimeline(\melo1, Pdef(\melo)).edit;



(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \clavbell,
			\degree, Pseq([0,3],inf).stutter(8),
			\dur, 1,
			\amp, 0.1,
		),
	])
)).play;
);
