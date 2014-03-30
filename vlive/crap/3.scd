


// alex mclean's vocable synthesis

// see:
// http://yaxu.org/software/vocable/
// http://yaxu.org/category/vocable/


(
Server.default.waitForBoot({
	q = ();
	q.putnam = ( sA:  // soprano
		[ [800, 1150, 2900, 3900, 4950]
			, [0, -6,  -32, -20, -50]
			, [80, 90,  120, 130, 140] ]
		,sE:
		[ [350, 2000, 2800, 3600, 4950]
			, [0, -20, -15, -40, -56]
			, [60, 100, 120, 150, 200] ]
		,sI:
		[ [270, 2140, 2950, 3900, 4950]
			, [0, -12 , -26 , -26 , -44]
			, [60, 90,  100, 120, 120] ]
		,sO:
		[ [450, 800,  2830, 3800, 4950]
			, [0, -11 , -22 , -22 , -50]
			, [70, 80,  100, 130, 135] ]
		,sU:
		[ [325, 700,  2700, 3800, 4950]
			, [0, -16, -35, -40, -60]
			, [50, 60,  170, 180, 200] ]
		// alto
		, aA:
		[ [800, 1150, 2800, 3500, 4950]
			, [0, -4  , -20, -36 , -60]
			, [80, 90,  120, 130, 140] ]
		,aE:
		[ [400, 1600, 2700, 3300, 4950]
			, [0, -24 , -30, -35, -60]
			, [60, 80,  120, 150, 200] ]
		,aI:
		[ [350, 1700, 2700, 3700, 4950]
			, [0, -20, -30, -36 , -60]
			, [50, 100, 120, 150, 200] ]
		,aO:
		[ [450, 800,  2830, 3500, 4950]
			, [0, -9  , -16 , -28 , -55]
			, [70, 80,  100, 130, 135] ]
		,aU:
		[ [325, 700, 2530, 3500, 4950]
			, [0, -12 , -30, -40, -64]
			, [50, 60,  170, 180, 200] ]
		// counter tenor
		, ctA: [
			[660, 1120, 2750, 3000, 3350]
			, [0, -6  , -23 , -24 , -38]
			, [80, 90,  120, 130, 140] ]
		,ctE: [
			[440, 1800, 2700, 3000, 3300]
			, [0, -14 , -18 , -20, -20]
			, [70, 80,  100, 120, 120] ]
		,ctI: [
			[270, 1850, 2900, 3350, 3590]
			, [0, -24 , -24 , -36 , -36]
			, [40, 90,  100, 120, 120] ]
		,ctO: [
			[430, 820,  2700, 3000, 3300]
			, [0, -10, -26 , -22 , -34]
			, [40, 80,  100, 120, 120] ]
		,ctU: [
			[370, 630,  2750, 3000, 3400]
			, [0, -20, -23 , -30, -34]
			, [40, 60,  100, 120, 120] ]
		// tenor
		,tA:
		[ [650, 1080, 2650, 2900, 3250]
			, [0, -6   , -7  , -8 , -22]
			, [80, 90,  120, 130, 140] ]
		,tE:
		[ [400, 1700, 2600, 3200, 3580]
			, [0, -14 , -12 , -14 , -20]
			, [70, 80,  100, 120, 120] ]
		,tI:
		[ [290, 1870, 2800, 3250, 3540]
			, [0, -15, -18 , -20, -30]
			, [40, 90,  100, 120, 120] ]
		,tO:
		[ [400, 800,  2600, 2800, 3000]
			, [0, -10, -12 , -12 , -26]
			, [40, 80,  100, 120, 120] ]
		,tU:
		[ [350, 600,  2700, 2900, 3300]
			, [0, -20, -17 , -14 , -26]
			, [40, 60,  100, 120, 120] ]
		// bass
		,bA:
		[ [600, 1040, 2250, 2450, 2750]
			, [0, -7   , -9  , -9 , -20]
			, [60, 70,  110, 120, 130] ]
		,bE:
		[ [400, 1620, 2400, 2800, 3100]
			, [0, -12  , -9 , -12 , -18]
			, [40, 80,  100, 120, 120] ]
		,bI:
		[ [250, 1750, 2600, 3050, 3340]
			, [0, -30, -16 , -22 , -28]
			, [60, 90,  100, 120, 120] ]
		,bO: [[400, 750,  2400, 2600, 2900],
			[0, -11 , -21 , -20, -40],
			[40, 80,  100, 120, 120]]
		,bU:
		[ [350, 600,  2400, 2675, 2950]
			, [0, -20, -32 , -28 , -36]
			, [40, 80,  100, 120, 120] ] );



	q.consonants = (b: [ 0.00223, 1.00000],
		c: [ 0.00317, 0.86667],
		d: [ 0.00596, 0.00571],
		f: [ 0.00105, 0.89714],
		g: [ 0.00340, 0.95330],
		h: [ 0.00474, 0.99619],
		j: [ 0.00187, 0.90000],
		k: [ 0.00310, 0.47238],
		l: [ 0.00315, 0.95333],
		m: [ 0.00389, 1.00000],
		n: [ 0.00384, 0.99905],
		p: [ 0.00572, 0.99810],
		q: [ 0.00983, 0.08762],
		r: [ 0.00106, 0.93619],
		s: [ 0.00103, 0.88286],
		t: [ 0.00125, 0.12762],
		v: [ 0.00359, 0.00095],
		w: [ 0.00940, 1.00000],
		x: [ 0.00550, 0.51905],
		y: [ 0.00299, 0.98286],
		z: [ 0.00477, 0.99905] );



	q.playWord = { |dict,voice=0, word="test"|
		{
			q.fd[voice].set(\gain, 1);
			word.toLower.do{
				|letter|
				q.playLetter(voice, letter);
				0.05.wait;
			};
			q.fd[voice].set(\gain, 0);
			q.playLetter(voice, $a);
			//"done".postln;
		}.fork;
	};

	q.playLetter = { |dict,voice,letter|
		if(letter.isVowel,
			{
				q.playVowel(voice, letter.asSymbol) },
			{
				if(letter.isAlpha,
					{
						q.playConsonant(voice, letter.asSymbol, 0.25)
					}, {
						//"non-alphabetic character... ignored".postln;
				});
	}) };

	q.playConsonant = { |dict,voice, letter, lagTime|
		q.fd[voice].set(\lagTime, lagTime,
			\delay, q.consonants[letter][0],
			\blend, q.consonants[letter][1]) };

	q.playVowel = { |dict,voice, letter|
		q.sendVowel(voice, 'a' ++ letter.asString.toUpper.asSymbol);
	};

	q.sendVowel = { |dict,voice, letter|
		letter = letter.asSymbol;
		q.fd[voice].set(
			\ffreqs, q.putnam[letter][0],
			\fgains, q.putnam[letter][1],
			\fbws, q.putnam[letter][2]) };

	q.initVoices = { |dict,numVoices|
		if(q.fd.isArray,	{
			q.fd.do{ |synth| synth.set(\gain, 0); synth.free; }});
		q.fd = 0!numVoices;
		numVoices.do{ |i|
			q.fd[i] = Synth(\ks);
	}};

	SynthDef(\ks, { |out=0,gain=0,delay=1,blend=440,
		ffreqs=#[350, 600,  2400, 2675, 2950],
		fgains=#[0, -20, -32 , -28 , -36],
		fbws=#[40, 80,  100, 120, 120],
		lag = 0.1|
		var laggedDelay = Lag.kr(delay, lag);
		var laggedBlend = Lag.kr(blend, lag);
		var snd0,snd1,snd2,snd3,snd4,snd5,snd6, snd7;
		var wn = WhiteNoise.ar;
		var sin = SinOsc.ar(200, 0);
		snd0 = Decay.ar(Impulse.ar(200, 0), 0.0025) * sin;
		snd1 = LocalIn.ar(1) + (snd0 * gain.lag(0.01));
		snd2 = DelayN.ar(snd1, 0.01, laggedDelay);
		snd3 = Delay1.ar(snd2);
		snd4 = (snd2 + snd3) / 2;
		snd5 = ((wn > blend) * snd4) + ((1 - (wn > blend)) * (snd4 * -1));
		snd6 = Mix(
			Resonz.ar(snd5,
				ffreqs,
				fbws/ffreqs)
			* fgains.dbamp);
		snd7 = snd6 * 1.5;
		LocalOut.ar(snd5 * 0.99);
		Out.ar(out, snd7.dup);
	}).add;

	q.initVoices(3);
})
)

