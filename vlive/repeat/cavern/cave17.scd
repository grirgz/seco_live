
(
~t = 120/2/60; TempoClock.default.tempo = ~t;
~swing = 0.3;
)

(
	// base swing drum
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1036].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0, 1,0,1,1, 0,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.1 * Pseq([
				0.6,1,1,1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				0,0,1,0, 0,0,1,0, 0,0,1,1, 0,0,1,0
			],inf).coin.not,
			\dur, 1/8,
			\dur, Pkey(\dur) * (1 + (~swing * Pseq([1,-1],inf))),
			\gain, 0.11,
		),
		
	])
)).play;
);

(
	// sing sing
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1036].value,
			\isRest, Pseq([
				1,0,0, 1,0,0, 1,0,0, 1,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 0.1,0,0, 0.3,0,1, 0.1,0,0.1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1624].value,
			\isRest, Pseq([
				1,0,0, 1,0,0,  1,0,1, 1,0,1,
				1,0,0, 1,0,1,  1,0,1, 1,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 1,0,0, 0.2,0,1, 0.2,0,0.2,
				1,0,0, 0.2,0,1, 0.2,0,1, 0.2,0,0.2,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[28].value,
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.11,
		),
		
	])
)).play;
);

(
	// advanced swing drum
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1036].value,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 0.1,0,0, 0.3,0,1, 0.1,0,0.1,
			],inf),
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1624].value,
			\isRest, Pseq([
				1,0,0, 1,0,0,  1,0,1, 1,0,1,
				1,0,0, 1,0,1,  1,0,1, 1,0,1,
			]/2,inf).coin.not,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 1,0,0, 0.2,0,1, 0.2,0,0.2,
				1,0,0, 0.2,0,1, 0.2,0,1, 0.2,0,0.2,
			],inf),
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,1,0, 0,1,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,1,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 1,0,0, 0.2,0,1, 0.2,0,0.2,
				1,0,0, 0.2,0.2,1, 1,0.2,0.2, 0.2,0.2,0.2,
			],inf),
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[28].value,
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.11,
			\out, BusDef(\mixer3, \audio),
		),
		
	])
)).play;
);

(
	// advanced swing drum
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1036].value,
			\isRest, Pseq([
				1,0,0, 0,0,0, 0,0,0, 0,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 0.1,0,0, 0.3,0,1, 0.1,0,0.1,
			],inf),
			\out, BusDef(\mixer0, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[1719].value,
			\bufnum, ~buflib.snare[1624].value,
			\isRest, Pseq([
				1,0,0, 2,0,0,  1,0,2, 1,0,1,
				1,0,0, 1,0,2,  1,0,2, 1,0,1,
			]/1.2,inf).coin.not,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 1,0,0, 0.2,0,1, 0.2,0,0.2,
				1,0,0, 0.2,0,1, 0.2,0,1, 0.2,0,0.2,
			],inf),
			\out, BusDef(\mixer1, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.clap[19].value,
			//\bufnum, ~buflib.clap[~buflib.clap.size.rand.debug("c")].value,
			\bufnum, ~buflib.clap[141].value,
			\isRest, Pseq([
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				0,0,0, 0,0,0,  1,1,0, 0,1,1,
				1,0,1, 1,0,0,  0,0,0, 0,0,1,
				0,0,0, 1,0,0,  1,0,1, 1,0,1,
				0,0,0, 0,0,0,  1,0,0, 0,0,0,
				1,0,0, 1,0,1,  1,0,1, 1,0,1,
			]/1.2,inf).coin.not,
			\dur, 1/12,
			\gain, 0.1 * Pseq([
				1,0,0, 1,0,0, 0.2,0,1, 0.2,0,0.2,
				1,0,0, 0.2,0.2,1, 1,0.2,0.2, 0.2,0.2,0.2,
			],inf),
			\out, BusDef(\mixer2, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1064].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\bufnum, ~buflib.hat[28].value,
			\isRest, Pseq([
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
			],inf).coin.not,
			\dur, 1/12,
			\gain, 0.11,
			\out, BusDef(\mixer3, \audio),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[977].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0, 0,0,1,  0,0,0, 0,0,1,
				1,0,0, 0,0,0,  0,0,0, 0,0,0,
				0,0,0, 0,0,1,  0,0,1, 0,0,1,
				0,0,0, 1,0,0,  0,0,0, 1,0,0,
			]/1.2,inf).coin.not,
			\dur, 1/12,
			\gain, 0.08,
			\out, BusDef(\mixer4, \audio),
		),
		
	])
)).play;
);


