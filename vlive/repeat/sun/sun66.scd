
// sound design 


// cleaning laser

(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var lfo1, lfo2, lfo3, lfo4, lfo5, lfo6, lfo7, lfo8;
	freq = EnvGen.kr(Env([45,200,210,51]*0.5,[1,2,2]), 1);
	env1 = EnvGen.kr(Env([1,2,2.1,1/4],[1,2,2]*1.1), 1);
	lfo1 = SinOsc.ar(0.05 * (1..10)) * 0.6  + 1;
	sig = LFSaw.ar(freq * [1,2,1.01]);
	//sig = DC.ar(0);
	sig = sig + LFSaw.ar(( freq * ( (1..10)/2+1 ) ).clip(20,20000), mul:(1..10).linexp(1,10,3.4,1).reverse * lfo1);
	//sig = LPF.ar(sig, 30 * env1,0.1) + sig;
	sig = sig.mean;
	sig1 = RLPF.ar(sig, \lpf.kr(100) * env1 * [0.5,1,2,1.002], \rq.kr(0.01) * ( SinOsc.ar(2) * 0.7 + 1 ) );
	sig1 = Compander.ar(sig1, sig1, \cpt.kr(1), \cpbelow.kr(1.001), \cpabove.kr(0.5), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig1.debug("sig1");
	sig1 = sig1.mean;
	sig = sig + sig1;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Ndef(\zed, { arg freq=49, pan=0, amp=0.1;
	var sig;
	var env1, env2, env3, env4, env5, env6, env7, env8;
	var op;
	op = {
		var isig;
		var rnd = { arg x; x * rrand(0.8,1.2)*2 };
		var rndsmall = { arg x; x * ( rrand(0,\delta.kr(0.01)) - \delta.kr/2 + 1 ) };
		var fr = freq/2;
		env1 = EnvGen.kr(Env([33+rrand(0,1.1),1,1.1,3].collect(rndsmall),[1+rrand(0,0.04),2,1].collect(rndsmall),[-2,0,0]), 1);
		env2 = EnvGen.kr(Env([3,1,0.1,3].collect(rnd),[1,2,1].collect(rnd)), 1);
		env3 = EnvGen.kr(Env([0,1,1,0].collect(rnd),[0.1,3,0.1].collect(rnd)), 1);
		env4 = EnvGen.kr(Env([1,1,1,1].collect(rnd),[1,2,1].collect(rnd)), 1);
		isig = LFSaw.ar(fr * env1);
		isig = RLPF.ar(isig, fr * env2, \rq.kr(0.1) * env4) + isig;
		isig = isig * env3;
	};
	sig = 10.collect(op);
	sig = sig.mean * 2;
	//sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
	sig = Pan2.ar(sig, pan, amp);
}).play;
);


(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, SynthDef(\xxx, { arg out=0, freq=200, pan=0, amp=0.1, gate=1;
				var sig;
				var env1, env2, env3, env4, env5, env6, env7, env8;
				var op;
				op = { arg ffac=1;
					var isig;
					var rnd = { arg x; x * rrand(0.8,1.2)*2 };
					var rndsmall = { arg x; x * ( rrand(0,1.0)*\del.kr(0.01) - ( \del.kr/2 ) + 1 ) };
					var fr = freq * ffac;
					//rndsmall = { arg x; x * ( rrand(0,1.0)*0.01 - ( 0.01/2 ) + 1 ) };
					//[1].collect(rndsmall).debug("rrc").poll;
					env1 = EnvGen.kr(Env([63+rrand(0,1.1),1,1.1,3].collect(rndsmall),[0.5+rrand(0,0.04),2,1].collect(rndsmall)).debug("env"), 1);
					env2 = EnvGen.kr(Env([13,1,0.1,3].collect(rnd),[1,2,1].collect(rnd)), 1);
					env3 = EnvGen.kr(Env([0,1,1,0].collect(rnd),[0.1,3,0.1].collect(rnd)), 1);
					env4 = EnvGen.kr(Env([1,1,1,1].collect(rnd),[1,2,1].collect(rnd)), 1);
					isig = LFSaw.ar(( fr * env1 ));
					isig = BPF.ar(isig, ( fr * env2 * 4).clip(20,20000), \rq.kr(0.1) * env4) + ( isig * 0.2 );
					isig = isig * env3;
				};
				sig = [op.(1/2),op.(1/2)];
				sig = sig.mean * 2;
				//sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
				sig = Pan2.ar(sig, pan, amp);
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				Out.ar(0, sig);

			}).add,
			\note, Pseq([
				//0,-3,-4,-5,
				0,
			],inf),
			\octave, 3,
			\dur, 8,
			\amp, 0.1,
		),
		
	])
)).play;
);


