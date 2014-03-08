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
