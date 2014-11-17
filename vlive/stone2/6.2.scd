(
Pdef(~name+++\pre, Pbind(
	\instrument, \bubblebub,
	\sizefactor, 0.1,
	\dur, 1/8,
	//\lag, Pwhite(0.0,1/8),
	\freq,  Pwhite(300.0,410),
	\freq, Pseg(Pseq([50,1000],inf),8,\exp),
	\amp ,  0.1, 
	\decay, 0.18, 
	\doneAction, 2
))
)


// END

SynthDef(\bubbletrigs, {|out=0, probability=0.5|
	var trigs, buf, a;
	// These two lines create a loop of zeroes 
	// with some ones (i.e. triggers) placed at prime-number locations
	a = {0}.dup(200);
	[29, 37, 47, 67, 89, 113, 157, 197].do{|val| a[val] = 1};
	buf = a.as(LocalBuf);
	// playbuf by default will use the server's rate, but we want one item every 15ms
	trigs = PlayBuf.kr(1, buf, 0.015.reciprocal / (s.sampleRate / s.options.blockSize), loop: 1);
	// Randomly discard half of them, to remove too much obvious looping
	trigs = CoinGate.kr(probability, trigs);
	// Let's poll to watch the events appearing
	trigs.poll(trigs);
	Out.kr(out, trigs);
}).store
)
 
// Then we'll play it:
x = Synth(\bubbletrigs); // watch the post window to see the bubble events happening (no sound yet!)
x.free;


 
x = Synth(\bubblebub);
x.set(\t_trig, 1); // run this line multiple times, to get multiple (very similar) bubbles!
x.free;


(
s.bind{	
	// Here we'll create busses to hold the triggers, passing them from synth to synth
	~maintrigbus = Bus.control(s, 1);
	~bubtrigbus = Bus.control(s, 4);
	// Note how we make sure things are running in the desired order, using \addAfter
	~trigs = Synth(\bubbletrigs, [\out: ~maintrigbus]);
	// This reads the main trig and puts each trig on a randomly-chosen bus
	~randomdistrib = {
		var trig, which;
		trig = In.kr(~maintrigbus);
		which = TIRand.kr(0,3, trig);
		// or try the Stepper instead of TIRand for "round-robin" selection:
		// which = Stepper.kr(trig, 0, 0, 3);
		which = which.poll(trig);
		Out.kr(~bubtrigbus.index + which, trig);
	}.play(target: ~trigs, addAction: \addAfter);
 
	s.sync;
 
	~bubs = [2400, 2600, 2500, 2700].collect{|afreq|
		Synth(\bubblebub, [\freq, afreq], target: ~randomdistrib, addAction: \addAfter);
	};
 
	s.sync;
 
	// "map" allows us to push the triggers from the control bus to the "t_trig" inputs:
	~bubs.do{|bub, bubindex| bub.map(\t_trig, ~bubtrigbus.index + bubindex) };
};
)


(
p = Pbind(
	\instrument, \bubblebub,
	// The commented version is a bit like the above timings...
	// \dur, Pseq([29, 37, 47, 67, 89, 113, 157, 197, 200].differentiate * 0.015, inf),
	// ...but happily we have useful random-distrib generators. Ppoisson would be ideal but is misbehaving for me!
	\dur, Pgauss(0.3, 0.2),
	\freq, Pwhite(0.0,1,inf).linexp(0,1, 1000, 3000),
	// doneAction of two allows the synths to free themselves. See  "UGen-doneActions".openHelpFile
	\doneAction, 2
).play
)
p.stop



(
SynthDef(\bubblebub, {	|out=0, t_trig=0, attack=0.01, decay=0.08, pitchcurvelen=0.1, freq=1000, doneAction=0, amp=0.1|
	var pitch, son;
	amp   = amp * EnvGen.ar(Env.perc(attack, decay).delay(0.003), t_trig, doneAction: doneAction);
	pitch = freq * EnvGen.ar(Env.new([0,0,1],[0,1]).exprange(1, 1.718), t_trig, timeScale: pitchcurvelen);
	son = SinOsc.ar(pitch);
	// high-pass to remove any lowpitched artifacts, scale amplitude
	son = HPF.ar(son, 15) * amp * 10;
	son = Pan2.ar(son, \pan.kr(0), amp);
	Out.ar(out, son);
}).add
);

(
p = Pdef(\plop, Pbind(
	\instrument, \bubblebub,
	\sizefactor, 0.1,
	\dur, Pwhite(0.1,0.3),
	\freq,  Pwhite(300.0,600),
	\amp ,  0.1, 
	\decay, 0.18, 
	\doneAction, 2
)).play
)
p.stop



play{Mix({a=LFNoise1.ar(0.2.rand);DelayC.ar(BPF.ar( WhiteNoise.ar(Dust2.ar(a*a*4**2).lag(8e-3)),10e3.rand+300,0.09),1,a*0.5+0.1,45)}!1).dup} 





//spinback
play{a = PMOsc;b= SinOsc;c=RLPF;d=440;a.ar(c.kr(b.kr(20,0,d),b.kr(0.2,0,d)))!2}// #supercollider



{ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14) * 400 + 500, 0.03, 0.003)}!2) + ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20) * 800 + 1000, 0.03, 0.005)}!2) * 4  }.play