ProtoDef(\rdn).presetCompileString.editorInsert
(
	// big bass with high rez
ProtoDef('rdn').make('deldefault', 'rdn', "5-OC4G-9S5B", BusDef('sendbus1'));
Ndef('rdn').put(100, \pset -> Pbind(
	'wet10', 1.0,
	'mix', 0.7436974789916,
	'gain', 0.37162162162162,
	'fb', 0.0001,
	'delay', 0.0001,
	'delay2', 0.040275599798503,
	'shift', 0.0,
	'shift2', 0.0,
	'distamp', 13.497461607899,
	'pitchlag', 1.0,
	'pitchmix', 0.0,
	'prelpf', 17000,
	'prehpf', 17,
	'lpf', 17000,
	'hpf', 17,
	'fbdistamp', 0.47619047619048,
	'fbdistmix', 0.91176470588235,
	'postlpf', 17000,
	'posthpf', 17,
	'wetamp', 0.46579739809918,
	'indelay', 0.04,
	'wet20', 1.0,
	'mamp', 1,
).keep(1));

);

(
Ndef(\nap, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var root = 2;
	var harm = [
		[0,3,7,9, 12,15,19, 13,21],
	].choose;
	env1 = EnvGen.kr(Env([1,1,4,1,10].scramble,[9,2.1,3.8,3].scramble*2).circle, 1);
	env2 = EnvGen.kr(Env([1,1,4,1,10],[1,3.1,7.8,5]).circle, 1);
	env3 = EnvGen.kr(Env([0,0,1,0,1],[9,4.1,3.8,3]).circle, 1);
	sig = ( harm+root ).midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac.postln*2);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.01,8.0))*PinkNoise.ar(1);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01), 1/env1/4) * ( SinOsc.ar(freq * fac / env1) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 );
		sig = Ringz.ar(sig, freq / 2 * fac * LFNoise1.kr(1/8).range(1.0,1.01), 1/env2/4) * ( SinOsc.ar(freq * fac / env2) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 ) + sig/14;
		//sig1 = SinOsc.ar(freq*fac * ( SinOsc.ar(env2*10) * env3 + 1 )) * LFSaw.ar(1/4*fac*env2).range(0,0.4) * Amplitude.kr(sig).lag2ud(0.1,2);
	});
	sig = BPF.ar(sig, LFNoise1.kr([ 1/2!2 ]).range(70,12000.0), 0.4 * LFNoise1.kr([ 1/2!2 ]).range(0.8,2.0)).flop.sum;
	sig.debug("sig");
	sig = sig.mean * 4;
	sig = CombL.ar(sig, 0.1, 1/( freq * Duty.kr(1/~t * [1,1.1], 0, Dseq([
		Drand(( harm+root ).midiratio)
	],inf)).lag2ud(0.01,0.2 * LFNoise1.kr(1/2).range(0.5,2.0)) ),0.4)/ 2 + sig ;
	//sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	sig = Limiter.ar(sig, 0.5, 0.001);
	//sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

(
Ndef(\nap, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var root = 2;
	var harm = [
		[0,3,7,9, 12,15,19, 13,21],
	].choose;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[1,2.1,3.8,3]), 1);
	env2 = EnvGen.kr(Env([1,1,4,1,10],[1,3.1,7.8,5]), 1);
	env3 = EnvGen.kr(Env([0,0,1,0,1],[9,4.1,3.8,3]).circle, 1);
	sig = ( harm+root ).midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac.postln*2);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.01,8.0))*PinkNoise.ar(1);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01), 1/env1/4) * ( SinOsc.ar(freq * fac / env1) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 );
		sig = Ringz.ar(sig, freq / 2 * fac * LFNoise1.kr(1/8).range(1.0,1.01), 1/env2/4) * ( SinOsc.ar(freq * fac / env2) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 ) + sig/14;
		//sig1 = SinOsc.ar(freq*fac * ( SinOsc.ar(env2*10) * env3 + 1 )) * LFSaw.ar(1/4*fac*env2).range(0,0.4) * Amplitude.kr(sig).lag2ud(0.1,2);
	});
	//sig = BPF.ar(sig, LFNoise1.kr([ 1/2!2 ]).range(70,12000.0), 0.4 * LFNoise1.kr([ 1/2!2 ]).range(0.8,2.0)).flop.sum;
	sig.debug("sig");
	sig = sig.mean * 4  ! 2;
	//sig = CombL.ar(sig, 0.1, 1/( freq * Duty.kr(1/~t * [1,1.1], 0, Dseq([
		//Drand(( harm+root ).midiratio)
	//],inf)).lag2ud(0.01,0.2 * LFNoise1.kr(1/2).range(0.5,2.0)) ),0.4)/ 2 + sig ;
	//sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	sig = Limiter.ar(sig, 0.5, 0.001);
	//sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

