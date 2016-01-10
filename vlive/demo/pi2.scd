
(
~decimals = "31415926535897932384626433832795028841971693993751058209749445923078164062862"
"089986280348253421170679821480865132823066470938446095505822317253594081284811"
"174502841027019385211055596446229489549303819644288109756659334461284756482337"
"867831652712019091456485669234603486104543266482133936072602491412737245870066"
"063155881748815209209628292540917153643678925903600113305305488204665213841469"
"519415116094330572703657595919530921861173819326117931051185480744623799627495"
"673518857527248912279381830119491298336733624406566430860213949463952247371907"
"021798609437027705392171762931767523846748184676694051320005681271452635608277"
"857713427577896091736371787214684409012249534301465495853710507922796892589235"
"420199561121290219608640344181598136297747713099605187072113499999983729780499"
"510597317328160963185950244594553469083026425223082533446850352619311881710100"
"031378387528865875332083814206171776691473035982534904287554687311595628638823"
"537875937519577818577805321712268066130019278766111959092164201989380952572010"
"654858632788659361533818279682303019520353018529689957736225994138912497217752"
"834791315155748572424541506959508295331168617278558890750983817546374649393192"
"550604009277016711390098488240128583616035637076601047101819429555961989467678"
"374494482553797747268471040475346462080466842590694912933136770289891521047521"
"620569660240580381501935112533824300355876402474964732639141992726042699227967"
"823547816360093417216412199245863150302861829745557067498385054945885869269956"
"909272107975093029553211653449872027559602364806654991198818347977535663698074"
"265425278625518184175746728909777727938000816470600161452491921732172147723501"
"414419735685481613611573525521334757418494684385233239073941433345477624168625"
"189835694855620992192221842725502542568876717904946016534668049886272327917860"
"857843838279679766814541009538837863609506800642251252051173929848960841284886"
"269456042419652850222106611863067442786220391949450471237137869609563643719172"
"874677646575739624138908658326459958133904780275900994657640789512694683983525"
"957098258226205224894077267194782684826014769909026401363944374553050682034962";

SynthDef(\blo, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq*[1,1.001]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\raid, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = LFSaw.ar(freq * [1,1.001]);
	sig = RLPF.ar(sig, freq*2);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;

SynthDef(\raid2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var env1 = EnvGen.kr(Env([1,2,1],[0.01,0.8]), 1);
	sig = LFSaw.ar(freq * [1,1.001, 1 + Rand(0,0.0001)]);
	sig1 = (sig * Rand(1,100)).wrap2(1)/2;
	sig = SelectX.ar( 
		SelectX.kr(ExpRand(0.001,1), [
			LFSaw.kr(1/8).range(0,1),
			SinOsc.kr(freq % 64 / 8).range(0,1),
		])
	, [sig, sig1]);
	sig = RLPF.ar(sig, freq*env1 * [1,1 + Rand(0,0.1),2,1.01]);

	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\raid3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spoon;
	var sig;
	var xfreq;
	var env1 = EnvGen.kr(Env([1,2,1],[0.01,0.8]), 1);
	env1 = 1;
	xfreq = freq * ( 1 + ( SinOsc.ar(Rand(100,500)) * Rand(0.1,3) ));
	xfreq = [xfreq, freq];
	sig = LFSaw.ar(xfreq *.t [1,1.001, 1 + Rand(0,0.0001)]);
	sig = SelectX.ar( spoon.range(0,1), sig);
	sig = RLPF.ar(sig, freq*env1 * [1,1 + Rand(0,0.1),2,1.01]);
	sig = HPF.ar(sig, 100);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = sig * 0.5;
	Out.ar(out, sig);
}).add;

SynthDef(\vache, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, totem=1, spoon;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	totem = totem.fold(0,8)/8;
	//totem.poll;
	freq = freq * [1,1+spoon.range(0.0001,0.001),1];
	sig1 = SinOsc.ar(freq);
	sig2 = LFSaw.ar(freq);
	sig3 = LFPulse.ar(freq);
	sig = SelectX.ar( spoon.range(0,2), [sig1, sig2, sig3]);
	sig = RLPF.ar(sig, spoon.range(1/4,4) * freq, spoon.range(0.3,0.8));

	sig1 = sig1.fold2(spoon.range(1,0.1));
	sig = SelectX.ar( spoon.range(1,0), [sig, sig1]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, (spoon+[0.1,0.7]).fold(-1,1), amp).flop;
	Out.ar(out, sig);
}).add;

