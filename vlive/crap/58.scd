(
~molecular_box = { arg lenpat, quant=16, keep=3, pattern;

	Prout({ arg ev;
	
		var lenstr = lenpat.asStream;
		var patstr;
		var buf = Array.fill(quant,{List.new});
		var pat, len;
		var i;
		var basepat;

		patstr = pattern.asStream;

		len = lenstr.next;
                if(len.isNil) {
                    nil.yield;
                };

		i = 0;
		inf.do {
			var n;
			buf[i] = buf[i].keep(0-keep);
			n = buf[i];

			if(n.size != 0) {
				// previous note found, change note length
				len = lenstr.next;
                                if(len.isNil) {
                                   nil.yield;
                                };
			};

			basepat = ev;
			basepat[\legato] = len;
			pat = patstr.next(basepat);
                        if(pat.isNil) {
                           nil.yield;
                        };

			n.add(Pn(pat,1));

			len.do {
				var n = buf[i];

				if(n.size != 0) {
					ev = Ppar(n).embedInStream;
				} {
					var myev;
					myev = ev.deepCopy;
					myev[\isRest] = true;
					ev = Pn(myev,1).embedInStream;
				};
				i = (i+1) % quant;
			};
		}
	})
};
);


(
~ev = (bla:3, rah:6);
~myev = ~ev.deepCopy;
~myev[\isRest] = true;
)


(
SynthDef(\simple, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	sig = SinOsc.ar(freq * [1,1.01,2.01,1.02,1/2] * (SinOsc.kr(3)*0.01+1));
	sig = sig + LFTri.ar(freq * [1,1/2,1.01]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\saw, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	var env;
	sig = LFSaw.ar(freq * [1,1.01,2.01,1.02]);
	sig = Pulse.ar(freq * [1,1.01,2,2.01,1.002]) + sig;
	env = EnvGen.ar(Env.adsr(0.4,0.3,0.31,0.1),gate,doneAction:0);
	sig = RLPF.ar(sig, \ffreq.kr(1000) * (env+0.5));
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;
SynthDef(\reverb, {arg out = 0, in=0;
    var sig = In.ar(in, 2);
    sig = FreeVerb.ar(sig,0.5,0.7);
    ReplaceOut.ar(out, sig);
}).add;
);



Synth.tail(1,\reverb); // if you want



(

Pdef(\mol, 

	~molecular_box.(Pseq([4.5,8],inf), 16, 3,
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) / 2,
			),
			Pbind(
				\instrument, Pn(\saw,4),
				\ffreq, Pseq([5000,1000,200,2000],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
				\legato, Pkey(\legato) / 2,
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				Pseq((0..13)),
				Pseq((0..10)-4),
				Pseq((5..1)),
				Pseq((0..5)*2),
				Pseq((20..10)),
				Pseq((0..10)-10),
			],inf),
		);

	)
	<>
	Pbind(
		\dur, 1/4,
		\scale, Scale.minor,
	)

).play;

)




(

Pdef(\mol, 

	~molecular_box.(Pseq([4.5,2,5,1],inf), 16, 3,
		Pbind(
			\legato, Pseq([
				Pfuncn({ arg ev; ev[\legato] },16),
				Pser([0.5],16)
			],inf)
		)
		<>
		Pseq([
			Pbind(
				\instrument, Pn(\simple,4),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.1,0.8,0.4) ],
					[ Env.adsr(0.4,0.4,0.6,0.2) ],
				],inf),
				\legato, Pkey(\legato) * Pseq([0.2,0.8,1.2],inf).stutter(3),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pseq([5000,1000,700],inf),
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
			Pbind(
				\instrument, Pn(\saw,2),
				\ffreq, Pkey(\freq) * 4,
				\adsr, Pseq([
					[ Env.adsr(0.1,0.4,0.4,0.3) ],
				],inf),
			),
		],inf) 
		<>
		Pbind(
			\degree, Pseq([
				Pseq((5..1)),
				Pseq((0..3)),
				Pseq((0..10)-4),
				Pseq((0..5)*3),
				Pseq((2..10)),
				Pseq((0..10)-10),
			],inf),
		);

	)
	<>
	Pbind(
		\dur, 1/4,
		\mtranspose, 2,
		\root, 4,
		\scale, Scale.aeolian,
	)

).play;
)



(
~ev = (bla:3, rah:6);
~myev = ~ev.deepCopy;
~myev[\isRest] = true;
)