(
Ndef(\nap, { arg freq=400, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var root = 2;
	var harm = [
		//[0,3,7,9, 12,15,19, 13,21],
		(0..40)
	].choose;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[1,2.1,3.8,3]), 1);
	env2 = EnvGen.kr(Env([1,1,4,1,10],[1,3.1,7.8,5]), 1);
	env3 = EnvGen.kr(Env([0,0,1,0,1],[9,4.1,3.8,3]).circle, 1);
	sig = ( harm+root ).midiratio.collect({ arg fac, idx;
		sig = Impulse.ar(fac.postln*2);
		sig = Decay2.ar(sig, 0.01, 0.1 * LFNoise1.kr(1/2).exprange(0.01,8.0))*PinkNoise.ar(1);
		sig = Ringz.ar(sig, freq * fac * LFNoise1.kr(1/2).range(1.0,1.01), 1/env1/4) * ( SinOsc.ar(freq * fac / env1) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 );
		sig = Ringz.ar(sig, freq / 2 * fac * LFNoise1.kr(1/8).range(1.0,1.01), 1/env2/4) * ( SinOsc.ar(freq * fac / env2) * LFNoise1.kr(0.1).range(0.0,0.1) + 1 ) + sig/14;
		//sig1 = SinOsc.ar(freq*fac * ( SinOsc.ar(env2*10) * env3 + 1 )) * LFSaw.ar(1/4*fac*env2).range(0,0.4) * Amplitude.kr(sig).lag2ud(0.1,2);
	});
	//sig = BPF.ar(sig, LFNoise1.kr([ 1/2!2 ]).range(70,12000.0), 0.4 * LFNoise1.kr([ 1/2!2 ]).range(0.8,2.0)).flop.sum;
	sig.debug("sig");
	sig = sig.mean * 4  ! 2;
	//sig = CombL.ar(sig, 0.1, 1/( freq * Duty.kr(1/~t * [1,1.1], 0, Dseq([
		//Drand(( harm+root ).midiratio)
	//],inf)).lag2ud(0.01,0.2 * LFNoise1.kr(1/2).range(0.5,2.0)) ),0.4)/ 2 + sig ;
	//sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	sig = Limiter.ar(sig, 0.5, 0.001);
	//sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(1), \damp.kr(0.4));
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);
Ndef(\nap).quant = 1;

(
Ndef(\nap, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var root = 2;
	var harm = [
		[0,3,7,9, 12,15,19, 13,21],
		//rrand(0,41!19)
		//(0..40)
		//{ Scale.locrian.degrees.choose * [1,2].choose + 12 }.dup(9)
		//{ Scale.dorian.degrees.choose * [1,2].choose + 12 }.dup(9)
	].choose;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[1,2.1,3.8,3]), 1);
	env2 = EnvGen.kr(Env([1,1,4,1,10],[1,3.1,7.8,5]), 1);
	env3 = EnvGen.kr(Env([0,0,1,0,1],[9,4.1,3.8,3]).circle, 1);
	env4 = SinOsc.ar(1).exprange(0.1,2); 
	sig = ( harm+root ).midiratio.collect({ arg fac, idx;
		var imp = Impulse.ar(fac * SinOsc.ar(( 1/fac )/8).exprange(0.01,2));
		imp = Trig1.ar(imp,0.01);
		sig = SinOsc.ar(freq * fac) * EnvGen.ar(Env.adsr(0.01* SinOsc.kr(1/fac*1.7).range(1,100),0.1,0.8,0.01 * SinOsc.kr(1/fac).range(1,100)), imp, doneAction:0); 
	});
	//sig = BPF.ar(sig, LFNoise1.kr([ 1/2!2 ]).range(70,12000.0), 0.4 * LFNoise1.kr([ 1/2!2 ]).range(0.8,2.0)).flop.sum;
	sig.debug("sig");
	sig = sig.mean * 4 * 2  ! 2;
	//sig = CombL.ar(sig, 0.1, 1/( freq * Duty.kr(1/~t * [1,1.1], 0, Dseq([
		//Drand(( harm+root ).midiratio)
	//],inf)).lag2ud(0.01,0.2 * LFNoise1.kr(1/2).range(0.5,2.0)) ),0.4)/ 2 + sig ;
	//sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	sig = Limiter.ar(sig, 0.5, 0.001);
	//sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(0.1), \damp.kr(0.4));
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