q.playWord(0, "Hello how are you today");

q.playWord(1, "asdf");

q.playWord(1, "hello");

q.playWord(1, "cmo zeoiza mi xe wvizu");

(
Task{
	["hello", "how", "are", "you", "today"].do{
		|word|
		q.playWord(0, word);
		0.5.wait;
	}
}.play
)


(
Pdef(\vocable,
	Pbind(
		\amp, 0,
		\word, Pseq(["soup", "tackle", "qop", "", "hello"],inf),
		\dur, 0.25,
		\voice, Pseq([0],inf),
		\func, Pfunc{|k|
					q.playWord(k.voice,k.word)}))
)

(
Pdef(\vocable,
	Pbind(
		\degree, \rest,
		\word, Pclump(Pwhite(1,2), Pseq(["soup", "tackle", "qop", "asdf", "ho", "hi"],inf)),
		\dur, 0.25,
		\strum, 0.125,
		\func, Pfunc{|k|
			if(k.word.isString,
				{
					q.playWord(0,k.word);
				}, {
					k.word[..(q.fd.size-1)].do{
						|word,i|
						q.playWord(i, word)

				}}
		)}
))
)

Pdef(\vocable).play


Pdef(\vocable).stop


//////////////////////////////////////////////////////////////////

Ndef(\gra, { arg freq=100; SinOsc.ar(freq)!2 }).play
Ndef(\gra).set(\freq, 50)
Ndef(\gra).get(\freq)
Ndef(\gra).nodeMap[\freq]