(
Ndef(\zed, { arg freq=200, pan=0, amp=0.1;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	freq = 28;
	freq = freq * EnvGen.kr(Env([3,1,1.1,3],[0.4,4,0.8]), 1);
	sig = LFSaw.ar(freq * [1,1.00001] * LFNoise1.ar(58,mul:0.02,add:1));
	sig = sig + LFSaw.ar(freq*6 * [1,1.00002] * LFNoise1.ar(58,mul:0.02,add:1), mul:0.3);
	sig = sig + LFSaw.ar(freq*8 * LFNoise1.ar(1,mul:0.07,add:1) * [1,1.00003] * LFNoise1.ar(58,mul:0.02,add:1), mul:0.3);
	//sig = BPF.ar(sig, 58,0.1)*1.8;
	sig1 = BPF.ar(sig, 258 * LFNoise1.ar(8,mul:0.2,add:1),0.1)*1;
	sig2 = BPF.ar(sig, 1757 * LFNoise1.ar(11,mul:0.2,add:1),0.1)*1;
	sig3 = BPF.ar(sig, 3758 * LFNoise1.ar(11,mul:0.2,add:1),0.1)*1;
	sig4 = BPF.ar(sig, 13758 * LFNoise1.ar(11,mul:0.2,add:1),0.1)*1;
	sig = [sig , sig1, sig2, sig3, sig4];
	//sig = BPF.ar(sig, MouseX.kr(20,9000),0.1)*1.8;
	sig = sig.mean;
	sig = Pan2.ar(sig, pan, amp);
}).play;
);

(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			 SynthDef(\xxx, { arg out=0, freq=200, pan=0, amp=0.1, gate=1;
				var sig;
				var env1, env2, env3, env4, env5, env6, env7, env8;
				var op;
				op = { arg ffac=1;
					var isig;
					var rnd = { arg x; x * rrand(0.8,1.2)*2 };
					var rndsmall = { arg x; x * ( rrand(0,1.0)*\del.kr(0.01) - ( \del.kr/2 ) + 1 ) };
					var fr = freq * ffac;
					//rndsmall = { arg x; x * ( rrand(0,1.0)*0.01 - ( 0.01/2 ) + 1 ) };
					//[1].collect(rndsmall).debug("rrc").poll;
					env1 = EnvGen.kr(Env([13+rrand(0,1.1),1,1.1,3].collect(rndsmall),[0.5+rrand(0,0.04),5,1].collect(rndsmall)).debug("env"), 1);
					env2 = EnvGen.kr(Env([13,1,0.1,3].collect(rnd),[1,2,1].collect(rnd)), 1);
					env3 = EnvGen.kr(Env([0,1,1,0].collect(rnd),[0.1,3,0.1].collect(rnd)), 1);
					env4 = EnvGen.kr(Env([1,1,1,1].collect(rnd),[1,2,1].collect(rnd)), 1);
					isig = LFSaw.ar(( fr * env1 ));
					isig = BPF.ar(isig, ( fr * env2 * 4).clip(20,20000), \rq.kr(0.1) * env4) + ( isig * 0.2 );
					isig = isig * env3;
				};
				sig = [op.(1/2),op.(1/2),op.(1)];
				sig = sig.mean * 2;
				//sig = Splay.ar(sig, \spread.kr(0.8), amp, pan);
				sig = Pan2.ar(sig, pan, amp);
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				Out.ar(out, sig);

			}).add.asDefName,
			\note, Pseq([
				//0,-3,-4,-5,
				0,1,-2,2
			],inf),
			\octave, 3,
			\dur, 1,
			\amp, 0.1,
		),
		
	])
)).play;
);

///////////////////////////////////////