(
Ndef(\nap, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var root = 2;
	var harm = [
		//[0,3,7,9, 12,15,19, 13,21],
		//rrand(0,41!19)
		(0..40)
		//{ Scale.locrian.degrees.choose * [1,2].choose + 12 }.dup(9)
		//{ Scale.dorian.degrees.choose * [1,2].choose + 12 }.dup(9)
	].choose;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[1,2.1,3.8,3]), 1);
	env2 = EnvGen.kr(Env([1,1,4,1,10],[1,3.1,7.8,5]), 1);
	env3 = EnvGen.kr(Env([0,0,1,0,1],[9,4.1,3.8,3]).circle, 1);
	env4 = SinOsc.ar(1).exprange(0.1,2); 
	sig = ( harm+root ).midiratio.collect({ arg fac, idx;
		var imp = Impulse.ar(fac * SinOsc.ar(( 1/fac )/8).exprange(0.01,2));
		imp = Trig1.ar(imp,0.01);
		sig = SinOsc.ar(freq * fac) * EnvGen.ar(Env.adsr(0.01* SinOsc.kr(1/fac*1.7).range(1,100),0.1,0.8,0.01 * SinOsc.kr(1/fac).range(1,100)), imp, doneAction:0); 
	});
	//sig = BPF.ar(sig, LFNoise1.kr([ 1/2!2 ]).range(70,12000.0), 0.4 * LFNoise1.kr([ 1/2!2 ]).range(0.8,2.0)).flop.sum;
	sig.debug("sig");
	sig = sig.mean * 4 * 2  ! 2;
	//sig = CombL.ar(sig, 0.1, 1/( freq * Duty.kr(1/~t * [1,1.1], 0, Dseq([
		//Drand(( harm+root ).midiratio)
	//],inf)).lag2ud(0.01,0.2 * LFNoise1.kr(1/2).range(0.5,2.0)) ),0.4)/ 2 + sig ;
	//sig = CombL.ar(sig, 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1 * env1!num).range(0.01,1.0),0.4) ;
	sig = Limiter.ar(sig, 0.5, 0.001);
	//sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(0.1), \damp.kr(0.4));
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);

(
Ndef(\nap, { arg freq=70, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var num=7;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var root = 2;
	var harm = [
		[0,3,7,9, 12,15,19, 13,21],
		//rrand(0,41!19)
		//(0..40)
		//{ Scale.locrian.degrees.choose * [1,2].choose + 12 }.dup(9)
		//{ Scale.dorian.degrees.choose * [1,2].choose + 12 }.dup(9)
	].choose;
	env1 = EnvGen.kr(Env([1,1,4,1,10],[1,2.1,3.8,3]), 1);
	env2 = EnvGen.kr(Env([1,1,4,1,10],[1,3.1,7.8,5]), 1);
	env3 = EnvGen.kr(Env([0,0,1,0,1],[9,4.1,3.8,3]).circle, 1);
	env4 = SinOsc.ar(1).exprange(0.1,2); 
	sig = ( harm+root ).midiratio.collect({ arg fac, idx;
		//var imp = Impulse.ar(fac * SinOsc.ar(( 1/fac )/8).exprange(0.01,freq));
		var imp = Impulse.ar(fac * freq/2/16);
		imp = Trig1.ar(imp,0.1 * SinOsc.kr(fac).range(0.1,1));
		sig = [LFPulse,LFSaw,SinOsc].choose.ar(freq * fac) * EnvGen.ar(Env.adsr(0.01* SinOsc.kr(1/fac*1.7).range(1,100),0.1,0.8,0.01 * SinOsc.kr(1/fac).range(1,100)), imp, doneAction:0); 
		sig = ( sig * LFNoise1.kr(1/2).range(0.0,4.0) ).tanh;
		sig = BPF.ar(sig, LFNoise1.kr([ 1/2!2 ]).exprange(70,12000.0), 0.4 * LFNoise1.kr([ 1/2!2 ]).range(0.8,2.0)).flop.sum;
	});
	//sig = BPF.ar(sig, LFNoise1.kr([ 1/2!2 ]).range(70,12000.0), 0.4 * LFNoise1.kr([ 1/2!2 ]).range(0.8,2.0)).flop.sum;
	sig.debug("sig");
	sig = sig.mean * 4 * 2  ! 2;
	//sig = CombL.ar(sig, 0.1, 1/( freq * Duty.kr(1/~t * [1,1.1], 0, Dseq([
		//Drand(( harm+root ).midiratio)
	//],inf)).lag2ud(0.01,0.2 * LFNoise1.kr(1/2).range(0.5,2.0)) ),0.4)/ 2 + sig ;
	sig = CombL.ar([ sig ], 0.3, Rand(0.1,0.3!num) * LFNoise1.kr(0.1!num).range(0.01,1.0),0.004).mean;
	sig = Limiter.ar(sig, 0.5, 0.001);
	//sig = FreeVerb.ar(sig, mix:0.5, room:1, damp:0.5);
	sig = FreeVerb2.ar(sig[0], sig[1], \mix.kr(0.5), \room.kr(0.1), \damp.kr(0.4));
	//sig = Pan2.ar(sig, pan, amp);
	sig = sig * amp;
}).play;
);