NodeMap

(

z = { exprand(100.0, 5000.0) } ! 20;

Ndef(\x, {

	var in = Decay.ar(Dust.ar(MouseX.kr(0.0001, 0.1, 1) * z, 10), 0.3) * PinkNoise.ar(0.4 ! (z.size div: 3), 1);

	z = z * LFNoise1.ar(0.2 ! z.size).range(1, 2) * LFNoise0.ar(20 ! z.size).exprange(1, 1.8);

	Splay.ar(ComplexRes.ar(in, z, 10 / z)) * 2

}).play

)





// this started out as a comparison between BPF and ComplexRes





(

z = [253.12, 2881.123, 2883.4, 1002.2, 882.01];

Ndef(\x, {

	var in = Decay.ar(Dust.ar(5, 100), 0.3) * PinkNoise.ar(0.4, 1);

	ComplexRes.ar(in, z, 10 / z).sum

}).play

)





(

z = [253.12, 2881.123, 2883.4, 1002.2, 882.01];

Ndef(\x, {

	var in = Decay.ar(Dust.ar(5, 100), 0.3) * PinkNoise.ar(0.4, 1);

	BPF.ar(in, z, (10 / z) * 2).sum

}).play

)



(

z = [253.12, 2881.123, 2883.4, 1002.2, 882.01];

Ndef(\x, {

	var in = Decay.ar(Dust.ar(5, 100), 0.3) * PinkNoise.ar(0.4, 1);

	z = z * LFNoise0.ar(13).range(1, 2);

	ComplexRes.ar(in, z, 10 / z).sum

}).play

)





