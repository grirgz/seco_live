
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
Pdef(\part, Pdef(\zedpart, 
	Ppar([
		Pmono(
			{ arg out=0, gate=1, amp=0.1, pan=0, freq=200;
				var sig;
				var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
				sig = 5.collect { arg idx;
					var ifreq = freq + ( idx/100 );
					var oscmix = SinOsc.kr(0.1 / ( idx+1 )).unipolar;
					sig1 = LFSaw.ar(ifreq);
					sig2 = LFPulse.ar(ifreq);
					sig3 = SinOsc.ar(ifreq);
					SelectX.ar(oscmix*2, [sig1, sig2, sig3]);
				};
				sig = sig.mean;
				sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
				sig = Pan2.ar(sig, pan, amp);
				Out.ar(out, sig);
			}.asDefName,
			\note, Pstep(Pseq([
				0,4,7,
			],inf),4),
			\octave, 5,
			\dur, 1,
			\amp, 0.1,
		)
		
	])
)).play;
);