SynthDef(\vache2, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, totem=1, spoon;
	var sig;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var mfreq;
	totem = totem.fold(0,8)/8;
	//totem.poll;
	//freq = freq * [1,1+spoon.range(0.0001,0.001),1];
	//freq = freq * [0,5].midiratio;
	mfreq = freq * ( 1 + ( SinOsc.ar(freq * Rand(1,1.1)) * ( spoon+[0,0.3,0.7] ).fold(0.1,2) ));
	sig1 = LFSaw.ar(mfreq);
	sig2 = LFSaw.ar(mfreq * 1/2);
	sig3 = LFPulse.ar(mfreq);
	sig = SelectX.ar( spoon.range(0,2), [sig1, sig2, sig3]);
	//sig = SelectX.ar( ( spoon+[0,1,1.3] ).fold2(0,1), [sig, sig1]);

	sig1 = sig1.fold2(spoon.range(1,0.1));
	sig = SelectX.ar( spoon.range(1,0), [sig, sig1]);
	sig = RLPF.ar(sig, ( spoon.range(1/4,4) * freq ), spoon.range(0.3,0.8));
	sig = HPF.ar(sig, (spoon+0.5).fold(1/4,4) * freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, (spoon+1.7).fold(-1,1), amp).flop;
	Out.ar(out, sig);
}).add;

	~gen_note_pat = { arg str, id=0;

		Plazy({
			var a = str.nextN(10);
			var spoon = Ndef(( \spoon++id ).asSymbol, { SinOsc.kr(1/a[5] * ( (a[0]+1)/5 )) });
			a.debug("In");

			Pfindur(a[5]+1,
				Pbind(
					\instrument, [
						\vache,
						\vache2,
						\blo,
						\raid,
						\raid2,
						\default,
						\raid3,
					].wrapAt(a[0]),
					\legato, a[8]/5 + 0.1,
					\totem, Ptime(),
					\spoon, spoon,
					\adsr, Pseq([
						[
							[ Env.adsr(0.1,0.1,0.8,0.1) ],
							[ Env.adsr(0.2,0.1,0.8,0.1) ],
							[ Env.adsr(0.02,0.1,0.8,0.3) ],
							[ Env.adsr(0.02,0.1,0.6,0.7) ],
						].wrapAt(a[1])
					],inf),
					\root, -4,
					\degree, 
					[
						Pseq(a.keep(2),inf),
						Pseq(a[[1,0,1,2]],inf),
						Pseq(a,inf),
						Pseq(a.mirror,inf),
						Pseq(a.drop(2).keep(4),inf),
						Pseq({a.choose}!(a[6]+1),inf),
					].wrapAt(a[2]),
					\octave, [3,4,5,6].wrapAt(a[3]),
					\isRest, 
					[
						Pseq(a.keep(2).collect({ arg x; x < 4 }),inf),
						Pseq(a.keep(4).collect({ arg x; x > 4 }),inf),
						false,
					].wrapAt(a[9]),
					\dur, [
						Pseq([2**a[7].wrap(0,6)/8, 1/4],inf),
						Pseq([2**a[7].wrap(0,4)/8, 1/4],inf),
						Pseq([2**a[7].wrap(0,4)/8, 1/8],inf),
						Pseq([2**a[7].wrap(0,5)/8],inf),
						//Pseq([2**8.rand/8],inf),
					].wrapAt(a[4]),
					\amp, Pkeyd(\amp, 0.1/4),
				)
			)
		})
	};

	~gen_perc_pat = { arg str, id=0;
		Plazy({

			var a = str.nextN(10);
			Pfindur(a[0]+1,
				Pbind(
					\instrument, \dr_oscsampler,
					\degree, Pseq([0],inf),
					\timeScale, a[0] + ( a[9]/10 ) / 7,
					\levelScale, a[1] + ( a[8]/10 ) / 10,
					\hpfreq, a[2].linexp(0,9,10,17000),
					\ffreq, a[3].linexp(0,9,10,17000),
					\pos, (
						a[4].linlin(0,9,0,1) + a[5].linlin(0,9,0,0.1) +  ( a[6]/(a[7]+1) / 100 )
					).wrap2(0,1),
					//\pos, 0.2,
					\hpmix, a[5].linlin(0,9,0,1),
					\lpmix, a[6].linlin(0,9,0,1),
					\sustain, a[8].linlin(0,9,0.01,0.1) + Pseq([0,0,0,0,0,Pwhite(0,0.1,3)],inf),
					//\legato, a[8].linlin(0,9,0.1,0.5),
					\isRest, 
					[
						Pseq(a.keep(2).collect({ arg x; x < 4 }),inf),
						Pseq(a.keep(4).collect({ arg x; x > 4 }),inf),
						false,
					].wrapAt(a[9]),
					\isRest, Pseq([
						[
							Pser([1,0],16),
							Pser([0,1],16),
							Pser([1,0.51],16),
							Pser([
								1,0,0.5,0, 0,0,0,0
							],16),
							Pser([
								1,0.7,0, 0,0,0,0
							],16),
							Pser([
								1,0,0,0, 0,0,0.4,0
							],16),
							Pser([
								0,0,0,0, 1,0,0,0
							],16),
							Pser([
								0,0,0,0, 1,0,0,0.5
							],16),
						].wrapAt( a[9] )
					],1).coin.not,
					\lag, 
						if(a[3] > 4) {
							0
						} {
							a[4]/20
						}
					,
					\dur, [
						Pseq([2**a[7].wrap(0,6)/8, 1/4],inf),
						Pseq([2**a[7].wrap(0,4)/8, 1/4],inf),
						Pseq([2**a[7].wrap(0,4)/8, 1/8],inf),
						Pseq([2**a[7].wrap(0,5)/8],inf),
						Pseq([2**a[7].wrap(0,5)/4],inf),
						Pseq([1/16, 1/16],inf),
						//Pseq([2**8.rand/8],inf),
					].wrapAt(a[4]),
					\dur, [
						1/4,
						1/8,
						1/16,
					].wrapAt(a[4]),
					\amp, 0.1
				)
			);
		})
	};

	// test
	//~str = Prand([1,2,3,6,5,6,4,2,9],inf).asStream;
	//~genpat.(~str).loop.play;