(

z = [253.12, 2881.123, 2883.4, 1002.2, 882.01];

Ndef(\x, {

	var in = Decay.ar(Dust.ar(5, 100), 0.3) * PinkNoise.ar(0.4, 1);

	z = z * LFNoise0.ar(13).range(1, 2);

	BPF.ar(in, z, (10 / z) * 2).sum

}).play

)

/* The sounds of Fibonacci
In the Fibonacci-sequence every term is found by adding the two previous terms:

0, 1, 1, 2, 3, 5, 8, 13.....

If you divide the terms of the Fibonacci-sequence by any given number and note the remainder, you will find a repeating sequence called the Pisano Period (Leonardo Pisano was the real name of Fibonacci):

2: 0, 1, 1, 0, 1, 1, 0, 1, 1, 0...
3: 0, 1, 1, 2, 0, 2, 2, 1, 0, 1, 1, 2, 0, 2, 2, 1...

This is great, because you can simply turn a Pisano Period into sound! For the number 2 the period has a length of 3 and using a sampling rate of 44100 this will result in a tone of 14700 Hz, which is within audible range (if you are young enough). The Pisano Period for the number 1000 is roundabout 1500, which will give you a tone of about 30 Hz, well within audible range.

Any term of the Pisano Period for a given number can be found by adding the two previous terms of that Pisano Period, divide it by the given number en note the remainder. That's nice, because you don't have to work with the enormous numbers of the original Fibonacci-sequence.

Any Pisano period will contain 1 or 2 or 4 zeros.

This idea was inspired by this video:
http://www.youtube.com/watch?v=Nu-lW-Ifyec

The Fibonacci-sequence can be found in the Online Encyclopedia of Integer Sequences:
http://oeis.org/A000045

as well as the sequence of lengths of the Pisano Period for different numbers:
http://oeis.org/A001175

 */
 
 s.boot;
 a=Array.new(14700000);//array for storing 1000 sounds each with a duration of 1/3 of a second
 c=Array.newClear(14700) //array for storing 1 sound with a duration of 1/3 of a second
 c.put(0,0);
 c.put(1,1);
 (
 for (2, 1000, {arg j; // voor j=2 t/m 1000, divisors
	for (2, 14699, {arg i; c=c.put(i, (c[i-1]+c[i-2])%j)});
	 c=2*(c+0.5)/j-1; //normalise, this will but the values conveniently between -1 and 1
 	for (0, 14699, {arg i; a=a.add(c[i])});
 	// a.add(c); will not work: a will contain an array in each cell in stead of a number
 	c.put(0,0); //this is necessary after normalising
 	 c.put(1,1);
 });
 ) //this will take a few seconds
 a=a.add(0); //to avoid glitches when switching the sound of. It also prevents nasty effects when playing the sounds repeatedly	
 b=Buffer.loadCollection(s, a);
 x = { PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 0) };
 x.play;
 x.free;
 b.free; 
 a.free;


Pbind(

)


0.coin

(
// This filters a simple sine wave, producing a chaotic result
x = {
var sig, out;
sig = SinOsc.ar(660);
out = Friction.ar(sig, friction: 5.41322e-5, mass: 8.05501);
Pan2.ar(out, 0, 0.1);
}.scope
)

x.free;

(
// Modulate the parameters by moving the mouse. Left speaker is original (modulated) sine wave, right speaker is filtered.
x = {
var sig, out;
sig = SinOsc.ar((LFPulse.kr(0.5) + LFPulse.kr(0.33)).range(220, 660).lag(0.1));
out = Friction.ar(sig, friction: MouseX.kr(0.00001, 0.03, 1), mass: MouseY.kr(0.2, 10, 1));
[sig, out] * 0.1;
}.scope
)

x.free;

(
// Some Ringz oscillators, each with a _separate_ Friction1, then merged to create a "rusty" klank.
// Note the way the effect changes as the sound dies away.
x = {
var imp, klank, rusty;
imp = Impulse.ar(1, 0, 0.1);
klank = Ringz.ar(imp, [800, 1071, 1153, 1723,10000].rand);

rusty = Friction.ar(klank, 
friction: 1.75584e-5, 
mass: 2.69789);

Pan2.ar(rusty.sum)
}.play(s);
)

