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
	+ (Delay1.ar(Ndef(\pul).ar) * 0.9)
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
Ndef(\pul, { | freq=80, rq=0.001, amp = 0.91 |
	var in = InFeedback.ar(\inbus.kr(BusDef(\fx1, \audio)), 2); 
	//in = Pulse.ar([100,250],0.5,0.1);
	RLPF.ar(
		in,
		freq: freq,
		rq: rq,
		mul: amp
	)
	+ (Delay1.ar(Ndef(\pul).ar) * 0.9)
}).play;
)

Pdef(\test).set(\out, BusDef(\fx1));
(
Pdef(\test, 
	Ppar([
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 0,
			\isRest, Pseq({[
				1,0,1,0, 0,0,0,0,
				1,0,0,1, 0,0,0,0,
				1,0,0,0, 0,0,0,0,
				1,0,0,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 4,
			\isRest, Pseq({[
				0,0,0,0, 1,0,0,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		PatKitDef(\sample1).asPattern(Pbind(
			\kitIndex, 8,
			\isRest, Pseq({[
				1,1,1,1, 1,1,1,1,
				1,0,1,0, 1,0,1,0,
				1,0,0,0, 1,0,0,0,
				0,0,1,0, 0,0,1,0,
			].clump(8).choose}.dup(8).flat,inf).coin.not,
			\sustain, 0.1,
			\dur, 1/8,
			\amp, 0.1,
		)),
		
	])
).play;
)



(
Ndef(\fall, { arg freq=200, pan=0, amp=0.1;
	var sig;
	sig = ( WhiteNoise.ar + 0.8 ) * LFSaw.ar({ exprand(10.0,10000) }!20 * ( 1 + ( SinOsc.ar((1..4).rand(0.0)/18 * XLine.kr(1,121200,80)) * 1/41 * XLine.kr(1,180,60) )));
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * ( 1 + ( SinOsc.ar((1..2).rand(0.0)/18 * XLine.kr(1,121200,60)) * 1/41 * XLine.kr(1,180,60) ))}!4) + sig / 2;
	sig = DelayC.ar(sig, 0.2, {rrand(1/5,1/10000) * XLine.kr(1,1/1000,14)}!4) + sig / 2;
	sig = sig + BPF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = BRF.ar(
		sig, 
		{ ( exprand(100.0,10000) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(20,20000) }!10,
		{ ( rand(0.01,1) * LFNoise1.ar(1/100.0.rand).range(1,2) ).clip(0.01,1) }!10
	);
	sig = LeakDC.ar(sig);
	sig = LPF.ar(sig, 17000 * XLine.kr(1/100,1,4));
	sig = sig * 5 * 3;
	sig = sig.mean;
	sig = sig * amp;
	sig;
}).play;
);