~fileread_str = { arg filepath;
	Prout({
		var num;
		//~file.readInt8
		//var file;
		if(~file.notNil) { ~file.close };
		~file = File(filepath.standardizePath,"rb");
		inf.do {
			num = ~file.getInt32;
			num.debug("NUM");

			if(num.isNil) {
				nil.yield;
			} {
				(num % 10).postln.yield;
			}
		}
	}).asStream;
};
)

(
~str = ~fileread_str.("/bin/ls");
//~str = Pseq( ~decimals.as(Array).collect(_.asString.asInteger) ).asStream; // pi decimals
Pdef(\soni, Ppar(
	4.collect { arg i;
		Pspawner({ arg sp;
			inf.do { arg x;
				sp.seq(~gen_note_pat.(~str), i);
			}
		})
	} ++
	4.collect { arg i;
		Pspawner({ arg sp;
			inf.do { arg x;
				sp.seq(~gen_perc_pat.(~str), i);
			}
		})
	}
)).play;
)

(
~str = ~fileread_str.("/bin/ls");
Pdef(\soni, 
	Pspawner({ arg sp;
		inf.do { arg x;
			[
				1,1,4,4, 1,1,2,2,
				4,0,2,1, 0,4,4,4,
			].clump(2).do { arg chans;
				2.do {
					chans[0].do { arg i;
						sp.par(~gen_note_pat.(~str), i)
					};
					chans[1].do { arg i;
						sp.par(~gen_perc_pat.(~str), i)
					};
					4.wait;
				}
			};

		}
	})
).play;
)

(
~str = ~fileread_str.("/bin/ls");
Pdef(\soni, 
	Pspawner({ arg sp;
		inf.do { arg x;
			[
				1,1,4,4, 1,1,2,2,
				4,0,2,1, 0,4,4,4,
			].clump(2).do { arg chans;
				2.do {
					chans[0].do { arg i;
						sp.par(~gen_note_pat.(~str), i)
					};
					chans[1].do { arg i;
						sp.par(~gen_perc_pat.(~str), i)
					};
					4.wait;
				}
			};

		}
	})
).play;
)