x.free;

(
// In this one we can play with the DC offset and the spring stiffness
x = {
var sig, out;
sig = SinOsc.ar(330) + MouseX.kr(0.01, 10, 1);

out = Friction.ar(sig, friction: 5.41322e-5, mass: 8.05501, 
spring: MouseY.kr(0,1));
Pan2.ar(out * 0.1);
}.scope
)

x.free;

(
// Similar, but this time as a filter for a control-rate signal. 
// Converts boring sinusoidal freq undulation into something much more interesting...
x = {
var sig, out;
sig = LFPar.kr(33) + MouseX.kr(0.01, 10, 1);

out = Friction.kr(sig, friction: 5.41322e-5, mass: 8.05501, 
spring: MouseY.kr(0,1));
out = SinOsc.ar(out.range(150,500));
Pan2.ar(out * 0.1);
}.scope
)

x.free;

Spec.add(\delayTime, [0, 2]);
Spec.add(\damp, [0, 1]);
Spec.add(\size, [0.5, 3]);
Spec.add(\diff, [0, 1]);
Spec.add(\feedback, [0, 1]);
Spec.add(\modDepth, [0, 50]);
Spec.add(\modFreq, [0, 10]);

Ndef(\reverb, {
	var in = SoundIn.ar([14, 15]);
	Greyhole.ar(in, \delayTime.kr(2), \damp.kr(0), \size.kr(1), \diff.kr(0.707), \feedback.kr(0.9), \modDepth.kr(0.1), \modFreq.kr(0.61))
})


(
s = Server.local.waitForBoot({
	~bus = Bus.audio(s,2);
	SynthDef(\reverb_ef, {
		arg		amp=1, lPos=0, mix=0.085, revTime=1.8, preDel=0.1, in, out;
		var		sig, verbSig, totalSig, outSig;

		//no wacky values please
		mix = mix.clip(0,1);

		sig = In.ar(in, 2);

		//pre-delay
		verbSig = DelayN.ar(sig, preDel, preDel);

		totalSig = 0;
		12.do{
			verbSig = AllpassN.ar(verbSig, 0.06, {Rand(0.001,0.06)}!2, revTime);
			verbSig = LPF.ar(verbSig, 4500);
			totalSig = totalSig + verbSig;
		};

		//dry/wet mix
		totalSig = XFade2.ar(sig, totalSig, mix.linlin(0,1,-1,1));

		outSig = totalSig * amp;
		Out.ar(out, outSig);
	}).add;

	SynthDef(\filtSaw, {
		arg		freq=440, detune=3.0, atk=6, sus=4, rel=6, curve1=1, curve2=(-1),
				minCf=30, maxCf=6000, minRq=0.005, maxRq=0.04,
				minBpfHz=0.02, maxBpfHz=0.25,
				lowShelf=220, rs=0.85, db=6,
				gate=1, amp=1, spread=1.0, out=0;
		var sig, env;
		env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel],[curve1,0,curve2]), gate, levelScale:amp, doneAction:2);
		sig = Saw.ar(
			freq +
			LFNoise1.kr({LFNoise1.kr(0.5).range(0.15,0.4)}!8).range(detune.neg,detune));
		sig = BPF.ar(
			sig,
			LFNoise1.kr({LFNoise1.kr(0.13).exprange(minBpfHz,maxBpfHz)}!8).exprange(minCf, maxCf),
			LFNoise1.kr({LFNoise1.kr(0.08).exprange(0.08,0.35)}!8).range(minRq, maxRq)
		);
		sig = BLowShelf.ar(sig, lowShelf, rs, db);
		sig = SplayAz.ar(4, sig, spread);
		sig = sig * env * 2;
		Out.ar(out, sig);
	}).add;

	~cluster = {
		var trnsp, bund;
		bund = s.makeBundle(false, {});
		trnsp = rrand(-7,7);
		Array.fill(exprand(4,14).round.postln, {[1,2,3,4,6,8,12,16].wchoose([7,6,5,4,3,3,1].normalizeSum)}).do{
			|i|
			var cfLo;
			cfLo = (([23,35,47,50,52,59,61,63,64,76,78].choose) + trnsp).midicps * ((1..8).choose);

				bund = s.makeBundle(false, {
					Synth(
						\filtSaw,
						[
							\freq, i,
							\detune, 0,
							\minBpfHz, 0.01,
							\maxBpfHz,i.expexp(1.0,16.0,0.1,16.0),
							\minRq, 0.003,
							\maxRq, exprand(0.008,0.08),
							\minCf, cfLo,
							\maxCf, cfLo * [1,1.1,1.5].wchoose([0.87,0.1,0.03]),
							\amp, exprand(0.15,0.25),
							\atk, exprand(0.7,8),
							\rel, 5,
							\sus, rrand(6,10.0),
							\spread, exprand(1.5,8.0),
							\out, ~bus,
						],
					)
				},
				bund
			)
		};

		//schedule on an integer time value
		SystemClock.schedAbs(
			(thisThread.seconds+1.0).round(1.0),
			{
				bund = s.makeBundle(nil, {}, bund);
				nil;
			}
		);
	};
});
)

