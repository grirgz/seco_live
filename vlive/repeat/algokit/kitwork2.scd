
(
Pdef(\drums, 
	Plazy({
		var kickline, hatline;
		kickline = {
			var seqs;
			var seq = {[
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			].clump(8).choose};

			seqs = seq ! 8;

			Pseq(

				( 
					//seq.value ! 3 ++ seq.value 
					//++ 
					//seq.value ! 3 ++ seq.value 
					//++ 
					//seq.dup(2) ++ seq.dup(2) 
					seqs[0] ++ seqs[1]
					++
					seqs[0] ++ seqs[2]
					//++
					//seqs[3] ++ seqs[2]
					//++
					//seqs[4] ++ seqs[5]
				).flat
				,inf
			).coin.not;
		};
		hatline = {Pser({[
			1,1,1,1, 1,1,1,1,
			1,1,0,0, 1,1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,1,1, 0,0,1,1,
			1,0,1,0, 1,0,1,0,
			0,0,1,0, 1,1,1,0,
			1,0,1,0, 1,1,0,1,
			1,0,0,0, 1,0,0,0,
			1,1,0,0, 1,0,0,0,
			0,0,1,0, 0,0,1,0,
		].clump(8).choose}.dup(16).flat,inf).coin.not};


		Pseq([
			PatKitDef(\scapkit).asPattern(Ppar([
				Pbind(
					\kitIndex, 0,
					\isRest, kickline.value,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 1,
					//\isRest, kickline.value,
					\gain,  Pseq([
						0.7, 0.7, 1, 0.7,
					],inf),
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 1,0,0,0,
						1,0,1,0, 1,0,1,0,
						1,0,1,0, 0,0,1,0,
						0,0,0,1, 0,0,0,0,
						0,0,1,0, 0,0,1,0,
						1,0,0,1, 0,0,1,0,
						1,0,0,0, 1,0,0,1,
						0,0,0,0, 1,0,1,1,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\speed, 1.8,
					\sustain, 0.051,
					\dur, 1/16,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 1,
					\isRest, kickline.value,
					\gain,  Pseq([
						0.7, 0.7, 0.7, 1
					],inf)/1.2,
					\lag, Prand([
						Pseq([0,0.01],inf).stutter(4),
						Pseq([0,0.01],inf).stutter(2),
						Pseq([0,0.01],inf).stutter(1),
						Pseq([0.01],inf).stutter(1),
						Pseq([0],inf).stutter(1),
					],inf),
					\sustain, 0.2,
					\speed, Pfin(64,Pseq({rrand(3/4!8,5/4).choose.asArray.stutter([4,8,16,32].choose)}.dup(4).flat,inf)).loop,
					\sustain, Pfin(64,Pseq({rrand(0.1!8,0.3).choose.asArray.stutter([4,8,16,32].choose)}.dup(4).flat,inf)).loop,
					\dur, [1/8,1/16].choose,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 9,
					\isRest, hatline.value,
					\sustain, 0.04,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 9,
					\isRest, hatline.value,
					\sustain, 0.05,
					\isRest, Pseq({[
						1,0,1,0, 0,0,1,0,
						1,0,0,0, 1,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,1,1, 1,1,1,1,
						1,0,0,1, 0,0,1,0,
						0,0,0,0, 1,0,0,0,
						0,0,1,0, 0,0,1,0,
						0,1,0,1, 0,0,1,0,
					].clump(8).choose}.dup(8).flat,inf).coin.not,
					\speed, 1.5,
					\dur, 1/16,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 10,
					\isRest, hatline.value,
					\sustain, 0.18,
					\speed, 0.9,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 4,
					\freq, 200,
					\isRest, Pseq({[
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\dur, 1/8,
					\amp, 0.1
				),
				Pbind(
					\kitIndex, 5,
					\freq, 200,
					\isRest, Pseq({[
						0,0,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0.2,0,
						0,0,0,0, 1,0,0,0,
						0,0.2,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0.4,
					].clump(8).choose}.dup(4).flat,inf).coin.not,
					\sustain, Pseq([0.1,0.2,0.05,0.3,0.1],inf),
					\dur, 1/8,
					\amp, 0.1
				),
			]))

		])
	})
).play;
)



(
SynthDef(\kick1, {
    var snd;
    snd = DC.ar(0);
    snd = snd + (SinOsc.ar(XLine.ar(200, 40, 0.01)) * Env.perc(0.015, 0.01).ar);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), XLine.ar(800, 100, 0.01), 0.6) * Env.perc(0.001, 0.02).delay(0.001).ar);
    snd = snd + (SinOsc.ar(XLine.ar(172, 50, 0.01)) * Env.perc(0.0001, 0.3, 1, \lin).delay(0.005).ar(2));
    snd = snd.tanh;
    Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;

SynthDef(\kick2, {
    var snd;
    snd = DC.ar(0);
    snd = snd + (HPF.ar(Hasher.ar(Sweep.ar), 1320) * Env.perc(0.003, 0.03).ar * 0.5);
    snd = snd + (SinOsc.ar(XLine.ar(750, 161, 0.02)) * Env.perc(0.0005, 0.02).ar);
    snd = snd + (SinOsc.ar(XLine.ar(167, 52, 0.04)) * Env.perc(0.0005, 0.3).ar(2));
    snd = snd.tanh;
    Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;

SynthDef(\kick3, {
    var snd;
    snd = DC.ar(0);
    snd = snd + (SinOsc.ar(XLine.ar(1500, 800, 0.01)) * Env.perc(0.0005, 0.01, curve: \lin).ar);
    snd = snd + (BPF.ar(Impulse.ar(0) * SampleRate.ir / 48000, 6100, 1.0) * 3.dbamp);
    snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 300, 0.9) * Env.perc(0.001, 0.02).ar);
    snd = snd + (SinOsc.ar(XLine.ar(472, 60, 0.045)) * Env.perc(0.0001, 0.3, curve: \lin).delay(0.005).ar(2));
    snd = snd.tanh;
    Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1)));
}).add;
)