(
Pdef(\yop, 

	Pseq([
		Pfindur(2, Pbind(\degree, 5)),
		Pfindur(2, Pbind()),
		Pfindur(2, Pbind(\degree, 6)),
		Pfindur(2, Pbind()),
	],inf)
	<>
	Pbind(
		\degree, 0,
		\dur, Pseq([1/2,1/4],inf),
	)

).play;
)
	
(
Pdef(\yop, 

	Ppar(
		4.collect({ arg xx;
			Pbind(
				\degree, xx,
				\isRest, Pfunc({ arg ev; ev[\mutepat][xx] == 0 }),
				\time, Ptime(),
				\bla, Pfunc({ arg ev; ev[\time].debug("TIME") })
			)
			<>
			Pseq([
				Pfindur(2, Pbind(\mutepat, [1,0,0,0])),
				Pfindur(2, Pbind(\mutepat, [1,1,0,0])),
				Pfindur(2, Pbind(\mutepat, [0,0,1,1])),
				Pfindur(2, Pbind(\mutepat, [1,0,1,1])),
			],inf)
			<>
			Pbind(
				\dur, Pseq([1/4],inf),
			)
		})
		
	)

).play;
)

( (0..7)/4 ).asInteger
(
//~str = ~fileread_str.("/home/ggz/Musique/REC00004.WAV");
~str = ~fileread_str.("/initrd.img");
Pdef(\soni, 
	Ppar(
		8.collect({ arg xx;
			var del = 4;
			Pbind(
				\isRest, Pfunc({ arg ev; ev[\mutepat][xx] }),
			)
			<>
			Pseq([
				//Pfindur(del, Pbind(\mutepat, [1,0,0,0, 0,0,0,0])),
				//Pfindur(del, Pbind(\mutepat, [1,0,0,0, 1,0,0,0])),
				//Pfindur(del, Pbind(\mutepat, [1,1,0,0, 1,1,0,0])),
				//Pfindur(del, Pbind(\mutepat, [1,1,1,0, 1,1,1,0])),

				//Pfindur(del, Pbind(\mutepat, [1,1,1,1, 1,1,1,1])),
				//Pfindur(del, Pbind(\mutepat, [0,0,0,0, 1,1,1,1])),
				//Pfindur(del, Pbind(\mutepat, [1,1,0,0, 0,0,1,1])),
				//Pfindur(del, Pbind(\mutepat, [0,0,0,0, 0,0,0,0])),

				Pfindur(del, Pbind(\mutepat, Pfunc({ ~str.nextN(8) < 4 }) )),
			],inf)
			<>
			Pseq([ 
				[
					~gen_perc_pat.(~str, xx),
					~gen_note_pat.(~str, xx),
				].wrapAt(( xx/4 ).asInteger) 
			],inf)
		})
		
	)
).play;
)

(0..5) > 0


(
~str = ~fileread_str.("/initrd.img");
Pdef(\flute, Pbind(
	\instrument, \default,
	\degree, Plazy({ arg ev; 
		var p = [
			(0..7),
			(0..7).reverse,
			0!8,
			4!8,
		].wrapAt(~str.next);

		p = [
			p,
			{
				p.collect({ arg x, i; if(i%2==0) { x-2 } { x } })
			},
			{
				p.collect({ arg x, i; if(i%3==0) { x-2 } { x } })
			},
		].wrapAt(~str.next).value;

		p = [
			p,
			{
				p.collect({ arg x, i; if(i%x==0) { x+2 } { x } })
			},
			{
				p.collect({ arg x, i; if(i%x==0) { x+2 } { x } })
			},
		].wrapAt(~str.next).value;

		p = [
			p,
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x+2 } { x } })
			},
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x-2 } { x } })
			},
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x-1 } { x } })
			},
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x+1 } { x } })
			},
		].wrapAt(~str.next).value;

		p = [
			p,
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x+2 } { x } })
			},
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x-2 } { x } })
			},
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x-1 } { x } })
			},
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x+1 } { x } })
			},
		].wrapAt(~str.next).value;

		p = [
			p,
			{
				p.collect({ arg x, i; if(x%2==0) { x } { \r } })
			},
			{
				p.collect({ arg x, i; if(x%4==0) { x } { \r } })
			},
			{
				p.collect({ arg x, i; if(x%i==0) { x } { \r } })
			},
			{
				p.collect({ arg x, i; if( ~str.next % 2==0) { x } { \r } })
			},
			{
				p.collect({ arg x, i; if(i%2!=0) { x } { \r } })
			},
		].wrapAt(~str.next).value;


		p = [
			p,
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x * [0,2,4] } { x } })
			},
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x * [0,4] } { x } })
			},
			{
				p.collect({ arg x, i; if( ~str.next > 4) { x * [0,2] } { x } })
			},
		].wrapAt(~str.next).value;

		Pseq(p)
	}).loop,
	\dur, 1/8,
	\amp, 0.1
)).play;
);