//start clusters
(
t = Task {
	//instantiate reverb synth
	Synth(\reverb_ef, [\in, ~bus, \out, 0]);

	{
		~cluster.value;
		rrand(5.5,12.0).wait;
	}.loop;
}.start;
)

//stop clusters
t.stop;

({var
	  rf = 7
	, rt = Impulse.kr(rf)
	, bs = 8.collect({|i| PulseDivider.kr(rt, 16, i*2)})
	, bt = bs[0] + bs[2] + Dust.kr(SinOsc.kr(0.01, 0, 0.25, 0.25))
	, be = Decay.kr(bt, 0.2)
	, se = Decay.kr(bs[5]+bs[6], 0.01)
	, bass = be*SinOsc.ar(SinOsc.ar([5,6], 0, 20, 
		Demand.kr(bt, 0, Drand((30..48), inf)).midicps
	))
	, snar = se*SinOsc.ar(2000+[0, 5])
	, off = (LPF.kr(BrownNoise.kr([1,1]), 10)**(1/3))>0
	, hat = DelayL.kr(Decay.kr(Mix.new(bs), 0.01), 20, rf.reciprocal*off)*PinkNoise.ar
	, line = Saw.ar(50)*0.1*(LFNoise0.kr(50)>0)*SinOsc.kr(0.1, 0, 0.4, 0.45)
	;
	Out.ar(0, FreeVerb.ar(bass+snar + hat + line, 
		SinOsc.kr(0.01, 0, 0.4, 0.5), 
		0.8, 0.5))
}.play
)