(

// Levels scaling
//m = m ? 0.8;// live
m = m ? 1.2;// rehersal

Ndef(\pul, { | freq=80, rq=0.001, amp = 0.91 |
	RLPF.ar(
		Pulse.ar([100,250],0.5,0.1),
		freq: freq,
		rq: rq,
		mul: amp
	)
	+ (DelayC.ar(Ndef(\pul).ar) * 0.9)
}).play;

// GUI: 2D slider
w = Window("Pulse", Rect(100,Window.screenBounds.height - 400, 300, 300));
w.view.decorator = FlowLayout(w.view.bounds);
t = Slider2D(w, Rect(0, 0,292, 292))
	.y_(1.0)
	.x_(0.0)
	.background_(Color.rand)
	.knobColor_(Color.rand)
	.action_({|pos|
		Ndef(\pul).set(
			\freq, pos.x.linexp(0,1.0, 80, 8000),
			\rq, pos.y.linlin(0, 1.0, 0.001, 1.0)
		)
	});
w.front;
CmdPeriod.doOnce({w.close; Ndef(\pul).clear(4)});

)

// Kill it
w.close; Ndef(\pul).clear(4);




(
SynthDef(\Synth3,
	{arg ress = 0;
		var klank, env;
		klank = Klank.ar(`[{Rand(70,21000)}!7, {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		klank = klank * Klank.ar(`[{Rand(70,21000)}!7, {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		klank = klank/4;
		env = EnvGen.kr(Env.perc(0.07, ress), doneAction:2);
		Out.ar(0, klank*env.dup*0.0128);
}).add;
)

(
SynthDef(\Synth3,
	{arg ress = 0;
		var klank, env;
		klank = Klank.ar(`[{Rand(70,21000)}!7, {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		klank = klank * Klank.ar(`[( {Rand(70,21000)}!7 * (1..8)/8 * LFNoise1.kr(1/2 * (1..8)/8).range(0.0,1.0) ).clip(50,20000), {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		klank = klank.tanh;
		klank = klank*7;
		env = EnvGen.kr(Env.perc(0.07, ress), doneAction:2);
		//klank = Pan2.ar(klank, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! klank.size, 1).mean;
		klank = Splay.ar(klank, 0.99, 1, 0);
		klank.debug("fkjfkj");
		Out.ar(0, klank*env*0.0128);
}).add;
)

(
SynthDef(\Synth3,
	{arg ress = 0;
		var klank, env;
		klank = Klank.ar(`[{Rand(70,21000)}!7, {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		klank = klank * Klank.ar(`[( {Rand(70,21000)}!7 * (1..8)/8 * LFNoise1.kr(1/2 * (1..8)/8).range(0.0,1.0) ).clip(50,20000), {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		klank = klank.tanh;
		klank = klank*7;
		env = EnvGen.kr(\adsr.kr(Env.adsr(0.0001,0.1,0.1,0.001)), Trig.kr(1,ress), doneAction:2);
		//klank = Pan2.ar(klank, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! klank.size, 1).mean;
		klank = Splay.ar(klank, 0.99, 1, 0);
		klank.debug("fkjfkj");
		Out.ar(0, klank*env*0.0128);
}).add;
)

(
SynthDef(\Synth3,
	{arg ress = 0;
		var klank, env;
		klank = Klank.ar(`[{Rand(70,21000)}!7, {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		klank = klank * Klank.ar(`[( {Rand(70,21000)}!7 * (1..8)/8 * LFNoise1.kr(1/2 * (1..8)/8).range(0.0,1.0) ).clip(50,20000), {Rand(0.128,0.700)}!7],BrownNoise.ar(0.7));
		klank = klank.tanh;
		klank = klank*7;
		env = EnvGen.kr(Env.adsr(0.0001,0.1,0.4,ress), Trig.kr(1,1/4), doneAction:2);
		//klank = Pan2.ar(klank, {LFNoise1.kr(1/2).range(-1.0,1.0)} ! klank.size, 1).mean;
		klank = Splay.ar(klank, 0.99, 1, 0);
		klank.debug("fkjfkj");
		Out.ar(0, klank*env*0.0128);
}).add;
)


{inf.do{x = rrand(0.01,0.7); Synth(\Synth3, [\ress, x+(7*x)]); x.wait;}}.fork




a = Synth(\MoaningDialogue)



//COOL TWEAKS

//AngryTweak

a.set(\feedback, 29,\freq, 6)

//CalmTweak

a.set(\feedback, 60, \freq, 0.8)

//WeirdTweak

a.set(\feedback, 2.8, \freq, 2)



(

SynthDef(\MoaningDialogue, {

	|rateL = 0.2, rateR = 0.3, freq = 2, feedback = 50, mul = 1 , lpfreq = 2500|

	Out.ar(0,

		FreeVerb.ar(

			BLowPass.ar(

				SinOscFB.ar(

					LFDNoise1.kr([rateL, rateR], freq), feedback;

				, mul),

				lpfreq,

				0.2

			),

			0.3,

			0.0

		)

	)}

).add

)