//////////////////////////////////////////:



(
~mkperc = { arg a;
	Pbind(
		\instrument, \dr_oscsampler,
		\degree, Pseq([0],inf),
		\timeScale, a[0] + ( a[9]/10 ) / 7,
		\levelScale, a[1] + ( a[8]/10 ) / 10,
		\hpfreq, a[2].linexp(0,9,10,17000),
		\ffreq, a[3].linexp(0,9,10,17000),
		\pos, (
			a[4].linlin(0,9,0,1) + a[5].linlin(0,9,0,0.1) +  ( a[6]/(a[7]+1) / 100 )
		).wrap2(0,1),
		//\pos, 0.2,
		\hpmix, a[5].linlin(0,9,0,1),
		\lpmix, a[6].linlin(0,9,0,1),
		\sustain, a[8].linlin(0,9,0.01,0.1) + Pseq([0,0,0,0,0,Pwhite(0,0.1,3)],inf),
		\sustain, a[8].linlin(0,9,0.01,0.1),
		//\legato, a[8].linlin(0,9,0.1,0.5),
		//\isrest, 
		//[
		//	pseq(a.keep(2).collect({ arg x; x < 4 }),inf),
		//	pseq(a.keep(4).collect({ arg x; x > 4 }),inf),
		//	false,
		//].wrapat(a[9]),
		//\lag, 
		//	if(a[3] > 4) {
		//		0
		//	} {
		//		a[4]/20
		//	}
		//,
		//\dur, [
		//	pseq([2**a[7].wrap(0,6)/8, 1/4],inf),
		//	pseq([2**a[7].wrap(0,4)/8, 1/4],inf),
		//	pseq([2**a[7].wrap(0,4)/8, 1/8],inf),
		//	pseq([2**a[7].wrap(0,5)/8],inf),
		//	pseq([2**a[7].wrap(0,5)/4],inf),
		//	pseq([1/16, 1/16],inf),
		//	//pseq([2**8.rand/8],inf),
		//].wrapat(a[4]),
		\amp, 0.1
	)
};

Pdef(\trav, 
	Ppar(
		[
			~mkperc.([5,2,3,4, 5,9,0,7, 1,9]),
			~mkperc.([4,3,4,1, 5,9,0,7, 1,9]),
			~mkperc.([3,1,4,1, 5,9,0,7, 1,9]),
		].collect({ arg x, i;
			Pbind(
				\amp, 2 * Pkey(\amp),
			)
			<>
			[
				Pbind(
					\dur, 1/8,
					\amp, Pkey(\amp) * 2,
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				),
				Pbind(
					\dur, 1/8,
					\amp, Pkey(\amp) * 2,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				),
				Pbind(
					\dur, 1/8,
					\amp, Pkey(\amp) * Pseq([
						1,0.3,0.5,0.3
					],inf).stutter(1),
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
				),

			][i]
			<> x
		
		})

	)
).play;
)


(
	Pdef(\kou, Pspawner({ arg sp;
		inf.do {
			4.do {
				sp.par(
					~mkperc.({ rrand(0,9) }!10)
					<>
					Pbind(
						\dur, 1/8,
						\isRest, Pseq([
							[
								Pser([1,0],16),
								Pser([
									1,0,0.5,0, 0,0,0,0
								],16),
								Pser([
									1,0.7,0, 0,0,0,0
								],16),
								Pser([
									1,0,0,0, 0,0,0.4,0
								],16),
								Pser([
									0,0,0,0, 1,0,0,0
								],16),
							].wrapAt( rrand(0,9) )
						],1).coin.not,
					)
				);
			};
			(1/8 * 16).wait

		}
	})).play
)

