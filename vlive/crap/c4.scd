Pbind(\freq, Pseq("Hello World!".ascii.midicps), \dur, 0.1, \legato, 20).play

Pbind(\degree, Pseq("Hello World!".ascii.wrap(-12,12)), \dur, 0.1, \legato, 20).play

Pbind(\scale, Scale.choose.postln, \degree, Pseq("Hello World!".ascii.wrap(-12,12)), \dur, 0.1, \legato, 20).play

Pbind(\scale, Scale.choose.postln, \degree, Pseq("Hello World!".ascii.wrap(-24,24)), \dur, 0.1, \legato, 20).play

Pbind(\freq, Pseq(Document.current.string.ascii.midicps), \dur, 0.1, \legato, 20).play

Pbind(\scale, Scale.choose.postln, \degree, Pseq(Document.current.string.ascii.wrap(-24,24)), \dur, 0.1, \legato, 20).play

(
p = { 
	Pbind(
		\instrument, \bilinvibrond,
		\scale, Scale.choose.postln, 
		\degree, Pseq("Hello World!".ascii.wrap(-12,12)),
		\dur, 0.1,
		\octave, Pseq(({ rrand(4, 7) } ! 12).sort),
		\mtranspose, rrand(-1.0, 1),
		\legato, 60,
		\out, BusDef(\sendbus1, \audio),
			\fspread, ~pmodenv.(Pseq([0.005,0.01],inf), Pwhite(1.0,8,inf)),
			\lplfofac, ~pmodenv.(Pseq([0.5,0.05,0.8,0.1]/4,inf), Pwhite(1,7.0)),
			\oscmix, Pseq([0,1/2,1,Pwhite(0,1.0,1)],inf),

			\modamp, ~pmodenv.(Pseq([0.4,1,0.02,1,0.1,1.4],inf), Pwhite(1/2,4), 1, -4),
			\oscmix, ~pmodenv.(Pseq([0.01,0.3,Pwhite(0,0.4,1)],inf), Pwhite(0.5,7)),
			\lpfr, ~pmodenv.(Pseq([2,4],inf), Pwhite(1.0/8,8)),
			\rq, 0.4,
			\lpmix, ~pmodenv.(Pseq([1,2,1,4]/4,inf), Pwhite(1.0/8,8)),
			\lpmix,1,
		\amp, 0.08
	) 
};

Pdef(\zed, 
	Pspawner { |sp| loop { sp.par(p.()); rrand(3.0, 7).wait } }
).play;
);


(
f = {
	var rep = [4, 8, 16, 32];
	var n = rep.choose;
	var x = [

	      54, 60, 66, 72, 81, 90, 96, 102,
	      108, 128, 132, 144, 162, 180, 192, 204,
	      216, 240, 264, 288, 324, 360, 384, 408,
	      432, 480, 528, 576, 648, 720, 768, 816,
	      864, 960, 1056, 1152, 1296, 1440, 1536, 1632,
	      1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264,
	      3456, 3840, 4224, 4608, 5184, 5760, 6144, 6528,
	      6912, 7680, 8448, 9216, 10368, 11520, 12288, 528

       ];
	var fac1 = [1,10,100,1000].choose;
	var fac2 = [1,10,100,1000].choose;
	var fac3 = [1,10,100,1000].choose;
	Mix.fill(n,
		{
			var detune = 5.rand;
			var saw;
			var sin;
			detune = XLine.kr(0.1,1+250.0.rand ,2+9.0.rand) * 2.0.rand* [1,-1].choose;
			sin = SinOsc.ar(x.choose * ( 1 + ( SinOsc.ar(x.choose/fac1) * x.choose/fac2 )) + detune, 4.rand, 0.25);
			saw = RLPF.ar(Saw.ar(x.choose*0.01+detune, 0.75), x.choose, 2.rand);
			saw = [
				saw,
				saw.fold2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
				saw.wrap2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
				saw *  SinOsc.ar(x.choose/2),
				( saw *  SinOsc.ar(x.choose/fac3).range(1,20) ).tanh/2,
			].choose;
			Pan2.ar((sin+saw) * EnvGen.kr(Env.sine(12, 1/n), 1, doneAction:2),
			1.rand2) 
		}
	);
};
)

(
// DEFINE A ROUTINE
r = Routine({

    inf.do({
		f.play;
        10.wait;
    })
});
)

r.reset.play;


// Rumush
// https://mycelialcordsblog.wordpress.com/
// https://fungorumush.bandcamp.com/releases
// https://soundcloud.com/fungorum

(
f = {
	var rep = [4, 8, 16, 32];
	var n = rep.choose;
	var x = [

	      54, 60, 66, 72, 81, 90, 96, 102,
	      108, 128, 132, 144, 162, 180, 192, 204,
	      216, 240, 264, 288, 324, 360, 384, 408,
	      432, 480, 528, 576, 648, 720, 768, 816,
	      864, 960, 1056, 1152, 1296, 1440, 1536, 1632,
	      1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264,
	      3456, 3840, 4224, 4608, 5184, 5760, 6144, 6528,
	      6912, 7680, 8448, 9216, 10368, 11520, 12288, 528

       ];
	Mix.fill(n,
		{
			var detune = 5.rand;
			var sin = SinOsc.ar(x.choose, 4.rand, 0.25);
			var saw = RLPF.ar(Saw.ar(x.choose*0.01+detune, 0.75), x.choose, 2.rand).tanh;
			Pan2.ar((sin+saw) * EnvGen.kr(Env.sine(12, 1/n), 1, doneAction:2),
			1.rand2) }
	);
};
)