(
Pdef(\drums, Plazy({
		var kickline, hatline, snareline;
		kickline = {
			var seqs;
			var seq = {[
				1,0,0,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,1,0,0,
				1,0,0,0, 0,0,0,1,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				0,0,0,0, 0,0,0,0,
				0,0,1,0, 0,0,0,0,
				0,1,0,1, 0,0,0,0,
				0,0,0,1, 0,0,1,0,
				1,0,0,1, 0,0,1,0,
				1,0,0,0, 0,0,1,0,
				1,0,1,0, 0,0,0,0,
				1,1,1,1, 0,0,0,0,
			].clump(8).choose};

			seqs = seq ! 8;

			Pseq(

				( 
					//seq.value ! 3 ++ seq.value 
					//++ 
					//seq.value ! 3 ++ seq.value 
					//++ 
					//seq.dup(2) ++ seq.dup(2) 
					seqs[0] ++ seqs[1]
					++
					seqs[0] ++ seqs[2]
					//++
					//seqs[3] ++ seqs[2]
					//++
					//seqs[4] ++ seqs[5]
				).flat
				,inf
			).coin.not;
		};
		hatline = {Pser({[
			1,1,1,1, 1,1,1,1,
			1,1,0,0, 1,1,0,0,
			0,0,0,0, 0,0,0,0,
			0,0,1,1, 0,0,1,1,
			1,0,1,0, 1,0,1,0,
			0,0,1,0, 1,1,1,0,
			1,0,1,0, 1,1,0,1,
			1,0,0,0, 1,0,0,0,
			1,1,0,0, 1,0,0,0,
			0,0,1,0, 0,0,1,0,
		].clump(8).choose}.dup(16).flat,inf).coin.not};
		snareline = {Pser({[
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,0,
			0,1,0,0, 1,0,0,0,
			0,1,0,0, 1,0,0,0,
			0,1,0,0, 1,0,0,0,
			0,0,0,0, 1,0,0,1,
			0,0,0,0, 1,0,0,1,
			0,0,0,0, 1,0,0,1,
			0,0,1,0, 1,0,1,0,
			0,0,1,0, 0,0,1,0,
			0,1,0,1, 0,1,0,1,
		].clump(8).choose}.dup(4).flat,inf).coin.not};
	Ppar([
		Pbind(
			\instrument, \kick1,
			\isRest, kickline.value,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \kick2,
			\isRest, kickline.value,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \kick3,
			\isRest, kickline.value,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaphihat,
			\isRest, hatline.value,
			\sustain, 0.01,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snaphihat,
			\isRest, hatline.value,
			\level, 0.8,
			\lag, Pseq([
				0,
				1/16,
			]).stutter(Prand([4,8,16],inf))/~t,
			\sustain, 0.02,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapkick,
			\isRest, kickline.value,
			\dur, 1/8,
			\amp, 0.1
		),
		Pbind(
			\instrument, \snapclap,
			\isRest, snareline.value,
			\dur, 1/4,
			\amp, 0.15,
		),
		PatKitDef(\algokit).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, snareline.value,
			\speed, rrand(0.9,1.1),
			\dur, 1/4,
			\sustain, 0.2,
			\gain, 0.8,
			\amp, 0.1
		)),
		PatKitDef(\algokit).asPattern(Pbind(
			\kitIndex, 5,
			\isRest, snareline.value,
			\speed, rrand(0.9,1.1),
			\dur, 1/8,
			\amp, 0.1
		)),
	])
	
}));
)


Pdef(\drums).set(\out, BusDef(\sendbus0, \audio))
Pdef(\drums).set(\out, 0)
Pdef(\drums).play;
ProtoDef(\rdn).edit
ProtoDef(\rdn).play