(
	Pdef(\kou, Pspawner({ arg sp;
		inf.do {
			4.do {
				sp.par(
					~mkperc.({ rrand(0,9) }!10)
					<>
					Pbind(
						\dur, 1/8,
						\isRest, Pseq([
							[
								Pser([1,0],16),
								Pser([
									1,0,0.5,0, 0,0,0,0
								],16),
								Pser([
									1,0.7,0, 0,0,0,0
								],16),
								Pser([
									1,0,0,0, 0,0,0.4,0
								],16),
								Pser([
									0,0,0,0, 1,0,0,0
								],16),
							].wrapAt( rrand(0,9) )
						],1).coin.not,
					)
				);
			};
			(1/8 * 16).wait

		}
	})).play
)


(
Pdef(\trav, 
	Ppar(
		3.collect({
			~mkperc.({ rrand(0,9) }!10)
		}).collect({ arg x, i;
			Pbind(
				\amp, 2 * Pkey(\amp),
			)
			<>
			[
				Pbind(
					\dur, 1/8,
					\amp, Pkey(\amp) * 2,
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				),
				Pbind(
					\dur, 1/8,
					\amp, Pkey(\amp) * 2,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				),
				Pbind(
					\dur, 1/8,
					\amp, Pkey(\amp) * Pseq([
						1,0.3,0.5,0.3
					],inf).stutter(1),
					\isRest, Pseq([
						1,1,
					],inf).coin.not,
				),

			][i]
			<> x
		
		})

	)
).play;
)

(
Pdef(\trav, 
	Ppar(
		3.collect({
			~mkperc.({ rrand(0,9) }!10)
		}).collect({ arg x, i;
			Pbind(
				\amp, 2 * Pkey(\amp),
			)
			<>
			[
				Pbind(
					\dur, 1/8,
					\amp, Pkey(\amp) * 2,
					\isRest, Pseq([
						1,0,1,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
						1,1,0,0, 0,0,0,0,
						0,0,0,0, 0,0,0,0,
					],inf).coin.not,
				),
				Pbind(
					\dur, 1/8,
					\amp, Pkey(\amp) * 2,
					\isRest, Pseq([
						0,0,0,0, 0,0,0,0,
						1,0,0,0, 0,0,0,0,
					],inf).coin.not,
				),
				Pbind(
					\dur, 1/16,
					\amp, Pkey(\amp) * 1,
					\isRest, Pseq([
						Plazy({ arg ev;
							var tab = 0 ! 16;
							[
								{ rrand(4,7).do { arg x; tab[x] = 1 } },
								{ rrand(4,7).do { arg x; tab[x*2] = 1 } },
								//{ rrand(2,6).do { arg x; tab.wrapPut(x*3, 1) } },
								{ rrand(1,4).do { arg x; tab.wrapPut(x*4, 1) } },
							].choose.value;
							Pseq(tab)
						}),
						Plazy({ arg ev;
							var tab = 0 ! 16;
							[
								{ rrand(4,7).do { arg x; tab[x] = 1 } },
								{ rrand(4,7).do { arg x; tab[x*2] = 1 } },
								{ rrand(2,6).do { arg x; tab.wrapPut(x*3, 1) } },
								{ rrand(1,4).do { arg x; tab.wrapPut(x*4, 1) } },
							].choose.value;
							Pseq(tab)
						}),
					],inf).coin.not,
				),

			][i]
			<> x
		
		})

	)
).play;
)

1

(
~divide = { arg seq, count=2;
	var res;
	var divi = { arg num;
		if(count > 0 and: {0.1.coin}) {
			if(0.2.coin) {
				~divide.([num/3, num/3, num/3], count-1)
			} {
				~divide.([num/2, num/2], count-1)
			}
		} {
			num
		}
	};
	res = seq.collect({ arg num;
		if(0.2.coin) {
			num = Rest(num);
		};
		if(num.isKindOf(Rest)) {
			num
		} {
			divi.(num)
		}
	}).flatten;
	//res.debug("RES");
	res
};
Pdef(\bla, 
	
	Ppar(
		6.collect({ arg i;
			Plazy({

				Pbind(
					\dur, Plazy({
						Pseq(~divide.([1,1,1,1]/2).debug("RES"), rrand(1,8))
					}),
					\amp, 0.1
				)
				<> ~mkperc.({ rrand(0,9) }!10)
			}).loop
		
		})
	)
).play;
);

Pdef(\bla).clear
0.2.coin
