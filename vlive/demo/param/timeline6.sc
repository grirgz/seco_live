
// I need a pattern which is
// - parallel
// - recursif
// - generous
// - dropdur
// - Pfindur

// no! parallel and generous is mathematically impossible, they never need to be together

// I need a pattern which is
// - parallel
// - recursif
// - dropdur
// - Pfindur

// then I need a pattern which is
// - generous
// - recursif
// - dropdur
// - Pfindur


// in this file, i am testing the timeline pattern, which handle launching and embeding custom events


(
	"/home/ggz/code/sc/seco/vlive/demo/param/lib/timeline.scd".load

////////////////////////////


	Ndef(\plop, { arg freq=200, pan=0, amp=0.1;
		var sig;
		sig = SinOsc.ar(freq * ( 1 + ( SinOsc.kr(8) * 1 )));
		sig = Pan2.ar(sig, pan, amp);
	});

	Ndef(\plop2, { arg freq=200, pan=0, amp=0.1;
		var sig;
		sig = LFSaw.ar(freq * ( 1 + ( SinOsc.kr(4) * 1 )));
		sig = Pan2.ar(sig, pan, amp);
	});

	SynthDef(\plop, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2, ffreq=4000, rq=0.3;
		var sig, sig1, sig2, sig3;
		sig = LFSaw.ar(freq * [1.01,1,0.99]);
		sig = RLPF.ar(sig, ffreq, rq);
		sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
		sig = Splay.ar(sig, spread, amp, pan);
		Out.ar(out, sig);
	}).add;



	////////////////////////

~pplay = { arg pat;
	var ppat;
	var punchIn = 5.0;
	var punchOut = 16.72;
	ppat = ~timeline_pattern.(pat, punchIn);
	ppat = 
		Pbind(
			\before, Pseq((0..64)),
		)
		<>
		ppat
		<>
		Pbind(
			\after, Pseq((0..64)),
		);
	ppat = ppat.trace;
	// TODO: rewrite Pfindur to cut events in two instead of pruning them
	// 		or maybe fix \player event type to use event cleanup
	ppat = Pfindur(punchOut - punchIn, ppat); 
	ppat.play;
};

// parallel subpattern + ndef + sub-sub pattern
~pplay.(
	Pseq([
		(
			eventType: \pattern,
			dur: 1,
			sustain: 2.5,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22),
					\dur, 1/8,
				)
			),
		),
		(
			eventType: \pattern,
			dur: 1,
			sustain: 4.5,
			pattern: Ref(
				Pseq([
					(
						eventType: \pattern,
						dur: 1,
						sustain: 2.5,
						pattern: Ref(
							Pbind(
								\instrument, \plop,
								\degree, Pseq([1,2,3,4],22),
								\dur, 1/3,
							)
						),
					),
					(
						eventType: \pattern,
						dur: 2,
						sustain: 6,
						pattern: Ref(
							Pbind(
								\instrument, \plop,
								\degree, Pseq([1,2,3,4],22)+10,
								\dur, 1/4,
							)
						),
					),

					
				])
			),
		),
		(
			type: \player,
			receiver: Ref(Ndef(\plop)),
			sustain: 4,
			dur: 1,
		),
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22)+10,
					\dur, 1/8,
				)
			),
		),

		
	])
);

) 

/////////////////////////////////////////////// test scores

(
// parallel subpattern + ndef
~pplay.(
	Pseq([
		(
			eventType: \pattern,
			dur: 1,
			sustain: 2.5,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22),
					\dur, 1/8,
				)
			),
		),
		(
			type: \player,
			receiver: Ref(Ndef(\plop)),
			sustain: 4,
			dur: 1,
		),
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22)+10,
					\dur, 1/8,
				)
			),
		),

		
	])
);
)

(
// parallel subpattern
~pplay.(
	Pseq([
		(
			eventType: \pattern,
			dur: 1,
			sustain: 2.5,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22),
					\dur, 1/8,
				)
			),
		),
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22)+10,
					\dur, 1/8,
				)
			),
		),

		
	])
);

)

(
// simple notes
~pplay.(
	Pbind(
		\degree, Pseq((0..3),2),
		\dur, 1/2,
	);
);
)

(
// subpattern
~pplay.(
	Pseq([
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22),
					\dur, 1/8,
				)
			),
		),
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],22)+10,
					\dur, 1/8,
				)
			),
		),

		
	])
);

)

/////////////////////


(
/// put back values in a stream
~pat = Pseq([1,2,3,4,5]);
~str = ~pat.asStream;
~str2 = Pseq([10,20,~str]).asStream;
~str2.nextN(10);
)

(
/// put back values in a stream
~pat = Pseq([1,2,3,4,5]);
~str = ~pat.asStream;
~str2 = Pseq([10,20,~str]).asStream;
~str2.nextN(10);
)

(

~pat =	Pseq([
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],2),
					\dur, 1/8,
				)
			),
		),
		(
			eventType: \pattern,
			dur: 2,
			sustain: 1,
			pattern: Ref(
				Pbind(
					\degree, Pseq([1,2,3,4],2)+10,
					\dur, 1/8,
				)
			),
		),

		
	]);

	~str = ~pat.asStream;
	~str.nextN(10,());
)


~ev = (dur: 0.125, degree:1)
Pseq([~ev]).asStream.nextN(2,())
Pseq([~ev]).asStream.next(Event.default)

Stream
~ev.play
~ev.use({ arg ev; ev.sustain })
~ev.use({ arg ev; ev[\legato] })

(
~pat = Pbind(
	\instrument, \default,
	\degree, Pseq((0..10)),
	\dur, 1,
	\amp, 0.1
);
~str = ~pat.asStream;
~ev = ~str.next(Event.default);
)

~ev = ();
~ev[\sustain]
().sustain
~ev~ev.sustain
~ev.parent
TempoClock
Event.default.parent