(
SynthDef(\organ_tonewheel0, {
	//additive tonewheel organ with few CPU usage

	arg out=0, freq = 440, amp = 0.7, gate=1, atk = 0.001, sus = 0.2, rel = 0.01, pan = 0,
	bass = 1, quint = 1, fundamental = 1, oct = 1, nazard = 1, blockFlute = 1, tierce = 1, larigot = 1, sifflute = 1, //organ voices (drawbars) amplitudes
	vrate = 3, vdepth = 0.008; //vibrato arguments
	var sig, env, vibrato;

	vibrato = SinOsc.kr(DC.kr(vrate)).range(1 - DC.kr(vdepth), 1+ DC.kr(vdepth));
	env = EnvGen.ar(Env.adsr(atk, 0.01, 0.98, rel), gate, doneAction: Done.freeSelf);
	sig = DynKlang.ar(`[[1/12,  1/7, 1, 12, 19, 24, 28, 31, 36].midiratio, ([DC.ar(bass) , DC.ar(quint), DC.ar(fundamental), DC.ar(oct), DC.ar(nazard), DC.ar(blockFlute), DC.ar(tierce), DC.ar(larigot), DC.ar(sifflute)].normalizeSum), nil], vibrato * freq);

	sig = sig * env;
	Out.ar(out, Pan2.ar(sig, pan, amp));
//By Zé Craum
}).add;
)
(
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pbind(
			\instrument, \organ_tonewheel0,
			\note, Pseq([
				0,4,2,1,
			],inf),
			\dur, 1,
			\amp, 0.1,
			\out, BusDef(\sendbus5, \audio),
		),
		
	])
)).play;
);

(
Pdef(\melo, 
		Pbind(
			\instrument, \organ_tonewheel0,
			\amp, 0.1,
			\out, BusDef(\sendbus5, \audio),
		),
)
);
ProtoDef(\piano).startControl(Pdef(\melo))

Pdef(\melo).edit
Pdef(\melo).asParamGroup.getPbindCompileString.editorInsert
(


);



(
Pdef(\part, Pdef(\drums1, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1436].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2339].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1408].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,0.1,1,0.1,
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\organ1, 
	Pbind(
		\instrument, \organ_tonewheel0,
		\amp, 0.1,
		'atk', 0.0010000000474975,
		'sus', 0.20000000298023,
		'rel', 0.0099999997764826,
		'bass', 0.1,
		'quint', 0.1,
		'fundamental', 2.1809411071225,
		'oct', 0.26814275072937,
		'nazard', 0.13610196448785,
		'blockFlute', 0.36494755137443,
		'tierce', 0.5282843274105,
		'larigot', 0.63560362141631,
		'sifflute', 0.41283471683001,
		'vrate', 0.67601952842179,
		'vdepth', 0.0008,
	)
);
);

NoteTimeline(\melo1, Pdef(\organ1)).edit
NoteTimeline(\melo2, Pdef(\organ1)).edit
Log(\Param).level = \info


(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1436].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1010].value,
			\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\bufnum, ~buflib.kick[1436].value,
			\speed, Pwhite(0.93,1.03,inf),
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\lag, Pwhite(0.02,0.08,inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2339].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\isRest, Pseq([
				0,0,1,0, 1,0,0,0,
				1,0,1,0, 0,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1408].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,1,0, 1,0,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,0.1,1,0.1,
			],inf),
		),
		
	])
)).play;
);

(
Pdef(\part, Pdef(\drums2, 
	Ppar([
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[1436].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\isRest, Pseq([
				1,0,0,0, 0,0,1,0,
				0,0,0,0, 1,0,0,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\dur, 1/8,
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.kick[409].value,
			//\bufnum, ~buflib.kick[~buflib.kick.size.rand.debug("k")].value,
			\speed, Pseq([ 0.93,1.03 ],inf).stutter(2),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.04,0.1,0.8,0.01) ],
			],inf),
			\dur, 1/8,
			\lag, Pwhite(0.02,0.08,inf),
			\gain, 0.1,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.snare[2339].value,
			//\bufnum, ~buflib.snare[~buflib.snare.size.rand.debug("s")].value,
			\speed, Pseq([ 0.93,1.03 ],inf).stutter(2),
			\isRest, Pseq([
				1,0,1,0,
			],inf).coin.not,
			\adsr, Pseq([
				[ Env.adsr(0.01,0.1,0.8,0.1) ],
			],inf),
			\legato, 0.5,
			\dur, 1/8,
			\gain, 0.11,
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[1408].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,1,1,1,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11 * Pseq([
				0.1,1.1,0.1,1.1,
			],inf),
		),
		Pbind(
			\instrument, \playersec,
			\bufnum, ~buflib.hat[651].value,
			//\bufnum, ~buflib.hat[~buflib.hat.size.rand.debug("h")].value,
			\isRest, Pseq([
				1,0,0,0, 1,0,0,0,
				0,0,1,1, 1,0,1,0,
				1,1,0,0, 1,0,0,1,
				0,0,1,0, 1,1,1,0,
			],inf).coin.not,
			\dur, 1/8,
			\gain, 0.11,
		),
		
	])
)).play;
);

FileSystemProject.load("libdef/CustomTrackList.scd")