(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8;
	var sig;
	var env;
	//sig = SinOsc.ar(freq);
	//sig = Decay2.ar(sig, 0.1,0.1);
	//sig = Decay2.ar(Dust.ar(100), 0.001, 0.11) * WhiteNoise.ar(1);
	//env = EnvGen.ar(Env.adsr(1.5,0.1,1,0.3),gate,doneAction:0);
	//sig = Decay2.ar(Impulse.ar(100*env+1+LFNoise1.kr(1).range(0,60)), 0.001, 0.11) * WhiteNoise.ar(1);
	sig = WhiteNoise.ar(1);
	sig = BPF.ar(sig, [100,500,200,15000]);
	//sig = Decay2.ar(Impulse.ar([10,1,5,20,31]), 0.001, 0.11) * WhiteNoise.ar(1);
	//sig = Decay2.ar(Impulse.ar([10,1,5,20,31])+Dust.ar(10), 0.001, 0.11) * sig;
	//sig = Decay2.ar(LFTri.ar([10,1,5,20,31])+Dust.ar(10), 0.001, 0.11) * sig;
	//sig = Decay2.ar(LFTri.ar(1), 0.001, 0.11) * sig;
	sig = LFTri.kr([4,1,3].collect{ arg x; LFNoise1.ar(x).range(1,x) }) * sig;
	sig = sig;
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.8),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, freq=200, spread=0.8;
	var sig;
	var sig1;
	var env;
	var mix;
	var trig;
	sig = WhiteNoise.ar(1);
	//sig = BPF.ar(sig, 15000*LFNoise1.kr(40).range(0.4,1.2));
	sig = BPF.ar(sig, 15000*SinOsc.kr([1,2,4,7,9]).range(0.4,1.2));
	sig = LFTri.ar([3,4,5]) * sig;
	//sig = CombL.ar(sig, 0.4,0.004*SinOsc.kr(1).range(0.1,10),0.1) + sig;
	//sig = (sig * 100).tanh(1) * 0.4;
	//sig = Disintegrator.ar(sig, 0.5);
	sig1 = sig;
	trig = Impulse.ar(1100*SinOsc.ar([1,2,5,7,9]).range(0.1,[4,2]));
	sig = Latch.ar(sig, trig);
	mix = LFNoise1.kr(1).range(0.1,0.9);
	mix = SinOsc.kr(2).range(0.1,0.9);
	sig = SelectX.ar(mix, [sig, sig1]);
	//sig = RedDestroyer.ar(sig, 0.4,0.5);
	//sig = RLPF.ar(sig, [500,1000,5000]);
	sig = sig * EnvGen.ar(Env.adsr(0.01,0.1,0.8,0.8),gate,doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	//sig = Pan2.ar(sig, pan, amp);
	Out.ar(out, sig);
}).add;
)

(
Pdef(\plop, Pbind(
	\instrument, \plop,
	\freq, 200,
	\dur, 1,
	\amp, 0.1
)).play;
)



(
Ndef(\plop, {
	var nz = { |...args| LFDNoise3.kr(*args) };
	var sig = Limiter.ar(
		BPF.ar(
			RHPF.ar(
				RLPF.ar(
					WhiteNoise.ar(nz.(1/[9,10],0.25,0.75)),
					nz.(5!2).exprange(100, 7000),
					nz.(1/5!2).range(0.4,1)),
				nz.(5!2).exprange(50,150),
				nz.(1/5!2).range(0.1,1)),
			nz.(5!2).exprange(150,1000),
			nz.(1/5!2).range(0.1,1)));
	//* LFGauss.ar([3,4],0.33) * LFGauss.ar(1/[4,9],0.25);
	//* SinOsc.ar(Lag2UD.kr(Duty.kr(1,0,{Dibrown(300,2400,250)}!2),0.25,0.8));
	//sig = sig * SinOsc.kr([1,2.3,2.314]).clip(0,1).sum;
	//sig = sig * SinOsc.kr([1,2.3,2.314]).clip(0,1).sum;
	sig = sig * LFNoise0.kr([1,8,8.3,16]).range(0,1).inject(1, _*_);
	sig = sig + DelayN.ar(sig, 1, [1,0.5,0.3], [0.12,0.3,0.1]);
	sig = sig.sum;
	sig = Rotate2.ar(sig[0], sig[1], LFSaw.kr(1/5));
	sig;
}).play
)



(

{ var nse, env, kic;
	kic = tanh(Ringz.ar(LPF.ar(Trig.ar(Impulse.ar(1.0),SampleDur.ir),1000),30,0.25,7).sin*2);
	env = Env.perc(0.05, 1, 1, -4);
	nse = BrownNoise.ar(2) + PinkNoise.ar(0.5)  * EnvGen.kr(env,Impulse.kr(1), doneAction: 2);
	nse = Mix.ar(BPF.ar(nse,[100,1200,80,40,20],MouseX.kr(0.0001,1),[1,0.2,1,1,1]));
	nse = LPF.ar(nse + kic, MouseY.kr(100,1000))! 2;
	nse = nse * 0.1;
}.play

)
