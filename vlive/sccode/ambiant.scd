(
Ndef(\ambient2, {
	var freqs = Array.series(8, 100, 100);
	var trig = Impulse.kr(1) + Impulse.kr(3/8);
	var blip = SinOsc.ar(Demand.kr(trig, 0, Drand(freqs, inf)), mul: 0.6) * Env.perc(0, 0.4).kr(gate: trig);
	var bass = Pan2.ar(LPF.ar(
		Saw.ar(50 * {LFNoise1.kr(1).bipolar(1/4).midiratio}!8, mul: LFTri.kr(2).range(0.2, 0.5)),
		SinOsc.kr(1/4).range(300, 1000),
	).sum * 0.4, 0);
	var sig = 0;
	freqs.do{ |freq|
		var detune = {LFNoise1.kr(1/4).bipolar(1/2).midiratio}!8;
		var voice = PMOsc.ar(
			freq * detune,
			LFNoise1.kr(1/7).exprange(4, 400),
			LFNoise1.kr(1/9).range(0, 3)
		) * 0.1;
		voice = LPF.ar(voice, LFNoise0.kr(LFNoise0.kr(1/4).range(1, 8)).exprange(300, 9000));
		sig = sig + Pan2.ar(voice.sum, SinOsc.kr(1/3), 0.2);
	};
	sig = sig + bass;
	sig = sig + Pan2.ar(CombL.ar(blip, 1, 1/2, 3), LFNoise1.kr(1));
	sig = XFade2.ar(sig, NHHall.ar(sig));
}).play(fadeTime: 5);
)


(
SynthDef.new(\gauss, {
	arg freq = 500, dev = 0, svfFreq = 1000, decay = 0.1, attack = 0.01, k = 0.4, semRatio = 1;
	var sig, env, sigM, sigS;
	freq = freq.lag2(0.01);
	sig = [GaussTrig.ar(freq, dev), GaussTrig.ar(freq, dev)]*10;
	sigM = (sig[0]+sig[1])/2;
	sigS = (sig[0]-sig[1])/2;
	sig = [(sigM+sigS), (sigM-sigS)];
	sigM = VASEM12.ar(sig, svfFreq*semRatio, 1, 0.5);
	sigS = 100.do {sigS = FOS.ar(sigS, k.neg, 1, k);}; //allpass disperser
	sig = SVF.ar(sig, svfFreq, 0.1);
	env = EnvGen.ar(Env.perc(attack, decay), 1, doneAction: 2);
	sig = sig*env/2;
	sig = LeakDC.ar(sig);
	Out.ar(0, sig);
}).add;
)
x = Synth.new(\gauss, [\freq, 1000, \dev, 0, \svfFreq, 1500])
x = Synth.new(\gauss, [\freq, 1000, \dev, 1, \svfFreq, 1500])

(//function that takes a collection representing a monzo as an argument, and outputs the ratio it encodes
~zo = {
	arg exponentCollection;
	var ratio = 1;
	exponentCollection.do({arg item, i; ratio = ratio * (i.nthPrime).pow(item);});
	ratio;
};
)

//pattern
(
s.latency = 0.5;
~func2 = {
	var seed = #[-1,0,1], i=0, temp, temp2 = List[], out;
	temp = seed;
    loop {
		out = temp[((i/3).floor)%temp.size] + seed[i%seed.size];
		out.yield;
		//("o: " ++ out).postln;
		i = i+1;
		temp2.add(out);
		if((i+1) > (temp.size**2), {temp = temp2});
    }
};

~func3 = {
	var seed = #[1,0,-1, 0], i=0, temp, temp2 = List[], out;
	temp = seed;
    loop {
		out = temp[((i/3).floor)%temp.size] + seed[i%seed.size];
		out.yield;
		//("o: " ++ out).postln;
		i = i+1;
		temp2.add(out);
		if((i+1) > (temp.size**2), {temp = temp2});
    }
};

~mutro = {
	var  i = 0, deltas, randos, out, maxStep;
	deltas = List[0.17, 0.17, 0.17, 0.17]; //starting deltas for each beat
	randos = List[0, 0, 0, 0]; //random values for each beat, first bar plays straight as randos are all 0
	maxStep = deltas[0]/10;
	loop{
		out = ((deltas[i] - randos[(i-1)%(deltas.size)] + randos[i]).abs); //if the first beat is pushed back by 0.2s, the second beat is moved forward 0.2s to keep it in roughly the same position before rando is added
		out.yield;
		i = (i+1)%(deltas.size);
		if(i%(deltas.size) == 0, //adds random value to each term of random array on beat one of each bar after bar 1
			{randos = randos.collect({arg item, i; item+(rrand(-1* maxStep, maxStep))})}
			//{"test".postln}
		);
	};
};

~root = 45*4;
w = Pbind(
	\instrument, \gauss,
	\freq,  (~root*~zo.([Prout(~func2), Prout(~func3)])),
	\svfFreq, 999 + Pgauss(0, 55),
	\dev, Prout(~mutro)/4 + Pgauss(0, 0.05),
	\dur, Prout(~mutro)*2,
	\decay, Prout(~mutro)*2 + Pgauss(0, 0.05),
	\attack, Pgauss(0.01, 0.02).max(0.01),
	\k, Prout(~func2).max(0).min(1),
	\semRatio, (Prout(~func2)/Prout(~func3)).abs
).play;

x = Pbind(
	\instrument, \gauss,
	\freq,  (~root*~zo.([Prout(~func3), Prout(~func2)])),
	\svfFreq, 888 + Pgauss(0, 55),
	\dev, Prout(~mutro)/3 + Pgauss(0, 0.05),
	\dur, 3*Prout(~mutro),
	\decay, 3*Prout(~mutro) + Pgauss(0, 0.05),
	\attack, Pgauss(0.01, 0.02).max(0.01),
	\k, Prout(~func2).max(0).min(1),
	\semRatio, (Prout(~func3)/Prout(~func2)).abs
).play;

y = Pbind(
	\instrument, \gauss,
	\freq,  (~root*~zo.([Prout(~func2), Prout(~func3)])),
	\svfFreq, 777 + Pgauss(0, 55),
	\dev, Prout(~mutro)/2 + Pgauss(0, 0.05),
	\dur, 2*Prout(~mutro),
	\decay, 0.5*Prout(~mutro) + Pgauss(0, 0.05),
	\attack, Pgauss(0.01, 0.02).max(0.01),
	\k, Prout(~func2).max(0).min(1),
	\semRatio, (Prout(~func2)/Prout(~func3)).abs
).play;

z = Pbind(
	\instrument, \gauss,
	\freq,  (~root*(4/3)*~zo.([Prout(~func2), Prout(~func3)])),
	\svfFreq, 555 + Pgauss(0, 55),
	\dev, Prout(~mutro) + Pgauss(0, 0.05),
	\dur, 2*Prout(~mutro),
	\decay, Prout(~mutro) + Pgauss(0, 0.05),
	\attack, Pgauss(0.01, 0.02).max(0.01),
	\k, Prout(~func2).max(0).min(1),
	\semRatio, (Prout(~func3)/Prout(~func2)).abs
).play;

{[GaussTrig.ar(freq: 45, dev: 0.1), GaussTrig.ar(freq: 45, dev: 0.1)]/50}.play;
)

s.scope;