(
// DEFINE A ROUTINE
r = Routine({

    inf.do({
		f.play;
        10.wait;
    })
});
)

r.reset.play;


//////////
(
f = {
	arg rep, 
	var rep = [4, 8, 16, 32];
	var fac = [1,10,100,1000];
	var n = 1;
	var x = [

	      54, 60, 66, 72, 81, 90, 96, 102,
	      108, 128, 132, 144, 162, 180, 192, 204,
	      216, 240, 264, 288, 324, 360, 384, 408,
	      432, 480, 528, 576, 648, 720, 768, 816,
	      864, 960, 1056, 1152, 1296, 1440, 1536, 1632,
	      1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264,
	      3456, 3840, 4224, 4608, 5184, 5760, 6144, 6528,
	      6912, 7680, 8448, 9216, 10368, 11520, 12288, 528

       ];
	var fac1 = TChoose.kr(1,fac);
	var fac2 = TChoose.kr(1,fac);
	var fac3 = TChoose.kr(1,fac);
	var xchoose = {
		TChoose.kr(1, x)
	};
	Mix.fill(n,
		{
			var detune = 5.rand;
			var saw;
			var sin;
			detune = XLine.kr(0.1,1+250.0.rand ,2+9.0.rand) * 2.0.rand* [1,-1].choose;
			sin = SinOsc.ar(x.choose * ( 1 + ( SinOsc.ar(x.choose/fac1) * x.choose/fac2 )) + detune, 4.rand, 0.25);
			saw = RLPF.ar(Saw.ar(x.choose*0.01+detune, 0.75), x.choose, 2.rand);
			saw = [
				saw,
				saw.fold2( SinOsc.ar(xchoose.()/fac3).range(0.1,1) ),
				saw.wrap2( SinOsc.ar(xchoose.()/fac3).range(0.1,1) ),
				saw *  SinOsc.ar(xchoose.()/2),
				( saw *  SinOsc.ar(xchoose.()/fac3).range(1,20) ).tanh/2,
			].choose;
			Pan2.ar((sin+saw) * EnvGen.kr(Env.sine(12, 1/rep.choose), 1, doneAction:2),
			1.rand2) 
		}
	);
};
)





(
Pdef(\zed, 
	Pbind(
		\instrument, Pfunc{ { arg freq, amp=0.1, gate=1;
			var sig;
			sig = [LFSaw, SinOsc].choose.ar(freq) ! 2 * amp;
			sig = sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
		}.asSynthDef.add },
		\degree, Pseq([0],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


(
Pdef(\zed, 
	Pbind(
		\instrument, Pfunc({
			{
				var rep = [4, 8, 16, 32];
				var n = rep.choose;
				var x = [

					54, 60, 66, 72, 81, 90, 96, 102,
					108, 128, 132, 144, 162, 180, 192, 204,
					216, 240, 264, 288, 324, 360, 384, 408,
					432, 480, 528, 576, 648, 720, 768, 816,
					864, 960, 1056, 1152, 1296, 1440, 1536, 1632,
					1728, 1920, 2112, 2304, 2592, 2880, 3072, 3264,
					3456, 3840, 4224, 4608, 5184, 5760, 6144, 6528,
					6912, 7680, 8448, 9216, 10368, 11520, 12288, 528

				];
				var fac1 = [1,10,100,1000].choose;
				var fac2 = [1,10,100,1000].choose;
				var fac3 = [1,10,100,1000].choose;
				Mix.fill(1,
					{
						var detune = 5.rand;
						var saw;
						var sin;
						var sig;
						detune = XLine.kr(0.1,1+250.0.rand ,2+9.0.rand) * 2.0.rand* [1,-1].choose;
						sin = SinOsc.ar(x.choose * ( 1 + ( SinOsc.ar(x.choose/fac1) * x.choose/fac2 )) + detune, 4.rand, 0.25);
						saw = RLPF.ar(Saw.ar(x.choose*0.01+detune, 0.75), x.choose, 2.rand);
						saw = [
							saw,
							saw.fold2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
							saw.wrap2( SinOsc.ar(x.choose/fac3).range(0.1,1) ),
							saw *  SinOsc.ar(x.choose/2),
							( saw *  SinOsc.ar(x.choose/fac3).range(1,20) ).tanh/2,
						].choose;
						sig = (sin+saw) * EnvGen.kr(Env.sine(rrand(4,20), 1/n), 1, doneAction:2);
						sig = Limiter.ar(sig);
						sig = Pan2.ar(sig, 1.rand2);
					}
				);
			}.asSynthDef.add;
		}),
		\dur, Pexprand(0.2,3,inf),
		\amp, 0.1,
	)
).play;
);



(
Pdef(\demo, 
	Pbind(
		\osc, Prand([
			{ arg freq; SinOsc.ar(freq) },
			{ arg freq; LFSaw.ar(freq) },
		],inf),
		\instrument, Pfunc({ arg ev;
			{ arg freq, amp, gate=1;
				var sig;
				//sig = ev[\osc].(freq) ! 2 * amp;
				sig = ev[\osc].(freq);
				sig = sig ! 2 * amp;
				sig = RLPF.ar(sig, \lpfr.kr(1.3) * freq, \rq.kr(0.5));
				sig * EnvGen.kr(\adsr.kr(Env.adsr(0.1,0.1,0.8,0.1)), gate, doneAction:2);
			}.asSynthDef.add
		}),
		\degree, Pseq([0,2,3],inf),
		\dur, 1,
		\amp, 0.1,
	)
).play;
);


Quarks.install("https://github.com/grirgz/param");
Quarks.uninstall("https://github.com/grirgz/param");
Quarks.install("Log")

