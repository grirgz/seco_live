
	(
	Pdef(\cri, 
		Ppar(
			5.collect({
				Plazy({
					var x = [
						14.rand,
						14.rand,
						14.rand,
						14.rand,
					];

					Pfindur(8.rand+1,
						Pbind(
							\instrument, [
								\blo,
								\raid,
								\raid2,
								\raid3,
								\default,
							].choose,
							\legato, 1.0.rand + 0.1,
							\adsr, Pseq([
								[
									[ Env.adsr(0.1,0.1,0.8,0.1) ],
									[ Env.adsr(0.2,0.1,0.8,0.1) ],
									[ Env.adsr(0.02,0.1,0.8,0.3) ],
									[ Env.adsr(0.02,0.1,0.6,0.7) ],
								].choose
							],inf),
							\degree, 
							[
								Pseq(x.keep(2),inf),
								Pseq(x[[1,0,1,2]],inf),
								Pseq(x,inf),
								Pseq(x.mirror,inf),
								Pseq({x.choose}!4,inf),
								Pseq({x.choose}!1,inf),
							].choose,
							\octave, [3,4,5,6].choose,
							\dur, [
								Pseq([2**8.rand/8, 1/4],inf),
								//Pseq([2**8.rand/8],inf),
							].choose,
							\amp, 0.1/4
						)
					)
				}).loop
			})
		)

	).play;
	)


(
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

SynthDef(\raid3, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	var xfreq;
	var sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
	var fmfreq;
	//var env1 = EnvGen.kr(Env([1,2,1],[0.01,0.8]), 1);
	fmfreq = SelectX.kr(Rand(0,2), [
		Rand(1,1400.0).cpsmidi.round(1).midicps,
		freq * Rand(1,4),
		Rand(1,500)
	]);
	fmfreq = freq * Rand(1,8)/2;
	xfreq = freq * ( 1 + ( SinOsc.ar(fmfreq) * Rand(0.1,3) ));
	sig = LFSaw.ar(xfreq * [1,1.001, 1 + Rand(0,0.0001)]);
	sig1 = (sig * Rand(1,10)).tanh/2;
	sig = SelectX.ar(Rand(0,1), [sig, sig1]);
	sig = RLPF.ar(sig, freq * Rand(1,5) * [1,1 + Rand(0,0.1),2,1.01]);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp).flop;
	//sig = sig * 0.5;
	Out.ar(out, sig);
}).add;
);

(
	~genpat = { arg a;
		// size: 9

		Plazy({
			var x = a;

			Pfindur(a[5]+1,
				Pbind(
					\instrument, [
						\blo,
						\raid,
						\raid2,
						\default,
						//\raid3,
					].wrapAt(a[0]),
					\legato, a[8]/5 + 0.1,
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
						Pseq(x.keep(2),inf),
						Pseq(x[[1,0,1,2]],inf),
						Pseq(x,inf),
						Pseq(x.mirror,inf),
						Pseq(x.drop(2).keep(4),inf),
						Pseq({x.choose}!(a[6]+1),inf),
					].wrapAt(a[2]),
					\octave, [3,4,5,6].wrapAt(a[3]),
					\dur, [
						Pseq([2**a[7].wrap(0,6)/8, 1/4],inf),
						//Pseq([2**8.rand/8],inf),
					].wrapAt(a[4]),
					\amp, 0.1/4
				)
			)
		})
	};

	~genpat.([1,2,3,4,5,6,4,2,9]).play;
)


2**0.wrap(0,6)/8

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


~str = Pseq(
	~decimals.as(Array).collect(_.asString.asInteger).clump(9)
).asStream;
~pat = Pseq(
	~decimals.as(Array).collect(_.asString.asInteger)
);

Pbind(
	\instrument, \default,
	\midinote, ~pat+60,
	\dur, Pkey(\midinote)-60/9+1/8,
	\amp, 0.1
).play;
Ppar(
	4.collect { arg i;
		Pspawner({ arg sp;
			inf.do { arg x;
				var arr = ~str.next;
				[i,x,arr].debug("ARR");
				sp.seq(~genpat.(arr));
			}
		})
	}
).play;


)

~genpat.([ 4, 6, 0, 9, 5, 5, 0, 5, 8  ]).play
[1,2].mirror



(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200;
	var sig;
	sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.1),gate,doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
);

Pbind(
	\instrument, \default,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
);


////////////////////////////////////////////////////// deuxieme round

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
);

(
	~genpat = { arg str, id=0;

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
					\amp, 0.1/4
				)
			)
		})
	};

	// test
	//~str = Prand([1,2,3,6,5,6,4,2,9],inf).asStream;
	//~genpat.(~str).loop.play;
)

//// GO !
(
~str = Pseq( ~decimals.as(Array).collect(_.asString.asInteger) ).asStream; // pi decimals
//~str = Prand((0..9),inf).asStream; // same with random decimals
Pdef(\soni, Ppar(
	4.collect { arg i;
		Pspawner({ arg sp;
			inf.do { arg x;
				sp.seq(~genpat.(~str), i);
			}
		})
	}
)).play;
)

////////////////////////////////////////////////////////////

/// if you want other decimals, you can compute them with bc, scale is number of decimals (could be long)
(
~get_decimals = { arg count, formula;
	"echo 'scale=%; %' | bc -l".format(count, formula).unixCmdGetStdOut.drop(-1)
		.replace(".","")
		.replace("\n","")
		.replace("\\", ""); 
};
)

// pi
~decimals = ~get_decimals.(2000, "4*a(1)")
// square root of 2, i like it better than pi
~decimals = ~get_decimals.(2000, "sqrt(2)")
// try less random pattern, each fraction has its little song
~decimals = ~get_decimals.(2000, "14/13")
// copy paste to reduce compute time
~decimals.asCompileString;


~decimals = ~get_decimals.(2000, "s(0.5)"); // sin(0.5)

(
~decimals = ~get_decimals.(2000, "1/29"); 
~decimals.asCompileString.debug("playing");
~str = Pseq( ~decimals.as(Array).collect(_.asString.asInteger) ).asStream; // pi decimals
//~str = Prand((0..9),inf).asStream; // same with random decimals
Pdef(\soni, Ppar(
	4.collect { arg i;
		Pspawner({ arg sp;
			inf.do { arg x;
				sp.seq(~genpat.(~str), i);
			}
		})
	}
)).play;
)


(
~decimals = ~get_decimals.(2000, "2/12345"); 
~decimals.asCompileString.debug("playing");
~str = Pseq( ~decimals.as(Array).collect(_.asString.asInteger) ).asStream; // pi decimals
//~str = Prand((0..9),inf).asStream; // same with random decimals
Pdef(\soni,
	Plazy({ arg msp;
		var num = ~str.next;
		Ppar(

			(num+1).collect { arg i;
				Pspawner({ arg sp;
					~str.next.do { arg x;
						sp.seq(~genpat.(~str), i);
					}
				})
			}
		)

	}).loop;
).play;
)