(
Pdef(\drums).play;
Ndef(\drumfx2, { arg freq=200, pan=0, amp=0.1;
	var sig = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
	var delay;
	var ramp;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	delay = EnvGen.kr(Env([0,0.01,0],[0.01,\bsustain.kr]), \dtrig.tr(0));
	ramp = EnvGen.kr(Env([0,0,1],[0.0,\bsustain.kr]), \dtrig.tr(0));
	sig = sig + DelayC.ar(sig, 0.1,delay * (1..8)/8,mul:1.1).mean;
	sig = sig + FreqShift.ar(sig, delay);
	sig1 = sig + LFSaw.ar(Pitch.kr(sig).flop.[0].poll * ramp * [1,1.001]/8, mul:0.1);
	sig = SelectX.ar(ramp, [sig, sig1]);
	sig = Compander.ar(sig, sig, \cpt.kr(0.4), \cpbelow.kr(1.001), \cpabove.kr(0.9), \cpclamp.kr(0.01), \cprelax.kr(0.1));
	sig;
}).play;
Ndef(\drumfx2).put(10, \set -> Pseq([
	Pbind(
		\dtrig, 0,
		\dur, Pseq([2],1),
		\bsustain, Pkey(\dur)/~t,
	),
	Pbind(
		\dtrig, 1,
		\dur, Pseq([6],1),
		\bsustain, Pkey(\dur)/~t,
	),
	
],inf))
);

(
Pdef(\drums).play;
Ndef(\drumfx1, { arg freq=200, pan=0, amp=0.1;
	var sig = InFeedback.ar(\inbus.kr(BusDef(\sendbus0, \audio)), 2); 
	sig.poll;
	sig = sig + DelayC.ar(sig, 0.1,\delay.kr(0));
	sig;
}).play;
Ndef(\drumfx1).put(10, \set -> Pseq([
	Pbind(
		\delay, 0,
		\dur, Pseq([6],1)
	),
	Pbind(
		\delay, 0.1,
		\dur, Pseq([2],1)
	),
	
],inf))
);


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);




(
SynthDef(\sca1, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq * ((1..4)/\fspread.kr(40) + 1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar(1/[10,20,30,40],mul:0.2);
	sig = sig * 3;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
SynthDef(\sca2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFCub.ar(freq * ((1..4)/\fspread.kr(40) + 1));
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	pan = pan + SinOsc.ar(1/[10,20,30,40],mul:0.2);
	sig = sig * 3;
	sig = Pan2.ar(sig, pan, amp).mean;
	Out.ar(out, sig);
}).add;
);

(
Pdef(\sca1, Pbind(
	\instrument, \sca1,
	\degree, Pseq([
		[0,2,4],
		[0,2b,4],
		[0,2,4],
		[0,2b,4],
	],inf),
	\fspread, 500,
	\dur, 1,
	\amp, 0.1
)).play;
Pdef(\sca2, Pbind(
	\instrument, \sca2,
	\degree, Pstep(Pseq([
		9,
		9b,
		7,
		7,
	],inf),1),
	\fspread, Pseq([50,500,5000,20000],inf),
	\dur, 1/4,
	\amp, 0.051
)).play;
);

(
Pdef(\drums, 
	Ppar([
		PatKitDef(\algokit).asPattern(
			Ppar([
				Pbind(
					\kitIndex, 1,
					\isRest, Pseq([
						1,0,0,0, 0,0,0,0,
						1,0,0,1, 0,0,0,0,
						1,0,0,0, 0,0,1,0,
						1,0,0,1, 0,0,0,0,
					],inf).coin.not,
					//\speed, rrand(0.9,1.1),
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.01,0.8,0.4) ],
					],inf),
					\sustain, 0.08,
					//\gain, 0.8,
				),
				Pbind(
					\kitIndex, 5,
					\isRest, Pseq([
						0,0,0,0, 1,0,0,0,
						0,0,0,0, 1,0,0,0,
					],inf).coin.not,
					//\speed, rrand(0.9,1.1),
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.01,0.8,0.1) ],
					],inf),
					\sustain, 0.08,
					//\gain, 0.8,
				),
				Pbind(
					\kitIndex, 8,
					\isRest, Pseq([
						1,0,1,0, 1,0,1,0,
						0,0,1,0, 0,0,1,0,
						1,1,0,1, 1,0,1,0,
						0,0,1,0, 0,0,1,0,
					],inf).coin.not,
					//\speed, rrand(0.9,1.1),
					\dur, 1/8,
					\adsr, Pseq([
						[ Env.adsr(0.01,0.1,0.2,0.04) ],
					],inf),
					\sustain, 0.08,
					//\gain, 0.8,
				),
			]),
		)
	])
).play;
)

Pdef(\main, 
	Pseq([
		Ppar([
			Pfindur(14,Pdef(\drums)),
			Pfindur(16,Pdef(\sca1)),
			Pfindur(16,Pdef(\sca1)),
		
		])
	],1),
).play;

ClipTimeline(\sca).edit
